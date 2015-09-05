ITEM.name = "Фонарик"
ITEM.model = "models/raviool/flashlight.mdl"
ITEM.desc = "Обычный фонарик."
ITEM.price = 20
ITEM.permit = "misc"
ITEM.factions = {}
ITEM:hook("drop", function(item)
	if (item.player:FlashlightIsOn()) then
		item.player:Flashlight(false)
	end
end)

function ITEM:onTransfered()
	local client = self:getOwner()

	if (IsValid(client) and client:FlashlightIsOn()) then
		client:Flashlight(false)
	end
end