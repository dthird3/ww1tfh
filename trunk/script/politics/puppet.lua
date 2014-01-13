-----------------------------------------------------------
-- LUA Hearts of Iron 3 Puppet File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 3/20/2013
-----------------------------------------------------------
local P = {}
Politics_Puppet = P

-- #######################
-- Called by politics.lua
-- #######################
function P.Puppets(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("Puppets")
    if voPoliticsMinisterData.Country:CanCreatePuppet() then
		local loFunRef = Support_Country.Get_Function(voPoliticsMinisterData, "Politics_Puppets")

		if loFunRef then
			local loPoliticsObject = {
				ministerAI = voPoliticsMinisterData.ministerAI,			-- AI Object
				Year = voPoliticsMinisterData.Year,						-- Current in game Year (integer)
				Month = voPoliticsMinisterData.Month,					-- Current in game Month (integer)
				Day = voPoliticsMinisterData.Day,						-- Current in game Day (integer)
				Actor = {
					Name = tostring(voPoliticsMinisterData.Tag), -- Country Name (String)
					Tag = voPoliticsMinisterData.Tag,			-- Country Tag
					Country = voPoliticsMinisterData.Country,	-- Country Object
					Strategy = voPoliticsMinisterData.Strategy,			-- Strategy Object
					IsAtWar = voPoliticsMinisterData.IsAtWar,			-- True/False is this country a at war
					Faction = voPoliticsMinisterData.Faction,			-- Faction Object the country belongs to
					FactionName = voPoliticsMinisterData.FactionName,	-- Name of the Faction the country belongs to (string)
					HasFaction = voPoliticsMinisterData.HasFaction		-- True/False does the country have a faction
				}
			}
		
			loFunRef(loPoliticsObject)
		end	
    end
end

-- #######################
-- Support Methods
-- #######################
function P.Command_Puppet(vAI, voPuppetTag, voFromTag)
--Utils.LUA_DEBUGOUT("Command_Puppet")
	local loCommand = CCreateVassalCommand(voPuppetTag, voFromTag)
	vAI:Post(loCommand)
	return true
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return Politics_Puppet