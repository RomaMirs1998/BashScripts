#!/bin/bash

#Überprüfung der Argumente
if [ "$#" -ne 2 ]; then
        echo "Bash Skript wurde falsch verwendet!"
        echo "./imagedownloader.sh <Wikimedia_Link> <Zielordner>"
        exit 1
fi

LINK="$1"
ZIELORDNER="$2"

# Zielordner erstellen, falls nicht vorhanden
mkdir -p  "$ZIELORDNER"

# HTML-Inhalt des Links herunterladen
wget --timeout=10  --user-agent="Mozilla/5.0" -O - "$LINK" > temp.html
HTML_INHALT=$(cat temp.html)
rm temp.html

IMG_URLS=$(echo "$HTML_INHALT" | grep -Eo 'https://upload\.wikimedia\.org/wikipedia/commons/[^" ]+\.jpg')

download_image() {
    img_url="$1"
    DATEINAME=$(basename "$img_url")
    if [[ ! -f "${ZIELORDNER}/${DATEINAME}" ]]; then
        STATUS=$(wget --timeout=10 --user-agent="Mozilla/5.0" --spider -S "$img_url" 2>&1 | grep 'HTTP/' | awk '{print $2}')
        if [[ "$STATUS" == "200" ]]; then
            wget --timeout=10 --user-agent="Mozilla/5.0" -O "${ZIELORDNER}/${DATEINAME}" "$img_url"
        fi
    fi
}

export -f download_image
export ZIELORDNER

echo "$IMG_URLS" | xargs -I {} -P 10 bash -c 'download_image "$@"' _ {}

echo "DOWNLOAD WAR ERFOLGREICH!"
