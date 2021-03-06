script_name ("Money recolor")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local imgui = require 'mimgui'
local struct = require "lib.struct"
local m = imgui
local new = imgui.new
local ffi = require 'ffi'
local str, sizeof = ffi.string, ffi.sizeof
local iniData = {}
local mainCfg = {
	settings = {
        enable = true,
        r = 255,
        g = 0,
        b = 0,
        a = 255,
    }
}

local imgui_begin = new.bool()
local v_r = new.int(47)
local v_g = new.int(90)
local v_b = new.int(38)
local col = imgui.new.float (2.12)
local naujas 


local newFrame =
    imgui.OnFrame(
    function()
        return imgui_begin[0]
    end,
    function(player)
        imgui.Begin('Colours')
        imgui.Text('R:')
        m.SliderInt("##1",v_r,0,255)
        m.Spacing()
        imgui.Text('G:')
        m.SliderInt("##2",v_g,0,255)
        m.Spacing()
        imgui.Text('B:')
        m.SliderInt("##3",v_b,0,255)
        m.Spacing()
        m.Text('Picker:')
        m.ColorPicker3('##4',col)
		
		--writeMemory(0xBAB230, 4, hex, false)
        imgui.End()
    end
)

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	if not doesFileExist(getGameDirectory().."//moonloader//config//colours//settings.ini") then
		local iniBool = inicfg.save(mainCfg, "colours/settings")
	end
	iniData = inicfg.load(mainCfg, "colours/settings")
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("colour")
		if not cmdResult then
			local result = sampRegisterChatCommand("colour", toggleScript)
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript(arg)
    if #arg == 0 then
        imgui_begin[0] = not imgui_begin[0]
    end
    --sampAddChatMessage(naujas, -1)
    -- local r = tostring(col)
    -- if r ~= nil then
    -- sampAddChatMessage("nr: "..r, -1) -- 0x0e6257c0
    -- else
    --     sampAddChatMessage('nil', -1)
    -- end
    -- sampAddChatMessage("aaa: "..col, -1)
    -- local rgb = {v_b, v_g, v_r}
    -- local hex = rgbToHex(rgb)
    -- -- -- value = readMemory(0xBAB230, 4, false)
    -- -- -- sampAddChatMessage("aaa: "..value, -1)  -- default -13866954
    -- writeMemory(0xBAB230, 4, hex, false)
end

--------------------------------------------------------------------------------
-- Ini failo apdirbimas

--writeSetting(false)
function writeSetting(msgBool)
	patvirtinimas = inicfg.save(iniData, "colours/settings")
	if patvirtinimas and msgBool then sampAddChatMessage(ltu("[] Nustatymai ??ra??yti."), 0x1cd031) end
	--iniData = inicfg.load(nil, "colours/settings") -- nlb gerai sitas
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
		"\xc4\x85",	--??
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
	--?????????????????? ??????????????????
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[1]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[2]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[3]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[4]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[5]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[6]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[7]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[8]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[9]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[10]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[11]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[12]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[13]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[14]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[15]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[16]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[17]) end
	if string.find(text, "??") then text = string.gsub(text, "??", ltu[18]) end
	text = u8:decode(text)
	return text
end 

-- function rgbToHex(rgb)  -- {255, 255, 255}
-- 	local hexadecimal = '0X'

-- 	for key, value in pairs(rgb) do
-- 		local hex = ''

-- 		while(value > 0)do
-- 			local index = math.fmod(value, 16) + 1
-- 			value = math.floor(value / 16)
-- 			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
-- 		end

-- 		if(string.len(hex) == 0)then
-- 			hex = '00'

-- 		elseif(string.len(hex) == 1)then
-- 			hex = '0' .. hex
-- 		end

-- 		hexadecimal = hexadecimal .. hex
-- 	end

-- 	return hexadecimal
-- end