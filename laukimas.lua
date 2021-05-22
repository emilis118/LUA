script_name("Laukimo BOT")
script_version("1.0")
script_author("Emilis")

local sampev = require 'lib.samp.events'
local json = require 'lib.json'
local enable = true
local crash = false
require "lib.moonloader"
local data = {
	username = "emilis",
	content = "lochas",
}



function main()
	repeat wait (0)
	until isSampLoaded()
	while true do
		wait(0)
		if enable then
			--local siuntimas = convertTableToJsonString(data)
			--sampAddChatMessage(siuntimas, 0xffffff)
			sendToDiscord("eml", "cbb")
			enable = false
		end
	end
end
--[[
function convertTableToJsonString(data)
    return (neatJSON(data, {sort = false, wrap = false}))
end
]]
function sendToDiscord(name, message)
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest('https://discord.com/api/webhooks/811218614714761216/3ULm28B-k_n4ElCjaej6WTWbR8_SC1zMTQPpRflsQtP5UlhaXlOvbd578sKWW1fP6R9t',
	function(err, text, headers) end,
	'POST',
	json.encode({username = name, content = message}),
	{ ['Content-Type'] = 'application/json' })
end

--json.encode({username = name, content = message})
