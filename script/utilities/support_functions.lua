-----------------------------------------------------------
-- LUA Hearts of Iron 3 Common Helper methods
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/23/2013
-----------------------------------------------------------

local P = {}
Support_Functions = P

function P.GetICBreakDown(voCountry)
	--Utils.LUA_DEBUGOUT("GetICBreakDown")
	local CountryIC = {
		TotalIC = voCountry:GetTotalIC(),	-- (integer) Total IC (one to the right in game interface)
		Base = voCountry:GetMaxIC(),		-- (integer) Base IC (one shows in the middle in game interface)
		IC = nil,							-- (integer) Calculated IC with no lend lease based on modifiers
		LendLease = nil,					-- (integer) Estimated IC which is Total IC minus IC
		OBJs = {
			CModifier = voCountry:GetGlobalModifier(),
			TechStatus = voCountry:GetTechnologyStatus()
		},
		Modifiers = {
			Global = nil,
			Tech = nil
		}
	}

	CountryIC.Modifiers.Global = CountryIC.OBJs.CModifier:GetValue(CModifier._MODIFIER_GLOBAL_IC_)
	CountryIC.Modifiers.Tech = CountryIC.OBJs.TechStatus:GetIcModifier()

	CountryIC.IC = CountryIC.Base + (CountryIC.Base * (CountryIC.Modifiers.Global + CountryIC.Modifiers.Tech))
	CountryIC.LendLease = CountryIC.TotalIC - CountryIC.IC

	return CountryIC
end

function P.IsFriendDistance(voAI, voFaction, voCountry)
	--Utils.LUA_DEBUGOUT("IsFriendDistance")
	local liLowestScore = nil

	if not(voCountry:HasFaction()) then
		for loFaction in CCurrentGameState.GetFactions() do
			if not(loFaction == voFaction) then
				-- They are aligning with another faction
				local liAlignment = math.floor(voAI:GetCountryAlignmentDistance(voCountry, loFaction:GetFactionLeader():GetCountry()):Get())
				
				if not(liLowestScore) then
					liLowestScore = liAlignment
				elseif liAlignment < liLowestScore then
					liLowestScore = liAlignment
				end
			end
		end
	end
		
	return liLowestScore
end

function P.IsFriend(voAI, voFaction, voCountry, viAlignment)
	--Utils.LUA_DEBUGOUT("IsFriend")
	if viAlignment == nil then
		viAlignment = 100
	end
	
	if not(voCountry:HasFaction()) then
		for loFaction in CCurrentGameState.GetFactions() do
			if not(loFaction == voFaction) then
				-- They are aligning with another faction
				local liAlignment = math.floor(voAI:GetCountryAlignmentDistance(voCountry, loFaction:GetFactionLeader():GetCountry()):Get())
				
				if liAlignment < viAlignment then
					return false
				end
			end
		end
	else
		if voCountry:GetFaction() ~= voFaction then
			return false
		end
	end
	
	return true
end

function P.GoodToWarCheck(voTargetTag, voTargetCountry, voForeignMinisterData, vbNeighborCheck, vbFactionWarCheck, vbNapCheck, vbAllianceCheck)
	--Utils.LUA_DEBUGOUT("GoodToWarCheck")
	local lbDOW = false

	if voTargetCountry:Exists() then
		local loRelation = voForeignMinisterData.Country:GetRelation(voTargetTag)

		-- Do we have an Alliance
		if not(loRelation:HasAlliance()) or vbAllianceCheck then
			-- Do we have a Non Aggression Pact
			if not(loRelation:HasNap()) or vbNapCheck then
				-- Make Sure we are not already at war
				if not(loRelation:HasWar()) then
					-- Make sure they are our neighbor or Neighbor Check is bypassed
					local lbIsNeighbor = vbNeighborCheck
				
					if not(lbIsNeighbor) then
						lbIsNeighbor = voForeignMinisterData.Country:IsNonExileNeighbour(voTargetTag)
					end
				
					if lbIsNeighbor then
						-- If they have a faction check to see if we are already atwar with that faciton leader
						if voTargetCountry:HasFaction() then
							local loFaction = voTargetCountry:GetFaction()
							-- They are not in our faction
							if loFaction ~= voForeignMinisterData.Faction then
								if vbFactionWarCheck then
									lbDOW = true
								else
									local loFactionLeaderTag = voTargetCountry:GetFaction():GetFactionLeader()
									local loFactionRelation = voForeignMinisterData.Country:GetRelation(loFactionLeaderTag)
				
									-- If we are at war with that faction already then DOW
									if loFactionRelation:HasWar() then
										lbDOW = true
									end
								end
							end
						else
							-- check so we have threat or we shouldnt be randomly attacking neutrals
							if voForeignMinisterData.FactionName == "allies" then
								if loRelation:GetThreat():Get() > 30 then
									lbDOW = true
								end
							else
								lbDOW = true
							end
						end
					end
				end
			end
		end
	end
	
	return lbDOW
end

function P.IsFactionNeighbor(voCountry, voFaction)
	--Utils.LUA_DEBUGOUT("IsFactionNeighbor")
	for loNeighborTag in voCountry:GetControllerNeighbours() do
		if loNeighborTag:GetCountry():GetFaction() == voFaction then
			return true
		end
	end
	
	return false
end

-- voStandardOBJ := Standard object, that has .Country and .Tag
function P.IsValidCountry(voStandardOBJ)
	--Utils.LUA_DEBUGOUT("voStandardOBJ")
	-- Broken down this way for performance
	if not(voStandardOBJ.Country:Exists()) then
		return false
	elseif not(voStandardOBJ.Tag:IsReal()) then
		return false
	elseif not(voStandardOBJ.Tag:IsValid()) then	
		return false
	end

	return true
end

return Support_Functions
