-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local keyboard = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEH
-----------------------------------------------------------------------------------------------------------------------------------------
function src.spawnVeh(name)
    local mHash = GetHashKey(name)

    RequestModel(mHash)
    while not HasModelLoaded(mHash) do
        RequestModel(mHash)
        Citizen.Wait(10)
    end

    if HasModelLoaded(mHash) then
        local ped = PlayerPedId()
        local nveh = CreateVehicle(mHash,GetEntityCoords(ped),GetEntityHeading(ped),true,false)

        SetVehicleDirtLevel(nveh,0.0)
        SetVehRadioStation(nveh,"OFF")
        SetVehicleNumberPlateText(nveh,"luccasrj")
		SetPedIntoVehicle(ped,nveh,-1)
        SetEntityAsMissionEntity(nveh,true,true)

        SetVehicleFuelLevel(nveh,100.0)

        SetModelAsNoLongerNeeded(mHash)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNINGVEH
-----------------------------------------------------------------------------------------------------------------------------------------
function src.TuningVeh(index)
	if NetworkDoesNetworkIdExist(index.vehNet) then
		local v = index.veh
		if DoesEntityExist(v) then
			SetVehicleModKit(v,0)
			SetVehicleMod(v,0,GetNumVehicleMods(v,0)-1,false)
			SetVehicleMod(v,1,GetNumVehicleMods(v,1)-1,false)
			SetVehicleMod(v,2,GetNumVehicleMods(v,2)-1,false)
			SetVehicleMod(v,3,GetNumVehicleMods(v,3)-1,false)
			SetVehicleMod(v,4,GetNumVehicleMods(v,4)-1,false)
			SetVehicleMod(v,5,GetNumVehicleMods(v,5)-1,false)
			SetVehicleMod(v,6,GetNumVehicleMods(v,6)-1,false)
			SetVehicleMod(v,7,GetNumVehicleMods(v,7)-1,false)
			SetVehicleMod(v,8,GetNumVehicleMods(v,8)-1,false)
			SetVehicleMod(v,9,GetNumVehicleMods(v,9)-1,false)
			SetVehicleMod(v,10,GetNumVehicleMods(v,10)-1,false)
			SetVehicleMod(v,11,GetNumVehicleMods(v,11)-1,false)
			SetVehicleMod(v,12,GetNumVehicleMods(v,12)-1,false)
			SetVehicleMod(v,13,GetNumVehicleMods(v,13)-1,false)
			SetVehicleMod(v,14,2,false)
			SetVehicleMod(v,15,GetNumVehicleMods(v,15)-2,false)
			SetVehicleMod(v,16,GetNumVehicleMods(v,16)-1,false)
			ToggleVehicleMod(v,17,true)
			ToggleVehicleMod(v,18,true)
			ToggleVehicleMod(v,19,true)
			ToggleVehicleMod(v,20,true)
			ToggleVehicleMod(v,21,true)
			ToggleVehicleMod(v,22,true)
			SetVehicleMod(v,25,GetNumVehicleMods(v,25)-1,false)
			SetVehicleMod(v,27,GetNumVehicleMods(v,27)-1,false)
			SetVehicleMod(v,28,GetNumVehicleMods(v,28)-1,false)
			SetVehicleMod(v,30,GetNumVehicleMods(v,30)-1,false)
			SetVehicleMod(v,33,GetNumVehicleMods(v,33)-1,false)
			SetVehicleMod(v,34,GetNumVehicleMods(v,34)-1,false)
			SetVehicleMod(v,35,GetNumVehicleMods(v,35)-1,false)
			SetVehicleMod(v,38,GetNumVehicleMods(v,38)-1,true)
			SetVehicleTyresCanBurst(v,false)
			if not IsThisModelABike(v) then
				SetVehicleWindowTint(v,1)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
-----------------------------------------------------------------------------------------------------------------------------------------
function src.syncArea(x,y,z)
	ClearAreaOfVehicles(x,y,z,2000.0,false,false,false,false,false)
    ClearAreaOfEverything(x,y,z,2000.0,false,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.syncObject(index) 
	if NetworkDoesNetworkIdExist(index) then
        local v = NetToPed(index)
        if DoesEntityExist(v) and IsEntityAnObject(v) then
            Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
            SetEntityAsMissionEntity(v,true,true)
            NetworkRequestControlOfEntity(v)
            Citizen.InvokeNative(0x539E0AE3E6634B9F,Citizen.PointerValueIntInitialized(v))
            DeleteEntity(v)
            DeleteObject(v)
            SetObjectAsNoLongerNeeded(v)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.teleportWay()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsPedInAnyVehicle(ped) then
		ped = veh
    end

	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09,waypointBlip,Citizen.ResultAsVector()))

	local canTp = true
	
	local ground
	local groundFound = false
	local groundCheckHeights = { 0.0,50.0,100.0,150.0,200.0,250.0,300.0,350.0,400.0,450.0,500.0,550.0,600.0,650.0,700.0,750.0,800.0,850.0,900.0,950.0,1000.0,1050.0,1100.0 }

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(ped,x,y,height,0,0,1)

		RequestCollisionAtCoord(x,y,z)
		while not HasCollisionLoadedAroundEntity(ped) do
			RequestCollisionAtCoord(x,y,z)
			Citizen.Wait(1)
		end
		Citizen.Wait(20)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if ground then
			z = z + 1.0
			groundFound = true
			break;
		end
	end

	if not groundFound then
		z = 1200
		GiveDelayedWeaponToPed(PlayerPedId(),0xFBAB5776,1,0)
	end

	RequestCollisionAtCoord(x,y,z)
	while not HasCollisionLoadedAroundEntity(ped) do
		RequestCollisionAtCoord(x,y,z)
		Citizen.Wait(1)
	end

	if canTp then
		SetEntityCoordsNoOffset(ped,x,y,z,0,0,1)
	end
	return "Executado"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.deleteNpcs()
	local handle,ped = FindFirstPed()
	local finished = false
	repeat
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(ped),true)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance < 3 then
			Citizen.InvokeNative(0xAD738C3085FE7E11,ped,true,true)
			TriggerServerEvent("tryDeletePed",PedToNet(ped))
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLACEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.placeObject(objectName,name)
    local coord = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1),0.0,1.0,-0.94)
    local heading = GetEntityHeading(GetPlayerPed(-1))
    if name ~= "d" then
        object = CreateObject(GetHashKey(objectName),coord.x,coord.y,coord.z,true,true,true)
        PlaceObjectOnGroundProperly(object)
        SetEntityHeading(object,heading)
        FreezeEntityPosition(object,true) 
    else
        if DoesObjectOfTypeExistAtCoords(coord.x,coord.y,coord.z,0.9,GetHashKey(objectName),true) then
            object = GetClosestObjectOfType(coord.x,coord.y,coord.z,0.9,GetHashKey(objectName),false,false,false)
			SetEntityAsMissionEntity(object,true,true)
			DeleteObject(object)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEARENA
-----------------------------------------------------------------------------------------------------------------------------------------
local object = nil
function src.generateArena(objectName,params)
	if params == "deletar" then
		if DoesEntityExist(object) then
			DeleteEntity(object)
			object = nil
		end
	else
		local coords = GetEntityCoords(PlayerPedId())
		
		if DoesEntityExist(object) then
			DeleteEntity(object)
			object = nil
		end
		
		RequestModel(objectName)
		while not HasModelLoaded(objectName) do
			Citizen.Wait(3)
		end
		
		object = CreateObject(GetHashKey(objectName),coords.x,coords.y,coords.z-0.97,true,true,true)
		FreezeEntityPosition(object,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.repairVehicle(index)
	local index = VehToNet(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			local fuel = GetVehicleFuelLevel(v)

			SetVehicleFixed(v)
			SetVehicleDeformationFixed(v)
			SetVehicleOnGroundProperly(v)
			SetVehicleDirtLevel(v,0.0)
			SetVehicleUndriveable(v,false)
			SetVehicleBodyHealth(v,1000.0)
			SetVehicleEngineHealth(v,1000.0)
			SetVehiclePetrolTankHealth(v,1000.0)
			SetVehicleFuelLevel(v,fuel)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
function src.returnHash()
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then 
		return GetEntityModel(vehicle)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUGKEYBOARD
-----------------------------------------------------------------------------------------------------------------------------------------
function src.bugKeyboard()
	keyboard = not keyboard
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TROLLTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if keyboard then
			idle = 4
			for i=0,357 do
				DisableControlAction(0,i,true) 
			end 
		end
		Citizen.Wait(idle) 
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAGDOLL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("plf-admin:Ragdoll")
AddEventHandler("plf-admin:Ragdoll",function(ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
	SetPedToRagdollWithFall(PlayerPedId(),1500,2000,0,ForwardVector,1.0,0.0,0.0,0.0,0.0,0.0,0.0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('clonePreset')
AddEventHandler('clonePreset',function(custom)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if custom[1] == -1 then
			SetPedComponentVariation(ped,1,0,0,2)
		else
			SetPedComponentVariation(ped,1,custom[1],custom[2],2)
		end

		if custom[3] == -1 then
			SetPedComponentVariation(ped,5,0,0,2)
		else
			SetPedComponentVariation(ped,5,custom[3],custom[4],2)
		end

		if custom[5] == -1 then
			SetPedComponentVariation(ped,7,0,0,2)
		else
			SetPedComponentVariation(ped,7,custom[5],custom[6],2)
		end

		if custom[7] == -1 then
			SetPedComponentVariation(ped,3,15,0,2)
		else
			SetPedComponentVariation(ped,3,custom[7],custom[8],2)
		end

		if custom[9] == -1 then
			if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
				SetPedComponentVariation(ped,4,18,0,2)
			elseif GetEntityModel(ped) == GetHashKey('mp_f_freemode_01') then
				SetPedComponentVariation(ped,4,15,0,2)
			end
		else
			SetPedComponentVariation(ped,4,custom[9],custom[10],2)
		end

		if custom[11] == -1 then
			SetPedComponentVariation(ped,8,15,0,2)
		else
			SetPedComponentVariation(ped,8,custom[11],custom[12],2)
		end

		if custom[13] == -1 then
			if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
				SetPedComponentVariation(ped,6,34,0,2)
			elseif GetEntityModel(ped) == GetHashKey('mp_f_freemode_01') then
				SetPedComponentVariation(ped,6,35,0,2)
			end
		else
			SetPedComponentVariation(ped,6,custom[13],custom[14],2)
		end

		if custom[15] == -1 then
			SetPedComponentVariation(ped,11,15,0,2)
		else
			SetPedComponentVariation(ped,11,custom[15],custom[16],2)
		end

		if custom[17] == -1 then
			SetPedComponentVariation(ped,9,0,0,2)
		else
			SetPedComponentVariation(ped,9,custom[17],custom[18],2)
		end

		if custom[19] == -1 then
			SetPedComponentVariation(ped,10,0,0,2)
		else
			SetPedComponentVariation(ped,10,custom[19],custom[20],2)
		end

		if custom[21] == -1 then
			ClearPedProp(ped,0)
		else
			SetPedPropIndex(ped,0,custom[21],custom[22],2)
		end

		if custom[23] == -1 then
			ClearPedProp(ped,1)
		else
			SetPedPropIndex(ped,1,custom[23],custom[24],2)
		end

		if custom[25] == -1 then
			ClearPedProp(ped,2)
		else
			SetPedPropIndex(ped,2,custom[25],custom[26],2)
		end

		if custom[27] == -1 then
			ClearPedProp(ped,6)
		else
			SetPedPropIndex(ped,6,custom[27],custom[28],2)
		end

		if custom[29] == -1 then
			ClearPedProp(ped,7)
		else
			SetPedPropIndex(ped,7,custom[29],custom[30],2)
		end
	end
end)