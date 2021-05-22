script_name('Loterija i /admin')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local json = require 'lib.jsoncfg'
local mad = require 'MoonAdditions'
local game = {}
local results = {}
local enable = false
local mainCfg = {
    settings = {enable = true, debug = false},
    position = {
        varX = 0.8,
        varY = 0.98,
        transparency = 255
    }
}
local x = 0
local y = 0
local min = 0
local max = 1000
local usertextdraw = {}
local debug = true
local u = 0 -- don't delete
local randomNumber = -5
local testMode = 'pokalbis'
local msgPresets = {
    test = {'%u%l+_%u%l+: {FFFFFF}%(%d+%) {FFFFFF}%d+', '%) {FFFFFF}%d+'},
    real = {'%u%l+_%u%l+ %(%d+%) administratoriams: %d+', 'administratoriams: %d+'},
    pokalbis = {'%(%d+%) %u%l+_%u%l+: %d+', ': %d+'}
}
local allString = '%u%l+_%u%l+ %(%d+%) administratoriams: %d+'
local filter = 'administratoriams: %d+'
--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    -- if not doesFileExist(getGameDirectory() .. '//moonloader//config//adminEvent//game.json') then
    --     json.write(getGameDirectory() .. '//moonloader//config//adminEvent//game.json', allowedJson)
    --     sampAddChatMessage('sukuriamas json failas', -1)
    -- end
    -- game = json.read(getGameDirectory() .. '//moonloader//config//adminEvent//game.json')
    -- results = json.read(getGameDirectory() .. '//moonloader//config//adminEvent//results.json')
    screenRes()
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('lstart')
        if not cmdResult then
            local result = sampRegisterChatCommand('lstart', toggleScript)
        end
        local cmdResult = sampIsChatCommandDefined('lmin')
        if not cmdResult then
            local result = sampRegisterChatCommand('lmin', setMin)
        end
        local cmdResult = sampIsChatCommandDefined('lmax')
        if not cmdResult then
            local result = sampRegisterChatCommand('lmax', setMax)
        end
        local cmdResult = sampIsChatCommandDefined('print')
        if not cmdResult then
            local result = sampRegisterChatCommand('print', printerinti)
        end
        local cmdResult = sampIsChatCommandDefined('lstop')
        if not cmdResult then
            local result = sampRegisterChatCommand('lstop', lotteryResults)
        end
        local cmdResult = sampIsChatCommandDefined('lreset')
        if not cmdResult then
            local result = sampRegisterChatCommand('lreset', resetAll)
        end
        local cmdResult = sampIsChatCommandDefined('lresetscore')
        if not cmdResult then
            local result = sampRegisterChatCommand('lresetscore', resetTheScore)
        end
        local cmdResult = sampIsChatCommandDefined('linfo')
        if not cmdResult then
            local result = sampRegisterChatCommand('linfo', informacinesZinutes)
        end
        local cmdResult = sampIsChatCommandDefined('lwin')
        if not cmdResult then
            local result = sampRegisterChatCommand('lwin', winners)
        end
        local cmdResult = sampIsChatCommandDefined('ltest')
        if not cmdResult then
            local result = sampRegisterChatCommand('ltest', testToggle)
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    enable = not enable
    if enable then
        sampAddChatMessage(
            ltu('[Loterija] Žaidimas {16f534}įjungtas. {b88d0f}(cmd: /loterija, /lmin [>0], /lmax [>lmin])'),
            0x1cd031
        )
        -- sampSendChat(ltu('Pradedam žaidimą'))
        textAdd()
        randomNumber = random(min, max)
        local testavimas = false
        for i = 1, 100 do
            if randomNumber <= min or randomNumber >= max then
                randomNumber = random(min, max)
            else
                break
            end
        end
        printString('random skaicius: ' .. randomNumber, 2000)
        sampSendChat(
            ltu(
                --[[ /s  ]]'/s [Loterija] START. Atspėk skaičių tarp ' ..
                    min .. ' - ' .. max .. ' į /p(1-10) (skaičius). PVZ.: /p1 69'
            )
        )
    else
        sampAddChatMessage(
            ltu('[Loterija] Žaidimas {ff0000}išjungtas. {b88d0f}(cmd: /loterija, /lmin [>0], /lmax [>lmin])'),
            0x1cd031
        )
        textDelete()
    end
end

function printerinti()
    for i = 1, #game do
        sampAddChatMessage('zaidejas: ' .. game[i].nickname .. ' spejimas: ' .. game[i].guess, -1)
    end
end

function setMin(arg)
    if #arg ~= 0 then
        min = tonumber(arg)
        sampAddChatMessage('Naujas MIN: ' .. min, 0x1cd031)
    else
        sampAddChatMessage('Dabartinis MIN: ' .. min, 0x1cd031)
    end
end

function setMax(arg)
    if #arg ~= 0 then
        max = tonumber(arg)
        sampAddChatMessage('Naujas MAX: ' .. max, 0x1cd031)
    else
        sampAddChatMessage('Dabartinis MAX: ' .. max, 0x1cd031)
    end
end

function resetAll()
    game = {}
    -- results = {}
    -- json.write(getGameDirectory() .. '//moonloader//config//adminEvent//results.json', results)
    json.write(getGameDirectory() .. '//moonloader//config//adminEvent//game.json', game)
    sampAddChatMessage(ltu('[Loterija] Spėjimai išvalyti'), -1)
    textDelete()
end

function winners()
    results = json.read(getGameDirectory() .. '//moonloader//config//adminEvent//results.json')
    local laimetojas = 0
    local iterator = {}
    local kiekPoziciju = 3
    if results ~= {} and results ~= nil then
        for i = 1, #results do
            if results[i].score >= laimetojas then
                laimetojas = results[i].score
                table.insert(iterator, i)
            end
            
        end
        
        for k = 1, #iterator do
            if k > kiekPoziciju - 1 then break end --gal nereik -1
            local asd = k - 1
        sampAddChatMessage(
            ltu(
                '[Loterija] '.. k ..' vieta: ' ..
                    results[iterator[#iterator-asd]].nickname .. ' surinko taškų: ' .. results[iterator[#iterator-asd]].score
            ),
            -1
        )
        
        end
        sampAddChatMessage(ltu('[Loterija] Išviso dalyvių: '..table.getn(results)), -1)
        
    else
        sampAddChatMessage('Nera rezultatu', -1)
    end
end
--------------------------------------------------------------------------------

function sampev.onServerMessage(color, msg)
    if enable then
        if testMode == 'test' then
            allString = msgPresets.test[1]
            filter = msgPresets.test[2]
        elseif testMode == 'admin' then
            allString = msgPresets.real[1]
            filter = msgPresets.real[2]
        elseif testMode == 'pokalbis' then
            allString = msgPresets.pokalbis[1]
            filter = msgPresets.pokalbis[2]
        end
        -- if string.find(msg, '%u%l+_%u%l+ %(%d+%) administratoriams: %d+') then           -- sita naudoti galutinej versijoj
        -- local spejimas = string.match(msg, 'administratoriams: %d+')
        if string.find(msg, allString) then -- siti du TESTAMS
            ----------------------- nick atpazinimas
            local spejimas = string.match(msg, filter)
            spejimas = string.match(spejimas, '%d+')
            local nickas = string.match(msg, '%u%l+_%u%l+')
            if debug then
                sampAddChatMessage('radau: ' .. nickas .. ' spejimas: ' .. spejimas, -1)
            end
            local tikrinimas = true
            -- Testavimui commentinti:
            for i = 1, #game do
                if game[i].nickname == nickas then
                    tikrinimas = false
                    if debug then
                        sampAddChatMessage('radau pasikartojanti nick: ' .. nickas, -1)
                    end
                    break
                end
            end
            local insertGuess = tonumber(spejimas)
            if tikrinimas then
                if insertGuess > 0 and insertGuess <= 1000 then
                    local ideti = {
                        nickname = nickas,
                        guess = insertGuess
                    }
                    table.insert(game, ideti)
                    json.write(getGameDirectory() .. '//moonloader//config//adminEvent//game.json', game)
                    textDelete()
                    textAdd()
                    if debug then
                        sampAddChatMessage('idejau i lentele', -1)
                    end
                end
            end
        ----------------------- mechanics
        end
    end
    -- Emilis_Evil (112) administratoriams: test
end

function testToggle()
    testMode = not testMode
    if testMode then
        sampAddChatMessage('[Loterija] Ijungtas {FF0000}testavimo{FFFFFF} rezimas.', -1)
    else
        sampAddChatMessage('[Loterija] Ijungtas {00FF00}oficialus{FFFFFF} rezimas.', -1)
    end
end

function informacinesZinutes()
    sampAddChatMessage('/lstart /lstop /lreset /lresetscore /lmin /lmax /lwin', -1)
end

function lotteryResults()
    if enable then
        -- if results == nil then
        --     sampAddChatMessage('tuscias', -1)
        --     return
        -- else
        --     sampAddChatMessage(results, -1)
        --     return
        -- end
        enable = false
        sampAddChatMessage(ltu('[Loterija] Žaidimas stabdomas. Teisingas spėjimas buvo: '..randomNumber), -1)
        results = json.read(getGameDirectory() .. '//moonloader//config//adminEvent//results.json')
        for i = 1, #game do
            if results ~= nil and results ~= {} then
                local naujoIterpimas = true
                for j = 1, #results do
                    if game[i].nickname == results[j].nickname then
                        naujoIterpimas = false
                        local scoreSkirtumas = math.abs(randomNumber - math.abs(game[i].guess))
                        local pridetiTasku = 0
                        if scoreSkirtumas >= 0 and scoreSkirtumas <= 100 then
                            pridetiTasku = 100 - scoreSkirtumas
                        end
                        results[j].score = results[j].score + pridetiTasku
                        json.write(getGameDirectory() .. '//moonloader//config//adminEvent//results.json', results)
                        break
                    end
                end
                if naujoIterpimas then
                    local scoreSkirtumas = math.abs(randomNumber - math.abs(game[i].guess))
                    local pridetiTasku = 0
                    if scoreSkirtumas >= 0 and scoreSkirtumas <= 100 then
                        pridetiTasku = 100 - scoreSkirtumas
                    end
                    local ideti = {
                        nickname = game[i].nickname,
                        score = pridetiTasku
                    }
                    table.insert(results, ideti)
                    json.write(getGameDirectory() .. '//moonloader//config//adminEvent//results.json', results)
                end
            elseif results == {} or results == nil then
                results = {}
                for i = 1, #game do
                    local scoreSkirtumas = math.abs(randomNumber - math.abs(game[i].guess))
                    local pridetiTasku = 0
                    if scoreSkirtumas >= 0 and scoreSkirtumas <= 100 then
                        pridetiTasku = 100 - scoreSkirtumas
                    end
                    local ideti = {
                        nickname = game[i].nickname,
                        score = pridetiTasku
                    }
                    table.insert(results, ideti)
                    json.write(getGameDirectory() .. '//moonloader//config//adminEvent//results.json', results)
                end
            end
        end
    else
        sampAddChatMessage('nebuvo pradetas zaidimas', -1)
    end
end

function resetTheScore()
    results = {
        {nickname = 'Emilis_Evil', score = 0}
    }
    -- results = {}
    -- json.write(getGameDirectory() .. '//moonloader//config//adminEvent//results.json', results)
    json.write(getGameDirectory() .. '//moonloader//config//adminEvent//results.json', results)
    sampAddChatMessage(ltu('[Loterija] {FF0000}Rezultatai {FFFFFF}išvalyti'), -1)
    textDelete()
    resetAll()
end

function textAdd()
    local yChange = -17
    for i = 1, #game do
        if i <= 40 then
            usertextdraw[i] = mad.textdraw.new(game[i].nickname .. '_(' .. game[i].guess .. ')', x, y)
        elseif i > 40 then
            usertextdraw[i] = mad.textdraw.new(game[i].nickname .. '_(' .. game[i].guess .. ')', x - 20, y)
        end
        y = y + yChange
        if y <= 220 then
            if mainCfg.position.varX >= 0.2 then
                mainCfg.position.varX = mainCfg.position.varX - 0.2
            end
            screenRes()
        end
        --nametextdraw[i].style = mad.font_style.PRICEDOWN
        usertextdraw[i].width = 0.6
        usertextdraw[i].height = 0.85
        usertextdraw[i]:set_text_color(255, 255, 255, mainCfg.position.transparency)
        if mainCfg.position.transparency < 255 then
            usertextdraw[i].outline = 0
        else
            usertextdraw[i].outline = 1
        end
        usertextdraw[i].background = false
        usertextdraw[i].wrap = 250
    end
end

function textDelete()
    for i = 1, #usertextdraw do
        usertextdraw[i].text = ''
    end
    usertextdraw = {}
    screenRes()
end

--[[ Colors:
{ff0000} - raudona
{1cd031} - default zalia kaip serve
{16f534} - zalia, ryskesne
{b88d0f} - oranzine, komandu paaiskinimas
]]
function random(x, y)
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x + (math.random(math.randomseed(os.time() + u)) * 999999 % y))
    else
        return math.floor((math.random(math.randomseed(os.time() + u)) * 100))
    end
end

-- Example --

-- for i = 1, 1 do
--     print(random(-5, 25)) -- Call the random number genorator by doing this
-- end

function screenRes()
    local w, h = getScreenResolution()
    x = math.floor(w * mainCfg.position.varX)
    y = math.floor(h * mainCfg.position.varY)
end

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
