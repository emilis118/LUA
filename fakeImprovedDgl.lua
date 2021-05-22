script_name ("Fake Improved dgl")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local vk = require 'lib.vkeys'
local iniData = {}
local mainCfg = {
	settings = {enable = false}
}

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()

	if not doesFileExist(getGameDirectory().."//moonloader//config//fakeImprovedDgl//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "fakeImprovedDgl/settings")
	end
	iniData = inicfg.load(mainCfg, "fakeImprovedDgl/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("fakeimpr")
		if not cmdResult then
			local result = sampRegisterChatCommand("fakeimpr", toggleScript)
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas


function toggleScript()
	iniData.settings.enable = not iniData.settings.enable
	if iniData.settings.enable then
		printString("~W~Fake Improved ~g~ON", 400)
	else
		printString("~W~Fake Improved ~R~OFF", 400)
	end
	writeSetting(false)
end

--------------------------------------------------------------------------------
-- Ini failo apdirbimas


--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "fakeImprovedDgl/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[Online Checker] Nustatymai irasyti.", 0x1cd031) end
	--iniData = inicfg.load(nil, "fakeImprovedDgl/settings") -- nlb gerai sitas
end

--------------------------------------------------------------------------------

function sampev.onShowTextDraw(textdrawId, textdraw)
	if not iniData.settings.enable then return end
	if isKeyDown(vk.VK_L) then
		if textdrawId == 2088 then
			if textdraw.letterColor == -16711681 then
				textdraw.letterColor = -1
				return {textdrawId, textdraw}
			end
		end
	end
end