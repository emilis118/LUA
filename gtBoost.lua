script_name("GT Boost")


local sampev = require 'lib.samp.events'
local raknet = require 'lib.samp.raknet'
local memory = require 'memory'
local ffi = require 'ffi'
local vk = require "lib.vkeys"
local toggle = false
local toggleWarn = false
local handle = 0
local X = 0.0
local Y = 0.0
local Z = 0.0
local multiplier = 1.05 -- default
local limiter = 2.495 -- default

----------------------------------------------------------------------------

function main()
	repeat wait(0)
	until isSampAvailable()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("gts")
		if not cmdResult then
			local result = sampRegisterChatCommand("gts", setScript)
		end
		if toggle then
			getCar()
			if isKeyDown(vk.VK_W) then
				repeat
					wait(50)
					X, Y, Z = getVehicleMoveSpeed(handle)
					local greitis = math.sqrt(X^2 + Y^2 + Z^2)
					--sampAddChatMessage(greitis, 0xffffff)
					if greitis <= limiter then
						local newX = X * multiplier
						local newY = Y * multiplier
						setVehicleMoveSpeed(handle, newX, newY, Z)
					else
						setVehicleMoveSpeed(handle, X, Y, Z)
						--1.073 = 215km/h
						-- x = 500 km/h
					end
				until wasKeyReleased(vk.VK_W)
			end
			if isKeyDown(vk.VK_S) then
				repeat
					wait(50)
					X, Y, Z = getVehicleMoveSpeed(handle)
					local newX = X * 0.9
					local newY = Y * 0.9
					setVehicleMoveSpeed(handle, newX, newY, Z)
				until wasKeyReleased(vk.VK_S)
			end
		end
	end
end

----------------------------------------------------------------------------

function sampev.onTextDrawSetString(id, text)
	if id == 2048 and string.find(text, "~r~GT~n~") then
		if toggleWarn == false then
			toggle = true
			toggleWarn = true
			--sampAddChatMessage("[GT Boost] Aptikome GT, boost ijungtas.", 0xffffff)
		end
	elseif id == 2048 and not string.find(text, "~r~GT~n~") then
		if toggleWarn == true then
			toggle = false
			toggleWarn = false
			--sampAddChatMessage("[GT Boost] Neradome GT, boost {ff0000}isjungtas.", 0xffffff)
		end
	end
end

----------------------------------------------------------------------------

function getCar()
	local result = isCharInAnyCar(PLAYER_PED)
	if result then
		local car = storeCarCharIsInNoSave(PLAYER_PED)
		handle = car
		local modelId = getCarModel(car)
	end
end

----------------------------------------------------------------------------

function setVehicleMoveSpeed(handle, x, y, z)
	local ptr = getCarPointer(handle)
	if ptr ~= 0 then
		ffi.cast("void (__thiscall *)(uint32_t, float, float, float)", 0x441130)(ptr, x, y, z)
	end
end

----------------------------------------------------------------------------

function getVehicleMoveSpeed(handle)
	local ptr = getCarPointer(handle)
	if ptr ~= 0 then
		local X = memory.getfloat(ptr + 0x44, true)
		local Y = memory.getfloat(ptr + 0x44 + 0x4, true)
		local Z = memory.getfloat(ptr + 0x44 + 0x8, true)
		return X, Y, Z
	end
end
----------------------------------------------------------------------------

function sampev.onSetVehicleVelocity(turn, velocity)
	if toggle then
		return false
	end
end
----------------------------------------------------------------------------

function setScript(arg)
	if #arg == 0 then
		if multiplier == 1.05 and limiter == 2.495 then
			sampAddChatMessage("[GT Boost] Nustatyti max greiti: /gts [200-800]", 0xffffff)
			sampAddChatMessage("[GT Boost] Nustatyti isibegejima: /gts [1-10]", 0xffffff)
		else
			sampAddChatMessage("[GT Boost] Grazinti originalus nustatymai", 0xffffff)
			multiplier = 1.05
			limiter = 2.495
		end
	end
	for i = 1, 9 do
		if arg == tostring(i) then
			sampAddChatMessage("[GT Boost] Nustatytas isibegejimas: {ff0000}"..tostring(i), 0xffffff)
			local multiplierStr = "1.0"..tostring(i)
			multiplier = tonumber(multiplierStr)
		end
	end
	if #arg == 3 then
		local speed = tonumber(arg)
		limiter = speed * 1.073 / 215
		sampAddChatMessage("[GT Boost] Nustatytas max greitis: {ff0000}"..arg, 0xffffff)
	end
end

----------------------------------------------------------------------------
