local P = {}
AI_DOM = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 7662, 1) -- SantoDomingo
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end




return AI_DOM
