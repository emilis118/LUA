script_name ("Moderator counter")
script_version("1.0")
script_author("Emilis")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
	settings = {enable = true},
	counters = {
		jail = 0,
		mute = 0,
		unjail = 0,
		unmute = 0,
		kick = 0,
		ban = 0,
		banx = 0,
		unban = 0,
		blist = 0,
		unblist = 0,
		pzu = 0,
	},
	teleports = {
		tpsf = 0,
		tpls = 0,
		tplv = 0,
		tpdrag = 0,
		tpvip = 0,
		tpadmin = 0,
		tpd = 0,
		tpm = 0,
		tpcage = 0,
		tpdrift = 0,
		tpdrift1 = 0,
		tpswim = 0,
		tpswimend = 0,
		tpkalnas = 0,
		tprace = 0,
	}
}

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//ModCounter//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "ModCounter/settings")
	end
	iniData = inicfg.load(mainCfg, "ModCounter/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("modcounter")
		if not cmdResult then
			local result = sampRegisterChatCommand("modcounter", showCount)
		end
		local cmdResult = sampIsChatCommandDefined("tpcounter")
		if not cmdResult then
			local result = sampRegisterChatCommand("tpcounter", teleCount)
		end
	end
end

--------------------------------------------------------------------------------

function showCount(arg)
	if arg == "toggle" then iniData.settings.enable = not iniData.settings.enable writeSetting(false) end
	if #arg == 0 then
		sampAddChatMessage("--------------------------------------------------", 0x1cd031)
		sampAddChatMessage("[MOD Counter] Atlikta veiksmu:", 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/jail {1cd031}count: {e01929}"..iniData.counters.jail, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/mute {1cd031}count: {e01929}"..iniData.counters.mute, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/unjail {1cd031}count: {e01929}"..iniData.counters.unjail, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/unmute {1cd031}count: {e01929}"..iniData.counters.unmute, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/kick {1cd031}count: {e01929}"..iniData.counters.kick, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/ban {1cd031}count: {e01929}"..iniData.counters.ban, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/banx {1cd031}count: {e01929}"..iniData.counters.banx, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/unban {1cd031}count: {e01929}"..iniData.counters.unban, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/blist {1cd031}count: {e01929}"..iniData.counters.blist, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/unblist {1cd031}count: {e01929}"..iniData.counters.unblist, 0x1cd031)
		sampAddChatMessage("[MOD Counter] {eb6b34}/pzu {1cd031}count: {e01929}"..iniData.counters.pzu, 0x1cd031)
		sampAddChatMessage("--------------------------------------------------", 0x1cd031)
	end
end

--------------------------------------------------------------------------------

function teleCount()
	sampAddChatMessage("--------------------------------------------------", 0x1cd031)
	sampAddChatMessage("[Teleport Counter] Atlikta teleport:", 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpsf {1cd031}count: {e01929}"..iniData.teleports.tpsf, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpls {1cd031}count: {e01929}"..iniData.teleports.tpls, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tplv {1cd031}count: {e01929}"..iniData.teleports.tplv, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpd {1cd031}count: {e01929}"..iniData.teleports.tpd, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpm {1cd031}count: {e01929}"..iniData.teleports.tpm, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpvip {1cd031}count: {e01929}"..iniData.teleports.tpvip, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpadmin {1cd031}count: {e01929}"..iniData.teleports.tpadmin, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpdrag {1cd031}count: {e01929}"..iniData.teleports.tpdrag, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpdrift {1cd031}count: {e01929}"..iniData.teleports.tpdrift, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpdrift1 {1cd031}count: {e01929}"..iniData.teleports.tpdrift1, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpcage {1cd031}count: {e01929}"..iniData.teleports.tpcage, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpswim {1cd031}count: {e01929}"..iniData.teleports.tpswim, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpswimend {1cd031}count: {e01929}"..iniData.teleports.tpswimend, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tpkalnas {1cd031}count: {e01929}"..iniData.teleports.tpkalnas, 0x1cd031)
	sampAddChatMessage("[Teleport Counter] {eb6b34}/tprace {1cd031}count: {e01929}"..iniData.teleports.tprace, 0x1cd031)
	sampAddChatMessage("--------------------------------------------------", 0x1cd031)
end

--------------------------------------------------------------------------------

function sampev.onSendCommand(cmd)
	if not iniData.settings.enable then return end
	if string.find(cmd, "/jail") then iniData.counters.jail = iniData.counters.jail + 1 end
	if string.find(cmd, "/mute") then iniData.counters.mute = iniData.counters.mute + 1 end
	if string.find(cmd, "/unjail") then iniData.counters.unjail = iniData.counters.unjail + 1 end
	if string.find(cmd, "/unmute") then iniData.counters.unmute = iniData.counters.unmute + 1 end
	if string.find(cmd, "/kick") or string.find(cmd, "/akick") then iniData.counters.kick = iniData.counters.kick + 1 end
	if string.find(cmd, "/ban") or string.find(cmd, "/aban") then iniData.counters.ban = iniData.counters.ban + 1 end
	if string.find(cmd, "/banx") then iniData.counters.banx = iniData.counters.banx + 1 end
	if string.find(cmd, "/unban") then iniData.counters.unban = iniData.counters.unban + 1 end
	if string.find(cmd, "/unblist") then iniData.counters.unblist = iniData.counters.unblist + 1 end
	if string.find(cmd, "/blist") then iniData.counters.blist = iniData.counters.blist + 1 end
	if string.find(cmd, "/pzu") then iniData.counters.pzu = iniData.counters.pzu + 1 end
	if string.find(cmd, "/tpsf") then iniData.teleports.tpsf = iniData.teleports.tpsf + 1 end
	if string.find(cmd, "/tpls") then iniData.teleports.tpls = iniData.teleports.tpls + 1 end
	if string.find(cmd, "/tplv") then iniData.teleports.tplv = iniData.teleports.tplv + 1 end
	if string.find(cmd, "/tpd") then iniData.teleports.tpd = iniData.teleports.tpd + 1 end
	if string.find(cmd, "/tpm") then iniData.teleports.tpm = iniData.teleports.tpm + 1 end
	if string.find(cmd, "/tpvip") then iniData.teleports.tpvip = iniData.teleports.tpvip + 1 end
	if string.find(cmd, "/tpadmin") then iniData.teleports.tpadmin = iniData.teleports.tpadmin + 1 end
	if string.find(cmd, "/tpdrag") then iniData.teleports.tpdrag = iniData.teleports.tpdrag + 1 end
	if string.find(cmd, "/tpdrift") then iniData.teleports.tpdrift = iniData.teleports.tpdrift + 1 end
	if string.find(cmd, "/tpdrift1") then iniData.teleports.tpdrift1 = iniData.teleports.tpdrift1 + 1 end
	if string.find(cmd, "/tpcage") then iniData.teleports.tpcage = iniData.teleports.tpcage + 1 end
	if string.find(cmd, "/tpswim") then iniData.teleports.tpswim = iniData.teleports.tpswim + 1 end
	if string.find(cmd, "/tpswimend") then iniData.teleports.tpswimend = iniData.teleports.tpswimend + 1 end
	if string.find(cmd, "/tpkalnas") then iniData.teleports.tpkalnas = iniData.teleports.tpkalnas + 1 end
	if string.find(cmd, "/tprace") then iniData.teleports.tprace = iniData.teleports.tprace + 1 end
	writeSetting(false)
end

--------------------------------------------------------------------------------

function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "ModCounter/settings")
	if patvirtinimas and msgBool then sampAddChatMessage("[MOD Counter] Skaicius atnaujintas.", 0x1cd031) end
end
