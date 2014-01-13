-----------------------------------------------------------
-- LUA Hearts of Iron 3 Laws File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 3/21/2013
-----------------------------------------------------------
local P = {}
Politics_Laws = P

-- #######################
-- Called by politics.lua
-- #######################
function P.ChangeLaws(voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("ChangeLaws")
	-- Positions definitions
	-- Each position has an index, a callback function, a government position index, and a list of available CMinister objects
	-- We assert the existance of 8 changeable positions, and bind them to a lua callback function
	local loLaws = {
		civil_law = {
			Callback = P.CivilLaw,
			range_low = 1,
			range_high = 5,
			laws = {
				OPEN_SOCIETY = 1,
				LIMITED_RESTRICTIONS = 2,
				LEGALISTIC_RESTRICTIONS = 3,
				REPRESSION = 4,
				TOTALITARIAN_SYSTEM = 5
			}
		},
		conscription_law = {
			Callback = P.Get_Highest, 
			range_low = 6,
			range_high = 10,
			laws = {
				VOLUNTEER_ARMY = 6,
				RECRUIT_RANGE_ONE = 7,
				RECRUIT_RANGE_TWO = 8,
				RECRUIT_RANGE_THREE = 9,
				RECRUIT_RANGE_FOUR = 10
			}
		},
		economic_law = {
			Callback = P.Get_Highest, 
			range_low = 11,
			range_high = 15,
			laws = {
				FULL_CIVILIAN_ECONOMY = 11,
				BASIC_MOBILISATION = 12,
				FULL_MOBILISATION = 13,
				WAR_ECONOMY = 14,
				TOTAL_ECONOMIC_MOBILISATION = 15
			}
		},
		education_investment_law = {
			Callback = P.Get_Highest, 
			range_low = 16,
			range_high = 19,
			laws = {
				MINIMAL_EDUCATION_INVESTMENT = 16,
				AVERAGE_EDUCATION_INVESTMENT = 17,
				MEDIUM_LARGE_EDUCATION_INVESTMENT = 18,
				BIG_EDUCATION_INVESTMENT = 19
			}
		},
		industrial_policy_laws = {
			Callback = P.IndustrialPolicies, 
			range_low = 20,
			range_high = 22,
			laws = {
				CONSUMER_PRODUCT_ORIENTATION = 20,
				MIXED_INDUSTRY = 21,
				HEAVY_INDUSTRY_EMPHASIS = 22
			}
		},
		press_laws = {
			Callback = P.PressLaws, 
			range_low = 23,
			range_high = 26,
			laws = {
				FREE_PRESS = 23,
				CENSORED_PRESS = 24,
				STATE_PRESS = 25,
				PROPAGANDA_PRESS = 26
			}
		},
		training_laws = {
			Callback = P.TrainingLaws, 
			range_low = 27,
			range_high = 30,
			laws = {
				MINIMAL_TRAINING = 27,
				BASIC_TRAINING = 28,
				ADVANCED_TRAINING = 29,
				SPECIALIST_TRAINING = 30
			}
		}
	}
	
	for loGroup in CLawDataBase.GetGroups() do
		local lsGroupName = tostring(loGroup:GetKey())
		
		if loLaws[lsGroupName] then
			local loNewLaw = nil
			local loCurrentLaw = voPoliticsMinisterData.Country:GetLaw(loGroup)
			
			local lbProcess = true
			local loFunRef = Support_Country.Get_Function(voPoliticsMinisterData, "ChangeLaw_" .. lsGroupName)
			
			-- Custom method check it
			if loFunRef then
				lbProcess, loNewLaw = loFunRef(loLaws[lsGroupName], loCurrentLaw, voPoliticsMinisterData)
			end	
			
			if lbProcess then
				loNewLaw = loLaws[lsGroupName].Callback(loCurrentLaw, loLaws[lsGroupName], voPoliticsMinisterData)
			end
			
			if loNewLaw ~= nil then
				if loNewLaw:GetIndex() ~= loCurrentLaw:GetIndex() then
					if loNewLaw:ValidFor(voPoliticsMinisterData.Tag) then
						P.Command_ChangeLaw(voPoliticsMinisterData.Tag, loNewLaw, loGroup)
					end
				end
			end
		end
	end
end

-- #######################
-- Support Methods
-- #######################
function P.Command_ChangeLaw(voFromTag, voNewLaw, voGroup)
--Utils.LUA_DEBUGOUT("Command_ChangeLaw")
	local loCommand = CChangeLawCommand(voFromTag, voNewLaw, voGroup)
	loCommand:SetEnablePostMessage(true)
	CCurrentGameState.Post(loCommand)
	return true
end
-- ###############################################
-- END OF Support methods
-- ###############################################

--################
-- Scoring Methods
--################
function P.Get_Highest(voCurrentLaw, voLaw, voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("Get_Highest")
	local loNewLaw = nil
	local liCurrentLawIndex = voCurrentLaw:GetIndex()
	
	if liCurrentLawIndex ~= voLaw.range_high then
		local liCurrentGroupIndex = voCurrentLaw:GetGroup():GetIndex()
		
		for i = (liCurrentLawIndex + 1), voLaw.range_high do
			loPotentialLaw = CLawDataBase.GetLaw(i)
			
			if liCurrentGroupIndex ~= loPotentialLaw:GetGroup():GetIndex() then 
				break -- Something is wrong and the LUA is not matching with the /common/laws.txt file
				
			elseif loPotentialLaw:ValidFor(voPoliticsMinisterData.Tag) then
				loNewLaw = loPotentialLaw
			end
		end
	end
	
	return loNewLaw
end
function P.CivilLaw(voCurrentLaw, voLaw, voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("CivilLaw")
	-- Performance Check do we really need to do anything?
	-- Switch Democracies back to Open Society if no longer atwar!
	if not(voPoliticsMinisterData.IsAtWar)
	and voPoliticsMinisterData.IdeologyGroupName == "democracy" then
		return CLawDataBase.GetLaw(voLaw.laws.OPEN_SOCIETY)
	else
		return P.Get_Highest(voCurrentLaw, voLaw, voPoliticsMinisterData)
	end
end
function P.IndustrialPolicies(voCurrentLaw, voLaw, voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("IndustrialPolicies")
	-- Peace get the break from the CG hit
	if not(voPoliticsMinisterData.IsAtWar) then
		return CLawDataBase.GetLaw(voLaw.laws.CONSUMER_PRODUCT_ORIENTATION)
	else
		return P.Get_Highest(voCurrentLaw, voLaw, voPoliticsMinisterData)
	end
end
function P.PressLaws(voCurrentLaw, voLaw, voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("PressLaws")
	-- Performance Check do we really need to do anything?
	-- Switch Democracies back to Free Press if no longer atwar!
	if not(voPoliticsMinisterData.IsAtWar) 
	and voPoliticsMinisterData.IdeologyGroupName == "democracy" then
		return CLawDataBase.GetLaw(voLaw.laws.FREE_PRESS)
	else
		return P.Get_Highest(voCurrentLaw, voLaw, voPoliticsMinisterData)
	end
end
function P.TrainingLaws(voCurrentLaw, voLaw, voPoliticsMinisterData)
--Utils.LUA_DEBUGOUT("TrainingLaws")
	local loLawRule = {
		MINIMAL_TRAINING = { IC = 0 },
		BASIC_TRAINING = { IC = 35 },
		ADVANCED_TRAINING = { IC = 90 },
		SPECIALIST_TRAINING = { IC = 140 }
	}
	
	local lsNewLaw = nil
	
	for k, v in pairs(loLawRule) do 
		if not(lsNewLaw) then
			lsNewLaw = k
		elseif voPoliticsMinisterData.IcOBJ.Base > v.IC and loLawRule[lsNewLaw].IC < v.IC then
			lsNewLaw = k
		end
	end
	
	return CLawDataBase.GetLaw(voLaw.laws[lsNewLaw])
end

--################
-- End of Scoring Methods
--################

return Politics_Laws
