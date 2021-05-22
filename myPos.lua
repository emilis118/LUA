script_name("My Position")

local sampev = require 'lib.samp.events'
require "lib.sampfuncs"
require "lib.moonloader"
local myPosX = 0.0
local myPosY = 0.0
local myPosZ = 0.0
local otherPosX = 0.0
local otherPosY = 0.0
local otherPosZ = 0.0
local specX = 0.0
local specY = 0.0
local specZ = 0.0
local ID = -1
local holder = -1


function main()
	repeat wait(0)
	until isSampLoaded()
	repeat wait(0)
	until isSampfuncsLoaded()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("pos")
		if not cmdResult then
			local result = sampRegisterChatCommand("pos", findPosition)
		end
		local cmdResult = sampIsChatCommandDefined("spos")
		if not cmdResult then
			local result = sampRegisterChatCommand("spos", findSpecPos)
		end
	end
end

function findSpecPos()
	if specX ~= nil and specY ~= nil and specZ ~= nil then
		sampAddChatMessage("[SPos] X: "..specX.." , Y: "..specY.." , Z: "..specZ, 0x33bf2e)
	end 
end

function findPosition(arg)
	if #arg == 0 then
		if myPosX ~= nil and myPosY ~= nil and myPosZ ~= nil then
			sampAddChatMessage("[Pos] X: "..myPosX.." , Y: "..myPosY.." , Z: "..myPosZ, 0x33bf2e)
		end
	end
	if #arg == 1 or #arg == 2 or #arg == 3 then
		ID = tonumber(arg)
		if ID ~= holder then
			holder = ID
			sampAddChatMessage("[Pos] Pasikeite ID: "..ID, 0x33bf2e)
			otherPosX = 0.0
			otherPosY = 0.0
			otherPosZ = 0.0
		end
		sampAddChatMessage("[Pos] Filtruojama zaidejo pozicija: "..ID, 0x33bf2e)
		if otherPosX ~= nil and otherPosY ~= nil and otherPosY ~= nil then
			sampAddChatMessage("[Pos] X: "..otherPosX.." , Y: "..otherPosY.." , Z: "..otherPosZ.." , ID: "..ID, 0x33bf2e)
		end
	end
end

function sampev.onSendPlayerSync(data)
	myPosX = data.position.x
	myPosY = data.position.y
	myPosZ = data.position.z
end

function sampev.onSendSpectatorSync(data)
	specX = data.position.x
	specY = data.position.y
	specZ = data.position.z
end


function sampev.onPlayerSync(playerId, data)
	if playerId == ID then
		otherPosX = data.position.x
		otherPosY = data.position.y
		otherPosZ = data.position.z
	end
end
