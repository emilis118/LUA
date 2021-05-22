script_name ("Skelbimai pro")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local inicfg = require 'inicfg'
local encoding = require 'encoding'
local requests = require('lib.requests')
encoding.default = 'cp1257'
u8 = encoding.UTF8
local iniData = {}
local mainCfg = {
	settings = {
		enable = true,
		limit = 30,
	}
}
local textas = ""
local search = ""

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//skelbimaiPro//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "skelbimaiPro/settings")
	end
	iniData = inicfg.load(mainCfg, "skelbimaiPro/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("ssk")
		if not cmdResult then
			local result = sampRegisterChatCommand("ssk", toggleScript)
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript(arg)
	search = ""
	textas = ""
	if string.find(arg, " ") then
		search = string.gsub(arg, " ", "%%20")
	else
		search = ltu(arg)
	end
	local url = "https://sarg.kasteckis.lt/api/skelbimai?limit="..tostring(iniData.settings.limit).."&search="..search
	response = requests.get(url)
	local json_body, error = response.json()

	if #json_body.rows == 0 or json_body == nil then
		sampAddChatMessage("[Skelbimai] Neradau nieko.", 0x1cd031)
	else
		for i = 1, #json_body.rows do
		textas = textas..json_body.rows[i].datetime.."\t"..u8:decode(json_body.rows[i].text).."\n"
		end
		sampShowDialog(1, ltu("Paskutiniai "..iniData.settings.limit.." reporterių skelbimai"), textas, ltu("Uždaryti"), nil, 2)
	end
end

--------------------------------------------------------------------------------

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "skelbimaiPro/settings")
	if patvirtinimas and msgBool then sampAddChatMessage(ltu("[Skelbimai] Nustatymai įrašyti."), 0x1cd031) end
	--iniData = inicfg.load(nil, "skelbimaiPro/settings") -- nlb gerai sitas
end

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