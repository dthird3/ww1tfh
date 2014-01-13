-----------------------------------------------------------
-- LUA Hearts of Iron 3 Invite/Join Faction File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/10/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_InviteFaction = P

-- #######################
-- Called by the EXE
-- #######################
function DiploScore_InviteToFaction(voAI, voActorTag, voRecipientTag, voObserverTag)

--Utils.LUA_DEBUGOUT("DiploScore_InviteToFaction")
	local loDiploScoreObj = {
		Score = 0,														-- Current Score (integer)
		ministerAI = voAI,												-- AI Object
		loAllies = CCurrentGameState.GetFaction("allies"),				-- Faction Object for Allies
		Year = CCurrentGameState.GetCurrentDate():GetYear(),			-- Current in game Year (integer)
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(),	-- Current in game Month (integer)
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(),		-- Current in game Day (integer)
		Actor = {
			Name = tostring(voActorTag),		-- Country Name (String)
			Tag = voActorTag,					-- Country Tag
			Country = voActorTag:GetCountry(),	-- Country Object
			IsExile = nil,						-- True/False is this countries goverment in exile
			IsAtWar = nil,						-- True/False is this country a at war
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			IsPuppet = nil},					-- True/False is this country a puppet
		Target = {
			Name = tostring(voRecipientTag),	-- Country Name (String)
			Tag = voRecipientTag,				-- Country Tag
			Country = voRecipientTag:GetCountry(), -- Country Object
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile	= nil, 						-- True/False are the in exile
			IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = nil,					-- (integer) Total amount of ports the country has
			IsAtWar = nil,						-- True/False is this country at war
			IsAtWarWithFaction = false,			-- True/False is this country at war with another faction
			Neutrality = nil,					-- Current Neutrality level (integer)
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			Relation = nil						-- Relation Object between the Actor/Target
		}
	}	
	
	loDiploScoreObj.Actor.IsExile = loDiploScoreObj.Actor.Country:IsGovernmentInExile()
	loDiploScoreObj.Actor.Ideology = loDiploScoreObj.Actor.Country:GetRulingIdeology()
	loDiploScoreObj.Actor.IdeologyGroup = loDiploScoreObj.Actor.Ideology:GetGroup()
	loDiploScoreObj.Actor.IsPuppet = loDiploScoreObj.Actor.Country:IsPuppet()
	loDiploScoreObj.Actor.HasFaction = loDiploScoreObj.Actor.Country:HasFaction()
	loDiploScoreObj.Actor.IsAtWar = loDiploScoreObj.Actor.Country:IsAtWar()
	loDiploScoreObj.Actor.Faction = loDiploScoreObj.Actor.Country:GetFaction()
	loDiploScoreObj.Actor.FactionName = tostring(loDiploScoreObj.Actor.Faction:GetTag())
	
	loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
	loDiploScoreObj.Target.IsPuppet = loDiploScoreObj.Target.Country:IsPuppet()
	loDiploScoreObj.Target.PortsTotal = loDiploScoreObj.Target.Country:GetNumOfPorts()
	loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
	loDiploScoreObj.Target.IsNaval = (loDiploScoreObj.Target.PortsTotal > 0 and loDiploScoreObj.Target.IcOBJ.IC >= 20)

	loDiploScoreObj.Target.Relation = voAI:GetRelation(voRecipientTag, voActorTag)
	loDiploScoreObj.Target.Ideology = loDiploScoreObj.Target.Country:GetRulingIdeology()
	loDiploScoreObj.Target.IdeologyGroup = loDiploScoreObj.Target.Ideology:GetGroup()
	loDiploScoreObj.Target.HasFaction = loDiploScoreObj.Target.Country:HasFaction()
	loDiploScoreObj.Target.IsAtWar = loDiploScoreObj.Target.Country:IsAtWar()
	loDiploScoreObj.Target.Neutrality = loDiploScoreObj.Target.Country:GetEffectiveNeutrality():Get()	
	loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
	loDiploScoreObj.Target.FactionName = tostring(loDiploScoreObj.Target.Faction:GetTag())

	-- The enemy of my enemy is my friend
	if loDiploScoreObj.Target.IsAtWar then
		for loDiploStatus in loDiploScoreObj.Target.Country:GetDiplomacy() do
			local loTarget = loDiploStatus:GetTarget()
			
			if loTarget:IsValid() and loDiploStatus:HasWar() then
			
				-- We both have a war with the same country
				if loDiploScoreObj.Actor.Country:GetRelation(loTarget):HasWar() then
					loDiploScoreObj.Score = 50
					break
				else
					local loTargetCountry = loTarget:GetCountry()
					
					-- It looks like they are at war with another faction so stay out of it
					if loTargetCountry:HasFaction() then
						loDiploScoreObj.Score = 0
						loDiploScoreObj.Target.IsAtWarWithFaction = true
						break
					end
				end
			end					
		end
	end

	if not(loDiploScoreObj.Target.IsAtWarWithFaction) then
		-- Calculate score depending on neutrality.
		-- The function  below is new. 
		------------------------------
		loDiploScoreObj.Score = loDiploScoreObj.Score + (100 - loDiploScoreObj.Target.Neutrality) * 
														(100 - loDiploScoreObj.Target.Neutrality) * 300 / 10000
		-- only join allies if not maximum neutrality country. those join when attacked
		if (loDiploScoreObj.Target.IcOBJ.Base < 50) and (loDiploScoreObj.Actor.Faction == loDiploScoreObj.loAllies) then
			if loDiploScoreObj.Target.Neutrality > 89 then
				loDiploScoreObj.Score = 0
			end
		end
		
		-- Same ideology so a small bonus
		if loDiploScoreObj.Target.IdeologyGroup == loDiploScoreObj.Actor.IdeologyGroup then
			-- check if safe (quick check if it can even happy to save call time
			if loDiploScoreObj.Score > 40 then
				if loDiploScoreObj.Target.IcOBJ.Base > 50 or loDiploScoreObj.Target.Country:IsLandSafeToJoin(loDiploScoreObj.Actor.Faction)  then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 25
				else
					loDiploScoreObj.Score = loDiploScoreObj.Score - 100
				end
			end
		else
			loDiploScoreObj.Score = loDiploScoreObj.Score - 80 -- we'll only join if attacked pretty much, bar a small chance
		end		
	end

	return Support_Country.Call_Score_Function(false, 'DiploScore_InviteToFaction', loDiploScoreObj)
end

-- #######################
-- Support Methods
-- #######################
function P.InviteFaction(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("InviteFaction")
	-- Invite to Faction Check
	if (voForeignMinisterData.Diplomats >= defines.diplomacy.INVITE_FACTION_INFLUENCE_COST) then
		-- Only the faction leader can invite 
		if voForeignMinisterData.Country:IsFactionLeader() then
			for loTargetCountry in CCurrentGameState.GetCountries() do
				local loTarget = {
					Tag = loTargetCountry:GetCountryTag(),
					Country = loTargetCountry,
					Score = 0,
					SpamPenalty = 0,
					FinalScore = 0,
					Relation = nil}
					
				loTarget.Country = loTarget.Tag:GetCountry()
				loTarget.Relation = loTarget.Country:GetRelation(voForeignMinisterData.Tag)
				
				if P.Can_Click_Button(loTarget, voForeignMinisterData) then
					local loCommand = CFactionAction(voForeignMinisterData.Tag, loTarget.Tag)
					loCommand:SetValue(false)
					
					-- Done this way for performance
					if loCommand:IsSelectable() then
						loTarget.Score = DiploScore_InviteToFaction(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil)
						loTarget.SpamPenalty = voForeignMinisterData.ministerAI:GetSpamPenalty(loTarget.Tag)
						loTarget.FinalScore = loTarget.Score - loTarget.SpamPenalty

						if loTarget.FinalScore > 50 then
							P.Command_InviteFaction(voForeignMinisterData.minister, nil, nil, nil, loTarget.FinalScore, loCommand)
						end
					end
				end
			end
		end
	end

	-- See if we need to ask to join the faction
	if (voForeignMinisterData.Diplomats >= defines.diplomacy.JOIN_FACTION_INFLUENCE_COST) then
		-- Puppets never ask to join a faction as they follow their master
		if not(voForeignMinisterData.HasFaction) and not(voForeignMinisterData.IsPuppet) then
			for loFaction in CCurrentGameState.GetFactions() do
				local loFactionLeaderTag = loFaction:GetFactionLeader()
				local loCommand = CFactionAction(voForeignMinisterData.Tag, loFactionLeaderTag)
				
				if loCommand:IsSelectable() then
					local liScore = DiploScore_InviteToFaction(voForeignMinisterData.ministerAI, loFactionLeaderTag, voForeignMinisterData.Tag, nil)
					liScore = liScore - voForeignMinisterData.ministerAI:GetSpamPenalty(loFactionLeaderTag)
					
					if liScore > 50 then
						P.Command_InviteFaction(voForeignMinisterData.minister, nil, nil, nil, liScore, loCommand)
					end
				end
			end
		end
	end
end
function P.Command_InviteFaction(voMinister, voFromTag, voTargetTag, vbJoinInvite, viScore, voCommand)
--Utils.LUA_DEBUGOUT("Command_InviteFaction")
	if not(voCommand) then
		voCommand = CFactionAction(voFromTag, voTargetTag)
	end
	
	-- False means Inviting them
	-- True means Asking to Join
	if not(vbJoinInvite == nil) then
		voCommand:SetValue(vbJoinInvite)
	end
	
	if voCommand:IsSelectable() then
		voMinister:Propose(voCommand, viScore )
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
						if not(voTarget.Country:HasFaction()) then
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

return ForeignMinister_InviteFaction