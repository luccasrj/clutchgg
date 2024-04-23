--- @params
--- @source = player source
function vRP.getSteamBySource(source)
    local identifiers = GetPlayerIdentifiers(source)
    for k,v in ipairs(identifiers) do
        if string.match(v,"steam:") then
            return v:gsub("steam:","")
        end
    end
	return false
end

--- @params
--- @userId = player id
function vRP.getSteam(userId)
    local source = vRP.userSource(userId)
    if source then
        local identifiers = GetPlayerIdentifiers(source)
        for k,v in ipairs(identifiers) do
            if string.match(v,"steam:") then
                return v:gsub("steam:","")
            end
        end
    end

    local steamQuery = exports.oxmysql:query_async("SELECT `steam` FROM `characters` WHERE `id` = @id",{ id = userId })
    if #steamQuery > 0 then
        return steamQuery[1].steam
    end

	return false
end

--- @params
--- @playerSource = player source
function vRP.getDiscordBySource(source)
    if source then
        local identifiers = GetPlayerIdentifiers(source)
        for k,v in ipairs(identifiers) do
            if string.match(v,"discord:") then
                return v:gsub("discord:","")
            end
        end
    end
	return false
end

--- @params
--- @userId = player Id
function vRP.getDiscord(userId)
    local source = vRP.userSource(userId)
    if source then
        local identifiers = GetPlayerIdentifiers(source)
        for k,v in ipairs(identifiers) do
            if string.match(v,"discord:") then
                return v:gsub("discord:","")
            end
        end
    end


    local steam = vRP.getSteam(userId)
    if not steam then
        return false
    end

    local discordQuery = exports.oxmysql:query_async("SELECT `discord` FROM `accounts` WHERE `steam` = @steam",{ steam = steam })
    if #discordQuery > 0 then
        return discordQuery[1].discord
    end

	return false
end