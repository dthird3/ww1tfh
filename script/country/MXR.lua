-----------------------------------------------------------
-- LUA Hearts of Iron 3 Mexico File
-- Created By: Lothos
-- Modified By: Trevor
-- Date Last Modified: 26/10/14
-----------------------------------------------------------

local P = {}
AI_MXR = P

-- #######################################
-- POLITICS MINISTER
function P.Politics_Mobilization(voPoliticsObject)
	-- Do not do anything as we never want to mobilize
	return false
end

function P.TechList(voTechnologyData)
	local loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Land Strict')

	return loPreferTech
end
-- #######################################
-- FOREIGN MINISTER
function P.ForeignMinister_Alignment(voForeignMinisterData)
	return ForeignMinister_Alignment.Alignment_Neutral(voForeignMinisterData)
end

-- #######################################
-- DIPLOMACY SCORE GENERATION

return AI_MXR