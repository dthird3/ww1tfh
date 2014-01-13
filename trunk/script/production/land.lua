-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production Land File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/13/2013
-----------------------------------------------------------

local P = {}
Prod_Land = P

function P.Build(voProductionData, viIC)
--Utils.LUA_DEBUGOUT("landBuild")
	local LandObj = {
		Ratio = Prod_Units.IsUnitsAvailable(voProductionData, Support_Country.Call_Function(voProductionData, "LandRatio", voProductionData)),
		ActualRatio = {},
		Multiplier = 0,
		Special = {
			Needed = 0,
			Distribution = nil,
			Ratio = nil,
			ActualRatio = {},
			Multiplier = 0
		}
	}
	
	LandObj.Special.Distribution, LandObj.Special.Ratio = Support_Country.Call_Function(voProductionData, "SpecialForcesRatio", voProductionData)

	local lbExit = false
	while not(lbExit) do
		local liStartIC = viIC

		voProductionData, LandObj = Prod_Units.StandardProdRatio(voProductionData, LandObj)

		-- Special Forces
		if LandObj.Special.Ratio ~= nil and LandObj.Special.Distribution[2] > 0 then
			LandObj.Special.Needed = math.max(0, math.ceil((voProductionData.Units.Counts.Land / LandObj.Special.Distribution[1]) * LandObj.Special.Distribution[2]) - voProductionData.Units.Counts.Special)

			-- Do we need special forces
			if LandObj.Special.Needed > 0 then
				voProductionData, LandObj.Special = Prod_Units.StandardProdRatio(voProductionData, LandObj.Special)

				-- Modify the counts based on the max amount allowed
				voProductionData = P.ModifyUnitNeeds(voProductionData, LandObj.Special.ActualRatio, LandObj.Special.Needed)
			end	
		end
		
		local liNewICCount
		voProductionData, liNewICCount = Prod_Units.ProcessUnits(voProductionData, viIC, LandObj.Special.ActualRatio)
		voProductionData, liNewICCount = Prod_Units.ProcessUnits(voProductionData, liNewICCount, LandObj.ActualRatio)
		voProductionData.IC.Available = voProductionData.IC.Available - (viIC - liNewICCount)
		viIC = liNewICCount

		-- Check to see if we used all our IC up
		if liStartIC == viIC or viIC < 0.1 then
			lbExit = true
		end
	end

	return voProductionData
end

function P.RatioGenerator(voProductionData)
--Utils.LUA_DEBUGOUT("landRatioGenerator")
	-- These ratios are Germanies base which is good for majority of countries
	local laUnits = {
		militia_brigade = { active = true, ratio = 0 },
		garrison_brigade = { active = true, ratio = 0 },
		infantry_brigade = { tech = "infantry_activation", ratio = 20 },
		light_armor_brigade = { tech = "lighttank_brigade", ratio = 1 },
		armor_brigade = { tech = "tank_brigade", ratio = 1 }
	}

	local laRatios = {}

	for x, y in pairs(laUnits) do
		if y.active then
			laRatios[x] = y.ratio
		elseif y.tech then
			-- Is it on my prefer list?
			if voProductionData.TechList[y.tech] then
				-- Make sure its not on my ignore list
				if not(voProductionData.TechList[y.tech].Ignore) then
					laRatios[x] = y.ratio
				end
			end
		end
	end

	return laRatios
end

function P.ModifyUnitNeeds(voProductionData, vaUnitRatio, viUnitNeeds)
--Utils.LUA_DEBUGOUT("landModifyUnitNeeds")
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

		-- Subtract from the special forces till it = 0
		if voProductionData.Units[lsLowestUnit].Need > viUnitNeeds then
			voProductionData.Units[lsLowestUnit].Need = viUnitNeeds
			viUnitNeeds = 0;
		else
			viUnitNeeds = viUnitNeeds - voProductionData.Units[lsLowestUnit].Need;
		end
		
		liLowestValue = -1
	end

	return voProductionData
end

function P.RatioReplace(vaArray, vsUnit, viRatio)
--Utils.LUA_DEBUGOUT("landRatioReplace")
	if vaArray[vsUnit] then
		vaArray[vsUnit] = viRatio
	end

	return vaArray
end

return Prod_Land