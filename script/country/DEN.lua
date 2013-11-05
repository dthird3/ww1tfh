
local P = {}
AI_DEN = P

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(voProductionData)
	local laArray = {
			0.0, -- Land
			0.0, -- Air
			0.8, -- Sea
			0.2}; -- Other
	return laArray
end

function P.Build_CoastalFort(ic, voProductionData)
	return ic, false
end

function P.Build_AntiAir(ic, voProductionData)
	return ic, false
end
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 1130, 2) -- Fredrikshavn
ic = Support.Build_AirBase(ic, voProductionData, 1482, 2) -- Kobenhavn
ic = Support.Build_AirBase(ic, voProductionData, 8086, 2) -- Reykjavik
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end

return AI_DEN

