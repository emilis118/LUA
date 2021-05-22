script_name ("Fake FPS")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {enable = true}
}
local toggleFps = false
local oldMoney = 0
local oldDrunkLevel = 0
--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//fakeFPS//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "fakeFPS/settings")
	end
	iniData = inicfg.load(mainCfg, "fakeFPS/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("fps")
		if not cmdResult then
			local result = sampRegisterChatCommand("fps", toggleScript)
		end
		if toggleFps then
			newDrunkLevel = oldDrunkLevel - 1000
			newMoney = oldMoney + 1
			RakNet = raknetNewBitStream()
			raknetBitStreamWriteInt8(RakNet, 205)
			raknetBitStreamWriteInt32(RakNet, newMoney)
			raknetBitStreamWriteInt32(RakNet, newDrunkLevel)
			raknetSendBitStream(RakNet)
			raknetDeleteBitStream(RakNet)
			printString("siunciu "..newMoney, 100)
			toggleFps = false
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
	iniData.settings.enable = not iniData.settings.enable
	sampAddChatMessage("a", -1)
end

--------------------------------------------------------------------------------
-- Ini failo apdirbimas

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "fakeFPS/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[Pro INV] Nustatymai irasyti.", 0x1cd031) end
	--iniData = inicfg.load(nil, "fakeFPS/settings") -- nlb gerai sitas
end
--[[
function onSendPacket(id, bitstream)
	if id == 205 then
		toggleFps = true
		--sampAddChatMessage("ijungiu", -1)
		return false
		--return false
	end
end]]

function sampev.onSendStatsUpdate(money, drunkLevel)
	oldMoney = money
	oldDrunkLevel = drunkLevel
	toggleFps = true
	return false
end
