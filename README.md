# San Fierro RPG (MTA:SA)

Etap 1 - rdzen gamemode'a: rejestracja/logowanie (SQLite + bcrypt), postacie, pieniadze (gotowka/bank), HUD, spawn w San Fierro, autozapis, respawn w szpitalu.

## Instalacja
1. Skopiuj `resources/sf_rpg` do `mods/deathmatch/resources/` na serwerze MTA.
2. W konsoli: `refresh`, potem `start sf_rpg`.
3. Dodaj `<resource src="sf_rpg" startup="1" protected="0" />` do mtaserver.conf, aby startowal automatycznie.

Konfiguracja (spawny, kasa startowa, skiny): `resources/sf_rpg/shared.lua`.
Komendy: `/przelej [gracz] [kwota]`.
Eksporty: `getCharacterData`, `giveMoney`, `takeMoney`.

Uwaga: kod nie byl testowany na zywym serwerze (brak MTA w srodowisku autora) - zglaszaj bledy z debugscript 3.
Nastepne etapy: frakcje, prace, pojazdy, domy, ekwipunek.
