local P = {}
AI_AST = P

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
		{"tank_reliability", 0}};	

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
			0.50, -- Air
			0.50, -- Sea
			0.00}; -- Other	
	elseif voProductionData.Year <= 1939 and not(voProductionData.IsAtWar) then
		laArray = {
			0.00, -- Land
			0.40, -- Air
			0.65, -- Sea
			0.00}; -- Other
	elseif voProductionData.IsAtWar then
		if voProductionData.Year <= 1941 then
			laArray = {
				0.15, -- Land
				0.35, -- Air
				0.50, -- Sea
				0.00}; -- Other
		else
			laArray = {
				0.50, -- Land
				0.20, -- Air
				0.30, -- Sea
				0.00}; -- Other
		end
	else
		laArray = {
			0.30, -- Land
			0.36, -- Air
			0.34, -- Sea
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

	local laUnits = {marine_brigade = 1,
		bergsjaeger_brigade = 1};
	
	return laRatio, laUnits	
end

-- Transport to Land unit distribution
function P.TransportLandRatio(voProductionData)
	local laArray = {
		12, -- Land
		1,  -- transport
		1}  -- invasion craft
  
	return laArray
end

function P.AirRatio(voProductionData)
	local laArray = {
		interceptor = 4,
		tactical_bomber = 7};	
	return laArray
end

-- Build a few air bases
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 10262, 1) -- Broome
ic = Support.Build_AirBase(ic, voProductionData, 6566, 2) -- PortMoresby
ic = Support.Build_AirBase(ic, voProductionData, 6596, 2) -- Darwin
ic = Support.Build_AirBase(ic, voProductionData, 7923, 2) -- Brisbane
ic = Support.Build_AirBase(ic, voProductionData, 7950, 2) -- Perth
ic = Support.Build_AirBase(ic, voProductionData, 7989, 2) -- Sydney
ic = Support.Build_AirBase(ic, voProductionData, 8062, 2) -- Geelong
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end


function P.ForeignMinister_Alignment(...)
	return Support.AlignmentPush("allies", ...)
end

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		ENG = {Score = 20},
		CAN = {Score = 20},
		SAF = {Score = 20},
		NZL = {Score = 20},
		FRA = {Score = 20}}
	
	if laTrade[voDiploScoreObj.TagName] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.TagName].Score
	end
	
	return voDiploScoreObj.Score
end

return AI_AST
