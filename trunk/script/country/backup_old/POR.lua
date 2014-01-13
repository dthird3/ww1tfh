
local P = {}
AI_POR = P

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
	elseif voProductionData.Year <= 1938 and not(voProductionData.IsAtWar) then
		laArray = {
			0.15, -- Land
			0.40, -- Air
			0.45, -- Sea
			0.00}; -- Other
	elseif voProductionData.IsAtWar then
		if voProductionData.Year <= 1941 then
			laArray = {
				0.40, -- Land
				0.30, -- Air
				0.30, -- Sea
				0.00}; -- Other
		else
			laArray = {
				0.50, -- Land
				0.25, -- Air
				0.25, -- Sea
				0.00}; -- Other
		end
	else
		laArray = {
			0.30, -- Land
			0.45, -- Air
			0.25, -- Sea
			0.00}; -- Other
	end
	
	return laArray
end
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 10085, 1) -- Cabinda
ic = Support.Build_AirBase(ic, voProductionData, 10194, 1) -- Benguela
ic = Support.Build_AirBase(ic, voProductionData, 10340, 1) -- Inhambane
ic = Support.Build_AirBase(ic, voProductionData, 10631, 1) -- Cap Verde
ic = Support.Build_AirBase(ic, voProductionData, 10632, 1) -- Sao Tome
ic = Support.Build_AirBase(ic, voProductionData, 4644, 2) -- Lisbon
ic = Support.Build_AirBase(ic, voProductionData, 5886, 1) -- Macau
ic = Support.Build_AirBase(ic, voProductionData, 8970, 2) -- Azores
ic = Support.Build_AirBase(ic, voProductionData, 9794, 1) -- Bissau
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end

function P.DiploScore_InviteToFaction(voDiploScoreObj)
	local spaTag = CCountryDataBase.GetTag("SPA")
	local sprTag = CCountryDataBase.GetTag("SPR")
	
	-- If Spanish Civil War is going on don't join any alliance
	if sprTag:GetCountry():GetRelation(spaTag):HasWar() then
		voDiploScoreObj.Score = 0 -- not interested in factions until we sorted out things at home
	
	-- Do not get involved as long as we are isolated (to easy for allies to get us)
	else
		local loAxis = CCurrentGameState.GetFaction("axis")
		
		if voDiploScoreObj.Faction == loAxis then
			local ministerContinent = voDiploScoreObj.TargetCountry:GetActingCapitalLocation():GetContinent()
			
			local loMadridContFaction = CCurrentGameState.GetProvince(4540):GetController():GetCountry():GetFaction()
			if not( loMadridContFaction == loAxis) then
				return 0
			end
		end
	end
	
	return voDiploScoreObj.Score
end

return AI_POR
