local P = {}
AI_COL = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9790, 1) -- Barranquilla
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end



return AI_COL
