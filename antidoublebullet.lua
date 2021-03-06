script_name('double shot')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
    settings = {enable = true}
}
local watching
local oldtime = getGameTimer()
local memory = require 'memory'
--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('double')
        if not cmdResult then
            local result = sampRegisterChatCommand('double', toggleScript)
        end
        --0xB7CD98 0xB6F5F0
        -- local addr = 0x12AC6B24
        -- local addr = 0xB6F5F0 + 0x15C
        local addr = 0x12AC674C --anim state
        
        mem = readMemory(addr, 1, false)
        -- printString('memory: ' .. mem, 200)
        -- writeMemory(addr,1, 7,false)
        -- mem = readMemory(addr, 1, false)
        -- printString('memory: ' .. mem, 200)
        -- result = memory.setint8(addr, 7, false)
        writeMemory(addr,1,154,false)
        if result then
            printString('memory: ' .. mem .. ' sekmingai', 200)
        else
            printString('memory: ' .. mem .. ' nesekmingai', 200)
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript(arg)
    if #arg ~= 0 then
        watching = arg
        sampAddChatMessage('Stebimos ' .. arg .. ' kulkos', -1)
    end
end
-- targetType;
-- 	uint16_t  targetId;
-- 	VectorXYZ origin;
-- 	VectorXYZ target;
-- 	VectorXYZ center;
-- 	uint8_t   weaponId;


function sampev.onBulletSync(playerId, data)
    if watching ~= nil then
        if playerId == tonumber(watching) then
            sampAddChatMessage(
                'Target ID: ' .. data.targetId .. '; laikas nuo praeitos kulkos: ' .. getGameTimer() - oldtime .. ' ms.' --[[ '; origin x: '..data.origin.x..'; y:'..data.origin.y..'; z:'..data.origin.y ]],
                -1
            )
            oldtime = getGameTimer()
        end
    end
end
--------------------------------------------------------------------------------
-- Ini failo apdirbimas

--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'proInv/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[] Nustatymai ??ra??yti.'), 0x1cd031)
    end
    --iniData = inicfg.load(nil, "proInv/settings") -- nlb gerai sitas
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
        '\xc4\x85', --??
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
    --?????????????????? ??????????????????
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[1])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[2])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[3])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[4])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[5])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[6])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[7])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[8])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[9])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[10])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[11])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[12])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[13])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[14])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[15])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[16])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[17])
    end
    if string.find(text, '??') then
        text = string.gsub(text, '??', ltu[18])
    end
    text = u8:decode(text)
    return text
end
