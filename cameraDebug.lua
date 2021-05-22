script_name("AimData")
script_description("/aimdata <ID> seka zmogaus kamera")
script_version_number(1)
script_version("v.001")
script_authors("Emilis")

require "lib.sampfuncs"
require "lib.moonloader"

function main()
	repeat wait(0)	until isSampAvailable()
	while true do
		wait(0)
		if not sampIsChatCommandDefined("camdebug") then
			local result = sampRegisterChatCommand("camdebug", camDebug)		-- nustatyti
		end
	end
end

function camDebug()
local X, Y, Z = getActiveCameraCoordinates()
sampAddChatMessage("Kameros coordinates:", 0xFFFFFF)
sampAddChatMessage("X: "..X.." Y: "..Y.." Z: "..Z, 0xFFFFFF)
end
