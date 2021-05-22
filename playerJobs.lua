script_name('Jobs')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local jobList = {
    'Taksistas (pirmos firmos)',
    'Taksistas (antros firmos)',
    'Mechanikas',
    'Medikas',
    'Apsauginis',
    'Narkotikų Prekeivis',
    'Ginklų Prekeivis',
    'Interpolas',
    'FTB',
    'Kareivis',
    'Policininkas',
    'Radistas',
    'Reporteris',
    'Tolimųjų reisų vairuotojas',
    'Cosa Nostra',
    'Immortal',
    'Varrios Los Aztecas',
    'Los Santos Vagos'
}
local collected = {}
for i = 1, 500 do
    collected[i] = {nickname = "V_P", job = "taxi1"}
end
local enable = false
local k = 0
local j = 0
local time = 0
local setTime = 0
local timeDefault = 400
--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('jscan')
        if not cmdResult then
            local result = sampRegisterChatCommand('jscan', toggleScript)
        end
        local cmdResult = sampIsChatCommandDefined('jimm')
        if not cmdResult then
            local result = sampRegisterChatCommand('jimm', showImmortals)
        end
        local cmdResult = sampIsChatCommandDefined('jcn')
        if not cmdResult then
            local result = sampRegisterChatCommand('jcn', showCosa)
        end
        -- local cmdResult = sampIsChatCommandDefined('jall')
        -- if not cmdResult then
        --     local result = sampRegisterChatCommand('jall', showAll)
        -- end
        if enable then
            time = getGameTimer()
            if setTime < time then
                setTime = getGameTimer() + timeDefault
                j = j + 1
                sampSendChat('/info ' .. j)
            end
            if j == id then
                enable = false
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    k = 0
    id = sampGetMaxPlayerId(false)
    sampAddChatMessage(ltu('[Player Jobs] Pradedam skenuoti žaidėjus.'), 0x1cd031)
    enable = true
end

--------------------------------------------------------------------------------

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    -- sampAddChatMessage('id: ' .. dialogId, -1)
    -- sampAddChatMessage('style: ' .. style, -1)
    -- sampAddChatMessage('title: ' .. title, -1)
    sampAddChatMessage('text: ' .. text, -1)
    if dialogId == 8888 and style == 0 --[[ and title == 'Žaidėjo informacija' ]] and enable then
        k = k + 1
        for i = 1, #jobList do
            if string.find(text, 'Darbas: ' .. jobList[i]) and string.find(text, '%u%l+_%u%l+') --[[ or moteriska lytis ]] then -- pamastyti del ltu raidyno
                collected[k].nickname = string.match(text, '%u%l+_%u%l+')
                collected[k].job = string.match(text, jobList[i])
                sampAddChatMessage('nick: ' .. collected[k].nickname .. '  job: ' .. collected[k].job, -1)
            end
        end
    end
end

--------------------------------------------------------------------------------

function showImmortals()
    sampShowDialog(444, ltu('Prisijungę IMMORTAL mafijos nariai'), countImm(), ltu('Uždaryti'), nil, 2)
end

--------------------------------------------------------------------------------

function showCosa()
    sampShowDialog(444, ltu('Prisijungę COSA mafijos nariai'), countCosa(), ltu('Uždaryti'), nil, 2)
end

--------------------------------------------------------------------------------

function countImm()
    local parseText = ''
    for i = 1, #collected do
        if collected[i].job == jobList[15] then
            parseText = parseText .. collected[i].nickname .. '\t' .. collected[i].job .. '\n'
        end
    end
    return parseText
end

--------------------------------------------------------------------------------

function countCosa()
    local parseText = ''
    for i = 1, #collected do
        if collected[i].job == jobList[14] then
            parseText = parseText .. collected[i].nickname .. '\t' .. collected[i].job .. '\n'
        end
    end
    return parseText
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
