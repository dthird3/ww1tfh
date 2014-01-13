
local P = {}
AI_USA = P

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
	local ignoreTech = {};

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

	-- Set the default in the array incase no condition is met
	local laArray = {
			0.30, -- Land
			0.30, -- Air
			0.40, -- Sea
			0.00}; -- Other	         

	
	-- Not atwar so
	if not(voProductionData.IsAtWar) and voProductionData.Year < 1917 then
		if voProductionData.Year <= 1914 then
			laArray = {
				0.05, -- Land 
				0.27, -- Air
				0.25, -- Sea
				0.43}; -- Other
		elseif voProductionData.Year <= 1916 then
			laArray = {
				0.15, -- Land 
				0.24, -- Air
				0.25, -- Sea
				0.36}; -- Other
		elseif voProductionData.ManpowerTotal < 50 then
			laArray = {
				0.00, -- Land
				0.58, -- Air
				0.42, -- Sea
				0.00}; -- Other
		end
	else
		local loGerUsaDiplo = voProductionData.ministerCountry:GetRelation(CCountryDataBase.GetTag("GER"))
		local loJapUsaDiplo = voProductionData.ministerCountry:GetRelation(CCountryDataBase.GetTag("JAP"))
		local lbGERWar = loGerUsaDiplo:HasWar() 
		local lbJAPWar = loJapUsaDiplo:HasWar()
	
		if lbGERWar or lbJAPWar then
			local liGERWar = 12
			local liJAPWar = 12
			
			if lbGERWar then
				liGERWar = loGerUsaDiplo:GetWar():GetCurrentRunningTimeInMonths()
			end
				
			if lbJAPWar then
				liJAPWar = loJapUsaDiplo:GetWar():GetCurrentRunningTimeInMonths()
			end
			
			local liWarMonths = math.min(liGERWar)
			
			if liWarMonths < 12 then
				laArray = {
					0.90, -- Land
					0.05, -- Air
					0.05, -- Sea
					0.00}; -- Other
			end
		end
	end
	
	return laArray
end

-- Land ratio distribution
function P.LandRatio(voProductionData)
	local laArray
	
	if voProductionData.Year < 1915 or not(voProductionData.IsAtWar) then
		laArray = {
			garrison_brigade = 10,
			infantry_brigade = 30
		}
	else
		laArray = {
			garrison_brigade = 2,
			infantry_brigade = 20
		}
	end
	
	return laArray
end

-- Special Forces ratio distribution
function P.SpecialForcesRatio(voProductionData)
	local laRatio = {
		5, -- Land
		1}; -- Special Force Unit

	local laUnits = {
		marine_brigade = 3,
		bergsjaeger_brigade = 0.5};
	
	return laRatio, laUnits	
end

-- Elite Units
function P.EliteUnits(voProductionData)
	local laUnits = {"ranger_brigade"};
	
	return laUnits	
end

-- Which units should get 1 more Support unit with Superior Firepower tech
function P.FirePower(voProductionData)
	local laArray = {
		"ranger_brigade",
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
		destroyer = 8,
		submarine = 0.75,
		light_cruiser = 2,
		heavy_cruiser = 1.25,
		dreadnaught = 2,
		escort_carrier = 0.25,
		carrier = 1};
	
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
	local laArray = {
		10, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		150, -- If Percentage extra is less than this it will force it up to the amount entered
		250, -- If Percentage extra is greater than this it will force it down to this
		5} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end



function P.Build_CoastalFort(ic, voProductionData)
	return ic, false
end
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 6124, 2) -- ClarkField
ic = Support.Build_AirBase(ic, voProductionData, 6142, 1) -- Manila
ic = Support.Build_AirBase(ic, voProductionData, 7717, 1) --  Panama
ic = Support.Build_AirBase(ic, voProductionData, 10664, 2) -- Wake Island
ic = Support.Build_AirBase(ic, voProductionData, 3533, 2) -- Sacramento
ic = Support.Build_AirBase(ic, voProductionData, 3544, 2) -- CrownPoint
ic = Support.Build_AirBase(ic, voProductionData, 3658, 2) -- SanFransisco
ic = Support.Build_AirBase(ic, voProductionData, 3793, 2) -- Milwaukee
ic = Support.Build_AirBase(ic, voProductionData, 3797, 2) -- Detroit
ic = Support.Build_AirBase(ic, voProductionData, 4016, 2) -- Boston
ic = Support.Build_AirBase(ic, voProductionData, 4273, 2) -- Pittsburgh
ic = Support.Build_AirBase(ic, voProductionData, 4279, 2) -- NewYork
ic = Support.Build_AirBase(ic, voProductionData, 4530, 2) -- WashingtonDC
ic = Support.Build_AirBase(ic, voProductionData, 4694, 2) -- LosAngeles
ic = Support.Build_AirBase(ic, voProductionData, 4900, 2) -- Norfolk
ic = Support.Build_AirBase(ic, voProductionData, 5317, 2) -- Charleston
ic = Support.Build_AirBase(ic, voProductionData, 5825, 2) -- Honolulu
ic = Support.Build_AirBase(ic, voProductionData, 6119, 2) -- Guam
ic = Support.Build_AirBase(ic, voProductionData, 6697, 2) -- Seattle
ic = Support.Build_AirBase(ic, voProductionData, 6774, 2) -- Portland
ic = Support.Build_AirBase(ic, voProductionData, 7032, 2) -- Rumford
ic = Support.Build_AirBase(ic, voProductionData, 7104, 2) -- Chicago
ic = Support.Build_AirBase(ic, voProductionData, 7221, 2) -- Dayton
ic = Support.Build_AirBase(ic, voProductionData, 7281, 2) -- StLouis
ic = Support.Build_AirBase(ic, voProductionData, 7350, 2) -- SanDiego
ic = Support.Build_AirBase(ic, voProductionData, 7386, 2) -- LittleRock
ic = Support.Build_AirBase(ic, voProductionData, 7387, 2) -- Memphis
ic = Support.Build_AirBase(ic, voProductionData, 7388, 2) -- Charlotte
ic = Support.Build_AirBase(ic, voProductionData, 7422, 2) -- Atlanta
ic = Support.Build_AirBase(ic, voProductionData, 7452, 2) -- Gulfport
ic = Support.Build_AirBase(ic, voProductionData, 7465, 2) -- Jacksonville
ic = Support.Build_AirBase(ic, voProductionData, 7494, 2) -- Houston
ic = Support.Build_AirBase(ic, voProductionData, 7670, 1) -- PuertoRico
ic = Support.Build_AirBase(ic, voProductionData, 8078, 2) -- Anchorage
ic = Support.Build_AirBase(ic, voProductionData, 8080, 2) -- Miami
ic = Support.Build_AirBase(ic, voProductionData, 8645, 2) -- Bismarck
ic = Support.Build_AirBase(ic, voProductionData, 8706, 2) -- Minneapolis
ic = Support.Build_AirBase(ic, voProductionData, 8726, 2) -- SaltLakeCity
ic = Support.Build_AirBase(ic, voProductionData, 8834, 2) -- Omaha
ic = Support.Build_AirBase(ic, voProductionData, 8835, 2) -- DesMoines
ic = Support.Build_AirBase(ic, voProductionData, 8854, 2) -- Denver
ic = Support.Build_AirBase(ic, voProductionData, 8939, 2) -- SantaFe
ic = Support.Build_AirBase(ic, voProductionData, 8962, 2) -- Phoenix
ic = Support.Build_AirBase(ic, voProductionData, 8990, 2) -- Tulsa
ic = Support.Build_AirBase(ic, voProductionData, 9016, 2) -- OklahomaCity
ic = Support.Build_AirBase(ic, voProductionData, 9019, 2) -- Clampton
ic = Support.Build_AirBase(ic, voProductionData, 9329, 3) -- SanAntonio
ic = Support.Build_AirBase(ic, voProductionData, 9420, 2) -- CorpusChristi
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end


function P.Build_NavalBase(ic, voProductionData)
	ic = Support.Build_NavalBase(ic, voProductionData, 10669, 10) --Midway
	ic = Support.Build_NavalBase(ic, voProductionData, 5825, 10) --Honolulu
	ic = Support.Build_NavalBase(ic, voProductionData, 5712, 6) -- AmamiOshima
	ic = Support.Build_NavalBase(ic, voProductionData, 5720, 6) -- TokunoShima
	ic = Support.Build_NavalBase(ic, voProductionData, 5748, 6) -- Nago
	ic = Support.Build_NavalBase(ic, voProductionData, 5759, 6) -- Naha
	ic = Support.Build_NavalBase(ic, voProductionData, 10642, 6) -- Iwo Jima
	ic = Support.Build_NavalBase(ic, voProductionData, 14129, 6) -- Bonin Islands
	ic = Support.Build_NavalBase(ic, voProductionData, 10664, 10) --Wake island

	-- Ports in Spain in case Germany takes them over
	ic = Support.Build_NavalBase(ic, voProductionData, 3884, 10) 
	ic = Support.Build_NavalBase(ic, voProductionData, 3814, 10) 
	ic = Support.Build_NavalBase(ic, voProductionData, 3676, 10) 
	ic = Support.Build_NavalBase(ic, voProductionData, 3877, 10) 
	ic = Support.Build_NavalBase(ic, voProductionData, 3679, 10) 
	ic = Support.Build_NavalBase(ic, voProductionData, 3610, 10) 
	ic = Support.Build_NavalBase(ic, voProductionData, 3675, 10) 
		
	if voProductionData.Year < 1942 then
		return ic, false
	end
	
	return ic, true
end

function P.Build_Radar(ic, voProductionData)
	return ic, false
end

function P.Build_AntiAir(ic, voProductionData)
	return ic, false
end

function P.Build_Infrastructure(ic, voProductionData)
	return ic, true
end

function P.Build_Fort(ic, voProductionData)
	return ic, false
end

function P.Build_Industry(vIC, voProductionData)

	if voProductionData.Year < 1917 then

		return vIC, true

	end

	return vIC, false
end

-- END OF PRODUTION OVERIDES
-- #######################################

function P.ForeignMinister_Alignment(...)

	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()

	if liYear >1915 then
		return Support.AlignmentPush("allies", ...)
	else
		--return Support.AlignmentNeutral(...)
	end	


end

function P.DiploScore_Embargo(voDiploScoreObj)

	if voDiploScoreObj.EmbargoHasFaction then
		local loAllyFaction = CCurrentGameState.GetFaction("allies")

		-- If USA is leaning toward the allies and UK then embargo their enemies
		if Support.IsFriend(voDiploScoreObj.ministerAI, loAllyFaction, voDiploScoreObj.ministerCountry) then
			local allyTag = loAllyFaction:GetFactionLeader()
			local loAllyCountry = allyTag:GetCountry()
			
			if loAllyCountry:GetRelation(voDiploScoreObj.EmbargoTag):HasWar() then
				voDiploScoreObj.Score = 100
			end
			
			-- Push Japan to the top of the que if they are in the Axis
			if tostring(voDiploScoreObj.EmbargoTag) == "JAP" then
				local loAxisFaction = CCurrentGameState.GetFaction("axis")
				local chiTag = CCountryDataBase.GetTag("CHI")
				
				if voDiploScoreObj.EmbargoCountry:GetFaction() == loAxisFaction
				or voDiploScoreObj.EmbargoCountry:GetRelation(chiTag):HasWar() then
					voDiploScoreObj.Score = 100
				end
			end
		end
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_Debt(voDiploScoreObj)
	local loAllyFaction = CCurrentGameState.GetFaction("allies")
	
	-- If the requesting country is part of the Allies then
	if voDiploScoreObj.ToCountry:GetFaction() == loAllyFaction then
		-- Make sure the USA is not part of a faction already
		if not(voDiploScoreObj.FromCountry:HasFaction()) then
			if Support.IsFriend(voDiploScoreObj.ministerAI, loAllyFaction, voDiploScoreObj.FromCountry) then
				-- Check to see if they are at war
				if voDiploScoreObj.ToCountry:IsAtWar() then
					-- Calculate the score based on USA neutrality the lower it is the more likely they will allow the debt
					local liNeutrality = voDiploScoreObj.FromCountry:GetEffectiveNeutrality():Get()
					voDiploScoreObj.Score = 110 - liNeutrality
				end
			end
		end
	else
		local lsToTag = tostring(voDiploScoreObj.ToTag)
		
		-- If it is China do a special check
		if lsToTag == "CHI" then
			-- If we are friendly to the Allied faction
			if Support.IsFriend(voDiploScoreObj.ministerAI, loAllyFaction, voDiploScoreObj.FromCountry) then
				local japTag = CCountryDataBase.GetTag("JAP")
				
				-- If China and Japan are at war then let China be allowed debt even if not in the Allies
				if voDiploScoreObj.ToCountry:GetRelation(japTag):HasWar() then
					voDiploScoreObj.Score = 100
				end
			end
		end
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		JAP = {Score = 100},
		ENG = {Score = 50},
		FRA = {Score = 50},
		GER = {Score = -10},
		ITA = {Score = -10},
		SOV = {Score = -10},
		CHI = {Score = 50},
		CHC = {Score = 50},
		CGX = {Score = 50},
		CSX = {Score = 50},
		CXB = {Score = 50},
		CYN = {Score = 50},
		SIK = {Score = 50}}
	
	if laTrade[voDiploScoreObj.TagName] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.TagName].Score
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_InviteToFaction(voDiploScoreObj)
	local loAllies = CCurrentGameState.GetFaction("allies")
	
	-- Only go through these checks if we are being asked to join the Allies
	if voDiploScoreObj.Faction == loAllies then
		local liYear = CCurrentGameState.GetCurrentDate():GetYear()
		local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
		local chiTag = CCountryDataBase.GetTag("CHI")
		local lochiTagCountry = chiTag:GetCountry()
		local lbChinaExists = lochiTagCountry:Exists() 
		
		-- Date check to make sure they come in within resonable time
		if liYear >= 1918 then
			voDiploScoreObj.Score = voDiploScoreObj.Score + 30
		elseif liYear >= 1917 then
			voDiploScoreObj.Score = voDiploScoreObj.Score + 20
		end
		
		-- China check see if Japan is being aggressive in China
		if lbChinaExists then
			local japTag = CCountryDataBase.GetTag("JAP")
			local loChiJapRelation = lochiTagCountry:GetRelation(japTag)
			
			-- Check to see who they are a puppet of
			if lochiTagCountry:IsPuppet() then
				local lojapTagCountry = japTag:GetCountry()
			
				-- China has been taken over by Japan
				if (loChiJapRelation:HasAlliance())
				or (lochiTagCountry:HasFaction() and lochiTagCountry:GetFaction() == lojapTagCountry:GetFaction()) then
					voDiploScoreObj.Score = voDiploScoreObj.Score + 0
				end
			else
				local lbChiJapHasWar = loChiJapRelation:HasWar()
				
				if lochiTagCountry:IsGovernmentInExile() and lbChiJapHasWar then
					voDiploScoreObj.Score = voDiploScoreObj.Score + 0
				elseif lbChiJapHasWar then
					voDiploScoreObj.Score = voDiploScoreObj.Score + 0
				end
			end
		else
			-- China is out of the war for some reason
			voDiploScoreObj.Score = voDiploScoreObj.Score + 0
		end
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_Guarantee(voDiploScoreObj)

	local recipientCountry = voDiploScoreObj.TargetTag:GetCountry()
	if not voDiploScoreObj.HasFaction then
		local continent = tostring( recipientCountry:GetCapitalLocation():GetContinent():GetTag() )
		if (continent == "north_america" or continent == "south_america")
		and not (tostring(voDiploScoreObj.TargetTag) == 'CAN') then
			return 100
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
			"HOL", -- Holland
			"SWE", -- Sweden
			"CHI", -- China
			"NOR"} -- Norway
			
		laIgnoreWatch = {
			"TUR", -- Turkey
			"SPA", -- Spain
			"SPR", -- Republic Spain
			"POR"} -- Portugal
			
		laIgnore = {
			"HUN", -- Hungary
			"ROM", -- Romania
			"BUL", -- Bulgaria
			"FIN", -- Finland
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
			"VIC"} -- Vichy
			
		-- Make a list of countries that are not in Asia and ignore them
		for loTCountry in CCurrentGameState.GetCountries() do
			if loTCountry:Exists() then
				local lsContinent = tostring(loTCountry:GetActingCapitalLocation():GetContinent():GetTag())
				-- If they are not in Asia then ignore them
				if lsContinent == "north_america" or lsContinent == "south_america" then
					table.insert(laWatch, tostring(loTCountry:GetCountryTag()))
				end
			end
		end				
	end
	
	return laWatch, laIgnoreWatch, laIgnore
end

function P.ForeignMinister_ProposeWar(voForeignMinisterData)
	if not(voForeignMinisterData.Strategy:IsPreparingWar()) then
		if voForeignMinisterData.FactionName == "allies" then
	
			-- Generic DOW for countries not part of the same faction
			if not(voForeignMinisterData.IsAtWar) then
				for loDiploStatus in voForeignMinisterData.ministerCountry:GetDiplomacy() do
					local loTargetTag = loDiploStatus:GetTarget()

					if loTargetTag:IsValid() then
						local loTargetCountry = loTargetTag:GetCountry()
						
						if loDiploStatus:GetThreat():Get() > voForeignMinisterData.ministerCountry:GetMaxNeutralityForWarWith(loTargetTag):Get()  then
							if Support.GoodToWarCheck(loTargetTag, loTargetCountry, voForeignMinisterData, true, true) then
								voForeignMinisterData.Strategy:PrepareWar(loTargetTag, 100 )
							end
						end
					end
				end
			end

			-- Special Checks Start after this point
			local loAxisTag = CCurrentGameState.GetFaction("axis"):GetFactionLeader()
			
			-- If we are atwar with the leader of the Axis then look for Vichy
			if voForeignMinisterData.ministerCountry:GetRelation(loAxisTag):HasWar() then
				local loVICTag = CCountryDataBase.GetTag("VIC")
				local loVichyCountry = loVICTag:GetCountry()
				
				if Support.GoodToWarCheck(loVICTag, loVichyCountry, voForeignMinisterData, true, false) then
					voForeignMinisterData.Strategy:PrepareWar(loVICTag, 100)
				end
			end
		end
	end
end

-- Produce slightly better trained troops
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _ADVANCED_TRAINING_ = 29
	return CLawDataBase.GetLaw(_ADVANCED_TRAINING_)
end

return AI_USA

