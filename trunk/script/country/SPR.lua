
local P = {}
AI_SPR = P


function P.ProductionWeights(voProductionData)
	local laArray
	
	-- Check to see if manpower is to low
	if (voProductionData.ManpowerTotal < 60 and voProductionData.LandCountTotal > 30)
	or voProductionData.ManpowerTotal < 30 then
		laArray = {
			0.0, -- Land
			0.57, -- Air
			0.42, -- Sea
			0.01}; -- Other
			
	elseif voProductionData.IsAtWar then
			laArray = {
				0.40, -- Land
				0.35, -- Air
				0.25, -- Sea
				0.00}; -- Other
		else
           laArray = {
				0.10, -- Land
				0.51, -- Air
				0.39, -- Sea
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

	local laUnits = {bergsjaeger_brigade = 1};
	
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

function P.Build_CoastalFort(ic, voProductionData)
	return ic, false
end

function P.Build_AntiAir(ic, voProductionData)
	return ic, false
end

function P.DiploScore_InviteToFaction(voDiploScoreObj)
	local spaTag = CCountryDataBase.GetTag("SPA")
	
	-- Is Spanish Civil War still going on?
	if voDiploScoreObj.TargetCountry:GetRelation(spaTag):HasWar() then
		voDiploScoreObj.Score = 0 -- not interested in factions until we sorted out things at home
	
	-- Penalty hit if Gibraltar and London are both controlled by the UK
	--   Make sure UK is not part of the Axis as well in the check in case they are a puppet
	else
		local loAxis = CCurrentGameState.GetFaction("axis")
		local engTag = CCountryDataBase.GetTag("ENG")
		
		if voDiploScoreObj.Faction == loAxis
		and not(engTag:GetCountry():GetFaction() == loAxis) then
			if CCurrentGameState.GetProvince(1964):GetController() == engTag -- London check
			and CCurrentGameState.GetProvince(5191):GetController() == engTag then -- Gibraltar check
				voDiploScoreObj.Score = 0
			end
		elseif voDiploScoreObj.Faction == CCurrentGameState.GetFaction("allies") then -- dont join if bordering germany
			if voDiploScoreObj.TargetCountry:IsNonExileNeighbour( CCountryDataBase.GetTag("GER") ) then
				voDiploScoreObj.Score = 0
			end
		end
	end
	
	return voDiploScoreObj.Score
end

return AI_SPR
