-----------------------------------------------------------
-- LUA Hearts of Iron 3 Switzerland File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/5/2013
-----------------------------------------------------------

local P = {}
AI_HOL = P

-- #######################################
-- POLITICS MINISTER
function P.Politics_Mobilization(voPoliticsObject)
	-- Do not do anything as we never want to mobilize
	return false
end

-- #######################################
-- FOREIGN MINISTER
function P.ForeignMinister_Alignment(voForeignMinisterData)
	return ForeignMinister_Alignment.Alignment_Neutral(voForeignMinisterData)
end

-- #######################################
-- DIPLOMACY SCORE GENERATION
function P.DiploScore_Alliance(voDiploScoreObj)
	-- Stay out of the war, we do not care whats happening around us
	if not(voDiploScoreObj.Target.IsAtWar) then
		voDiploScoreObj.Score = 0
	end
	
	return voDiploScoreObj.Score
end
function P.DiploScore_GiveMilitaryAccess(voDiploScoreObj)
	-- We stay out of everything
	return 0
end


function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		CAN = {Score = -20},
		AST = {Score = -20},
		ENG = {Score = -20},
		SAF = {Score = -20},
		NZL = {Score = -20},
		TUR = {Score = 40},
		GER = {Score = 60},
		AUH = {Score = 60},
		ITA = {Score = -20},
		JAP = {Score = -50},
		FRA = {Score = -50}}
	
	if laTrade[voDiploScoreObj.Actor.Name] then
		return voDiploScoreObj.Score + laTrade[voDiploScoreObj.Actor.Name].Score
	end
	
	return voDiploScoreObj.Score
end


return AI_HOL