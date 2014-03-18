-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany Default File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------

local P = {}
AI_GER = P

-- #######################################
-- TRADE Weights
function P.TradeWeights(voResourceData)
	local laResouces = {
	
		METAL = {
			Buffer = 3, 			-- Amount extra to keep abouve our needs
			BufferSaleCap = 50000, 	-- Amount we need in reserve before we sell the resource
			BufferBuyCap = 40000, 	-- Amount we need before we stop actively buying (existing trades are NOT cancelled)
			BufferCancelCap = 45000 -- Amount we need before we cancel trades simply because we have to much
		},
		RARE_MATERIALS = {
			Buffer = 5,
			BufferSaleCap = 95000,
			BufferBuyCap = 80000,
			BufferCancelCap = 90000},
		CRUDE_OIL = {
			Buffer = 1,
			BufferSaleCap = 40000},
		FUEL = {
			Buffer = 8,
			BufferSaleCap = 90000}}
	
	return laResouces
end



-- #######################################
-- TECH RESEARCH
function P.TechList(voTechnologyData)
	local loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Land')

	-- Super High Priority to get regular Tanks fast
	if loPreferTech['tank_brigade'] then
		if loPreferTech['tank_brigade'].Priority > 0 then
			loPreferTech['tank_brigade'].Priority = 1000
		end
	end

	return loPreferTech
end

-- #######################################
-- PRODUCTION Section


function P.SliderWeights(voProdSliders)
		--PriorityOrder = {
			--[0] = { 'Consumer', 'Supply', 'LendLease', 'Reinforce', 'Production', 'Upgrade' },
			--[1] = { 'Consumer', 'Supply', 'LendLease', 'Production', 'Reinforce', 'Upgrade' },
			--[2] = { 'Consumer', 'Supply', 'LendLease', 'Upgrade', 'Reinforce', 'Production' },
			--[3] = { 'Consumer', 'Supply', 'LendLease', 'Reinforce', 'Upgrade', 'Production' },
			--[4] = { 'Consumer', 'Reinforce', 'Supply', 'LendLease', 'Production', 'Upgrade' }
		--},
	
	local laSliders = voProdSliders.PrioSelected.Ori

	if voProdSliders.HasReinforceBonus then
		laSliders = 4
	elseif voProdSliders.Year >= 1914 or voProdSliders.IsAtWar or ( voProdSliders.Year == 1913 and voProdSliders.Month >= 7 ) then
		laSliders = 0
	else
		laSliders = 1
	end

	return laSliders 
end


function P.ProductionWeights(voProductionData)
	local laArray = {
		0.55, -- Land
		0.10, -- Air
		0.15, -- Sea
		0.20} -- Other
	if voProductionData.IsAtWar then
		laArray = {
			0.80, -- Land
			0.10, -- Air
			0.05, -- Sea
			0.05} -- Other
	end
		
		
	-- Check to see if manpower is to low
	-- More than 20 brigades build stuff that does not use manpower
	if (voProductionData.Manpower.Total < 500 and voProductionData.Units.Counts.Land > 100)
	or voProductionData.Manpower.Total < 300 then
		laArray = {
			0.05, -- Land
			0.30, -- Air
			0.30, -- Sea
			0.35} -- Other	
	end
	
	return laArray
end
function P.SpecialForcesRatio(voProductionData)
	local laRatio = {
			35, -- Land
			1} -- Special Force Unit

	local laUnits = { bergsjaeger_brigade = 3 }
	
	return laRatio, laUnits
end
function P.EliteUnits(voProductionData)
	local laUnits = {
		"waffen_brigade"}
	
	return laUnits	
end
function P.FirePower(voProductionData)
	local laArray = {
		"waffen_brigade",
		"armor_brigade"}
		
	return laArray
end
function P.AirRatio(voProductionData)
	local laArray = Prod_Air.RatioGenerator(voProductionData)
	laArray = Prod_Land.RatioReplace(laArray, "airship", 0.25)
	
	return laArray
end
function P.NavalRatio(voProductionData)
	local laArray = Prod_Sea.RatioGenerator(voProductionData)
	laArray = Prod_Land.RatioReplace(laArray, "submarine", 6)

	return laArray
end
function P.TransportLandRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "TransportLandRatio")
	local laArray = {
		100, -- Land
		1,  -- transport
		0}  -- invasion craft

  
	return laArray
end
function P.ConvoyRatio(voProductionData)
	local laArray = {
		0, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		0, -- If Percentage extra is less than this it will force it up to the amount entered
		30, -- If Percentage extra is greater than this it will force it down to this
		50} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end
function P.Buildings(voProductionData)
	local loProdBuilding = {
		Buildings = {
			coastal_fort = {
				Build = (voProductionData.Year > 1938)
			},
			industry = {
				Build = (voProductionData.Year > 1940)
			},
			infra = {
				Build = (voProductionData.Year > 1937)
			},
			naval_base = {
				Build = (voProductionData.Year > 1940)
			},
			air_base = {
				PreferMaxLevel = 2,
				MaxRun = 3,
				PreferList = {
					1306, -- Memel
					1626, -- Danzig
					1866, -- Torun
					1924, -- Poznan
					1980, -- Metz
					14160, -- Euskirchen
					1527, -- Konigsberg
					1570, -- Wilhelmshaven
					1572, -- Kiel
					1736, -- Bremen
					1740, -- Rostock
					1742, -- Stettin
					1857, -- Hannover
					1861, -- Berlin
					1920, -- Potsdam
					2027, -- Ludinghausen
					2085, -- Recklinghausen
					2093, -- Cottbus
					2142, -- Dusseldorf
					2145, -- Kassel
					2153, -- Breslau
					2257, -- Koln
					2371, -- Bitburg
					2374, -- FrankfurtamMain
					2433, -- Darmstadt
					2687, -- Stuttgart
					2952} -- Munchen
			},
			anti_air = {
				Build = (voProductionData.Year > 1937)
			},
			land_fort = {
				PreferMaxLevel = 2,
				MaxRun = 3,
				PreferList = {
					3150, -- Mulhouse
					3083, -- Colmar
					2947, -- selestad
					2815, -- strasburg
					2814, -- schirmeck
					2684, -- sarreguemines
					2618} -- metz
			}
		}
	}
	
	if voProductionData.Year > 1914 then
		loProdBuilding.Buildings.land_fort.MaxRun = 1
	end
	
	return loProdBuilding
end
-- #######################################
-- SUPPORT METHODS
-- Setup_Custom is called from GER_FAC.lua and GER.lua
function P.DiploScore_Alliance(voDiploScoreObj)
	-- Stay out of the war, we do not care whats happening around us
	local loTag = CCountryDataBase.GetTag("ITA")
	if voDiploScoreObj.Target.Tag == loTag or voDiploScoreObj.Actor.Tag == loTag  then
		voDiploScoreObj.Score = 200
	end
	
	return voDiploScoreObj.Score
end
function P.ForeignMinister_EvaluateDecision(voDecision)
	local loDecisions = {
		vs_plan = {Year = 1914, Month = 7, Day = 20, War = true, Country = "FRA", Score = 100 }}

	if loDecisions[voDecision.Name] then
		if (voDecision.Year == loDecisions[voDecision.Name].Year
		and voDecision.Month >= loDecisions[voDecision.Name].Month
		and voDecision.Day >= loDecisions[voDecision.Name].Day )
		or
		(voDecision.Year == loDecisions[voDecision.Name].Year
		and voDecision.Month > loDecisions[voDecision.Name].Month)
		or
		(voDecision.Year > loDecisions[voDecision.Name].Year) then
			if loDecisions[voDecision.Name].War then
				ForeignMinister_War.PrepareWarDecision(CCountryDataBase.GetTag(loDecisions[voDecision.Name].Country), voDecision, 100)
			else
				return loDecisions[voDecision.Name].Score
			end
		else
			return 0
		end
	end
	
	return voDecision.Score
end

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		CAN = {Score = -20},
		AST = {Score = -20},
		ENG = {Score = -20},
		SAF = {Score = -20},
		NZL = {Score = -20},
		TUR = {Score = 40},
		AUH = {Score = 60},
		HOL = {Score = 100},
		ITA = {Score = -20},
		JAP = {Score = -50},
		FRA = {Score = -50}}
	
	if laTrade[voDiploScoreObj.Actor.Name] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.Actor.Name].Score
	end
	
	return voDiploScoreObj.Score
end

return AI_GER
