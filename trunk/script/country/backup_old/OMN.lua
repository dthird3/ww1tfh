local P = {}
AI_OMN = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9598, 1) -- Masqat
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end





return AI_OMN
