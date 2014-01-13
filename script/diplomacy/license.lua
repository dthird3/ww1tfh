-----------------------------------------------------------
-- LUA Hearts of Iron 3 License File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 9/15/2012
-----------------------------------------------------------
local P = {}
Support_License = P

-- ###########################
-- Called by the EXE
-- ###########################
function DiploScore_LicenceTechnology(voAI, voActorTag, voRecipientTag, voObserverTag, voCommand)
--Utils.LUA_DEBUGOUT("DiploScore_LicenceTechnology")
	local loDiploScoreObj = {
		Score = 0,
		DefaultScore = 50,
		ministerAI = voAI,
		Command = voCommand,
		SubUnit = voCommand:GetSubunit(),
		Cost = 0,
		TotalCost = 0,
		Parallel = voCommand:GetParalell(),
		Serial = voCommand:GetSerial(),
		UnitCount = 0,
		IsNeighbor = nil,
		Relation = nil,
		OfferAmount = nil,
		Actor = {
			Name = tostring(voActorTag),
			Tag = voActorTag,
			Country = voActorTag:GetCountry(),
			Faction = nil,
			Continent = nil,
			Ideology = nil,
			Strategy = nil,
			Money = 0
		},
		Target = {
			Name = tostring(voRecipientTag),
			Tag = voRecipientTag,
			Country = voRecipientTag:GetCountry(),
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile	= nil, 						-- True/False are the in exile
			IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = nil,					-- (integer) Total amount of ports the country has
			Faction = nil,
			Continent = nil,
			Ideology = nil,
			HasFaction = nil,
		}
	}
	
	-- They did not select a unit so return 0
	if not(loDiploScoreObj.SubUnit) then
		return 0
	end
	
	loDiploScoreObj.Actor.Faction = loDiploScoreObj.Actor.Country:GetFaction()
	loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
	loDiploScoreObj.Actor.Ideology = tostring(loDiploScoreObj.Actor.Country:GetRulingIdeology():GetGroup():GetKey())
	loDiploScoreObj.Target.Ideology = tostring(loDiploScoreObj.Target.Country:GetRulingIdeology():GetGroup():GetKey())
	loDiploScoreObj.Actor.HasFaction = loDiploScoreObj.Actor.Country:HasFaction()
	
	loDiploScoreObj.AlignDist = math.floor(loDiploScoreObj.ministerAI:GetCountryAlignmentDistance(loDiploScoreObj.Actor.Country, loDiploScoreObj.Target.Country):Get())

	if (loDiploScoreObj.Actor.HasFaction and loDiploScoreObj.Actor.Faction == loDiploScoreObj.Target.Faction)
	or (loDiploScoreObj.Actor.Ideology == loDiploScoreObj.Target.Ideology and loDiploScoreObj.AlignDist < 125)
	or (loDiploScoreObj.AlignDist < 80) then
		-- Get Cost Per Unit
		loDiploScoreObj.UnitCount = loDiploScoreObj.Parallel * loDiploScoreObj.Serial
		loDiploScoreObj.Actor.Money = loDiploScoreObj.Actor.Country:GetPool():Get(CGoodsPool._MONEY_):Get()
		loDiploScoreObj.Cost = P.CalculateCost(loDiploScoreObj.Actor, loDiploScoreObj.Target, loDiploScoreObj.SubUnit)
		loDiploScoreObj.TotalCost = loDiploScoreObj.Cost * loDiploScoreObj.UnitCount
		loDiploScoreObj.OfferAmount = loDiploScoreObj.Command:GetMoney():Get() * loDiploScoreObj.UnitCount

		if loDiploScoreObj.TotalCost > loDiploScoreObj.Actor.Money
		or loDiploScoreObj.TotalCost > loDiploScoreObj.OfferAmount then
			return 0
		else
			loDiploScoreObj.Relation = loDiploScoreObj.ministerAI:GetRelation(loDiploScoreObj.Actor.Tag, loDiploScoreObj.Target.Tag)
			loDiploScoreObj.Target.Strategy = loDiploScoreObj.Target.Country:GetStrategy()
			loDiploScoreObj.IsNeighbor = loDiploScoreObj.Actor.Country:IsNonExileNeighbour(loDiploScoreObj.Target.Tag)	
			loDiploScoreObj.Continent = loDiploScoreObj.Target.Country:GetActingCapitalLocation():GetContinent()
			loDiploScoreObj.Continent = loDiploScoreObj.Actor.Country:GetActingCapitalLocation():GetContinent()

			loDiploScoreObj.Score = loDiploScoreObj.DefaultScore -- Set it to default
			loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Target.Strategy:GetAntagonism(loDiploScoreObj.Actor.Tag) / 15			
			loDiploScoreObj.Score = loDiploScoreObj.Score + loDiploScoreObj.Target.Strategy:GetFriendliness(loDiploScoreObj.Actor.Tag) / 10
			loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Relation:GetThreat():Get() / 5
			loDiploScoreObj.Score = loDiploScoreObj.Score + tonumber(tostring(loDiploScoreObj.Relation:GetValue():GetTruncated())) / 3
			
			if loDiploScoreObj.Actor.HasFaction then
				if loDiploScoreObj.Actor.Faction == loDiploScoreObj.Target.Faction then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 30
				end
			end
			
			if loDiploScoreObj.Relation:IsGuaranteed() then
				loDiploScoreObj.Score = loDiploScoreObj.Score + 5
			end
			if loDiploScoreObj.Relation:HasFriendlyAgreement() then
				loDiploScoreObj.Score = loDiploScoreObj.Score + 15
			end
			if loDiploScoreObj.Relation:IsFightingWarTogether() then
				loDiploScoreObj.Score = loDiploScoreObj.Score + 25
			end
			
			if loDiploScoreObj.IsNeighbor then
				loDiploScoreObj.Score = loDiploScoreObj.Score + 5
			end
			
			if loDiploScoreObj.Target.Continent == loDiploScoreObj.Actor.Continent then
				loDiploScoreObj.Score = loDiploScoreObj.Score + 5
			end
			
			if loDiploScoreObj.Actor.Ideology == loDiploScoreObj.Target.Ideology then
				loDiploScoreObj.Score = loDiploScoreObj.Score + 15
			end
			
			if Support_Functions.IsFriend(loDiploScoreObj.ministerAI, loDiploScoreObj.Actor.Faction, loDiploScoreObj.Target.Country) then
				loDiploScoreObj.Score = loDiploScoreObj.Score + 20
			end
		end
	end

	if loDiploScoreObj.Score > 0 then
		loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
		loDiploScoreObj.Target.IsPuppet = loDiploScoreObj.Target.Country:IsPuppet()
		loDiploScoreObj.Target.PortsTotal = loDiploScoreObj.Target.Country:GetNumOfPorts()
		loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
		loDiploScoreObj.Target.IsNaval = (loDiploScoreObj.Target.PortsTotal > 0 and loDiploScoreObj.Target.IcOBJ.IC >= 20)

		loDiploScoreObj.Score = Support_Country.Call_Score_Function(false, "DiploScore_LicenceTechnology", loDiploScoreObj)
	end
	
	return loDiploScoreObj.Score
end

-- #######################
-- Support Methods
-- #######################
function P.ProductionCheck(voType, voProductionData)
--Utils.LUA_DEBUGOUT("ProductionCheck")
	local lbLicenseRequired = false
	
	if voType.Type ~= "Land" then
		local loSubUnit = CSubUnitDataBase.GetSubUnit(voType.Name)
		
		-- Try to License it if we do not have it
		if not(voProductionData.TechStatus:IsUnitAvailable(loSubUnit)) and not(loSubUnit:IsCapitalShip()) then
			lbLicenseRequired = true -- Set the License required flag
		
			local liUnitMPcost = loSubUnit:GetBuildCostMP():Get()
			local liTotalMP = voProductionData.Units[voType.Name].Need * liUnitMPcost
			
			if voProductionData.Manpower.Total < liTotalMP then
				voProductionData.Units[voType.Name].Need = math.floor(voProductionData.Manpower.Total / liUnitMPcost)
			end		
			
			-- WE do not do parralel runs just one serial run
			voProductionData.Units[voType.Name].Need = math.min(voProductionData.Units[voType.Name].Need, voType.Serial)
			
			-- Performance check, make sure we have to build something after MP check
			if voProductionData.Units[voType.Name].Need > 0 then
				-- Creater the Buyer Object
				local loBuyerInfo = {
					Country = voProductionData.Country,
					HasFaction = voProductionData.Country:HasFaction(),
					Faction = voProductionData.Country:GetFaction(),
					Ideology = tostring(voProductionData.Country:GetRulingIdeology():GetGroup():GetKey()),
					Pool = voProductionData.Country:GetPool():Get(CGoodsPool._MONEY_):Get(),
					Diplomats = voProductionData.Country:GetDiplomaticInfluence():Get()}
					
				local loLowestBidder = nil
				
				-- Make sure we have actual diplomats before we do all this work
				if (loBuyerInfo.Diplomats >= defines.diplomacy.LICENCE_INFLUENCE_COST) then
					for loDiploStatus in loBuyerInfo.Country:GetDiplomacy() do
						local loSellerInfo = {
							Tag = loDiploStatus:GetTarget(),
							Country = nil,
							TechStatus = nil,
							SpamPenalty = nil,
							Faction = nil,
							Ideology = nil,
							Relation = loDiploStatus,
							Units = voProductionData.Units[voType.Name].Need,
							Command = nil,
							Score = 0,
							Cost = 0}

						loSellerInfo.Country = loSellerInfo.Tag:GetCountry()
							
						if P.Can_Click_Button(loSellerInfo, voProductionData) then
							loSellerInfo.Faction = loSellerInfo.Country:GetFaction()
							loSellerInfo.Ideology = tostring(loSellerInfo.Country:GetRulingIdeology():GetGroup():GetKey())
							
							loSellerInfo.TechStatus = loSellerInfo.Country:GetTechnologyStatus()
							
							-- They can produce the tech so figure out cost
							if loSellerInfo.TechStatus:IsUnitAvailable(loSubUnit) then
								loSellerInfo.Faction = loSellerInfo.Country:GetFaction()
								loSellerInfo.Ideology = tostring(loSellerInfo.Country:GetRulingIdeology():GetGroup():GetKey())
								loSellerInfo.SpamPenalty = voProductionData.ministerAI:GetSpamPenalty(loSellerInfo.Tag)
								
								loSellerInfo.Cost = P.CalculateCost(loBuyerInfo, loSellerInfo, loSubUnit)
								
								-- Now figure out how many we can afford
								if loBuyerInfo.Pool < (loSellerInfo.Cost * loSellerInfo.Units) then
									loSellerInfo.Units = math.floor(loBuyerInfo.Pool / loSellerInfo.Cost)
								end
							
								-- We can afford some so lets get a score
								if loSellerInfo.Units > 0 then
									-- Create Command Object
									loSellerInfo.Command = CLicenceTechnologyAction(voProductionData.Tag, loSellerInfo.Tag)
									loSellerInfo.Command:SetSubunit(loSubUnit)
									loSellerInfo.Command:SetMoney(CFixedPoint(loSellerInfo.Cost))
									loSellerInfo.Command:SetSerial(loSellerInfo.Units)
									loSellerInfo.Command:SetParallel(1)
									
									loSellerInfo.Score = DiploScore_LicenceTechnology(voProductionData.ministerAI, voProductionData.Tag, loSellerInfo.Tag, nil, loSellerInfo.Command)
									
									if (loSellerInfo.Score - loSellerInfo.SpamPenalty) > 50 then
										if not(loLowestBidder) then
											loLowestBidder = loSellerInfo
										else
											-- Always go with the cheapest bidder
											if loLowestBidder.Cost > loSellerInfo.Cost then
												loLowestBidder = loSellerInfo
											elseif loLowestBidder.Cost == loSellerInfo.Cost then
												-- Cost is the same so go with the better score
												if loLowestBidder.Score < loSellerInfo.Score then
													loLowestBidder = loSellerInfo
												end
											end
										end
									end
								end
							end
						end
					end
					
					-- We found someone to license this from so ask
					--   Do not take into account the IC incase they say no this way que is always full
					if loLowestBidder then
						-- Update MP count on assumption we will build the unit
						voProductionData.Manpower.Total = voProductionData.Manpower.Total - loLowestBidder.Units * liUnitMPcost
						voProductionData.ministerAI:PostAction(loLowestBidder.Command)
					end
				end
			end
		end
	end
	
	return lbLicenseRequired, voProductionData.Manpower.Total
end
function P.CalculateCost(voBuyerInfo, voSellerInfo, voSubUnit)
--Utils.LUA_DEBUGOUT("CalculateCost")
	local liICCode = voSubUnit:GetBuildCostIC():Get()
	local liBuildTime = voSubUnit:GetBuildTime():Get()
	local liCost = 0

	if voBuyerInfo.Faction == voSellerInfo.Faction and voBuyerInfo.HasFaction then
		if voBuyerInfo.Country:IsAtWar() then
			liCost = (liICCode * liBuildTime) * 0.005 -- Half of 1 percent
		else
			liCost = (liICCode * liBuildTime) * 0.0075 -- 75% of 1 percent
		end
	elseif voBuyerInfo.Ideology == voSellerInfo.Ideology then
		liCost = (liICCode * liBuildTime) * 0.0085 -- 85% of 1 percent
	else
		liCost = (liICCode * liBuildTime) * 0.01 -- 1 percent
	end
	
	return liCost
end
function P.Can_Click_Button(voTarget, voProductionData)
--Utils.LUA_DEBUGOUT("Can_Click_Button")
	if voTarget.Country:Exists() then
		if voTarget.Tag:IsReal() then
			if voTarget.Tag:IsValid() then
				if not(voTarget.Country:IsPuppet()) then
					if not(voTarget.Relation:HasWar()) then
						if not(voProductionData.Country:HasDiplomatEnroute(voTarget.Tag)) then
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

return Support_License