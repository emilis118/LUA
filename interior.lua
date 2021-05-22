local sampev = require 'lib.samp.events'
local vk = require 'lib.vkeys'
local noInt = false

function main()
    repeat
        wait(0)
    until isSampAvailable()

    local cmdResult = sampIsChatCommandDefined('bubble')
        if not cmdResult then
            local result = sampRegisterChatCommand('bubble', toggleScript)
        end

    while true do
        wait(0)
        if isKeyDown(vk.VK_B) and not sampIsChatInputActive() then
            if not noInt then
                sampAddChatMessage('send', -1)
                noInt = true
                bs = raknetNewBitStream()
                raknetBitStreamWriteInt8(bs, 18)
                raknetSendRpc(118, bs)
                raknetDeleteBitStream(bs)
                bs = raknetNewBitStream()
                raknetBitStreamWriteInt8(bs, 18)
                raknetEmulRpcReceiveBitStream(156,bs)
                raknetDeleteBitStream(bs)
            end
        elseif not sampIsChatInputActive() then
            if noInt then
                sampAddChatMessage('send else', -1)
                noInt = false
                bs = raknetNewBitStream()
                raknetBitStreamWriteInt8(bs, 0)
                raknetSendRpc(118, bs)
                raknetDeleteBitStream(bs)
                bs = raknetNewBitStream()
                raknetBitStreamWriteInt8(bs, 0)
                raknetEmulRpcReceiveBitStream(156,bs)
                raknetDeleteBitStream(bs)
            end
        end
    end
end

function toggleScript()
    -- Parameters: UINT16 playerid, UINT32 color, float drawDistance, UINT32 expiretime, UINT8 textLength, char text[]
    bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, 77)
    raknetBitStreamWriteInt32(bs, 0xffffffff)
    raknetBitStreamWriteFloat(bs, 20.0)
    raknetBitStreamWriteInt32(bs, 2000)
    raknetBitStreamWriteInt8(bs, 6)
    raknetBitStreamWriteString(bs, "swswsw")
    raknetSendRpc(59, bs)
    raknetDeleteBitStream(bs)
    sampAddChatMessage('sendinu', -1)
end

-- function sampev.onSendInteriorChangeNotification(interior)
--     sampAddChatMessage("inter: "..interior, -1)

-- end

-- function sampev.onSetInterior(interior)
--     if noInt then return false end
--     sampAddChatMessage("SRW inter: "..interior, -1)
-- end

-- function sampev.onVehicleStreamIn(vehicleId, data)
--     data.addSiren = 1
--     return {vehicleId, data}
-- end

-- function sampev.onInitGame(playerId, hostName, settings, vehicleModels, vehicleFriendlyFire)
--     sampAddChatMessage('host: '..hostName, -1)
--     sampAddChatMessage('classesAvailable: '..settings.classesAvailable, -1)
--     sampAddChatMessage('globalChatRadius: '..settings.globalChatRadius, -1)
--     sampAddChatMessage('nametagDrawDist: '..settings.nametagDrawDist, -1)
--     sampAddChatMessage('normalOnfootSendrate: '..settings.normalOnfootSendrate, -1)
--     sampAddChatMessage('normalIncarSendrate: '..settings.normalIncarSendrate, -1)
--     sampAddChatMessage('normalFiringSendrate: '..settings.normalFiringSendrate, -1)
--     sampAddChatMessage('sendMultiplier: '..settings.sendMultiplier, -1)
--     sampAddChatMessage('lagCompMode: '..settings.lagCompMode, -1)
    
    
--     if vehicleFriendlyFire then sampAddChatMessage('galima', -1) else sampAddChatMessage('negalima', -1) end
--     settings.vehicleFriendlyFire = true
--     vehicleFriendlyFire = true
--     settings.limitGlobalChatRadius = false
--     return {playerId, hostName, settings, vehicleModels, vehicleFriendlyFire}
-- end