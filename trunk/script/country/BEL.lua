
local P = {}
AI_BEL = P

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(voProductionData)
	local laArray = {
		0.07, -- Land
		0.33, -- Air
		0.40, -- Sea
		0.20}; -- Other
	
	return laArray
end

function P.DiploScore_InviteToFaction(voDiploScoreObj)
	-- Whatever their chance is lower it by 10 makes it harder to get them in
	return (voDiploScoreObj.Score - 10)
end
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 10113, 1) -- Boma
ic = Support.Build_AirBase(ic, voProductionData, 2197, 2) -- Antwerpen
ic = Support.Build_AirBase(ic, voProductionData, 2311, 3) -- Bruxelles
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end

return AI_BEL

