script_name ("raknet Send")
script_version("1.0")
script_author("Emilis")
script_description("description")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {enable = true}
}
local originX = 0.0
local originY = 0.0
local originZ = 0.0
local targetX = 0.0
local targetY = 0.0
local targetZ = 0.0
local centerX = 0.0
local centerY = 0.0
local centerZ = 0.0

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("rpc")
		if not cmdResult then
			local result = sampRegisterChatCommand("rpc", toggleScript)
		end
		--local result, ped = getCharPlayerIsTargeting(PLAYER_PED)
		local result = isPlayerTargettingChar(player, ped)
		if result then sampAddChatMessage(ped, -1) end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas


function toggleScript(arg)

	if arg == "del" then
		RakNet = raknetNewBitStream()
		raknetBitStreamWriteInt8(RakNet, 204)
		raknetBitStreamWriteInt16(RakNet, 65535)
		raknetBitStreamWriteInt16(RakNet, 65535)
		raknetBitStreamWriteInt8(RakNet, 0)
		--raknetBitStreamWriteInt8(RakNet, 24)
		--raknetBitStreamWriteInt16(RakNet, 996)
		raknetSendBitStream(RakNet)
		raknetDeleteBitStream(RakNet)
		return
	end
	--[[
		RakNet = raknetNewBitStream()
		raknetBitStreamWriteInt8(RakNet, 204)
		raknetBitStreamWriteInt16(RakNet, tonumber(arg))
		raknetBitStreamWriteInt16(RakNet, 65535)
		raknetBitStreamWriteInt8(RakNet, 0)
		--raknetBitStreamWriteInt8(RakNet, 24)
		--raknetBitStreamWriteInt16(RakNet, 996)
		raknetSendBitStream(RakNet)
		raknetDeleteBitStream(RakNet)
		]]
		sampAddChatMessage("vykdau", -1)
		--[[
		local data = samp_create_sync_data('bullet', false)
		data.targetType = 1
		data.targetId = tonumber(arg)
		data.origin.x, data.origin.y, data.origin.z = getActiveCameraCoordinates()
		data.target.x, data.target.y, data.target.z = data.origin.x + 5.0, data.origin.y + 5.0, data.origin.z + 5.0
		data.weaponId = getCurrentCharWeapon(PLAYER_PED)
		data.send()
		]]
end

-- {0.292832, 0.388079},   // 24
--[[
function sampev.onSendGiveDamage(playerId, damage, weaponId, bodypart)
sampAddChatMessage(playerId, -1)
sampAddChatMessage(damage, -1)
sampAddChatMessage(weaponId, -1)
sampAddChatMessage(bodypart, -1)
--bodypart = 3
--sampAddChatMessage(bodypart, -1)
--return {playerId, damage, weaponId, bodypart}
end
]]
--[[
function sampev.onSendTakeDamage(playerId, damage, weaponId, bodypart)
sampAddChatMessage(playerId, -1)
sampAddChatMessage(damage, -1)
sampAddChatMessage(weaponId, -1)
sampAddChatMessage(bodypart, -1)
--damage = 24.5
--return {playerId, damage, weaponId, bodypart}
end
]]


--[[
function sampev.onCreateObject(objectId, data)
--if data.modelId == 450 then
sampAddChatMessage("idejo "..objectId, 1000)
--end
end

function sampev.onDestroyObject(objectId)
sampAddChatMessage("sunaikino "..objectId, 1000)
return false
end
]]
--setCharProofs(ped, BP, FP, EP, CP, MP)
--[[
function onSendPacket(id, bitstream)
	if id == 204 then
		sampAddChatMessage("issiunciu", -1)
		--return false
	end
end

function sampev.onSendWeaponsUpdate(playerTarget, actorTarget, weapons)
	sampAddChatMessage(playerTarget, -1)
	sampAddChatMessage(actorTarget, -1)
	for i = 1, #weapons do
		if weapons[i] ~= nil then
			sampAddChatMessage("ammo: "..weapons[i].ammo, -1)
			sampAddChatMessage("slot: "..weapons[i].slot, -1)
			sampAddChatMessage("weapon: "..weapons[i].weapon, -1)
		end
	end
end
]]

function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    -- from SAMP.Lua
    local raknet = require 'samp.raknet'
    require 'samp.synchronization'

    copy_from_player = copy_from_player or true
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    -- copy player's sync data to the allocated memory
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    -- function to send packet
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    -- metatable to access sync data and 'send' function
    local mt = {
        __index = function(t, index)
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
end


function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
	--[[
	sampAddChatMessage("id: "..id, -1)
	sampAddChatMessage("color: "..color, -1)
	sampAddChatMessage("positionx: "..position.x, -1)
	sampAddChatMessage("positiony: "..position.y, -1)
	sampAddChatMessage("positionz: "..position.z, -1)
	sampAddChatMessage("distance: "..distance, -1)
	if testLOS then sampAddChatMessage("testLOS: ", -1) end
	sampAddChatMessage("attachedPlayerId: "..attachedPlayerId, -1)
	sampAddChatMessage("attachedVehicleId: "..attachedVehicleId, -1)
	sampAddChatMessage("text: "..text, -1)
	]]
	if attachedPlayerId == 5 then
		printString("darau", 100)
		pakeist = string.match(text, "FPS: %d+")
		pakeist = string.match(pakeist, "%d+")
		pakeist2 = tonumber(pakeist)
		pakeist2 = pakeist2 * 5
		text = string.gsub(text, "FPS: %d+", "FPS1: "..pakeist2)
		return {id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text}
	end
end

function sampev.onSetPlayerVelocity(velocity)
	sampAddChatMessage("aaa", -1)
	return false
end 
-- su situ galima padaryt kad /baik nesustabdytu
-- function sampev.onClearPlayerAnimation(con)
-- 	sampAddChatMessage("aaa", -1)
-- 	return false
-- end 

