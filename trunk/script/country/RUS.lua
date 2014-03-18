-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany Default File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------

local P = {}
AI_RUS = P

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

	local loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Land')
	-- Remove Resource priority
	if loPreferTech['oil_to_coal_conversion'] then
		if loPreferTech['oil_to_coal_conversion'].Priority > 0 then
			loPreferTech['oil_to_coal_conversion'].Priority = 0
		end
	end
	if loPreferTech['raremetal_refinning_techniques'] then
		if loPreferTech['raremetal_refinning_techniques'].Priority > 0 then
			loPreferTech['raremetal_refinning_techniques'].Priority = 0
		end
	end
	if loPreferTech['oil_refinning'] then
		if loPreferTech['oil_refinning'].Priority > 0 then
			loPreferTech['oil_refinning'].Priority = 0
		end
	end
	if loPreferTech['steel_production'] then
		if loPreferTech['steel_production'].Priority > 0 then
			loPreferTech['steel_production'].Priority = 0
		end
	end
	if loPreferTech['coal_processing_technologies'] then
		if loPreferTech['coal_processing_technologies'].Priority > 0 then
			loPreferTech['coal_processing_technologies'].Priority = 0
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
	elseif voProdSliders.Year >= 1912 or voProdSliders.IsAtWar or ( voProdSliders.Year == 1911 and voProdSliders.Month >= 7 ) then
		laSliders = 0
	else
		laSliders = 1
	end

	return laSliders 
end


function P.ProductionWeights(voProductionData)
	local laArray = {
		0.65, -- Land
		0.10, -- Air
		0.05, -- Sea
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
			0.50, -- Air
			0.10, -- Sea
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
		"guards_brigade"}
	
	return laUnits	
end
function P.FirePower(voProductionData)
	local laArray = {
		"guards_brigade",
		"armor_brigade"}
		
	return laArray
end
function P.AirRatio(voProductionData)
	local laArray = Prod_Air.RatioGenerator(voProductionData)
	
	return laArray
end
function P.NavalRatio(voProductionData)
	local laArray = Prod_Sea.RatioGenerator(voProductionData)
	

	return laArray
end
function P.TransportLandRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "TransportLandRatio")
	local laArray = {
		500, -- Land
		1,  -- transport
		0}  -- invasion craft

  
	return laArray
end
function P.ConvoyRatio(voProductionData)
	local laArray = {
		1, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		5, -- If Percentage extra is less than this it will force it up to the amount entered
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
					1928, -- Warszawa
					1986, -- BrestLitovsk
					1178, -- Riga
					782} -- Leningrad
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

function P.ChangeLaw_training_laws(voLawGroup, voCurrentLaw, voPoliticsMinisterData)
	local lbAtWarGER = voPoliticsMinisterData.Country:GetRelation(CCountryDataBase.GetTag("GER")):HasWar()
	
	-- If atwar with Germany check for special conditions on training
	if lbAtWarGER then
		local lbControlMoscow = (CCurrentGameState.GetProvince(1409):GetController() == voPoliticsMinisterData.Country:GetCountryTag())
		
		-- If its 1943 and we still control Moscow make better trained troops
		if voPoliticsMinisterData.Year >= 1916 and lbControlMoscow then
			return false, CLawDataBase.GetLaw(voLawGroup.laws.BASIC_TRAINING) 
		else
			return false, CLawDataBase.GetLaw(voLawGroup.laws.MINIMAL_TRAINING)
		end
	else
		return false, CLawDataBase.GetLaw(voLawGroup.laws.MINIMAL_TRAINING)
	end
end

-- #######################################
-- SUPPORT METHODS
-- Setup_Custom is called from GER_FAC.lua and GER.lua

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
return AI_RUS
