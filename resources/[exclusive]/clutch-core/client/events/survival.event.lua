-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local timeDeath = 1
local deathStatus = false
local invencibleCount = 0
local playerActive = true
local updateTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:PLAYERACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if playerActive then
			if GetGameTimer() >= updateTimers then
				local ped = PlayerPedId()
				updateTimers = GetGameTimer() + 10000
				vRPS.userUpdate(GetEntityHealth(ped),GetEntityCoords(ped))

				if invencibleCount < 3 then
					invencibleCount = invencibleCount + 1
					if invencibleCount >= 3 then
						SetEntityInvincible(ped,false)
					end
				end
				
			end
		end

		Citizen.Wait(5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 200
        if playerActive then
            local ped = PlayerPedId()
            if GetEntityHealth(ped) <= 101 and timeDeath >= 0 then
                timeDistance = 4
                if not deathStatus then
                    timeDeath = 1
                    deathStatus = true
                    SetEntityHealth(ped,0)
                    SetEntityInvincible(ped,false)
					SendNUIMessage({ death = true })
					FreezeEntityPosition(ped, true)
					
					if IsPedInAnyVehicle(ped) then
						local vehicle = GetVehiclePedIsUsing(ped)
						if GetPedInVehicleSeat(vehicle,-1) == ped then
							SetVehicleEngineOn(vehicle,false,true,true)
							TaskLeaveVehicle(ped, vehicle, 0)
						end
					end
                else
					if not LocalPlayer.state.inGame then
						if timeDeath > 0 then
							SendNUIMessage({ deathtext = "<color> <h1>AGUARDE</h1> </color> <small> "..timeDeath.." segundos. </small>" })
							SetEntityVisible(ped,false,false)
							TriggerEvent("animations:reset")
						else
							TriggerEvent("animations:reset")
							SendNUIMessage({ deathtext = "<color> <h1>E</h1> </color> <small>pressione para reviver</small>" })
						end
					else
						SendNUIMessage({ deathtext = "<color> <h1>AGUARDE</h1> </color> <small> O PRÓXIMO ROUND </small>" })
					end
                end
            end
        end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCK BUTTONS ON DEAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if deathStatus then 
            local ped = PlayerPedId()
			SetPedToRagdoll(ped,2000,2000,0,0,0,0)
			-- SetEntityHealth(ped,101)
			BlockWeaponWheelThisFrame()
			DisablePlayerFiring(ped,true)
			DisableControlAction(0,21,true)
			DisableControlAction(0,22,true)
			DisableControlAction(0,23,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,29,true)
			DisableControlAction(0,32,true)
			DisableControlAction(0,33,true)
			DisableControlAction(0,34,true)
			DisableControlAction(0,35,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,58,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,75,true)
			DisableControlAction(0,137,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,168,true)
			DisableControlAction(0,169,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,264,true)
			DisableControlAction(0,268,true)
			DisableControlAction(0,269,true)
			DisableControlAction(0,270,true)
			DisableControlAction(0,271,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,344,true)
		end
		Citizen.Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND DEATH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("+death",function(source,args,rawCommand)
	local ped = PlayerPedId()
	if timeDeath <= 0 then 
		TriggerEvent("respawnPlayer")	
		FreezeEntityPosition(ped, false)	
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING DEATH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	RegisterKeyMapping("+death","Death","keyboard","E")
end)
---------------------------------------------------------------------------------------------------------------------------------------
-- HS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(4)
        SetPedSuffersCriticalHits(PlayerPedId(-1), true)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTHRECHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		SetPlayerHealthRechargeMultiplier(PlayerId(),0)
		SetPlayerHealthRechargeLimit(PlayerId(),0)
		
		if GetEntityMaxHealth(PlayerPedId()) ~= 400 then
			SetEntityMaxHealth(PlayerPedId(),400)
			SetPedMaxHealth(PlayerPedId(),400)
		end

		Citizen.Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if deathStatus and timeDeath > 0 then
			timeDeath = timeDeath - 1
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("respawnPlayer")
AddEventHandler("respawnPlayer",function()
	local ped = PlayerPedId()
	timeDeath = 1
	deathStatus = false
	TriggerEvent("resetBleeding")
	TriggerEvent("resetDiagnostic")
	TriggerEvent("animations:reset")
	ClearPedBloodDamage(ped)
	SetEntityHealth(ped,400)
	SendNUIMessage({ death = false })
	local coords = GetEntityCoords(ped)
	NetworkResurrectLocalPlayer(coords,true,true,false)
	serverAPI.respawnServer()
	ClearPedTasksImmediately(ped)
	SetEntityVisible(ped,true,false)
	SetPedArmour(ped, 0)
end)