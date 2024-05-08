#!/bin/bash

# Проверяем наличие аргумента - директории для сохранения файлов EVTX
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Путь к каталогу, где будут находиться файлы EVTX
LOGDIR="$1/logs"

# Проверяем существование каталога LOGDIR, и если его нет, создаем
mkdir -p "$LOGDIR"

# Переходим в каталог с файлами EVTX или выходим с ошибкой
cd "$LOGDIR" || exit -2

# Поиск файлов EVTX и обработка их имён
wevtutil el | while read ALOG; do
    ALOG="${ALOG%$'\r'}"
    echo "${ALOG}:"
    SAFNAM="${ALOG// /_}"
    SAFNAM="${SAFNAM//\//-}"
    wevtutil epl "$ALOG" "$(hostname)_${SAFNAM}.evtx"
done

# Архивирование файлов EVTX
ARCHIVE_NAME="$(hostname)_logs_evtx_$(date +"%Y-%m-%d_%H-%M-%S").tar.gz"
tar -czf "$ARCHIVE_NAME" *.evtx

# Удаление файлов EVTX после успешного архивирования
find . -type f -name "*.evtx" -delete

# Формирование пути к файлу архива
ARCHIVE_PATH="$LOGDIR/$ARCHIVE_NAME"

# Вывод пути к файлу архива
echo "Скрипт успешно выполнен. Файл архива: ${ARCHIVE_PATH}"

# Вычисление хэша SHA256 и размера архива
HASH=$(sha256sum "$ARCHIVE_PATH" | awk '{print $1}')
SIZE=$(du -h "$ARCHIVE_PATH" | cut -f1)

# Вывод хэша SHA256 и размера архива
echo "SHA256: $HASH"
echo "Размер: $SIZE"
