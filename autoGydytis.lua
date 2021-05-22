script_name("Auto /gydytis")
script_version("1.0")
script_authors("Emilis")

local sampev = require 'lib.samp.events'
local enable = true
local interiorCheck = false
local interiorCheck2 = false
local takeGun = false
local pzuCheck = true
local enter = false

-------------------------------------------------------------------------

function main()
	repeat wait(0)
	until isSampAvailable()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("autogydytis")
		if not cmdResult then
			local result = sampRegisterChatCommand("autogydytis", toggleScript)
		end
		if interiorCheck and pzuCheck then sendCmd("/gydytis") interiorCheck = false takeGun = true end
	end
end

-------------------------------------------------------------------------

function toggleScript()
	enable = not enable
	if enable then
		sampAddChatMessage("[AUTO /gydytis] {34eb37}Ijungtas. {b88d0f}Isjungti su /autogydytis.", 0x1cd031)
	else
		sampAddChatMessage("[AUTO /gydytis] {eb3434}Isjungtas. {b88d0f}Ijungti su /autogydytis.", 0x1cd031)
	end
end

-------------------------------------------------------------------------

function sampev.onSendInteriorChangeNotification(interior)
	if not enable then return end
	if interior ~= 0 then interiorCheck = true interiorCheck2 = true end
end

-------------------------------------------------------------------------

function sendCmd(cmd)
	sampSendChat(cmd)
end

-------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
	if not enable then return end
	if interiorCheck2 and pzuCheck and string.find(text, "Tokios komandos n") then enter = true end
	interiorCheck2 = false
	if enter then
		enter = false
		sampAddChatMessage("[AUTO /gydytis] Neturite namo rakto.", 0xff0000)
		return false
	end
end

-------------------------------------------------------------------------

function sampev.onTogglePlayerSpectating(state)
	if state then pzuCheck = false else pzuCheck = true end
end
