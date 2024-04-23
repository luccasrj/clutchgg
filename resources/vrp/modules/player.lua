-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local identity = vRP.userIdentity(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable then

		if dataTable["health"] == nil then
			dataTable["health"] = 200
		end

		Citizen.Wait(1000)

		vRPC.applySkin(source,dataTable["skin"])
		vRPC.setHealth(source,dataTable["health"])

		Citizen.Wait(1000)

		TriggerClientEvent("barbershop:apply",source,vRP.userData(user_id,"Barbershop"))
		TriggerClientEvent("skinshop:apply",source,vRP.userData(user_id,"Clothings"))
		TriggerClientEvent("tattoos:apply",source,vRP.userData(user_id,"Tatuagens"))

		Citizen.Wait(1000)
		
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryDeleteObject")
AddEventHandler("tryDeleteObject",function(entIndex)
	TriggerClientEvent("player:deleteObject",-1,entIndex)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET POLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getPolice()
	local source = source
	local userId = vRP.getUserId(source)
	if userId then
		return exports["common"]:Group().hasPermission(userId,"police")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getHealth(source)
	return GetEntityHealth(GetPlayerPed(source))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODELPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.modelPlayer(source)
	local ped = GetPlayerPed(source)
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		return "mp_m_freemode_01"
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		return "mp_f_freemode_01"
	end
end
