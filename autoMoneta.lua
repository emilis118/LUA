script_name("autoMoneta")
script_version("1.0")
script_author("Emilis")
script_description("/.moneta - ijungia auto sutikima su betkokia moneta")

-----------------------------------------------------------------------------

local sampev = require 'lib.samp.events'
local enable = true
require "lib.sampfuncs"
require "lib.moonloader"
local playerName = "Kebabu_Dievas"
local enable = false
local monetaMax = 999999999

-----------------------------------------------------------------------------

function main()
	repeat wait (0)
	until isSampLoaded()
	repeat wait (0)
	until isSampfuncsLoaded()
	local result = sampRegisterChatCommand(".moneta", toggleFunc)
	local result = sampRegisterChatCommand(".monetamax", monetaMaxas)
	while true do wait(0) end
end

-----------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
	if enable then
		if string.find(text, "* Jeigu sutinki") then
			--sampAddChatMessage("radau: "..text, 0xFFFFFF)
			playerName = string.match(text, "%u%l+_%u%l+")
			--sampAddChatMessage("rastas nick: "..playerName, 0xFFFFFF)
			suma = string.match(text, " %d+ ")
			--sampAddChatMessage("rasta suma: "..suma, 0xFFFFFF)
			simbolis = string.match(text, "[HS]$")
			--sampAddChatMessage("rastas simbolis: -="..simbolis.."=-", 0xFFFFFF)
			if monetaMax > tonumber(suma) then
				sampSendChat("/moneta "..playerName..suma..simbolis)
			else
				sampAddChatMessage("{FF0000}*** Pasiulymas buvo didesnis, nei leidziama suma (/.monetamax).", 0xFFFFFF)
			end
		end
	end
end

function toggleFunc()
	if enable then
		enable = false
		sampAddChatMessage("{fc9003}*** Auto Moneta {fc0303}isjungta{fc9003}. Ijungti su {e3fc03}/.moneta", 0xFFFFFF)
	else
		enable = true
		sampAddChatMessage("{fc9003}*** Auto Moneta {2cfc03}ijungta{fc9003}. Isjungti su {e3fc03}/.moneta", 0xFFFFFF)
	end
end

function monetaMaxas(args)
	local arg = tonumber(args)
	if #args == 0 then
		sampAddChatMessage("{fc9003}*** Norint nustatyti maksimalia zaidimo suma - {e3fc03}/.monetamax [suma] {FFFFFF}(be k ar m)", 0xFFFFFF)
	elseif arg == 0 then
		sampAddChatMessage("{fc9003}*** Auto Moneta {fc0303}isjungta{fc9003}. Ijungti su {e3fc03}/.moneta", 0xFFFFFF)
		enable = false
	elseif arg > 0 then
		monetaMax = arg
		enable = true
		sampAddChatMessage("{fc9003}*** Auto Moneta maksimali suma: {2cfc03}"..tostring(monetaMax).."{fc9003}. Auto moneta {2cfc03}ijungta", 0xFFFFFF)
	elseif arg < 0 then
		sampAddChatMessage("{ff0000}*** Irasykite teigiama skaiciu. {e3fc03}Pvz.: /.monetamax 100000", 0xFFFFFF)
	end
end
