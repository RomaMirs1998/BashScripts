#!/bin/bash

# Hilfsfunktion zur Anzeige der Benutzung des Skripts.
zeige_anleitung() {
    echo "Verwendung: ./thumbs.sh (-e|-p|-s) [-d] Dimension Bild [...]"
    echo "Optionen:"
    echo "  -e: Erstellt exakte Thumbnails (streckt das Bild auf Dimension x Dimension)"
    echo "  -p: Erstellt proportionale Thumbnails (skaliert das Bild proportional)"
    echo "  -s: Erstellt quadratische Thumbnails ohne Streckung"
    echo "  -d: Entfernt EXIF-Metadaten aus Thumbnails"
    exit 1
}

# Überprüfen Sie die minimale Anzahl der Argumente.
if [[ $# -lt 3 ]]; then
    zeige_anleitung
fi

# Optionen abrufen
EXIF_LOESCHEN=0
MODUS=""
while getopts "epsd" opt; do
    case $opt in
        e) MODUS="exakt";;
        p) MODUS="proportional";;
        s) MODUS="quadrat";;
        d) EXIF_LOESCHEN=1;;
        *) zeige_anleitung;;
    esac
done
shift $((OPTIND-1))

GROESSE="$1"
shift

# Jedes Bild verarbeiten
for BILD in "$@"; do
    # Dateinamen ohne Erweiterung für das Thumbnail extrahieren
    DATEINAME=$(basename "$BILD" | cut -f 1 -d '.')

    # Aktion basierend auf dem Modus bestimmen
    case $MODUS in
        "exakt")
            # Bild auf genaue Dimensionen strecken
            convert "$BILD" -resize "${GROESSE}x${GROESSE}!" "${DATEINAME}_thumb.jpg"
            ;;
        "proportional")
            # Bild proportional skalieren
            convert "$BILD" -resize "${GROESSE}x${GROESSE}" "${DATEINAME}_thumb.jpg"
            ;;
        "quadrat")
            # Ohne Streckung auf Quadrat skalieren
            convert "$BILD" -resize "${GROESSE}x${GROESSE}^" -gravity center -crop "${GROESSE}x${GROESSE}+0+0" "${DATEINAME}_thumb.jpg"
            ;;
        *)
            echo "Ungültiger Modus."
            exit 1
            ;;
    esac

    # Wenn die Option EXIF_LOESCHEN gesetzt ist, entfernen Sie die Metadaten.
    if [[ $EXIF_LOESCHEN -eq 1 ]]; then
        convert "${DATEINAME}_thumb.jpg" -strip "${DATEINAME}_thumb.jpg"
    fi

    echo "Thumbnail erstellt für $BILD -> ${DATEINAME}_thumb.jpg"
done

