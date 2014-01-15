-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/12/2013
-----------------------------------------------------------

-- ###################################
-- # Main Method called by the EXE
-- #####################################
function BalanceProductionSliders(voAI, voCountry, viPrioSelected, vLendLease, vConsumer, vProduction, vSupply, vReinforce, vUpgrade, vbHasReinforceBonus)
	
	--Utils.LUA_DEBUGOUT("BalanceProductionSliders")
	local ProdSliders = {
		ministerAI = voAI,
		Name = nil,
		Tag = voCountry:GetCountryTag(),
		Country = voCountry,
		Year = CCurrentGameState.GetCurrentDate():GetYear(), -- Current in game Year (integer)
		Month = CCurrentGameState.GetCurrentDate():GetMonthOfYear(), -- Current in game Month (integer)
		Day = CCurrentGameState.GetCurrentDate():GetDayOfMonth(), -- Current in game Day (integer)
		IsPuppet = voCountry:IsPuppet(),			-- True/False are they a Puppet Country
		IsExile	= voCountry:IsGovernmentInExile(), 	-- True/False are the in exile
		IsNaval = nil, 								-- True/False do the meet requirements to use the Naval standard file or Land
		IcOBJ = Support_Functions.GetICBreakDown(voCountry),
		PortsTotal = voCountry:GetNumOfPorts(), 	-- (integer) Total amount of ports the country has
		IsAtWar = nil,
		Dissent = nil,
		PrioSelected = { New = viPrioSelected, Ori = viPrioSelected },
		Slider = {
			LendLease = { New = vLendLease, Ori = vLendLease },
			Consumer = { New = vConsumer, Ori = vConsumer },
			Production = { New = vProduction, Ori = vProduction },
			Supply = { New = vSupply, Ori = vSupply },
			Reinforce = { New = vReinforce, Ori = vReinforce },
			Upgrade = { New = vUpgrade, Ori = vUpgrade },
		},		
		PriorityOrder = {
			[0] = { 'Consumer', 'Supply', 'LendLease', 'Reinforce', 'Production', 'Upgrade' },
			[1] = { 'Consumer', 'Supply', 'LendLease', 'Production', 'Reinforce', 'Upgrade' },
			[2] = { 'Consumer', 'Supply', 'LendLease', 'Upgrade', 'Reinforce', 'Production' },
			[3] = { 'Consumer', 'Supply', 'LendLease', 'Reinforce', 'Upgrade', 'Production' },
			[4] = { 'Consumer', 'Reinforce', 'Supply', 'LendLease', 'Production', 'Upgrade' }
		},
		Supply = {
			Pool = nil
		}
	}
	
	ProdSliders.Name = tostring(ProdSliders.Tag)
	ProdSliders.IsNaval = (ProdSliders.PortsTotal > 0 and ProdSliders.IcOBJ.IC >= 20)
	ProdSliders.IsAtWar = ProdSliders.Country:IsAtWar()
	ProdSliders.Dissent = ProdSliders.Country:GetDissent():Get()
	ProdSliders.Supply.Pool = ProdSliders.Country:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get()
	
	-- If country just started mobilizing (or gets bonus reinforcements for some other reason), boost reinforcements
	if ( ProdSliders.PrioSelected.Ori == 0 or ProdSliders.PrioSelected.Ori == 3 )then
		if vbHasReinforceBonus then
			ProdSliders.PrioSelected.New = 4
		end
	end
	
	-- If Dissent is present add 10% to the Production of Consumer Goods
	if ProdSliders.Dissent > 0.01 then -- fight dissent 
		ProdSliders.Slider.Consumer.New = ProdSliders.Slider.Consumer.New + 0.1
	end
	
	if ProdSliders.Slider.Supply.New > 0 then
		local liSupplyBase = math.min((ProdSliders.IcOBJ.TotalIC * 150), 50000) -- Base Supply goal cap of 50k
		
		local loSupplyRules = {
			pile_1 = { pool = 1.0, slider = 0 },
			pile_2 = { pool = 0.8, slider = 0.5 },
			pile_4 = { pool = 0.74, slider = 0.6 },
			pile_5 = { pool = 0.7, slider = 0.7 },
			pile_6 = { pool = 0.64, slider = 0.99 },
			pile_7 = { pool = 0.6, slider = 1.0 },
			pile_8 = { pool = 0.56, slider = 1.02 },
			pile_default = { pool = 0, slider = 1.15 },
		}
	
		local loCSupplyRule = loSupplyRules.pile_default
		
		for k, v in pairs(loSupplyRules) do
			if (v.pool * liSupplyBase) <= ProdSliders.Supply.Pool and loCSupplyRule.pool < v.pool then
				loCSupplyRule = v
			end
		end
	
		ProdSliders.Slider.Supply.New = ProdSliders.Slider.Supply.New * loCSupplyRule.slider
	end

	-- Lend-Lease priority
	if (ProdSliders.PrioSelected.Ori == 0) then 
		-- If we have no lease then no point in going in here
		--   OR if the decision to shut lease off fired dont go in here
		if ProdSliders.Country:HasActiveLendLeaseToAnyone() 
		and not(ProdSliders.Country:GetFlags():IsFlagSet("ai_turn_off_lend_lease")) then
			local lbProcess = true
			local liMaxLLPercentage = 0
			local loFunRef = Support_Country.Get_Function(ProdSliders, "Prod_LendLease")
			
			-- Custom method check it
			if loFunRef then
				lbProcess, liMaxLLPercentage = loFunRef(ProdSliders)
			end
			
			if lbProcess then
				if ProdSliders.IsAtWar then
					liMaxLLPercentage = 0.1
				else
					liMaxLLPercentage = 0.3
				end
			end
			
			ProdSliders.Slider.LendLease.New = ProdSliders.Country:GetMaxLendLeaseFraction():Get() * liMaxLLPercentage
		else
			ProdSliders.Slider.LendLease.New = 0
		end
	end

	local liLeftOver = 1.0
	
	-- Normalize the distribution
	for i = 1, 6, 1 do
		if liLeftOver >= ProdSliders.Slider[ProdSliders.PriorityOrder[ProdSliders.PrioSelected.New][i]].New then
			liLeftOver = liLeftOver - ProdSliders.Slider[ProdSliders.PriorityOrder[ProdSliders.PrioSelected.New][i]].New
		else
			ProdSliders.Slider[ProdSliders.PriorityOrder[ProdSliders.PrioSelected.New][i]].New = liLeftOver
			liLeftOver = 0
		end
	end
	
	if ProdSliders.PrioSelected.Ori == 0 then
		local liProdUpgradeTotalPercentage = ProdSliders.Slider.Upgrade.New + ProdSliders.Slider.Production.New + liLeftOver
		
		-- If the total needed for Upgrading exceedes the total amount available between
		--   Production and Upgrades then divide the number in half so something gets produced.
		if ProdSliders.IsAtWar or ProdSliders.Year >= 1914 then
			if (ProdSliders.Slider.Upgrade.Ori > liProdUpgradeTotalPercentage)
			or (ProdSliders.Slider.Upgrade.Ori > (liProdUpgradeTotalPercentage * 0.75)) then
					ProdSliders.Slider.Upgrade.New = (liProdUpgradeTotalPercentage * 0.75)
					ProdSliders.Slider.Production.New = (liProdUpgradeTotalPercentage * 0.25)
			-- Upgrades is covered put everything extra into Production
			else
				ProdSliders.Slider.Upgrade.New = ProdSliders.Slider.Upgrade.Ori
				ProdSliders.Slider.Production.New = liProdUpgradeTotalPercentage - ProdSliders.Slider.Upgrade.Ori
			end
		else
			if (ProdSliders.Slider.Upgrade.Ori > liProdUpgradeTotalPercentage)
			or (ProdSliders.Slider.Upgrade.Ori > (liProdUpgradeTotalPercentage * 0.25)) then
					ProdSliders.Slider.Upgrade.New = (liProdUpgradeTotalPercentage * 0.25)
					ProdSliders.Slider.Production.New = (liProdUpgradeTotalPercentage * 0.75)
			-- Upgrades is covered put everything extra into Production
			else
				ProdSliders.Slider.Upgrade.New = ProdSliders.Slider.Upgrade.Ori
				ProdSliders.Slider.Production.New = liProdUpgradeTotalPercentage - ProdSliders.Slider.Upgrade.Ori
			end
		end
	else
		-- We have some dessent so put extra IC to lower it
		if ProdSliders.Dissent > 0.01 then
			ProdSliders.Slider.Consumer.New = ProdSliders.Slider.Consumer.New + liLeftOver
		else
			ProdSliders.Slider.Production.New = ProdSliders.Slider.Production.New + liLeftOver
		end
	end

	local liCheckSum = 0
	for k, v in pairs(ProdSliders.Slider) do
		liCheckSum = liCheckSum + math.abs(v.New - v.Ori)
	end

	-- Make sure there was a change before we send the command up
	if liCheckSum > 0.01 then
		local loCommand = CChangeInvestmentCommand(ProdSliders.Tag, 
													ProdSliders.Slider.LendLease.New, 
													ProdSliders.Slider.Consumer.New, 
													ProdSliders.Slider.Production.New, 
													ProdSliders.Slider.Supply.New, 
													ProdSliders.Slider.Reinforce.New, 
													ProdSliders.Slider.Upgrade.New)
		ProdSliders.ministerAI:Post(loCommand)
	end
end


-- ###################################
-- # Main Method called by the EXE
-- #####################################
function BalanceLendLeaseSliders(voAI, voCountry, voLengLeaseTags, voLendLeaseValues)
		--Utils.LUA_DEBUGOUT("BalanceLendLeaseSliders")
	local LeaseSliderData = {
		Name = tostring(loCountryTag),
		Tag = voCountry:GetCountryTag(),
		Country = voCountry,
		IsPuppet = voCountry:IsPuppet(),			-- True/False are they a Puppet Country
		IsExile	= voCountry:IsGovernmentInExile(), 	-- True/False are the in exile
		IsNaval = nil, 								-- True/False do the meet requirements to use the Naval standard file or Land
		IcOBJ = Support_Functions.GetICBreakDown(voCountry),
		PortsTotal = voCountry:GetNumOfPorts(), 	-- (integer) Total amount of ports the country has
		TotalIC = 0,	-- Total amount of IC the countries who want Lend Lease have
		LeaseCountryTags = voLengLeaseTags, -- Array of Country tags sent from the EXE
		CountryCount = voLengLeaseTags:GetSize(), -- How many countries have Lend Lease agreement (integer)
		DiviserCount = 0,	-- How many records have (Locked = false) (integer)
		Countries = {}		-- Array of Country tables that have Lend Lease agreements
	}
	
	LeaseSliderData.DiviserCount = LeaseSliderData.CountryCount
	LeaseSliderData.IsNaval = (LeaseSliderData.PortsTotal > 0 and LeaseSliderData.IcOBJ.IC >= 20)
	
	-- Break the countries down
	for i=0, (LeaseSliderData.CountryCount-1) do
		local loCountry = {
			Name = nil,			-- Name of the county (string)
			IndexID = i,		-- Index ID to be used when sending the record back to the EXE
			Tag = voLengLeaseTags:GetAt(i),	-- Country Tag Object
			Country = nil,		-- Country Object
			Locked = false,		-- True/False means that any percentage adjustments are not effecting this country
			IcOBJ = nil,		-- IC Object from Support_Functions.GetICBreakDown
			Percentage = 0,		-- Percentage of Lend Lease they will get
			ModPercentage = 0	-- Modified percentage of Lend Lease the will get
		}
		
		loCountry.Name = tostring(loCountry.Tag)
		loCountry.Country = loCountry.Tag:GetCountry()
		loCountry.IcOBJ = Support_Functions.GetICBreakDown(loCountry.Country)
		
		LeaseSliderData.TotalIC = LeaseSliderData.TotalIC + loCountry.IcOBJ.IC
		LeaseSliderData.Countries[loCountry.Name] = loCountry
	end
	
	-- Now Calculate percentages
	for k, v in pairs(LeaseSliderData.Countries) do
		if v.IcOBJ.IC > 0 then
			v.Percentage = v.IcOBJ.IC / LeaseSliderData.TotalIC
			v.ModPercentage = v.Percentage
		end
	end
	
	local loFunRef = Support_Country.Get_Function(LeaseSliderData, "LendLease_Distribution")
	
	-- Custom method check it
	if loFunRef then
		LeaseSliderData = loFunRef(LeaseSliderData)
	end
	
	-- If the two do not equal then that means we need to normalize
	if LeaseSliderData.DiviserCount ~= LeaseSliderData.CountryCount then
		-- Use as a new base IC instead of TotalIC base
		local liModifiedTotal = 0

		-- First add new Percentage Total
		for k, v in pairs(LeaseSliderData.Countries) do
			liModifiedTotal = liModifiedTotal + (v.ModPercentage * LeaseSliderData.TotalIC)
		end

		-- If new total > than old we need to normalize
		if liModifiedTotal > LeaseSliderData.TotalIC then
			local liNotLockedTotal = 0
			
			-- Look at non-locked countries
			for k, v in pairs(LeaseSliderData.Countries) do
				if not(v.Locked) then
					liNotLockedTotal = liNotLockedTotal + (v.ModPercentage * LeaseSliderData.TotalIC)
				end
			end
			
			if liNotLockedTotal > liModifiedTotal then
				-- Non-locked are higher so just normalize them and leave locked alone
				for k, v in pairs(LeaseSliderData.Countries) do
					if not(v.Locked) then
						v.ModPercentage = ((v.ModPercentage * LeaseSliderData.TotalIC) / liModifiedTotal)
					end
				end
			else
				liModifiedTotal = liModifiedTotal - liNotLockedTotal
				
				for k, v in pairs(LeaseSliderData.Countries) do
					-- Normalize the locked countries
					if v.Locked then
						v.ModPercentage = ((v.ModPercentage * LeaseSliderData.TotalIC) / liModifiedTotal)
						
					-- Set all non-locked to 0 as the locked are taking everything
					else
						v.ModPercentage = 0
					end
				end
			end
		end
	end
	
	-- Figure out the percentages
	for k, v in pairs(LeaseSliderData.Countries) do
		local liFinalValue = LeaseSliderData.TotalIC * v.ModPercentage
		voLendLeaseValues:SetAt(v.IndexID, CFixedPoint(liFinalValue)) -- it gets normalized anyway
	end

	-- Do this to confirm LL sliders distribution
	local loCommand = CChangeLendLeaseDistributionCommand(LeaseSliderData.Tag)
	loCommand:SetData(voLengLeaseTags, voLendLeaseValues)
	voAI:Post(loCommand)
end