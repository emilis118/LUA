script_name ("No text filler")
script_version("1.0")
script_author("Emilis")
script_description("description")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {toggle = true}
}

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//NoChatFiller//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "NoChatFiller/settings")
	end
	iniData = inicfg.load(mainCfg, "NoChatFiller/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("chatfiller")
		if not cmdResult then
			local result = sampRegisterChatCommand("chatfiller", toggleScript)
		end
	end
end

--------------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
	if not iniData.settings.toggle then return end
	if color == 16711850 and text == " " then return false end
end

--------------------------------------------------------------------------------

function toggleScript()
	iniData.settings.toggle = not iniData.settings.toggle
	if iniData.settings.toggle then
		sampAddChatMessage("[Chat Filler] {ff0000}Nebebus{1fab1d} rasomos tuscios zinutes", 0x1fab1d)
	else
		sampAddChatMessage("[Chat Filler] {ffffff}Bus{1fab1d} rasomos tuscios zinutes", 0x1fab1d)
	end
	writeSetting(true)
end

--------------------------------------------------------------------------------

function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "NoChatFiller/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[Chat Filler] Nustatymai irasyti.", 0x1fab1d) end
end
