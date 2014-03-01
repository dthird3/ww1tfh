-----------------------------------------------------------
-- LUA Hearts of Iron 3 Switzerland File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/5/2013
-----------------------------------------------------------

local P = {}
AI_BUL = P

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
		return ForeignMinister_Alignment.Alignment_Push("axis", voForeignMinisterData, true, true)
	end
	return true
end

-- #######################################
-- DIPLOMACY SCORE GENERATION


return AI_BUL