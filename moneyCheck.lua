script_name ("Money checker")
script_version("1.0")
script_author("Emilis")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local id = 0
local toggle = false
local rankose = 0
local banke = 0
local taupomoji = 0
local namuose = 0
local uzdirbo = 0
local suma = 0

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("moneycheck")
		if not cmdResult then
			local result = sampRegisterChatCommand("moneycheck", toggler)
		end
		checkMoney()
	end
end


--------------------------------------------------------------------------------

function toggler()
	toggle = not toggle
	if toggle then
		sampAddChatMessage("[Money Checker] Ijungtas. Komanda: /moneycheck", 0xffffff)
		id = sampGetMaxPlayerId(false)
	else
		sampAddChatMessage("[Money Checker] {ff0000}Isjungtas.{ffffff} Komanda: /moneycheck", 0xffffff)
	end
end

--------------------------------------------------------------------------------

function checkMoney()
	if not toggle then return end
	for i = 1, id do
		if not toggle then sampAddChatMessage("[Money Checker] {ff0000}Sustabdomas!", 0xffffff) break end
		wait(300)
		sampSendChat("/pinigai "..i)
		if i == id then toggle = false end
	end
end


--------------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
	if not toggle then return end
	--if color ~= 885850026 then return end
	sampAddChatMessage(text, 0xffffff)
	if string.find(text, "turi") then
		local noDots = string.gsub(text, "%.", "")
		rankose = string.match(noDots, "%d+")
		banke = string.match(noDots, "Banke: %d+")
		banke = string.match(banke, "%d+")
		namuose = string.match(noDots, "Namuose: %d+")
		namuose = string.match(namuose, "%d+")
		taupomoji = string.match(noDots, "Taupomoji: %d+")
		taupomoji = string.match(taupomoji, "%d+")
		uzdirbo = string.match(noDots, "dirbo: %d+")
		if uzdirbo ~= nil then uzdirbo = string.match(uzdirbo, "%d+") end
		--[[
		sampAddChatMessage(rankose, 0xff0000)
		sampAddChatMessage(banke, 0xff0000)
		sampAddChatMessage(namuose, 0xff0000)
		sampAddChatMessage(taupomoji, 0xff0000)
		sampAddChatMessage(uzdirbo, 0xff0000)
		]]
		suma = tonumber(rankose) + tonumber(banke) + tonumber(namuose) + tonumber(taupomoji) + tonumber(uzdirbo)
		sampAddChatMessage(suma, 0xff0000)
		suma = 0
	end
	if string.find(text, "istorija: /israsas") then
		return false
	end
end

--------------------------------------------------------------------------------
