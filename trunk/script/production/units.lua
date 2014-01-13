-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production Units File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/14/2013
-----------------------------------------------------------

local P = {}
Prod_Units = P

-- ###############################################
-- Producton support methods
-- ###############################################
function P.ProcessUnits(voProductionData, viIC, vaUnitRatio)
--Utils.LUA_DEBUGOUT("ProcessUnits")
-- ###############################################
-- Processes an array of units based on the Need count and how low they are on their ratio.
--   The units with the lowest ratio go to the top of the que.
-- voProductionData = Production Data Object
-- viIC				= Amount of IC that can be used for production the units
-- vaUnitRatio		= Array with the units that can be built
-- ###############################################

	-- Performance check, make sure there is enough IC to actually do something
	if viIC > 0.1 then
		local lsLowestUnit
		local liLowestValue = -1
		local laUnitProcess = {}

		-- Main Loop Determines how many passess we actually have to make
		for i, z in pairs(vaUnitRatio) do
			for k, v in pairs(vaUnitRatio) do
				if not(laUnitProcess[k] == true) then
					if (not(lsLowestUnit == k) and liLowestValue >= vaUnitRatio[k])
					or liLowestValue == -1 then
						liLowestValue = vaUnitRatio[k]
						lsLowestUnit = k
					end
				end
			end

			laUnitProcess[lsLowestUnit] = true

			voProductionData, viIC = P.BuildUnit(voProductionData, viIC, lsLowestUnit)			

			liLowestValue = -1
		end
	end
	
	return voProductionData, viIC
end
function P.BuildUnit(voProductionData, viIC, vsType)
--Utils.LUA_DEBUGOUT("BuildUnit")
-- ###############################################
-- Builds the unit type specified, but also makes a copy of the units object so it can't be permanately changed in a country specific file.
--    Pulls the unit type from the UnitTypes global variable and how many it needs from the voProductionData Object
-- voProductionData = Production Data Object
-- viIC				= Amount of IC that can be used for production the units
-- vsType			= Unit type to build
-- ###############################################

	local loType = { Name = vsType }
	for k, v in pairs(UnitTypes[vsType]) do
		loType[k] = UnitTypes[vsType][k]
	end

	-- Setup Parameter defaults
	if loType.Serial == nil then loType.Serial = 1 end
	if loType.Size == nil then loType.Size = 1 end
	if loType.Support == nil then loType.Support = 0 end
	
	local lbLicenseRequired = false
	lbLicenseRequired, voProductionData.Manpower.Total =  Support_License.ProductionCheck(loType, voProductionData)
	
	if not(lbLicenseRequired) then
		if viIC > 0.1 and voProductionData.Units[vsType].Need > 0 then 
			-- Firepower Check, if present and on list add one to support count
			if voProductionData.FirePower.IsActive then
				if voProductionData.FirePower.Units ~= nil then
					for i = 0, table.getn(voProductionData.FirePower.Units), 1 do
						if voProductionData.FirePower.Units[i] == vsType then
							if loType.Support > 1 then
								loType.Support = loType.Support + 1 -- Increase support units needed
							else
								loType.Size = loType.Size + 1 -- Increase Unit Size
							end
							break
						end
					end
				end
			end

			if loType.SubType == "Carrier" then
				loType.SubQuantity = loType.SubQuantity + voProductionData.Carrier.Size
			end
		
			local lsMethodOveride = "Build_" .. vsType
			local liOrigNeed = voProductionData.Units[vsType].Need
			-- Check to see if the Country AI file has an overide or Defaults Do
			local loFunRef = Support_Country.Get_Function(voProductionData, lsMethodOveride)
			if loFunRef then
				viIC, voProductionData.Manpower.Total, voProductionData.Units[vsType].Need = loFunRef(viIC, voProductionData.Manpower.Total, loType, voProductionData, voProductionData.Units[vsType].Need)
			else
				viIC, voProductionData.Manpower.Total, voProductionData.Units[vsType].Need = Prod_Units.CreateUnit(loType, viIC, voProductionData.Units[vsType].Need, voProductionData, nil)
			end

			-- Done in case Production makes a second pass
			voProductionData.Units[vsType].Building = voProductionData.Units[vsType].Total + (liOrigNeed - voProductionData.Units[vsType].Need)
			voProductionData = P.UpdateCounts(voProductionData, loType)
		end
	end

	return voProductionData, viIC
end
function P.CreateUnit(voType, vIC, viUnitQuantity, voProductionData, vaSupportUnits, vbForce)
--Utils.LUA_DEBUGOUT("CreateUnit")
-- ###############################################
-- Creates the physical unit and places it in the production que
--	loType = {
--		Name = "infantry_brigade", 				### The unit type
--		Serial = 4, 							### How large of a serial run do you want
--		Size = 1,  								### How many of this unit type do you want in the division
--		Support = 2, 							### How many support units do you want
--		SupportGroup = "Infantry", 				### What support group to use
--		SecondaryMain = "bergsjaeger_brigade", 	### What secondary main unit do you want to attach to this (will attach 1 of them)
--		SubUnit = "cag", 						### Builds this is a seperate unit if the main one is built
--		SubQuantity = 1}  						### How many to build of the seperate unit

--  laSupportUnit = {
--		"anti_air_brigade",
--		"anti_tank_brigade"}

-- voType 			= look at the definition above (loType) on how to create the voType Array
-- vIC 				= how many IC is available to build this unit	
-- viUnitQuantity 	= How many of this unit type do we need to build
-- voProductionData	= Production Object from ai_production_minister.lua
-- vaSupportUnit	= (OPTIONAL) Look at the definition above (laSupportUnit) on how to create one.
-- vbForce			= (OPTIONAL) It will foce production of the unit and ignore IC cost (still checks MP)
-- ###############################################

	if voType.Size == nil then voType.Size = 1 end
	
	-- Not enough to build the unit so exit	
	if voType.Size > viUnitQuantity then
		return vIC, voProductionData.Manpower.Total, viUnitQuantity
	end
	
	local loUnitType = CSubUnitDataBase.GetSubUnit(voType.Name)
	if (vIC > 0.1 or vbForce) and voProductionData.TechStatus:IsUnitAvailable(loUnitType) then
		local loSecUnitType = nil
		local liSecManpowerCost = 0
		
		-- Secondary Main Unit Type setup
		if not(voType.SecondaryMain == nil) then
			loSecUnitType = CSubUnitDataBase.GetSubUnit(voType.SecondaryMain)
			
			-- If secondary main can not be built then exit out immediately
			if not(voProductionData.TechStatus:IsUnitAvailable(loSecUnitType)) then
				return vIC, voProductionData.Manpower.Total, viUnitQuantity
			end
			
			liSecManpowerCost = loSecUnitType:GetBuildCostMP():Get()
		end
		
		-- Setup Parameter defaults
		if voType.Serial == nil then voType.Serial = 1 end
		if voType.Support == nil then voType.Support = 0 end
	
		local liUnitMPcost = loUnitType:GetBuildCostMP():Get()
		local liManpowerCostByUnit = ((liUnitMPcost * voType.Size) + liSecManpowerCost)
		local liManpowerLeft = voProductionData.Manpower.Total
		
		if (liManpowerLeft > liManpowerCostByUnit) then
			local liSecUnitCost = 0
			local lbReserve = (not voProductionData.IsAtWar) and loUnitType:IsRegiment()

			-- Secondary Unit Cost Check
			if not(loSecUnitType == nil) then
				liSecUnitCost = voProductionData.Country:GetBuildCostIC( loSecUnitType, 1, lbReserve ):Get()
			end
		
			local liTotalDivisions = math.floor(viUnitQuantity / voType.Size)
			local i = 0 -- Counter for amount of units built
			local liUnitCost = (voProductionData.Country:GetBuildCostIC( loUnitType, 1, lbReserve ):Get()) + liSecUnitCost
			local laOriginalSupportArray = nil
				
			-- Performance reasons why its done outside of the loop
			if vaSupportUnits ~= nil then
				laOriginalSupportArray = vaSupportUnits
			elseif voType.SupportGroup ~= nil then
				laOriginalSupportArray = P.BuildSupportArray(voType.SupportGroup, voProductionData)
			end
			
			if liTotalDivisions > 0 then
				while i < liTotalDivisions do
					local liBuildCount
					local laAttachUnitArray = nil
					
					-- If there is a support array then process it
					if laOriginalSupportArray ~= nil then
						laAttachUnitArray = {}
						
						-- Make a copy of the support table so it can be reused for each parrallel run
						for y = 1, table.getn(laOriginalSupportArray) do
							laAttachUnitArray[y] = laOriginalSupportArray[y]
						end
					end

					if 	liTotalDivisions >= (i + voType.Serial) then
						local liTManpowerCost = liManpowerCostByUnit * voType.Serial
						
						-- We have enough MP so continue
						if liManpowerLeft > liTManpowerCost then
							liBuildCount = voType.Serial
							i = i + voType.Serial
							liManpowerLeft = liManpowerLeft - liTManpowerCost
							
						-- We do not have enough MP so stick to what we can build
						else
							liBuildCount = math.floor(liManpowerLeft / liManpowerCostByUnit)
							i = liTotalDivisions
							liManpowerLeft = liManpowerLeft - (liManpowerCostByUnit * liBuildCount)
						end
					else
						local liTManpowerCost = liManpowerCostByUnit * liTotalDivisions
					
						if liManpowerLeft > liTManpowerCost then
							liBuildCount = liTotalDivisions - i
							liManpowerLeft = liManpowerLeft - liTManpowerCost
						else
							liBuildCount = math.floor(liManpowerLeft / liManpowerCostByUnit)
							liManpowerLeft = liManpowerLeft - (liManpowerCostByUnit * liBuildCount)
						end
						
						i = liTotalDivisions
					end
					
					vIC = vIC - (liUnitCost * voType.Size)

					local loBuildOrder = SubUnitList()
					-- Add the amount of brigades requested of the main type
					for m = 1, voType.Size, 1 do
						SubUnitList.Append( loBuildOrder, loUnitType )
					end

					-- Check to see if there is a secondary main
					if not(loSecUnitType == nil) then
						SubUnitList.Append( loBuildOrder, loSecUnitType )
					end
					
					-- Attach a minor brigade if one can be attached
					--   updated the vIC total for the minor unit being attached
					if laAttachUnitArray ~= nil then
						for x = 1, voType.Support do
							local liTotalSupportUnits = table.getn(laAttachUnitArray)

							if liTotalSupportUnits > 0 then
								local loSupportUnit = (math.random(liTotalSupportUnits))
								local liManpowerCostBySubUnit = laAttachUnitArray[loSupportUnit]:GetBuildCostMP():Get()
								
								-- Enough MP so attach the support unit
								if liManpowerLeft > liManpowerCostBySubUnit then
									SubUnitList.Append( loBuildOrder, laAttachUnitArray[loSupportUnit] )
									vIC = vIC - (voProductionData.Country:GetBuildCostIC( laAttachUnitArray[loSupportUnit], 1, lbReserve ):Get())
									liManpowerLeft = liManpowerLeft - liManpowerCostBySubUnit
								end
								
								-- Remove the unit from the array so it will not get 2 of the same support units
								table.remove(laAttachUnitArray, loSupportUnit)
								
							-- No Minors so exit out
							else
								x = voType.Support + 1
							end
						end
					end
						
					viUnitQuantity = viUnitQuantity - (voType.Size * liBuildCount)
					voProductionData.ministerAI:Post(CConstructUnitCommand(voProductionData.Tag, loBuildOrder, voProductionData.CapitalPrvID, liBuildCount, lbReserve, CNullTag(), CID()))

					-- Process sub unit (used mainly for Carriers to build CAG)
					if not(voType.SubUnit == nil) and liManpowerLeft > 0 then
						-- Call self
						local liUnitNeeds -- Variable is not used at all

						-- Copy the object so the original is not changed
						local loType = {Name = voType.SubUnit}
						for k, v in pairs(UnitTypes[voType.SubUnit]) do
							loType[k] = UnitTypes[voType.SubUnit][k]
						end
						
						loType.Serial = liBuildCount
						vIC, voProductionData.Manpower.Total, liUnitNeeds = P.CreateUnit(loType, vIC, (voType.SubQuantity * liBuildCount), voProductionData, nil, true)
					end
					
					-- Reset the ManpowerTotal
					voProductionData.Manpower.Total = liManpowerLeft
					
					if vIC <= 0.1 and not(vbForce) then
						i = liTotalDivisions --Causes it to exit loop
					end
				end
			end
		end
	end

	return vIC, voProductionData.Manpower.Total, viUnitQuantity
end
function P.BuildSupportArray(vsSupportGroup, voProductionData, voFilter)
--Utils.LUA_DEBUGOUT("BuildSupportArray")
-- ###############################################
-- Called by the CreateUnit method, it helps build a support unit array based on the SupportType
-- vsSupportGroup	= Selects the units assigned to the specified Support group stored in UnitTypes, SupportGroup
-- voProductionData	= Production Data Object
-- voFilter			= String Array of units to block from forming the support group array
-- ###############################################

	local laUnitArray = {}
		
	if not(voFilter) then
		voFilter = {}
	else
		voFilter = Utils.Set(voFilter)
	end
	
	for k, v in pairs(UnitTypes) do
		if v.SupportType ~= nil then
			if v.SupportType[vsSupportGroup] then
				if not(voFilter[k]) then
					local loUnit = CSubUnitDataBase.GetSubUnit(k)
					if voProductionData.TechStatus:IsUnitAvailable(loUnit) then
						table.insert( laUnitArray, loUnit )
					end
				end
			end
		end
	end
	
	return laUnitArray	
end
function P.UpdateCounts(voProductionData, voType)
--Utils.LUA_DEBUGOUT("UpdateCounts")
-- ###############################################
-- Updates all the main counts for the specified unit
-- voProductionData	= Production Data Object
-- voType			= Unit object to update the counts for
-- ###############################################

	voProductionData.Units.Counts[voType.Type] = voProductionData.Units.Counts[voType.Type] + voProductionData.Units[voType.Name].Total

	if voType.Type == "Land" and voType.SubType == "Special Forces" then
		voProductionData.Units.Counts.Special = voProductionData.Units.Counts.Special + voProductionData.Units[voType.Name].Total
	end
	if voType.CanPara == true then 
		voProductionData.Units.Counts.Para = voProductionData.Units.Counts.Para + voProductionData.Units[voType.Name].Total 
	end

	return voProductionData
end

function P.StandardProdRatio(voProductionData, voProdOBJ)
--Utils.LUA_DEBUGOUT("StandardProdRatio")
-- ###############################################
-- Calculates the unit ratios and how many of each unit type is needed based on the ratios
--   Called from all the main production LUA files
-- voProductionData	= Production Data Object
-- voProdOBJ		= Production Object (Air, Land, Sea or Elite)
-- ###############################################

	voProdOBJ.Ratio = P.IsUnitsAvailable(voProductionData, voProdOBJ.Ratio)

	-- Calculate what the ratio is for each unit type
	for k, v in pairs(voProdOBJ.Ratio) do
		voProdOBJ.ActualRatio[k] = P.CalculateRatio(voProductionData.Units[k].Total, voProdOBJ.Ratio[k])
	end
		
	-- Multiplier used to figure out how many units of each type you need
	--   to keep the ratio
	voProdOBJ.Multiplier = P.GetMultiplier(voProdOBJ)

	-- Now Figure out what the Unit needs are
	for k, v in pairs(voProdOBJ.ActualRatio) do
		voProductionData.Units[k].Need = (voProdOBJ.Ratio[k] * voProdOBJ.Multiplier) - voProductionData.Units[k].Total
	end

	return voProductionData, voProdOBJ
end
function P.IsUnitsAvailable(voProductionData, vaRatio)
--Utils.LUA_DEBUGOUT("IsUnitsAvailable")
-- ###############################################
-- Goes through the array of units and checks to see if they can be built (Checks if unit is availabe)
--   Does a sub ject to see if the unit has been defined as a License. If so it will allow it to stay in the array even if it can't be built.
-- voProductionData	= Production Data Object
-- vaRatio			= String array of units and the ratio they have been assigned
-- ###############################################

	for k, v in pairs(vaRatio) do
		if not(voProductionData.TechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit(k))) then
			if not(UnitTypes[k].License) then
				vaRatio[k] = 0
			end
		end
	end
	
	return vaRatio
end
function P.GetHighestUnit(voProductionData, vsSubType)
--Utils.LUA_DEBUGOUT("GetHighestUnit")
-- ###############################################
-- Grabs the highest unit in the UnitTypes array for the Sub Type specified
--    return nil if no Available unit was found
-- voProductionData	= Production Data Object
-- vsSubType		= String sub type being requested
-- ###############################################

	local lsUnitAvailable = nil
	
	for k, v in pairs(UnitTypes) do
		if v.SubType == vsSubType then
			if voProductionData.TechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit(k)) then
				lsUnitAvailable = k
			end
		end
	end
	
	return lsUnitAvailable
end
function P.CalculateRatio(viUnitCount, viUnitRatio)
--Utils.LUA_DEBUGOUT("CalculateRatio")
-- ###############################################
-- Calculates the current ratios based off the unit count
-- viUnitCount		= How many units of this type exist
-- viUnitRatio		= What is the ratio designated for this unit type
-- ###############################################

	local rValue
	
	if viUnitRatio == 0 then
		rValue = 0
	elseif viUnitCount == 0 then
		rValue = 1
	else
		rValue = viUnitCount / viUnitRatio
	end
	
	return rValue
end
function P.GetMultiplier(voProdObj)
--Utils.LUA_DEBUGOUT("GetMultiplier")
-- ###############################################
-- Goes through the ActualRatio array in the voProdObj object and grabs the highest multiplier and returns it.
-- voProdObj		= Production Object from the types (Sea, Air, Land and Elite)
-- ###############################################

	local liMultiplier = 0
	local liAddToMultiplier = 2
	
	for k, v in pairs(voProdObj.ActualRatio) do	
		if voProdObj.Ratio[k] > 0 then
			liMultiplier = math.max(liMultiplier, voProdObj.ActualRatio[k])
		end
	end
	
	-- Make sure some sort of multiplier gets past, AddToMultipler if 0 means Multiplier is something
	return math.max((liMultiplier + liAddToMultiplier), liAddToMultiplier)
end

return Prod_Units