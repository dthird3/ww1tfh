-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany Default File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------

local P = {}
AI_AUH = P

-- #######################################
-- TRADE Weights
function P.TradeWeights(voResourceData)
	local laResouces = {
	
		METAL = {
			Buffer = 3, 			-- Amount extra to keep abouve our needs
			BufferSaleCap = 50000, 	-- Amount we need in reserve before we sell the resource
			BufferBuyCap = 40000, 	-- Amount we need before we stop actively buying (existing trades are NOT cancelled)
			BufferCancelCap = 45000 -- Amount we need before we cancel trades simply because we have to much
		},
		RARE_MATERIALS = {
			Buffer = 5,
			BufferSaleCap = 95000,
			BufferBuyCap = 80000,
			BufferCancelCap = 90000},
		CRUDE_OIL = {
			Buffer = 1,
			BufferSaleCap = 40000},
		FUEL = {
			Buffer = 8,
			BufferSaleCap = 90000}}
	
	return laResouces
end

-- #######################################
-- TECH RESEARCH
function P.TechList(voTechnologyData)
	local loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Land')

	return loPreferTech
end

-- #######################################
-- PRODUCTION Section

function P.SliderWeights(voProdSliders)
		--PriorityOrder = {
			--[0] = { 'Consumer', 'Supply', 'LendLease', 'Reinforce', 'Production', 'Upgrade' },
			--[1] = { 'Consumer', 'Supply', 'LendLease', 'Production', 'Reinforce', 'Upgrade' },
			--[2] = { 'Consumer', 'Supply', 'LendLease', 'Upgrade', 'Reinforce', 'Production' },
			--[3] = { 'Consumer', 'Supply', 'LendLease', 'Reinforce', 'Upgrade', 'Production' },
			--[4] = { 'Consumer', 'Reinforce', 'Supply', 'LendLease', 'Production', 'Upgrade' }
		--},
	
	local laSliders = voProdSliders.PrioSelected.Ori

	if voProdSliders.HasReinforceBonus then
		laSliders = 4
	elseif voProdSliders.Year >= 1914 or voProdSliders.IsAtWar or ( voProdSliders.Year == 1913 and voProdSliders.Month >= 7 ) then
		laSliders = 0
	else
		laSliders = 1
	end

	return laSliders 
end


function P.ProductionWeights(voProductionData)
	local laArray = {
		0.65, -- Land
		0.10, -- Air
		0.05, -- Sea
		0.20} -- Other
	if voProductionData.IsAtWar then
		laArray = {
			0.80, -- Land
			0.10, -- Air
			0.05, -- Sea
			0.05} -- Other
	end
		
	-- Check to see if manpower is to low
	-- More than 20 brigades build stuff that does not use manpower
	if (voProductionData.Manpower.Total < 500 and voProductionData.Units.Counts.Land > 100)
	or voProductionData.Manpower.Total < 300 then
		laArray = {
			0.05, -- Land
			0.50, -- Air
			0.10, -- Sea
			0.35} -- Other	
	end
	
	return laArray
end
function P.SpecialForcesRatio(voProductionData)
	local laRatio = {
			35, -- Land
			1} -- Special Force Unit

	local laUnits = { bergsjaeger_brigade = 3 }
	
	return laRatio, laUnits
end
function P.EliteUnits(voProductionData)
	local laUnits = {
		"austrian_brigade"}
	
	return laUnits	
end
function P.FirePower(voProductionData)
	local laArray = {
		"austrian_brigade",
		"armor_brigade"}
		
	return laArray
end
function P.NavalRatio(voProductionData)
	local laArray = Prod_Sea.RatioGenerator(voProductionData)
	laArray = Prod_Land.RatioReplace(laArray, "submarine", 6)

	return laArray
end
function P.TransportLandRatio(voProductionData)
--Utils.LUA_DEBUGOUT("Default_mixed" .. "TransportLandRatio")
	local laArray = {
		100, -- Land
		1,  -- transport
		0}  -- invasion craft

  
	return laArray
end
function P.ConvoyRatio(voProductionData)
	local laArray = {
		0, -- Percentage extra (adds to 100 percent so if you put 10 it will make it 110% of needed amount)
		0, -- If Percentage extra is less than this it will force it up to the amount entered
		30, -- If Percentage extra is greater than this it will force it down to this
		50} -- Escort to Convoy Ratio (Number indicates how many convoys needed to build 1 escort)
  
	return laArray
end
function P.Buildings(voProductionData)
	local loProdBuilding = {
		Buildings = {
			coastal_fort = {
				Build = (voProductionData.Year > 1938)
			},
			industry = {
				Build = (voProductionData.Year > 1940)
			},
			infra = {
				Build = (voProductionData.Year > 1937)
			},
			naval_base = {
				Build = (voProductionData.Year > 1940)
			},
			air_base = {
				PreferMaxLevel = 2,
				MaxRun = 3,
				PreferList = {
					2445, -- Krakow
					2562, -- Praha
					2636, -- Przemysl
					2769, -- Stanislawow
					3027, -- Bratislava
					4236, -- Split
					3026, -- Wien
					3289, -- Innsbruck
					3904} -- Pola
			},
			anti_air = {
				Build = (voProductionData.Year > 1937)
			},
			land_fort = {
				Build = (voProductionData.Year > 1937)
			}
		}
	}
	
	if voProductionData.Year > 1914 then
		loProdBuilding.Buildings.land_fort.MaxRun = 1
	end
	
	return loProdBuilding
end

function P.ForeignMinister_ProposeWar(voForeignMinisterData)
	if not(voForeignMinisterData.Strategy:IsPreparingWar()) then
		if voForeignMinisterData.FactionName == "axis" then
			local lsMinisterCapital = voForeignMinisterData.Country:GetActingCapitalLocation():GetContinent():GetTag()
		
			-- Generic DOW for countries not part of the same faction
			if not(voForeignMinisterData.IsAtWar) and lsMinisterCapital == "europe" then
				for loDiploStatus in voForeignMinisterData.Country:GetDiplomacy() do
					local loTargetTag = loDiploStatus:GetTarget()

					if loTargetTag:IsValid() then
						local loTargetCountry = loTargetTag:GetCountry()
						local lsTargetContinent = tostring(loTargetCountry:GetActingCapitalLocation():GetContinent():GetTag())
						
						-- Limit DOWs to the same continent as the UKs capital
						if lsTargetContinent == "scandinavia"
						or lsTargetContinent == "europe"
						or lsTargetContinent == "british_isle" then
							if loDiploStatus:GetThreat():Get() > voForeignMinisterData.Country:GetMaxNeutralityForWarWith(loTargetTag):Get() then
								if Support_Functions.GoodToWarCheck(loTargetTag, loTargetCountry, voForeignMinisterData, true, false, false, false) then
									ForeignMinister_War.PrepareWar(loTargetTag, voForeignMinisterData.Country, voForeignMinisterData.Strategy, 100)
								end
							end
						end
					end
				end
			end

			-- Special Checks Start after this point
			-- Normal DOW checks
			-- Seperate Watch for Italy

			local loITATag = CCountryDataBase.GetTag("ITA")
			local loItalyCountry = loITATag:GetCountry()

			if not(voDiploScoreObj.Faction == loItalyCountry:GetFaction()) and voDiploScoreObj.Year > 1914 then
				loWarTag = loITATag
			end

			-- Do we have a DOW?
			if loWarTag ~= nil then
				ForeignMinister_War.PrepareWar(loWarTag, voForeignMinisterData.Country, voForeignMinisterData.Strategy, 100)
			end			
		end
	end
end

-- #######################################
-- SUPPORT METHODS
-- Setup_Custom is called from GER_FAC.lua and GER.lua

return AI_AUH
