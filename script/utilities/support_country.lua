-----------------------------------------------------------
-- LUA Hearts of Iron 3 Support To Call Functions in Country Files File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/25/2013
-----------------------------------------------------------

local P = {}
Support_Country = P

-- returns function ref if one exists, otherwise null
function P.Has_Function(voTag, vsFunName)
	--Utils.LUA_DEBUGOUT("Has_Function")
	local loCountryFile = _G['AI_' .. tostring(voTag)]
	
	if loCountryFile then
		return loCountryFile[vsFunName]
	end
	
	return nil
end

-- vbActor := Boolean to either Use the Actor or Target variables
-- vsFunName := Name of the function to call
-- voStandardScoreObj := Standard score object
function P.Call_Score_Function(vbActor, vsFunName, voStandardScoreObj, ...)
	--Utils.LUA_DEBUGOUT("Call_Score_Function")
	local loFunRef = P.Get_Score_Function(vbActor, vsFunName, voStandardScoreObj)

	if loFunRef then
		return loFunRef(voStandardScoreObj, ...)
	end
	
	return voStandardScoreObj.Score
end

-- vbActor := Boolean to either Use the Actor or Target variables
-- vsFunName := Name of the function to call
function P.Get_Score_Function(vbActor, vsFunName, voStandardScoreObj)
	--Utils.LUA_DEBUGOUT("Get_Score_Function")
	if vbActor then
		return P.Get_Function(voStandardScoreObj.Actor, vsFunName)
	else
		return P.Get_Function(voStandardScoreObj.Target, vsFunName)
	end
end

-- voStandardTickObj := Standard Tick object, assumes certain variables always exists
-- vsFunName := Name of the function to call
-- ... := Parameters (if any) to be passed to function
function P.Call_Function(voStandardTickObj, vsFunName, ...)
	--Utils.LUA_DEBUGOUT("Call_Function")
	local loFunRef = P.Get_Function(voStandardTickObj, vsFunName)

	if loFunRef then
		return loFunRef(...)
	end
	
	return nil
end

-- voStandardTickObj := Standard Tick object, assumes certain variables always exists
-- vsFunName := Name of the function to call
function P.Get_Function(voStandardTickObj, vsFunName)
	--Utils.LUA_DEBUGOUT("Get_Function")
	local loFunRef = nil
	
	if voStandardTickObj.IsExile then
		loFunRef = P.Has_Function((tostring(voStandardTickObj.Tag) .. '_GIE'), vsFunName)
	elseif voStandardTickObj.IsPuppet then
		loFunRef = P.Has_Function((tostring(voStandardTickObj.Tag) .. '_PUP'), vsFunName)
	else
		loFunRef = P.Has_Function(voStandardTickObj.Tag, vsFunName)
	end
	
	if loFunRef then
		return loFunRef
	else
		if voStandardTickObj.IsExile then
			return P.Has_Function("DEFAULT_GIE", vsFunName)
		elseif voStandardTickObj.IsPuppet then
			return P.Has_Function("DEFAULT_PUP", vsFunName)
		elseif voStandardTickObj.IsNaval then
			return P.Has_Function("DEFAULT_MIXED", vsFunName)
		elseif voStandardTickObj.IsNaval == false then
			return P.Has_Function("DEFAULT_LAND", vsFunName)
		end
	end
	
	return nil
end

return Support_Country