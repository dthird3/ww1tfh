local P = {}
AI_SAL = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 9699, 2) -- SanSalvador
ic = Support.Build_AirBase(ic, voProductionData, 9699, 1) -- ElSalvador.txt
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end



return AI_SAL
