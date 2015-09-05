SCHEMA.name = "Metro 2033 RP"
SCHEMA.author = "netzona.org"
SCHEMA.desc = "A roleplaying schema based on the destroyed world of Metro: Last Light."
SCHEMA.uniqueID = "metro2033"
nut.config.mainColor = Color(255, 0, 0)

nut.currency.set("Round", "Rounds", "")

nut.util.includeDir("hooks")
nut.util.include("sh_baseclient.lua")
nut.util.include("cl_legs.lua")

local ICON_DWELLER = Material("icon16/metrodw.png")
local ICON_RANGER = Material("icon16/rangerdw.png")

local ICON_USER = Material("icon16/user.png")
local ICON_HEART = Material("icon16/heart.png")
local ICON_WRENCH = Material("icon16/wrench.png")
local ICON_STAR = Material("icon16/star.png")
local ICON_SHIELD = Material("icon16/shield.png")
local ICON_DEVELOPER = Material("icon16/wrench_orange.png")

nut.chat.Register("ooc", {
	onChat = function(speaker, text)
		local icon = ICON_USER
		local factionicon = ICON_DWELLER

		if (speaker:Team() == FACTION_DWELLER) then
		  factionicon = ICON_DWELLER
		end
		
		if (speaker:SteamID() == "STEAM_0:1:34930764") then
			icon = ICON_DEVELOPER
		elseif (speaker:IsSuperAdmin()) then
			icon = ICON_SHIELD
		elseif (speaker:IsAdmin()) then
			icon = ICON_STAR
		elseif (speaker:IsUserGroup("operator")) then
			icon = ICON_WRENCH
		elseif (speaker:IsUserGroup("donator")) then
			icon = ICON_HEART
		end

		local override = nut.schema.Call("GetUserIcon", speaker)

		if (override and type(override) != "IMaterial") then
			override = Material(override)
		end

		chat.AddText(override or icon, factionicon, Color(250, 40, 40), "[OOC] ", speaker, color_white, ": "..text)
	end,
	prefix = {"//", "/ooc"},
	deadCanTalk = true,
	canSay = function(speaker)
		local nextOOC = speaker:GetNutVar("nextOOC", 0)

		if (nextOOC < CurTime()) then
			speaker:SetNutVar("nextOOC", CurTime() + nut.config.oocDelay)
			return true
		end

		nut.util.Notify("You must wait "..math.ceil(nextOOC - CurTime()).." more second(s) before using OOC.", speaker)

		return false
	end,
	noSpacing = true
})