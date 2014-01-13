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
		RARE_MATERIALS = {
			Buffer = 7,
			BufferSaleCap = 10000},
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
function P.ConvoyRatio(voProductionData)
	local laArray = {
		0, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		0, -- If Percentage extra is less than this it will force it up to the amount entered
		30, -- If Percentage extra is greater than this it will force it down to this
		50} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end

-- #######################################
-- SUPPORT METHODS
-- Setup_Custom is called from GER_FAC.lua and GER.lua

return AI_GER
