-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------
-- --Utils.LUA_DEBUGOUT("Country: " .. tostring(ProductionData.Tag))

-- ###################################
-- # Main Method called by the EXE
-- #####################################
function ProductionMinister_Tick(minister)
	--Utils.LUA_DEBUGOUT("ProductionMinister_Tick")
	local ProductionData = {
		Custom = nil,							-- Used to store custom variables
		minister = minister,
		ministerAI = nil,
		Tag = minister:GetCountryTag(),
		Country = nil,
		Year = CCurrentGameState.GetCurrentDate():GetYear(),			-- Current in game Year (integer)
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(),	-- Current in game Month (integer)
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(),		-- Current in game Day (integer)
		IsPuppet = nil, 					-- True/False are they a Puppet Country
		IsExile	= nil, 						-- True/False are the in exile
		IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
		Ideology = nil,						-- Current Ideolgoy of the country
		IdeologyGroup = nil,				-- Group the countries Ideology belongs to
		IdeologyGroupName = nil, 			-- Name of the ideology group (string)
		IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
		PortsTotal = nil,					-- (integer) Total amount of ports the country has
		IsAtWar = nil,						-- Boolean are they atwar with someone
		TechStatus = nil,					-- TechStatus Object
		AirfieldsTotal = 0,					-- Total amount of airfields
		CapitalPrv = nil,					-- Province OBJ Where the capital is located.
		CapitalPrvID = nil,					-- Province ID for the capital
		Continent = nil, 					-- Continent where their capital is
		TotalLeadership = 0,				-- Total Amount of Leadership the country has
		icSupplies = 0, 					-- Total Amount of IC being used for supplies
		icSupplyPercentage = 0,				-- Percentage of IC going to supplies
		TechList = nil,						-- Hold an array of techs the country has a prio to research
		
		Carrier = { Size = 0 },				-- Carrier Tech checks to see if above standard size
		FirePower = {
			IsActive = false,				-- True/False does the country have Firepower tech (+1 unit size)
			Units = nil						-- Array holding the units that should get +1 to to support units
		},
		Manpower = {
			IsMobilizeCovered = false,
			Total = 0, -- If this is changed update tech_minister.lua
		},
		Units = { -- Each Unit type is added in here by its name with counts
			Counts = {
				Land = 0,
				Air = 0,
				Naval = 0,
				Secret = 0,
				Special = 0,
				Para = 0
			}
		},
		IC = {
			Allocated = 0,
			Available = 0,
			Used = 0,
			Types = {
				Land = {
					IsMain = true,
					Total = 0,
					Building = 0,
					Available = 0,
					Produce = Prod_Land.Build
				},
				Air = {
					IsMain = true,
					Total = 0,
					Building = 0,
					Available = 0,
					Produce = Prod_Air.Build
				},
				Sea = {
					IsMain = true,
					Total = 0,
					Building = 0,
					Available = 0,
					Produce = Prod_Sea.Build
				},
				Other = {
					Total = 0,
					Building = 0,
					Available = 0,
					Produce = Prod_Buildings.Build
				}
			}
		}
	}
	
	-- Initialize Production Object
	-- #################
	ProductionData.Country = ProductionData.Tag:GetCountry()
	
	--Utils.LUA_DEBUGOUT("ProductionMinister_Tick" .. tostring(ProductionData.Tag))
	-- Make sure we have a valid country to work with
	if not(Support_Functions.IsValidCountry(ProductionData)) then
		return false
	end

	ProductionData.IC.Allocated = ProductionData.Country:GetICPart(CDistributionSetting._PRODUCTION_PRODUCTION_):Get()
	ProductionData.IC.Used = ProductionData.Country:GetUsedIC():Get()
	ProductionData.IC.Available = ProductionData.IC.Allocated - ProductionData.IC.Used

	-- Performance check
	--   if no IC just exit completely so no objects get created
	if ProductionData.IC.Available < 0.1 then
		return
	end

	-- Initialize counts
	for k, v in pairs(UnitTypes) do
		ProductionData.Units[k] = {
			Built = 0,
			Building = 0,
			Need = 0,
			Total = 0
		}
	end
	
	ProductionData.ministerAI = minister:GetOwnerAI()
	ProductionData.IsExile = ProductionData.Country:IsGovernmentInExile()
	ProductionData.IsPuppet = ProductionData.Country:IsPuppet()
	ProductionData.IcOBJ = Support_Functions.GetICBreakDown(ProductionData.Country)
	ProductionData.PortsTotal = ProductionData.Country:GetNumOfPorts()
	ProductionData.IsNaval = (ProductionData.PortsTotal > 0 and ProductionData.IcOBJ.IC >= 20)
	ProductionData.Ideology = ProductionData.Country:GetRulingIdeology()
	ProductionData.IdeologyGroup = ProductionData.Ideology:GetGroup()
	ProductionData.IdeologyGroupName = tostring(ProductionData.IdeologyGroup:GetKey())

	ProductionData.TechStatus = ProductionData.Country:GetTechnologyStatus()
	ProductionData.Manpower.IsMobilizeCovered = ProductionData.Country:HasExtraManpowerLeft()
	ProductionData.IsAtWar = ProductionData.Country:IsAtWar()
	ProductionData.CapitalPrv = ProductionData.Country:GetActingCapitalLocation()
	ProductionData.CapitalPrvID = ProductionData.CapitalPrv:GetProvinceID()
	ProductionData.Continent = tostring(ProductionData.CapitalPrv:GetContinent():GetTag())
	-- End Initialize Production Object
	-- #################

	-- Custom Init Call
	ProductionData.Custom = Support_Country.Call_Function(ProductionData, "ProductionData_Init", ProductionData)
	
	-- Convoys
	ProductionData = Prod_Convoy.ConstructConvoys(ProductionData, ProductionData.IC.Available)
	
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickB")
	-- Check to make sure they have Manpower
	--    IC check added for performance. If none dont bother executing.
	if ProductionData.Manpower.IsMobilizeCovered and ProductionData.IC.Available > 0.1 then
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBA")
		-- Performance, load only if Manpower/IC check past
		ProductionData.FirePower.IsActive = (ProductionData.TechStatus:GetLevel(CTechnologyDataBase.GetTechnology("superior_firepower")) ~= 0)
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBB")
		ProductionData.Carrier.Size = 2 --ProductionData.TechStatus:GetLevel(CTechnologyDataBase.GetTechnology("carrier_flat_technology"))
	----Utils.LUA_DEBUGOUT("ProductionMinister_TickBC")
		--ProductionData.Carrier.Size = ProductionData.TechStatus:GetLevel(CTechnologyDataBase.GetTechnology("carrier_size_technology")) + ProductionData.Carrier.Size
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBD")
		ProductionData.Manpower.Total = ProductionData.Country:GetManpower():Get()
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBE")
		ProductionData.AirfieldsTotal = ProductionData.Country:GetNumOfAirfields()
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBF")

		-- These variables mainly used to call tech generator to calculate ratios
		---   Placed in here for performance reasons.
		ProductionData.TotalLeadership = ProductionData.Country:GetTotalLeadership():Get()
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBG")
		ProductionData.icSupplies = ProductionData.Country:GetICPart(CDistributionSetting._PRODUCTION_SUPPLY_):Get()
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBH")
		ProductionData.icSupplyPercentage = ProductionData.icSupplies / ProductionData.IcOBJ.IC
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBI")
		ProductionData.TechList = Support_Country.Call_Function(ProductionData, "TechList", ProductionData)
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBJ")

		-- Verify Build Ratios against available units
		-- 1 = Land
		-- 2 = Air
		-- 3 = Sea
		-- 4 = Other (Typically Buildings)
		local laProdWeights = Support_Country.Call_Function(ProductionData, "ProductionWeights", ProductionData)
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBK")
		
		if ProductionData.FirePower.IsActive then
			ProductionData.FirePower.Units = Support_Country.Call_Function(ProductionData, "FirePower", ProductionData)
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickBL")
		end

	--Utils.LUA_DEBUGOUT("ProductionMinister_TickC")
		-- Elite Units processing before anything else so IC is distributed after
		ProductionData = Prod_Elite.Build(ProductionData, ProductionData.IC.Available)

		-- Get the counts of the unit types currently being produced
		local laTempProd = ProductionData.ministerAI:GetProductionSubUnitCounts()
		local laTempCurrent = ProductionData.ministerAI:GetDeployedSubUnitCounts()
		--local laTempTReq = ProductionData.ministerAI:GetTheatreSubUnitNeedCounts()
		
		-- Get the build counts
		for subUnit in CSubUnitDataBase.GetSubUnitList() do
			local lsUnitType = subUnit:GetKey():GetString() 
			
			if not(UnitTypes[lsUnitType] == nil) then
				local nIndex = subUnit:GetIndex()

				ProductionData.Units[lsUnitType].Built = laTempCurrent:GetAt(nIndex)
				ProductionData.Units[lsUnitType].Building = laTempProd:GetAt(nIndex)
				ProductionData.Units[lsUnitType].Total = ProductionData.Units[lsUnitType].Built + ProductionData.Units[lsUnitType].Building
			end
		end	
		
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickD")
		-- One loop to do all the counting (Performance)
		for k, v in pairs(UnitTypes) do
			v.Name = k
			ProductionData = Prod_Units.UpdateCounts(ProductionData, v)
		end
		-- End of Counting

		-- If no air fields do not build any air units
		if not(ProductionData.AirfieldsTotal > 0) and laProdWeights[2] > 0 then
			for i = 1, 4, 1 do
				-- Make sure not Air
				if i ~= 2 then
					if laProdWeights[i] > 0 then
						-- We found something so exit
						laProdWeights[i] = laProdWeights[2] + laProdWeights[i]
						break
					end
				end
			end
		end

		-- If no ports do not build any naval units
		if not(ProductionData.PortsTotal > 0) and laProdWeights[3] > 0 then
			for i = 1, 4, 1 do
				-- Make sure not Sea
				if i ~= 3 then
					if laProdWeights[i] > 0 then
						-- We found something so exit
						laProdWeights[i] = laProdWeights[3] + laProdWeights[i]
						break
					end
				end
			end
		end

	--Utils.LUA_DEBUGOUT("ProductionMinister_TickE")
		-- Begin IC break down		
		ProductionData.IC.Types.Land.Total = ProductionData.IC.Allocated * laProdWeights[1]
		ProductionData.IC.Types.Air.Total = ProductionData.IC.Allocated * laProdWeights[2]
		ProductionData.IC.Types.Sea.Total = ProductionData.IC.Allocated * laProdWeights[3]
		ProductionData.IC.Types.Other.Total = ProductionData.IC.Allocated * laProdWeights[4]

		-- Figure out what the AI is currently producing in each category
		for loBuildItem in ProductionData.Country:GetConstructions() do
			if loBuildItem:IsMilitary() then
				local loMilitary = loBuildItem:GetMilitary()
				
				if loMilitary:IsLand() then
					ProductionData.IC.Types.Land.Building = ProductionData.IC.Types.Land.Building + loBuildItem:GetCost()
				elseif loMilitary:IsNaval() then
					ProductionData.IC.Types.Sea.Building = ProductionData.IC.Types.Sea.Building + loBuildItem:GetCost()
				elseif loMilitary:IsAir() then
					for loConstDef in loMilitary:GetBrigades() do
						local loSubUnit = loConstDef:GetType()
						
						-- If it is a cag add it to naval IC count instead of air
						if loSubUnit:IsCag() then
							ProductionData.IC.Types.Sea.Building = ProductionData.IC.Types.Sea.Building + loBuildItem:GetCost()
						else
							ProductionData.IC.Types.Air.Building = ProductionData.IC.Types.Air.Building + loBuildItem:GetCost()
						end
						
						-- Exit the loop right away
						break
					end
				end
			else
				ProductionData.IC.Types.Other.Building = ProductionData.IC.Types.Other.Building + loBuildItem:GetCost()
			end
		end
		
		-- Allocate IC to each section
		for k, v in pairs(ProductionData.IC.Types) do
			v.Available = v.Total - v.Building
		end

		-- Needs to be in a seperate loop from the above loop incase Country specific file needs something
		for k, v in pairs(ProductionData.IC.Types) do
			if v.Available > 0.1 and v.IsMain then
				ProductionData = v.Produce(ProductionData, v.Available)
			end
		end
	end

	--Utils.LUA_DEBUGOUT("ProductionMinister_TickF")
	-- Reset Available to whicever is max in case some other area went over
	ProductionData.IC.Available = math.max(ProductionData.IC.Available, ProductionData.IC.Types.Other.Available)

	-- There is IC left so produce buildigns
	if ProductionData.IC.Available > 0.1 then
		--Utils.LUA_DEBUGOUT("BUILDING: " .. tostring(ProductionData.Tag))
		ProductionData = Prod_Buildings.Build(ProductionData, ProductionData.IC.Available)
	end

	if math.random(4) == 1 then
		ProductionData.minister:PrioritizeBuildQueue()
	end
	--Utils.LUA_DEBUGOUT("ProductionMinister_TickG")
end