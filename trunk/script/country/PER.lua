local P = {}
AI_PER = P

function P.DiploScore_InviteToFaction(voDiploScoreObj)
	local loAxis = CCurrentGameState.GetFaction("axis")
	
	if voDiploScoreObj.Faction == loAxis then
		voDiploScoreObj.Score = voDiploScoreObj.Score - 40
	end
	
	return voDiploScoreObj.Score
end

function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 4625, 2) -- Tabriz
ic = Support.Build_AirBase(ic, voProductionData, 9184, 3) -- Kermanshah
ic = Support.Build_AirBase(ic, voProductionData, 9429, 1) -- BandareAbbas
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end


return AI_PER
