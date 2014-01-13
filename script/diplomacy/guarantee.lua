-----------------------------------------------------------
-- LUA Hearts of Iron 3 Guarantee File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_Guarantee = P

-- #######################
-- Support Methods
-- #######################
function P.GetScore(voTarget, voForeignMinisterData)

--Utils.LUA_DEBUGOUT("GetScore")
	local loDiploScoreObj = {
		Score = 0,												-- Current Score (integer)
		ministerAI = voForeignMinisterData.ministerAI,			-- AI Object
		Year = voForeignMinisterData.Year,						-- Current in game Year (integer)
		Month = voForeignMinisterData.Month,					-- Current in game Month (integer)
		Day = voForeignMinisterData.Day,						-- Current in game Day (integer)
		Actor = {
			Name = tostring(voForeignMinisterData.Tag),			-- Country Name (String)
			Tag = voForeignMinisterData.Tag,					-- Country Tag
			Country = voForeignMinisterData.Country,			-- Country Object
			IsPuppet = voForeignMinisterData.IsPuppet,			-- True/False are they a Puppet Country
			IsExile	= voForeignMinisterData.IsExile,			-- True/False are the in exile
			IsNaval = voForeignMinisterData.IsNaval,			-- True/False do the meet requirements to use the Naval standard file or Land
			Ideology = voForeignMinisterData.Ideology,			-- Current Ideolgoy of the country
			IdeologyGroup = voForeignMinisterData.IdeologyGroup, -- Group the countries Ideology belongs to
			IdeologyGroupName = voForeignMinisterData.IdeologyGroupName, -- (string) Actual name of the Ideology Group
			IcOBJ = voForeignMinisterData.IcOBJ,				-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = voForeignMinisterData.PortsTotal,		-- (integer) Total amount of ports the country has
			IsMajor = voForeignMinisterData.IsMajor,			-- True/False is this country a major power
			IsAtWar = voForeignMinisterData.IsAtWar,			-- True/False is this country a at war
			Faction = voForeignMinisterData.Faction,			-- Faction Object the country belongs to
			FactionName = voForeignMinisterData.FactionName,	-- Name of the Faction the country belongs to (string)
			HasFaction = voForeignMinisterData.HasFaction,		-- True/False does the country have a faction
			Strategy = voForeignMinisterData.Strategy,			-- Strategy Object
			Desperation = voForeignMinisterData.Desperation,	-- Current Desperation level (integer)
			Neutrality = voForeignMinisterData.Neutrality, 		-- Current Neutrality level (integer)
			Diplomats = voForeignMinisterData.Diplomats, 		-- How many diplomats they have (integer)
			Continent = nil,									-- Continent Object the capital is on
			ContinentName = nil,								-- Continent Name the capital is on (string)
		},
		Target = {
			Name = voTarget.Name,		-- Country Name (String)
			Tag = voTarget.Tag,			-- Country Tag
			Country = voTarget.Country, -- Country Object
			IsMajor = nil,				-- True/False is this country a major power
			IsAtWar = nil,				-- True/False is this country at war
			IsExile = nil,				-- True/False is this countries goverment in exile
			Ideology = nil,				-- Current Ideolgoy of the country
			IdeologyGroup = nil,		-- Group the countries Ideology belongs to
			Faction = nil,				-- Faction Object the country belongs to
			FactionName = nil,			-- Name of the Faction the country belongs to (string)
			HasFaction = voTarget.HasFaction, -- True/False does the country have a faction
			Neutrality = nil, 			-- Current Neutrality level (integer)
			Relation = voTarget.Relation, -- Relation Object between the two countries
			RelationValue = nil,		-- Relation Value between Actor/Target (integer)
			IsNeighbour = nil, 			-- True/False is Actor/Targer neighbors
			Continent = nil,			-- Continent Object the capital is on
			ContinentName = nil			-- Continent Name the capital is on (string)
		}
	}
	
	-- Performance Check
	-- If both parties are in faction no point in a guarantee
	if not(loDiploScoreObj.Actor.IsExile) then
		if (not(loDiploScoreObj.Target.HasFaction) and loDiploScoreObj.Actor.HasFaction)
		or (loDiploScoreObj.Target.HasFaction and not(loDiploScoreObj.Actor.HasFaction))
		or (not(loDiploScoreObj.Target.HasFaction) and not(loDiploScoreObj.Actor.HasFaction)) then
			loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
	
			-- if the target is in exile dont do it either
			if not(loDiploScoreObj.Target.IsExile) then
				loDiploScoreObj.Actor.Ideology = loDiploScoreObj.Actor.Country:GetRulingIdeology()
				loDiploScoreObj.Actor.IdeologyGroup = loDiploScoreObj.Actor.Ideology:GetGroup()
				loDiploScoreObj.Actor.Continent = loDiploScoreObj.Actor.Country:GetActingCapitalLocation():GetContinent()
				loDiploScoreObj.Actor.ContinentName = tostring(loDiploScoreObj.Actor.Continent:GetTag())

				loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
				loDiploScoreObj.Target.FactionName = tostring(loDiploScoreObj.Target.Faction:GetTag())
				loDiploScoreObj.Target.IsAtWar = loDiploScoreObj.Target.Country:IsAtWar()
				loDiploScoreObj.Target.Ideology = loDiploScoreObj.Target.Country:GetRulingIdeology()
				loDiploScoreObj.Target.IdeologyGroup = loDiploScoreObj.Target.Ideology:GetGroup()
				loDiploScoreObj.Target.IsMajor = loDiploScoreObj.Target.Country:IsMajor()
				loDiploScoreObj.Target.Neutrality = loDiploScoreObj.Target.Country:GetEffectiveNeutrality():Get()
				loDiploScoreObj.Target.Continent = loDiploScoreObj.Target.Country:GetActingCapitalLocation():GetContinent()
				loDiploScoreObj.Target.ContinentName = tostring(loDiploScoreObj.Target.Continent:GetTag())
				loDiploScoreObj.Target.IsNeighbour = loDiploScoreObj.Actor.Country:IsNeighbour(loDiploScoreObj.Target.Tag)
				loDiploScoreObj.Target.RelationValue = loDiploScoreObj.Target.Relation:GetValue():GetTruncated()

				-- Same ideology so small bonus
				if loDiploScoreObj.Target.IdeologyGroup == loDiploScoreObj.Actor.IdeologyGroup then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 5
				end
			
				-- If they are not a major power small bonus
				if not(loDiploScoreObj.Target.IsMajor) then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 5
				end
			
				-- We are neighbors so small bonus
				if loDiploScoreObj.Target.IsNeighbour then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 5
				end
			
				-- We are on the same continent so bonus
				if loDiploScoreObj.Actor.Continent == loDiploScoreObj.Target.Continent then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 5
				end

				-- Diplomacy checks to see if we are friendly to eachother
				if loDiploScoreObj.Target.Relation:HasFriendlyAgreement() then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 5
				end
				if loDiploScoreObj.Target.Relation:AllowDebts() then
					loDiploScoreObj.Score = loDiploScoreObj.Score + 5
				end
			
				-- Now add our relations
				if loDiploScoreObj.Target.RelationValue > 10 then
					loDiploScoreObj.Score = loDiploScoreObj.Score + (loDiploScoreObj.Target.RelationValue / 10)
				else
					loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Target.RelationValue
				end
			
				loDiploScoreObj.Score = loDiploScoreObj.Score + loDiploScoreObj.Actor.Strategy:GetFriendliness(loDiploScoreObj.Target.Tag) / 2
				loDiploScoreObj.Score = loDiploScoreObj.Score + loDiploScoreObj.Actor.Strategy:GetProtectionism(loDiploScoreObj.Target.Tag)
				loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Actor.Strategy:GetAntagonism(loDiploScoreObj.Target.Tag) / 2
				loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Target.Country:GetDiplomaticDistance(loDiploScoreObj.Actor.Tag):GetTruncated() 
			
				loDiploScoreObj.Score = Support_Country.Call_Score_Function(true, 'DiploScore_Guarantee', loDiploScoreObj)
			
				-- Clamp down, if the score is not over 70 do not guarantee as it should be rare
				if loDiploScoreObj.Score < 70 then
					loDiploScoreObj.Score = 0
				end
			end
		end
	end

	return loDiploScoreObj.Score
end

function P.Guarantee(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Guarantee")
	-- If we are in Exile there is no point
	if not(voForeignMinisterData.IsExile) then
		-- Make sure we have the diplomats and our Neutrality is low enough
		--   Puppets should never issue Guarantees
		if (voForeignMinisterData.Diplomats >= defines.diplomacy.GUARANTEE_INFLUENCE_COST)
		and (voForeignMinisterData.Diplomats >= defines.diplomacy.REVOKE_GUARANTEE_INFLUENCE_COST)
		and (voForeignMinisterData.Neutrality <= defines.diplomacy.GUARANTEE_NEUTRALITY_LIMIT)
		and not(voForeignMinisterData.IsPuppet) then
			for loRelation in voForeignMinisterData.Country:GetDiplomacy() do
				local loTarget = {
					Name = nil,
					Tag = loRelation:GetTarget(),
					Country = nil,
					HasFaction = nil,
					Embargoed = nil,
					Score = 0,
					Relation = loRelation
				}
			
				loTarget.Name = tostring(loTarget.Tag)	
				loTarget.Country = loTarget.Tag:GetCountry()
				loTarget.Relation = loTarget.Country:GetRelation(voForeignMinisterData.Tag)
			
				if P.Can_Click_Button(loTarget, voForeignMinisterData) then
					loTarget.HasFaction = loTarget.Country:HasFaction()
					loTarget.Embargoed = loTarget.Relation:HasEmbargo()
				
					if not(loRelation:IsGuaranting()) then
						if not(loTarget.Embargoed) and not(loTarget.HasFaction) then
							local liScore = P.GetScore(loTarget, voForeignMinisterData)

							if liScore > 50 then
								if P.Command_Guarantee(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, liScore) then
									break -- Can only execute one Guarantee command at a time
								end
							end
						end
					-- This code commented out since Guarantee's can't be cancelled.
					--else
					--	local liScore = P.GetScore(loTarget, voForeignMinisterData)

					--	if loTarget.Embargoed or loTarget.HasFaction or liScore < 50 then
							-- Cancel
					--		if P.Command_Guarantee(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100) then
					--			break -- Can only execute one Guarantee command at a time
					--		end
					--	end
					end
				end
			end
		end
	end
end

function P.Command_Guarantee(voMinister, voFromTag, voTargetTag, vbCancel, viScore)
--Utils.LUA_DEBUGOUT("Command_Guarantee")
	local loCommand = CGuaranteeAction(voFromTag, voTargetTag)
	
	-- Guarantees can't be removed once placed.
	--   although vbCancel is a parm it is useless right now
	if vbCancel then
		loCommand:SetValue(false)
	end

	if loCommand:IsSelectable() then
		voMinister:Propose(loCommand, viScore )
		return true
	end
	
	return false
end

function P.Can_Click_Button(voTarget, voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Can_Click_Button")
	if voTarget.Country:Exists() then
		if voTarget.Tag:IsReal() then
			if voTarget.Tag:IsValid() then
				if not(voTarget.Relation:HasWar()) then
					if not(voForeignMinisterData.Country:HasDiplomatEnroute(voTarget.Tag)) then
						return true
					end
				end
			end
		end
	end
	
	return false
end

-- ###############################################
-- END OF Support methods
-- ###############################################

return ForeignMinister_Guarantee