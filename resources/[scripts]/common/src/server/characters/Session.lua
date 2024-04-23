local quarentine = false
local quarentineStatus = {}
local usersLocked = {}
local renameWebhook = "#"

function kickAll() 
    print("[^1Session^7] Iniciando o sistema de desligamento.")
	exports["vrp"]:updateMaintenance(true)

	local playerList = vRP.userList()
	for k,v in pairs(playerList) do
		vRP.kick(k,"Você foi desconectado(a), pois o servidor foi reiniciado.")
		Citizen.Wait(100)
	end
	
	TriggerEvent("admin:KickAll")
end
AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 120 then
		CreateThread(function()
			Wait(60000)
			kickAll() 
		end)
	end
end)

RegisterCommand("kickall",function(source,args,rawCommand)
    if source ~= 0 then
        return
    end

    kickAll()
end)

local identifiers = {}

identifiers.getPlayerIdentifiers = function(source)
    local res = {
        license = 'N/A',
    }

    -- print('PLAYER IDENTIFIERS: '..json.encode(GetPlayerIdentifiers(src)))
    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            res.license = v
		end
    end

    -- print('PLAYER IDENTIFIERS: '..json.encode(res))
    return res
end

AddEventHandler("vRP:playerSpawn",function(userId,source)
	local steam = vRP.getSteamBySource(source)
	local identity = vRP.userIdentity(userId)
	local license = identifiers.getPlayerIdentifiers(source).license
	exports.oxmysql:query("UPDATE `accounts` SET `license` = @license WHERE `steam` = @steam",{ steam = steam, license = license })
	if not identity then
		return
	end

	local discordQuery = exports.oxmysql:query_async("SELECT `discord` FROM `accounts` WHERE `steam` = @steam AND `discord` IS NOT NULL",{ steam = steam })
	if #discordQuery > 0 then
		PerformHttpRequest(renameWebhook, function(err, text, headers)
		end, 'POST', json.encode({ content = discordQuery[1].discord.." "..userId.." "..identity.surname }), { ['Content-Type'] = 'application/json' })
	end
end)

local function format(time)
    local days = math.floor(time/86400)
    local hours = math.floor(math.fmod(time, 86400)/3600)
    local minutes = math.floor(math.fmod(time,3600)/60)
    local seconds = math.floor(math.fmod(time,60))
    if days > 0 then
        return string.format("%d dia(s) e %d hora(s)",days,hours)
    elseif hours > 0 then
        return string.format("%d hora(s) e %d minuto(s)",hours,minutes)
    elseif minutes > 0 then        
        return string.format("%d minuto(s) e %d segundos",minutes,seconds)
    else
        return string.format("%d segundos",seconds)
    end
end