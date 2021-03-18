# Quickloot

Ein Patch auf Basis von Ninja 2, welcher es in `Gothic 2 die Nacht des Raben` ermöglicht 
mit der rechten Maustaste Gegenstände von Leichen, Bewusstlosen, offenen Truhen und dem Boden 
aufzuheben, ohne dabei eine Animation abzuspielen.

Diebstähle werden mit diesem Patch ebenfalls bemerkt.  
Glaubt nicht ihr könnt einfach in Häuser eindringen und ungestraft alles klauen ;)

## Für Spieler

### Installation

1. Quickloot.vdf herunterladen:  
https://github.com/Kirides/ninja-quickloot/releases/latest  
_unter `Assets` die `Quickloot.vdf` anklicken zum herunterladen_
1. Quickloot.vdf nach `...\Gothic\Data` - verschieben/kopieren
1. Die aktuelle Version von `Ninja` installieren, falls nicht bereits erledigt:  
https://github.com/szapp/Ninja/wiki/Installation-(DE)#wiki-wrapper  
_Dies ist eine Verlinkung auf den offiziellen Wiki Artikel zu der Instatllation von Ninja_

Nach dem ersten Start des Spiels werden in der `Gothic.ini` neue Einträge unter der Sektion `NINJA_QUICKLOOT` angelegt.  

```ini
[NINJA_QUICKLOOT]
Key=RMB
Prefix=Erhalten:
UseAnimations=1
AnimSpeed=700

# try using FONT_OLD_10_WHITE.TGA if you need russian/polish etc. texts
UsePatchFont=0
Font=Ninja_QuickLoot_Font_DE.tga
```

Über das Spiel Menü im Bereich Steuerung kann für "Quickloot (Patch)" entsprechend die Taste(n) belegt werden.  
Stanadard:
- G2: `MAUS RECHTS`
- G1: `V`

----

## Für Entwickler

### Verwendete Bibliotheken

- Ikarus (Ninja-Intern)
- LeGo (Ninja-Intern)

### Build Anleitung

1. Quickloot.vm auf GothicVDFS.exe ziehen.
1. Erstellen.
