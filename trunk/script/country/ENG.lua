-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany Default File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------

local P = {}
AI_ENG = P

-- #######################################
-- TRADE Weights
function P.TradeWeights(voResourceData)
	local laResouces = {
	
		METAL = {
			Buffer = 1, 			-- Amount extra to keep abouve our needs
			BufferSaleCap = 10000, 	-- Amount we need in reserve before we sell the resource
			BufferBuyCap = 5000, 	-- Amount we need before we stop actively buying (existing trades are NOT cancelled)
			BufferCancelCap = 8000 -- Amount we need before we cancel trades simply because we have to much
		},
		RARE_MATERIALS = {
			Buffer = 1,
			BufferSaleCap = 10000,
			BufferBuyCap = 5000,
			BufferCancelCap = 8000},
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
	local loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Sea')

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
		0.20, -- Land
		0.10, -- Air
		0.30, -- Sea
		0.40} -- Other
	if voProductionData.IsAtWar then
		laArray = {
			0.40, -- Land
			0.10, -- Air
			0.45, -- Sea
			0.05} -- Other
	end
		
		
	-- Check to see if manpower is to low
	-- More than 20 brigades build stuff that does not use manpower
	if (voProductionData.Manpower.Total < 100 and voProductionData.Units.Counts.Land > 50)
	or voProductionData.Manpower.Total < 500 then
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
			20, -- Land
			1} -- Special Force Unit

	local laUnits = { marine_brigade = 1,
		bergsjaeger_brigade = 1 }
	
	return laRatio, laUnits
end
function P.EliteUnits(voProductionData)
	local laUnits = {
		"gurkha_brigade"}
	
	return laUnits	
end
function P.FirePower(voProductionData)
	local laArray = {
		"gurkha_brigade",
		"infantry_brigade",
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
	local laArray = {
		20, -- Land
		1,  -- transport
		0.25}  -- invasion craft
  
	return laArray
end
function P.ConvoyRatio(voProductionData)
	local laArray = {
		10, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		50, -- If Percentage extra is less than this it will force it up to the amount entered
		150, -- If Percentage extra is greater than this it will force it down to this
		10} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end
function P.Buildings(voProductionData)
	local loProdBuilding = {
		Buildings = {
			coastal_fort = {
				Build = (voProductionData.Year > 1938)
			},
			industry = {
				Build = (voProductionData.Year <= 1914 and not(voProductionData.YearIsAtWar) ),
				PreferOnly = true,
				PreferList = {
1787, 
1728, 
1128, 
1127, 
1341, 
1255, 
2018, 
1522, 
1567, 
1524, 
1478, 
2078, 
2079, 
2021, 
2250, 
1053, 
1729, 
1731} 
			},
			infra = {
				Build = (voProductionData.Year > 1937)
			},
			naval_base = {
				Build = (voProductionData.Year > 1940)
			},
			air_base = {
				PreferMaxLevel = 10,
				MaxRun = 3,
				PreferOnly = true,
				PreferList = {
1127, -- Glasgow
1521, -- Liverpool
1563, -- Dublin
1567, -- Sheffield
1728, -- Birmingham
1731, -- Norwich
1964, -- London
2021, -- Dover
2078, -- Southampton
2250, -- Plymouth
5172, -- Lemesos
5191, -- Gibraltar
5359, -- Malta
5564, -- ElArish
5586, -- ElIskandarya
					9969} -- Accra
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
-- #######################################
-- SUPPORT METHODS
-- Setup_Custom is called from GER_FAC.lua and GER.lua
function P.ChangeLaw_training_laws(voLawGroup, voCurrentLaw, voPoliticsMinisterData)
	return false, CLawDataBase.GetLaw(voLawGroup.laws.SPECIALIST_TRAINING)
end

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		CAN = {Score = 20},
		AST = {Score = 20},
		SAF = {Score = 20},
		NZL = {Score = 20},
		TUR = {Score = 40},
		GER = {Score = 60},
		AUH = {Score = 60}}
	
	if laTrade[voDiploScoreObj.Actor.Name] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.Actor.Name].Score
	end
	
	return voDiploScoreObj.Score
end
return AI_ENG
