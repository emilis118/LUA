script_name("AUTO Ginklai")
script_version("1.0")

local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
-- local enable = true
local interiorCheck = false
local interiorCheck2 = false
local takeGun = false
local pzuCheck = true
local enter = false
local pickUpEdit = false
local togglePickup = false
local noCarMsg = true
local checkId = 0
local data = {}
local mainCfg = {
	settings = {
		enable = true,
		pickup = 0,
	},
	gun = {
		kiekis = 1,
	},
	ammo = {
		"150",
		"150",
		"150",
		"150",
		"150"
	},
	kuris = {
		"1",
		"2",
		"3",
		"4",
		"5"
	}
}

-------------------------------------------------------------------------

function main()
	repeat wait(0)
	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//AutoSpinta//settings.ini") then
		sampAddChatMessage("irasau", 0xffffff)
		iniBool = inicfg.save(mainCfg, "AutoSpinta/settings")
	end
	data = inicfg.load(mainCfg, "AutoSpinta/settings")
	--name = nameLock()
	--unlockScript(name)
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("gun")
		if not cmdResult then
			local result = sampRegisterChatCommand("gun", toggleScript)
		end
		if interiorCheck and pzuCheck then
			interiorCheck = false
			interiorCheck2 = false
			takeGun = true
		end
		if takeGun and data.settings.enable then
			takeGun = false
			for i = 1, data.gun.kiekis do
				for j = 1, 5 do
					if i == data.kuris[j] then
						wait(200)
						sendCmd("/isimti ginkla"..j.." "..data.ammo[j])
						noCarMsg = false
						togglePickup = false
					end
				end
			end
		end
		if togglePickup and checkId >= 150 and noCarMsg then
			togglePickup = false
			checkId = 0
			noCarMsg = true
			sampAddChatMessage("[AUTO Ginklai] {ff0000}Pastatykit automobili arciau namo pickupo!", 0x1cd031)
		end
		if togglePickup and checkId < 150 then
			pickupas(data.settings.pickup)
			checkId = checkId + 1
		end
		--if data.gun.kiekis ~= nil then sampAddChatMessage(data.gun.ammo1, 0xffffff) end
	end
end

-------------------------------------------------------------------------

function toggleScript(arg)
	if #arg == 0 then
		data.settings.enable = not data.settings.enable
		if data.settings.enable then
			sampAddChatMessage("[AUTO Ginklai] {34eb37}Ijungtas. {b88d0f}Isjungti su /gun.", 0x1cd031)
		else
			sampAddChatMessage("[AUTO Ginklai] {eb3434}Isjungtas. {b88d0f}Ijungti su /gun.", 0x1cd031)
		end
	end
	if arg == "info" then
		sampAddChatMessage("----------------------------------------------------------------", 0x1cd031)
		sampAddChatMessage("[AUTO Ginklai] Norint ijungti ar isjungti: {b88d0f}/gun.", 0x1cd031)
		sampAddChatMessage("[AUTO Ginklai] Norint nustatyti kiek ginklu paimti: {b88d0f}/gun [1-5].", 0x1cd031)
		sampAddChatMessage("[AUTO Ginklai] Norint nustatyti ginklu eiliskuma (pagal /spinta): {b88d0f}/gun order(1-5) [1-5].", 0x1cd031)
		sampAddChatMessage("[AUTO Ginklai] Norint nustatyti kiek kulku paimti: {b88d0f}/gun ammo(1-5) [1-10000].", 0x1cd031)
		sampAddChatMessage("----------------------------------------------------------------", 0x1cd031)
	end
	for i = 1, 5 do
		if arg == tostring(i) then
			data.gun.kiekis = tonumber(arg)
			sampAddChatMessage("[AUTO Ginklai] Kiek skirtingu ginklu bus paimta: "..data.gun.kiekis, 0x1cd031)
		end
		for j = 1, 5 do
			if arg == "order"..tostring(i).." "..tostring(j) then
				data.kuris[i] = j
				sampAddChatMessage("[AUTO Ginklai] Eiliskumas: "..i.." ginklas bus paimtas "..j.."-as.", 0x1cd031)
			end
		end
	end
	if string.find(arg, "ammo%d %d+") then
		local ammoNumber = string.match(arg, "%d")
		local ammoCapacity = string.match(arg, " %d+")
		local ammoCapacity = string.match(ammoCapacity, "%d+")
		for i = 1, 5 do
			if tonumber(ammoNumber) == i then
				data.ammo[i] = ammoCapacity
				sampAddChatMessage("[AUTO Ginklai] "..i.." ginklas bus paimtas su "..data.ammo[i].." soviniu.", 0x1cd031)
			end
		end
	end
	if arg == "eile" then
		local checkas1 = 100
		local checkas2 = 200
		sampAddChatMessage("Ginklu eiliskumas: ", 0x1cd031)
		for i = 1, #data.kuris do
			sampAddChatMessage("Numeris "..i.." bus paimtas "..data.kuris[i].."-as", 0x1cd031)
		end
		for i = 1, #data.kuris do
			for j = 1, #data.kuris do
				if i ~= j and data.kuris[i] == data.kuris[j] and checkas1 == 100 and checkas2 == 200 then
					sampAddChatMessage("{ff0000}Svarbu: {1cd031}pastebeta, kad ginklas "..i.." ir ginklas "..j.." sutampa eiliskumu. {ff0000}Programa gali veikti neteisingai.", 0x1cd031)
					checkas1 = i
					checkas2 = j
				elseif checkas1 >= 1 and checkas1 <= 5 and checkas2 >= 1 and checkas2 <= 5 then
					if checkas1 == j and checkas2 == i then checkas1 = 100 checkas2 = 200 end
				end
			end
		end
	end
	if arg == "pickup" then
		sampAddChatMessage("[AUTO Ginklai] Kitas uzliptas pickup taps nustatytu pickup", 0x1cd031)
		pickUpEdit = true
	end
	writeSetting(true)
end

-------------------------------------------------------------------------

function sampev.onSendInteriorChangeNotification(interior)
	if not data.settings.enable then return end
	if interior ~= 0 then interiorCheck = true interiorCheck2 = true end
end

-------------------------------------------------------------------------

function sendCmd(cmd)
	sampSendChat(cmd)
end

-------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
	if not enable then return end
	if interiorCheck2 and pzuCheck and string.find(text, "Tokios komandos n") then enter = true end
	interiorCheck2 = false
	if enter then
		enter = false
		sampAddChatMessage("[AUTO Ginklai] Neturite namo rakto ar leidimo naudotis spinta.", 0xff0000)
		return false
	end
end

-------------------------------------------------------------------------

function sampev.onTogglePlayerSpectating(state)
	if state then pzuCheck = false else pzuCheck = true end
end

-------------------------------------------------------------------------

function writeSetting(msgBool)
	patvirtinimas = inicfg.save(data, "AutoSpinta/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[AUTO Ginklai] Nustatymai irasyti.", 0x1cd031) end
end

-------------------------------------------------------------------------
--[[
function nameLock()
	local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local name = sampGetPlayerNickname(id)
	writeSetting(false)
	return name
end
]]
-------------------------------------------------------------------------
--[[
function unlockScript(nick)
	local loadint = false
	local scr = thisScript()
	local allow = {
		"Marius_Greendeath",
	}
	for i = 1, #allow do
		if nick == allow[i] then loadint = true end
	end
	if not loadint then sampAddChatMessage("Draudziamas nick", 0xffffff) scr:unload() end
end
]]
-------------------------------------------------------------------------

function sampev.onSendPickedUpPickup(pickupId)
	if pickUpEdit then
		data.settings.pickup = pickupId
		writeSetting(true)
	end
end

-------------------------------------------------------------------------

function sampev.onSendCommand(cmd)
	if string.find(cmd, "tpm") then
		if data.settings.enable then
			togglePickup = true
			checkId = 0
		end
	end
end

-------------------------------------------------------------------------

function pickupas(pickId)
	sampSendPickedUpPickup(pickId)
end
