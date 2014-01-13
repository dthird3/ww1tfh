
local P = {}
AI_HOL = P

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(voProductionData)
	local laArray = {
		0.07, -- Land
		0.33, -- Air
		0.40, -- Sea
		0.20}; -- Other
	
	return laArray
end


function P.DiploScore_Embargo(voDiploScoreObj)
	-- If Japan then do some special checks
	if tostring(voDiploScoreObj.EmbargoTag) == "JAP" then
		-- If we are part of the allies
		if voDiploScoreObj.Faction == CCurrentGameState.GetFaction("allies") then
			local usaTag = CCountryDataBase.GetTag("USA")
			local loRelation = usaTag:GetCountry():GetRelation(voDiploScoreObj.EmbargoTag)
			
			-- USA is currently embargoing Japan
			if loRelation:HasEmbargo() then
				voDiploScoreObj.Score = 100
				
			-- Do not embargo japan unless the USA does so first
			else
				voDiploScoreObj.Score = 0
			end
			
		-- Never embargo Japan then
		else
			voDiploScoreObj.Score = 0
		end
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		JAP = {Score = 150}}
	
	if laTrade[voDiploScoreObj.TagName] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.TagName].Score
	end
	
	return voDiploScoreObj.Score
end

function P.DiploScore_InviteToFaction(voDiploScoreObj)
	-- Whatever their chance is lower it by 10 makes it harder to get them in
	return (voDiploScoreObj.Score - 10)
end


function P.ForeignMinister_Alignment(...)
	return Support.AlignmentNeutral(...)
end
function P.Build_AirBase(ic, voProductionData)
ic = Support.Build_AirBase(ic, voProductionData, 1910, 2) -- Amsterdam
ic = Support.Build_AirBase(ic, voProductionData, 6398, 2) -- Manado
ic = Support.Build_AirBase(ic, voProductionData, 6500, 2) -- Oosthaven
ic = Support.Build_AirBase(ic, voProductionData, 6507, 2) -- Batavia
if voProductionData.Year < 1915 then
return ic, false
end
return ic, true
end

return AI_HOL

