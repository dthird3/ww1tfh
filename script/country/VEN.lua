local P = {}
AI_VEN = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9740, 1) -- Maracaibo
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end


return AI_VEN
