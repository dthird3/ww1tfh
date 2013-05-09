local P = {}
AI_BRA = P

-- #######################################
-- Start of Tech Research
function P.LandTechs(voTechnologyData)
	local ignoreTech = {
		{"cavalry_smallarms", 4}, 
		{"cavalry_support", 3},
		{"cavalry_guns", 3}, 
		{"cavalry_at", 3},
		{"militia_smallarms", 1},
		{"militia_support", 1},
		{"militia_guns", 1},
		{"militia_at", 1},
		{"improved_police_brigade", 0},
		{"desert_warfare_equipment", 0},
		{"jungle_warfare_equipment", 7},
		{"artic_warfare_equipment", 0},
		{"amphibious_warfare_equipment", 7},
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
		"marine_infantry",
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
		{"operational_level_command_structure", 0},
		{"tactical_command_structure", 0},
		{"integrated_support_doctrine", 0},
		{"mechanized_offensive", 0},
		{"combined_arms_warfare", 0},
		{"special_forces", 0}};
		
	local preferTech = {
		"operational_level_organisation",
		"infantry_warfare",
		"mass_assault",
		"peoples_army"}	
		
	return ignoreTech, preferTech
end

function P.ProductionWeights(voProductionData)
	local laArray
	
	-- Check to see if manpower is to low
	-- More than 100 brigades build stuff that does not use manpower
	if (voProductionData.ManpowerTotal < 60 and voProductionData.LandCountTotal > 30)
	or voProductionData.ManpowerTotal < 30 then
		laArray = {
			0.0, -- Land
			0.60, -- Air
			0.40, -- Sea
			0.00}; -- Other	
	elseif voProductionData.Year <= 1938 and not(voProductionData.IsAtWar) then
		laArray = {
			0.30, -- Land
			0.40, -- Air
			0.30, -- Sea
			0.00}; -- Other
	elseif voProductionData.IsAtWar then
		if voProductionData.Year <= 1940 then
			laArray = {
				0.30, -- Land
				0.40, -- Air
				0.30, -- Sea
				0.00}; -- Other
		else
			laArray = {
				0.60, -- Land
				0.20, -- Air
				0.20, -- Sea
				0.00}; -- Other
		end
	else
		laArray = {
			0.30, -- Land
			0.46, -- Air
			0.24, -- Sea
			0.00}; -- Other
	end
	
	return laArray
end
-- Land ratio distribution
function P.LandRatio(voProductionData)
	local laArray = {
		garrison_brigade = 1,
		infantry_brigade = 4};

	return laArray
end

-- Special Forces ratio distribution
function P.SpecialForcesRatio(voProductionData)
	local laRatio = {
		5, -- Land
		1}; -- Special Force Unit

	local laUnits = {marine_brigade = 2,
		bergsjaeger_brigade = 1};
	
	return laRatio, laUnits	
end



-- Transport to Land unit distribution
function P.TransportLandRatio(voProductionData)
	local laArray = {
		16, -- Land
		1,  -- transport
		1}  -- invasion craft
  
	return laArray
end

function P.ForeignMinister_Alignment(voForeignMinisterData)
	-- If USA is leaning toward the allies and UK is at war start shifting
	if not(voForeignMinisterData.HasFaction) then
		local loUSACountry = CCountryDataBase.GetTag("USA"):GetCountry()
		local loAllyFaction = CCurrentGameState.GetFaction("allies")
	
		if Support.IsFriend(voForeignMinisterData.ministerAI, loAllyFaction, loUSACountry) then
			return Support.AlignmentPush("allies", voForeignMinisterData, true)
		end
	end
	
	return true
end

function P.DiploScore_InviteToFaction(voDiploScoreObj)
	local loAlliedFaction = CCurrentGameState.GetFaction("allies")
	
	-- If the Allies are calling make sure USA is involved
	if voDiploScoreObj.Faction == loAlliedFaction then
		local usaTag = CCountryDataBase.GetTag("USA")
		local loUSACountry = usaTag:GetCountry()
	
		if Support.IsFriend(voDiploScoreObj.ministerAI, loAlliedFaction, loUSACountry) then
			local loUSACountry = usaTag:GetCountry()
			
			-- USA not in the allies yet so don't join
			if not(loUSACountry:GetFaction() == loAlliedFaction) then
				voDiploScoreObj.Score = 0
			end
		end
	end
	
	return voDiploScoreObj.Score
end

return AI_BRA
