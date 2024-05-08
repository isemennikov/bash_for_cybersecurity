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
tar -czf "logs_evtx.tar.gz" *.evtx
ARCHIVE_PATH="${LOGDIR}/logs_evtx.tar.gz"

# Выводим сообщение о успешном завершении скрипта и пути к файлу архива
echo "Скрипт успешно выполнен. Файл архива: ${ARCHIVE_PATH}"
