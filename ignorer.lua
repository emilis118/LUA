script_name("Ignore players")
script_version("1.0")
script_author("Emilis")
script_description("/ignore Vardas_Pavarde")

local sampev = require 'lib.samp.events'
local enable = false
local toggleTest = true
local enter = false
local enterChat = false
local debug = false -- /ignore debug ijungimas
local toggleRead = true
local readCfg = true
local smsIgnr = false
local hello = true
local which = ""
require "lib.sampfuncs"
require "lib.moonloader"
local ignoreList = {}
local cfg = {}
local bendras = false
local vip = false
local admin = false
local admin2 = false
local system = false
local sms = false
local pokalbiai = false
local racija = false
local sMsg = false
local vMsg = false
local sAll = false
local pzuGun = false
local modCheck = false
local gp = false
local teisesauga = false
local mafijos = false
local gaujos = false
local apsauga = false
local apsauga1 = false
local mods = {
	"Emilis_Evil",
	"Admin_Bumeris",
	"Tautrimas_Juska",
	"Kornelijus_Kornis",
	"Domas_Sliuuzas",
	"Beliunas_Justas",
	"Giedrius_Gangs",
	"Khai_Offline",
	"Edcka_Bmw",
	"Voduf_Cornow",
	"Arnas_Max",
}

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
		cfgSet()
		if toggleTest then
			testList()
		end
		local cmdResult = sampIsChatCommandDefined("ignore")
		if not cmdResult then
			local result = sampRegisterChatCommand("ignore", ignore)
		end
	end
end

function sampev.onChatMessage(playerId, text)
	if enable then
		enterChat = false
		if bendras then
			for i = 1, #ignoreList do
				if ignoreList[i] == sampGetPlayerNickname(playerId) then
					if debug then sampAddChatMessage("[IGNORE] Nuignoravau_chat: "..ignoreList[i], 0x3f9412) end
					enterChat = true
					break
				end
			end
		end
		if enterChat then
			enterChat = false
			return false
		end
	end
end

function sampev.onServerMessage(color, text)
	if enable then
		enter = false
		for i = 1, #ignoreList do
			if vip and string.find(text, "%[VIP%] "..ignoreList[i]..": ") then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau: "..ignoreList[i], 0x3f9412) end
				break
			end
			if admin and string.find(text, ignoreList[i]) and string.find(text, "administratoriams") then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau: "..ignoreList[i], 0x3f9412) end
				break
			end
			if admin2 and string.find(text, "%[ADMIN%] "..ignoreList[i]..":") then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau: "..ignoreList[i], 0x3f9412) end
				break
			end
			if system then
				if string.find(text, ", jog "..ignoreList[i].." %(%d+%) suk") or string.find(text, ignoreList[i].." prane") then
					enter = true
					if debug then sampAddChatMessage("[IGNORE] Nuignoravau: "..ignoreList[i], 0x3f9412) end
					break
				end
			end
			if sms and string.find(text, "%[SMS%] %[") and string.find(text, ignoreList[i]) then
				if string.find(text, ">> "..ignoreList[i]) then enter = false else
					enter = true
					smsIgnr = true
					if debug then sampAddChatMessage("[IGNORE] Nuignoravau: "..ignoreList[i], 0x3f9412) end
					break
				end
			end
			if smsIgnr and color == -65110 then
				enter = true
				smsIgnr = false
				break
			end
			if pokalbiai and string.find(text, "%]%(") and string.find(text, ignoreList[i]) then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau: "..ignoreList[i], 0x3f9412) end
				break
			end
			if racija and string.find(text, "%[racija%]") and string.find(text, ignoreList[i]) then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau: "..ignoreList[i], 0x3f9412) end
				break
			end
			if sMsg and string.find(text, "%*Admin") and string.find(text, ignoreList[i]) then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau: "..ignoreList[i], 0x3f9412) end
				break
			end
			if vMsg and string.find(text, "%*{......}VIP") and string.find(text, ignoreList[i]) then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau: "..ignoreList[i], 0x3f9412) end
				break
			end
		end
		if sAll and string.find(text, "%*Admin") then
			for k = 1, #mods do
				if not string.find(text, mods[k]) then
					modCheck = true
				else
					modCheck = false
					break
				end
			end
			if modCheck then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau /s zinute", 0x3f9412) end
			end
		end
		if pzuGun and string.find(text, "ginklas pakito") then
			enter = true
			if debug then sampAddChatMessage("[IGNORE] Nuignoravau ginklo pakitimo zinute", 0x3f9412) end
		end
		if gp and string.find(text, "pardaviau") and string.find(text, "su") and string.find(text, "kulk") then
			enter = true
			if debug then sampAddChatMessage("[IGNORE] Nuignoravau ginklo pardavimo zinute", 0x3f9412) end
		end
		if teisesauga then
			if string.find(text, "Pareig") and string.find(text, "pasteb") and string.find(text, "nuo policijos") and string.find(text, "balta spalva") then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau teisesaugos racija (bega)", 0x3f9412) end
			end
			if string.find(text, "Policija") and string.find(text, "Prane") and string.find(text, "udo") and string.find(text, "duotas") then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau teisesaugos racija (zudo)", 0x3f9412) end
			end
			if string.find(text, "sumok") and string.find(text, "racija") then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau teisesaugos racija (bauda 1)", 0x3f9412) end
			end
			if string.find(text, "pasi") and string.find(text, "racija") and string.find(text, "jis buvo b.glys") then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau teisesaugos racija (bauda begliui)", 0x3f9412) end
			end
			if string.find(text, "at.miau") and string.find(text, "racija") and string.find(text, "pa.ym.jim.") then
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau teisesaugos racija (bauda begliui)", 0x3f9412) end
			end
		end
		if mafijos then
			if string.find(text, "mafijos") then
				if string.find(text, "Cosa Nostra") or string.find(text, "Immortal") then
					enter = true
					if debug then sampAddChatMessage("[IGNORE] Nuignoravau mafijos /d zinute", 0x3f9412) end
				end
			end
		end
		if gaujos then
			if string.find(text, "gaujos") then
				if string.find(text, "Los Santos Vagos") or string.find(text, "Varrios Los Aztecas") then
					enter = true
					if debug then sampAddChatMessage("[IGNORE] Nuignoravau gaujos /d zinute", 0x3f9412) end
				end
			end
		end
		if apsauga then
			if string.find(text, "gaujos") then
				if string.find(text, "Los Santos Vagos") or string.find(text, "Varrios Los Aztecas") then
					enter = true
					if debug then sampAddChatMessage("[IGNORE] Nuignoravau gaujos /d zinute", 0x3f9412) end
				end
			end
		end
		if apsauga1 then
			if string.find(text, "Pasaugoti") and string.find(text, "kategorija") and string.find(text, "Neprivalomas") then -- neprivalomas iskv
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau apsaugos zinute", 0x3f9412) end
			end
			if string.find(text, "kvie") and string.find(text, "apsaug") and string.find(text, "XP") then -- neprivalomas iskv
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau apsaugos zinute", 0x3f9412) end
			end
			if string.find(text, "paimtas per") and string.find(text, "ms") and string.find(text, "pas") then -- neprivalomas iskv
				enter = true
				if debug then sampAddChatMessage("[IGNORE] Nuignoravau apsaugos zinute", 0x3f9412) end
			end
		end
		if enter then
			enter = false
			return false
		end
	end
end

function ignore(arg)
	if #arg == 0 then
		if enable then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore{3f9412}. Prideti zaideja: {b88d0f}/ignore V_P", 0x3f9412)
			cfgChange("enable", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore{3f9412}. Prideti zaideja: {b88d0f}/ignore V_P", 0x3f9412)
			cfgChange("enable", true)
		end
	end
	if arg == "debug" then
		if debug then
			sampAddChatMessage("{3f9412}[IGNORE] Debuginimas {ff0000}isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore debug{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("debug", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE] Debuginimas {20fc03}ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore debug{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("debug", true)
		end
	end
	if arg == "cfg" then
		for i = 1, #cfg do
			sampAddChatMessage("[IGNORE] "..cfg[i], 0x3f9412)
		end
		sampAddChatMessage("[IGNORE] -----------------------------------------------------------------------------------", 0x33bf2e)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}bendro chat{3f9412} filtra: {b88d0f}/ignore bendras", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}vip chat{3f9412} filtra: {b88d0f}/ignore vipchat", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}/admin{3f9412} filtra: {b88d0f}/ignore /admin", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}admin chat (//){3f9412} filtra: {b88d0f}/ignore adminchat", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}sistemos pranesimu{3f9412} filtra: {b88d0f}/ignore syschat", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}/pokalbiai{3f9412} filtra: {b88d0f}/ignore pokalbiai", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}raciju{3f9412} filtra: {b88d0f}/ignore pokalbiai", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}/s zinuciu{3f9412} filtra: {b88d0f}/ignore /s", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}/v zinuciu{3f9412} filtra: {b88d0f}/ignore /v", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {d41522}visu {e32b2b}/s{3f9412} zinuciu filtra: {b88d0f}/ignore sall", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}ginklu pasikeitimo (/pzu){3f9412} zinuciu filtra: {b88d0f}/ignore ginklas", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}ginklu prekeiviu pardavimu{3f9412} zinuciu filtra: {b88d0f}/ignore gp", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}teisesaugos (ne /nustatymai){3f9412} zinuciu filtra: {b88d0f}/ignore teisesauga", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {d41522}visas {e32b2b}mafiju /d zinutes{3f9412} zinuciu filtra: {b88d0f}/ignore mafijos", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {d41522}visas {e32b2b}gauju /d zinutes{3f9412} zinuciu filtra: {b88d0f}/ignore gaujos", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}apsaugos iskvietimu{3f9412} zinuciu filtra: {b88d0f}/ignore apsauga", 0x3f9412)
		sampAddChatMessage("[IGNORE] Norint ijungti/isjungti {e32b2b}apsaugos kitu{3f9412} zinuciu filtra: {b88d0f}/ignore apsauga1", 0x3f9412)
		sampAddChatMessage("[IGNORE] -----------------------------------------------------------------------------------", 0x33bf2e)
	end
	if arg == "info" then
		sampAddChatMessage("[IGNORE] Ijungti/isjungti script: {b88d0f}/ignore", 0x3f9412)
		sampAddChatMessage("[IGNORE] Prideti arba istrinti zaideja: {b88d0f}/ignore Vardas_Pavarde", 0x3f9412)
		sampAddChatMessage("[IGNORE] Paziureti kokie zaidejai sarase: {b88d0f}/ignore list", 0x3f9412)
		sampAddChatMessage("[IGNORE] Matyti, kai blokuojama zinute: {b88d0f}/ignore debug", 0x3f9412)
		sampAddChatMessage("[IGNORE] Paziureti ir pakeisti nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
	end
	if arg == "bendras" then
		--bendras = not bendras
		if bendras then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore bendras{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("bendras", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore bendras{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("bendras", true)
		end
	end
	if arg == "vipchat" then
		--bendras = not bendras
		if vip then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore vipchat{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("vipchat", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore vipchat{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("vipchat", true)
		end
	end
	if arg == "/admin" then
		--bendras = not bendras
		if admin then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore /admin{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("/admin", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore /admin{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("/admin", true)
		end
	end
	if arg == "adminchat" then
		--bendras = not bendras
		if admin2 then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore adminchat{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("adminchat", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore adminchat{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("adminchat", true)
		end
	end
	if arg == "syschat" then
		--bendras = not bendras
		if system then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore syschat{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("syschat", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore syschat{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("syschat", true)
		end
	end
	if arg == "sms" then
		--bendras = not bendras
		if sms then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore sms{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("sms", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore sms{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("sms", true)
		end
	end
	if arg == "pokalbiai" then
		--bendras = not bendras
		if pokalbiai then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore pokalbiai{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("pokalbiai", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore pokalbiai{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("pokalbiai", true)
		end
	end
	if arg == "racija" then
		--bendras = not bendras
		if racija then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore racija{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("racija", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore racija{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("racija", true)
		end
	end
	if arg == "/s" then
		--bendras = not bendras
		if sMsg then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore /s{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("/s", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore /s{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("/s", true)
		end
	end
	if arg == "/v" then
		--bendras = not bendras
		if vMsg then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore /v{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("/v", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore /v{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("/v", true)
		end
	end
	if arg == "sall" then
		--bendras = not bendras
		if sAll then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore sall{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("sall", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore sall{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("sall", true)
		end
	end
	if arg == "ginklas" then
		--bendras = not bendras
		if pzuGun then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore ginklas{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("ginklas", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore ginklas{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("ginklas", true)
		end
	end
	if arg == "gp" then
		if gp then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore gp{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("gp", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore gp{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("gp", true)
		end
	end
	if arg == "teisesauga" then
		if teisesauga then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore teisesauga{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("teisesauga", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore teisesauga{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("teisesauga", true)
		end
	end
	if arg == "mafijos" then
		if mafijos then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore mafijos{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("mafijos", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore mafijos{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("mafijos", true)
		end
	end
	if arg == "gaujos" then
		if gaujos then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore gaujos{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("gaujos", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore gaujos{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("gaujos", true)
		end
	end
	if arg == "apsauga" then
		if apsauga then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore apsauga{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("apsauga", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore apsauga{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("apsauga", true)
		end
	end
	if arg == "apsauga1" then
		if apsauga1 then
			sampAddChatMessage("{3f9412}[IGNORE]{ff0000} Isjungtas. {3f9412}Norint ijungti: {b88d0f}/ignore apsauga1{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("apsauga1", false)
		else
			sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Ijungtas. {3f9412}Norint isjungti: {b88d0f}/ignore apsauga1{3f9412}. Placiau apie nustatymus: {b88d0f}/ignore cfg", 0x3f9412)
			cfgChange("apsauga1", true)
		end
	end
	if #arg ~= 0 and arg ~= "debug" and arg ~= "list" and arg ~= "info" and arg ~= "cfg" and arg ~= "check" and arg ~= "bendras" and arg ~= "vipchat" and arg ~= "/admin" and arg ~= "adminchat" and arg ~= "syschat" and arg ~= "pokalbiai" then
		if arg ~= "/s" and arg ~= "/v" and arg ~= "sall" and arg ~= "sms" and arg ~= "ginklas" and arg ~= "gp" and arg ~= "teisesauga" and arg ~= "mafijos" and arg ~= "gaujos" and arg ~= "apsauga" and arg ~= "apsauga1" then
			if string.find(arg, "%u%l+_%u%l+") then
				local writer = true
				for i = 1, #ignoreList do
					if ignoreList[i] == arg then
						sampAddChatMessage("{3f9412}[IGNORE] Istrinamas zaidejas: {ff0000}"..arg, 0x3f9412)
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
					for k = 1, #mods do
						if arg == mods[k] then
							modCheck = true
							break
						end
					end
					if modCheck then
						sampAddChatMessage("{3f9412}[IGNORE] Sio zaidejo negalima prideti i sarasa: {ff0000}"..arg..".", 0x3f9412)
						modCheck = false
					else
						sampAddChatMessage("{3f9412}[IGNORE] Pridetas i ignore sarasa: {20fc03}"..arg..".", 0x3f9412)
						file = io.open(getGameDirectory().."//moonloader//config//ignorer//ignore.txt", "a")
						io.output(file)
						io.write(arg.."\n")
						io.close(file)
						toggleRead = true
						readCfg = true
					end
				end
			else
				sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Norint ideti zaideja i sarasa: /ignore Vardas_Pavarde (pilnas)", 0x3f9412)
			end
		end
	end
	if arg == "list" then
		sampAddChatMessage("{3f9412}[IGNORE]{20fc03} Zaideju sarasas:", 0x3f9412)
		for i = 1, #ignoreList do
			sampAddChatMessage(i..". "..ignoreList[i], 0x3f9412)
		end
	end
end

function deletePlayer(player)
	file = io.open(getGameDirectory().."//moonloader//config//ignorer//ignore.txt", "r")
	local lines = ""
	while(true) do
		local line = file:read("*line")
		if not line then break end
		if not string.find(line, player, 1) then --if string not found
			lines = lines .. line .. "\n"
		end
	end
	file:close()
	file = io.open(getGameDirectory().."//moonloader//config//ignorer//ignore.txt", "w+")
	file:write(lines)
	file:close()
end

function cfgChange(which, truefalse)
	fileCfg = io.open(getGameDirectory().."//moonloader//config//ignorer//ignorecfg.txt", "r")
	local linesTable = {}
	local lines = ""
	local j = 0
	while(true) do
		j = j + 1
		local line = fileCfg:read("*line")
		if not line then break end
		if string.find(line, which, 1) then
			if truefalse then
				linesTable[j] = which .. " = true" .. "\n"
			else
				linesTable[j] = which .. " = false" .. "\n"
			end
		end
		if not string.find(line, which, 1) then --if string not found
			linesTable[j] = line .. "\n"
		end
	end
	for i = 1, #linesTable do
		lines = lines..linesTable[i]
	end
	fileCfg:close()
	fileCfg = io.open(getGameDirectory().."//moonloader//config//ignorer//ignorecfg.txt", "w+")
	fileCfg:write(lines)
	fileCfg:close()
	readCfg = true
end

function cfgSet()
	if readCfg then
		cfg = {}
		fileCfg = io.open(getGameDirectory().."//moonloader//config//ignorer//ignorecfg.txt", "r")
		local j = 0
		for line in fileCfg:lines() do
			if not string.find(line, ";") then
				j = j + 1
				cfg[j] = line
			end
		end
		j = 0
		io.close(fileCfg)
	end
	if readCfg then
		if cfg[1] == "enable = true" then enable = true else enable = false end
		if cfg[2] == "debug = true" then debug = true else debug = false end
		if cfg[3] == "bendras = true" then bendras = true else bendras = false end
		if cfg[4] == "vipchat = true" then vip = true else vip = false end
		if cfg[5] == "/admin = true" then admin = true else admin = false end
		if cfg[6] == "adminchat = true" then admin2 = true else admin2 = false end
		if cfg[7] == "syschat = true" then system = true else system = false end
		if cfg[8] == "sms = true" then sms = true else sms = false end
		if cfg[9] == "pokalbiai = true" then pokalbiai = true else pokalbiai = false end
		if cfg[10] == "racija = true" then racija = true else racija = false end
		if cfg[11] == "/s = true" then sMsg = true else sMsg = false end
		if cfg[12] == "/v = true" then vMsg = true else vMsg = false end
		if cfg[13] == "sall = true" then sAll = true else sAll = false end
		if cfg[14] == "ginklas = true" then pzuGun = true else pzuGun = false end
		if cfg[15] == "gp = true" then gp = true else gp = false end
		if cfg[16] == "teisesauga = true" then teisesauga = true else teisesauga = false end
		if cfg[17] == "mafijos = true" then mafijos = true else mafijos = false end
		if cfg[18] == "gaujos = true" then gaujos = true else gaujos = false end
		if cfg[19] == "apsauga = true" then apsauga = true else apsauga = false end
		if cfg[20] == "apsauga1 = true" then apsauga1 = true else apsauga1 = false end
		readCfg = false
	end
end

function readIgnore()
	if toggleRead then
		-- wipe
		ignoreList = {}
		-- nuskaito faila
		file = io.open(getGameDirectory().."//moonloader//config//ignorer//ignore.txt", "r")
		local j = 0
		for line in file:lines() do
			j = j + 1
			ignoreList[j] = line
		end
		j = 0
		io.close(file)
		-- isjungia failo skaityma
		toggleRead = false
	end
end

function hello()
	if hello then
		sampAddChatMessage("[IGNORE] Norint suzinoti komandas: {b88d0f}/ignore info", 0x3f9412)
	end
end

function sampGetPlayerIdByNickname(nick)
	local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if nick == sampGetPlayerNickname(id) then return id end
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == nick then return i end
	end
end

function testList()
	toggleTest = false
	for i = 1, #mods do
		for j = 1, #ignoreList do
			if mods[i] == ignoreList[j] then
				sampAddChatMessage("[IGNORE] MODERATORIAI NEGALI BUTI IGNORUOJAMI", 0xff0000)
				enable = false
				wait(999999999)
			end
		end
	end
end
