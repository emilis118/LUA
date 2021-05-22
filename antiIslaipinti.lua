script_name("Anti Islaipinimas")

require "lib.sampfuncs"
require "lib.moonloader"
local sampev = require 'lib.samp.events'
local enable = false

function main()
	repeat wait (0)
	until isSampLoaded()
	repeat wait (0)
	until isSampfuncsLoaded()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("alp")
		if not cmdResult then
			local result = sampRegisterChatCommand("alp", toggleFunc)
		end
	end
end


function toggleFunc()
	enable = not enable
	if enable then
		sampAddChatMessage("{34eb37}[alp] Ijungtas. {cdeb34}Isjungti su /alp.", 0x34eb74)
	else
		sampAddChatMessage("{eb3434}[alp] Isjungtas. {cdeb34}Ijungti su /alp.", 0x34eb74)
	end
end

function sampev.onRemovePlayerFromVehicle()
	if enable then
		sampAddChatMessage("[alp] uzblokavau islaipinima", 0x34eb74)
		return false
	end
end
