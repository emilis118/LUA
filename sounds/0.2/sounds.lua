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
    {nick = 'Emilis_Evil', allow = true},
}
local data = {}
local iniData = {}
local mainCfg = {
    settings = {
        enable = true
    }
}
local version = 0.2
local sounds = {
    '!baranka',
    '!biski',
    '!inv',
    '!fart',
    '!gaujose',
    '!mikrafonas',
    '!nachui',
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
    '!pyderas'
}
local response = requests.get('https://pimpalas.000webhostapp.com/accounts.json')
local json_data, error = response.json()
local result = false
local button = nil
local list = nil
local enableUpdate = false
local toggleUpdate = false
local index = nil
--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()

    if not doesFileExist(getGameDirectory() .. '//moonloader//config//sounds//settings.ini') then
        local iniBool = inicfg.save(mainCfg, 'sounds/settings')
    end
    iniData = inicfg.load(mainCfg, 'sounds/settings')

    local response = requests.get('https://pimpalas.000webhostapp.com/version.ini')
    if version < tonumber(response.text) then
        sampAddChatMessage(ltu('[Sounds] {ff0000}Aptikta nauja versija. {1cd031}Tam, kad atnaujinti pasirinkite "Atnaujinti" {b88d0f}/garsai {1cd031}lentel??je.'), 0x1cd031)
        toggleUpdate = true
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
            if list == 2 then
                local dialogText = ''
                for i = 1, #json_data do
                    dialogText = dialogText .. json_data[i].nick .. '\n'
                end
                sampShowDialog(3, ltu('Leid??iami vardai'), dialogText, ltu('U??daryti'), nil, 2)
            end
			if list == 3 then
                sampAddChatMessage(ltu("[Sounds] Atnaujinama versija ??: "..response.text), 0x1cd031)
				enableUpdate = true
            end
        end
		if enableUpdate then
			enableUpdate = false
			index = downloadUrlToFile(
				"http://pimpalas.000webhostapp.com/sounds.luac", 
				getGameDirectory() .. '//moonloader//sounds.luac',
				download_handler
			)
		end
    end
end

--------------------------------------------------------------------------------

function showSounds()
    if toggleUpdate then
        sampShowDialog(
            2,
            'Garsai',
            ltu(
                '{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai\n{ff0000}Atnaujinti program??'
            ),
            'Pasirinkti',
            ltu('U??daryti'),
            2
        )
    else
        sampShowDialog(
            2,
            'Garsai',
            ltu('{16f534}??jungti {1cd031}/ {ff0000}i??jungti\nVisi Garsai\n{16f534}Leid??iami {ffffff}vardai'),
            'Pasirinkti',
            ltu('U??daryti'),
            2
        )
    end
    -- sampAddChatMessage(data[1].nick, -1)
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
    for i = 1, #sounds do
        for j = 1, #json_data do
            if
                string.find(text, json_data[j].nick) and string.find(text, sounds[i]) or
                    color == -65110 and string.find(text, sounds[i])
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

--------------------------------------------------------------------------------

function sampev.onChatMessage(playerId, text)
    local name = sampGetPlayerNickname(playerId)
    for i = 1, #sounds do
        for j = 1, #json_data do
            if name == json_data[j].nick and string.find(text, sounds[i]) then
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
        sampAddChatMessage(ltu('[Sounds] {16f534}S??kmingai {1cd031}atnaujinta. Perkraunamas script.'), 0x1cd031)
    end
end
