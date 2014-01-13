-----------------------------------------------------------
-- LUA Hearts of Iron 3 Alignment File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 3/12/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_Alignment = P

-- #######################
-- Support Methods
-- #######################
function P.Alignment(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Alignment")
	if not(voForeignMinisterData.HasFaction) then
		local lbProcess = true
		local loFunRef = Support_Country.Get_Function(voForeignMinisterData, "ForeignMinister_Alignment")
		
		if loFunRef then
			lbProcess = loFunRef(voForeignMinisterData)
		end
	
		if lbProcess then
			local loLeaderTag = CCurrentGameState.GetFaction(voForeignMinisterData.IdeologyMaping[voForeignMinisterData.IdeologyGroupName]):GetFactionLeader()
			local loLeaderCountry = loLeaderTag:GetCountry()
			local liAlignment = voForeignMinisterData.ministerAI:GetCountryAlignmentDistance(voForeignMinisterData.Country, loLeaderCountry):Get()
			
			local loCommand = CInfluenceAllianceLeader(voForeignMinisterData.Tag, loLeaderTag)
			
			-- We are to far from our normal alignment so drift back
			if loCommand:IsSelectable() and liAlignment > 250 then
				lbCmdExecute = true
				voForeignMinisterData.ministerAI:PostAction(loCommand)
			elseif liAlignment < 175 then
				-- To Cancel the Influence
				loCommand:SetValue(false)
				if loCommand:IsSelectable() then
					lbCmdExecute = true
					voForeignMinisterData.ministerAI:PostAction(loCommand)
				end
			end

			-- Since nothing was done lets see if we need to push away due to war
			if not(lbCmdExecute) and voForeignMinisterData.IsAtWar then -- lbCmdExecute gets re-used
				local loFactionsAtWar = { }
				-- Generate lists of factions we are at war with 
				--    (can't use faction leaders as it is possible to be at war with someone
				--	  in a faction where the entire faction is not at war with you)
				for loTargetTag in voForeignMinisterData.Country:GetCurrentAtWarWith() do
					local loTargetCountry = loTargetTag:GetCountry()

					if loTargetCountry:HasFaction() then
						local loFaction = loTargetCountry:GetFaction()
						local lsFaction = tostring(loFaction:GetTag())
						
						if not(loFactionsAtWar[lsFaction]) then
							loFactionsAtWar[lsFaction] = {}
							loFactionsAtWar[lsFaction].Faction = loFaction
							loFactionsAtWar[lsFaction].Tag = loFaction:GetFactionLeader()
							loFactionsAtWar[lsFaction].Country = loFactionsAtWar[lsFaction].Tag:GetCountry()
							loFactionsAtWar[lsFaction].Aligment = voForeignMinisterData.ministerAI:GetCountryAlignmentDistance(voForeignMinisterData.Country, loFactionsAtWar[lsFaction].Country):Get()

							-- We are drifing to close to a faction we are at war with
							if loFactionsAtWar[lsFaction].Aligment < 200 then
								lbCmdExecute = true
							end
						end
					end
				end

				-- We are at war with atleast one person in a faction
				if lbCmdExecute then
					local loDriftCountry = {
						Tag = nil,
						Alignment = nil
					}
					for k, v in pairs(voForeignMinisterData.IdeologyMaping) do
						-- We are not at war with this faction so check aligment
						if not(loFactionsAtWar[voForeignMinisterData.IdeologyMaping[k]]) then
							local loLeaderTag = CCurrentGameState.GetFaction(voForeignMinisterData.IdeologyMaping[k]):GetFactionLeader()
							local loLeaderCountry = loLeaderTag:GetCountry()
							local liAlignment = voForeignMinisterData.ministerAI:GetCountryAlignmentDistance(voForeignMinisterData.Country, loLeaderCountry):Get()
							
							if not(loDriftCountry.Tag) then
								loDriftCountry.Tag = loLeaderTag
								loDriftCountry.Alignment = liAlignment

							-- Drift to the one farthest from us
							elseif liAlignment > loDriftCountry.Alignment then
								loDriftCountry.Tag = loLeaderTag
								loDriftCountry.Alignment = liAlignment
							end
						end
					end

					-- It is possible to be at war with all factions so do nothing
					if not(loDriftCountry.Tag) then
						local loCommand = CInfluenceAllianceLeader(voForeignMinisterData.Tag, loDriftCountry.Tag)
			
						-- We are to far from our normal alignment so drift back
						if loCommand:IsSelectable() then
							voForeignMinisterData.ministerAI:PostAction(loCommand)
						end
					end
				end
			end
		end
	end
end
-- Used to try and keep a country in the middle
function P.Alignment_Neutral(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Alignment_Neutral")
	local loFactions = {}
	local lsFarthestFaction = nil
	local liFarthestFaction = nil
	local lbInfluence = false

	-- Look at where we are currently aligned to
	for k, v in pairs(voForeignMinisterData.IdeologyMaping) do
		local loLeaderTag = CCurrentGameState.GetFaction(voForeignMinisterData.IdeologyMaping[k]):GetFactionLeader()
		local loLeaderCountry = loLeaderTag:GetCountry()
		local liAlignment = voForeignMinisterData.ministerAI:GetCountryAlignmentDistance(voForeignMinisterData.Country, loLeaderCountry):Get()
		local loCommand = CInfluenceAllianceLeader(voForeignMinisterData.Tag, loLeaderTag)

		loFactions[k] = {
			Tag = loLeaderTag,
			Country = loLeaderCountry,
			Aligning = not(loCommand:IsSelectable()),
			Command = loCommand,
			Alignment = liAlignment}
			
		if not(lsFarthestFaction) then
			lsFarthestFaction = k
			liFarthestFaction = liAlignment
		elseif liAlignment > liFarthestFaction then
			lsFarthestFaction = k
			liFarthestFaction = liAlignment
		end
		
		if loFactions[k].Alignment < 180 then
			lbInfluence = true
		end
	end
	
	-- Now try and get us back into the middle
	for k, v in pairs(voForeignMinisterData.IdeologyMaping) do
		if k == lsFarthestFaction and lbInfluence then
			if loFactions[k].Command:IsSelectable() then
				voForeignMinisterData.ministerAI:PostAction(loFactions[k].Command)
			end
		else
			if not(loFactions[k].Command:IsSelectable()) then
				loFactions[k].Command:SetValue(false)
				if loFactions[k].Command:IsSelectable() then
					voForeignMinisterData.ministerAI:PostAction(loFactions[k].Command)
				end
			end
		end
	end
	
	return false
end

-- Used to try and push a country into a specific corner
-- (vsFaction)		= Faction you want them be pushed toward
-- (vbIdeology) 	= is an Overide for the Ideology check
-- (vbIsFactionWar) = is an Overide for the faction we want to help being at war
function P.Alignment_Push(vsFaction, voForeignMinisterData, vbIdeology, vbIsFactionWar)
--Utils.LUA_DEBUGOUT("Alignment_Push")
	if not(voForeignMinisterData.HasFaction) then
		if voForeignMinisterData.IdeologyMaping[voForeignMinisterData.IdeologyGroupName] == vsFaction or vbIdeology then
			local loFactionLeaderTag = CCurrentGameState.GetFaction(vsFaction):GetFactionLeader()
			local loFactionCountry = loFactionLeaderTag:GetCountry()
			
			if loFactionCountry:IsAtWar() or vbIsFactionWar then
				local loCommand = CInfluenceAllianceLeader(voForeignMinisterData.Tag, loFactionLeaderTag)
				
				if loCommand:IsSelectable() then
					voForeignMinisterData.ministerAI:PostAction(loCommand)
				end
				
				-- Condition Met so turn off other pushes
				for loFaction in CCurrentGameState.GetFactions() do
					if tostring(loFaction:GetTag()) ~= vsFaction then
						loCommand = CInfluenceAllianceLeader(voForeignMinisterData.Tag, loFaction:GetFactionLeader())
						if not(loCommand:IsSelectable()) then
							loCommand:SetValue(false)
							if loCommand:IsSelectable() then
								voForeignMinisterData.ministerAI:PostAction(loCommand)
							end
						end
					end
					
				end
				
				return false
			end
		end
	end
	
	return true
end


-- ###############################################
-- END OF Support methods
-- ###############################################

return ForeignMinister_Alignment