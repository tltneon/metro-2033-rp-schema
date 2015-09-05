ITEM.name = "Gas Mask"
ITEM.partdata = { -- You can use PAC3 to setup the part.
        model = "models/half-dead/metroll/p_mask_2.mdl",
        bone = "ValveBiped.Bip01_Head1",
        position = Vector( 2.36, -3.093, -0.113 ),
        angle = Angle( -90.448, 0.01, 0.011 ),
        scale = Vector( 1, 1, 1 ),
        size = 1,
--
}
ITEM.model = Model("models/half-dead/metroll/p_mask_2.mdl")
ITEM.overlay = Material("effects/gasmask_screen.vmt")
ITEM.weight = 1
ITEM.desc = "A Mask that protects you from the bad air area."
ITEM.price = 200