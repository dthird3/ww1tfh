-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany Default File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------

local P = {}
AI_FRA = P

-- #######################################
-- TRADE Weights
function P.TradeWeights(voResourceData)
	local laResouces = {
	
		METAL = {
			Buffer = 10, 			-- Amount extra to keep abouve our needs
			BufferSaleCap = 90000, 	-- Amount we need in reserve before we sell the resource
			BufferBuyCap = 20000, 	-- Amount we need before we stop actively buying (existing trades are NOT cancelled)
			BufferCancelCap = 80000 -- Amount we need before we cancel trades simply because we have to much
		},
		RARE_MATERIALS = {
			Buffer = 10,
			BufferSaleCap = 90000,
			BufferBuyCap = 20000,
			BufferCancelCap = 80000},
		ENERGY = {
			Buffer = 10,
			BufferSaleCap = 50000,
			BufferBuyCap = 20000,
			BufferCancelCap = 40000},
		CRUDE_OIL = {
			Buffer = 1,
			BufferSaleCap = 5000},
		SUPPLIES = {
			BuyOveride = true,
			Buffer = 1,
			BufferSaleCap = 5000, -- Ignored for supplies
			BufferBuyCap = 80000,
			BufferCancelCap = 90000},
		FUEL = {
			Buffer = 2,
			BufferSaleCap = 5000}}
	
	return laResouces
end



-- #######################################
-- TECH RESEARCH
function P.TechList(voTechnologyData)
	local loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Land')

	-- Super High Priority to get regular Tanks fast
	if loPreferTech['lighttank_brigade'] then
		if loPreferTech['lighttank_brigade'].Priority > 0 then
			loPreferTech['lighttank_brigade'].Priority = 1000
		end
	end
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
		"alpins_brigade"}
	
	return laUnits	
end
function P.FirePower(voProductionData)
	local laArray = {
		"alpins_brigade",
		"armor_brigade"}
		
	return laArray
end
function P.AirRatio(voProductionData)
	local laArray = Prod_Air.RatioGenerator(voProductionData)
	
	return laArray
end
function P.NavalRatio(voProductionData)
	local laArray = Prod_Sea.RatioGenerator(voProductionData)
	laArray = Prod_Land.RatioReplace(laArray, "coastal_submarine", 0)
	laArray = Prod_Land.RatioReplace(laArray, "submarine", 0.1)
	laArray = Prod_Land.RatioReplace(laArray, "longrange_submarine", 0.1)

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
					2309,  -- Lille
2422,  -- Cherbourg
2425,  -- Amiens
2550,  -- Reims
2605,  -- Quimper
2613,  -- Paris
2682,  -- StMihiel
2683,  -- Nancy
2746,  -- Troyes
2812,  -- Neufchateau
2870,  -- Nantes
3077,  -- Bourges
3149,  -- Montbeliard
3215,  -- Gray
3351,  -- Besancon
3479,  -- Bordeaux
3484,  -- Vichy
3687,  -- Lyon
3959,  -- Pau
3961,  -- Toulouse
4229,  -- Marseille
4230,  -- Toulon
4486,  -- Ajaccio
5134,  -- Tunis
5160,  -- Alger
5292,  -- Oran
5916,  -- Hanoi
6236,  -- Saigon
9741,  -- Dakar
9968,  -- Abidjan
					5412} -- Casablanca
			},
			anti_air = {
				Build = (voProductionData.Year > 1937)
			},
			land_fort = {
				Build = (voProductionData.Year > 1937)
			}
		}
	}
	
	if voProductionData.Year > 1914 then
		loProdBuilding.Buildings.land_fort.MaxRun = 1
	end
	
	return loProdBuilding
end

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		CAN = {Score = 20},
		AST = {Score = 20},
		SAF = {Score = 20},
		NZL = {Score = 20},
		USA = {Score = 20},
		GRE = {Score = 200},
		GER = {Score = -20},
		ITA = {Score = -20},
		JAP = {Score = 50},
		FRA = {Score = 20}}
	
	if laTrade[voDiploScoreObj.Actor.Name] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.Actor.Name].Score
	end
	
	return voDiploScoreObj.Score
end

-- #######################################
-- SUPPORT METHODS
-- Setup_Custom is called from GER_FAC.lua and GER.lua

return AI_FRA
