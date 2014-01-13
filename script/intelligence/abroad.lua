-----------------------------------------------------------
-- LUA Hearts of Iron 3 Abroad Spies File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/6/2013
-----------------------------------------------------------
local P = {}
Intelligence_Abroad = P

function P.Spies(voIntelligenceMinisterData)
--Utils.LUA_DEBUGOUT("Spies")
	-- Special Note:
	--    Priority tells the EXE how to spread everything percent based
	--    If you set only 1 mission at priority of 1 it gets 100% (the same as if you set it to 3)
	local AbroadSpy = {
		MaxMissions = 3,
		LeaderShip = voIntelligenceMinisterData.Country:GetTotalLeadership(),
		Spies = 0,						-- (Integer) How many spies we have in their country
		MissionLength = 60,
		DayCount = CCurrentGameState.GetCurrentDate():GetTotalDays(),
		IsHuman = CCurrentGameState.IsPlayer(voIntelligenceMinisterData.Tag),	-- Human controlling this country
		CapitalProvince = voIntelligenceMinisterData.Country:GetActingCapitalLocation(),	-- Province Object for the capital
		Continent = nil, 		-- Continent Object the capital is on
		IcOBJ = Support_Functions.GetICBreakDown(voIntelligenceMinisterData.Country), -- IC Object from Support_Functions.GetICBreakDown
		Priorities = {
			[SpyMission.SPYMISSION_COUNTER_ESPIONAGE] = 0,
			[SpyMission.SPYMISSION_BOOST_RULING_PARTY] = 0,
			[SpyMission.SPYMISSION_MILITARY] = 0,
			[SpyMission.SPYMISSION_TECH] = 0,
			[SpyMission.SPYMISSION_BOOST_OUR_PARTY] = 0,
			[SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY] = 0,
			[SpyMission.SPYMISSION_INCREASE_THREAT] = 0,
			[SpyMission.SPYMISSION_COVERT_OPS] = 0
		},
		Missions = {
			COUNTER_ESPIONAGE_ThreatScore = {
				Priority = 2,
				ThreatScore = 1,
				Spies = 1,
				Type = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
			},
			COUNTER_ESPIONAGE_IsAlly = {
				Priority = 2,
				Ally = true,
				Spies = 1,
				Type = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
			},
			COUNTER_ESPIONAGE_IsEnemy = {
				Priority = 1,
				Enemy = true,
				Spies = 4,
				Type = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
			},
			RULING_PARTY_70 = {
				Priority = 1,
				Enemy = false,
				IdeologyRequire = true,
				PartyPopularity = 70,
				Spies = 1,
				Type = SpyMission.SPYMISSION_BOOST_RULING_PARTY
			},
			RULING_PARTY_30 = {
				Priority = 2,
				Enemy = false,
				IdeologyRequire = true,
				PartyPopularity = 30,
				Spies = 1,
				Type = SpyMission.SPYMISSION_BOOST_RULING_PARTY
			},
			MILITARY = {
				Priority = 1,
				HumanOnly = true,
				Ally = false,
				Spies = 1,
				Type = SpyMission.SPYMISSION_MILITARY
			},
			TECH = {
				Priority = 1,
				Leader = true,
				Spies = 1,
				Type = SpyMission.SPYMISSION_TECH
			},
			OUR_PARTY = {
				Priority = 1,
				Enemy = false,
				IdeologyRequire = false,
				Spies = 1,
				Type = SpyMission.SPYMISSION_BOOST_OUR_PARTY
			},
			LOWER_NATIONAL_UNITY_ThreatScore = {
				Priority = 3,
				ThreatScore = 75,
				Spies = 1,
				Type = SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY
			},
			LOWER_NATIONAL_UNITY = {
				Priority = 1,
				Threat = 30,
				Enemy = true,
				Spies = 3,
				Type = SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY
			},
			INCREASE_THREAT_ThreatScore = {
				Priority = 3,
				ThreatScore = 75,
				Spies = 1,
				Type = SpyMission.SPYMISSION_INCREASE_THREAT
			},
			INCREASE_THREAT = {
				Priority = 1,
				Enemy = true,
				Spies = 3,
				Type = SpyMission.SPYMISSION_INCREASE_THREAT
			},
			COVERT_OPS = {
				Priority = 1,
				HumanOnly = true,
				Enemy = true,
				Spies = 3,
				Type = SpyMission.SPYMISSION_COVERT_OPS
			}
		}
	}

	AbroadSpy.Continent = AbroadSpy.CapitalProvince:GetContinent()
	AbroadSpy.HomeSpies = voIntelligenceMinisterData.SpyPresence:GetLevel():Get()

	for loCountry in CCurrentGameState.GetCountries() do
		local loTarget = {
			Tag = loCountry:GetCountryTag(),-- Tag Object
			Country = loCountry,			-- Country Object
			IsHuman = nil,					-- (True/False) Human controlling this country
			ThreatScore = 0,				-- (Integer) HUMAN ONLY Threat score based on what missions they are running on us
			SpyPresence = nil,				-- Our Spy Presence on them
			SpyPriority = 0,				-- (Integer) What is our priority on them
			NewSpyPriority = 0,				-- (Integer) New Priority we are setting for them
			Spies = 0,						-- (Integer) How many spies we have in their country
			ChangeDayCount = nil,			-- (Integer) How many days since our last mission change
			Ideology = nil,					-- Current Ideolgoy of the country
			IdeologyGroup = nil,			-- Group the countries Ideology belongs to
			PartyPopularity = 0,			-- (Integer) How popular the rulling ideology is
			LeaderShip = nil,				-- (Integer) How much leadership we have
			IsAtWar = nil,					-- (True/False) Are we at war with them
			IsExile = nil,					-- (True/False) Are they in exile
			IsNeighbor = nil,				-- (True/False) Are we neighbors
			Capital = nil,					-- Province Object that their capital is in.
			Continent = nil,				-- (String) What continent is their capital on
			IcOBJ = nil,					-- IC Object from Support_Functions.GetICBreakDown
			IsAlly = nil					-- (True/False) Are we allies.
		}

		-- Make sure we can spy on them
		if P.Can_Spy(voIntelligenceMinisterData, loTarget) then
			loTarget.IsHuman = CCurrentGameState.IsPlayer(loTarget.Tag)
			loTarget.IsExile = loTarget.Country:IsGovernmentInExile()
			loTarget.IsAlly = loTarget.Country:CalculateIsAllied(voIntelligenceMinisterData.Tag)
			loTarget.SpyPresence = voIntelligenceMinisterData.Country:GetSpyPresence(loTarget.Tag)
			loTarget.SpyPriority = loTarget.SpyPresence:GetPriority()
			loTarget.Spies = loTarget.SpyPresence:GetLevel():Get()
			loTarget.ChangeDayCount = loTarget.SpyPresence:GetLastMissionChangeDate():GetTotalDays()
			loTarget.Ideology = loTarget.Country:GetRulingIdeology()
			loTarget.IdeologyGroup = loTarget.Ideology:GetGroup()
			loTarget.PartyPopularity = loTarget.Country:AccessIdeologyPopularity():GetValue(loTarget.Ideology):Get()
			loTarget.Relation = voIntelligenceMinisterData.Country:GetRelation(loTarget.Tag)
			loTarget.Threat = loTarget.Relation:GetThreat():Get()
			loTarget.IsAtWar = loTarget.Relation:HasWar()
			loTarget.LeaderShip = loTarget.Country:GetTotalLeadership()

			--########################################
			-- Generate Threat Score (HUMAN PLAYER ONLY)
			--########################################
			if loTarget.IsHuman then
				local loSpyPresence = loTarget.Country:GetSpyPresence(voIntelligenceMinisterData.Tag)
				local liSpies = loSpyPresence:GetLevel():Get()

				-- Performance: If they have spies in our country then check
				if liSpies > 0 then
					local loThreat = { -- IF THREAT SCORE CHANGED HERE UPDATE abroad.lua as well
						COUNTER_ESPIONAGE = {
							Threat = 25,									-- Threat Score determines how dangerous this mission is
							Type = SpyMission.SPYMISSION_COUNTER_ESPIONAGE	-- Mission type as defined in the EXE
						},
						OUR_PARTY = {
							PartyCheck = true,								-- Compares Ideology Group if same then Threat Ignored
							Threat = 25,
							Type = SpyMission.SPYMISSION_BOOST_OUR_PARTY
						},		
						LOWER_NATIONAL_UNITY = {
							Threat = 100,
							Type = SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY
						},
						INCREASE_THREAT = {
							Threat = 100,
							Type = SpyMission.SPYMISSION_INCREASE_THREAT
						},
						COVERT_OPS = {
							Threat = 75,
							Type = SpyMission.SPYMISSION_COVERT_OPS
						}
					}

					for x, y in pairs(loThreat) do
						-- If the mission type has a threat see if its on us
						if y.Threat > 0 then
							if loSpyPresence:GetMissionPriority(y.Type) > 0 then
								local lbThreatCheck = true

								if y.PartyCheck then
									-- Same ideology so who cares if they have spies doing this to us
									if voIntelligenceMinisterData.IdeologyGroup == loTarget.IdeologyGroup then
										lbThreatCheck = false
									end
								end

								if lbThreatCheck and y.Threat > loTarget.ThreatScore then
									loTarget.ThreatScore = y.Threat
								end
							end
						end
					end
				end
			end
			--########################################
			-- End Human Player Only
			--########################################

			-- If they are in Exile just set priority to 0
			if loTarget.IsExile and loTarget.SpyPriority > 0 then
				P.Command_SetCountryPrio(voIntelligenceMinisterData.ministerAI, voIntelligenceMinisterData.Tag, loTarget.Tag, 0)
			else
				-- If we don't have atleast 7 spies in our home country set all priorities to 0
				if AbroadSpy.HomeSpies > 7 then -- Works with "if Leadership.Spies < 8 then" from tech_minister.lua file
					loTarget.IsNeighbor = loTarget.Country:IsNonExileNeighbour(voIntelligenceMinisterData.Tag)
					loTarget.Capital = loTarget.Country:GetActingCapitalLocation()
					loTarget.Continent = loTarget.Capital:GetContinent()
					loTarget.IcOBJ = Support_Functions.GetICBreakDown(loTarget.Country)
				
					-- if neighbors +1
					if loTarget.IsNeighbor then
						loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1
					end

					-- if we are atwar +1
					if loTarget.IsAtWar then
						loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1
					-- Threat to high +1 but only if not at war
					elseif loTarget.Threat > 30 then
						loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1
					end

					-- If we are Allies +1
					if loTarget.IsAlly then
						loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1
					end

					-- Same Continent +1
					if loTarget.Continent == AbroadSpy.Continent then
						loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1
					end

					-- They have more leadership than us so we can get Techs +1
					if (AbroadSpy.LeaderShip * 1.25) < loTarget.LeaderShip then
						loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1
					end

					-- They have a large base of IC so worry!
					if loTarget.IcOBJ.Base > 100 then
						loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1
					end

					-- They are allot smaller than us
					if loTarget.IcOBJ.Base < (AbroadSpy.IcOBJ.Base * 0.4) then
						-- Help Minors who are potential allies
						if not(loTarget.IsAtWar) 
						and loTarget.NewSpyPriority == 0
						and loTarget.IdeologyGroup == voIntelligenceMinisterData.IdeologyGroup then
							loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1

						elseif loTarget.NewSpyPriority > 0 then
							if loTarget.NewSpyPriority > 1
							or not(loTarget.IdeologyGroup == voIntelligenceMinisterData.IdeologyGroup) then
								loTarget.NewSpyPriority = loTarget.NewSpyPriority - 1
							end
						end
					elseif loTarget.IcOBJ.Base > 50 and AbroadSpy.IcOBJ.Base > 50 then
						-- There leadership is close to ours or more and we are a large country
						--    so its possible they have techs we want
						if loTarget.LeaderShip > (AbroadSpy.LeaderShip * 0.8) then
							loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1
						end
					end

					if loTarget.ThreatScore == 100 then
						loTarget.NewSpyPriority = loTarget.NewSpyPriority + 2
					elseif loTarget.ThreatScore > 0 then
						loTarget.NewSpyPriority = loTarget.NewSpyPriority + 1
					end
				end

				-- Normalize				
				loTarget.NewSpyPriority = math.min(loTarget.NewSpyPriority, CSpyPresence.MAX_SPY_PRIORITY )

				-- If prio changes then update it
				if loTarget.NewSpyPriority ~= loTarget.SpyPriority then
					P.Command_SetCountryPrio(voIntelligenceMinisterData.ministerAI, voIntelligenceMinisterData.Tag, loTarget.Tag, loTarget.NewSpyPriority)
				end
			end

			-- If we do not have any spies there don't set any missions
			if loTarget.Spies > 0 then
				local liRandomChange = 100

				-- Make sure no Divide by Zero creates an elastic change instead of fixed time
				if AbroadSpy.DayCount > 0 and loTarget.ChangeDayCount > 0 then
					liRandomChange = (AbroadSpy.DayCount - loTarget.ChangeDayCount)
				end

				-- Elastic Mission range change (for Human players always update missions)
				if math.random(50) < liRandomChange or loTarget.IsHuman then
					for x, y in pairs(AbroadSpy.Missions) do
						local lbAddMission = true

						-- If we have less leadership don't bother
						if y.Leader ~= nil and lbAddMission then
							if y.Leader then
								if loTarget.LeaderShip < (AbroadSpy.LeaderShip * 0.8) then
									lbAddMission = false
								end
							end
						end

						if y.Ally ~= nil and lbAddMission then
							-- We are not allies so do not add the mission in
							if y.Ally ~= loTarget.IsAlly then
								lbAddMission = false
							end
						end

						if y.Enemy ~= nil and lbAddMission then
							-- We are not at war
							if y.Enemy ~= loTarget.IsAtWar then
								lbAddMission = false
							end
						end

						if y.Spies ~= nil and lbAddMission then
							-- If we do not have the minimum amount of spies
							if y.Spies > loTarget.Spies then
								lbAddMission = false
							end
						end

						if y.IdeologyRequire ~= nil and lbAddMission then
							if y.IdeologyRequire -- If our groups are not the same then fail
							and loTarget.IdeologyGroup ~= voIntelligenceMinisterData.IdeologyGroup then
								lbAddMission = false

							elseif not(y.IdeologyRequire) -- If our groups are the same then fail
							and loTarget.IdeologyGroup == voIntelligenceMinisterData.IdeologyGroup then
								lbAddMission = false
							end
						end

						-- If PartyPoplarity below x number
						if y.PartyPopularity ~= nil and lbAddMission then
							if loTarget.PartyPopularity > y.PartyPopularity then
								lbAddMission = false
							end
						end

						-- We must not be at war to do this check
						if y.Threat ~= nil and not(loTarget.IsAtWar) and lbAddMission then
							-- If their threat is less than do not perform this mission
							if y.Threat > loTarget.Threat then
								lbAddMission = false
							end
						end

						-- Mission can only be used against Human Players
						if y.HumanOnly ~= nil  and lbAddMission then
							if y.HumanOnly ~= AbroadSpy.IsHuman then
								lbAddMission = false
							end
						end

						-- Check to see if the threat score is less than what the check is
						if y.ThreatScore ~= nil and lbAddMission then
							if y.ThreatScore > loTarget.ThreatScore then
								lbAddMission = false
							end
						end

						if lbAddMission then
							if AbroadSpy.Priorities[y.Type] < y.Priority then
								AbroadSpy.Priorities[y.Type] = y.Priority
							end 
						end
					end

					for x, y in pairs(AbroadSpy.Priorities) do
						if loTarget.SpyPresence:GetMissionPriority(x) ~= y then
							P.Command_SetMissionPrio(voIntelligenceMinisterData.ministerAI, voIntelligenceMinisterData.Tag, loTarget.Tag, x, y)
						end

						-- Reset them back once assigned
						AbroadSpy.Priorities[x] = 0
					end
				end
			else
				-- No spies so turn off all activity
				for x, y in pairs(AbroadSpy.Missions) do
					if loTarget.SpyPresence:GetMissionPriority(y.Type) ~= 0 then
						P.Command_SetMissionPrio(voIntelligenceMinisterData.ministerAI, voIntelligenceMinisterData.Tag, loTarget.Tag, y.Type, 0)
					end
				end
			end
		end
	end
end

function P.Can_Spy(voIntelligenceMinisterData, voTarget)
--Utils.LUA_DEBUGOUT("Can_Spy")
	if voTarget.Tag ~= voIntelligenceMinisterData.Tag then
		if voTarget.Country:Exists() then
			if voTarget.Tag:IsReal() then
				if voTarget.Tag:IsValid() then
					return true
				end
			end
		end
	end
	
	return false
end


function P.Command_SetMissionPrio(voAI, voFromTag, voTargetTag, voSpyMission, viPrio)
--Utils.LUA_DEBUGOUT("Command_SetMissionPrio")
	local loCommand = CChangeSpyMission(voFromTag, voTargetTag, voSpyMission, viPrio)
	voAI:Post(loCommand)
end

function P.Command_SetCountryPrio(voAI, voFromTag, voTargetTag, viPrio)
--Utils.LUA_DEBUGOUT("Command_SetCountryPrio")
	local loCommand = CChangeSpyPriority(voFromTag, voTargetTag, viPrio)
	voAI:Post(loCommand)
end

return Intelligence_Abroad