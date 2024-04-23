-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
tvRP = {}
vRP.userIds = {}
vRP.userTables = {}
vRP.userSources = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNER/PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy.addInterface("vRP",vRP)
Tunnel.bindInterface("vRP",tvRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MYSQL
-----------------------------------------------------------------------------------------------------------------------------------------
local mysqlDriver
local userSql = {}
local mysqlInit = false
local maintenance = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CACHE
-----------------------------------------------------------------------------------------------------------------------------------------
local cacheQuery = {}
local cachePrepare = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERDBDRIVER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.registerDBDriver(name,on_init,on_prepare,on_query)
	if not userSql[name] then
		userSql[name] = { on_init,on_prepare,on_query }
		mysqlDriver = userSql[name]
		mysqlInit = true

		for _,prepare in pairs(cachePrepare) do
			on_prepare(table.unpack(prepare,1,table.maxn(prepare)))
		end

		for _,query in pairs(cacheQuery) do
			query[2](on_query(table.unpack(query[1],1,table.maxn(query[1]))))
		end

		cachePrepare = {}
		cacheQuery = {}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETXT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateTxt(archive,text)
	archive = io.open("resources/logsystem/"..archive,"a")
	if archive then
		archive:write(text.."\n")
	end

	archive:close()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.prepare(name,query)
	if mysqlInit then
		mysqlDriver[2](name,query)
	else
		table.insert(cachePrepare,{ name,query })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.query(name,params,mode)
	if not mode then mode = "query" end

	if mysqlInit then
		return mysqlDriver[3](name,params or {},mode)
	else
		local r = async()
		table.insert(cacheQuery,{{ name,params or {},mode },r })
		return r:wait()
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXECUTE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.execute(name,params)
	return vRP.query(name,params,"execute")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFOACCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.infoAccount(steam)
	local infoAccount = vRP.query("accounts/getInfos",{ steam = steam })
	if infoAccount[1] then
		return infoAccount[1]
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userData(user_id,key)
	local consult = vRP.query("playerdata/getUserdata",{ user_id = parseInt(user_id), key = key })
	if consult[1] then
		return json.decode(consult[1]["dvalue"])
	else
		return {}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userInventory(user_id)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable then
		if dataTable["inventory"] == nil then
			dataTable["inventory"] = {}
		end

		return dataTable["inventory"]
	end

	return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUSERINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setUserInventory(user_id,inv)
    local dataTable = vRP.getDatatable(user_id)
    if dataTable then
        dataTable["inventory"] = inv
    end

    return dataTable["inventory"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESELECTSKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateSelectSkin(user_id,hash)
	local dataTable = vRP.getDatatable(user_id)
	if dataTable then
		dataTable["skin"] = hash
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERID
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserId(source)
	return vRP.userIds[parseInt(source)]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userList()
	return vRP.userSources
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.userPlayers()
	return vRP.userIds
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERSOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.userSource(user_id)
	return vRP.userSources[parseInt(user_id)]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getDatatable(user_id)
	return vRP.userTables[parseInt(user_id)]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function(reason)
	playerDropped(source,reason)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.kick(user_id,reason)
	local userSource = vRP.userSource(user_id)
	if userSource then
		playerDropped(userSource,"Kick/Afk")
		DropPlayer(userSource,reason)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
function playerDropped(source,reason)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getDatatable(user_id)
		if dataTable then
			local discord = vRP.getDiscord(user_id)
			local name = GetPlayerName(vRP.userSource(user_id))
			exports["common"]:Log().embedDiscord(user_id,name,discord,"usuario-desconectou","Desconectou-se às "..os.date("%d/%m/%y %H:%M:%S"))
			TriggerEvent("vRP:playerLeave",user_id,source)
			vRP.execute("playerdata/setUserdata",{ user_id = parseInt(user_id), key = "Datatable", value = json.encode(dataTable) })
			vRP.userSources[parseInt(user_id)] = nil
			vRP.userTables[parseInt(user_id)] = nil
			vRP.userIds[parseInt(source)] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEINFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.userUpdate(pHealth)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local dataTable = vRP.getDatatable(user_id)
		if dataTable then
			dataTable["health"] = parseInt(pHealth)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEUSER
-----------------------------------------------------------------------------------------------------------------------------------------
local function createUser(steam)
	local accountQuery = exports.oxmysql:query_async("SELECT `whitelist` FROM `accounts` WHERE `steam` = @steam",{ steam = steam })
	if #accountQuery <= 0 then
		exports.oxmysql:query("INSERT INTO `accounts` (`steam`) VALUES (@steam)",{ steam = steam })
		return false
	end

	if accountQuery[1].whitelist == 1 then
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
local tkn = "Bot "..KADOKASODKASOKDOASKD
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDAPIREQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
local function discordAPIRequest(method,endpoint,jsonData)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = { data = resultData, code = errorCode, headers = resultHeaders}
    end, method, #jsonData > 0 and json.encode(jsonData) or "", {["Content-Type"] = "application/json", ["Authorization"] = tkn })

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISINDISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
local function isInDiscord(discordId)
    if discordId then
        local endpoint = ("guilds/%s/members/%s"):format(GUILD_ID,discordId)
        local member = discordAPIRequest("GET",endpoint,{})
        if member.code == 200 then
			return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Queue:playerConnecting",function(source,identifiers,deferrals)
	local src = source
	local steam = vRP.getSteamBySource(source)
	if not steam then
		deferrals.done("Não foi possível encontrar sua Steam.")
		TriggerEvent("Queue:removeQueue",identifiers)
		return
	end


	local ban = exports["common"]:Ban().is(source, steam)
	if ban then 
		print("User Banned connecting... | Steam: ["..ban.steam.."]; Reason: ["..ban.reason.."]; ID punish: ["..ban.id.."]")
		if ban.category == "ban" then
			deferrals.done("\n\nSeu acesso a comunidade foi revogado permanentemente.\n\nMotivo: "..ban.reason.."\nSua steam: "..steam.."\nPara mais informações entre em contato via Ticket.\n\nPowered by LAST SURVIVOR")
			return
		else
			deferrals.done("\n\nSeu acesso a comunidade foi revogado temporariamente até "..exports["common"]:Ban().format(ban.expire_time).."\n\nMotivo: "..ban.reason.."\nSua steam: "..steam.."\nPara mais informações entre em contato via Ticket.\n\nPowered by LAST SURVIVOR")
			return
		end
	end

	local whitelisted = createUser(steam,src)
	if not whitelisted then
		deferrals.done(""..steam.."\n\nhttps://discord.gg/clutchgg")
		TriggerEvent("Queue:removeQueue",identifiers)
		return
	end

	exports.oxmysql:query("UPDATE `accounts` SET `last_login` = NOW(), `endpoint` = @endpoint WHERE `steam` = @steam",{ steam = steam, endpoint = (GetPlayerEndpoint(source) or "0.0.0.0") })
	deferrals.done()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.characterChosen(source,user_id,model)
	vRP.userIds[source] = user_id
	vRP.userSources[user_id] = source
	vRP.userTables[user_id] = vRP.userData(user_id,"Datatable")

	if model ~= nil then
		vRP.userTables[user_id]["skin"] = GetHashKey(model)
	end

	TriggerEvent("vRP:playerSpawn",user_id,source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetGameType("LAST SURVIVOR")
	SetMapName("LAST SURVIVOR")
	SetRoutingBucketEntityLockdownMode(0,"relaxed")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETBANNED REPLACEMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setBanned(userId,banned)
	if banned then
		vRP.kick(userId,"Seu acesso a comunidade foi revogado permanentemente por suspeita de trapaça.")
		exports["common"]:Ban().intelligence(userId,10,0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPLACEMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasPermission(userId,permission)
	return exports["common"]:Group().hasPermission(userId,permission)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERSBYPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUsersByPermission(perm)
	return exports["common"]:Group().getAllByPermission(perm)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE
-----------------------------------------------------------------------------------------------------------------------------------------
function updateMaintenance(status)
	maintenance = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("updateMaintenance",updateMaintenance)

vRP.getUserSource = vRP.userSource
vRP.getUserIdentity = vRP.userIdentity