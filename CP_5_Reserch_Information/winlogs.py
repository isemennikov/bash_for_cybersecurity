#!/usr/bin/env python3
import os
import subprocess
import shutil
import tarfile
import hashlib
from datetime import datetime

def main(log_dir):
    # Создание каталога для файлов EVTX
    log_dir = os.path.join(log_dir, "logs")
    os.makedirs(log_dir, exist_ok=True)

    # Поиск файлов EVTX и обработка их имён
    evtx_files = []
    wevtutil_process = subprocess.Popen(["wevtutil", "el"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    output, _ = wevtutil_process.communicate()
    for line in output.splitlines():
        log_name = line.strip()
        print(log_name + ":")
        safe_name = log_name.replace(" ", "_").replace("/", "-")
        evtx_file = os.path.join(log_dir, f"{os.uname().nodename}_{safe_name}.evtx")
        subprocess.run(["wevtutil", "epl", log_name, evtx_file])
        evtx_files.append(evtx_file)

    # Архивирование файлов EVTX
    archive_name = f"{os.uname().nodename}_logs_evtx_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.tar.gz"
    with tarfile.open(archive_name, "w:gz") as tar:
        for evtx_file in evtx_files:
            tar.add(evtx_file, arcname=os.path.basename(evtx_file))

    # Удаление файлов EVTX
    for evtx_file in evtx_files:
        os.remove(evtx_file)

    # Вывод пути к файлу архива
    archive_path = os.path.join(log_dir, archive_name)
    print(f"Скрипт успешно выполнен. Файл архива: {archive_path}")

    # Вычисление хэша SHA256 и размера архива
    with open(archive_path, "rb") as f:
        hash_sha256 = hashlib.sha256(f.read()).hexdigest()
    size_mb = os.path.getsize(archive_path) / (1024 * 1024)

    # Вывод хэша SHA256 и размера архива
    print(f"SHA256: {hash_sha256}")
    print(f"Размер: {size_mb:.2f} MB")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Скрипт для архивации файлов EVTX в директории и их удаления")
    parser.add_argument("log_dir", type=str, help="Путь к директории для сохранения файлов EVTX")
    args = parser.parse_args()
    main(args.log_dir)
