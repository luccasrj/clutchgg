local userList = {}
local adminMode = false
local blipsStatus = {}

RegisterNetEvent("common:admin_blips:updateList2",function(list)
    userList = list
end)

local function drawAdmin2(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.3, 0.3)
        SetTextColour(255,255,255,255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 150)
        SetTextDropshadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local function startThread2(params)
    if params then
        if blipsStatus[params] then
            blipsStatus[params] = nil
        else
            blipsStatus[params] = true
        end
    end
    local mySource = GetPlayerServerId(GetSourceByPed(PlayerPedId()))
    Citizen.CreateThread(function()
        while adminMode do
            local timeIdle = 999
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            for k,v in pairs(GetActivePlayers()) do
                local targetSource = GetPlayerServerId(v)
                local targetPed = GetPlayerPed(v)
                local targetCoords = GetEntityCoords(targetPed)
                local x1, y1, z1 = table.unpack( GetEntityCoords( PlayerPedId(), true ) )
                local x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( v ), true ) )
                local meters = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                if PlayerPedId() ~= GetPlayerPed(v) then
                    if GetEntityHealth(targetPed) > 101 then
                        if targetPed and userList[targetSource] then
                            local drawStr = ""
                            if #(coords - targetCoords) <= 425 and not userList[targetSource].hidden then
                                timeIdle = 0
                                if userList[targetSource].noclip == nil or userList[targetSource].noclip == false then
                                    if userList[targetSource].teamname ~= nil then
                                        drawStr = drawStr..""..userList[targetSource].teamname.." | ~w~"..userList[targetSource].surname..""
                                    else
                                        drawStr = drawStr.."["..userList[targetSource].group.."] ~w~"..userList[targetSource].surname..""
                                    end
                                end
                                drawAdmin2(targetCoords.x, targetCoords.y, targetCoords.z+1.0,drawStr)
                            end
                        end
                    end
                end
            end
            Citizen.Wait(timeIdle)
        end
    end)
end

function GetSourceByPed(id)
	for _, player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)
		if (ped == id) then
			return player
		end
	end
	return nil
end

function client.toggleAdmin2(params)
    if params then
        startThread(params)
        return
    end

    if adminMode then
        adminMode = false
        return false
    else
        adminMode = true
        if params then
            startThread2(params)
        else
            startThread2()
        end
        return true
    end
end