local P = {}
AI_GUA = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9713, 2) -- Guatemala
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end


return AI_GUA
