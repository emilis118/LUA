script_name('Discord voiceChat')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local iniData = {}
local effil = require 'lib.effil'
local json = require 'lib.json'
local mainCfg = {
    settings = {enable = true}
}
local position = {
    -3000,
    -2727.2728,
    -2454.5456,
    -2181.8184,
    -1909.0912,
    -1636.364,
    -1363.6368,
    -1090.9096,
    -818.1824,
    -545.4552,
    -272.728,
    -0.00080000000036762,
    272.7264,
    545.4536,
    818.1808,
    1090.908,
    1363.6352,
    1636.3624,
    1909.0896,
    2181.8168,
    2454.544,
    2727.2712
}
local abc = {
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V'
}
local enable = true
local isInArea = false
local area = ''
local areaOld = ''
--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('dc')
        if not cmdResult then
            local result = sampRegisterChatCommand('dc', toggleScript)
        end
        if enable then
            for x = 1, #position do
                for y = 1, #position do
                    isInArea =
                        isCharInArea2d(
                        PLAYER_PED,
                        position[x],
                        position[y],
                        position[x] + 272.72,
                        position[y] + 272.72,
                        false
                    )
                    if isInArea then
                        area = abc[x] .. tostring(y)
                        break
                    end
                end
            end
            if area ~= areaOld then
                areaOld = area

                sendDiscord(
                    true,
                    'https://discord.com/api/webhooks/811218614714761216/3ULm28B-k_n4ElCjaej6WTWbR8_SC1zMTQPpRflsQtP5UlhaXlOvbd578sKWW1fP6R9t',
                    area
                )
            end
            printString(area, 300)
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    enable = not enable
end

--------------------------------------------------------------------------------

function sendDiscord(getName, sendUrl, text)
    local requests = require('lib.requests')
    local encoding = require 'encoding'
    encoding.default = 'cp1257'
    local u8 = encoding.UTF8
    local _, idas = false, 0
    if getName then
        _, idas = sampGetPlayerIdByCharHandle(PLAYER_PED)
    end
    local data = {
        username = '',
        content = ''
    }
    local header = {['Content-Type'] = 'application/json'}
    data.username = sampGetPlayerNickname(idas)
    data.content = u8:encode(text)
    datas = encodeJson(data)
    local sender = {
        url = 'https://discord.com/api/webhooks/841831293800022049/aMAzmRCy_O7cmrgLOGZigqIAEMeh_Lo2vt8SgaOPGr1sE4I0KUmUU1PBZ6xQXvce5WTX',
        data = {['content'] = 'swx', ['username'] = 'pimpis'},
        headers = {['Content-Type'] = 'application/json'}
    }
    -- responses = requests.post(sender) --{url = sendUrl, headers = headers, data = args}
    asyncHttpRequest(
        'POST',
        'https://discord.com/api/webhooks/841831293800022049/aMAzmRCy_O7cmrgLOGZigqIAEMeh_Lo2vt8SgaOPGr1sE4I0KUmUU1PBZ6xQXvce5WTX',
        sender,
        function(response)
            print(response.text)
        end,
        function(error)
            print(error)
        end,
        text
    )
end

function asyncHttpRequest(method, url, args, resolve, reject, text)
    strResponse = '������� ����� �� �������...'
    local encoding = require 'encoding'
    encoding.default = 'cp1257'
    local u8 = encoding.UTF8
    local _, idas = false, 0
    _, idas = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local argai = {
        username = '',
        content = ''
    }
    argai.username = sampGetPlayerNickname(idas)
    argai.content = u8:encode('!cmove '..text..' <@253240592086073344>')
    local sdata = json.encode(argai)
    sendRequest = true
    local request_thread =
        effil.thread(
        function(method, url, args)
            local requests = require 'requests'
            local result, response = pcall(requests.post, {
                url = 'https://discord.com/api/webhooks/841831293800022049/aMAzmRCy_O7cmrgLOGZigqIAEMeh_Lo2vt8SgaOPGr1sE4I0KUmUU1PBZ6xQXvce5WTX',
                data = sdata,--{['content'] = 'swx', ['username'] = 'pimpis'},
                headers = {['Content-Type'] = 'application/json'}
            })
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
