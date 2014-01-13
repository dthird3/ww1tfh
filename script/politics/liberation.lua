-----------------------------------------------------------
-- LUA Hearts of Iron 3 Liberation File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/10/2013
-----------------------------------------------------------
local P = {}
Politics_Liberation = P

-- #######################
-- Generate Score
-- #######################
function P.GetScore(voTarget, voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("GetScore")
	local loDiploScoreObj = {
		Score = 100,											-- Current Score (integer)
		ministerAI = voPoliticsMinisterData.ministerAI,			-- AI Object
		Year = voPoliticsMinisterData.Year,						-- Current in game Year (integer)
		Month = voPoliticsMinisterData.Month,					-- Current in game Month (integer)
		Day = voPoliticsMinisterData.Day,						-- Current in game Day (integer)
		Actor = {
			Name = tostring(voPoliticsMinisterData.Tag),		-- Country Name (String)
			Tag = voPoliticsMinisterData.Tag,					-- Country Tag
			Country = voPoliticsMinisterData.Country,			-- Country Object
			IsPuppet = voPoliticsMinisterData.IsPuppet, 		-- True/False are they a Puppet Country
			IsExile	= voPoliticsMinisterData.IsExile, 			-- True/False are the in exile
			IsNaval = voPoliticsMinisterData.IsNaval, 			-- True/False do the meet requirements to use the Naval standard file or Land
			IcOBJ = voPoliticsMinisterData.IcOBJ, 				-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = voPoliticsMinisterData.PortsTotal,		-- (integer) Total amount of ports the country has
			IsMajor = voPoliticsMinisterData.IsMajor,			-- True/False is this country a major power
			IsAtWar = voPoliticsMinisterData.IsAtWar,			-- True/False is this country a at war
			Faction = voPoliticsMinisterData.Faction,			-- Faction Object the country belongs to
			FactionName = voPoliticsMinisterData.FactionName,	-- Name of the Faction the country belongs to (string)
			HasFaction = voPoliticsMinisterData.HasFaction,		-- True/False does the country have a faction
			Strategy = voPoliticsMinisterData.Strategy},		-- Strategy Object
		Target = {
			Name = voTarget.Name,				-- Country Name (String)
			Tag = voTarget.Tag,					-- Country Tag
			Country = voTarget.Country}			-- Country Object
	}

	return Support_Country.Call_Score_Function(true, 'PoliticsScore_Liberate', loDiploScoreObj)
end

-- #######################
-- Called by politics.lua
-- #######################
function P.Liberation(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("Liberation")
	-- Peformance are there any countries we can liberate
	if voPoliticsMinisterData.Country:MayLiberateCountries() then
		local lbProcess = true
		local loFunRef = Support_Country.Get_Function(voPoliticsMinisterData, "Politics_Liberation")
		
		-- Custom method check it
		if loFunRef then
			lbProcess = loFunRef(voPoliticsMinisterData)
		end
		
		-- Should we continue or did custom shut me down
		if lbProcess then
			for loLiberateTag in voPoliticsMinisterData.Country:GetPossibleLiberations() do
				local loTarget = {
					Name = tostring(loLiberateTag),
					Tag = loLiberateTag,
					Country = loLiberateTag:GetCountry()
				}
				
				if not(voPoliticsMinisterData.IsAtWar) then
					if P.GetScore(loTarget, voPoliticsMinisterData) > 70 then
						P.Command_Liberate(voPoliticsMinisterData.ministerAI, loTarget.Tag, voPoliticsMinisterData.Tag)							
					end
				else
					-- Ok to liberate our puppets since AI will fight through them
					if loTarget.Country:IsPuppet() then
						if loTarget.Country:GetOverlord() == voPoliticsMinisterData.Tag then
							if P.GetScore(loTarget, voPoliticsMinisterData) > 70 then
								P.Command_Liberate(voPoliticsMinisterData.ministerAI, loTarget.Tag, voPoliticsMinisterData.Tag)							
							end
						end
					end
				end
			end
		end
	end
end

-- #######################
-- Support Methods
-- #######################
function P.Command_Liberate(vAI, voTargetTag, voFromTag)
--Utils.LUA_DEBUGOUT("Command_Liberate")
	local loCommand = CLiberateCountryCommand(voTargetTag, voFromTag)
	vAI:Post(loCommand)
	return true
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return Politics_Liberation