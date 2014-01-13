-----------------------------------------------------------
-- LUA Hearts of Iron 3 Lend Lease File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/10/2013
-----------------------------------------------------------

local P = {}
ForeignMinister_LendLease = P

-- #######################
-- Called by the EXE
-- #######################
function DiploScore_OfferLendLease(voAI, voActorTag, voRecipientTag, voObserverTag)
--Utils.LUA_DEBUGOUT("Can_Click_Button")
	-- Always accept Lend Lease if coming from a Human Player
	if CCurrentGameState.IsPlayer(voActorTag) then
		return 100
	else
		return P.GetScore(voAI, voRecipientTag, voActorTag)
	end
end
function DiploScore_RequestLendLease(voAI, voActorTag, voRecipientTag, voObserverTag, voCommand)
--Utils.LUA_DEBUGOUT("DiploScore_RequestLendLease")
	return P.GetScore(voAI, voActorTag, voRecipientTag)
end

-- #######################
-- Support Methods
-- #######################
function P.GetScore(voAI, voActorTag, voRecipientTag)
--Utils.LUA_DEBUGOUT("GetScore")
	local loDiploScoreObj = {
		Score = 0,														-- Current Score (integer)
		ministerAI = voAI,												-- AI Object
		Year = CCurrentGameState.GetCurrentDate():GetYear(),			-- Current in game Year (integer)
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(),	-- Current in game Month (integer)
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(),		-- Current in game Day (integer)
		Actor = {
			Name = tostring(voActorTag),		-- Country Name (String)
			Tag = voActorTag,					-- Country Tag
			Country = voActorTag:GetCountry(),	-- Country Object
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile = nil,						-- Are they in Exile
			IsMajor = nil,						-- True/False is this country a major power
			IsAtWar = nil,						-- True/False is this country a at war
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil},				-- Group the countries Ideology belongs to
		Target = {
			Name = tostring(voRecipientTag),	-- Country Name (String)
			Tag = voRecipientTag,				-- Country Tag
			Country = voRecipientTag:GetCountry(), -- Country Object
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile	= nil, 						-- True/False are the in exile
			IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = nil,					-- (integer) Total amount of ports the country has
			IsMajor = nil,						-- True/False is this country a major power
			IsAtWar = nil,						-- True/False is this country a at war
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			Relation = nil,						-- Relation Object between the Actor/Target
			Friendliness = nil,					-- How friendly are the two countries (integer)
			Antagonism = nil,					-- Antagonism level between the two countries (integer)
			Threat = nil,						-- Current threat level (integer)
			AlignDistance = nil,				-- Alignment distance between this country and the Faction Leader (integer)
			Strategy = nil,						-- Strategy Object
			Neutrality = nil,					-- Current Neutrality level (integer)
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil}				-- Group the countries Ideology belongs to
	}
	
	loDiploScoreObj.Actor.IsAtWar = loDiploScoreObj.Actor.Country:IsAtWar()
	loDiploScoreObj.Actor.IsExile = loDiploScoreObj.Actor.Country:IsGovernmentInExile()

	loDiploScoreObj.Target.Relation = loDiploScoreObj.Target.Country:GetRelation(loDiploScoreObj.Actor.Tag)
	loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
	
	-- They are embargoing us so no point, or they are not at war, or one of us is in Exile
	if (loDiploScoreObj.Target.Relation:HasEmbargo())
	or (loDiploScoreObj.Target.Relation:HasWar())
	or not(loDiploScoreObj.Actor.IsAtWar)
	or (loDiploScoreObj.Actor.IsExile)
	or (loDiploScoreObj.Target.IsExile) then
		return 0
	end
	
	loDiploScoreObj.Actor.Ideology = loDiploScoreObj.Actor.Country:GetRulingIdeology()
	loDiploScoreObj.Actor.IdeologyGroup = loDiploScoreObj.Actor.Ideology:GetGroup()
	loDiploScoreObj.Actor.HasFaction = loDiploScoreObj.Actor.Country:HasFaction()
	loDiploScoreObj.Actor.Faction = loDiploScoreObj.Actor.Country:GetFaction()
	loDiploScoreObj.Actor.FactionName = tostring(loDiploScoreObj.Actor.Faction:GetTag())
	loDiploScoreObj.Actor.IsMajor = loDiploScoreObj.Actor.Country:IsMajor()

	loDiploScoreObj.Target.IsAtWar = loDiploScoreObj.Target.Country:IsAtWar()
	loDiploScoreObj.Target.Ideology = loDiploScoreObj.Target.Country:GetRulingIdeology()
	loDiploScoreObj.Target.IdeologyGroup = loDiploScoreObj.Target.Ideology:GetGroup()
	loDiploScoreObj.Target.HasFaction = loDiploScoreObj.Target.Country:HasFaction()
	loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
	loDiploScoreObj.Target.FactionName = tostring(loDiploScoreObj.Target.Faction:GetTag())
	loDiploScoreObj.Target.IsMajor = loDiploScoreObj.Target.Country:IsMajor()

	if loDiploScoreObj.Target.HasFaction and loDiploScoreObj.Actor.HasFaction then
		if loDiploScoreObj.Actor.Faction ~= loDiploScoreObj.Target.Faction then
			-- The factions are not the same and the target is comintern which does not do Lend Lease with other factions
			if loDiploScoreObj.Target.FactionName == "comintern" then
				return 0
			else
				-- We will only help major powers in another faction
				if loDiploScoreObj.Actor.IsMajor and loDiploScoreObj.Target.IsMajor then
					-- Go through their wars to see if we have a common enemy
					for loTargetTag in loDiploScoreObj.Target.Country:GetCurrentAtWarWith() do
						local loRelation = loDiploScoreObj.Actor.Country:GetRelation(loTargetTag)
						
						-- We are atwar with the same country
						if loRelation:HasWar() then
							local loTargetCountry = loTargetTag:GetCountry()
							if loTargetCountry:IsMajor() then
								-- Give them a base of 200 to start with (to country will have many negatives)
								loDiploScoreObj.Score = 200 
							end
						end
					end
				end
			end
		else
			-- Give them a base of 50 to start with
			loDiploScoreObj.Score = 50 
		end
	else
		if loDiploScoreObj.Target.HasFaction then
			-- Comintern does not provide Lend Lease to anyone outside their faction
			if loDiploScoreObj.Target.FactionName == "comintern" then
				if loDiploScoreObj.Target.IsMajor then
					-- Although the request is not in the comintern their Ideology is so give them Lend Lease
					if loDiploScoreObj.Actor.IdeologyGroup == loDiploScoreObj.Target.IdeologyGroup then
						loDiploScoreObj.Score = 100 
					end
				else -- Comintern Minors do not give Lend Lease
					return 0
				end
			end
		end
	end
	loDiploScoreObj.Actor.IsPuppet = loDiploScoreObj.Actor.Country:IsPuppet()
	loDiploScoreObj.Actor.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Actor.Country)
	
	loDiploScoreObj.Target.IsPuppet = loDiploScoreObj.Target.Country:IsPuppet()
	loDiploScoreObj.Target.PortsTotal = loDiploScoreObj.Target.Country:GetNumOfPorts()
	loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
	loDiploScoreObj.Target.IsNaval = (loDiploScoreObj.Target.PortsTotal > 0 and loDiploScoreObj.Target.IcOBJ.IC >= 20)

	loDiploScoreObj.Target.Strategy = loDiploScoreObj.Target.Country:GetStrategy()
	loDiploScoreObj.Target.Friendliness = loDiploScoreObj.Target.Strategy:GetFriendliness(loDiploScoreObj.Actor.Tag)
	loDiploScoreObj.Target.Antagonism = loDiploScoreObj.Target.Strategy:GetAntagonism(loDiploScoreObj.Actor.Tag)
	loDiploScoreObj.Target.Threat = loDiploScoreObj.Target.Relation:GetThreat():Get()

	loDiploScoreObj.AlignDistance = loDiploScoreObj.ministerAI:GetCountryAlignmentDistance(loDiploScoreObj.Actor.Country, loDiploScoreObj.Target.Country):Get()

	-- Their IC is lower than ours or very close to ours so no point in Lend Leasing
	--   Or they have less than 50 IC so don't even bother them for lend lease
	-- Puppets do not get lend-lease unless country specific file overides it
	if (loDiploScoreObj.Actor.IsPuppet)
	or (loDiploScoreObj.Target.IcOBJ.IC < 50)
	or ((loDiploScoreObj.Actor.IcOBJ.IC * 1.2) > loDiploScoreObj.Target.IcOBJ.IC) then
		loDiploScoreObj.Score = 0 
	else
		loDiploScoreObj.Score = loDiploScoreObj.Score + (loDiploScoreObj.Target.Friendliness * 0.4)
		loDiploScoreObj.Score = loDiploScoreObj.Score - (loDiploScoreObj.Target.Antagonism * 0.4)
		loDiploScoreObj.Score = loDiploScoreObj.Score - (loDiploScoreObj.Target.Threat * 0.5)

		if loDiploScoreObj.Actor.IdeologyGroup == loDiploScoreObj.Target.IdeologyGroup then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 10
		end
		
		if loDiploScoreObj.AlignDistance > 0 then
			loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.AlignDistance
		end
	end
	
	return Support_Country.Call_Score_Function(false, 'DiploScore_RequestLendLease', loDiploScoreObj)
end
function P.LendLease(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("LendLease")
	-- Exile Countries can not send lend lease
	if not(voForeignMinisterData.IsExile) then
		-- Do we want to offer anyone lendlease
		if (voForeignMinisterData.Neutrality <= defines.diplomacy.LEND_LEASE_NEUTRALITY_LIMIT) then
			-- Puppets can only ask for Lend Lease from their master
			if voForeignMinisterData.IsPuppet then
				local loTarget = {
					Tag = voForeignMinisterData.Country:GetOverlord(),
					Country = nil,
					Score = 0,
					SpamPenalty = 0,
					Relation = loRelation
				}
			
				loTarget.Country = loTarget.Tag:GetCountry()
				loTarget.Relation = loTarget.Country:GetRelation(voForeignMinisterData.Tag)
			
				if P.Can_Click_Button(loTarget, voForeignMinisterData) then
					if not(voForeignMinisterData.Country:HasActiveLendLeaseFrom(loTarget.Tag)) then
						loTarget.Score = P.GetScore(voForeignMinisterData.ministerAI, loTarget.Tag, voForeignMinisterData.Tag, nil)

						if not(voForeignMinisterData.Country:IsGivingLendLeaseToTarget(loTarget.Tag)) then
							loTarget.SpamPenalty = voForeignMinisterData.ministerAI:GetSpamPenalty(loTarget.Tag)
							loTarget.Score = loTarget.Score - loTarget.SpamPenalty
						
							-- Do we want to give them lend lease
							if loTarget.Score > 70 then
								P.Command_OfferLendLease(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, loTarget.Score)
							else
								-- We did not want to give them lend lease but maybe they will give us Lend Lease
								loTarget.Score = P.GetScore(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil, nil)
								loTarget.Score = loTarget.Score - loTarget.SpamPenalty
							
								if loTarget.Score > 70 then
									P.Command_RequestLendLease(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, loTarget.Score)
								end
							end	

						-- We are giving them lend lease so do we want to cancel it
						elseif loTarget.Score < 50 then
							P.Command_OfferLendLease(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100)
						end
					else 
						-- Never cancel Lend Lease from a Human Player let them decide when to do it
						if not(CCurrentGameState.IsPlayer(loTarget.Tag)) then
							-- They are giving us Lend Lease see if we want to cancel that
							loTarget.Score = DiploScore_RequestLendLease(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil, nil)
						
							if loTarget.Score < 50 then
								P.Command_RequestLendLease(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100)
							end
						end
					end				
				end
			
			-- Not a puppet so go through the Country Loop
			else
				for loRelation in voForeignMinisterData.Country:GetDiplomacy() do
					local loTarget = {
						Tag = loRelation:GetTarget(),
						Country = nil,
						Score = 0,
						SpamPenalty = 0,
						Relation = loRelation
					}
					
					loTarget.Country = loTarget.Tag:GetCountry()
					loTarget.Relation = loTarget.Country:GetRelation(voForeignMinisterData.Tag)
				
					if P.Can_Click_Button(loTarget, voForeignMinisterData) then
						if not(voForeignMinisterData.Country:HasActiveLendLeaseFrom(loTarget.Tag)) then
							loTarget.Score = P.GetScore(voForeignMinisterData.ministerAI, loTarget.Tag, voForeignMinisterData.Tag, nil)

							if not(voForeignMinisterData.Country:IsGivingLendLeaseToTarget(loTarget.Tag)) then
								loTarget.SpamPenalty = voForeignMinisterData.ministerAI:GetSpamPenalty(loTarget.Tag)
								loTarget.Score = loTarget.Score - loTarget.SpamPenalty
							
								-- Do we want to give them lend lease
								if loTarget.Score > 70 then
									if P.Command_OfferLendLease(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, loTarget.Score) then
										break
									end
								else
									-- We did not want to give them lend lease but maybe they will give us Lend Lease
									loTarget.Score = P.GetScore(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil, nil)
									loTarget.Score = loTarget.Score - loTarget.SpamPenalty
								
									if loTarget.Score > 70 then
										if P.Command_RequestLendLease(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, loTarget.Score) then
											break
										end
									end
								end	

							-- We are giving them lend lease so do we want to cancel it
							elseif loTarget.Score < 50 then
								if P.Command_OfferLendLease(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100) then
									break
								end
							end
						else 
							-- Never cancel Lend Lease from a Human Player let them decide when to do it
							if not(CCurrentGameState.IsPlayer(loTarget.Tag)) then
								-- They are giving us Lend Lease see if we want to cancel that
								loTarget.Score = DiploScore_RequestLendLease(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil, nil)
							
								if loTarget.Score < 50 then
									if P.Command_RequestLendLease(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100) then
										break
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
function P.Command_RequestLendLease(voMinister, voFromTag, voTargetTag, vbCancel, viScore)
--Utils.LUA_DEBUGOUT("Command_RequestLendLease")
	local loCommand = CRequestLendLeaseAction(voFromTag, voTargetTag)
	
	if vbCancel then
		loCommand:SetValue(false)
	end

	if loCommand:IsSelectable() then
		voMinister:Propose(loCommand, viScore )
		return true
	end
	
	return false
end
function P.Command_OfferLendLease(voMinister, voFromTag, voTargetTag, vbCancel, viScore)
--Utils.LUA_DEBUGOUT("Command_OfferLendLease")
	local loCommand = COfferLendLeaseAction(voFromTag, voTargetTag)
	
	if vbCancel then
		loCommand:SetValue(false)
	end

	if loCommand:IsSelectable() then
		voMinister:Propose(loCommand, viScore )
		return true
	end
	
	return false
end
function P.Can_Click_Button(voTarget, voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Can_Click_Button")
	if voTarget.Country:Exists() then
		if voTarget.Tag:IsReal() then
			if voTarget.Tag:IsValid() then
				if not(voTarget.Country:IsPuppet()) then
					if not(voTarget.Relation:HasWar()) then
						if not(voForeignMinisterData.Country:HasDiplomatEnroute(voTarget.Tag)) then
							return true
						end
					end
				end
			end
		end
	end
	
	return false
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return ForeignMinister_LendLease