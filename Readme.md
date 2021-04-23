# Kwickloot

Ein Patch auf Basis von Ninja 2, welcher es in `Gothic 2 die Nacht des Raben` ermöglicht 
mit der rechten Maustaste Gegenstände von Leichen, Bewusstlosen, offenen Truhen und dem Boden 
aufzuheben, ohne dabei eine Animation abzuspielen.

Diebstähle werden mit diesem Patch ebenfalls bemerkt.  
Glaubt nicht ihr könnt einfach in Häuser eindringen und ungestraft alles klauen ;)

## Für Spieler

### Installation

1. Kwickloot.vdf herunterladen:  
https://github.com/Kirides/ninja-quickloot/releases/latest  
_unter `Assets` die `Kwickloot.vdf` anklicken zum herunterladen_
1. Kwickloot.vdf nach `...\Gothic\Data` - verschieben/kopieren
1. Die aktuelle Version von `Ninja` installieren, falls nicht bereits erledigt:  
https://github.com/szapp/Ninja/wiki/Installation-(DE)#wiki-wrapper  
_Dies ist eine Verlinkung auf den offiziellen Wiki Artikel zu der Instatllation von Ninja_

Nach dem ersten Start des Spiels werden in der `Gothic.ini` neue Einträge unter der Sektion `KWICKLOOT` angelegt.  

```ini
[KWICKLOOT]
# Only displayed if UseAnimations is disabled
Prefix=Erhalten:

# virtual X/Y-offset where the text should be displayed
# range is 0-8196
PrintX=150
PrintY=4096

# Enables animations
UseAnimations=1

# Speed of the X/Y movement in milliseconds
AnimSpeed=700

# Patch defaults to FONT_OLD_10_WHITE.TGA
# if that font does not look good for you,
# try one of the internal fonts (currently just DE)
UsePatchFont=0
Font=Kwickloot_Font_DE.tga

# Item instance name which is the currency
szItemMoney=ITMI_GOLD

# enable colors
UseColors=1

[KWICKLOOT_COLORS]
# Everything else
ItemOther=#FFFFFF
# Item value >= 250
ItemRare=#FFA500
# Currency
ItemGold=#FFFF00
# Item value <= 10
ItemCommon=#C0C0C0
ItemWeapon=#E3A5AA
ItemQuest=#009AFF
ItemFood=#04F804
```

Über das Spiel Menü im Bereich Steuerung kann für "(Patch) Kwickloot" entsprechend die Taste(n) belegt werden.  
Die Standards für G1/G2 sind:
- G2: `MAUS RECHTS`
- G1: `V`

----

## Für Entwickler

### Verwendete Bibliotheken

- Ikarus (Ninja-Intern)
- LeGo (Ninja-Intern)

### Build Anleitung

1. Kwickloot.vm auf GothicVDFS.exe ziehen.
1. Erstellen.
