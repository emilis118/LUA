script_name('Account Manager')
script_version('1.0')
script_author('Emilis')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local json = require 'jsoncfg'
local mainCfg = {
    settings = {
        enable = 'select', -- 'auto', 'select', 'off'
        putPsw = true,
        putQuestion = true,
        putbank = true,
        mainAccount = 1
    },
    account = {
        {
            name = 'Emilis_Evil',
            password = 'emixas',
            question = ' egbrolis19980530',
            bankPin = '9366'
        },
        {
            name = 'Kreivos_Akys',
            password = 'dmdm',
            question = nil,
            bankPin = nil
        }
    }
}
local playerName = ''
local whichAccount = nil
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    if doesFileExist(getGameDirectory() .. '//moonloader//config//loginManager//accounts.json') then
        data = json.read(getGameDirectory() .. '//moonloader//config//loginManager//accounts.json')
    else
        if not doesDirectoryExist(getGameDirectory() .. '//moonloader//config//loginManager//') then
            sampAddChatMessage('sukuriam direktorija', -1)
            os.execute('mkdir moonloader\\config\\loginManager')
        end
        json.write(getGameDirectory() .. '//moonloader//config//loginManager//accounts.json', mainCfg)
        local scr = thisScript()
        scr:reload()
    end

    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('account')
        if not cmdResult then
            local result = sampRegisterChatCommand('account', toggleScript)
        end
        local result, button, list = sampHasDialogRespond(45) -- 45 - main tab, 46 - accounts tab, 47/48/49/50 - account inputs, 51 - delete accs.
        if result and button == 1 then
            if list == 0 then
                if data.settings.enable == 'select' then
                    data.settings.enable = 'off'
                elseif data.settings.enable == 'off' then
                    data.settings.enable = 'auto'
                elseif data.settings.enable == 'auto' then
                    data.settings.enable = 'select'
                end
                sampShowDialog(45, 'Account Manager', createText('main'), 'Select', 'Close', 2)
            end
            if list == 1 then
                sampShowDialog(46, 'Accounts', createText('accounts'), 'Select', 'Close', 2)
            end
            if list == 2 then
                data.settings.putPsw = not data.settings.putPsw
                sampShowDialog(45, 'Account Manager', createText('main'), 'Select', 'Close', 2)
            end
            if list == 3 then
                data.settings.putQuestion = not data.settings.putQuestion
                sampShowDialog(45, 'Account Manager', createText('main'), 'Select', 'Close', 2)
            end
            if list == 4 then
                data.settings.putbank = not data.settings.putbank
                sampShowDialog(45, 'Account Manager', createText('main'), 'Select', 'Close', 2)
            end
            json.write(getGameDirectory() .. '//moonloader//config//loginManager//accounts.json', data)
        end
        result = false
        local result, button, list = sampHasDialogRespond(46)
        if result and button == 1 then
            local k = 1
            if list == 0 then
                sampShowDialog(
                    47,
                    'Nickname',
                    'Enter the nickname\nExample: {00ff00}Vardas_Pavarde',
                    'Enter',
                    'Close',
                    1
                )
            end
            if data.account[1].name ~= nil then
                for i = 1, #data.account do
                    k = k + 1
                    if list == i then
                        data.settings.mainAccount = i
                    end
                end
            end
            if list == k then
                sampShowDialog(51, 'Delete account', createText('delete'), 'Select', 'Close', 2)
            end
            json.write(getGameDirectory() .. '//moonloader//config//loginManager//accounts.json', data)
        end
        local result, button, list, input = sampHasDialogRespond(47)
        if result then
            local newData = {
                name = '',
                password = '',
                question = '',
                bankPin = ''
            }
            local stopper = false
            repeat
                wait(0)
                local last = #data.account
                if result and button == 1 then
                    if string.find(input, '%u%l+_%u%l+') then
                        newData.name = input
                        sampShowDialog(48, 'Password', 'Enter the password:', 'Enter', 'Cancel', 3)
                    else
                        sampAddChatMessage(
                            '* Wrong name format. {1cd031}Correct format: {00ff00}Vardas_Pavarde',
                            0xff0000
                        )
                    end
                    json.write(getGameDirectory() .. '//moonloader//config//loginManager//accounts.json', data)
                end
                result = false
                button = nil
                list = nil
                input = nil
                local result, button, list, input = sampHasDialogRespond(48)
                if result and button == 1 then
                    newData.password = input
                    sampShowDialog(
                        49,
                        'Question',
                        'Enter security question:\nIf you do not have a question press "None"',
                        'Enter',
                        'None',
                        3
                    )
                elseif result and button == 0 then
                    sampAddChatMessage('* Adding cancelled.', 0xff0000)
                    table.remove(data.account, #data.account)
                end
                local result, button, list, input = sampHasDialogRespond(49)
                if result and button == 1 then
                    newData.question = input
                    sampShowDialog(
                        50,
                        'Bank PIN',
                        'Enter bank PIN question:\nIf you do not have a bank PIN press "None"',
                        'Enter',
                        'Cancel',
                        3
                    )
                elseif result and button == 0 then
                    newData.question = nil
                end
                local result, button, list, input = sampHasDialogRespond(50)
                if result and button == 1 then
                    newData.bankPin = input
                    table.insert(data, newData)
                    stopper = true
                elseif result and button == 0 then
                    newData.bankPin = nil
                    table.insert(data, newData)
                    stopper = true
                end
            until stopper
            json.write(getGameDirectory() .. '//moonloader//config//loginManager//accounts.json', data)
        end
    end
end
--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    sampShowDialog(45, 'Account Manager', createText('main'), 'Select', 'Close', 2)
    --[[ if arg == 'info' then
        sampAddChatMessage(
            ltu('------------------------------------------------------------------------------'),
            0x1cd031
        )
        sampAddChatMessage(ltu('[Account Manager] Pakeisti paskyros nustatymus naudokite: {b88d0f}/account'), 0x1cd031)
        sampAddChatMessage(
            ltu(
                '[Account Manager] {16f534}Įjungti {1cd031}ar {ff0000}išjungti {1cd031)}pasisveikinimo žinutes: {b88d0f}/account hello'
            ),
            0x1cd031
        )
        sampAddChatMessage(
            ltu('------------------------------------------------------------------------------'),
            0x1cd031
        )
    end
    if arg == 'hello' then
        data.settings.hello = not data.settings.hello
        if data.settings.hello then
            sampAddChatMessage(ltu('[Account Manager] Pasisveikimo žinutės {16f534}įjungtos{1cd031}.'), 0x1cd031)
        else
            sampAddChatMessage(ltu('[Account Manager] Pasisveikimo žinutės {ff0000}išjungtos{1cd031}.'), 0x1cd031)
        end
    end ]]
end

--------------------------------------------------------------------------------

function hello(bool, accountName)
    if bool then
        if data.settings.selectAccount then
            sampAddChatMessage(ltu('[Account Manager] Pasirinkite norimą paskyrą.'), 0x1cd031)
        end
        if data.settings.enable then
            sampAddChatMessage(
                ltu('[Account Manager] Būsite automatiškai prijungtas į {16f534}' .. accountName),
                0x1cd031
            )
        end
        sampAddChatMessage(
            ltu('[Account Manager] Sužinoti daugiau apie account manager: {b88d0f}/account info'),
            0x1cd031
        )
    end
end

--------------------------------------------------------------------------------

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    sampAddChatMessage(dialogId, -1)
    if dialogId == 8888 and title == 'PRIMINIMAS' then
        return false
    end
    if dialogId == 3 and title == 'Prisijungimas' and data.settings.putPsw and whichAccount ~= nil then
        closeDialogWithButton(
            3,
            1,
            nil,
            string.len(data.account[whichAccount].password),
            data.account[whichAccount].password
        )
        return false
    end
    if dialogId == 10711 and title == 'Klausimas' and data.settings.putQuestion and whichAccount ~= nil then
        closeDialogWithButton(
            10711,
            1,
            nil,
            string.len(data.account[whichAccount].question),
            data.account[whichAccount].question
        )
        return false
    end
    if dialogId == 117 and title == 'SARG bankas' and data.settings.putbank and whichAccount ~= nil then
        closeDialogWithButton(
            117,
            1,
            nil,
            string.len(data.account[whichAccount].bankPin),
            data.account[whichAccount].bankPin
        )
        return false
    end
end

--------------------------------------------------------------------------------

function closeDialogWithButton(id, button, listItem, textLength, text) -- 1 = left, 0 = right
    bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, id)
    raknetBitStreamWriteInt8(bs, button)
    raknetBitStreamWriteInt16(bs, listItem)
    raknetBitStreamWriteInt8(bs, textLength)
    raknetBitStreamWriteString(bs, text)
    raknetSendRpc(62, bs)
    raknetDeleteBitStream(bs)
end

--------------------------------------------------------------------------------

function sampev.onSendClientJoin(ver, mod, nickname, a, b, c, d)
    sampAddChatMessage('acc: ' .. nickname)
    for i = 1, #data.account do
        if nickname == data.account[i].name then
            playerName = nickname
            whichAccount = i
        end
    end
end
--------------------------------------------------------------------------------

function createText(selecter)
    local text = {}
    local textas = ''
    local k = 1
    if selecter == 'main' then
        if data.settings.enable == 'auto' then
            text[1] = 'Login Mode: \t\t{00ff00}ON\n'
        elseif data.settings.enable == 'select' then
            text[1] = 'Login Mode: \t\t{ffff00}Select on login\n'
        elseif data.settings.enable == 'off' then
            text[1] = 'Login Mode: \t\t{ff0000}OFF\n'
        end
        if data.account == {} or data.account == nil then
            if data.account[1].name ~= nil then
                text[2] =
                    'Accounts\t\t(Default: {00ff00}' .. data.account[data.settings.mainAccount].name .. '{ffffff})\n'
            end
        else
            text[2] = 'Accounts\n'
        end
        if data.settings.putPsw then
            text[3] = 'Password input: \t{00ff00}ON\n'
        else
            text[3] = 'Password input: \t{ff0000}OFF\n'
        end
        if data.settings.putQuestion then
            text[4] = 'Question input: \t{00ff00}ON\n'
        else
            text[4] = 'Question input: \t{ff0000}OFF\n'
        end
        if data.settings.putbank then
            text[5] = 'Bank PIN input: \t{00ff00}ON\n'
        else
            text[5] = 'Bank PIN input: \t{ff0000}OFF\n'
        end
    end
    if selecter == 'accounts' then
        text[1] = 'Add {00ff00}new {ffffff}account...\n'
        if data.account[1].name ~= nil then
            for i = 1, #data.account do
                text[i + 1] = data.account[i].name .. '\n'
                k = k + 1
            end
        else
            text[2] = ' '
        end
        text[k + 1] = '{ff0000}Delete {ffffff}account'
    end
    if selecter == 'delete' then
        if data.account[1].name ~= nil then
            for i = 1, #data.account do
                text[i] = data.account[i].name .. '\n'
            end
        else
            sampAddChatMessage('* No accounts found.', 0xff0000)
        end
    end
    if text ~= {} then
        for i = 1, #text do
            textas = textas .. text[i]
        end
        return textas
    end
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--writeSetting(false)
function writeSettingJson(msgBool, path)
    json.write(path, data)
    data = json.read(path)
    if data ~= {} and msgBool then
        sampAddChatMessage(ltu('[Account Manager] Nustatymai įrašyti.'), 0x1cd031)
    end
end

--[[ Colors:
{ff0000} - raudona
{1cd031} - default zalia kaip serve
{16f534} - zalia, ryskesne
{b88d0f} - oranzine, komandu paaiskinimas
]]
--------------------------------------------------------------------------------

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
