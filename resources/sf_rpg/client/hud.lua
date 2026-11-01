local sw, sh = guiGetScreenSize()
local scale = math.max(sh / 1080, 0.7)

addEventHandler("onClientResourceStart", resourceRoot, function()
    setPlayerHudComponentVisible("money", false)
end)
addEventHandler("onClientResourceStop", resourceRoot, function()
    setPlayerHudComponentVisible("money", true)
end)

addEventHandler("onClientRender", root, function()
    local name = getElementData(localPlayer, "sf:charName")
    if not name then return end
    local money = getElementData(localPlayer, "sf:money") or 0
    local bank = getElementData(localPlayer, "sf:bank") or 0
    local x, y = sw - 330 * scale, 20 * scale
    dxDrawText("$" .. money, x + 1, y + 1, sw - 20 * scale + 1, y + 41, tocolor(0, 0, 0, 255), 1.6 * scale, "bankgothic", "right")
    dxDrawText("$" .. money, x, y, sw - 20 * scale, y + 40, tocolor(80, 220, 80, 255), 1.6 * scale, "bankgothic", "right")
    dxDrawText("Bank: $" .. bank, x, y + 40 * scale, sw - 20 * scale, y + 70 * scale, tocolor(230, 230, 230, 255), 1.0 * scale, "default-bold", "right")
    dxDrawText(name, x, y + 65 * scale, sw - 20 * scale, y + 90 * scale, tocolor(200, 200, 255, 255), 1.0 * scale, "default-bold", "right")
end)
