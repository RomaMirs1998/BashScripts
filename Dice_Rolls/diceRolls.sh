#!/bin/bash

# Gesamtsumme für alle Würfelwürfe initialisieren.
gesamtSumme=0

# Diese Funktion simuliert das Werfen eines Würfels.
# Sie nimmt zwei Argumente:
#   1. Die Anzahl der Würfe.
#   2. Die Anzahl der Seiten des Würfels.
wuerfelWerfen() {
    # Anzahl der Würfe und Seiten des Würfels aus den übergebenen Argumenten holen.
    anzahlWuerfe=$1
    seitenZahl=$2

    # Ausgabe, welcher Würfel wie oft geworfen wird.
    echo "Würfle einen ${seitenZahl}-seitigen Würfel ${anzahlWuerfe}-mal:"

    # Teilsumme für diesen speziellen Würfeltyp initialisieren.
    teilSumme=0
    # Für jede Anzahl von Würfen...
    for i in $(seq 1 $anzahlWuerfe); do
        # Zufällige Zahl zwischen 1 und seitenZahl generieren.
        wurfErgebnis=$(( RANDOM % seitenZahl + 1 ))
        # Ergebnis zur Teilsumme hinzufügen.
        teilSumme=$(($teilSumme + $wurfErgebnis))
        # Ergebnis dieses speziellen Wurfs ausgeben.
        echo "  Wurf #${i} = ${wurfErgebnis}"
    done

    # Teilsumme zur Gesamtsumme hinzufügen.
    gesamtSumme=$(($gesamtSumme + $teilSumme))

    # Gesamtergebnis für diesen Würfeltyp ausgeben.
    echo -e "Wurf mit ${seitenZahl}-seitigem Würfel ${anzahlWuerfe}-mal ergibt: ${teilSumme}\n"
}

# Diese Funktion zeigt eine Hilfemeldung an, wie das Skript verwendet wird.
zeigeHilfe() {
    echo "Verwendung: roll.sh [anzahlWuerfe]-[seitenZahl] ..."
    echo "z.B. roll.sh 1-6 würfelt einen 6-seitigen Würfel einmal"
    echo "z.B. roll.sh 6 3-8 2-20 würfelt einen 6-seitigen Würfel einmal, einen 8-seitigen Würfel dreimal und einen 20-seitigen Würfel zweimal"
}

# Überprüfung, ob Argumente bereitgestellt wurden.
# Wenn nicht, wird die Hilfemeldung angezeigt.
if [ "$#" -eq 0 ]; then
    zeigeHilfe
    exit 1
fi

# Anzahl der übergebenen Argumente initialisieren.
argumentAnzahl=0
# Für jedes übergebene Argument...
for arg in "$@"; do
    argumentAnzahl=$(($argumentAnzahl + 1))
    
    # Überprüfen, ob das Argument dem erwarteten Format entspricht.
    # Wenn nicht, wird eine Fehlermeldung und die Hilfemeldung angezeigt.
    if ! [[ $arg =~ ^[0-9]*-[0-9]+$ || $arg =~ ^[0-9]+$ ]]; then
        echo "Ungültiges Argument: $arg"
        zeigeHilfe
        exit 1
    fi

    # Anzahl der Seiten des Würfels aus dem Argument extrahieren.
    seitenZahl="${arg##*-}"
    # Wenn nur eine Zahl übergeben wurde, wird angenommen, dass der Würfel einmal geworfen wird.
    if [[ ${#arg} -eq 1 ]]; then
        anzahlWuerfe=1
    else
        # Ansonsten wird die Anzahl der Würfe aus dem Argument extrahiert.
        anzahlWuerfe="${arg%-*}"
    fi
    # Die Funktion zum Würfeln wird mit der Anzahl der Würfe und der Anzahl der Seiten aufgerufen.
    wuerfelWerfen $anzahlWuerfe $seitenZahl
done

# Wenn mehr als ein Argument übergeben wurde, wird die Gesamtsumme aller Würfe angezeigt.
if [[ $argumentAnzahl -gt 1 ]]; then
    echo "Insgesamt ergibt das Würfeln ${gesamtSumme}."
fi

