local P = {}
AI_URU = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 7893, 1) -- Montevideo
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end



return AI_URU
