-----------------------------------------------------------
-- LUA Hearts of Iron 3 Intelligence File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/3/2013
-----------------------------------------------------------

-- ###################################
-- # Main Method called by the EXE
-- #####################################
function IntelligenceMinister_Tick(minister)
	--Utils.LUA_DEBUGOUT("IntelligenceMinister_Tick")
	-- Performance 50% chance of the tick firing
	if math.random(2) == 1 then
		return
	end

	local IntelligenceMinisterData = {
		Custom = nil,						-- Used to store custom variables
		minister = minister,				-- minister Object
		ministerAI = minister:GetOwnerAI(),	-- AI Object
		Tag = minister:GetCountryTag(),		-- Country Tag
		Country = nil, 						-- Country Object
		Year = CCurrentGameState.GetCurrentDate():GetYear(), -- Current in game Year (integer)
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(), -- Current in game Month (integer)
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(), -- Current in game Day (integer)
		IsPuppet = nil, 					-- True/False are they a Puppet Country
		IsExile	= nil, 						-- True/False are the in exile
		IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
		PortsTotal = nil,					-- (integer) Total amount of ports the country has
		IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
		SpyPresence = nil,					-- CSpyPresence object for This country (on itself)
		Ideology = nil,						-- Current Ideolgoy of the country
		IdeologyGroup = nil,				-- Group the countries Ideology belongs to
		IdeologyGroupName = nil 			-- Name of the ideology group (string)
	}	

	IntelligenceMinisterData.Country = IntelligenceMinisterData.Tag:GetCountry()

	-- Make sure we have a valid country to work with
	if not(Support_Functions.IsValidCountry(IntelligenceMinisterData)) then
		return false
	end

	IntelligenceMinisterData.IsPuppet = IntelligenceMinisterData.Country:IsPuppet()
	IntelligenceMinisterData.IsExile = IntelligenceMinisterData.Country:IsGovernmentInExile()
	IntelligenceMinisterData.IcOBJ = Support_Functions.GetICBreakDown(IntelligenceMinisterData.Country)
	IntelligenceMinisterData.PortsTotal = IntelligenceMinisterData.Country:GetNumOfPorts()
	IntelligenceMinisterData.IsNaval = (IntelligenceMinisterData.PortsTotal > 0 and IntelligenceMinisterData.IcOBJ.IC >= 20)

	IntelligenceMinisterData.Ideology = IntelligenceMinisterData.Country:GetRulingIdeology()
	IntelligenceMinisterData.IdeologyGroup = IntelligenceMinisterData.Ideology:GetGroup()
	IntelligenceMinisterData.IdeologyGroupName = tostring(IntelligenceMinisterData.IdeologyGroup:GetKey())

	IntelligenceMinisterData.SpyPresence = IntelligenceMinisterData.Country:GetSpyPresence(IntelligenceMinisterData.Tag)


	local loMethodCalls = {
		Intelligence_Home.Spies,
		Intelligence_Abroad.Spies
	}

	-- Call one of the Standard methods randomly each tick
	loMethodCalls[math.random(table.getn(loMethodCalls))](IntelligenceMinisterData)
end