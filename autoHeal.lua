script_name("autoHeal")
script_description("/autoheal - ijungia/isjungia, /autoheal [1-1000] nuo kiek zaidejo/masinos hp")
script_author("EA")

local toggle = false
local toggle2 = false
local toggleHeal = false
local vairuotojas = false
require "lib.sampfuncs"
require "lib.moonloader"
local sampev = require 'lib.samp.events'
local setCarHealth = 900.0
local setPedHealth = 90.0
local gydomasId = 0
local vairuotojoId = 0

function main()
	repeat wait (0)
	until isSampLoaded()
	repeat wait (0)
	until isSampfuncsLoaded() 				--a
	while true do
		local randomiser = math.random(1000, 3000)
		local randomiserMini = math.random(500, 1400)
		wait(0)
		local cmdResult = sampIsChatCommandDefined("autoheal")
		if cmdResult then wait(0) else
			local result = sampRegisterChatCommand("autoheal", toggleFunc)
		end
		local carResult = isCharInAnyCar(PLAYER_PED)
		if toggle then
			local spawnResult = sampIsLocalPlayerSpawned()
			if spawnResult and carResult then
				local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
				local car = getCarCharIsUsing(PLAYER_PED)
				local carHealth = getCarHealth(car)
				if carHealth < setCarHealth then
					wait(randomiser)
					sampSendChat("/gydyti")
				end
			elseif spawnResult then
				local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
				local health = sampGetPlayerHealth(id)
				if setPedHealth > health then
					wait(randomiser)
					sampSendChat("/gydyti")
				end
			end --elfs
		end
	end
end

function toggleFunc(arg)
	local input = tonumber(arg)
	if #arg == 0 then
		toggle = not toggle
		if toggle then
			sampAddChatMessage("[AUTOHEAL] Ijungtas. Nustatyti gyvybes: /autoheal [1-1000]", 0xFFFFFF)
		elseif toggle == false then
			sampAddChatMessage("[AUTOHEAL] Isjungtas.", 0xFFFFFF)
		end
	elseif input <= 0 then
		sampAddChatMessage("[AUTOHEAL] Norint nustatyti gydymo skaiciu veskite /autoheal [1-100] arba [101-1000] (automobiliui).", 0xFFFFFF)
		toggle = false
	elseif input > 0 and input <= 100 then
		setPedHealth = input + .0
		sampAddChatMessage("[AUTOHEAL] Nustatytas zaidejo pagydymas, kai gyvybes zemiau: "..arg, 0xFFFFFF)
		toggle = true
	elseif input > 100 and input <= 1000 then
		setCarHealth = input + .0
		sampAddChatMessage("[AUTOHEAL] Nustatytas automobilio pagydymas, kai gyvybes zemiau: "..arg, 0xFFFFFF)
		toggle = true
	end
end

function togglePassHealer()
	toggle2 = not toggle2
	if toggle2 then
		sampAddChatMessage("[AUTOHEAL] Ijungtas. Dabar bus pagydomi keleiviai, kai ju hp nukris zemiau nustatytu hp (same kaip sau)", 0xFFFFFF)
	elseif toggle2 == false then
		sampAddChatMessage("[AUTOHEAL] Keleiviu healinimas isjungtas.", 0xFFFFFF)
	end
end

function sampev.onPassengerSync(playerId, data)
	local carResult = isCharInAnyCar(PLAYER_PED)
	if toggle2 and carResult then
		local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		local carId = data.vehicleId
		gydomasId = playerId
		--sampAddChatMessage("rastas carID: "..carId, 0xFF0000)
		if playerId ~= id and carId == playerCarId then
			local health = data.health
			if health < setPedHealth then
				toggleHeal = true
			end
		end
	end
end

function sampev.onVehicleSync(playerId, vehicleId, data)
	if vehicleId == playerCarId and playerId ~= myId then
		vairuotojoId = playerId
	end
end
