script_name("pressSpace")
script_description("/aimdata <ID> seka zmogaus kamera")
script_version_number(1)
script_version("v.001")
script_authors("Emilis")

local sampev = require 'lib.samp.events'
local raknet = require 'lib.samp.raknet'

function main()
	repeat wait(0)
	until isSampAvailable()
end

function sampev.onPlayerSync(playerId, data)
	--sampAddChatMessage("Gavo", 0xffffff)
	if data.health ~= nil then
		sampAddChatMessage(playerId.."   data: "..data.health, 0xffffff)
	end
end
