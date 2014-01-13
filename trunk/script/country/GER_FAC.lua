-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany Fascist File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/13/2013
-----------------------------------------------------------

local P = {}
AI_GER_FAC = P

-- #######################################
-- TRADE Weights
-- Uses German Default file GER.lua

-- #######################################
-- AI Sliders
function P.Prod_LendLease(voProdSliders)
	-- If we have more than 250 IC then sure to Lend Lease
	if voProdSliders.IcOBJ.IC > 150 then
		return false, 0.10
	end
	
	return false, 0.0
end
function P.LendLease_Distribution(voLeaseSliderData)
	local loCountries = {
		AUH = { MinPercentage = 0.40 },
		TUR = { MinPercentage = 0.10 }
	}
	
	for k, v in pairs(voLeaseSliderData.Countries) do
		if loCountries[v.Name] then
			if v.Percentage < loCountries[v.Name].MinPercentage then
				voLeaseSliderData.DiviserCount = voLeaseSliderData.DiviserCount - 1
				v.ModPercentage = loCountries[v.Name].MinPercentage
				v.Locked = true
			end
		end
	end
	
	return voLeaseSliderData
end

-- #######################################
-- TRADE
function P.TradeData_Init(voTradeData)
	return P.Setup_Custom(voTradeData.Country)
end
function P.TradeData_Trade(voTradeData, voTradeCountry)
	local lbProcess = true
	
	if voTradeData.Custom.AllyWar then
		-- We are not Neighbors
		if not(voTradeData.Country:IsNonExileNeighbour(voTradeCountry.Tag)) then
			local loContinent = {
				europe = {},
				scandinavia = {}
			}
			
			local lsContinent = tostring(voTradeCountry.Country:GetActingCapitalLocation():GetContinent():GetTag())
			
			-- Check if on same Continent
			if not(loContinent[lsContinent]) then
				lbProcess = false -- Do not process this country
			end
		end
	end
	
	return lbProcess
end

-- #######################################
-- CANCEL TRADE
function P.TradeData_Cancel_Init(voCTradeData)
	return P.Setup_Custom(voCTradeData.Country)
end
function P.TradeData_Cancel(voCTradeData, voTradeCountry)
	local lbProcess = true
	
	if voCTradeData.Custom.AllyWar then
		-- If they are receiving the resource we may need to cancel
		if not(voTradeCountry.IsTradeTo) then
			-- We are not Neighbors
			if not(voCTradeData.Country:IsNonExileNeighbour(voTradeCountry.Tag)) then
				local loContinent = {
					europe = {},
					scandinavia = {}
				}
			
				local lsContinent = tostring(voTradeCountry.Country:GetActingCapitalLocation():GetContinent():GetTag())
				
				-- Check if on same Continent
				if not(loContinent[lsContinent]) then
					local loCommand = CTradeAction(voCTradeData.Tag, voTradeCountry.Tag)
					loCommand:SetRoute(voTradeCountry.TradOBJ)
					loCommand:SetValue(false)
					voCTradeData.ministerAI:PostAction(loCommand)
					lbProcess = false -- Only process if we find nothing to cancel
				end
			end
		end
	end
	
	return lbProcess
end

-- #######################################
-- TECH RESEARCH
-- Uses German Default file GER.lua
function P.TechnologyData_Init(voTechnologyData)
	return P.Setup_Custom(voTechnologyData.Country)
end
function P.TechList(voTechnologyData)
	local loPreferTech = nil

	if voTechnologyData.Custom.SeaLion and not(voTechnologyData.Custom.SovietWar) then
		loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Mixed')
	else
		loPreferTech = Support_Tech.TechGenerator(voTechnologyData, 'Land')
	end

	-- Super High Priority to get regular Tanks fast
	if loPreferTech['tank_brigade'] then
		if loPreferTech['tank_brigade'].Priority > 0 then
			loPreferTech['tank_brigade'].Priority = 1000
		end
	end

	return loPreferTech
end

-- #######################################
-- PRODUCTION Section
-- Uses German Default file GER.lua
function P.ProductionData_Init(voProductionData)
	return P.Setup_Custom(voProductionData.Country)
end
function P.ProductionWeights(voProductionData)
	local laArray = {
		0.65, -- Land
		0.15, -- Air
		0.15, -- Sea
		0.05} -- Other
	
	-- Check to see if manpower is to low
	if voProductionData.Manpower.Total < 100 then
		laArray = {
			0.0, -- Land
			0.50, -- Air
			0.20, -- Sea
			0.30} -- Other
	elseif voProductionData.Year <= 1914 and not(voProductionData.IsAtWar) then
		-- Peacetime Prep for SeaLion
		if voProductionData.Custom.SeaLion then
			laArray = {
				0.60, -- Land
				0.05, -- Air
				0.25, -- Sea
				0.10} -- Other
		else
			laArray = {
				0.47, -- Land
				0.28, -- Air
				0.15, -- Sea
				0.10} -- Other
		end
	
	-- More than 400 brigades so build stuff that does not use manpower
	elseif (voProductionData.Manpower.Total < 200 and voProductionData.Units.Counts.Land > 400) then
		laArray = {
			0.15, -- Land
			0.40, -- Air
			0.20, -- Sea
			0.25} -- Other
			
	-- Sea Lion build lots of navy
	elseif voProductionData.Custom.SeaLion and not(voProductionData.Custom.SovietWar) then
		laArray = {
			0.40, -- Land
			0.25, -- Air
			0.30, -- Sea
			0.05} -- Other

	elseif voProductionData.IsAtWar then
		-- Desperation check and if so heavy production of land forces
		if voProductionData.Country:CalcDesperation():Get() > 0.4 then
			laArray = {
				0.65, -- Land
				0.20, -- Air
				0.10, -- Sea
				0.05} -- Other
				
		-- If the Soviets have Moscow and we are at war
		elseif voProductionData.Custom.SovietWar then
			if (CCurrentGameState.GetProvince(1409):GetController() == voProductionData.Custom.WarTags['RUS'].Tag) then
				laArray = {
					0.60, -- Land 
					0.23, -- Air
					0.12, -- Sea        
					0.05} -- Other
			end
		end
	end
	
	return laArray
end
function P.TransportLandRatio(voProductionData)
	local laArray
		laArray = {
			250, -- Land
			1, -- Transport
			0.5} -- Invasion
	
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
				Build = (voProductionData.Year > 1937)
			},
			anti_air = {
				Build = (voProductionData.Year > 1937)
			},
			land_fort = {
				PreferMaxLevel = 2,
				MaxRun = 3,
				PreferList = {
					3150, -- Mulhouse
					3083, -- Colmar
					2947, -- selestad
					2815, -- strasburg
					2814, -- schirmeck
					2684, -- sarreguemines
					2618} -- metz
			}
		}
	}
	
	if voProductionData.Year > 1914 then
		loProdBuilding.Buildings.land_fort.MaxRun = 1
	end
	
	return loProdBuilding
end

-- #######################################
-- POLITICS MINISTER
function P.Politics_Mobilization(voPoliticsObject)
	if voPoliticsObject.Year < 1914 then
		Politics_Mobilization.Command_Mobilize(voPoliticsObject.ministerAI, voPoliticsObject.Actor.Tag, true)
		return false
	end
	
	return true
end

-- #######################################
-- FOREIGN MINISTER
function P.ForeignMinister_EvaluateDecision(voDecision)
	local loDecisions = {
		molotov_ribbentrop_pact = {Year = 1939, Month = 7, Day = 5, Score = 100},
		danzig_or_war = {Year = 1939, Month = 8, Day = 0, War = true, Country = "POL", Score = 100 },
		anschluss_of_austria = {Year = 1938, Month = 2, Day = 8, Score = 100 },
		the_treaty_of_munich = {Year = 1938, Month = 8, Day = 8, Score = 100 },
		first_vienna_award = {Year = 1939, Month = 2, Day = 25, Score = 100 }}

	if loDecisions[voDecision.Name] then
		if (voDecision.Year == loDecisions[voDecision.Name].Year
		and voDecision.Month >= loDecisions[voDecision.Name].Month
		and voDecision.Day >= loDecisions[voDecision.Name].Day )
		or
		(voDecision.Year == loDecisions[voDecision.Name].Year
		and voDecision.Month > loDecisions[voDecision.Name].Month)
		or
		(voDecision.Year > loDecisions[voDecision.Name].Year) then
			if loDecisions[voDecision.Name].War then
				ForeignMinister_War.PrepareWarDecision(CCountryDataBase.GetTag(loDecisions[voDecision.Name].Country), voDecision, 100)
			else
				return loDecisions[voDecision.Name].Score
			end
		else
			return 0
		end
	end
	
	return voDecision.Score
end
function P.ForeignMinister_Influence(voForeignMinisterData, voInfluence)
	if voForeignMinisterData.FactionName == "axis" then
		voInfluence.Watch = {
			"TUR", -- Ottoman
			"BUL", -- Bulgaria
			"AUH"};	 -- Hungary
			
		voInfluence.IgnoreWatch = {
			"POR", -- Portugal
			"SWE", -- Sweden
			"CHI", -- China
			"BEL", -- Belgium
			"HOL"} -- Holland
			
		voInfluence.Ignore = {
			"AST", -- Australia
			"CAN", -- Canada
			"SAF", -- South Africa
			"NZL", -- New Zealand
			"AUS", -- Austria
			"CZE", -- Czechoslovakia
			"SCH", -- Switzerland
			"LAT", -- Lativia
			"LIT", -- Lithuania
			"EST", -- Estonia
			"LUX", -- Luxemburg
			"VIC", -- Vichy
			"DEN", -- Denmark
			"POL", -- Poland
			"ETH", -- Ethiopia			
			"CYN", -- Yunnan
			"SIK", -- Sikiang
			"CGX", -- Guangxi Clique
			"CSX", -- Shanxi
			"TIB", -- Tibet
			"AFG", -- Afghanistan
			"CHC"};	-- Communist China
	end
	
	return voInfluence
end
function P.ForeignMinister_CallAlly(voForeignMinisterData)
	-- Make sure Germany is in the Axis and if not let default code run
	if voForeignMinisterData.FactionName ~= "axis" then
		return true
	end
	
	-- Get a list of all your allies
	local laAllies = {}

	for loAllyTag in voForeignMinisterData.Country:GetAllies() do
		local lbLoad = true
		local loAllyCountry = loAllyTag:GetCountry()

		-- Only call our allies and our puppets
		if loAllyCountry:IsPuppet() then
			if loAllyCountry:GetOverlord() ~= voForeignMinisterData.Tag then
				lbLoad = false
			end
		end
		
		if lbLoad then
			local loAlly = {
				Name = tostring(loAllyTag),
				Tag = loAllyTag,
				Country = loAllyCountry,
				Continent = loAllyCountry:GetActingCapitalLocation():GetContinent(),
				Score = DiploScore_CallAlly(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loAllyTag, loAllyTag, nil)
			}

			laAllies[loAlly.Name] = loAlly
		end
	end

	
	-- Go through our Wars
	for loTargetTag in voForeignMinisterData.Country:GetCurrentAtWarWith() do
		if loTargetTag:IsValid() then
			local lsTargetTag = tostring(loTargetTag)
			
			-- Call in all potential allies
			for k, v in pairs(laAllies) do
				-- Check to see if the two are already at war?
				if not(v.Country:GetRelation(loTargetTag):HasWar()) then
					-- We are desperate so call everyone
					ForeignMinister_CallAlly.Execute_CallAlly(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, v.Tag, loTargetTag)
				end
			end
		end
	end
	
	return false
end
function P.ForeignMinister_MilitaryAccess(voForeignMinisterData)
	
	return true
end
--function P.ForeignMinister_ProposeWar(voForeignMinisterData)

--end

-- #######################################
-- DIPLOMACY SCORE GENERATION
function P.DiploScore_Alliance(voDiploScoreObj)
	local loScoreCheck = {
		RUS = { Score = 100, Flag = "unholy_alliance" }
	}	
	
	if loScoreCheck[voDiploScoreObj.Actor.Name] then
		if loScoreCheck[voDiploScoreObj.Actor.Name].Flag then
			if voDiploScoreObj.Target.Country:GetFlags():IsFlagSet(loScoreCheck[voDiploScoreObj.Actor.Name].Flag) then
				voDiploScoreObj.Score = loScoreCheck[voDiploScoreObj.Actor.Name].Score
			end
		end
	end

	return voDiploScoreObj.Score
end
function P.DiploScore_InfluenceNation(voDiploScoreObj)
	-- Only do this if we are in the axis
	if voDiploScoreObj.Actor.FactionName == "axis" then
		local loInfluences = {
			TUR = {Score = 500},
			AUH = {Score = 500},
			BUL = {Score = 200, Province = 4058, Year = 1915}}
	
		-- Are they on our list
		if loInfluences[voDiploScoreObj.Target.Name] then
			if loInfluences[voDiploScoreObj.Target.Name].Province then
				if loInfluences[voDiploScoreObj.Target.Name].Year <= voDiploScoreObj.Year then
					if CCurrentGameState.GetProvince(loInfluences[voDiploScoreObj.Target.Name].Province):GetOwner() ~= voDiploScoreObj.Target.Tag then
						return 0 -- No need to influence, assume they will align
					end
				end
			end
			
			return (voDiploScoreObj.Score + loInfluences[voDiploScoreObj.Target.Name].Score)
		end
	end

	return voDiploScoreObj.Score
end
function P.DiploScore_OfferTrade(voDiploScoreObj)
	local laTrade = {
		RUS = {Score = 50},
		SWE = {Score = 100},
		ITA = {Score = 200},
		HOL = {Score = 200},
		TUR = {Score = 50},
		FIN = {Score = 100},
		BUL = {Score = 100},
		ROM = {Score = 100},
		HUN = {Score = 100},
		VIC = {Score = 50},
		SPA = {Score = 50},
		SPR = {Score = 50},
		ENG = {Score = -20},
		FRA = {Score = -20},
		POR = {Score = 30}}
	
	local loCustom = P.Setup_Custom(voDiploScoreObj.Target.Country)
	
	if voDiploScoreObj.IsActorBuyer then
		if laTrade[voDiploScoreObj.Actor.Name] then
			voDiploScoreObj.Score = voDiploScoreObj.Score + laTrade[voDiploScoreObj.Actor.Name].Score
		end
	else
		local loContinent = {
			europe = {},
			scandinavia = {}
		}
	
		local lsContinent = tostring(voDiploScoreObj.Actor.Continent:GetTag())
				
		if loCustom.AllyWar
		and not(loContinent[lsContinent]) 
		and not(voDiploScoreObj.IsNeighbor) then
			voDiploScoreObj.Score = 0
		else
			if laTrade[voDiploScoreObj.Actor.Name] then
				voDiploScoreObj.Score = voDiploScoreObj.Score + laTrade[voDiploScoreObj.Actor.Name].Score
			end
		end
	end
	
	return voDiploScoreObj.Score
end
function P.DiploScore_RequestLendLease(voDiploScoreObj)
	if voDiploScoreObj.Target.FactionName == "axis" then
		local laContinents = {
			europe = {},
			scandinavia = {},
			british_isle = {}}	

		local lsContinent = tostring(voDiploScoreObj.Actor.Country:GetActingCapitalLocation():GetContinent():GetTag())

		-- Only give LL to countries in the continents on our list
		if not(laContinents[lsContinent]) then
			return 0
		end
	end
	
	return voDiploScoreObj.Score
end
function P.DiploScore_Embargo(voDiploScoreObj)
	-- Never Embargo the Soviets
	if voDiploScoreObj.Actor.FactionName == "axis" then
		if voDiploScoreObj.Target.Name == "RUS" then
			voDiploScoreObj.Score = 0
		end
	end
	
	return voDiploScoreObj.Score
end

-- #######################################
-- SUPPORT METHODS
function P.Setup_Custom(voCountry)
	local loCustom = {
		AllyWar = false,
		SovietWar = false,
		UnknownWar = false,
		SeaLion = false,
		IsAtWar = voCountry:IsAtWar(),
		WarTags = {}
	}

	local loPCountries  = {
		USA = { AllyWar = true },
		ENG = { AllyWar = true },
		FRA = { AllyWar = true },
		RUS = { SovietWar = true }
	}
	
	if loCustom.IsAtWar then
		for loTargetTag in voCountry:GetCurrentAtWarWith() do
			if loTargetTag:IsReal() then
				if loTargetTag:IsValid() then
					local lsTargetTag = tostring(loTargetTag)
					loCustom.WarTags[lsTargetTag] = {
						Tag = loTargetTag
					}
					
					if loPCountries[lsTargetTag] then
						if loPCountries[lsTargetTag].AllyWar then
							loCustom.AllyWar = true
						elseif loPCountries[lsTargetTag].SovietWar then
							loCustom.SOV.Tag = loTargetTag
							loCustom.SovietWar = true
						end
					else
						loCustom.UnknownWar = true
					end
				end
			end
		end
	end

	-- If we are not at war with the Soviets see if we should load up Sea Lion AI
	if not(loCustom.SovietWar) then
		if voCountry:GetFlags():IsFlagSet("ai_sea_lion") then
			loCustom.SeaLion = true
		elseif voCountry:GetFlags():IsFlagSet("su_signs_peace") then
			loCustom.SeaLion = true
		else
			local loSOV = {
				Tag,
				Relation
			}

			loSOV.Tag = CCountryDataBase.GetTag("RUS")
			loSOV.Relation = voCountry:GetRelation(loSOV.Tag)

			if loSOV.Relation:HasAlliance() then
				loCustom.SeaLion = true
			end
		end
	end
	
	return loCustom
end


return AI_GER_FAC
