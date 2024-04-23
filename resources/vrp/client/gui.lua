local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local uObject = nil
local uPoint = false
local animDict = nil
local animName = nil
local crouch = false
local celular = false
local cancelando = false
local animActived = false
local playerActive = false
local cdBtns = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCELULAR
-----------------------------------------------------------------------------------------------------------------------------------------
local function startThreadCelular()
	Citizen.CreateThread(function()
		while celular and playerActive do
			if VRP_DEBUG then
				print("startThreadCelular")
			end

			DisableControlAction(1,18,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,68,true)
			DisableControlAction(1,70,true)
			DisableControlAction(1,91,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,143,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(PlayerPedId(),true)
			Citizen.Wait(1)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCANCELANDO
-----------------------------------------------------------------------------------------------------------------------------------------
local function startThreadCancelando()
	Citizen.CreateThread(function()
		while (cancelando) and playerActive do
			if VRP_DEBUG then
				print("startThreadCancelando")
			end

			DisableControlAction(1,18,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,68,true)
			DisableControlAction(1,70,true)
			DisableControlAction(1,91,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,143,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(PlayerPedId(),true)
			Citizen.Wait(1)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function startThreadAnim()
	Citizen.CreateThread(function()
		while animActived and playerActive do

			if VRP_DEBUG then
				print("startThreadAnim")
			end

			DisableControlAction(1,18,true)
			DisableControlAction(1,24,true)
			DisableControlAction(1,25,true)
			DisableControlAction(1,68,true)
			DisableControlAction(1,70,true)
			DisableControlAction(1,91,true)
			DisableControlAction(1,140,true)
			DisableControlAction(1,142,true)
			DisableControlAction(1,143,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(PlayerPedId(),true)
			if not IsEntityPlayingAnim(PlayerPedId(),animDict,animName,3) then
				TaskPlayAnim(PlayerPedId(),animDict,animName,3.0,3.0,-1,animFlags,0,0,0,0)
			end

			Citizen.Wait(1)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp:playerActive")
AddEventHandler("vrp:playerActive",function()
	playerActive = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUS:CELULAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	celular = status
	if celular then
		startThreadCelular()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("cancelando")
AddEventHandler("cancelando",function(status)
	cancelando = status
	if cancelando then
		startThreadCancelando()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.request(id,text,time)
	SendNUIMessage({ act = "request", id = id, text = tostring(text), time = time })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUIPROMPT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("prompt",function(data,cb)
	if data["act"] == "close" then
		SetNuiFocus(false,false)
		vRPS.promptResult(data["result"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROMPT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.prompt(title,default_text)
	SendNUIMessage({ act = "prompt", title = title, text = tostring(default_text) })
	SetNuiFocus(true,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("request",function(data,cb)
	if data["act"] == "response" then
		vRPS.requestResult(data["id"],data["ok"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIMSET
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.loadAnimSet(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.createObjects(newDict,newAnim,newProp,newFlag,newHands,newHeight,newPos1,newPos2,newPos3,newPos4,newPos5)
	if DoesEntityExist(uObject) then
		TriggerServerEvent("tryDeleteObject",ObjToNet(uObject))
		uObject = nil
	end

	local ped = PlayerPedId()
	local mHash = GetHashKey(newProp)
	local coords = GetEntityCoords(ped)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Citizen.Wait(1)
	end

	if HasModelLoaded(mHash) then
		if newAnim ~= "" then
			tvRP.loadAnimSet(newDict)
			TaskPlayAnim(ped,newDict,newAnim,3.0,3.0,-1,newFlag,0,0,0,0)
		end

		if newHeight then
			uObject = CreateObject(mHash,coords["x"],coords["y"],coords["z"],true,true,false)
			AttachEntityToEntity(uObject,ped,GetPedBoneIndex(ped,newHands),newHeight,newPos1,newPos2,newPos3,newPos4,newPos5,true,true,false,true,1,true)
		else
			u = CreateObject(mHash,coords["x"],coords["y"],coords["z"],true,true,false)
			AttachEntityToEntity(uObject,ped,GetPedBoneIndex(ped,newHands),0.0,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
		end

		local netObjs = ObjToNet(uObject)

		SetNetworkIdCanMigrate(netObjs,true)

		SetEntityAsMissionEntity(uObject,true,false)
		SetEntityAsNoLongerNeeded(uObject)
		SetModelAsNoLongerNeeded(mHash)

		animActived = true
		animFlags = newFlag
		animDict = newDict
		animName = newAnim
		startThreadAnim()
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.removeObjects(status)
	if status == "one" then
		tvRP.stopAnim(true)
	elseif status == "two" then
		tvRP.stopAnim(false)
	else
		tvRP.stopAnim(true)
		tvRP.stopAnim(false)
	end

	animActived = false
	TriggerEvent("camera")
	TriggerEvent("binoculos")
	if DoesEntityExist(uObject) then
		TriggerServerEvent("tryDeleteObject",ObjToNet(uObject))
		uObject = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKDRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
local blockDrunk = false
RegisterNetEvent("vrp:blockDrunk")
AddEventHandler("vrp:blockDrunk",function(status)
	blockDrunk = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POINT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 100
		if uPoint and playerActive then
			timeDistance = 1
			local ped = PlayerPedId()
			local camPitch = GetGameplayCamRelativePitch()

			if camPitch < -70.0 then
				camPitch = -70.0
			elseif camPitch > 42.0 then
				camPitch = 42.0
			end
			camPitch = (camPitch + 70.0) / 112.0

			local camHeading = GetGameplayCamRelativeHeading()
			local cosCamHeading = Cos(camHeading)
			local sinCamHeading = Sin(camHeading)
			if camHeading < -180.0 then
				camHeading = -180.0
			elseif camHeading > 180.0 then
				camHeading = 180.0
			end
			camHeading = (camHeading + 180.0) / 360.0

			local nn = 0
			local blocked = 0
			local coords = GetOffsetFromEntityInWorldCoords(ped,(cosCamHeading*-0.2)-(sinCamHeading*(0.4*camHeading+0.3)),(sinCamHeading*-0.2)+(cosCamHeading*(0.4*camHeading+0.3)),0.6)
			local ray = Cast_3dRayPointToPoint(coords["x"],coords["y"],coords["z"]-0.2,coords.x,coords.y,coords.z+0.2,0.4,95,ped,7);
			nn,blocked,coords,coords = GetRaycastResult(ray)

			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Pitch",camPitch)
			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Heading",camHeading * -1.0 + 1.0)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isBlocked",blocked)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isFirstPerson",Citizen.InvokeNative(0xEE778F8C7E1142E2,Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLECONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		--DisableControlAction(1,37,false)
		DisableControlAction(1,99,false)
		DisableControlAction(1,100,false)
		DisableControlAction(1,157,false)
		DisableControlAction(1,158,false)
		DisableControlAction(1,160,false)
		DisableControlAction(1,164,false)
		DisableControlAction(1,165,false)
		DisableControlAction(1,159,false)
		DisableControlAction(1,161,false)
		DisableControlAction(1,162,false)
		DisableControlAction(1,163,false)
		DisableControlAction(1,261,false)
		DisableControlAction(1,262,false)
		DisableControlAction(1,204,false)
		DisableControlAction(1,211,false)
		DisableControlAction(1,349,false)
		DisableControlAction(1,192,false)

		Citizen.Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCEPT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cRaccept",function(source,args)
	SendNUIMessage({ act = "event", event = "Y" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cRreject",function(source,args)
	SendNUIMessage({ act = "event", event = "U" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("cRengine","Ligar veículo","keyboard","Z")
RegisterKeyMapping("cRbind left","Bind Left","keyboard","LEFT")
RegisterKeyMapping("cRbind right","Bind Right","keyboard","RIGHT")
RegisterKeyMapping("cRbind up","Bind Up","keyboard","UP")
RegisterKeyMapping("cRbind down","Bind Down","keyboard","DOWN")
RegisterKeyMapping("cRaccept","Aceitar chamado","keyboard","Y")
RegisterKeyMapping("cRreject","Rejeitar chamado","keyboard","U")
RegisterKeyMapping("lockVehicles","Trancar veículo","keyboard","L")