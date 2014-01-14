
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
-- DiploScore_JoinFactionGoal(viScore, ai, actor, recipient, observer, goal )
-- DiploScore_InfluenceNation(voDiploScoreObj)
-- DiploScore_Guarantee(voDiploScoreObj)
-- DiploScore_Embargo(voDiploScoreObj)
-- DiploScore_NonAgression(voAI, voCountryOne, voCountryTwo,observer)
-- DiploScore_GiveMilitaryAccess(viScore, voAI, voCountry)
-- DiploScore_CallAlly(viScore, ai, actor, recipient, observer)
-- DiploScore_RequestLendLease(viScore, ai, actor, recipient, observer)
-- DiploScore_Debt(voDiploScoreObj)
-- EvaluateLimitedWar(viScore, minister, target, warDesirability)


--##########################
-- Foreign Minister Hooks

-- ForeignMinister_EvaluateDecision(voDecision, voForeignMinisterData)
-- ForeignMinister_CallAlly(voForeignMinisterData)
-- ForeignMinister_Alignment(voForeignMinisterData)
-- ForeignMinister_MilitaryAccess(voForeignMinisterData)
-- ForeignMinister_Influence(voForeignMinisterData)
-- ForeignMinister_ProposeWar(voForeignMinisterData)

--##########################
-- Politics Minister Hooks

-- HandleMobilization(minister)
-- HandlePuppets(minister)

-- Handle special Law cases, the @@@ is the law group name in string format
-- CallLaw_@@@@@(minister, loCurrentLaw)

-- Changing of Ministers
--    Each method is passed an array of ministers that can be put into the position
-- Call_ChiefOfAir(ministerCountry, vaMinisters)
-- Call_ChiefOfNavy(ministerCountry, vaMinisters)
-- Call_ChiefOfArmy(ministerCountry, vaMinisters)
-- Call_MinisterOfIntelligence(ministerCountry, vaMinisters)
-- Call_ChiefOfStaff(ministerCountry, vaMinisters)
-- Call_ForeignMinister(ministerCountry, vaMinisters)
-- Call_ArmamentMinister(ministerCountry, vaMinisters)
-- Call_MinisterOfSecurity(ministerCountry, vaMinisters)

-- #######################################
-- Intelligence Hooks

-- Intel_Home(voIntelligenceData)
-- Intel_Priority(voIntelligenceData, voIntelCountry)
-- Intel_Mission(voIntelligenceData, voIntelCountry)
-- Intel_Priority_Ally(voIntelligenceData, voIntelCountry)
-- Intel_Mission_Ally(voIntelligenceData, voIntelCountry)


local P = {}
AI_DEFAULT_LAND = P


-- #######################################
-- Start of Tech Research

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(voTechnologyData)
	local laArray = {
		0.30, -- _RESEARCH_LAND_
		0.15, -- _RESEARCH_LAND_DOC_
		0.20, -- _RESEARCH_AIR_
		0.15, -- _RESEARCH_AIR_DOC_
		0.0, -- _RESEARCH_NAVAL_
		0.0, -- _RESEARCH_NAVAL_DOC_
		0.15, -- _RESEARCH_INDUSTRIAL_
		0.00, -- _RESEARCH_SECRET_
		0.05}; -- _RESEARCH_UNKNOWN_
	
	return laArray
end

function P.LandTechs(voTechnologyData)
	local ignoreTech = {
		{"cavalry_smallarms", 3}, 
		{"cavalry_support", 3},
		{"cavalry_guns", 3}, 
		{"cavalry_at", 3},
		{"militia_smallarms", 1},
		{"militia_support", 1},
		{"militia_guns", 1},
		{"militia_at", 1},
		{"armored_car_armour", 0},
		{"armored_car_gun", 0},
		{"marine_infantry", 0},
		{"imporved_police_brigade", 0},
		{"desert_warfare_equipment", 0},
		{"jungle_warfare_equipment", 0},
		{"artic_warfare_equipment", 0},
		{"amphibious_warfare_equipment", 0},
		{"airborne_warfare_equipment", 0},
		{"lighttank_brigade", 0},
		{"lighttank_gun", 0},
		{"lighttank_engine", 0},
		{"lighttank_armour", 0},
		{"lighttank_reliability", 0},
		{"tank_brigade", 0},
		{"tank_gun", 0},
		{"tank_engine", 0},
		{"tank_armour", 0},
		{"tank_reliability", 0},
		{"heavy_tank_brigade", 0},
		{"heavy_tank_gun", 0},
		{"heavy_tank_engine", 0},
		{"heavy_tank_armour", 0},
		{"heavy_tank_reliability", 0},
		{"SP_brigade", 0},
		{"mechanised_infantry", 0},
		{"super_heavy_tank_brigade", 0},
		{"super_heavy_tank_gun", 0},
		{"super_heavy_tank_engine", 0},
		{"super_heavy_tank_armour", 0},
		{"super_heavy_tank_reliability", 0},
		{"rocket_art", 0},
		{"rocket_art_ammo", 0},
		{"rocket_carriage_sights", 0}};	

	local preferTech = {
		"militia_smallarms",
		"militia_support",
		"militia_guns",
		"militia_at",
		"infantry_activation",
		"smallarms_technology",
		"infantry_support",
		"infantry_guns",
		"infantry_at",
		"art_barrell_ammo",
		"art_carriage_sights"};
		
	return ignoreTech, preferTech
end

function P.LandDoctrinesTechs(voTechnologyData)
	local ignoreTech = {
		{"mobile_warfare", 0},
		{"elastic_defence", 0},
		{"spearhead_doctrine", 0},
		{"schwerpunkt", 0},
		{"blitzkrieg", 0},
		{"superior_firepower", 0},
		{"operational_level_command_structure", 0},
		{"tactical_command_structure", 0},
		{"integrated_support_doctrine", 0},
		{"mechanized_offensive", 0},
		{"combined_arms_warfare", 0},
		{"special_forces", 0}};
		
	local preferTech = {
		"infantry_warfare",
		"mass_assault",
		"peoples_army"}	
		
	return ignoreTech, preferTech
end

function P.AirTechs(voTechnologyData)
	local ignoreTech = {
		{"basic_four_engine_airframe", 0},
		{"basic_strategic_bomber", 0},
		{"large_fueltank", 0},
		{"four_engine_airframe", 0},
		{"strategic_bomber_armament", 0},
		{"cargo_hold", 0},
		{"large_bomb", 0},
		{"advanced_aircraft_design", 0},
		{"small_airsearch_radar", 0},
		{"medium_airsearch_radar", 0},
		{"large_airsearch_radar", 0},
		{"small_navagation_radar", 0},
		{"medium_navagation_radar", 0},
		{"large_navagation_radar", 0},
		{"rocket_interceptor_tech", 0},
		{"drop_tanks", 0},
		{"jet_engine", 0}};

	local preferTech = {
		"single_engine_aircraft_design",
		"basic_aeroengine",
		"basic_small_fueltank",
		"basic_single_engine_airframe",
		"basic_aircraft_machinegun",
		"twin_engine_aircraft_design",
		"basic_medium_fueltank",
		"basic_twin_engine_airframe",
		"basic_bomb"};
		
	return ignoreTech, preferTech
end

function P.AirDoctrineTechs(voTechnologyData)
	local ignoreTech = {
		{"forward_air_control", 0},
		{"battlefield_interdiction", 0},
		{"bomber_targerting_focus", 0},
		{"fighter_targerting_focus", 0}, 
		{"heavy_bomber_pilot_training", 0},
		{"heavy_bomber_groundcrew_training", 0},
		{"strategic_bombardment_tactics", 0},
		{"airborne_assault_tactics", 0},
		{"strategic_air_command", 0}};

	local preferTech = {
		"fighter_pilot_training",
		"interception_tactics",
		"cas_pilot_training",
		"cas_groundcrew_training",
		"ground_attack_tactics",
		"tac_pilot_training",
		"interdiction_tactics",
		"tactical_air_command"};		
		
	return ignoreTech, preferTech
end

function P.NavalTechs(voTechnologyData)
	local ignoreTech = {"all"};

	return ignoreTech, nil
end

function P.NavalDoctrineTechs(voTechnologyData)
	local ignoreTech = {"all"};
		
	return ignoreTech, nil
end

function P.IndustrialTechs(voTechnologyData)
	local ignoreTech = {
		{"oil_to_coal_conversion", 0},
		{"heavy_aa_guns", 0},
		{"radio_detection_equipment", 0},
		{"radar", 0},
		{"decryption_machine", 0},
		{"encryption_machine", 0},
		{"rocket_tests", 0},
		{"rocket_engine", 0},
		{"theorical_jet_engine", 0},
		{"atomic_research", 0},
		{"nuclear_research", 0},
		{"isotope_seperation", 0},
		{"civil_nuclear_research", 0},
		{"oil_refinning", 0},
		{"steel_production", 0},
		{"raremetal_refinning_techniques", 0},
		{"coal_processing_technologies", 0}};

	local preferTech = {
		"agriculture",
		"industral_production",
		"industral_efficiency",
		"supply_production",
		"education"};
		
	return ignoreTech, preferTech
end

function P.SecretWeaponTechs(voTechnologyData)
	local ignoreTech = {"all"}

	return ignoreTech, nil
end

function P.OtherTechs(voTechnologyData)
	local ignoreTech = {
		{"naval_engineering_research", 0},
		{"submarine_engineering_research", 0},
		{"aeronautic_engineering_research", 0},
		{"rocket_science_research", 0},
		{"chemical_engineering_research", 0},
		{"nuclear_physics_research", 0},
		{"jetengine_research", 0},
		{"mechanicalengineering_research", 0},
		{"automotive_research", 0},
		{"electornicegineering_research", 0},
		{"artillery_research", 0},
		{"mobile_research", 0},
		{"militia_research", 0},
		{"infantry_research", 0},
		{"civil_defence", 0}};

	return ignoreTech, nil
end

-- END OF TECH RESEARCH OVERIDES
-- #######################################

-- Land Brigades vs Air Units ratio
--   If Air Ratio is met AI will shift its Air IC to build land units
function P.LandToAirRatio(voProductionData)
	local laArray = {
		5, -- Land Briages
		1}; -- Air
	
	return laArray
end

function P.ProductionWeights(voProductionData)
	local laArray
	--Utils.LUA_DEBUGOUT("OPTION default land")
	-- Check to see if manpower is to low
	-- More than 30 brigades so build stuff that does not use manpower
	if (voProductionData.ManpowerTotal < 30 and voProductionData.LandCountTotal > 30)
	or voProductionData.ManpowerTotal < 10 then
		laArray = {
			0.0, -- Land
			0.50, -- Air
			0.0, -- Sea
			0.50}; -- Other	
	elseif voProductionData.IsAtWar then
		laArray = {
			0.65, -- Land
			0.25, -- Air
			0.0, -- Sea
			0.10}; -- Other
	else
		laArray = {
			0.55, -- Land
			0.25, -- Air
			0.0, -- Sea
			0.20}; -- Other
	end
	
	return laArray
end

-- Land ratio distribution
function P.LandRatio(voProductionData)
	local laArray = {infantry_brigade = 13};
	
	return laArray
end

-- Special Forces ratio distribution
function P.SpecialForcesRatio(voProductionData)
	local laRatio = {
		40, -- Land
		1}; -- Special Force Unit

	local laUnits = {
		marine_brigade = 3,
		bergsjaeger_brigade = 3};
	
	return laRatio, laUnits	
end

-- Which units should get 1 more Support unit with Superior Firepower tech
--- Firepower is on ignore list but just in case human player researches it
function P.FirePower(voProductionData)
	local laArray = {"infantry_brigade"};
		
	return laArray
end

-- Air ratio distribution
function P.AirRatio(voProductionData)
	local laArray = {
		interceptor = 6,
		tactical_bomber = 4};
	
	return laArray
end

-- Flying Bomb/Rocket distribution against total Air Power
function P.RocketRatio(voProductionData)
	local laArray = {
		10, -- Air
		1}; -- Bomb/Rockety
	
	return laArray
end

-- Naval ratio distribution
function P.NavalRatio(voProductionData)
	local laArray = {}
	
	return laArray
end

-- Transport to Land unit distribution
function P.TransportLandRatio(voProductionData)
	local laArray = {
		0, -- Land
		0,  -- transport
		0}  -- invasion craft
  
	return laArray
end

-- Convoy Ratio control
--- NOTE: If goverment is in Exile these parms are ignored
function P.ConvoyRatio(voProductionData)
	local laArray = {
		0, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		5, -- If Percentage extra is less than this it will force it up to the amount entered
		10, -- If Percentage extra is greater than this it will force it down to this
		5} -- Escort to Convoy Ratio

  
	return laArray
end

-- Do not build Rocket Sites
function P.Build_RocketTest(ic, voProductionData)
	-- Only build Rocket Sites if 1943 or greater
	if voProductionData.Year <= 1942 then
		return ic, false
	else
		-- Small Country so wait till 1945 before we worry about this
		if (voProductionData.icTotal < 50 and voProductionData.Year <= 1945) then
			return ic, false
		end
	end
	
	return ic, true	
end

return AI_DEFAULT_LAND