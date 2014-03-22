-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany Default File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------

local P = {}
AI_TUR = P

-- #######################################
-- TRADE Weights
function P.TradeWeights(voResourceData)
	local laResouces = {
	
		METAL = {
			Buffer = 3, 			-- Amount extra to keep abouve our needs
			BufferSaleCap = 40000, 	-- Amount we need in reserve before we sell the resource
			BufferBuyCap = 8000, 	-- Amount we need before we stop actively buying (existing trades are NOT cancelled)
			BufferCancelCap = 25000 -- Amount we need before we cancel trades simply because we have to much
		},
		RARE_MATERIALS = {
			Buffer = 3,
			BufferSaleCap = 20000,
			BufferBuyCap = 5000,
			BufferCancelCap = 15000},
		CRUDE_OIL = {
			Buffer = 1,
			BufferSaleCap = 30000},
		FUEL = {
			Buffer = 2,
			BufferSaleCap = 50000}}
	
	return laResouces
end

-- #######################################
-- TECH RESEARCH
function P.TechList(voTechnologyData)
	local loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Land Strict')

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
	elseif voProdSliders.Year >= 1911 or voProdSliders.IsAtWar then
		laSliders = 0
	else
		laSliders = 1
	end

	return laSliders 
end


function P.ProductionWeights(voProductionData)
	local laArray = {
		0.90, -- Land
		0.00, -- Air
		0.00, -- Sea
		0.10} -- Other
	if voProductionData.IsAtWar then
		laArray = {
			0.85, -- Land
			0.05, -- Air
			0.00, -- Sea
			0.10} -- Other
	end
		
	-- Check to see if manpower is to low
	-- More than 20 brigades build stuff that does not use manpower
	if (voProductionData.Manpower.Total < 100 and voProductionData.Units.Counts.Land > 60)
	or voProductionData.Manpower.Total < 50 then
		laArray = {
			0.05, -- Land
			0.50, -- Air
			0.00, -- Sea
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
		"janissary_brigade"}
	
	return laUnits	
end
function P.FirePower(voProductionData)
	local laArray = {
		"janissary_brigade",
		"bergsjaeger_brigade"}
		
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
		5, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		5, -- If Percentage extra is less than this it will force it up to the amount entered
		10, -- If Percentage extra is greater than this it will force it down to this
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
					4188, -- Trabzon
					9213, -- Baghdad
					4503, -- Istanbul
					5567, -- Jerusalem
					4619, -- Ankara
					5299, -- Beirut
					7332, -- Batman
					4966} -- Izmir
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
function P.ForeignMinister_CallAlly(voForeignMinisterData)
	
	return false
end


function P.ForeignMinister_EvaluateDecision(voDecision)
	local loDecisions = {
		ottshell = {Year = 1914, Month = 10, Day = 1, War = true, Country = "RUS", Score = 100 }}

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
-- #######################################
-- SUPPORT METHODS
-- Setup_Custom is called from GER_FAC.lua and GER.lua

function P.DiploScore_Alliance(voDiploScoreObj)
	if voDiploScoreObj.Actor.name == "HJZ" or voDiploScoreObj.Actor.name == "ASR" or voDiploScoreObj.Actor.name == "YEM" or voDiploScoreObj.Target.name == "HJZ" or voDiploScoreObj.Target.name == "ASR" or voDiploScoreObj.Target.name == "YEM" then
		return 200
	end
	
	return voDiploScoreObj.Score
end


function P.DiploScore_CallAlly(voDiploScoreObj)
	voDiploScoreObj.Score = 0
	
	return voDiploScoreObj.Score
end
return AI_TUR
