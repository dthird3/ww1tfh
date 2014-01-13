-----------------------------------------------------------
-- LUA Hearts of Iron 3 Allow Debts File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/10/2013
-----------------------------------------------------------
local P = {}
ForeignMinister_Debt = P

-- #######################
-- Called by the EXE
-- #######################
function DiploScore_Debt(voAI, voActorTag, voRecipientTag, voObserverTag)
--Utils.LUA_DEBUGOUT("DiploScore_Debt")
	local loDiploScoreObj = {
		Score = 0,														-- Current Score (integer)
		ministerAI = voAI,												-- AI Object
		Year = CCurrentGameState.GetCurrentDate():GetYear(),			-- Current in game Year (integer)
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(),	-- Current in game Month (integer)
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(),		-- Current in game Day (integer)
		Resource = nil,													-- Resource Object, used to get resource counts etc...
		Actor = {
			Name = tostring(voActorTag),		-- Country Name (String)
			Tag = voActorTag,					-- Country Tag
			Country = voActorTag:GetCountry(),	-- Country Object
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			Money = {},							-- Money Object has two sub fields (DailyBalance = daily change, Pool = Current amount in the pool)
			IsAtWar = nil},						-- True/False is this country a at war
		Target = {
			Name = tostring(voRecipientTag),	-- Country Name (String)
			Tag = voRecipientTag,				-- Country Tag
			Country = voRecipientTag:GetCountry(), -- Country Object
			IsPuppet = nil, 					-- True/False are they a Puppet Country
			IsExile	= nil, 						-- True/False are the in exile
			IsNaval = nil, 						-- True/False do the meet requirements to use the Naval standard file or Land
			IcOBJ = nil,						-- IC Object from Support_Functions.GetICBreakDown
			PortsTotal = nil,					-- (integer) Total amount of ports the country has
			OverlordTag = nil,					-- Country Tag for the Master of this puppet (IsPuppet must be true)
			IsActorOverlord = nil,				-- True/False is the Actor the Overlord of this country (puppet Master)
			HasFaction = nil,					-- True/False does the country have a faction
			Faction = nil,						-- Faction Object the country belongs to
			FactionName = nil,					-- Name of the Faction the country belongs to (string)
			Money = {},							-- Money Object has two sub fields (DailyBalance = daily change, Pool = Current amount in the pool)
			HasAlliance = nil,					-- True/False does Actor/Target have an Alliance
			Relation = nil}						-- Relation Object between Actor/Target
	}

	loDiploScoreObj.Target.IsPuppet = loDiploScoreObj.Target.Country:IsPuppet()

	-- If they are our puppet we can then Allow Debt
	if loDiploScoreObj.Target.IsPuppet then
		loDiploScoreObj.Target.OverlordTag = loDiploScoreObj.Target.Country:GetOverlord()
		
		if loDiploScoreObj.Target.OverlordTag == loDiploScoreObj.Actor.Tag then
			loDiploScoreObj.Target.IsActorOverlord = true
			loDiploScoreObj.Score = 100
		else
			return 0 -- You can't allow debt to a puppet of another nation
		end
	end

	loDiploScoreObj.Actor.IsAtWar = loDiploScoreObj.Actor.Country:IsAtWar()

	loDiploScoreObj.Target.IsExile = loDiploScoreObj.Target.Country:IsGovernmentInExile()
	loDiploScoreObj.Target.PortsTotal = loDiploScoreObj.Target.Country:GetNumOfPorts()
	loDiploScoreObj.Target.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Target.Country)
	loDiploScoreObj.Target.IsNaval = (loDiploScoreObj.Target.PortsTotal > 0 and loDiploScoreObj.Target.IcOBJ.IC >= 20)
	
	-- You can't Allow Debt to puppets of another country
	if loDiploScoreObj.Actor.IsAtWar and not(loDiploScoreObj.Target.IsPuppet)  then
		loDiploScoreObj.Target.HasFaction = loDiploScoreObj.Target.Country:HasFaction()
		loDiploScoreObj.Target.Relation = loDiploScoreObj.Target.Country:GetRelation(loDiploScoreObj.Actor.Tag)
		loDiploScoreObj.Target.HasAlliance = loDiploScoreObj.Target.Relation:HasAlliance()
		
		loDiploScoreObj.Score = 1
		
		if loDiploScoreObj.Target.HasFaction or loDiploScoreObj.Target.HasAlliance then
			loDiploScoreObj.Actor.Faction = loDiploScoreObj.Actor.Country:GetFaction()
			loDiploScoreObj.Actor.FactionName = tostring(loDiploScoreObj.Actor.Faction:GetTag())
			
			loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
			loDiploScoreObj.Target.FactionName = tostring(loDiploScoreObj.Target.Faction:GetTag())
			loDiploScoreObj.Score = 2
			
			if (loDiploScoreObj.Target.HasFaction and loDiploScoreObj.Actor.Faction == loDiploScoreObj.Target.Faction)
			or (loDiploScoreObj.Target.HasAlliance) then
				loDiploScoreObj.Resource = CResourceValues()
				
				loDiploScoreObj.Resource:GetResourceValues(loDiploScoreObj.Actor.Country, CGoodsPool._MONEY_)
				loDiploScoreObj.Actor.Money.DailyBalance = loDiploScoreObj.Resource.vDailyBalance
				loDiploScoreObj.Actor.Money.Pool = loDiploScoreObj.Resource.vPool
				loDiploScoreObj.Actor.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Actor.Country)

				loDiploScoreObj.Resource:GetResourceValues(loDiploScoreObj.Target.Country, CGoodsPool._MONEY_)
				loDiploScoreObj.Target.Money.DailyBalance = loDiploScoreObj.Resource.vDailyBalance
				loDiploScoreObj.Target.Money.Pool = loDiploScoreObj.Resource.vPool

				loDiploScoreObj.Score = 3
				
				-- Make sure they have a money reserve to even allow the debt
				if (loDiploScoreObj.Target.IcOBJ.IC * 1.5) <= loDiploScoreObj.Actor.IcOBJ.IC then
					if loDiploScoreObj.Target.Money.DailyBalance < 0.5 and loDiploScoreObj.Actor.Money.DailyBalance > 0.5 then
						if loDiploScoreObj.Target.Money.Pool < 500 and loDiploScoreObj.Actor.Money.Pool > 500 then
							loDiploScoreObj.Score = 100
						end
					end				
				end
			end
		end
	end
	
	local loFunRef = Support_Country.Get_Score_Function(false, 'DiploScore_Debt', loDiploScoreObj)
	
	if loFunRef then
		-- Object was not initalized so setup everything
		if loDiploScoreObj.Score < 3 or loDiploScoreObj.Target.IsActorOverlord then
			loDiploScoreObj.Target.HasFaction = loDiploScoreObj.Target.Country:HasFaction()
			loDiploScoreObj.Target.Relation = loDiploScoreObj.Target.Country:GetRelation(loDiploScoreObj.Actor.Tag)
			loDiploScoreObj.Target.HasAlliance = loDiploScoreObj.Target.Relation:HasAlliance()
			loDiploScoreObj.Actor.Faction = loDiploScoreObj.Actor.Country:GetFaction()
			loDiploScoreObj.Actor.FactionName = tostring(loDiploScoreObj.Actor.Faction:GetTag())
			loDiploScoreObj.Target.Faction = loDiploScoreObj.Target.Country:GetFaction()
			loDiploScoreObj.Target.FactionName = tostring(loDiploScoreObj.Target.Faction:GetTag())

			loDiploScoreObj.Resource = CResourceValues()
			loDiploScoreObj.Resource:GetResourceValues(loDiploScoreObj.Actor.Country, CGoodsPool._MONEY_)
			loDiploScoreObj.Actor.Money.DailyBalance = loDiploScoreObj.Resource.vDailyBalance
			loDiploScoreObj.Actor.Money.Pool = loDiploScoreObj.Resource.vPool
			loDiploScoreObj.Actor.IcOBJ = Support_Functions.GetICBreakDown(loDiploScoreObj.Actor.Country)

			loDiploScoreObj.Resource:GetResourceValues(loDiploScoreObj.Target.Country, CGoodsPool._MONEY_)
			loDiploScoreObj.Target.Money.DailyBalance = loDiploScoreObj.Resource.vDailyBalance
			loDiploScoreObj.Target.Money.Pool = loDiploScoreObj.Resource.vPool
		end
	
		loDiploScoreObj.Score = loFunRef(loDiploScoreObj)
	end
	
	if loDiploScoreObj.Score < 50 then
		loDiploScoreObj.Score = 0 -- Clamp the score down
	end
	
	return loDiploScoreObj.Score
end

-- #######################
-- Support Methods
-- #######################
function P.AllowDebt(voForeignMinisterData)
--Utils.LUA_DEBUGOUT("AllowDebt")
	-- Do we have enough Diplomats send an Allow Debt Request
	if (voForeignMinisterData.Diplomats >= defines.diplomacy.ALLOW_DEBT_INFLUENCE_COST) then
		-- Puppets can never ask to be allowed debt
		if not(voForeignMinisterData.Country:IsPuppet()) then
			for loTargetCountry in CCurrentGameState.GetCountries() do
				local loTarget = {
					Tag = loTargetCountry:GetCountryTag(),
					Country = loTargetCountry,
					Score = 0,
					FinalScore = 0,
					SpamPenalty = 0,
					Relation = nil}
					
				loTarget.Country = loTarget.Tag:GetCountry()
				loTarget.Relation = loTarget.Country:GetRelation(voForeignMinisterData.Tag)
				
				if P.Can_Click_Button(loTarget, voForeignMinisterData) then
					-- Can we get them to let us have debt
					if not(loTarget.Relation:AllowDebts()) then 
						loTarget.Score = DiploScore_Debt(voForeignMinisterData.ministerAI, voForeignMinisterData.Tag, loTarget.Tag, nil)
						loTarget.SpamPenalty = voForeignMinisterData.ministerAI:GetSpamPenalty(loTarget.Tag)
						loTarget.FinalScore = loTarget.Score - loTarget.SpamPenalty
						
						if loTarget.FinalScore > 70 then -- Send the Allow debt
							P.Command_AllowDebt(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, false, loTarget.FinalScore)
						end
					-- We are letting them get Debt with us make sure thats ok
					else
						loTarget.Score = DiploScore_Debt(voForeignMinisterData.ministerAI, loTarget.Tag, voForeignMinisterData.Tag, nil)
						
						if loTarget.Score < 50 then -- Cancel Allow Debt
							P.Command_AllowDebt(voForeignMinisterData.minister, voForeignMinisterData.Tag, loTarget.Tag, true, 100)
						end
					end
				end
			end
		end
	end
end
function P.Command_AllowDebt(voMinister, voFromTag, voTargetTag, vbCancel, viScore)
--Utils.LUA_DEBUGOUT("Command_AllowDebt")
	local loCommand = CDebtAction(voFromTag, voTargetTag)
	
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
				if not(voTarget.Country:IsPuppet()) or voTarget.Country:GetOverlord() == voForeignMinisterData.Tag then
					if not(voTarget.Relation:HasWar()) then
						if not(voForeignMinisterData.Country:HasDiplomatEnroute(voTarget.Tag)) then
							return true
						end
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

return ForeignMinister_Debt