#!/bin/bash

# Diese Funktion berechnet den SHA-512-Hash für den Inhalt einer Datei.
# Sie gibt den berechneten Hash zurück.
function calculate_sha512() {
    # Der Befehl 'sha512sum' berechnet den SHA-512-Hash einer Datei.
    # Der Befehl 'cut' wird verwendet, um nur den Hashwert aus der Ausgabe zu extrahieren.
    sha512sum "${1}" | cut -d " " -f 1
}

# Diese Funktion überprüft, ob eine Datei an einem gegebenen Pfad existiert.
# Wenn die Datei nicht existiert, wird das Skript mit einer Fehlermeldung beendet.
function ensure_file_exists() {
    if [[ ! -f "${1}" ]]; then
        echo "$1 existiert nicht." >&2
        exit 1
    fi
}

# Diese Funktion überprüft, ob eine Datei an einem gegebenen Pfad NICHT existiert.
# Wenn die Datei existiert, wird das Skript mit einer Fehlermeldung beendet.
function ensure_file_does_not_exist() {
    if [[ -f "${1}" ]]; then
        echo "$1 existiert bereits." >&2
        exit 2
    fi
}

# Diese Funktion durchsucht ein angegebenes Verzeichnis nach Dateien und erstellt für jede Datei einen SHA-512-Hash.
# Diese Hashes werden dann in einer "Integritätskarte" gespeichert, die später verwendet werden kann, 
# um die Integrität der Dateien zu überprüfen.
function create_integrity_map() {
    local target_directory=$1  # Das Verzeichnis, das gescannt werden soll.
    local output_map_file=$2   # Die Datei, in der die Integritätskarte gespeichert wird.

    # Überprüfung, ob die Ausgabedatei bereits existiert.
    ensure_file_does_not_exist $output_map_file

    # Der Befehl 'find' wird verwendet, um alle Dateien im angegebenen Verzeichnis zu finden.
    # Für jede gefundene Datei wird der SHA-512-Hash berechnet und in der Integritätskarte gespeichert.
    find "${target_directory}" -type f -print0 | while IFS= read -r -d $'\0' file; do
        echo -ne "Verarbeite ${file}...\r"
        hash_value=$(calculate_sha512 "${file}")
        echo "${file},${hash_value}" >> "${output_map_file}"
    done

    echo "Integritätskarte erfolgreich erstellt!"
}

# Diese Funktion überprüft die Dateien in einem Verzeichnis anhand einer vorhandenen Integritätskarte.
# Sie identifiziert Dateien, die geändert wurden oder fehlen.
function verify_integrity() {
    local input_map_file=$1  # Die Integritätskarte, die zur Überprüfung verwendet wird.

    # Überprüfung, ob die Integritätskarte existiert.
    ensure_file_exists $input_map_file

    # Jede Zeile der Integritätskarte wird gelesen, und es wird überprüft, ob der aktuelle Hash der Datei 
    # mit dem in der Karte gespeicherten Hash übereinstimmt.
    while IFS=',' read -r file_path expected_hash; do
        if [[ ! -f "${file_path}" ]]; then
            echo -e "\033[33mWarnung:\033[0m ${file_path} fehlt."
            continue
        fi

        current_hash=$(calculate_sha512 "${file_path}")
        if [[ "${expected_hash}" != "${current_hash}" ]]; then
            echo -e "\033[33mWarnung:\033[0m ${file_path} wurde geändert."
        fi
    done < "${input_map_file}"

    echo "Überprüfung abgeschlossen!"
}

# Diese Funktion aktualisiert eine vorhandene Integritätskarte.
# Das bedeutet, dass für jede in der Karte aufgeführte Datei der Hash erneut berechnet wird.
function update_integrity_map() {
    local input_map_file=$1  # Die zu aktualisierende Integritätskarte.

    # Überprüfung, ob die Integritätskarte existiert.
    ensure_file_exists $input_map_file

    # Eine temporäre Datei wird erstellt, um die aktualisierten Hashes zu speichern.
    temp_map=$(mktemp)
    while IFS=',' read -r file_path _; do
        if [[ ! -f "${file_path}" ]]; then
            echo -e "\033[33mWarnung:\033[0m ${file_path} fehlt. Überspringen..."
            continue
        fi

        echo -ne "Aktualisiere ${file_path}...\r"
        hash_value=$(calculate_sha512 "${file_path}")
        echo "${file_path},${hash_value}" >> "${temp_map}"
    done < "${input_map_file}"

    # Die alte Karte wird durch die aktualisierte Karte ersetzt.
    mv "${temp_map}" "${input_map_file}"

    echo "Integritätskarte erfolgreich aktualisiert!"
}

# Die Hauptlogik des Skripts startet hier.
# Abhängig von den Befehlszeilenoptionen wird entweder eine Integritätskarte erstellt, 
# die Integrität von Dateien überprüft oder eine vorhandene Karte aktualisiert.
if [[ $# -lt 2 ]]; then
    echo "Verwendung: $0 -b <Verzeichnis> <Karte_Datei>     Integritätskarte erstellen"
    echo "           $0 -c <Karte_Datei>                    Überprüfen mit bestehender Karte"
    echo "           $0 -r <Karte_Datei>                    Bestehende Karte aktualisieren"
    exit 1
fi

# Verarbeiten der Befehlszeilenoptionen und Aufrufen der entsprechenden Funktion.
while getopts "bcr" opt; do
    case $opt in
    b)
        shift $((OPTIND-1))
        create_integrity_map "$1" "$2"
        ;;
    c)
        shift $((OPTIND-1))
        verify_integrity "$1"
        ;;
    r)
        shift $((OPTIND-1))
        update_integrity_map "$1"
        ;;
    *)
        echo "Ungültige Option."
        exit 1
        ;;
    esac
done

