script_name ("Fake Animations")
script_version("1.0")
script_author("Emilis")
script_description("description")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {str = "pagrindiniai nustatymai cia"}
}
local pirmoPozX = 0.0
local pirmoPozY = 0.0
local pirmoPozZ = 0.0
local pirmasId = 0
local antrasId = 0
local toggle1 = false
local toggle2 = false
local toggle3 = false
local part1 = false
local part2 = false
local part3 = false
local part4 = false
local kintX = 0.6
local kintY = 0.0
local kintZ = 0.0

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("setactor1")
		if not cmdResult then
			local result = sampRegisterChatCommand("setactor1", toggleScript)
		end
		local cmdResult = sampIsChatCommandDefined("setactor2")
		if not cmdResult then
			local result = sampRegisterChatCommand("setactor2", setActor)
		end
		local cmdResult = sampIsChatCommandDefined("setrotation")
		if not cmdResult then
			local result = sampRegisterChatCommand("setrotation", rotationSet)
		end
	end
end

--------------------------------------------------------------------------------

function sampev.onApplyPlayerAnimation(playerId, animLib, animName, frameDelta, loop, lockX, lockY, freeze, time)
	--[[ viskas apie animacijas
	sampAddChatMessage("playerID: "..playerId, 0xffffff)
	sampAddChatMessage("animLib: "..animLib, 0xffffff)
	sampAddChatMessage("animName: "..animName, 0xffffff)
	sampAddChatMessage("frameDelta: "..frameDelta, 0xffffff)
	if loop then sampAddChatMessage("loop", 0xffffff) end
	if lockX then sampAddChatMessage("lockX", 0xffffff) end
	if lockY then sampAddChatMessage("lockY", 0xffffff) end
	if freeze then sampAddChatMessage("freeze", 0xffffff) end
	sampAddChatMessage("time: "..time, 0xffffff)
	]]
	for i = 1, 200 do
		sampAddChatMessage('a', -1)
	playerId = i
	--animLib = "BLOWJOBZ"
	--animName = "BJ_COUCH_LOOP_W"
	animLib = "SNM"
	animName = "SnM_Cane_W"
	frameDelta = 4.0999999046326
	loop = true
	lockX = true
	lockY = true
	freeze = true
	time = 0
	toggle3 = true
	return {playerId, animLib, animName, frameDelta, loop, lockX, lockY, freeze, time}
end
	--[[
	if toggle2 and playerId == pirmasId then return end
	if toggle3 and playerId == antrasId then return end

	if part3 and not toggle2 then
		playerId = pirmasId
		--animLib = "BLOWJOBZ"
		--animName = "BJ_COUCH_LOOP_W"
		animLib = "BLOWJOBZ"
		animName = "BJ_STAND_LOOP_P"
		frameDelta = 4.0999999046326
		loop = true
		lockX = false
		lockY = false
		freeze = false
		time = 0
		toggle2 = true
		--return {playerId, animLib, animName, frameDelta, loop, lockX, lockY, freeze, time}
	end
	if part4 and not toggle3 then
		playerId = antrasId
		--animLib = "BLOWJOBZ"
		--animName = "BJ_COUCH_LOOP_W"
		animLib = "SNM"
		animName = "SnM_Cane_W"
		frameDelta = 4.0999999046326
		loop = true
		lockX = true
		lockY = true
		freeze = true
		time = 0
		toggle3 = true
		return {playerId, animLib, animName, frameDelta, loop, lockX, lockY, freeze, time}
	end
	]]
end

function sampev.onSetActorFacingAngle(actorId, angle)
	sampAddChatMessage("actorId: "..actorId, 0xffffff)
	sampAddChatMessage("angle: "..angle, 0xffffff)
end

--function sampev.onSendPlayerSync(data)
--myPosX = data.position.x
--myPosY = data.position.y
--myPosZ = data.position.z
--end

function sampev.onPlayerSync(playerId, data)
	--sampAddChatMessage("playerId "..playerId, 0xffffff)
	if playerId == pirmasId and part3 then return false end
	if playerId == antrasId and part4 then return false end
	if part1 and playerId == pirmasId then
		part3 = true
		pirmoPozX = data.position.x
		pirmoPozY = data.position.y
		pirmoPozZ = data.position.z
		part1 = false
	end
	if part2 and playerId == antrasId then
		part4 = true
		if pirmoPozX ~= nil then data.position.x = pirmoPozX + kintX end
		if pirmoPozY ~= nil then data.position.y = pirmoPozY + kintY end
		if pirmoPozZ ~= nil then data.position.z = pirmoPozZ + kintZ end
		part2 = false
		data.weapon = 36
		return {playerId, data}
	end
end

function toggleScript(arg)
	pirmasId = tonumber(arg)
	part1 = not part1
	if part1 then sampAddChatMessage("[pirma] ijungtas "..arg, 0xff0000) else sampAddChatMessage("[pirma ]isjungtas ", 0xff0000) toggle2 = false end
end

function setActor(arg)
	antrasId = tonumber(arg)
	part2 = not part2
	if part2 then sampAddChatMessage("[antras] ijungtas "..arg, 0xff0000) else sampAddChatMessage("[antras] isjungtas ", 0xff0000) toggle2 = false end
end

function rotationSet()
	toggle1 = not toggle1
	if toggle1 then sampAddChatMessage("rotation nustatomas", 0xffffff) end
	if pirmasId ~= nil then
		local result, ped = sampGetCharHandleBySampPlayerId(pirmasId)
		local ptr = getCharPointer(ped)
		local rotation1 = ptr + 0x558
		if result then freezeCharPosition(ped, true) setCharRotation(ped, 0.0 , 0.0, 0.0) end
	end
	if antrasId ~= nil then
		local result, ped = sampGetCharHandleBySampPlayerId(antrasId)
		if result then setCharRotation(ped, 0.0 , 0.0, 0.0) end
	end
end

function sampev.onSetPlayerFacingAngle(angle)
	return false
end
