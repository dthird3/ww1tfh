-----------------------------------------------------------
-- LUA Hearts of Iron 3 Political File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 3/21/2013
-----------------------------------------------------------

-- ###################################
-- # Main Method called by the EXE
-- #####################################
function PoliticsMinister_Tick(minister)
	--Utils.LUA_DEBUGOUT("PoliticsMinister_Tick")
	local PoliticsMinisterData = {
		Custom = nil,						-- Used to store custom variables
		Local = {},							-- Used for the sub functions to store variables they wish to pass on
		minister = minister,				-- minister Object
		ministerAI = minister:GetOwnerAI(),	-- AI Object
		Tag = minister:GetCountryTag(),		-- Country Tag
		Country = nil, 						-- Country Object
		Year = CCurrentGameState.GetCurrentDate():GetYear(), -- Current in game Year (integer)
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(), -- Current in game Month (integer)
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(), -- Current in game Day (integer)
		IsPuppet = nil, 					-- True/False are they a Puppet Country
		IsExile	= nil, 						-- True/False are the in exile
		IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
		IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
		PortsTotal = nil,					-- (integer) Total amount of ports the country has
		Strategy = nil,						-- Strategy Object
		IsAtWar = nil, 						-- True/False is this country a at war
		Faction = nil, 						-- Faction Object the country belongs to
		FactionName = nil, 					-- Name of the Faction the country belongs to (string)
		HasFaction = nil, 					-- True/False does the country have a faction
		Ideology = nil,						-- Current Ideolgoy of the country
		IdeologyGroup = nil,				-- Group the countries Ideology belongs to
		IdeologyGroupName = nil 			-- Name of the ideology group (string)
	}
	--Utils.LUA_DEBUGOUT("PoliticsMinister_TickA")
	PoliticsMinisterData.Country = PoliticsMinisterData.Tag:GetCountry()

	-- Make sure we have a valid country to work with
	if not(Support_Functions.IsValidCountry(PoliticsMinisterData)) then
		return false
	end
	--Utils.LUA_DEBUGOUT("PoliticsMinister_TickB" .. tostring(PoliticsMinisterData.Tag) )
	PoliticsMinisterData.IsAtWar = PoliticsMinisterData.Country:IsAtWar()
	PoliticsMinisterData.Faction = PoliticsMinisterData.Country:GetFaction()
	PoliticsMinisterData.FactionName = tostring(PoliticsMinisterData.Faction:GetTag())
	PoliticsMinisterData.HasFaction = PoliticsMinisterData.Country:HasFaction()
	PoliticsMinisterData.Strategy = PoliticsMinisterData.Country:GetStrategy()
	PoliticsMinisterData.Ideology = PoliticsMinisterData.Country:GetRulingIdeology()
	PoliticsMinisterData.IdeologyGroup = PoliticsMinisterData.Ideology:GetGroup()
	PoliticsMinisterData.IdeologyGroupName = tostring(PoliticsMinisterData.IdeologyGroup:GetKey())
	PoliticsMinisterData.IsExile = PoliticsMinisterData.Country:IsGovernmentInExile()
	PoliticsMinisterData.IsPuppet = PoliticsMinisterData.Country:IsPuppet()
	PoliticsMinisterData.IcOBJ = Support_Functions.GetICBreakDown(PoliticsMinisterData.Country)
	PoliticsMinisterData.PortsTotal = PoliticsMinisterData.Country:GetNumOfPorts()
	PoliticsMinisterData.IsNaval = (PoliticsMinisterData.PortsTotal > 0 and PoliticsMinisterData.IcOBJ.IC >= 20)
	--Utils.LUA_DEBUGOUT("PoliticsMinister_TickC")
	-- Custom Init Call
	PoliticsMinisterData.Custom = Support_Country.Call_Function(PoliticsMinisterData, "PoliticsMinisterData_Init", PoliticsMinisterData)
	--Utils.LUA_DEBUGOUT("PoliticsMinister_TickD")
	local loMethodCalls = {
		Politics_Mobilization.Mobilization,
		Politics_Liberation.Liberation,
		Politics_Puppet.Puppets,
		Politics_Minister.ChangeMinister,
		Politics_Laws.ChangeLaws
	}
	--Utils.LUA_DEBUGOUT("PoliticsMinister_TickE")	
	-- Call one of the Standard Diplomacy methods randomly each tick
	loMethodCalls[math.random(table.getn(loMethodCalls))](PoliticsMinisterData)
	--Utils.LUA_DEBUGOUT("PoliticsMinister_TickF")
	
		--Utils.LUA_DEBUGOUT("Custom".. tostring(PoliticsMinisterData.Custom))
		--Utils.LUA_DEBUGOUT("Local".. tostring(PoliticsMinisterData.Local))
		----Utils.LUA_DEBUGOUT("minister".. tostring(PoliticsMinisterData.minister))
		----Utils.LUA_DEBUGOUT("ministerAI".. tostring(PoliticsMinisterData.ministerAI))
		--Utils.LUA_DEBUGOUT("Tag".. tostring(PoliticsMinisterData.Tag))
		----Utils.LUA_DEBUGOUT("Country".. tostring(PoliticsMinisterData.Country))
		--Utils.LUA_DEBUGOUT("Year".. tostring(PoliticsMinisterData.Year))
		--Utils.LUA_DEBUGOUT("Month".. tostring(PoliticsMinisterData.Month))
		--Utils.LUA_DEBUGOUT("Day".. tostring(PoliticsMinisterData.Day))
		--Utils.LUA_DEBUGOUT("IsPuppet".. tostring(PoliticsMinisterData.IsPuppet))
		--Utils.LUA_DEBUGOUT("IsExile".. tostring(PoliticsMinisterData.IsExile))
		--Utils.LUA_DEBUGOUT("IsNaval".. tostring(PoliticsMinisterData.IsNaval))
		--Utils.LUA_DEBUGOUT("IcOBJ".. tostring(PoliticsMinisterData.IcOBJ))
		--Utils.LUA_DEBUGOUT("PortsTotal".. tostring(PoliticsMinisterData.PortsTotal))
		----Utils.LUA_DEBUGOUT("Strategy".. tostring(PoliticsMinisterData.Strategy))
		--Utils.LUA_DEBUGOUT("IsAtWar".. tostring(PoliticsMinisterData.IsAtWar))
		----Utils.LUA_DEBUGOUT("Faction".. tostring(PoliticsMinisterData.Faction))
		--Utils.LUA_DEBUGOUT("FactionName".. tostring(PoliticsMinisterData.FactionName))
		--Utils.LUA_DEBUGOUT("HasFaction".. tostring(PoliticsMinisterData.HasFaction))
		----Utils.LUA_DEBUGOUT("Ideology".. tostring(PoliticsMinisterData.Ideology))
		----Utils.LUA_DEBUGOUT("IdeologyGroup".. tostring(PoliticsMinisterData.IdeologyGroup))
		----Utils.LUA_DEBUGOUT("IdeologyGroupName".. tostring(PoliticsMinisterData.IdeologyGroupName))
		--Utils.LUA_DEBUGOUT("PoliticsMinister_TickG")
	

end

-- Being called by the EXE not sure why
function Laws(minister)
	--Utils.LUA_DEBUGOUT("ForeignMinister_Laws")
end
