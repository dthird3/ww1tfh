local P = {}
AI_ECU = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9974, 1) -- Quito
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end




return AI_ECU
