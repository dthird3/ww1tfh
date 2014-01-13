-----------------------------------------------------------
-- LUA Hearts of Iron 3 Diplomacy File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 8/24/2012
-----------------------------------------------------------
require('utils')

function DiploScore_PeaceAction(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	--Utils.LUA_DEBUGOUT("DiploScore_PeaceAction")
	if voObserverTag == voActorTag then
		return 0
	else
		score = 0
		
		-- intel first
		----Utils.LUA_DEBUGOUT("----------")
		local intel = CAIIntel(voRecipientTag, voActorTag)
		if intel:GetFactor() > 0.1 then
			local recipientStrength = intel:CalculateTheirPercievedMilitaryStrengh()
			local actorStrength = intel:CalculateOurMilitaryStrength()
			local strengthFactor = actorStrength / recipientStrength - 0.5
			score = 100 * strengthFactor
		end
		----Utils.LUA_DEBUGOUT("score: " .. score )
		
		local sizeFactor = voActorTag:GetCountry():GetNumberOfControlledProvinces() / voRecipientTag:GetCountry():GetNumberOfControlledProvinces()
		----Utils.LUA_DEBUGOUT("sizeFactor: " .. sizeFactor )
		sizeFactor = (sizeFactor - 1) * 100
				
		score = score + math.min(sizeFactor, 100)
		
		score = score + voRecipientTag:GetCountry():GetSurrenderLevel():Get() * 100
		----Utils.LUA_DEBUGOUT("score: " .. score )
		score = score - voActorTag:GetCountry():GetSurrenderLevel():Get() * 100
		----Utils.LUA_DEBUGOUT("score: " .. score )
		
		local strategy = voRecipientTag:GetCountry():GetStrategy()
		score = score + strategy:GetFriendliness(voActorTag) / 2
		score = score - strategy:GetAntagonism(voActorTag) / 2
		--score = score + strategy:GetThreat(voActorTag) / 2
		----Utils.LUA_DEBUGOUT("score: " .. score )
		return score
	end
end

-- This is called if a human player wants to send an EXP unit to someone but thats it
function DiploScore_SendExpeditionaryForce(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	--Utils.LUA_DEBUGOUT("DiploScore_SendExpeditionaryForce")
	if voObserverTag == voActorTag then
		return 0 
	else
		local  score = 0
		-- do we want to accept?
		local recipientCountry = voRecipientTag:GetCountry()
		if recipientCountry:GetDailyBalance( CGoodsPool._SUPPLIES_ ):Get() > 1.0 then
			-- maybe we have enough stockpiles
			local supplyStockpile = recipientCountry:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get()
			local weeksSupplyUse = recipientCountry:GetDailyExpense( CGoodsPool._SUPPLIES_ ):Get() * 7
			if supplyStockpile > weeksSupplyUse * 20.0 then
				score = score + 70
			elseif supplyStockpile > weeksSupplyUse * 10.0 then
				score = score + 40
			end
			
			if recipientCountry:IsAtWar() then
				score = score + 20
			else
				score = 0 -- no war, no need for troops
			end
		end
		
		return score
	end
end