script_name("Seed")
script_description("/aimdata <ID> seka zmogaus kamera")
script_version_number(1)
script_version("v.001")
script_authors("Emilis")

local sampev = require 'lib.samp.events'
local raknet = require 'lib.samp.raknet'
local io = require 'io'

function main()
	repeat wait(0)
	until isSampAvailable()
end
--[[
function onSendRpc(id, bitStream, priority, reliability, orderingChannel, shiftTs)
sampAddChatMessage("send: " .. id .. " " .. bitStream, 0xFFFFFF)
-- return process, id, bitStream, priority, reliability, orderingChannel, shiftTs
end]]--
--[[function onReceiveRpc(id, bitStream)
--if id == pzuPos or id == money or id == 20 or id == 34 or id == 69 or id == 158 then
sampAddChatMessage("receive: ".. id .. " " .. bitStream, 0xFFFFFF)
--end
-- return process, id, bitStream
end
]]--
--[[
function onReceivePacket(id, bitStream)
if id == 207 or id == 212 or id == 205 then
-- return process, id, bitStream
sampAddChatMessage(id .. "      " .. bitStream, 0xFFFFFF)
end
--return bitStream
end
]]--
--[[
function sampev.onTogglePlayerSpectating(state)
sampAddChatMessage("Toggle Player Spectating: "..state, 0xFFFFFF)
end
function sampev.onSpectatePlayer(playerId, camType) -- geras del /pzu atpazinimo
sampAddChatMessage("Spectate player: "..playerId.." camType: "..camType, 0xFFFFFF)
end
function sampev.onSpectateVehicle(vehicleId, camType) -- geras del /pzu atpazinimo, bet reik nustatyt vairuotoja stebima etc.
sampAddChatMessage("Spectate vehicle: "..vehicleId.." camType: "..camType, 0xFFFFFF)
end
function sampev.onClearPlayerAnimation(playerId)	-- ZR GERAS DEL AUTO TTT, bet gali rodyt neteisingai
sampAddChatMessage("Clear player animation: "..playerId.." ID.", 0xFFFFFF)
end

function sampev.onSetPlayerArmedWeapon(weaponId)
sampAddChatMessage("Set player armed weapon: "..weaponId.." ID.", 0xFFFFFF)
end

function sampev.onClientCheck(requestType, subject, offset, length)
	sampAddChatMessage("requestType: "..requestType, -1)
	sampAddChatMessage("subject: "..subject, -1)
	sampAddChatMessage("offset: "..offset, -1)
	sampAddChatMessage("length: "..length, -1)
end

function sampev.onInterpolateCamera(setPos, fromPos, destPos, time, mode)
sampAddChatMessage("Set pos T/F: "..setPos.." time: "..time.." mode: ".. mode, 0xFFFFFF)
sampAddChatMessage("Camera - from X: "..fromPos.x.." from Y: "..fromPos.y.." from Z: ".. fromPos.z, 0xFFFFFF)
sampAddChatMessage("Camera - dest X: "..destPos.x.." dest Y: "..destPos.y.." dest Z: ".. destPos.z, 0xFFFFFF)
end

function sampev.onSetPlayerTeam(playerId, teamId)
sampAddChatMessage("Set player team: "..playerId.." player. Team id: "..teamId, 0xFF0000)
end


function sampev.onSetCameraPosition(position)
sampAddChatMessage("Camera - pos X: "..position.x.." pos Y: "..position.y.." pos Z: ".. position.z, 0xFFFFFF)
end
function sampev.onPlayerDeath(playerId)
sampAddChatMessage("Player death: "..playerId.." ID.", 0xFFFFFF)
end
function sampev.onSendRconCommand(command)
sampAddChatMessage("Rcon cmd out: "..command, 0xFFFFFF)
end
]]--
--[[
function sampev.onSendStatsUpdate(money, drunkLevel)
	drunkLevel = drunkLevel + 200
--sampAddChatMessage("Money out: "..money.." drunkLevel: "..drunkLevel, 0xFFFFFF)
	return {money, drunkLevel}
end
]]
--[[
function sampev.onGivePlayerMoney(money)
money = 10000000
sampAddChatMessage("Money in: "..money, 0xFFFFFF)
return money
end
function sampev.onResetPlayerMoney()
sampAddChatMessage("Pinigu reset", 0xFFFFFF)
return false
end
]]
--
-- ANTI-ANT ETC PROTOTIPAS
--[[
function sampev.onTogglePlayerControllable(controllable)
return false
end ]]--
--[[
function sampev.onSetVehicleVelocity(turn, velocity)
--sampAddChatMessage("X: "..velocity.x.." Y: "..velocity.y.." Z: --"..velocity.z, 0xFFFFFF)
return false
end
function sampev.onSetPlayerVelocity(velocity)
sampAddChatMessage("X: "..velocity.x.." Y: "..velocity.y.." Z: --"..velocity.z, 0xFFFFFF)
return false
end
function sampev.onServerMessage(color, text)
if string.match(text, "savo noru") and string.match(text, "nuo policijos") then
sampAddChatMessage(text, color)
local vardas = text:match('%w+_%w+')
sampAddChatMessage(vardas, color)


--sampSendChat("/ban Mantino_Black 1 test")
takeScreen()
end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
sampAddChatMessage("matau lentele, style: "..style.." "..title.." "..button1.." "..button2.." "..text,0xFFFFFF)
local result, button, list, input = sampHasDialogRespond(dialogId)
sampAddChatMessage(list, 0xFFFFFF)
local result = sampIsDialogActive()
end

function takeScreen()
if isSampLoaded() then
require("ffi").cast("void (*__stdcall)()", sampGetBase() + 0x70FC0)()
end
end
]]--
--[[
function sampev.onApplyPlayerAnimation(playerId, animLib, animName, loop, lockX, lockY, freeze, time)
sampAddChatMessage("ID: "..playerId.." animLib: "..animLib.." animName: "..animName, 0xFFFFFF)
sampAddChatMessage(" time:"..time, 0xFFFFFF)
--if freeze then sampAddChatMessage("buvo uzfreezintas", 0xFFFFFF) else sampAddChatMessage("buvo nebe uzfreezintas", 0xFFFFFF) end
end
]]--

--[[
function sampev.onSetPlayerAttachedObject(playerId, index, create, object)
local objectas = object.modelId
local offsetX = object.offset.x
local offsetY = object.offset.y
local offsetZ = object.offset.z
local rotationX = object.rotation.x
local rotationY = object.rotation.y
local rotationZ = object.rotation.z
--sampAddChatMessage("id: "..playerId.." daikto ID: "..objectas, 0xFFFFFF)
local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
--sampAddChatMessage(id, 0xFFFFFF)
if playerId == id and objectas == 355 then
requestModel(19086)
loadAllModelsNow()
local createdObject = createObject (19086, offsetX, offsetY, offsetZ)
attachObjectToChar(createdObject, PLAYER_PED, offsetX+0.165, offsetY, offsetZ, 0.0, 25.0, 90.0) -- rotation: 0.0 25.0 90.0 = kaip birka

--sampAddChatMessage(rotationX.." "..rotationY.. " "..rotationZ, 0xFFFFFF)
create = false
return create
else
return false
end
end
]]
--[[

function sampev.onSendClientJoin(version, mod, nickname, challengeResponse, joinAuthKey, clientVer, unknown)
sampAddChatMessage(version, 0xFFFFFF)
sampAddChatMessage(mod, 0xFFFFFF)
sampAddChatMessage(nickname, 0xFFFFFF)
sampAddChatMessage(challengeResponse, 0xFFFFFF)
sampAddChatMessage(joinAuthKey, 0xFFFFFF)
sampAddChatMessage(clientVer, 0xFFFFFF)
sampAddChatMessage(unknown, 0xFFFFFF)
nickname = "Emilis_Debil"
return {version, mod, nickname, challengeResponse, joinAuthKey, clientVer, unknown}
end
]]
--[[
function sampev.onInitGame(handler.on_init_game_reader, handler.on_init_game_writer)
sampAddChatMessage(playerId, 0xFF0000)
sampAddChatMessage(hostName, 0xFF0000)
if settings.zoneNames then sampAddChatMessage("taip", 0xFF0000)
else sampAddChatMessage("ne", 0xFF0000)
end
sampAddChatMessage(settings.globalChatRadius, 0xFF0000)
sampAddChatMessage(settings.nametagDrawDist, 0xFF0000)
if settings.nametagLOS then sampAddChatMessage("taip", 0xFF0000)
else sampAddChatMessage("ne", 0xFF0000)
end
sampAddChatMessage(settings.classesAvailable, 0xFF0000)
sampAddChatMessage(settings.normalOnfootSendrate, 0xFF0000)
sampAddChatMessage(settings.normalIncarSendrate, 0xFF0000)
sampAddChatMessage(settings.normalFiringSendrate, 0xFF0000)
sampAddChatMessage(settings.sendMultiplier, 0xFF0000)
if settings.instagib then sampAddChatMessage("taip", 0xFF0000)
else sampAddChatMessage("ne", 0xFF0000)
end


end
]]
--[[ SITAS DELAY PADARO ANT CALLBACKU
function callback()
lua_thread.create(function ()
doFade(1000, true)
wait(3000) -- на 3 секунды гасим экран
doFade(1000, false)
end
end
]]
--[[
function sampev.onSendRconCommand(command)
sampAddChatMessage("rcn: "..command, 0xFFFFFF)
end
]]
--[[
function sampev.onPlayerStreamIn(playerId, team, model, position, rotation, color, fightingStyle)
sampAddChatMessage("[IN]playerID: "..playerId.." team: "..team.." model: "..model, 0xFFFFFF)
sampAddChatMessage("[IN]positionX: "..position.x.." positionY: "..position.y.." position: "..position.z.." rotation: "..rotation, 0xFFFFFF)

sampAddChatMessage("[IN]color: "..color.." fightingStyle: "..fightingStyle, 0xFFFFFF)
end
function sampev.onSendPlayerSync(data)
posX = data.position.x
posY = data.position.y
posZ = data.position.z
--sampAddChatMessage("X: "..posX.." Y: "..posY.." Z: "..posZ, 0xff0000)
end

function sampev.onPlayerStreamOut(playerId)
sampAddChatMessage("[OUT]playerID: "..playerId, 0xFF0000)
end ]]
--[[
function sampev.onTogglePlayerSpectating(state)
	if state then
		sampAddChatMessage("Ijunge spectate", 0xFFFFFF)
	else
		sampAddChatMessage("Isjunge spectate", 0xFFFFFF)
	end
	return false
end


function sampev.onSpectatePlayer(playerId, camType)
	sampAddChatMessage("ziuri i:"..playerId, 0xFFFFFF)
	return false
end


function sampev.onSpectateVehicle(vehicleId, camType)
	sampAddChatMessage("ziuri i:"..vehicleId, 0xFFFFFF)
	return false
end

function sampev.onSendSpectatorSync(data, empty_writer)
	if pzux ~= nil and pzuy ~= nil and pzuz ~= nil then
		data.position.x = pzux
		data.position.y = pzuy
		data.position.z = pzuz
	end
	--sampAddChatMessage("x: "..posX.." y: "..posY.." z: "..posZ, 0xFFFFFF)
end


function sampev.onAimSync(playerId, data)
	if playerId == 5 then
		pzux = data.camPos.x
		pzuy = data.camPos.y
		pzuz = data.camPos.z
		--sampAddChatMessage("x: "..pzux.." y: "..pzuy.." z: "..pzuz, 0xFFFFFF)
		--[[
		if myCharX ~=nil and myCharY ~= nil and myCharZ ~= nil then
		local a = pzux-myCharX
		local b = pzuy-myCharY
		local c = pzuz-myCharZ
		local d = math.sqrt(a^2+b^2+c^2)
		if d < 6.5 and d > 0.5 then
		sampAddChatMessage("[ANTI PZU] Mane stebi!! Zaidejas: "..playerId.." camDist: "..d, 0xFFFFFF)
		]] --[[
	end
end
--end
--end


function sampev.onSendPlayerSync(data, empty_writer)
	--myCharX = data.position.x
	--myCharY = data.position.y
	--myCharZ = data.position.z
	--sampAddChatMessage("x: "..posX.." y: "..posY.." z: "..posZ, 0xFFFFFF)
	--return false
end


function sampev.onSendAimSync(data, empty_writer)
	local myPosX = data.camPos.x
	local myPosY = data.camPos.y
	local myPosZ = data.camPos.z
	--sampAddChatMessage("x: "..myPosX.." y: "..myPosY.." z: "..myPosZ, 0xFFFFFF)
	if pzux ~= nil and pzuy ~= nil and pzuz ~= nil then
		data.camPos.x = pzux
		data.camPos.y = pzuy
		data.camPos.z = pzuz
		--local myPosX = data.camPos.x
		--local myPosY = data.camPos.y
		--local myPosZ = data.camPos.z
		--sampAddChatMessage("new x: "..myPosX.." y: "..myPosY.." z: "..myPosZ, 0xFFFFFF)
	end
end
]]
--[[
function sampev.onSendEnterVehicle(vehicleId, passenger)
	sampAddChatMessage("onSendEnterVehicle", 0xffffff)
end

function sampev.onSendClickPlayer()
	sampAddChatMessage("onSendClickPlayer", 0xffffff)
end

function sampev.onSendCommand()
	sampAddChatMessage("onSendCommand", 0xffffff)
end

function sampev.onSendClientJoin()
	sampAddChatMessage("onSendClientJoin", 0xffffff)
end
function sampev.onSendEnterEditObject()
	sampAddChatMessage("onSendEnterEditObject", 0xffffff)
end
function sampev.onSendSpawn()
	sampAddChatMessage("onSendSpawn", 0xffffff)
	return false
end
function sampev.onSendDeathNotification()
	sampAddChatMessage("onSendDeathNotification", 0xffffff)
end
function sampev.onSendDialogResponse()
	sampAddChatMessage("onSendDialogResponse", 0xffffff)
end
function sampev.onSendClickTextDraw()
	sampAddChatMessage("onSendClickTextDraw", 0xffffff)
end
function sampev.onSendVehicleTuningNotification()
	sampAddChatMessage("onSendVehicleTuningNotification", 0xffffff)
end
function sampev.onSendClientCheckResponse()
	sampAddChatMessage("onSendClientCheckResponse", 0xffffff)
end
function sampev.onSendVehicleDamaged()
	sampAddChatMessage("onSendVehicleDamaged", 0xffffff)
end
function sampev.onSendEditAttachedObject()
	sampAddChatMessage("onSendEditAttachedObject", 0xffffff)
end
function sampev.onSendEditObject()
	sampAddChatMessage("onSendEditObject", 0xffffff)
end
function sampev.onSendInteriorChangeNotification()
	sampAddChatMessage("onSendInteriorChangeNotification", 0xffffff)
end
function sampev.onSendMapMarker()
	sampAddChatMessage("onSendMapMarker", 0xffffff)
end
function sampev.onSendRequestClass()
	sampAddChatMessage("onSendRequestClass", 0xffffff)
end
function sampev.onSendRequestSpawn()
	sampAddChatMessage("onSendRequestSpawn", 0xffffff)
end
function sampev.onSendPickedUpPickup()
	sampAddChatMessage("onSendPickedUpPickup", 0xffffff)
end
function sampev.onSendMenuSelect()
	sampAddChatMessage("onSendMenuSelect", 0xffffff)
end
function sampev.onSendVehicleDestroyed()
	sampAddChatMessage("onSendVehicleDestroyed", 0xffffff)
end
function sampev.onSendQuitMenu()
	sampAddChatMessage("onSendQuitMenu", 0xffffff)
end
function sampev.onSendExitVehicle()
	sampAddChatMessage("onSendExitVehicle", 0xffffff)
end
function sampev.onSendUpdateScoresAndPings()
	sampAddChatMessage("onSendUpdateScoresAndPings", 0xffffff)
end
function sampev.onSendRconCommand()
	sampAddChatMessage("onSendRconCommand", 0xffffff)
end
]]
--[[
function sampev.onSendStatsUpdate()
	sampAddChatMessage("onSendStatsUpdate", 0xffffff)
end

function sampev.onSendPlayerSync()
	sampAddChatMessage("onSendPlayerSync", 0xffffff)
end
function sampev.onSendVehicleSync()
	sampAddChatMessage("onSendVehicleSync", 0xffffff)
end
function sampev.onSendPassengerSync()
	sampAddChatMessage("onSendPassengerSync", 0xffffff)
end
function sampev.onSendAimSync()
	sampAddChatMessage("onSendAimSync", 0xffffff)
end
function sampev.onSendUnoccupiedSync()
	sampAddChatMessage("onSendUnoccupiedSync", 0xffffff)
end
]]
--[[
function sampev.onSendTrailerSync()
	sampAddChatMessage("onSendTrailerSync", 0xffffff)
end
function sampev.onSendBulletSync()
	sampAddChatMessage("onSendBulletSync", 0xffffff)
end
function sampev.onSendSpectatorSync()
	sampAddChatMessage("onSendSpectatorSync", 0xffffff)
end
]]
--[[
function sampev.onRequestClassResponse(canSpawn, team, skin, unk, position, rotation, weapons, ammo)
	sampAddChatMessage("req class response", 0xffffff)
	sampAddChatMessage("skinas: "..skin, 0xffffff)
	sampAddChatMessage("poz:"..position.x.." Y: "..position.y.." Z: "..position.z, 0xff0000)
end

function sampev.onSendRequestClass(classId)
	sampAddChatMessage("send req class", 0xffffff)
	sampAddChatMessage("classid: "..classId, 0xffffff)
	--classId = 2
	--return {classId}
end

function sampev.onRequestSpawnResponse(response)
	if response then
		sampAddChatMessage("responce : taip", 0xffffff)
	else
		sampAddChatMessage("responce : ne", 0xffffff)
	end
end

function sampev.onSetPlayerSkin(playerId, skinId)
	sampAddChatMessage(playerId.." skinId: "..skinId, 0xffffff)
	skinId = 267
	return {skinId}
end

function sampev.onSendClickPlayer(playerId, source)
	sampAddChatMessage(playerId, " sorce: "..source, 0xffffff)
end
]]
--[[ GT IJUNGIMAS
function sampev.onTextDrawSetString(id, text)

	sampAddChatMessage("id: "..id.." txt: "..text, 0xffffff)
end
]]
