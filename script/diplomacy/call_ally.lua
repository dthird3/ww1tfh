-----------------------------------------------------------
-- LUA Hearts of Iron 3 Call Ally File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/10/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_CallAlly = P

-- #######################
-- Called by the EXE
-- #######################
function DiploScore_CallAlly(voAI, voActorTag, voRecipientTag, voObserverTag, voCommand)
--Utils.LUA_DEBUGOUT("DiploScore_CallAlly")
	local loDiploScoreObj = {
		Score = 0,														-- Current Score (integer)
		ministerAI = voAI,												-- AI Object
		Year = CCurrentGameState.GetCurrentDate():GetYear(),			-- Current in game Year (integer)
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(),	-- Current in game Month (integer)
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(),		-- Current in game Day (integer)
		Command = voCommand,											-- Command Object
		Actor = {
			Name = tostring(voActorTag),		-- Country Name (String)
			Tag = voActorTag,					-- Country Tag
			Country = voActorTag:GetCountry(),	-- Country Object
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil},					-- Name of the Faction the country belongs to (string)
		Target = {
			Name = tostring(voRecipientTag),	-- Country Name (String)
			Tag = voRecipientTag,				-- Country Tag
			Country = voRecipientTag:GetCountry(), -- Country Object
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile	= nil, 						-- True/False are the in exile
			IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = nil,					-- (integer) Total amount of ports the country has
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			MasterTag = nil}					-- Master Country Tag (if Target has a Master and Targe is a puppet)
	}

	loDiploScoreObj.Actor.HasFaction = loDiploScoreObj.Actor.Country:HasFaction()
	loDiploScoreObj.Actor.Faction = loDiploScoreObj.Actor.Country:GetFaction()
	loDiploScoreObj.Actor.FactionName = tostring(loDiploScoreObj.Actor.Faction:GetTag())
	
	loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
	loDiploScoreObj.Target.FactionName = tostring(loDiploScoreObj.Target.Faction:GetTag())
	loDiploScoreObj.Target.MasterTag = loDiploScoreObj.Target.Country:GetOverlord()

	-- Are they in a faction
	if (loDiploScoreObj.Actor.HasFaction and loDiploScoreObj.Actor.Faction == loDiploScoreObj.Target.Faction)
	or (loDiploScoreObj.Target.MasterTag == loDiploScoreObj.Actor.Tag) then
		loDiploScoreObj.Score = 100
	else
		-- Must be an alliance so return alliance score
		loDiploScoreObj.Score = 0 --DiploScore_Alliance(voAI, voActorTag, voRecipientTag, voObserverTag, nil)
	end

	loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
	loDiploScoreObj.Target.IsPuppet = loDiploScoreObj.Target.Country:IsPuppet()
	loDiploScoreObj.Target.PortsTotal = loDiploScoreObj.Target.Country:GetNumOfPorts()
	loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
	loDiploScoreObj.Target.IsNaval = (loDiploScoreObj.Target.PortsTotal > 0 and loDiploScoreObj.Target.IcOBJ.IC >= 20)
	
	return Support_Country.Call_Score_Function(false, 'DiploScore_CallAlly', loDiploScoreObj)
end

-- #######################
-- Support Methods
-- #######################
function P.CallAlly(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("CallAlly")
	-- Exit there is nothing for us to do here
	if not(voForeignMinisterData.IsAtWar) then
		return
	end

	-- Do nothing if we do not have the diplomats
	if (voForeignMinisterData.Diplomats >= defines.diplomacy.CALLALLY_INFLUENCE_COST) then
		-- Call our Allies in
		local lbProcess = true
		local loFunRef = Support_Country.Get_Function(voForeignMinisterData, "ForeignMinister_CallAlly")
		
		if loFunRef then
			lbProcess = loFunRef(voForeignMinisterData)
		end
		
		if lbProcess then
			-- Get a list of all your allies
			local laAllies = {}
			
			-- First add allies
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
						AllyTag = loAllyTag,
						AllyCountry = loAllyCountry,
						Score = DiploScore_CallAlly(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loAllyTag, loAllyTag, nil)
					}
					laAllies[tostring(loAllyTag)] = loAlly
				end
			end
			
			for loTargetTag in voForeignMinisterData.Country:GetCurrentAtWarWith() do
				if loTargetTag:IsValid() then
					local loRelation = voForeignMinisterData.Country:GetRelation(loTargetTag)
					local loWar = loRelation:GetWar()
					local loTargetCountry = loTargetTag:GetCountry()
					local lbTargetIsMajor = loTargetCountry:IsMajor()
					
					-- if we are fighting a major bring in everyone
					if loWar:IsLimited() and not(lbTargetIsMajor) then
						-- do we want to call in help? 
						if voForeignMinisterData.Desperation > 0.4 then --strengthFactor < 1.4 then
							-- Call in all potential allies
							for k, v in pairs(laAllies) do
								if v.Score > 50 then
									if not(v.AllyCountry:GetRelation(loTargetTag):HasWar()) then
										P.Command_CallAlly(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, v.AllyTag, loTargetTag)
									end
								end
							end
						end
					else -- not-limited, call in any faction members not there
						-- Call in all potential allies
						for k, v in pairs(laAllies) do
							if v.Score > 50 then
								if not(v.AllyCountry:GetRelation(loTargetTag):HasWar()) then
									P.Command_CallAlly(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, v.AllyTag, loTargetTag)
								end
							end
						end
					end
				end
			end
		end
	end
end
function P.Command_CallAlly(vAI, voFromTag, voAllyTag, voTargetTag)
--Utils.LUA_DEBUGOUT("Command_CallAlly")
	-- Call our Ally in
	local loCommand = CCallAllyAction( voFromTag, voAllyTag, voTargetTag)
	loCommand:SetValue(true)
	
	if loCommand:IsSelectable() then
		vAI:PostAction(loCommand)
		return true
	end
	
	return false
end
function P.Execute_CallAlly(vAI, voFromTag, voAllyTag, voTargetTag)
--Utils.LUA_DEBUGOUT("Execute_CallAlly")
	local liScore = DiploScore_CallAlly(vAI, voFromTag, voAllyTag, voAllyTag, nil)

	if liScore > 50 then
		return P.Command_CallAlly(vAI, voFromTag, voAllyTag, voTargetTag)
	end
	
	return false
end
-- ###############################################
-- END OF Support methods
-- ###############################################

return ForeignMinister_CallAlly