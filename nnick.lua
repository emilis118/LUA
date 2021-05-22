script_name("NickName")
script_version("1.0")
script_author("Emilis")
script_description("/nnick Vardas_Pavarde nick")

----------------------------------------------------------------------------

require "lib.sampfuncs"
require "lib.moonloader"
local sampev = require 'lib.samp.events'
local enable = true
local nameList = {}
local toggleRead = true
local hello = true
local edit = false
local cmdEdit = ""
local nickas = ""
local setCmd = {
	"/sms",
	"/to",
	"/get",
	"/xp",
	"/heal",
	"/info",
	"/pzu",
}

----------------------------------------------------------------------------

function main()
	repeat wait(0)
	until isSampLoaded()
	repeat wait(0)
	until isSampfuncsLoaded()
	wait(3000)
	hello()
	while true do
		wait(0)
		readIgnore()
		local cmdResult = sampIsChatCommandDefined("nnick")
		if not cmdResult then
			local result = sampRegisterChatCommand("nnick", command)
		end
	end
end

----------------------------------------------------------------------------

function hello()
	if hello then
		sampAddChatMessage("[NickName] Norint suzinoti komandas: {b88d0f}/nnick info", 0x3f9412)
	end
end

----------------------------------------------------------------------------

function command(arg)
	if #arg == 0 then
		enable = not enable
		if enable then
			sampAddChatMessage("{3f9412}[NNICK]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/nnick{3f9412}. Prideti zaideja: {b88d0f}/nnick Vardas_Pavarde nickas", 0x3f9412)
		else
			sampAddChatMessage("{3f9412}[NNICK]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/nnick{3f9412}. Prideti zaideja: {b88d0f}/nnick Vardas_Pavarde nickas", 0x3f9412)
		end
	end
	--<<<
	if arg == "info" then
		sampAddChatMessage("[NNICK] Ijungti/isjungti script: {b88d0f}/nnick", 0x3f9412)
		sampAddChatMessage("[NNICK] Prideti arba istrinti zaideja: {b88d0f}/nnick Vardas_Pavarde nickas", 0x3f9412)
		sampAddChatMessage("[NNICK] Paziureti kokie zaidejai sarase: {b88d0f}/nnick list", 0x3f9412)
	end
	--<<<
	if #arg ~= 0 and arg ~= "debug" and arg ~= "list" and arg ~= "info" then
		if string.find(arg, "%u%l+_%u%l+ %a+") then
			local writer = true
			for i = 1, #nameList do
				if nameList[i] == arg then
					sampAddChatMessage("{3f9412}[NNICK] Istrinamas zaidejas: {ff0000}"..arg, 0x3f9412)
					local player = arg
					deletePlayer(player)
					writer = false
					toggleRead = true
					readCfg = true
					-- nustraukia loop
					break
				end
			end
			if writer then
				sampAddChatMessage("{3f9412}[NNICK] Pridetas i nickname sarasa: {20fc03}"..arg..".", 0x3f9412)
				file = io.open(getGameDirectory().."//moonloader//config//nnick//nicknames.txt", "a")
				io.output(file)
				io.write(arg.."\n")
				io.close(file)
				toggleRead = true
				readCfg = true
			end
		else
			sampAddChatMessage("{3f9412}[NNICK]{20fc03} Norint ideti zaideja i sarasa: /nnick Vardas_Pavarde nick (tik raides)", 0x3f9412)
		end
	end
	--<<<
	if arg == "list" then
		sampAddChatMessage("{3f9412}[NNICK]{20fc03} Zaideju sarasas:", 0x3f9412)
		for i = 1, #nameList do
			sampAddChatMessage(i..". "..nameList[i], 0x3f9412)
		end
	end
end
--<<<
function deletePlayer(player)
	file = io.open(getGameDirectory().."//moonloader//config//nnick//nicknames.txt", "r")
	local lines = ""
	while(true) do
		local line = file:read("*line")
		if not line then break end
		if not string.find(line, player, 1) then --if string not found
			lines = lines .. line .. "\n"
		end
	end
	file:close()
	file = io.open(getGameDirectory().."//moonloader//config//nnick//nicknames.txt", "w+")
	file:write(lines)
	file:close()
end
--<<<

--<<<
--<<<
function readIgnore()
	if toggleRead then
		-- wipe
		nameList = {}
		-- nuskaito faila
		file = io.open(getGameDirectory().."//moonloader//config//nnick//nicknames.txt", "r")
		local j = 0
		for line in file:lines() do
			j = j + 1
			nameList[j] = line
		end
		j = 0
		io.close(file)
		-- isjungia failo skaityma
		toggleRead = false
	end
end
--<<<
function sampev.onSendCommand(cmd)
	if not enable then return end
	local newCmd = ""
	for i = 1, #nameList do
		nickas = string.match(nameList[i], " %a+")
		for j = 1, #setCmd do
			if nickas ~= nil and string.find(cmd, setCmd[j]..nickas) then
				edit = true
				cmdEdit = string.match(nameList[i], "%u%l+_%u%l+")
				cmdEdit = " "..cmdEdit
				break
			end
		end
		if edit then break end
	end
	if edit and cmdEdit ~= nil then
		edit = false
		newCmd = string.gsub(cmd, nickas, cmdEdit)
		return {newCmd}
	end
end
--<<<
