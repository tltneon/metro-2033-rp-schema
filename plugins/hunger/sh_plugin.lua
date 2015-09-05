PLUGIN.name = "Голод+++"
PLUGIN.author = "LiGyH"
PLUGIN.desc = "Фабрики + голод."

if (SERVER) then
function PLUGIN:PostPlayerLoadout(client)
		client:setLocalVar("hunger", 100)
		client:setLocalVar("thirst", 100)

		local hungID = "nutHung"..client:SteamID()
		local thirID = "nutThir"..client:SteamID()
		local hungSpeed = 1
		local thirSpeed = 2

		timer.Create(hungID, 90, 0, function()
			if (IsValid(client)) then
			local character = client:getChar()
			client:setLocalVar("hunger", client:getLocalVar("hunger") - hungSpeed)
			client:setLocalVar("thirst", client:getLocalVar("thirst") - thirSpeed)
			--character:updateAttrib("surv", 0.01)
			else
				timer.Remove(hungID)
			end
		end)
		
		timer.Create(thirID, 5, 0, function()
		if (IsValid(client)) then
			if (client:getLocalVar("hunger") <= 0) or (client:getLocalVar("thirst") <= 0) then
				client:TakeDamage(5)
			end
		else
			timer.Remove(thirID)
		end
		end)
		
end

local playerMeta = FindMetaTable("Player")

	function playerMeta:restoreHunger(amount)
		local current = self:getLocalVar("hunger", 0)
		local value = math.Clamp(current + amount, 0, 100)

		self:setLocalVar("hunger", value)
	end
	
	function playerMeta:restoreThirst(amount)
		local current = self:getLocalVar("thirst", 0)
		local value = math.Clamp(current + amount, 0, 100)

		self:setLocalVar("thirst", value)
	end

else
	nut.bar.add(function() return LocalPlayer():getLocalVar("hunger", 0) / 100 end, Color(40, 100, 40), nil, "hunger")
	nut.bar.add(function() return LocalPlayer():getLocalVar("thirst", 0) / 100 end, Color(40, 40, 200), nil, "thirst")
end