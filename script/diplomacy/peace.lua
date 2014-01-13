-----------------------------------------------------------
-- LUA Hearts of Iron 3 Peace File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 12/22/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_Peace = P

-- #######################
-- Called by the EXE
-- #######################
function DiploScore_PeaceAction(voAI, voActorTag, voRecipientTag, voObserverTag, action)
--Utils.LUA_DEBUGOUT("DiploScore_PeaceAction")
	-- No way to effectively use this so do not let the AI ever make peace
	return 0
end
-- #######################
-- Support Methods
-- #######################
function P.Peace(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Peace")
	-- Nothing to do heare yet just a place holder in case Paradox enhances the LUA
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return ForeignMinister_Peace