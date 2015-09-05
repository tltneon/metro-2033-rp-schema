------- used for 'clothing'
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
------ used for 'parts'
if (CLIENT) then
        hook.Add("HUDPaint", "nut_PartOverlay", function()
                        if (!IsValid(LocalPlayer()) or !LocalPlayer().character) then
                                return
                        end
 
                        for v, items in pairs(LocalPlayer():GetInventory()) do
                                local itemTable = nut.item.Get(v)
 
                                if (itemTable and itemTable.overlay and itemTable.category == "Appearance") then
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