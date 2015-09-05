ITEM.name = "Food base"
ITEM.desc = "A food."
ITEM.category = "food"
ITEM.model = "models/props_lab/bindergraylabel01b.mdl"
ITEM.hunger = 5
ITEM.thirst = 5
ITEM.empty = false
ITEM.factions = {}
ITEM.functions.Eat = {
	onRun = function(item)
	local client = item.player
	if item.hunger > 0 then client:restoreHunger(item.hunger) end
	if item.thirst > 0 then client:restoreThirst(item.thirst) end
	--client:EmitSound( "physics/flesh/flesh_bloody_break.wav", 75, 200 )
	client:EmitSound("zona/stalkerrp/actions/interface/inv_food.ogg")
	--if !item.empty then client:getChar():getInv():add(item.uniqueID.."_empty") end
		return true
	end,
	onCanRun = function(item)
		return (!item.empty)
	end,
	icon = "icon16/cup.png",
	name = "Употребить"
}
ITEM.permit = "food"