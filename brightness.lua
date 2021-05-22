script_name ("Brightness Fix")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {
        enable = true,
        brightness = 700,
    }
}
local toggleCheck = false

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//brightness//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "brightness/settings")
	end
	iniData = inicfg.load(mainCfg, "brightness/settings")
    
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("brightness")
		if not cmdResult then
			local result = sampRegisterChatCommand("brightness", toggleScript)
		end
        local brgt = readMemory(0xBA6784, 4, false)
        if brgt == iniData.settings.brightness then toggleCheck = false else toggleCheck = true end
        if toggleCheck then
            toggleCheck = false
            setBrightness(iniData.settings.brightness)
        end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript(arg)
    if #arg == 0 then sampAddChatMessage(ltu("[Brightness] Nustatyti mėgstamą brightness: {b88d0f}/brightness [1 - 5000]"), 0x1cd031) return end
    local skaic = string.match(arg, "%d+")
    iniData.settings.brightness = tonumber(skaic)
    setBrightness(iniData.settings.brightness)
    writeSetting(true)
end

--------------------------------------------------------------------------------

function setBrightness(value)
    local oldValue = readMemory(0xBA6784, 4, false)
    if oldValue == value then return
    else writeMemory(0xBA6784, 4, value, false) end
end 

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "brightness/settings")
	if patvirtinimas and msgBool then sampAddChatMessage(ltu("[Brightness] Nustatymai įrašyti."), 0x1cd031) end
	--iniData = inicfg.load(nil, "brightness/settings") -- nlb gerai sitas
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