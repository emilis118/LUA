script_name('svytureliai')
script_version('1.0')

--------------------------------------------------------------------------------

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local json = require 'lib.jsoncfg'
local iniData = {}
local mainCfg = {
    settings = {enable = true}
}
local vehicleIds = {400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415,
	416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433,
	434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451,
	452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469,
	470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487,
	488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505,
	506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523,
	524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541,
	542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559,
	560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577,
	578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595,
	596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611
}

local vehicleNames = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perennial", "Sentinel", "Dumper", "Fire Truck", "Trashmaster", "Stretch", "Manana", 
                       "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", 
                       "Mr. Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", 
                       "Trailer 1", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", 
                       "Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", 
                       "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", 
                       "Quadbike", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", 
                       "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring Racer", "Sandking", 
                       "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer 3", "Hotring Racer 2", "Bloodring Banger", 
                       "Rancher Lure", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stuntplane", "Tanker", "Roadtrain", "Nebula", 
                       "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Towtruck", "Fortune", "Cadrona", "FBI Truck", 
                       "Willard", "Forklift", "Tractor", "Combine Harvester", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", 
                       "Bullet", "Clover", "Sadler", "Fire Truck Ladder", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility Van", 
                       "Nevada", "Yosemite", "Windsor", "Monster 2", "Monster 3", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", 
                       "Tahoma", "Savanna", "Bandito", "Freight Train Flatbed", "Streak Train Trailer", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", 
                       "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer (Tanker Commando)", "Emperor", "Wayfarer", "Euros", "Hotdog", 
                       "Club", "Box Freight", "Trailer 3", "Andromada", "Dodo", "RC Cam", "Launch", "Police LS", "Police", "Police SF", "Police LV", "Police Ranger", 
                       "Ranger", "Picador", "S.W.A.T.", "Alpha", "Phoenix", "Glendale Damaged", "Sadler", "Sadler Damaged", "Baggage Trailer (covered)", 
                       "Baggage Trailer (Uncovered)", "Trailer (Stairs)", "Boxville Mission", "Farm Trailer", "Street Clean Trailer"
}

local allowedCars = {402, 411, 415, 451, 541, 560}

local defaultPos = {
    {x = 0, y = -0.46959999203682, z = 0.76740002632141},
    {x = -0.31949999928474, y = 0.18369999527931, z = 0.73100000619888},
    {x = -0.2900390625, y = -0.2841796875, z = 0.63195705413818},
    {x = -0.46299999952316, y = -0.31360000371933, z = 0.62519997358322},
    {x = -0.2900390625, y = -0.2841796875, z = 0.60195708274841},
    {x = 0, y = 0, z = 0.80000001192093},
}
--------------------------------------------------------------------------------

function main()
    repeat
        wait(0)
    until isSampAvailable()
    if not doesFileExist(getGameDirectory() .. '//moonloader//config//svytureliai//settings.ini') then
        local iniBool = inicfg.save(mainCfg, 'svytureliai/settings')
    end
    iniData = inicfg.load(mainCfg, 'svytureliai/settings')
    
    if not doesFileExist(getGameDirectory() .. '//moonloader//config//svytureliai//positions.json') then
	    json.write(getGameDirectory() .. '//moonloader//config//svytureliai//positions.json', defaultPos)
    end
    positions = json.read(getGameDirectory() .. '//moonloader//config//svytureliai//positions.json')
    while true do
        wait(0)
        local cmdResult = sampIsChatCommandDefined('lights')
        if not cmdResult then
            local result = sampRegisterChatCommand('lights', toggleScript)
        end
        local cmdResult = sampIsChatCommandDefined('lx')
        if not cmdResult then
            local result = sampRegisterChatCommand('lx', setLx)
        end
        local cmdResult = sampIsChatCommandDefined('ly')
        if not cmdResult then
            local result = sampRegisterChatCommand('ly', setLy)
        end
        local cmdResult = sampIsChatCommandDefined('lz')
        if not cmdResult then
            local result = sampRegisterChatCommand('lz', setLz)
        end
        local cmdResult = sampIsChatCommandDefined('lreset')
        if not cmdResult then
            local result = sampRegisterChatCommand('lreset', resetLights)
        end
    end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    car = getCarCharIsUsing(PLAYER_PED)
    -- bool result = isCarModel(Vehicle car,Model modelId)
    modelId = getCarModel(car)
    
    for i = 1, #allowedCars do
        if modelId == allowedCars[i] then 
            sampAddChatMessage(ltu('[Švyturėliai] Aptiktas automobilis: '..vehicleNames[modelId-399]), -1)
            sampAddChatMessage(ltu('[Švyturėliai] Default X pozicija: '..defaultPos[i].x), -1)
            sampAddChatMessage(ltu('[Švyturėliai] Default Y pozicija: '..defaultPos[i].y), -1)
            sampAddChatMessage(ltu('[Švyturėliai] Default Z pozicija: '..defaultPos[i].z), -1)
            sampAddChatMessage(ltu('[Švyturėliai] Nustatyti naujas pozicijas šiam automobiliui: /lx [X.X]    /ly [X.X]   /lz [X.X]'), -1)
            break
        end
    end
end

function setLx(arg)
    if #arg == 0 then
        sampAddChatMessage(ltu('[Švyturėliai] Nustatyti naujas pozicijas šiam automobiliui: /lx [X.X]    /ly [X.X]   /lz [X.X]'), -1)
    else
        arg = tonumber(arg)
        car = getCarCharIsUsing(PLAYER_PED)
        modelId = getCarModel(car)
        for i = 1, #allowedCars do
            if modelId == allowedCars[i] then 
                positions[i].x = arg
                sampAddChatMessage(ltu('[Švyturėliai] Įrašyta nauja ('..vehicleNames[modelId-399]..') pozicija X: '..positions[i].x), -1)
                json.write(getGameDirectory() .. '//moonloader//config//svytureliai//positions.json', positions)
                break
            end
        end
    end
end
function setLy(arg)
    if #arg == 0 then
        sampAddChatMessage(ltu('[Švyturėliai] Nustatyti naujas pozicijas šiam automobiliui: /lx [X.X]    /ly [X.X]   /lz [X.X]'), -1)
    else
        arg = tonumber(arg)
        car = getCarCharIsUsing(PLAYER_PED)
        modelId = getCarModel(car)
        for i = 1, #allowedCars do
            if modelId == allowedCars[i] then 
                positions[i].y = arg
                sampAddChatMessage(ltu('[Švyturėliai] Įrašyta nauja ('..vehicleNames[modelId-399]..') pozicija Y: '..positions[i].y), -1)
                json.write(getGameDirectory() .. '//moonloader//config//svytureliai//positions.json', positions)
                break
            end
        end
    end
end
function setLz(arg)
    if #arg == 0 then
        sampAddChatMessage(ltu('[Švyturėliai] Nustatyti naujas pozicijas šiam automobiliui: /lx [X.X]    /ly [X.X]   /lz [X.X]'), -1)
    else
        arg = tonumber(arg)
        car = getCarCharIsUsing(PLAYER_PED)
        modelId = getCarModel(car)
        for i = 1, #allowedCars do
            if modelId == allowedCars[i] then 
                positions[i].z = arg
                sampAddChatMessage(ltu('[Švyturėliai] Įrašyta nauja ('..vehicleNames[modelId-399]..') pozicija Z: '..positions[i].z), -1)
                json.write(getGameDirectory() .. '//moonloader//config//svytureliai//positions.json', positions)
                break
            end
        end
    end
end


function resetLights()
 car = getCarCharIsUsing(PLAYER_PED)
  modelId = getCarModel(car)
    for i = 1, #allowedCars do
            if modelId == allowedCars[i] then 
                
                sampAddChatMessage(ltu('[Švyturėliai] Atstatyta originali ('..vehicleNames[modelId-399]..') pozicija.'), -1)
                positions[i].x = defaultPos[i].x
                positions[i].y = defaultPos[i].y
                positions[i].z = defaultPos[i].z
                json.write(getGameDirectory() .. '//moonloader//config//svytureliai//positions.json', positions)
                break
            end
        end
end


function sampev.onCreateObject(objectId, data)
    -- sampAddChatMessage('sukurtas: '..data.modelId, -1)
    if data.modelId == 18646 or data.modelId == 19419 then
        sampAddChatMessage('id: '..data.modelId, -1)
        if data.attachToVehicleId ~= 0xFFFF or data.attachToObjectId ~= 0xFFFF then
            car = getCarCharIsUsing(PLAYER_PED)
            modelId = getCarModel(car)
            print('X: '..data.attachOffsets.x)
            print('Y: '..data.attachOffsets.y)
            print('Z: '..data.attachOffsets.z)
            for i = 1, #allowedCars do
                if modelId == allowedCars[i] then 
                    data.attachOffsets.x = positions[i].x
                    data.attachOffsets.y = positions[i].y
                    data.attachOffsets.z = positions[i].z
                    break
                end
            end
            
            return {objectId, data}
        end
    end
end


--------------------------------------------------------------------------------
-- Ini failo apdirbimas

--writeSetting(false)
function writeSetting(msgBool)
    patvirtinimas = inicfg.save(iniData, 'svytureliai/settings')
    if patvirtinimas and msgBool then
        sampAddChatMessage(ltu('[Švyturėliai] Nustatymai įrašyti.'), 0x1cd031)
    end
    --iniData = inicfg.load(nil, "svytureliai/settings") -- nlb gerai sitas
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

