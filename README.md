# ✈️ Flight Progress

GPS-basierter Flug-Fortschrittstracker für Android. Zeigt in Echtzeit den Fortschritt zum Ziel als Prozent an - funktioniert auch im Flugmodus (GPS ist passiv).

## Features

- 📍 GPS-basierte Positionsbestimmung
- 📊 Echtzeit-Fortschrittsanzeige in Prozent
- 🌍 45+ Hauptstädte weltweit vorinstalliert
- ✈️ Funktioniert im Flugmodus
- 🎨 Modernes Dark-Theme Design

## Städte

Europa: Berlin, London, Paris, Madrid, Rom, Wien, Amsterdam, Warschau, Moskau, Stockholm, Oslo, Kopenhagen, Helsinki, Lissabon, Athen, Prag, Budapest, Zürich

Amerika: New York, Washington D.C., Los Angeles, Miami, Toronto, Mexico City, São Paulo, Buenos Aires

Asien: Tokyo, Beijing, Shanghai, Hong Kong, Singapore, Bangkok, Seoul, Delhi, Mumbai, Dubai, Tel Aviv, Istanbul

Afrika & Ozeanien: Cairo, Cape Town, Sydney, Melbourne, Auckland

## Installation

```bash
cd openclaw_test
flutter pub get
```

## Starten

```bash
# Android Emulator/Device
flutter run

# Alle Geräte anzeigen
flutter devices
```

## Build APK

```bash
flutter build apk
```

Die APK findest du dann in `build/app/outputs/flutter-apk/app-release.apk`

## Verwendung

1. **Ziel wählen** - Wähle deine Zielstadt aus der Dropdown-Liste
2. **Position setzen** - Tippe "Aktuelle Position als Start" (GPS muss aktiv sein)
3. **Tracking starten** - Tippe "Tracking starten"
4. **Flugmodus** - Aktiviere den Flugmodus, GPS funktioniert weiterhin passiv
5. **Beobachten** - Der Fortschritt wird automatisch aktualisiert

## Hinweise

- GPS funktioniert im Flugmodus, da es nur Signale empfängt (kein Senden)
- Bei manchen Flugzeugen kann das GPS-Signal eingeschränkt sein (Fensterplatz hilft)
- Die App benötigt Standortberechtigung
