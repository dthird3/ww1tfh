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
AI_DEFAULT_PUP = P

-- #######################################
-- TECH RESEARCH
function P.TechFolderOrder(voTechnologyData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "TechFolderOrder")
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
--Utils.LUA_DEBUGOUT("Default_pup" .. "TechList")
	return Support_Tech.TechGenerator(voTechnologyData, 'Land Strict')
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
--Utils.LUA_DEBUGOUT("Default_pup" .. "ProductionWeights")
	local laArray = {
		0.70, -- Land
		0.20, -- Air
		0.0, -- Sea
		0.10} -- Other
		
	-- Check to see if manpower is to low
	-- More than 20 brigades build stuff that does not use manpower
	if (voProductionData.Manpower.Total < 20 and voProductionData.Units.Counts.Land > 20)
	or voProductionData.Manpower.Total < 10 then
		laArray = {
			0.05, -- Land
			0.40, -- Air
			0.0, -- Sea
			0.55} -- Other	
	end
	
	return laArray
end
function P.LandRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "LandRatio")
	return Prod_Land.RatioGenerator(voProductionData)
end
function P.SpecialForcesRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "SpecialForcesRatio")
	local laRatio = {
		40, -- Land
		1}; -- Special Force Unit

	local laUnits = {
		marine_brigade = 3,
		bergsjaeger_brigade = 3};
	
	return laRatio, laUnits	
end
function P.EliteUnits(voProductionData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "EliteUnits")
	return nil	
end
function P.FirePower(voProductionData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "FirePower")
	local laArray = {"infantry_brigade"}
		
	return laArray
end
function P.AirRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "AirRatio")
	return Prod_Air.RatioGenerator(voProductionData)
end
function P.RocketRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "RocketRatio")
	local laArray = {
		0, -- Air
		0} -- Bomb/Rockety
	
	return laArray
end
function P.NavalRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "NavalRatio")
	return Prod_Sea.RatioGenerator(voProductionData)
end
function P.TransportLandRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "TransportLandRatio")
	local laArray = {
		0, -- Land
		0,  -- transport
		0}  -- invasion craft

  
	return laArray
end
function P.ConvoyRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_pup" .. "ConvoyRatio")
	local laArray = {
		0, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		5, -- If Percentage extra is less than this it will force it up to the amount entered
		10, -- If Percentage extra is greater than this it will force it down to this
		5} -- Escort to Convoy Ratio

	return laArray
end
function P.Build_infantry_brigade(vIC, viManpowerTotal, voType, voProductionData, viUnitQuantity)
--Utils.LUA_DEBUGOUT("Default_pup" .. "Build_infantry_brigade")
	local lsContinent = tostring(voProductionData.Country:GetActingCapitalLocation():GetContinent():GetTag())
	
	-- If in Asia remove armor cars
	if lsContinent == "asia" then
		local loFilter = { "armored_car_brigade" }
		local loSupportUnits = Prod_Units.BuildSupportArray(voType.SupportGroup, voProductionData, loFilter)
		
		return Prod_Units.CreateUnit(voType, vIC, viUnitQuantity, voProductionData, loSupportUnits)
	end

	return Prod_Units.CreateUnit(voType, vIC, viUnitQuantity, voProductionData, nil)
end
function P.Buildings(voProductionData)
--Utils.LUA_DEBUGOUT("Buildings")
	local loProdBuilding = {
		UseRandom = false,
		Buildings = {
			underground = nil,
			radar_station = nil,
			rocket_test = nil,
			coastal_fort = nil,
			land_fort = nil,
			anti_air = nil,
			industry = nil,
			nuclear_reactor = nil,
			infra = nil,
			air_base = nil,
			naval_base = nil
		}
	}
	
	return loProdBuilding
end

return AI_DEFAULT_PUP