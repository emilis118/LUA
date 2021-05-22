script_name('Mafia Colours')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
    settings = {
        enable = true,
        mafia = 'cosa',
        color = true,
        setImmSkin = true,
        immId = 264,
        setCnSkin = false,
        cnId = 167
    }
}
local color = 0xFF0000
local skins = {
    cn = {
        117,
        118,
        120,
        263
    },
    imm = {
        124,
        125,
        126,
        169
    }
}

--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    if not doesFileExist(getGameDirectory() .. '//moonloader//config//mafia//settings.ini') then
        local iniBool = inicfg.save(mainCfg, 'mafia/settings')
    end
    iniData = inicfg.load(mainCfg, 'mafia/settings')
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('mafia')
        if not cmdResult then
            local result = sampRegisterChatCommand('mafia', toggleScript)
        end
        local result, button, list = sampHasDialogRespond(15)
        if result and button == 1 then
            if list == 0 then
                iniData.settings.enable = not iniData.settings.enable
                openDialog(1)
            elseif list == 1 then
                if iniData.settings.mafia == 'immortal' then
                    iniData.settings.mafia = 'cosa'
                else
                    iniData.settings.mafia = 'immortal'
                end
                openDialog(1)
            elseif list == 2 then
                iniData.settings.color = not iniData.settings.color
                openDialog(1)
            elseif list == 3 then
                iniData.settings.setImmSkin = not iniData.settings.setImmSkin
                openDialog(1)
            elseif list == 4 then
                iniData.settings.setCnSkin = not iniData.settings.setCnSkin
                openDialog(1)
            elseif list == 5 then
                openDialog(2)
            elseif list == 6 then
                openDialog(3)
            end
            writeSetting(false)
        end
        result = false
        local result, button, _, input = sampHasDialogRespond(16)
        if result and button == 1 then
            if input ~= nil then
                iniData.settings.immId = tonumber(input)
                writeSetting(false)
            end
        end
        result = false
        local result, button, _, input = sampHasDialogRespond(17)
        if result and button == 1 then
            if input ~= nil then
                iniData.settings.cnId = tonumber(input)
                writeSetting(false)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    openDialog(1)
    writeSetting(false)
end

--------------------------------------------------------------------------------

function sampev.onPlayerStreamIn(playerId, team, model, position, rotation, color, fightingStyle)
    if iniData.settings.enable then
        for i = 1, #skins.cn do
            if model == skins.cn[i] then
                if iniData.settings.setCnSkin then
                    model = iniData.settings.cnId
                end
                if iniData.settings.color then
                    if iniData.settings.mafia == 'cosa' then
                        color = 0x00ff00ff
                    else
                        color = 0xff0000ff
                    end
                end
                return {playerId, team, model, position, rotation, color, fightingStyle}
            end
        end
        for i = 1, #skins.imm do
            if model == skins.imm[i] then
                if iniData.settings.setImmSkin then
                    model = iniData.settings.immId
                end
                if iniData.settings.color then
                    if iniData.settings.mafia == 'immortal' then
                        color = 0x00ff00ff
                    else
                        color = 0xff0000ff
                    end
                end
                return {playerId, team, model, position, rotation, color, fightingStyle}
            end
        end
    end
end

function sampev.onSetPlayerSkin(playerId, skinId)
    if iniData.settings.enable then
        for i = 1, #skins.cn do
            if skinId == skins.cn[i] then
                if iniData.settings.color then
                    if iniData.settings.mafia == 'cosa' then
                        bs = raknetNewBitStream()
                        raknetBitStreamWriteInt16(bs, playerId)
                        raknetBitStreamWriteInt32(bs, 0x00ff00ff)
                        raknetEmulRpcReceiveBitStream(72, bs)
                        raknetDeleteBitStream(bs)
                    else
                        bs = raknetNewBitStream()
                        raknetBitStreamWriteInt16(bs, playerId)
                        raknetBitStreamWriteInt32(bs, 0xff0000ff)
                        raknetEmulRpcReceiveBitStream(72, bs)
                        raknetDeleteBitStream(bs)
                    end
                end
                if iniData.settings.setCnSkin then 
                    skinId = iniData.settings.cnId
                    return {playerId, skinId}
                end
            end
        end
        for i = 1, #skins.imm do
            if skinId == skins.imm[i] then
                if iniData.settings.color then
                    if iniData.settings.mafia == 'immortal' then
                        bs = raknetNewBitStream()
                        raknetBitStreamWriteInt16(bs, playerId)
                        raknetBitStreamWriteInt32(bs, 0x00ff00ff)
                        raknetEmulRpcReceiveBitStream(72, bs)
                        raknetDeleteBitStream(bs)
                    else
                        bs = raknetNewBitStream()
                        raknetBitStreamWriteInt16(bs, playerId)
                        raknetBitStreamWriteInt32(bs, 0xff0000ff)
                        raknetEmulRpcReceiveBitStream(72, bs)
                        raknetDeleteBitStream(bs)
                    end
                end
                if iniData.settings.setImmSkin then 
                    skinId = iniData.settings.immId
                    return {playerId, skinId}
                end
            end
        end
    end
end

function resetNameColors()
    local id = sampGetMaxPlayerId(false)
    for i = 0, id do
        bs = raknetNewBitStream()
        raknetBitStreamWriteInt16(bs, id)
        raknetBitStreamWriteInt32(bs, 0x808080)
        raknetEmulRpcReceiveBitStream(72, bs)
        raknetDeleteBitStream(bs)
    end
end

function openDialog(whichPage)
    if whichPage == 1 then
        sampShowDialog(15, ltu('Mafijų nustatymai'), textHandle(whichPage), 'Pasirinkti', ltu('Uždaryti'), 2)
    elseif whichPage == 2 then
        sampShowDialog(16, ltu('Nustatyti IMMORTAL skin'), textHandle(whichPage), 'Pasirinkti', ltu('Uždaryti'), 1)
    elseif whichPage == 3 then
        sampShowDialog(17, ltu('Nustatyti Cosa Nostra skin'), textHandle(whichPage), 'Pasirinkti', ltu('Uždaryti'), 1)
    end
end

function textHandle(whichPage)
    local text1 = ''
    local text2 = ''
    local text3 = ''
    local text4 = ''
    local text5 = ''
    local text6 = ''
    local text7 = ''
    local allText = ''
    if whichPage == 1 then
        if iniData.settings.enable then
            text1 = 'Mafia: {00ff00}Ijungtas'
        else
            text1 = 'Mafia: {ff0000}Isjungtas'
        end
        if iniData.settings.mafia == 'immortal' then
            text7 = ltu('Dabartinė mafija: {3F53D2}IMMORTAL')
        elseif iniData.settings.mafia == 'cosa' then
            text7 = ltu('Dabartinė mafija: {EDF944}Cosa Nostra')
        end
        if iniData.settings.color then
            text2 = '{ffffff}Nick spalvos keitimas: {00ff00}Ijungtas'
        else
            text2 = '{ffffff}Nick spalvos keitimas: {ff0000}Isjungtas'
        end
        if iniData.settings.setImmSkin then
            text3 = 'Pakeisti {3F53D2}IMMORTAL{ffffff} skin: {00ff00}Ijungta'
        else
            text3 = 'Pakeisti {3F53D2}IMMORTAL{ffffff} skin: {ff0000}Isjungta'
        end
        if iniData.settings.setCnSkin then
            text4 = 'Pakeisti {EDF944}Cosa Nostra{ffffff} skin: {00ff00}Ijungta'
        else
            text4 = 'Pakeisti {EDF944}Cosa Nostra{ffffff} skin: {ff0000}Isjungta'
        end
        text5 = 'Nustatyti {3F53D2}IMMORTAL{ffffff} skin ID:\t(Dabar ' .. tostring(iniData.settings.immId) .. ')'
        text6 = 'Nustatyti {EDF944}Cosa Nostra{ffffff} skin ID:\t(Dabar ' .. tostring(iniData.settings.cnId) .. ')'
        allText =
            text1 .. '\n' .. text7 .. '\n' .. text2 .. '\n' .. text3 .. '\n' .. text4 .. '\n' .. text5 .. '\n' .. text6
        return allText
    elseif whichPage == 2 then
        allText = ltu('Įveskite norimą IMMORTAL skin ID (Default: 264):')
        return allText
    elseif whichPage == 3 then
        allText = ltu('Įveskite norimą Cosa Nostra skin ID (Default: 167):')
        return allText
    end
end
--[[ 
    On / off
    Esama mafija: Cosa/IMM
    Nick spalvos: on/off
    Pakeisti IMM skin ---- ismeta lentele ivest id
    Pakeisti CN skin
 ]]
--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'mafia/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[] Nustatymai įrašyti.'), 0x1cd031)
    end
    --iniData = inicfg.load(nil, "mafia/settings") -- nlb gerai sitas
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
