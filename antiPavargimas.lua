script_name ("Anti Pavargimas")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {enable = true, debug = false}
}
local toggleNoSend = false
local posX = 0.0
local posY = 0.0
local posZ = 0.0
local moveSpeedX = 0.0
local moveSpeedY = 0.0
local moveSpeedZ = 0.0

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//antiPavargimas//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "antiPavargimas/settings")
	end
	iniData = inicfg.load(mainCfg, "antiPavargimas/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("antipavargimas")
		if not cmdResult then
			local result = sampRegisterChatCommand("antipavargimas", toggleScript)
		end
		if toggleNoSend then wait(2000) toggleNoSend = false end
	end
end

--------------------------------------------------------------------------------

function toggleScript()
	if #arg == 0 then
		iniData.settings.enable = not iniData.settings.enable
		if iniData.settings.enable then
			sampAddChatMessage("[ANTI Pavargimas] {16f534}Ijungtas.", 0x1cd031)
		else
			sampAddChatMessage("[ANTI Pavargimas] {ff0000}Isjungtas.", 0x1cd031)
		end
	end
	if arg == "debug" then
		iniData.settings.debug = not iniData.settings.debug
		if iniData.settings.debug then
			sampAddChatMessage("[ANTI Pavargimas] Debugginimas {16f534}Ijungtas.", 0x1cd031)
		else
			sampAddChatMessage("[ANTI Pavargimas] Debugginimas {ff0000}Isjungtas.", 0x1cd031)
		end
	end
	writeSetting(true)
end

--------------------------------------------------------------------------------

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "antiPavargimas/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[ANTI pavargimas] Nustatymai irasyti.", 0x1cd031) end
	iniData = inicfg.load(nil, "antiPavargimas/settings")
end

--------------------------------------------------------------------------------

function sampev.onSendPlayerSync(data)
	--if not iniData.settings.enable then return end
	if not toggleNoSend then
		posX = data.position.x
		posY = data.position.y
		posZ = data.position.z
		moveSpeedX = data.moveSpeed.x
		moveSpeedY = data.moveSpeed.y
		moveSpeedZ = data.moveSpeed.z
	end
	if toggleNoSend then
		data.moveSpeed.x = 0.0
		data.moveSpeed.y = 0.0
		data.moveSpeed.z = 0.0
	end
end

--------------------------------------------------------------------------------

function sampev.onClearPlayerAnimation(playerId)
	sampAddChatMessage("clear", -1)
end

--------------------------------------------------------------------------------

function sampev.onApplyPlayerAnimation(playerId, animLib, animName, frameDelta, loop, lockX, lockY, freeze, time)
	if not iniData.settings.enable then return end
	sampAddChatMessage(animName.." "..time.." "..animLib, -1)
	if animName == "IDLE_tired" then toggleNoSend = true printString("~r~Fake ~w~pavargimas", 2000) return false end
end
