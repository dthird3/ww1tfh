	-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production Buildings File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/13/2013
-----------------------------------------------------------

local P = {}
Prod_Buildings = P

-- ###################################
-- # Main Method called by the ai_production_minister
-- #####################################
function P.Build(voProductionData, viIC)
--Utils.LUA_DEBUGOUT("buildBuild")
	local liOriginalIC = viIC

	-- Buildings
	local loProdBuilding = {
		UseRandom = true,
		Buildings = {
			radar_station = {
				Priority = 1,							-- If UserRandom = false then it uses Priority
				Build = false,							-- True/False should we build this building
				BuildCap = 0,							-- Maximum amount of these buldings we should ever have 0 means unlimited
				MaxQue = 0,								-- Maximum amount to have in the production que at any time 0 means no max set
				MaxRun = 2,								-- How many to process in a single loop (integer)
				ExpenseRule = false,					-- Only build if incoming resources exceed resources used by industry
				CoreOnly = false,						-- True/False build only in core provinces
				NonCoreOnly = false,					-- True/False build only in non-core provinces
				CapitalOnly = false,					-- Limits the building to the Capital Province only
				CapitalAddPrefer = false,				-- Adds the Capital Province ID to the prefer list so that its always prio for the building but will build it in other areas
			 --	RequireIsOr = true,						-- True/False Makes the RequireBuilding/BackupBuilding switch from an AND statement on the building types to an OR statement
				RequireBuilding = { radar_station = 1 }, -- Required building and how many of that building type (greater than or equal to)
				BackupBuilding = { air_base = 1 },		-- If the RequiredBuilding is not found then it looks at the secondary one if a Primary is found all secondary are ignored
				Terrain = {"urban"},					-- Not used future parm
				Continent = nil,						-- Building is restricted to only provinces in this continent
				IsFrontProvince = false,				-- True/False do we allow this build on front provinces
				OnlyFrontProvince = false, 				-- True/False only build this on front provinces
				PreferOnly = false,						-- Only do what is on the prefer list and nothing more
				PreferList = nil,						-- List of IDs that are on the prefer list for building
				PreferMaxLevel = nil					-- Max level before ID is removed from prefer list
			},
			rocket_test = {
				Priority = 2,
				Build = false,
				BuildCap = 1,
				MaxQue = 1,
				MaxRun = 1,
				ExpenseRule = false,
				CoreOnly = true,
				NonCoreOnly = false,
				CapitalOnly = false,
				CapitalAddPrefer = false,
				RequireBuilding = { industry = 1},
				Terrain = {"urban"},
				Continent = nil,
				IsFrontProvince = false,
				OnlyFrontProvince = false,
				PreferOnly = false,
				PreferList = nil,
				PreferMaxLevel = nil
			},
			coastal_fort = {
				Priority = 3,
				Build = true,
				BuildCap = 0,
				MaxQue = 0,
				MaxRun = 1,
				ExpenseRule = false,
				CoreOnly = false,
				NonCoreOnly = false,
				CapitalOnly = false,
				CapitalAddPrefer = false,
				RequireBuilding = { naval_base = 3},
				Terrain = nil,
				Continent = nil,
				IsFrontProvince = false,
				OnlyFrontProvince = false,
				PreferOnly = false,
				PreferList = nil,
				PreferMaxLevel = nil
			},
			land_fort = {
				Priority = 4,
				Build = true,
				BuildCap = 0,
				MaxQue = 0,
				MaxRun = 1,
				ExpenseRule = false,
				CoreOnly = true,
				NonCoreOnly = false,
				CapitalOnly = false,
				CapitalAddPrefer = false,
				RequireIsOr = true,
				RequireBuilding = { industry = 2, land_fort = 1 },
				Terrain = {"urban"},
				Continent = nil,
				IsFrontProvince = false,
				OnlyFrontProvince = false,
				PreferOnly = false,
				PreferList = nil,
				PreferMaxLevel = nil
			},
			anti_air = {
				Priority = 5,
				Build = true,
				BuildCap = 0,
				MaxQue = 0,
				MaxRun = 3,
				ExpenseRule = false,
				CoreOnly = true,
				NonCoreOnly = false,
				CapitalOnly = false,
				CapitalAddPrefer = true,
				RequireIsOr = true,
				RequireBuilding = { industry = 2, naval_base = 1 },
				Terrain = {"urban"},
				Continent = nil,
				IsFrontProvince = false,
				OnlyFrontProvince = false,
				PreferOnly = false,
				PreferList = nil,
				PreferMaxLevel = nil
			},
			industry = {
				Priority = 6,
				Build = true,
				BuildCap = 0,
				MaxQue = 0,
				MaxRun = 1,
				ExpenseRule = true,
				CoreOnly = true,
				NonCoreOnly = false,
				CapitalOnly = false,
				CapitalAddPrefer = true,
				RequireIsOr = true,
				RequireBuilding = { industry = 2 },
				BackupBuilding = { air_base = 1, naval_base = 1, industry = 1 },
				Terrain = {"urban"},
				Continent = nil,
				IsFrontProvince = false,
				OnlyFrontProvince = false,
				PreferOnly = false,
				PreferList = nil,
				PreferMaxLevel = nil
			},
			nuclear_reactor = {
				Priority = 7,
				Build = false,
				BuildCap = 2,
				MaxQue = 0,
				MaxRun = 1,
				ExpenseRule = false,
				CoreOnly = true,
				NonCoreOnly = false,
				CapitalOnly = false,
				CapitalAddPrefer = false,
				RequireBuilding = { industry = 3 },
				Terrain = {"urban"},
				Continent = nil,
				IsFrontProvince = false,
				OnlyFrontProvince = false,
				PreferOnly = false,
				PreferList = nil,
				PreferMaxLevel = nil
			},
			air_base = {
				Priority = 8,
				Build = true,
				BuildCap = 0,
				MaxQue = 0,
				MaxRun = 2,
				ExpenseRule = false,
				CoreOnly = false,
				NonCoreOnly = false,
				CapitalOnly = false,
				CapitalAddPrefer = false,
				RequireIsOr = true,
				RequireBuilding = { air_base = 1, naval_base = 1, industry = 1 },
				Terrain = nil,
				Continent = nil,
				IsFrontProvince = false,
				OnlyFrontProvince = false,
				PreferOnly = false,
				PreferList = nil,
				PreferMaxLevel = nil
			},
			naval_base = {
				Priority = 9,
				Build = true,
				BuildCap = 0,
				MaxQue = 0,
				MaxRun = 1,
				ExpenseRule = false,
				CoreOnly = false,
				NonCoreOnly = false,
				CapitalOnly = false,
				CapitalAddPrefer = false,
				RequireIsOr = true,
				RequireBuilding = { naval_base = 1, dry_dock = 1 },
				Terrain = nil,
				Continent = nil,
				IsFrontProvince = false,
				OnlyFrontProvince = false,
				PreferOnly = false,
				PreferList = nil,
				PreferMaxLevel = nil
			},
			infra = {
				Priority = 10,
				Build = true,
				BuildCap = 0,
				MaxQue = 0,
				MaxRun = 3,
				ExpenseRule = false,
				CoreOnly = false,
				NonCoreOnly = false,
				CapitalOnly = false,
				CapitalAddPrefer = true,
				RequireIsOr = true,
				RequireBuilding = { rail_road = 1, industry = 3 },
				Terrain = nil,
				Continent = nil,
				IsFrontProvince = false,
				OnlyFrontProvince = false,
				PreferOnly = false,
				PreferList = nil,
				PreferMaxLevel = nil
			},
			-- Underground any other rules beyond these are not used and cause LUA error
			underground = {
				Priority = 19,
				Build = false,
				MaxQue = 0,
				BuildCap = 0,
				MaxRun = 3,
				ExpenseRule = false
			}
		}
	}
		
	if voProductionData.IcOBJ.IC > 50
	or voProductionData.IcOBJ.IC > 10 and voProductionData.Year > 1943 then
		loProdBuilding.Buildings.rocket_test.Build = true
		loProdBuilding.Buildings.nuclear_reactor.Build = true
	end	
	
	local loFunRef = Support_Country.Get_Function(voProductionData, "Buildings")
		
	-- Process default overides
	if loFunRef then
		local loProvOverides = loFunRef(voProductionData)
			
		if loProvOverides.Buildings.UseRandom == false then
			loProdBuilding.Buildings.UseRandom = false
		end
			
		for k, v in pairs(loProvOverides.Buildings) do
			if not(loProvOverides.Buildings[k]) then
				loProdBuilding.Buildings[k].Build = false
			else
				for x, y in pairs(loProvOverides.Buildings[k]) do
					loProdBuilding.Buildings[k][x] = loProvOverides.Buildings[k][x]
				end
			end
		end
	end		
		
	local loBuildOBJArray = {}
	local loRandomList = {}
	local liBuildingCount = 0
		
	local lbDoCoreLoop = false -- Just for Performance in case there is a reason someone does not care where things go
	local lbExpenseRule = false -- Performance incase they do not want the rule
		
	for k, v in pairs(loProdBuilding.Buildings) do
		if v.Build then
			v.Name = k
			v.OBJ = CBuildingDataBase.GetBuilding(k)
			v.CanBuild = voProductionData.TechStatus:IsBuildingAvailable(v.OBJ)
				
			if v.CanBuild then
				if v.CoreOnly or v.NonCoreOnly then
					lbDoCoreLoop = true
				end
				if v.ExpenseRule then
					lbExpenseRule = true
				end

				if v.CapitalAddPrefer then
					if v.PreferList == nil then
						v.PreferList = { voProductionData.CapitalPrvID }
					else
						table.insert(v.PreferList, voProductionData.CapitalPrvID)
					end
				end

				v.Cost = voProductionData.Country:GetBuildCost(v.OBJ):Get()
				v.PreferList = Utils.Set(v.PreferList)
				liBuildingCount = liBuildingCount + 1
				loRandomList[liBuildingCount] = v.Name

				loBuildOBJArray[k] = v
			end
		end
	end		

	local loProvinces = P.ProvincesLoop(voProductionData, lbDoCoreLoop)

	-- Performance check, no need to count resources if we dont want the rule
	if vbExpenseRule then
		local liExpenseFactor, liHomeFactor = P.CalculateExpenseResourceFactor(ProductionData.Country)
			
		-- We produce more than what we use so build more industry
		if liHomeFactor > liExpenseFactor then
			lbExpenseRule = true
		end
	end		

	if liBuildingCount > 0 then
		for l = 1, liBuildingCount do 
			local liIndex = l
				
			if loProdBuilding.UseRandom then
				-- Grab things randomly
				liIndex = math.random(table.getn(loRandomList))
			else
				local liLowesIndex = nil
				local liLowestPriority = nil
					
				-- Sort by Priority
				for z = 1, table.getn(loRandomList) do
					if not(liLowesIndex) then
						liLowesIndex = z
						liLowestPriority = loBuildOBJArray[loRandomList[z]].Priority
					else
						if liLowestPriority > loBuildOBJArray[loRandomList[z]].Priority then
							liLowesIndex = z
							liLowestPriority = loBuildOBJArray[loRandomList[z]].Priority
						end
					end
				end
					
				liIndex = liLowesIndex
			end
			
			-- Max sure we are not at the maximum amount we can have in the production que
			if loBuildOBJArray[loRandomList[liIndex]].MaxQue == 0
			or  loBuildOBJArray[loRandomList[liIndex]].MaxQue > loProvinces.Buildings[loRandomList[liIndex]].Que then
				
				-- If there is a MaxQue then we need to modify MaxRun so we do not exceed our que count
				if loBuildOBJArray[loRandomList[liIndex]].MaxQue > 0 then
					local liMaxQueCount = loBuildOBJArray[loRandomList[liIndex]].MaxQue - loProvinces.Buildings[loRandomList[liIndex]].Que

					if loBuildOBJArray[loRandomList[liIndex]].MaxRun > liMaxQueCount then
						loBuildOBJArray[loRandomList[liIndex]].MaxRun = liMaxQueCount
					end
				end

				-- Make sure we have not hit any cap and if so skip this building
				if loBuildOBJArray[loRandomList[liIndex]].BuildCap == 0 
				or  loBuildOBJArray[loRandomList[liIndex]].BuildCap > loProvinces.Buildings[loRandomList[liIndex]].Count then
				
					-- If the building needs Expense Rule check
					if not(loBuildOBJArray[loRandomList[liIndex]].ExpenseRule)
					or loBuildOBJArray[loRandomList[liIndex]].ExpenseRule == lbExpenseRule then
					
						local lbProcess = true -- Flag used to indicate to process regular code as well
						local loFunRef = Support_Country.Get_Function(voProductionData, "Build_" .. loRandomList[liIndex])
						
						if loFunRef then
							viIC, lbProcess = loFunRef(viIC, voProductionData)
						end
						
						if lbProcess and viIC > 0.1 then
							local loUserdProvinceIDs = {}
							
							for i = 1, loBuildOBJArray[loRandomList[liIndex]].MaxRun do
								--Utils.LUA_DEBUGOUT("COUNTRY: " .. tostring(voProductionData.tag) )
								local liProvinceID = P.GetProvince(loProdBuilding.Buildings[loRandomList[liIndex]], loProvinces, loUserdProvinceIDs, voProductionData)
			
								-- If no Province ID that means we have nothing that qualifies so skip it
								if not(liProvinceID) or viIC <= 0.1 then
									break
								else
									local loCommand = CConstructBuildingCommand(voProductionData.Tag, loProdBuilding.Buildings[loRandomList[liIndex]].OBJ, liProvinceID, 1 )
			
									if loCommand:IsValid() then
										table.insert(loUserdProvinceIDs, liProvinceID)
										voProductionData.ministerAI:Post(loCommand)
										viIC = viIC - loProdBuilding.Buildings[loRandomList[liIndex]].Cost -- Upodate IC total	
									end
								end
								i = i + 1
							end
						elseif viIC <= 0.1 then
							break
						end
					end
				end
			end
				
			-- Remove item from the random list
			table.remove(loRandomList, liIndex)
		end
	end
	
	voProductionData.IC.Available = voProductionData.IC.Available - (liOriginalIC - viIC)

	return voProductionData
end

-- ###################################
-- # Support Methods used in P.Build method
-- #####################################
function P.GetProvince(loBuilding, voProvinces, voUserdProvinceIDs, voProductionData)
--Utils.LUA_DEBUGOUT("GetProvince")
	local loPreferIDs = {}
	local loProvinceIDs = {}
	local loUsedProvinceIDs = Utils.Set(voUserdProvinceIDs)

	local BackUpBuilding = {
		Needed = (loBuilding.BackupBuilding),
		Prefer = { Count = 0 },
		Backup = {
			Count = 0,
			Provinces = {}
		}
	}
	
	for k, v in pairs(voProvinces.Provinces) do
	
		-- Undegrounds have a special method to get their ProvinceIDs
		if loBuilding.Name == "underground" then
			return voProductionData.Country:GetRandomUnderGroundTarget()
	
		elseif not(loUsedProvinceIDs[v.ID]) then
	
	
			-- Make sure there is room for the building
			if not(v.Buildings[loBuilding.Name].CurrentlyBuilding > 0)
			and v.Buildings[loBuilding.Name].CurrentSize < 10 then
				local lbSkip = false
				
				-- Prefer list check		
				if loBuilding.PreferList then
					if loBuilding.PreferList[v.ID] then
						if voProductionData.Country:IsBuildingAllowed(loBuilding.OBJ, v.Province) then
							if not(loBuilding.PreferMaxLevel) then
								table.insert(loPreferIDs, v.ID)
								lbSkip = true
							else
								if loBuilding.PreferMaxLevel == 0
								or v.Buildings[loBuilding.Name].CurrentSize < loBuilding.PreferMaxLevel then
								
									table.insert(loPreferIDs, v.ID)
									lbSkip = true
								end
							end
						end
					end
				end			
			
				if not(lbSkip) and not(loBuilding.PreferOnly) then
					-- Capital province check
					if not(loBuilding.CapitalOnly)
					or loBuilding.CapitalOnly == v.IsCapital then
				
						-- Core province check
						if not(loBuilding.CoreOnly)
						or loBuilding.CoreOnly == v.IsCore then
						
							-- Non-Core province check
							if not(loBuilding.NonCoreOnly)
							or loBuilding.NonCoreOnly ~= v.IsCore then
				
								-- Front province check
								if not(loBuilding.IsFrontProvince)
								or loBuilding.IsFrontProvince == v.IsFrontProvince then

									-- Only Front province check
									if not(loBuilding.OnlyFrontProvince)
									or loBuilding.OnlyFrontProvince == v.IsFrontProvince then
								
										-- Continent province check
										if not(loBuilding.Continent)
										or loBuilding.Continent == v.ContinentName then
										
											local lbBuildingCheck = true
											
											-- Building Check
											if loBuilding.RequireBuilding then
												if loBuilding.RequireIsOr then
													for x, y in pairs(loBuilding.RequireBuilding) do
														--Utils.LUA_DEBUGOUT("x:" .. tostring(x) .. "y:" .. tostring(y) .. " province " .. tostring(v.ID))
														if v.Buildings[x].CurrentSize >= loBuilding.RequireBuilding[x] then
															--Utils.LUA_DEBUGOUT("OK")
															lbBuildingCheck = true
															break -- We met the Or condition so exit
														else
															--Utils.LUA_DEBUGOUT("OK")
															lbBuildingCheck = false
														end	
														--Utils.LUA_DEBUGOUT("OK2")
													end
												else
													for x, y in pairs(loBuilding.RequireBuilding) do
														if v.Buildings[x].CurrentSize < loBuilding.RequireBuilding[x] then
															lbBuildingCheck = false
														end	
													end													
												end

												-- Do we need to process the backup loop
												if BackUpBuilding.Needed then
													-- We have not found anything yet so add to backup
													if lbBuildingCheck then
														BackUpBuilding.Prefer.Count = BackUpBuilding.Prefer.Count + 1
													
													-- Only process this if we have not found anything yet
													elseif BackUpBuilding.Prefer.Count == 0 then
														lbBuildingCheck = true -- Temporary reset back to true

														if loBuilding.RequireIsOr then
															for x, y in pairs(loBuilding.BackupBuilding) do
																if v.Buildings[x].CurrentSize >= loBuilding.BackupBuilding[x] then
																	lbBuildingCheck = true
																	break -- We met the Or condition so exit
																else
																	lbBuildingCheck = false
																end	
															end
														else
															for x, y in pairs(loBuilding.BackupBuilding) do
																if v.Buildings[x].CurrentSize < loBuilding.BackupBuilding[x] then
																	lbBuildingCheck = false
																end	
															end
														end

														-- If we met the condition then add it in
														if lbBuildingCheck then
															BackUpBuilding.Backup.Provinces[k] = v
															BackUpBuilding.Backup.Count = BackUpBuilding.Backup.Count + 1
															lbBuildingCheck = false -- Set to false as it will be added later
														end
													end
												end
											end

											if lbBuildingCheck then
												if voProductionData.Country:IsBuildingAllowed(loBuilding.OBJ, v.Province) then
													table.insert(loProvinceIDs, v.ID)
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	-- Check to see if we need to add backup Province IDs
	if BackUpBuilding.Needed and BackUpBuilding.Prefer.Count == 0 and BackUpBuilding.Backup.Count > 0 then
		for k, v in pairs(BackUpBuilding.Backup.Provinces) do
			table.insert(loProvinceIDs, v.ID)
		end
	end

	if table.getn(loPreferIDs) > 0 then 
		return loPreferIDs[math.random(table.getn(loPreferIDs))]
	end
	
	if table.getn(loProvinceIDs) > 0 then 
		return loProvinceIDs[math.random(table.getn(loProvinceIDs))]
	end
	
	return nil
end
function P.ProvincesLoop(voProductionData, vbDoCoreLoop)
--Utils.LUA_DEBUGOUT("ProvincesLoop")
	local loProvinces = {
		CoreProvinceIDs = {},
		Provinces = {},
		Buildings = {
			coastal_fort = {
				Que = 0,	-- How many in the production Que
				Count = 0,	-- How many total do we have
				OBJ = CBuildingDataBase.GetBuilding("coastal_fort") 
			},
			land_fort = {
				Que = 0,
				Count = 0, 
				OBJ = CBuildingDataBase.GetBuilding("coastal_fort") 
			},
			anti_air = {
				Que = 0,
				Count = 0, 
				OBJ = CBuildingDataBase.GetBuilding("coastal_fort") 
			},
			industry = {
				Que = 0,
				Count = 0,
				OBJ = CBuildingDataBase.GetBuilding("industry" )
			},
			radar_station = {
				Que = 0,
				Count = 0,
				OBJ = CBuildingDataBase.GetBuilding("radar_station" )
			},
			nuclear_reactor = {
				Que = 0,
			 	Count = 0,
				OBJ = CBuildingDataBase.GetBuilding("nuclear_reactor" )
			},
			rocket_test = {
				Que = 0,
				Count = 0,
				OBJ = CBuildingDataBase.GetBuilding("rocket_test" )
			},
			infra = { 
				Que = 0,
				Count = 0,
				OBJ = CBuildingDataBase.GetBuilding("infra")
			},
			air_base = {
				Que = 0,
				Count = 0,
				OBJ = CBuildingDataBase.GetBuilding("air_base")
			},
			naval_base = {
				Que = 0,
				Count = 0,
				OBJ = CBuildingDataBase.GetBuilding("naval_base")
			},
			underground = {
				Que = 0,
				Count = 0,
				OBJ = CBuildingDataBase.GetBuilding("underground")
			}
		}
	}
	
	-- Loop through CORE Provinces
	if vbDoCoreLoop then
		--Utils.LUA_DEBUGOUT("COUNTRY_Loop: " .. tostring(voProductionData.tag) )
		for liProvinceId in voProductionData.Country:GetCoreProvinces() do
			local loProvince = CCurrentGameState.GetProvince(liProvinceId)
			
			if voProductionData.Tag == loProvince:GetOwner() then
				table.insert(loProvinces.CoreProvinceIDs, liProvinceId)
			end
		end
	end
	
	-- Set the IDs so they can be indexed
	loProvinces.CoreProvinceIDs = Utils.Set(loProvinces.CoreProvinceIDs)
	
	for liProvinceId in voProductionData.Country:GetControlledProvinces() do
		local loProvince = {
			ID = liProvinceId,
			Province = nil,
			Infra = nil,
			InfraSize = nil,
			IsCore = false,
			IsFrontProvince = false,
			IsCapital = (voProductionData.CapitalPrvID == liProvinceId),
			Continent = nil,
			ContinentName = nil,
			Buildings = {}
		}
		--Utils.LUA_DEBUGOUT("COUNTRY_LoopB: " .. tostring(voProductionData.tag) )
		loProvince.Province = CCurrentGameState.GetProvince(liProvinceId)
		loProvince.Infra = loProvince.Province:GetBuilding(loProvinces.Buildings.infra.OBJ)
		loProvince.InfraSize = loProvince.Infra:GetMax():Get()
	
		if loProvince.InfraSize > 1 then
			if voProductionData.Tag == loProvince.Province:GetOwner() then
				loProvince.Continent = loProvince.Province:GetContinent()
				loProvince.ContinentName = tostring(loProvince.Continent:GetTag())
				loProvince.IsFrontProvince = loProvince.Province:IsFrontProvince(false)
				
				-- Check to see if it is present in the core province list
				if loProvinces.CoreProvinceIDs[liProvinceId] then
					loProvince.IsCore = true
				end
				
				-- Continue
				for k, v in pairs(loProvinces.Buildings) do
					local loBuilding = {
						Type = k,
						BuildingOBJ = nil,
						CurrentlyBuilding = 0,
						CurrentSize = 0
					}
					
					-- Is the building currently being built in the province
					loBuilding.CurrentlyBuilding = loProvince.Province:GetCurrentConstructionLevel(loProvinces.Buildings[k].OBJ)
					loBuilding.BuildingOBJ = loProvince.Province:GetBuilding(loProvinces.Buildings[k].OBJ)
					loBuilding.CurrentSize = loBuilding.CurrentlyBuilding + loBuilding.BuildingOBJ:GetMax():Get()
					loProvinces.Buildings[k].Que = loProvinces.Buildings[k].Que + loBuilding.CurrentlyBuilding
					loProvinces.Buildings[k].Count = loProvinces.Buildings[k].Count + loBuilding.CurrentSize + loBuilding.CurrentlyBuilding
					
					-- Create the building within the province
					loProvince.Buildings[k] = loBuilding
				end
				
				-- Move the Province into the main array
				loProvinces.Provinces[liProvinceId] = loProvince
			end
		end
	end

	return loProvinces
end
function P.CalculateExpenseResourceFactor(voCountry)
--Utils.LUA_DEBUGOUT("CalculateExpenseResourceFactor")
	local loEnergy = CResourceValues()
	local loMetal = CResourceValues()
	local loRare = CResourceValues()
	local loOil = CResourceValues()
	
	loEnergy:GetResourceValues( voCountry, CGoodsPool._ENERGY_ )
	loMetal:GetResourceValues( voCountry, CGoodsPool._METAL_ )
	loRare:GetResourceValues( voCountry, CGoodsPool._RARE_MATERIALS_ )
	loOil:GetResourceValues( voCountry, CGoodsPool._CRUDE_OIL_ )
	
	local liExpenseFactor = loEnergy.vDailyExpense * 0.5
	liExpenseFactor = liExpenseFactor + loMetal.vDailyExpense
	liExpenseFactor = liExpenseFactor + (loRare.vDailyExpense * 2)
	
	local liHomeFactor = Support_Trade.CalculateHomeProduced(loEnergy) * 0.5
	liHomeFactor = liHomeFactor + Support_Trade.CalculateHomeProduced(loMetal)
	liHomeFactor = liHomeFactor + (Support_Trade.CalculateHomeProduced(loRare) * 2)
	
	-- Only count oil if we are in the positive, if not then ignore it
	local liOilFactor = Support_Trade.CalculateHomeProduced(loOil)
	if liOilFactor > 0 then
		liHomeFactor = liHomeFactor + (liOilFactor * 3)
	end
	
	return liExpenseFactor, liHomeFactor
end

-- ###################################
-- # Support Methods called by Country files
-- #####################################
function P.Build_RocketTest(...)
--Utils.LUA_DEBUGOUT("Build_RocketTest")
	return P.Build_Building("rocket_test", ...)
end

function P.Build_Radar(...)
--Utils.LUA_DEBUGOUT("Build_Radar")
	return P.Build_Building("radar_station", ...)
end

function P.Build_Fort(...)
--Utils.LUA_DEBUGOUT("Build_Fort")
	return P.Build_Building("land_fort", ...)
end
		
function P.Build_CoastalFort(...)
--Utils.LUA_DEBUGOUT("Build_CoastalFort")
	return P.Build_Building("coastal_fort", ...)
end

function P.Build_AntiAir(...)
--Utils.LUA_DEBUGOUT("Build_AntiAir")
	return P.Build_Building("anti_air", ...)
end

function P.Build_Industry(...)
--Utils.LUA_DEBUGOUT("Build_Industry")
	return P.Build_Building("industry", ...)
end

function P.Build_Infrastructure(...)
--Utils.LUA_DEBUGOUT("Build_Infrastructure")
	return P.Build_Building("infrastructure", ...)
end

function P.Build_AirBase(...)
--Utils.LUA_DEBUGOUT("Build_AirBase")
	return P.Build_Building("air_base", ...)
end

function P.Build_NavalBase(...)
--Utils.LUA_DEBUGOUT("Build_NavalBase")
	return P.Build_Building("naval_base", ...)
end

function P.Build_NuclearReactor(...)
--Utils.LUA_DEBUGOUT("Build_NuclearReactor")
	return P.Build_Building("nuclear_reactor", ...)
end

-- Handles the creating of the building, this can be called directly
function P.Build_Building(vsBuildingType, viIC, voProductionData, viProvinceID, viMax)
--Utils.LUA_DEBUGOUT("Build_Building")
	if viIC > 0.1 then
		--Utils.LUA_DEBUGOUT("COUNTRY_build building: " .. tostring(voProductionData.tag) )
		local loProvince = CCurrentGameState.GetProvince(viProvinceID)
		local lbHasControl = (loProvince:GetController() == voProductionData.Tag)
	
		if lbHasControl then
			local loBuildingType = CBuildingDataBase.GetBuilding(vsBuildingType)
			local loBuilding = loProvince:GetBuilding(loBuildingType)

			if loBuilding:GetMax():Get() < viMax and loProvince:GetCurrentConstructionLevel(loBuildingType) == 0 then
				local loBuildingCost = voProductionData.Country:GetBuildCost(loBuildingType):Get()
				
				if viIC > 0.1 then
					local loCommand = CConstructBuildingCommand(voProductionData.Tag, loBuildingType , viProvinceID, 1)
					
					if loCommand:IsValid() then
						voProductionData.ministerAI:Post(loCommand)
						viIC = viIC - loBuildingCost -- Update IC total
					end
				end
			end
		end
	end
	
	return viIC
end


return Prod_Buildings