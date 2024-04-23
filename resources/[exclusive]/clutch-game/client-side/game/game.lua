LocalPlayer.state.inLobby = false
LocalPlayer.state.inGame = false
local FreezeTimer = 10
local cam = nil
local coordsLobby = {
    [1] = vec3(-1637.85,-3128.36,12.99),
    [2] = vec3(-1637.86,-3130.89,12.99),
    [3] = vec3(-1639.59,-3129.58,12.99),
    [4] = vec3(-1640.83,-3129.62,12.99),
    [5] = vec3(-1642.12,-3129.36,12.99),
}

RegisterNetEvent("clutch-game:InitRound",function(inGame)
    if LocalPlayer.state.inLobby then
        DeleteCamera()
        LocalPlayer.state.inLobby = false
        LocalPlayer.state.inGame = true
    end
    local ped = PlayerPedId()
    TriggerEvent("respawnPlayer")
    SetEntityCoords(ped, inGame.gameSpawn.x, inGame.gameSpawn.y, inGame.gameSpawn.z)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    Citizen.Wait(FreezeTimer*1000)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
end)

RegisterNetEvent("clutch-game:lobby",function(pos,status)
    local ped = PlayerPedId()
    if LocalPlayer.state.inGame then
        LocalPlayer.state.inGame = false
    end
    TriggerServerEvent("clutch-game:setInDimension",status)
    TriggerEvent("respawnPlayer")
    CreateCamera()
    LocalPlayer.state.inLobby = true
    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, coordsLobby[pos])
    SetEntityHeading(ped, 328.8)
    SetNuiFocus(true,true)
end)

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        Citizen.Wait(0)
        if LocalPlayer.state.inLobby then
            SetEntityInvincible(ped, true)
            DisplayRadar(false)
        end
    end
end)

function CreateCamera()
    local ped = PlayerPedId()
    SetNuiFocus(true,true)
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, -1635.67,-3124.61,14.04+ 0.5)
    SetCamRot(cam, 0.0, 0.0, 150.0)
    SetCamActive(cam, true)
    RemoveAllPedWeapons(ped,true)
    RenderScriptCams(true, false, 0, true, true)
end

function DeleteCamera()
    local ped = PlayerPedId()
    SetNuiFocus(false,false)
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamRot(cam, -3.0, 0.0, 700.0)
    SetCamAffectsAiming(cam, false)
    SetCamActive(cam, false)
    RenderScriptCams(false, false, 0, 1, 0)
    DeleteEntity(cam)
    DestroyCam(cam,true)
    ClearPedTasks(ped)
    RemoveAllPedWeapons(ped,true)
    SetEntityInvincible(ped,false)
end