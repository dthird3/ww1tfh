-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production Elite File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/13/2013
-----------------------------------------------------------

local P = {}
Prod_Elite = P

function P.Build(voProductionData, viIC)
--Utils.LUA_DEBUGOUT("EliteBuild")
	local EliteObj = {
		Ratio = Support_Country.Call_Function(voProductionData, "EliteUnits", voProductionData),
		ActualRatio = {}
	}

	if EliteObj.Ratio ~= nil then
		-- Setup Elite Units and add them to the Regular Land Array but with a priority of 0
		for k, v in pairs(EliteObj.Ratio) do
			voProductionData.Units[v].Need = voProductionData.Country:CountMaxUnitsStillBuildable(CSubUnitDataBase.GetSubUnit(v))
			EliteObj.ActualRatio[v] = -999
		end

		local liNewICCount
		voProductionData, liNewICCount = Prod_Units.ProcessUnits(voProductionData, viIC, EliteObj.ActualRatio)
		voProductionData.IC.Allocated = voProductionData.IC.Allocated - (viIC - liNewICCount)
		voProductionData.IC.Available = voProductionData.IC.Allocated - voProductionData.IC.Used
	end

	return voProductionData
end

return Prod_Elite