local timePlayed = {}

PlayedTime = {}

function PlayedTime.format(time)
    local days = math.floor(time/86400)
    local hours = math.floor(math.fmod(time, 86400)/3600)
    local minutes = math.floor(math.fmod(time,3600)/60)
    local seconds = math.floor(math.fmod(time,60))
    if days > 0 then
        return string.format("<b>%d dia(s)</b> e <b>%d hora(s)</b>",days,hours)
    elseif hours > 0 then
        return string.format("<b>%d hora(s)</b> e <b>%d minuto(s)</b>",hours,minutes)
    elseif minutes > 0 then        
        return string.format("<b>%d minuto(s)</b> e <b>%d segundos</b>",minutes,seconds)
    else
        return string.format("<b>%d segundos</b>",seconds)
    end
end

function PlayedTime.get(steam)
    local timeQuery = exports.oxmysql:query_async("SELECT `time_played` FROM `accounts` WHERE `steam` = @steam",{ steam = steam })
    if #timeQuery > 0 then
        if timeQuery[1].time_played <= 0 then
            return "RECÉM-CHEGADO(A)"
        end

        return PlayedTime.format(timeQuery[1].time_played)
    end
end

function PlayedTime.getDefault(steam)
    local timeQuery = exports.oxmysql:query_async("SELECT `time_played` FROM `accounts` WHERE `steam` = @steam",{ steam = steam })
    if #timeQuery > 0 then
        return timeQuery[1].time_played
    end
end

function PlayedTime.getTime(userId,steam)
    if timePlayed[userId] then
        local timeQuery = exports.oxmysql:query_async("SELECT `time_played` FROM `accounts` WHERE `steam` = @steam",{ steam = steam })
        if #timeQuery > 0 then
            return timeQuery[1].time_played + (os.time() - timePlayed[userId])
        end
    else
        local timeQuery = exports.oxmysql:query_async("SELECT `time_played` FROM `accounts` WHERE `steam` = @steam",{ steam = steam })
        if #timeQuery > 0 then
            return timeQuery[1].time_played
        end
    end
end


AddEventHandler("vRP:playerSpawn",function(userId,source)
    timePlayed[userId] = os.time()
end)

AddEventHandler("vRP:playerLeave",function(userId,source)
    if userId then
        if timePlayed[userId] then
            local steam = vRP.getSteamBySource(source)
            local timeFormatted = os.time() - timePlayed[userId]
            exports.oxmysql:query("UPDATE `accounts` SET `time_played` = `time_played` + @time_played WHERE steam = @steam",{ steam = steam, time_played = timeFormatted })
            timePlayed[userId] = nil
        end
    end
end)

exports("PlayedTime",function()
    return PlayedTime
end)