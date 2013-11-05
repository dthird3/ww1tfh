local P = {}
AI_PAR = P


function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 10254, 2) -- Asuncion
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end


return AI_PAR
