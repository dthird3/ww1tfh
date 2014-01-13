-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production Air File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/13/2013
-----------------------------------------------------------

local P = {}
Prod_Air = P

function P.Build(voProductionData, viIC)
--Utils.LUA_DEBUGOUT("airBuild")
	local AirObj = {
		Ratio = Support_Country.Call_Function(voProductionData, "AirRatio", voProductionData),
		ActualRatio = {},
		Multiplier = 0,
		Rocket = {
			Ratio = Support_Country.Call_Function(voProductionData, "RocketRatio", voProductionData),
		}
	}
	
	local lbExit = false
	while not(lbExit) do
		local liStartIC = viIC

		voProductionData, AirObj = Prod_Units.StandardProdRatio(voProductionData, AirObj)

		-- Do we need Air Transports
		--if voProductionData.Units.Counts.Para > 0 then
			--local liTotalAirTrans = voProductionData.Units["transport_plane"].Total
			--local liTotalAirTransNeeded = math.floor(voProductionData.Units.Counts.Para / 3)
			
			--if liTotalAirTransNeeded > liTotalAirTrans then
				--voProductionData.Units["transport_plane"].Need = liTotalAirTransNeeded - liTotalAirTrans
				--AirObj.ActualRatio["transport_plane"] = -1000
			--end
		--end

		-- Does the country have a Secret Ratio
		--if AirObj.Rocket.Ratio[1] > 0 then
			--local liSNeeded = math.max(0, math.ceil((voProductionData.Units.Counts.Air / AirObj.Rocket.Ratio[1]) * AirObj.Rocket.Ratio[2]) - voProductionData.Units.Counts.Secret)
			
			-- Do they need any
			--if liSNeeded > 0 then
				--local lsUnitType = Prod_Units.GetHighestUnit(voProductionData, "Secret")
				
				--if lsUnitType ~= nil then
					-- Pick a secret weapon randomly
					--voProductionData.Units[lsUnitType].Need = liSNeeded
					--AirObj.ActualRatio[lsUnitType] = 1
				--end
			--end
		--end

		local liNewICCount
		voProductionData, liNewICCount = Prod_Units.ProcessUnits(voProductionData, viIC, AirObj.ActualRatio)
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
--Utils.LUA_DEBUGOUT("airRatioGenerator")
	-- These ratios are Germanies base which is good for majority of countries
	local laUnits = {
		interceptor = { tech = "single_engine_aircraft_design", ratio = 5 },
		scout = { tech = "military_aircraft_design", ratio = 3 },
		tactical_bomber = { tech = "twin_engine_aircraft_design", ratio = 4 },
		airship = { tech = "airship_development", ratio = 1 }
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

return Prod_Air