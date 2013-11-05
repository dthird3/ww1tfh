local P = {}
AI_LIB = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9952, 2) -- Liberia
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end


return AI_LIB
