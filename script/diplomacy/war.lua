-----------------------------------------------------------
-- LUA Hearts of Iron 3 War File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 7/11/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_War = P

-- #######################
-- Called from foreing_minister.lua
-- #######################
function P.War(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("War")
	-- If not AI controlled then no point going in here
	if not(CCurrentGameState.IsPlayer(voForeignMinisterData.Tag)) then
		local loFunRef = Support_Country.Get_Function(voForeignMinisterData, "ForeignMinister_ProposeWar")

		-- Make sure we are not in exile
		if loFunRef and not(voForeignMinisterData.IsExile) then
			local liSurrenderLevel = voForeignMinisterData.Country:GetSurrenderLevel():Get()

			-- If we are less than 10% surrender level and not at war then run this
			if liSurrenderLevel < 0.10 or not(voForeignMinisterData.IsAtWar) then
				Support_Country.Call_Function(voForeignMinisterData, "ForeignMinister_ProposeWar", voForeignMinisterData)
			end
		end
	end
end

-- #######################
-- Support Methods
-- #######################
-- THIS DOES NOT WORK DO NOT USE IT YET IT IS JUST A PLACE HOLDER
function P.Command_War(voMinister, voFromTag, voTargetTag, vbLimited)
--Utils.LUA_DEBUGOUT("Command_War")
	local loCommand = CDeclareWarAction(voFromTag, voTargetTag)
	
	if vbLimited then
		loCommand:SetValue(true)
	end

	if loCommand:IsSelectable() then
		voMinister:ProposeWar(loCommand)
		return true
	end
	
	return false
end

function P.PrepareWar(voTargetTag, voFromCountry, voStrategy, viScore)
--Utils.LUA_DEBUGOUT("PrepareWar")
	if not(voStrategy:IsPreparingWarWith(voTargetTag)) then 
		local liTargetNeutrality = voFromCountry:GetEffectiveNeutrality():Get()
		local liDOWNeutrality = voFromCountry:GetMaxNeutralityForWarWith(voTargetTag):Get()
	
		if liTargetNeutrality < liDOWNeutrality then
			voStrategy:PrepareWar(voTargetTag, viScore)
			return true
		else
			return false
		end
	end
	
	return true
end
function P.PrepareLimitedWar(voTargetTag, voFromCountry, voStrategy, viScore)
--Utils.LUA_DEBUGOUT("PrepareLimitedWar")
	if not(voStrategy:IsPreparingWarWith(voTargetTag)) then 
		local liTargetNeutrality = voFromCountry:GetEffectiveNeutrality():Get()
		local liDOWNeutrality = voFromCountry:GetMaxNeutralityForWarWith(voTargetTag):Get()
	
		if liTargetNeutrality < liDOWNeutrality then
			voStrategy:PrepareLimitedWar(voTargetTag, viScore)
			return true
		else
			return false
		end
	end
	
	return true
end
function P.PrepareWarDecision(voTargetTag, voDecision, viScore)
--Utils.LUA_DEBUGOUT("PrepareWarDecision")
	voDecision.Actor.Strategy:PrepareWarDecision(voTargetTag, viScore, voDecision.Decision, false)
	return true
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return ForeignMinister_War