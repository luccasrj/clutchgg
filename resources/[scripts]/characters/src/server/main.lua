local charLocked = {}
local usersLogin = {}
local namesUsed = {}

Citizen.CreateThread(function()
    local query = exports.oxmysql:query_async("SELECT `surname` FROM `characters`",{ steam = steam })
    if #query > 0 then
        for k,v in pairs(query) do
            namesUsed[v.surname:lower()] = true
        end
    end
end)

function src.checkName(name)
    for k,v in pairs(namesUsed) do
        if string.find(k,name) or string.find(k,name:lower()) then 
            return false
        end
    end
    return true
end

function src.updateNames()
    namesUsed = {}
    local query = exports.oxmysql:query_async("SELECT `surname` FROM `characters`",{ steam = steam })
    if #query > 0 then
        for k,v in pairs(query) do
            namesUsed[v.surname:lower()] = true
        end
    end
    return true
end

exports("checkName",function(name)
    return src.checkName(name)
end)

exports("updateNames",function()
    return src.updateNames()
end)

function src.initSystem()
    local source = source
    local steam = vRP.getSteamBySource(source)
    local characterList = {}
    
    local query = exports.oxmysql:query_async("SELECT `id`,`surname` FROM `characters` WHERE `steam` = @steam",{ steam = steam })
    if #query > 0 then
        local userId = query[1].id
        local group = nil
        while group == nil do
            group = exports["common"]:Group().load(userId)
            Citizen.Wait(100)
        end
        for k,v in pairs(query) do
            table.insert(characterList,{ userId = v.id, surname = v.surname })
        end
        return { 
            id = userId,
            params = characterList, 
            chars = #query,
            group = group 
        }
    end
end

function src.spawnCharacter(userId,spawnPoint)
    local source = source
    local steam = vRP.getSteamBySource(source)
    local query = exports.oxmysql:query_async("SELECT `surname` FROM `characters` WHERE `steam` = @steam AND `id` = @id",{ steam = steam, id = userId })

    if #query > 0 then
        vRP.characterChosen(source,userId,nil)
        TriggerClientEvent("characters:justSpawn",source)
        if not usersLogin[userId] then 
            usersLogin[userId] = true 
        end
    end 
    exports["common"]:Log().embedDiscord(userId,nil,nil,"usuario-conectou","Conectou-se às "..os.date("%d/%m/%y %H:%M:%S"))
end

function src.newCharacter(surname,sex)
    local source = source
    if not charLocked[source] then
        charLocked[source] = true

        local steam = vRP.getSteamBySource(source)
        local countCharsQuery = exports.oxmysql:query_async("SELECT COUNT(id) AS qtd FROM `characters` WHERE `steam` = @steam",{ steam = steam })
        
        local created = exports.oxmysql:query_async("INSERT INTO `characters` (`steam`,`surname`) VALUES (@steam,@surname)",{
            steam = steam,
            surname = surname
        })

        vRP.characterChosen(source,created.insertId,sex)
        TriggerClientEvent("characters:justSpawn",source)

        Wait(2000)
        
        TriggerEvent("player:presetIntro",source)
        
        charLocked[source] = nil
        usersLogin[created.insertId] = true

    end
end

function src.previewCharacter(userId)
    local source = source
    local data = vRP.userData(userId,"Datatable")
    local clothes = vRP.userData(userId,"Clothings")
    local barber = vRP.userData(userId,"Barbershop")
    TriggerClientEvent("characters:previewCharacter",source,data.skin,clothes,barber)
end

function src.getLogin(userId)
    return usersLogin[userId] or false
end

RegisterNetEvent("characters:report_error",function(err,data)
    local src = source
    if err and data then 
        print('Erro ao logar -> ', err,data,src,GetPlayerName(source))
    end
end)