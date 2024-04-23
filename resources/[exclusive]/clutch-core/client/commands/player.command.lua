-----------------------------------------------------------------------------------------------------------------------------------------
-- ENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
local enable_energetic = false
RegisterCommand("energetico",function(source,args)
	if enable_energetic == false then
    	setEnergetic(true)
	end
	SetTimeout(20000,function()
		setEnergetic(false)
	end)
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		setEnergetic(true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
function setEnergetic(status)
    enable_energetic = status
    if enable_energetic then
        SetRunSprintMultiplierForPlayer(PlayerId(),1.20)
    else
        SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADENERGETIC
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        if enable_energetic then
            timeDistance = 4
            RestorePlayerStamina(PlayerId(),1.0)
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fps",function(source,args)
    if args[1] == "on" then
        SetTimecycleModifier("cinema")
    elseif args[1] == "off" then
        SetTimecycleModifier("default")
    end
end)