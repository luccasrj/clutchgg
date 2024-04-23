local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vRPhud = {}
local agachar = false
local bigmap = false
Tunnel.bindInterface("vrp_hud",vRPhud)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local hour = 0
local minute = 0
local month = ""
local dayMonth = 0
local voice = 1
local voiceDisplay = ""
local proximity = 2
local sBuffer = {}
local vBuffer = {}
local ExNoCarro = false
local showHud = true
local gasolina = 0
local motor = 0
local started = true
local displayValue = false
local timedown = 0
local fome = 0
local sede = 0

function vRPhud.setHunger(hunger)
	fome = hunger
end

function vRPhud.setThirst(thirst)
	sede = thirst
end
----------------------------------------------------------------------------------------------------------------------------------------
-- DATA E HORA
-----------------------------------------------------------------------------------------------------------------------------------------
function calculateTimeDisplay()
	hour = GetClockHours()
	month = GetClockMonth()
	minute = GetClockMinutes()
	dayMonth = GetClockDayOfMonth()
	heading = GetEntityHeading(PlayerPedId())

	if hour <= 9 then
		hour = "0"..hour
	end

	if minute <= 9 then
		minute = "0"..minute end
	
	
	if month == 0 then
		month = "Janeiro"
	elseif month == 1 then
		month = "Fevereiro"
	elseif month == 2 then
		month = "Março"
	elseif month == 3 then
		month = "Abril"
	elseif month == 4 then
		month = "Maio"
	elseif month == 5 then
		month = "Junho"
	elseif month == 6 then
		month = "Julho"
	elseif month == 7 then
		month = "Agosto"
	elseif month == 8 then
		month = "Setembro"
	elseif month == 9 then
		month = "Outubro"
	elseif month == 10 then
		month = "Novembro"
	elseif month == 11 then
		month = "Dezembro"
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOICE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerSpawned",function()
	NetworkSetTalkerProximity(1.0)
	started = true
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		setVoice()
	end
end)

function setVoice()
	NetworkSetTalkerProximity(1.0)
	NetworkClearVoiceChannel()
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
local menu_celular = false
RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	menu_celular = status
end)
local hidden = false
-------------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterCommand("minimap",function(source,args)
	if hidden == false then
		Citizen.CreateThread(function ()
			while true do
				DisplayRadar(false)
				Citizen.Wait(0)
			end
		end)
		hidden = true
	elseif hidden == true then
		Citizen.CreateThread(function ()
			while true do
				DisplayRadar(true)
				Citizen.Wait(0)
			end
		end)	
		hidden = false
	end
end]]

RegisterNetEvent("hud:hidehud",function()
	SendNUIMessage({action = "hideServer"})
end)

RegisterNetEvent("hud:showhud",function()
	SendNUIMessage({action = "showServer"})
end)

Citizen.CreateThread(function()
	while true do
		if started and not hidden then 
			if IsPauseMenuActive() or menu_celular then
				displayValue = false
	        else
	            displayValue = true
				if GetEntityHealth(PlayerPedId()) > 101 then
					ped = PlayerPedId()
					health = (GetEntityHealth(ped))/101 * 35
					armor = GetPedArmour(ped)/101 * 139.8
				elseif GetEntityHealth(PlayerPedId()) <= 101 then
					health = 0
					armor = 0
				end
				
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
				calculateTimeDisplay()
				inCar  = false
				PedCar = 0
				speed = 0
				rpm = 0
				marcha = 0
				cruiseIsOn = false
				VehIndicatorLight = 0
				SendNUIMessage({show = show,incar = inCar,speed = speed,rpm = parseInt(rpm*30),gear = marcha,heal = health,armor = armor,dia = dayMonth,mes = month,hora = hour,minuto = minute,voz = voiceDisplay,piscaEsquerdo = piscaEsquerdo,piscaDireito = piscaDireito,gas = gasolina,engine = parseInt(motor/10),farol = farol,  thirst = parseInt(thirst), hunger = parseInt(hunger), sede = math.ceil(100-sede),fome = math.ceil(100-fome), cruise = cruiseIsOn,display = displayValue,street = street,rua2 = street2});
			end
		end
		Citizen.Wait(150)
	end
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
	SetRadarBigmapEnabled(true, false)
	Wait(50)
	SetRadarBigmapEnabled(false, false)

	while true do
		Citizen.Wait(0)
		BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		if timedown > 0 and GetEntityHealth(ped) > 101 then
			timedown = timedown - 1
			if timedown <= 1 then
				TriggerServerEvent("qr_inventory:Cancel")
			end
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- RAGDOLL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		if timedown > 1 and GetEntityHealth(ped) > 101 then
			if not IsEntityPlayingAnim(ped,"anim@heists@ornate_bank@hostages@hit","hit_react_die_loop_ped_a",3) then
				vRP.playAnim(false,{"anim@heists@ornate_bank@hostages@hit","hit_react_die_loop_ped_a"},true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if timedown > 0 then
			timeDistance = 4
			DisableControlAction(0,170,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,105,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,20,true)
			DisableControlAction(0,29,true)
		end
		Citizen.Wait(timeDistance)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR AGACHAR E ATIRAR QUE NAO BUGA HUD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local player = PlayerId()
        if agachar then 
            DisablePlayerFiring(player, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        DisableControlAction(0,36,true)
        if not IsPedInAnyVehicle(ped) then
            RequestAnimSet("move_ped_crouched")
            RequestAnimSet("move_ped_crouched_strafing")
            if IsDisabledControlJustPressed(0,36) then
                if agachar then
                    ResetPedStrafeClipset(ped)
                    ResetPedMovementClipset(ped,0.25)
                    agachar = false
                else
                    SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
                    SetPedMovementClipset(ped,"move_ped_crouched",0.25)
                    agachar = true
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
		SetRadarAsExteriorThisFrame()
		SetRadarAsInteriorThisFrame("h4_fake_islandx",vec(4700.0,-5145.0),0,0)
	end
end)

local ArmasDlog = {
    [GetHashKey('WEAPON_UNARMED')] = 'SOCO',
    [GetHashKey('WEAPON_KNIFE')] = "FACA",
    [GetHashKey('WEAPON_NIGHTSTICK')] = "WEAPON_NIGHTSTICK",
    [GetHashKey('WEAPON_HAMMER')] = "WEAPON_HAMMER",
    [GetHashKey('WEAPON_BAT')] = "WEAPON_BAT",
    [GetHashKey('WEAPON_GOLFCLUB')] = "WEAPON_GOLFCLUB",
    [GetHashKey('WEAPON_CROWBAR')] = "WEAPON_CROWBAR",
    [GetHashKey('WEAPON_PISTOL')] = "WEAPON_PISTOL",
    [GetHashKey('WEAPON_COMBATPISTOL')] = "Combat Pistol",
    [GetHashKey('WEAPON_APPISTOL')] = "WEAPON_APPISTOL",
    [GetHashKey('WEAPON_PISTOL50')] = "WEAPON_PISTOL50",
    [GetHashKey('WEAPON_MICROSMG')] = "Micro Smg",
    [GetHashKey('WEAPON_SMG')] = "Smg",
    [GetHashKey('WEAPON_ASSAULTSMG')] = "Assault Smg",
    [GetHashKey('WEAPON_ASSAULTRIFLE')] = "Ak-47",
    [GetHashKey('WEAPON_CARBINERIFLE')] = "Carbine Rifle",
    [GetHashKey('WEAPON_ADVANCEDRIFLE')] = "WEAPON_ADVANCEDRIFLE",
    [GetHashKey('WEAPON_MG')] = "WEAPON_MG",
    [GetHashKey('WEAPON_COMBATMG')] = "WEAPON_COMBATMG",
    [GetHashKey('WEAPON_PUMPSHOTGUN')] = "WEAPON_PUMPSHOTGUN",
    [GetHashKey('WEAPON_SAWNOFFSHOTGUN')] = "WEAPON_SAWNOFFSHOTGUN",
    [GetHashKey('WEAPON_ASSAULTSHOTGUN')] = "WEAPON_ASSAULTSHOTGUN",
    [GetHashKey('WEAPON_BULLPUPSHOTGUN')] = "WEAPON_BULLPUPSHOTGUN",
    [GetHashKey('WEAPON_STUNGUN')] = "WEAPON_STUNGUN",
    [GetHashKey('WEAPON_SNIPERRIFLE')] = "WEAPON_SNIPERRIFLE",
    [GetHashKey('WEAPON_HEAVYSNIPER')] = "WEAPON_HEAVYSNIPER",
    [GetHashKey('WEAPON_GRENADELAUNCHER')] = "WEAPON_GRENADELAUNCHER",
    [GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE')] = 'WEAPON_GRENADELAUNCHER_SMOKE',
    [GetHashKey('WEAPON_RPG')] = "WEAPON_RPG",
    [GetHashKey('WEAPON_MINIGUN')] = "WEAPON_MINIGUN",
    [GetHashKey('WEAPON_GRENADE')] = "WEAPON_GRENADE",
    [GetHashKey('WEAPON_STICKYBOMB')] = "WEAPON_STICKYBOMB",
    [GetHashKey('WEAPON_SMOKEGRENADE')] = "WEAPON_SMOKEGRENADE",
    [GetHashKey('WEAPON_BZGAS')] = "WEAPON_BZGAS",
    [GetHashKey('WEAPON_MOLOTOV')] = "WEAPON_MOLOTOV",
    [GetHashKey('WEAPON_FIREEXTINGUISHER')] = "WEAPON_FIREEXTINGUISHER",
    [GetHashKey('WEAPON_PETROLCAN')] = "WEAPON_PETROLCAN",
    [GetHashKey('WEAPON_FLARE')] = "WEAPON_FLARE",
    [GetHashKey('WEAPON_SNSPISTOL')] = "Sns Pistol",
    [GetHashKey('WEAPON_SPECIALCARBINE')] = "Special Carbine",
    [GetHashKey('WEAPON_HEAVYPISTOL')] = "WEAPON_HEAVYPISTOL",
    [GetHashKey('WEAPON_BULLPUPRIFLE')] = "BullPup",
    [GetHashKey('WEAPON_HOMINGLAUNCHER')] = "WEAPON_HOMINGLAUNCHER",
    [GetHashKey('WEAPON_PROXMINE')] = "WEAPON_PROXMINE",
    [GetHashKey('WEAPON_SNOWBALL')] = "WEAPON_SNOWBALL",
    [GetHashKey('WEAPON_VINTAGEPISTOL')] = "WEAPON_VINTAGEPISTOL",
    [GetHashKey('WEAPON_DAGGER')] = "WEAPON_DAGGER",
    [GetHashKey('WEAPON_FIREWORK')] = "WEAPON_FIREWORK",
    [GetHashKey('WEAPON_MUSKET')] = "WEAPON_MUSKET",
    [GetHashKey('WEAPON_MARKSMANRIFLE')] = "WEAPON_MARKSMANRIFLE",
    [GetHashKey('WEAPON_HEAVYSHOTGUN')] = "WEAPON_HEAVYSHOTGUN",
    [GetHashKey('WEAPON_GUSENBERG')] = "WEAPON_GUSENBERG",
    [GetHashKey('WEAPON_HATCHET')] = "WEAPON_HATCHET",
    [GetHashKey('WEAPON_RAILGUN')] = "WEAPON_RAILGUN",
    [GetHashKey('WEAPON_COMBATPDW')] = "WEAPON_COMBATPDW",
    [GetHashKey('WEAPON_KNUCKLE')] = "WEAPON_KNUCKLE",
    [GetHashKey('WEAPON_MARKSMANPISTOL')] = "WEAPON_MARKSMANPISTOL",
    [GetHashKey('WEAPON_FLASHLIGHT')] = "WEAPON_FLASHLIGHT",
    [GetHashKey('WEAPON_MACHETE')] = "WEAPON_MACHETE",
    [GetHashKey('WEAPON_MACHINEPISTOL')] = "WEAPON_MACHINEPISTOL",
    [GetHashKey('WEAPON_SWITCHBLADE')] = "WEAPON_SWITCHBLADE",
    [GetHashKey('WEAPON_REVOLVER')] = "WEAPON_REVOLVER",
    [GetHashKey('WEAPON_COMPACTRIFLE')] = "WEAPON_COMPACTRIFLE",
    [GetHashKey('WEAPON_DBSHOTGUN')] = "WEAPON_DBSHOTGUN",
    [GetHashKey('WEAPON_FLAREGUN')] = "WEAPON_FLAREGUN",
    [GetHashKey('WEAPON_AUTOSHOTGUN')] = "WEAPON_AUTOSHOTGUN",
    [GetHashKey('WEAPON_BATTLEAXE')] = "WEAPON_BATTLEAXE",
    [GetHashKey('WEAPON_COMPACTLAUNCHER')] = "WEAPON_COMPACTLAUNCHER",
    [GetHashKey('WEAPON_MINISMG')] = "WEAPON_MINISMG",
    [GetHashKey('WEAPON_PIPEBOMB')] = "WEAPON_PIPEBOMB",
    [GetHashKey('WEAPON_POOLCUE')] = "WEAPON_POOLCUE",
    [GetHashKey('WEAPON_SWEEPER')] = "WEAPON_SWEEPER",
    [GetHashKey('WEAPON_WRENCH')] = "WEAPON_WRENCH",
    [GetHashKey('WEAPON_PISTOL_MK2')] =  "WEAPON_PISTOL_MK2",
    [GetHashKey('WEAPON_SNSPISTOL_MK2')] =  "WEAPON_SNSPISTOL_MK2",
    [GetHashKey('WEAPON_REVOLVER_MK2')] =  "WEAPON_REVOLVER_MK2",
    [GetHashKey('WEAPON_SMG_MK2')] =  "WEAPON_SMG_MK2",
    [GetHashKey('WEAPON_PUMPSHOTGUN_MK2')] =  "WEAPON_PUMPSHOTGUN_MK2",
    [GetHashKey('WEAPON_ASSAULTRIFLE_MK2')] =  "WEAPON_ASSAULTRIFLE_MK2",
    [GetHashKey('WEAPON_CARBINERIFLE_MK2')] =  "WEAPON_CARBINERIFLE_MK2",
    [GetHashKey('WEAPON_SPECIALCARBINE_MK2')] =  "Special Carbine Mk II",
    [GetHashKey('WEAPON_BULLPUPRIFLE_MK2')] =  "WEAPON_BULLPUPRIFLE_MK2",
    [GetHashKey('WEAPON_COMBATMG_MK2')] =  "WEAPON_COMBATMG_MK2",
    [GetHashKey('WEAPON_HEAVYSNIPER_MK2')] =  "WEAPON_HEAVYSNIPER_MK2",
	[GetHashKey('WEAPON_SMOKEGRENADE')] =  "WEAPON_SMOKEGRENADE",
    [GetHashKey('WEAPON_MARKSMANRIFLE_MK2')] =  "WEAPON_MARKSMANRIFLE_MK2"
}

--[[ Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 244) then
			if not bigmap then
				bigmap = true
				SetRadarBigmapEnabled(true, false)
			elseif bigmap then
				bigmap = false
				SetRadarBigmapEnabled(false, false)
			end
		end
	end
end) ]]

Citizen.CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local weapon = nil
		local Hash = GetSelectedPedWeapon(PlayerPedId())
		local _,Min = GetAmmoInClip(Ped,Hash)
		local Max = GetAmmoInPedWeapon(Ped,Hash)
		local health = GetEntityHealth(PlayerPedId())
		if health <= 101 then
			SendNUIMessage({ action = "Weapons", Status = false, Min = Min, Max = Max, Name = weapon })
		end
		if LocalPlayer.state.Init then
			if AmmoMax ~= Max or AmmoMin ~= Min then
				if ArmasDlog[Hash] then
					weapon = ArmasDlog[Hash]
				end
				AmmoMax = Max
				AmmoMin = Min

				if (Max - Min) <= 0 then
					Max = 0
				else
					Max = Max - Min
				end

				SendNUIMessage({ action = "Weapons", Status = true, Min = Min, Max = Max, Name = weapon })
			end
		else
			SendNUIMessage({ action = "Weapons", Status = false })
		end
		Wait(100)
	end
end)