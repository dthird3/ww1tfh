
local P = {}
AI_ROM = P


-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(voProductionData)
	local laArray
	
	-- Check to see if manpower is to low
	-- More than 100 brigades build stuff that does not use manpower
	if (voProductionData.ManpowerTotal < 90 and voProductionData.LandCountTotal > 45)
	or voProductionData.ManpowerTotal < 45 then
		laArray = {
			0.0, -- Land
			0.60, -- Air
			0.40, -- Sea
			0.00}; -- Other	
	elseif voProductionData.Year <= 1912 and not(voProductionData.IsAtWar) then
		laArray = {
			0.40, -- Land
			0.15, -- Air
			0.45, -- Sea
			0.00}; -- Other
	elseif voProductionData.IsAtWar then
		if voProductionData.Year <= 1939 then
			laArray = {
				0.40, -- Land
				0.20, -- Air
				0.40, -- Sea
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
			0.35, -- Air
			0.35, -- Sea
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

	local laUnits = { bergsjaeger_brigade = 1};
	
	return laRatio, laUnits	
end

-- Transport to Land unit distribution
function P.TransportLandRatio(voProductionData)
	local laArray = {
		0, -- Land
		0,  -- transport
		0}  -- invasion craft
  
	return laArray
end
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 3917, 2) -- Bucuresti
ic = Support.Build_AirBase(ic, voProductionData, 3919, 1) -- Constanta
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		GER = {Score = -50},
		AUH = {Score = -100},
		TUR = {Score = -20},
		SOV = {Score = 50},
		ENG = {Score = 20},
		FRA = {Score = 20}}
	
	if laTrade[voDiploScoreObj.TagName] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.TagName].Score
	end
	
	return voDiploScoreObj.Score
end

function P.ForeignMinister_Alignment(voForeignMinisterData)

	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
	if liYear > 1914 then
		return Support.AlignmentPush("allies", voForeignMinisterData, true, true)
	else
		--return Support.AlignmentNeutral(...)
	end	


end

function P.DiploScore_InviteToFaction(voDiploScoreObj)
	local loAllies = CCurrentGameState.GetFaction("allies")
	
	-- Only go through these checks if we are being asked to join the Axis
	if voDiploScoreObj.Faction == loAllies then
		local liYear = CCurrentGameState.GetCurrentDate():GetYear()
		local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
		
		-- Date check to make sure they come in within resonable time
		if liYear >= 1916 then
			if liMonth >= 8 then
				voDiploScoreObj.Score = voDiploScoreObj.Score + 50
			else
				voDiploScoreObj.Score = voDiploScoreObj.Score - 200
			end
			if liYear >= 1917 then
				voDiploScoreObj.Score = voDiploScoreObj.Score + 100
			end
		else
			voDiploScoreObj.Score = voDiploScoreObj.Score - 200
		end
	end
	
	return voDiploScoreObj.Score
end
function DiploScore_PeaceAction(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	return 0
end
return AI_ROM