script_name ("Auto /baik mafiju zonose")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {
		enable = true,
		toggleCamera = true,
		toggleAlways = true,
	}
}
local maxas = 0.0
local toggle1 = false
local toggle2 = false
local toggle3 = false
local toggleCmd = false
local i = 0

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//AutoBaik//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "AutoBaik/settings")
	end
	iniData = inicfg.load(mainCfg, "AutoBaik/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("baik")
		if not cmdResult then
			local result = sampRegisterChatCommand("baik", toggleScript)
		end
		if not iniData.settings.enable then toggle3 = false end
		if toggle3 then sendCmd("/baik") toggle3 = false end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas


function toggleScript(arg)
	if arg == "toggle" then
		iniData.settings.enable = not iniData.settings.enable
		if iniData.settings.enable then
			sampAddChatMessage("[AUTO /baik] {16f534}Ijungtas.", 0x1cd031)
		else
			sampAddChatMessage("[AUTO /baik] {ff0000}Isjungtas.", 0x1cd031)
		end
		writeSetting(true)
	end
	if arg == "camera" then
		iniData.settings.toggleCamera = not iniData.settings.toggleCamera
		if iniData.settings.toggleCamera then
			sampAddChatMessage("[AUTO /baik] Kameros nenusukimas {b88d0f}tik kai auto /baik {16f534}ijungtas.", 0x1cd031)
		else
			sampAddChatMessage("[AUTO /baik] Kameros nenusukimas {b88d0f}tik kai auto /baik {ff0000}isjungtas.", 0x1cd031)
		end
		writeSetting(true)
	end
	if arg == "always" then
		iniData.settings.toggleAlways = not iniData.settings.toggleAlways
		if iniData.settings.toggleAlways then
			sampAddChatMessage("[AUTO /baik] Kameros nenusukimas {b88d0f}visada {16f534}ijungtas.", 0x1cd031)
		else
			sampAddChatMessage("[AUTO /baik] Kameros nenusukimas {b88d0f}visada {ff0000}isjungtas.", 0x1cd031)
		end
		writeSetting(true)
	end
	if arg == "info" then
		sampAddChatMessage("----------------------------------------------------------------", 0x1cd031)
		sampAddChatMessage("[AUTO /baik] Ijungti ar isjungti script: {b88d0f}/baik toggle", 0x1cd031)
		sampAddChatMessage("[AUTO /baik] Neleisti servui nusukt kamera kai /baik: {b88d0f}/baik camera", 0x1cd031)
		sampAddChatMessage("[AUTO /baik] Neleisti servui nusukt kamera {ff0000}visada: {b88d0f}/baik always", 0x1cd031)
		sampAddChatMessage("----------------------------------------------------------------", 0x1cd031)
	end
	if #arg == 0 then
		sendCmd("/baik")
	end
	if arg ~= "toggle" and arg ~= "info" and arg ~= "always" and arg ~= "camera" and #arg > 0 then
		sendCmd("/baik")
	end
end

--------------------------------------------------------------------------------
-- Ini failo apdirbimas

function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "AutoBaik/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[AUTO /baik] Nustatymai irasyti.", 0x1cd031) end
end

--------------------------------------------------------------------------------

function sampev.onSendPlayerSync(data)
	if toggle2 then
		if i < 200 then i = i + 1
		else toggle2 = false end
	end
	if not toggle2 then
		if data.moveSpeed.z < -0.22 then toggle1 = true end
		local result = isCharInAreaOnFoot2d(PLAYER_PED, -645.8, 1000.5, -729.0, 913.5, false)
		local result1 = isCharInAreaOnFoot2d(PLAYER_PED, -1064.5, -1595.9, -1136.4, -1697.8, false)
		if result then
			if data.position.z < 14.0 and toggle1 then toggle1 = false toggle2 = true i = 0 toggle3 = true if iniData.settings.toggleCamera then toggleCamera = true end end
		end
		if result1 then
			if data.position.z < 78.6 and toggle1 then toggle1 = false toggle2 = true i = 0 toggle3 = true if iniData.settings.toggleCamera then toggleCamera = true end end
		end
	end
end

function sendCmd(cmd)
	sampSendChat(cmd)
end

function sampev.onSetCameraBehind()
	if iniData.settings.toggleAlways then
		return false
	end
	if toggleCamera then
		toggleCamera = false
		return false
	end
end
