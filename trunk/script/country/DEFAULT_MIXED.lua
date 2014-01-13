
-- #######################################
-- Production Overides the main LUA with country specific ones

-- Handle special Build Unit, the @@@ is the Unit type in string format
-- Build_@@@@@(ic, voProductionData, viUnitsNeeded)

-- #####################
-- Exepected Returns
-- IC = How much IC is left after execution
-- Boolean = Flag indicating weather to execute generic code as well for the building type
-- #####################
-- Build_Underground(ic, voProductionData)
-- Build_NuclearReactor(ic, voProductionData)
-- Build_RocketTest(ic, voProductionData)
-- Build_Industry(ic, voProductionData)
-- Build_CoastalFort(ic, voProductionData)
-- Build_Fort(ic, voProductionData)
-- Build_AntiAir(ic, voProductionData)
-- Build_Radar(ic, voProductionData)
-- Build_Infrastructure(ic, voProductionData)
-- Build_AirBase(ic, voProductionData)

-- must return how much IC is left


-- #######################################
-- Diplomacy Hooks
-- These all must return a numeric score (100 being 100% chance of success)

-- DiploScore_OfferTrade(voDiploScoreObj)
-- DiploScore_Alliance(voDiploScoreObj)
-- DiploScore_InviteToFaction(viScore, ai, actor, recipient, observer)
-- DiploScore_JoinFaction(viScore, minister, faction)
-- DiploScore_InfluenceNation(voDiploScoreObj)
-- DiploScore_Guarantee(voDiploScoreObj)
-- DiploScore_Embargo(voDiploScoreObj)
-- DiploScore_NonAgression(voAI, voCountryOne, voCountryTwo,observer)
-- DiploScore_GiveMilitaryAccess(voDiploScoreObj)
-- DiploScore_CallAlly(voDiploScoreObj)
-- DiploScore_RequestLendLease(voDiploScoreObj)
-- DiploScore_Debt(voDiploScoreObj)
-- EvaluateLimitedWar(viScore, minister, target, warDesirability)


--##########################
-- Foreign Minister Hooks

-- ForeignMinister_EvaluateDecision(voDecision)
-- ForeignMinister_CallAlly(voForeignMinisterData)
-- ForeignMinister_Alignment(voForeignMinisterData)
-- ForeignMinister_MilitaryAccess(voForeignMinisterData)
-- ForeignMinister_Influence(voForeignMinisterData, voInfluence)
-- ForeignMinister_ProposeWar(voForeignMinisterData)

--##########################
-- Politics Minister Hooks

-- Politics_Mobilization(voPoliticsObject)
-- Politics_Puppets(voPoliticsObject)

-- Handle special Law cases, the @@@ is the law group name in string format
-- CallLaw_@@@@@(minister, loCurrentLaw)

-- Changing of Ministers
--    Each method is passed an array of ministers that can be put into the position
-- Call_ChiefOfAir(Country, vaMinisters)
-- Call_ChiefOfNavy(Country, vaMinisters)
-- Call_ChiefOfArmy(Country, vaMinisters)
-- Call_MinisterOfIntelligence(Country, vaMinisters)
-- Call_ChiefOfStaff(Country, vaMinisters)
-- Call_ForeignMinister(Country, vaMinisters)
-- Call_ArmamentMinister(Country, vaMinisters)
-- Call_MinisterOfSecurity(Country, vaMinisters)

-- #######################################
-- Intelligence Hooks

-- Intel_Home(voIntelligenceData)
-- Intel_Priority(voIntelligenceData, voIntelCountry)
-- Intel_Mission(voIntelligenceData, voIntelCountry)
-- Intel_Priority_Ally(voIntelligenceData, voIntelCountry)
-- Intel_Mission_Ally(voIntelligenceData, voIntelCountry)

local P = {}
AI_DEFAULT_MIXED = P

-- #######################################
-- TECH RESEARCH
function P.TechFolderOrder(voTechnologyData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "TechFolderOrder")
	local laArray = {
		'infantry_folder', 
		'industry_folder',
		'land_doctrine_folder',
		'fighter_folder',
		'armour_folder',
		'air_doctrine_folder',
		'bomber_folder',
		'smallship_folder',
		'capitalship_folder',
		'naval_doctrine_folder',
		'secretweapon_folder',
		'theory_folder'};
	
	return laArray
end
function P.TechList(voTechnologyData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "TechList")
	return Support_Tech.TechGenerator(voTechnologyData, 'Mixed')
end

-- #######################################
-- PRODUCTION Section
function P.ProductionWeights(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "ProductionWeights")
	local laArray = {
		0.35, -- Land
		0.20, -- Air
		0.35, -- Sea
		0.10} -- Other
		
	-- Check to see if manpower is to low
	-- More than 20 brigades build stuff that does not use manpower
	if (voProductionData.Manpower.Total < 20 and voProductionData.Units.Counts.Land > 20)
	or voProductionData.Manpower.Total < 10 then
		laArray = {
			0.05, -- Land
			0.30, -- Air
			0.30, -- Sea
			0.35} -- Other	
	end
	
	return laArray
end
function P.LandRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "LandRatio")
	return Prod_Land.RatioGenerator(voProductionData)
end
function P.SpecialForcesRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "SpecialForcesRatio")
	local laRatio = {
		50, -- Land
		1}; -- Special Force Unit

	local laUnits = {
		marine_brigade = 3,
		bergsjaeger_brigade = 3};
	
	return laRatio, laUnits	
end
function P.EliteUnits(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "EliteUnits")
	local lbAirTran = false --voProductionData.TechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("transport_plane"))
	local laUnits = nil
	
	--if lbAirTran then
	--	laUnits = {"paratrooper_brigade"};
	--end
	
	
	return laUnits	
end
function P.FirePower(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "FirePower")
	local laArray = {"infantry_brigade"}
		
	return laArray
end



function P.AirRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "AirRatio")
	return Prod_Air.RatioGenerator(voProductionData)
end
function P.RocketRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "RocketRatio")
	local laArray = {
		10, -- Air
		1} -- Bomb/Rockety
	
	return laArray
end
function P.NavalRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "NavalRatio")
	return Prod_Sea.RatioGenerator(voProductionData)
end
function P.TransportLandRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "TransportLandRatio")
	local laArray = {
		10, -- Land
		1,  -- transport
		0}  -- invasion craft

  
	return laArray
end
function P.ConvoyRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "ConvoyRatio")
	local laArray = {
		5, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		10, -- If Percentage extra is less than this it will force it up to the amount entered
		20, -- If Percentage extra is greater than this it will force it down to this
		5} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end
function P.Build_infantry_brigade(vIC, viManpowerTotal, voType, voProductionData, viUnitQuantity)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "Build_infantry_brigade")
	local lsContinent = tostring(voProductionData.Country:GetActingCapitalLocation():GetContinent():GetTag())
	
	-- If in Asia remove armor cars
	if lsContinent == "asia" then
		local loFilter = { "armored_car_brigade" }
		local loSupportUnits = Prod_Units.BuildSupportArray(voType.SupportGroup, voProductionData, loFilter)
		
		return Prod_Units.CreateUnit(voType, vIC, viUnitQuantity, voProductionData, loSupportUnits)
	end

	return Prod_Units.CreateUnit(voType, vIC, viUnitQuantity, voProductionData, nil)
end

return AI_DEFAULT_MIXED
