-----------------------------------------------------------
-- LUA Hearts of Iron 3 Embargo File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/10/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_Embargo = P

-- #######################
-- Support Methods
-- #######################

function P.GetScore(voTarget, voForeignMinisterData)
--Utils.LUA_DEBUGOUT("GetScore")

	local loDiploScoreObj = {
		Score = 0,												-- Current Score (integer)
		ministerAI = voForeignMinisterData.ministerAI,			-- AI Object
		Year = voForeignMinisterData.Year,						-- Current in game Year (integer)
		Month = voForeignMinisterData.Month,					-- Current in game Month (integer)
		Day = voForeignMinisterData.Day,						-- Current in game Day (integer)
		Actor = {
			Name = tostring(voForeignMinisterData.Tag),	-- Country Name (String)
			Tag = voForeignMinisterData.Tag,			-- Country Tag
			Country = voForeignMinisterData.Country,	-- Country Object
			IsMajor = voForeignMinisterData.IsMajor,			-- True/False is this country a major power
			IsAtWar = voForeignMinisterData.IsAtWar,			-- True/False is this country a at war
			Faction = voForeignMinisterData.Faction,			-- Faction Object the country belongs to
			FactionName = voForeignMinisterData.FactionName,	-- Name of the Faction the country belongs to (string)
			FactionLeaderTag = voForeignMinisterData.Faction:GetFactionLeader(), -- Country Tag of the Faction leader
			HasFaction = voForeignMinisterData.HasFaction,		-- True/False does the country have a faction
			Strategy = voForeignMinisterData.Strategy,			-- Strategy Object
			Desperation = voForeignMinisterData.Desperation,	-- Current Desperation level (integer)
			Neutrality = voForeignMinisterData.Neutrality, 		-- Current Neutrality level (integer)
			Diplomats = voForeignMinisterData.Diplomats}, 		-- How many diplomats they have (integer)
		Target = {
			Name = voTarget.Name,				-- Country Name (String)
			Tag = voTarget.Tag,					-- Country Tag
			Country = voTarget.Country,			-- Country Object
			HasFaction = voTarget.HasFaction,	-- True/False does the country have a faction
			Faction = voTarget.Faction,			-- Faction Object the country belongs to
			FactionName = voTarget.FactionName,	-- Name of the Faction the country belongs to (string)
			IsEmbargoed = voTarget.Embargoed,	-- True/False Is Actor embargoing Target
			Relation = voTarget.Relation,		-- Relation Object between Actor/Target
			Strategy = voTarget.Country:GetStrategy(), -- Strategy Object
			Threat = voTarget.Relation:GetThreat():Get(), -- Current threat level (integer)
			Friendliness = nil}					-- How friendly are the two countries (integer)
	}	

	loDiploScoreObj.Target.Threat = loDiploScoreObj.Target.Relation:GetThreat():Get()
	loDiploScoreObj.Target.Friendliness = loDiploScoreObj.Target.Strategy:GetFriendliness(loDiploScoreObj.Actor.Tag)
	
	if loDiploScoreObj.Actor.IsAtWar then
		if (loDiploScoreObj.Target.Threat - (loDiploScoreObj.Target.Friendliness * .25)) > 50 then
			loDiploScoreObj.Score = 75
		else
			for loTargetTag in loDiploScoreObj.Actor.Country:GetCurrentAtWarWith() do
				local loTargetCountry = loTargetTag:GetCountry()
				
				if loDiploScoreObj.Target.HasFaction then
					-- They are in the same faction as our enemy so embargo them
					if loTargetCountry:GetFaction() == loDiploScoreObj.Target.Faction then
						loDiploScoreObj.Score = 100 
						break
					end
				end
				
				-- They are allied with our enemy so embargo them
				if loTargetCountry:GetRelation(loDiploScoreObj.Target.Tag):HasAlliance() then
					loDiploScoreObj.Score = 100 
					break
				end
				
				-- They are a friend of one of our enemies so embargo them
				if loDiploScoreObj.Target.Country:IsFriend(loTargetTag, true) then
					loDiploScoreObj.Score = 80 
					break
				end
			end
		end
	end
	
	-- Check to make sure they are not aligning to our faction if so do not embargo
	if loDiploScoreObj.Score > 0 then
		if loDiploScoreObj.Actor.HasFaction and not(loDiploScoreObj.Target.HasFaction) then
			local lbIsAligning = ForeignMinister_Influence.IsAligning(loDiploScoreObj.Target.Tag, loDiploScoreObj.Actor.FactionLeaderTag)

			-- They are aligning to us so do not embargo
			if lbIsAligning then
				loDiploScoreObj.Score = 0
			end
		end
	end
	
	return Support_Country.Call_Score_Function(true, 'DiploScore_Embargo', loDiploScoreObj)
end

function P.Embargo(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Embargo")
	-- Make sure we have the diplomats and our Neutrality is low enough
	if (voForeignMinisterData.Diplomats >= defines.diplomacy.EMBARGO_INFLUENCE_COST)
	and (voForeignMinisterData.Neutrality <= defines.diplomacy.EMBARGO_NETRALITY) then
		for loRelation in voForeignMinisterData.Country:GetDiplomacy() do
			local loTarget = {
				Name = nil,
				Tag = loRelation:GetTarget(),
				Country = nil,
				HasFaction = nil,
				Embargoed = nil,
				Score = 0,
				Faction = nil,
				FactionName = nil,
				Relation = loRelation}
				
			loTarget.Country = loTarget.Tag:GetCountry()
			
			if P.Can_Click_Button(loTarget, voForeignMinisterData) then
				loTarget.Name = tostring(loTarget.Tag)
				loTarget.Embargoed = loRelation:HasEmbargo()
				loTarget.HasFaction = loTarget.Country:HasFaction()
				loTarget.Faction = loTarget.Country:GetFaction()
				loTarget.FactionName = tostring(loTarget.Faction:GetTag())
				
				if loTarget.Embargoed then
					if (loTarget.HasFaction and loTarget.Faction == voForeignMinisterData.Faction)
					or (loRelation:HasAlliance())
					or (loRelation:HasMilitaryAccess())
					or (loRelation:HasNap()) then
						if P.Command_Embargo(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100) then
							break -- Can only execute one Embargo command at a time
						end
					else
						loTarget.Score = P.GetScore(loTarget, voForeignMinisterData)
						
						if loTarget.Score < 40 then
							if P.Command_Embargo(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100) then
								break -- Can only execute one Embargo command at a time
							end
						end
					end

				-- Do not think about embargoing anyone if we are in exile as there is no point
				elseif not(voForeignMinisterData.IsExile) then
					if not(loTarget.HasFaction and loTarget.Faction == voForeignMinisterData.Faction)
					and not(loRelation:HasAlliance())
					and not(loRelation:HasMilitaryAccess())
					and not(loRelation:HasNap()) then
						loTarget.Score = P.GetScore(loTarget, voForeignMinisterData)
						
						if loTarget.Score > 50 then
							if P.Command_Embargo(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, loTarget.Score) then
								break -- Can only execute one Embargo command at a time
							end
						end
					end
				end
			end
		end
	end
end
function P.Command_Embargo(voMinister, voFromTag, voTargetTag, vbCancel, viScore)
--Utils.LUA_DEBUGOUT("Command_Embargo")
	local loCommand = CEmbargoAction(voFromTag, voTargetTag)
	
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

return ForeignMinister_Embargo