script_name("autoskelb")
script_version("1.0")
script_author("Emilis")

--------------------------------------------------------------------------------

require "lib.sampfuncs"
require "lib.moonloader"
local enable = false
local enable2 = false
local zinute = {
	"/s [Loterija] Atsiprašau už flood; Svarbios instrukcijos bei taisyklės visiems:",
	"/s [Loterija] Žaisti esate kviečiami visi, per vieną seriją galite spėti tik 1 kartą (programa tiesiog neužfiksuos kitų).",
	"/s [Loterija] Kaip spėti: kai paskelbsiu žaidimo pradžią į pokalbį spėsime skaičių nuo 1 iki 1000 (įskaitant).",
	"/s [Loterija] Teisingas spėjimo pavyzdys: '/p1 69', (betkuris iš trijų pokalbių). Po kablelio skaičiai nesiskaito",
	"/s [Loterija] Paruošta taškų sistema: Score = laimingas skaičius - jūsų spėjimas. Neigiamų taškų gauti neįmanoma, drąsiai spėliokite.",
	"/s [Loterija] Maksimaliai per žaidimą gausite 100 taškų (pataikius į skaičių). Visi taškai sumuojasi, todėl svarbu dalyvaut rounduose.",
	"/s [Loterija] Paskelbus nugalėtoją visus rezultatus resetinsim ir pradėsim iš naujo. SĖKMĖS VISIEMS! :)",
}
local papildomosZinutes = {
	"/s [Loterija] Sveiki, šiuo metu vyksta loterija. Visi esate kviečiami dalyvauti. Prizai: 50 kreditų x 4 žaidimai.",
	"/s [Loterija] DRAUDŽIAMA duoti naujus /mute kol vyksta loterija. Adminai, kurie trukdys, gaus mute/ban.",
	"/s [Loterija] Jei žmogus yra vertas mute, palaukite renginio pabaigos arba parašykite skundą forume.",
}

--------------------------------------------------------------------------------

function main()
	repeat wait(0)
	until isSampLoaded()
	repeat wait(0)
	until isSampfuncsLoaded()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("autoskelb")
		if not cmdResult then
			local result = sampRegisterChatCommand("autoskelb", toggle)
		end
		local cmdResult = sampIsChatCommandDefined("autoskelb2")
		if not cmdResult then
			local result = sampRegisterChatCommand("autoskelb2", toggle2)
		end
		skelbti()
		papildomos()
		wait(60000) -- bendras cooldown
	end
end

--------------------------------------------------------------------------------

function toggle()
	enable = not enable
	if enable then
		sampAddChatMessage("[AUTO SKELBIMAS] Ijungtas.", 0xffffff)
	else
		sampAddChatMessage("[AUTO SKELBIMAS] {ff0000}Isjungtas.", 0xffffff)
	end
end

function toggle2()
	enable2 = not enable2
	if enable2 then
		sampAddChatMessage("[AUTO SKELBIMAS] Papildomos Ijungtas.", 0xffffff)
	else
		sampAddChatMessage("[AUTO SKELBIMAS] Papildomos {ff0000}Isjungtas.", 0xffffff)
	end
end

--------------------------------------------------------------------------------

function skelbti()
	if enable then
		for i = 1, #zinute do
			sampSendChat(ltu(zinute[i]))
			wait (5000)
		end
	end
end

function papildomos()
	if enable2 then
		for i = 1, #papildomosZinutes do
			sampSendChat(ltu(papildomosZinutes[i]))
			wait (5000)
		end
	end
end

function ltu(text)
    local encoding = require 'encoding'
    encoding.default = 'cp1257'
    local u8 = encoding.UTF8
    local ltu = {
        '\xc4\x85', --ą
        '\xc4\x8d',
        '\xc4\x99',
        '\xc4\x97',
        '\xc4\xaf',
        '\xc5\xa1',
        '\xc5\xb3',
        '\xc5\xab',
        '\xc5\xbe',
        '\xc4\x84',
        '\xc4\x8c',
        '\xc4\x98',
        '\xc4\x96',
        '\xc4\xae',
        '\xc5\xa0',
        '\xc5\xb2',
        '\xc5\xaa',
        '\xc5\xbd'
    }
    --ąčęėįšųūž ĄČĘĖĮŠŲŪŽ
    if string.find(text, 'ą') then
        text = string.gsub(text, 'ą', ltu[1])
    end
    if string.find(text, 'č') then
        text = string.gsub(text, 'č', ltu[2])
    end
    if string.find(text, 'ę') then
        text = string.gsub(text, 'ę', ltu[3])
    end
    if string.find(text, 'ė') then
        text = string.gsub(text, 'ė', ltu[4])
    end
    if string.find(text, 'į') then
        text = string.gsub(text, 'į', ltu[5])
    end
    if string.find(text, 'š') then
        text = string.gsub(text, 'š', ltu[6])
    end
    if string.find(text, 'ų') then
        text = string.gsub(text, 'ų', ltu[7])
    end
    if string.find(text, 'ū') then
        text = string.gsub(text, 'ū', ltu[8])
    end
    if string.find(text, 'ž') then
        text = string.gsub(text, 'ž', ltu[9])
    end
    if string.find(text, 'Ą') then
        text = string.gsub(text, 'Ą', ltu[10])
    end
    if string.find(text, 'Č') then
        text = string.gsub(text, 'Č', ltu[11])
    end
    if string.find(text, 'Ę') then
        text = string.gsub(text, 'Ę', ltu[12])
    end
    if string.find(text, 'Ė') then
        text = string.gsub(text, 'Ė', ltu[13])
    end
    if string.find(text, 'Į') then
        text = string.gsub(text, 'Į', ltu[14])
    end
    if string.find(text, 'Š') then
        text = string.gsub(text, 'Š', ltu[15])
    end
    if string.find(text, 'Ų') then
        text = string.gsub(text, 'Ų', ltu[16])
    end
    if string.find(text, 'Ū') then
        text = string.gsub(text, 'Ū', ltu[17])
    end
    if string.find(text, 'Ž') then
        text = string.gsub(text, 'Ž', ltu[18])
    end
    text = u8:decode(text)
    return text
end