-----------------------------------------------------------
-- LUA Hearts of Iron 3 Foreign Minister File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------

-- ###################################
-- # Called by the EXE
-- #####################################
function ForeignMinister_OnWar( agent, countryTag1, countryTag2, war )
	--Utils.LUA_DEBUGOUT("ForeignMinister_OnWar")
	--if war:IsLimited() then
		-- dont pull anything else right now, lets wait until we need it
	--end
end

function ForeignMinister_EvaluateDecision(minister, voDecisions, voScope) 
	--Utils.LUA_DEBUGOUT("ForeignMinister_EvaluateDecision")
	local loDiploScoreObj = {
		Score = math.random(100),
		minister = minister,
		ministerAI = minister:GetOwnerAI(),
		Year = CCurrentGameState.GetCurrentDate():GetYear(),
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(),
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(),
		Decision = voDecisions,
		Name = tostring(voDecisions:GetKey()),
		Actor = {
			Tag = minister:GetCountryTag(),
			Country = nil,
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile	= nil, 						-- True/False are the in exile
			IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
			Ideology = nil,						-- Current Ideolgoy of the country
			IdeologyGroup = nil,				-- Group the countries Ideology belongs to
			IdeologyGroupName = nil,			-- (string) Actual name of the Ideology Group
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = nil,					-- (integer) Total amount of ports the country has
			Strategy = nil, 					-- Strategy Object
			IsAtWar = nil 						-- True/False are they atwar with someone
		}
	}

	loDiploScoreObj.Actor.Country = loDiploScoreObj.Actor.Tag:GetCountry()
	loDiploScoreObj.Actor.IsExile = loDiploScoreObj.Actor.Country:IsGovernmentInExile()
	loDiploScoreObj.Actor.IsPuppet = loDiploScoreObj.Actor.Country:IsPuppet()
	loDiploScoreObj.Actor.Ideology = loDiploScoreObj.Actor.Country:GetRulingIdeology()
	loDiploScoreObj.Actor.IdeologyGroup = loDiploScoreObj.Actor.Ideology:GetGroup()
	loDiploScoreObj.Actor.IdeologyGroupName = tostring(loDiploScoreObj.Actor.IdeologyGroup:GetKey())
	loDiploScoreObj.Actor.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Actor.Country)
	loDiploScoreObj.Actor.PortsTotal = loDiploScoreObj.Actor.Country:GetNumOfPorts()
	loDiploScoreObj.Actor.IsNaval = (loDiploScoreObj.Actor.PortsTotal > 0 and loDiploScoreObj.Actor.IcOBJ.IC >= 20)
	
	local loFunRef = Support_Country.Get_Score_Function(true, "ForeignMinister_EvaluateDecision", loDiploScoreObj)
	
	if loFunRef then
		loDiploScoreObj.Actor.Strategy = loDiploScoreObj.Actor.Country:GetStrategy()
		loDiploScoreObj.Actor.IsAtWar = loDiploScoreObj.Actor.Country:IsAtWar()

		loDiploScoreObj.Score = loFunRef(loDiploScoreObj)
	end

	return loDiploScoreObj.Score
end

function ForeignMinister_Tick(minister)
	--Utils.LUA_DEBUGOUT("ForeignMinister_Tick")
	
	-- Execute Decisions
	minister:ExecuteDiploDecisions()
	
	local ForeignMinisterData = {
		Custom = nil,						-- Used to store custom variables
		minister = minister,
		ministerAI = minister:GetOwnerAI(),
		Tag = minister:GetCountryTag(),
		Country = nil,
		Year = CCurrentGameState.GetCurrentDate():GetYear(),
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(),
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(),
		IsPuppet = nil, 					-- True/False are they a Puppet Country
		IsExile	= nil, 						-- True/False are the in exile
		IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
		IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
		PortsTotal = nil,					-- (integer) Total amount of ports the country has
		Desperation = nil,
		Ideology = nil,						-- Current Ideolgoy of the country
		IdeologyGroup = nil,				-- Group the countries Ideology belongs to
		IdeologyGroupName = nil,			-- (string) Actual name of the Ideology Group
		IdeologyMaping = nil, 				-- Maps the Ideology to the faction
		Neutrality = nil, 					-- What is their current Neutrality
		Strategy = nil, 					-- Strategy Object
		IsAtWar = nil, 						-- Boolean are they atwar with someone
		IsMajor = nil, 						-- Boolean are they a major power
		Faction = nil,						-- Faction the country is in
		FactionName = nil, 					-- The name of the faction as a string
		Diplomats = nil, 					-- Amount of Diplomats currently available
		DiploBuffer = 0,					-- How many diplomats to keep in reserve
		HasFaction = nil,					-- Boolean do they have a faction
		CanInfluence = false				-- If the Country meets the basic qualifications for influencing
	}
	
	ForeignMinisterData.Country = ForeignMinisterData.Tag:GetCountry()

	-- Make sure we have a valid country to work with
	if not(Support_Functions.IsValidCountry(ForeignMinisterData)) then
		return false
	end

	ForeignMinisterData.IsAtWar = ForeignMinisterData.Country:IsAtWar()
	ForeignMinisterData.Strategy = ForeignMinisterData.Country:GetStrategy()
	ForeignMinisterData.IsMajor = ForeignMinisterData.Country:IsMajor()
	ForeignMinisterData.Faction = ForeignMinisterData.Country:GetFaction()
	ForeignMinisterData.FactionName = tostring(ForeignMinisterData.Faction:GetTag())
	ForeignMinisterData.HasFaction = ForeignMinisterData.Country:HasFaction()
	ForeignMinisterData.Desperation = ForeignMinisterData.Country:CalcDesperation():Get()
	ForeignMinisterData.Ideology = ForeignMinisterData.Country:GetRulingIdeology()
	ForeignMinisterData.IdeologyGroup = ForeignMinisterData.Ideology:GetGroup()
	ForeignMinisterData.IdeologyGroupName = tostring(ForeignMinisterData.IdeologyGroup:GetKey())
	ForeignMinisterData.IdeologyMaping = {fascism = "axis", democracy = "allies", communism = "comintern"}
	ForeignMinisterData.Neutrality = ForeignMinisterData.Country:GetEffectiveNeutrality():Get()
	ForeignMinisterData.Diplomats = ForeignMinisterData.Country:GetDiplomaticInfluence():Get()
	ForeignMinisterData.IsExile = ForeignMinisterData.Country:IsGovernmentInExile()
	ForeignMinisterData.IsPuppet = ForeignMinisterData.Country:IsPuppet()
	ForeignMinisterData.IcOBJ = Support_Functions.GetICBreakDown(ForeignMinisterData.Country)
	ForeignMinisterData.PortsTotal = ForeignMinisterData.Country:GetNumOfPorts()
	ForeignMinisterData.IsNaval = (ForeignMinisterData.PortsTotal > 0 and ForeignMinisterData.IcOBJ.IC >= 20)
	ForeignMinisterData.CanInfluence = (ForeignMinisterData.HasFaction and ForeignMinisterData.IsMajor)
	
	-- If they can influence set the buffer to whatever it costs to influence a country
	if ForeignMinisterData.CanInfluence then
		ForeignMinisterData.DiploBuffer = defines.diplomacy.INFLUENCE_INFLUENCE_COST
	end

	-- Custom Init Call
	ForeignMinisterData.Custom = Support_Country.Call_Function(ForeignMinisterData, "ForeignMinisterData_Init", ForeignMinisterData)
	
	-- Only do these if we exceed our buffer in diplomats
	if ForeignMinisterData.DiploBuffer < ForeignMinisterData.Diplomats then
		local loMethodCalls = {
			ForeignMinister_MilitaryAccess.MilitaryAccess,
			ForeignMinister_Embargo.Embargo,
			ForeignMinister_NAP.NAP,
			ForeignMinister_Alliance.Alliance,
			ForeignMinister_Debt.AllowDebt,
			ForeignMinister_Guarantee.Guarantee,
			ForeignMinister_LendLease.LendLease,
			--ForeignMinister_ExpForces.ExpForces,
			ForeignMinister_InviteFaction.InviteFaction
		}

		-- Call one of the Standard methods randomly each tick
		loMethodCalls[math.random(table.getn(loMethodCalls))](ForeignMinisterData)
	end

	-- Secondary priority calls
	local loMethodCallsScondary = {
		ForeignMinister_War.War,
		ForeignMinister_CallAlly.CallAlly,
		ForeignMinister_Influence.Influence,
		--ForeignMinister_Peace.Peace,
		ForeignMinister_Alignment.Alignment
	}

	-- Call one of the Priority methods randomly each tick
	loMethodCallsScondary[math.random(table.getn(loMethodCallsScondary))](ForeignMinisterData)
end