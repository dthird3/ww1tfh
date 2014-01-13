-----------------------------------------------------------
-- LUA Hearts of Iron 3 Mobilization File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 3/19/2013
-----------------------------------------------------------
local P = {}
Politics_Mobilization = P

-- #######################
-- Generate Score
-- #######################
function P.GetScore(voTarget, voPoliticsObject)
--Utils.LUA_DEBUGOUT("GetScore")
	local liScore = 0

	-- can we even declare war?
	if not(voPoliticsObject.ministerAI:CanDeclareWar(voPoliticsObject.Actor.Tag, voTarget.Tag)) then
		return 0
	end

	local liAntogonism = voPoliticsObject.Actor.Strategy:GetAntagonism(voTarget.Tag);
	local liFriendliness = voPoliticsObject.Actor.Strategy:GetFriendliness(voTarget.Tag);

	-- dont declare war on people we like
	if liFriendliness > 0 and liAntogonism < 1 then
		return 0
	end

	-- no suicide :S
	if voPoliticsObject.Actor.Country:GetNumberOfControlledProvinces() < voTarget.Country:GetNumberOfControlledProvinces() / 4 then
		return 0
	end

	-- watch out if we have bad intel, should be infiltrating more
	local loIntel = CAIIntel(voPoliticsObject.Actor.Tag, voTarget.Tag)
	if loIntel:GetFactor() < 0.1 then
		return 0
	end

	-- compare military power
	local liTheirStrength = loIntel:CalculateTheirPercievedMilitaryStrengh()
	local liOurStrength = loIntel:CalculateOurMilitaryStrength()
	local liStrengthFactor = liOurStrength / liTheirStrength

	if liStrengthFactor < 1.0 then
		liScore = liScore - 75 * (1.0 - liStrengthFactor)
	else
		liScore = liScore + 20 * (liStrengthFactor - 1.0)
	end

	-- personality
	if voPoliticsObject.Actor.Strategy:IsMilitarist() then
		liScore = liScore * 1.3
	end
	
	return liScore
end

-- #######################
-- Called by politics.lua
-- #######################
function P.Mobilization(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("Mobilization")
	local loPoliticsObject = {
		Mobilize = false,
		ministerAI = voPoliticsMinisterData.ministerAI,			-- AI Object
		Year = voPoliticsMinisterData.Year,						-- Current in game Year (integer)
		Month = voPoliticsMinisterData.Month,					-- Current in game Month (integer)
		Day = voPoliticsMinisterData.Day,						-- Current in game Day (integer)
		Actor = {
			Name = tostring(voPoliticsMinisterData.Tag), -- Country Name (String)
			Tag = voPoliticsMinisterData.Tag,			-- Country Tag
			Country = voPoliticsMinisterData.Country,	-- Country Object
			IsMobilized = nil,									-- True/False is the country mobilized already
			Strategy = voPoliticsMinisterData.Strategy,			-- Strategy Object
			IsAtWar = voPoliticsMinisterData.IsAtWar,			-- True/False is this country a at war
			Faction = voPoliticsMinisterData.Faction,			-- Faction Object the country belongs to
			FactionName = voPoliticsMinisterData.FactionName,	-- Name of the Faction the country belongs to (string)
			HasFaction = voPoliticsMinisterData.HasFaction,		-- True/False does the country have a faction
			IcOBJ = voPoliticsMinisterData.IcOBJ,
			Neutrality = nil									-- Current Neutrality level (integer)
		}
	}

	-- Only AI would ever use this code
	if not(CCurrentGameState.IsPlayer(voPoliticsMinisterData.Tag)) then
		-- Performance if we are atwar there is no need to check this
		if not(loPoliticsObject.Actor.IsAtWar) then
			-- Performance check Already Mobilized so exit
			loPoliticsObject.Actor.Neutrality = loPoliticsObject.Actor.Country:GetEffectiveNeutrality():Get()
			loPoliticsObject.Actor.IsMobilized = loPoliticsObject.Actor.Country:IsMobilized()

			local lbProcess = true
			local loFunRef = Support_Country.Get_Function(voPoliticsMinisterData, "Politics_Mobilization")
			
			-- Custom method check it
			if loFunRef then
				lbProcess = loFunRef(loPoliticsObject)
			end
			
			-- Should we continue or did custom shut me down
			if lbProcess then
				-- Out Faction leader is at war so mobilize
				if loPoliticsObject.Actor.HasFaction then
					local loFaction = loPoliticsObject.Actor.Country:GetFaction()

					-- Faction leader is atwar so mobilize
					if loPoliticsObject.Actor.Faction:GetFactionLeader():GetCountry():IsAtWar() then
						loPoliticsObject.Mobilize = true
					end
				end				
				
				-- Preparing for War so mobilize
				if not(loPoliticsObject.Mobilize) then
					-- If we are preparing for war then mobilize
					if loPoliticsObject.Actor.Strategy:IsPreparingWar() then
						loPoliticsObject.Mobilize = true
					end
				end
			
				-- check if a neighbor is starting to look threatening
				if not(loPoliticsObject.Mobilize) then
					for loCountryTag in loPoliticsObject.Actor.Country:GetControllerNeighbours() do
						local loTarget = {
							Name = nil,
							Tag = loCountryTag,
							Country = loCountryTag:GetCountry(),
							IcOBJ = nil
						}
						
						local liThreat = loPoliticsObject.Actor.Country:GetRelation(loTarget.Tag):GetThreat():Get()
						
						if (loPoliticsObject.Actor.Neutrality - liThreat) < 10 then
							local liDistance = loPoliticsObject.ministerAI:GetCountryAlignmentDistance(loPoliticsObject.Actor.Country, loTarget.Country):Get()
							liThreat = liThreat * (math.min(liDistance / 400.0, 1.0))
							loTarget.IcOBJ = Support_Functions.GetICBreakDown(loTarget.Country)

							if loPoliticsObject.Actor.IcOBJ.IC > 50 and loTarget.IcOBJ.IC < loPoliticsObject.Actor.IcOBJ.IC then
								liThreat = liThreat / 2 -- we can handle them if they descide to attack anyway
							end
							
							if liThreat > 30 then
								if P.GetScore(loTarget, loPoliticsObject) > 70 then
									loPoliticsObject.Mobilize = true
									break
								end
							end
						end
					end
				end
				
				if loPoliticsObject.Mobilize and not(loPoliticsObject.Actor.IsMobilized) then
					P.Command_Mobilize(loPoliticsObject.ministerAI, loPoliticsObject.Actor.Tag, true)
				elseif loPoliticsObject.Actor.IsMobilized and not(loPoliticsObject.Mobilize) then
					P.Command_Mobilize(loPoliticsObject.ministerAI, loPoliticsObject.Actor.Tag, false)
				end
			end
		end
	end
end

-- #######################
-- Support Methods
-- #######################
function P.Command_Mobilize(vAI, voTag, vbMobilize)
--Utils.LUA_DEBUGOUT("Command_Mobilize")
	-- Mobilization Command
	local loCommand = CToggleMobilizationCommand(voTag, vbMobilize)
	vAI:Post(loCommand)
	return true
end
function P.Can_Click_Button(voTarget)
--Utils.LUA_DEBUGOUT("Can_Click_Button")
	if voTarget.Country:Exists() then
		if voTarget.Tag:IsReal() then
			if voTarget.Tag:IsValid() then
				return true
			end
		end
	end
	
	return false
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return Politics_Mobilization