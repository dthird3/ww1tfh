-----------------------------------------------------------
-- LUA Hearts of Iron 3 Alliance File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------
local P = {}
Support_Tech = P

-- #######################
-- Called by the EXE
-- #######################
function TechMinister_Tick(minister, vbSliders, vbResearch)
	--Utils.LUA_DEBUGOUT("TechMinister_Tick")
	-- Reset Global Array Container
	local TechnologyData = {
		Custom = nil,		-- Used to store custom variables
		minister = minister,
		ministerAI = minister:GetOwnerAI(),
		Tag = minister:GetCountryTag(),
		Country = nil,
		Year = CCurrentGameState.GetCurrentDate():GetYear(),
		TechMaxYear = CTechnologyDataBase.GetLatestTechYear() + 1,
		IsPuppet = nil, 					-- True/False are they a Puppet Country
		IsExile	= nil, 						-- True/False are the in exile
		IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
		Ideology = nil,								-- Current Ideolgoy of the country
		IdeologyGroup = nil,						-- Group the countries Ideology belongs to
		IdeologyGroupName = nil, 					-- Name of the ideology group (string)
		IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
		PortsTotal = nil,					-- (integer) Total amount of ports the country has
		IsAtWar = nil, 						-- Boolean are they atwar with someone
		IsMajor = nil, 						-- Boolean are they a major power
		TechStatus = nil, 					-- TechStatus Object
		Continent = nil, 					-- Continent where their capital is
		TotalLeadership = 0,				-- Total Amount of Leadership the country has
		ManpowerTotal = 0, 					-- Total Manpower the country has
		icSupplies = 0, 					-- Total Amount of IC being used for supplies
		icSupplyPercentage = 0,				-- Percentage of IC going to supplies
		TechData = {}} 						-- Created and Maintained in the Process_Tech method

	-- Initialize Production Object 
	--   only the ones that are used for the slider
	-- #################
	TechnologyData.Country = TechnologyData.Tag:GetCountry()

	--Utils.LUA_DEBUGOUT("TechMinister_TickA " .. tostring(TechnologyData.Tag) )
	-- Make sure we have a valid country to work with
	if not(Support_Functions.IsValidCountry(TechnologyData)) then
		return false
	end

	TechnologyData.IsMajor = TechnologyData.Country:IsMajor()
	-- End Initialize Production Object
	-- #################	

	--Utils.LUA_DEBUGOUT("TechMinister_TickB")
	local liResearchSlotsAllowed = 0
	
	if vbSliders then
		-- Calling balance sliders like this allows me to get what the new Research slot count would be
		--    once the sliders are shifted
		local loLeaderSliders = Support_Tech.BalanceLeadershipSliders(TechnologyData, vbSliders)
		liResearchSlotsAllowed = math.ceil(loLeaderSliders.Slots_Research)
	else
		-- Sliders already set by player
		liResearchSlotsAllowed = TechnologyData.Country:GetAllowedResearchSlots()
	end
	
	--Utils.LUA_DEBUGOUT("TechMinister_TickC")
	if vbResearch then
		local ResearchSlotsNeeded = liResearchSlotsAllowed - TechnologyData.Country:GetNumberOfCurrentResearch()
		-- Performance check, exit if there are no slots available
		if ResearchSlotsNeeded >= 0.01 then
			-- Initialize Data Object
			--   add the ones used for Tech Research
			-- #################
			TechnologyData.TechStatus = TechnologyData.Country:GetTechnologyStatus()
			TechnologyData.Continent = tostring(TechnologyData.Country:GetActingCapitalLocation():GetContinent():GetTag())
			TechnologyData.TotalLeadership = TechnologyData.Country:GetTotalLeadership():Get()
			TechnologyData.ManpowerTotal = TechnologyData.Country:GetManpower():Get()
			TechnologyData.icSupplies = TechnologyData.Country:GetICPart(CDistributionSetting._PRODUCTION_SUPPLY_):Get()
			TechnologyData.IsAtWar = TechnologyData.Country:IsAtWar()
			TechnologyData.IsExile = TechnologyData.Country:IsGovernmentInExile()
			TechnologyData.IsPuppet = TechnologyData.Country:IsPuppet()
			TechnologyData.PortsTotal = TechnologyData.Country:GetNumOfPorts()
			TechnologyData.IcOBJ = Support_Functions.GetICBreakDown(TechnologyData.Country)
			TechnologyData.icSupplyPercentage = TechnologyData.icSupplies / TechnologyData.IcOBJ.IC
			TechnologyData.IsNaval = (TechnologyData.PortsTotal > 0 and TechnologyData.IcOBJ.IC >= 20)
			TechnologyData.Ideology = TechnologyData.Country:GetRulingIdeology()
			TechnologyData.IdeologyGroup = TechnologyData.Ideology:GetGroup()
			TechnologyData.IdeologyGroupName = tostring(TechnologyData.IdeologyGroup:GetKey())
			
			--Utils.LUA_DEBUGOUT("TechMinister_TickD")
			-- Custom Init Call
			TechnologyData.Custom = Support_Country.Call_Function(TechnologyData, "TechnologyData_Init", TechnologyData)
			
			TechnologyData.TechData = {
				FolderOrder = nil, -- Order to Research the folders in if no favorites are researchable
				TechList = nil -- Tech List weather on priority or ignore
			}

			TechnologyData.TechData.FolderOrder = Support_Country.Call_Function(TechnologyData, "TechFolderOrder", TechnologyData)

			-- NOTE TechList is called from the production AI as well!
			TechnologyData.TechData.TechList = Support_Country.Call_Function(TechnologyData, "TechList", TechnologyData)
			
			-- End Initialize Production Object
			-- #################	

			--Utils.LUA_DEBUGOUT("TechMinister_TickE")
			
			P.Process_Tech(TechnologyData, TechnologyData.Year, ResearchSlotsNeeded)
		end
	end
	
	
	--Utils.LUA_DEBUGOUT("TechMinister_TickF")
	
	
		--Utils.LUA_DEBUGOUT("Custom".. tostring(TechnologyData.Custom))
		----Utils.LUA_DEBUGOUT("minister".. tostring(TechnologyData.minister))
		----Utils.LUA_DEBUGOUT("ministerAI".. tostring(TechnologyData.ministerAI))
		--Utils.LUA_DEBUGOUT("Tag".. tostring(TechnologyData.Tag))
		----Utils.LUA_DEBUGOUT("Country".. tostring(TechnologyData.Country))
		--Utils.LUA_DEBUGOUT("Year".. tostring(TechnologyData.Year))
		--Utils.LUA_DEBUGOUT("TechMaxYear".. tostring(TechnologyData.TechMaxYear))
		--Utils.LUA_DEBUGOUT("IsPuppet".. tostring(TechnologyData.IsPuppet))
		--Utils.LUA_DEBUGOUT("IsExile".. tostring(TechnologyData.IsExile))
		--Utils.LUA_DEBUGOUT("IsNaval".. tostring(TechnologyData.IsNaval))
		--Utils.LUA_DEBUGOUT("TechStatus".. tostring(TechnologyData.TechStatus))
		--Utils.LUA_DEBUGOUT("Continent".. tostring(TechnologyData.Continent))
		--Utils.LUA_DEBUGOUT("IcOBJ".. tostring(TechnologyData.IcOBJ))
		--Utils.LUA_DEBUGOUT("PortsTotal".. tostring(TechnologyData.PortsTotal))
		--Utils.LUA_DEBUGOUT("TotalLeadership".. tostring(TechnologyData.TotalLeadership))
		--Utils.LUA_DEBUGOUT("ManpowerTotal".. tostring(TechnologyData.ManpowerTotal))
		--Utils.LUA_DEBUGOUT("icSupplies".. tostring(TechnologyData.icSupplies))
		--Utils.LUA_DEBUGOUT("icSupplyPercentage".. tostring(TechnologyData.icSupplyPercentage))
		----Utils.LUA_DEBUGOUT("Strategy".. tostring(TechnologyData.Strategy))
		--Utils.LUA_DEBUGOUT("IsAtWar".. tostring(TechnologyData.IsAtWar))
		----Utils.LUA_DEBUGOUT("Faction".. tostring(TechnologyData.Faction))
		--Utils.LUA_DEBUGOUT("IsMajor".. tostring(TechnologyData.IsMajor))
		----Utils.LUA_DEBUGOUT("Ideology".. tostring(TechnologyData.Ideology))
		----Utils.LUA_DEBUGOUT("IdeologyGroup".. tostring(TechnologyData.IdeologyGroup))
		----Utils.LUA_DEBUGOUT("IdeologyGroupName".. tostring(TechnologyData.IdeologyGroupName))
	
	
end

-- #######################
-- Support Methods
-- #######################
-- Balances the research sliders	
function P.BalanceLeadershipSliders(StandardDataObject, vbSliders)
--Utils.LUA_DEBUGOUT("BalanceLeadershipSliders")
	local liInfluenceCap = 25 -- Cap based on total leadership, if below this do not influence at all
	local liDiplomacyNoFaction = 0.5 -- Major or Minor not in a faction or does not meet influence cap
	local liDiplomacyInFaction = 4.5 -- Majors that are in a faction and exceed influence cap
	
    local Leadership = {
		NCONeeded = false,
		CanInfluence = false,
		SpyPresence = nil,	-- CSpyPresence object from the EXE
		Spies = 0,			-- How many spies do they have in our country
		ActiveInfluence = StandardDataObject.Country:CalculateNumberOfActiveInfluences(),
		Diplomats = StandardDataObject.Country:GetDiplomaticInfluence():Get(),
		TotalLeadership = StandardDataObject.Country:GetTotalLeadership():Get(),
		Default_Research = 0,
		Default_Espionage = 0.03,
		Default_Diplomacy = 0.08,
		Default_NCO = 0.1,
		Percent_Research = 0,
		Percent_Espionage = 0.03,
		Percent_Diplomacy = 0.08,
		Percent_NCO = 0.1,
		Slots_Research = 0,
		Slots_Espionage = 0,
		Slots_Diplomacy = 0,
		Slots_NCO = 0}
	
	Leadership.CanInfluence = (StandardDataObject.Country:HasFaction() and Leadership.TotalLeadership >= liInfluenceCap)
	
	-- Officer ratio.
	local liCurrentOfficeRatio = StandardDataObject.Country:GetOfficerRatio():Get()
	local liMaxOfficeRatio = defines.military.MAX_OFFICERS
		
	-- Checks to see if you are loosing officers
	--   if so take them from espionage and diplomacy
	if liCurrentOfficeRatio < (liMaxOfficeRatio * 0.70) then
		-- Move the Espionage into the NCO and set it to 0 since we are short
		Leadership.Percent_NCO = 0.5 + Leadership.Percent_Espionage
		Leadership.Percent_Espionage = 0.0
		Leadership.NCONeeded = true
	elseif liCurrentOfficeRatio < (liMaxOfficeRatio * 0.75) then
		Leadership.Percent_NCO = 0.3
	elseif liCurrentOfficeRatio  < (liMaxOfficeRatio * 0.85) then
		Leadership.Percent_NCO = 0.2
	elseif liCurrentOfficeRatio  < (liMaxOfficeRatio * 0.92) then
		Leadership.Percent_NCO = 0.1
	
	-- Check to see if you have to many officers
	--    if so increase research
	elseif liCurrentOfficeRatio > (liMaxOfficeRatio * 0.99) then
		Leadership.Percent_NCO = 0.0
	end

	-- Figure out Espionage level
	--   This is down after NCO in case Espionage is turned off.
	if Leadership.Percent_Espionage > 0 then
		Leadership.SpyPresence = StandardDataObject.Country:GetSpyPresence(StandardDataObject.Tag)
		Leadership.Spies = Leadership.SpyPresence:GetLevel():Get()
		
		-- We have to few Home Spies so increase our leadership
		if Leadership.Spies < 8 then -- Works with "if AbroadSpy.HomeSpies > 7 then" from tech_minister.lua
			Leadership.Percent_Espionage = 0.1
		-- We have way to few home spies so bump it up even more
		elseif Leadership.Spies < 5 then
			Leadership.Percent_Espionage = 0.2
		end
	end
	
	-- If the AI has to many diplomats then set it to 0 (100 is max you can have)
	-- If the NCO desperation is true try and shift diplomacy into NCO production instead of Research
	if StandardDataObject.IsMajor then
		if Leadership.NCONeeded then
			Leadership.Percent_NCO = Leadership.Percent_NCO + Leadership.Percent_Diplomacy
			Leadership.Percent_Diplomacy = 0.01
		else
			if Leadership.Diplomats > 50 then
				-- Make it so they have exactly what they need to maintain the influence
				if Leadership.ActiveInfluence > 0 then
					Leadership.Percent_Diplomacy = Leadership.ActiveInfluence / Leadership.TotalLeadership
				else
					Leadership.Percent_Diplomacy = 0.01
				end
			end
		end
	else
		if Leadership.NCONeeded then
			Leadership.Percent_NCO = Leadership.Percent_NCO + Leadership.Percent_Diplomacy
			Leadership.Percent_Diplomacy = 0.01
		elseif Leadership.Diplomats > 20 then
			Leadership.Percent_Diplomacy = 0.01
		elseif Leadership.Diplomats > 15 then
			Leadership.Percent_Diplomacy = Leadership.Percent_Diplomacy / 4
		elseif Leadership.Diplomats > 10 then
			Leadership.Percent_Diplomacy = Leadership.Percent_Diplomacy / 2
		end	
	end
	
	-- Apply the diplomacy caps
    if Leadership.Percent_Diplomacy > 0.01 then
		if StandardDataObject.IsMajor then
			if Leadership.CanInfluence then
				Leadership.Percent_Diplomacy = (math.min(liDiplomacyInFaction, (Leadership.TotalLeadership * Leadership.Percent_Diplomacy)) / Leadership.TotalLeadership)
			else
				Leadership.Percent_Diplomacy = (math.min(liDiplomacyNoFaction, (Leadership.TotalLeadership * Leadership.Percent_Diplomacy)) / Leadership.TotalLeadership)
			end
		else
			Leadership.Percent_Diplomacy = (math.min(liDiplomacyNoFaction, (Leadership.TotalLeadership * Leadership.Percent_Diplomacy)) / Leadership.TotalLeadership)
		end
	end
	
	-- Research is whatever is left over
	Leadership.Percent_Research = (((1 - Leadership.Percent_Espionage) - Leadership.Percent_Diplomacy) - Leadership.Percent_NCO)
	
	Leadership.Slots_Research = Leadership.TotalLeadership * Leadership.Percent_Research
	Leadership.Slots_Espionage = Leadership.TotalLeadership * Leadership.Percent_Espionage
	Leadership.Slots_Diplomacy = Leadership.TotalLeadership * Leadership.Percent_Diplomacy
	Leadership.Slots_NCO = Leadership.TotalLeadership * Leadership.Percent_NCO
	
	-- Do not post unless set to true as this could be a call from other AIs to get information on the sliders
	if vbSliders then
		local command = CChangeLeadershipCommand(StandardDataObject.Tag, Leadership.Percent_NCO, Leadership.Percent_Diplomacy, Leadership.Percent_Espionage, Leadership.Percent_Research)
		StandardDataObject.ministerAI:Post(command)
	end
	
	return Leadership
end

-- Processes the main tech reasearch for the specified country
--   designed to be a recursive call in case the AI needs to research in the future
function P.Process_Tech(voTData, viYear, viResearchNeeded)
	--Utils.LUA_DEBUGOUT("Process_Tech")
	-- Performance check, exit if there are no slots available
	if (viResearchNeeded < 0.01)
	or (viYear >= voTData.TechMaxYear) then
		return
	end
	
	local liOriginalResearchNeeded = viResearchNeeded
	local loRData = {
		PreferList = {}, -- List of Techs on the AI Prefer List
		RegularList = {} -- List of Techs the AI can research (not on prefer list)
	}
	-- Figure out what the AI can research
	for loTech in CTechnologyDataBase.GetTechnologies() do
		if voTData.minister:CanResearch(loTech) and loTech:IsValid() then
			local liTechYear = voTData.TechStatus:GetYear(loTech, (voTData.TechStatus:GetLevel(loTech) + 1))
			
			if liTechYear <= viYear then
				local lsFolder = tostring(loTech:GetFolder():GetKey())
				local lsTechName = tostring(loTech:GetKey())

				if voTData.TechData.TechList[lsTechName] then
					if not(voTData.TechData.TechList[lsTechName].Ignore) then
						loRData.PreferList[lsTechName] = {
							Folder = lsFolder,
							Name = lsTechName,
							Tech = loTech,
							Priority = voTData.TechData.TechList[lsTechName].Priority
						}
						
						-- 50% score bonus per year behind
						if voTData.Year > liTechYear then
							local liPriority = loRData.PreferList[lsTechName].Priority
							loRData.PreferList[lsTechName].Priority = ((((voTData.Year - liTechYear) * 0.5) * liPriority) + liPriority)
						end
					end
				else
					if not(loRData.RegularList[lsFolder]) then
						loRData.RegularList[lsFolder] = {}
					end			
					
					table.insert(loRData.RegularList[lsFolder], loTech)
				end
			end
		end
	end
	
	local i = 1
	-- Process Prefer Techs
	while i <= viResearchNeeded do
		local loBestTech = nil
		
		for k, v in pairs(loRData.PreferList) do
			if not(loBestTech) then
				loBestTech = v
			else
				if v.Priority > loBestTech.Priority then
					loBestTech = v
				end
			end
		end
		
		-- Research the Tech
		if loBestTech then
			voTData.ministerAI:Post(CStartResearchCommand(voTData.Tag, loBestTech.Tech))
			loRData.PreferList[loBestTech.Name] = nil
			viResearchNeeded = viResearchNeeded - 1
		else
			-- Exit out there is nothing more to do here
			i = viResearchNeeded + 1
		end
	end
	
	-- Process Non-Prefer Techs if we still have research slots
	if viResearchNeeded > 0 then
		for k, v in pairs(voTData.TechData.FolderOrder) do
			-- Make sure there is something for us to do
			if loRData.RegularList[v] then
				local liFolderLength = table.getn(loRData.RegularList[v])

				if liFolderLength > 0 and viResearchNeeded > 0 then
					i = 1
					while i <= viResearchNeeded do
						local liRandomTech = math.random(liFolderLength)
						voTData.ministerAI:Post(CStartResearchCommand(voTData.Tag, loRData.RegularList[v][liRandomTech]))
						table.remove(loRData.RegularList[v], liRandomTech)
						viResearchNeeded = viResearchNeeded - 1
						liFolderLength = liFolderLength - 1
						
						-- Can we still research in the same folder, if not exit out
						if viResearchNeeded == 0 or liFolderLength == 0 then
							i = viResearchNeeded + 1
						end
					end
				end
				
				if viResearchNeeded == 0 then
					break -- Exit out of the loop
				end
			end
		end
	end
	
	-- Only go into the future if we found nothing to research as the EXE needs to reset so wait for next tick
	if liOriginalResearchNeeded == viResearchNeeded and viResearchNeeded > 0 then
		P.Process_Tech(voTData, (viYear + 1), viResearchNeeded)
	end
end

--vsFocus
--	Land Strict = Strictly Land/Air with submarines but nothing else (they get super low priorities)
--  Land = High Priority on land based units and small/medium aircraft units (no strat bombers)
--  Sea = High Priority on sea and sacrifice armor
--  Mixed = All Infantry, Up to Regular Armor and priority on Navy
function P.TechGenerator(voTData, vsFocus)
	--Utils.LUA_DEBUGOUT("TechGenerator")
	-- This is in case the call came from the Production AI
	if voTData.ManpowerTotal == nil then
		voTData.ManpowerTotal = voTData.Manpower.Total
	end

	-- Holds the final priorities, also contains defaults
	local laPreferTech = {
		infantry_activation = { Priority = 100 },
		smallarms_technology = { Priority = 99 },
		infantry_support = { Priority = 99 },
		infantry_guns = { Priority = 99 },
		infantry_at = { Priority = 99 },
		at_barrell_sights = { Priority = 98 },
		at_ammo_muzzel = { Priority = 98 },
		art_barrell_ammo = { Priority = 97 },
		art_carriage_sights = { Priority = 97 },
		aa_barrell_ammo = { Priority = 96 },
		aa_carriage_sights = { Priority = 96 },	
		
		militia_smallarms = { Priority = 51 },
		militia_support = { Priority = 51 },
		militia_guns = { Priority = 51 },
		militia_at = { Priority = 51 }
	}

	-- Setup the techs
	for k, v in pairs(TechRules) do -- Located in globals.lua
		for x, y in pairs(v) do
			if not(y.Ignore) then
				if y.Leadership <= voTData.TotalLeadership and y.IC <= voTData.IcOBJ.IC then
					local lbAddTech = true

					-- Resource Check
					if y.Resource then
						local loResource = CResourceValues()
						loResource:GetResourceValues(voTData.Country, y.Resource)
						
						-- Quantity Check
						if (loResource.vDailyHome < y.Quantity)
						or (y.Not and loResource.vDailyHome >= y.Quantity) then
							lbAddTech = false
						end
					end
					
					-- Manpower Check
					if y.Manpower then
						if (y.Manpower < voTData.ManpowerTotal)
						or (y.Not and y.Manpower >= voTData.ManpowerTotal) then
							lbAddTech = false
						end
					end
				
					-- Continent Check
					if y.Continent then
						if (y.Continent ~= voTData.Continent)
						or (y.Not and y.Continent == voTData.Continent) then
							lbAddTech = false
						end
					end

					-- Focus Check
					if y.Focus ~= nil then
						if (y.Focus ~= vsFocus)
						or (y.Not and y.Focus == vsFocus) then
							lbAddTech = false
						end
					end
					
					-- Percentage (must always have a Type assigned)
					if y.Percentage then
						if y.Type == 'Supply' then
							if (y.Percentage < voTData.icSupplyPercentage)
							or (y.Not and y.Percentage >= voTData.icSupplyPercentage) then
								lbAddTech = false
							end
						end
					end

					if lbAddTech then
						if laPreferTech[k] then
							if laPreferTech[k].Priority < y.Priority then
								laPreferTech[k] = { Priority = y.Priority }
							end
						else
							laPreferTech[k] = { Priority = y.Priority }
						end
					end
				end
			else
				-- Focus Check
				if y.Focus ~= nil then
					-- If Focus is on ignore then jump out
					if y.Focus == vsFocus then
						laPreferTech[k] = { Focus = vsFocus, Priority = 0, Ignore = true }
						break
					end
				elseif not(laPreferTech[k]) then
					laPreferTech[k] = { Priority = 0, Ignore = true }
				end
			end
		end
	end
	
	return laPreferTech
end

-- ###############################################
-- END OF Support methods
-- ###############################################

return Support_Tech