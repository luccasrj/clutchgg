local webhooks = {}
local discordUsername = "CLUTCH"
local discordAvatar = "https://cdn.discordapp.com/attachments/946174904284368936/1229671539952058398/discord.png?ex=663087dd&is=661e12dd&hm=e163e2a9c3e0b8c87ea8012661232f262fefa1a724f0aca23d1256c834bb9271&" --URL

Log = {}

function Log.load(res)
    local query = exports.oxmysql:query_async("SELECT * FROM logs")
    local list = {}
    if #query > 0 then
        for _,v in pairs(query) do
            webhooks[v.name] = v.link
            table.insert(list,v.name)
        end
    end

    if res then
        return list
    end
end

function Log.simple(webhook,message)
    PerformHttpRequest(webhooks[webhook],function(err,text,headers) end,"POST",json.encode({
        content = message
    }),{ ["Content-Type"] = "application/json" })
end

function Log.embedSimple(webhook,message,color)
    if not color then
        color = 3092790
    end

    PerformHttpRequest(webhooks[webhook],function(err,text,headers) end,"POST",json.encode({
        username = discordUsername,
        avatar_url = discordAvatar,
        embeds = { { color = color, description = message } }
    }),{ ["Content-Type"] = "application/json" })
end

function Log.embedDiscord(userId,name,discord2,webhook,message,color,screenshot)
    userId = parseInt(userId)
    local identity = vRP.userIdentity(userId)
    local steam = vRP.getSteam(userId)
    local discord = vRP.getDiscord(userId)
    
    color = 16084034
    
    if not name and not discord2 then
        PerformHttpRequest(webhooks[webhook],function(err,text,headers) end,"POST",json.encode({
            username = discordUsername,
            avatar_url = discordAvatar,
            embeds = { { color = color, description = "ID: "..userId.."\nNome: "..identity.surname.." \nDiscord: <@"..(discord or "N/A")..">\nSteam: "..steam.." ("..(GetPlayerName(vRP.userSource(userId)) or "N/A")..")\n\n"..message } }
        }),{ ["Content-Type"] = "application/json" })
        if screenshot then
            local source = vRP.userSource(userId)
            if source then
                exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(source,webhooks[webhook],
                    {
                        encoding = "png",
                        quality = 1
                    },
                    {
                        username = discordUsername,
                        avatar_url = discordAvatar,
                    },
                    30000,
                    function(error)
                        if error then
                            return print("^1Erro ao enviar screenshot: "..error.."^7")
                        end
                    end
                )
            end
        end
    elseif name and discord2 then
        PerformHttpRequest(webhooks[webhook],function(err,text,headers) end,"POST",json.encode({
            username = discordUsername,
            avatar_url = discordAvatar,
            embeds = { { color = color, description = "ID: "..userId.."\nNome: "..identity.surname.." \nDiscord: <@"..discord2..">\nSteam: "..steam.." ("..name..")\n\n"..message } }
        }),{ ["Content-Type"] = "application/json" })
        if screenshot then
            local source = vRP.userSource(userId)
            if source then
                exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(source,webhooks[webhook],
                    {
                        encoding = "png",
                        quality = 1
                    },
                    {
                        username = discordUsername,
                        avatar_url = discordAvatar,
                    },
                    30000,
                    function(error)
                        if error then
                            return print("^1Erro ao enviar screenshot: "..error.."^7")
                        end
                    end
                )
            end
        end
    end
end

AddEventHandler("onResourceStart",function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    Log.load()
end)

RegisterCommand("updatelogs",function(source,args,rawCmd)
    if source == 0 then
        local res = Log.load(true)
        for k,v in pairs(res) do
            print("[^3WARNING^7] Recarregado log "..v.." com sucesso.")
        end
        return
    end

    local userId = vRP.getUserId(source)
    if userId then
        if not exports["common"]:Group().hasAccessOrHigher(userId,"dev") then
            return
        end

        Log.load()
        TriggerClientEvent("Notify",source,"sucesso","Recarregado todas as logs.")
    end
end)

exports("Log", function()
    return Log
end)