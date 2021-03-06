script_name('play sound')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local json = require 'lib.jsoncfg'
local requests = require 'lib.requests'
local dlstatus = require('moonloader').download_status
local vk = require 'lib.vkeys'
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
local version = 0.6
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
    '!neten'
}
local soundsEml = {
    '!moan'
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

co =
    coroutine.create(
    function()
        for i = 1, 5 do
            response = requests.get('https://pimpalas.000webhostapp.com/accounts.json') -- kazka del cia
            json_data, error = response.json()
            response = requests.get('https://pimpalas.000webhostapp.com/version.ini')
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
        sampAddChatMessage(ltu('[Sounds] Bandome prisijungti i?? naujo.'), -1)
        coroutine.resume(co)
    elseif coroutine.status(co) == 'dead' then
        limpMode = true
        sampAddChatMessage(ltu('[Sounds] Nepavyko prisijungti prie serverio.'), 0x1cd031)
        sampAddChatMessage(
            ltu('[Sounds] Script veiks saugumo re??ime - nepatikrinsim atnaujinim?? ir gird??sit visus garsus.'),
            0x1cd031
        )
    elseif response ~= nil then
        enable = true
    end

    if not doesFileExist(getGameDirectory() .. '//moonloader//config//sounds//settings.ini') then
        local iniBool = inicfg.save(mainCfg, 'sounds/settings')
    end
    iniData = inicfg.load(mainCfg, 'sounds/settings')

    -- while true do

    -- end
    if enable then
        if version < tonumber(response.text) then
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
        sampAddChatMessage(ltu('-------------------------------------------------------------------'), 0x1cd031)
        sampAddChatMessage(ltu('[Sounds] Naujov??s:'), 0x1cd031)
        sampAddChatMessage(
            ltu('[Sounds] Trys nauji garsai: {b88d0f}!varaisamp{1cd031}, {b88d0f}!neten{1cd031}.'),
            0x1cd031
        )
        sampAddChatMessage(ltu('-------------------------------------------------------------------'), 0x1cd031)
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
                    local dialogText = ''
                    for i = 1, #json_data do
                        dialogText = dialogText .. json_data[i].nick .. '\n'
                    end
                    sampShowDialog(3, ltu('Leid??iami vardai'), dialogText, ltu('U??daryti'), nil, 2)
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
                    sampAddChatMessage(
                        ltu('-------------------------------------------------------------------'),
                        0x1cd031
                    )
                    sampAddChatMessage(ltu('[Sounds] Naujov??s:'), 0x1cd031)
                    sampAddChatMessage(
                        ltu('[Sounds] Trys nauji garsai: {b88d0f}!varaisamp{1cd031}, {b88d0f}!neten{1cd031}.'),
                        0x1cd031
                    )
                    sampAddChatMessage(
                        ltu('-------------------------------------------------------------------'),
                        0x1cd031
                    )
                end
                if list == 7 or list == 8 or list == 6 then
                    sampAddChatMessage(ltu('[Sounds] Atnaujinama versija ??: ' .. response.text), 0x1cd031)
                    enableUpdate = true
                end
            end
            if enableUpdate then
                enableUpdate = false
                index =
                    downloadUrlToFile(
                    'http://pimpalas.000webhostapp.com/sounds.luac',
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
            '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n{16f534}Niekada negroti {b88d0f}??aidimo {ffffff}radijos\n{16f534}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujov??s programoje'
    elseif green3 and not green4 then -- + -
        printText =
            '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n{16f534}Niekada negroti {b88d0f}??aidimo {ffffff}radijos\n{ff0000}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujov??s programoje'
    elseif not green3 and green4 then -- - +
        printText =
            '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n{ff0000}Niekada negroti {b88d0f}??aidimo {ffffff}radijos\n{16f534}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujov??s programoje'
    elseif not green3 and not green4 then -- - -
        printText =
            '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n{ff0000}Niekada negroti {b88d0f}??aidimo {ffffff}radijos\n{ff0000}Niekada negroti {b88d0f}serverio {ffffff}radijos\nNaujov??s programoje'
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
    for i = 1, #sounds do
        if color == -65110 and string.find(text, sounds[i]) or limpMode and string.find(text, sounds[i]) then
            local failas = string.match(text, sounds[i])
            failas = failas .. '.mp3'
            failas = string.gsub(failas, '!', '')
            local urlas = 'http://pimpalas.000webhostapp.com/' .. failas

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
                -- nuo cia naujas atpazinimas
                for k = 1, #chat do
                    local s, p = string.find(text, chat[k] .. json_data[j].nick .. ':')
                    if
                        string.find(text, chat[k] .. json_data[j].nick .. ':') and string.find(text, sounds[i]) and
                            s == 1
                     then
                        local failas = string.match(text, sounds[i])
                        failas = failas .. '.mp3'
                        failas = string.gsub(failas, '!', '')
                        local urlas = 'http://pimpalas.000webhostapp.com/' .. failas

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
    if enable and not limpMode then
        for i = 1, #soundsEml do
            -- nuo cia naujas atpazinimas
            for k = 1, #chat do
                local s, p = string.find(text, chat[k] .. 'Emilis_Evil:')
                if string.find(text, chat[k] .. 'Emilis_Evil:') and string.find(text, soundsEml[i]) and s == 1 then
                    local failas = string.match(text, soundsEml[i])
                    failas = failas .. '.mp3'
                    failas = string.gsub(failas, '!', '')
                    local urlas = 'http://pimpalas.000webhostapp.com/' .. failas

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
            local urlas = 'http://pimpalas.000webhostapp.com/' .. failas

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

function neverPlayRadio(bool)
    if bool then
        local radio = getRadioChannel()
        if radio ~= 12 then
            setRadioChannel(12)
        -- 0x8CB7A5 ??? [byte] Current Radiostation-ID
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
