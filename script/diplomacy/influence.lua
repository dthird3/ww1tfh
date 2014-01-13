-----------------------------------------------------------
-- LUA Hearts of Iron 3 Influence File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 11/17/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_Influence = P

-- #######################
-- Support Methods
-- #######################
function P.GetScore(voTarget, voForeignMinisterData)
--Utils.LUA_DEBUGOUT("GetScore")
	local loDiploScoreObj = {
		Score = 500,											-- Current Score (integer)
		ministerAI = voForeignMinisterData.ministerAI,			-- AI Object
		Year = voForeignMinisterData.Year,						-- Current in game Year (integer)
		Month = voForeignMinisterData.Month,					-- Current in game Month (integer)
		Day = voForeignMinisterData.Day,						-- Current in game Day (integer)
		Actor = {
			Name = tostring(voForeignMinisterData.Tag),	-- Country Name (String)
			Tag = voForeignMinisterData.Tag,			-- Country Tag
			Country = voForeignMinisterData.Country,	-- Country Object
			IsPuppet = voForeignMinisterData.IsPuppet, 		-- True/False are they a Puppet Country
			IsExile	= voForeignMinisterData.IsExile, 			-- True/False are the in exile
			IsNaval = voForeignMinisterData.IsNaval, 			-- True/False do the meet requirements to use the Naval standard file or Land
			Ideology = voForeignMinisterData.Ideology,			-- Current Ideolgoy of the country
			IdeologyGroup = voForeignMinisterData.IdeologyGroup, -- Group the countries Ideology belongs to
			IdeologyGroupName = voForeignMinisterData.IdeologyGroupName, -- (string) Actual name of the Ideology Group
			IcOBJ = voForeignMinisterData.IcOBJ, 				-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = voForeignMinisterData.PortsTotal,		-- (integer) Total amount of ports the country has
			IsMajor = voForeignMinisterData.IsMajor,			-- True/False is this country a major power
			IsAtWar = voForeignMinisterData.IsAtWar,			-- True/False is this country a at war
			Faction = voForeignMinisterData.Faction,			-- Faction Object the country belongs to
			FactionName = voForeignMinisterData.FactionName,	-- Name of the Faction the country belongs to (string)
			HasFaction = voForeignMinisterData.HasFaction,		-- True/False does the country have a faction
			FactionLeaderTag = voForeignMinisterData.Faction:GetFactionLeader(), -- Country Tag of the Faction leader
			FactionLeaderCountry = nil,							-- Country Object of the Faction leader
			Strategy = voForeignMinisterData.Strategy,			-- Strategy Object
			Desperation = voForeignMinisterData.Desperation,	-- Current Desperation level (integer)
			Neutrality = voForeignMinisterData.Neutrality, 		-- Current Neutrality level (integer)
			Diplomats = voForeignMinisterData.Diplomats, 		-- How many diplomats they have (integer)
			CapitalProvince = nil,								-- Province Object for the capital
			Continent = nil 									-- Continent Object the capital is on
		},
		Target = {
			Name = voTarget.Name,		-- Country Name (String)
			Tag = voTarget.Tag,			-- Country Tag
			Country = voTarget.Country,	-- Country Object
			AlignDistance = nil,		-- Alignment distance between this country and the Faction Leader (integer)
			Ideology = nil,				-- Current Ideolgoy of the country
			IdeologyGroup = nil,		-- Group the countries Ideology belongs to
			IsMajor = nil,				-- True/False is this country a major power
			Neutrality = nil,			-- Current Neutrality level (integer)
			IsNeighbour = nil,			-- True/False is Actor/Targer neighbors
			Relation = nil,				-- Relation Object between Actor/Target
			RelationValue = nil,		-- Current relation value (integer)
			Threat = nil,				-- Current threat level (integer)
			IsGuaranteed = nil,			-- True/False is Actor guaranteing Target
			HasFriendlyAgreement = nil,	-- True/False does Actor/Target have a freindly agreement
			AllowDebts = nil,			-- True/False are they allowing debts
			IcOBJ = nil,				-- IC Object from Support_Functions.GetICBreakDown
			CapitalProvince = nil,		-- Province Object for the capital
			Continent = nil 			-- Continent Object the capital is on
		}
	}	
	
	loDiploScoreObj.Actor.FactionLeaderCountry = loDiploScoreObj.Actor.FactionLeaderTag:GetCountry()
	loDiploScoreObj.Target.AlignDistance = loDiploScoreObj.ministerAI:GetCountryAlignmentDistance(loDiploScoreObj.Target.Country, loDiploScoreObj.Actor.FactionLeaderCountry):Get()
	
	-- Performance Check, are they already in our corner if so exit out do not influence
	if loDiploScoreObj.Target.AlignDistance <= 10 then
		loDiploScoreObj.Score = 0
	else
		-- Load these only if we need to (Performance)
		loDiploScoreObj.Actor.Ideology = loDiploScoreObj.Actor.Country:GetRulingIdeology()
		loDiploScoreObj.Actor.IdeologyGroup = loDiploScoreObj.Actor.Ideology:GetGroup()
		loDiploScoreObj.Actor.CapitalProvince = loDiploScoreObj.Actor.Country:GetActingCapitalLocation()
		loDiploScoreObj.Actor.Continent = loDiploScoreObj.Actor.CapitalProvince:GetContinent()
		
		loDiploScoreObj.Target.Ideology = loDiploScoreObj.Target.Country:GetRulingIdeology()
		loDiploScoreObj.Target.IdeologyGroup = loDiploScoreObj.Target.Ideology:GetGroup()
		loDiploScoreObj.Target.IsMajor = loDiploScoreObj.Target.Country:IsMajor()
		loDiploScoreObj.Target.Neutrality = loDiploScoreObj.Target.Country:GetEffectiveNeutrality():Get()
		loDiploScoreObj.Target.IsNeighbour = loDiploScoreObj.Target.Country:IsNonExileNeighbour(loDiploScoreObj.Target.Tag)
		loDiploScoreObj.Target.Relation = loDiploScoreObj.ministerAI:GetRelation(loDiploScoreObj.Actor.Tag, loDiploScoreObj.Target.Tag)
		loDiploScoreObj.Target.RelationValue = loDiploScoreObj.Target.Relation:GetValue():GetTruncated()
		loDiploScoreObj.Target.Threat = loDiploScoreObj.Target.Relation:GetThreat():Get()
		loDiploScoreObj.Target.IsGuaranteed = loDiploScoreObj.Target.Relation:IsGuaranteed()
		loDiploScoreObj.Target.HasFriendlyAgreement = loDiploScoreObj.Target.Relation:HasFriendlyAgreement()
		loDiploScoreObj.Target.AllowDebts = loDiploScoreObj.Target.Relation:AllowDebts()
		loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
		loDiploScoreObj.Target.CapitalProvince = loDiploScoreObj.Target.Country:GetActingCapitalLocation()
		loDiploScoreObj.Target.Continent = loDiploScoreObj.Target.CapitalProvince:GetContinent()
		
		-- Calculate Importance based on IC
		---   Remember on Majors can Influence
		if loDiploScoreObj.Target.IcOBJ.IC > loDiploScoreObj.Actor.IcOBJ.IC then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 70
		elseif loDiploScoreObj.Target.IcOBJ.IC > loDiploScoreObj.Actor.IcOBJ.Base * 0.5 then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 40
		elseif loDiploScoreObj.Target.IcOBJ.IC > loDiploScoreObj.Actor.IcOBJ.Base * 0.3 then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 30
		elseif loDiploScoreObj.Target.IcOBJ.IC > loDiploScoreObj.Actor.IcOBJ.Base * 0.2 then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 20
		elseif loDiploScoreObj.Target.IcOBJ.IC > loDiploScoreObj.Actor.IcOBJ.Base * 0.1 then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 10
		elseif loDiploScoreObj.Target.IcOBJ.IC > loDiploScoreObj.Actor.IcOBJ.Base * 0.05 then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 5
		end
		
		-- The closer they are to entering the war the higher priority to influence them out
		if loDiploScoreObj.Target.Neutrality > 90 then
			loDiploScoreObj.Score = loDiploScoreObj.Score - 100
		elseif loDiploScoreObj.Target.Neutrality > 80 then
			loDiploScoreObj.Score = loDiploScoreObj.Score - 70
		elseif loDiploScoreObj.Target.Neutrality > 70 then
			loDiploScoreObj.Score = loDiploScoreObj.Score - 10
		elseif loDiploScoreObj.Target.Neutrality < defines.diplomacy.JOIN_FACTION_NEUTRALITY + 10 then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 50
		end
		
		-- Political checks
		-- ################
		loDiploScoreObj.Score = loDiploScoreObj.Score - loDiploScoreObj.Target.Threat / 5
		loDiploScoreObj.Score = loDiploScoreObj.Score + loDiploScoreObj.Target.RelationValue / 3
		
		if loDiploScoreObj.Target.IsGuaranteed then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 10
		end
		if loDiploScoreObj.Target.HasFriendlyAgreement then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 10
		end
		if loDiploScoreObj.Target.AllowDebts then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 5
		end
		-- ################
		
		-- We are neighbors
		if loDiploScoreObj.Target.IsNeighbour then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 50
		else
			-- We are on the same continent so bonus
			if loDiploScoreObj.Target.Continent == loDiploScoreObj.Actor.Continent then
				loDiploScoreObj.Score = loDiploScoreObj.Score + 40
			end
		end
		
		-- They are already leaning toward us 
		if Support_Functions.IsFriend(loDiploScoreObj.ministerAI, loDiploScoreObj.Actor.Faction, loDiploScoreObj.Target.Country) then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 20
		else
			loDiploScoreObj.Score = loDiploScoreObj.Score - 20
		end
		
		-- They are a major power
		if loDiploScoreObj.Target.IsMajor then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 10
		end
		
		-- They have a neighbor that is in our faction already
		if loDiploScoreObj.Target.Country:HasNeighborInFaction(loDiploScoreObj.Actor.Faction) then
			loDiploScoreObj.Score = loDiploScoreObj.Score + 20
		end
		
		if loDiploScoreObj.Actor.IdeologyGroup ~= loDiploScoreObj.Target.IdeologyGroup then
			loDiploScoreObj.Score = loDiploScoreObj.Score - 15
		else
			loDiploScoreObj.Score = loDiploScoreObj.Score + 15
		end
		
		loDiploScoreObj.Score = Support_Country.Call_Score_Function(true, 'DiploScore_InfluenceNation', loDiploScoreObj)
	end
	
	return loDiploScoreObj.Score
end
function P.Influence(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Influence")
	-- Make sure they are allowed to influence
	if voForeignMinisterData.CanInfluence then
		local Influence = {
			Buffer = 0.1,				-- Size of Diplomacy Buffer so there is a gain
			WatchDistanceCap = 120,		-- (integer) Distance Cap from another faction
			Conversion = defines.economy.LEADERSHIP_TO_DIPLOMACY,-- Diplomacy conversion factor (defines.lua)
			Cost = defines.diplomacy.INFLUENCE_INFLUENCE_COST,	-- Cost to start the Influence (defines.lua)
			Upkeep = defines.diplomacy.INFLUENCE_UPKEEP,		-- Cost to maintain the Influence (defines.lua)
			LeaderShipOBJ = nil,		-- Located in the ai_tech_minister.lua file
			IgnoreWatch = {},			-- Countries on Ignore but are being watched so they dont shift to another faction
			Watch = {},					-- Countries on the Watch list
			Ignore = {},				-- Countries on the Ignore list
			Counts = {
				Total = 0,				-- (integer) Amount of Influences the country can have
				Remaining = 0,			-- (integer) Remaining Influences left
				Current = 0,			-- (integer) How many Influences currently being done
				Watch = 0				-- (integer) How many influences to be used for watching
			},
			Countries = {
				Influencing = {},		-- (Array) Country Objects for each country we are currently influencing
				PotentialTarget = {},	-- (Array) Country Objects of each country that is a potential target
				Target = {}				-- (Array) Country Objects of each country that is a final target
			}
		}
		
		Influence.LeaderShipOBJ = Support_Tech.BalanceLeadershipSliders(voForeignMinisterData, false)

		-- We are allowed to influence so figure out what we can do
		if Influence.LeaderShipOBJ.CanInfluence then
			-- Calculate how much Influence they have to use
			Influence.Counts.Total = math.floor((((Influence.LeaderShipOBJ.TotalLeadership * Influence.LeaderShipOBJ.Default_Diplomacy) * Influence.Conversion) - Influence.Buffer) / Influence.Upkeep)
			
			-- Prevents divide by 0 error
			if Influence.LeaderShipOBJ.ActiveInfluence > 0 then
				Influence.Counts.Current = Influence.LeaderShipOBJ.ActiveInfluence / Influence.Upkeep
			end
			
			Influence.Counts.Watch = math.ceil(Influence.Counts.Total / 0.5)
			Influence.Counts.Remaining = Influence.Counts.Total - Influence.Counts.Watch

		-- Performance: We can't influence anything so why process this
		elseif Influence.LeaderShipOBJ.ActiveInfluence == 0 then
			return false
		end
		
		local loFunRef = Support_Country.Get_Function(voForeignMinisterData, "ForeignMinister_Influence")
		
		if loFunRef then
			Influence = loFunRef(voForeignMinisterData, Influence)
			Influence.Watch = Utils.Set(Influence.Watch)
			Influence.IgnoreWatch = Utils.Set(Influence.IgnoreWatch)
			Influence.Ignore = Utils.Set(Influence.Ignore)
		end
		
		local loFactionLeaderTag = voForeignMinisterData.Faction:GetFactionLeader()
		
		for loRelation in voForeignMinisterData.Country:GetDiplomacy() do
			local loTargetTag = loRelation:GetTarget()
			local lsTargetTag = tostring(loTargetTag)
			
			-- Do not process if on the ignore list
			if not(Influence.Ignore[lsTargetTag]) and Influence.LeaderShipOBJ.CanInfluence then
				local loTargetCountry = loTargetTag:GetCountry()

				-- If they are aligning do not influence
				if P.Can_Click_Button(loTargetTag, loTargetCountry, loRelation, voForeignMinisterData) then
					-- If lbIsAligning = true and lbIsInfluencing = true : means we are influencing them
					-- If lbIsAligning = true and lbIsInfluencing = false : means they are aligning to us
					local lbIsAligning = P.IsAligning(loTargetTag, loFactionLeaderTag)
					local lbIsNeighbor = voForeignMinisterData.Country:IsNonExileNeighbour(loTargetTag)
					
					if lbIsAligning then
						local loReverseRelation = loTargetCountry:GetRelation(voForeignMinisterData.Tag)
						local lbIsInfluencing = loReverseRelation:IsBeingInfluenced()
						
						if lbIsInfluencing then
							Influence.Countries.Influencing[lsTargetTag] = {
								Name = lsTargetTag,
								Tag = loTargetTag,
								Country = loTargetCountry,
								Distance = 0,
								BeingWatched = (lbIsNeighbor or Influence.Watch[lsTargetTag] or Influence.IgnoreWatch[lsTargetTag]),
								Score = nil
							}
								
							-- Are they our neighbour or on our watch list
							if Influence.Countries.Influencing[lsTargetTag].BeingWatched then
								Influence.Countries.Influencing[lsTargetTag].Distance = Support_Functions.IsFriendDistance(voForeignMinisterData.ministerAI, voForeignMinisterData.Faction, loTargetCountry)
							end
								
							Influence.Countries.Influencing[lsTargetTag].Score = P.GetScore(Influence.Countries.Influencing[lsTargetTag], voForeignMinisterData)
							Influence.Countries.PotentialTarget[lsTargetTag] = Influence.Countries.Influencing[lsTargetTag]
						end
					else
						Influence.Countries.PotentialTarget[lsTargetTag] = {
							Name = lsTargetTag,
							Tag = loTargetTag,
							Country = loTargetCountry,
							Distance = 0,
							BeingWatched = (lbIsNeighbor or Influence.Watch[lsTargetTag] or Influence.IgnoreWatch[lsTargetTag]),
							Score = nil
						}
							
						-- Are they our neighbour or on our watch list
						if Influence.Countries.PotentialTarget[lsTargetTag].BeingWatched then
							Influence.Countries.PotentialTarget[lsTargetTag].Distance = Support_Functions.IsFriendDistance(voForeignMinisterData.ministerAI, voForeignMinisterData.Faction, loTargetCountry)
						end

						Influence.Countries.PotentialTarget[lsTargetTag].Score = P.GetScore(Influence.Countries.PotentialTarget[lsTargetTag], voForeignMinisterData)
					end
				end
			else
				-- They are on the ignore list check to see if we are influencing them
				local loTargetCountry = loTargetTag:GetCountry()
				local loReverseRelation = loTargetCountry:GetRelation(voForeignMinisterData.Tag)
				local lbIsInfluencing = loReverseRelation:IsBeingInfluenced()
				
				if lbIsInfluencing then
					Influence.Countries.Influencing[lsTargetTag] = {
						Name = lsTargetTag,
						Tag = loTargetTag,
						Country = loTargetCountry,
						Distance = 0,
						BeingWatched = false,
						Score = 0
					}
				end
			end
		end
		
		local liCurrentInfluenceCount = 0

		-- First add Watch Countries
		for i = 1, Influence.Counts.Watch, 1 do
			local loWatch = nil
			
			for k, v in pairs(Influence.Countries.PotentialTarget) do
				if v.BeingWatched and not(Influence.Countries.Target[v.Name]) then
					if v.Distance < Influence.WatchDistanceCap then
						if not(loWatch) then
							loWatch = v
						else
							if loWatch.Distance > v.Distance then
								loWatch = v
							end
						end
					end
				end
			end
			
			if not(loWatch) then
				-- Nothing to do so exit out
				break 
			else
				-- Add it to target list
				liCurrentInfluenceCount = liCurrentInfluenceCount + 1
				Influence.Countries.Target[loWatch.Name] = loWatch
			end
		end
		
		-- Process Best Targets with what's left
		Influence.Counts.Remaining =  Influence.Counts.Remaining + (Influence.Counts.Watch - liCurrentInfluenceCount)
		for i = 1, (Influence.Counts.Remaining), 1 do
			local loBest = nil
			
			for k, v in pairs(Influence.Countries.PotentialTarget) do
				if not(Influence.Countries.Target[v.Name]) then
					if not(loBest) then
						loBest = v
					else
						if loBest.Score < v.Score then
							loBest = v
						end
					end
				end
			end
			
			if not(loBest) then
				-- Nothing to do so exit out
				break 
			else
				-- Add it to target list
				liCurrentInfluenceCount = liCurrentInfluenceCount + 1
				Influence.Countries.Target[loBest.Name] = loBest
			end
		end
		
		-- Now Cancel Influences we no longer want
		for k, v in pairs(Influence.Countries.Influencing) do
			if not(Influence.Countries.Target[v.Name]) then
				P.Command_Influence(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, v.Tag, true)
			else
				Influence.Countries.Target[v.Name] = nil
			end
		end
		
		-- Now Influence who is left
		for k, v in pairs(Influence.Countries.Target) do
			-- Make sure we are not already influencing them
			if not(Influence.Countries.Influencing[v.Name]) then
				-- Do we have the diplomats?
				if voForeignMinisterData.Diplomats >= Influence.Cost then
					voForeignMinisterData.Diplomats = voForeignMinisterData.Diplomats - Influence.Cost
					P.Command_Influence(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, v.Tag)
				else
					-- We have no more Diplomacy points so exit
					break
				end
			end
		end
	end
end

function P.Command_Influence(voAI, voFromTag, voTargetTag, vbCancel)
--Utils.LUA_DEBUGOUT("Command_Influence")
	local loCommand = CInfluenceNation(voFromTag, voTargetTag)
	
	if vbCancel then
		loCommand:SetValue(false)
		voAI:PostAction(loCommand)
		return true
	elseif loCommand:IsSelectable() then
		voAI:PostAction(loCommand)
		return true
	end
	
	return false
end
function P.Can_Click_Button(voTargetTag, voTargetCountry, voDiploStatus, voForeignMinisterData)
--Utils.LUA_DEBUGOUT("Can_Click_Button")
	local lbInfluence = false
	
	if voTargetTag ~= voForeignMinisterData.Tag then
		if voTargetCountry:Exists() then
			if voTargetTag:IsReal() then
				if voTargetTag:IsValid() then
					if not(voTargetCountry:IsGovernmentInExile()) then
						if not(voTargetCountry:IsPuppet()) then
							if not(voForeignMinisterData.Country:HasDiplomatEnroute(voTargetTag)) then
								if not(voTargetCountry:HasFaction()) then
									if not(voDiploStatus:HasWar()) then
										lbInfluence = true
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	return lbInfluence
end
function P.IsAligning(voTargetTag, voFactionLeaderTag)
	local loCommand = CInfluenceAllianceLeader(voTargetTag, voFactionLeaderTag)
	
	-- Are they already aligning toward us check (true means no)
	if not(loCommand:IsSelectable()) then
		return true
	end										
	
	return false
end


-- ###############################################
-- END OF Support methods
-- ###############################################

return ForeignMinister_Influence