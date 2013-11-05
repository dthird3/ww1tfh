local P = {}
AI_HJZ = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9553, 1) -- AlMadinah
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end



return AI_HJZ
