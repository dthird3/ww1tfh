local P = {}
AI_HAI = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 7661, 2) -- PortauPrince
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end



return AI_HAI
