script_name ("Set camera pos")
script_version("1.0")
script_author("Emilis")
script_description("description")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local toggle = false
local memory = require 'memory'

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("camset")
		if not cmdResult then
			local result = sampRegisterChatCommand("camset", readCmd)
		end
	end
end

--------------------------------------------------------------------------------

function readCmd(arg)
	if #arg == 0 then
		sampAddChatMessage("[CamSet] /camset x y z rotX rotY rotZ", 0xffffff)
		local X, Y, Z = getActiveCameraCoordinates()
		sampAddChatMessage("[CamPos] X: "..X.."   Y: "..Y.."   Z: "..Z, 0xffffff)
		--memory.setfloat(0xB6EC00, -1900.0, true)
		cmrFixed(X, Y, Z, 0.0, 0.0, 0.0)
		--[[
		writeMemory(0xB6EC00, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6F33C, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6F348, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6F384, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6F868, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6F874, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6F934, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6F9D0, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6FA18, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6FF84, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB6FFB8, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB700E0, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB76874, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0xB7688C, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0x0195BD34, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0x0195BD74, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0x03E4FFD8, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0x03E4FFE4, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0x03E5C2A0, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0x26BA7C18, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0x03E4FFD8, 4, representFloatAsInt(-1900.0), true)
		writeMemory(0x03E4FFD8, 4, representFloatAsInt(-1900.0), true)
		]]
	end
	if arg == "get" then
		 doublevalue = memory.getuint64 (0xB6EC00, false)
		 printString(tostring(doublevalue), 300)
	end
	if arg == "restore" then
		restoreCamera()
	end
end

--------------------------------------------------------------------------------

function cmrFixed(x, y, z, rotX, rotY, rotZ)
	sampAddChatMessage("vykdau", -1)
	setFixedCameraPosition (x+5.0, y, z, rotX, rotY, rotZ)
	pointCameraAtPoint (x+15.0, y+5.0, z, 2)
	setCameraPositionUnfixed(0.5, 0.5)
end
