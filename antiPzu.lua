script_name("Anti Pzu")
script_description("/apzu [id]")
script_version_number(1)
script_version("v.001")
script_authors("Emilis")

local sampev = require 'lib.samp.events'
local raknet = require 'lib.samp.raknet'
local enable = false
local id = 0

function main()
	repeat wait(0)
	until isSampAvailable()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("apzu")
		if not cmdResult then
			local result = sampRegisterChatCommand("apzu", toggleFunc)
		end
	end
end

function sampev.onAimSync(playerId, data)
	if id ~= nil and playerId == id and enable then
		local camPosX = data.camPos.x
		local camPosY = data.camPos.y
		local camPosZ = data.camPos.z
		sampAddChatMessage("CAMPOS X: "..camPosX.." Y: "..camPosY.." Z: "..camPosZ, 0xffffff)
		if myCharX ~= nil and myCharY ~= nil and myCharZ ~= nil then
			local skirtX = myCharX - camPosX
			local skirtY = myCharY - camPosY
			local skirtZ = myCharZ - camPosZ
			local distance = math.sqrt(skirtX^2 + skirtY^2 + skirtZ^2)
			sampAddChatMessage("SX: "..skirtX.." SY: "..skirtX.." SZ: "..skirtX, 0xffffff)
			sampAddChatMessage("Distance: "..distance, 0xffffff)
		end
	end
end

function sampev.onSendPlayerSync(data, empty_writer)
	if enable then
		myCharX = data.position.x
		myCharY = data.position.y
		myCharZ = data.position.z
		--sampAddChatMessage("x: "..posX.." y: "..posY.." z: "..posZ, 0xFFFFFF)
		--return false
	end
end

function sampev.onPlayerStreamIn(playerId, team, model, position, rotation, color, fightingStyle)
	if enable and id ~= nil and playerId ~= nil and playerId == id then
		sampAddChatMessage("[ANTIPZU] Stream in team: "..team.." model: "..model.." position: "..position, 0xFF0000)
		sampAddChatMessage("[ANTIPZU] Stream in color: "..color.." fightstyle: "..fightingStyle, 0xFF0000)
		if myCharX ~= nil and myCharY ~= nil and myCharZ ~= nil then
			local posx = position.x
			local posy = position.y
			local posz = position.z
			local skirtX = myCharX - posx
			local skirtY = myCharY - posy
			local skirtZ = myCharZ - posz
			local distance = math.sqrt(skirtX^2 + skirtY^2 + skirtZ^2)
			if distance < 40.0 then
				sampAddChatMessage("[ANTIPZU] Atstumas (<40): "..distance, 0xffffff)
			end
		end
	end
end

function sampev.onSetPlayerSkillLevel(playerId, skill, level)
	if enable and id ~= nil and playerId ~= nil and playerId == id then
		sampAddChatMessage("[ANTIPZU] Skill: "..skill.." level: "..level, 0xFF0000)
	end
end

function sampev.onPlayerStreamOut(playerId)
	if enable and id ~= nil and playerId ~= nil and playerId == id then
		sampAddChatMessage("[ANTIPZU] Stebimas zaidejas stream out: "..playerId, 0xFF0000)
	end
end

function sampev.onSetPlayerSkin(playerId, skinId)
	if enable and id ~= nil and playerId ~= nil and playerId == id then
		sampAddChatMessage("[ANTIPZU] Nustatytas zaidejo skin: "..skinId, 0xffffff)
	end
end

function sampev.onPlayerDeath(playerId)
	if enable and id ~= nil and playerId ~= nil and playerId == id then
		sampAddChatMessage("[ANTIPZU] Zaidejas mire: "..skinId, 0xffffff)
	end
end
--[[
function sampev.onSendClickPlayer(playerId, source)
if enable and id ~= nil and playerId ~= nil and playerId == id then
sampAddChatMessage("[ANTIPZU] Send click player: "..source, 0xffffff)
end
end
]]
function sampev.onPlayerSync(playerId, data)
	if enable and id ~= nil and playerId ~= nil and playerId == id and myCharX ~= nil and myCharY ~= nil and myCharZ ~= nil then
		local skirtX = myCharX - data.position.x
		local skirtY = myCharY - data.position.y
		local skirtZ = myCharZ - data.position.z
		local distance = math.sqrt(skirtX^2 + skirtY^2 + skirtZ^2)
		if distance < 40.0 then
			sampAddChatMessage("[ANTIPZU] Atstumas(<40): "..distance, 0xffffff)
		end
	end
end

function toggleFunc(arg)
	if #arg == 0 then
		sampAddChatMessage("[ANTIPZU] Rasyti /apzu [id]", 0xffffff)
		enable = false
	end
	if #arg ~= 0 then
		id = tonumber(arg)
		enable = not enable
	end
	if enable then
		sampAddChatMessage("[ANTIPZU] Debuginamas zaidejas: "..id, 0xffffff)
	else
		sampAddChatMessage("[ANTIPZU] Isjungtas.", 0xffffff)
	end
end
