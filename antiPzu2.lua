script_name("anti pzu2")

local sampev = require 'lib.samp.events'
require "lib.sampfuncs"
require "lib.moonloader"
local toggle = false

-----------------------------------------------------------------------

function main()
	repeat wait(0)
	until isSampLoaded()
	repeat wait(0)
	until isSampfuncsLoaded()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined(".antipzu")
		if not cmdResult then
			local result = sampRegisterChatCommand(".antipzu", toggle)
		end
	end
end

-----------------------------------------------------------------------
--[[
function sampev.onShowTextDraw(textdrawId, textdraw)
	if not toggle then return end
	sampAddChatMessage("id: "..textdrawId.." flags: "..textdraw.flags, 0x328ba8)
	sampAddChatMessage("letterWidth: "..textdraw.letterWidth, 0x328ba8)
	sampAddChatMessage("letterHeight: "..textdraw.letterHeight, 0x328ba8)
	sampAddChatMessage("letterColor: "..textdraw.letterColor, 0x328ba8)
	sampAddChatMessage("lineWidth: "..textdraw.lineWidth, 0x328ba8)
	sampAddChatMessage("lineHeight: "..textdraw.lineHeight, 0x328ba8)
	sampAddChatMessage("boxColor: "..textdraw.boxColor, 0x328ba8)
	sampAddChatMessage("shadow: "..textdraw.shadow, 0x328ba8)
	sampAddChatMessage("outline: "..textdraw.outline, 0x328ba8)
	sampAddChatMessage("backgroundColor: "..textdraw.backgroundColor, 0x328ba8)
	sampAddChatMessage("style: "..textdraw.style, 0x328ba8)
	sampAddChatMessage("selectable: "..textdraw.selectable, 0x328ba8)
	sampAddChatMessage("position: "..textdraw.position.x, 0x328ba8)
	sampAddChatMessage("position: "..textdraw.position.y, 0x328ba8)
	sampAddChatMessage("modelId: "..textdraw.modelId, 0x328ba8)
	sampAddChatMessage("rotation: "..textdraw.rotation.x, 0x328ba8)
	sampAddChatMessage("rotation: "..textdraw.rotation.y, 0x328ba8)
	sampAddChatMessage("rotation: "..textdraw.rotation.z, 0x328ba8)
	sampAddChatMessage("zoom: "..textdraw.zoom, 0x328ba8)
	sampAddChatMessage("color: "..textdraw.color, 0x328ba8)
	sampAddChatMessage("text: "..textdraw.text, 0x328ba8)
	textdraw.modelId = 285
	return {textdrawId, textdraw}
end
]]
-----------------------------------------------------------------------

function toggle()
	toggle = not toggle
	if toggle then sampAddChatMessage("isjungtas", 0xffffff)
	else sampAddChatMessage("ijungtas", 0xff0000) end
end

-----------------------------------------------------------------------

function sampev.onSendPlayerSync(data)
	if toggle then return end
	local gavno = data.position.z
	gavno = gavno - 30.0
	data.position.z = gavno
	local textas = tostring(data.position.z)
	sampAddChatMessage(textas, 0xffffff)
end




-----------------------------------------------------------------------






-----------------------------------------------------------------------






-----------------------------------------------------------------------
