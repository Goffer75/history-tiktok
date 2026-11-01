Session = {}

local function validUsername(name)
    return type(name) == "string" and #name >= 3 and #name <= 20 and name:match("^[%w_]+$") ~= nil
end

local function reply(player, ok, msg)
    triggerClientEvent(player, "sf:authResult", player, ok, msg)
end

function isLoggedIn(player)
    return Session[player] ~= nil
end

local function startSession(player, accountId)
    Session[player] = { accountId = accountId }
    reply(player, true, "Zalogowano.")
    loadOrCreateCharacter(player, accountId)
end

addEvent("sf:register", true)
addEventHandler("sf:register", resourceRoot, function(username, password)
    local player = client
    if not player or Session[player] then return end
    if not validUsername(username) then
        return reply(player, false, "Login: 3-20 znakow, litery, cyfry i _.")
    end
    if type(password) ~= "string" or #password < Config.minPasswordLength or #password > 64 then
        return reply(player, false, "Haslo musi miec min. " .. Config.minPasswordLength .. " znakow.")
    end
    local rows = dbPoll(dbQuery(DB, "SELECT id FROM accounts WHERE username = ?", username), -1)
    if rows and #rows > 0 then
        return reply(player, false, "Taki login jest juz zajety.")
    end
    passwordHash(password, "bcrypt", {}, function(hash)
        if not isElement(player) or Session[player] then return end
        if not hash then return reply(player, false, "Blad rejestracji.") end
        local _, _, id = dbPoll(dbQuery(DB,
            "INSERT INTO accounts (username, password, serial, registered) VALUES (?, ?, ?, ?)",
            username, hash, getPlayerSerial(player), getRealTime().timestamp), -1)
        if id then
            startSession(player, id)
        else
            reply(player, false, "Blad rejestracji (login zajety?).")
        end
    end)
end)

addEvent("sf:login", true)
addEventHandler("sf:login", resourceRoot, function(username, password)
    local player = client
    if not player or Session[player] then return end
    if type(username) ~= "string" or type(password) ~= "string" then return end
    local rows = dbPoll(dbQuery(DB, "SELECT id, password FROM accounts WHERE username = ?", username), -1)
    if not rows or not rows[1] then
        return reply(player, false, "Nieprawidlowy login lub haslo.")
    end
    local row = rows[1]
    for _, s in pairs(Session) do
        if s.accountId == row.id then
            return reply(player, false, "To konto jest juz zalogowane.")
        end
    end
    passwordVerify(password, row.password, function(ok)
        if not isElement(player) or Session[player] then return end
        if ok then
            startSession(player, row.id)
        else
            reply(player, false, "Nieprawidlowy login lub haslo.")
        end
    end)
end)

addEventHandler("onPlayerJoin", root, function()
    triggerClientEvent(source, "sf:showLogin", source)
end)

-- Jedyny handler wyjscia: najpierw zapis, potem czyszczenie danych.
addEventHandler("onPlayerQuit", root, function()
    saveCharacter(source)
    Characters[source] = nil
    Session[source] = nil
end)
