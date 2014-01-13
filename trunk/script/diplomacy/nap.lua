-----------------------------------------------------------
-- LUA Hearts of Iron 3 Non Aggression Pact File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/10/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_NAP = P

-- #######################
-- Called by the EXE
-- #######################
function DiploScore_NonAgression(voAI, voActorTag, voRecipientTag, voObserverTag)
--Utils.LUA_DEBUGOUT("DiploScore_NonAgression")
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
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			Relation = nil},					-- Relation Object between the Target/Actor
		Target = {
			Name = tostring(voRecipientTag),	-- Country Name (String)
			Tag = voRecipientTag,				-- Country Tag
			Country = voRecipientTag:GetCountry(), -- Country Object
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile	= nil, 						-- True/False are the in exile
			IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = nil,					-- (integer) Total amount of ports the country has
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			Strategy = nil,						-- Strategy Object
			Neutrality = nil,					-- Current Neutrality level (integer)
			Friendliness = nil,					-- How friendly are the two countries (integer)
			Antagonism = nil,					-- Antagonism level between the two countries (integer)
			Threat = nil,						-- Current threat level (integer)
			IsGuaranteed = nil,					-- True/False is Actor guaranteing Target
			HasFriendlyAgreement = nil,			-- True/False does Actor/Target have a freindly agreement
			AllowDebts = nil,					-- True/False are they allowing debts
			Relation = nil						-- Relation Object between the Actor/Target
		}
	}

	loDiploScoreObj.Actor.HasFaction = loDiploScoreObj.Actor.Country:HasFaction()
	loDiploScoreObj.Actor.Faction = loDiploScoreObj.Actor.Country:GetFaction()
	loDiploScoreObj.Actor.FactionName = tostring(loDiploScoreObj.Actor.Faction:GetTag())
	loDiploScoreObj.Actor.Relation = loDiploScoreObj.Actor.Country:GetRelation(loDiploScoreObj.Target.Tag)
	
	loDiploScoreObj.Target.HasFaction = loDiploScoreObj.Target.Country:HasFaction()
	loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
	loDiploScoreObj.Target.FactionName = tostring(loDiploScoreObj.Target.Faction:GetTag())

	if (loDiploScoreObj.Actor.HasFaction and loDiploScoreObj.Actor.Faction == loDiploScoreObj.Target.Faction)
	or (loDiploScoreObj.Actor.Relation:HasEmbargo()) -- They are Embargoing us so no NAP
	or (loDiploScoreObj.Target.Country:IsPuppet()) -- We are a puppet so no NAP
	or (loDiploScoreObj.Actor.Relation:HasWar()) -- We are atwar so no NAP
	or (loDiploScoreObj.Actor.Relation:HasAlliance()) then -- We have an Alliance no point in a NAP
		return 0 -- Exit there is no point for a NAP
	end
	
	loDiploScoreObj.Actor.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Actor.Country)
	loDiploScoreObj.Actor.Ideology = loDiploScoreObj.Actor.Country:GetRulingIdeology()
	loDiploScoreObj.Actor.IdeologyGroup = loDiploScoreObj.Actor.Ideology:GetGroup()
	
	loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
	loDiploScoreObj.Target.IsPuppet = loDiploScoreObj.Target.Country:IsPuppet()
	loDiploScoreObj.Target.PortsTotal = loDiploScoreObj.Target.Country:GetNumOfPorts()
	loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
	loDiploScoreObj.Target.IsNaval = (loDiploScoreObj.Target.PortsTotal > 0 and loDiploScoreObj.Target.IcOBJ.IC >= 20)
	loDiploScoreObj.Target.Ideology = loDiploScoreObj.Target.Country:GetRulingIdeology()
	loDiploScoreObj.Target.IdeologyGroup = loDiploScoreObj.Target.Ideology:GetGroup()
	loDiploScoreObj.Target.Strategy = loDiploScoreObj.Target.Country:GetStrategy()
	loDiploScoreObj.Target.Neutrality = loDiploScoreObj.Target.Country:GetEffectiveNeutrality():Get()
	loDiploScoreObj.Target.Relation = loDiploScoreObj.Target.Country:GetRelation(loDiploScoreObj.Actor.Tag)
	loDiploScoreObj.Target.Friendliness = loDiploScoreObj.Target.Strategy:GetFriendliness(loDiploScoreObj.Actor.Tag)
	loDiploScoreObj.Target.Antagonism = loDiploScoreObj.Target.Strategy:GetAntagonism(loDiploScoreObj.Actor.Tag)
	loDiploScoreObj.Target.Threat = loDiploScoreObj.Target.Relation:GetThreat():Get()
	loDiploScoreObj.Target.IsGuaranteed = loDiploScoreObj.Target.Relation:IsGuaranteed()
	loDiploScoreObj.Target.HasFriendlyAgreement = loDiploScoreObj.Target.Relation:HasFriendlyAgreement()
	loDiploScoreObj.Target.AllowDebts = loDiploScoreObj.Target.Relation:AllowDebts()

	loDiploScoreObj.Score = loDiploScoreObj.Score + (loDiploScoreObj.Target.Friendliness * 0.4)
	loDiploScoreObj.Score = loDiploScoreObj.Score - (loDiploScoreObj.Target.Antagonism * 0.4)
	loDiploScoreObj.Score = loDiploScoreObj.Score - (loDiploScoreObj.Target.Threat * 0.5)
	
	-- The stronger they are the more likely they are not interested
	if loDiploScoreObj.Actor.IcOBJ.IC > (loDiploScoreObj.Target.IcOBJ.IC * 5) then
		loDiploScoreObj.Score = loDiploScoreObj.Score - 30
	elseif loDiploScoreObj.Actor.IcOBJ.IC > (loDiploScoreObj.Target.IcOBJ.IC * 4) then
		loDiploScoreObj.Score = loDiploScoreObj.Score - 20
	elseif loDiploScoreObj.Actor.IcOBJ.IC > (loDiploScoreObj.Target.IcOBJ.IC * 3) then
		loDiploScoreObj.Score = loDiploScoreObj.Score - 10
	elseif loDiploScoreObj.Actor.IcOBJ.IC > (loDiploScoreObj.Target.IcOBJ.IC * 2) then
		loDiploScoreObj.Score = loDiploScoreObj.Score - 5
	end		
	
	-- The more neutral they are the more likely they want Non-Aggression Pacts
	if loDiploScoreObj.Target.Neutrality > 90 then
		loDiploScoreObj.Score = loDiploScoreObj.Score + 15
	elseif loDiploScoreObj.Target.Neutrality > 80 then
		loDiploScoreObj.Score = loDiploScoreObj.Score + 10
	elseif loDiploScoreObj.Target.Neutrality > 70 then
		loDiploScoreObj.Score = loDiploScoreObj.Score + 5
	end
	
	-- If we have some sort of friendly agreement already
	if loDiploScoreObj.Target.IsGuaranteed then
		loDiploScoreObj.Score = loDiploScoreObj.Score + 5
	end
	
	if loDiploScoreObj.Target.HasFriendlyAgreement then
		loDiploScoreObj.Score = loDiploScoreObj.Score + 5
	end
	if loDiploScoreObj.Target.AllowDebts then
		loDiploScoreObj.Score = loDiploScoreObj.Score + 5
	end

	-- If same ideologies small bonus
	if loDiploScoreObj.Actor.IdeologyGroup == loDiploScoreObj.Target.IdeologyGroup then
		loDiploScoreObj.Score = loDiploScoreObj.Score + 5
	end
	
	-- We do not have a border so divide the score in half
	if loDiploScoreObj.Target.Country:IsNonExileNeighbour(loDiploScoreObj.Actor.Tag) then
		loDiploScoreObj.Score = loDiploScoreObj.Score + 5
	else
		loDiploScoreObj.Score = loDiploScoreObj.Score * 0.5 -- Cut the score in half they are not a neighbor
	end

	return Support_Country.Call_Score_Function(false, 'DiploScore_NonAgression', loDiploScoreObj)
end

-- #######################
-- Support Methods
-- #######################
function P.NAP(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("NAP")
	-- Do we have enough Diplomats to do a NAP
	if (voForeignMinisterData.Diplomats >= defines.diplomacy.NAP_INFLUENCE_COST) then
		for loRelation in voForeignMinisterData.Country:GetDiplomacy() do
			local loTarget = {
				Tag = loRelation:GetTarget(),
				Country = nil,
				ActorScore = 0,
				TargetScore = 0,
				FinalScore = 0,
				SpamPenalty = 0,
				Relation = loRelation}
				
			loTarget.Country = loTarget.Tag:GetCountry()
			
			if P.Can_Click_Button(loTarget, voForeignMinisterData) then
				loTarget.ActorScore = DiploScore_NonAgression(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil)
				
				if not(loTarget.Relation:HasNap()) then
					loTarget.TargetScore = DiploScore_NonAgression(voForeignMinisterData.ministerAI, loTarget.Tag, voForeignMinisterData.Tag, nil)
					loTarget.SpamPenalty = voForeignMinisterData.ministerAI:GetSpamPenalty(loTarget.Tag)
					loTarget.FinalScore = math.min(loTarget.ActorScore, loTarget.TargetScore) - loTarget.SpamPenalty
					
					if loTarget.FinalScore > 70 then
						if P.Command_NAP(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, loTarget.FinalScore) then
							break
						end
					end
				else
					if loTarget.ActorScore < 50 then
						if P.Command_NAP(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100) then
							break
						end
					end
				end
			end
		end
	end
end
function P.Command_NAP(voMinister, voFromTag, voTargetTag, vbCancel, viScore)
--Utils.LUA_DEBUGOUT("Command_NAP")
	local loCommand = CNapAction(voFromTag, voTargetTag)
	
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
						if not(voTarget.Relation:HasAlliance()) then
							if not(voForeignMinisterData.Country:HasDiplomatEnroute(voTarget.Tag)) then
								return true
							end
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

return ForeignMinister_NAP