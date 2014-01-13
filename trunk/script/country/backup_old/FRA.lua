local P = {}
AI_FRA = P

-- #######################################

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(voTechnologyData)
	local laTechWeights = {
		0.17, -- landBasedWeight
		0.22, -- landDoctrinesWeight
		0.12, -- airBasedWeight
		0.15, -- airDoctrinesWeight
		0.08, -- navalBasedWeight
		0.10, -- navalDoctrinesWeight
		0.10, -- industrialWeight
		0.03, -- secretWeaponsWeight
		0.03}; -- otherWeight
	
	return laTechWeights
end

-- Techs that are used in the main file to be ignored
--   techname|level (level must be 1-9 a 0 means ignore all levels
--   use as the first tech name the word "all" and it will cause the AI to ignore all the techs
function P.LandTechs(voTechnologyData)
	local lbArmor = voTechnologyData.TechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("armor_brigade"))
	local ignoreTech
	
	if lbArmor then
		ignoreTech = {
			{"cavalry_smallarms", 3}, 
			{"cavalry_support", 3},
			{"cavalry_guns", 3}, 
			{"cavalry_at", 1},
			{"amphibious_invasion_technology", 3},
			{"amphibious_assault_units", 3}
		}
	else
		ignoreTech = {
			{"cavalry_smallarms", 3}, 
			{"cavalry_support", 3},
			{"cavalry_guns", 3}, 
			{"cavalry_at", 1},
			{"lighttank_gun", 2},
			{"lighttank_engine", 2},
			{"lighttank_armour", 2},
			{"lighttank_reliability", 2},
			{"amphibious_invasion_technology", 3},
			{"amphibious_assault_units", 3}
		}
	end
	
		
	local preferTech = {
		"armored_car_brigade_development",
		"armored_car_armour",
		"armored_car_gun",
		"infantry_activation",
		"smallarms_technology",
		"infantry_support",
		"infantry_guns",
		"infantry_at",
		"lighttank_brigade",
		"lighttank_gun",
		"lighttank_engine",
		"lighttank_armour",
		"lighttank_reliability",
		"tank_brigade",
		"tank_gun",
		"tank_engine",
		"tank_armour",
		"tank_reliability",
		"art_barrell_ammo",
		"art_carriage_sights"}
		
	return ignoreTech, preferTech
end

function P.LandDoctrinesTechs(voTechnologyData)
	local ignoreTech = {
		{"guerilla_warfare", 0},
		{"large_formations", 0}};
		
	local preferTech = {
		"mobile_warfare",
		"elastic_defence",
		"spearhead_doctrine",
		"schwerpunkt",
		"blitzkrieg",
		"operational_level_command_structure",
		"tactical_command_structure",
		"delay_doctrine",
		"integrated_support_doctrine",
		"mechanized_offensive",
		"combined_arms_warfare",
		"infantry_warfare",
		"central_planning",
		"mass_assault",
		"grand_battle_plan",
		"assault_concentration",
		"operational_level_organisation"};
		
	return ignoreTech, preferTech
end

function P.AirTechs(voTechnologyData)
	local ignoreTech = {};

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
		{"fighter_targerting_focus", 0}};

	local preferTech = {
		"fighter_pilot_training",
		"fighter_groundcrew_training",
		"interception_tactics",
		"ground_attack_tactics",
		"tac_pilot_training",
		"interdiction_tactics",
		"tactical_air_command"};		
		
	return ignoreTech, preferTech
end
		
function P.NavalTechs(voTechnologyData)
	local ignoreTech = {
        {"submarine_airwarningequipment", 0},
        {"submarine_antiaircraft", 0}};

	local preferTech = {};
		
	return ignoreTech, preferTech
end
		
function P.NavalDoctrineTechs(voTechnologyData)
	local ignoreTech = {};

	local preferTech = {
		"fleet_auxiliary_carrier_doctrine",
		"light_cruiser_escort_role",
		"carrier_group_doctrine",
		"light_cruiser_crew_training",
		"carrier_crew_training",
		"carrier_task_force",
		"naval_underway_repleshment",
		"radar_training",
		"sea_lane_defence",
		"destroyer_escort_role",
		"battlefleet_concentration_doctrine",
		"destroyer_crew_training",
		"battleship_crew_training",
		"commerce_defence",
		"fire_control_system_training",
		"commander_decision_making",
		"cruiser_warfare",
		"cruiser_crew_training",
		"spotting",
		"basing"};
		
	return ignoreTech, preferTech
end

function P.IndustrialTechs(voTechnologyData)
	local ignoreTech = {
		{"steel_production", 0},
		{"raremetal_refinning_techniques", 0},
		{"coal_processing_technologies", 0}};

	local preferTech = {
		"agriculture",
		"industral_production",
		"industral_efficiency",
		"oil_to_coal_conversion",
		"supply_production",
		"oil_refinning",
		"education",
		"mechnical_computing_machine"};
		
	return ignoreTech, preferTech
end
		
function P.SecretWeaponTechs(voTechnologyData)
	local ignoreTech = {
		{"civ_airship_development", 0},
		{"airship_development", 0},
		{"airship_engine", 0},
		{"airship_bomb", 0}};
		
	local preferTech = {
		"poison_gas",
		"poison_gas_cylinders",
		"poison_gas_shells"};
		
	return ignoreTech, preferTech
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
		{"airship_research", 0}};

	local preferTech = {
		"supply_transportation",
		"supply_organisation",
		"civil_defence"};		

	return ignoreTech, preferTech
end

-- END OF TECH RESEARCH OVERIDES
-- #######################################


-- #######################################
-- Production Overides the main LUA with country specific ones

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(voProductionData)
	local laArray
	
	-- Check to see if manpower is to low
	-- More than 150 brigades so build stuff that does not use manpower
	if (voProductionData.ManpowerTotal < 100 and voProductionData.LandCountTotal > 150)
	or voProductionData.ManpowerTotal < 50 then
		laArray = {
			0.0, -- Land
			0.30, -- Air
			0.35, -- Sea
			0.35}; -- Other	
			
	-- We no longer control Paris (so we lost)
	elseif voProductionData.IsExile then
		laArray = {
			0.30, -- Land
			0.20, -- Air
			0.30, -- Sea
			0.20}; -- Other	(Help build Undergrounds)
	elseif voProductionData.Year >= 1940 then
		laArray = {
			0.65, -- Land
			0.20, -- Air
			0.10, -- Sea
			0.05}; -- Other
	else
		laArray = {
			0.50, -- Land
			0.18, -- Air
			0.20, -- Sea
			0.12}; -- Other
	end
	
	return laArray
end

-- Land ratio distribution
function P.LandRatio(voProductionData)
	local laArray
	
	-- Early years focus on Infantry
	if not(voProductionData.IsExile) then
		laArray = {
			garrison_brigade = 2,
			infantry_brigade = 20};
			
	-- France has learned it's lesson now focus on a more modern setup
	else
		laArray = {
			infantry_brigade = 20}		
	end
	
	return laArray
end

-- Special Forces ratio distribution
function P.SpecialForcesRatio(voProductionData)
	local laRatio = {
		40, -- Land
		1}; -- Special Force Unit

	local laUnits = {bergsjaeger_brigade = 3};
	
	return laRatio, laUnits	
end

-- Elite Units
function P.EliteUnits(voProductionData)
	local laUnits = {"alpins_brigade"};
	
	return laUnits	
end

-- Which units should get 1 more Support unit with Superior Firepower tech
function P.FirePower(voProductionData)
	local laArray = {
		"alpins_brigade"};
		
	return laArray
end

-- Air ratio distribution
function P.AirRatio(voProductionData)
	local laArray = {
		interceptor = 6,
		tactical_bomber = 5};
	
	return laArray
end

-- Naval ratio distribution
function P.NavalRatio(voProductionData)
	local laArray = {
		destroyer = 2,
		submarine = 0.25,
		light_cruiser = 2,
		heavy_cruiser = 2,
		dreadnaught = 4};
	
	return laArray
end

-- Transport to Land unit distribution
function P.TransportLandRatio(voProductionData)
	local laArray = {
		25, -- Land
		1,  -- transport
		1}  -- invasion craft
  
	return laArray
end

-- Convoy Ratio control
--- NOTE: If goverment is in Exile these parms are ignored
function P.ConvoyRatio(voProductionData)
	local laArray
	
	if voProductionData.Year < 1940 and not(voProductionData.IsExile) then
		laArray = {
			5, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
			5, -- If Percentage extra is less than this it will force it up to the amount entered
			10, -- If Percentage extra is greater than this it will force it down to this
			10} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
	else
		laArray = {
			5, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
			5, -- If Percentage extra is less than this it will force it up to the amount entered
			10, -- If Percentage extra is greater than this it will force it down to this
			5} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
	end
  
	return laArray
end

-- Create Custom infantry for France
function P.Build_infantry_brigade(vIC, viManpowerTotal, voType, voProductionData, viUnitQuantity)
	-- Build old style formations till 1940
	if voProductionData.Year < 1940 and not(voProductionData.IsAtWar) and not(voProductionData.IsExile) then
		local laSupportUnit = {
			"artillery_brigade",
			"anti_air_brigade",
			"anti_tank_brigade"}

		voType.Size = 3
		voType.Support = 1
	end

	return Support.CreateUnit(voType, vIC, viUnitQuantity, voProductionData, laSupportUnit)
end


-- Do not build coastal forts
function P.Build_CoastalFort(vIC, voProductionData)
	return vIC, false
end

function P.Build_RocketTest(ic, voProductionData)
	
	ic = Support.Build_RocketTest(ic, voProductionData, 2613, 1) -- Paris

	return ic, false	
end

function P.Build_AntiAir(vIC, voProductionData)
	return vIC, false
end

function P.Build_Infrastructure(vIC, voProductionData)
	return vIC, false	
end

function P.Build_Fort(vIC, voProductionData)
		return vIC, false	
end

function P.Build_NavalBase(vIC, voProductionData)

		return vIC, false	
end

function P.Build_Radar(vIC, voProductionData)

		return vIC, false	
end

function P.Build_Underground(vIC, voProductionData)
	if voProductionData.IsExile then
		return vIC, true
	end
	
	return vIC, false
end

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 2309, 3) -- Lille
ic = Support.Build_AirBase(ic, voProductionData, 2422, 2) -- Cherbourg
ic = Support.Build_AirBase(ic, voProductionData, 2425, 2) -- Amiens
ic = Support.Build_AirBase(ic, voProductionData, 2550, 2) -- Reims
ic = Support.Build_AirBase(ic, voProductionData, 2605, 2) -- Quimper
ic = Support.Build_AirBase(ic, voProductionData, 2613, 5) -- Paris
ic = Support.Build_AirBase(ic, voProductionData, 2682, 2) -- StMihiel
ic = Support.Build_AirBase(ic, voProductionData, 2683, 3) -- Nancy
ic = Support.Build_AirBase(ic, voProductionData, 2746, 2) -- Troyes
ic = Support.Build_AirBase(ic, voProductionData, 2812, 3) -- Neufchateau
ic = Support.Build_AirBase(ic, voProductionData, 2870, 2) -- Nantes
ic = Support.Build_AirBase(ic, voProductionData, 3077, 2) -- Bourges
ic = Support.Build_AirBase(ic, voProductionData, 3149, 2) -- Montbeliard
ic = Support.Build_AirBase(ic, voProductionData, 3215, 2) -- Gray
ic = Support.Build_AirBase(ic, voProductionData, 3351, 2) -- Besancon
ic = Support.Build_AirBase(ic, voProductionData, 3479, 2) -- Bordeaux
ic = Support.Build_AirBase(ic, voProductionData, 3484, 2) -- Vichy
ic = Support.Build_AirBase(ic, voProductionData, 3687, 2) -- Lyon
ic = Support.Build_AirBase(ic, voProductionData, 3959, 2) -- Pau
ic = Support.Build_AirBase(ic, voProductionData, 3961, 2) -- Toulouse
ic = Support.Build_AirBase(ic, voProductionData, 4229, 2) -- Marseille
ic = Support.Build_AirBase(ic, voProductionData, 4230, 2) -- Toulon
ic = Support.Build_AirBase(ic, voProductionData, 4486, 1) -- Ajaccio
ic = Support.Build_AirBase(ic, voProductionData, 5134, 2) -- Tunis
ic = Support.Build_AirBase(ic, voProductionData, 5160, 2) -- Alger
ic = Support.Build_AirBase(ic, voProductionData, 5292, 2) -- Oran
ic = Support.Build_AirBase(ic, voProductionData, 5916, 2) -- Hanoi
ic = Support.Build_AirBase(ic, voProductionData, 6236, 2) -- Saigon
ic = Support.Build_AirBase(ic, voProductionData, 9741, 2) -- Dakar
ic = Support.Build_AirBase(ic, voProductionData, 9968, 2) -- Abidjan
ic = Support.Build_AirBase(ic, voProductionData, 5412, 2) -- Casablanca
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end



-- END OF PRODUTION OVERIDES
-- #######################################
function P.DiploScore_InviteToFaction(voDiploScoreObj)
	-- Stay out of the war, we do not care whats happening around us
	if not(voDiploScoreObj.IsAtWar) then
		voDiploScoreObj.Score = 0
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_Alliance(voDiploScoreObj)
	-- Stay out of the war, we do not care whats happening around us
	if not(voDiploScoreObj.IsAtWar) then
		voDiploScoreObj.Score = 0
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_GiveMilitaryAccess(viScore, voAI, voCountry)
	-- We stay out of everything
	return 0
end
function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		ENG = {Score = 20},
		AST = {Score = 20},
		SAF = {Score = 20},
		NZL = {Score = 20},
		USA = {Score = 20},
		JAP = {Score = 50},
		GER = {Score = -20},
		ITA = {Score = -20},
		CAN = {Score = 20}}
	
	if laTrade[voDiploScoreObj.TagName] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.TagName].Score
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_Debt(voDiploScoreObj)
	local lsToTag = tostring(voDiploScoreObj.ToTag)
	
	if lsToTag == "CHI" then
		local loAllyFaction = CCurrentGameState.GetFaction("allies")
		
		-- We must be in the allies before we do this
		if voDiploScoreObj.FromCountry:GetFaction() == loAllyFaction then
			local japTag = CCountryDataBase.GetTag("JAP")
			
			-- If China and Japan are at war then let China be allowed debt even if not in the Allies
			if voDiploScoreObj.ToCountry:GetRelation(japTag):HasWar() then
				voDiploScoreObj.Score = 100
			end
		end
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_InfluenceNation(voDiploScoreObj)
	-- Only do this if we are in the allies
	if voDiploScoreObj.FactionName == "allies" then
		local loInfluences = {
			AST = {Score = 70},
			CAN = {Score = 70},
			SAF = {Score = 70},
			NZL = {Score = 70},
			USA = {Score = 70},
			BRA = {Score = 40},
			YUG = {Score = 20},
			GRE = {Score = 20}}	
	
		-- Are they on our list
		if loInfluences[voDiploScoreObj.TargetName] then
			return (voDiploScoreObj.Score + loInfluences[voDiploScoreObj.TargetName].Score)
		end
	end

	return voDiploScoreObj.Score	
end

function P.HandleMobilization(minister)
	local ai = minister:GetOwnerAI()
	
	local ministerTag = minister:GetCountryTag()
	local gerTag = CCountryDataBase.GetTag("GER")

	-- If Germany Controls Czechoslovakia then
	if CCurrentGameState.GetProvince(2562):GetController() == gerTag then -- Praha check
		ai:Post(CToggleMobilizationCommand( ministerTag, true ))					
	else
		-- Check if a neighbor is starting to look threatening
		-- This code should be idential to the one in ai_politics_minsiter.lua
		local ministerCountry = ministerTag:GetCountry()
		local liTotalIC = ministerCountry:GetTotalIC()
		local liNeutrality = ministerCountry:GetNeutrality():Get() * 0.9
		
		for loCountryTag in ministerCountry:GetNeighbours() do
			local liThreat = ministerCountry:GetRelation(loCountryTag):GetThreat():Get()
			
			if (liNeutrality - liThreat) < 10 then
				local loCountry = loCountryTag:GetCountry()
				
				liThreat = liThreat * CalculateAlignmentFactor(ai, ministerCountry, loCountry)
				
				if liTotalIC > 50 and loCountry:GetTotalIC() < liTotalIC then
					liThreat = liThreat / 2 -- we can handle them if they descide to attack anyway
				end
				
				if liThreat > 30 then
					if CalculateWarDesirability(ai, loCountry, ministerTag) > 70 then
						ai:Post(CToggleMobilizationCommand( ministerTag, true ))
					end
				end
			end
		end
	end
end

--##########################
-- Foreign Minister Hooks
function P.ForeignMinister_Influence(voForeignMinisterData)
	local laIgnoreWatch -- Ignore this country but monitor them if they are about to join someone else
	local laWatch -- Monitor them and also fi their score is high enough they can be influenced normally
	local laIgnore -- Ignore them completely

	if voForeignMinisterData.FactionName == "allies" then
		laWatch = {
			"BEL", -- Belgium
			"HOL", -- Holland
			"SWE", -- Sweden
			"CHI", -- China
			"NOR"} -- Norway
			
		laIgnoreWatch = {
			"TUR", -- Turkey
			"SPA", -- Spain
			"SPR", -- Republic Spain
			"POR", -- Portugal
			"AFG", -- Afghanistan
			"PER", -- Persia
			"SAU", -- Saudi Arabia
			"ARG", -- South America
			"BOL", 
			"BRA",
			"CHL",
			"COL",
			"ECU",
			"GUY",
			"PAR",
			"PRU",
			"URU",
			"VEN",
			"CUB", -- Central America
			"COS",
			"DOM",
			"GUA",
			"HAI",
			"HON",
			"MEX",
			"NIC",
			"PAN",
			"SAL"}
			
		laIgnore = {
			"HUN", -- Hungary
			"ROM", -- Romania
			"BUL", -- Bulgaria
			"FIN", -- Finland
			"CYN", -- Yunnan
			"SIK", -- Sikiang
			"CGX", -- Guangxi Clique
			"CSX", -- Shanxi
			"TIB", -- Tibet
			"CHC", -- Communist China
			"LAT", -- Lativia
			"LIT", -- Lithuania
			"EST", -- Estonia
			"LUX", -- Luxemburg
			"VIC", -- Vichy
			"DEN", -- Denmark
			"ETH", -- Ethiopia
			"AUS", -- Austria
			"CZE", -- Czechoslovakia
			"SCH", -- Switzerland
			"VIC", -- Vichy
			"JAP", -- Japan
			"ITA"} -- Italy
	end
	
	return laWatch, laIgnoreWatch, laIgnore
end


return AI_FRA

