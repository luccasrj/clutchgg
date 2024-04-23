local userList = {}
local adminList = {}
local teamname = {}
AddEventHandler("vRP:playerSpawn",function(userId,source)
    Citizen.SetTimeout(5000,function()
        local identity = vRP.userIdentity(userId)

        local set = Group.getHigher(userId) or "Player"

		TriggerClientEvent("vrp:playerActive",source,user_id,identity.surname,set)

        local timePlayed = exports["common"]:PlayedTime().getDefault(identity.steam)
        userList[source] = {
            userId = userId,
            noclip = nil,
            teamname = nil,
            surname = (identity.surname) or "N/A",
            timePlayed = timePlayed or 0,
            group = Group.getHigher(userId),
            blipsEnabled = adminList[userId] and true or false
        }

        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList2",v,userList)
        end
    end)
end)

AddEventHandler("vRP:playerLeave",function(userId,source)
    if userList[source] then
        userList[source] = nil
    end

    if adminList[userId] then
        adminList[userId] = nil
    end

    teamname[source] = {}

    for k,v in pairs(adminList) do
        TriggerClientEvent("common:admin_blips:updateList2",v,userList)
    end
end)

local function loadPlayers2()
    Citizen.SetTimeout(2000,function()
        local users = vRP.userList()
        for id,src in pairs(users) do
            if userList[src] and userList[src].hidden then
                goto skip
            end

            if teamname[src] == {} then
                teamname[src] = nil
            end

            local identity = vRP.userIdentity(id)
            local timePlayed = exports["common"]:PlayedTime().getDefault(identity.steam)
            userList[src] = {
                userId = id,
                src = src,
                noclip = Player(src).state.inNoclip,
                teamname = teamname[src],
                surname = (identity.surname) or "N/A",
                timePlayed = timePlayed or 0,
                group = Group.getHigher(id),
                blipsEnabled = adminList[id] and true or false
            }

            ::skip::
        end
    
        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList2",v,userList)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local users = vRP.userList()
        for id,src in pairs(users) do
            if userList[src] and userList[src].hidden then
                goto skip
            end

            if teamname[src] == {} then
                teamname[src] = nil
            end

            local identity = vRP.userIdentity(id)
            local timePlayed = exports["common"]:PlayedTime().getDefault(identity.steam)
            userList[src] = {
                userId = id,
                src = src,
                noclip = Player(src).state.inNoclip,
                teamname = teamname[src],
                surname = (identity.surname) or "N/A",
                timePlayed = timePlayed or 0,
                group = Group.getHigher(id),
                blipsEnabled = adminList[id] and true or false
            }

            ::skip::
        end

        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList2",v,userList)
        end

        Citizen.Wait(5000)
    end
end)

RegisterNetEvent("clutch-gg:sendteam",function(source,nome)
    teamname[source] = nome
end)
RegisterNetEvent("clutch-gg:removeteam",function()
    local source = source
    teamname[source] = nil
end)

AddEventHandler("onResourceStart",function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    loadPlayers2()
end)

RegisterCommand("am",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    local is_staff = exports["common"]:Group().hasPermission(userId,"staff") or exports["common"]:Group().hasPermission(userId,"strmer")
    if not is_staff then 
        return
    end

    local res = client.toggleAdmin2(source,args[1])
    if res then
        adminList[userId] = source
        userList[source].blipsEnabled = true
        
        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList2",v,userList)
        end
    else
        adminList[userId] = nil
        userList[source].blipsEnabled = false

        for k,v in pairs(adminList) do
            TriggerClientEvent("common:admin_blips:updateList2",v,userList)
        end
    end
end)

exports("checkHidden", function(source)
    if userList[source] and userList[source].hidden then
        return true
    end
    return false
end)