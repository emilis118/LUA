script_name('SprintHook')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local vk = require 'lib.vkeys'
local iniData = {}
local mainCfg = {
    settings = {
        enable = true,
        fakeSpeed = true,
        onlyMafia = false
    }
}
local max = 0

--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    if not doesFileExist(getGameDirectory() .. '//moonloader//config//sprintHook//settings.ini') then
        local iniBool = inicfg.save(mainCfg, 'sprintHook/settings')
    end
    iniData = inicfg.load(mainCfg, 'sprintHook/settings')
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('sprint')
        if not cmdResult then
            local result = sampRegisterChatCommand('sprint', toggleScript)
        end
        if not isCharInAnyCar(PLAYER_PED) then
            if isKeyDown(vk.VK_W) and isKeyDown(vk.VK_SPACE) and iniData.settings.enable then
                -- printString("Hook",200)
                local random = math.random(1, 3)
                if random == 2 or random == 3 then
                    setGameKeyState(16, 8)
                else
                    setGameKeyState(16, 0)
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    iniData.settings.enable = not iniData.settings.enable
    max = 0.0
    writeSetting(false)
end

function sampev.onSendPlayerSync(data)
    local runningMode = 0
    local x = data.moveSpeed.x
    local y = data.moveSpeed.y
    local z = data.moveSpeed.z

    local speed = math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
    if max < speed then
        max = speed
    end
    -- ON:
    -- 0.1604 paprastai begant
    -- 0.1969 stojant
    -- 0.2492 suolis

    -- OFF:
    -- 0.1259 paprastai begant
    -- 0.1969 stojant
    -- 0.3032 suolis

    if --[[ z >= -0.01 and  ]] isKeyDown(vk.VK_SHIFT) and isKeyDown(vk.VK_SPACE) then
        runningMode = 2 -- suolis
    elseif --[[ z >= -0.01 and ]] isKeyDown(vk.VK_SPACE) then
        runningMode = 1 -- begimas su space
    end

    if runningMode == 1 and iniData.settings.enable then
        if math.abs(x) >= math.abs(y) then
            if x >= 0 then
                data.moveSpeed.x = data.moveSpeed.x - 0.08
                sampAddChatMessage(data.moveSpeed.x, -1)
            else
                data.moveSpeed.x = data.moveSpeed.x + 0.08
                sampAddChatMessage(data.moveSpeed.x, -1)
            end
        else
            if y >= 0 then
                data.moveSpeed.y = data.moveSpeed.y - 0.08
                sampAddChatMessage(data.moveSpeed.y, -1)
            else
                data.moveSpeed.y = data.moveSpeed.y + 0.08
                sampAddChatMessage(data.moveSpeed.y, -1)
            end
        end
    end
    local newSpeed = math.sqrt(data.moveSpeed.x^2 + data.moveSpeed.y^2 + data.moveSpeed.z^2)
    local skirtumas = speed - newSpeed
    -- if iniData.settings.enable then
    -- printString(
    --     string.format(
    --         '~g~ON ~w~Speed: ~r~%.4f ~w~MAX: ~r~%.4f ~w~RUN: %d ~w~x: ~g~%.4f ~w~y: ~g~%.4f ~w~z: ~g~%.4f ~w~new: ~g~%.4f',
    --         speed,
    --         max,
    --         runningMode,
    --         x,
    --         y,
    --         z,
    --         skirtumas
    --     ),
    --     200
    -- )
    -- else
    --     printString(string.format('~r~OFF ~w~Speed: ~r~%.4f ~w~MAX: ~r~%.4f', speed, max), 200)
    -- end
end

--------------------------------------------------------------------------------
-- Ini failo apdirbimas

--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'sprintHook/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[] Nustatymai ??ra??yti.'), 0x1cd031)
    end
    --iniData = inicfg.load(nil, "sprintHook/settings") -- nlb gerai sitas
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
