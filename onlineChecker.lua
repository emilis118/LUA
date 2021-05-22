script_name ("Online Checker")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local vk = require "lib.vkeys"
local mad = require 'MoonAdditions'
local iniData = {}
local mainCfg = {
	settings = {enable = true, debug = false},
	ac = {
		"Matas_Ammo",
		"Deividas_Bayern",
		"Burrito_Dievas",
		"Frozen_Inferno",
		"Liudax_Ltu",
		"Vytautas_Knockers",
	},
	position = {
		varX = 0.83,
		varY = 0.98,
		transparency = 255,
	}
}
local online = {}
local idTable = {}
local textPos = 1
local x = 0
local y = 0
local nametextdraw = {}
local toggleEvents = false

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	repeat
		wait(0)
		local result = sampIsLocalPlayerSpawned()
	until result
	if not doesFileExist(getGameDirectory().."//moonloader//config//acOnline//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "acOnline/settings")
	end
	iniData = inicfg.load(nil, "acOnline/settings")
	wait(100)
	toggleEvents = true
	screenRes()
	if iniData.settings.enable then
		checkOnline()
	end
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("ac")
		if not cmdResult then
			local result = sampRegisterChatCommand("ac", toggleScript)
		end
		local cmdResult = sampIsChatCommandDefined("acadd")
		if not cmdResult then
			local result = sampRegisterChatCommand("acadd", addPlayer)
		end
		local cmdResult = sampIsChatCommandDefined("acdelete")
		if not cmdResult then
			local result = sampRegisterChatCommand("acdelete", deletePlayer)
		end
		local cmdResult = sampIsChatCommandDefined("acdebug")
		if not cmdResult then
			local result = sampRegisterChatCommand("acdebug", debugToggle)
		end
		local cmdResult = sampIsChatCommandDefined("acsetx")
		if not cmdResult then
			local result = sampRegisterChatCommand("acsetx", setX)
		end
		if not cmdResult then
			local result = sampRegisterChatCommand("acsety", setY)
		end
		if not cmdResult then
			local result = sampRegisterChatCommand("actransp", setTransparency)
		end
		if not cmdResult then
			local result = sampRegisterChatCommand("acinfo", infoMsg)
		end
		if wasKeyPressed(vk.VK_F8) then
			textDelete()
			wait(1000)
			textAdd()
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas


function toggleScript(arg)
	if #arg == 0 then
		iniData.settings.enable = not iniData.settings.enable
		if iniData.settings.enable then
			sampAddChatMessage("[Online Checker] Zaideju sarasas {16f534}ijungtas.", 0x1cd031)
			textDelete()
			textAdd()
		else
			sampAddChatMessage("[Online Checker] Zaideju sarasas {ff0000}isjungtas.", 0x1cd031)
			textDelete()
		end
		writeSetting(false)
	end
	if arg == "list" then
		for i = 1, #iniData.ac do
			sampAddChatMessage("[Online Checker] "..i..". "..iniData.ac[i], 0x1cd031)
		end
	end
end

--------------------------------------------------------------------------------

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "acOnline/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[Online Checker] Nustatymai irasyti.", 0x1cd031) end
	iniData = inicfg.load(nil, "acOnline/settings")
end

--------------------------------------------------------------------------------

function checkOnline()
	online = {}
	for i = 1, #iniData.ac do
		if iniData.settings.debug then sampAddChatMessage(iniData.ac[i], -1) end
		id = sampGetPlayerIdByNickname(iniData.ac[i])
		if id ~= nil then table.insert(online, tostring(iniData.ac[i]).."_("..id..")") end
		if id ~= nil then table.insert(idTable, id) end
	end
	if iniData.settings.debug then
		for i = 1, #online do
			sampAddChatMessage("[Online Checker] Online: {b88d0f}"..online[i], 0x1cd031)
		end
		for i = 1, #idTable do
			sampAddChatMessage("[Online Checker] ID: {b88d0f}"..idTable[i], 0x1cd031)
		end
	end
	textAdd()
end

--------------------------------------------------------------------------------

function addPlayer(arg)
	local pasikeitimas = false
	if #arg ~= 0 then
		table.insert(iniData.ac, arg)
		pasikeitimas = true
	end
	if pasikeitimas then
		writeSetting(true)
		checkOnline()
		textDelete()
		textAdd()
	end
end


--------------------------------------------------------------------------------

function deletePlayer(arg)
	local pasikeitimas = false
	if #arg ~= 0 and string.find(arg, "%u%l+_%u%l+") then
		for i = 1, #iniData.ac do
			if iniData.ac[i] == arg then table.remove(iniData.ac, i) pasikeitimas = true break end
		end
	else sampAddChatMessage("[Online Checker] Naudokite tokia forma: {b88d0f}/acdelete Vardas_Pavarde", 0x1cd031)
	end
	if not pasikeitimas then sampAddChatMessage("[Online Checker] Tokio zaidejo {ff0000}nerasta.", 0x1cd031) end
	if pasikeitimas then
		writeSetting(true)
		checkOnline()
		textDelete()
		textAdd()
	end
end

--------------------------------------------------------------------------------

function sampGetPlayerIdByNickname(nick)
	local result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if nick == sampGetPlayerNickname(id) then return id end
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == nick then return i end
	end
end

--------------------------------------------------------------------------------

function sampev.onPlayerJoin(playerId, color, isNpc, nickname)
	if not toggleEvents then return end
	if isNpc then return end
	if isGamePaused() then return end
	if string.find(nickname, "@") then if iniData.settings.debug then sampAddChatMessage("Radau zaideja su email", -1) sampAddChatMessage(nickname, -1) end end
	for i = 1, #iniData.ac do
		if nickname == iniData.ac[i] then
			textDelete()
			textAdd()
		end
	end
end

--------------------------------------------------------------------------------

function sampev.onPlayerQuit(playerId, reason)
	if not toggleEvents then return end
	if isGamePaused() then return end
	for i = 1, #idTable do
		if playerId == idTable[i] then
			textDelete()
			textAdd()
			if iniData.settings.debug then sampAddChatMessage("darau checka online", -1) end
		end
	end
end

--------------------------------------------------------------------------------

function sampev.onSetPlayerName(playerId, name, success)
	if not toggleEvents then return end
	if isGamePaused() then return end
	for i = 1, #iniData.ac do
		if nickname == iniData.ac[i] then
			--local scr = thisScript()
			--scr:reload()
			textDelete()
			textAdd()
		end
	end
end


--------------------------------------------------------------------------------

function debugToggle()
	iniData.settings.debug = not iniData.settings.debug
	if iniData.settings.debug then
		sampAddChatMessage("[Online Checker] Debugginimas {16f534}ijungtas.", 0x1cd031)
	else
		sampAddChatMessage("[Online Checker] Debugginimas {ff0000}isjungtas.", 0x1cd031)
	end
	writeSetting(true)
end

--------------------------------------------------------------------------------

function textAdd()
	local yChange = -17
	for i = 1, #online do
		nametextdraw[i] = mad.textdraw.new(online[i], x, y)
		y = y + yChange
		--nametextdraw[i].style = mad.font_style.PRICEDOWN
		nametextdraw[i].width = 0.6
		nametextdraw[i].height = 0.85
		nametextdraw[i]:set_text_color(255, 255, 255, iniData.position.transparency)
		if iniData.position.transparency < 255 then nametextdraw[i].outline = 0 else nametextdraw[i].outline = 1 end
		nametextdraw[i].background = false
		nametextdraw[i].wrap = 250
	end
	--y = y + yChange
	nick_textdraw = mad.textdraw.new("~g~Online:", x, y)
	--nametextdraw[i] = mad.textdraw.new("~g~Online:", x, y)
	--nametextdraw[i].style = mad.font_style.PRICEDOWN
	nick_textdraw.width = 0.6
	nick_textdraw.height = 0.85
	nick_textdraw:set_text_color(255, 255, 255, iniData.position.transparency)
	if iniData.position.transparency < 255 then nick_textdraw.outline = 0 else nick_textdraw.outline = 1 end
	nick_textdraw.background = false
	nick_textdraw.wrap = 250
end

--------------------------------------------------------------------------------

function textDelete()
	if nametextdraw ~= nil then
		for i = 1, #nametextdraw do
			nametextdraw[i].text = ""
		end
	end
	if nick_textdraw ~= nil then nick_textdraw.text = "" end
	screenRes()
	--local scr = thisScript()
	--scr:reload()
end

--------------------------------------------------------------------------------

function screenRes()
	local w, h = getScreenResolution()
	x = math.floor(w * iniData.position.varX)
	y = math.floor(h * iniData.position.varY)
end

--------------------------------------------------------------------------------

function setX(arg)
	if #arg ~= 0 and tonumber(arg) < 1.0 and tonumber(arg) > 0.0 then
		iniData.position.varX = tonumber(arg)
		writeSetting(true)
		sampAddChatMessage("[Online Checker] Nustatytas X kintamasis: {ff0000}" ..iniData.position.varX.." {b88d0f}/acsetx [0.0 - 1.0]", 0x1cd031)
	else
		sampAddChatMessage("[Online Checker] Neteisingai panaudota komanda, naudokite {b88d0f}/acsetx [0.0 - 1.0]", 0x1cd031)
	end
end

--------------------------------------------------------------------------------

function setY(arg)
	if #arg ~= 0 and tonumber(arg) < 1.0 and tonumber(arg) > 0.0 then
		iniData.position.varY = tonumber(arg)
		writeSetting(true)
		sampAddChatMessage("[Online Checker] Nustatytas Y kintamasis: {ff0000}" ..iniData.position.varY.." {b88d0f}/acsety [0.0 - 1.0]", 0x1cd031)
	else
		sampAddChatMessage("[Online Checker] Neteisingai panaudota komanda, naudokite {b88d0f}/acsety [0.0 - 1.0]", 0x1cd031)
	end
end

--------------------------------------------------------------------------------

function setTransparency(arg)
	if #arg ~= 0 and tonumber(arg) <= 255 and tonumber(arg) > 0 then
		iniData.position.transparency = tonumber(arg)
		writeSetting(true)
		sampAddChatMessage("[Online Checker] Nustatytas permatomumas: {ff0000}" ..iniData.position.transparency.." {b88d0f}/actransp [1 - 255]", 0x1cd031)
	else
		sampAddChatMessage("[Online Checker] Neteisingai panaudota komanda, naudokite {b88d0f}/actransp [1 - 255]", 0x1cd031)
	end
end

--------------------------------------------------------------------------------

function infoMsg()
	sampAddChatMessage("----------------------------------------------------------------------------------------", 0x1cd031)
	sampAddChatMessage("[Online Checker] {34eb37}Ijungti {1cd031}/ {ff0000}isjungti {1cd031}script: {b88d0f}/ac", 0x1cd031)
	sampAddChatMessage("[Online Checker] {34eb37}Prideti {1cd031}zmogu i sarasa: {b88d0f}/acadd Vardas_Pavarde", 0x1cd031)
	sampAddChatMessage("[Online Checker] {ff0000}Istrinti {1cd031}zmogu is saraso: {b88d0f}/acdelete Vardas_Pavarde", 0x1cd031)
	sampAddChatMessage("[Online Checker] Pakeisti teksto {b88d0f}X {1cd031}lokacija: {b88d0f}/acsetx [0.0 - 1.0]", 0x1cd031)
	sampAddChatMessage("[Online Checker] Pakeisti teksto {b88d0f}Y {1cd031}lokacija: {b88d0f}/acsety [0.0 - 1.0]", 0x1cd031)
	sampAddChatMessage("[Online Checker] Pakeisti teksto {b88d0f}permatomuma {1cd031}(rekomenduojama palikti 255): {b88d0f}/acsety [1 - 255]", 0x1cd031)
	sampAddChatMessage("----------------------------------------------------------------------------------------", 0x1cd031)
end

--------------------------------------------------------------------------------
