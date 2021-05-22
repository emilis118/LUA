script_name("goto")

-----------------------------------------------------------------------------

require "lib.sampfuncs"
require "lib.moonloader"
local sampev = require 'lib.samp.events'
local enable = false
local enable1 = true
local fakePos = false
local noPosChange = false
local performBank = false
local sendOld = false
local orgPosX = 0.0
local orgPosY = 0.0
local orgPosZ = 0.0
local result = false


-----------------------------------------------------------------------------

function main()
	repeat wait (0)
	until isSampLoaded()
	repeat wait (0)
	until isSampfuncsLoaded()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("goto")
		if not cmdResult then
			local result = sampRegisterChatCommand("goto", toggleFunc)
		end
		if enable then
			--2474 bankas tpls
			noPosChange = true
			wait(200)
			sampSendChat("/tpls")
			wait(200)
			if performBank then
				--sampAddChatMessage("c", 0xffffff)
				--sampSendPickedUpPickup(2474)
				performBank = false
				enable = false
				sendOld = true
				enable1 = false
			end
		end
	end
end

-----------------------------------------------------------------------------

function toggleFunc(arg)
	--sampAddChatMessage("bankinam", 0xffffff)
	result, orgPosX, orgPosY, orgPosZ = sampGetStreamedOutPlayerPos(tonumber(arg))
	enable = true
end

-----------------------------------------------------------------------------

function sampev.onSetPlayerPos(position)
	--sampAddChatMessage("debug: "..position.x.." Y: "..position.y.." Z: "..position.z, 0xffffff)
	if noPosChange then
		--sampAddChatMessage("b", 0xffffff)
		noPosChange = false
		performBank = true
		fakePos = true
		position.x = orgPosX
		position.y = orgPosY
		position.z = orgPosZ
		return {position}
	end
end

----------------------------------------------------------------------------

function sampev.onSendPlayerSync(data)
	if fakePos then
		data.position.x = 383.09
		data.position.y = -1818.38
		data.position.z = 7.84
		fakePos = false
	end
	if sendOld then
		--sampAddChatMessage("a", 0xffffff)
		sendOld = false
		data.position.x = orgPosX
		data.position.y = orgPosY
		data.position.z = orgPosZ
	end
end
