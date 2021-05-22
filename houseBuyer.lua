script_name ("pavadinimas")
script_version("1.0")

--------------------------------------------------------------------------------

require "lib.moonloader"
local sampev = require 'lib.samp.events'
local enable = false
local pickup = 0
local pickUpEdit = false
local toggleBuy = false
local togglePress = false
local dialogIds = 0
local Paspaudziau = false

--------------------------------------------------------------------------------

function main()
	repeat wait(0)	until isSampAvailable()
	while true do
		wait(0)
		local cmdResult = sampIsChatCommandDefined("autobuy")
		if not cmdResult then
			local result = sampRegisterChatCommand("autobuy", toggleScript)
		end
        if toggleBuy then
            sampSendPickedUpPickup(pickup)
        end 
		result = sampIsDialogActive()
		if enable and togglePress and result then
			togglePress = false 
			closeDialogWithButton(dialogIds, 1, 65535, 0, "") 
		end
	end
end

--------------------------------------------------------------------------------
-- Komandos registravimas

function toggleScript()
    enable = not enable
    if enable then
        sampAddChatMessage(ltu('[Namo Pirkimas] Automatinis namų pirkimas {16f534}įjungtas{1cd031}. Užlipkite ant {ff0000}norimo namo {1cd031}ikonos.'), 0x1cd031)
        pickUpEdit = true
    else
        sampAddChatMessage(ltu('[Namo Pirkimas] Automatinis namų pirkimas {ff0000}išjungtas.'), 0x1cd031)
        toggleBuy = false
    end
end


function sampev.onSendPickedUpPickup(pickupId)
	if pickUpEdit and enable then
		pickup = pickupId
        pickUpEdit = false
        sampAddChatMessage(ltu('[Namo Pirkimas] Nustatytas namo pickup: {ff0000}'..pickup), 0x1cd031)
        toggleBuy = true
	end
end
--------------------------------------------------------------------------------

function closeDialogWithButton(id, button, listItem, textLength, text) -- 1 = left, 0 = right
	sampAddChatMessage("darau", -1)
    bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, id)
    raknetBitStreamWriteInt8(bs, button)
    raknetBitStreamWriteInt16(bs, listItem)
    raknetBitStreamWriteInt8(bs, textLength)
    raknetBitStreamWriteString(bs, text)
    raknetSendRpc(62, bs)
    raknetDeleteBitStream(bs)
	Paspaudziau = true
end 

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    togglePress = true
    toggleBuy = false
	dialogIds = dialogId
    sampAddChatMessage(dialogId.."   "..style.."  "..title.."   "..button1, -1)
end 

function sampev.onSendDialogResponse(dialogId, button, listbox, input)
    sampAddChatMessage(dialogId, -1)
	sampAddChatMessage("a", -1)
	sampAddChatMessage(button, -1)
	sampAddChatMessage("b", -1)
	sampAddChatMessage(listbox, -1)
	sampAddChatMessage("c", -1)
	sampAddChatMessage(input, -1)
	if Paspaudziau then 
		sampAddChatMessage("false", -1)
		Paspaudziau = false
		return false
	end 
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