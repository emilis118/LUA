script_name("ChatId")
script_version("2.0")
script_author("Emilis")
script_description("default on, /chatid - toggle on/off")

-----------------------------------------------------------------------------

local sampev = require 'lib.samp.events'
--require "lib.sampfuncs"
require "lib.moonloader"
local checkEnd = {
	"%[%d+%]",
	": %(%d+%)",
	" %(%d+%)",
	"%(%d+%)",
	" %[P%] %(%d+%)",
	" %[N%] %(%d+%)",
}
local checkStart = {
	"Mod] ",
	"G.Mod] ",
	"AntiCheat] ",
	"%[",
}
local inicfg = require 'inicfg'
local iniData = {
	settings = {enable = true}}
local mainCfg = {
	settings = {enable = true}
}


-----------------------------------------------------------------------------

function main()
	repeat wait (0)
	until isSampLoaded()
	repeat wait (0)
	until isSampfuncsLoaded()
	if not doesFileExist(getGameDirectory().."//moonloader//config//chatId//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "chatId/settings")
	end
	iniData = inicfg.load(mainCfg, "chatId/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("chatid")
		if not cmdResult then
			local result = sampRegisterChatCommand("chatid", toggleFunc)
		end
	end
end

-----------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
	if iniData.settings.enable then
		enter = false
		if string.find(text, "%u%l+_%u%l+") then
			local playerName = {}
			for capture in string.gmatch(text, "%u%l+_%u%l+") do
				table.insert(playerName, capture)
			end

			for i = 1, #playerName do
				if playerName[i] then
					playerId = sampGetPlayerIdByNickname(playerName[i])
					local edit = true
					if edit and playerId ~= nil then
						for k = 1, #checkEnd do
							for n = 1, #checkStart do
								if string.find(text, checkStart[n]..playerName[i]) or string.find(text, playerName[i]..checkEnd[k]) then edit = false end
							end
						end
					end
					if edit and playerId ~= nil then
						text = string.gsub(text, playerName[i], playerName[i].."["..playerId.."]")
						enter = true
						edit = false
					end
				end
			end
		end
	end
	if enter then
		sampAddChatMessage(text, bit.rshift(color, 8))
		return false
	end
end

function sampGetPlayerIdByNickname(nick)
	local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if nick == sampGetPlayerNickname(id) then return id end
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == nick then return i end
	end
end

function toggleFunc()
	iniData.settings.enable = not iniData.settings.enable
	if iniData.settings.enable then
		sampAddChatMessage(ltu("{34eb37}[ChatID] ??jungtas. {cdeb34}I??jungti su /chatid."), 0x34eb74)
	else
		sampAddChatMessage(ltu("{eb3434}[ChatID] I??jungtas. {cdeb34}??jungti su /chatid."), 0x34eb74)
	end
	writeSetting(true)
end

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "chatId/settings")
	if patvirtinimas and msgBool then sampAddChatMessage(ltu("[Chat ID] Nustatymai ??ra??yti."), 0x1cd031) end
	--iniData = inicfg.load(nil, "chatId/settings") -- nlb gerai sitas
end

function ltu(text)
	local encoding = require 'encoding'
	encoding.default = 'cp1257'
	local u8 = encoding.UTF8
	local ltu = {
		"\xc4\x85",	--??
		"\xc4\x8d",
		"\xc4\x99",
		"\xc4\x97",
		"\xc4\xaf",
		"\xc5\xa1",
		"\xc5\xb3",
		"\xc5\xab",
		"\xc5\xbe",
		"\xc4\x84",
		"\xc4\x8c",
		"\xc4\x98",
		"\xc4\x96",
		"\xc4\xae",
		"\xc5\xa0",
		"\xc5\xb2",
		"\xc5\xaa",
		"\xc5\xbd",
	}
	--?????????????????? ??????????????????
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[1]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[2]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[3]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[4]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[5]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[6]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[7]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[8]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[9]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[10]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[11]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[12]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[13]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[14]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[15]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[16]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[17]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[18]) end
	text = u8:decode(text)
	return text
end 