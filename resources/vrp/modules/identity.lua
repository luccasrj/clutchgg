-----------------------------------------------------------------------------------------------------------------------------------------
-- USERIDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userIdentity(user_id)
	local rows = vRP.getInformation(user_id)
	return rows[1]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userPlate(vehPlate)
	local rows = vRP.query("vehicles/plateVehicles",{ plate = vehPlate })
	if rows[1] then
		return rows[1]["user_id"]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInformation(user_id)
	return vRP.query("characters/getUsers",{ id = parseInt(user_id) })
end