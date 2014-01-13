-----------------------------------------------------------
-- LUA Hearts of Iron 3 Minister File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/1/2013
-----------------------------------------------------------
local P = {}
Politics_Minister = P

-- #######################
-- Called by politics.lua
-- #######################
function P.ChangeMinister(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("ChangeMinister")
	-- Positions definitions
	-- Each position has an index, a callback function, a government position index, and a list of available CMinister objects
	-- We assert the existance of 8 changeable positions, and bind them to a lua callback function
	local laPositions = {
		CHIEF_OF_AIR = {
			Index = 10,
			Callback = P.ChiefOfAir, 
			GovPosition = CGovernmentPositionDataBase.GetGovernmentPositionByIndex(10),
			AvailableMinisters = {},
			PersonalityScore = {}
		},
		CHIEF_OF_NAVY = {
			Index = 9,
			Callback = P.ChiefOfNavy, 
			GovPosition = CGovernmentPositionDataBase.GetGovernmentPositionByIndex(9), 
			AvailableMinisters = {},
			PersonalityScore = {}
		},
		CHIEF_OF_ARMY = {
			Index = 8,
			Callback = P.ChiefOfArmy, 
			GovPosition = CGovernmentPositionDataBase.GetGovernmentPositionByIndex(8), 
			AvailableMinisters = {},
			PersonalityScore = {}
		},
		CHIEF_OF_STAFF = {
			Index = 7,
			Callback = P.ChiefOfStaff, 
			GovPosition = CGovernmentPositionDataBase.GetGovernmentPositionByIndex(7), 
			AvailableMinisters = {},
			PersonalityScore = {}
		},
		MINISTER_OF_INTELLIGENCE = {
			Index = 6,
			Callback = P.MinisterOfIntelligence, 
			GovPosition = CGovernmentPositionDataBase.GetGovernmentPositionByIndex(6), 
			AvailableMinisters = {},
			PersonalityScore = {}
		},
		MINISTER_OF_SECURITY = {
			Index = 5,
			Callback = P.MinisterOfSecurity, 
			GovPosition = CGovernmentPositionDataBase.GetGovernmentPositionByIndex(5), 
			AvailableMinisters = {},
			PersonalityScore = {}
		},
		ARMAMENT_MINISTER = {
			Index = 4,
			Callback = P.ArmamentMinister, 
			GovPosition = CGovernmentPositionDataBase.GetGovernmentPositionByIndex(4), 
			AvailableMinisters = {},
			PersonalityScore = {}
		},
		FOREIGN_MINISTER = {
			Index = 3,
			Callback = P.ForeignMinister, 
			GovPosition = CGovernmentPositionDataBase.GetGovernmentPositionByIndex(3), 
			AvailableMinisters = {},
			PersonalityScore = {}
		}
	}
	
	-- Organize the ministers by positions they can take
	for loMinister in voPoliticsMinisterData.Country:GetPossibleMinisters() do
		-- Make sure we are the same Ideology
		if voPoliticsMinisterData.IdeologyGroup == loMinister:GetIdeology():GetGroup() then
			-- Cycle through positions
			for k, v in pairs(laPositions) do
				if loMinister:IsValid() then
					-- If current minister can take current position, append it to current position AvailableMinisters
					if loMinister:CanTakePosition(v.GovPosition) then
						table.insert(laPositions[k].AvailableMinisters, loMinister)
					end
				end
			end
		end
	end
	
	-- Add things to the voPoliticsMinisterData that we need here
	voPoliticsMinisterData.Local.PortsTotal = voPoliticsMinisterData.Country:GetNumOfPorts()
	voPoliticsMinisterData.Local.Manpower = voPoliticsMinisterData.Country:GetManpower():Get()
	
	-- Now get the scores for each position
	for k, v in pairs(laPositions) do
	
		-- First Load up the scores
		local lbProcess = true
		local loFunRef = Support_Country.Get_Function(voPoliticsMinisterData, "ChangeMinister_" .. k)
		
		-- Custom method check it
		if loFunRef then
			lbProcess, v.PersonalityScore = loFunRef(voPoliticsMinisterData)
		end	
		
		if lbProcess then
			v.PersonalityScore = v.Callback(voPoliticsMinisterData)
		end
		-- End of Score Loading
		
		-- Now Process the ministers
		local loSelectedMinister = nil 
		local liCurrentScore = 0 
		
		for liIndex, loMinister in pairs(v.AvailableMinisters) do 
			local liScore = 0 
			local lsMinisterType = tostring(loMinister:GetPersonality(v.GovPosition):GetKey()) 

			-- Check to make sure its a minister whose trait gets a score
			if v.PersonalityScore[lsMinisterType] ~= nil then 
				liScore = v.PersonalityScore[lsMinisterType] 
				
				if liScore > liCurrentScore then 
					liCurrentScore = liScore 
					loSelectedMinister = loMinister 
				end 
			end 
		end 
		
		-- Setup the minister
		if loSelectedMinister ~= nil then 
			if voPoliticsMinisterData.Country:GetMinister(v.GovPosition) ~= loSelectedMinister then 
				P.Command_ChangeMinister(voPoliticsMinisterData.ministerAI, voPoliticsMinisterData.Tag, loSelectedMinister, v.GovPosition)
			end 
		end 
	end
end

-- #######################
-- Support Methods
-- #######################
function P.Command_ChangeMinister(vAI, voFromTag, voMinister, voPosition)
--Utils.LUA_DEBUGOUT("Command_ChangeMinister")
	local loCommand = CChangeMinisterCommand(voFromTag, voMinister, voPosition)
	vAI:Post(loCommand)
	return true
end
-- ###############################################
-- END OF Support methods
-- ###############################################

--################
-- Scoring Methods
--################
function P.MinisterOfSecurity(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("MinisterOfSecurity")
	local laPersonalityScore = {}

	if voPoliticsMinisterData.IsAtWar then 
		laPersonalityScore["man_of_the_people"] = 70 
		laPersonalityScore["efficient_sociopath"] = 60 
		laPersonalityScore["crime_fighter"] = 50 
		laPersonalityScore["compassionate_gentleman"] = 40 
		laPersonalityScore["silent_lawyer"] = 30 
		laPersonalityScore["prince_of_terror"] = 20 
		laPersonalityScore["back_stabber"] = 10 
	else 
		laPersonalityScore["man_of_the_people"] = 70 
		laPersonalityScore["silent_lawyer"] = 60 
		laPersonalityScore["compassionate_gentleman"] = 50 
		laPersonalityScore["efficient_sociopath"] = 40 
		laPersonalityScore["crime_fighter"] = 30 
		laPersonalityScore["prince_of_terror"] = 20 
		laPersonalityScore["back_stabber"] = 10 
	end 
	
	return laPersonalityScore
end
function P.ArmamentMinister(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("ArmamentMinister")
	local laPersonalityScore = {}
	local liExpenseFactor, liHomeFactor = Prod_Buildings.CalculateExpenseResourceFactor(voPoliticsMinisterData.Country)
	
	-- We are short on resources
	if liExpenseFactor > liHomeFactor then
		laPersonalityScore["military_entrepreneur"] = 150 
		laPersonalityScore["resource_industrialist"] = 140 
		laPersonalityScore["administrative_genius"] = 130 
		laPersonalityScore["laissez_faires_capitalist"] = 120 
		laPersonalityScore["theoretical_scientist"] = 110 
		laPersonalityScore["infantry_proponent"] = 100 
		laPersonalityScore["air_to_ground_proponent"] = 90 
		laPersonalityScore["air_superiority_proponent"] = 80 
		laPersonalityScore["battle_fleet_proponent"] = 70 
		laPersonalityScore["air_to_sea_proponent"] = 60 
		laPersonalityScore["strategic_air_proponent"] = 50 
		laPersonalityScore["submarine_proponent"] = 40 
		laPersonalityScore["tank_proponent"] = 30 
		laPersonalityScore["corrupt_kleptocrat"] = 20 
		laPersonalityScore["crooked_kleptocrat"] = 10
	elseif voPoliticsMinisterData.IsAtWar then 
		laPersonalityScore["administrative_genius"] = 150 
		laPersonalityScore["military_entrepreneur"] = 140 
		laPersonalityScore["resource_industrialist"] = 130 
		laPersonalityScore["laissez_faires_capitalist"] = 120
		laPersonalityScore["theoretical_scientist"] = 110 
		laPersonalityScore["infantry_proponent"] = 100 
		laPersonalityScore["air_to_ground_proponent"] = 90 
		laPersonalityScore["air_superiority_proponent"] = 80 
		laPersonalityScore["battle_fleet_proponent"] = 70 
		laPersonalityScore["air_to_sea_proponent"] = 60 
		laPersonalityScore["strategic_air_proponent"] = 50 
		laPersonalityScore["submarine_proponent"] = 40 
		laPersonalityScore["tank_proponent"] = 30 
		laPersonalityScore["corrupt_kleptocrat"] = 20 
		laPersonalityScore["crooked_kleptocrat"] = 10 	
	else
		laPersonalityScore["administrative_genius"] = 150 
		laPersonalityScore["resource_industrialist"] = 140 
		laPersonalityScore["laissez_faires_capitalist"] = 130 
		laPersonalityScore["military_entrepreneur"] = 120 
		laPersonalityScore["theoretical_scientist"] = 110 
		laPersonalityScore["infantry_proponent"] = 100 
		laPersonalityScore["air_to_ground_proponent"] = 90 
		laPersonalityScore["air_superiority_proponent"] = 80 
		laPersonalityScore["battle_fleet_proponent"] = 70 
		laPersonalityScore["air_to_sea_proponent"] = 60 
		laPersonalityScore["strategic_air_proponent"] = 50 
		laPersonalityScore["submarine_proponent"] = 40 
		laPersonalityScore["tank_proponent"] = 30 
		laPersonalityScore["corrupt_kleptocrat"] = 20 
		laPersonalityScore["crooked_kleptocrat"] = 10 
	end
	
	return laPersonalityScore
end
function P.ForeignMinister(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("ForeignMinister")
	local laPersonalityScore = {}
	
	-- Foreign minister pick depends mainly on current faction 
	if voPoliticsMinisterData.FactionName == "comintern" then 
		laPersonalityScore["biased_intellectual"] = 50 
	elseif voPoliticsMinisterData.FactionName == "allies" then 
		laPersonalityScore["the_cloak_n_dagger_schemer"] = 50 
	elseif voPoliticsMinisterData.FactionName == "axis" then 
		laPersonalityScore["great_compromiser"] = 50 
	end 

	laPersonalityScore["apologetic_clerk"] = 40 
	laPersonalityScore["ideological_crusader"] = 30 

	-- Some foreign minister are irrelevant while at war 
	if not(voPoliticsMinisterData.IsArwar) then 
		laPersonalityScore["general_staffer"] = 20 
	end 
	
	laPersonalityScore["iron_fisted_brute"] = 10 
	
	return laPersonalityScore
end
function P.ChiefOfStaff(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("ChiefOfStaff")
	local laPersonalityScore = {}
	
	if voPoliticsMinisterData.IsAtWar then 
		if voPoliticsMinisterData.Local.Manpower < 40 then 
			laPersonalityScore["school_of_mass_combat"] = 60 
			laPersonalityScore["school_of_psychology"] = 50 
		else 
			laPersonalityScore["school_of_psychology"] = 60 
			laPersonalityScore["school_of_mass_combat"] = 50 
		end              
		
		laPersonalityScore["logistics_specialist"] = 40 
		laPersonalityScore["school_of_fire_support"] = 30 
		laPersonalityScore["school_of_defence"] = 20 
		laPersonalityScore["school_of_manoeuvre"] = 10 
	else 
		laPersonalityScore["school_of_mass_combat"] = 60 
		laPersonalityScore["logistics_specialist"] = 50 
		laPersonalityScore["school_of_fire_support"] = 40 
		laPersonalityScore["school_of_defence"] = 30 
		laPersonalityScore["school_of_manoeuvre"] = 20 
		laPersonalityScore["school_of_psychology"] = 10 
	end 
	
	return laPersonalityScore
end
function P.MinisterOfIntelligence(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("MinisterOfIntelligence")
	local laPersonalityScore = {}
	
	if voPoliticsMinisterData.Local.PortsTotal > 0 and voPoliticsMinisterData.IcOBJ.IC > 30 then
		laPersonalityScore["dismal_enigma"] = 60 
		laPersonalityScore["research_specialist"] = 50 
	else
		laPersonalityScore["research_specialist"] = 60 
		laPersonalityScore["dismal_enigma"] = 50 
	end
	
	laPersonalityScore["naval_intelligence_specialist"] = 40 
	laPersonalityScore["technical_specialist"] = 30 
	laPersonalityScore["industrial_specialist"] = 20 
	laPersonalityScore["political_specialist"] = 10 

	return laPersonalityScore
end
function P.ChiefOfArmy(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("ChiefOfArmy")
	local laPersonalityScore = {}

	laPersonalityScore["guns_and_butter_doctrine"] = 50 
	laPersonalityScore["static_defence_doctrine"] = 40 
	laPersonalityScore["decisive_battle_doctrine"] = 30 
	laPersonalityScore["elastic_defence_doctrine"] = 20 
	laPersonalityScore["armoured_spearhead_doctrine"] = 10 

	return laPersonalityScore
end
function P.ChiefOfNavy(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("ChiefOfNavy")
	local laPersonalityScore = {}

	laPersonalityScore["decisive_naval_battle_doctrine"] = 50 
	laPersonalityScore["indirect_approach_doctrine"] = 40 
	laPersonalityScore["open_seas_doctrine"] = 30 
	laPersonalityScore["base_control_doctrine"] = 20 
	laPersonalityScore["power_projection_doctrine"] = 10 

	return laPersonalityScore
end
function P.ChiefOfAir(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("ChiefOfAir")
	local laPersonalityScore = {}

	laPersonalityScore["air_superiority_doctrine"] = 50 
	laPersonalityScore["army_aviation_doctrine"] = 40 
	laPersonalityScore["naval_aviation_doctrine"] = 30 
	laPersonalityScore["carpet_bombing_doctrine"] = 20 
	laPersonalityScore["vertical_envelopment_doctrine"] = 10
	
	if voPoliticsMinisterData.Local.PortsTotal > 0 and voPoliticsMinisterData.IcOBJ.IC > 30 then
		laPersonalityScore["army_aviation_doctrine"] = 30 
		laPersonalityScore["naval_aviation_doctrine"] = 40
	end

	return laPersonalityScore
end
--################
-- End of Scoring Methods
--################

return Politics_Minister