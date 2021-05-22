script_name ("Pro Pzu")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local mad = require 'MoonAdditions'
local iniData = {}
local mainCfg = {
	settings = {
		enable = true,
		drawHp = true,
		drawAp = true,
		drawPing = true,
		drawLos = true,
		drawFps = true,
		drawCarHp = true,
	},
	position = {
		varX = 0.99,
		varY = 0.5,
		varDelta = 20,
		transparency = 255,
	},
}
local pzuState = false
local pzuPlayerId = 0
local pzuCarId = 0
local nick = "Vardas_Pavarde"
local hp = 0
local ap = 0
local weapon = 0
local carHp = 0
local ping = 0
local fps = 0
local loss = 0
local drawToggle = true
local textAdded = false

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//proPzu//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "proPzu/settings")
	end
	iniData = inicfg.load(mainCfg, "proPzu/settings")

	screenRes()	-- gauna screen resolutiona

	textAdd()
	nick_textdraw.text = ""
	hp_textdraw.text = ""
	ap_textdraw.text = ""
	ping_textdraw.text = ""
	fps_textdraw.text = ""
	loss_textdraw.text = ""
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("propzu")
		if not cmdResult then
			local result = sampRegisterChatCommand("propzu", toggleScript)
		end
		if pzuState and drawToggle then  -- nupiesia texta
			drawToggle = false
			textAdded = true
		elseif not pzuState and not drawToggle then
			textAdded = false
			drawToggle = true
		end
		if pzuState and textAdded and iniData.settings.enable then
			if spectatingType == "player" then
				nick_textdraw.text = nick
				if iniData.settings.drawHp then hp_textdraw.text = "HP:_~r~"..hp end
				if iniData.settings.drawAp then ap_textdraw.text = "Armour:_~b~"..ap end
				if iniData.settings.drawPing then
					if tonumber(ping) < 60 then
						ping_textdraw.text = "PING:_~g~"..ping
					else
						ping_textdraw.text = "PING:_~r~"..ping
					end
				end
				if iniData.settings.drawFps then
					if tonumber(fps) > 40 then
						fps_textdraw.text = "FPS:_~g~"..fps
					else
						fps_textdraw.text = "FPS:_~r~"..fps
					end
				end
				if iniData.settings.drawLos then
					if tonumber(loss) < 1.01 then
						loss_textdraw.text = "Lost:_~g~"..loss
					else
						loss_textdraw.text = "Lost:_~r~"..loss
					end
				end
			end
			--[[
			if spectatingType == "car" then
				nick_textdraw.text = "Name:_"..nick
				if iniData.settings.drawHp then hp_textdraw.text = "HP:_~r~"..carHp end
				if iniData.settings.drawPing then ping_textdraw.text = "PING:_~r~"..ping end
				if iniData.settings.drawFps then fps_textdraw.text = "FPS:_~r~"..fps end
				if iniData.settings.drawLos then loss_textdraw.text = "Lost:_~r~"..loss end
			end
			]]
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
	iniData.settings.enable = not iniData.settings.enable
	if iniData.settings.enable then
		sampAddChatMessage("[PRO PZU] {16f534}Ijungtas.", 0x1cd031)
	else
		sampAddChatMessage("[PRO PZU] {ff0000}Isjungtas.", 0x1cd031)
	end
	writeSetting(true)
end

--------------------------------------------------------------------------------
-- Ini failo apdirbimas

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "proPzu/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[PRO PZU] Nustatymai irasyti.", 0x1cd031) end
	--iniData = inicfg.load(nil, "proPzu/settings") -- nlb gerai sitas
end

--------------------------------------------------------------------------------

function sampev.onTogglePlayerSpectating(state)
	if state then pzuState = true else
		pzuState = false
		nick_textdraw.text = ""
		hp_textdraw.text = ""
		ap_textdraw.text = ""
		ping_textdraw.text = ""
		fps_textdraw.text = ""
		loss_textdraw.text = ""
	end
end

--------------------------------------------------------------------------------

function sampev.onSpectatePlayer(playerId, camType)
	if pzuState then pzuPlayerId = playerId spectatingType = "player" end
end

--------------------------------------------------------------------------------

function sampev.onSpectateVehicle(vehicleId, camType)
	if pzuState then pzuCarId = vehicleId spectatingType = "car" end
end

--------------------------------------------------------------------------------

function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
	if pzuState and attachedPlayerId == pzuPlayerId then
		nick = sampGetPlayerNickname(attachedPlayerId)
	end
	if attachedPlayerId == pzuPlayerId then
		if string.find(text, "FPS: %d+") then
			fps = string.match(text, "FPS: %d+")
			fps = string.match(fps, "%d+")
		end
		if string.find(text, "%d%.%d+") then
			loss = string.match(text, "%d%.%d+")
		end
		if string.find(text, "PING: %d+") then
			ping = string.match(text, "PING: %d+")
			ping = string.match(ping, "%d+")
		end
		if iniData.settings.enable then return false end
	end
end

--------------------------------------------------------------------------------

function screenRes()
	local w, h = getScreenResolution()
	x = math.floor(w * iniData.position.varX)
	y = math.floor(h * iniData.position.varY)
end

--------------------------------------------------------------------------------

function textAdd()
	nick_textdraw = mad.textdraw.new("Name_"..nick, x, y)
	nick_textdraw.width = 0.6
	nick_textdraw.height = 0.85
	nick_textdraw:set_text_color(255, 255, 255, iniData.position.transparency)
	if iniData.position.transparency < 255 then nick_textdraw.outline = 0 else nick_textdraw.outline = 1 end
	nick_textdraw.background = false
	nick_textdraw.wrap = 500
	nick_textdraw.alignment = 2
	--y = y +n * iniData.position.varDelta

	if iniData.settings.drawHp then
		hp_textdraw = mad.textdraw.new("HP:_"..hp, x, y+1*iniData.position.varDelta)
		hp_textdraw.width = 0.6
		hp_textdraw.height = 0.85
		hp_textdraw:set_text_color(255, 255, 255, iniData.position.transparency)
		if iniData.position.transparency < 255 then hp_textdraw.outline = 0 else hp_textdraw.outline = 1 end
		hp_textdraw.background = false
		hp_textdraw.wrap = 500
		hp_textdraw.alignment = 2
	end
	if iniData.settings.drawAp then
		ap_textdraw = mad.textdraw.new("Armour:_"..ap, x, y+2*iniData.position.varDelta)
		ap_textdraw.width = 0.6
		ap_textdraw.height = 0.85
		ap_textdraw:set_text_color(255, 255, 255, iniData.position.transparency)
		if iniData.position.transparency < 255 then ap_textdraw.outline = 0 else ap_textdraw.outline = 1 end
		ap_textdraw.background = false
		ap_textdraw.wrap = 500
		ap_textdraw.alignment = 2
	end
	if iniData.settings.drawFps then
		fps_textdraw = mad.textdraw.new("FPS:_"..fps, x, y+3*iniData.position.varDelta)
		fps_textdraw.width = 0.6
		fps_textdraw.height = 0.85
		fps_textdraw:set_text_color(255, 255, 255, iniData.position.transparency)
		if iniData.position.transparency < 255 then fps_textdraw.outline = 0 else fps_textdraw.outline = 1 end
		fps_textdraw.background = false
		fps_textdraw.wrap = 500
		fps_textdraw.alignment = 2
	end
	if iniData.settings.drawPing then
		ping_textdraw = mad.textdraw.new("PING:_"..ping, x, y+4*iniData.position.varDelta)
		ping_textdraw.width = 0.6
		ping_textdraw.height = 0.85
		ping_textdraw:set_text_color(255, 255, 255, iniData.position.transparency)
		if iniData.position.transparency < 255 then ping_textdraw.outline = 0 else ping_textdraw.outline = 1 end
		ping_textdraw.background = false
		ping_textdraw.wrap = 500
		ping_textdraw.alignment = 2
	end
	if iniData.settings.drawLos then
		loss_textdraw = mad.textdraw.new("Lost:_"..loss, x, y+5*iniData.position.varDelta)
		loss_textdraw.width = 0.6
		loss_textdraw.height = 0.85
		loss_textdraw:set_text_color(255, 255, 255, iniData.position.transparency)
		if iniData.position.transparency < 255 then loss_textdraw.outline = 0 else loss_textdraw.outline = 1 end
		loss_textdraw.background = false
		loss_textdraw.wrap = 500
		loss_textdraw.alignment = 2
	end
end

--------------------------------------------------------------------------------

function textDelete()
	if nick_textdraw ~= nil then
		nick_textdraw.text = ""
		hp_textdraw.text = ""
		ap_textdraw.text = ""
		ping_textdraw.text = ""
		fps_textdraw.text = ""
		loss_textdraw.text = ""
	end
end

--------------------------------------------------------------------------------

function sampev.onPlayerSync(playerId, data)
	if pzuState and pzuPlayerId == playerId and spectatingType == "player" then
		hp = data.health
		ap = data.armor
		weapon = data.weapon
	end
end

--------------------------------------------------------------------------------

function sampev.onVehicleSync(vehicleId, data)
	if pzuState and pzuCarId == vehicleId and spectatingType == "car" then
		carHp = data.vehicleHealth
	end
end

--------------------------------------------------------------------------------
--[[ Colors:
{ff0000} - raudona
{1cd031} - default zalia kaip serve
{16f534} - zalia, ryskesne
{b88d0f} - oranzine, komandu paaiskinimas
]]
