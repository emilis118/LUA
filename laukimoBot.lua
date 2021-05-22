script_name ("pavadinimas")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {enable = true}
}
local data = {}
local mainJson = {}
local laukimoCheck = false
--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//laukimoBot//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "laukimoBot/settings")
	end
	iniData = inicfg.load(mainCfg, "laukimoBot/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("laukimas")
		if not cmdResult then
			local result = sampRegisterChatCommand("laukimas", toggleScript)
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    iniData.settings.enable = not iniData.settings.enable
    if iniData.settings.enable then
        sampAddChatMessage(ltu("[Laukimo BOT] {16f534}Įjungtas."), 0x1cd031)
    else
        sampAddChatMessage(ltu("[Laukimo BOT] {ff0000}Išjungtas."), 0x1cd031)
    end
    writeSetting(false)
end

--------------------------------------------------------------------------------
-- Ini failo apdirbimas

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "laukimoBot/settings")
	if patvirtinimas and msgBool then sampAddChatMessage(ltu("[Laukimo BOT] Nustatymai įrašyti."), 0x1cd031) end
	--iniData = inicfg.load(nil, "laukimoBot/settings") -- nlb gerai sitas
end

--------------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
    if string.find(text, "/laukti %u%l+_%u%l+ ") --[[ and color == 0xffff01  ]]then
        sampSendChat(text)
        laukimoCheck = true
        -- panaudojimas
        -- nusiust i dc laukimo confirma
    end
    if --[[ laukimoCheck and  ]]string.find(text, "Tokio jau lauki") then
        local sendText = ltu("Klaida. Žaidėjas jau laukiamas.")
        sendDiscord(false, "Laukimo BOT", "https://discord.com/api/webhooks/811218614714761216/3ULm28B-k_n4ElCjaej6WTWbR8_SC1zMTQPpRflsQtP5UlhaXlOvbd578sKWW1fP6R9t", sendText)
    end
    if string.find(text, "%u%l+_%u%l+ prisijungs, jums apie tai") then
        text = string.match(text, "%u%l+_%u%l+")
        local sendText = ltu("Laukiamas žaidėjas: "..text..". @Emilis#5325")
        sendDiscord(false, "Laukimo BOT", "https://discord.com/api/webhooks/811218614714761216/3ULm28B-k_n4ElCjaej6WTWbR8_SC1zMTQPpRflsQtP5UlhaXlOvbd578sKWW1fP6R9t", sendText)
    end 
end 



function sendDiscord(getName, name, sendUrl, text)
    local requests = require('lib.requests')
    local encoding = require 'encoding'
    encoding.default = 'cp1257'
    local u8 = encoding.UTF8
    local _, idas = false, 0
    if getName then
        _, idas = sampGetPlayerIdByCharHandle(PLAYER_PED)
    end
    local args = {
        username = '',
        content = ''
    }
    local headers = {['Content-Type'] = 'application/json'}
    if getName then 
        args.username = sampGetPlayerNickname(idas)
    else 
        args.username = name
    end
    args.content = u8:encode(text)
    responses = requests.post {url = sendUrl, headers = headers, data = args}
end
--[[ Colors:
{ff0000} - raudona
{1cd031} - default zalia kaip serve
{16f534} - zalia, ryskesne
{b88d0f} - oranzine, komandu paaiskinimas
]]

function ltu(text)
	local encoding = require 'encoding'
	encoding.default = 'cp1257'
	local u8 = encoding.UTF8
	local ltu = {
		"\xc4\x85",	--ą
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
	--ąčęėįšųūž ĄČĘĖĮŠŲŪŽ
	if string.find(text, "ą") then text = string.gsub(text, "ą", ltu[1]) end
	if string.find(text, "č") then text = string.gsub(text, "č", ltu[2]) end
	if string.find(text, "ę") then text = string.gsub(text, "ę", ltu[3]) end
	if string.find(text, "ė") then text = string.gsub(text, "ė", ltu[4]) end
	if string.find(text, "į") then text = string.gsub(text, "į", ltu[5]) end
	if string.find(text, "š") then text = string.gsub(text, "š", ltu[6]) end
	if string.find(text, "ų") then text = string.gsub(text, "ų", ltu[7]) end
	if string.find(text, "ū") then text = string.gsub(text, "ū", ltu[8]) end
	if string.find(text, "ž") then text = string.gsub(text, "ž", ltu[9]) end
	if string.find(text, "Ą") then text = string.gsub(text, "Ą", ltu[10]) end
	if string.find(text, "Č") then text = string.gsub(text, "Č", ltu[11]) end
	if string.find(text, "Ę") then text = string.gsub(text, "Ę", ltu[12]) end
	if string.find(text, "Ė") then text = string.gsub(text, "Ė", ltu[13]) end
	if string.find(text, "Į") then text = string.gsub(text, "Į", ltu[14]) end
	if string.find(text, "Š") then text = string.gsub(text, "Š", ltu[15]) end
	if string.find(text, "Ų") then text = string.gsub(text, "Ų", ltu[16]) end
	if string.find(text, "Ū") then text = string.gsub(text, "Ū", ltu[17]) end
	if string.find(text, "Ž") then text = string.gsub(text, "Ž", ltu[18]) end
	text = u8:decode(text)
	return text
end 