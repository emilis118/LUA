script_name('play sound')
script_version('1.0')

--------------------------------------------------------------------------------
local restarter = false
local dlstatus = require('moonloader').download_status
local fileList = {
    'effil.lua',
    'libeffil.dll',
    'jsoncfg.lua',
    'samp//events//bitstream_io.lua',
    'samp//events//core.lua',
    'samp//events//extra_types.lua',
    'samp//events//handlers.lua',
    'samp//events//utils.lua',
    'samp//events.lua',
    'samp//raknet.lua',
    'samp//synchronization.lua'
}

function downloadManager(variable, method)
    print('ieskoma: ' .. variable .. '; method: ' .. method)
    if method == 'file' then
        local new = ''
        if string.find(variable, '//%a+//') then
            new = string.match(variable, '%a+//%a+//')
            variable = string.gsub(variable, new, '')
            --print('file: ' .. variable)
        elseif string.find(variable, '//') then
            new = string.match(variable, '%a+//')
            variable = string.gsub(variable, new, '')
            --print('file: ' .. variable)
        else
            return variable
        end
        return variable
    end
    if method == 'dir' then
        local new = ''
        local dir = ''
        if string.find(variable, '%....') then
            new = string.match(variable, '%a+%....')
            variable = string.gsub(variable, new, '')
            dir = variable
            dir = string.gsub(dir, '//', '\\\\')
            if not doesDirectoryExist(getGameDirectory() .. '//moonloader//lib//' .. dir) then
                os.execute('mkdir moonloader\\lib\\' .. dir)
            end
        end
        return variable
    end
    if method == 'fileDir' then
        local sendVar = variable
        if string.find(variable, '%....') then
            if string.find(variable, '_') then
                new = string.match(variable, '%a+_%a+%....')
            else
                new = string.match(variable, '%a+%....')
            end
            variable = string.gsub(variable, new, '')
            dir = variable
            dir = string.gsub(dir, '//', '\\\\')
            if not doesDirectoryExist(getGameDirectory() .. '//moonloader//lib//' .. dir) then
                os.execute('mkdir moonloader\\lib\\' .. dir)
            end
        end
        print('return filedir: ' .. sendVar)
        return sendVar
    end
end

for i = 1, #fileList do
    if not doesFileExist(getGameDirectory() .. '//moonloader//lib//' .. downloadManager(fileList[i], 'fileDir')) then
        print('nerado failo: ' .. fileList[i])
        index =
            downloadUrlToFile(
            'http://emlsound.xyz/' .. downloadManager(fileList[i], 'file'),
            getGameDirectory() .. '//moonloader//lib//' .. downloadManager(fileList[i], 'fileDir')
        )
    end
end

-- if restarter then
--     sampAddChatMessage('Atsiusti reikalingi libraries, perkraunamas script.', -1)
--     local scr = thisScript()
--     scr:reload()
-- end

for i = 1, #fileList do
    if not doesFileExist(getGameDirectory() .. '//moonloader//lib//' .. downloadManager(fileList[i], 'fileDir')) then
        sampAddChatMessage(ltu('[Sounds] Atsi??stas reikalingi library: '..fileList[i]), -1)
    local scr = thisScript()
    scr:reload()
    end
end

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local json = require 'lib.jsoncfg'
local effil = require 'lib.effil'
local requests = require 'lib.requests'

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
local version = 1.0
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
    '!dantim',
    '!rimas1',
    '!rimas2',
    '!rimas3',
    '!saiba',
    '!kalanta1',
    '!algiukai',
}
local soundsEml = {
    '!moan',
    '!liestis',
    '!pari'
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
}
local response
local json_data, error
local stopScript = false
local serverVersion = 0.0
local limpMode = false
local allowedJson = {
    {nick = 'Test_Nick', toggle = false}
}
local antiFlood = false
local naujoves = {
    '-------------------------------------------------------------------',
    '[Sounds] Naujov??s:',
    '[Sounds] Garsai veiks su kaikuriais ChatID.',
    '[Sounds] Nebebus trumpam sustabdomas ??aidimas perkrovus script.',
    '[Sounds] Nepaleis gars?? kol nuleistas ??aidimas ar ??jungtas ESC.',
    '[Sounds] Apsauga nuo gars?? floodinimo (3 sekund??s).',
    '[Sounds] Nauji garsai:',
    '-------------------------------------------------------------------'
}

co =
    coroutine.create(
    function()
        -- for i = 1, 2 do
        asyncHttpRequest(
            'GET',
            'http://emlsound.xyz/accounts.json',
            args,
            function(response)
                json_data = decodeJson(response.text)
            end,
            function(error)
                print(error)
                sampAddChatMessage(ltu('[Sounds] Nepavyko prisijungti prie serverio.'), 0x1cd031)
                sampAddChatMessage(
                    ltu('[Sounds] Script veiks saugumo re??ime - nepatikrinsim atnaujinim?? ir gird??sit visus garsus.'),
                    0x1cd031
                )
                limpMode = true
            end
        )
        asyncHttpRequest(
            'GET',
            'http://emlsound.xyz/version.ini',
            args,
            function(response)
                enable = true
                serverVersion = response.text
                --sampAddChatMessage(serverVersion, -1)
            end,
            function(error)
                print(error)
                limpMode = true
            end
        )
        coroutine.yield()
        -- end

        -- for i = 1, 2 do
        --     if i == 1 then
        --         response = requests.get('http://emlsound.xyz/accounts.json')
        --         json_data, error = response.json()
        --         response = requests.get('http://emlsound.xyz/version.ini')
        --         urlUse = 'http://emlsound.xyz/'
        --     end
        --     if i == 2 then
        --         printString('Alternatyvus serveris (/garsai)', 5000)
        --         response = requests.get('https://pimpalas.000webhostapp.com/accounts.json')
        --         json_data, error = response.json()
        --         response = requests.get('https://pimpalas.000webhostapp.com/version.ini')
        --         urlUse = 'https://pimpalas.000webhostapp.com/'
        --     end
        -- if i == 5 then
        -- stopScript = true
        -- end

        -- end
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
    thread = lua_thread.create_suspended(antiAfkFunc)
    coroutine.resume(co)
    -- if response == nil and coroutine.status(co) ~= 'dead' then
    --     sampAddChatMessage(ltu('[Sounds] Bandome prisijungti i?? naujo.'), -1)
    --     coroutine.resume(co)
    -- -- elseif coroutine.status(co) == 'dead' then
    -- --     limpMode = true
    -- --     sampAddChatMessage(ltu('[Sounds] Nepavyko prisijungti prie serverio.'), 0x1cd031)
    -- --     sampAddChatMessage(
    -- --         ltu('[Sounds] Script veiks saugumo re??ime - nepatikrinsim atnaujinim?? ir gird??sit visus garsus.'),
    -- --         0x1cd031
    -- --     )
    -- elseif response ~= nil then
    --     sampAddChatMessage('enablina',-1)
    --     enable = true
    -- end
    repeat
        wait(0)
    until enable

    if not doesFileExist(getGameDirectory() .. '//moonloader//config//sounds//settings.ini') then
        local iniBool = inicfg.save(mainCfg, 'sounds/settings')
    end
    iniData = inicfg.load(mainCfg, 'sounds/settings')

    if not doesFileExist(getGameDirectory() .. '//moonloader//config//sounds//allowed.json') then
        json.write(getGameDirectory() .. '//moonloader//config//sounds//allowed.json', allowedJson)
        sampAddChatMessage('sukuriamas json failas', -1)
    end
    allowedJson = json.read(getGameDirectory() .. '//moonloader//config//sounds//allowed.json')
    if enable then
        if version < tonumber(serverVersion) then
            sampAddChatMessage(
                ltu(
                    '[Sounds] {ff0000}Aptikta nauja versija. {1cd031}Tam, kad atnaujinti pasirinkite "Atnaujinti" {b88d0f}/garsai {1cd031}lentel??je.'
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
            sampAddChatMessage(ltu('[Sounds] S??kmingai i??tryn??m?? settings.ini. Perkrauname script.'), 0x1cd031)
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

    while true do
        wait(0)
        avalue = readMemory(0xBA67A4, 1, false)
        if avalue == 0 then
            enable = true
        else
            enable = false
        end
        --antiflood
        -- if antiFlood then
        --     thread:run()
        -- end
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
                        sampAddChatMessage(ltu('[Sounds] {16f534}??jungtas.'), 0x1cd031)
                    else
                        sampAddChatMessage(ltu('[Sounds] {ff0000}I??jungtas.'), 0x1cd031)
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
                    sampShowDialog(1, 'Garsai', dialogText, ltu('U??daryti'), nil, 2)
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
                        ltu('[Sounds] Script paleid??ia gars?? per internetin?? radij?? kaip /powerfm ir kiti.'),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Svarbu, kad "RADIO" garso nustatymas neb??t?? 0. (??aidimo radij?? galima blokuoti per script)'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Paprasti vartotojai gali paleisti script tik per {b88d0f}/sms {1cd031}arba {b88d0f}bendr??j?? chat{1cd031}.'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Para??ykite {b88d0f}!garso_pavadinimas{1cd031}. Pvz.: {b88d0f}!biski, !viskas. {1cd031}Garsai randami {b88d0f}/garsai {1cd031}lentel??je'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] {ff0000}Premium {1cd031}vartotojai - ??aid??jai esantys {00ff00}Leid??iami vardai {1cd031}s??ra??e.'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu('[Sounds] Jie gali leisti garsus visur - {b88d0f}/vip, //, /v, /r, /s ir t.t.'),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Nor??dami nusipirkti teis?? naudoti garsus visur susisiekite su {ff0000}Emilis_Evil'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(ltu('[Sounds] Kainos:'), 0x1cd031)
                    sampAddChatMessage(ltu('[Sounds] {ff0000}1 {1cd031}m??nesis - {ff0000}25M.'), 0x1cd031)
                    sampAddChatMessage(ltu('[Sounds] {ff0000}3 {1cd031}m??nesiai - {ff0000}50M.'), 0x1cd031)
                    sampAddChatMessage(ltu('[Sounds] {ff0000}Visam {1cd031}laikui - {ff0000}100M.'), 0x1cd031)
                    sampAddChatMessage(
                        ltu(
                            '[Sounds] Premium vartotojus galima u??tildyti Leid??iami vardai lentel??je - bendruose chat i?? j?? gars?? nebegird??site.'
                        ),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu('-------------------------------------------------------------------'),
                        0x1cd031
                    )
                end
                if list == 7 or list == 8 then
                    sampAddChatMessage(ltu('[Sounds] Atnaujinama versija ??: ' .. response.text), 0x1cd031)
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
            '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n{16f534}Niekada negroti {b88d0f}??aidimo {ffffff}radijos\n{16f534}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujov??s programoje\nNaudojimo instrukcijos'
    elseif green3 and not green4 then -- + -
        printText =
            '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n{16f534}Niekada negroti {b88d0f}??aidimo {ffffff}radijos\n{ff0000}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujov??s programoje\nNaudojimo instrukcijos'
    elseif not green3 and green4 then -- - +
        printText =
            '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n{ff0000}Niekada negroti {b88d0f}??aidimo {ffffff}radijos\n{16f534}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujov??s programoje\nNaudojimo instrukcijos'
    elseif not green3 and not green4 then -- - -
        printText =
            '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n{ff0000}Niekada negroti {b88d0f}??aidimo {ffffff}radijos\n{ff0000}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujov??s programoje\nNaudojimo instrukcijos'
    end

    if toggleUpdate then
        sampShowDialog(
            2,
            'Garsai',
            ltu(
                '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n \n \n \n \n{ff0000}Atnaujinti program??'
            ),
            'Pasirinkti',
            ltu('U??daryti'),
            2
        )
    else
        sampShowDialog(2, 'Garsai', ltu(printText), 'Pasirinkti', ltu('U??daryti'), 2)
    end
    -- sampAddChatMessage(data[1].nick, -1)
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
    if not antiFlood then
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
                    antiFlood = true
                    thread:run()
                    break
                end
            end
        end
        local text = removeChars(text, true, false, true)
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
                                    antiFlood = true
                                    thread:run()
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
                            antiFlood = true
                            thread:run()
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
end

--------------------------------------------------------------------------------

function sampev.onChatMessage(playerId, text)
    -- local name = sampGetPlayerNickname(playerId)
    if not antiFlood then
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
                    antiFlood = true
                    thread:run()
                    break
                end
            end
            --[[ end ]]
        end
    end
end

function sampev.onPlayAudioStream(url, a, b, c)
    if iniData.settings.enable and iniData.settings.neverPlayServer then
        if not string.find(url, 'emlsound') then
            return false
        end
    end
end
--------------------------------------------------------------------------------

--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'sounds/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[Sounds] Nustatymai ??ra??yti.'), 0x1cd031)
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

function download_handler(id, status, p1, p2)
    if stop_downloading then
        stop_downloading = false
        download_id = nil
        return false
    end
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        local a = os.remove(getGameDirectory() .. '//moonloader//config//sounds//settings.ini')
        if a ~= nil then
            sampAddChatMessage(ltu('[Sounds] S??kmingai i??tryn??m?? settings.ini. Perkrauname script.'), 0x1cd031)
        end
        local scr = thisScript()
        scr:reload()
    end
end

function download_handler_lib(id, status, p1, p2)
    if stop_downloading then
        stop_downloading = false
        download_id = nil
        return false
    end
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        if a ~= nil then
            sampAddChatMessage(ltu('[Sounds] S??kmingai atnaujinome libraries.'), 0x1cd031)
        end
    end
end

function neverPlayRadio(bool)
    if bool then
        local radio = getRadioChannel()
        if radio ~= 12 then
            setRadioChannel(12)
        end
    end
end

function setRadioLevel(level)
    if level ~= nil then
        writeMemory(0xBA6798, 1, level, false)
    end
end

function removeChars(text, colorBrackets, spaces, chatId) -- pabaigt cia
    if colorBrackets and string.find(text, '{......}') then
        text = string.gsub(text, '{......}', '')
    end
    if spaces and string.find(text, ' ') then
        text = string.gsub(text, ' ', '')
    end
    if chatId and string.find(text, '%u%l+_%u%l+%[%d+%]') then
        --sampAddChatMessage('radau ir naikinu', -1)
        local match = string.match(text, '%u%l+_%u%l+%[%d+%]')
        local secondMatch = string.match(match, '%u%l+_%u%l+')
        text = string.gsub(text, match, secondMatch)
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
    sampShowDialog(3, ltu('Leid??iami vardai'), dialogText, ltu('Pakeisti'), ltu('U??daryti'), 2)
end

function asyncHttpRequest(method, url, args, resolve, reject)
    strResponse = '????????????????????? ??????????????? ?????? ?????????????????????...'
    sendRequest = true
    local request_thread =
        effil.thread(
        function(method, url, args)
            local requests = require 'requests'
            local result, response = pcall(requests.request, method, url, args)
            if result then
                response.json, response.xml = nil, nil
                sendRequest = false
                return true, response
            else
                sendRequest = false
                return false, response
            end
        end
    )(method, url, args)
    if not resolve then
        resolve = function()
        end
    end
    if not reject then
        reject = function()
        end
    end
    lua_thread.create(
        function()
            local runner = request_thread
            while true do
                local status, err = runner:status()
                if not err then
                    if status == 'completed' then
                        local result, response = runner:get()
                        if result then
                            sendRequest = false
                            resolve(response)
                        else
                            sendRequest = false
                            reject(response)
                        end
                        return
                    elseif status == 'canceled' then
                        sendRequest = false
                        return reject(status)
                    end
                else
                    sendRequest = false
                    return reject(err)
                end
                wait(0)
            end
        end
    )
end

function antiAfkFunc()
    wait(3000)
    antiFlood = false
end
