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
function P.ProductionWeights(voProductionData)
	local laArray = {
		0.65, -- Land
		0.10, -- Air
		0.15, -- Sea
		0.10} -- Other
		
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
				Build = (voProductionData.Year > 1913)
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

return AI_GER
