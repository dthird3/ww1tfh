local P = {}
AI_NIC = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9739, 1) -- Managua
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end



return AI_NIC
