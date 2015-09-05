ITEM.name = "ITEM Clothes"
ITEM.uniqueID = "ITEM_cloth"
ITEM.category = "Clothing"
ITEM.data = {
        bulletDef = 0,
        Condition = 0,
        Equipped = false
}
ITEM.functions = {}
ITEM.functions.Wear = {
        run = function(itemTable, client, data)
        if (SERVER) then
                        local model = itemTable.model
                       
                        if ((string.find(model, "female") or nut.anim.GetClass(model) == "citizen_female") and itemTable.femaleModel) then
                                model = itemTable.femaleModel
                        end
 
                        if (data.Condition <= 5) then
                        nut.util.Notify("This clothing item is broken!", client)
                       
                        return false
                       
                        end
                       
                        if (!model) then
                                client.character:SetData("oldModel", nil, nil, true)
                                error("Clothing item without valid model! ("..(itemTable.uniqueID or "null")..")")
                        end
 
                        if (client.character:GetData("oldModel")) then
                                nut.util.Notify("You are already wearing another set of clothing.", client)
 
                                return false
                        end
 
                        local replacement = itemTable.replacement
                        local lowerPlyModel = string.lower(client:GetModel())
 
                        if (replacement) then
                                --[[
                                        Replacements can either be:
                                        ITEM.replacement = {"group02", "group03"}
 
                                        or:
 
                                        ITEM.replacement = {
                                                {"group01", "group03"},
                                                {"group02", "group03"}
                                        }
 
                                        You can also use regular expressions.
                                --]]
                                if (#replacement == 2 and type(replacement[1]) == "string" and type(replacement[2]) == "string") then
                                        model = string.gsub(lowerPlyModel, replacement[1], replacement[2])
                                elseif (#replacement > 0) then
                                        for k, v in pairs(replacement) do
                                                if (v[1] and v[2]) then
                                                        model = string.gsub(lowerPlyModel, string.lower(v[1]), string.lower(v[2]))
                                                end
                                        end
                                end
                        end
 
                        if (model == lowerPlyModel) then
                                model = itemTable.model
                        end
 
                        client.character:SetData("oldModel", lowerPlyModel, nil, true)
                        client.character.model = model
                        client:SetModel(model)
            client:SetArmor(data.Condition)
                       
                        if (itemTable.OnWear) then
                                itemTable:OnWear(client, data)
                        end
 
                        local newData = table.Copy(data)
                        newData.Equipped = true
 
                        client:UpdateInv(itemTable.uniqueID, 1, newData, true)
                        nut.schema.Call("OnClothEquipped", client, itemTable, true)
 
        end
        end,
        shouldDisplay = function(itemTable, data, entity)
                return !data.Equipped or data.Equipped == nil
        end
}
 
ITEM.functions.Repair = {
        text = "Repair",
        run = function(itemTable, client, data)
                if (SERVER) then
                        if (!client:HasItem("repair")) then
                                nut.util.Notify("You do not have the necessary supplies!", client)
 
                                return false
                        end
                        client:UpdateInv("repair", -1, nil, true)
                        
                        local newData = table.Copy(data)
                        
                        newData.bulletDef = data.bulletDef
                        newData.Condition = 100
 
                        client:UpdateInv(itemTable.uniqueID, 1, newData, true)
                        nut.util.Notify("You have repaired the suit!", client)
                end
        end,
        shouldDisplay = function(itemTable, data, entity)
                return data.Condition <= 50 and !data.Equipped or data.Equipped == nil
        end
}
 
ITEM.functions.TakeOff = {
        text = "Take Off",
        run = function(itemTable, client, data)
                if (SERVER) then
                        if (!client.character:GetData("oldModel")) then
                                return false
                        end

                        local newData = table.Copy(data)
                        
                        newData.Equipped = false
                        newData.Condition = client:Armor()
                       
                        local model = client.character:GetData("oldModel", client:GetModel())
                                client.character.model = model
                                client:SetModel(model)
                                client:SetArmor(0)
                        client.character:SetData("oldModel", nil, nil, true)
                       
                        client:UpdateInv(itemTable.uniqueID, 1, newData, true)
                        nut.schema.Call("OnClothEquipped", client, itemTable, false)
 
                        return true
                end
        end,
        shouldDisplay = function(itemTable, data, entity)
                return data.Equipped == true
        end
}
 
local size = 16
local border = 4
local distance = size + border
local tick = Material("icon16/tick.png")
 
function ITEM:PaintIcon(w, h)
        if (self.data.Equipped) then
                surface.SetDrawColor(0, 0, 0, 50)
                surface.DrawRect(w - distance - 1, w - distance - 1, size + 2, size + 2)
 
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(tick)
                surface.DrawTexturedRect(w - distance, w - distance, size, size)
        end
end
 
function ITEM:CanTransfer(client, data)
        if (data.Equipped) then
                nut.util.Notify("You must unequip the item before doing that.", client)
        end
 
        return !data.Equipped
end

function ITEM:GetDropModel()
        return (itemTable.dropModel or "models/props_c17/suitCase_passenger_physics.mdl")
end
 
function ITEM:OnRegister(itemTable)
        if (itemTable.outfitModel) then
                error("ITEM.outfitModel is now deprecated. Change it to ITEM.model")
        end
end
 
if (SERVER) then
        hook.Add("PlayerSpawn", "nut_ClothingITEM", function(client)
                timer.Simple(0.1, function()
                        if (!IsValid(client) or !client.character) then
                                return
                        end
 
                        for v, items in pairs(client:GetInventory()) do
                                local itemTable = nut.item.Get(v)
 
                                if (itemTable and itemTable.category == "Clothing") then
                                        for k, v in pairs(items) do
                                                if (v.data.Equipped) then
                                                        client:SetArmor(v.data.Condition)
                                                end
                                        end
                                end
                        end
                end)
        end)
        hook.Add("PlayerDeath", "nut_ClothingDeath", function(client)
                timer.Simple(0.1, function()
                        if (!IsValid(client) or !client.character) then
                                return
                        end
 
                        for v, items in pairs(client:GetInventory()) do
                                local itemTable = nut.item.Get(v)
 
                                if (itemTable and itemTable.category == "Clothing") then
                                        for k, v in pairs(items) do
                                                if (v.data.Equipped) then
                                            v.data.Condition = client:Armor()
                                                end
                                        end
                                end
                        end
                end)
        end)
        hook.Add("ScalePlayerDamage", "nut_Damage", function(client, hitgroup, dmginfo)
                        if (!IsValid(client) or !client.character) then
                                return
                        end
 
                        for v, items in pairs(client:GetInventory()) do
                                local itemTable = nut.item.Get(v)
 
                                if (itemTable and itemTable.category == "Clothing") then
                                        for k, v in pairs(items) do
                                                if (v.data.Equipped) then
                                                if (dmginfo:IsDamageType(DMG_BULLET) then
                                                    dmginfo:ScaleDamage( v.data.bulletDef )
                                                elseif ( v.data.Condition <= 5 ) then 
                                                    (dmginfo:ScaleDamage(1)) 
                                                end
                                                if ( v.data.Condition == 0) then
                                                    data.Equipped == false
                                                        LocalPlayer():EmitSound( "stalker/armourbreak.wav" )
                                                    end
                                                end
                                            end
                                    end
                            end
                    end)
            end
    end
end
    
if (CLIENT) then
        hook.Add("HUDPaint", "nut_ClothingOverlay", function()
                        if (!IsValid(LocalPlayer()) or !LocalPlayer().character) then
                                return
                        end
 
                        for v, items in pairs(LocalPlayer():GetInventory()) do
                                local itemTable = nut.item.Get(v)
 
                                if (itemTable and itemTable.overlay and itemTable.category == "Clothing") then
                                        for k, v in pairs(items) do
                                                if (v.data.Equipped) then
                        local mat = itemTable.overlay
                                                surface.SetDrawColor(255, 255, 255, 220)
                                                surface.SetMaterial(mat)
                                                surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
                                        end
                                end
                        end
                end
        end)
end