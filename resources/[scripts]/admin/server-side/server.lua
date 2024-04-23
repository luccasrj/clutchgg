-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("admin",cRP)
local cantTeleport = {}
vCLIENT = Tunnel.getInterface("admin")
local vehList = {}
local vehPlates = {}
local spawnTimers = {}
local vehHardness = {}
local searchTimers = {}
local vehSignal = {}
local dismantleVehicles = {}
local singleVeh = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") and args[1] then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			local mHash = GetHashKey(args[1])
			local vehObject = CreateVehicle(mHash,coords["x"],coords["y"],coords["z"],heading,true,true)

			while not DoesEntityExist(vehObject) do
				Citizen.Wait(1)
			end

			local netVeh = NetworkGetNetworkIdFromEntity(vehObject)
			local vehPlate = "VEH"..parseInt(math.random(10000,99999) + user_id)
			vCLIENT.createVehicle(-1,mHash,netVeh,vehPlate,1000,1000,100,nil,true,true,true,{ 1.25,0.75,0.95 })
			TriggerEvent("engine:insertEngines",netVeh,100,"")
			vehList[netVeh] = { user_id,vehName,vehPlate }
			TaskWarpPedIntoVehicle(ped,vehObject,-1)
			TriggerEvent("plateHardness",vehPlate,1)
			TriggerEvent("plateEveryone",vehPlate)
			vehPlates[vehPlate] = user_id
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nc",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if userId then
        local is_staff = exports["common"]:Group().hasPermission(userId,"staff") 
		local is_vip = exports["common"]:Group().hasPermission(userId,"nc") 
		local is_streamer = exports["common"]:Group().hasPermission(userId,"strmer")
		if is_staff or is_vip or is_streamer then 
			if Player(source).state.inNoclip then 
				Player(source).state.inNoclip = false
			else
				Player(source).state.inNoclip = true
			end
			
			if not vRPC.inVehicle(source) then
				vRPC.noClip(source)
			end
    	end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
        if exports["common"]:Group().hasPermission(user_id,"staff") then
			if args[1] then
				local nuser_id = parseInt(args[1])
				local otherPlayer = vRP.userSource(nuser_id)
				if otherPlayer then
					TriggerClientEvent("respawnPlayer",otherPlayer)
					FreezeEntityPosition(otherPlayer, false)
					exports["common"]:Log().embedDiscord(user_id,nil,nil,"commands-god","**ID:**```"..nuser_id.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
				end
			else
				TriggerClientEvent("respawnPlayer",source)
				FreezeEntityPosition(source, false)
				exports["common"]:Log().embedDiscord(user_id,nil,nil,"commands-god","**ID:**```"..user_id.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,args,rawCmd)
	local user_id = vRP.getUserId(source)
	if not user_id then
		return
	end
	if args[1] == "" then return end
	if not args[1] then return end
	local is_staff = exports["common"]:Group().hasPermission(user_id,"staff")
	if parseInt(args[1]) > 0 then
		local source2 = vRP.getUserSource(parseInt(args[1]))
		if cantTeleport[source2] == nil then			
			if source2 then
				if is_staff then	
					local ped = GetPlayerPed(source2)
					local coords = GetEntityCoords(ped)

					vRPC.teleport(source,coords["x"],coords["y"],coords["z"])

					local playerDimension = GetPlayerRoutingBucket(source2)
					SetPlayerRoutingBucket(source,parseInt(playerDimension))
					TriggerClientEvent("clutch-core:client:SetDimension",source2,playerDimension)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local weaponList = {
	["player"] = {
		[GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = {
			["attachments"] = {
				"COMPONENT_AT_AR_AFGRIP_02",
				"COMPONENT_AT_AR_FLSH",
				"COMPONENT_AT_MUZZLE_04",
				"COMPONENT_AT_SIGHTS",    
				"COMPONENT_AT_SCOPE_MEDIUM_MK2"
			},
		},
		[GetHashKey("WEAPON_ASSAULTRIFLE")] = {
			["attachments"] = {
				"COMPONENT_AT_AR_AFGRIP",
				"COMPONENT_AT_AR_FLSH",
				"COMPONENT_AT_SIGHTS",
				"COMPONENT_AT_SCOPE_MACRO"
			},
		},
		[GetHashKey("WEAPON_CARBINERIFLE")] = {
			["attachments"] = {
				"COMPONENT_AT_AR_AFGRIP",
				"COMPONENT_AT_AR_FLSH",
				"COMPONENT_AT_SCOPE_MEDIUM"
			},
		},
		["-86904375"] = { -- Carbine Rifle Mk2
			["attachments"] = {
				"COMPONENT_AT_AR_AFGRIP_02", 
				"COMPONENT_AT_AR_FLSH",
				"COMPONENT_AT_MUZZLE_04",  
				"COMPONENT_AT_SCOPE_MEDIUM_MK2", 
				"COMPONENT_AT_SIGHTS"
			},
		},
		[GetHashKey("WEAPON_SPECIALCARBINE")] = {
			["attachments"] = {
				"COMPONENT_AT_AR_AFGRIP",
				"COMPONENT_AT_AR_FLSH",
				"COMPONENT_AT_SCOPE_MEDIUM"
			},
		},
		[GetHashKey("WEAPON_SPECIALCARBINE_MK2")] = {
			["attachments"] = {
				"COMPONENT_AT_AR_AFGRIP_02",
				"COMPONENT_AT_AR_FLSH",
				"COMPONENT_AT_MUZZLE_04",
				"COMPONENT_AT_SCOPE_MEDIUM_MK2"
			},
		},
		[GetHashKey("WEAPON_MACHINEPISTOL")] = {
			["attachments"] = {
				"COMPONENT_MACHINEPISTOL_CLIP_02"
			},
		},
		[GetHashKey("WEAPON_SMG")] = {
			["attachments"] = {
				"COMPONENT_AT_AR_FLSH",
				"COMPONENT_AT_SCOPE_MACRO_02"
			},
		},
		[GetHashKey("WEAPON_SMG_MK2")] = {
			["attachments"] = {
				"COMPONENT_AT_AR_FLSH",
				"COMPONENT_AT_SCOPE_SMALL_SMG_MK2",
				"COMPONENT_AT_SIGHTS_SMG"
			},
		},
		[GetHashKey("WEAPON_PISTOL_MK2")] = {
			["attachments"] = {
				"COMPONENT_AT_PI_FLSH_02",
				"COMPONENT_AT_PI_COMP",
				"COMPONENT_AT_PI_RAIL"
			},
		},
		[GetHashKey("WEAPON_COMBATPISTOL")] = {
			["attachments"] = {
				"COMPONENT_AT_PI_FLSH",
				"COMPONENT_COMBATPISTOL_CLIP_02"
			},
		},
		[GetHashKey("WEAPON_APPISTOL")] = {
			["attachments"] = {
				"COMPONENT_AT_PI_FLSH",
				"COMPONENT_APPISTOL_CLIP_02"
			},
		},
		[GetHashKey("WEAPON_SNSPISTOL")] = {
			["attachments"] = {},
		},
		[GetHashKey("WEAPON_HEAVYPISTOL")] = {
			["attachments"] = {},
		},
	},
	["vip"] = {
		[GetHashKey("WEAPON_DAGGER")] = {},
		[GetHashKey("WEAPON_BAT")] = {},
		[GetHashKey("WEAPON_BOTTLE")] = {},
		[GetHashKey("WEAPON_FLASHLIGHT")] = {},
		[GetHashKey("WEAPON_HATCHET")] = {},
		[GetHashKey("WEAPON_KNIFE")] = {},
		[GetHashKey("WEAPON_MACHETE")] = {},
		[GetHashKey("WEAPON_SWITCHBLADE")] = {},
		[GetHashKey("WEAPON_NIGHTSTICK")] = {},
		[GetHashKey("WEAPON_REVOLVER_MK2")] = {},
		[GetHashKey("WEAPON_SNOWBALL")] = {}
	},	
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") and parseInt(args[1]) > 0 then
			TriggerClientEvent("Notify",source,"importante","Passaporte <b>"..args[1].."</b> expulso.",5000)
			vRP.kick(args[1],"Expulso da cidade.")
			exports["common"]:Log().embedDiscord(user_id,nil,nil,"commands-kick","**ID:**```"..args[1].."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wl",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if userId then
		if exports["common"]:Group().hasPermission(userId,"dev") then
			local user_steam
			local split_steam 
			if not args[1] then 
				user_steam = vRP.prompt(source,"Steam:","")
				if user_steam == "" then return false end
			else
				user_steam = args[1]
			end

			if string.match(user_steam,"steam") then 
				user_steam = splitString(user_steam,":")
			end

			local account_exist = vRP.infoAccount(user_steam[2] or user_steam)
			if account_exist then
				vRP.execute("accounts/infosWhitelist",{ whitelist = true, steam = (user_steam[2] or user_steam) })
				TriggerClientEvent("Notify",source,"sucesso","Steam autorizada.")
			else
				TriggerClientEvent("Notify",source,"negado","Steam não registrada.")
			end
			
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unwl",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if userId then
		if exports["common"]:Group().hasPermission(userId,"dev") then
			local user_steam
			local split_steam 
			if not args[1] then 
				user_steam = vRP.prompt(source,"Steam:","")
				if user_steam == "" then return false end
			else
				user_steam = args[1]
			end

			if string.match(user_steam,"steam") then 
				user_steam = splitString(user_steam,":")
			end

			local account_exist = vRP.infoAccount(user_steam[2] or user_steam)
			if account_exist then
				vRP.execute("accounts/infosWhitelist",{ whitelist = false, steam = (user_steam[2] or user_steam) })
				TriggerClientEvent("Notify",source,"sucesso","Steam Revogada.")
			else
				TriggerClientEvent("Notify",source,"negado","Steam não registrada.")
			end
			
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if userId then
		if exports["common"]:Group().hasPermission(userId,"staff") then
			local targetId = vRP.prompt(source,"Passaporte:","")
			if targetId == "" then return end
			targetId = parseInt(targetId)

			local punishId = vRP.prompt(source,"ID da punição:","")
			if punishId == "" then return end
			punishId = parseInt(punishId)

			exports["common"]:Ban().intelligence(targetId,punishId,userId)
			exports["common"]:Log().embedDiscord(userId,nil,nil,"commands-ban","**ID:**```"..targetId.."```\n**ID DA PUNIÇÃO:**```"..parseInt(punishId).."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if userId then
		if exports["common"]:Group().hasPermission(userId,"staff") then
			local targetId = vRP.prompt(source,"Passaporte:","")
			if targetId == "" then return end
			targetId = parseInt(targetId)
			exports["common"]:Ban().removeUserBan(targetId,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LAOD BANS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("load-bans",function(source,args,rawCommand)
	exports["common"]:Ban().load()
	print("[^3WARNING^7] Bans carregados com sucesso.")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			local fcoords = vRP.prompt(source,"Cordenadas:","")
			if fcoords == "" then
				return
			end

			local coords = {}
			for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
				table.insert(coords,parseInt(coord))
			end

			vRPC.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if not exports["common"]:Group().hasPermission(user_id,"ceo") then
			return
		end

		if not args[1] or not args[2] then return end
		local cant_user = not exports["common"]:Group().hasAccessOrHigher(user_id,args[2]:lower(),true)
		if (cant_user) then
			return TriggerClientEvent("Notify",source,"negado","Você não pode adicionar este grupo.")
		end

		exports["common"]:Group().add(parseInt(args[1]),args[2]:lower(),user_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if not exports["common"]:Group().hasPermission(user_id,"ceo") then
			return
		end

		if not args[1] or not args[2] then
			return
		end

		local cant_user = not exports["common"]:Group().hasAccessOrHigher(user_id,args[2]:lower(),true)
		if (cant_user) then
			return TriggerClientEvent("Notify",source,"negado","Você não pode remover este grupo.")
		end
		
		exports["common"]:Group().remove(parseInt(args[1]),args[2],user_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENAME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rename",function(source,args,rawCommand)
	local source = source
    local userId = vRP.getUserId(source)
	local is_staff = exports["common"]:Group().hasPermission(userId,"staff") 
	if is_staff then
		if not args[1] then
			local otherIdentity = vRP.userIdentity(userId)
			local update_names = exports["characters"]:updateNames()
			if update_names then
				local oldname = otherIdentity.surname
				local newSurname = vRP.prompt(source, "Novo apelido (Tab para não alterar):",""..otherIdentity.surname)
				if #newSurname > 16 then
					return TriggerClientEvent("Notify",source,"sucesso","Esse nome excediu o limite de letras <b>(16)</b>.",10000)
				end
				
				local check_name = exports["characters"]:checkName(newSurname)
				
				if not check_name then 
					return TriggerClientEvent("Notify",source,"sucesso","Nome em uso.",10000)
				end
				
				TriggerEvent("renameplayer",source,userId,oldname,newSurname)				
				exports["oxmysql"]:query_async("UPDATE `characters` SET `surname` = @surname WHERE `id` = @id",{
					id = parseInt(userId),
					surname = newSurname == "" and otherIdentity.surname or newSurname,
				})

				exports["common"]:Log().embedDiscord(userId,nil,nil,"commands-rename","**ID:**```"..userId.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
		elseif args[1] then
			local userId2 = parseInt(args[1])
			local source2 = vRP.getUserSource(userId2)
			local otherIdentity = vRP.userIdentity(userId2)
			if otherIdentity then
				local oldname = otherIdentity.surname
				local update_names = exports["characters"]:updateNames()
				if update_names then
					local newSurname = vRP.prompt(source, "Novo apelido (Tab para não alterar):",""..otherIdentity.surname)
					
					if #newSurname > 16 then
						return TriggerClientEvent("Notify",source,"sucesso","Esse nome excediu o limite de letras <b>(16)</b>.",10000)
					end

					local check_name = exports["characters"]:checkName(newSurname)
					
					if not check_name then 
						return TriggerClientEvent("Notify",source,"sucesso","Nome em uso.",10000)
					end

					TriggerEvent("renameplayer",source2,userId2,oldname,newSurname)
					
					exports["oxmysql"]:query_async("UPDATE `characters` SET `surname` = @surname WHERE `id` = @id",{
						id = parseInt(userId2),
						surname = newSurname == "" and otherIdentity.surname or newSurname,
					})
					exports["common"]:Log().embedDiscord(userId,nil,nil,"commands-rename","**ID:**```"..userId2.."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
					TriggerClientEvent("Notify",source,"sucesso","Identidade atualizada com sucesso.",10000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds2',function(source,args,rawCommand)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	local user_id = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(user_id,"staff") then
		vRP.prompt(source,"Cordenadas:",tD(coords.x)..","..tD(coords.y)..","..tD(coords.z))
	end
end)

RegisterCommand('h',function(source,args,rawCommand)
	local ped = GetPlayerPed(source)
	local heading = GetEntityHeading(ped)
	local user_id = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(user_id,"staff") then
		vRP.prompt(source,"Heading:",heading)
	end
end)


function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if args[1] == "" then return end
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") and parseInt(args[1]) > 0 then
			local otherPlayer = vRP.userSource(args[1])
			if otherPlayer then
				local ped = GetPlayerPed(source)
				local coords = GetEntityCoords(ped)
				vRPC.teleport(otherPlayer,coords["x"],coords["y"],coords["z"])
				local playerDimension = GetPlayerRoutingBucket(source)
				SetPlayerRoutingBucket(otherPlayer,parseInt(playerDimension))
				TriggerClientEvent("clutch-core:client:SetDimension",otherPlayer,playerDimension)

				exports["common"]:Log().embedDiscord(user_id,nil,nil,"commands-tptome","**ID:**```"..args[1].."```\nComando executado às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			vCLIENT.teleportWay(source)
		end
	end
end)
--[[ -----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptoway",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and exports["common"]:Group().hasPermission(user_id,"staff") then 
		if not args[1] or parseInt(args[1]) <= 0 then
			return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000)
		end

		local otherPlayer = vRP.userSource(parseInt(args[1]))
		if otherPlayer then
			vCLIENT.teleportWay(otherPlayer)
			TriggerClientEvent("Notify",otherPlayer,"sucesso","Você foi teletransportado(a) por um(a) Administrador(a).",20000)
		else
			TriggerClientEvent("Notify",source,"negado","Usuário desconectado.",10000)
		end
	end
end) ]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limpararea",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)

			TriggerClientEvent("syncarea",-1,coords["x"],coords["y"],coords["z"],100)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			TriggerClientEvent("Notify",source,"default","<b>Jogadores:</b> "..GetNumPlayerIndices(),60000,"left","logo")
		end
	end
end)