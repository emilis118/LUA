script_name("Anti AFK")
script_version("1.0")
script_author("Emilis")
script_description("/aafk")

-----------------------------------------------------------------------------

local sampev = require 'lib.samp.events'
local enable = false
local crash = false
require "lib.sampfuncs"
require "lib.moonloader"
local posX = 0.0
local posY = 0.0
local posZ = 0.0

-----------------------------------------------------------------------------

function main()
	repeat wait (0)
	until isSampLoaded()
	repeat wait (0)
	until isSampfuncsLoaded()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("asafk")
		if not cmdResult then
			local result = sampRegisterChatCommand("asafk", toggleFunc)
		end
		if crash then
			sampSendPickedUpPickup(2474)
			--sampSendClickTextdraw(53)
		end
	end
end

-----------------------------------------------------------------------------

function toggleFunc(arg)
	if #arg == 0 then
		enable = not enable
		if enable then
			sampAddChatMessage("{34eb37}[Anti AFK] Ijungtas. {cdeb34}Isjungti su /aafk.", 0x34eb74)
		else
			sampAddChatMessage("{eb3434}[Anti AFK] Isjungtas. {cdeb34}Ijungti su /aafk.", 0x34eb74)
		end
	end
end

-----------------------------------------------------------------------------

function sampev.onSendPlayerSync(data)
	if enable then
		posX = data.position.x
		posY = data.position.y
		posZ = data.position.z
		sampAddChatMessage("org X: "..data.position.x.." Y: "..data.position.y.." Z: "..data.position.z, 0xa88532)
		local random = 0.0
		random = math.random(0.0, 10.0)
		random = random * 0.01 * 10
		sampAddChatMessage("random: ".. random, 0xffffff)
		posX = posX + random
		posY = posY + random
		--posZ = posZ + random
		data.position.x = posX
		data.position.y = posY
		--data.position.z = posZ
		--data.upDownKeys = 128
		sampAddChatMessage("send X: "..data.position.x.." Y: "..data.position.y.." Z: "..data.position.z, 0x7fa832)
		--sampAddChatMessage("upDown "..data.upDownKeys, 0x7fa832)

	end
end

-----------------------------------------------------------------------------

function sampev.onConnectionRequestAccepted(ip, port, playerId, challenge)
	sampAddChatMessage("test1 "..ip, 0x7fa832)
	sampAddChatMessage("test2 "..port, 0xa88532)
	sampAddChatMessage("test3 "..playerId, 0x7fa832)
	sampAddChatMessage("test4 "..challenge, 0xa88532)
end


