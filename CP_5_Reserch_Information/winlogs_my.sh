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
if tar -czf "logs_evtx.tar.gz" *.evtx; then
    ARCHIVE_PATH="${LOGDIR}/$(hostname)_logs_evtx_$(date +"%Y-%m-%d_%H-%M-%S").tar.gz"
    # Удаление файлов EVTX после успешного архивирования
    find $LOGDIR -type f -name "*.evtx" -print0 | xargs -0 rm --
    # Выводим сообщение о успешном завершении скрипта и пути к файлу архива
    echo "Скрипт успешно выполнен. Файл архива: ${ARCHIVE_PATH}"
else
    echo "Ошибка при создании архива. Скрипт завершился с ошибкой."
fi



# Формирование имени архива с использованием имени хоста и текущей даты и времени
ARCHIVE_NAME="$(hostname)_logs_evtx_$(date +"%Y-%m-%d_%H-%M-%S").tar.gz"

# Архивирование файлов EVTX с использованием сформированного имени архива
#tar -czf "$ARCHIVE_NAME" *.evtx
#ARCHIVE_PATH="$LOGDIR/$ARCHIVE_NAME"

## Проверка успешности создания архива
#if [ -f "$ARCHIVE_PATH" ]; then
#    # Вычисление хэша SHA256
#    HASH=$(sha256sum "$ARCHIVE_PATH" | awk '{print $1}')
#    # Вычисление размера архива в мегабайтах
#    SIZE=$(du -m "$ARCHIVE_PATH" | awk '{print $1}')
#    # Вывод пути к файлу архива, его SHA256-хэша и размера в мегабайтах
#    echo "Скрипт успешно выполнен. Файл архива: $ARCHIVE_PATH"
#    echo "SHA256: $HASH"
#    echo "Размер: ${SIZE}MB"
#else
#    echo "Ошибка: архив не создан."
#fi