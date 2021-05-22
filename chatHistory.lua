script_name("ChatHistory")
script_version("1.0")
script_author("Emilis")
script_description("CTRL + up/down arrow ijungus chata")

local sampev = require 'lib.samp.events'
local vk = require "lib.vkeys"
local enable = true
require "lib.sampfuncs"
require "lib.moonloader"
local messages = {}
local i = 0
local k = 0

--------------------------------------------------------------------------------

function main()
	repeat wait (0)
	until isSampLoaded()
	repeat wait (0)
	until isSampfuncsLoaded()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("cleanmemory")
		if not cmdResult then
			local result = sampRegisterChatCommand("cleanmemory", cleanMemory)
		end
		local chatActive = sampIsChatInputActive()
		if chatActive and enable then
			k = i
			while true do
				wait(0)
				if wasKeyPressed(vk.VK_RIGHT) then --VK_DOWN
					--sampAddChatMessage("Rasta: "..i.." eiluciu", 0xffffff)
					k = k - 1
					sampSetChatInputText(messages[k])

				elseif wasKeyPressed(vk.VK_LEFT) then
					--sampAddChatMessage("debug: paspaude i {ff0000}apacia", 0xffffff)
					k = k + 1
					sampSetChatInputText(messages[k])

				elseif wasKeyPressed(vk.VK_RETURN) or wasKeyPressed(vk.VK_ESCAPE) then
					break
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function sampev.onServerMessage(color, text)
	if enable and text ~= " " then
		i = i + 1
		messages[i] = text
		--sampAddChatMessage(color, 0xffffff) --debug
		if i == 20 then
			cleanmemory()
		end
	end
end

function cleanMemory()
	messages = {}
	i = 0
	enable = not enable
	sampAddChatMessage("[CHAT HISTORY] Atmintis isvalyta.", 0xffffff)
end
