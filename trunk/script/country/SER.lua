-----------------------------------------------------------
-- LUA Hearts of Iron 3 Switzerland File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/5/2013
-----------------------------------------------------------

local P = {}
AI_SER = P

-- #######################################
-- POLITICS MINISTER
function P.Politics_Mobilization(voPoliticsObject)
	if (voPoliticsObject.Year == 1912 and voPoliticsObject.Month > 6) or  (voPoliticsObject.Year == 1913 and voPoliticsObject.Month > 5 and voPoliticsObject.Month < 7) then
		Politics_Mobilization.Command_Mobilize(voPoliticsObject.ministerAI, voPoliticsObject.Actor.Tag, true)
		return false
	end
	return true
end

-- #######################################
-- FOREIGN MINISTER
function P.ForeignMinister_Alignment(voForeignMinisterData)
	if not(voForeignMinisterData.HasFaction) and voForeignMinisterData.Year >=1913 then
		return ForeignMinister_Alignment.Alignment_Push("allies", voForeignMinisterData, true, true)
	end
	return true
end

-- #######################################
-- DIPLOMACY SCORE GENERATION

function P.DiploScore_Alliance(voDiploScoreObj)
	if voDiploScoreObj.Actor.name == "GRE" or voDiploScoreObj.Actor.name == "MTN" or voDiploScoreObj.Actor.name == "BUL" or voDiploScoreObj.Target.name == "GRE" or voDiploScoreObj.Target.name == "MTN" or voDiploScoreObj.Target.name == "BUL" then
		return 200
	end
	
	return voDiploScoreObj.Score
end
return AI_SER