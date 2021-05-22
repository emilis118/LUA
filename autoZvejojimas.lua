script_name('Auto /zvejoti')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local iniData = {}
local mainCfg = {
    settings = {enable = true}
}
local plude = 0
local toggleZvejyba = false
local toggleFishing = false
local k = 0
local toggleSpace = false
local vk = require 'vkeys'
local neverRepeat = false
local timeMs = 0
local toggleStartFish = false

--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    if not doesFileExist(getGameDirectory().."//moonloader//config//autoZvejojimas//settings.ini") then
    	local iniBool = inicfg.save(mainCfg, "autoZvejojimas/settings")
    end
    iniData = inicfg.load(mainCfg, "autoZvejojimas/settings")
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('autozvejoti')
        if not cmdResult then
            local result = sampRegisterChatCommand('autozvejoti', toggleScript)
        end
        local chat = sampIsChatInputActive()
        if toggleZvejyba then
            if toggleFishing and toggleSpace and not chat then
                -- setCharKeyDown(16, true)
                -- setVirtualKeyDown(vk.VK_SPACE, true)
                setGameKeyState(16, 8)
            else
                -- setCharKeyDown(16, false)
                -- setVirtualKeyDown(vk.VK_SPACE, false)
                setGameKeyState(16, 0)
            end
            if toggleFishing and not chat then
                if toggleLeft then
                    setGameKeyState(0, -128)
                -- else
                -- 	setGameKeyState(0, 0)
                end
                if toggleUp then
                    setGameKeyState(1, -128)
                -- else
                -- 	setGameKeyState(1, 0)
                end
                if toggleRight then
                    setGameKeyState(0, 128)
                -- else
                -- 	setGameKeyState(0, 0)
                end
                if toggleDown then
                    setGameKeyState(1, 128)
                -- else
                -- 	setGameKeyState(1, 0)
                end
            end
        end
        local timeNow =  getGameTimer()
        if iniData.settings.enable and timeMs + 5000 < timeNow and toggleStartFish then
            startFishing()
            toggleStartFish = false
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    iniData.settings.enable = not iniData.settings.enable
    if iniData.settings.enable then
        sampAddChatMessage(ltu('[Auto /zvejoti] Automatinė žvejyba {16f534}įjungta.'), 0x1cd031)
    else
        sampAddChatMessage(ltu('[Auto /zvejoti] Automatinė žvejyba {ff0000}išjungta.'), 0x1cd031)
    end
	writeSetting(true)
end

--------------------------------------------------------------------------------

--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'autoZvejojimas/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[Auto /zvejoti] Nustatymai įrašyti.'), 0x1cd031)
    end
    --iniData = inicfg.load(nil, "autoZvejojimas/settings") -- nlb gerai sitas
end

--------------------------------------------------------------------------------

function sampev.onShowTextDraw(id, textdraw)
    if iniData.settings.enable then
        if id == 49 then
            toggleRight = true
        end
        if id == 50 then
            toggleLeft = true
        end
        if id == 51 then
            toggleUp = true
        end
        if id == 52 then
            toggleDown = true
        end
        if id == 48 then
            toggleSpace = false
        end
    end
end

function sampev.onTextDrawHide(id)
    if iniData.settings.enable then
        if id == 49 then
            toggleRight = false
        end
        if id == 50 then
            toggleLeft = false
        end
        if id == 51 then
            toggleUp = false
        end
        if id == 52 then
            toggleDown = false
        end
    end
end

function sampev.onCreateObject(objectId, data) -- kaip patikrint ar "tavo"
    if iniData.settings.enable then
        if data.modelId == 2238 then
            plude = objectId
            sampAddChatMessage(plude, -1)
            toggleFishing = true
            createPos = {x = 0.0, y = 0.0, z = 0.0}
            createPos.x = data.position.x
            createPos.y = data.position.y
            createPos.z = data.position.z
            -- sampAddChatMessage('create object id: ' .. data.position.x, -1)
            -- sampAddChatMessage('create object id: ' .. data.position.y, -1)
            -- sampAddChatMessage('create object id: ' .. data.position.z, -1)
        end
    end
end

function sampev.onMoveObject(objectId, fromPos, destPos, speed, rotation)
    if iniData.settings.enable and objectId == plude then
        k = k + 1
        -- local skirtumas = math.abs(math.sqrt((destPos.x - fromPos.x)^2 + (destPos.y - fromPos.y)^2 + (destPos.z - fromPos.z)^2))
        -- sampAddChatMessage(skirtumas, -1)
        if speed > 0.03 and k > 2 then
            toggleSpace = true
        end
    --printString(objectId.." from: "..fromPos.x.." dest: "..destPos.x.. " speed "..speed,1000)
    end
end

function sampev.onDestroyObject(objectId)
    if objectId == plude then
        k = 0
        toggleFishing = false
        toggleSpace = false
        toggleLeft = false
        toggleRight = false
        toggleUp = false
        toggleDown = false
        toggleZvejyba = false
    end
end

function sampev.onSendCommand(cmd)
    if cmd == '/zvejoti' then
        toggleZvejyba = true
    end
end

function sampev.onPlaySound(soundId, position)
    if soundId == 31205 then
        sampAddChatMessage(ltu('Ištraukta žuvis. Permetame.'), 0x1cd031)
        timeMs = getGameTimer()
        toggleStartFish = true
    end
end

function startFishing()
    sampSendChat('/zvejoti')
end
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

--------------------------------------------------------------------------------
