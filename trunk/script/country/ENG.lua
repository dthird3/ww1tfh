local P = {}
AI_ENG = P

-- #######################################

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(voTechnologyData)
	local laTechWeights = {
		0.17, -- landBasedWeight
		0.08, -- landDoctrinesWeight
		0.12, -- airBasedWeight
		0.15, -- airDoctrinesWeight
		0.22, -- navalBasedWeight
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

	local preferTech = {
		"destroyer_technology",
		"destroyer_armament",
		"destroyer_antiaircraft",
		"destroyer_engine",
		"destroyer_armour",
		"battleship_technology",
		"capitalship_armament",
		"battleship_antiaircraft",
		"battleship_engine",		
		"super_heavy_battleship_technology",
		"dreadnaught_armour",
		"dreadnaught_antiaircraft",
		"dreadnaught_engine",
		"battleship_armour"};
		
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
	-- Default Ratio when no conditions are met
	--Utils.LUA_DEBUGOUT("England productionweights.. Manpower = "..tostring(voProductionData.ManpowerTotal).." land count = " ..tostring(voProductionData.LandCountTotal))
	local laArray = {
		0.40, -- Land
		0.20, -- Air
		0.30, -- Sea
		0.10}; -- Other
			
	-- Check to see if manpower is to low
	-- More than 30 brigades so build stuff that does not use manpower
	if (voProductionData.ManpowerTotal < 30 and voProductionData.LandCountTotal > 30)
	or voProductionData.ManpowerTotal < 10 then
		laArray = {
			0.0, -- Land
			0.50, -- Air
			0.35, -- Sea
			0.15}; -- Other	
	elseif voProductionData.Year <= 1913 and not(voProductionData.IsAtWar) then
		laArray = {
			0.10, -- Land
			0.0, -- Air
			0.70, -- Sea
			0.20}; -- Other
	elseif voProductionData.IsAtWar then
		local loGERTag = CCountryDataBase.GetTag("GER")
		local loEngGerRelation = voProductionData.ministerCountry:GetRelation(loGERTag)
		local lbEngGerWar = loEngGerRelation:HasWar()
		
		-- Germany and UK are at war
		if lbEngGerWar then
			local loUSATag = CCountryDataBase.GetTag("USA")
			local loUSACountry = loUSATag:GetCountry()
			
			-- If USA and UK Faction the same
			if voProductionData.ministerCountry:GetFaction() == loUSACountry:GetFaction() then
				local loEngGerWar = loEngGerRelation:GetWar()
				local liWarMonths = loEngGerWar:GetCurrentRunningTimeInMonths()
				
				if liWarMonths < 24 then
					laArray = {
						0.40, -- Land
						0.25, -- Air
						0.30, -- Sea
						0.05}; -- Other						
				else
					laArray = {
						0.60, -- Land
						0.17, -- Air
						0.18, -- Sea
						0.05}; -- Other
				end
			end
		end
	end
	
	return laArray
end

-- Land ratio distribution
function P.LandRatio(voProductionData)
	local laArray = {
			garrison_brigade = 2,
			infantry_brigade = 20}


	if voProductionData.IsAtWar then
		local loUSATag = CCountryDataBase.GetTag("USA")
		local loUSACountry = loUSATag:GetCountry()
	
		-- If the UK and USA are allied start building a motorized army
		if voProductionData.ministerCountry:GetFaction() == loUSACountry:GetFaction() then
			laArray = {
				infantry_brigade = 20}
		
		end
	end
	
	return laArray
end

-- Special Forces ratio distribution
function P.SpecialForcesRatio(voProductionData)
	local laRatio = {
		11, -- Land
		1}; -- Special Force Unit

	local laUnits = {
		marine_brigade = 2,
		bergsjaeger_brigade = 1};
	
	return laRatio, laUnits	
end

-- Elite Units
function P.EliteUnits(voProductionData)
	local laUnits = {"gurkha_brigade"};
	
	return laUnits	
end

-- Which units should get 1 more Support unit with Superior Firepower tech
function P.FirePower(voProductionData)
	local laArray = {
		"infantry_brigade"};
		
	return laArray
end

-- Air ratio distribution
function P.AirRatio(voProductionData)
	local laArray = {
		interceptor = 4,
		tactical_bomber = 3};
	
	return laArray
end

-- Naval ratio distribution
function P.NavalRatio(voProductionData)
	local laArray = {
		destroyer = 2,
		submarine = 0.75,
		light_cruiser = 2,
		heavy_cruiser = 1,
		dreadnaught = 4,
		escort_carrier = 0.3,
		carrier = 0.5};
	
	return laArray
end

-- Transport to Land unit distribution
function P.TransportLandRatio(voProductionData)
	local laArray = {
		20, -- Land
		1,  -- transport
		1}  -- invasion craft
  
	return laArray
end

-- Convoy Ratio control
--- NOTE: If goverment is in Exile these parms are ignored
function P.ConvoyRatio(voProductionData)
	local laArray = {
		10, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		100, -- If Percentage extra is less than this it will force it up to the amount entered
		200, -- If Percentage extra is greater than this it will force it down to this
		15} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end


-- Do not build coastal forts
function P.Build_CoastalFort(vIC, voProductionData)
	return vIC, false
end

function P.Build_Industry(vIC, voProductionData)
	-- Do not build factories till 1939 or if we go to war early

	if voProductionData.Year < 1915 and not(voProductionData.IsAtWar) then
		vIC = Support.Build_Industry(vIC, voProductionData, 1787, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1728, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1128, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1127, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1341, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1255, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 2018, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1522, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1567, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1524, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1478, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 2078, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 2079, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 2021, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 2250, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1053, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1729, 10)
		vIC = Support.Build_Industry(vIC, voProductionData, 1731, 10)
		return vIC, true
	else
		return vIC, true
	end
	
end

function P.Build_Infrastructure(vIC, voProductionData)

	return vIC, false
end

function P.Build_NavalBase(vIC, voProductionData)	
	return vIC, false
end

function P.Build_AirBase(vIC, voProductionData)
	return vIC, false
end

function P.Build_AntiAir(vIC, voProductionData)	
	return vIC, false
end

function P.Build_Fort(vIC, voProductionData)
	return vIC, false
end

function P.Build_Radar(vIC, voProductionData)

	return vIC, false	
end

function P.Build_RocketTest(ic, voProductionData)
	
	ic = Support.Build_RocketTest(ic, voProductionData, 1907, 1) -- Oxford

	return ic, false	
end

-- END OF PRODUTION OVERIDES
-- #######################################

-- #######################################
-- Intelligence Hooks


-- End of Intelligence Hooks
-- #######################################

function P.DiploScore_Embargo(voDiploScoreObj)
	-- If Japan then do some special checks
	if tostring(voDiploScoreObj.EmbargoTag) == "JAP" then
		-- If we are part of the allies and JAP in axis
		if (voDiploScoreObj.ministerCountry:GetFaction() == CCurrentGameState.GetFaction("allies")) and
			(voDiploScoreObj.Faction == CCurrentGameState.GetFaction("axis"))
		then
			local usaTag = CCountryDataBase.GetTag("USA")
			local loRelation = usaTag:GetCountry():GetRelation(voDiploScoreObj.EmbargoTag)
			
			-- USA is currently embargoing Japan
			-- and is at war so we make sure they dow US first
			if loRelation:HasEmbargo() and loRelation:HasWar() then
				voDiploScoreObj.Score = 100
				
			-- Do not embargo japan unless the USA does so first
			else
				voDiploScoreObj.Score = 0
			end
			
		-- Never embargo Japan then
		else
			voDiploScoreObj.Score = 0
		end
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

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		CAN = {Score = 20},
		AST = {Score = 20},
		SAF = {Score = 20},
		NZL = {Score = 20},
		USA = {Score = 20},
		CHI = {Score = 100},
		GER = {Score = -20},
		ITA = {Score = -20},
		JAP = {Score = 50},
		FRA = {Score = 20}}
	
	if laTrade[voDiploScoreObj.TagName] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.TagName].Score
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
			SER = {Score = 20},
			GRE = {Score = 20}}	
	
		-- Are they on our list
		if loInfluences[voDiploScoreObj.TargetName] then
			return (voDiploScoreObj.Score + loInfluences[voDiploScoreObj.TargetName].Score)
		end
	end

	return voDiploScoreObj.Score
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
			"SWE", -- Sweden
			"CHI", -- China
			"ROM", -- Romania
			"JAP", -- Japan
			"NOR", -- Norway
			"ITA"} -- Italy
			
		laIgnoreWatch = {
			"TUR", -- Turkey
			"SPA", -- Spain
			"SPR", -- Republic Spain
			"POR", -- Portugal
			"AFG", -- Afghanistan
			"PER", -- Persia
			"SAU", -- Saudi Arabia
			"ARG", -- South America
			"HOL", -- Holland
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
			"AUH", -- Hungary
			"BUL", -- Bulgaria
			"FIN", -- Finland
			"CYN", -- Yunnan
			"SIA", -- Siam
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
			"VIC"} 
	end
	
	return laWatch, laIgnoreWatch, laIgnore
end

function P.ForeignMinister_ProposeWar(voForeignMinisterData)
	if not(voForeignMinisterData.Strategy:IsPreparingWar()) then
		if voForeignMinisterData.FactionName == "allies" then
			local loMinisterCapital = voForeignMinisterData.ministerCountry:GetCapitalLocation():GetContinent()
		
			-- Generic DOW for countries not part of the same faction
			if not(voForeignMinisterData.IsAtWar) then
				for loDiploStatus in voForeignMinisterData.ministerCountry:GetDiplomacy() do
					local loTargetTag = loDiploStatus:GetTarget()

					if loTargetTag:IsValid() then
						local loTargetCountry = loTargetTag:GetCountry()
						local loTargetContinent = loTargetCountry:GetCapitalLocation():GetContinent()
						
						-- Limit DOWs to the same continent as the UKs capital
						if loMinisterCapital == loTargetContinent then
							if loDiploStatus:GetThreat():Get() > voForeignMinisterData.ministerCountry:GetMaxNeutralityForWarWith(loTargetTag):Get() then
								if Support.GoodToWarCheck(loTargetTag, loTargetCountry, voForeignMinisterData, true, true) then
									voForeignMinisterData.Strategy:PrepareWar(loTargetTag, 100 )
								end
							end
						end
					end
				end
			end

			-- Special Checks Start after this point
			local loWarTag = nil
			local loAxisTag = CCurrentGameState.GetFaction("axis"):GetFactionLeader()
			
			-- Normal DOW checks
			if not(voForeignMinisterData.IsAtWar) and voForeignMinisterData.Year < 1941 then
				local loCominternTag = CCurrentGameState.GetFaction("comintern"):GetFactionLeader()
				local loCominternCountry = loCominternTag:GetCountry()
				local loAxisCountry = loAxisTag:GetCountry()
				
				local lbAxisVsComintermWar = loAxisCountry:GetRelation(loCominternTag):HasWar()
				
				if lbAxisVsComintermWar then
					-- Both Axis and Comintern are at war but we are at peace then check to see if we help Russia or Germany
					if loCominternCountry:CalcDesperation():Get() > 0.4 then
						loWarTag = loAxisTag
						
					elseif loAxisCountry:CalcDesperation():Get() > 0.4 then
						loWarTag = loCominternTag
					end
				else
					-- If Axis are at war
					if loAxisCountry:IsAtWar() then
						loWarTag = loAxisTag
						
					-- If Comintern are at war
					elseif loCominternCountry:IsAtWar() then
						loWarTag = loCominternTag
					end			
				end
				
				-- Seperate Watch for Italy
				if loWarTag == nil then
					local loITATag = CCountryDataBase.GetTag("ITA")
					local loItalyCountry = loITATag:GetCountry()

					if loItalyCountry:IsAtWar() then
						for loDiploStatus in loItalyCountry:GetDiplomacy() do
							local loTargetTag = loDiploStatus:GetTarget()
							local lsTargetTag = tostring(loTargetTag)
							
							if loTargetTag:IsValid() and loDiploStatus:HasWar() and lsTargetTag ~= "ETH" then
								loWarTag = loITATag
								break
							end
						end
					end
				end
				
			-- If we are atwar with the leader of the Axis then look for Vichy
			elseif voForeignMinisterData.ministerCountry:GetRelation(loAxisTag):HasWar() then
				-- Vichy Check and allied with USA
				local loUSATag = CCountryDataBase.GetTag("USA")
				local loUSACountry = loUSATag:GetCountry()
				
				-- Only consider this if we are in the same faction
				if loUSACountry:GetFaction() == voForeignMinisterData.Faction then
					local loVICTag = CCountryDataBase.GetTag("VIC")
					local loVichyCountry = loVICTag:GetCountry()
					
					if Support.GoodToWarCheck(loVICTag, loVichyCountry, voForeignMinisterData, true, false) then
						loWarTag = loVICTag
					end
				end
			end
			
			-- Do we have a DOW?
			if loWarTag ~= nil then
				voForeignMinisterData.Strategy:PrepareWar(loWarTag, 100)
			end			
		end
	end
end





-- Produce slightly better trained troops
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _ADVANCED_TRAINING_ = 29
	return CLawDataBase.GetLaw(_ADVANCED_TRAINING_)
end



return AI_ENG
