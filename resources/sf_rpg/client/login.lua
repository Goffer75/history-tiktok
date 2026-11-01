local sw, sh = guiGetScreenSize()
local win, eUser, ePass, lblMsg, bLogin, bReg
local cwin, eName, lblCMsg, bCreate, bPrev, bNext
local skins, skinIdx, preview = {}, 1, nil

local function msg(l, t) if isElement(l) then guiSetText(l, t) end end

local function setCam()
    fadeCamera(true)
    setCameraMatrix(-1900, 900, 80, -1750, 950, 30)
end

addEvent("sf:showLogin", true)
addEventHandler("sf:showLogin", root, function()
    if isElement(win) then return end
    setCam()
    showChat(false)
    showCursor(true)
    local w, h = 340, 230
    win = guiCreateWindow((sw - w) / 2, (sh - h) / 2, w, h, "San Fierro RPG - Logowanie", false)
    guiWindowSetSizable(win, false)
    guiCreateLabel(20, 35, 80, 20, "Login:", false, win)
    eUser = guiCreateEdit(100, 32, 220, 26, "", false, win)
    guiCreateLabel(20, 75, 80, 20, "Haslo:", false, win)
    ePass = guiCreateEdit(100, 72, 220, 26, "", false, win)
    guiEditSetMasked(ePass, true)
    lblMsg = guiCreateLabel(20, 110, 300, 40, "", false, win)
    guiLabelSetColor(lblMsg, 255, 90, 90)
    bLogin = guiCreateButton(20, 160, 145, 40, "Zaloguj", false, win)
    bReg = guiCreateButton(175, 160, 145, 40, "Zarejestruj", false, win)
end)

local function submit(ev)
    local u, p = guiGetText(eUser), guiGetText(ePass)
    if u == "" or p == "" then return msg(lblMsg, "Wypelnij oba pola.") end
    msg(lblMsg, "Prosze czekac...")
    triggerServerEvent(ev, resourceRoot, u, p)
end

addEventHandler("onClientGUIClick", root, function()
    if source == bLogin then submit("sf:login")
    elseif source == bReg then submit("sf:register")
    elseif source == bCreate then
        triggerServerEvent("sf:createCharacter", resourceRoot, guiGetText(eName), skins[skinIdx])
    elseif source == bPrev or source == bNext then
        skinIdx = skinIdx + (source == bNext and 1 or -1)
        if skinIdx < 1 then skinIdx = #skins elseif skinIdx > #skins then skinIdx = 1 end
        if isElement(preview) then setElementModel(preview, skins[skinIdx]) end
    end
end)

addEvent("sf:authResult", true)
addEventHandler("sf:authResult", root, function(ok, text)
    if ok then
        if isElement(win) then destroyElement(win) end
        win = nil
        showCursor(false)
        showChat(true)
    else
        msg(lblMsg, text)
    end
end)

addEvent("sf:showCharCreator", true)
addEventHandler("sf:showCharCreator", root, function(allowed)
    skins, skinIdx = allowed, 1
    showCursor(true)
    local w, h = 340, 220
    cwin = guiCreateWindow((sw - w) / 2, (sh - h) / 2, w, h, "Tworzenie postaci", false)
    guiWindowSetSizable(cwin, false)
    guiCreateLabel(20, 35, 300, 20, "Imie i nazwisko (np. John Smith):", false, cwin)
    eName = guiCreateEdit(20, 58, 300, 26, "", false, cwin)
    bPrev = guiCreateButton(20, 95, 60, 30, "<", false, cwin)
    guiCreateLabel(95, 101, 150, 20, "Zmien skin", false, cwin)
    bNext = guiCreateButton(260, 95, 60, 30, ">", false, cwin)
    lblCMsg = guiCreateLabel(20, 132, 300, 20, "", false, cwin)
    guiLabelSetColor(lblCMsg, 255, 90, 90)
    bCreate = guiCreateButton(20, 160, 300, 40, "Stworz postac", false, cwin)
end)

addEvent("sf:charResult", true)
addEventHandler("sf:charResult", root, function(ok, text)
    if ok then
        if isElement(cwin) then destroyElement(cwin) end
        cwin = nil
        showCursor(false)
        showChat(true)
    else
        msg(lblCMsg, text)
    end
end)
