script_name("dialog")
script_version("1.0")
script_author("Emilis")

require "lib.sampfuncs"
require "lib.moonloader"
local text = {
	"sudas",
	"bybys",
	"kiausai",
}

function main()
	repeat wait(0)
	until isSampLoaded()
	repeat wait(0)
	until isSampfuncsLoaded()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("dialog")
		if not cmdResult then
			local result = sampRegisterChatCommand("dialog", dialog)
		end
	end
end

function dialog()
	local text = {
		"sudas",
		"bybys",
		"kiausai",
	}
	sampShowDialog(1, "caption", text, "button1", "button2", 2)
end
