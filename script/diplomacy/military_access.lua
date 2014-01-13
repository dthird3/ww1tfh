-----------------------------------------------------------
-- LUA Hearts of Iron 3 Military Access File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/10/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_MilitaryAccess = P

-- #######################
-- Called by the EXE
-- #######################
function DiploScore_DemandMilitaryAccess(voAI, voActorTag, voRecipientTag, voObserverTag)
--Utils.LUA_DEBUGOUT("DiploScore_DemandMilitaryAccess")
	-- Actor and Observer are same thing when demanding
	local loDiploScoreObj = P.Generate_MilitaryAccess_Score(voAI, voActorTag, voRecipientTag)
	
	-- Same as Offer but reverse the voActorTag and voRecipientTag
	--   Only pass the country that is asking for access
	return Support_Country.Call_Score_Function(false, 'DiploScore_GiveMilitaryAccess', loDiploScoreObj)
end
function DiploScore_OfferMilitaryAccess(voAI, voActorTag, voRecipientTag, voObserverTag, action)
--Utils.LUA_DEBUGOUT("DiploScore_OfferMilitaryAccess")
	-- Recipient and Observer are same thing when Offering
	local loDiploScoreObj = P.Generate_MilitaryAccess_Score(voAI, voRecipientTag, voActorTag)
	
	-- Same as Offer but reverse the voActorTag and voRecipientTag
	--   Only pass the country that we are considering giving access to
	return Support_Country.Call_Score_Function(false, 'DiploScore_GiveMilitaryAccess', loDiploScoreObj)
end

-- #######################
-- Support Methods
-- #######################
function P.Generate_MilitaryAccess_Score(voAI, voActorTag, voRecipientTag)
--Utils.LUA_DEBUGOUT("Generate_MilitaryAccess_Score")
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
			IsExile = nil,						-- True/False is this countries goverment in exile
			IsAtWar = nil,						-- True/False is this country a at war
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
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
			Neutrality = nil,					-- Current Neutrality level (integer)
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			Relation = nil}						-- Relation Object between the Actor/Target
	}
	
	
	loDiploScoreObj.Actor.Faction = loDiploScoreObj.Actor.Country:GetFaction()
	loDiploScoreObj.Actor.FactionName = tostring(loDiploScoreObj.Actor.Faction:GetTag())
	loDiploScoreObj.Actor.IsExile = loDiploScoreObj.Actor.Country:IsGovernmentInExile()
	loDiploScoreObj.Actor.Ideology = loDiploScoreObj.Actor.Country:GetRulingIdeology()
	loDiploScoreObj.Actor.IdeologyGroup = loDiploScoreObj.Actor.Ideology:GetGroup()
	loDiploScoreObj.Actor.IsPuppet = loDiploScoreObj.Actor.Country:IsPuppet()
	loDiploScoreObj.Actor.HasFaction = loDiploScoreObj.Actor.Country:HasFaction()
	loDiploScoreObj.Actor.IsAtWar = loDiploScoreObj.Actor.Country:IsAtWar()
	loDiploScoreObj.Actor.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Actor.Country)

	loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
	loDiploScoreObj.Target.IsPuppet = loDiploScoreObj.Target.Country:IsPuppet()
	loDiploScoreObj.Target.PortsTotal = loDiploScoreObj.Target.Country:GetNumOfPorts()
	loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
	loDiploScoreObj.Target.IsNaval = (loDiploScoreObj.Target.PortsTotal > 0 and loDiploScoreObj.Target.IcOBJ.IC >= 20)
	loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
	loDiploScoreObj.Target.FactionName = tostring(loDiploScoreObj.Target.Faction:GetTag())
	loDiploScoreObj.Target.Relation = voAI:GetRelation(voRecipientTag, voActorTag)
	loDiploScoreObj.Target.Ideology = loDiploScoreObj.Target.Country:GetRulingIdeology()
	loDiploScoreObj.Target.IdeologyGroup = loDiploScoreObj.Target.Ideology:GetGroup()
	loDiploScoreObj.Target.HasFaction = loDiploScoreObj.Target.Country:HasFaction()
	loDiploScoreObj.Target.IsAtWar = loDiploScoreObj.Target.Country:IsAtWar()
	loDiploScoreObj.Target.Neutrality = loDiploScoreObj.Target.Country:GetEffectiveNeutrality():Get()
	
	-- Goverments in Exile should never ask or give military access
	if not(loDiploScoreObj.Actor.IsExile) and not(loDiploScoreObj.Target.IsExile) then
		-- If they are atwar with eachother this is impossible
		if not(loDiploScoreObj.Target.Relation:HasWar()) then
			local loRecipientCountry = voRecipientTag:GetCountry()
			local loActorCountry = voActorTag:GetCountry()
			
			-- Asking or Demanding as a puppet is not possible for military access
			if not(loDiploScoreObj.Actor.IsPuppet) and not(loDiploScoreObj.Actor.IsPuppet) then
				-- If they are in a faction then exit
				if not(loDiploScoreObj.Target.HasFaction) then
					local lbMajorNeighborCheck = false
				
					-- Same ideology so a small bonus
					if loDiploScoreObj.Actor.IdeologyGroup == loDiploScoreObj.Target.IdeologyGroup then
						loDiploScoreObj.Score = loDiploScoreObj.Score + 25
					else
						loDiploScoreObj.Score = loDiploScoreObj.Score - 10
					end
					
					-- Check to see who they are after, if it is another major do not get involved
					for loCountryTag in loDiploScoreObj.Target.Country:GetNeighbours() do
						local loRelation2 = voAI:GetRelation(voActorTag, loCountryTag)
						
						if loRelation2:HasWar() then
							local loCountry2 = loCountryTag:GetCountry()
							if loCountry2:IsMajor() then
								lbMajorNeighborCheck = true
								loDiploScoreObj.Score = loDiploScoreObj.Score - 25
								break
							end
						end
					end
					
					-- They are after a minor so go ahead and give them a small bonus
					if not(lbMajorNeighborCheck) then
						loDiploScoreObj.Score = loDiploScoreObj.Score + 25
					end
					
					-- They are not at war so why do they need military access?
					if not(loDiploScoreObj.Actor.IsAtWar) then
						loDiploScoreObj.Score = loDiploScoreObj.Score - 50
					end

					-- Calculate strength based on IC
					--   The smaller the minor the more likely they will say yes
					if loDiploScoreObj.Actor.IcOBJ.IC > (loDiploScoreObj.Target.IcOBJ.IC * 7) then
						loDiploScoreObj.Score = loDiploScoreObj.Score + 25
					elseif loDiploScoreObj.Actor.IcOBJ.IC > (loDiploScoreObj.Target.IcOBJ.IC * 5) then
						loDiploScoreObj.Score = loDiploScoreObj.Score + 10
					elseif loDiploScoreObj.Actor.IcOBJ.IC > (loDiploScoreObj.Target.IcOBJ.IC * 3) then
						loDiploScoreObj.Score = loDiploScoreObj.Score + 5
					end

					-- If they are heavily neutral then don't let them through
					if loDiploScoreObj.Target.Neutrality > 90 then
						loDiploScoreObj.Score = loDiploScoreObj.Score - 50
					elseif loDiploScoreObj.Target.Neutrality > 80 then
						loDiploScoreObj.Score = loDiploScoreObj.Score - 25
					elseif loDiploScoreObj.Target.Neutrality > 70 then
						loDiploScoreObj.Score = loDiploScoreObj.Score - 10
					end
					
					-- Now Calculate Threat and Relations into the score
					loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Target.Relation:GetThreat():Get() / 5
					loDiploScoreObj.Score = loDiploScoreObj.Score + loDiploScoreObj.Target.Relation:GetValue():GetTruncated() / 3
				end
			end
		end
	end
	
	return loDiploScoreObj
end

function P.MilitaryAccess(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("MilitaryAccess")
	if (voForeignMinisterData.Diplomats >= defines.diplomacy.MILACCESS_INFLUENCE_COST) then
		local lbProcess = true
		local loFunRef = Support_Country.Get_Function(voForeignMinisterData, "ForeignMinister_MilitaryAccess")
		
		if loFunRef then
			lbProcess = loFunRef(voForeignMinisterData)
		end
		
		-- Request for Military Access
		--  Only major powers will request military access
		if lbProcess then
			for loNeighborTag in voForeignMinisterData.Country:GetControllerNeighbours() do
				local loTarget = {
					Tag = loNeighborTag,
					Country = loNeighborTag:GetCountry(),
					Score = 0,
					SpamPenalty = 0,
					FinalScore = 0,
					Relation = nil}
			
				loTarget.Relation = voForeignMinisterData.Country:GetRelation(loTarget.Tag)

				if P.Can_Click_Button(loTarget, voForeignMinisterData) then
					-- Make sure we do not already have military access
					if not(loTarget.Relation:HasMilitaryAccess()) then
						if voForeignMinisterData.IsAtWar then
							-- Now check their neighbors to see if they touch an enemy
							for loWarTargetTag in loTarget.Country:GetControllerNeighbours() do
								if not(loWarTargetTag == voForeignMinisterData.Tag) then
									local loWarRelation = voForeignMinisterData.Country:GetRelation(loWarTargetTag)

									if loWarRelation:HasWar() then
										if not(voForeignMinisterData.Strategy:IsPreparingWarWith(loWarTargetTag)) then
											loTarget.Score = DiploScore_DemandMilitaryAccess(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil)
											loTarget.SpamPenalty = voForeignMinisterData.ministerAI:GetSpamPenalty(loTarget.Tag)
											loTarget.FinalScore = loTarget.Score - loTarget.SpamPenalty
											
											if loTarget.FinalScore > 50 then
												if P.Command_DemandAccess(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, loTarget.FinalScore) then
													break
												end
											end
										end
									end
								end
							end
						end
					else
						loTarget.Score = DiploScore_DemandMilitaryAccess(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil)

						if loTarget.Score < 50 then
							if P.Command_DemandAccess(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100) then
								break
							end
						end
					end
				end
			end
		end
	
		-- Check to see if we need to cancel someones access to our territory
		--   We never offer military access but we do cancel
		for loTargetCountry in CCurrentGameState.GetCountries() do
			local loTarget = {
				Tag = loTargetCountry:GetCountryTag(),
				Country = loTargetCountry,
				Score = 0,
				Relation = nil}		

			if not(loTarget.Tag == voForeignMinisterData.Tag) then
				loTarget.Relation = loTarget.Country:GetRelation(voForeignMinisterData.Tag)
				
				-- We are giving them military access look to see if we should cancel it
				if loTarget.Relation:HasMilitaryAccess() then
					loTarget.Score = DiploScore_OfferMilitaryAccess(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil)

					if loTarget.Score < 50 then
						if P.Command_OfferAccess(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100) then
							break
						end
					end
				end
			end
		end
	end
end

function P.Command_DemandAccess(voMinister, voFromTag, voTargetTag, vbCancel, viScore)
--Utils.LUA_DEBUGOUT("Command_DemandAccess")
	local loCommand = CMilitaryAccessAction(voFromTag, voTargetTag)
	
	if vbCancel then
		loCommand:SetValue(false)
	end

	if loCommand:IsSelectable() then
		voMinister:Propose(loCommand, viScore )
		return true
	end
	
	return false
end
function P.Command_OfferAccess(voMinister, voFromTag, voTargetTag, vbCancel, viScore)
--Utils.LUA_DEBUGOUT("Command_OfferAccess")
	local loCommand = COfferMilitaryAccessAction(voFromTag, voTargetTag)
	
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
				if not(voTarget.Tag == voForeignMinisterData.Tag) then
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
	end
	
	return false
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return ForeignMinister_MilitaryAccess