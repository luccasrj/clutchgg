-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("player",cRP)
vSERVER = Tunnel.getInterface("player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
local weaAttachs = {
	["WEAPON_PISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_HEAVYPISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_PISTOL_MK2"] = {
		"COMPONENT_AT_PI_RAIL",
		"COMPONENT_AT_PI_FLSH_02",
		"COMPONENT_AT_PI_COMP"
	},
	["WEAPON_COMBATPISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_APPISTOL"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_MICROSMG"] = {
		"COMPONENT_AT_PI_FLSH",
		"COMPONENT_AT_SCOPE_MACRO"
	},
	["WEAPON_SMG"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02",
		"COMPONENT_AT_PI_SUPP"
	},
	["WEAPON_ASSAULTSMG"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO",
		"COMPONENT_AT_AR_SUPP_02"
	},
	["WEAPON_COMBATPDW"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_AR_AFGRIP",
		"COMPONENT_AT_SCOPE_SMALL"
	},
	["WEAPON_PUMPSHOTGUN"] = {
		"COMPONENT_AT_AR_FLSH"
	},
	["WEAPON_CARBINERIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_CARBINERIFLE_CLIP_02",
		"COMPONENT_AT_AR_AFGRIP",
		"COMPONENT_AT_SCOPE_MEDIUM"
	},
	["WEAPON_CARBINERIFLE_MK2"] = {
		"COMPONENT_CARBINERIFLE_MK2_CLIP_02",
		"COMPONENT_AT_AR_AFGRIP_02",
		"COMPONENT_AT_SCOPE_MEDIUM_MK2",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_ASSAULTRIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO",
		"COMPONENT_AT_AR_AFGRIP"
	},
	["WEAPON_MACHINEPISTOL"] = {
		"COMPONENT_AT_PI_SUPP"
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		"COMPONENT_AT_AR_AFGRIP_02",
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM_MK2",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_PISTOL50"] = {
		"COMPONENT_AT_PI_FLSH"
	},
	["WEAPON_SNSPISTOL_MK2"] = {
		"COMPONENT_AT_PI_FLSH_03",
		"COMPONENT_AT_PI_RAIL_02",
		"COMPONENT_AT_PI_COMP_02"
	},
	["WEAPON_SMG_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_BULLPUPRIFLE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_SMALL",
		"COMPONENT_AT_AR_SUPP"
	},
	["WEAPON_BULLPUPRIFLE_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MACRO_02_MK2",
		"COMPONENT_AT_MUZZLE_01"
	},
	["WEAPON_SPECIALCARBINE"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM",
		"COMPONENT_AT_AR_AFGRIP"
	},
	["WEAPON_SPECIALCARBINE_MK2"] = {
		"COMPONENT_AT_AR_FLSH",
		"COMPONENT_AT_SCOPE_MEDIUM_MK2",
		"COMPONENT_AT_MUZZLE_01"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local attachList = {}
local colorList = {}
--[[ -----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("attachs",function(source,args)
 	local ped = PlayerPedId()
	for k,v in pairs(weaAttachs) do
		if GetSelectedPedWeapon(ped) == GetHashKey(k) then
			attachList[k] = true
			for k2,v2 in pairs(v) do
				GiveWeaponComponentToPed(ped,GetHashKey(k),GetHashKey(v2))
			end
		end
	end
 end) ]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISUSINGATTACH
-----------------------------------------------------------------------------------------------------------------------------------------
function applyAttachs(weaponName)
	if attachList[weaponName] then
		local ped = PlayerPedId()
		for k,v in pairs(weaAttachs) do
			if weaponName == k then
				for k2,v2 in pairs(v) do
					GiveWeaponComponentToPed(ped,GetHashKey(k),GetHashKey(v2))
				end
			end
		end
	end

	if colorList[GetSelectedPedWeapon(PlayerPedId())] then
		SetPedWeaponTintIndex(PlayerPedId(),GetSelectedPedWeapon(PlayerPedId()),colorList[GetSelectedPedWeapon(PlayerPedId())])
	end
end

exports("applyAttachs",applyAttachs)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKCOMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
local blockCommands = false
RegisterNetEvent("player:blockCommands")
AddEventHandler("player:blockCommands",function(status)
	blockCommands = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKS
-----------------------------------------------------------------------------------------------------------------------------------------
function blocks()
	return blockCommands
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKCOMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("blockCommands",blocks)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:deleteVehicle")
AddEventHandler("player:deleteVehicle",function(vehIndex,vehPlate)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) and GetVehicleNumberPlateText(v) == vehPlate then
			SetEntityAsMissionEntity(v,false,false)
			DeleteEntity(v)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:deleteObject")
AddEventHandler("player:deleteObject",function(entIndex)
	if NetworkDoesNetworkIdExist(entIndex) then
		local v = NetToEnt(entIndex)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v,false,false)
			DeleteEntity(v)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLECARRY
-----------------------------------------------------------------------------------------------------------------------------------------
local uCarry = nil
local iCarry = false
local sCarry = false
function cRP.toggleCarry(source)
	uCarry = source
	iCarry = not iCarry

	local ped = PlayerPedId()
	if iCarry and uCarry then
		AttachEntityToEntity(ped,GetPlayerPed(GetPlayerFromServerId(uCarry)),11816,0.6,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		sCarry = true
	else
		if sCarry then
			DetachEntity(ped,false,false)
			sCarry = false
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeVehicle()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		if iCarry then
			iCarry = false
			DetachEntity(GetPlayerPed(GetPlayerFromServerId(uCarry)),false,false)
		end

		TaskLeaveVehicle(ped,GetVehiclePedIsUsing(ped),4160)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.putVehicle(vehIndex)
	if NetworkDoesNetworkIdExist(vehIndex) then
		local v = NetToEnt(vehIndex)
		if DoesEntityExist(v) then
			local vehSeats = 5
			local ped = PlayerPedId()

			repeat
				vehSeats = vehSeats - 1

				if IsVehicleSeatFree(v,vehSeats) then
					ClearPedTasks(ped)
					ClearPedSecondaryTask(ped)
					SetPedIntoVehicle(ped,v,vehSeats)

					if iCarry then
						iCarry = false
						DetachEntity(GetPlayerPed(GetPlayerFromServerId(uCarry)),false,false)
					end

					vehSeats = true
				end
			until vehSeats == true or vehSeats == 0
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(name,args)
	if name == "CEventNetworkEntityDamage" then
		if (GetEntityHealth(args[1]) <= 101 and IsPedAPlayer(args[1])) then
			local index = NetworkGetPlayerIndexFromPed(args[1])
			local source = GetPlayerServerId(index)
			TriggerServerEvent("player:deathLogs",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOWME
-----------------------------------------------------------------------------------------------------------------------------------------
local function showMe3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/300
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,50)
end

local showMe = {}
function cRP.pressMe(source,text)
	local pedSource = GetPlayerFromServerId(source)
	if pedSource ~= -1 then
		showMe[GetPlayerPed(pedSource)] = { text,5 }
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		for k,v in pairs(showMe) do
			local _x,_y,_z = table.unpack(GetEntityCoords(k))
			local distance = GetDistanceBetweenCoords(x,y,z,_x,_y,_z,true)
			if distance <= 5 then
				timeDistance = 4
				if HasEntityClearLosToEntity(ped,k,17) then
					showMe3D(_x,_y,_z+1.0,"~w~"..v[1])
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(showMe) do
			if v[2] > 0 then
				v[2] = v[2] - 1
				if v[2] <= 0 then
					showMe[k] = nil
				end
			end
		end
		Citizen.Wait(1000)
	end
end)