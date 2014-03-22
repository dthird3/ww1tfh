-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany Default File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------

local P = {}
AI_ITA = P

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
	local loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Mixed')

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
		0.50, -- Land
		0.10, -- Air
		0.20, -- Sea
		0.20} -- Other
	if voProductionData.IsAtWar then
		laArray = {
			0.60, -- Land
			0.10, -- Air
			0.25, -- Sea
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
		"alpini_brigade"}
	
	return laUnits	
end
function P.FirePower(voProductionData)
	local laArray = {
		"alpini_brigade",
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
		40, -- Land
		1,  -- transport
		0.25}  -- invasion craft
  
	return laArray
end
function P.ConvoyRatio(voProductionData)
	local laArray = {
		5, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		10, -- If Percentage extra is less than this it will force it up to the amount entered
		50, -- If Percentage extra is greater than this it will force it down to this
		40} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end
function P.Buildings(voProductionData)
	local loProdBuilding = {
		Buildings = {
			coastal_fort = {
				Build = (voProductionData.Year > 1938)
			},
			industry = {
				Build = (voProductionData.Year > 1920 and not(voProductionData.YearIsAtWar) ),
				PreferOnly = true,
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
3692,  -- Milano
3696, -- Venezia
3971, -- Savona
4549, -- Roma
4765, -- Napoli
4869, -- Taranto
4914, -- Cagliari
5138, -- Rodos
5233, -- Palermo
5445, -- Tarabulus
5484, -- Banghazi
5511, -- Tubruq
9767} -- Ed
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

function P.DiploScore_Alliance(voDiploScoreObj)
	if voDiploScoreObj.Actor.name == "AUH" or voDiploScoreObj.Actor.name == "GER" or voDiploScoreObj.Target.name == "AUH" or voDiploScoreObj.Target.name == "GER" then
		local loAHTag = CCountryDataBase.GetTag("AUH")
		local loSERTag = CCountryDataBase.GetTag("SER")
		local loAHCountry = loAHTag:GetCountry()
		local loRelation = loAHCountry:GetRelation(loSERTag)
		
		
		if not(voDiploScoreObj.Target.IsAtWar) and not(loRelation:HasWar()) then
			return 200
		else
			return -200	
		end
	end
	
	return voDiploScoreObj.Score
end
function P.DiploScore_InviteToFaction(voDiploScoreObj)
	local loAllies = CCurrentGameState.GetFaction("allies")
	
	-- Only go through these checks if we are being asked to join the Allies
	if voDiploScoreObj.Faction == loAllies then
		local liYear = CCurrentGameState.GetCurrentDate():GetYear()
		local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
		
		-- Date check to make sure they come in within resonable time
		if liYear >= 1916 then
			voDiploScoreObj.Score = voDiploScoreObj.Score + 200
		elseif liYear >= 1915 then
			if liMonth >= 5 then
				voDiploScoreObj.Score = voDiploScoreObj.Score + 100
			else
				voDiploScoreObj.Score = voDiploScoreObj.Score - 200	
			end
		else
			voDiploScoreObj.Score = voDiploScoreObj.Score - 200
		end
	end
	
	return voDiploScoreObj.Score
end
function P.ForeignMinister_Alignment(voForeignMinisterData)

	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
	if liYear > 1913 then
		return ForeignMinister_Alignment.Alignment_Push("allies", voForeignMinisterData)
	else
		--return Support.AlignmentNeutral(...)
	end	


end


-- #######################################
-- SUPPORT METHODS
-- Setup_Custom is called from GER_FAC.lua and GER.lua


return AI_ITA
