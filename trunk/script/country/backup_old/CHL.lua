local P = {}
AI_CHL = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 10336, 2) -- Santiago
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end


return AI_CHL
