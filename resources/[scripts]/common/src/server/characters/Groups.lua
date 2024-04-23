local userGroupsCache = {}
local groupsList = {
    ["ceo"] = {
        ["name"] = "CEOO",
        ["role"] = "staff",
        ["access"] = 5
    },
    ["eqp"] = {
        ["name"] = "Equipe",
        ["role"] = "staff",
        ["access"] = 3
    },
    ["dev"] = {
        ["name"] = "Desenvolvedor",
        ["role"] = "staff",
        ["access"] = 2
    },
    ["streamer"] = {
        ["name"] = "Streamer",
        ["role"] = "strmer",
        ["access"] = 0
    },
    ["booster"] = {
        ["name"] = "Booster",
        ["role"] = "vip",
        ["access"] = 0
    },
}

Group = {}

function Group.load(userId)
    userGroupsCache[userId] = {}
    local query = exports.oxmysql:query_async("SELECT `group` FROM `groups` WHERE `character_id` = @character_id",{ character_id = userId })
    if #query > 0 then
        for _,v in pairs(query) do
            if groupsList[v.group] then
                userGroupsCache[userId][v.group] = true
            end
        end
        local ok = nil
        while ok == nil do
            ok = Group.getHigher(userId)
            Wait(100)
        end
        return ok
    end
    return "Sem grupo"
end

function Group.has(userId,group)
    local source = vRP.userSource(userId)
    if source then
        if not userGroupsCache[userId] then
            userGroupsCache[userId] = {}
        end

        if userGroupsCache[userId][group] then
            return true
        end
    else
        local query = exports.oxmysql:query_async("SELECT `id` FROM `groups` WHERE `character_id` = @character_id AND `group` = @group",{ character_id = userId, group = group })
        if #query > 0 then
            return true
        end
    end
    return false
end

function Group.add(userId,group,staffId)
    local source = vRP.userSource(userId)
    local staffSource = vRP.userSource(staffId)
    if not groupsList[group] then
        if staffSource then
        end
        return
    end

    if Group.has(userId,group) then
        if staffSource then
        end
        return
    end

    if groupsList[group].role == "undefined" then
        if staffSource then
        end
        return
    end
    
    if source then
        if not userGroupsCache[userId] then
            userGroupsCache[userId] = {}
        end

        userGroupsCache[userId][group] = true
    end
    
    exports.oxmysql:query("INSERT INTO `groups` (`character_id`,`group`) VALUES (@character_id,@group)",{ character_id = userId, group = group })
    if staffSource then
    end
end

function Group.remove(userId,group,staffId)
    local source = vRP.userSource(userId)
    local staffSource = vRP.userSource(staffId)
    if not groupsList[group] then
        if staffSource then
        end
        return
    end
    
    if userGroupsCache[userId] then
        if userGroupsCache[userId][group] then
            userGroupsCache[userId][group] = nil
        end
    end
    
    exports.oxmysql:query("DELETE FROM `groups` WHERE `character_id` = @character_id AND `group` = @group",{ character_id = userId, group = group })
    if staffSource then
    end
end

function Group.hasPermission(userId,group)
    if not userGroupsCache[userId] then
        return false,group
    end

    if groupsList[group] then
        if userGroupsCache[userId][group] then
            return true,group
        end
        return false,group
    end

    for k,v in pairs(userGroupsCache[userId]) do
        if groupsList[k].role then
            if groupsList[k].role == group then
                return true,k
            end
        end
    end
    return false,group
end

function Group.hasAccessOrHigher(userId,group,search)
    if not userGroupsCache[userId] then
        return false
    end

    if not groupsList[group] then
        return false
    end

    if not groupsList[group].role or not groupsList[group].access then
        return false
    end

    local role = groupsList[group].role
    local access = groupsList[group].access

    if userGroupsCache[userId] then
        for k,v in pairs(userGroupsCache[userId]) do
            if groupsList[k].role then
                if groupsList[k].role == role then
                    if ((search and access < groupsList[k].access) or (not search and access <= groupsList[k].access)) then
                        return true
                    end
                end
            end
        end

        return false
    end
end

function Group.getAllByPermission(group)
    local returnList = Group.getUsersByPermission(group)
    for k,v in pairs(returnList) do 
        returnList[k] = vRP.userSource(v)
    end

    return returnList
end

function Group.getUsersByPermission(group)
    local returnList = {}
    if groupsList[group] then
        for k,v in pairs(userGroupsCache) do
            for l,w in pairs(v) do
                if l == group then
                    table.insert(returnList,k)
                end
            end
        end
    else
        for k,v in pairs(userGroupsCache) do
            for l,w in pairs(v) do
                if groupsList[l].role then
                    if groupsList[l].role == group then
                        table.insert(returnList,k)
                    end
                end
            end
        end
    end

    return returnList
end

function Group.getUsersByDimension(dimension)
    local users_in_dimension = {}

    local users = vRP.userList()
    for id,src in pairs(users) do
        if GetPlayerRoutingBucket(src) == dimension then
			table.insert(users_in_dimension,tonumber(id))
		end
    end
	return users_in_dimension
end

function Group.getRole(group)
    return groupList[group].role and groupList[group].role or false
end

local allowedRoles = { 
    ["laundry"] = true,
    ["drugs"] = true,
    ["undefined"] = true,
    ["weapon"] = true,
    ["ammo"] = true,
}

function Group.getSquad(userId)
    if userGroupsCache[userId] then
        for k,v in pairs(userGroupsCache[userId]) do
            if allowedRoles[groupsList[k].role] then 
               return { squad = k, squadName = groupsList[k].name, reputation = vRP.squadReputation(k) }
            end
        end
        return nil
    end
end

function Group.getHigher(userId)
    local higher = ""..userId..""

    if userGroupsCache[userId] then
        for k,v in pairs(userGroupsCache[userId]) do
            if groupsList[k].role then
                if higher == "" then
                    higher = k
                end
                    
                if groupsList[higher] == nil or groupsList[higher].access == nil then
                    return k
                end
                
                if groupsList[k] == nil or groupsList[k].access == nil then
                    return higher
                end

                if groupsList[higher].access < groupsList[k].access then
                    return higher
                end
            end
        end
    end
    return higher
end

local function verifyOverrideRoles()
    for k,v in pairs(groupsList) do
        if k == v.role then
            print("^1[ERRO CRUCIAL] ^7Foi encontrado um grupo com o mesmo nome de uma role "..v.role)
        end
    end
end

--AddEventHandler("vRP:playerSpawn",function(userId,source)
   --Group.load(userId)
--end)

AddEventHandler("vRP:playerLeave",function(userId,source)
    if not userGroupsCache[userId] then return end

    userGroupsCache[userId] = nil
end)

RegisterNetEvent("clutch:atualizar",function(source,args,rawCmd)
    local userId = vRP.getUserId(source)
    if userId then
        Group.load(userId)
    end
end)

RegisterNetEvent("squads:memberSquad",function()
    local source = source
    local userId = vRP.getUserId(source)
    if not Group.hasPermission(userId,"staff") then
        return
    end

    TriggerClientEvent("dynamic:closeSystem",source)

    local squadName = vRP.prompt(source,"Nome do Squad:","")
    if squadName == "" then return end

    if groupsList[squadName] then
        local getAll = exports.oxmysql:query_async("SELECT `character_id`,`group` FROM `groups` WHERE `group` = @group",{ group = squadName }) 
        if #getAll > 0 then 
            local messageStr = ""
            for k,v in pairs(getAll) do 
                messageStr = messageStr.." <b>"..v.character_id.."</b>: "..v.group.."<br>"
            end
        end
    else
    end
end)

AddEventHandler("onResourceStart",function(resourceName)
    Citizen.Wait(300)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    verifyOverrideRoles()

    local users = vRP.userList()
    for id,src in pairs(users) do
        Group.load(id)
    end
end)


exports("Group",function()
    return Group
end)