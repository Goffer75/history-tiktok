DB = nil

local function createTables()
    dbExec(DB, [[CREATE TABLE IF NOT EXISTS accounts (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(20) NOT NULL UNIQUE,
        password VARCHAR(100) NOT NULL,
        serial VARCHAR(32) NULL,
        registered INT UNSIGNED NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
    dbExec(DB, [[CREATE TABLE IF NOT EXISTS characters (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        account_id INT UNSIGNED NOT NULL UNIQUE,
        name VARCHAR(24) NOT NULL UNIQUE,
        skin SMALLINT NOT NULL,
        money INT NOT NULL,
        bank INT NOT NULL,
        health FLOAT NOT NULL DEFAULT 100,
        armor FLOAT NOT NULL DEFAULT 0,
        x FLOAT NULL, y FLOAT NULL, z FLOAT NULL, rot FLOAT NULL,
        interior TINYINT UNSIGNED NOT NULL DEFAULT 0,
        dimension INT UNSIGNED NOT NULL DEFAULT 0,
        playtime INT UNSIGNED NOT NULL DEFAULT 0,
        FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
end

addEventHandler("onResourceStart", resourceRoot, function()
    local conn = string.format("dbname=%s;host=%s;port=%d;charset=%s",
        MySQL.database, MySQL.host, MySQL.port, MySQL.charset)
    DB = dbConnect("mysql", conn, MySQL.user, MySQL.password, "share=1")
    if not DB then
        outputServerLog("[SF-RPG] BLAD: nie mozna polaczyc z MySQL. Sprawdz server/mysql_config.lua")
        outputDebugString("[SF-RPG] Brak polaczenia z MySQL - zatrzymuje zasob.", 1)
        cancelEvent()
        stopResource(getThisResource())
        return
    end
    createTables()
    outputServerLog("[SF-RPG] Polaczono z MySQL, tabele gotowe.")
    for _, p in ipairs(getElementsByType("player")) do
        triggerClientEvent(p, "sf:showLogin", p)
    end
end)

addEventHandler("onResourceStop", resourceRoot, function()
    if DB and isElement(DB) then destroyElement(DB) end
end)
