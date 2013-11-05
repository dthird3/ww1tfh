local P = {}
AI_NOR = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 291, 2) -- Trondheim
ic = Support.Build_AirBase(ic, voProductionData, 65, 1) -- Narvik
ic = Support.Build_AirBase(ic, voProductionData, 808, 2) -- Bergen
ic = Support.Build_AirBase(ic, voProductionData, 812, 2) -- Oslo
ic = Support.Build_AirBase(ic, voProductionData, 9, 1) -- Tromso
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end




return AI_NOR
