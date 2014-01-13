
local P = {}
AI_SAF = P

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
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
	elseif voProductionData.Year <= 1938 and not(voProductionData.IsAtWar) then
		laArray = {
			0.20, -- Land
			0.35, -- Air
			0.45, -- Sea
			0.00}; -- Other
	elseif voProductionData.IsAtWar then
		if voProductionData.Year <= 1941 then
			laArray = {
				0.30, -- Land
				0.30, -- Air
				0.40, -- Sea
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
		infantry_brigade = 8};

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

function P.ForeignMinister_Alignment(...)
	return Support.AlignmentPush("allies", ...)
end
function P.DiploScore_InviteToFaction(voDiploScoreObj)
	local loAllies = CCurrentGameState.GetFaction("allies")
	
	-- Only go through these checks if we are being asked to join the allies
	if voDiploScoreObj.Faction == loAllies then
		local liYear = CCurrentGameState.GetCurrentDate():GetYear()
		local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
		
		-- Date check to make sure they come in within resonable time
		if liYear >= 1914 then
			if liMonth >= 8 then
				voDiploScoreObj.Score = voDiploScoreObj.Score + 50
			else
				voDiploScoreObj.Score = voDiploScoreObj.Score - 200
			end
			if liYear >= 1915 then
				voDiploScoreObj.Score = voDiploScoreObj.Score + 100
			end
		else
				voDiploScoreObj.Score = voDiploScoreObj.Score - 200
		end
	end
	
	return voDiploScoreObj.Score
end


function P.DiploScore_Alliance(voDiploScoreObj)

		voDiploScoreObj.Score = 0
	return  voDiploScoreObj.Score
end

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		ENG = {Score = 20},
		AST = {Score = 20},
		CAN = {Score = 20},
		NZL = {Score = 20},
		FRA = {Score = 20}}
	
	if laTrade[voDiploScoreObj.TagName] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.TagName].Score
	end
	
	return voDiploScoreObj.Score
end
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 10350, 1) -- WalvisBay
ic = Support.Build_AirBase(ic, voProductionData, 7965, 1) -- Durban
ic = Support.Build_AirBase(ic, voProductionData, 8054, 2) -- CapeTown
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end

return AI_SAF
