-----------------------------------------------------------
-- LUA Hearts of Iron 3 Alliance File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_Alliance = P

-- #######################
-- Called by the EXE
-- #######################
function DiploScore_Alliance(voAI, voActorTag, voRecipientTag, voObserverTag)
--Utils.LUA_DEBUGOUT("DiploScore_Alliance")
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
			HasFaction = nil,					-- True/False does the country have a faction
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			CapitalProvince = nil,				-- Province Object for the capital
			Continent = nil,					-- Continent Object the capital is on
			IsAtWar = nil},						-- True/False is this country a at war
		Target = {
			Name = tostring(voRecipientTag),	-- Country Name (String)
			Tag = voRecipientTag,				-- Country Tag
			Country = voRecipientTag:GetCountry(), -- Country Object
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile	= nil, 						-- True/False are the in exile
			IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			IdeologyGroupName = nil, 			-- Name of the ideology group (string)
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = nil,					-- (integer) Total amount of ports the country has
			HasFaction = nil,					-- True/False does the country have a faction
			Relation = nil,						-- Relation Object between the two countries
			Strategy = nil,						-- Strategy Object
			Neutrality = nil,					-- Current Neutrality level (integer)
			CapitalProvince = nil,				-- Province Object for the capital
			Continent = nil,					-- Continent Object the capital is on
			IsAtWar = nil,						-- True/False is this country a at war
			IsNeighbour = nil,					-- True/False is Actor/Targer neighbors
			DiplomaticDistance = nil,			-- Diplomatic Distance between the two countries (integer)
			Friendliness = nil,					-- How friendly are the two countries (integer)
			Antagonism = nil,					-- Antagonism level between the two countries (integer)
			Threat = nil						-- Current threat level (integer)
		}
	}
	
	loDiploScoreObj.Actor.HasFaction = loDiploScoreObj.Actor.Country:HasFaction()
	loDiploScoreObj.Target.HasFaction = loDiploScoreObj.Target.Country:HasFaction()
	
	local lbBypass = false -- If we hit a condition to make the score 0 then skip everything

	-- One of us are in a faction so not possible or Target is a Puppet
	if loDiploScoreObj.Target.HasFaction or loDiploScoreObj.Actor.HasFaction or loDiploScoreObj.Target.Country:IsPuppet() then
		lbBypass = true
	end
	
	loDiploScoreObj.Target.Relation = loDiploScoreObj.Target.Country:GetRelation(loDiploScoreObj.Actor.Tag)
	
	-- The target is embargoing the actor so its not possible to form an alliance
	if loDiploScoreObj.Target.Relation:HasEmbargo() then
		lbBypass = true
	end
	
	loDiploScoreObj.Actor.IsAtWar = loDiploScoreObj.Actor.Country:IsAtWar()

	-- Check our Wars skip if we are atwar with someone
	if loDiploScoreObj.Actor.IsAtWar and not(loDiploScoreObj.Target.IsAtWar) then
		-- If they are atwar with someone who we consider a Friend do not form an alliance
		for loTargetTag in loDiploScoreObj.Actor.Country:GetCurrentAtWarWith() do
			if loDiploScoreObj.Target.Country:IsFriend(loTargetTag, false) then
				lbBypass = true
			end
		end
	end

	loDiploScoreObj.Actor.Ideology = loDiploScoreObj.Actor.Country:GetRulingIdeology()
	loDiploScoreObj.Actor.IdeologyGroup = loDiploScoreObj.Actor.Ideology:GetGroup()
	loDiploScoreObj.Actor.CapitalProvince = loDiploScoreObj.Actor.Country:GetActingCapitalLocation()
	loDiploScoreObj.Actor.Continent = loDiploScoreObj.Actor.CapitalProvince:GetContinent()
	
	loDiploScoreObj.Target.Ideology = loDiploScoreObj.Target.Country:GetRulingIdeology()
	loDiploScoreObj.Target.IdeologyGroup = loDiploScoreObj.Target.Ideology:GetGroup()
	loDiploScoreObj.Target.IdeologyGroupName = tostring(loDiploScoreObj.Target.IdeologyGroup:GetKey())
	loDiploScoreObj.Target.CapitalProvince = loDiploScoreObj.Target.Country:GetActingCapitalLocation()
	loDiploScoreObj.Target.Continent = loDiploScoreObj.Target.CapitalProvince:GetContinent()
	loDiploScoreObj.Target.Strategy = loDiploScoreObj.Target.Country:GetStrategy()
	loDiploScoreObj.Target.DiplomaticDistance = loDiploScoreObj.Target.Country:GetDiplomaticDistance(loDiploScoreObj.Actor.Tag):GetTruncated()
	loDiploScoreObj.Target.Friendliness = loDiploScoreObj.Target.Strategy:GetFriendliness(loDiploScoreObj.Actor.Tag)
	loDiploScoreObj.Target.Antagonism = loDiploScoreObj.Target.Strategy:GetAntagonism(loDiploScoreObj.Actor.Tag)
	loDiploScoreObj.Target.Threat = loDiploScoreObj.Target.Relation:GetThreat():Get()
	loDiploScoreObj.Target.IsAtWar = loDiploScoreObj.Target.Country:IsAtWar()
	loDiploScoreObj.Target.IsNeighbour = loDiploScoreObj.Target.Country:IsNonExileNeighbour(loDiploScoreObj.Target.Tag)
	loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
	loDiploScoreObj.Target.IsPuppet = loDiploScoreObj.Target.Country:IsPuppet()
	loDiploScoreObj.Target.PortsTotal = loDiploScoreObj.Target.Country:GetNumOfPorts()
	loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
	loDiploScoreObj.Target.IsNaval = (loDiploScoreObj.Target.PortsTotal > 0 and loDiploScoreObj.Target.IcOBJ.IC >= 20)

	-- Skip Scoring if we determined it should be 0 no matter what
	if not(lbBypass) then
		loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Target.DiplomaticDistance / 10
		loDiploScoreObj.Score = loDiploScoreObj.Score + loDiploScoreObj.Target.Friendliness / 2
		loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Target.Antagonism / 2
		loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Target.Threat / 2

		-- If we are atwar with someone real strong panic
		if loDiploScoreObj.Target.IsAtWar then
			for loTargetTag in loDiploScoreObj.Actor.Country:GetCurrentAtWarWith() do
				local loIcOBJ = Support_Functions.GetICBreakDown(loTargetTag:GetCountry())
		
				if (loDiploScoreObj.Target.IcOBJ.IC * 1.2) < loIcOBJ.IC then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 50
					break
				end
			end
		end

		-- If part of the same ideology group small bonus
		if loDiploScoreObj.Target.IdeologyGroup == loDiploScoreObj.Actor.IdeologyGroup then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 10
		
		-- No Penalty if we are atwar
		elseif not(loDiploScoreObj.Target.IsAtWar) then
			loDiploScoreObj.Score = loDiploScoreObj.Score - 30
		end

		if loDiploScoreObj.Target.IsNeighbour then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 5
		end
	
		if loDiploScoreObj.Actor.Continent == loDiploScoreObj.Target.Continent then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 5
		end
	end
	
	return Support_Country.Call_Score_Function(false, 'DiploScore_Alliance', loDiploScoreObj)
end

-- #######################
-- Support Methods
-- #######################
function P.Alliance(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Alliance")
	-- Do we have enough Diplomats to do an Alliance
	if (voForeignMinisterData.Diplomats >= defines.diplomacy.JOIN_ALLIANCE_INFLUENCE_COST) then
		for loRelation in voForeignMinisterData.Country:GetDiplomacy() do
			local loTarget = {
				Name = nil,
				Tag = loRelation:GetTarget(),
				Country = nil,
				ActorScore = 0,
				TargetScore = 0,
				FinalScore = 0,
				SpamPenalty = 0,
				Relation = loRelation}
			
			if loTarget.Tag ~= voForeignMinisterData.Tag then
				loTarget.Country = loTarget.Tag:GetCountry()
			
				if P.Can_Click_Button(loTarget, voForeignMinisterData) then
					loTarget.ActorScore = DiploScore_Alliance(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil)
					loTarget.TargetScore = DiploScore_Alliance(voForeignMinisterData.ministerAI, loTarget.Tag, voForeignMinisterData.Tag, nil)
					--Utils.LUA_DEBUGOUT("AllianceStart " .. tostring(voForeignMinisterData.Tag).. " tag " .. tostring(voForeignMinisterData.Tag).." target " .. tostring(loTarget.Tag).. " score " .. tostring(loTarget.ActorScore))	
					if not(loTarget.Relation:HasAlliance()) then
						loTarget.TargetScore = DiploScore_Alliance(voForeignMinisterData.ministerAI, loTarget.Tag, voForeignMinisterData.Tag, nil)
						loTarget.SpamPenalty = voForeignMinisterData.ministerAI:GetSpamPenalty(loTarget.Tag)
						loTarget.FinalScore = math.min(loTarget.ActorScore, loTarget.TargetScore) - loTarget.SpamPenalty
						
						if loTarget.FinalScore > 70 then
							
							--Utils.LUA_DEBUGOUT("check>70 " .. tostring(loTarget.FinalScore))	
							if P.Command_Alliance(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, loTarget.FinalScore) then
								break
							end
						end
					else
						if loTarget.TargetScore < -150 then
						
							--Utils.LUA_DEBUGOUT("check<50 " .. tostring(loTarget.ActorScore).." from ".. tostring(voForeignMinisterData.Tag).." to "..  tostring(loTarget.Tag))
							--if P.Command_Alliance(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100) then
								--break
							--end
						end
					end
				end
			end
		end
	end
end
function P.Command_Alliance(voMinister, voFromTag, voTargetTag, vbCancel, viScore)
--Utils.LUA_DEBUGOUT("Command_Alliance")

	local loCommand = CAllianceAction(voFromTag, voTargetTag)
	
	--Utils.LUA_DEBUGOUT("cancelcheck " .. tostring(vbCancel).." from ")
	if vbCancel then
		loCommand:SetValue(false)
	end

	
	--Utils.LUA_DEBUGOUT("selectcheck " .. tostring(loCommand:IsSelectable()))
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

return ForeignMinister_Alliance