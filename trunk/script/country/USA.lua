-----------------------------------------------------------
-- LUA Hearts of Iron 3 USA File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/26/2013
-----------------------------------------------------------

local P = {}
AI_USA = P

-- #######################################
-- TECH RESEARCH
function P.TechFolderOrder(voTechnologyData)
	local laArray = {
		'infantry_folder', 
		'industry_folder',
		'armour_folder',
		'smallship_folder',
		'capitalship_folder',
		'fighter_folder',
		'land_doctrine_folder',
		'bomber_folder',
		'air_doctrine_folder',
		'naval_doctrine_folder',
		'secretweapon_folder',
		'theory_folder'};
	
	return laArray
end
function P.TechList(voTechnologyData)
	return Support_Tech.TechGenerator(voTechnologyData, 'Mixed')
end

-- #######################################
-- AI Sliders

-- #######################################
-- PRODUCTION Section
function P.ProductionWeights(voProductionData)

	-- Set the default in the array incase no condition is met
	local laArray = {
			0.35, -- Land
			0.20, -- Air
			0.45, -- Sea
			0.05}; -- Other	         
	
	-- Not atwar so
	if voProductionData.Year < 1915 and not(voProductionData.IsAtWar) then
		laArray = {
			0.05, -- Land
			0.20, -- Air
			0.40, -- Sea
			0.35 -- Other	
		}
	end
	if voProductionData.Manpower.Total < 100 then
		laArray = {
			0.00, -- Land
			0.40, -- Air
			0.40, -- Sea
			0.20 -- Other	
		}
	end
	
	return laArray
end
function P.LandRatio(voProductionData)
	local laArray = Prod_Land.RatioGenerator(voProductionData)
	
	if voProductionData.Year < 1915 and not(voProductionData.IsAtWar) then
		laArray = Prod_Land.RatioReplace(laArray, "garrison_brigade", 2)
		laArray = Prod_Land.RatioReplace(laArray, "infantry_brigade", 1)
		laArray = Prod_Land.RatioReplace(laArray, "armor_brigade", 0)
	else
		laArray = Prod_Land.RatioReplace(laArray, "armor_brigade", 1.5)
	end
	
	return laArray
end
function P.SpecialForcesRatio(voProductionData)
	local laRatio = {
		10, -- Land
		1 -- Special Force Unit
	}

	local laUnits = {
		marine_brigade = 1,
		bergsjaeger_brigade = 2
	}
	
	return laRatio, laUnits	
end
function P.EliteUnits(voProductionData)
	local laUnits = {
		"ranger_brigade"};
	
	return laUnits	
end
function P.FirePower(voProductionData)
	local laArray = {
		"ranger_brigade",
		"infantry_brigade"
	}
		
	return laArray
end
function P.AirRatio(voProductionData)
	local laArray = Prod_Air.RatioGenerator(voProductionData)
	
	return laArray
end
function P.NavalRatio(voProductionData)
	local laArray = Prod_Sea.RatioGenerator(voProductionData)
	laArray = Prod_Land.RatioReplace(laArray, "escort_carrier", 0)

	return laArray
end
function P.TransportLandRatio(voProductionData)
	local laArray = {
		12, -- Land
		1,  -- transport
		0.25}  -- invasion craft
  
	return laArray
end
function P.ConvoyRatio(voProductionData)
	local laArray = {
		10, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		150, -- If Percentage extra is less than this it will force it up to the amount entered
		250, -- If Percentage extra is greater than this it will force it down to this
		5} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end
function P.Buildings(voProductionData)
	local loProdBuilding = {
		UseRandom = (voProductionData.Year > 1940 or voProductionData.IsAtWar),
		Buildings = {
			rocket_test = { Priority = 1 },
			land_fort = {
				Priority = 8,
				Build = (voProductionData.Year > 1943)
			},
			industry = { 
				Priority = 6,
				MaxRun = 10,
			},
			infra = {
				Priority = 8,
				Build = (voProductionData.Year > 1940)
			},
			anti_air = {
				Priority = 7,
				Build = (voProductionData.Year > 1940),
				NonCoreOnly = true
			},
			air_base = {
				Priority = 2,
				Build = (voProductionData.Year > 1913),
				NonCoreOnly = true,
				PreferMaxLevel = 4,
				MaxRun = 3
			},
			naval_base = {
				Priority = 4,
				Build = (voProductionData.Year > 1938),
				NonCoreOnly = true,
				PreferMaxLevel = 7,
				MaxRun = 3,
				PreferOnly = true,
				PreferList = {
					10669, -- Midway
					5825, -- Honolulu
					5712, -- AmamiOshima
					5720, -- TokunoShima
					5748, -- Nago
					5759, -- Naha
					10642, -- Iwo Jima
					14129, -- Bonin Islands
					10664} -- Wake island
			},
			radar_station = {
				Priority = 1,
				Build = (voProductionData.Year > 1938),
				NonCoreOnly = true,
				PreferMaxLevel = 10,
				MaxRun = 3,
				PreferOnly = true,
				PreferList = {
					7637, -- Guantanamo
					4900, -- Norfolk
					10669, -- Midway
					5825, -- Honolulu
					5712, -- AmamiOshima
					5720, -- TokunoShima
					5748, -- Nago
					5759, -- Naha
					10642, -- Iwo Jima
					14129, -- Bonin Islands
					10664} -- Wake island
			}
		}
	}
	
	if voProductionData.Year > 1915 or voProductionData.IsAtWar then
		loProdBuilding.Buildings.air_base.MaxRun = 2
		loProdBuilding.Buildings.naval_base.MaxRun = 1
		loProdBuilding.Buildings.industry.MaxRun = 1
	end	
	
	if voProductionData.Year > 1916 or voProductionData.IsAtWar then
		loProdBuilding.Buildings.air_base.PreferOnly = false
		loProdBuilding.Buildings.naval_base.PreferOnly = false
	end
	
	return loProdBuilding
end

-- #######################################
-- FOREIGN MINISTER

-- #######################################
-- DIPLOMACY SCORE GENERATION

return AI_USA

