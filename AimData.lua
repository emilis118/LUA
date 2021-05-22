script_name('AimData')
script_description('/aimdata <ID> seka zmogaus kamera')
script_version_number(1)
script_version('v.001')
script_authors('Emilis')

require 'lib.sampfuncs'
require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local memory = require 'memory'
local vk = require 'lib.vkeys'
local toggle = false -- isjungimas V + H
local id = 0
local kintamX = 0.0 -- pastumia taikinuka X
local kintamY = 0.0 -- pastumia taikinuka Y

function main()
    repeat
        wait(0)
    until isSampAvailable()
    --
    --[[
	dialog = dxutCreateDialog("info")
	dxutSetDialogPos(dialog, 1300, 300, 300, 500)
	local result = dxutIsDialogVisible(dialog)
	local resultExists = dxutIsDialogExists(dialog)
	dxutAddStatic(dialog, 1, "playerCamMode: ", 30, 20, 80, 20)
	dxutAddStatic(dialog, 2, "", 130, 20, 120, 20)
	dxutAddStatic(dialog, 3, "aimX: ", 30, 40, 80, 20)
	dxutAddStatic(dialog, 4, "", 130, 40, 120, 20)
	dxutAddStatic(dialog, 5, "aimY: ", 30, 60, 80, 20)
	dxutAddStatic(dialog, 6, "", 130, 60, 120, 20)
	dxutAddStatic(dialog, 7, "aimZ: ", 30, 80, 80, 20)
	dxutAddStatic(dialog, 8, "", 130, 80, 120, 20)
	dxutAddStatic(dialog, 9, "camPosX: ", 30, 100, 80, 20)
	dxutAddStatic(dialog, 10, "", 130, 100, 120, 20)
	dxutAddStatic(dialog, 11, "camPosY: ", 30, 120, 80, 20)
	dxutAddStatic(dialog, 12, "", 130, 120, 120, 20)
	dxutAddStatic(dialog, 13, "camPosZ: ", 30, 140, 80, 20)
	dxutAddStatic(dialog, 14, "", 130, 140, 120, 20)
	dxutAddStatic(dialog, 15, "fAimZ: ", 30, 160, 80, 20)
	dxutAddStatic(dialog, 16, "", 130, 160, 120, 20)
	dxutAddStatic(dialog, 17, "camExtZoom: ", 30, 180, 80, 20)
	dxutAddStatic(dialog, 18, "", 130, 180, 120, 20)
	dxutAddStatic(dialog, 19, "weaponState: ", 30, 200, 80, 20)
	dxutAddStatic(dialog, 20, "", 130, 200, 120, 20)
	dxutAddStatic(dialog, 21, "unknown: ", 30, 220, 80, 20)
	dxutAddStatic(dialog, 22, "", 130, 220, 120, 20)
	dxutAddStatic(dialog, 23, "targetType: ", 30, 240, 80, 20)
	dxutAddStatic(dialog, 24, "", 130, 240, 120, 20)
	dxutAddStatic(dialog, 25, "targetId: ", 30, 260, 80, 20)
	dxutAddStatic(dialog, 26, "", 130, 260, 120, 20)
	dxutAddStatic(dialog, 27, "bulletOriginX: ", 30, 280, 80, 20)
	dxutAddStatic(dialog, 28, "", 130, 280, 120, 20)
	dxutAddStatic(dialog, 29, "bulletOriginY: ", 30, 300, 80, 20)
	dxutAddStatic(dialog, 30, "", 130, 300, 120, 20)
	dxutAddStatic(dialog, 31, "bulletOriginZ: ", 30, 320, 80, 20)
	dxutAddStatic(dialog, 32, "", 130, 320, 120, 20)
	dxutAddStatic(dialog, 33, "bulletTargetX: ", 30, 340, 80, 20)
	dxutAddStatic(dialog, 34, "", 130, 340, 120, 20)
	dxutAddStatic(dialog, 35, "bulletTargetY: ", 30, 360, 80, 20)
	dxutAddStatic(dialog, 36, "", 130, 360, 120, 20)
	dxutAddStatic(dialog, 37, "bulletTargetZ: ", 30, 380, 80, 20)
	dxutAddStatic(dialog, 38, "", 130, 380, 120, 20)
	dxutAddStatic(dialog, 39, "bulletCenterX: ", 30, 400, 80, 20)
	dxutAddStatic(dialog, 40, "", 130, 400, 120, 20)
	dxutAddStatic(dialog, 41, "bulletCenterY: ", 30, 420, 80, 20)
	dxutAddStatic(dialog, 42, "", 130, 420, 120, 20)
	dxutAddStatic(dialog, 43, "bulletCenterZ: ", 30, 440, 80, 20)
	dxutAddStatic(dialog, 44, "", 130, 440, 120, 20)
	dxutAddStatic(dialog, 45, "weaponId: ", 30, 460, 80, 20)
	dxutAddStatic(dialog, 46, "", 130, 460, 120, 20)

	if not result and resultExists then
	dxutSetDialogVisible(dialog, true)
end

]]
    readScreenRes()
    while true do
        wait(0)
        if not sampIsChatCommandDefined('aim') then
            local result = sampRegisterChatCommand('aim', getId) -- nustatyti
        end

        -- if toggle then
        --     -- setAim()
        --     drawLine()
        -- end
        if isKeyDown(vk.VK_RCONTROL) and wasKeyPressed(vk.VK_O) then
            sampAddChatMessage('Stebejimas {ff0000}nutrauktas{ffffff}.', 0xFFFFFF)
            toggle = false
        end
    end
end

function getId(arg)
    if #arg == 0 then
        sampAddChatMessage("Komandos 'aim' sintakse: /aim [ID]", 0xFFFFFF)
    else
        id = tonumber(arg)
        local name = sampGetPlayerNickname(id)
        sampAddChatMessage('Stebimas zaidejas: ' .. name .. ' ID: ' .. id, 0xFFFFFF)
        toggle = true
    end
end

-- function setAim()
--     --pointCameraAtChar(id, 53, 2)

--     --setCameraPositionUnfixed(aimZ, angleZ)
--     local rotX = 0.0
--     local rotY = 0.0
--     local rotZ = 0.0
--     if camPosX ~= nil then
--         printString('px', 100)
--     end
--     memory.setfloat(0xB6F258, angleZ, true) -- nustato kameros pasisukima (X)
--     memory.setfloat(0xB6F248, aimZ, true) -- nustato kameros pasisukima (Z)

--     local myAimData = allocateMemory(31)
--     local result, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
--     sampStorePlayerAimData(myId, myAimData)
--     local myAimX = getStructFloatElement(myAimData, 1, false)
--     local myAimY = getStructFloatElement(myAimData, 5, false)
--     local myAimZ = getStructFloatElement(myAimData, 9, false)
--      --
--     --[[
-- 	if aimZ ~= nil and myAimZ ~= nil and aimX ~= nil and aimY ~= nil then
-- 	local skirtumasCamX = math.abs(myAimX) - math.abs(aimX)
-- 	local skirtumasCamY = math.abs(myAimY) - math.abs(aimY)
-- 	myAngleZ = math.atan2(skirtumasCamY, skirtumasCamX) -- 9@
-- 	local skirtumasCamZ = math.abs(myAimZ) - math.abs(aimZ)
-- 	--setCameraPositionUnfixed(aimZ + skirtumasCamZ, angleZ + myAngleZ)
-- 	--sampAddChatMessage("skir: "..skirtumasCamX.." Y: "..skirtumasCamY.." Z: "..skirtumasCamZ, 0xFFFFFF)
-- end
-- ]]
-- freeMemory(myAimData)
--     --pointCameraAtChar(id, 53, 2)
--     --setCameraPositionUnfixed(aimZ, angleZ)				-- +pi = rytai -pi = vakarai -pi/2 = siaure +pi/2 pietus
--     --setFixedCameraPosition(positionX, positionY, positionZ, rotationX, rotationY, rotationZ)
--     --dxutDeleteDialog(dialog)
-- end

function sampev.onAimSync(playerId, data)
    if playerId == id and toggle then
        local cFront = {
            x = 0.0,
            y = 0.0,
            z = 0.0
        }
        local cPos = {
            x = 0.0,
            y = 0.0,
            z = 0.0
        }
        playerCamMode = data.camMode
        if playerCamMode ~= nil then
            writeMemory(0xB70140, 1, playerCamMode, false)
            writeMemory(0x8CC388, 1, playerCamMode, false)
            writeMemory(0xB6F1A8, 1, playerCamMode, false)
        end
        cFront.x = data.camFront.x
        cFront.y = data.camFront.y
        cFront.z = data.camFront.z
        local result, posX, posY, posZ = sampGetStreamedOutPlayerPos(playerId)
        cPos.x = data.camPos.x
        cPos.y = data.camPos.y
        cPos.z = data.camPos.z
        dX = -cFront.x * (cPos.x - posX)
        dY = -cFront.y * (cPos.y - posY)
        dZ = -cFront.z * (cPos.z - posZ)

        printString('px', 100)
		bs = raknetNewBitStream()
        raknetBitStreamWriteFloat(bs, -2 * dX)
        raknetBitStreamWriteFloat(bs, -2 * dY)
        raknetBitStreamWriteFloat(bs, dZ)
        raknetBitStreamWriteInt8(bs, 2)
        raknetEmulRpcReceiveBitStream(158, bs)
        raknetDeleteBitStream(bs)
        bs = raknetNewBitStream()
        raknetBitStreamWriteFloat(bs, cPos.x)
        raknetBitStreamWriteFloat(bs, cPos.y)
        raknetBitStreamWriteFloat(bs, cPos.z)
        raknetEmulRpcReceiveBitStream(157, bs)
        raknetDeleteBitStream(bs)
        
        if aimY ~= nil and aimX ~= nil then
            angleZ = math.atan2(aimY, aimX) -- 9@
            if angleZ >= 0.0 then
                angleZ = angleZ - math.pi
            else
                angleZ = angleZ + math.pi
            end
        end
        -- setCameraPositionUnfixed(aimZ, angleZ)
        fAimZ = data.aimZ
        camExtZoom = data.camExtZoom
        weaponState = data.weaponState
    --unknown = data.unknown
    -- Lenteles info:
    --[[
		dxutSetControlText(dialog, 2 , playerCamMode)
		dxutSetControlText(dialog, 4 , aimX)
		dxutSetControlText(dialog, 6 , aimY)
		dxutSetControlText(dialog, 8 , aimZ)
		dxutSetControlText(dialog, 10 , camPosX)
		dxutSetControlText(dialog, 12 , camPosY)
		dxutSetControlText(dialog, 14 , camPosZ)
		dxutSetControlText(dialog, 16 , fAimZ)
		dxutSetControlText(dialog, 18 , camExtZoom)
		dxutSetControlText(dialog, 20 , weaponState)
		dxutSetControlText(dialog, 22 , unknown)
		]]
    --
	async
    end
end

function sampev.onSendAimSync(data)
    printString(
        string.format(
            'Front: X: %.4f Y: %.4f Z: %.4f X: %.4f Y: %.4f Z: %.4f',
            data.camFront.x,
            data.camFront.y,
            data.camFront.z,
            data.camPos.x,
            data.camPos.y,
            data.camPos.z
        ),
        400
    )
end

function sampev.onBulletSync(playerId, data)
    if playerId == id and toggle then
        targetType = data.targetType
        targetId = data.targetId
        bulletOriginX = data.origin.x -- nebe local
        bulletOriginY = data.origin.y
        bulletOriginZ = data.origin.z
        bulletTargetX = data.target.x
        bulletTargetY = data.target.y
        bulletTargetZ = data.target.z
        bulletCenterX = data.center.x
        bulletCenterY = data.center.y
        bulletCenterZ = data.center.z
        weaponId = data.weaponId

    --[[
		dxutSetControlText(dialog, 24 , targetType)
		dxutSetControlText(dialog, 26 , targetId)
		dxutSetControlText(dialog, 28 , bulletOriginX)
		dxutSetControlText(dialog, 30 , bulletOriginY)
		dxutSetControlText(dialog, 32 , bulletOriginZ)
		dxutSetControlText(dialog, 34 , bulletTargetX)
		dxutSetControlText(dialog, 36 , bulletTargetY)
		dxutSetControlText(dialog, 38 , bulletTargetZ)
		dxutSetControlText(dialog, 40 , bulletCenterX)
		dxutSetControlText(dialog, 42 , bulletCenterY)
		dxutSetControlText(dialog, 44 , bulletCenterZ)
		dxutSetControlText(dialog, 46 , weaponId)
		--renderDrawLineBy3dCoords(bulletOriginX, bulletOriginY, bulletOriginZ, bulletTargetX, bulletTargetY, bulletTargetZ, 2, 0xFF0000)

		]]
    --
    end
end
--
--[[
function renderDrawLineBy3dCoords(posX, posY, posZ, posX2, posY2, posZ2, width, color)
local SposX, SposY = convert3DCoordsToScreen(posX, posY, posZ)
local SposX2, SposY2 = convert3DCoordsToScreen(posX2, posY2, posZ2)
if isPointOnScreen(posX, posY, posZ, 1) and isPointOnScreen(posX2, posY2, posZ2, 1) then
renderDrawLine(SposX, SposY, SposX2, SposY2, width, color)
end
end
]] function readScreenRes()
    xScreen = readMemory(0xC9C040, 4, 0)
    yScreen = readMemory(0xC9C044, 4, 0)
    --sampAddChatMessage("X: " .. xScreen .. " Y: " .. yScreen, 0xFFFFFF)
    xScreen = xScreen + .0
    yScreen = yScreen + .0
    xScreen = xScreen * 0.53
    yScreen = yScreen * 0.4
    --sampAddChatMessage("X: " .. xScreen .. " Y: " .. yScreen, 0xFFFFFF)
end

function drawLine()
    renderDrawLine(
        xScreen - 11.0 + kintamX,
        yScreen + 0.5 + kintamY,
        xScreen + 13.0 + kintamX,
        yScreen + 0.5 + kintamY,
        2.0,
        0xFFD00000
    )
    renderDrawLine(
        xScreen + 3.0 + kintamX,
        yScreen - 10.0 + kintamY,
        xScreen + 3.0 + kintamX,
        yScreen + 12.0 + kintamY,
        2.0,
        0xFFD00000
    ) -- opaque red
    --wait ( 0 )  -- one frame delay
end
