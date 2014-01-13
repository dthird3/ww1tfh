-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production Convoy File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/13/2013
-----------------------------------------------------------

local P = {}
Prod_Convoy = P

function P.ConstructConvoys(voProductionData, viIC)
--Utils.LUA_DEBUGOUT("ConstructConvoys")
	-- Puppets can only trade with their Overlord
	if voProductionData.IsPuppet then
		local loOverlordTag = voProductionData.Country:GetOverlord()
		
		-- We are neighbours with our Overlord so exit out
		if voProductionData.Country:IsNonExileNeighbour(loOverlordTag) then
			return voProductionData
			
		-- Check Continent (done this way for performance)
		else
			local loOverlordCountry = loOverlordTag:GetCountry()
			local lsOverlordContinent = tostring(loOverlordCountry:GetActingCapitalLocation():GetContinent():GetTag())

			if voProductionData.Continent == lsOverlordContinent then
				return voProductionData
			end
		end
	end

	-- No point in looking in here unless we have a port
	if viIC > 0.1 and voProductionData.PortsTotal > 0 then
		local liOriginalIC = viIC
		local liNeeded = voProductionData.Country:GetTotalNeededConvoyTransports()
		local liCurrent = voProductionData.Country:GetTotalConvoyTransports()
		local liConstruction = voProductionData.minister:CountTransportsUnderConstruction()
		local maxSerial = 5

		-- Grab the Convoy Ratios and Calculate Convoys Needed
		local laConvoyRatio = Support_Country.Call_Function(voProductionData, "ConvoyRatio", voProductionData)
		
		-- Comes back nil means don't build any convoys or escorts
		if laConvoyRatio ~= nil then
			local liNeededMultiplier = ((100 + laConvoyRatio[1]) * .01)
			local liLowCap = laConvoyRatio[2]
			local liHighCap = laConvoyRatio[3]
			local liEscortRatio = laConvoyRatio[4]
			
			local liActuallyNeeded = Utils.Round((((liNeeded * liNeededMultiplier) - liCurrent) - liConstruction ))
			local liLowCapNeeded = (liNeeded - (liCurrent + liConstruction)) + liLowCap
			local liHighCapNeeded = (liNeeded - (liCurrent + liConstruction)) + liHighCap
			
			if liLowCapNeeded > liActuallyNeeded then
				liActuallyNeeded = liLowCapNeeded
			elseif liActuallyNeeded > liHighCapNeeded then
				liActuallyNeeded = liHighCapNeeded
			end
			
			-- If their convoy reserves are to low then build smaller serial runs
			if liActuallyNeeded > 100 then maxSerial = 10 end
			
			if liActuallyNeeded > 0 then
				local liCost = voProductionData.Country:GetConvoyBuildCost():Get()
				local liRequested = math.ceil(liActuallyNeeded / defines.economy.CONVOY_CONSTRUCTION_SIZE)
				viIC = P.BuildTransportOrEscort(voProductionData, liRequested, maxSerial, false, liCost, viIC)
			end

			-- Now Process Escorts Check
			local liENeeded = 0
			-- Seperate line in case of Ratio of 0
			if liEscortRatio > 0 then 
				liENeeded = math.ceil((liNeeded + liLowCap) / liEscortRatio)
			end
			
			local liECurrent = voProductionData.Country:GetEscorts()
			local liEConstruction = voProductionData.minister:CountEscortsUnderConstruction()
			local lEActuallyNeeded = liENeeded - (liECurrent + liEConstruction)

			-- If we need escorts lets build them
			if lEActuallyNeeded > 0 then
				local liCost = voProductionData.Country:GetEscortBuildCost():Get()
				local liRequested = math.ceil(lEActuallyNeeded / defines.economy.CONVOY_CONSTRUCTION_SIZE)
				viIC = P.BuildTransportOrEscort(voProductionData, liRequested, 5, true, liCost, viIC)
			end 
		end

		voProductionData.IC.Allocated = voProductionData.IC.Allocated - (liOriginalIC - viIC)
		voProductionData.IC.Available = voProductionData.IC.Allocated - voProductionData.IC.Used
	end

	return voProductionData
end
--vbConvoyOrEscort = is a boolean (true = escort, false = convoy)
function P.BuildTransportOrEscort(voProductionData, viNeeded, viMaxSerial, vbConvoyOrEscort, viICCost, viIC)
--Utils.LUA_DEBUGOUT("BuildTransportOrEscort")
	while viNeeded > 0 do
		local liSerial = viMaxSerial
		if 	viNeeded < viMaxSerial then liSerial = viNeeded end
		viNeeded = viNeeded - liSerial
		
		if viIC > 0.1 then
			local loCommand = CConstructConvoyCommand(voProductionData.Tag, vbConvoyOrEscort, liSerial)
			voProductionData.ministerAI:Post(loCommand)
			viIC = viIC - viICCost
		end
	end
	
	return viIC
end


return Prod_Convoy