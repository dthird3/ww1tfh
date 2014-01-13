
local P = {}
AI_SCH = P

function P.HandleMobilization(minister)
	-- Do not do anything as we never want to mobilize
end
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 3422, 2) -- Bern
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end

function P.DiploScore_Alliance(voDiploScoreObj)
	-- Stay out of the war, we do not care whats happening around us
	if not(voDiploScoreObj.IsAtWar) then
		voDiploScoreObj.Score = 0
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_GiveMilitaryAccess(viScore, voAI, voCountry)
	-- We stay out of everything
	return 0
end

function P.ForeignMinister_Alignment(...)
	return Support.AlignmentNeutral(...)
end

-- Create very highly trained troops
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _SPECIALIST_TRAINING_ = 30
	return CLawDataBase.GetLaw(_SPECIALIST_TRAINING_)
end

function P.DiploScore_ConsiderAccess(viScore, ai, actor, recipient, observer)
	return 0
end

return AI_SCH
