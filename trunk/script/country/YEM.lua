-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany Default File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------

local P = {}
AI_YEM = P


function P.DiploScore_Alliance(voDiploScoreObj)
	if voDiploScoreObj.Actor.name == "TUR" or voDiploScoreObj.Actor.name == "ASR" or voDiploScoreObj.Actor.name == "HJZ" or voDiploScoreObj.Target.name == "TUR" or voDiploScoreObj.Target.name == "ASR" or voDiploScoreObj.Target.name == "HJZ" then
		return 200
	end
	
	return voDiploScoreObj.Score
end
return AI_YEM
