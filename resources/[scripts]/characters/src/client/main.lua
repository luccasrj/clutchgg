local characterCamera = nil

local scene = {
    ped = nil,
    camera = nil,
    camera2 = nil,
}
local animList = {
    ["female"] = {
        { "anim@amb@nightclub_island@dancers@club@","mi_idle_b_f02", true }
    },
    ["male"] = {
        { "amb@world_human_cop_idles@female@idle_b","idle_e", true }
    }
}

local function createPed(hashKey,clothes,barber)
    if DoesEntityExist(scene.ped) then
        DeleteEntity(scene.ped)
        scene.ped = nil
    end

    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end

    local _,z = GetGroundZFor_3dCoord(461.16,-228.51,65.96, 0)
    scene.ped = CreatePed(27, hashKey,461.16,-228.51,54.96,218.27, 0, 0)
    
    ClearPedTasks(scene.ped)
    DecorSetBool(scene.ped, 'ScriptedPed', true)
    SetPedKeepTask(scene.ped, false)
    TaskSetBlockingOfNonTemporaryEvents(scene.ped, false)
    ClearPedTasks(scene.ped)
    FreezeEntityPosition(scene.ped,true)
    SetEntityInvincible(scene.ped,true)
    setClothing(scene.ped,clothes)
    setBarbershop(scene.ped,barber)

    if GetEntityModel(scene.ped) == "mp_f_freemode_01" then
        local randomAnim = math.random(#animList["female"])
        vRP.playAnim(false,{ animList["female"][randomAnim][1], animList["female"][randomAnim][2] },animList["female"][randomAnim][3],scene.ped)
    else
        local randomAnim = math.random(#animList["male"])
        vRP.playAnim(false,{ animList["male"][randomAnim][1], animList["male"][randomAnim][2] },animList["male"][randomAnim][3],scene.ped)
    end
end

RegisterNetEvent("characters:previewCharacter",function(hash,clothes,barber)
    createPed(hash,clothes,barber)
end)

local function startScene()
    local ped = PlayerPedId()

    SetEntityCoords(PlayerPedId(),461.49,-228.42,54.96,218.27)
    scene.camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 469.86,-264.17,72.03, 0.00, 0.0, -335.0, 38.0, true, 2)
    scene.camera2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 463.17,-230.95,55.6, 10.0, 0.0, -335.0, 38.0, true, 2)
    RenderScriptCams(1, 1, 0, 0, 0)
    Wait(0)
    SetFocusPosAndVel(GetCamCoord(scene.camera), 0.0, 0.0, 0.0)
    SetCamActiveWithInterp(scene.camera2, scene.camera, 5000, 1, 1)
    Wait(0)
    SetFocusPosAndVel(GetCamCoord(scene.camera2), 0.0, 0.0, 0.0)
end

local function generateJoin(data)
    local ped = PlayerPedId()
    TriggerServerEvent("Queue:playerConnect")
    --startScene()

    SetEntityVisible(ped,true,false)
    FreezeEntityPosition(ped,false)
    SetEntityInvincible(ped,false)
    SetEntityHealth(ped,400)
    ShutdownLoadingScreen()

    --SetNuiFocus(true,true)
    if data then
        ExecuteCommand("dia")
        server.getLogin(data.id)
        server.spawnCharacter(data.id,nil)
        SetPedArmour(ped,0)
    else
        ExecuteCommand("dia")
        SetEntityCoords(PlayerPedId(),1189.18,9097.73,1771.24,320.32)
        SetEntityVisible(ped,false,false)
        FreezeEntityPosition(ped,true)
        SetEntityInvincible(ped,true)
        SetEntityHealth(ped,400)
        SetPedArmour(ped,0)
        SetNuiFocus(true,true)
        SendNUIMessage({ action = "openSystem" })
    end
end


RegisterNUICallback("generateDisplay",function(data,cb)
    local params,chars,maxChars, group, id = server.initSystem()
    cb({ params = params, chars = chars, max_chars = maxChars, group = group, id = id  })
end)

RegisterNUICallback("createCharacter",function(data,cb)
    local decoded = data.result
    local check_name = server.checkName(decoded.surname)
    if check_name then 
        cb({ sucess = true })
        server.newCharacter(decoded.surname,decoded.gender)
    else
        -- cb({error = true, txt = "Nome de usuário em uso"})
        TriggerEvent("Notify","negado","Nome de usuário em uso")
    end
end)

RegisterNUICallback("characterSelected",function(data,cb)
    server.previewCharacter(data.id)
    local userLogin = server.getLogin(data.id)
    SendNUIMessage({ action = "updateLocates", params = userLogin and "{}" })
    cb("ok")
end)

RegisterNUICallback("spawnCharacter",function(data,cb)
    server.spawnCharacter(data.userId,data.choice)
    cb("ok")
    SetPedArmour(ped,0)
end)

RegisterNetEvent("characters:justSpawn",function()
    if DoesEntityExist(scene.ped) then
        DeleteEntity(scene.ped)
        scene.ped = nil
    end

    DoScreenFadeOut(0)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped,false,false)

    SetEntityVisible(ped,true,false)
    TriggerEvent("hudActived",true)
    SetNuiFocus(false,false)
    ExecuteCommand("lobby")
    Citizen.Wait(2500)
    
    DoScreenFadeIn(1000)
    SetPedArmour(ped,0)
end)

RegisterNUICallback("deletePed",function(data,cb)
    if DoesEntityExist(scene.ped) then
        DeleteEntity(scene.ped)
        scene.ped = nil
    end
    cb("ok")
end)

RegisterNUICallback("createSimplePed",function(data,cb)
    if DoesEntityExist(scene.ped) then
        DeleteEntity(scene.ped)
        scene.ped = nil
    end

    cb("ok")
end)


Citizen.CreateThread( function()
    local mHash = GetHashKey("mp_m_freemode_01")

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Citizen.Wait(1)
	end

	if HasModelLoaded(mHash) then
		SetPlayerModel(PlayerId(),mHash)
		SetModelAsNoLongerNeeded(mHash)
		FreezeEntityPosition(PlayerPedId(),false)
	end

    while not server do
		Citizen.Wait(1)
	end
    
    local data = server.initSystem()
	local status, err = pcall(function() 
		return generateJoin(data)
	end)
    if not status and err then 
		if not reported then 
			reported = true 
		    TriggerServerEvent("characters:report_error", err, data)
		end
		print("ERRO DURANTE CONEXÃO!",err)
		initialThread()
		return false
	end

	TriggerEvent("spawn:generateJoin")
	TriggerServerEvent("Queue:playerConnect")

end)