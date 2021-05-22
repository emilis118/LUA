script_name('Pokalbiai')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local mad = require 'MoonAdditions'
local vk = require 'lib.vkeys'
local iniData = {}
local mainCfg = {
    settings = {
        enable = true
    },
    pokalbiai = {
        'TEST',
    },
    number = {
        1,
    }
}
local selector = 0
local nick_textdraw
local firstDraw = true
local x = 40
local y = 375

--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    if not doesFileExist(getGameDirectory() .. '//moonloader//config//pokalbiai//settings.ini') then
        local iniBool = inicfg.save(mainCfg, 'pokalbiai/settings')
    end
    iniData = inicfg.load(mainCfg, 'pokalbiai/settings')
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('pokalbiai')
        if not cmdResult then
            local result = sampRegisterChatCommand('pokalbiai', toggleScript)
        end
        if sampIsChatInputActive() and iniData.settings.enable then
            -- nupiesti pokalbio toggle
            showText(selector, true)
        else
            showText(selector, false)
        end
        -- if IsKeyDown(vk.VK_TAB) and wasKeyPressed(vk.VK_W) and sampIsChatInputActive() then selector = 0 end
        if wasKeyPressed(vk.VK_TAB) and sampIsChatInputActive() then
            if selector == #iniData.pokalbiai then
                selector = 0
            else
                selector = selector + 1
            end
        end
        if wasKeyPressed(vk.VK_LCONTROL) and sampIsChatInputActive() then
            selector = 0
        end
        -- if wasKeyPressed(vk.VK_TAB) and sampIsChatInputActive() then
        --     if selector == #iniData.pokalbiai then
        --         selector = 0
        --     else
        --         selector = selector + 1
        --     end
        -- end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript(arg)
    if #arg == 0 then
        sampSendChat('/pokalbiai')
    end
    if arg == 'toggle' then
        iniData.settings.enable = not iniData.settings.enable
        if iniData.settings.enable then
            sampAddChatMessage(
                ltu('[Pokalbiai] {16f534}Įjungti{1cd031}.  Išjungti su {b88d0f}/pokalbiai toggle.'),
                0x1cd031
            )
            sampAddChatMessage(ltu('[Pokalbiai] Nepamirškite nuskaityti pokalbių parašę {b88d0f}/pokalbiai.'), 0x1cd031)
        else
            sampAddChatMessage(
                ltu('[Pokalbiai] {ff0000}Išjungti{1cd031}. Įjungti su {b88d0f}/pokalbiai toggle'),
                0x1cd031
            )
        end
        writeSetting(true)
    end
end

--------------------------------------------------------------------------------

function sampev.onSendChat(msg)
    if selector == 0 then
        return
    end
    for i = 1, #iniData.pokalbiai do
        if selector == i then
            sampSendChat('/p' .. tostring(iniData.number[i]) .. ' ' .. msg)
            return false
        end
    end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if dialogId == 3401 and style == 2 and title == 'Pokalbiai' and iniData.settings.enable then
        iniData.pokalbiai = {}
        iniData.number = {}
        local k = 0
        for i = 1, 10 do
            if string.find(text, i .. '%. %a+') then
                k = k + 1
                local placeText = string.match(text, i .. '%. %a+')
                iniData.pokalbiai[k] = string.match(placeText, '%a+')
                iniData.number[k] = string.match(placeText, '%d+')
                -- sampAddChatMessage('Radau: ' .. iniData.pokalbiai[k] .. ' ir ' .. iniData.number[k], -1)
            end
        end
        writeSetting(false)
        sampAddChatMessage(ltu('[Pokalbiai] Nuskaityti pokalbiai, atnaujinta atmintis. Script prisimins vardus net po relog.'), 0x1cd031)
        sampAddChatMessage(ltu('[Pokalbiai] Primename, kad script galite {ff0000}išjungti {1cd031}parašę {b88d0f}/pokalbiai toggle'), 0x1cd031)
    end
end

function showText(i, showBool)
    if firstDraw and showBool then
        firstDraw = false
        if iniData.pokalbiai[i] ~= nil then
            nick_textdraw = mad.textdraw.new('Mode_' .. tostring(iniData.pokalbiai[i]), x, y)
        else
            nick_textdraw = mad.textdraw.new('Pokalbis:_~g~Chat', x, y)
        end
        nick_textdraw.width = 0.6
        nick_textdraw.height = 0.85
        nick_textdraw:set_text_color(255, 255, 255, 255)
        nick_textdraw.outline = 1
        nick_textdraw.background = false
        nick_textdraw.wrap = 250
    elseif showBool and nick_textdraw ~= nil then
        if i == 0 then
            nick_textdraw.text = 'Mode_~g~Chat'
        else
            nick_textdraw.text = 'Mode_~r~' .. tostring(iniData.pokalbiai[i])
        end
    elseif not showBool and nick_textdraw ~= nil then
        nick_textdraw.text = ''
    end
end
--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'pokalbiai/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[Pokalbiai] Nustatymai įrašyti.'), 0x1cd031)
    end
    --iniData = inicfg.load(nil, "pokalbiai/settings") -- nlb gerai sitas
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
