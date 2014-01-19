
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
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 4831, 4) -- Qusayban
ic = Support.Build_AirBase(ic, voProductionData, 9100, 2) -- AlMawsil
ic = Support.Build_AirBase(ic, voProductionData, 9183, 2) -- Kifri
ic = Support.Build_AirBase(ic, voProductionData, 9213, 2) -- Baghdad
ic = Support.Build_AirBase(ic, voProductionData, 4188, 4) -- Trabzon
ic = Support.Build_AirBase(ic, voProductionData, 4253, 2) -- Bafra
ic = Support.Build_AirBase(ic, voProductionData, 4503, 2) -- Istanbul
ic = Support.Build_AirBase(ic, voProductionData, 4505, 2) -- Duzce
ic = Support.Build_AirBase(ic, voProductionData, 4513, 2) -- Erzurum
ic = Support.Build_AirBase(ic, voProductionData, 4560, 2) -- Malkara
ic = Support.Build_AirBase(ic, voProductionData, 4615, 2) -- Bursa
ic = Support.Build_AirBase(ic, voProductionData, 4619, 2) -- Ankara
ic = Support.Build_AirBase(ic, voProductionData, 4728, 2) -- Kirikkale
ic = Support.Build_AirBase(ic, voProductionData, 4883, 2) -- Gaziantep
ic = Support.Build_AirBase(ic, voProductionData, 4966, 4) -- Izmir
ic = Support.Build_AirBase(ic, voProductionData, 4968, 3) -- Denizli
ic = Support.Build_AirBase(ic, voProductionData, 5013, 2) -- Icel
ic = Support.Build_AirBase(ic, voProductionData, 5045, 2) -- Antalya
ic = Support.Build_AirBase(ic, voProductionData, 7332, 2) -- Batman
ic = Support.Build_AirBase(ic, voProductionData, 5299, 3) -- Beirut
ic = Support.Build_AirBase(ic, voProductionData, 5360, 4) -- Sour
ic = Support.Build_AirBase(ic, voProductionData, 9073, 2) -- TallBirak
ic = Support.Build_AirBase(ic, voProductionData, 5535, 4) -- TelAvivYafo
ic = Support.Build_AirBase(ic, voProductionData, 5567, 3) -- Jerusalem
ic = Support.Build_AirBase(ic, voProductionData, 5633, 3) -- ElKuntilla
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
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
return AI_TUR
