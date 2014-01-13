-----------------------------------------------------------
-- LUA Hearts of Iron 3 Home Spies File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/3/2013
-----------------------------------------------------------
local P = {}
Intelligence_Home = P

function P.Spies(voIntelligenceMinisterData)
--Utils.LUA_DEBUGOUT("Spies")
	local HomeSpy = {
		ThreatScore = 0,					-- Integer determines threat level from enemy presence
		SpyPriority = nil,					-- Integer Priority This country has (on itself)
		Default = "NATIONAL_UNITY",
		Abroad = { -- IF THREAT SCORE CHANGED HERE UPDATE abroad.lua as well
			COUNTER_ESPIONAGE = {
				Threat = 25,									-- Threat Score determines how dangerous this mission is
				Type = SpyMission.SPYMISSION_COUNTER_ESPIONAGE	-- Mission type as defined in the EXE
			},
			TECH = {
				Threat = 25,
				Type = SpyMission.SPYMISSION_TECH
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
		},
		Home = {
			COUNTER_ESPIONAGE = {
				Type = SpyMission.SPYMISSION_COUNTER_ESPIONAGE,
				Priority = 0
			},
			NATIONAL_UNITY = {
				Value = voIntelligenceMinisterData.Country:GetNationalUnity():Get(),
				Type = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY,
				FinalScore = 0,
				Priority = 0,
				Scores = {
					Chk1 = { Value = 90, Score = 0 },
					Chk2 = { Value = 80, Score = 40 },
					Chk3 = { Value = 70, Score = 50 },
					Chk4 = { Value = 60, Score = 70 },
					Chk5 = { Value = 50, Score = 80 },
					Chk6 = { Value = 0, Score = 100 }
				}
			},
			RULING_PARTY = {
				Value = voIntelligenceMinisterData.Country:AccessIdeologyPopularity():GetValue(voIntelligenceMinisterData.Ideology):Get(),
				Type = SpyMission.SPYMISSION_BOOST_RULING_PARTY,
				FinalScore = 0,
				Priority = 0,
				Scores = {
					Chk1 = { Value = 70, Score = 0 },
					Chk2 = { Value = 60, Score = 45 },
					Chk3 = { Value = 50, Score = 55 },
					Chk4 = { Value = 40, Score = 65 },
					Chk5 = { Value = 30, Score = 75 },
					Chk6 = { Value = 0, Score = 95 }
				}
			}
		}
	}

	HomeSpy.SpyPriority = voIntelligenceMinisterData.SpyPresence:GetPriority()

	-- Calculate Bad Spies Threat Score
	for loTag in voIntelligenceMinisterData.Country:GetSpyingOnUs() do
		local loCountry = {
			Tag = loTag,		-- Country Tag
			Country = loTag:GetCountry(), -- Country Object
			SpyPresence = nil,	-- CSpyPresence object from the EXE
			Spies = 0			-- How many spies do they have in our country
		}
		loCountry.SpyPresence = loCountry.Country:GetSpyPresence(voIntelligenceMinisterData.Tag)
		loCountry.Spies = loCountry.SpyPresence:GetLevel():Get()

		-- Performance: If they have spies in our country then check
		if loCountry.Spies > 0 then
			for x, y in pairs(HomeSpy.Abroad) do
				-- If the mission type has a threat see if its on us
				if y.Threat > 0 then
					if loCountry.SpyPresence:GetMissionPriority(y.Type) > 0 then
						local lbThreatCheck = true

						if y.PartyCheck then
							local loIdeologyGroup = loCountry.Country:GetRulingIdeology():GetGroup()

							-- Same ideology so who cares if they have spies doing this to us
							if voIntelligenceMinisterData.IdeologyGroup == loIdeologyGroup then
								lbThreatCheck = false
							end
						end

						if lbThreatCheck and y.Threat > HomeSpy.ThreatScore then
							HomeSpy.ThreatScore = y.Threat
						end
					end
				end
			end
		end
		
		-- We reached max score of 100 so just get out
		if HomeSpy.ThreatScore == 100 then
			break
		end
	end


	-- Now figure out What the priorities are for Counter Espionage Mission
	local liPrioLeft = 3
	
	if HomeSpy.ThreatScore > 0 then
		local liPriority = 0

		if HomeSpy.ThreatScore == 100 then
			liPriority = 2
		elseif HomeSpy.ThreatScore > 0 then
			liPriority = 1
		end

		HomeSpy.Home["COUNTER_ESPIONAGE"].Priority = liPriority
		liPrioLeft = liPrioLeft - liPriority
	end

	local liCurrentScore = 0
	local liCurrentValue = 0

	-- Figure out the Score for each mission type
	for x, y in pairs(HomeSpy.Home) do
		if y.Scores then
			for l, m in pairs(y.Scores) do
				if y.Value > m.Value and m.Value > liCurrentValue then
					liCurrentScore = m.Score
				end
			end

			y.FinalScore = liCurrentScore
			liCurrentScore = 0
			liCurrentValue = 0
		end
	end

	-- Which mission wun
	for x, y in pairs(HomeSpy.Home) do
		if y.FinalScore then
			if y.FinalScore > liCurrentScore then
				HomeSpy.Default = x
				liCurrentScore = y.FinalScore
			end
		end
	end

	HomeSpy.Home[HomeSpy.Default].Priority = liPrioLeft

	-- Assign the mission
	for x, y in pairs(HomeSpy.Home) do
		if voIntelligenceMinisterData.SpyPresence:GetMissionPriority(y.Type) ~= y.Priority then
			P.Command_SetMissionPrio(voIntelligenceMinisterData.ministerAI, voIntelligenceMinisterData.Tag, voIntelligenceMinisterData.Tag, y.Type, y.Priority)
		end
    end

	-- Always set your home priority to the highest
	if HomeSpy.SpyPriority < CSpyPresence.MAX_SPY_PRIORITY then
		P.Command_SetCountryPrio(voIntelligenceMinisterData.ministerAI, voIntelligenceMinisterData.Tag, voIntelligenceMinisterData.Tag, CSpyPresence.MAX_SPY_PRIORITY)
	end
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

return Intelligence_Home