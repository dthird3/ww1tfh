-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production Sea File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/13/2013
-----------------------------------------------------------

local P = {}
Prod_Sea = P

function P.Build(voProductionData, viIC)
--Utils.LUA_DEBUGOUT("seabuild")
	local SeaObj = {
		Ratio = Support_Country.Call_Function(voProductionData, "NavalRatio", voProductionData),
		ActualRatio = {},
		Multiplier = 0,
		Transport = {
			Ratio = Support_Country.Call_Function(voProductionData, "TransportLandRatio", voProductionData),
		}
	}

	local lbExit = false
	while not(lbExit) do
		local liStartIC = viIC
		
		voProductionData, SeaObj = Prod_Units.StandardProdRatio(voProductionData, SeaObj)

		-- Prevent Divide by 0 error in case of no land units
		if voProductionData.Units.Counts.Land > 0 then
			-- Transport Ships
			if SeaObj.Transport.Ratio[2] > 0 then
				local lsUnitType = Prod_Units.GetHighestUnit(voProductionData, "Transport")

				if lsUnitType ~= nil then
					voProductionData.Units[lsUnitType].Need  = math.ceil((voProductionData.Units.Counts.Land / SeaObj.Transport.Ratio[1]) * SeaObj.Transport.Ratio[2]) - voProductionData.Units[lsUnitType].Total
					SeaObj.ActualRatio[lsUnitType] = 0
				end
			end

			-- Invasion Craft
			if SeaObj.Transport.Ratio[3] > 0 then
				local lsUnitType = Prod_Units.GetHighestUnit(voProductionData, "Invasion")

				if lsUnitType ~= nil then
					voProductionData.Units[lsUnitType].Need = math.ceil((voProductionData.Units.Counts.Land / SeaObj.Transport.Ratio[1]) * SeaObj.Transport.Ratio[3]) - voProductionData.Units[lsUnitType].Total
					SeaObj.ActualRatio[lsUnitType] = 0
				end
			end
		end

		local liCAGsNeeded = voProductionData.Units["escort_carrier"].Total
		local liCAGsCount = voProductionData.Units["cag"].Total

		-- Add full carriers to the count
		liCAGsNeeded = liCAGsNeeded + ((UnitTypes["carrier"].SubQuantity + voProductionData.Carrier.Size) * voProductionData.Units["carrier"].Total)
		
		if liCAGsNeeded > liCAGsCount then
			voProductionData.Units["cag"].Need = liCAGsNeeded - liCAGsCount
			-- Give it a ratio of 1 so the AI will push them to be built first
			SeaObj.ActualRatio["cag"] = 0
		end

		local liNewICCount
		voProductionData, liNewICCount = Prod_Units.ProcessUnits(voProductionData, viIC, SeaObj.ActualRatio)
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
--Utils.LUA_DEBUGOUT("seaRatioGenerator")
	-- These ratios are Germanies base which is good for majority of countries
	local laUnits = {
		chk1 = { unit = "coastal_submarine", tech = "submarine_technology", ratio = 1 },
		chk1 = { unit = "submarine", tech = "mediumsubmarine_technology", ratio = 2 },
		chk1 = { unit = "longrange_submarine", tech = "longrangesubmarine_technology", ratio = 1 },
		chk2 = { unit = "destroyer", tech = "destroyer_technology", ratio = 3 },
		chk3 = { unit = "protected_cruiser", tech = "protectedcruiser_technology", ratio = 0 },
		chk4 = { unit = "light_cruiser", tech = "lightcruiser_technology", ratio = 2 },
		chk5 = { unit = "heavy_cruiser", tech = "heavycruiser_technology", ratio = 0.5 },
		chk6 = { unit = "battlecruiser", tech = "battlecruiser_technology", ratio = 0 },
		chk7 = { unit = "battleship", tech = "battleship_technology", ratio = 0.0 },
		chk7 = { unit = "dreadnaught", tech = "super_heavy_battleship_technology", ratio = 2 },
		chk8 = { unit = "escort_carrier", tech = "escort_carrier_technology", ratio = 0.25 },
		chk9 = { unit = "carrier", tech = "carrier_technology", ratio = 0.1 }
	}

	local laRatios = {}

	for x, y in pairs(laUnits) do
		if y.active then
			laRatios[y.unit] = y.ratio
		elseif y.tech then
			-- Is it on my prefer list?
			if voProductionData.TechList[y.tech] then
				-- Make sure its not on my ignore list
				if not(voProductionData.TechList[y.tech].Ignore) then
					laRatios[y.unit] = y.ratio
				end
			end
		end
	end

	return laRatios
end

return Prod_Sea