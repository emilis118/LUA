script_name('pavadinimas')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local json = require 'lib.jsoncfg'
local objectJson = {
    id = 66666666,
    modelId = 0,
    position = {x = 0.0, y = 0.0, z = 0.0},
    rotation = {x = 0.0, y = 0.0, z = 0.0},
    drawDistance = 0.0,
    noCameraCol = false,
    attachToVehicleId = 0xFFFF,
    attachToObjectId = 0xFFFF,
    texturesCount = 0,
    materials = {},
    materialText = {},
    materials_text = materialText
}
local tempWrite = {}
local settings = {
    enable = true,
    drawDistance = 45.0
}
local k = 0
--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    -- setup(true)
    if not doesFileExist(getGameDirectory() .. '//moonloader//config//objectLoader//objects.json') then
        json.write(getGameDirectory() .. '//moonloader//config//objectLoader//objects.json', objectJson)
        sampAddChatMessage('sukuriamas json failas', -1)
    end
    objectJson = json.read(getGameDirectory() .. '//moonloader//config//objectLoader//objects.json')
    --------------------------------------------------------------------------------
    if not doesFileExist(getGameDirectory() .. '//moonloader//config//objectLoader//settings.json') then
        json.write(getGameDirectory() .. '//moonloader//config//objectLoader//settings.json', settings)
        sampAddChatMessage('sukuriamas json failas', -1)
    end
    settings = json.read(getGameDirectory() .. '//moonloader//config//objectLoader//settings.json')
    --------------------------------------------------------------------------------
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('object')
        if not cmdResult then
            local result = sampRegisterChatCommand('object', toggleScript)
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    sampAddChatMessage(':' .. getGameDirectory(), -1)
    sampAddChatMessage('Objektu yra: ' .. tostring(#objectJson), -1)
end

function sampev.onCreateObject(objectId, data)
    k = k + 1
    printString(k,800)
    -- if data.attachToObjectId == 0xFFFF or data.attachToVehicleId == 0xFFFF then
    --     if settings.enable then
    --         printString(objectId, 1000)
    --         local toggle = true
    --         for i = 1, #objectJson do
    --             if objectId == objectJson[i].id then
    --                 if data.position.x == objectJson[i].position.x and data.position.y == objectJson[i].position.y and data.position.z == objectJson[i].position.z then
    --                     toggle = false
    --                     break
    --                 end
    --             end
    --         end
    --         if toggle then
    --             -- sampAddChatMessage('Rastas naujas objektas: ' .. objectId .. ' irasoma i faila', -1)
    --             local tempObject = {
    --                 id = objectId,
    --                 modelId = data.modelId,
    --                 position = {x = data.position.x, y = data.position.y, z = data.position.z},
    --                 rotation = {x = data.rotation.x, y = data.rotation.y, z = data.rotation.z},
    --                 drawDistance = data.drawDistance,
    --                 noCameraCol = data.noCameraCol,
    --                 attachToVehicleId = data.attachToVehicleId,
    --                 attachToObjectId = data.attachToObjectId,
    --                 texturesCount = data.texturesCount,
    --                 materials = data.materials,
    --                 materialText = data.materialText,
    --                 materials_text = data.materials_text
    --             }
    --             table.insert(objectJson, tempObject)
    --             json.write(getGameDirectory() .. '//moonloader//config//objectLoader//objects.json', objectJson)
    --         end
    --     end
    -- end
    --[[ local data = {materials = {}, materialText = {}}
	local objectId = bsread.int16(bs)
	data.modelId = bsread.int32(bs)
	data.position = bsread.vector3d(bs)
	data.rotation = bsread.vector3d(bs)
	data.drawDistance = bsread.float(bs)
	data.noCameraCol = bsread.bool8(bs)
	data.attachToVehicleId = bsread.int16(bs)
	data.attachToObjectId = bsread.int16(bs)
	if data.attachToVehicleId ~= 0xFFFF or data.attachToObjectId ~= 0xFFFF then
		data.attachOffsets = bsread.vector3d(bs)
		data.attachRotation = bsread.vector3d(bs)
		data.syncRotation = bsread.bool8(bs)
	end
	data.texturesCount = bsread.int8(bs)
	while raknetBitStreamGetNumberOfUnreadBits(bs) >= 8 do
		local materialType = bsread.int8(bs)
		if materialType == MATERIAL_TYPE.TEXTURE then
			table.insert(data.materials, read_object_material(bs))
		elseif materialType == MATERIAL_TYPE.TEXT then
			table.insert(data.materialText, read_object_material_text(bs))
		end
	end
	data.materials_text = data.materialText -- obsolete ]]
end
--------------------------------------------------------------------------------
-- Ini failo apdirbimas

--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'objectLoader/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[] Nustatymai įrašyti.'), 0x1cd031)
    end
    --iniData = inicfg.load(nil, "objectLoader/settings") -- nlb gerai sitas
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

function setup(boolDir)
    if boolDir then
        local result = doesDirectoryExist(getGameDirectory() .. 'moonloader\\config\\objectLoadert')
        if not result then
            os.execute('mkdir ' .. getGameDirectory() .. '')
        end
    end
end
