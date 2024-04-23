-----------------------------------------------------------------------------------------------------------------------------------------
-- PRIVATEVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local secret = "MTIyNTI5MzA3ODQyMDc4MzE4Nw.GDtjyo.AYXrloRB9nJhcXuo7vG_UAQU6Yvk9vO4w-P90k" --TOKEN DO BOT
local guildId = "1215703403737649254" --ID DO SERVIDOR
local server_token = "Bot "..secret
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local discordTags = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADPLAYERROLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("clutch:UpdateRoles",function(source)
    local myRoles = GetRoles(source)
    if myRoles then
        discordTags[source] = myRoles
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASDISCORDTAG
-----------------------------------------------------------------------------------------------------------------------------------------
function hasDiscordTag(source,tagId)
    if discordTags[source] then
        for k,v in pairs(discordTags[source]) do
            if tostring(v) == tostring(tagId) then
                return true
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDREQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function DiscordRequest(method,endpoint,jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = { data = resultData, code = errorCode, headers = resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = server_token })

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASDISCORDROLE
-----------------------------------------------------------------------------------------------------------------------------------------
function hasDiscordRole(user,role)
    local discordId = nil

    for _,id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id,"discord:") then
            discordId = string.gsub(id,"discord:","")
            break;
        end 
    end

    local theRole = nil
    if type(role) == "number" then
        theRole = tostring(role)
    else
        theRole = Config["ROLES"][role]
    end

    if discordId then
        local endpoint = ("guilds/%s/members/%s"):format(guildId,discordId)
        local member = DiscordRequest("GET",endpoint,{})

        if member["code"] == 200 then
            local data = json.decode(member["data"])
            local roles = data["roles"]
            local found = true 
            for i=1,#roles do
                if roles[i] == theRole then
                    return true 
                end 
            end 
            return false 
        else
            return false
        end
    else
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASDISCORDROLE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetRoles(user)
    local discordId = nil
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end

    if discordId then
        local endpoint = ("guilds/%s/members/%s"):format(guildId, discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            local roles = data.roles
            local found = true
            return roles
        else
            return false
        end
    else
        return false
    end
end
---------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
---------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("update",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    TriggerEvent("clutch:UpdateRoles",source,source)
    Citizen.SetTimeout(2000,function()
        for k,v in pairs(Config.ROLES) do
            if hasDiscordTag(source,v) then
                exports["common"]:Group().add(userId,k,userId)
            else
                if exports["common"]:Group().hasPermission(userId,k) then
                    exports["common"]:Group().remove(userId,k,userId)
                end
            end
            Citizen.Wait(50)
        end
    end)
    TriggerEvent("clutch:atualizar",source)
    TriggerClientEvent("Notify",source,"sucesso","Você atualizou seus grupos.")
end)
---------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
---------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(userId,source)
    TriggerEvent("clutch:UpdateRoles",source,source)
    Citizen.SetTimeout(2000,function()
        for k,v in pairs(Config.ROLES) do
            if hasDiscordTag(source,v) then
                exports["common"]:Group().add(userId,k,userId)
            else
                if exports["common"]:Group().hasPermission(userId,k) then
                    exports["common"]:Group().remove(userId,k,userId)
                end
            end
            Citizen.Wait(50)
        end
    end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASDISCORDROLE
-----------------------------------------------------------------------------------------------------------------------------------------
exports("hasDiscordRole",hasDiscordRole)
exports("hasDiscordTag",hasDiscordTag)