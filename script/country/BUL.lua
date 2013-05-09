local P = {}
AI_BUL = P

function P.ForeignMinister_Alignment(voForeignMinisterData)

	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
	if liYear > 1913 then
		return Support.AlignmentPush("axis", voForeignMinisterData, true, true)
	else
		--return Support.AlignmentNeutral(...)
	end	


end
function P.HandleMobilization(minister)
	local ai = minister:GetOwnerAI()
	local ministerTag =  minister:GetCountryTag()


		local liYear = CCurrentGameState.GetCurrentDate():GetYear()
		local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
		
	if (liYear == 1912 and liMonth > 6) or  (liYear == 1913 and liMonth > 5 and liMonth < 7) then
		ai:Post(CToggleMobilizationCommand( ministerTag, true ))
	else
		
		local ministerCountry = ministerTag:GetCountry()
		local liTotalIC = ministerCountry:GetTotalIC()
		local liNeutrality = ministerCountry:GetNeutrality():Get() * 0.9

		-- Regular loop to see if anyone is threatening to us
		for loCountryTag in ministerCountry:GetNeighbours() do
			local liThreat = ministerCountry:GetRelation(loCountryTag):GetThreat():Get()
			
			if (liNeutrality - liThreat) < 10 then
				local loCountry = loCountryTag:GetCountry()
				
				liThreat = liThreat * CalculateAlignmentFactor(ai, ministerCountry, loCountry)
				
				if liTotalIC > 50 and loCountry:GetTotalIC() < liTotalIC then
					liThreat = liThreat / 2 -- we can handle them if they descide to attack anyway
				end
				
				if liThreat > 30 then
					if CalculateWarDesirability(ai, loCountry, ministerTag) > 70 then
						ai:Post(CToggleMobilizationCommand( ministerTag, true ))
					end
				end
			end
		end
	end
end
function P.DiploScore_InviteToFaction(voDiploScoreObj)
	local loAllies = CCurrentGameState.GetFaction("axis")
	
	-- Only go through these checks if we are being asked to join the Axis
	if voDiploScoreObj.Faction == loAllies then
		local liYear = CCurrentGameState.GetCurrentDate():GetYear()
		local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
		
		-- Date check to make sure they come in within resonable time
		if liYear >= 1915 then
			if liMonth >= 9 then
				voDiploScoreObj.Score = voDiploScoreObj.Score + 50
			else
				voDiploScoreObj.Score = voDiploScoreObj.Score - 200
			end
			if liYear >= 1916 then
				voDiploScoreObj.Score = voDiploScoreObj.Score + 100
			end
		else
				voDiploScoreObj.Score = voDiploScoreObj.Score - 200
		end
	end
	
	return voDiploScoreObj.Score
end
function DiploScore_PeaceAction(voAI, voActorTag, voRecipientTag, voObserverTag, action)
	return 0
end
return AI_BUL
