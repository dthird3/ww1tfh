local P = {}
AI_PAN = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 7722, 2) -- Colon
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end



return AI_PAN
