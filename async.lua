script_name ("async")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local effil = require 'lib.effil'
local iniData = {}
local mainCfg = {
	settings = {enable = true}
}
local host = "http://emlsound.xyz/accounts.json"
--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()

	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("aaas")
		if not cmdResult then
			local result = sampRegisterChatCommand("aaas", toggleScript)
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    asyncHttpRequest('GET', host, args,
    function(response)
        data = decodeJson(response.text)
        print(data)
        sampAddChatMessage('gavau', -1)
    end,
    function(error) 
        print(error)
    end)
end

--------------------------------------------------------------------------------
function asyncHttpRequest(method, url, args, resolve, reject)
    strResponse = '������� ����� �� �������...'
    sendRequest = true
    local request_thread = effil.thread(function (method, url, args)
       local requests = require 'requests'
       local result, response = pcall(requests.request, method, url, args)
       if result then
          response.json, response.xml = nil, nil
          sendRequest = false
          return true, response
       else
            sendRequest = false
          return false, response
       end
    end)(method, url, args)
    if not resolve then resolve = function() end end
    if not reject then reject = function() end end
    lua_thread.create(function()
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
    end)
 end


function ltu(text)
	local encoding = require 'encoding'
	encoding.default = 'cp1257'
	local u8 = encoding.UTF8
	local ltu = {
		"\xc4\x85",	--ą
		"\xc4\x8d",
		"\xc4\x99",
		"\xc4\x97",
		"\xc4\xaf",
		"\xc5\xa1",
		"\xc5\xb3",
		"\xc5\xab",
		"\xc5\xbe",
		"\xc4\x84",
		"\xc4\x8c",
		"\xc4\x98",
		"\xc4\x96",
		"\xc4\xae",
		"\xc5\xa0",
		"\xc5\xb2",
		"\xc5\xaa",
		"\xc5\xbd",
	}
	--ąčęėįšųūž ĄČĘĖĮŠŲŪŽ
	if string.find(text, "ą") then text = string.gsub(text, "ą", ltu[1]) end
	if string.find(text, "č") then text = string.gsub(text, "č", ltu[2]) end
	if string.find(text, "ę") then text = string.gsub(text, "ę", ltu[3]) end
	if string.find(text, "ė") then text = string.gsub(text, "ė", ltu[4]) end
	if string.find(text, "į") then text = string.gsub(text, "į", ltu[5]) end
	if string.find(text, "š") then text = string.gsub(text, "š", ltu[6]) end
	if string.find(text, "ų") then text = string.gsub(text, "ų", ltu[7]) end
	if string.find(text, "ū") then text = string.gsub(text, "ū", ltu[8]) end
	if string.find(text, "ž") then text = string.gsub(text, "ž", ltu[9]) end
	if string.find(text, "Ą") then text = string.gsub(text, "Ą", ltu[10]) end
	if string.find(text, "Č") then text = string.gsub(text, "Č", ltu[11]) end
	if string.find(text, "Ę") then text = string.gsub(text, "Ę", ltu[12]) end
	if string.find(text, "Ė") then text = string.gsub(text, "Ė", ltu[13]) end
	if string.find(text, "Į") then text = string.gsub(text, "Į", ltu[14]) end
	if string.find(text, "Š") then text = string.gsub(text, "Š", ltu[15]) end
	if string.find(text, "Ų") then text = string.gsub(text, "Ų", ltu[16]) end
	if string.find(text, "Ū") then text = string.gsub(text, "Ū", ltu[17]) end
	if string.find(text, "Ž") then text = string.gsub(text, "Ž", ltu[18]) end
	text = u8:decode(text)
	return text
end 