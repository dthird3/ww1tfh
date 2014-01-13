-----------------------------------------------------------
-- LUA Hearts of Iron 3 Trade File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------
local P = {}
Support_Trade = P


-- ###########################
-- Called by the EXE and handles the Analyzing of offered trades
-- ###########################
function DiploScore_OfferTrade(voAI, voFromTag, voToTag, voObserverTag, voTradeAction, voTradedFrom, voTradedTo)
	--Utils.LUA_DEBUGOUT("DiploScore_OfferTrade")
	local loDiploScoreObj = {
		Score = 0,
		DefaultScore = 50,
		ministerAI = voAI,
		TradeRoute = voTradeAction:GetRoute(),
		Relation = voAI:GetRelation(voToTag, voFromTag),
		HasFriendlyAgreement = false,
		IsFightingWarTogether = false,
		IsActorBuyer = false,
		IsNeighbor = nil,
		NeedConvoy = false,
		ConvoyPoints = 0,
		FreeTrade = false,
		Money = nil,
		ResourceRequest = nil,
		Strategy = nil,
		Actor = {
			Name = tostring(voFromTag),
			Tag = voFromTag,
			Country = voFromTag:GetCountry(),
			CapitalProvince = nil,
			Continent = nil,
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			IdeologyGroupName = nil, 			-- Name of the ideology group (string)
			Resources = nil,
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil					-- Name of the Faction the country belongs to (string)
		},
		Target = {
			Name = tostring(voToTag),
			Tag = voToTag,
			Country = voToTag:GetCountry(),
			CapitalProvince = nil,
			Continent = nil,
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			IdeologyGroupName = nil, 			-- Name of the ideology group (string)
			Resources = nil,
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil					-- Name of the Faction the country belongs to (string)
		}
	}
		
	loDiploScoreObj.FreeTrade = Support_Trade.FreeTradeCheck(voAI, voToTag, voFromTag, loDiploScoreObj.Relation)
	
	-- Two way trade get out!
	-- 0 cost trade but make sure they are not Commintern
	if (voTradedTo.vMoney > 0 and voTradedFrom.vMoney > 0)
	or (voTradedTo.vMoney == 0 and voTradedFrom.vMoney == 0 and not(loDiploScoreObj.FreeTrade)) then
		return 0
	end

	local liFromCount = 0
	local liToCount = 0
		
	-- They can trade freely between eachother
	if loDiploScoreObj.FreeTrade then
		liFromCount = voTradedFrom.vMetal + voTradedFrom.vEnergy + voTradedFrom.vRareMaterials + voTradedFrom.vCrudeOil + voTradedFrom.vSupplies + voTradedFrom.vFuel
		liToCount = voTradedTo.vMetal + voTradedTo.vEnergy + voTradedTo.vRareMaterials + voTradedTo.vCrudeOil + voTradedTo.vSupplies + voTradedTo.vFuel
	end

	if (voTradedTo.vMoney > 0)
	or (lbFreeTrader and liFromCount > 0 and liToCount <= 0) then
		-- Get the Money amount
		loDiploScoreObj.Money = voTradedTo.vMoney
		loDiploScoreObj.ResourceRequest = voTradedFrom
		
		if loDiploScoreObj.TradeRoute:GetTo() == loDiploScoreObj.Actor.Tag then
			loDiploScoreObj.IsActorBuyer = true
		end
	else
		-- Get the Money amount
		loDiploScoreObj.Money = voTradedFrom.vMoney
		loDiploScoreObj.ResourceRequest = voTradedTo

		if loDiploScoreObj.TradeRoute:GetFrom() == loDiploScoreObj.Actor.Tag then
			loDiploScoreObj.IsActorBuyer = true
		end
	end		
		
	-- Do we need convoys for this?
	if loDiploScoreObj.IsActorBuyer then
		loDiploScoreObj.NeedConvoy = loDiploScoreObj.Actor.Country:NeedConvoyToTradeWith(loDiploScoreObj.Target.Tag)
		
		if loDiploScoreObj.NeedConvoy then
			loDiploScoreObj.ConvoyPoints = loDiploScoreObj.Actor.Country:GetTransports()
		end
	else
		loDiploScoreObj.NeedConvoy = loDiploScoreObj.Target.Country:NeedConvoyToTradeWith(loDiploScoreObj.Actor.Tag)
		
		if loDiploScoreObj.NeedConvoy then
			loDiploScoreObj.ConvoyPoints = loDiploScoreObj.Target.Country:GetTransports()
		end
	end
	
	-- Do we have the transports for this
	if loDiploScoreObj.NeedConvoy and loDiploScoreObj.ConvoyPoints == 0 then
		return 0
	end		

	loDiploScoreObj.Actor.Resources = Support_Trade.Trade_GetResources(loDiploScoreObj.Actor.Tag, loDiploScoreObj.Actor.Country, loDiploScoreObj.IsActorBuyer)
	loDiploScoreObj.Target.Resources = Support_Trade.Trade_GetResources(loDiploScoreObj.Target.Tag, loDiploScoreObj.Target.Country, not(loDiploScoreObj.IsActorBuyer))
	
	local lbFoundOne = false
	local loBuyerResources = loDiploScoreObj.Actor.Resources
	local loSellerResources = loDiploScoreObj.Target.Resources
	
	if not(loDiploScoreObj.IsActorBuyer) then
		loBuyerResources = loDiploScoreObj.Target.Resources
		loSellerResources = loDiploScoreObj.Actor.Resources
	end
	
	for k, v in pairs(loBuyerResources) do
		if not(v.ByPass) then
			if loDiploScoreObj.ResourceRequest[v.TradeOBJ] > 0 then
				if lbFoundOne then
					return 0 -- We only process one resource at a time
				end
				if loDiploScoreObj.IsActorBuyer then
					if loDiploScoreObj.ResourceRequest[v.TradeOBJ] <= loSellerResources[k].Sell then
						-- Always add the default in as they may be buying more than they need
						loDiploScoreObj.Score = ((loDiploScoreObj.ResourceRequest[v.TradeOBJ] * v.ScoreFactor) * v.ShortPercentage) + loDiploScoreObj.DefaultScore
					end
				else
					if loDiploScoreObj.ResourceRequest[v.TradeOBJ] <= v.Buy and v.TradeAway <= 0 then
						if loDiploScoreObj.Money <= loBuyerResources.MONEY.CanSpend then
							loDiploScoreObj.Score = ((loDiploScoreObj.ResourceRequest[v.TradeOBJ] * v.ScoreFactor) * v.ShortPercentage)
						end

						-- Only add Default in if there is something to work with
						if loDiploScoreObj.Score > 0 then
							loDiploScoreObj.Score = loDiploScoreObj.Score + loDiploScoreObj.DefaultScore
						end
					end
				end

				lbFoundOne = true
			end
		end
	end
	
	-- Now shift the score based on Diplomatic relations!
	if loDiploScoreObj.Score > 0 then
		-- Political checks
		if loDiploScoreObj.IsActorBuyer then
			loDiploScoreObj.Strategy = loDiploScoreObj.Target.Country:GetStrategy()
			loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Strategy:GetAntagonism(loDiploScoreObj.Actor.Tag) / 15			
			loDiploScoreObj.Score = loDiploScoreObj.Score + loDiploScoreObj.Strategy:GetFriendliness(loDiploScoreObj.Actor.Tag) / 10
		else
			loDiploScoreObj.Strategy = loDiploScoreObj.Actor.Country:GetStrategy()
			loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Strategy:GetAntagonism(loDiploScoreObj.Target.Tag) / 15			
			loDiploScoreObj.Score = loDiploScoreObj.Score + loDiploScoreObj.Strategy:GetFriendliness(loDiploScoreObj.Target.Tag) / 10
		end
		
		loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Relation:GetThreat():Get() / 5
		loDiploScoreObj.Score = loDiploScoreObj.Score + tonumber(tostring(loDiploScoreObj.Relation:GetValue():GetTruncated())) / 3
		
		loDiploScoreObj.IsNeighbor = loDiploScoreObj.Actor.Country:IsNonExileNeighbour(loDiploScoreObj.Target.Tag)
		loDiploScoreObj.HasFriendlyAgreement = loDiploScoreObj.Relation:HasFriendlyAgreement()
		loDiploScoreObj.IsFightingWarTogether = loDiploScoreObj.Relation:IsFightingWarTogether()
		
		loDiploScoreObj.Actor.CapitalProvince = loDiploScoreObj.Actor.Country:GetActingCapitalLocation()
		loDiploScoreObj.Actor.Continent = loDiploScoreObj.Actor.CapitalProvince:GetContinent()
		loDiploScoreObj.Actor.Ideology = loDiploScoreObj.Actor.Country:GetRulingIdeology()
		loDiploScoreObj.Actor.IdeologyGroup = loDiploScoreObj.Actor.Ideology:GetGroup()
		loDiploScoreObj.Actor.IdeologyGroupName = tostring(loDiploScoreObj.Actor.IdeologyGroup:GetKey())

		loDiploScoreObj.Actor.HasFaction = loDiploScoreObj.Actor.Country:HasFaction()
		loDiploScoreObj.Actor.Faction = loDiploScoreObj.Actor.Country:GetFaction()
		loDiploScoreObj.Actor.FactionName = tostring(loDiploScoreObj.Actor.Faction:GetTag())

		loDiploScoreObj.Target.CapitalProvince = loDiploScoreObj.Target.Country:GetActingCapitalLocation()
		loDiploScoreObj.Target.Continent = loDiploScoreObj.Target.CapitalProvince:GetContinent()
		loDiploScoreObj.Target.Ideology = loDiploScoreObj.Target.Country:GetRulingIdeology()
		loDiploScoreObj.Target.IdeologyGroup = loDiploScoreObj.Target.Ideology:GetGroup()
		loDiploScoreObj.Target.IdeologyGroupName = tostring(loDiploScoreObj.Target.IdeologyGroup:GetKey())
		loDiploScoreObj.Target.HasFaction = loDiploScoreObj.Target.Country:HasFaction()
		loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
		loDiploScoreObj.Target.FactionName = tostring(loDiploScoreObj.Target.Faction:GetTag())
		
		if loDiploScoreObj.HasFriendlyAgreement then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 10
		end
		
		if loDiploScoreObj.IsFightingWarTogether then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 15
		end		
		
		if loDiploScoreObj.IsNeighbor then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 15
		end
		
		if loDiploScoreObj.Actor.Continent == loDiploScoreObj.Target.Continent then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 10
		end
		
		if loDiploScoreObj.Actor.IdeologyGroup == loDiploScoreObj.Target.IdeologyGroup then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 10
		end
		
		if loDiploScoreObj.Actor.HasFaction or loDiploScoreObj.Target.HasFaction then
			-- In the same faction
			if loDiploScoreObj.Actor.Faction == loDiploScoreObj.Target.Faction then
				loDiploScoreObj.Score = loDiploScoreObj.Score + 20
				
			-- Both in Faction but different factions
			elseif loDiploScoreObj.Actor.HasFaction and loDiploScoreObj.Target.HasFaction then
				loDiploScoreObj.Score = loDiploScoreObj.Score - 10
				
			-- Actor is in Faction / Target does not have faction
			elseif loDiploScoreObj.Actor.HasFaction then
				if Support_Functions.IsFriend(loDiploScoreObj.ministerAI, loDiploScoreObj.Actor.Faction, loDiploScoreObj.Target.Country) then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 5
				end
				
			-- Target is in Faction / Actor does not have faction
			elseif loDiploScoreObj.Target.HasFaction then
				if Support_Functions.IsFriend(loDiploScoreObj.ministerAI, loDiploScoreObj.Target.Faction, loDiploScoreObj.Actor.Country) then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 5
				end
			end
		end
		
		-- Land Route gets bigger bonus
		if not(loDiploScoreObj.NeedConvoy) then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 5
		end
		
		loDiploScoreObj.Score = Support_Country.Call_Score_Function(false, 'DiploScore_OfferTrade', loDiploScoreObj)
	end
	
	return loDiploScoreObj.Score
end
function EvalutateExistingTrades(voAI, voTag)
--Utils.LUA_DEBUGOUT("EvalutateExistingTrades")
	local CTradeData = {
		Custom = nil,			-- Used to store custom variables
		ministerAI = voAI,
		Tag = voTag,
		Country = voTag:GetCountry(),
		IsPuppet = false, 		-- True/False are they a Puppet Country
		IsExile	= false, 		-- True/False are the in exile
		IsNaval = false, 		-- True/False do the meet requirements to use the Naval standard file or Land
		Ideology = nil,			-- Current Ideolgoy of the country
		IdeologyGroup = nil,	-- Group the countries Ideology belongs to
		IdeologyGroupName = nil,-- Name of the ideology group (string)
		PortsTotal = 0,			-- (integer) Total amount of ports the country has
		IcOBJ = nil,			-- IC Object from Support_Functions.GetICBreakDown
		Resources = nil			-- Resource array from Support_Trade.Trade_GetResources
	}
	
	CTradeData.IcOBJ = Support_Functions.GetICBreakDown(CTradeData.Country)
	CTradeData.Resources = Support_Trade.Trade_GetResources(CTradeData.Tag, CTradeData.Country)
	CTradeData.IsExile = CTradeData.Country:IsGovernmentInExile()
	CTradeData.IsPuppet = CTradeData.Country:IsPuppet()
	CTradeData.PortsTotal = CTradeData.Country:GetNumOfPorts()
	CTradeData.IsNaval = (CTradeData.PortsTotal > 0 and CTradeData.IcOBJ.IC >= 20)
	CTradeData.Ideology = CTradeData.Country:GetRulingIdeology()
	CTradeData.IdeologyGroup = CTradeData.Ideology:GetGroup()
	CTradeData.IdeologyGroupName = tostring(CTradeData.IdeologyGroup:GetKey())
	
	-- Custom Init Call
	CTradeData.Custom = Support_Country.Call_Function(CTradeData, "TradeData_Cancel_Init", CTradeData)
	
	local laHighResource = {}
	local laShortResource = {}
	local laCancel = {}
	local lbContinue = false
	local lbBuying = false
	local liMoneyOverage = 0
	
	-- Figure out if we have a glutten of resources coming in
	for k, v in pairs(CTradeData.Resources) do
		if not(v.Bypass) then
			if v.Buy > 0 then
				lbBuying = true
			end

			-- We are buying and selling the same resource
			if v.TradeFor > 0 and v.TradeAway > 0 then
				-- Cancel something
				if v.DailyBalance > v.Buffer then
					laShortResource[k] = true
					lbContinue = true
				else
					laShortResource[k] = true
					lbContinue = true
				end
			else
				if k == "SUPPLIES" or k == "CRUDE_OIL" then
					-- If we are loosing money (give the buffer some leasticity before canceling by cutting it in half
					if CTradeData.Resources.MONEY.DailyBalance < (CTradeData.Resources.MONEY.Buffer * 0.5)
					or (v.Pool > v.BufferCancelCap) then
						if v.TradeFor > 0 then
							laHighResource[k] = true
							lbContinue = true
						end
					end
				else
					-- Gluten Check
					if v.TradeFor > 0 and v.Buy <= 0 then
						if (v.DailyBalance > v.Buffer) then
							-- If we are higher than our cancel pool or our daily balance is greater than the buffer multiplied by 2 (give some elasticity)
							if (v.Pool > v.BufferCancelCap) or (v.DailyBalance > (v.Buffer * 1.5)) then
								laHighResource[k] = true
								lbContinue = true
							end
						end
						
					-- Selling what we need check
					elseif v.TradeAway > 0 then
						if v.DailyBalance < (v.Buffer * 0.5) then
							laShortResource[k] = true
							lbContinue = true
						end
					end
				end
			end
		end
	end
	
	-- Few extra checks in case we have to much or to little money
	if not(lbContinue) then
		-- We are loosing money so look for stuff to cancel
		if CTradeData.Resources.MONEY.DailyBalance < (CTradeData.Resources.MONEY.Buffer * 0.5) then
			if CTradeData.Resources.FUEL.TradeFor > 0 then
				laHighResource["FUEL"] = true
				lbContinue = true
			end
		end	
	
		-- Supply check to see if we should cancel cause we are buying to much
		if CTradeData.Resources.MONEY.DailyBalance > (CTradeData.Resources.MONEY.Buffer * 1.5) then
			if CTradeData.Resources.SUPPLIES.TradeFor > 0 then
				if CTradeData.Resources.SUPPLIES.DailyBalance > (CTradeData.Resources.SUPPLIES.Buffer * 1.5) then
					if CTradeData.Resources.SUPPLIES.DailyBalance > (CTradeData.Resources.MONEY.Buffer) then
						laHighResource["SUPPLIES"] = true
						lbContinue = true
					end
				end
				
			-- Check to see if we are trading away to much
			elseif CTradeData.Resources.SUPPLIES.TradeAway > 0 and not(lbBuying) then
				liMoneyOverage = CTradeData.Resources.MONEY.DailyBalance - CTradeData.Resources.MONEY.Buffer
				
				if liMoneyOverage > 0 then
					laShortResource["SUPPLIES"] = true
					lbContinue = true
				end
			end
		end
	end

	-- Check to see if this country has any hook
	local loFunRef = Support_Country.Get_Function(CTradeData, "TradeData_Cancel")
	
	for loTradeRoute in CTradeData.Country:AIGetTradeRoutes() do
		local loTradeCountry = {
			Tag = loTradeRoute:GetFrom(),
			Country = nil,
			IsTradeTo = false,		-- They are the ones receiving the resource
			CapitalProvince = nil,	-- Province Object for the capital
			Continent = nil, 		-- Continent Object the capital is on
			TradOBJ = loTradeRoute
		}
		
		if loTradeCountry.Tag == CTradeData.Tag then
			loTradeCountry.Tag = loTradeRoute:GetTo()
		end
		
		-- Are they the ones responsible for this convoy?
		if loTradeRoute:GetConvoyResponsible() == loTradeCountry.Tag then
			loTradeCountry.IsTradeTo = true
		end
	
		local lbProcess = true
		
		if loFunRef then
			-- Only load this information if we have a function
			loTradeCountry.Country = loTradeCountry.Tag:GetCountry()
			loTradeCountry.CapitalProvince = loTradeCountry.Country:GetActingCapitalLocation()
			loTradeCountry.Continent = loTradeCountry.CapitalProvince:GetContinent()
			
			lbProcess = loFunRef(CTradeData, loTradeCountry)
		end
		
		if lbProcess then	
			-- Kill Inactive Trades
			if loTradeRoute:IsInactive() and CTradeData.ministerAI:HasTradeGoneStale(loTradeRoute) then
				local loTradeAction = CTradeAction(CTradeData.Tag, loTradeCountry.Tag)
				loTradeAction:SetRoute(loTradeRoute)
				loTradeAction:SetValue(false)
				
				if loTradeAction:IsSelectable() then
					CTradeData.ministerAI:PostAction(loTradeAction)
				end
				
			else
				-- If nothing to do skip this
				if lbContinue then
					for k, v in pairs(CTradeData.Resources) do
						if not(v.Bypass) then
							local Trade = {
								Trade = loTradeRoute,
								Command = nil,
								Money = 0,
								Quantity = 0}

							-- Are we short or High on anything
							if laShortResource[k] or laHighResource[k] then
								if laShortResource[k] then
									Trade.Quantity = loTradeRoute:GetTradedFromOf(v.CGoodsPool):Get()
								elseif laHighResource[k] then
									Trade.Quantity = loTradeRoute:GetTradedToOf(v.CGoodsPool):Get()
								end

								local GetTradedFromOf = loTradeRoute:GetTradedFromOf(v.CGoodsPool):Get()
								local GetTradedToOf = loTradeRoute:GetTradedToOf(v.CGoodsPool):Get()
								
								-- Look for the lowest one to cancel
								if Trade.Quantity > 0 then
									if k == "SUPPLIES" and liMoneyOverage > 0 then
										Trade.Money = loTradeRoute:GetTradedToOf(CTradeData.Resources.MONEY.CGoodsPool):Get()
										
										-- Clean up our Over selling of supplies
										if Trade.Money <= liMoneyOverage and not(laCancel[k]) then
											if not(laCancel[k]) then
												Trade.Command = CTradeAction(CTradeData.Tag, loTradeCountry.Tag)
												laCancel[k] = Trade
											else
												if laCancel[k].Money < Trade.Money then
													Trade.Command = CTradeAction(CTradeData.Tag, loTradeCountry.Tag)
													laCancel[k] = Trade
												end
											end										
										end
									elseif not(laCancel[k]) then
										Trade.Command = CTradeAction(CTradeData.Tag, loTradeCountry.Tag)
										laCancel[k] = Trade
									else
										-- Regular resource check
										if laCancel[k].Quantity > Trade.Quantity then
											Trade.Command = CTradeAction(CTradeData.Tag, loTradeCountry.Tag)
											laCancel[k] = Trade
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

	for k, v in pairs(laCancel) do
		v.Command:SetRoute(v.Trade)
		v.Command:SetValue(false)
		CTradeData.ministerAI:PostAction(v.Command)
	end
end
function ProposeTrades(vAI, voTag)

--Utils.LUA_DEBUGOUT("ProposeTrades")
	local TradeData = {
		Custom = nil,			-- Used to store custom variables
		ministerAI = vAI,
		Tag = voTag,
		Country = voTag:GetCountry(),
		IsPuppet = false, 		-- True/False are they a Puppet Country
		IsExile	= false, 		-- True/False are the in exile
		IsNaval = false, 		-- True/False do the meet requirements to use the Naval standard file or Land
		Ideology = nil,			-- Current Ideolgoy of the country
		IdeologyGroup = nil,	-- Group the countries Ideology belongs to
		IdeologyGroupName = nil,-- Name of the ideology group (string)
		IcOBJ = nil,			-- IC Object from Support_Functions.GetICBreakDown
		PortsTotal = 0,			-- (integer) Total amount of ports the country has
		Diplomats = nil,
		Resources = nil
	}
	
	-- Make sure we have a valid country to work with
	if not(Support_Functions.IsValidCountry(TradeData)) then
		return false
	end

	TradeData.IcOBJ = Support_Functions.GetICBreakDown(TradeData.Country)
	TradeData.IsExile = TradeData.Country:IsGovernmentInExile()
	TradeData.IsPuppet = TradeData.Country:IsPuppet()
	TradeData.PortsTotal = TradeData.Country:GetNumOfPorts()
	TradeData.IsNaval = (TradeData.PortsTotal > 0 and TradeData.IcOBJ.IC >= 20)
	TradeData.Ideology = TradeData.Country:GetRulingIdeology()
	TradeData.IdeologyGroup = TradeData.Ideology:GetGroup()
	TradeData.IdeologyGroupName = tostring(TradeData.IdeologyGroup:GetKey())
	TradeData.Diplomats = TradeData.Country:GetDiplomaticInfluence():Get()
	
	-- Custom Init Call
	TradeData.Custom = Support_Country.Call_Function(TradeData, "TradeData_Init", TradeData)
	
	-- Make sure we have actual diplomats before we do all this work
	-- If we are a puppet we can't initiate trades
	if (TradeData.Diplomats >= defines.diplomacy.TRADE_INFLUENCE_COST) and not(TradeData.Country:IsPuppet()) then
		TradeData.Resources = Support_Trade.Trade_GetResources(TradeData.Tag, TradeData.Country)
	
		local laTrades = {} -- Contains an array of trades we will try to execute
		local lbNeedTrades = false -- DO we need any actual Trades
		local liMinTradeAmount = 0.25 -- Another copy if this in Support_Trade.Trade_GetResources
		local liMaxTradeAmount = 50
		
		for k, v in pairs(TradeData.Resources) do
			-- Can We solve our problems by Canceling Trades
		--	if v.Buy > 0 and v.TradeAway > 0 then
		--		v.Buy = TradeData.ministerAI:EvaluateCancelTrades(v.Buy, v.CGoodsPool)
		--	end
			
			if v.Buy > 0 or v.Sell > 0 then 
				lbNeedTrades = true
			end
		end
		
		-- Performance check, skip if we have nothing to do
		if lbNeedTrades then
			for loTCountry in CCurrentGameState.GetCountries() do
				local loCountryTrade = {
					Tag = loTCountry:GetCountryTag(),
					Country = loTCountry,
					Resources = nil,
					SpamPenalty = nil,
					FreeTrade = false,
					Relation = nil
				}
				
				if loCountryTrade.Tag ~= TradeData.Tag then
					if not(TradeData.Country:HasDiplomatEnroute(loCountryTrade.Tag)) and loTCountry:Exists() then
						loCountryTrade.Relation = TradeData.ministerAI:GetRelation(TradeData.Tag, loCountryTrade.Tag)
						
						if P.Can_Click_Button(loCountryTrade, TradeData) then
							local lbProcess = true
							local loFunRef = Support_Country.Get_Function(TradeData, "TradeData_Trade")
							
							if loFunRef then
								lbProcess = loFunRef(TradeData, loCountryTrade)
							end							
						
							if lbProcess then
								loCountryTrade.Resources = Support_Trade.Trade_GetResources(loCountryTrade.Tag, loCountryTrade.Country)
								loCountryTrade.SpamPenalty = TradeData.ministerAI:GetSpamPenalty(loCountryTrade.Tag)
								loCountryTrade.FreeTrade = Support_Trade.FreeTradeCheck(TradeData.ministerAI, loCountryTrade.Tag, TradeData.Tag, loCountryTrade.Relation)
								
								for k, v in pairs(loCountryTrade.Resources) do
									if not(v.Bypass) then
										local loTrade = {
											Resource = v.CGoodsPool,
											Score = 0,
											Buy = false,
											Sell = false,
											FreeTrade = loCountryTrade.FreeTrade,
											Command = nil,
											Quantity = 0}
										
										-- They have something we need
										if v.Sell > 0 and TradeData.Resources[k].Buy > 0 then
											loTrade.Buy = true
											loTrade.Quantity = math.min(v.Sell, TradeData.Resources[k].Buy, liMaxTradeAmount)
										else
											if loCountryTrade.Resources.MONEY.DailyIncome > 0 or loCountryTrade.FreeTrade then
												-- They need something we are selling
												if v.Buy > 0 and TradeData.Resources[k].Sell > 0 then
													loTrade.Sell = true
													loTrade.Quantity = math.min(v.Buy, TradeData.Resources[k].Sell, liMaxTradeAmount)
												end
											end
										end
										
										-- Now lets gets a score
										if loTrade.Buy then
											local loCommand = CTradeAction(TradeData.Tag, loCountryTrade.Tag)
											loCommand:SetTrading(CFixedPoint(loTrade.Quantity), v.CGoodsPool)
											
											if not(TradeData.ministerAI:AlreadyTradingDisabledResource(loCommand:GetRoute())) then
												if loCommand:IsValid() and loCommand:IsSelectable() then
													local liCost = loCommand:GetTrading(CGoodsPool._MONEY_, TradeData.Tag):Get()

													if liCost > TradeData.Resources.MONEY.CanSpend and not(loCountryTrade.FreeTrade) then
														local liMultiplier = liCost / loTrade.Quantity
														loTrade.Quantity = TradeData.Resources.MONEY.CanSpend / liMultiplier
														loCommand:SetTrading(CFixedPoint(loTrade.Quantity), v.CGoodsPool)
													end
													
													if loTrade.Quantity > liMinTradeAmount then
														loTrade.Score = loCommand:GetAIAcceptance() - loCountryTrade.SpamPenalty
														
														if loTrade.Score > 50 then
															loTrade.Command = loCommand
														end
													end
												end
											end
											
										elseif loTrade.Sell then
											local loCommand = CTradeAction(TradeData.Tag, loCountryTrade.Tag)
											loCommand:SetTrading(CFixedPoint(loTrade.Quantity * -1), v.CGoodsPool)
											
											if not(TradeData.ministerAI:AlreadyTradingDisabledResource(loCommand:GetRoute())) then
												if loCommand:IsValid() and loCommand:IsSelectable() then
													local liCost = loCommand:GetTrading(CGoodsPool._MONEY_, loCountryTrade.Tag):Get()

													if liCost > loCountryTrade.Resources.MONEY.CanSpend and not(loCountryTrade.FreeTrade) then
														local liMultiplier = liCost / loTrade.Quantity
														loTrade.Quantity = loCountryTrade.Resources.MONEY.CanSpend / liMultiplier
														loCommand:SetTrading(CFixedPoint(loTrade.Quantity * -1), v.CGoodsPool)
													end

													if loTrade.Quantity > liMinTradeAmount then
														loTrade.Score = loCommand:GetAIAcceptance() - loCountryTrade.SpamPenalty

														if loTrade.Score > 50 then
															loTrade.Command = loCommand
														end
													end
												end
											end
										end
										
										-- Add it to the processing Array
										if loTrade.Command then
											laTrades[tostring(loCountryTrade.Tag) .. tostring(k)] = loTrade
										end
									end
								end
							end
						end
					end
				end
			end
			
			local loFinalTrade = nil
			-- Do we have potential trades to process
			for k, v in pairs(laTrades) do
				if not(loFinalTrade) then
					loFinalTrade = v
				else
					-- Free Trades get priority
					if v.FreeTrade then
						if not(loFinalTrade.FreeTrade) then
							loFinalTrade = v
						elseif v.Score > loFinalTrade.Score then
							loFinalTrade = v
						end
					elseif v.Score > loFinalTrade.Score then
						loFinalTrade = v
					end
				end
			end
			
			if loFinalTrade then
				TradeData.ministerAI:PostAction(loFinalTrade.Command)
			end
		end
	end
end

-- #######################
-- Support Methods
-- #######################
function P.Trade_GetResources(voTag, voCountry, vbHumanSelling)
	--Utils.LUA_DEBUGOUT("Trade_GetResources")
	local liMinTradeAmount = 0.25
	local liDaysResource = 30	-- Minimum amount of days to store the resource before selling
	local ResourceData = {
		Tag = voTag,
		Country = voCountry,
		IsPuppet = nil, 		-- True/False are they a Puppet Country
		IsExile	= nil, 			-- True/False are the in exile
		IsNaval = nil, 			-- True/False do the meet requirements to use the Naval standard file or Land
		Ideology = nil,			-- Current Ideolgoy of the country
		IdeologyGroup = nil,	-- Group the countries Ideology belongs to
		IdeologyGroupName = nil,-- Name of the ideology group (string)
		IcOBJ = Support_Functions.GetICBreakDown(voCountry),
		PortsTotal = nil,		-- (integer) Total amount of ports the country has
		TechStatus = nil,
		ModifierICTech = nil,
		ModifierICGlobal = nil
	}

	local laResouces = {
		MONEY = {
			ByPass = true,
			Buffer = 0.1,
			BufferSaleCap = 20, 
			TradeOBJ = "vMoney",
			CGoodsPool = CGoodsPool._MONEY_
		},
		METAL = {
			Buffer = 1, 			-- Amount extra to keep abouve our needs
			BufferSaleCap = (ResourceData.IcOBJ.TotalIC * liDaysResource), 	-- Amount we need in reserve before we sell the resource
			BufferBuyCap = 80000, 	-- Amount we need before we stop actively buying (existing trades are NOT cancelled)
			BufferCancelCap = 90000, -- Amount we need before we cancel trades simply because we have to much
			ScoreFactor = 2, 		-- Multiplier used when calculating the final trade score against the resource (resource count * ScoreFactor)
			Multiplier = 1, 		-- (DO NOT OVERIDE THIS IN COUNTRY FILES)
			TradeOBJ = "vMetal",	-- (DO NOT OVERIDE THIS IN COUNTRY FILES)
			CGoodsPool = CGoodsPool._METAL_, -- (DO NOT OVERIDE THIS IN COUNTRY FILES)
			Cost = defines.goods_cost.METAL	-- (DO NOT OVERIDE THIS IN COUNTRY FILES)
		},
		ENERGY = {
			Buffer = 5,
			BufferSaleCap = ((ResourceData.IcOBJ.TotalIC * 2) * liDaysResource),
			BufferBuyCap = 80000,
			BufferCancelCap = 90000,
			ScoreFactor = 1,
			Multiplier = 2, 		-- Factor to use to calculate needs
			TradeOBJ = "vEnergy",
			CGoodsPool = CGoodsPool._ENERGY_,
			Cost = defines.goods_cost.ENERGY
		},
		RARE_MATERIALS = {
			Buffer = 0.5,
			BufferSaleCap = ((ResourceData.IcOBJ.TotalIC * .5) * liDaysResource),
			BufferBuyCap = 80000,
			BufferCancelCap = 90000,
			ScoreFactor = 4,
			Multiplier = 0.5, 		-- Factor to use to calculate needs
			TradeOBJ = "vRareMaterials",
			CGoodsPool = CGoodsPool._RARE_MATERIALS_,
			Cost = defines.goods_cost.RARE_MATERIALS
		},
		CRUDE_OIL = {
			BuyOveride = true,
			Buffer = 0.25,
			BufferSaleCap = (ResourceData.IcOBJ.TotalIC * liDaysResource),
			BufferBuyCap = 80000,
			BufferCancelCap = 90000,
			ScoreFactor = 2,
			TradeOBJ = "vCrudeOil",
			CGoodsPool = CGoodsPool._CRUDE_OIL_,
			Cost = defines.goods_cost.CRUDE_OIL
		},
		SUPPLIES = {
			BuyOveride = true,
			Buffer = 1,
			BufferSaleCap = 5000, -- Ignored for supplies
			BufferBuyCap = 80000,
			BufferCancelCap = 90000,
			ScoreFactor = 3,
			TradeOBJ = "vSupplies",
			CGoodsPool = CGoodsPool._SUPPLIES_,
			Cost = defines.goods_cost.SUPPLIES
		},
		FUEL = {
			BuyOveride = true,
			Buffer = 0.25,
			BufferSaleCap = ((ResourceData.IcOBJ.TotalIC * 2) * liDaysResource),
			BufferBuyCap = 80000,
			BufferCancelCap = 90000,
			ScoreFactor = 3,
			TradeOBJ = "vFuel",
			CGoodsPool = CGoodsPool._FUEL_,
			Cost = defines.goods_cost.FUEL
		}
	}

	-- Special setup for countries over 50 IC which can be overiden in country file
	if ResourceData.IcOBJ.IC > 50 then
		-- Makes them sell supplies so they can buy what they need
		laResouces.CRUDE_OIL.BuyOveride = false
		laResouces.FUEL.BuyOveride = false
	end

	ResourceData.IsExile = ResourceData.Country:IsGovernmentInExile()
	ResourceData.IsPuppet = ResourceData.Country:IsPuppet()
	ResourceData.PortsTotal = ResourceData.Country:GetNumOfPorts()
	ResourceData.IsNaval = (ResourceData.PortsTotal > 0 and ResourceData.IcOBJ.IC >= 20)
	ResourceData.Ideology = ResourceData.Country:GetRulingIdeology()
	ResourceData.IdeologyGroup = ResourceData.Ideology:GetGroup()
	ResourceData.IdeologyGroupName = tostring(ResourceData.IdeologyGroup:GetKey())
	ResourceData.TechStatus = ResourceData.Country:GetTechnologyStatus()
	ResourceData.ModifierICTech = ResourceData.TechStatus:GetIcModifier():Get()
	ResourceData.ModifierICGlobal = ResourceData.Country:GetGlobalModifier():GetValue(CModifier._MODIFIER_GLOBAL_IC_):Get()

	local loFunRef = Support_Country.Get_Function(ResourceData, "TradeWeights")
	
	if loFunRef then
		local laResourcePassed = loFunRef(ResourceData)
		
		if laResourcePassed then
			for k, v in pairs(laResourcePassed) do
				for x, y in pairs(laResourcePassed[k]) do
					laResouces[k][x] = laResourcePassed[k][x]
				end
			end
		end
	end
			
	local lbBuying = false
	local loResource = CResourceValues()
	local loTradeAway = ResourceData.Country:GetTradedAwaySansAlliedSupply()
	local loTradeFor = ResourceData.Country:GetTradedForSansAlliedSupply()
	local liMoneyNeeded = 0

	for k, v in pairs(laResouces) do
		loResource:GetResourceValues(ResourceData.Country, v.CGoodsPool)
		v.DailyBalance = loResource.vDailyBalance
		v.DailyExpense = loResource.vDailyExpense -- Modify this to use IC to count expense not resources
		v.DailyIncome = loResource.vDailyIncome
		v.DailyHome = P.CalculateHomeProduced(loResource)
		v.Pool = loResource.vPool
		
		-- If we have a multiplier then check
		if v.Multiplier then
			-- This is to handle in case resources hit 0 so the AI knows it needs allot more
			v.DailyExpense = math.max(v.DailyExpense, (v.Multiplier * ResourceData.IcOBJ.IC))
			v.DailyBalance = v.DailyIncome - v.DailyExpense
		end
		
		v.Buy = 0
		v.Sell = 0
		v.TradeAway = 0
		v.TradeFor = 0
		v.ShortPercentage = 0
		
		-- Now Calculate what our needs are
		if not(v.ByPass) then
			v.TradeFor = loTradeFor:GetFloat(v.CGoodsPool)
			v.TradeAway = loTradeAway:GetFloat(v.CGoodsPool)
			
			if v.DailyBalance < v.Buffer and v.TradeAway <= 0 then
				-- Make sure we are not being a gluten with the resources before we buy
				if v.Pool < v.BufferBuyCap then
					local liBuy = (v.DailyBalance  * -1) + v.Buffer
					if liBuy >= liMinTradeAmount then
						v.Buy = liBuy
						
						if not(v.BuyOveride) then
							lbBuying = true

							-- Only count priority resources
							if v.Cost then
								liMoneyNeeded = liMoneyNeeded + (v.Buy * v.Cost)
							end
						end
					end
				end
			elseif v.DailyBalance > v.Buffer then
				if (v.TradeFor <= 0 or vbHumanSelling) and (v.Pool > v.BufferSaleCap) then
					v.Sell = v.DailyBalance - v.Buffer
				end
			end
		end
		
		-- Calculate Short Percentage
		if v.Buy > 0 and v.DailyIncome > 0 and v.DailyExpense > 0 then
			v.ShortPercentage = (1.0 - (v.DailyIncome / v.DailyExpense))
		elseif v.Buy > 0 then
			v.ShortPercentage = 1.0
		end
	end
	
	laResouces.MONEY.CanSpend = laResouces.MONEY.DailyBalance - laResouces.MONEY.Buffer
	
	-- Crude oil needs check, makes sure we don't buy crude and instead spend cash on supplies
	if laResouces.CRUDE_OIL.Buy > 0 then
		if (laResouces.FUEL.DailyBalance > laResouces.FUEL.Buffer
		and laResouces.CRUDE_OIL.DailyHome > (laResouces.FUEL.DailyBalance * 0.5)
		and laResouces.FUEL.Pool > laResouces.FUEL.BufferSaleCap)
		or lbBuying then
			laResouces.CRUDE_OIL.Buy = 0
		end
	end
	
	-- We are buying but short on money so setup Supply selling
	if lbBuying and laResouces.MONEY.DailyBalance <= laResouces.MONEY.Buffer and laResouces.SUPPLIES.TradeFor <= 0 then
		laResouces.SUPPLIES.Buy = 0
		laResouces.SUPPLIES.Sell = math.min(20, (liMoneyNeeded / laResouces.SUPPLIES.Cost))
		laResouces.SUPPLIES.ShortPercentage = 1.0
		
	-- We are not buying and have money to spend to pick up supplies
	elseif not(lbBuying) and laResouces.MONEY.DailyBalance > laResouces.MONEY.Buffer and laResouces.SUPPLIES.TradeAway <= 0 then 
		laResouces.SUPPLIES.Sell = 0
		laResouces.SUPPLIES.Buy = math.min(20, ((laResouces.SUPPLIES.DailyExpense * 1.2) - laResouces.SUPPLIES.TradeFor))
		laResouces.SUPPLIES.ShortPercentage = 1.0
		
	-- Not buying or selling supplies so set it to 0
	else
		laResouces.SUPPLIES.Buy = 0
		laResouces.SUPPLIES.Sell = 0
	end	
	
	return laResouces
end
function P.FreeTradeCheck(voAI, voToTag, voFromTag, voRelation)
		--Utils.LUA_DEBUGOUT("FreeTradeCheck")
	-- Commiterm Check or ALlow Debt check
	if voAI:CanTradeFreeResources(voToTag, voFromTag) or voRelation:AllowDebts() then
		return true
	else
		return false
	end
end
function P.Can_Click_Button(voTarget, voTradeData)
	--Utils.LUA_DEBUGOUT("Can_Click_Button")
	if voTarget.Country:Exists() then
		if voTarget.Tag:IsReal() then
			if voTarget.Tag:IsValid() then
				if not(voTarget.Country:IsPuppet()) or voTarget.Country:GetOverlord() == voTradeData.Tag then
					if not(voTarget.Relation:HasWar()) then
						if not(voTradeData.Country:HasDiplomatEnroute(voTarget.Tag)) then
							return true
						end
					end
				end
			end
		end
	end
	
	return false
end

function P.CalculateHomeProduced(loResource)
	--Utils.LUA_DEBUGOUT("CalculateHomeProduced")
	local liDailyHome = loResource.vDailyHome
	
	if loResource.vConvoyedIn > 0 then
		-- If the Convoy in exceeds Home Produced by 10% it means they have a glutten coming in or
		--   are a sea bearing country like ENG or JAP
		--   so go ahead and count this as home produced up to 90% of it just in case something happens!
		if liDailyHome > loResource.vDailyExpense then
			liDailyHome = liDailyHome + loResource.vConvoyedIn
		else
			liDailyHome = liDailyHome + (loResource.vConvoyedIn * 0.9)
		end
	end	
	
	return liDailyHome
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return Support_Trade