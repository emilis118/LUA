script_name ("Fake message")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("msg")
		if not cmdResult then
			local result = sampRegisterChatCommand("msg", toggleScript)
		end
	end
end

--------------------------------------------------------------------------------


function toggleScript(arg)
	sampSendChat(arg)
end
