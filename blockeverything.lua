require "lib.moonloader"
local ev = require 'lib.samp.events'

function ev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
return false
end

function ev.onCreateObject(objectId, data)
    return false
end

function ev.onSetObjectPosition(objectId, position)
    return false
end

function ev.onSetObjectRotation(objectId, rotation)
    return false
end

function ev.onDestroyObject(objectId)
    return false
end


function ev.onCreatePickup(id, model, pickupType, position)
    return false
end

function ev.onSetPlayerAttachedObject(playerId, index, create, object)
    return false
end

function ev.onSetObjectMaterial()
    return false
end

function ev.onSetObjectMaterialText()
    return false
end

function onReceiveRpc(id, bitStream)
	if id >= 44 and id <= 47 and toggle then
		-- return process, id, bitStream
		return false
	end
end