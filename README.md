# San Fierro RPG (MTA:SA) - MySQL

Etap 1 - rdzen gamemode'a na MySQL/MariaDB: rejestracja/logowanie (bcrypt), postacie, pieniadze (gotowka/bank), HUD, spawn w San Fierro, autozapis, respawn w szpitalu.

## Instalacja
1. Utworz pusta baze i uzytkownika, np.:
   `CREATE DATABASE sf_rpg CHARACTER SET utf8mb4; CREATE USER 'sf_rpg'@'127.0.0.1' IDENTIFIED BY 'twoje_haslo'; GRANT ALL ON sf_rpg.* TO 'sf_rpg'@'127.0.0.1';`
2. Wpisz dane w `resources/sf_rpg/server/mysql_config.lua` (plik tylko serwerowy). Nie commituj prawdziwego hasla.
3. Skopiuj `resources/sf_rpg` do `mods/deathmatch/resources/`, w konsoli: `refresh`, `start sf_rpg`.
   Tabele `accounts` i `characters` tworza sie automatycznie.

Wymaga serwera MTA 1.5.x+ z modulem MySQL (wbudowany w dbConnect "mysql").
Konfiguracja (spawny, kasa, skiny): `shared.lua`. Komenda: `/przelej [gracz] [kwota]`.
Eksporty: `getCharacterData`, `giveMoney`, `takeMoney`.

Uwaga: kod nie byl uruchamiany na zywym serwerze. Bledy zglaszaj z `debugscript 3`.
Nastepne etapy: frakcje, prace, pojazdy, domy, ekwipunek.
