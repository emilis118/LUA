script_name ("pavadinimas")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {
		enable = true,
		printOn = true,
		key = 67,
		hpFrom = 200,
		sendFake = true,
	}
}
local mygtukai = {
	"C", "Q", "E", "R",
}
local mygtukuValue = {
	67, 81, 69, 82,
}
local dmgReceived = false
local dmgId = 0
local dmgDamage = 0.0
local dmgWeapon = 0
local dmgBodypart = 0
local mygtukaiSuccess = false
local keyPressed = false
local id = 0
local damage = {
    [22] = 8.25,
    [23] = 13.2,
    [24] = 46.2,
    [25] = 3.3,
    [26] = 3.3,
    [27] = 4.95,
    [28] = 6.6,
    [29] = 8.25,
    [30] = 9.9,
    [31] = 9.9,
    [32] = 6.6,
    [33] = 24.75,
    [34] = 41.25,
    [38] = 46.2
}

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//proInv//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "proInv/settings")
	end
	iniData = inicfg.load(mainCfg, "proInv/settings")
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("inv")
		if not cmdResult then
			local result = sampRegisterChatCommand("inv", toggleScript)
		end
		local result = sampIsChatInputActive()
		local health = getCharHealth(PLAYER_PED)
		if iniData.settings.enable and isKeyDown(iniData.settings.key) and not result and health <= iniData.settings.hpFrom then
			if iniData.settings.printOn then printString("~W~INV ~G~ON", 10) end
			inv(true) -- pakeist i true
			keyPressed = true
		else
			inv(false)
			keyPressed = false
		end
		sendFakeTakeDmg()
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript(arg)
	local hpArg = false
	local keyArg = false
	if string.find(arg, "hp %d+") then hpArg = true end
	if string.find(arg, "key %a") then keyArg = true end
	if #arg == 0 then
		iniData.settings.enable = not iniData.settings.enable
		if iniData.settings.enable then
			sampAddChatMessage("[PRO INV] {16f534}Ijungtas.", 0x1cd031)
		else
			sampAddChatMessage("[PRO INV] {ff0000}Isjungtas.", 0x1cd031)
		end
	elseif hpArg then
		local tempString = string.match(arg, "%d+")
		iniData.settings.hpFrom = tonumber(tempString)
		sampAddChatMessage("[PRO INV] Script veiks kai gyvybiu maziau nei: {ff0000}"..iniData.settings.hpFrom, 0x1cd031)
	elseif keyArg then
		local tempString = string.match(arg, " %a")
		local tempString = string.match(tempString, "%a")
		for i = 1, #mygtukai do
			if tempString:upper() == mygtukai[i] then
				iniData.settings.key = mygtukuValue[i]
				sampAddChatMessage("[PRO INV] Nustatytas naujas mygtukas: {ff0000}"..tempString:upper(), 0x1cd031)
				mygtukaiSuccess = true
				break
			else
				mygtukaiSuccess = false
			end
		end
		if not mygtukaiSuccess then
			sampAddChatMessage("[PRO INV] Leidziami mygtukai:", 0x1cd031)
			for i = 1, #mygtukai do
				sampAddChatMessage(i..". "..mygtukai[i], 0x1cd031)
			end
			mygtukaiSuccess = false
		end
	elseif arg == "print" then
		iniData.settings.printOn = not iniData.settings.printOn
		if iniData.settings.printOn then
			sampAddChatMessage("[PRO INV] Rasymas kai veikia INV: {16f534}Ijungtas.", 0x1cd031)
		else
			sampAddChatMessage("[PRO INV] Rasymas kai veikia INV: {ff0000}Isjungtas.", 0x1cd031)
		end
	elseif arg == "fake" then
		iniData.settings.sendFake = not iniData.settings.sendFake
		if iniData.settings.sendFake then
			sampAddChatMessage("[PRO INV] Fake damage siuntimas: {16f534}Ijungtas.", 0x1cd031)
		else
			sampAddChatMessage("[PRO INV] Fake damage siuntimas: {ff0000}Isjungtas.", 0x1cd031)
		end
	elseif arg == "info" then
		sampAddChatMessage("----------------------------------------------------------------", 0x1cd031)
		sampAddChatMessage("[PRO INV] {16f534}Ijungti {1cd031}/ {ff0000}isjungti {1cd031}script: {b88d0f}/inv", 0x1cd031)
		sampAddChatMessage("[PRO INV] Pakeisti mygtuka: {b88d0f}/inv key [ABC]", 0x1cd031)
		sampAddChatMessage("[PRO INV] Pakeisti nuo kiek gyvybiu veikia: {b88d0f}/inv hp [1 - 200]", 0x1cd031)
		sampAddChatMessage("[PRO INV] {16f534}Ijungti {1cd031}/ {ff0000}isjungti {1cd031}'INV ON' zinute: {b88d0f}/inv print", 0x1cd031)
		sampAddChatMessage("[PRO INV] {16f534}Ijungti {1cd031}/ {ff0000}isjungti {b88d0f}fake zalos gavimo {1cd031}siuntima: {b88d0f}/inv fake", 0x1cd031)
		sampAddChatMessage("----------------------------------------------------------------", 0x1cd031)
	end
	writeSetting(true)
end

--------------------------------------------------------------------------------
-- Ini failo apdirbimas

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "proInv/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[PRO INV] Nustatymai irasyti.", 0x1cd031) end
	--iniData = inicfg.load(nil, "proInv/settings") -- nlb gerai sitas
end

--------------------------------------------------------------------------------

function inv(toggle)
	if toggle then
		setCharProofs(PLAYER_PED, true, true, true, true, true)
	else
		setCharProofs(PLAYER_PED, false, false, false, false, false)
	end
end

--------------------------------------------------------------------------------

function sendFakeTakeDmg()
	if iniData.settings.sendFake and iniData.settings.enable and dmgReceived then
		dmgReceived = false
		sampSendTakeDamage(dmgId, dmgDamage, dmgWeapon, 3)
	end
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function sampev.onBulletSync(playerId, data)
	if data.targetId == id and keyPressed then dmgReceived = true end
	dmgId = playerId
	if data.weaponId ~= nil then dmgWeapon = data.weaponId dmgDamage = damage[data.weaponId] end
end

--------------------------------------------------------------------------------
--[[
function sampev.onSendPlayerSync(data)
	posX = data.position.x
	posY = data.position.y
	posZ = data.position.z
end
]]

--------------------------------------------------------------------------------
