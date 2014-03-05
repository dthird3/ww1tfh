-----------------------------------------------------------
-- LUA Hearts of Iron 3 Switzerland File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/5/2013
-----------------------------------------------------------

local P = {}
AI_POR = P

-- #######################################
-- POLITICS MINISTER
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


return AI_POR