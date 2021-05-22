script_name('play sound')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local json = require 'lib.jsoncfg'
local requests = require 'lib.requests'
local dlstatus = require('moonloader').download_status
local allowedNames = {
    {nick = 'Emilis_Evil', allow = true}
}
local data = {}
local iniData = {}
local mainCfg = {
    settings = {
        enable = true,
        neverPlay = true,
        neverPlayServer = true,
        firstTime = true
    }
}
local urlUse = 'http://emlsound.xyz/'
local version = 0.95
local sounds = {
    '!baranka',
    '!biski',
    '!inv',
    '!fart',
    '!gaujose',
    '!mikrafonas',
    '!nh',
    '!pornhub',
    '!supermena',
    '!motina',
    '!dvdoi',
    '!atsiprasau',
    '!hatoj',
    '!montagoaim',
    '!montagojiban',
    '!viskas',
    '!atsiprasai',
    '!kalantahaha',
    '!kralikas',
    '!pridurkas',
    '!sakyk',
    '!semkes',
    '!sliapa',
    '!urgz',
    '!vazonsninga',
    '!veipo',
    '!aciu',
    '!angar',
    '!bana',
    '!clap',
    '!dvduztenka',
    '!grybas',
    '!sninga',
    '!taiten',
    '!nerek',
    '!pavargimas',
    '!ptu',
    '!pdr',
    '!prisijunge',
    '!ginsit',
    '!borta',
    '!nebebus',
    '!vazonas',
    '!pagalbininkai',
    '!parukyt',
    '!skyle',
    '!smaukai',
    '!supratai',
    '!bekomentaru',
    '!bgalvi',
    '!pabazarink',
    '!varaisamp',
    '!neten',
    '!nuims',
    '!pica',
    '!pinigu',
    '!stoner',
    '!trch',
    '!zeniau',
    '!gaidzio',
    '!siuksle',
    '!sorry',
    '!dantim'
}
local soundsEml = {
    '!moan',
    '!liestis'
}

local result = false
local button = nil
local list = nil
local enableUpdate = false
local toggleUpdate = false
local index = nil
local green3 = false
local green4 = false
local k = 0
local enable = false
local chat = {
    '%[VIP%] ',
    '%[ADMIN%] ',
    '%[racija%] ',
    '%[%a+%]%(%d+%) ',
    '%[%a+%] ',
    '%*VIP ',
    '%*Admin '
    -- '%[Mod%] ',
    -- '%[G. Mod%] ',
    -- '%[DPKT%] ',
    -- '%[NGPT%] ',
    -- '%[AntiCheat%] ',
}
local response
local json_data, error
local stopScript = false
local limpMode = false
local allowedJson = {
    {nick = 'Test_Nick', toggle = false}
}
local naujoves = {
    '-------------------------------------------------------------------',
    '[Sounds] Naujovės:',
    '[Sounds] Nauji garsai: {b88d0f}!nuims !pica !pinigu !stoner !trch !zeniau !gaidzio !siuksle !sorry !dantim',
    '[Sounds] Atsirado paaiškinamasis pasirinkimas.',
    '-------------------------------------------------------------------'
}

co =
    coroutine.create(
    function()
        for i = 1, 2 do
            if i == 1 then
                response = requests.get('http://emlsound.xyz/accounts.json')
                json_data, error = response.json()
                response = requests.get('http://emlsound.xyz/version.ini')
                urlUse = 'http://emlsound.xyz/'
            end
            if i == 2 then
                printString('Alternatyvus serveris (/garsai)', 5000)
                response = requests.get('https://pimpalas.000webhostapp.com/accounts.json')
                json_data, error = response.json()
                response = requests.get('https://pimpalas.000webhostapp.com/version.ini')
                urlUse = 'https://pimpalas.000webhostapp.com/'
            end
            -- if i == 5 then
            -- stopScript = true
            -- end
            coroutine.yield()
        end
    end
)
--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()

    if stopScript then
        local scr = thisScript()
        scr:unload()
    end
    coroutine.resume(co)
    if response == nil and coroutine.status(co) ~= 'dead' then
        sampAddChatMessage(ltu('[Sounds] Bandome prisijungti iš naujo.'), -1)
        coroutine.resume(co)
    elseif coroutine.status(co) == 'dead' then
        limpMode = true
        sampAddChatMessage(ltu('[Sounds] Nepavyko prisijungti prie serverio.'), 0x1cd031)
        sampAddChatMessage(
            ltu('[Sounds] Script veiks saugumo režime - nepatikrinsim atnaujinimų ir girdėsit visus garsus.'),
            0x1cd031
        )
    elseif response ~= nil then
        enable = true
    end
    if not doesFileExist(getGameDirectory() .. '//moonloader//lib//effil.lua') then
        index =
            downloadUrlToFile(
            'http://emlsound.xyz/effil.lua',
            getGameDirectory() .. '//moonloader//lib//effil.lua',
            download_handler_lib
        )
        index =
            downloadUrlToFile(
            'http://emlsound.xyz/libeffil.dll',
            getGameDirectory() .. '//moonloader//lib//libeffil.dll',
            download_handler_lib
        )
    end
    if not doesFileExist(getGameDirectory() .. '//moonloader//config//sounds//settings.ini') then
        local iniBool = inicfg.save(mainCfg, 'sounds/settings')
    end
    iniData = inicfg.load(mainCfg, 'sounds/settings')

    if not doesFileExist(getGameDirectory() .. '//moonloader//config//sounds//allowed.json') then
        json.write(getGameDirectory() .. '//moonloader//config//sounds//allowed.json', allowedJson)
        sampAddChatMessage('sukuriamas json failas', -1)
    end
    allowedJson = json.read(getGameDirectory() .. '//moonloader//config//sounds//allowed.json')
    -- while true do

    -- end
    if enable then
        if version < tonumber(response.text) then
            sampAddChatMessage(
                ltu(
                    '[Sounds] {ff0000}Aptikta nauja versija. {1cd031}Tam, kad atnaujinti pasirinkite "Atnaujinti" {b88d0f}/garsai {1cd031}lentelėje.'
                ),
                0x1cd031
            )
            toggleUpdate = true
        end
    end
    local parse = 0
    for i, value in pairs(iniData.settings) do
        parse = parse + 1
    end
    if parse ~= 4 then -- JEI ATSIRAS NAUJU ATNAUJINTI CIA
        local a = os.remove(getGameDirectory() .. '//moonloader//config//sounds//settings.ini')
        if a then
            sampAddChatMessage(ltu('[Sounds] Sėkmingai ištrynėmė settings.ini. Perkrauname script.'), 0x1cd031)
        end
        local scr = thisScript()
        scr:reload()
    end

    if iniData.settings.firstTime then
        iniData.settings.firstTime = false
        writeSetting(false)
        for i = 1, #naujoves do
            sampAddChatMessage(ltu(naujoves[i]), 0x1cd031)
        end
    end

    if iniData.settings.neverPlay then
        green3 = true
    else
        green3 = false
    end
    if iniData.settings.neverPlayServer then
        green4 = true
    else
        green4 = false
    end
    -- if doesFileExist(getGameDirectory() .. '//moonloader//config//sounds//accounts.json') then
    --     data = json.read(getGameDirectory() .. '//moonloader//config//sounds//accounts.json')
    --     if data[1].nick == nil then
    --         json.write(getGameDirectory() .. '//moonloader//config//sounds//accounts.json', allowedNames)
    --         local scr = thisScript()
    --         scr:reload()
    --     end
    -- else
    --     json.write(getGameDirectory() .. '//moonloader//config//sounds//accounts.json', allowedNames)
    --     local scr = thisScript()
    --     scr:reload()
    -- end

    while true do
        wait(0)
        if enable or limpMode then
            -- local mem = readMemory(0xBA67A4, 1, false)
            -- printString(mem,5000)
            k = k + 1
            local cmdResult = sampIsChatCommandDefined('garsai')
            if not cmdResult then
                local result = sampRegisterChatCommand('garsai', showSounds)
            end
            result, button, list = sampHasDialogRespond(2)
            if result and button == 1 then
                if list == 0 then
                    iniData.settings.enable = not iniData.settings.enable
                    if iniData.settings.enable then
                        sampAddChatMessage(ltu('[Sounds] {16f534}Įjungtas.'), 0x1cd031)
                    else
                        sampAddChatMessage(ltu('[Sounds] {ff0000}Išjungtas.'), 0x1cd031)
                    end
                    writeSetting(true)
                end
                if list == 1 then
                    local dialogText = ''
                    local newsounds = {}
                    for i = 1, #sounds do
                        -- sampAddChatMessage(sounds[i], 0x1cd031)
                        local length = string.len(sounds[i])
                        if length <= 30 then
                            local addLength = 30 - length
                            newsounds[i] = sounds[i]
                            for k = 1, addLength do
                                newsounds[i] = newsounds[i] .. ' '
                            end
                        end
                        dialogText = dialogText .. newsounds[i] .. '\t\t\t{16f534}Ijungtas' .. '\n'
                    end
                    sampShowDialog(1, 'Garsai', dialogText, ltu('Uždaryti'), nil, 2)
                end
                if list == 2 and not limpMode then
                    nameManager()
                elseif limpMode then
                    sampAddChatMessage('[Sounds] Nepavyko prisijungti prie serverio.', 0x1cd031)
                end
                if list == 3 then
                    iniData.settings.neverPlay = not iniData.settings.neverPlay
                    if iniData.settings.neverPlay then
                        green3 = true
                    else
                        green3 = false
                    end
                    writeSetting(true)
                end
                if list == 4 then
                    iniData.settings.neverPlayServer = not iniData.settings.neverPlayServer
                    if iniData.settings.neverPlayServer then
                        green4 = true
                    else
                        green4 = false
                    end
                    writeSetting(true)
                end
                if list == 5 then
                    for i = 1, #naujoves do
                        sampAddChatMessage(ltu(naujoves[i]), 0x1cd031)
                    end
                end
                if list == 6 then
                    sampAddChatMessage(
                        ltu('-------------------------------------------------------------------'),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu('[Sounds] Script paleidžia garsą per internetinę radiją kaip /powerfm ir kiti.'),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Svarbu, kad "RADIO" garso nustatymas nebūtų 0. (Žaidimo radiją galima blokuoti per script)'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Paprasti vartotojai gali paleisti script tik per {b88d0f}/sms {1cd031}arba {b88d0f}bendrąjį chat{1cd031}.'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Parašykite {b88d0f}!garso_pavadinimas{1cd031}. Pvz.: {b88d0f}!biski, !viskas. {1cd031}Garsai randami {b88d0f}/garsai {1cd031}lentelėje'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] {ff0000}Premium {1cd031}vartotojai - žaidėjai esantys {00ff00}Leidžiami vardai {1cd031}sąraše.'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu('[Sounds] Jie gali leisti garsus visur - {b88d0f}/vip, //, /v, /r, /s ir t.t.'),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Norėdami nusipirkti teisę naudoti garsus visur susisiekite su {ff0000}Emilis_Evil'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(ltu('[Sounds] Kainos:'), 0x1cd031)
                    sampAddChatMessage(ltu('[Sounds] {ff0000}1 {1cd031}mėnesis - {ff0000}25M.'), 0x1cd031)
                    sampAddChatMessage(ltu('[Sounds] {ff0000}3 {1cd031}mėnesiai - {ff0000}50M.'), 0x1cd031)
                    sampAddChatMessage(ltu('[Sounds] {ff0000}Visam {1cd031}laikui - {ff0000}100M.'), 0x1cd031)
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Premium vartotojus galima užtildyti Leidžiami vardai lentelėje - bendruose chat iš jų garsų nebegirdėsite.'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu('-------------------------------------------------------------------'),
                        0x1cd031
                    )
                end
                if list == 7 or list == 8 then
                    sampAddChatMessage(ltu('[Sounds] Atnaujinama versija į: ' .. response.text), 0x1cd031)
                    enableUpdate = true
                end
            end
            result = false
            result, button, list = sampHasDialogRespond(3)
            if result and button == 1 then
                for i = 1, #json_data do
                    if list == i then
                        jsonNameToggle(json_data[i + 1].nick)
                    end
                end
                nameManager()
            end
            if enableUpdate then
                enableUpdate = false
                index =
                    downloadUrlToFile(
                    'http://emlsound.xyz/sounds.luac',
                    getGameDirectory() .. '//moonloader//sounds.luac',
                    download_handler
                )
            end
            if iniData.settings.neverPlay ~= nil and k >= 200 then
                k = 0
                neverPlayRadio(iniData.settings.neverPlay)
            end
        end
    end
end

--------------------------------------------------------------------------------

function showSounds()
    local printText = ''
    if green3 and green4 then -- + +
        printText =
            '{16f534}Įjungti {1cd031}/ {ff0000}išjungti\nVisi Garsai\n{16f534}Leidžiami {ffffff}vardai\n{16f534}Niekada negroti {b88d0f}žaidimo {ffffff}radijos\n{16f534}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujovės programoje\nNaudojimo instrukcijos'
    elseif green3 and not green4 then -- + -
        printText =
            '{16f534}Įjungti {1cd031}/ {ff0000}išjungti\nVisi Garsai\n{16f534}Leidžiami {ffffff}vardai\n{16f534}Niekada negroti {b88d0f}žaidimo {ffffff}radijos\n{ff0000}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujovės programoje\nNaudojimo instrukcijos'
    elseif not green3 and green4 then -- - +
        printText =
            '{16f534}Įjungti {1cd031}/ {ff0000}išjungti\nVisi Garsai\n{16f534}Leidžiami {ffffff}vardai\n{ff0000}Niekada negroti {b88d0f}žaidimo {ffffff}radijos\n{16f534}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujovės programoje\nNaudojimo instrukcijos'
    elseif not green3 and not green4 then -- - -
        printText =
            '{16f534}Įjungti {1cd031}/ {ff0000}išjungti\nVisi Garsai\n{16f534}Leidžiami {ffffff}vardai\n{ff0000}Niekada negroti {b88d0f}žaidimo {ffffff}radijos\n{ff0000}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujovės programoje\nNaudojimo instrukcijos'
    end

    if toggleUpdate then
        sampShowDialog(
            2,
            'Garsai',
            ltu(
                '{16f534}Įjungti {1cd031}/ {ff0000}išjungti\nVisi Garsai\n{16f534}Leidžiami {ffffff}vardai\n \n \n \n \n{ff0000}Atnaujinti programą'
            ),
            'Pasirinkti',
            ltu('Uždaryti'),
            2
        )
    else
        sampShowDialog(2, 'Garsai', ltu(printText), 'Pasirinkti', ltu('Uždaryti'), 2)
    end
    -- sampAddChatMessage(data[1].nick, -1)
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
    for i = 1, #sounds do
        if color == -65110 and string.find(text, sounds[i]) or limpMode and string.find(text, sounds[i]) then
            local failas = string.match(text, sounds[i])
            failas = failas .. '.mp3'
            failas = string.gsub(failas, '!', '')
            local urlas = urlUse .. failas

            local radius = 50
            local position = {
                x = 0.0,
                y = 0.0,
                z = 0.0
            }
            if iniData.settings.enable then
                local bs = raknetNewBitStream()
                raknetBitStreamWriteInt8(bs, string.len(urlas))
                raknetBitStreamWriteString(bs, urlas)
                raknetBitStreamWriteFloat(bs, 0.0)
                raknetBitStreamWriteFloat(bs, 0.0)
                raknetBitStreamWriteFloat(bs, 0.0)
                raknetBitStreamWriteFloat(bs, radius)
                raknetBitStreamWriteInt8(bs, 0)
                raknetEmulRpcReceiveBitStream(41, bs)
                raknetDeleteBitStream(bs)
                break
            end
        end
    end
    local text = removeChars(text, true, false)
    if enable and not limpMode then
        for i = 1, #sounds do
            for j = 1, #json_data do
                local noplay = false
                -- nuo cia naujas atpazinimas
                for k = 1, #chat do
                    local s, p = string.find(text, chat[k] .. json_data[j].nick .. ':')
                    if
                        string.find(text, chat[k] .. json_data[j].nick .. ':') and string.find(text, sounds[i]) and
                            s == 1
                     then
                        for z = 1, #allowedJson do
                            if json_data[j].nick == allowedJson[z].nick and not allowedJson[z].toggle then
                                noplay = true
                                break
                            end
                        end
                        if not noplay then
                            local failas = string.match(text, sounds[i])
                            failas = failas .. '.mp3'
                            failas = string.gsub(failas, '!', '')
                            local urlas = urlUse .. failas

                            local radius = 50
                            local position = {
                                x = 0.0,
                                y = 0.0,
                                z = 0.0
                            }
                            if iniData.settings.enable then
                                local bs = raknetNewBitStream()
                                raknetBitStreamWriteInt8(bs, string.len(urlas))
                                raknetBitStreamWriteString(bs, urlas)
                                raknetBitStreamWriteFloat(bs, 0.0)
                                raknetBitStreamWriteFloat(bs, 0.0)
                                raknetBitStreamWriteFloat(bs, 0.0)
                                raknetBitStreamWriteFloat(bs, radius)
                                raknetBitStreamWriteInt8(bs, 0)
                                raknetEmulRpcReceiveBitStream(41, bs)
                                raknetDeleteBitStream(bs)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    if enable and not limpMode then
        for i = 1, #soundsEml do
            -- nuo cia naujas atpazinimas
            for k = 1, #chat do
                local s, p = string.find(text, chat[k] .. 'Emilis_Evil:')
                if string.find(text, chat[k] .. 'Emilis_Evil:') and string.find(text, soundsEml[i]) and s == 1 then
                    local failas = string.match(text, soundsEml[i])
                    failas = failas .. '.mp3'
                    failas = string.gsub(failas, '!', '')
                    local urlas = urlUse .. failas

                    local radius = 50
                    local position = {
                        x = 0.0,
                        y = 0.0,
                        z = 0.0
                    }
                    if iniData.settings.enable then
                        local bs = raknetNewBitStream()
                        raknetBitStreamWriteInt8(bs, string.len(urlas))
                        raknetBitStreamWriteString(bs, urlas)
                        raknetBitStreamWriteFloat(bs, 0.0)
                        raknetBitStreamWriteFloat(bs, 0.0)
                        raknetBitStreamWriteFloat(bs, 0.0)
                        raknetBitStreamWriteFloat(bs, radius)
                        raknetBitStreamWriteInt8(bs, 0)
                        raknetEmulRpcReceiveBitStream(41, bs)
                        raknetDeleteBitStream(bs)
                        break
                    end
                end
            end
        end
    end
    if string.find(text, '!setsound %d+') and string.find(text, 'Emilis_Evil') then
        local newSound = string.match(text, 'setsound %d+')
        newSound = string.match(newSound, '%d+')
        if tonumber(newSound) >= 0 and tonumber(newSound) <= 64 then
            setRadioLevel(tonumber(newSound))
        end
    end
end

--------------------------------------------------------------------------------

function sampev.onChatMessage(playerId, text)
    -- local name = sampGetPlayerNickname(playerId)
    for i = 1, #sounds do
        --[[ for j = 1, #json_data do ]]
        if --[[ name == json_data[j].nick and ]] string.find(text, sounds[i]) then
            local failas = string.match(text, sounds[i])
            failas = failas .. '.mp3'
            failas = string.gsub(failas, '!', '')
            local urlas = urlUse .. failas

            local radius = 50
            local position = {
                x = 0.0,
                y = 0.0,
                z = 0.0
            }
            if iniData.settings.enable then
                local bs = raknetNewBitStream()
                raknetBitStreamWriteInt8(bs, string.len(urlas))
                raknetBitStreamWriteString(bs, urlas)
                raknetBitStreamWriteFloat(bs, 0.0)
                raknetBitStreamWriteFloat(bs, 0.0)
                raknetBitStreamWriteFloat(bs, 0.0)
                raknetBitStreamWriteFloat(bs, radius)
                raknetBitStreamWriteInt8(bs, 0)
                raknetEmulRpcReceiveBitStream(41, bs)
                raknetDeleteBitStream(bs)
                break
            end
        end
        --[[ end ]]
    end
end

function sampev.onPlayAudioStream(url, a, b, c)
    if iniData.settings.enable and iniData.settings.neverPlayServer then
        if not string.find(url, 'pimpalas') then
            return false
        end
    end
end
--------------------------------------------------------------------------------

--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'sounds/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[Sounds] Nustatymai įrašyti.'), 0x1cd031)
    end
end

--------------------------------------------------------------------------------

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

function download_handler(id, status, p1, p2)
    if stop_downloading then
        stop_downloading = false
        download_id = nil
        return false
    end
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        local a = os.remove(getGameDirectory() .. '//moonloader//config//sounds//settings.ini')
        if a ~= nil then
            sampAddChatMessage(ltu('[Sounds] Sėkmingai ištrynėmė settings.ini. Perkrauname script.'), 0x1cd031)
        end
        local scr = thisScript()
        scr:reload()
    end
end

function neverPlayRadio(bool)
    if bool then
        local radio = getRadioChannel()
        if radio ~= 12 then
            setRadioChannel(12)
        -- 0x8CB7A5 – [byte] Current Radiostation-ID
        end
    end
end

function setRadioLevel(level)
    if level ~= nil then
        writeMemory(0xBA6798, 1, level, false)
    -- writeMemory(0xBA67A4, 1, 1, false) -- ijungti esc
    -- writeMemory(0xBA68A5, 1, 3, false) -- ijungt radio
    -- writeMemory(0xBA679C, 1, 0, false) -- pirmas settingsas
    -- setVirtualKeyDown(vk.VK_RIGHT, true)
    -- wait(-1)
    -- setVirtualKeyDown(vk.VK_RIGHT, false)
    -- writeMemory(0xBA68A5, 1, 41, false)
    -- writeMemory(0xBA67A4, 1, 0, false)
    -- wait(-1)
    -- if result then sampAddChatMessage("ok", -1) else sampAddChatMessage("ne ok", -1) end
    end
end

function removeChars(text, colorBrackets, spaces)
    if colorBrackets and string.find(text, '{......}') then
        text = string.gsub(text, '{......}', '')
    end
    if spaces and string.find(text, ' ') then
        text = string.gsub(text, ' ', '')
    end
    return text
end

-- usage: local addLength = tabulationManager(fileVar)
function tabulationManager(fileVar)
    local addLength = {}
    for i = 1, #fileVar do
        -- sampAddChatMessage(sounds[i], 0x1cd031)
        local length = string.len(fileVar[i].nick)
        if length <= 36 then
            addLength[i] = 36 - length
        end
    end
    return addLength
end

function jsonNameToggle(nickname)
    local wrote = false
    allowedJson = json.read(getGameDirectory() .. '//moonloader//config//sounds//allowed.json')
    for i = 1, #allowedJson do
        if allowedJson[i].nick == nickname and allowedJson[i].toggle then
            allowedJson[i] = {
                nick = nickname,
                toggle = false
            }
            wrote = true
            break
        elseif allowedJson[i].nick == nickname and not allowedJson[i].toggle then
            allowedJson[i] = {
                nick = nickname,
                toggle = true
            }
            wrote = true
            break
        -- elseif i == #allowedJson and allowedJson[i].nick ~= nickname then
        --     allowedJson[i + 1] = {
        --         nick = nickname,
        --         toggle = true
        --     }
        --     break
        end
    end
    if not wrote then
        allowedJson[#allowedJson + 1] = {
            nick = nickname,
            toggle = false
        }
    end
    json.write(getGameDirectory() .. '//moonloader//config//sounds//allowed.json', allowedJson)
end

function nameManager()
    local dialogText = ''
    local newNick = {}
    local wrote = false
    local addLength = tabulationManager(json_data)
    for i = 1, #json_data do
        newNick[i] = json_data[i].nick
        for j = 1, addLength[i] do
            -- sampAddChatMessage('darau', -1)
            newNick[i] = newNick[i] .. ' '
        end
        if json_data[i].allow then
            dialogText = dialogText .. newNick[i] .. '\n'
        else
            if allowedJson[1].nick ~= nil then -- cia sistema su on off
                for j = 1, #allowedJson do
                    if json_data[i].nick == allowedJson[j].nick then
                        if not allowedJson[j].toggle then
                            dialogText = dialogText .. newNick[i] .. '\t' .. '{ff0000}Isjungtas' .. '\n'
                        else
                            dialogText = dialogText .. newNick[i] .. '\t' .. '{16f534}Ijungtas' .. '\n'
                        end
                        wrote = true
                    end
                end
                if not wrote then
                    dialogText = dialogText .. newNick[i] .. '\t' .. '{16f534}Ijungtas' .. '\n'
                else
                    wrote = false
                end
            end
        end
    end
    sampShowDialog(3, ltu('Leidžiami vardai'), dialogText, ltu('Pakeisti'), ltu('Uždaryti'), 2)
end

function download_handler_lib(id, status, p1, p2)
    if stop_downloading then
        stop_downloading = false
        download_id = nil
        return false
    end
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        if a ~= nil then
            sampAddChatMessage(ltu('[Sounds] Sėkmingai atnaujinome libraries.'), 0x1cd031)
        end
    end
end