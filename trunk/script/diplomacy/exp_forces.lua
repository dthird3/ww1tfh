-----------------------------------------------------------
-- LUA Hearts of Iron 3 Expeditionary Forces File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 12/22/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_ExpForces = P

-- #######################
-- Called by the EXE
--    This only fires if humans are sending the AI EXP forces
-- #######################
function DiploScore_SendExpeditionaryForce(voAI, voActorTag, voRecipientTag, voObserverTag, voAction)
--Utils.LUA_DEBUGOUT("DiploScore_SendExpeditionaryForce")
	local loDiploScoreObj = {
		Score = 0,														-- Current Score (integer)
		ministerAI = voAI,												-- AI Object
		Year = CCurrentGameState.GetCurrentDate():GetYear(),			-- Current in game Year (integer)
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(),	-- Current in game Month (integer)
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(),		-- Current in game Day (integer)
		Actor = {
			Name = tostring(voActorTag),		-- Country Name (String)
			Tag = voActorTag,					-- Country Tag
			Country = voActorTag:GetCountry()	-- Country Object
		},
		Target = {
			Name = tostring(voRecipientTag),	-- Country Name (String)
			Tag = voRecipientTag,				-- Country Tag
			Country = voRecipientTag:GetCountry(), -- Country Object
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile	= nil, 						-- True/False are the in exile
			IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			IdeologyGroupName = nil,			-- (string) Actual name of the Ideology Group
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = nil,					-- (integer) Total amount of ports the country has
			IsAtWar = nil,						-- True/False is this country at war
			icSupplies = 0, 					-- Total Amount of IC being used for supplies
			icSupplyPercentage = 0				-- Percentage of IC going to supplies
		}
	}

	loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
	loDiploScoreObj.Target.IsPuppet = loDiploScoreObj.Target.Country:IsPuppet()
	loDiploScoreObj.Target.Ideology = loDiploScoreObj.Target.Country:GetRulingIdeology()
	loDiploScoreObj.Target.IdeologyGroup = loDiploScoreObj.Target.Ideology:GetGroup()
	loDiploScoreObj.Target.IdeologyGroupName = tostring(loDiploScoreObj.Target.IdeologyGroup:GetKey())
	loDiploScoreObj.Target.PortsTotal = loDiploScoreObj.Target.Country:GetNumOfPorts()
	loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
	loDiploScoreObj.Target.IsNaval = (loDiploScoreObj.Target.PortsTotal > 0 and loDiploScoreObj.Target.IcOBJ.IC >= 20)

	loDiploScoreObj.Target.IsAtWar = loDiploScoreObj.Target.Country:IsAtWar()

	-- Never accept EXP forces unless we are at war
	if loDiploScoreObj.Target.IsAtWar then
		loDiploScoreObj.Target.icSupplies = loDiploScoreObj.Target.Country:GetICPart(CDistributionSetting._PRODUCTION_SUPPLY_):Get()
		loDiploScoreObj.Target.icSupplyPercentage = loDiploScoreObj.Target.icSupplies / loDiploScoreObj.Target.IcOBJ.IC

		-- Only process this if less than 20% of our IC is going to supplies
		if loDiploScoreObj.Target.icSupplyPercentage < 0.20 then
			local liOurStrength = -1
			local liEnemeyTotalStrength = 0

			-- Look at all of our wars
			for loTargetTag in loDiploScoreObj.Target.Country:GetCurrentAtWarWith() do
				local loIntel = CAIIntel(loTargetTag, loDiploScoreObj.Target.Tag)

				liEnemeyTotalStrength = liEnemeyTotalStrength + loIntel:CalculateTheirPercievedMilitaryStrengh()

				-- Done this way for performance
				if liOurStrength < 0 then
					liOurStrength = loIntel:CalculateOurMilitaryStrength()
				end
			end

			-- Prevent divide by 0
			if liOurStrength >= 1 and liEnemeyTotalStrength > 0 then
				-- Only consider if we are weaker then our enemy
				if liOurStrength < liEnemeyTotalStrength then
					-- Example (((50/40 = 1.25) - 1 = 0.25) * 100 = 25) then min score of 25 vs 100 
					loDiploScoreObj.Score = math.min((((liEnemeyTotalStrength / liOurStrength) - 1) * 100), 100)
				end

			-- Say yes if we are extremely weak
			elseif liOurStrength < 1 and liEnemeyTotalStrength > 0 then
				-- We have no troops so say yes to anything
				loDiploScoreObj.Score = 100
			end
		end
	end

	return Support_Country.Call_Score_Function(false, 'DiploScore_ReceiveExpForces', loDiploScoreObj)
end
-- #######################
-- Support Methods
-- #######################
function P.ExpForces(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("ExpForces")
	-- Nothing to do heare yet just a place holder in case Paradox enhances the LUA
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return ForeignMinister_ExpForces