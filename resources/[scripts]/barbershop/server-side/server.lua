-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("barbershop",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateSkin(myClothes)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.execute("playerdata/setUserdata",{ user_id = user_id, key = "Barbershop", value = json.encode(myClothes) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("debug",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent("barbershop:apply",source,vRP.userData(user_id,"Barbershop"))
		TriggerClientEvent("skinshop:apply",source,vRP.userData(user_id,"Clothings"))
		TriggerClientEvent("tattoos:apply",source,vRP.userData(user_id,"Tatuagens"))
		TriggerClientEvent("target:resetDebug",source)

		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)

		local activePlayers = vRPC.activePlayers(source)
		for _,v in ipairs(activePlayers) do
			async(function()
				TriggerClientEvent("syncarea",v,coords["x"],coords["y"],coords["z"],1)
			end)
		end
	end
end)