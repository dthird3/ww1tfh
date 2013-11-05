local P = {}
AI_COS = P

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 7721, 2) -- SanJose
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end




return AI_COS
