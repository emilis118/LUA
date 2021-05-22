-- < Script Info >
script_name("RakEmulator+")
script_author("Musaigen")
script_version("1.0.3")
-- < Librarys >
local sf = require "sampfuncs"
local imgui = require "imgui"
local raknetIO = require "emulator.bitstream_io"
local incoming_rpc = require "emulator.incoming_rpc"
local outcoming_packets = require "emulator.outcoming_packets"
local outcoming_rpc = require "emulator.outcoming_rpc"
local encoding = require "encoding"
encoding.default = "CP1251"
local loaded_notf, notf = pcall(import, "imgui_notf.lua")
local u8 = encoding.UTF8
-- < Config >
local config = {
    menu = imgui.ImBool(false),
    tab_select = imgui.ImInt(1),
    tab_outcoming_packets_select = imgui.ImInt(1),
    tab_incoming_rpc_select = imgui.ImInt(1),
    tab_outcoming_rpc_select = imgui.ImInt(1),
    data = {
        packets = {
            outcoming = {names = {}, id = {}, convdata = {}}
        },
        rpc = {
            incoming = {names = {}, id = {}, convdata = {}},
            outcoming = {names = {}, id = {}, convdata = {}}
        },
        scenarios = {},
        nops_data = {status = {}, names = {}, nops = {
            outcoming_rpc = {},
            incoming_rpc = {},
            outcoming_packet = {}
        }}
    },
    -- < Scenario Options >
    rename_buffer = imgui.ImBuffer(256),
    scenario_id = imgui.ImInt(0),
    old_scenario_id = 0,
    change_convdata = nil,
    wait_scenario_buffer = imgui.ImInt(0),
    data_id = nil,
    autofill_data = nil,
    nop_id = imgui.ImInt(0)
}

local guide_text = 
[[
СОЗДАНИЕ СЦЕНАРИЕВ.
Для того чтобы создать сценарий нужно нажать на кнопку "Add Scenario".

УДАЛЕНИЕ СЦЕНАРИЕВ.
Для того чтобы удалить сценарий, нужно нажать ИМЕННО на название сценария(например нажать на Scenario0), и нажать на кнопку "Remove Scenario".

ПЕРЕИМЕНОВАНИЕ СЦЕНАРИЕВ.
Для того чтобы переименовать сценарий, нужно нажать ИМЕННО на название сценария, и нажать на кнопку "Rename Scenario", ввести новое название сценария в поле...
и нажать кнопку "Apply"

НАСТРОЙКИ СЦЕНАРИЕВ.
Для того чтобы зайти в настройки сценария, нужно нажать ИМЕННО на название сценария, и нажать кнопку "Settings", появится окно с настройками
> Add Wait - При нажатии добавляет задержку в сценарий. Справа есть поле, куда нужно ввести нужную вам задержку в миллисекундах(т.е 1 секунда = 1000 миллисекунд)
> Loop - Если есть галочка, то сценарий будет повторяться до тех пор, пока вы в ручную не завершите его.

ЗАПУСК И ОСТАНОВКА СЦЕНАРИЕВ.
Для запуска сценария нужно нажать на кнопку Play(если сценарий уже запущен будет кнопка Stop, это будет значит что вы можете закончить сценарий в ручную).

ДОБАВЛЕНИЕ ПАКЕТОВ/RPC В СЦЕНАРИЙ.
Для того чтобы добавить пакет/RPC в сценарий, нужно выбрать нужный вам пакет/RPC, ввести данные котороые вас интересуют и нажать кнопку "Add To Scenario"(Сценарий должен быть создан, если у вас он не создан,
будет одна кнопка Close)
После этого, выбрать нужный вам сценарий и нажать кнопку "Add".

РЕДАКТИРОВАНИЕ ПАКЕТОВ/RPC В СЦЕНАРИИ.
Для того чтобы редактировать пакет/RPC в сценарии, нужно нажать ЛКМ именно на его название(например нажать на 207 | PLAYER_SYNC, 11 | SetPlayerName, 2500 | WAIT и т.д)
Отредактировать его как вам нужно, и нажать кнопку "Exit".

УДАЛЕНИЕ ПАКЕТОВ/RPC ИЗ СЦЕНАРИЯ.
Для того, чтобы удалить пакет/RPC/задержку из сценария, нужно нажать ПКМ именно на его название(например нажать на 207 | PLAYER_SYNC, 11 | SetPlayerName, 2500 | WAIT и т.д)

РЕДАКТИРОВАНИЕ АВТОЗАПОЛНЕНИЯ ПАКЕТОВ/RPC В СЦЕНАРИИ.
Нужно нажать на нужный вам пакет/RPC в сценарии(см. РЕДАКТИРОВАНИЕ ПАКЕТОВ/RPC В СЦЕНАРИИ.) и нажать кнопку "Edit Autofill".
Дальше идет выбор автозаполнения, если кружок стоит на None значит автозаполнение выполнятся не будет. Все на английском, но не составит труда перевести
]]

-- < Entry Point >
function main()
    while not isSampAvailable() do
        wait(0)
    end

    fillPacketsAndConvertData()

    sampRegisterChatCommand(
        "emulator",
        function()
            config.menu.v = not config.menu.v
        end
    )

    while true do
        wait(0)

        imgui.Process = config.menu.v

        if #config.data.scenarios > 0 then
            for k, v in pairs(config.data.scenarios) do
                if v.play then
                    for k, packet in pairs(v.data) do
                        if v.play then
                            if packet.convdata ~= "WAIT_UNIQUE" then
                                if packet.convdata ~= "NOP_UNIQUE" then
                                    for k1, v1 in pairs(packet.convdata) do
                                        if v1[3] ~= nil then
                                            for k2, v2 in pairs(packet.autofill[v1[1]]) do
                                                local currentChoose = packet.autofill[v1[1]][packet.autofill[v1[1]].id.v + 1]
                                                if currentChoose.name ~= "None" then
                                                    local util = v1[3]
                                                    for i = 1, #util do
                                                        local utilData = util[i]
                                                        if utilData[2] ~= nil then
                                                            if type(utilData[2]) == "table" then
                                                                local t = {}
                                                                for i = 1, #packet.convdata do
                                                                    for ik = 1, #utilData[2] do
                                                                        if utilData[2][ik] == packet.convdata[i][1] then
                                                                            table.insert(t, packet.convdata[i][2])
                                                                        end
                                                                    end
                                                                end
                                                                local callback = utilData[3](v1[2], t)
                                                                if callback ~= nil then
                                                                    AddNotification("Error while syncing: " ..callback[1], 2.500, callback[2])
                                                                end
                                                            else
                                                                local callback = utilData[2](v1[2])
                                                                if callback ~= nil then
                                                                    AddNotification("Error while syncing: " .. callback[1], 2.500, callback[2])
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end    
                                    end
                                    SendData(packet.id, packet.convdata)
                                else
                                    local status = packet.id == "TRUE" and true or false
                                    local typeNop, id = packet.name:match("(.+) | (%d+)")
                                    if typeNop == "INCOMING_RPC" then 
                                        table.insert(config.data.nops_data.nops.incoming_rpc, {id = id, status = status})
                                    elseif typeNop == "OUTCOMING_RPC" then 
                                        table.insert(config.data.nops_data.nops.outcoming_rpc, {id = id, status = status})
                                    elseif typeNop == "OUTCOMING_PACKET" then 
                                        table.insert(config.data.nops_data.nops.outcoming_packet, {id = id, status = status})
                                    end
                                end
                            else
                                wait(packet.id)
                            end
                        end
                    end
                    if not v.loop.v then
                        v.play = false
                    end
                end
            end
        end
    end
end
-- < Draw >
function imgui.OnDrawFrame()
    local resX, resY = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(1000, 500), imgui.Cond.FirstUseEver)
    imgui.Begin("RakEmulator BETA", config.menu, imgui.WindowFlags.NoResize)

    imgui.SelectableList(
        "Select Type List",
        imgui.ImVec2(175, 0),
        config.tab_select,
        {
            "Incoming RPC",
            "Outcoming RPC",
            "Outcoming Packets",
            "Scenarios"
        }
    )
    imgui.SameLine()

    if config.tab_select.v == 1 then
        imgui.SelectableList(
            "Select Incoming Rpc List",
            imgui.ImVec2(175, 0),
            config.tab_incoming_rpc_select,
            config.data.rpc.incoming.names
        )
    elseif config.tab_select.v == 2 then
        imgui.SelectableList(
            "Select Outcoming Rpc List",
            imgui.ImVec2(175, 0),
            config.tab_outcoming_rpc_select,
            config.data.rpc.outcoming.names
        )
    elseif config.tab_select.v == 3 then
        imgui.SelectableList(
            "Select Out Packets List",
            imgui.ImVec2(175, 0),
            config.tab_outcoming_packets_select,
            config.data.packets.outcoming.names
        )
    end

    local convdata = {}
    local id = 0
    if config.tab_select.v == 1 then
        id = config.data.rpc.incoming.id[config.tab_incoming_rpc_select.v]
        convdata = config.data.rpc.incoming.convdata[config.data.rpc.incoming.id[config.tab_incoming_rpc_select.v]]
    elseif config.tab_select.v == 2 then
        id = config.data.rpc.outcoming.id[config.tab_outcoming_rpc_select.v]
        convdata = config.data.rpc.outcoming.convdata[config.data.rpc.outcoming.id[config.tab_outcoming_rpc_select.v]]
    elseif config.tab_select.v == 3 then
        id = config.data.packets.outcoming.id[config.tab_outcoming_packets_select.v]
        convdata = 
        config.data.packets.outcoming.convdata[
        config.data.packets.outcoming.id[config.tab_outcoming_packets_select.v]
        ]
    end
    imgui.SameLine()
    imgui.BeginGroup()

    imgui.PushItemWidth(500)

    if config.tab_select.v < 4 then
        drawConvertedData(convdata)

        local size = imgui.ImVec2(imgui.GetWindowWidth() - imgui.GetStyle().WindowPadding.x - (342 * 1.44), 25)

        if imgui.Button("Send Data", size) then
            SendData(id)
        end

        imgui.Button("Add To Scenario", size)
        if imgui.BeginPopupContextItem("Add To Scenario", 0) then
            if #config.data.scenarios > 0 then
                local scenarios = {}
                for k, v in pairs(config.data.scenarios) do
                    scenarios[#scenarios + 1] = v.name
                end
                imgui.Combo("Select Scenario", config.scenario_id, scenarios)

                if imgui.Button("Add") then
                    local dataType = GetSendDataType(id)
                    local name = ""
                    if dataType == "INCOMING_RPC" then
                        name = raknetGetRpcName(id)
                    elseif dataType == "OUTCOMING_RPC" then
                        name = raknetGetRpcName(id)
                    elseif dataType == "OUTCOMING_PACKET" then
                        name = raknetGetPacketName(id)
                    end

                    local autofill = {}

                    for k, v in pairs(convdata) do
                        if v[3] ~= nil then
                            autofill[v[1]] = {id = imgui.ImInt(0), {name = "None"}}
                            for k1, v1 in pairs(v[3]) do
                                local block = false
                                if type(v1[2]) == "table" then
                                    if type(v1[3]) ~= "function" then
                                        block = true
                                    end
                                else
                                    if type(v1[2]) ~= "function" then
                                        block = true
                                    end
                                end
                                if not block then
                                    table.insert(autofill[v[1]], {name = v1[1]})
                                end
                            end
                        end
                    end

                    table.insert(
                        config.data.scenarios[config.scenario_id.v + 1].data,
                        {
                            id = id,
                            name = name,
                            convdata = convdata,
                            autofill = autofill
                        }
                    )
                end
            end

            if imgui.Button("Close") then
                imgui.CloseCurrentPopup()
            end

            imgui.EndPopup()
        end
    else
        if config.tab_select.v < 5 then
            local size = imgui.ImVec2(imgui.GetWindowWidth() + imgui.GetStyle().WindowPadding.x - 202, 20)
            if imgui.Button("Add Scenario", size) then
                table.insert(
                    config.data.scenarios,
                    {name = "Scenario" .. #config.data.scenarios, play = false, loop = imgui.ImBool(false), data = {}}
                )
            end
            imgui.Button("Read Guide(ONLY Rus)", size)
            if imgui.BeginPopupContextItem("Guide", 0) then
                imgui.TextUnformatted(u8(guide_text))

                if imgui.Button("Close") then
                    imgui.CloseCurrentPopup()
                end

                imgui.EndPopup()
            end
            imgui.BeginChild("Scenarios", imgui.ImVec2(0, 0), true)
            for k, v in pairs(config.data.scenarios) do
                local dl = imgui.GetWindowDrawList()
                local p = imgui.GetCursorScreenPos()
                imgui.BeginGroup()
                dl:AddRectFilled(
                    p,
                    imgui.ImVec2(p.x + imgui.GetWindowWidth(), p.y + imgui.CalcTextSize(v.name).y),
                    imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.FrameBg])
                )
                imgui.SetCursorPosX(imgui.GetCursorPosX() + 5)
                imgui.Text(v.name)
                if imgui.IsItemClicked(0) then
                    config.tab_select.v = k + 4
                end
                imgui.EndGroup()
            end
            imgui.EndChild()
        elseif config.tab_select.v ~= 999999 and config.tab_select.v ~= 999998 then
            local data = config.data.scenarios[config.tab_select.v - 4]
            local size = imgui.ImVec2(imgui.GetWindowWidth() + imgui.GetStyle().WindowPadding.x - 202, 20)
            if imgui.Button(data.play and "Stop" or "Play", size) then
                data.play = not data.play
            end
            imgui.Button("Rename Scenario", size)
            if imgui.BeginPopupContextItem("Rename", 0) then
                imgui.InputText("New Scenario Name", config.rename_buffer)
                imgui.Text("Old name: " .. data.name)

                if imgui.Button("Apply") then
                    data.name = config.rename_buffer.v
                end

                if imgui.Button("Close") then
                    imgui.CloseCurrentPopup()
                end

                imgui.EndPopup()
            end
            if imgui.Button("Remove Scenario", size) then
                local old = config.tab_select.v
                config.tab_select.v = 4
                table.remove(config.data.scenarios, old - 4)
            end
            imgui.Button("Settings", size)
            if imgui.BeginPopupContextItem("Scenario Settings", 0) then
                if imgui.Button("Add Wait") then
                    table.insert(
                        data.data,
                        {
                            id = config.wait_scenario_buffer.v,
                            name = "WAIT",
                            convdata = "WAIT_UNIQUE"
                        }
                    )
                end
                imgui.SameLine()
                imgui.InputInt("Wait(ms)", config.wait_scenario_buffer)

                if imgui.Button("Add Nop") then
                    local name = config.data.nops_data.names[config.nop_id.v + 1]
                    table.insert(
                        data.data,
                        {
                            id = string.upper(tostring(config.data.nops_data.status[config.nop_id.v + 1].v)),
                            name = name,
                            convdata = "NOP_UNIQUE"
                        }
                    )
                end
                imgui.SameLine()
                imgui.Checkbox("##NopStatus", config.data.nops_data.status[config.nop_id.v + 1])
                imgui.SameLine()

                imgui.Combo("Nops", config.nop_id, config.data.nops_data.names)


                imgui.Checkbox("Loop", data.loop)
                if imgui.Button("Close") then
                    imgui.CloseCurrentPopup()
                end

                imgui.EndPopup()
            end
            if imgui.Button("Exit", size) then
                config.tab_select.v = 4
            end
            imgui.BeginChild("Scenarios Data", imgui.ImVec2(0, 0), true)

            for k, v in pairs(data.data) do
                local dl = imgui.GetWindowDrawList()
                local p = imgui.GetCursorScreenPos()
                imgui.BeginGroup()
                dl:AddRectFilled(
                    p,
                    imgui.ImVec2(p.x + imgui.GetWindowWidth(), p.y + imgui.CalcTextSize(v.name).y),
                    imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.FrameBg])
                )
                imgui.SetCursorPosX(imgui.GetCursorPosX() + 5)
                imgui.Text(string.format("%s | %s", tostring(v.id), v.name))
                if imgui.IsItemClicked(0) then
                    for k, val in pairs(config.data.scenarios) do
                        if val.name == data.name then
                            config.autofill_data = v.autofill
                            config.data_id = v
                            config.old_scenario_id = k
                            config.change_convdata = v.convdata
                            config.tab_select.v = 999999
                        end
                    end
                elseif imgui.IsItemClicked(1) then
                    table.remove(data.data, k)
                end

                imgui.EndGroup()
            end

            imgui.EndChild()
        end
    end

    if config.tab_select.v == 999999 then
        if config.change_convdata ~= nil then
            if config.change_convdata == "WAIT_UNIQUE" then
                imgui.InputInt("Wait(ms)", config.wait_scenario_buffer)
            else
                drawConvertedData(config.change_convdata)
                if
                imgui.Button(
                    "Edit Autofill",
                    imgui.ImVec2(imgui.GetWindowWidth() - imgui.GetStyle().WindowPadding.x - (342 * 1.44), 25)
                )
                then
                    config.tab_select.v = 999998
                end
            end
            if
            imgui.Button(
                "Exit",
                imgui.ImVec2(imgui.GetWindowWidth() - imgui.GetStyle().WindowPadding.x - (342 * 1.44), 25)
            )
            then
                if config.change_convdata == "WAIT_UNIQUE" then
                    config.data_id.id = config.wait_scenario_buffer.v
                end
                config.tab_select.v = config.old_scenario_id + 4
                config.old_scenario_id = 0
                config.change_convdata = nil
            end
        else
            config.tab_select.v = config.old_scenario_id + 4
            config.old_scenario_id = 0
            config.change_convdata = nil
            AddNotification("Invalid data", 2.500, 3)
        end
    elseif config.tab_select.v == 999998 then
        for k, v in pairs(config.change_convdata) do
            if v[3] ~= nil then
                if imgui.CollapsingHeader(v[1]) then
                    for k1, v1 in pairs(config.autofill_data[v[1]]) do
                        if type(v1) == "table" then
                            imgui.RadioButton(
                                v1.name .. "##" .. tostring(k1 + k + 1),
                                config.autofill_data[v[1]].id,
                                k1 - 1
                            )
                        end
                    end
                end
            end
        end
        imgui.Separator()
        if imgui.Button("Exit", imgui.ImVec2(imgui.GetWindowWidth() + imgui.GetStyle().WindowPadding.x - 202, 20)) then
            config.tab_select.v = 999999
        end
    end

    imgui.PopItemWidth()

    imgui.EndGroup()

    imgui.End()
end
-- < Events >
function onSendRpc(id)
    local state = true
    for k, v in pairs(config.data.nops_data.nops.outcoming_rpc) do 
        if tonumber(v.id) == id then
            if v.status then 
                state = false
            else
                config.data.nops_data.nops.outcoming_rpc[k] = nil
            end
        end
    end
    return state
end

function onReceiveRpc(id)
    local state = true
    for k, v in pairs(config.data.nops_data.nops.incoming_rpc) do 
        if tonumber(v.id) == id then
            if v.status then 
                state = false
            else
                config.data.nops_data.nops.incoming_rpc[k] = nil
            end
        end
    end
    return state
end

function onSendPacket(id)
    local state = true
    for k, v in pairs(config.data.nops_data.nops.outcoming_packet) do 
        if tonumber(v.id) == id then
            if v.status then 
                state = false
            else
                config.data.nops_data.nops.outcoming_packet[k] = nil
            end
        end
    end
    return state
end
-- < Functions >
function fillPacketsAndConvertData()
    for i = 11, 166 do
        if incoming_rpc[i] ~= nil then
            table.insert(config.data.rpc.incoming.names, raknetGetRpcName(i))
            table.insert(config.data.rpc.incoming.id, i)
            config.data.rpc.incoming.convdata[i] = convertPacketDefineToData(incoming_rpc[i])
            table.insert(config.data.nops_data.status, imgui.ImBool(false))
            table.insert(config.data.nops_data.names, ("INCOMING_RPC | %d | %s"):format(i, raknetGetRpcName(i)))
        end
        if outcoming_rpc[i] ~= nil then
            table.insert(config.data.rpc.outcoming.names, raknetGetRpcName(i))
            table.insert(config.data.rpc.outcoming.id, i)
            config.data.rpc.outcoming.convdata[i] = convertPacketDefineToData(outcoming_rpc[i])
            table.insert(config.data.nops_data.status, imgui.ImBool(false))
            table.insert(config.data.nops_data.names, ("OUTCOMING_RPC | %d | %s"):format(i, raknetGetRpcName(i)))
        end
    end

    for i = 200, 212 do
        if outcoming_packets[i] ~= nil then
            table.insert(config.data.packets.outcoming.names, raknetGetPacketName(i))
            table.insert(config.data.packets.outcoming.id, i)
            config.data.packets.outcoming.convdata[i] = convertPacketDefineToData(outcoming_packets[i])
            table.insert(config.data.nops_data.status, imgui.ImBool(false))
            table.insert(config.data.nops_data.names, ("OUTCOMING_PACKET | %d | %s"):format(i, raknetGetPacketName(i)))
        end
    end
end

function convertPacketDefineToData(packetDefine)
    local data = {}

    for i = 1, #packetDefine do
        local def = packetDefine[i]
        -- < Defines
        local nameDef = def[1]
        local typeDef = def[2]
        local ffDef = def[3]

        if typeDef == "int8" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImInt(0),
                    ffDef,
                    "inputint"
                }
            )
        elseif typeDef == "int16" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImInt(0),
                    ffDef,
                    "inputint"
                }
            )
        elseif typeDef == "int32" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImInt(0),
                    ffDef,
                    "inputint"
                }
            )
        elseif typeDef == "float" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImFloat(0.0),
                    ffDef,
                    "inputfloat"
                }
            )
        elseif typeDef == "vector3d" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImFloat3(0.0, 0.0, 0.0),
                    ffDef,
                    "inputfloat3"
                }
            )
        elseif typeDef == "floatQuat" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImFloat4(0.0, 0.0, 0.0, 0.0),
                    ffDef,
                    "inputfloat4"
                }
            )
        elseif typeDef == "string" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImBuffer(256),
                    ffDef,
                    "inputtext"
                }
            )
        elseif typeDef == "string256" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImBuffer(256),
                    ffDef,
                    "inputtext"
                }
            )
        elseif typeDef == "encodedString4096" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImBuffer(4096),
                    ffDef,
                    "inputtext"
                }
            )
        elseif typeDef == "Int32Array3" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImInt3(0, 0, 0),
                    ffDef,
                    "inputint3"
                }
            )
        elseif typeDef == "bool" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImBool(false),
                    ffDef,
                    "checkbox"
                }
            )
        elseif typeDef == "vector2d" then
            table.insert(
                data,
                {
                    nameDef,
                    imgui.ImFloat2(0.0, 0.0),
                    ffDef,
                    "inputfloat2"
                }
            )
        end
    end

    return data
end

function drawConvertedData(convdata)
    if convdata then
        for i = 1, #convdata do
            local name = convdata[i][1]
            local val = convdata[i][2]
            local util = convdata[i][3]
            local typeData = convdata[i][4]

            if typeData == "inputint" then
                imgui.InputInt(name, val)
            elseif typeData == "checkbox" then
                imgui.Checkbox(name, val)
            elseif typeData == "inputint3" then
                imgui.InputInt3(name, val)
            elseif typeData == "inputfloat" then
                imgui.InputFloat(name, val)
            elseif typeData == "inputfloat2" then
                imgui.InputFloat2(name, val)
            elseif typeData == "inputfloat3" then
                imgui.InputFloat3(name, val)
            elseif typeData == "inputfloat4" then
                imgui.InputFloat4(name, val)
            elseif typeData == "inputtext" then
                imgui.InputText(name, val)
            end
            if util ~= nil then
                imgui.SameLine()
                imgui.TextDisabled("(!)")
                if imgui.BeginPopupContextItem(name .. "popup") then
                    for i = 1, #util do
                        local utilData = util[i]
                        if utilData[2] ~= nil then
                            if imgui.Button(utilData[1]) then
                                if type(utilData[2]) == "table" then
                                    local t = {}
                                    for i = 1, #convdata do
                                        for ik = 1, #utilData[2] do
                                            if utilData[2][ik] == convdata[i][1] then
                                                table.insert(t, convdata[i][2])
                                            end
                                        end
                                    end
                                    local callback = utilData[3](val, t)
                                    if callback ~= nil then
                                        AddNotification(callback[1], 2.500, callback[2])
                                    end
                                else
                                    local callback = utilData[2](val)
                                    if callback ~= nil then
                                        AddNotification(callback[1], 2.500, callback[2])
                                    end
                                end
                            end
                        else
                            imgui.Text(utilData[1])
                        end
                    end

                    if imgui.Button("Close") then
                        imgui.CloseCurrentPopup()
                    end

                    imgui.EndPopup()
                end
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                    imgui.Text("Press RBM To activate fast functions")
                    imgui.EndTooltip()
                end
            end
        end
    end
end

function SendData(id, convdata)
    local define = GetSendDefine(id)
    if convdata == nil then
        data = GetSendConvertedData(id)
    else
        data = convdata
    end
    local dataType = GetSendDataType(id)
    local bs = raknetNewBitStream()
    if dataType == "OUTCOMING_PACKET" then
        raknetBitStreamWriteInt8(bs, id)
    end
    for i = 1, #data do
        local dataElement = data[i]
        local dataType = dataElement[4]
        local defineElement = define[i]
        local defineType = defineElement[2]

        if dataType == "inputint" then
            raknetIO[defineType].write(bs, dataElement[2].v)
        elseif dataType == "checkbox" then
            raknetIO[defineType].write(bs, dataElement[2].v)
        elseif dataType == "float" then
            raknetIO[defineType].write(bs, dataElement[2].v)
        elseif dataType == "inputtext" then
            raknetIO[defineType].write(bs, u8:decode(dataElement[2].v))
        elseif dataType == "inputint3" then
            raknetIO[defineType].write(bs, dataElement[2])
        elseif dataType == "inputfloat2" then
            raknetIO[defineType].write(bs, {x = dataElement[2].v[1], y = dataElement[2].v[2]})
        elseif dataType == "inputfloat3" then
            raknetIO[defineType].write(bs, {x = dataElement[2].v[1], y = dataElement[2].v[2], z = dataElement[2].v[3]})
        elseif dataType == "inputfloat4" then
            raknetIO[defineType].write(
                bs,
                {
                    dataElement[2].v[4],
                    dataElement[2].v[1],
                    dataElement[2].v[2],
                    dataElement[2].v[3]
                }
            )
        end
    end
    if dataType == "OUTCOMING_PACKET" then
        raknetSendBitStreamEx(bs, sf.HIGH_PRIORITY, sf.UNRELIABLE_SEQUENCED, 1)
    elseif dataType == "INCOMING_RPC" then
        raknetEmulRpcReceiveBitStream(id, bs)
    elseif dataType == "OUTCOMING_RPC" then
        raknetSendRpc(id, bs)
    end
    raknetDeleteBitStream(bs)
end

function GetSendDefine(id)
    if incoming_rpc[id] ~= nil then
        return incoming_rpc[id]
    elseif outcoming_rpc[id] ~= nil then
        return outcoming_rpc[id]
    elseif outcoming_packets[id] ~= nil then
        return outcoming_packets[id]
    end
end

function GetSendConvertedData(id)
    if incoming_rpc[id] ~= nil then
        return config.data.rpc.incoming.convdata[id]
    elseif outcoming_rpc[id] ~= nil then
        return config.data.rpc.outcoming.convdata[id]
    elseif outcoming_packets[id] ~= nil then
        return config.data.packets.outcoming.convdata[id]
    end
end

function GetSendDataType(id)
    local data = {"INCOMING_RPC", "OUTCOMING_RPC", "OUTCOMING_PACKET"}
    if incoming_rpc[id] ~= nil then
        return data[1]
    elseif outcoming_rpc[id] ~= nil then
        return data[2]
    elseif outcoming_packets[id] ~= nil then
        return data[3]
    end
end

function AddNotification(text, time, style)
    if loaded_notf then
        notf.addNotification(text, time, style)
    end
end

function imgui.SelectableList(name, size, var, selectables)
    imgui.BeginChild(name, size, true)

    for i = 1, #selectables do
        local name = selectables[i]
        if imgui.Selectable(name) then
            var.v = i
        end
    end

    imgui.EndChild()
end

function apply_custom_style()
    imgui.SwitchContext()
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

    colors[clr.FrameBg] = ImVec4(0.16, 0.29, 0.48, 0.54)
    colors[clr.FrameBgHovered] = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.FrameBgActive] = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.TitleBg] = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive] = ImVec4(0.16, 0.29, 0.48, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.SliderGrab] = ImVec4(0.24, 0.52, 0.88, 1.00)
    colors[clr.SliderGrabActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Button] = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.ButtonHovered] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
    colors[clr.Header] = ImVec4(0.26, 0.59, 0.98, 0.31)
    colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
    colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Separator] = colors[clr.Border]
    colors[clr.SeparatorHovered] = ImVec4(0.26, 0.59, 0.98, 0.78)
    colors[clr.SeparatorActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
    colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.ResizeGripActive] = ImVec4(0.26, 0.59, 0.98, 0.95)
    colors[clr.TextSelectedBg] = ImVec4(0.26, 0.59, 0.98, 0.35)
    colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg] = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg] = colors[clr.PopupBg]
    colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg] = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab] = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton] = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()
