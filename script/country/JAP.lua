-----------------------------------------------------------
-- LUA Hearts of Iron 3 Japan File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 12/10/2013
-----------------------------------------------------------
local P = {}
AI_JAP = P

-- #######################################
-- TRADE Weights
function P.TradeWeights(voResourceData)
	local laResouces = {
		METAL = {
			Buffer = 2,
			BufferSaleCap = 10000},
		ENERGY = {
			BufferSaleCap = 10000},
		RARE_MATERIALS = {
			Buffer = 5,
			BufferSaleCap = 10000},
		CRUDE_OIL = {
			Buffer = 1,
			BufferSaleCap = 40000},
		FUEL = {
			Buffer = 12,
			BufferSaleCap = 90000}}
	
	return laResouces
end

-- #######################################
-- TRADE

-- #######################################
-- CANCEL TRADE

-- #######################################
-- TECH RESEARCH
function P.TechList(voTechnologyData)
	return Support_Tech.TechGenerator(voTechnologyData, 'Sea')
end

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

-- #######################################
-- AI Sliders

-- #######################################
-- PRODUCTION Section
function P.ProductionWeights(voProductionData)
	local laArray = {
		0.50, -- Land
		0.15, -- Air
		0.32, -- Sea
		0.03} -- Other

	-- Check to see if manpower is to low
	if voProductionData.Manpower.Total < 200 then
		laArray = {
			0.0, -- Land
			0.45, -- Air
			0.50, -- Sea
			0.05} -- Other
	end
	
	return laArray
end
function P.LandRatio(voProductionData)
	local laArray = Prod_Land.RatioGenerator(voProductionData)

	return laArray
end
function P.SpecialForcesRatio(voProductionData)
	local laUnits = nil
	local laRatio = {
		15, -- Land
		1} -- Special Force Unit
	
		laUnits = {
			bergsjaeger_brigade = 1,
			marine_brigade = 9
		}

	-- Returning a nul for laUnits means no Special forces will be built
	return laRatio, laUnits
end
function P.EliteUnits(voProductionData)
	local laUnits = {
		"imperial_brigade",
	}

	return laUnits	
end
function P.FirePower(voProductionData)
	local laArray = {
		"imperial_brigade",
		"infantry_brigade"
	}

	return laArray
end
function P.AirRatio(voProductionData)
	local laArray = Prod_Air.RatioGenerator(voProductionData)
	laArray = Prod_Land.RatioReplace(laArray, "cas", 2)
	
	return laArray
end
function P.NavalRatio(voProductionData)
	local laArray = Prod_Sea.RatioGenerator(voProductionData)
	laArray = Prod_Land.RatioReplace(laArray, "escort_carrier", 3)

	return laArray
end
function P.TransportLandRatio(voProductionData)
	local laArray = {
		35, -- Land
		1,  -- transport
		0.25}  -- invasion craft
  
	return laArray
end
function P.ConvoyRatio(voProductionData)
	local laArray = {
		10, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		100, -- If Percentage extra is less than this it will force it up to the amount entered
		200, -- If Percentage extra is greater than this it will force it down to this
		5} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end
function P.Buildings(voProductionData)
	local loProdBuilding = {
		Buildings = {
			industry = {
				Build = (voProductionData.Year > 1941)
			},
			coastal_fort = {
				Build = (voProductionData.Year > 1941)
			},
			air_base = {
				Build = (voProductionData.Year > 1910)
			},
			naval_base = {
				Build = (voProductionData.Year > 1941)
			},
			anti_air = {
				Build = (voProductionData.Year > 1941)
			},
			infra = {
				Build = (voProductionData.Year > 1941)
			},
			land_fort = {
				Build = (voProductionData.Year > 1941)
			}
		}
	}
	
	return loProdBuilding
end

-- #######################################
-- POLITICS MINISTER

-- #######################################
-- FOREIGN MINISTER

-- #######################################
-- DIPLOMACY SCORE GENERATION

-- #######################################
-- SUPPORT METHODS


return AI_JAP
