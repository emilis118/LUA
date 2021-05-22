local imgui = require('imgui')
local neatJSON = require('neatjson')
local sf = require('sampfuncs')
local vk = require('vkeys')
local encoding = require('encoding')
local ev = require('lib.samp.events')
local weapons = require 'game.weapons'
local inicfg = require('inicfg')
local sapi = require "SA-MP API.init"

local u8 = encoding.UTF8
encoding.default = 'CP1251'

local server = {
	ip = '',
    port = 0,
}

local font = renderCreateFont('Arial', 8, 4 + 8)

local xw, yw = getScreenResolution()

local menuPos = imgui.ImVec2(xw / 2, yw / 2)
local menuActive = imgui.ImBool(false)
local preMenuActive = false
local menuHideCursor = imgui.ImBool(false)
local activeTab = 0

local needsInit = 0

local nopsMenuPos = imgui.ImVec2(xw / 2, yw / 2)
local nopsMenu = imgui.ImBool(false)
local nopsTab = 0
local nopsList = {}
local selectedNop = imgui.ImInt(0)
local nopFilerBox = imgui.ImBuffer(256)

local sendMenuPos = imgui.ImVec2(xw / 2, yw / 2)
local sendMenu = imgui.ImBool(false)
local sendGamestate = imgui.ImInt(0)
local sendInterior = imgui.ImInt(0)
local sendTextdraw = imgui.ImInt(0)
local sendPickup = imgui.ImInt(0)
local sendRC = imgui.ImInt(0)
local sendConvertOnfootToSpectator = imgui.ImBool(false)

local logMenuPos = imgui.ImVec2(xw / 2, yw / 2)
local logMenu = imgui.ImBool(false)
local logRenderPickups = imgui.ImBool(false)
local logPickedUpPickups = imgui.ImBool(false)
local logRenderTextdraws = imgui.ImBool(false)
local logClickedTextdraws = imgui.ImBool(false)
local logBox = imgui.ImBuffer(1000000)
local pickups = {}

local bruteMenuPos = imgui.ImVec2(xw / 2, yw / 2)
local bruteMenu = imgui.ImBool(false)
local bruteSelectedRpc = imgui.ImInt(0)
local bruteDelay = imgui.ImInt(100)
local bruteMin = imgui.ImInt(1)
local bruteMax = imgui.ImInt(1000)
local bruteBox = imgui.ImBuffer(1000000)
local bruteFilterBox = imgui.ImBuffer(256)
local bruteFilteredBox = imgui.ImBuffer(1000000)
local bruteEnabled = false
local brutePaused = false
local bruteCurrent = 0
local bruteMode = 0

local anotherMenuPos = imgui.ImVec2(xw / 2, yw / 2)
local anotherMenu = imgui.ImBool(false)
local anotherSelectedWeapon = imgui.ImInt(0)
local anotherRandomAmmo = imgui.ImBool(false)
local anotherAmmoAmount = imgui.ImInt(1000)

local settingsMenuPos = imgui.ImVec2(xw / 2, yw / 2)
local settingsMenu = imgui.ImBool(false)
local settingsSelectedTheme = imgui.ImInt(0)
local settingsSaveNops = imgui.ImBool(false)
local settingsSaveSend = imgui.ImBool(false)
local settingsSaveBrute = imgui.ImBool(false)
local settingsSaveLog = imgui.ImBool(false)
local settingsSaveAnother = imgui.ImBool(false)
local settingsHideCursorCode = imgui.ImBuffer(5)
local settingsShowMenuCode = imgui.ImBuffer(5)

local configMenuPos = imgui.ImVec2(xw / 2, yw / 2)
local configMenu = imgui.ImBool(false)
local configNameBox = imgui.ImBuffer(256)
local configList = {}
local selectedConfig = imgui.ImInt(0)
local preConfig = selectedConfig.v

local snowEnabled = false
local disableSnowForeverV = false
local snows = {}
local snowOnScreen = 50

local data = {
    rpc = {
        incoming = {
            
        },
        outcoming = {

        }
    },
    packets = {
        incoming = {
            
        },
        outcoming = {

        }
    }
}

local configs = {}
local settings = {defaultConfig = 1}

math.randomseed(os.time())

function imgui.OnDrawFrame()
    local xw, yw = getScreenResolution()
    local needsHide = false
    if needsInit == 1 then needsInit = 2 end
    if needsInit == 2 and not menuActive.v then
        needsHide = true
        menuActive.v = true
    end
    if menuActive.v then
        imgui.SetNextWindowSize(imgui.ImVec2(525, 340), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(menuPos, needsInit ~= 2 and imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Bypasser', menuActive, imgui.WindowFlags.NoResize, imgui.WindowFlags.AutoResize)
        imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
        imgui.PushStyleVar(imgui.StyleVar.FrameRounding, 0)
        local i = -1
        local maxElements = 5
        local size = imgui.ImVec2(100, 20)
        if not nopsMenu.v then
            i = i + 1
            if i < maxElements then
                imgui.SameLine()
            else
                i = 0
            end
            if imgui.ButtonActivated(activeTab == 1, u8'Нопы', size) then
                activeTab = 1 
            end
            if imgui.IsItemClicked() and imgui.IsMouseDoubleClicked(0) then
                nopsMenu.v = true
            end
        end
        if not sendMenu.v then
            i = i + 1
            if i < maxElements then
                imgui.SameLine()
            else
                i = 0
            end
            if imgui.ButtonActivated(activeTab == 2, u8'Отправка', size) then
                activeTab = 2
            end
            if imgui.IsItemClicked() and imgui.IsMouseDoubleClicked(0) then
                sendMenu.v = true
            end
        end
        if not bruteMenu.v then
            i = i + 1
            if i < maxElements then
                imgui.SameLine()
            else
                i = 0
            end
            if imgui.ButtonActivated(activeTab == 3, u8'Перебор', size) then
                activeTab = 3
            end
            if imgui.IsItemClicked() and imgui.IsMouseDoubleClicked(0) then
                bruteMenu.v = true
            end
        end
        if not logMenu.v then
            i = i + 1
            if i < maxElements then
                imgui.SameLine()
            else
                i = 0
            end
            if imgui.ButtonActivated(activeTab == 4, u8'Лог / Рендер', size) then
                activeTab = 4
            end
            if imgui.IsItemClicked() and imgui.IsMouseDoubleClicked(0) then
                logMenu.v = true
            end
        end
        if not anotherMenu.v then
            i = i + 1
            if i < maxElements then
                imgui.SameLine()
            else
                i = 0
            end
            if imgui.ButtonActivated(activeTab == 5, u8'Прочее', size) then
                activeTab = 5
            end
            if imgui.IsItemClicked() and imgui.IsMouseDoubleClicked(0) then
                anotherMenu.v = true
            end
        end
        if not settingsMenu.v then
            i = i + 1
            if i < maxElements then
                imgui.SameLine()
            else
                i = 0
            end
            if imgui.ButtonActivated(activeTab == 6, u8'Настройки', size) then
                activeTab = 6
            end
            if imgui.IsItemClicked() and imgui.IsMouseDoubleClicked(0) then
                settingsMenu.v = true
            end
        end
        if not configMenu.v then
            i = i + 1
            if i < maxElements then
                imgui.SameLine()
            else
                i = 0
            end
            if imgui.ButtonActivated(activeTab == 7, u8'Конфиги', size) then
                activeTab = 7
            end
            if imgui.IsItemClicked() and imgui.IsMouseDoubleClicked(0) then
                configMenu.v = true
            end
        end
        imgui.PopStyleVar()
        imgui.PopStyleVar()
        imgui.Separator()
        if activeTab == 1 and not nopsMenu.v then
            imguiRenderNops()
        end
        if activeTab == 2 and not sendMenu.v then
            imguiRenderSend()
        end
        if activeTab == 3 and not bruteMenu.v then
            imguiRenderBrute()
        end
        if activeTab == 4 and not logMenu.v then
            imguiRenderLog()
        end
        if activeTab == 5 and not anotherMenu.v then
            imguiRenderAnother()
        end
        if activeTab == 6 and not settingsMenu.v then
            imguiRenderSettings()
        end
        if activeTab == 7 and not configMenu.v then
            imguiRenderConfig()
        end
        if imgui.IsWindowHovered() then
            menuPos = imgui.GetWindowPos()
        end
        if needsHide then
            needsHide = false
            menuActive.v = false
        end
        imgui.End()
    end

    if needsInit == 2 and not nopsMenu.v then
        needsHide = true
        nopsMenu.v = true
    end
    if nopsMenu.v then
        imgui.SetNextWindowSize(imgui.ImVec2(525, 285), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(nopsMenuPos, needsInit ~= 2 and imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Bypasser | Нопы', nopsMenu, imgui.WindowFlags.NoResize)
        imguiRenderNops()
        if imgui.IsWindowHovered() then
            nopsMenuPos = imgui.GetWindowPos()
        end
        if needsHide then
            needsHide = false
            nopsMenu.v = false
        end
        imgui.End()
    end

    if needsInit == 2 and not sendMenu.v then
        needsHide = true
        sendMenu.v = true
    end
    if sendMenu.v then
        imgui.SetNextWindowSize(imgui.ImVec2(225, 300), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(sendMenuPos, needsInit ~= 2 and imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Bypasser | Отправка', sendMenu, imgui.WindowFlags.NoResize)
        imguiRenderSend()
        if imgui.IsWindowHovered() then
            sendMenuPos = imgui.GetWindowPos()
        end
        if needsHide then
            needsHide = false
            sendMenu.v = false
        end
        imgui.End()
    end

    if needsInit == 2 and not bruteMenu.v then
        needsHide = true
        bruteMenu.v = true
    end
    if bruteMenu.v then
        imgui.SetNextWindowSize(imgui.ImVec2(525, 305), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(bruteMenuPos, needsInit ~= 2 and imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Bypasser | Перебор', bruteMenu, imgui.WindowFlags.NoResize)
        imguiRenderBrute()
        if imgui.IsWindowHovered() then
            bruteMenuPos = imgui.GetWindowPos()
        end
        if needsHide then
            needsHide = false
            bruteMenu.v = false
        end
        imgui.End()
    end

    if needsInit == 2 and not logMenu.v then
        needsHide = true
        logMenu.v = true
    end
    if logMenu.v then
        imgui.SetNextWindowSize(imgui.ImVec2(260, 220), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(logMenuPos, needsInit ~= 2 and imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Bypasser | Лог / Рендер', logMenu, imgui.WindowFlags.NoResize)
        imguiRenderLog()
        if imgui.IsWindowHovered() then
            logMenuPos = imgui.GetWindowPos()
        end
        if needsHide then
            needsHide = false
            logMenu.v = false
        end
        imgui.End()
    end

    if needsInit == 2 and not settingsMenu.v then
        needsHide = true
        settingsMenu.v = true
    end
    if settingsMenu.v then
        imgui.SetNextWindowSize(imgui.ImVec2(300, 260), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(settingsMenuPos, needsInit ~= 2 and imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Bypasser | Настройки', settingsMenu, imgui.WindowFlags.NoResize)
        imguiRenderSettings()
        if imgui.IsWindowHovered() then
            settingsMenuPos = imgui.GetWindowPos()
        end
        if needsHide then
            needsHide = false
            settingsMenu.v = false
        end
        imgui.End()
    end

    if needsInit == 2 and not anotherMenu.v then
        needsHide = true
        anotherMenu.v = true
    end
    if anotherMenu.v then
        imgui.SetNextWindowSize(imgui.ImVec2(240, 180), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(anotherMenuPos, needsInit ~= 2 and imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Bypasser | Прочее', anotherMenu, imgui.WindowFlags.NoResize)
        imguiRenderAnother()
        if imgui.IsWindowHovered() then
            anotherMenuPos = imgui.GetWindowPos()
        end
        if needsHide then
            needsHide = false
            anotherMenu.v = false
        end
        imgui.End()
    end
    
    if needsInit == 2 and not configMenu.v then
        needsHide = true
        configMenu.v = true
    end
    if configMenu.v then
        imgui.SetNextWindowSize(imgui.ImVec2(525, 285), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(configMenuPos, needsInit ~= 2 and imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Bypasser | Конфиги', configMenu, imgui.WindowFlags.NoResize)
        imguiRenderConfig()
        if imgui.IsWindowHovered() then
            configMenuPos = imgui.GetWindowPos()
        end
        if needsHide then
            needsHide = false
            configMenu.v = false
        end
        imgui.End()
    end

    --if needsInit == 2 then sampAddChatMessage('disabled', -1)  end
    if needsInit == 2 then needsInit = 0 end

end

function imguiRenderNops()
    imgui.BeginChild('##noptabs', imgui.ImVec2(-0.1, 45 ), false)
    if imgui.ButtonActivated(nopsTab == 1, u8'Входящие пакеты##nop', imgui.ImVec2(123, 20)) then
        nopsTab = 1
    end
    imgui.SameLine()
    if imgui.ButtonActivated(nopsTab == 2, u8'Входящие RPC##nop', imgui.ImVec2(123, 20)) then
        nopsTab = 2
    end
    imgui.SameLine()
    if imgui.ButtonActivated(nopsTab == 3, u8'Исходящие пакеты##nop', imgui.ImVec2(123, 20)) then
        nopsTab = 3
    end
    imgui.SameLine()
    if imgui.ButtonActivated(nopsTab == 4, u8'Исходящие RPC##nop', imgui.ImVec2(123, 20)) then
        nopsTab = 4
    end
    if imgui.ButtonActivated(nopsTab == 5, u8'Нопнутые##nop', imgui.ImVec2(123, 20)) then
        nopsTab = 5
    end
    imgui.EndChild()
    imgui.PushItemWidth(-0.1)
    nopsList = getNops()
    imgui.ListBox('##test', selectedNop, nopsList, 8, callback)
    if imgui.IsItemClicked() and imgui.IsMouseDoubleClicked(0) then
        local packet = getSelectedNop()
        if packet ~= nil then
            packet.isNopped = not packet.isNopped
        end
    end
    imgui.PopItemWidth()
    imgui.PushItemWidth(-0.1)
    imgui.InputTextWithHint('##nopfilter', u8'Фильтр', nopFilerBox)
    imgui.PopItemWidth()
    local packet = getSelectedNop()
    if packet ~= nil then
        if imgui.Button((packet.isNopped and u8'Выключить' or u8'Включить') .. ' NOP', imgui.ImVec2(100, 20)) then
            packet.isNopped = not packet.isNopped
        end
        imgui.SameLine()
    end
    if nopsTab ~= 0 then
        if imgui.Button(u8'Переключить всё', imgui.ImVec2(120, 20)) then
            for k, packetName in pairs(nopsList) do
                local packet = getNopByName(packetName, packetName:find('##outcoming'))
                packet.isNopped = not packet.isNopped
            end
        end
    end
end

function imguiRenderSend()
    if imgui.Button(u8'Заспавниться', imgui.ImVec2(-0.1, 20)) then
        sampSpawnPlayer()
        restoreCameraJumpcut()
    end
    if imgui.Button(u8'Заспавниться (эмуляция)', imgui.ImVec2(-0.1, 20)) then
        emul_rpc('onRequestSpawnResponse', {true})
        emul_rpc('onSetSpawnInfo', {0, getCharModel(PLAYER_PED), 0, {0, 0, 0}, 0, {0}, {0}})
        restoreCameraJumpcut()
    end
    if imgui.Button(u8'RequestSpawn', imgui.ImVec2(-0.1, 20)) then
        sampSendRequestSpawn()
    end
    if imgui.Button(u8'В спектатор', imgui.ImVec2(100, 20)) then
        emul_rpc('onTogglePlayerSpectating', {true})
    end
    imgui.SameLine()
    if imgui.Button(u8'Из спектатора', imgui.ImVec2(100, 20)) then
        emul_rpc('onTogglePlayerSpectating', {false})
    end
    imgui.Checkbox(u8'Onfoot Sync >> Spectator Sync', sendConvertOnfootToSpectator)
    imgui.Text(u8'В спектаторе: ' .. (sapi.Get().pBase.pPools.pPlayer.pLocalPlayer.iIsSpectating == 1 and u8'Да' or u8'Нет'))
    if imgui.Combo(u8'Gamestate', sendGamestate, {'None', 'Wait Connect', 'Await Join', 'Connected', 'Restarting', 'Disconnected'}) then
        sampSetGamestate(sendGamestate.v)
    end
    imgui.PushItemWidth(50)
    imgui.InputInt('##sendinterior', sendInterior, 0, 0)
    imgui.PopItemWidth()
    imgui.SameLine()
    if imgui.Button(u8'Изменить интерьер', imgui.ImVec2(-0.1, 20)) then
        sampSendInteriorChange(sendInterior.v)
        setInteriorVisible(sendInterior.v)
    end
    imgui.PushItemWidth(50)
    imgui.InputInt('##sendtextdraw', sendTextdraw, 0, 0)
    imgui.PopItemWidth()
    imgui.SameLine()
    if imgui.Button(u8'Кликнуть textdraw', imgui.ImVec2(-0.1, 20)) then
        sampSendClickTextdraw(sendTextdraw.v)
    end
    imgui.PushItemWidth(50)
    imgui.InputInt('##sendpickup', sendPickup, 0, 0)
    imgui.PopItemWidth()
    imgui.SameLine()
    if imgui.Button(u8'Поднять pickup', imgui.ImVec2(-0.1, 20)) then
        sampSendPickedUpPickup(sendPickup.v)
    end
    imgui.PushItemWidth(50)
    imgui.InputInt('##sendrc', sendRC, 0, 0)
    imgui.PopItemWidth()
    imgui.SameLine()
    if imgui.Button(u8'RequestClass', imgui.ImVec2(-0.1, 20)) then
        sampRequestClass(sendRC.v)
    end
end

function imguiRenderBrute()
    imgui.PushItemWidth(200)
    imgui.Combo(u8'Что будем перебирать?', bruteSelectedRpc, {u8'Текстдравы', u8'Пикапы', u8'RequestClass'})
    imgui.PopItemWidth()
    imgui.SameLine()
    imgui.PushItemWidth(50)
    imgui.InputInt(u8'Задержка##brute', bruteDelay, 0, 0, bruteEnabled and imgui.InputTextFlags.ReadOnly)
    imgui.PopItemWidth()
    imgui.PushItemWidth(50)
    imgui.InputInt(u8'От##brute', bruteMin, 0, 0, bruteEnabled and imgui.InputTextFlags.ReadOnly)
    imgui.PopItemWidth()
    imgui.SameLine()
    imgui.PushItemWidth(50)
    imgui.InputInt(u8'До##brute', bruteMax, 0, 0, bruteEnabled and imgui.InputTextFlags.ReadOnly)
    imgui.PopItemWidth()
    if imgui.Button((bruteEnabled and u8'Выключить' or u8'Включить') .. u8' перебор', imgui.ImVec2(-0.1, 20)) then
        bruteEnabled = not bruteEnabled
        brutePaused = false
        if bruteEnabled then
            bruteBox.v = ''
            lua_thread.create(brute)
        end   
    end
    if bruteEnabled then
        if imgui.Button(brutePaused and u8'Продолжить' or u8'Пауза', imgui.ImVec2(-0.1, 20)) then
            brutePaused = not brutePaused
        end
    end
    imgui.Text(u8'Текущий ID: ' .. bruteCurrent)
    imgui.PushItemWidth(-0.1)
    imgui.InputTextMultiline('##brutegood', bruteGetFilteredString(), 10, imgui.InputTextFlags.ReadOnly)
    imgui.PopItemWidth()
    imgui.PushItemWidth(-0.1)
    imgui.InputTextWithHint('##brutefilter', u8'Фильтр', bruteFilterBox)
    imgui.PopItemWidth()
end

function imguiRenderLog()
    imgui.Checkbox(u8'Отображать пикапы (место, id)', logRenderPickups)
    imgui.Checkbox(u8'Логгировать поднятые пикапы', logPickedUpPickups)
    imgui.Separator()
    imgui.Checkbox(u8'Отображать ID текстдравов', logRenderTextdraws)
    imgui.Checkbox(u8'Логгировать кликнутые текстдравы', logClickedTextdraws)
    imgui.Separator()
    imgui.InputTextMultiline('##logbox', logBox, imgui.ImVec2(-0.1, -0.1))
end

function imguiRenderAnother()
    if imgui.Button(u8'Показать диалог', imgui.ImVec2(110, 20)) then
        enableDialog(true)
    end
    imgui.SameLine()
    if imgui.Button(u8'Скрыть диалог', imgui.ImVec2(110, 20)) then
        enableDialog(false)
    end
    imgui.Combo(u8'Выбранное оружие', anotherSelectedWeapon, getWeaponNameList())
    imgui.Checkbox(u8'Рандомное кол-во патронов', anotherRandomAmmo)
    if not anotherRandomAmmo.v then
        imgui.PushItemWidth(50)
        imgui.InputInt(u8'Кол-во патронов', anotherAmmoAmount, 0, 0)
        imgui.PopItemWidth()
    end
    if imgui.Button(u8'Выдать оружие', imgui.ImVec2(110, 20)) then
        local id = getRealWeaponId()
        requestModel(getWeapontypeModel(id))
        loadAllModelsNow()
        local ammo = anotherRandomAmmo.v and math.random(1, 9999) or anotherAmmoAmount.v
        giveWeaponToChar(PLAYER_PED, id, ammo)
    end
    imgui.SameLine()
    if imgui.Button(u8'Забрать оружие', imgui.ImVec2(110, 20)) then
        local id = getRealWeaponId()
        removeWeaponFromChar(PLAYER_PED, id)
    end
    if imgui.Button(u8'Забрать всё оружие', imgui.ImVec2(-0.1, 20)) then
        removeAllCharWeapons(PLAYER_PED)
    end
end

function imguiRenderConfig()
    configList = getConfigListNames()
    imgui.PushItemWidth(-0.1)
    imgui.ListBox(u8'##configlist', selectedConfig, configList, 8)
    imgui.PopItemWidth()
    if imgui.IsItemClicked(0) then
        lua_thread.create(function() 
            wait(150)
            updateConfig(getConfigByIndex(preConfig).name)
            saveConfig(getConfigByIndex(preConfig))
            setConfig(getConfigByIndex(selectedConfig.v).name)
            preConfig = selectedConfig.v
        end)
    end
    imgui.PushItemWidth(-0.1)
    imgui.InputTextWithHint('##configName', u8'Название', configNameBox)
    imgui.PopItemWidth()
    local size = imgui.ImVec2(100, 20)
    if imgui.Button(u8'Создать##config', size) then
        if configNameBox.v:len() > 0 then
            if isConfigNameAvailable(configNameBox.v) then
                lua_thread.create(function() 
                    wait(0)
                    createConfig(configNameBox.v)
                    updateConfig(getConfigByIndex(selectedConfig.v).name)
                    saveConfig(getConfigByIndex(selectedConfig.v))
                    selectedConfig.v = table.getn(configs) - 1
                    preConfig = selectedConfig.v
                    setConfig(configNameBox.v)
                end)
            end
        end
    end
    imgui.SameLine()
    if imgui.Button(u8'Удалить##config', size) then
        lua_thread.create(function()
            wait(0)
            deleteConfig(selectedConfig.v)
            if table.getn(configs) == 0 then
                createConfig('Default')
            end
            selectedConfig.v = 0
            preConfig = 0
            setConfig(getConfigByIndex(selectedConfig.v).name)
        end)
    end
    imgui.SameLine()
    if imgui.Button(u8'Дублировать##config', size) then
        if configNameBox.v:len() > 0 then
            if isConfigNameAvailable(configNameBox.v) then
                lua_thread.create(function() 
                    wait(0)
                    local config = clone(getConfigByIndex(selectedConfig.v))
                    config.name = configNameBox.v
                    table.insert(configs, config)
                    updateConfig(getConfigByIndex(selectedConfig.v).name)
                    saveConfig(getConfigByIndex(selectedConfig.v))
                    selectedConfig.v = table.getn(configs) - 1
                    preConfig = selectedConfig.v
                    setConfig(configNameBox.v)
                end)
            end
        end
    end
end

function imguiRenderSettings()
    if imgui.Combo(u8'Стиль ImGui', settingsSelectedTheme, getThemeNames(true)) then
        setTheme(settingsSelectedTheme.v)
    end
    imgui.Separator()
    imgui.Checkbox(u8'Сохранять вкладку "Нопы"', settingsSaveNops)
    imgui.Checkbox(u8'Сохранять вкладку "Отправка"', settingsSaveSend)
    imgui.Checkbox(u8'Сохранять вкладку "Перебор"', settingsSaveBrute)
    imgui.Checkbox(u8'Сохранять вкладку "Лог / Рендер"', settingsSaveLog)
    imgui.Checkbox(u8'Сохранять вкладку "Прочее"', settingsSaveAnother)
    imgui.Separator()
    imgui.PushItemWidth(50)
    imgui.InputText('##settingsHideCursor', settingsShowMenuCode)
    imgui.PopItemWidth()
    imgui.SameLine()
    imgui.Text(u8'Чит-Код для скрытия и показа меню')
    imgui.PushItemWidth(50)
    imgui.InputText('##settingsShowMenu', settingsHideCursorCode)
    imgui.PopItemWidth()
    imgui.SameLine()
    imgui.Text(u8'Чит-Код для скрытия и показа курсора')
    if snowEnabled then
        if imgui.Button(u8'УБРАТЬ ЭТОТ ЧЁРТОВ СНЕГОПАД НАВСЕГДА', imgui.ImVec2(-0.1, 20)) then
            disableSnowForever()
        end
    end
end

function disableSnowForever()
    disableSnowForeverV = true
    snowEnabled = false
    sampAddChatMessage('{AAAAAA}Дед мороз не придёт к тебе, мерзавец...', 0xFFAAAAAA)
end

function SnowAI()
    while snowEnabled do
        wait(math.random(100, 500))
        if table.getn(snows) < snowOnScreen then
            local snow = {x = math.random(0, 1920), y = 0}
            table.insert(snows, snow)
        end
    end
    snows = {}
end

function renderSnow()
    for k, snow in pairs(snows) do
        snow.y = snow.y + 1
        snow.x = snow.x + math.random(-0.00010, 0.00010)
        if snow.y > yw then
            table.remove(snows, k)
        else
            if menuActive.v then
                renderDrawPolygon(snow.x, snow.y, 5, 5, 8, 0, 0xFFFFFFFF)
            end
        end
    end
end

function getConfigListNames()
    local configListNames = {}
    for k, config in pairs(configs) do
        table.insert(configListNames, config.name)
    end
    return configListNames
end

function loadSettings()
    local date = os.date('*t')
    local dir = getWorkingDirectory() .. '/config/bypasser/'
    local ini = inicfg.load(nil, dir .. 'settings.ini')
    selectedConfig.v = ini.settings.selectedConfig
    disableSnowForeverV = ini.settings.disableThisShitSnowfall
    snowEnabled = not disableSnowForeverV and ((date.month == 12 and date.day >= 24) or (date.month == 1 and date.day <= 7))
    preConfig = selectedConfig.v
    if selectedConfig.v > table.getn(configs) - 1 then
        selectedConfig.v = 0
    end
    setConfig(getConfigByIndex(selectedConfig.v).name)
end

function loadConfigs()
    local dir = getWorkingDirectory() .. '/config/bypasser'
    dir = getWorkingDirectory() .. '/config/bypasser/configs'
    local handle, name = findFirstFile(dir .. '/*.json')
    while name do
        if handle then
            if not name then
                findClose(name)
            else
                loadConfig(name)
                name = findNextFile(handle)
            end
        end
    end
    if table.getn(configs) == 0 then
        local config = createConfig('Default')
        saveConfig(config)
    end
end

function convertTableToJsonString(data)
    return (neatJSON(data, {sort = true, wrap = 40}))
end

function setConfig(name)
   -- sampAddChatMessage('set: ' .. name, -1)
    local config = getConfig(name)
    if config ~= nil then
        disableAllNops()

        settingsSaveNops.v = config.settings.saveNops
        settingsSaveSend.v = config.settings.saveSend
        settingsSaveLog.v = config.settings.saveLog
        settingsSaveBrute.v = config.settings.saveBrute
        settingsSaveAnother.v = config.settings.saveAnother

        local nops = config.settings.nops.enabled
        for k, nop in pairs(nops) do
            if nop:find('##incomingPacket', 1, true) then
                for j, packet in pairs(data.packets.incoming) do
                    if nop:find(packet.name, 1, true) then
                        packet.isNopped = true
                        break
                    end
                end
            end
            if nop:find('##incomingRPC', 1, true) then
                for j, packet in pairs(data.rpc.incoming) do
                    if nop:find(packet.name, 1, true) then
                        packet.isNopped = true
                        break
                    end
                end
            end
            if nop:find('##outcomingPacket', 1, true) then
                for j, packet in pairs(data.packets.outcoming) do
                    if nop:find(packet.name, 1, true) then
                        packet.isNopped = true
                        break
                    end
                end
            end
            if nop:find('##outcomingRPC', 1, true) then
                for j, packet in pairs(data.rpc.outcoming) do
                    if nop:find(packet.name, 1, true) then
                        sampAddChatMessage('nopped', -1)
                        packet.isNopped = true
                        break
                    end
                end
            end
        end

        nopFilerBox.v = config.settings.nops.filter

        sendInterior.v = config.settings.send.interior
        sendPickup.v = config.settings.send.pickupId
        sendTextdraw.v = config.settings.send.textdrawId
        sendConvertOnfootToSpectator.v = config.settings.send.convertOnfootToSpectator

        sendRC.v = config.settings.send.sendRC == nil and 0 or config.settings.send.sendRC

        logRenderPickups.v = config.settings.log.renderPickups
        logRenderTextdraws.v = config.settings.log.renderTextdraws
        logPickedUpPickups.v = config.settings.log.logPickups
        logClickedTextdraws.v = config.settings.log.logTextdraws

        bruteMin.v = config.settings.brute.min
        bruteMax.v = config.settings.brute.max
        bruteDelay.v = config.settings.brute.delay
        bruteFilterBox.v = config.settings.brute.filter

        anotherRandomAmmo.v = config.settings.another.randomAmmo
        anotherAmmoAmount.v = config.settings.another.ammo
        anotherSelectedWeapon.v = config.settings.another.selectedWeapon

        settingsSelectedTheme.v = config.settings.selectedTheme

        menuPos.x, menuPos.y = config.windows.main.x, config.windows.main.y

        nopsMenu.v = config.windows.nops.active
        nopsMenuPos.x, nopsMenuPos.y = config.windows.nops.x, config.windows.nops.y

        sendMenu.v = config.windows.send.active
        sendMenuPos.x, sendMenuPos.y = config.windows.send.x, config.windows.send.y

        logMenu.v = config.windows.log.active
        logMenuPos.x, logMenuPos.y = config.windows.log.x, config.windows.log.y

        bruteMenu.v = config.windows.brute.active
        bruteMenuPos.x, bruteMenuPos.y = config.windows.brute.x, config.windows.brute.y

        anotherMenu.v = config.windows.another.active
        anotherMenuPos.x, anotherMenuPos.y = config.windows.another.x, config.windows.another.y

        configMenu.v = config.windows.configs.active
        configMenuPos.x, configMenuPos.y = config.windows.configs.x, config.windows.configs.y

        settingsMenu.v = config.windows.settings.active
        settingsMenuPos.x, settingsMenuPos.y = config.windows.settings.x, config.windows.settings.y

        settingsShowMenuCode.v = config.settings.codes.showMenu
        settingsHideCursorCode.v = config.settings.codes.hideCursor

        setTheme(settingsSelectedTheme.v)
        needsInit = 1
    end
end

function getConfigByIndex(index)
    return configs[index + 1]
end

function isConfigNameAvailable(name)
    for k, config in pairs(configs) do
        if rusLower(config.name):lower() == rusLower(name):lower() then
            return false
        end
    end
    return true
end

function getConfig(name)
    for k, config in pairs(configs) do
        if config.name == name then
            return config
        end
    end
    return nil
end

function loadConfig(fileName)
    local dir = getWorkingDirectory() .. '/config/bypasser/configs/'
    local f = io.open(dir .. fileName, 'r')
    local jsonData = f:read('*a')
    f:close()
    local config = decodeJson(jsonData)
    table.insert(configs, config)
end


function deleteConfig(index)
    local dir = getWorkingDirectory() .. '/config/bypasser/configs/'
    local configName = configs[index + 1].name
    table.remove(configs, index + 1)
    os.remove(dir .. u8:decode(configName) .. '.json')
end

function updateConfig(name)
    local config = getConfig(name)
    if config ~= nil then
        config.settings.saveNops = settingsSaveNops.v
        config.settings.saveSend = settingsSaveSend.v
        config.settings.saveLog = settingsSaveLog.v
        config.settings.saveBrute = settingsSaveBrute.v
        config.settings.saveAnother = settingsSaveAnother.v

        if settingsSaveNops.v then
            config.settings.nops.enabled = getNoppedPackets()
            config.settings.nops.filter = nopFilerBox.v
        end

        if settingsSaveSend.v then
            config.settings.send.interior = sendInterior.v
            config.settings.send.pickupId = sendPickup.v
            config.settings.send.sendRC = sendRC.v
            config.settings.send.textdrawId = sendTextdraw.v
            config.settings.send.convertOnfootToSpectator = sendConvertOnfootToSpectator.v
        end

        if settingsSaveLog.v then
            config.settings.log.renderPickups = logRenderPickups.v
            config.settings.log.renderTextdraws = logRenderTextdraws.v
            config.settings.log.logPickups = logPickedUpPickups.v
            config.settings.log.logTextdraws = logClickedTextdraws.v
        end

        if settingsSaveBrute.v then
            config.settings.brute.min = bruteMin.v
            config.settings.brute.max = bruteMax.v
            config.settings.brute.delay = bruteDelay.v
            config.settings.brute.filter = bruteFilterBox.v
        end

        if settingsSaveAnother.v then
            config.settings.another.randomAmmo = anotherRandomAmmo.v
            config.settings.another.ammo = anotherAmmoAmount.v
            config.settings.another.selectedWeapon = anotherSelectedWeapon.v
        end

        config.settings.selectedTheme = settingsSelectedTheme.v

        config.settings.codes.showMenu = settingsShowMenuCode.v
        config.settings.codes.hideCursor = settingsHideCursorCode.v

        config.windows.main.x, config.windows.main.y = menuPos.x, menuPos.y

        config.windows.nops.active = nopsMenu.v
        config.windows.nops.x, config.windows.nops.y = nopsMenuPos.x, nopsMenuPos.y

        config.windows.send.active = sendMenu.v
        config.windows.send.x, config.windows.send.y = sendMenuPos.x, sendMenuPos.y

        config.windows.log.active = logMenu.v
        config.windows.log.x, config.windows.log.y = logMenuPos.x, logMenuPos.y

        config.windows.brute.active = bruteMenu.v
        config.windows.brute.x, config.windows.brute.y = bruteMenuPos.x, bruteMenuPos.y

        config.windows.another.active = anotherMenu.v
        config.windows.another.x, config.windows.another.y = anotherMenuPos.x, anotherMenuPos.y

        config.windows.configs.active = configMenu.v
        config.windows.configs.x, config.windows.configs.y = configMenuPos.x, configMenuPos.y

        config.windows.settings.active = settingsMenu.v
        config.windows.settings.x, config.windows.settings.y = settingsMenuPos.x, settingsMenuPos.y
    end
end

function saveConfig(config)
    local dir = getWorkingDirectory() .. '/config/bypasser/configs'
    local jsonData = convertTableToJsonString(config)
    local f = io.open(dir .. '/' .. u8:decode(config.name) .. '.json', 'w')
    f:write(jsonData)
    f:close()
end

function createConfig(name)
    local xw, yw = getScreenResolution()
    local config = {
        name = name, 
        settings = {
            nops = {
                enabled = {}, 
                filter = ''
            }, 
            send = {
                interior = 0, 
                pickupId = 0, 
                textdrawId = 0, 
                convertOnfootToSpectator = false
            },
            log = {
                renderPickups = false,
                renderTextdraws = false,
                logPickups = false,
                logTextdraws = false
            },
            brute = {
                min = 1,
                max = 1000,
                delay = 100,
                filter = ''
            },
            another = {
                randomAmmo = false,
                ammo = 1000,
                selectedWeapon = 0
            },
            codes = {
                showMenu = 'BP',
                hideCursor = 'BC'
            },
            saveNops = false,
            saveSend = false,
            saveLog = false,
            saveBrute = false,
            saveAnother = false,
            selectedTheme = 0,
        },
        windows = {
            main = {
                active = false,
                x = xw / 2,
                y = yw / 2
            },
            nops = {
                active = false,
                x = xw / 2,
                y = yw / 2
            },
            send = {
                active = false,
                x = xw / 2,
                y = yw / 2
            },
            log = {
                active = false,
                x = xw / 2,
                y = yw / 2
            },
            brute = {
                active = false,
                x = xw / 2,
                y = yw / 2
            },
            another = {
                active = false,
                x = xw / 2,
                y = yw / 2
            },
            configs = {
                active = false,
                x = xw / 2,
                y = yw / 2
            },
            settings = {
                active = false,
                x = xw / 2,
                y = yw / 2
            }
        }
    }
    table.insert(configs, config)
    return config
end

function brute()
    bruteMode = bruteSelectedRpc.v
    if bruteMin.v > bruteMax.v then
        local t = bruteMin.v
        bruteMin.v = bruteMax.v
        bruteMax.v = t
    end
    for i = bruteMin.v, bruteMax.v do
        while brutePaused do
            wait(0)
        end
        if not bruteEnabled then
            break
        end
        bruteCurrent = i
        if bruteMode == 0 then
            sampSendClickTextdraw(bruteCurrent)
        end
        if bruteMode == 1 then
            sampSendPickedUpPickup(bruteCurrent)
        end
        if bruteMode == 2 then
            sampRequestClass(bruteCurrent)
        end
        wait(bruteDelay.v)
    end
    bruteEnabled = false
end

function bruteGetFilteredString()
    local filter = bruteFilterBox.v
    bruteFilteredBox.v = ''
    if filter ~= '' then
        local lines = split(bruteBox.v, '\n')
        for k, v in pairs(lines) do
            if v:lower():find(filter:lower(), 1, true) then
                bruteFilteredBox.v = bruteFilteredBox.v .. v .. '\n'
            end
        end
    else
        bruteFilteredBox.v = bruteBox.v
    end
    return bruteFilteredBox
end

function bruteAddLog(text)
    bruteBox.v = bruteBox.v .. '[ID: ' .. bruteCurrent .. '] - ' .. text .. '\n'
end

function main()
    repeat wait(0) until isSampAvailable()
    while not sapi.GetIsAvailable() do wait(0) end
    if sampGetGamestate() == 3 then
        server.ip, server.port = sampGetCurrentServerAddress()
        for pickupId = 1, 4096 do
            local pickup = sampGetPickupHandleBySampId(pickupId)
            if pickup ~= nil then
                local x, y, z = getPickupCoordinates(pickup)
                table.insert(pickups, {id = pickupId, pos = {x = x, y = y, z = z}})
            end
        end
    end
    for k, v in pairs(sf) do
        local packet = {name = k, id = v, isNopped = false}
        if k:find('PACKET_', 1, true) then
            table.insert(data.packets.outcoming, packet)
            table.insert(data.packets.incoming, clone(packet))
        elseif k:find('RPC_SCR', 1, true) then
            table.insert(data.rpc.incoming, packet)
        elseif k:find('RPC_', 1, true) then
            table.insert(data.rpc.outcoming, packet)
        end
    end
    loadConfigs()
    loadSettings()
    table.sort(data.packets.outcoming, function(a, b) return a.name:upper() < b.name:upper() end)
    table.sort(data.packets.incoming, function(a, b) return a.name:upper() < b.name:upper() end)
    table.sort(data.rpc.incoming, function(a, b) return a.name:upper() < b.name:upper() end)
    table.sort(data.rpc.outcoming, function(a, b) return a.name:upper() < b.name:upper() end)
    lua_thread.create(function() 
        while true do
            wait(500)
            local gamestate = sampGetGamestate()
            if sendGamestate.v ~= gamestate then
                sendGamestate.v = gamestate
            end
        end
    end)
    if snowEnabled then lua_thread.create(SnowAI) end
    while true do
        wait(0)
        if snowEnabled then renderSnow() end
        imgui.Process = menuActive.v
        if preMenuActive ~= menuActive.v then
            preMenuActive = menuActive.v
            if not preMenuActive then
                local dir = getWorkingDirectory() .. '/config/bypasser/'
                --sampAddChatMessage('saving...', -1)
                updateConfig(getConfigByIndex(selectedConfig.v).name)
                saveConfig(getConfigByIndex(selectedConfig.v))
                local ini = inicfg.save({
                    settings = {
                        selectedConfig = selectedConfig.v,
                        disableThisShitSnowfall=disableSnowForeverV
                    }
                }, dir .. 'settings.ini')
            end
        end
        if imgui.Process then
            imgui.ShowCursor = not menuHideCursor.v
        end
        if testCheat(settingsShowMenuCode.v) then
            menuActive.v = not menuActive.v
        end
        if testCheat(settingsHideCursorCode.v) then
            menuHideCursor.v = not menuHideCursor.v
        end
        if logRenderPickups.v then
            local x, y, z = getCharCoordinates(PLAYER_PED)
            for k, pickup in pairs(pickups) do
                local pos = pickup.pos
                if isPointOnScreen(pos.x, pos.y, pos.z, 0) then
                    if getDistanceBetweenCoords3d(x, y, z, pos.x, pos.y, pos.z) <= 1000 then
                        local pxw, pyw = convert3DCoordsToScreen(pos.x, pos.y, pos.z)
                        local xw, yw = convert3DCoordsToScreen(x, y, z)
                        renderDrawLine(xw, yw, pxw, pyw, 1, getActualTheme()[3])
                        renderFontDrawText(font, 'Pickup: ' .. pickup.id, pxw, pyw, getActualTheme()[3])
                    end
                end
            end
        end
        if logRenderTextdraws.v then
            for id = 1, 2048 do
                if sampTextdrawIsExists(id) then
                    local x, y = sampTextdrawGetPos(id)
                    local xw, yw = convertGameScreenCoordsToWindowScreenCoords(x, y)
                    renderFontDrawText(font, 'Textdraw: ' .. id, xw, yw, getActualTheme()[3])
                end
            end
        end
    end
end

function ev.onSendPlayerSync(data)
    if sendConvertOnfootToSpectator.v then
        sendSpectator(data)
        return false
    end
end

local russian_characters = {
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}

function rusLower(s)
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
        output = output .. russian_characters[ch+32]
        elseif ch == 168 then -- Ё
        output = output .. russian_characters[184]
        else
        output = output .. string.char(ch)
        end
    end
    return output
end

function sendSpectator(data)
    sync = samp_create_sync_data('spectator')
    sync.position = data.position
    sync.keysData = data.keysData
    sync.leftRightKeys = data.leftRightKeys
    sync.upDownKeys = data.upDownKeys
    sync.send()
end

function ev.onSendPickedUpPickup(id)
    if logPickedUpPickups.v then
        logBox.v = logBox.v .. 'Pickup: ' .. id .. '\n'
    end
end

function ev.onSendClickTextDraw(id)
    if logClickedTextdraws.v then
        logBox.v = logBox.v .. 'Textdraw: ' .. id .. '\n'
    end
end

function ev.onCreatePickup(id, model, type, pos)
    for k, pickup in pairs(pickups) do
        if pickup.id == id then
            return {id, model, type, pos}
        end
    end
    table.insert(pickups, {id = id, pos = pos})
end

function ev.onSendClientJoin(ver, mod, nick, response, authkey, clientVer, unk)
    local ip, port = sampGetCurrentServerAddress()
    if ip ~= server.ip or port ~= server.port then
        server.ip = ip
        server.port = port
        pickups = {}
    end
end

function getMyId()
    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    return id
end

function enableDialog(bool)
    local memory = require 'memory'
    memory.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
    sampToggleCursor(bool)
end

function onReceivePacket(id, bitStream)
    if isNopped(id, false, true) then
        return false
    end
end

function getRealWeaponId()
    local weaponList = getWeaponNameList()
    local weaponName = weaponList[anotherSelectedWeapon.v + 1]
    for k, weapon in pairs(weapons.names) do
        if weapon == weaponName then
            return k
        end
    end
    return 0
end

function getWeaponNameList()
    local weaponList = {}
    for k, weapon in pairs(weapons.names) do
        table.insert(weaponList, weapon)
    end
    return weaponList
end

function onReceiveRpc(id, bitStream)
    if bruteEnabled and not brutePaused then
        if id == 12 then
            bruteAddLog('SetPlayerPos')
        end
        if id == 13 then
            bruteAddLog('SetPlayerPosFindZ')
        end
        if id == 86 then
            local playerid = raknetBitStreamReadInt16(bitStream)
            if playerid == getMyId() then
                bruteAddLog('ApplyPlayerAnimation')
            end
        end
        if id == 87 then
            local playerid = raknetBitStreamReadInt16(bitStream)
            if playerid == getMyId() then
                bruteAddLog('ClearPlayerAnimation')
            end
        end
        if id == 153 then
            local playerid = raknetBitStreamReadInt32(bitStream)
            if playerid == getMyId() then
                bruteAddLog('SetPlayerSkin')
            end
        end
        if id == 15 then
            bruteAddLog('TogglePlayerControllable')
        end
        if id == 88 then
            bruteAddLog('SetPlayerSpecialAction')
        end
        if id == 69 then
            local playerid = raknetBitStreamReadInt16(bitStream)
            if playerid == getMyId() then
                bruteAddLog('SetPlayerTeam')
            end
        end
        if id == 124 then
            bruteAddLog('TogglePlayerSpectating')
        end
        if id == 16 then
            bruteAddLog('PlayerPlaySound')
        end
        if id == 18 then
            bruteAddLog('GivePlayerMoney')
        end
        if id == 20 then
            bruteAddLog('ResetPlayerMoney')
        end
        if id == 21 then
            bruteAddLog('ResetPlayerWeapons')
        end
        if id == 22 then
            bruteAddLog('GivePlayerWeapon')
        end
        if id == 66 then
            bruteAddLog('SetPlayerArmour')
        end
        if id == 145 then
            bruteAddLog('SetPlayerAmmo')
        end
        if id == 156 then
            bruteAddLog('SetPlayerInterior')
        end
        if id == 157 then
            bruteAddLog('SetPlayerCameraPos')
        end
        if id == 133 then
            bruteAddLog('SetPlayerWantedLevel')
        end
        if id == 74 then
            bruteAddLog('ForceClassSelection')
        end
        if id == 158 then
            bruteAddLog('SetPlayerCameraLookAt')
        end
        if id == 68 then
            bruteAddLog('SetSpawnInfo')
        end
        if id == 126 then
            bruteAddLog('SpectatePlayer')
        end
        if id == 127 then
            bruteAddLog('SpectateVehicle')
        end
        if id == 134 then
            bruteAddLog('ShowTextDraw')
        end
        if id == 61 then
            bruteAddLog('ShowDialog')
        end
        if id == 135 then
            bruteAddLog('HideTextDraw')
        end
        if id == 70 then
            bruteAddLog('PutPlayerInVehicle')
        end
        if id == 71 then
            bruteAddLog('RemovePlayerFromVehicle')
        end
        if id == 128 then
            bruteAddLog('RequestClass')
        end
    end
    if isNopped(id, false, false) then
        return false
    end
end

function onSendPacket(id, bitStream, priority, reliability, orderingChannel)
    if isNopped(id, true, true) then
        return false
    end
end

function onSendRpc(id, bitStream, priority, reliability, orderingChannel, shiftTs)
    if isNopped(id, true, false) then
        return false
    end
end

function isNopped(id, outcoming, isPacket)
    if outcoming then
        if isPacket then
            for k, v in pairs(data.packets.outcoming) do
                if v.id == id then
                    return v.isNopped
                end
            end
        else
            for k, v in pairs(data.rpc.outcoming) do
                if v.id == id then
                    return v.isNopped
                end
            end
        end
    else
        if isPacket then
            for k, v in pairs(data.packets.incoming) do
                if v.id == id then
                    return v.isNopped
                end
            end
        else
            for k, v in pairs(data.rpc.incoming) do
                if v.id == id then
                    return v.isNopped
                end
            end
        end
    end
    return false
end

function getSelectedNop()
    local nopName = nopsList[selectedNop.v + 1]
    if nopName ~= nil then
        if nopName:find('##incoming', 1, true) then
            return getNopByName(nopName, false)
        else
            return getNopByName(nopName, true)
        end
    end
    return nil
end

function getNopByName(name, outcoming)
    if outcoming then
        for k, v in pairs(data.rpc.outcoming) do
            if name:find(v.name, 1, true) then
                return v
            end
        end
        for k, v in pairs(data.packets.outcoming) do
            if name:find(v.name, 1, true) then
                return v
            end
        end
    else
        for k, v in pairs(data.rpc.incoming) do
            if name:find(v.name, 1, true) then
                return v
            end
        end
        for k, v in pairs(data.packets.incoming) do
            if name:find(v.name, 1, true) then
                return v
            end
        end
    end
    return nil
end

function getNops()
    local elements = {}
    local filter = nopFilerBox.v
    if nopsTab == 1 then
        for k, v in pairs(data.packets.incoming) do
            if filter == '' or v.name:lower():find(filter:lower(), 1, true) then
                table.insert(elements, v.name .. (v.isNopped and ' [NOPPED]' or '') .. '##incomingPacket')
            end
        end
    end
    if nopsTab == 2 then
        for k, v in pairs(data.rpc.incoming) do
            if filter == '' or v.name:lower():find(filter:lower(), 1, true) then
                table.insert(elements, v.name .. (v.isNopped and ' [NOPPED]' or '') .. '##incomingRPC')
            end
        end
    end
    if nopsTab == 3 then
        for k, v in pairs(data.packets.outcoming) do
            if filter == '' or v.name:lower():find(filter:lower(), 1, true) then
                table.insert(elements, v.name .. (v.isNopped and ' [NOPPED]' or '') .. '##outcomingPacket')
            end
        end
    end
    if nopsTab == 4 then
        for k, v in pairs(data.rpc.outcoming) do
            if filter == '' or v.name:lower():find(filter:lower(), 1, true) then
                table.insert(elements, v.name .. (v.isNopped and ' [NOPPED]' or '') .. '##outcomingRPC')
            end
        end
    end
    if nopsTab == 5 then
        for k, v in pairs(data.packets.incoming) do
            if v.isNopped then
                if filter == '' or v.name:lower():find(filter:lower(), 1, true) then
                    table.insert(elements, u8'[Входящий] ' .. v.name .. '##incomingPacket')
                end
            end
        end
        for k, v in pairs(data.rpc.incoming) do
            if v.isNopped then
                if filter == '' or v.name:lower():find(filter:lower(), 1, true) then
                    table.insert(elements, u8'[Входящий] ' .. v.name .. '##incomingRPC')
                end
            end
        end
        for k, v in pairs(data.packets.outcoming) do
            if v.isNopped then
                if filter == '' or v.name:lower():find(filter:lower(), 1, true) then
                    table.insert(elements, u8'[Исходящий] ' .. v.name .. '##outcomingPacket')
                end
            end
        end
        for k, v in pairs(data.rpc.outcoming) do
            if v.isNopped then
                if filter == '' or v.name:lower():find(filter:lower(), 1, true) then
                    table.insert(elements, u8'[Исходящий] ' .. v.name .. '##outcomingRPC')
                end
            end
        end
    end
    return elements
end

function getNoppedPackets()
    local elements = {}
    for k, v in pairs(data.packets.incoming) do
        if v.isNopped then
            table.insert(elements, v.name .. '##incomingPacket')
        end
    end
    for k, v in pairs(data.rpc.incoming) do
        if v.isNopped then
            table.insert(elements, v.name .. '##incomingRPC')
        end
    end
    for k, v in pairs(data.packets.outcoming) do
        if v.isNopped then
            table.insert(elements, v.name .. '##outcomingPacket')
        end
    end
    for k, v in pairs(data.rpc.outcoming) do
        if v.isNopped then
            table.insert(elements, v.name .. '##outcomingRPC')
        end
    end
    return elements
end

function disableAllNops()
    local elements = {}
    for k, v in pairs(data.packets.incoming) do
        if v.isNopped then
            v.isNopped = false
        end
    end
    for k, v in pairs(data.rpc.incoming) do
        if v.isNopped then
            v.isNopped = false
        end
    end
    for k, v in pairs(data.packets.outcoming) do
        if v.isNopped then
            v.isNopped = false
        end
    end
    for k, v in pairs(data.rpc.outcoming) do
        if v.isNopped then
            v.isNopped = false
        end
    end
    return elements
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function imgui.ButtonActivated(activated, ...)
    if activated then
        imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.CheckMark])
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.CheckMark])

            imgui.Button(...)

        imgui.PopStyleColor()
        imgui.PopStyleColor()
        imgui.PopStyleColor()

    else
        return imgui.Button(...)
    end
end

function imgui.InputTextWithHint(label, hint, buf, flags, callback, user_data)
    local l_pos = {imgui.GetCursorPos(), 0}
    local handle = imgui.InputText(label, buf, flags, callback, user_data)
    l_pos[2] = imgui.GetCursorPos()
    local t = (type(hint) == 'string' and buf.v:len() < 1) and hint or '\0'
    local t_size, l_size = imgui.CalcTextSize(t).x, imgui.CalcTextSize('A').x
    imgui.SetCursorPos(imgui.ImVec2(l_pos[1].x + 8, l_pos[1].y + 2))
    imgui.TextDisabled((imgui.CalcItemWidth() and t_size > imgui.CalcItemWidth()) and t:sub(1, math.floor(imgui.CalcItemWidth() / l_size)) or t)
    imgui.SetCursorPos(l_pos[2])
    return handle
end

function exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
       if code == 13 then
          return true
       end
    end
    return ok, err
 end
 
 function isdir(path)
    return exists(path.."/")
 end

function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function clone (t)
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

function emul_rpc(hook, parameters)
    local bs_io = require 'samp.events.bitstream_io'
    local handler = require 'samp.events.handlers'
    local extra_types = require 'samp.events.extra_types'
    local hooks = {

        --[[ Outgoing rpcs
        ['onSendEnterVehicle'] = { 'int16', 'bool8', 26 },
        ['onSendClickPlayer'] = { 'int16', 'int8', 23 },
        ['onSendClientJoin'] = { 'int32', 'int8', 'string8', 'int32', 'string8', 'string8', 'int32', 25 },
        ['onSendEnterEditObject'] = { 'int32', 'int16', 'int32', 'vector3d', 27 },
        ['onSendCommand'] = { 'string32', 50 },
        ['onSendSpawn'] = { 52 },
        ['onSendDeathNotification'] = { 'int8', 'int16', 53 },
        ['onSendDialogResponse'] = { 'int16', 'int8', 'int16', 'string8', 62 },
        ['onSendClickTextDraw'] = { 'int16', 83 },
        ['onSendVehicleTuningNotification'] = { 'int32', 'int32', 'int32', 'int32', 96 },
        ['onSendChat'] = { 'string8', 101 },
        ['onSendClientCheckResponse'] = { 'int8', 'int32', 'int8', 103 },
        ['onSendVehicleDamaged'] = { 'int16', 'int32', 'int32', 'int8', 'int8', 106 },
        ['onSendEditAttachedObject'] = { 'int32', 'int32', 'int32', 'int32', 'vector3d', 'vector3d', 'vector3d', 'int32', 'int32', 116 },
        ['onSendEditObject'] = { 'bool', 'int16', 'int32', 'vector3d', 'vector3d', 117 },
        ['onSendInteriorChangeNotification'] = { 'int8', 118 },
        ['onSendMapMarker'] = { 'vector3d', 119 },
        ['onSendRequestClass'] = { 'int32', 128 },
        ['onSendRequestSpawn'] = { 129 },
        ['onSendPickedUpPickup'] = { 'int32', 131 },
        ['onSendMenuSelect'] = { 'int8', 132 },
        ['onSendVehicleDestroyed'] = { 'int16', 136 },
        ['onSendQuitMenu'] = { 140 },
        ['onSendExitVehicle'] = { 'int16', 154 },
        ['onSendUpdateScoresAndPings'] = { 155 },
        ['onSendGiveDamage'] = { 'int16', 'float', 'int32', 'int32', 115 },
        ['onSendTakeDamage'] = { 'int16', 'float', 'int32', 'int32', 115 },]]

        -- Incoming rpcs
        ['onInitGame'] = { 139 },
        ['onPlayerJoin'] = { 'int16', 'int32', 'bool8', 'string8', 137 },
        ['onPlayerQuit'] = { 'int16', 'int8', 138 },
        ['onRequestClassResponse'] = { 'bool8', 'int8', 'int32', 'int8', 'vector3d', 'float', 'Int32Array3', 'Int32Array3', 128 },
        ['onRequestSpawnResponse'] = { 'bool8', 129 },
        ['onSetPlayerName'] = { 'int16', 'string8', 'bool8', 11 },
        ['onSetPlayerPos'] = { 'vector3d', 12 },
        ['onSetPlayerPosFindZ'] = { 'vector3d', 13 },
        ['onSetPlayerHealth'] = { 'float', 14 },
        ['onTogglePlayerControllable'] = { 'bool8', 15 },
        ['onPlaySound'] = { 'int32', 'vector3d', 16 },
        ['onSetWorldBounds'] = { 'float', 'float', 'float', 'float', 17 },
        ['onGivePlayerMoney'] = { 'int32', 18 },
        ['onSetPlayerFacingAngle'] = { 'float', 19 },
        --['onResetPlayerMoney'] = { 20 },
        --['onResetPlayerWeapons'] = { 21 },
        ['onGivePlayerWeapon'] = { 'int32', 'int32', 22 },
        --['onCancelEdit'] = { 28 },
        ['onSetPlayerTime'] = { 'int8', 'int8', 29 },
        ['onSetToggleClock'] = { 'bool8', 30 },
        ['onPlayerStreamIn'] = { 'int16', 'int8', 'int32', 'vector3d', 'float', 'int32', 'int8', 32 },
        ['onSetShopName'] = { 'string256', 33 },
        ['onSetPlayerSkillLevel'] = { 'int16', 'int32', 'int16', 34 },
        ['onSetPlayerDrunk'] = { 'int32', 35 },
        ['onCreate3DText'] = { 'int16', 'int32', 'vector3d', 'float', 'bool8', 'int16', 'int16', 'encodedString4096', 36 },
        --['onDisableCheckpoint'] = { 37 },
        ['onSetRaceCheckpoint'] = { 'int8', 'vector3d', 'vector3d', 'float', 38 },
        --['onDisableRaceCheckpoint'] = { 39 },
        --['onGamemodeRestart'] = { 40 },
        ['onPlayAudioStream'] = { 'string8', 'vector3d', 'float', 'bool8', 41 },
        --['onStopAudioStream'] = { 42 },
        ['onRemoveBuilding'] = { 'int32', 'vector3d', 'float', 43 },
        ['onCreateObject'] = { 44 },
        ['onSetObjectPosition'] = { 'int16', 'vector3d', 45 },
        ['onSetObjectRotation'] = { 'int16', 'vector3d', 46 },
        ['onDestroyObject'] = { 'int16', 47 },
        ['onPlayerDeathNotification'] = { 'int16', 'int16', 'int8', 55 },
        ['onSetMapIcon'] = { 'int8', 'vector3d', 'int8', 'int32', 'int8', 56 },
        ['onRemoveVehicleComponent'] = { 'int16', 'int16', 57 },
        ['onRemove3DTextLabel'] = { 'int16', 58 },
        ['onPlayerChatBubble'] = { 'int16', 'int32', 'float', 'int32', 'string8', 59 },
        ['onUpdateGlobalTimer'] = { 'int32', 60 },
        ['onShowDialog'] = { 'int16', 'int8', 'string8', 'string8', 'string8', 'encodedString4096', 61 },
        ['onDestroyPickup'] = { 'int32', 63 },
        ['onLinkVehicleToInterior'] = { 'int16', 'int8', 65 },
        ['onSetPlayerArmour'] = { 'float', 66 },
        ['onSetPlayerArmedWeapon'] = { 'int32', 67 },
        ['onSetSpawnInfo'] = { 'int8', 'int32', 'int8', 'vector3d', 'float', 'Int32Array3', 'Int32Array3', 68 },
        ['onSetPlayerTeam'] = { 'int16', 'int8', 69 },
        ['onPutPlayerInVehicle'] = { 'int16', 'int8', 70 },
        --['onRemovePlayerFromVehicle'] = { 71 },
        ['onSetPlayerColor'] = { 'int16', 'int32', 72 },
        ['onDisplayGameText'] = { 'int32', 'int32', 'string32', 73 },
        --['onForceClassSelection'] = { 74 },
        ['onAttachObjectToPlayer'] = { 'int16', 'int16', 'vector3d', 'vector3d', 75 },
        ['onInitMenu'] = { 76 },
        ['onShowMenu'] = { 'int8', 77 },
        ['onHideMenu'] = { 'int8', 78 },
        ['onCreateExplosion'] = { 'vector3d', 'int32', 'float', 79 },
        ['onShowPlayerNameTag'] = { 'int16', 'bool8', 80 },
        ['onAttachCameraToObject'] = { 'int16', 81 },
        ['onInterpolateCamera'] = { 'bool', 'vector3d', 'vector3d', 'int32', 'int8', 82 },
        ['onGangZoneStopFlash'] = { 'int16', 85 },
        ['onApplyPlayerAnimation'] = { 'int16', 'string8', 'string8', 'bool', 'bool', 'bool', 'bool', 'int32', 86 },
        ['onClearPlayerAnimation'] = { 'int16', 87 },
        ['onSetPlayerSpecialAction'] = { 'int8', 88 },
        ['onSetPlayerFightingStyle'] = { 'int16', 'int8', 89 },
        ['onSetPlayerVelocity'] = { 'vector3d', 90 },
        ['onSetVehicleVelocity'] = { 'bool8', 'vector3d', 91 },
        ['onServerMessage'] = { 'int32', 'string32', 93 },
        ['onSetWorldTime'] = { 'int8', 94 },
        ['onCreatePickup'] = { 'int32', 'int32', 'int32', 'vector3d', 95 },
        ['onMoveObject'] = { 'int16', 'vector3d', 'vector3d', 'float', 'vector3d', 99 },
        ['onEnableStuntBonus'] = { 'bool', 104 },
        ['onTextDrawSetString'] = { 'int16', 'string16', 105 },
        ['onSetCheckpoint'] = { 'vector3d', 'float', 107 },
        ['onCreateGangZone'] = { 'int16', 'vector2d', 'vector2d', 'int32', 108 },
        ['onPlayCrimeReport'] = { 'int16', 'int32', 'int32', 'int32', 'int32', 'vector3d', 112 },
        ['onGangZoneDestroy'] = { 'int16', 120 },
        ['onGangZoneFlash'] = { 'int16', 'int32', 121 },
        ['onStopObject'] = { 'int16', 122 },
        ['onSetVehicleNumberPlate'] = { 'int16', 'string8', 123 },
        ['onTogglePlayerSpectating'] = { 'bool32', 124 },
        ['onSpectatePlayer'] = { 'int16', 'int8', 126 },
        ['onSpectateVehicle'] = { 'int16', 'int8', 127 },
        ['onShowTextDraw'] = { 134 },
        ['onSetPlayerWantedLevel'] = { 'int8', 133 },
        ['onTextDrawHide'] = { 'int16', 135 },
        ['onRemoveMapIcon'] = { 'int8', 144 },
        ['onSetWeaponAmmo'] = { 'int8', 'int16', 145 },
        ['onSetGravity'] = { 'float', 146 },
        ['onSetVehicleHealth'] = { 'int16', 'float', 147 },
        ['onAttachTrailerToVehicle'] = { 'int16', 'int16', 148 },
        ['onDetachTrailerFromVehicle'] = { 'int16', 149 },
        ['onSetWeather'] = { 'int8', 152 },
        ['onSetPlayerSkin'] = { 'int32', 'int32', 153 },
        ['onSetInterior'] = { 'int8', 156 },
        ['onSetCameraPosition'] = { 'vector3d', 157 },
        ['onSetCameraLookAt'] = { 'vector3d', 'int8', 158 },
        ['onSetVehiclePosition'] = { 'int16', 'vector3d', 159 },
        ['onSetVehicleAngle'] = { 'int16', 'float', 160 },
        ['onSetVehicleParams'] = { 'int16', 'int16', 'bool8', 161 },
        --['onSetCameraBehind'] = { 162 },
        ['onChatMessage'] = { 'int16', 'string8', 101 },
        ['onConnectionRejected'] = { 'int8', 130 },
        ['onPlayerStreamOut'] = { 'int16', 163 },
        ['onVehicleStreamIn'] = { 164 },
        ['onVehicleStreamOut'] = { 'int16', 165 },
        ['onPlayerDeath'] = { 'int16', 166 },
        ['onPlayerEnterVehicle'] = { 'int16', 'int16', 'bool8', 26 },
        ['onUpdateScoresAndPings'] = { 'PlayerScorePingMap', 155 },
        ['onSetObjectMaterial'] = { 84 },
        ['onSetObjectMaterialText'] = { 84 },
        ['onSetVehicleParamsEx'] = { 'int16', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 'int8', 24 },
        ['onSetPlayerAttachedObject'] = { 'int16', 'int32', 'bool', 'int32', 'int32', 'vector3d', 'vector3d', 'vector3d', 'int32', 'int32', 113 }

    }
    local handler_hook = {
        ['onInitGame'] = true,
        ['onCreateObject'] = true,
        ['onInitMenu'] = true,
        ['onShowTextDraw'] = true,
        ['onVehicleStreamIn'] = true,
        ['onSetObjectMaterial'] = true,
        ['onSetObjectMaterialText'] = true
    }
    local extra = {
        ['PlayerScorePingMap'] = true,
        ['Int32Array3'] = true
    }
    local hook_table = hooks[hook]
    if hook_table then
        local bs = raknetNewBitStream()
        if not handler_hook[hook] then
            local max = #hook_table-1
            if max > 0 then
                for i = 1, max do
                    local p = hook_table[i]
                    if extra[p] then extra_types[p]['write'](bs, parameters[i])
                    else bs_io[p]['write'](bs, parameters[i]) end
                end
            end
        else
            if hook == 'onInitGame' then handler.on_init_game_writer(bs, parameters)
            elseif hook == 'onCreateObject' then handler.on_create_object_writer(bs, parameters)
            elseif hook == 'onInitMenu' then handler.on_init_menu_writer(bs, parameters)
            elseif hook == 'onShowTextDraw' then handler.on_show_textdraw_writer(bs, parameters)
            elseif hook == 'onVehicleStreamIn' then handler.on_vehicle_stream_in_writer(bs, parameters)
            elseif hook == 'onSetObjectMaterial' then handler.on_set_object_material_writer(bs, parameters, 1)
            elseif hook == 'onSetObjectMaterialText' then handler.on_set_object_material_writer(bs, parameters, 2) end
        end
        raknetEmulRpcReceiveBitStream(hook_table[#hook_table], bs)
        raknetDeleteBitStream(bs)
    end
end

function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    -- from SAMP.Lua
    local raknet = require 'samp.raknet'
    --require 'samp.synchronization'

    copy_from_player = copy_from_player or true
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    -- copy player's sync data to the allocated memory
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    -- function to send packet
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    -- metatable to access sync data and 'send' function
    local mt = {
        __index = function(t, index)
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
end

local imguiThemes = {
    {
        'Красная',
        function()
            local style = imgui.GetStyle()
            local colors = style.Colors
            local clr = imgui.Col
            local ImVec4 = imgui.ImVec4
    
            style.WindowRounding = 2.0
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
            style.ChildWindowRounding = 2.0
            style.FrameRounding = 2.0
            style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 0
            style.GrabMinSize = 8.0
            style.GrabRounding = 1.0
    
            colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
            colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
            colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
            colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
            colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
            colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
            colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
            colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
            colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
            colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
            colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
            colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
            colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
            colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
            colors[clr.Separator]              = colors[clr.Border]
            colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
            colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
            colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
            colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
            colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
            colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
            colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
            colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
            colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
            colors[clr.ComboBg]                = colors[clr.PopupBg]
            colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
            colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
            colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
            colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
            colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
            colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
        end,
        0xFFFA4242
    },
    {
        'Синяя',
        function() 
            local style = imgui.GetStyle()
            local colors = style.Colors
            local clr = imgui.Col
            local ImVec4 = imgui.ImVec4

            style.WindowRounding = 2.0
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
            style.ChildWindowRounding = 2.0
            style.FrameRounding = 2.0
            style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 0
            style.GrabMinSize = 8.0
            style.GrabRounding = 1.0

            colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
            colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
            colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
            colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
            colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
            colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
            colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
            colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
            colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
            colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
            colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
            colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
            colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
            colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
            colors[clr.Separator]              = colors[clr.Border]
            colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
            colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
            colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
            colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
            colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
            colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
            colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
            colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
            colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
            colors[clr.ComboBg]                = colors[clr.PopupBg]
            colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
            colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
            colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
            colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
            colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
            colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
        end,
        0xFF4296FA
    },
    {
        'Коричневая',
        function() 
            local style = imgui.GetStyle()
            local colors = style.Colors
            local clr = imgui.Col
            local ImVec4 = imgui.ImVec4

            style.WindowRounding = 2.0
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
            style.ChildWindowRounding = 2.0
            style.FrameRounding = 2.0
            style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 0
            style.GrabMinSize = 8.0
            style.GrabRounding = 1.0

            colors[clr.FrameBg]                = ImVec4(0.48, 0.23, 0.16, 0.54)
            colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.43, 0.26, 0.40)
            colors[clr.FrameBgActive]          = ImVec4(0.98, 0.43, 0.26, 0.67)
            colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
            colors[clr.TitleBgActive]          = ImVec4(0.48, 0.23, 0.16, 1.00)
            colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            colors[clr.CheckMark]              = ImVec4(0.98, 0.43, 0.26, 1.00)
            colors[clr.SliderGrab]             = ImVec4(0.88, 0.39, 0.24, 1.00)
            colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.43, 0.26, 1.00)
            colors[clr.Button]                 = ImVec4(0.98, 0.43, 0.26, 0.40)
            colors[clr.ButtonHovered]          = ImVec4(0.98, 0.43, 0.26, 1.00)
            colors[clr.ButtonActive]           = ImVec4(0.98, 0.28, 0.06, 1.00)
            colors[clr.Header]                 = ImVec4(0.98, 0.43, 0.26, 0.31)
            colors[clr.HeaderHovered]          = ImVec4(0.98, 0.43, 0.26, 0.80)
            colors[clr.HeaderActive]           = ImVec4(0.98, 0.43, 0.26, 1.00)
            colors[clr.Separator]              = colors[clr.Border]
            colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.25, 0.10, 0.78)
            colors[clr.SeparatorActive]        = ImVec4(0.75, 0.25, 0.10, 1.00)
            colors[clr.ResizeGrip]             = ImVec4(0.98, 0.43, 0.26, 0.25)
            colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.43, 0.26, 0.67)
            colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.43, 0.26, 0.95)
            colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.50, 0.35, 1.00)
            colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.43, 0.26, 0.35)
            colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
            colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
            colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
            colors[clr.ComboBg]                = colors[clr.PopupBg]
            colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
            colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
            colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
            colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
            colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
        end,
        0xFFFA6E42
    },
    {
        'Голубая',
        function() 
            local style = imgui.GetStyle()
            local colors = style.Colors
            local clr = imgui.Col
            local ImVec4 = imgui.ImVec4

            style.WindowRounding = 2.0
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
            style.ChildWindowRounding = 2.0
            style.FrameRounding = 2.0
            style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 0
            style.GrabMinSize = 8.0
            style.GrabRounding = 1.0

            colors[clr.FrameBg]                = ImVec4(0.16, 0.48, 0.42, 0.54)
            colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.98, 0.85, 0.40)
            colors[clr.FrameBgActive]          = ImVec4(0.26, 0.98, 0.85, 0.67)
            colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
            colors[clr.TitleBgActive]          = ImVec4(0.16, 0.48, 0.42, 1.00)
            colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            colors[clr.CheckMark]              = ImVec4(0.26, 0.98, 0.85, 1.00)
            colors[clr.SliderGrab]             = ImVec4(0.24, 0.88, 0.77, 1.00)
            colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.98, 0.85, 1.00)
            colors[clr.Button]                 = ImVec4(0.26, 0.98, 0.85, 0.40)
            colors[clr.ButtonHovered]          = ImVec4(0.26, 0.98, 0.85, 1.00)
            colors[clr.ButtonActive]           = ImVec4(0.06, 0.98, 0.82, 1.00)
            colors[clr.Header]                 = ImVec4(0.26, 0.98, 0.85, 0.31)
            colors[clr.HeaderHovered]          = ImVec4(0.26, 0.98, 0.85, 0.80)
            colors[clr.HeaderActive]           = ImVec4(0.26, 0.98, 0.85, 1.00)
            colors[clr.Separator]              = colors[clr.Border]
            colors[clr.SeparatorHovered]       = ImVec4(0.10, 0.75, 0.63, 0.78)
            colors[clr.SeparatorActive]        = ImVec4(0.10, 0.75, 0.63, 1.00)
            colors[clr.ResizeGrip]             = ImVec4(0.26, 0.98, 0.85, 0.25)
            colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.98, 0.85, 0.67)
            colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.98, 0.85, 0.95)
            colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.81, 0.35, 1.00)
            colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.98, 0.85, 0.35)
            colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
            colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
            colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
            colors[clr.ComboBg]                = colors[clr.PopupBg]
            colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
            colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
            colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
            colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
            colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
        end,
        0xFF32A993
    },
    {
        'Салатовая',
        function() 
            local style = imgui.GetStyle()
            local colors = style.Colors
            local clr = imgui.Col
            local ImVec4 = imgui.ImVec4
        
            style.WindowRounding = 2.0
            style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
            style.ChildWindowRounding = 2.0
            style.FrameRounding = 2.0
            style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
            style.ScrollbarSize = 13.0
            style.ScrollbarRounding = 0
            style.GrabMinSize = 8.0
            style.GrabRounding = 1.0
        
            colors[clr.FrameBg]                = ImVec4(0.42, 0.48, 0.16, 0.54)
            colors[clr.FrameBgHovered]         = ImVec4(0.85, 0.98, 0.26, 0.40)
            colors[clr.FrameBgActive]          = ImVec4(0.85, 0.98, 0.26, 0.67)
            colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
            colors[clr.TitleBgActive]          = ImVec4(0.42, 0.48, 0.16, 1.00)
            colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            colors[clr.CheckMark]              = ImVec4(0.85, 0.98, 0.26, 1.00)
            colors[clr.SliderGrab]             = ImVec4(0.77, 0.88, 0.24, 1.00)
            colors[clr.SliderGrabActive]       = ImVec4(0.85, 0.98, 0.26, 1.00)
            colors[clr.Button]                 = ImVec4(0.85, 0.98, 0.26, 0.40)
            colors[clr.ButtonHovered]          = ImVec4(0.85, 0.98, 0.26, 1.00)
            colors[clr.ButtonActive]           = ImVec4(0.82, 0.98, 0.06, 1.00)
            colors[clr.Header]                 = ImVec4(0.85, 0.98, 0.26, 0.31)
            colors[clr.HeaderHovered]          = ImVec4(0.85, 0.98, 0.26, 0.80)
            colors[clr.HeaderActive]           = ImVec4(0.85, 0.98, 0.26, 1.00)
            colors[clr.Separator]              = colors[clr.Border]
            colors[clr.SeparatorHovered]       = ImVec4(0.63, 0.75, 0.10, 0.78)
            colors[clr.SeparatorActive]        = ImVec4(0.63, 0.75, 0.10, 1.00)
            colors[clr.ResizeGrip]             = ImVec4(0.85, 0.98, 0.26, 0.25)
            colors[clr.ResizeGripHovered]      = ImVec4(0.85, 0.98, 0.26, 0.67)
            colors[clr.ResizeGripActive]       = ImVec4(0.85, 0.98, 0.26, 0.95)
            colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.81, 0.35, 1.00)
            colors[clr.TextSelectedBg]         = ImVec4(0.85, 0.98, 0.26, 0.35)
            colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
            colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
            colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
            colors[clr.ComboBg]                = colors[clr.PopupBg]
            colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
            colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
            colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
            colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
            colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
        end,
        0xFFD9FA42
    },
    {
        'Монохром',
        function() 
            local style = imgui.GetStyle()
            local colors = style.Colors
            local clr = imgui.Col
            local ImVec4 = imgui.ImVec4

            style.Alpha = 1.0
            style.ChildWindowRounding = 3
            style.WindowRounding = 3
            style.GrabRounding = 1
            style.GrabMinSize = 20
            style.FrameRounding = 3

            colors[clr.Text] = ImVec4(0.00, 1.00, 1.00, 1.00)
            colors[clr.TextDisabled] = ImVec4(0.00, 0.40, 0.41, 1.00)
            colors[clr.WindowBg] = ImVec4(0.00, 0.00, 0.00, 1.00)
            colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.Border] = ImVec4(0.00, 1.00, 1.00, 0.65)
            colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.FrameBg] = ImVec4(0.44, 0.80, 0.80, 0.18)
            colors[clr.FrameBgHovered] = ImVec4(0.44, 0.80, 0.80, 0.27)
            colors[clr.FrameBgActive] = ImVec4(0.44, 0.81, 0.86, 0.66)
            colors[clr.TitleBg] = ImVec4(0.14, 0.18, 0.21, 0.73)
            colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.54)
            colors[clr.TitleBgActive] = ImVec4(0.00, 1.00, 1.00, 0.27)
            colors[clr.MenuBarBg] = ImVec4(0.00, 0.00, 0.00, 0.20)
            colors[clr.ScrollbarBg] = ImVec4(0.22, 0.29, 0.30, 0.71)
            colors[clr.ScrollbarGrab] = ImVec4(0.00, 1.00, 1.00, 0.44)
            colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 1.00, 1.00, 0.74)
            colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 1.00, 1.00, 1.00)
            colors[clr.ComboBg] = ImVec4(0.16, 0.24, 0.22, 0.60)
            colors[clr.CheckMark] = ImVec4(0.00, 1.00, 1.00, 0.68)
            colors[clr.SliderGrab] = ImVec4(0.00, 1.00, 1.00, 0.36)
            colors[clr.SliderGrabActive] = ImVec4(0.00, 1.00, 1.00, 0.76)
            colors[clr.Button] = ImVec4(0.00, 0.65, 0.65, 0.46)
            colors[clr.ButtonHovered] = ImVec4(0.01, 1.00, 1.00, 0.43)
            colors[clr.ButtonActive] = ImVec4(0.00, 1.00, 1.00, 0.62)
            colors[clr.Header] = ImVec4(0.00, 1.00, 1.00, 0.33)
            colors[clr.HeaderHovered] = ImVec4(0.00, 1.00, 1.00, 0.42)
            colors[clr.HeaderActive] = ImVec4(0.00, 1.00, 1.00, 0.54)
            colors[clr.ResizeGrip] = ImVec4(0.00, 1.00, 1.00, 0.54)
            colors[clr.ResizeGripHovered] = ImVec4(0.00, 1.00, 1.00, 0.74)
            colors[clr.ResizeGripActive] = ImVec4(0.00, 1.00, 1.00, 1.00)
            colors[clr.CloseButton] = ImVec4(0.00, 0.78, 0.78, 0.35)
            colors[clr.CloseButtonHovered] = ImVec4(0.00, 0.78, 0.78, 0.47)
            colors[clr.CloseButtonActive] = ImVec4(0.00, 0.78, 0.78, 1.00)
            colors[clr.PlotLines] = ImVec4(0.00, 1.00, 1.00, 1.00)
            colors[clr.PlotLinesHovered] = ImVec4(0.00, 1.00, 1.00, 1.00)
            colors[clr.PlotHistogram] = ImVec4(0.00, 1.00, 1.00, 1.00)
            colors[clr.PlotHistogramHovered] = ImVec4(0.00, 1.00, 1.00, 1.00)
            colors[clr.TextSelectedBg] = ImVec4(0.00, 1.00, 1.00, 0.22)
            colors[clr.ModalWindowDarkening] = ImVec4(0.04, 0.10, 0.09, 0.51)
        end,
        0xFF0ABCBC
    },
    {
        'Светло-синяя',
        function() 
            local style = imgui.GetStyle()
            local colors = style.Colors
            local clr = imgui.Col
            local ImVec4 = imgui.ImVec4

            colors[clr.Text]   = ImVec4(0.00, 0.00, 0.00, 0.51)
            colors[clr.TextDisabled]   = ImVec4(0.24, 0.24, 0.24, 1.00)
            colors[clr.WindowBg]              = ImVec4(1.00, 1.00, 1.00, 1.00)
            colors[clr.ChildWindowBg]         = ImVec4(0.96, 0.96, 0.96, 1.00)
            colors[clr.PopupBg]               = ImVec4(0.92, 0.92, 0.92, 1.00)
            colors[clr.Border]                = ImVec4(0.86, 0.86, 0.86, 1.00)
            colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.FrameBg]               = ImVec4(0.88, 0.88, 0.88, 1.00)
            colors[clr.FrameBgHovered]        = ImVec4(0.82, 0.82, 0.82, 1.00)
            colors[clr.FrameBgActive]         = ImVec4(0.76, 0.76, 0.76, 1.00)
            colors[clr.TitleBg]               = ImVec4(0.00, 0.45, 1.00, 0.82)
            colors[clr.TitleBgCollapsed]      = ImVec4(0.00, 0.45, 1.00, 0.82)
            colors[clr.TitleBgActive]         = ImVec4(0.00, 0.45, 1.00, 0.82)
            colors[clr.MenuBarBg]             = ImVec4(0.00, 0.37, 0.78, 1.00)
            colors[clr.ScrollbarBg]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.ScrollbarGrab]         = ImVec4(0.00, 0.35, 1.00, 0.78)
            colors[clr.ScrollbarGrabHovered]  = ImVec4(0.00, 0.33, 1.00, 0.84)
            colors[clr.ScrollbarGrabActive]   = ImVec4(0.00, 0.31, 1.00, 0.88)
            colors[clr.ComboBg]               = ImVec4(0.92, 0.92, 0.92, 1.00)
            colors[clr.CheckMark]             = ImVec4(0.00, 0.49, 1.00, 0.59)
            colors[clr.SliderGrab]            = ImVec4(0.00, 0.49, 1.00, 0.59)
            colors[clr.SliderGrabActive]      = ImVec4(0.00, 0.39, 1.00, 0.71)
            colors[clr.Button]                = ImVec4(0.00, 0.49, 1.00, 0.59)
            colors[clr.ButtonHovered]         = ImVec4(0.00, 0.49, 1.00, 0.71)
            colors[clr.ButtonActive]          = ImVec4(0.00, 0.49, 1.00, 0.78)
            colors[clr.Header]                = ImVec4(0.00, 0.49, 1.00, 0.78)
            colors[clr.HeaderHovered]         = ImVec4(0.00, 0.49, 1.00, 0.71)
            colors[clr.HeaderActive]          = ImVec4(0.00, 0.49, 1.00, 0.78)
            colors[clr.ResizeGrip]            = ImVec4(0.00, 0.39, 1.00, 0.59)
            colors[clr.ResizeGripHovered]     = ImVec4(0.00, 0.27, 1.00, 0.59)
            colors[clr.ResizeGripActive]      = ImVec4(0.00, 0.25, 1.00, 0.63)
            colors[clr.CloseButton]           = ImVec4(0.00, 0.35, 0.96, 0.71)
            colors[clr.CloseButtonHovered]    = ImVec4(0.00, 0.31, 0.88, 0.69)
            colors[clr.CloseButtonActive]     = ImVec4(0.00, 0.25, 0.88, 0.67)
            colors[clr.PlotLines]             = ImVec4(0.00, 0.39, 1.00, 0.75)
            colors[clr.PlotLinesHovered]      = ImVec4(0.00, 0.39, 1.00, 0.75)
            colors[clr.PlotHistogram]         = ImVec4(0.00, 0.39, 1.00, 0.75)
            colors[clr.PlotHistogramHovered]  = ImVec4(0.00, 0.35, 0.92, 0.78)
            colors[clr.TextSelectedBg]        = ImVec4(0.00, 0.47, 1.00, 0.59)
            colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35)
        end,
        0xFF569FEC
    },
    {
        'Тёмно-синяя',
        function() 
            local style = imgui.GetStyle()
            local colors = style.Colors
            local clr = imgui.Col
            local ImVec4 = imgui.ImVec4

            colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
            colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00)
            colors[clr.WindowBg] = ImVec4(0.11, 0.10, 0.11, 1.00)
            colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.PopupBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.Border] = ImVec4(0.86, 0.86, 0.86, 1.00)
            colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.FrameBg] = ImVec4(0.21, 0.20, 0.21, 0.60)
            colors[clr.FrameBgHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.FrameBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.TitleBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.TitleBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.MenuBarBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.ScrollbarBg] = ImVec4(0.00, 0.46, 0.65, 0.00)
            colors[clr.ScrollbarGrab] = ImVec4(0.00, 0.46, 0.65, 0.44)
            colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 0.46, 0.65, 0.74)
            colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.ComboBg] = ImVec4(0.15, 0.14, 0.15, 1.00)
            colors[clr.CheckMark] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.SliderGrab] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.SliderGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.Button] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.ButtonHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.ButtonActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.Header] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.HeaderHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.HeaderActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
            colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.30)
            colors[clr.ResizeGripHovered] = ImVec4(1.00, 1.00, 1.00, 0.60)
            colors[clr.ResizeGripActive] = ImVec4(1.00, 1.00, 1.00, 0.90)
            colors[clr.CloseButton] = ImVec4(1.00, 0.10, 0.24, 0.00)
            colors[clr.CloseButtonHovered] = ImVec4(0.00, 0.10, 0.24, 0.00)
            colors[clr.CloseButtonActive] = ImVec4(1.00, 0.10, 0.24, 0.00)
            colors[clr.PlotLines] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.PlotLinesHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.PlotHistogram] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.TextSelectedBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.00)
        end,
        0xFF0075A6
    },
    {
        'Светлая',
        function() 
            local style = imgui.GetStyle()
            local colors = style.Colors
            local clr = imgui.Col
            local ImVec4 = imgui.ImVec4

            colors[clr.Text] = ImVec4(0.00, 0.00, 0.00, 1.00)
            colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00)
            colors[clr.WindowBg] = ImVec4(0.94, 0.94, 0.94, 0.94)
            colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
            colors[clr.PopupBg] = ImVec4(1.00, 1.00, 1.00, 0.94)
            colors[clr.Border]= ImVec4(0.00, 0.00, 0.00, 0.39)
            colors[clr.BorderShadow] = ImVec4(1.00, 1.00, 1.00, 0.10)
            colors[clr.FrameBg] = ImVec4(1.00, 1.00, 1.00, 0.94)
            colors[clr.FrameBgHovered]= ImVec4(0.26, 0.59, 0.98, 0.40)
            colors[clr.FrameBgActive] = ImVec4(0.26, 0.59, 0.98, 0.67)
            colors[clr.TitleBg] = ImVec4(0.96, 0.96, 0.96, 1.00)
            colors[clr.TitleBgCollapsed] = ImVec4(1.00, 1.00, 1.00, 0.51)
            colors[clr.TitleBgActive] = ImVec4(0.82, 0.82, 0.82, 1.00)
            colors[clr.MenuBarBg] = ImVec4(0.86, 0.86, 0.86, 1.00)
            colors[clr.ScrollbarBg] = ImVec4(0.98, 0.98, 0.98, 0.53)
            colors[clr.ScrollbarGrab] = ImVec4(0.69, 0.69, 0.69, 1.00)
            colors[clr.ScrollbarGrabHovered] = ImVec4(0.59, 0.59, 0.59, 1.00)
            colors[clr.ScrollbarGrabActive] = ImVec4(0.49, 0.49, 0.49, 1.00)
            colors[clr.ComboBg] = ImVec4(0.86, 0.86, 0.86, 0.99)
            colors[clr.CheckMark] = ImVec4(0.26, 0.59, 0.98, 1.00)
            colors[clr.SliderGrab] = ImVec4(0.24, 0.52, 0.88, 1.00)
            colors[clr.SliderGrabActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
            colors[clr.Button]= ImVec4(0.26, 0.59, 0.98, 0.40)
            colors[clr.ButtonHovered] = ImVec4(0.26, 0.59, 0.98, 1.00)
            colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
            colors[clr.Header]= ImVec4(0.26, 0.59, 0.98, 0.31)
            colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
            colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
            colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.50)
            colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
            colors[clr.ResizeGripActive] = ImVec4(0.26, 0.59, 0.98, 0.95)
            colors[clr.CloseButton] = ImVec4(0.59, 0.59, 0.59, 0.50)
            colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)
            colors[clr.PlotLines] = ImVec4(0.39, 0.39, 0.39, 1.00)
            colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
            colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
            colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
            colors[clr.TextSelectedBg]= ImVec4(0.26, 0.59, 0.98, 0.35)
            colors[clr.ModalWindowDarkening] = ImVec4(0.20, 0.20, 0.20, 0.35)
        end,
        0xFF4296FA
    }
}

function getActualTheme()
    return imguiThemes[settingsSelectedTheme.v + 1]
end

function getThemeNames(utf8)
    themes = {}
    for k, v in pairs(imguiThemes) do
        table.insert(themes, utf8 and u8(v[1]) or v[1])
    end
    return themes
end

function setTheme(id)
    imgui.SwitchContext()
    imguiThemes[id + 1][2]()
end