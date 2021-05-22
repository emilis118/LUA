script_name('auto correct')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local json = require 'lib.jsoncfg'
local encoding = require 'encoding'
    encoding.default = 'cp1257'
    local u8 = encoding.UTF8
local iniData = {}
local mainCfg = {
    settings = {enable = true}
}
local spelling = {
    {wrong = 'nebutu', right = 'nebūtų'},
    {wrong = 'aciu', right = 'ačiū'}
}

--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    if not doesFileExist(getGameDirectory() .. '//moonloader//config//autoCorrect//spelling.json') then
        json.write(getGameDirectory() .. '//moonloader//config//autoCorrect//spelling.json', spelling)
        sampAddChatMessage('sukuriamas json failas', -1)
    end
    data = json.read(getGameDirectory() .. '//moonloader//config//autoCorrect//spelling.json')
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('ac')
        if not cmdResult then
            local result = sampRegisterChatCommand('ac', toggleScript)
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript(arg)
    local cbb = string.match(arg, "%s%a+%s")
    sampAddChatMessage("..."..cbb.."...", -1)
    sampAddChatMessage("..."..arg.."...", -1)
    local len = (string.len(arg) - 1 ) / 2
    sampAddChatMessage(len, -1)
    arg = u8:encode(arg)
    local check1 = ""
    for i = 1, len do
        check1 = check1 .. "."
    end
    
    local newWrong = string.match(arg, check1)
   
    local newRight = string.match(arg, "%s" .. check1)
    -- local newRight = string.match(newRight, "%g+")
    sampAddChatMessage(newWrong, -1)
    sampAddChatMessage(u8:decode(newRight), -1)
end

--------------------------------------------------------------------------------
function sampev.onSendChat(msg)
    for i = 1, #data do
        if string.find(msg, data[i].wrong) then
            msg = string.gsub(msg, data[i].wrong, ltu(data[i].right))
            sampSendChat(msg)
            return false
        end
    end
end

--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'autoCorrect/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[] Nustatymai įrašyti.'), 0x1cd031)
    end
    --iniData = inicfg.load(nil, "autoCorrect/settings") -- nlb gerai sitas
end

function stringCaseFormat(text)

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

function ltu1(text)
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
    return text
end
