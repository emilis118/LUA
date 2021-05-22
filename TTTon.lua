script_name("TTTon")
script_description("ctrl+L on/off, ctrl+q/e -5/+5s, /iesk 100m prideda ieskoma")
script_version_number(1)
script_version("v.001")
script_authors("Emilis")

require "lib.sampfuncs"
require "lib.moonloader"

local vk = require "lib.vkeys"
local timeDefault = 120000
local isWritingOn = false
local timeToSendMsg = 0
local trueTime = 0
local result, id = 0
local name = "EML"
local betSize = 0



function main()
	repeat
		wait(0)
	until isSampAvailable()
	repeat
		wait(0)
	until sampIsLocalPlayerSpawned()
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	name = sampGetPlayerNickname(id)
	local cmdResult = sampRegisterChatCommand("iesk", setBetSize)
	while true do			-- main loop
		wait(0)

		toggleScript()
		timechange()
		writeText()
		--sampSendChat("[TTT] Tarpininkavimo paslaugos (1proc, 30m minimum pot) /sms")
	end
end

function writeText()
	if timeToSendMsg <= getGameTimer() and isWritingOn then
		timeToSendMsg = getGameTimer() + timeDefault
		if betSize ~= 0 then
			sampSendChat("/s [TTT] Tarpininkavimo paslaugos (1proc, 30m minimum pot) /sms " .. name .. " (" .. id .. ") " .. "[IESKOMA: " .. betSize .. "M]")
		else
			sampSendChat("/s [TTT] Tarpininkavimo paslaugos (1proc, 30m minimum pot) /sms " .. name .. " (" .. id .. ")")
		end
	end
end

function setBetSize(arg)
	if #arg ==  0  then
		sampAddChatMessage("Komandos 'iesk' sintakse: /iesk [suma]", 0xFFFFFF)
	else
		sampAddChatMessage("Ieskoma suma = " .. arg .. "M", 0xFFFFFF)
		betSize = tonumber(arg)
	end
end

function toggleScript()
	if isKeyDown(vk.VK_RCONTROL) and wasKeyPressed(vk.VK_L) then
		isWritingOn = not isWritingOn
		if isWritingOn then
			timeToSendMsg = 0
			sampAddChatMessage("Auto TTT skelbimas - {29b260}ON{FFFFFF}!", 0xFFFFFF)
		else
			sampAddChatMessage("Auto TTT skelbimas - {d6381b}OFF{FFFFFF}!", 0xFFFFFF)
		end
	end
end


function timechange()
	if isKeyDown(vk.VK_RCONTROL) and wasKeyPressed(vk.VK_E) then
		timeDefault = timeDefault + 5000
		sampAddChatMessage("Pridejau {29b260}5s{FFFFFF} Naujas pasikartojimo intervalas: {e6e722}" .. timeDefault/1000 .. "{FFFFFF}s", 0xFFFFFF)
	end
	if isKeyDown(vk.VK_RCONTROL) and wasKeyPressed(vk.VK_Q) and timeDefault>5001 then
		timeDefault = timeDefault - 5000
		sampAddChatMessage("Atemiau {FF0000}5s{FFFFFF} Naujas pasikartojimo intervalas: {e6e722}" .. timeDefault/1000 .. "{FFFFFF}s", 0xFFFFFF)
	end
end
