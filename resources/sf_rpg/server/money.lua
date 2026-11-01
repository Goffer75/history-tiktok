function giveMoney(player, amount)
    local c = Characters[player]
    amount = tonumber(amount)
    if not c or not amount or amount <= 0 then return false end
    c.money = c.money + math.floor(amount)
    syncCharacter(player)
    return true
end

function takeMoney(player, amount)
    local c = Characters[player]
    amount = tonumber(amount)
    if not c or not amount or amount <= 0 then return false end
    amount = math.floor(amount)
    if c.money < amount then return false end
    c.money = c.money - amount
    syncCharacter(player)
    return true
end

addCommandHandler("przelej", function(player, _, targetName, amount)
    amount = math.floor(tonumber(amount) or 0)
    if not targetName or amount <= 0 then
        return outputChatBox("Uzycie: /przelej [gracz] [kwota]", player, 255, 200, 0)
    end
    local target = getPlayerFromName(targetName)
    if not target or target == player or not Characters[target] then
        return outputChatBox("Nie znaleziono gracza.", player, 255, 0, 0)
    end
    local x, y, z = getElementPosition(player)
    local tx, ty, tz = getElementPosition(target)
    if getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) > 5 then
        return outputChatBox("Gracz jest za daleko.", player, 255, 0, 0)
    end
    if not takeMoney(player, amount) then
        return outputChatBox("Nie masz tylu pieniedzy.", player, 255, 0, 0)
    end
    giveMoney(target, amount)
    outputChatBox("Przekazano $" .. amount .. " graczowi " .. getPlayerName(target), player, 0, 255, 0)
    outputChatBox("Otrzymano $" .. amount .. " od " .. getPlayerName(player), target, 0, 255, 0)
end)
