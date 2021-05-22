script_name ("ShutDown on AFK")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local mad = require 'MoonAdditions'
local vk = require "lib.vkeys"
local keyPlayer, keyVehicle = require 'lib.game.keys'
local iniData = {}
local mainCfg = {
	settings = {
		enable = false,
		debug = false,
		afkTimer = 3,
		antiAfk = false,
		sideText = true,
	},
	position = {
		varX = 0.005,
		varY = 0.5
	}
}
local isAfk = false
local oldPos = 0.0
local arJudu = false
local arEgzistuoju = false
local y = 0
local x = 0
local pressAfk = false
local pressAfk1 = false
local iterator = 0
local toggleShutdown = false
local spectatinu = false
local autoPzu = false
local autoPzuToggle = false
local specPosX = 0.0
local specPosY = 0.0
local specPosZ = 0.0


--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//shutdown//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "shutdown/settings")
	end
	iniData = inicfg.load(mainCfg, "shutdown/settings")
	--sampAddChatMessage("script uzsikrove", -1)
	screenRes()
	local shutdown_textdraw = mad.textdraw.new("~W~/shutdown idle", x, y)
	shutdown_textdraw.style = mad.font_style.MENU
	shutdown_textdraw.width = 0.5
	shutdown_textdraw.height = 0.95
	shutdown_textdraw.outline = 1
	shutdown_textdraw.shadow = 1
	shutdown_textdraw.background = false
	shutdown_textdraw.wrap = 500
	shutdown_textdraw:set_text_color(70, 168, 50, 255)

	local antiAfk_textdraw = mad.textdraw.new("~W~/antiafk idle", x, y+20)
	antiAfk_textdraw.style = mad.font_style.MENU
	antiAfk_textdraw.width = 0.5
	antiAfk_textdraw.height = 0.95
	antiAfk_textdraw.outline = 1
	antiAfk_textdraw.shadow = 1
	antiAfk_textdraw.background = false
	antiAfk_textdraw.wrap = 500
	antiAfk_textdraw:set_text_color(70, 168, 50, 255)

	local sidetext_textdraw = mad.textdraw.new("~W~/sidetext ~y~--- ~g~ijungia ~w~/ ~r~isjungia ~w~teksta", x, y+60)
	sidetext_textdraw.style = mad.font_style.MENU
	sidetext_textdraw.width = 0.5
	sidetext_textdraw.height = 0.95
	sidetext_textdraw.outline = 1
	sidetext_textdraw.shadow = 1
	sidetext_textdraw.background = false
	sidetext_textdraw.wrap = 500
	sidetext_textdraw:set_text_color(70, 168, 50, 255)

	local autopzu_textdraw = mad.textdraw.new("~W~/AutoPzu ~y~--- ~r~idle", x, y+40)
	autopzu_textdraw.style = mad.font_style.MENU
	autopzu_textdraw.width = 0.5
	autopzu_textdraw.height = 0.95
	autopzu_textdraw.outline = 1
	autopzu_textdraw.shadow = 1
	autopzu_textdraw.background = false
	autopzu_textdraw.wrap = 500
	autopzu_textdraw:set_text_color(70, 168, 50, 255)

	local incar_textdraw = mad.textdraw.new("~W~Automobilis ~r~neaptiktas", x, y+80)
	incar_textdraw.style = mad.font_style.MENU
	incar_textdraw.width = 0.5
	incar_textdraw.height = 0.95
	incar_textdraw.outline = 1
	incar_textdraw.shadow = 1
	incar_textdraw.background = false
	incar_textdraw.wrap = 500
	incar_textdraw:set_text_color(70, 168, 50, 255)

	if not iniData.settings.sideText then
		incar_textdraw.text = ""
		shutdown_textdraw.text = ""
		antiAfk_textdraw.text = ""
		sidetext_textdraw.text = ""
		autopzu_textdraw.text = ""
	end
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("shutdown")
		if not cmdResult then
			local result = sampRegisterChatCommand("shutdown", toggleScript)
		end
		local cmdResult = sampIsChatCommandDefined("antiafk")
		if not cmdResult then
			local result = sampRegisterChatCommand("antiafk", toggleAfk)
		end
		local cmdResult = sampIsChatCommandDefined("sidetext")
		if not cmdResult then
			local result = sampRegisterChatCommand("sidetext", toggleText)
		end
		local cmdResult = sampIsChatCommandDefined("autopzu")
		if not cmdResult then
			local result = sampRegisterChatCommand("autopzu", togglePzu)
		end
		local result = isCharInAnyCar(PLAYER_PED)
		if pressAfk then
			pressGameKey(vk.VK_Y)
		end
		if pressAfk1 then
			pressGameKey(vk.VK_SPACE)
		end
		if toggleShutdown and iniData.settings.enable then
			shutdown(0)
		end
		local toggleNoChange = false
		if result and arEgzistuoju and iniData.settings.sideText then
			if arJudu then
				incar_textdraw.text = "~W~Automobilis ~g~juda"
				arJudu = false
				result = false
				arEgzistuoju = false
				toggleNoChange = true
			else
				incar_textdraw.text = "~W~Automobilis ~r~nejuda"
				arJudu = false
				result = false
				arEgzistuoju = false
				toggleNoChange = true
			end
		elseif not result and not toggleNoChange and iniData.settings.sideText then
			incar_textdraw.text = "~W~Automobilis ~r~neaptiktas"
		end
		if autoPzu and not spectatinu then
			autopzu_textdraw.text = "~w~/Autopzu ~y~--- ~g~on"
			autoPzuToggle = true
			pzuRandom()
			wait(400)
		elseif not autoPzu then
			if autoPzuToggle then sampSendChat("/pzu") autoPzuToggle = false end
			autopzu_textdraw.text = "~w~/Autopzu ~y~--- ~r~off"
		end
		if iniData.settings.sideText then
			sidetext_textdraw.text = "~W~/sidetext ~y~--- ~g~ijungia ~w~/ ~r~isjungia ~w~teksta"
			if iniData.settings.enable then
				shutdown_textdraw.text = "~W~/shutdown ~y~--- ~g~on"
			else
				shutdown_textdraw.text = "~W~/shutdown ~y~--- ~r~off"
			end
			if iniData.settings.antiAfk then
				antiAfk_textdraw.text = "~W~/antiafk ~y~--- ~g~on"
			else
				antiAfk_textdraw.text = "~W~/antiafk ~y~--- ~r~off"
			end
		else
			incar_textdraw.text = ""
			shutdown_textdraw.text = ""
			antiAfk_textdraw.text = ""
			sidetext_textdraw.text = ""
			autopzu_textdraw.text = ""
		end
		if wasKeyPressed(vk.VK_F8) and iniData.settings.sideText then
			incar_textdraw.text = ""
			shutdown_textdraw.text = ""
			antiAfk_textdraw.text = ""
			sidetext_textdraw.text = ""
			autopzu_textdraw.text = ""
			wait(500)
			sidetext_textdraw.text = "~W~/sidetext ~y~--- ~g~ijungia ~w~/ ~r~isjungia ~w~teksta"
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript(arg)
	if #arg == 0 then
		iniData.settings.enable = not iniData.settings.enable
		if iniData.settings.enable then
			sampAddChatMessage("[AFK EML] {16f534}Ijungtas {1cd031}auto shutdown. PC bus isjungtas kai bus AFK {ff0000}"..iniData.settings.afkTimer.." {1cd031}min.", 0x1cd031)
		else
			sampAddChatMessage("[AFK EML] {ff0000}Isjungtas {1cd031}auto shutdown.", 0x1cd031)
		end
	end
	if #arg == 1 then
		iniData.settings.afkTimer = tonumber(arg)
		sampAddChatMessage("[AFK EML] {16f534}Nustatytas {1cd031}auto shutdown laikas: {ff0000}"..iniData.settings.afkTimer.." {1cd031}min.", 0x1cd031)
	end
	if arg == "debug" then
		iniData.settings.debug = not iniData.settings.debug
		if iniData.settings.debug then
			sampAddChatMessage("[AFK EML] Debugginimas {16f534}ijungtas{1cd031}.", 0x1cd031)
		else
			sampAddChatMessage("[AFK EML] Debugginimas {ff0000}isjungtas{1cd031}.", 0x1cd031)
		end
	end
	writeSetting(true)
end

--------------------------------------------------------------------------------

function toggleAfk()
	iniData.settings.antiAfk = not iniData.settings.antiAfk
	if iniData.settings.antiAfk then
		sampAddChatMessage("[AFK EML] {16f534}Ijungtas.", 0x1cd031)
	else
		sampAddChatMessage("[AFK EML] {ff0000}Isjungtas.", 0x1cd031)
	end
	writeSetting(true)
end

--------------------------------------------------------------------------------

function toggleText()
	iniData.settings.sideText = not iniData.settings.sideText
	if iniData.settings.sideText then
		sampAddChatMessage("[AFK EML] {16f534}Ijungtas.", 0x1cd031)
	else
		sampAddChatMessage("[AFK EML] {ff0000}Isjungtas.", 0x1cd031)
	end
	writeSetting(true)
end

--------------------------------------------------------------------------------

function togglePzu()
	autoPzu = not autoPzu
	if autoPzu then
		sampAddChatMessage("[AFK EML] AutoPzu {16f534}Ijungtas.", 0x1cd031)
	else
		sampAddChatMessage("[AFK EML] AutoPzu {ff0000}Isjungtas.", 0x1cd031)
	end
end

--------------------------------------------------------------------------------

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "shutdown/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[AFK EML] Nustatymai irasyti.", 0x1cd031) end
	--iniData = inicfg.load(nil, "shutdown/settings")
end

--------------------------------------------------------------------------------

function shutdown(time)
	if time == 0 then makeScreenshot(false) toggleShutdown = false os.execute("shutdown -s") end
	if time > 0 then makeScreenshot(false) toggleShutdown = false os.execute("shutdown -s -t "..time) end
	if time < 0 then sampAddChatMessage("[AFK EML] Laikas negali buti {ff0000}maziau {1cd031}nei {ff0000}0.", 0x1cd031) end
end

--------------------------------------------------------------------------------

function sampev.onShowTextDraw(textdrawId, textdraw)
	--if textdraw.text == 2087 then sampAddChatMessage(textdrawId.." text: "..textdraw.text, -1) end
	--if id ~= 2048 then sampAddChatMessage(textdrawId.." text: "..textdraw.text, -1) end
	if textdrawId == 2087 or textdrawId == 2091 then --pc isjungimui
		if string.find(textdraw.text, "~W~AFK "..iniData.settings.afkTimer.."min") then
			toggleShutdown = true
			if iniData.settings.debug then sampAddChatMessage("1. Pastebejau, kad AFK "..iniData.settings.afkTimer.." min.", -1) end
		end
		if string.find(textdraw.text, "~W~Esate AFK "..iniData.settings.afkTimer.."min") then
			toggleShutdown = true
			if iniData.settings.debug then sampAddChatMessage("2. Pastebejau, kad AFK "..iniData.settings.afkTimer.." min.", -1) end
		end
	end
	if textdrawId == 2087 and not string.find(textdraw.text, "LD_") then
		--if string.find(textdraw.text, "~W~AFK") then
		if iniData.settings.debug then sampAddChatMessage("3. Pastebejau, kad AFK ", -1) end
		isAfk = true
		if iniData.settings.antiAfk then
			pressAfk = true
			if iniData.settings.debug then sampAddChatMessage("paspaudziu antiAFK", -1) end
		end
		--end
		--[[
		if string.find(textdraw.text, "~W~Dabar esate AFK") then
		if iniData.settings.debug then sampAddChatMessage("3. Pastebejau, kad AFK "..iniData.settings.afkTimer.." min.", -1) end
		isAfk = true
		if iniData.settings.antiAfk then
		pressAfk = true
		if iniData.settings.debug then sampAddChatMessage("paspaudziu antiAFK", -1) end
	end
end
]]
end
if textdrawId == 2091 and iniData.settings.antiAfk then pressAfk1 = true end
end

--------------------------------------------------------------------------------

function sampev.onTextDrawSetString(id, text)
	--if id == 2087 then sampAddChatMessage(id.." text666: "..text, -1) end
	--if id ~= 2048 then sampAddChatMessage(id.." text666: "..text, -1) end
	if id == 2087 or id == 2091 then -- pc isjungimui
		if string.find(text, "~W~AFK "..iniData.settings.afkTimer.."min") then
			if iniData.settings.debug then sampAddChatMessage("4. Pastebejau, kad AFK "..iniData.settings.afkTimer.." min.", -1) end
			isAfk = true
			toggleShutdown = true
		end
		if string.find(text, "~W~Esate AFK "..iniData.settings.afkTimer.."min") then
			if iniData.settings.debug then sampAddChatMessage("5. Pastebejau, kad AFK "..iniData.settings.afkTimer.." min.", -1) end
			isAfk = true
			toggleShutdown = true
		end
	end
	if id == 2087 and not string.find(text, "LD_") then
		--if string.find(text, "~W~AFK") then
		if iniData.settings.debug then sampAddChatMessage("6. Pastebejau, kad AFK ", -1) end
		isAfk = true
		if iniData.settings.antiAfk then
			pressAfk = true
			if iniData.settings.debug then sampAddChatMessage("paspaudziu antiAFK", -1) end
		end
		--end
		--[[
		if string.find(text, "~W~Dabar esate AFK") then
		if iniData.settings.debug then sampAddChatMessage("6. Pastebejau, kad AFK "..iniData.settings.afkTimer.." min.", -1) end
		isAfk = true
		if iniData.settings.antiAfk then
		pressAfk = true
		if iniData.settings.debug then sampAddChatMessage("paspaudziu antiAFK", -1) end
	end
end
]]
end
if id == 2091 and iniData.settings.antiAfk then pressAfk1 = true end
end

--------------------------------------------------------------------------------

function sampev.onTextDrawHide(textdrawId)
	if iniData.settings.debug then sampAddChatMessage("veikia"..textdrawId, -1) end
	if textdrawId == 2087 or 2091 then
		isAfk = false
		pressAfk = false
		pressAfk1 = false
		iterator = 0
		if iniData.settings.debug then sampAddChatMessage("isAfk = false", -1) end
	end
end

--------------------------------------------------------------------------------

function sampev.onSendPassengerSync(data)
	if oldPos ~= data.position.x then
		local skirtumas = math.abs(oldPos - data.position.x)
		if skirtumas > 0.1 then
			oldPos = data.position.x
			arJudu = true
		else
			arJudu = false
		end
	end
end

--------------------------------------------------------------------------------

function sampev.onSendStatsUpdate(money, drunkLevel)
	arEgzistuoju = true
end

--------------------------------------------------------------------------------

function screenRes()
	local w, h = getScreenResolution()
	x = math.floor(w * iniData.position.varX)
	y = math.floor(h * iniData.position.varY)
end

--------------------------------------------------------------------------------

function pressGameKey(key)
	if iniData.settings.debug then sampAddChatMessage("Paspaudziu conv yes ", -1) end --..keyVehicle.CONVERSATIONYES
	iterator = iterator + 1
	if iterator > 20 then
		pressAfk = false
		pressAfk1 = false
		iterator = 0
		setVirtualKeyDown(vk.VK_T, true)
		setVirtualKeyDown(vk.VK_T, false)
		wait(100)
		setVirtualKeyDown(vk.VK_RETURN, true)
		wait(100)
		setVirtualKeyDown(vk.VK_RETURN, false)
	end
	--setGameKeyState(11, 65536)
	--setCharKeyDown(11, true)
	local random = math.random(1100, 2000)
	wait(random)
	setVirtualKeyDown(key, true)
	wait(500)
	setVirtualKeyDown(key, false)
	--setCharKeyDown(11, false)
	--setGameKeyState(11, 0)
	if iniData.settings.debug then sampAddChatMessage("Atleidziu", -1) end
end

--------------------------------------------------------------------------------

function sampev.onConnectionClosed()
	toggleShutdown = true
end

--------------------------------------------------------------------------------

function makeScreenshot(disable)
	if disable then displayHud(false) sampSetChatDisplayMode(0) end
	require('memory').setuint8(sampGetBase() + 0x119CBC, 1)
	if disable then displayHud(true) sampSetChatDisplayMode(2) end
end

--------------------------------------------------------------------------------

function sampev.onTogglePlayerSpectating(state)
	if state then spectatinu = true end
	if not state then spectatinu = false end
end

--------------------------------------------------------------------------------

function pzuRandom()
	local maxId = sampGetMaxPlayerId(false)
	local pzuId = math.random(1, maxId)
	sampSendChat("/pzu "..pzuId)
end

--------------------------------------------------------------------------------

function sampev.onSendSpectatorSync(data)
	specPosX = data.position.x
	specPosY = data.position.y
	specPosZ = data.position.z
end

--------------------------------------------------------------------------------

function syncDataToOnfootData()
	if not iniData.settings.antiAfk then return end
	local dataPtr = allocateMemory(40)
	setStructElement(dataPtr, 0, 1, 1, false)
	setStructElement(dataPtr, 1, 2, 198, true)
	sampAddChatMessage(originX, -1)
	setStructFloatElement(dataPtr, 3, originX, true)
	setStructFloatElement(dataPtr, 7, originY, true)
	setStructFloatElement(dataPtr, 11, originZ, true)
	setStructFloatElement(dataPtr, 15, targetX, true)
	setStructFloatElement(dataPtr, 19, targetY, true)
	setStructFloatElement(dataPtr, 23, targetZ, true)
	setStructFloatElement(dataPtr, 27, centerX, true)
	setStructFloatElement(dataPtr, 31, centerY, true)
	setStructFloatElement(dataPtr, 35, centerZ, true)
	setStructElement(dataPtr, 39, 1, 24, false)
	sampSendBulletData(dataPtr)
	freeMemory(dataPtr)
end

--------------------------------------------------------------------------------




--------------------------------------------------------------------------------





--------------------------------------------------------------------------------





--------------------------------------------------------------------------------
