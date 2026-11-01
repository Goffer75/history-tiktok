Characters = {}

function getCharacterData(player)
    return Characters[player]
end

local function syncClient(player)
    local c = Characters[player]
    if not c then return end
    setElementData(player, "sf:money", c.money)
    setElementData(player, "sf:bank", c.bank)
    setElementData(player, "sf:charName", c.name)
end
function syncCharacter(player) syncClient(player) end

local function spawnCharacter(player, c, fresh)
    local x, y, z, rot, int, dim
    if fresh or not c.x then
        local s = Config.spawns[math.random(#Config.spawns)]
        x, y, z, rot, int, dim = s[1], s[2], s[3], s[4], 0, 0
    else
        x, y, z, rot, int, dim = c.x, c.y, c.z, c.rot, c.interior, c.dimension
    end
    spawnPlayer(player, x, y, z, rot, c.skin, int, dim)
    setElementHealth(player, c.health > 0 and c.health or 100)
    setPedArmor(player, c.armor or 0)
    setPlayerName(player, (c.name:gsub(" ", "_")))
    fadeCamera(player, true)
    setCameraTarget(player, player)
    c.joined = getTickCount()
    syncClient(player)
end

function loadOrCreateCharacter(player, accountId)
    local rows = dbPoll(dbQuery(DB, "SELECT * FROM characters WHERE account_id = ?", accountId), -1)
    if rows and rows[1] then
        local c = rows[1]
        c.joined = 0
        Characters[player] = c
        spawnCharacter(player, c, false)
    else
        triggerClientEvent(player, "sf:showCharCreator", player, Config.allowedSkins)
    end
end

local function validCharName(n)
    return type(n) == "string" and #n <= 24 and n:match("^%u%l+ %u%l+$") ~= nil
end

local function skinAllowed(skin)
    for _, s in ipairs(Config.allowedSkins) do if s == skin then return true end end
    return false
end

addEvent("sf:createCharacter", true)
addEventHandler("sf:createCharacter", resourceRoot, function(name, skin)
    local player = client
    local sess = player and Session[player]
    if not sess or Characters[player] then return end
    if not validCharName(name) then
        return triggerClientEvent(player, "sf:charResult", player, false, "Format: Imie Nazwisko (np. John Smith).")
    end
    skin = tonumber(skin)
    if not skin or not skinAllowed(skin) then skin = Config.defaultSkin end
    local taken = dbPoll(dbQuery(DB, "SELECT id FROM characters WHERE name = ? COLLATE NOCASE", name), -1)
    if taken and #taken > 0 then
        return triggerClientEvent(player, "sf:charResult", player, false, "Taka postac juz istnieje.")
    end
    dbExec(DB, "INSERT INTO characters (account_id, name, skin, money, bank) VALUES (?, ?, ?, ?, ?)",
        sess.accountId, name, skin, Config.startMoney, Config.startBank)
    local rows = dbPoll(dbQuery(DB, "SELECT * FROM characters WHERE account_id = ?", sess.accountId), -1)
    if not rows or not rows[1] then
        return triggerClientEvent(player, "sf:charResult", player, false, "Blad tworzenia postaci.")
    end
    local c = rows[1]
    c.joined = 0
    Characters[player] = c
    triggerClientEvent(player, "sf:charResult", player, true, "")
    spawnCharacter(player, c, true)
end)

function saveCharacter(player)
    local c = Characters[player]
    if not c or not isElement(player) then Characters[player] = nil return end
    local x, y, z = getElementPosition(player)
    local _, _, rot = getElementRotation(player)
    local played = c.playtime
    if c.joined and c.joined > 0 then
        played = played + math.floor((getTickCount() - c.joined) / 1000)
        c.joined = getTickCount()
        c.playtime = played
    end
    dbExec(DB, [[UPDATE characters SET skin=?, money=?, bank=?, health=?, armor=?, x=?, y=?, z=?, rot=?,
        interior=?, dimension=?, playtime=? WHERE id=?]],
        getElementModel(player), c.money, c.bank, getElementHealth(player), getPedArmor(player),
        x, y, z, rot, getElementInterior(player), getElementDimension(player), played, c.id)
end

function saveAllCharacters()
    for p in pairs(Characters) do saveCharacter(p) end
end

addEventHandler("onResourceStart", resourceRoot, function()
    setTimer(saveAllCharacters, Config.saveInterval, 0)
end)
addEventHandler("onResourceStop", resourceRoot, saveAllCharacters)

addEventHandler("onPlayerQuit", root, function()
    Characters[source] = nil
end)

-- Respawn po smierci: szpital w San Fierro
addEventHandler("onPlayerWasted", root, function()
    local c = Characters[source]
    if not c then return end
    local player = source
    setTimer(function()
        if not isElement(player) or not Characters[player] then return end
        spawnPlayer(player, -2655.0, 639.0, 14.5, 180, c.skin, 0, 0)
        setElementHealth(player, 50)
        fadeCamera(player, true)
        setCameraTarget(player, player)
    end, 5000, 1)
end)
