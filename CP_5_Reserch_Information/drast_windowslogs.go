package main

import (
	"archive/tar"
	"compress/gzip"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"
)

func main() {
	// Получаем путь к директории для сохранения файлов EVTX из аргумента командной строки
	if len(os.Args) != 2 {
		fmt.Println("Usage: go run script.go <log_directory>")
		os.Exit(1)
	}
	logDir := os.Args[1]

	// Создаем директорию для файлов EVTX, если она не существует
	evtxDir := filepath.Join(logDir, "logs")
	err := os.MkdirAll(evtxDir, os.ModePerm)
	if err != nil {
		log.Fatal(err)
	}

	// Поиск файлов EVTX и их обработка
	evtxFiles := []string{}
	output, err := exec.Command("wevtutil", "el").Output()
	if err != nil {
		log.Fatal(err)
	}
	for _, line := range strings.Split(string(output), "\n") {
		logName := strings.TrimSpace(line)
		fmt.Printf("%s:\n", logName)
		safeName := strings.ReplaceAll(strings.ReplaceAll(logName, " ", "_"), "/", "-")
		evtxFile := filepath.Join(evtxDir, fmt.Sprintf("%s_%s.evtx", os.Getenv("COMPUTERNAME"), safeName))
		cmd := exec.Command("wevtutil", "epl", logName, evtxFile)
		if err := cmd.Run(); err != nil {
			log.Printf("Error exporting log %s: %v\n", logName, err)
			continue
		}
		evtxFiles = append(evtxFiles, evtxFile)
	}

	// Архивирование файлов EVTX
	archiveName := fmt.Sprintf("%s_logs_evtx_%s.tar.gz", os.Getenv("COMPUTERNAME"), time.Now().Format("2006-01-02_15-04-05"))
	archivePath := filepath.Join(logDir, archiveName)
	archiveFile, err := os.Create(archivePath)
	if err != nil {
		log.Fatal(err)
	}
	defer archiveFile.Close()
	gzipWriter := gzip.NewWriter(archiveFile)
	defer gzipWriter.Close()
	tarWriter := tar.NewWriter(gzipWriter)
	defer tarWriter.Close()
	for _, evtxFile := range evtxFiles {
		file, err := os.Open(evtxFile)
		if err != nil {
			log.Printf("Error opening file %s: %v\n", evtxFile, err)
			continue
		}
		defer file.Close()
		stat, err := file.Stat()
		if err != nil {
			log.Printf("Error getting file info for %s: %v\n", evtxFile, err)
			continue
		}
		header := &tar.Header{
			Name:    filepath.Base(evtxFile),
			Size:    stat.Size(),
			Mode:    int64(stat.Mode()),
			ModTime: stat.ModTime(),
		}
		if err := tarWriter.WriteHeader(header); err != nil {
			log.Printf("Error writing header for file %s: %v\n", evtxFile, err)
			continue
		}
		if _, err := io.Copy(tarWriter, file); err != nil {
			log.Printf("Error writing file %s to archive: %v\n", evtxFile, err)
		}
	}

	// Удаление файлов EVTX после архивации
	for _, evtxFile := range evtxFiles {
		if err := os.Remove(evtxFile); err != nil {
			log.Printf("Error removing file %s: %v\n", evtxFile, err)
		}
	}

	// Вывод пути к файлу архива
	fmt.Printf("Скрипт успешно выполнен. Файл архива: %s\n", archivePath)
}
