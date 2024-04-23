local punishmentsList = {}
local tokensBanned = {}
local tokensID = {}
local usersMuted = {}
local ToleranceBans = 0
Ban = {}

function getPlayerTokenHash(src)
    if src then
        local token_amount = GetNumPlayerTokens(src)
        local token_bigstring = {}

        for i = 1, token_amount do
            local addition = GetPlayerToken(src, i)
            if addition then
                table.insert(token_bigstring,addition)
            end
        end

        return token_bigstring
    else
        return {}
    end
end

function insertPlayerToken(src)
    if src then
        local steam = vRP.getSteamBySource(src)
        if steam then 
            local userToken = getPlayerTokenHash(src)
            if userToken then 
                userToken = json.encode(userToken)
                exports.oxmysql:query("UPDATE `accounts` SET `token`=:token WHERE `steam`=:steam;",{
                    token = userToken,
                    steam = steam
                })            
            end
            return userToken
        end
    end
end

local function getTokenBySteam(steam)
    if steam then 
        local query = exports.oxmysql:query_async("SELECT token FROM `accounts` WHERE steam =:steam",  { steam = steam })
        if query then
           return query[1].token
        end
    end
end

function Ban.format(seconds)
    local temp = os.date("*t", parseInt(seconds))
    local txt = temp.day .. "/" .. temp.month .. "/" .. temp.year .. " - " .. temp.hour .. ":" .. temp.min .. ":" .. temp.sec
    return txt
end

function Ban.load()
    local punishmentsQuery = exports.oxmysql:query_async("SELECT * FROM `punishments`")
    if #punishmentsQuery > 0 then
        for _,value in pairs(punishmentsQuery) do
            punishmentsList[value.id] = { displayName = value.name, category = value.category, duration = value.duration }
            Citizen.Wait(5)
        end
    else
        print("[^1WARNING^7] Não há nenhuma punição cadastrada.")
    end

    local tokensQuery = exports.oxmysql:query_async("SELECT * FROM `bans`")
    if #tokensQuery > 0 then
        for _,value in pairs(tokensQuery) do
            local tokens = json.decode(value.token)
            tokensID[value.id] = { 
                token = tokens,
                steam = value.steam,
                expire_time = value.expire_time or "PERM",
                category = value.category,
                is_active = value.is_active,
                id = value.id,
                reason = value.reason or "Sem motivo registrado",
            }
            if tokens ~= nil then
                for k,v in pairs(tokens) do
                    if value.is_active == 1 then 
                        table.insert(tokensBanned,v.."-"..value.id)
                    end
                end
            end

            if value.category == "mute" then 
                usersMuted[value.steam] = {
                    steam = value.steam,
                    expire_time = value.expire_time or "PERM",
                    category = value.category,
                    is_active = value.is_active,
                    id = value.id,
                    reason = value.reason or "Sem motivo registrado",
                }
            end

            Citizen.Wait(5)
        end
    else
        print("[^1WARNING^7] Não há nenhuma ban registrado.")
    end
end


function checkIsTokenBanned(tokens) 
    local amount_tokens = 0
    local pass = false
    for id,value in pairs(tokensBanned) do
        token = splitString(value,"-")
        if type(tokens) == "string" then 
            tokens = json.decode(tokens) 
        end
        for _,v in pairs(tokens) do
            if token[1] == v then 
                amount_tokens = (amount_tokens) + 1
                pass = true
            end
        end
    end
    if pass then 
        return true, tonumber(token[2]), amount_tokens
    end
    return false
end

function checkIsBanned(steam, token) 
    for id,value in pairs(tokensID) do
        if (value.steam == steam and value.is_active == 1 and value.category ~= "mute") then 
            return true, tokensID[id], amount or 0
        end
    end
    local token_ban, id_token, amount = checkIsTokenBanned(token)
    if (token_ban and amount and amount > ToleranceBans and tokensID[id_token].is_active == 1 and tokensID[id_token].category ~= "mute") then 
        return true, tokensID[id_token], amount or 0
    end
    return false
end

function Ban.isMuted(targetId)
    local steam = vRP.getSteam(targetId)
    if steam then
        local userProp = usersMuted[steam]
        if userProp then
            if userProp.is_active >= 1 then 
                return userProp.expire_time, userProp.reason
            end
        end
    end
    return false
end

function Ban.removeMuted(targetId)
    local steam = vRP.getSteam(targetId)
    if steam then
        local userProp = usersMuted[steam]
        if userProp then
            if userProp.is_active >= 1 then 
                exports.oxmysql:query("UPDATE `bans` SET `is_active` = false WHERE `id` = @id",{ id = userProp.id })
                usersMuted[steam] = nil
            end
        end
    end
end

function Ban.is(src,steam,token)
    local token = token or getPlayerTokenHash(src)
    local is_banned, data, amount_tokens_banned = checkIsBanned(steam, token)
    if is_banned then
        if os.time() >= parseInt(data.expire_time) then
            local rows = exports.oxmysql:executeSync("UPDATE `bans` SET `is_active` = false WHERE `id` = @id",{ id = data.id })
            if rows.affectedRows > 0 then 
                tokensID[data.id].active = 0
            end
            return false
        end
        return data
    end
    return false
end

function Ban.removeBanned(steam)
    local token = getTokenBySteam(steam)
    local is_banned, data, amount_tokens_banned = checkIsBanned(steam, token)
    if is_banned then
        tokensID[data.id].active = 0
        Ban.load()
        return data
    end
    return false
end

function Ban.removeUserBan(targetId,pusher)
    local steam = vRP.getSteam(targetId)
    if steam then
        local token = getTokenBySteam(steam)
        local is_banned, data, amount_tokens_banned = checkIsBanned(steam, token)
        if is_banned then
            local rows = exports.oxmysql:executeSync("UPDATE `bans` SET `is_active` = false WHERE `id` = @id",{ id = data.id })
            if rows.affectedRows > 0 then 
                tokensID[data.id].active = 0
                if pusher and pusher ~= 0 then 
                    TriggerClientEvent("Notify",pusher,"sucesso","Usuário <b>"..targetId.."</b> desbanido.")
                    exports["common"]:Log().embedDiscord(vRP.getUserId(pusher),nil,nil,"commands-unban","**ID:**```"..targetId.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
                else
                    print("Usuario desbanido!")
                end
            else
                if pusher and pusher ~= 0 then 
                    TriggerClientEvent("Notify",pusher,"negado","Banimento não encontrado.")
                else
                    print("Banimento não encontrado.")
                end
            end
        end
        Ban.load()
    end
end

function Ban.intelligence(targetId,punishmentId,staffId)
    targetId = parseInt(targetId)
    punishmentId = parseInt(punishmentId)
    local steam = vRP.getSteam(targetId)
    local targetSource = vRP.userSource(parseInt(targetId))

    local staffSource = vRP.userSource(staffId)
    if not punishmentsList[punishmentId] then
        if staffSource then 
            return TriggerClientEvent("Notify",staffSource,"negado","Punição <b>"..punishmentId.."</b> não existe.")
        else
            return
        end
    end

    if Ban.is(targetSource,steam,getTokenBySteam(steam)) then
        if staffSource then 
            return TriggerClientEvent("Notify",staffSource,"negado","Usuário <b>"..targetId.."</b> já possui uma punição ativa.")
        else
            return
        end
    end

    if staffId == 0 or vRP.request(staffSource,"Você deseja aplicar um banimento em <b>"..targetId.."</b> por <b>"..punishmentsList[punishmentId].displayName.."</b>?",30) then
        local token = getTokenBySteam(steam) or getPlayerTokenHash(targetSource)
        if punishmentsList[punishmentId].category:lower() == "tempban" then
            local timeFormatted = punishmentsList[punishmentId].duration + os.time() or 0
            exports.oxmysql:query("INSERT INTO `bans` (`steam`,`reason`,`category`,`expire_time`,`staff_id`, `token`) VALUES (@steam,@reason,@category,@expire_time,@staff_id,@token)",{
                steam = steam,
                reason = punishmentsList[punishmentId].displayName,
                category = "tempban",
                expire_time = timeFormatted,
                staff_id = staffId or 0,
                token = token
            })

            if staffSource then
                TriggerClientEvent("Notify",staffSource,"sucesso","Usuário <b>"..targetId.."</b> foi banido temporariamente devido a <b>"..punishmentsList[punishmentId].displayName.."</b> até <b>"..Ban.format(timeFormatted).."</b>.",15000)
            end
            
            vRP.kick(targetId,"\n\nSeu acesso a comunidade foi revogado até "..Ban.format(timeFormatted)..".\n\nMotivo: "..punishmentsList[punishmentId].displayName.."\nPara mais informações entre em contato via Ticket.")
        elseif punishmentsList[punishmentId].category:lower() == "mute" then
            if not Ban.isMuted(targetId) then 
                exports.oxmysql:query("INSERT INTO `bans` (`steam`,`reason`,`category`,`staff_id`, `token`) VALUES (@steam,@reason,@category,@staff_id,@token)",{
                    steam = steam,
                    reason = punishmentsList[punishmentId].displayName,
                    category = "mute",
                    staff_id = staffId or 0,
                    token = token
                })
    
                if staffSource then
                    TriggerClientEvent("Notify",staffSource,"sucesso","Usuário <b>"..targetId.."</b> foi mutado.",15000)
                end

            else
                if staffSource then
                    TriggerClientEvent("Notify",staffSource,"sucesso","Usuário <b>"..targetId.."</b> ja esta mutado.",15000)
                end
            end
            
        else
            exports.oxmysql:query("INSERT INTO `bans` (`steam`,`reason`,`category`,`staff_id`, `token`) VALUES (@steam,@reason,@category,@staff_id,@token)",{
                steam = steam,
                reason = punishmentsList[punishmentId].displayName,
                category = "ban",
                staff_id = staffId or 0,
                token = token
            })

            if staffSource then
                TriggerClientEvent("Notify",staffSource,"sucesso","Usuário <b>"..targetId.."</b> foi banido permanentemente devido a <b>"..punishmentsList[punishmentId].displayName.."</b>.",15000)
            end

            vRP.kick(targetId,"\n\nSeu acesso a comunidade foi revogado permanentemente.\n\nMotivo: "..punishmentsList[punishmentId].displayName.."\nPara mais informações entre em contato via Ticket.")
        end
        Ban.load()
    end
end

AddEventHandler("onResourceStart",function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    Ban.load()
end)

RegisterCommand("punicoes",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end

    local str = ""
    for k,v in pairs(punishmentsList) do
        str = str .."<br>"..v.displayName.." | <b>ID:</b> "..k
    end

    TriggerClientEvent("Notify",source,"sucesso","Lista de punições<br>"..str.."",30000,"normal")
end)

AddEventHandler("Queue:playerConnecting",function(source,_,deferrals) 
	local source = source
    local userToken = insertPlayerToken(source)
    if userToken then 
        local steam = vRP.getSteamBySource(source)
	    local ban = exports["common"]:Ban().is(src, steam, userToken)
        if ban then 
            if ban.category == "ban" then
                deferrals.done("\n\nSeu acesso a comunidade foi revogado permanentemente.\n\nMotivo: "..ban.reason.."\nSua steam: "..steam.."\nPara mais informações entre em contato via Ticket.")
            else
                deferrals.done("\n\nSeu acesso a comunidade foi revogado permanentemente até "..exports["common"]:Ban().format(ban.expire_time).."\n\nMotivo: "..ban.reason.."\nSua steam: "..steam.."\nPara mais informações entre em contato via Ticket.")
            end
        end
    end
end)

exports("Ban", function()
    return Ban
end)