local samem = require 'SAMemory'
local key   = require 'vkeys'

samem.require 'CPool' -- дефайн используемых структур
samem.require 'CVehicle'
samem.require 'CCamera'
samem.require 'CPlayerData'

-- теперь не надо приводить типы переменных в таблице библиотеки
-- local vehicle_pool = samem.cast('CPool **', samem.vehicle_pool)
--vecGameCamPos


function main()
    
    while true do
        if wasKeyPressed(key.VK_1) then
            local pool = samem.camera[0]

            if pool ~= samem.nullptr then -- проверка пула на доступность, нулевой индекс нужен для вызова эвента метатаблицы, который разыменует указатель
                -- sampAddChatMessage('veikia', -1)
                -- local camX = pool.vecGameCamPos.x
                for i = 1, 1000 do
                pool.vecGameCamPos.x = pool.vecGameCamPos.x + 5.0
                pool.mCameraMatrix.pos.x = pool.mCameraMatrix.pos.x + 5.0
                end
                -- pool.mCameraMatrix.pos.x = -pool.mCameraMatrix.pos.x
                -- sampAddChatMessage(pool.vecGameCamPos.x, -1)
                
                -- sampAddChatMessage(pool.vecAimingTargetCoors.x, -1)
                -- sampAddChatMessage(pool.mCameraMatrix.pos.x, -1)
                
                -- pool.fPedZoomBase = 1.5

            else
                print('Pool is unavailable.')
            end
        end
        if wasKeyPressed(key.VK_2) then
            sampAddChatMessage('darau' ,-1)
            X, Y, Z = getActiveCameraCoordinates()
            X = X + 0.1
            bs = raknetNewBitStream()
            raknetBitStreamWriteFloat(bs, X)
            raknetBitStreamWriteFloat(bs, Y)
            raknetBitStreamWriteFloat(bs, Z)
            raknetEmulRpcReceiveBitStream(157, bs)
            raknetDeleteBitStream(bs)
            bs = raknetNewBitStream()
            raknetBitStreamWriteFloat(bs, X)
            raknetBitStreamWriteFloat(bs, Y)
            raknetBitStreamWriteFloat(bs, Z)
            raknetBitStreamWriteInt8(bs, 2)
            raknetEmulRpcReceiveBitStream(158, bs)
            raknetDeleteBitStream(bs)
        end
        -- fSprintEnergy
        if wasKeyPressed(key.VK_BACK) then -- Backspace
            local veh = samem.player_vehicle[0]
            if veh ~= samem.nullptr then

                if veh.nVehicleClass == 6 then -- с поездом немного иначе
                    local train = samem.cast('CTrain *', veh)
                    train.fTrainSpeed = -train.fTrainSpeed -- просто инвертируем скорость, его, конечно, можно развернуть, но в сампе это не синхронизируется
                    return
                end

                local matrix = veh.pMatrix

                -- разворот на 180 градусов
                matrix.up = -matrix.up -- у 2d и 3d векторов перегружен оператор унарного минуса
                matrix.right = -matrix.right

                -- инверт вектора скорости
                veh.vMoveSpeed = -veh.vMoveSpeed
            end
        end
        -- if wasKeyPressed(key.VK_LBUTTON) then -- Backspace
        --     local veh = samem.player_vehicle[0]
        --     if veh ~= samem.nullptr then

        --         if veh.nVehicleClass == 6 then -- с поездом немного иначе
        --             local train = samem.cast('CTrain *', veh)
        --             train.fTrainSpeed = -train.fTrainSpeed -- просто инвертируем скорость, его, конечно, можно развернуть, но в сампе это не синхронизируется
        --             return
        --         end

        --         local matrix = veh.pMatrix

        --         -- разворот на 180 градусов
        --         matrix.up = -matrix.up -- у 2d и 3d векторов перегружен оператор унарного минуса
        --         matrix.right = -matrix.right

        --         -- инверт вектора скорости
        --         veh.vMoveSpeed = -veh.vMoveSpeed
        --     end
        -- end
        --nTimeForNextShot
        wait(0)
    end
end