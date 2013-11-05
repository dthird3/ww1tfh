local P = {}
AI_HON = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9714, 2) -- Tegucigalpa
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end

return AI_HON
