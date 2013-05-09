
local P = {}
AI_TUR = P

function P.ProductionWeights(voProductionData)
	local laArray
	
	-- Check to see if manpower is to low
	-- More than 100 brigades build stuff that does not use manpower
	if (voProductionData.ManpowerTotal < 50 and voProductionData.LandCountTotal > 25)
	or voProductionData.ManpowerTotal < 25 then
		laArray = {
			0.0, -- Land
			0.50, -- Air
			0.50, -- Sea
			0.00}; -- Other	
	elseif voProductionData.Year <= 1914 and not(voProductionData.IsAtWar) then
		laArray = {
				0.20, -- Land
				0.25, -- Air
				0.25, -- Sea
				0.30}; -- Other
	elseif voProductionData.IsAtWar then
		if voProductionData.Year <= 1914 then
			laArray = {
				0.30, -- Land
				0.15, -- Air
				0.25, -- Sea
				0.30}; -- Other
		else
			laArray = {
				0.60, -- Land
				0.15, -- Air
				0.25, -- Sea
				0.00}; -- Other
		end
	else
		laArray = {
			0.60, -- Land
			0.15, -- Air
			0.25, -- Sea
			0.00}; -- Other
	end
	
	return laArray
end
-- Land ratio distribution
function P.LandRatio(voProductionData)
	local laArray = {
		garrison_brigade = 1,
		infantry_brigade = 8};

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

-- Elite Units
function P.EliteUnits(voProductionData)
	local laUnits = {"janissary_brigade"};
	
	return laUnits	
end

-- Transport to Land unit distribution
function P.TransportLandRatio(voProductionData)
	local laArray = {
		200, -- Land
		1,  -- transport
		1}  -- invasion craft
  
	return laArray
end

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		GER = {Score = 100},
		ITA = {Score = 100},
		BUL = {Score = 20},
		ROM = {Score = 20},
		SOV = {Score = -50},
		ENG = {Score = -50},
		FRA = {Score = -20}}
	
	if laTrade[voDiploScoreObj.TagName] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.TagName].Score
	end
	
	return voDiploScoreObj.Score
end
function P.ForeignMinister_CallAlly(voForeignMinisterData)
	
	return false
end
function DiploScore_PeaceAction(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	return 0
end
return AI_TUR
