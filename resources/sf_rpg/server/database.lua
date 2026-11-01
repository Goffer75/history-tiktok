DB = nil

addEventHandler("onResourceStart", resourceRoot, function()
    DB = dbConnect("sqlite", "sf_rpg.db")
    if not DB then
        outputServerLog("[SF-RPG] Nie mozna polaczyc z baza SQLite!")
        cancelEvent()
        return
    end
    dbExec(DB, [[CREATE TABLE IF NOT EXISTS accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        serial TEXT,
        registered INTEGER NOT NULL
    )]])
    dbExec(DB, [[CREATE TABLE IF NOT EXISTS characters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_id INTEGER UNIQUE NOT NULL,
        name TEXT NOT NULL,
        skin INTEGER NOT NULL,
        money INTEGER NOT NULL,
        bank INTEGER NOT NULL,
        health REAL NOT NULL DEFAULT 100,
        armor REAL NOT NULL DEFAULT 0,
        x REAL, y REAL, z REAL, rot REAL,
        interior INTEGER NOT NULL DEFAULT 0,
        dimension INTEGER NOT NULL DEFAULT 0,
        playtime INTEGER NOT NULL DEFAULT 0
    )]])
    outputServerLog("[SF-RPG] Baza danych gotowa.")
    -- obsluga graczy dolaczajacych przy restarcie zasobu
    for _, p in ipairs(getElementsByType("player")) do
        triggerClientEvent(p, "sf:showLogin", p)
    end
end)
