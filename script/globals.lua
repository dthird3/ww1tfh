-----------------------------------------------------------
-- LUA Hearts of Iron 3 Global Variables
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 12/11/2013
-----------------------------------------------------------

--	militia_brigade = { 					#### Brigade now as specified in the units folder
--		License = true,						#### This unit can be licensed so do not remove it from the arrays (Excludes Land Units)
--		CanPara = true,						#### Can the unit Pradrop (gets counted for Air Transport building)
--		Serial = 4, 						#### How long should the serial run be (default 1)
--		Size = 3, 							#### How many of this brigade type should be used when building the division (default 1)
--		Support = 1, 						#### How many support brigades to attach to the unit (default 0)
-- 		SecondaryMain = "motorized_brigade" #### Add one unit of this type to the division always
--		SupportGroup = "Infantry", 			#### What support group to use Look at SupportType for groups
--		Type = "Land", 						#### What is the main type of the unit (Land, Naval, Air)
--		SubType = "Militia", 				#### What is the Subtype of the unit
--		SupportType = {						#### The SupportGroup that the support unit can be used with
--			"Garrison",
--			"Militia",
--			"Marine",
--			"Infantry",
--			"Motor",
--			"Armor"},
--		SubUnit = "cag",					#### Secondary unit that needs to be built for this primary unit 
--		SubQuantity = 1},                   #### Quantity of the secondary unit that needs to be built for this primary unit
UnitTypes = {
	-- Land Units
	hq_brigade = {
		Type = "Land",
		SubType = "Headquarters"},
	garrison_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Garrison",
		Type = "Land",
		SubType = "Infantry"},
	militia_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Militia",
		Type = "Land",
		SubType = "Infantry"},
	infantry_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Infantry"},
	cavalry_brigade = {
		Serial = 2,
		Size = 2,
		Type = "Land",
		SubType = "Cavalry"},
	bergsjaeger_brigade = {
		Serial = 3,
		Size = 2,
		Support = 1,
		SupportGroup = "Mountain",
		Type = "Land",
		SubType = "Special Forces"},
	marine_brigade = {
		Serial = 3,
		Size = 2,
		Support = 1,
		SupportGroup = "Marine",
		Type = "Land",
		SubType = "Special Forces"},
	partisan_brigade = {
		Type = "Land",
		SubType = "Partisan"},
	light_armor_brigade = {
		Serial = 2,
		Size = 1,
		Support = 1,
		SecondaryMain = "infantry_brigade",
		SupportGroup = "Armor",
		Type = "Land",
		SubType = "Armor"},
	armor_brigade = {
		Serial = 2,
		Size = 1,
		Support = 1,
		SecondaryMain = "infantry_brigade",
		SupportGroup = "Armor",
		Type = "Land",
		SubType = "Armor"},


	-- Support Brigades
	anti_air_brigade = {
		Type = "Land",
		SubType = "Support",
		SupportType = Utils.Set {
			"Infantry",
			"Garrison",
			"Militia"}},
	anti_tank_brigade = {
		Type = "Land",
		SubType = "Support",
		SupportType = Utils.Set {
			"Infantry",
			"Militia"}},
	artillery_brigade = {
		Type = "Land",
		SubType = "Support",
		SupportType = Utils.Set {
			"Infantry",
			"Militia"}},
	heavy_artillery_brigade = {
		Type = "Land",
		SubType = "Support",
		SupportType = Utils.Set {
			"Infantry"}},
	engineer_brigade = {
		Type = "Land",
		SubType = "Support",
		SupportType = Utils.Set {
			"Cavalry",
			"Mountain",
			"Marine",
			"Infantry",
			"Armor"}},
	police_brigade = {
		Type = "Land",
		SubType = "Support",
		SupportType = Utils.Set {
			"Garrison"}},
	armored_car_brigade = {
		Type = "Land",
		SubType = "Support",
		SupportType = Utils.Set {
			"Infantry",
			"Armor"}},
		
	-- Naval Units
	battlecruiser = {
		Type = "Naval",
		SubType = "Capital Ship"},
	battleship = {
		Type = "Naval",
		SubType = "Capital Ship"},
	dreadnaught = {
		Type = "Naval",
		SubType = "Capital Ship"},
	carrier = {
		Type = "Naval",
		SubType = "Carrier",
		SubUnit = "cag",
		SubQuantity = 2},
	escort_carrier = {
		Serial = 2,
		Type = "Naval",
		SubType = "Escort Carrier",
		SubUnit = "cag",
		SubQuantity = 1},
	cag = {
		Type = "Naval",
		SubType = "Carrier Plane"},
	destroyer = {
		License = true,
		Serial = 2,
		Type = "Naval",
		SubType = "Escort"},
	protected_cruiser = {
		License = true,
		Type = "Naval",
		SubType = "Cruiser"},
	light_cruiser = {
		License = true,
		Type = "Naval",
		SubType = "Cruiser"},
	heavy_cruiser = {
		License = true,
		Type = "Naval",
		SubType = "Cruiser"},
	coastal_submarine = {
		License = true,
		Type = "Naval",
		SubType = "Submarine"},
	submarine = {
		License = true,
		Type = "Naval",
		SubType = "Submarine"},
	longrange_submarine = {
		License = true,
		Type = "Naval",
		SubType = "Submarine"},

	-- Transport Craft (The Order matters as the last one available via tech is what the AI will build
	transport_ship = {
		Serial = 1,
		Type = "Naval",
		SubType = "Transport"},
		
	-- Invasion Craft (The Order matters as the last one available via tech is what the AI will build
	invasion_transport_ship = {
		License = true,
		Serial = 1,
		Type = "Naval",
		SubType = "Invasion"},
		
	-- Air Units
	scout = {
		License = true,
		Type = "Air",
		SubType = "Ground"},
	interceptor = {
		License = true,
		Serial = 2,
		Type = "Air",
		SubType = "Fighter"},
	airship = {
		Serial = 2,
		Type = "Air",
		SubType = "Strategic"},
	tactical_bomber = {
		License = true,
		Serial = 2,
		Type = "Air",
		SubType = "Tactical"},

	-- Secret Weapon
		
	-- Elite Units
	gurkha_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Elite Infantry"},
	waffen_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Elite Infantry"},	
	ranger_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Elite Infantry"},
	imperial_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Elite Infantry"},
	guards_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Elite Infantry"},	
	alpins_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Elite Infantry"},
	alpini_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Elite Infantry"},
	austrian_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Elite Infantry"},
	janissary_brigade = {
		Serial = 4,
		Size = 2,
		Support = 1,
		SupportGroup = "Infantry",
		Type = "Land",
		SubType = "Elite Infantry"}
}


-- Parameters for Rules
-- 	Priority 	= (integer) Priority Score used for selecting techs
--	Leadership 	= (integer) Minimum amount of leadership needed for the condition to be true (Not does not apply)
-- 	IC 			= (integer) Minimum amount of IC needed for the condition to be true (Not does not apply)
--	Not			= (True/False) Reverses conditions check instead of condition needed to be met it makes it not needed to be met
-- 	Continent	= (string) Continent the countries capital needs to be on for the condition to be true
--	Focus		= (string) Rule applies to only contries of the specified focus. (Land Strict, Land, Sea, Mixed)
-- 	Manpower	= (integer) Amount of Manpower needed for the condition to be true
-- 	Percentage	= (float) Requires "Type" to be defined, checks the percentage against the type. (Supply)
--	Ignore		= (True/False) If conditions met tech will be ignroed yes or no (assumes no if not present)
--	Quantity	= (integer) Requies "Resource" defined, it checks the quantity against the resource.
TechRules = {
	-- Infantry Equipment
	-- #########################
	desert_warfare_equipment = {
		Chk1 = { Priority = 52, Leadership = 15, IC = 50, Continent = "europe" },
		Chk2 = { Priority = 52, Leadership = 15, IC = 50, Continent = "north_america" },
		Chk3 = { Ignore = true }
	},
	jungle_warfare_equipment = {
		Chk1 = { Priority = 52, Leadership = 10, IC = 50, Continent = "asia" },
		Chk2 = { Priority = 52, Leadership = 10, IC = 50, Continent = "north_america" },
		Chk3 = { Ignore = true }
	},
	mountain_infantry = {
		Chk1 = { Priority = 81, Leadership = 5, IC = 10 }
	},
	mountain_warfare_equipment = {
		Chk1 = { Priority = 52, Leadership = 5, IC = 10 }
	},
	artic_warfare_equipment = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 50, Focus = "Land", Continent = "europe" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 50, Focus = "Land Strict", Continent = "europe" },
		Chk3 = { Ignore = true }
	},
	amphibious_warfare_equipment = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 50, Focus = "Sea" },
		Chk2 = { Priority = 50, Leadership = 15, IC = 50, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	marine_infantry = {
		Chk1 = { Priority = 80, Leadership = 8, IC = 25, Focus = "Sea" },
		Chk2 = { Priority = 80, Leadership = 8, IC = 25, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	gas_masks = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 50, Focus = "Land", Continent = "europe" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 50, Focus = "Land Strict", Continent = "europe" },
		Chk3 = { Ignore = true }
	},
		
	-- Industrial Techs
	-- #########################
	construction_engineering = {
		Chk1 = { Priority = 150, Leadership = 0, IC = 0 }
	},
	advanced_construction_engineering = {
		Chk1 = { Priority = 150, Leadership = 0, IC = 0 }
	},

	education = {
		Chk1 = { Priority = 130, Leadership = 0, IC = 0 }
	},
	mechnical_computing_machine = {
		Chk1 = { Priority = 128, Leadership = 0, IC = 0 }
	},

		
	industral_production = {
		Chk1 = { Priority = 125, Leadership = 0, IC = 0 }
	},
	industral_efficiency = {
		Chk1 = { Priority = 125, Leadership = 0, IC = 0 }
	},
		
	agriculture = {
		Chk1 = { Priority = 125, Leadership = 15, IC = 50, Manpower = 10 },
		Chk2 = { Priority = 125, Leadership = 10, IC = 40, Manpower = 5 },
		Chk3 = { Priority = 125, Leadership = 4, IC = 5, Manpower = 2 },
		Chk4 = { Priority = 80, Leadership = 15, IC = 200, Manpower = 500 },
		Chk5 = { Priority = 80, Leadership = 10, IC = 150, Manpower = 250 },
		Chk6 = { Priority = 20, Leadership = 4, IC = 5 }
	},
		
	supply_production = {
		Chk1 = { Priority = 89, Leadership = 0, IC = 0 },
		Chk2 = { Priority = 150, Leadership = 0, IC = 40, Percentage = 0.35, Type='Supply' }
	},
	supply_transportation = {
		Chk1 = { Priority = 80, Leadership = 7, IC = 50 },
		Chk2 = { Priority = 30, Leadership = 7, IC = 20 }
	},
	supply_organisation = {
		Chk1 = { Priority = 80, Leadership = 7, IC = 50 },
		Chk2 = { Priority = 30, Leadership = 7, IC = 20 }
	},
	heavy_aa_guns = {
		Chk1 = { Priority = 50, Leadership = 7, IC = 50 }
	},
	basing = {
		Chk1 = { Priority = 70, Leadership = 15, IC = 80, Focus = "Mixed" },
		Chk2 = { Priority = 90, Leadership = 15, IC = 80, Focus = "Sea" },
		Chk3 = { Ignore = true }
	},
	combat_medicine = {
		Chk1 = { Priority = 70, Leadership = 10, IC = 70 },
		Chk2 = { Ignore = true }
	},
	first_aid = {
		Chk1 = { Priority = 70, Leadership = 10, IC = 70 },
		Chk2 = { Ignore = true }
	},
	civil_defence = {
		Chk1 = { Priority = 70, Leadership = 10, IC = 70 },
		Chk2 = { Ignore = true }
	},
		

	decryption_machine = {
		Chk1 = { Priority = 60, Leadership = 10, IC = 50 }
	},
	encryption_machine = {
		Chk1 = { Priority = 60, Leadership = 10, IC = 50 }
	},



	oil_to_coal_conversion = {
		Chk1 = { Priority = 40, Leadership = 5, IC = 10, Quantity = 200, Resource = CGoodsPool._ENERGY_ },
		Chk2 = { Priority = 80, Leadership = 10, IC = 100 }
	},
	raremetal_refinning_techniques = {
		Chk1 = { Priority = 80, Leadership = 10, IC = 50, Quantity = 50, Resource = CGoodsPool._RARE_MATERIALS_ },
		Chk2 = { Priority = 60, Leadership = 0, IC = 0, Quantity = 30, Resource = CGoodsPool._RARE_MATERIALS_ },
		Chk3 = { Priority = 40, Leadership = 0, IC = 0, Quantity = 10, Resource = CGoodsPool._RARE_MATERIALS_ },
		Chk4 = { Ignore = true }
	},
	oil_refinning = {
		Chk1 = { Priority = 80, Leadership = 10, IC = 50, Quantity = 50, Resource = CGoodsPool._CRUDE_OIL_ },
		Chk2 = { Priority = 60, Leadership = 0, IC = 0, Quantity = 30, Resource = CGoodsPool._CRUDE_OIL_ },
		Chk3 = { Priority = 40, Leadership = 0, IC = 0, Quantity = 10, Resource = CGoodsPool._CRUDE_OIL_ },
		Chk4 = { Priority = 80, Leadership = 10, IC = 100 },
		Chk5 = { Ignore = true }
	},
	steel_production = {
		Chk1 = { Priority = 80, Leadership = 10, IC = 50, Quantity = 50, Resource = CGoodsPool._METAL_ },
		Chk2 = { Priority = 60, Leadership = 0, IC = 0, Quantity = 30, Resource = CGoodsPool._METAL_ },
		Chk3 = { Priority = 40, Leadership = 0, IC = 0, Quantity = 10, Resource = CGoodsPool._METAL_ },
		Chk4 = { Ignore = true }
	},
	coal_processing_technologies = {
		Chk1 = { Priority = 80, Leadership = 10, IC = 50, Quantity = 50, Resource = CGoodsPool._ENERGY_ },
		Chk2 = { Priority = 60, Leadership = 0, IC = 0, Quantity = 30, Resource = CGoodsPool._ENERGY_ },
		Chk3 = { Priority = 40, Leadership = 0, IC = 0, Quantity = 10, Resource = CGoodsPool._ENERGY_ },
		Chk4 = { Ignore = true }
	},
		
	-- Mobile Techs
	-- #########################

		
	armored_car_brigade_development = {
		Chk1 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Mixed" },
		Chk2 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land" },
		Chk3 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land Strict" },
		Chk4 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Mixed" },
		Chk5 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land" },
		Chk6 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land Strict" }
	},
	lighttank_brigade = {
		Chk1 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Mixed" },
		Chk2 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land" },
		Chk3 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land Strict" },
		Chk4 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Mixed" },
		Chk5 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land" },
		Chk6 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land Strict" }
	},
	tank_brigade = {
		Chk1 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Mixed" },
		Chk2 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land" },
		Chk3 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land Strict" },
		Chk4 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Mixed" },
		Chk5 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land" },
		Chk6 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land Strict" }
	},
	tank_gun = {
		Chk1 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Mixed" },
		Chk2 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land" },
		Chk3 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land Strict" },
		Chk4 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Mixed" },
		Chk5 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land" },
		Chk6 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land Strict" }
	},
	tank_engine = {
		Chk1 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Mixed" },
		Chk2 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land" },
		Chk3 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land Strict" },
		Chk4 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Mixed" },
		Chk5 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land" },
		Chk6 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land Strict" }
	},
	tank_armour = {
		Chk1 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Mixed" },
		Chk2 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land" },
		Chk3 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land Strict" },
		Chk4 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Mixed" },
		Chk5 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land" },
		Chk6 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land Strict" }
	},
	tank_reliability = {
		Chk1 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Mixed" },
		Chk2 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land" },
		Chk3 = { Priority = 75, Leadership = 20, IC = 50, Focus = "Land Strict" },
		Chk4 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Mixed" },
		Chk5 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land" },
		Chk6 = { Priority = 35, Leadership = 15, IC = 50, Focus = "Land Strict" }
	},

	engineer_brigade_activation = {
		Chk1 = { Priority = 65, Leadership = 10, IC = 25 },
		Chk2 = { Priority = 45, Leadership = 0, IC = 0 }
	},
	engineer_assault_equipment = {
		Chk1 = { Priority = 65, Leadership = 10, IC = 25 },
		Chk2 = { Priority = 45, Leadership = 0, IC = 0 }
	},
	engineer_bridging_equipment = {
		Chk1 = { Priority = 65, Leadership = 10, IC = 25 },
		Chk2 = { Priority = 45, Leadership = 0, IC = 0 }
	},
	armored_car_armour = {
		Chk1 = { Priority = 74, Leadership = 15, IC = 0, Continent = "asia", Not=true },
		Chk2 = { Priority = 34, Leadership = 10, IC = 0, Continent = "asia", Not=true }
	},
	armored_car_gun = {
		Chk1 = { Priority = 74, Leadership = 15, IC = 0, Continent = "asia", Not=true },
		Chk2 = { Priority = 34, Leadership = 10, IC = 0, Continent = "asia", Not=true }
	},	
		
		
	-- Small Aircraft
	-- #########################
	single_engine_aircraft_design = {
		Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
	},
	basic_aeroengine = {
		Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
	},
	small_fueltank = {
		Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
	},
	single_engine_airframe = {
		Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
	},
	basic_aircraft_machinegun = {
		Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
	},

	military_aircraft_design = {
		Chk1 = { Priority = 59, Leadership = 5, IC = 0 }
	},


		
	-- Large Aircraft
	-- #########################
	twin_engine_aircraft_design = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 10, IC = 15, Focus = "Mixed" },
		Chk4 = { Priority = 40, Leadership = 0, IC = 15 }
	},
	medium_fueltank = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 10, IC = 15, Focus = "Mixed" },
		Chk4 = { Priority = 40, Leadership = 0, IC = 15 }
	},
	twin_engine_airframe = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 10, IC = 15, Focus = "Mixed" },
		Chk4 = { Priority = 40, Leadership = 0, IC = 15 }
	},
	basic_bomb = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 10, IC = 15, Focus = "Mixed" },
		Chk4 = { Priority = 40, Leadership = 0, IC = 15 }
	},
	twin_engine_aircraft_armament = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 15, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 10, IC = 15, Focus = "Mixed" },
		Chk4 = { Priority = 40, Leadership = 0, IC = 15 }
	},

		
	civ_airship_development = {
		Chk1 = { Priority = 49, Leadership = 10, IC = 150, Focus = "Mixed" },
		Chk2 = { Priority = 21, Leadership = 10, IC = 150, Focus = "Land" },
		Chk3 = { Ignore = true }
	},
	airship_development = {
		Chk1 = { Priority = 49, Leadership = 10, IC = 150, Focus = "Mixed" },
		Chk2 = { Priority = 21, Leadership = 10, IC = 150, Focus = "Land" },
		Chk3 = { Ignore = true }
	},
	airship_engine = {
		Chk1 = { Priority = 49, Leadership = 10, IC = 150, Focus = "Mixed" },
		Chk2 = { Priority = 21, Leadership = 10, IC = 150, Focus = "Land" },
		Chk3 = { Ignore = true }
	},
	airship_bomb = {
		Chk1 = { Priority = 49, Leadership = 10, IC = 150, Focus = "Mixed" },
		Chk2 = { Priority = 21, Leadership = 10, IC = 150, Focus = "Land" },
		Chk3 = { Ignore = true }
	},
	airship_structure = {
		Chk1 = { Priority = 49, Leadership = 10, IC = 150, Focus = "Mixed" },
		Chk2 = { Priority = 21, Leadership = 10, IC = 150, Focus = "Land" },
		Chk3 = { Ignore = true }
	},
		
		
		

		
		
		
	-- Escort/Small Ships
	-- #########################		
	destroyer_technology = {
		Chk1 = { Priority = 58, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	destroyer_armament = {
		Chk1 = { Priority = 58, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	destroyer_antiaircraft = {
		Chk1 = { Priority = 58, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	destroyer_engine = {
		Chk1 = { Priority = 58, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	destroyer_armour = {
		Chk1 = { Priority = 58, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},

		
	lightcruiser_technology = {
		Chk1 = { Priority = 57, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 44, Leadership = 5, IC = 25 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	lightcruiser_armament = {
		Chk1 = { Priority = 57, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 44, Leadership = 5, IC = 25 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	lightcruiser_antiaircraft = {
		Chk1 = { Priority = 57, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 44, Leadership = 5, IC = 25 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	lightcruiser_engine = {
		Chk1 = { Priority = 57, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 44, Leadership = 5, IC = 25 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	lightcruiser_armour = {
		Chk1 = { Priority = 57, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 44, Leadership = 5, IC = 25 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
		
	submarine_technology = {
		Chk1 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land Strict" },
		Chk3 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk4 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk5 = { Ignore = true }
	},
	submarine_antiaircraft = {
		Chk1 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land Strict" },
		Chk3 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk4 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk5 = { Ignore = true }
	},
	submarine_engine = {
		Chk1 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land Strict" },
		Chk3 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk4 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk5 = { Ignore = true }
	},
	submarine_hull = {
		Chk1 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land Strict" },
		Chk3 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk4 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk5 = { Ignore = true }
	},
	submarine_torpedoes = {
		Chk1 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land Strict" },
		Chk3 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk4 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk5 = { Ignore = true }
	},
	mediumsubmarine_technology = {
		Chk1 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land Strict" },
		Chk3 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk4 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk5 = { Ignore = true }
	},
	longrangesubmarine_technology = {
		Chk1 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Land Strict" },
		Chk3 = { Priority = 55, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk4 = { Priority = 45, Leadership = 5, IC = 20 },
		Chk5 = { Ignore = true }
	},
		
	smallwarship_asw = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 30, Leadership = 5, IC = 20 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
		
	-- Amphibious Techs
	amphibious_invasion_craft = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},

	amphibious_invasion_technology = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	amphibious_assault_units = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
		
		
	-- Capital Ships
	-- #########################		
	heavycruiser_technology = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk3 = { Priority = 48, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk4 = { Priority = 43, Leadership = 7, IC = 25 },
		Chk5 = { Ignore = true, Focus = "Land Strict" },
		Chk6 = { Ignore = true }
	},
	heavycruiser_armament = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk3 = { Priority = 48, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk4 = { Priority = 43, Leadership = 7, IC = 25 },
		Chk5 = { Ignore = true, Focus = "Land Strict" },
		Chk6 = { Ignore = true }
	},
	heavycruiser_antiaircraft = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk3 = { Priority = 48, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk4 = { Priority = 43, Leadership = 7, IC = 25 },
		Chk5 = { Ignore = true, Focus = "Land Strict" },
		Chk6 = { Ignore = true }
	},
	heavycruiser_engine = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk3 = { Priority = 48, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk4 = { Priority = 43, Leadership = 7, IC = 25 },
		Chk5 = { Ignore = true, Focus = "Land Strict" },
		Chk6 = { Ignore = true }
	},
	heavycruiser_armour = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk3 = { Priority = 48, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk4 = { Priority = 43, Leadership = 7, IC = 25 },
		Chk5 = { Ignore = true, Focus = "Land Strict" },
		Chk6 = { Ignore = true }
	},
		
	battlecruiser_technology = {
		Chk1 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 40, Leadership = 15, IC = 75, Focus = "Land" },
		Chk4 = { Ignore = true }
	},
	battleship_technology = {
		Chk1 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 40, Leadership = 15, IC = 75, Focus = "Land" },
		Chk4 = { Ignore = true }
	},
	super_heavy_battleship_technology = {
		Chk1 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 40, Leadership = 15, IC = 75, Focus = "Land" },
		Chk4 = { Ignore = true }
	},
	capitalship_armament = {
		Chk1 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 40, Leadership = 15, IC = 75, Focus = "Land" },
		Chk4 = { Ignore = true }
	},
	dreadnaught_antiaircraft = {
		Chk1 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 40, Leadership = 15, IC = 75, Focus = "Land" },
		Chk4 = { Ignore = true }
	},
	dreadnaught_engine = {
		Chk1 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 40, Leadership = 15, IC = 75, Focus = "Land" },
		Chk4 = { Ignore = true }
	},
	dreadnaught_armour = {
		Chk1 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 52, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 40, Leadership = 15, IC = 75, Focus = "Land" },
		Chk4 = { Ignore = true }
	},
		
	cag_development = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	escort_carrier_technology = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	carrier_technology = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	carrier_antiaircraft = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	carrier_engine = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	carrier_armour = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	carrier_hanger = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	-- Land Doctrines
	-- #########################
	mobile_warfare = {
		Chk1 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 15, IC = 100, Focus = "Mixed" },
		Chk4 = { Ignore = true }
	},
	elastic_defence = {
		Chk1 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 15, IC = 100, Focus = "Mixed" },
		Chk4 = { Ignore = true }
	},
	spearhead_doctrine = {
		Chk1 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 15, IC = 100, Focus = "Mixed" },
		Chk4 = { Ignore = true }
	},
	schwerpunkt = {
		Chk1 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 15, IC = 100, Focus = "Mixed" },
		Chk4 = { Ignore = true }
	},
	blitzkrieg = {
		Chk1 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 15, IC = 100, Focus = "Mixed" },
		Chk4 = { Ignore = true }
	},
	tactical_command_structure = {
		Chk1 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 15, IC = 100, Focus = "Mixed" },
		Chk4 = { Ignore = true }
	},
	mechanized_offensive = {
		Chk1 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 15, IC = 100, Focus = "Mixed" },
		Chk4 = { Ignore = true }
	},		
	operational_level_command_structure = {
		Chk1 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land" },
		Chk2 = { Priority = 55, Leadership = 15, IC = 100, Focus = "Land Strict" },
		Chk3 = { Priority = 50, Leadership = 15, IC = 100, Focus = "Mixed" },
		Chk4 = { Ignore = true }
	},
		
	infantry_warfare = {
		Chk1 = { Priority = 97, Leadership = 0, IC = 0}
	},
	mass_assault = {
		Chk1 = { Priority = 97, Leadership = 0, IC = 0}
	},
	large_front = {
		Chk1 = { Priority = 50, Leadership = 0, IC = 0}
	},
	peoples_army = {
		Chk1 = { Priority = 50, Leadership = 0, IC = 0}
	},
		
	delay_doctrine = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	integrated_support_doctrine = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	superior_firepower = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	special_forces = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	central_planning = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	grand_battle_plan = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	trench_warfare = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	assault_concentration = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	operational_level_organisation = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	guerilla_warfare = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	large_formations = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},
	human_wave = {
		Chk1 = { Priority = 45, Leadership = 0, IC = 0}
	},		
		
		
	-- Aircraft Doctrines
	-- #########################
	bomber_targerting_focus = {
		Chk1 = { Ignore = true }
	},
	fighter_targerting_focus = {
		Chk1 = { Ignore = true }
	},
	forward_air_control = {
		Chk1 = { Ignore = true }
	},
	battlefield_interdiction = {
		Chk1 = { Ignore = true }
	},
		
	fighter_pilot_training = {
		Chk1 = { Priority = 58, Leadership = 5, IC = 0 }
	},
	fighter_groundcrew_training = {
		Chk1 = { Priority = 58, Leadership = 5, IC = 0 }
	},
	interception_tactics = {
		Chk1 = { Priority = 58, Leadership = 5, IC = 0 }
	},
		
		
	scout_pilot_training = {
		Chk1 = { Priority = 57, Leadership = 5, IC = 0 }
	},
	aerial_photography = {
		Chk1 = { Priority = 57, Leadership = 5, IC = 0 }
	},	
	ground_attack_tactics = {
		Chk1 = { Priority = 56, Leadership = 5, IC = 0 }
	},

	tac_pilot_training = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Land" },
		Chk2 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Land Strict" },
		Chk3 = { Priority = 49, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk4 = { Priority = 39, Leadership = 0, IC = 0 }
	},
	tac_groundcrew_training = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Land" },
		Chk2 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Land Strict" },
		Chk3 = { Priority = 49, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk4 = { Priority = 39, Leadership = 0, IC = 0 }
	},
		
	interdiction_tactics = {
		Chk1 = { Priority = 52, Leadership = 10, IC = 0, Focus = "Land" },
		Chk2 = { Priority = 48, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 38, Leadership = 0, IC = 0 }
	},
	logistical_strike_tactics = {
		Chk1 = { Priority = 52, Leadership = 10, IC = 0, Focus = "Land" },
		Chk2 = { Priority = 48, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 38, Leadership = 0, IC = 0 }
	},
	installation_strike_tactics = {
		Chk1 = { Priority = 52, Leadership = 10, IC = 0, Focus = "Land" },
		Chk2 = { Priority = 48, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 38, Leadership = 0, IC = 0 }
	},
	airbase_strike_tactics = {
		Chk1 = { Priority = 52, Leadership = 10, IC = 0, Focus = "Land" },
		Chk2 = { Priority = 48, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 38, Leadership = 0, IC = 0 }
	},
	tactical_air_command = {
		Chk1 = { Priority = 52, Leadership = 10, IC = 0, Focus = "Land" },
		Chk2 = { Priority = 48, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 38, Leadership = 0, IC = 0 }
	},
	heavy_bomber_pilot_training = {
		Chk1 = { Priority = 48, Leadership = 10, IC = 150, Focus = "Mixed" },
		Chk2 = { Priority = 20, Leadership = 10, IC = 150, Focus = "Land" },
		Chk3 = { Ignore = true }
	},
	heavy_bomber_groundcrew_training = {
		Chk1 = { Priority = 48, Leadership = 10, IC = 150, Focus = "Mixed" },
		Chk2 = { Priority = 20, Leadership = 10, IC = 150, Focus = "Land" },
		Chk3 = { Ignore = true }
	},
	strategic_bombardment_tactics = {
		Chk1 = { Priority = 48, Leadership = 10, IC = 150, Focus = "Mixed" },
		Chk2 = { Priority = 20, Leadership = 10, IC = 150, Focus = "Land" },
		Chk3 = { Ignore = true }
	},
	strategic_air_command = {
		Chk1 = { Priority = 48, Leadership = 10, IC = 150, Focus = "Mixed" },
		Chk2 = { Priority = 20, Leadership = 10, IC = 150, Focus = "Land" },
		Chk3 = { Ignore = true }
	},

	nav_pilot_training = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Sea" },
		Chk2 = { Priority = 49, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 35, Leadership = 10, IC = 0 },
		Chk4 = { Ignore = true, Focus = "Land Strict" }
	},
	nav_groundcrew_training = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Sea" },
		Chk2 = { Priority = 49, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 35, Leadership = 10, IC = 0 },
		Chk4 = { Ignore = true, Focus = "Land Strict" }
	},
	portstrike_tactics = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Sea" },
		Chk2 = { Priority = 49, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 35, Leadership = 10, IC = 0 },
		Chk4 = { Ignore = true, Focus = "Land Strict" }
	},
	navalstrike_tactics = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Sea" },
		Chk2 = { Priority = 49, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 35, Leadership = 10, IC = 0 },
		Chk4 = { Ignore = true, Focus = "Land Strict" }
	},
	naval_air_targeting = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Sea" },
		Chk2 = { Priority = 49, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 35, Leadership = 10, IC = 0 },
		Chk4 = { Ignore = true, Focus = "Land Strict" }
	},
	naval_tactics = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 0, Focus = "Sea" },
		Chk2 = { Priority = 49, Leadership = 10, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 35, Leadership = 10, IC = 0 },
		Chk4 = { Ignore = true, Focus = "Land Strict" }
	},
		
		
	-- Naval Doctrines
	-- #########################

	destroyer_crew_training = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 49, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 44, Leadership = 5, IC = 20 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	spotting = {
		Chk1 = { Priority = 50, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 50, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 30, Leadership = 5, IC = 20 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},

	light_cruiser_escort_role = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 48, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 43, Leadership = 7, IC = 25 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	light_cruiser_crew_training = {
		Chk1 = { Priority = 53, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 48, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 43, Leadership = 7, IC = 25 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
		

	submarine_crew_training = {
		Chk1 = { Priority = 54, Leadership = 10, IC = 75, Focus = "Land" },
		Chk2 = { Priority = 44, Leadership = 5, IC = 20 },
		Chk3 = { Ignore = true }
	},
		
	cruiser_warfare = {
		Chk1 = { Priority = 47, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 47, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 42, Leadership = 7, IC = 25 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	cruiser_crew_training = {
		Chk1 = { Priority = 47, Leadership = 10, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 47, Leadership = 10, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 42, Leadership = 7, IC = 25 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
		
	battlefleet_concentration_doctrine = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 44, Leadership = 15, IC = 75 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	battleship_crew_training = {
		Chk1 = { Priority = 51, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 51, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 44, Leadership = 15, IC = 75 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},

	carrier_group_doctrine = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 45, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	carrier_crew_training = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 45, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
		
	sea_lane_defence = {
		Chk1 = { Priority = 70, Leadership = 10, IC = 60, Focus = "Sea" },
		Chk2 = { Priority = 70, Leadership = 10, IC = 60, Focus = "Mixed" },
		Chk3 = { Priority = 50, Leadership = 0, IC = 0 },
	},
	commerce_defence = {
		Chk1 = { Priority = 50, Leadership = 0, IC = 0, Focus = "Sea" },
		Chk2 = { Priority = 50, Leadership = 0, IC = 0, Focus = "Mixed" },
		Chk3 = { Priority = 45, Leadership = 0, IC = 0 },
	},
	destroyer_escort_role = {
		Chk1 = { Priority = 45, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 45, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Priority = 30, Leadership = 15, IC = 125, Focus = "Land" },
		Chk4 = { Priority = 20, Leadership = 0, IC = 0 }
	},
	trade_interdiction_submarine_doctrine = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 125, Focus = "Land" },
		Chk2 = { Priority = 40, Leadership = 7, IC = 50 },
		Chk3 = { Priority = 30, Leadership = 5, IC = 0 },
	},
	unrestricted_submarine_warfare_doctrine = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 125, Focus = "Land" },
		Chk2 = { Priority = 40, Leadership = 7, IC = 50 },
		Chk3 = { Priority = 30, Leadership = 5, IC = 0 },
	},	
		
		
	fleet_auxiliary_submarine_doctrine = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 125, Focus = "Land" },
		Chk2 = { Priority = 40, Leadership = 7, IC = 50 },
		Chk3 = { Priority = 30, Leadership = 5, IC = 0 },
	},	
	fire_control_system_training = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 50, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 45, Leadership = 15, IC = 75 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},
	commander_decision_making = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 75, Focus = "Sea" },
		Chk2 = { Priority = 50, Leadership = 15, IC = 75, Focus = "Mixed" },
		Chk3 = { Priority = 45, Leadership = 15, IC = 75 },
		Chk4 = { Ignore = true, Focus = "Land Strict" },
		Chk5 = { Ignore = true }
	},		

	fleet_auxiliary_carrier_doctrine = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 45, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	carrier_task_force = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 45, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},
	naval_underway_repleshment = {
		Chk1 = { Priority = 50, Leadership = 15, IC = 125, Focus = "Sea" },
		Chk2 = { Priority = 45, Leadership = 15, IC = 125, Focus = "Mixed" },
		Chk3 = { Ignore = true }
	},

	
	
	-- other techs
cavalry_smallarms = {
Chk1 = { Ignore = true }
},
cavalry_support = {
Chk1 = { Ignore = true }
},
cavalry_guns = {
Chk1 = { Ignore = true }
},
cavalry_at = {
Chk1 = { Ignore = true }
},
militia_smallarms = {
Chk1 = { Ignore = true }
},
militia_support = {
Chk1 = { Ignore = true }
},
militia_guns = {
Chk1 = { Ignore = true }
},
militia_at = {
Chk1 = { Ignore = true }
},
infantry_activation = {
Chk1 = { Priority = 100, Leadership = 0, IC = 0 }
},
smallarms_technology = {
Chk1 = { Priority = 100, Leadership = 0, IC = 0 }
},
infantry_support = {
Chk1 = { Priority = 100, Leadership = 0, IC = 0 }
},
infantry_guns = {
Chk1 = { Priority = 100, Leadership = 0, IC = 0 }
},
infantry_at = {
Chk1 = { Priority = 100, Leadership = 0, IC = 0 }
},
imporved_police_brigade = {
Chk1 = { Ignore = true }
},
civilian_aviation = {
Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
},
air_launched_torpedo = {
Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
},
small_bomb = {
Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
},
single_engine_aircraft_armament = {
Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
},
aeroengine = {
Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
},
medium_bomb = {
Chk1 = { Priority = 60, Leadership = 5, IC = 0 }
},
lighttank_gun = {
Chk1 = { Priority = 75, Leadership = 10, IC = 80 }
},
lighttank_engine = {
Chk1 = { Priority = 75, Leadership = 10, IC = 80 }
},
lighttank_armour = {
Chk1 = { Priority = 75, Leadership = 10, IC = 80 }
},
lighttank_reliability = {
Chk1 = { Priority = 75, Leadership = 10, IC = 80 }
},
at_brigade = {
Chk1 = { Priority = 40, Leadership = 5, IC = 0 }
},
aa_brigade = {
Chk1 = { Priority = 20, Leadership = 5, IC = 0 }
},
art_brigade = {
Chk1 = { Priority = 750, Leadership = 5, IC = 0 }
},
art_barrell_ammo = {
Chk1 = { Priority = 750, Leadership = 5, IC = 0 }
},
art_barrell = {
Chk1 = { Priority = 750, Leadership = 5, IC = 0 }
},
art_howitzer = {
Chk1 = { Priority = 750, Leadership = 5, IC = 0 }
},
art_carriage_sights = {
Chk1 = { Priority = 750, Leadership = 5, IC = 0 }
},
at_barrell_sights = {
Chk1 = { Priority = 40, Leadership = 5, IC = 0 }
},
at_ammo_muzzel = {
Chk1 = { Priority = 40, Leadership = 5, IC = 0 }
},
aa_barrell_ammo = {
Chk1 = { Priority = 20, Leadership = 5, IC = 0 }
},
aa_carriage_sights = {
Chk1 = { Priority = 20, Leadership = 5, IC = 0 }
},
heavy_artillery_development = {
Chk1 = { Priority = 55, Leadership = 8, IC = 50 }
},
hart_barrell_ammo = {
Chk1 = { Priority = 55, Leadership = 8, IC = 50 }
},
hart_barrell = {
Chk1 = { Priority = 55, Leadership = 8, IC = 50 }
},
hart_super = {
Chk1 = { Priority = 55, Leadership = 8, IC = 50 }
},
hart_carriage_sights = {
Chk1 = { Priority = 55, Leadership = 8, IC = 50 }
},
combat_engineering = {
Chk1 = { Priority = 55, Leadership = 8, IC = 50 }
},
rolling_barrage = {
Chk1 = { Priority = 55, Leadership = 5, IC = 0 }
},
protectedcruiser_technology = {
Chk1 = { Ignore = true }
},
protectedcruiser_armament = {
Chk1 = { Ignore = true }
},
protectedcruiser_antiaircraft = {
Chk1 = { Ignore = true }
},
protectedcruiser_engine = {
Chk1 = { Ignore = true }
},
protectedcruiser_armour = {
Chk1 = { Ignore = true }
},
battlecruiser_antiaircraft = {
Chk1 = { Ignore = true }
},
battlecruiser_engine = {
Chk1 = { Ignore = true }
},
battlecruiser_armour = {
Chk1 = { Ignore = true }
},
battleship_antiaircraft = {
Chk1 = { Ignore = true }
},
battleship_engine = {
Chk1 = { Ignore = true }
},
battleship_armour = {
Chk1 = { Ignore = true }
},
battleship_armament = {
Chk1 = { Ignore = true }
},
poison_gas = {
Chk1 = { Priority = 35, Leadership = 10, IC = 80 }
},
poison_gas_cylinders = {
Chk1 = { Priority = 35, Leadership = 10, IC = 80 }
},
poison_gas_shells = {
Chk1 = { Priority = 35, Leadership = 10, IC = 80 }
},
submarine_engineering_research = {
Chk1 = { Ignore = true }
},
aeronautic_engineering_research = {
Chk1 = { Ignore = true }
},
chemical_engineering_research = {
Chk1 = { Ignore = true }
},
mechanicalengineering_research = {
Chk1 = { Ignore = true }
},
automotive_research = {
Chk1 = { Ignore = true }
},
artillery_research = {
Chk1 = { Ignore = true }
},
mobile_research = {
Chk1 = { Ignore = true }
},
militia_research = {
Chk1 = { Ignore = true }
},
infantry_research = {
Chk1 = { Ignore = true }
},
airship_research = {
Chk1 = { Ignore = true }
}

	-- Secret Weapons
	-- #########################

}
	