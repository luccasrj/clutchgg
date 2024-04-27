local InGroup = {}
local InQueue = {}
local gamesActives = {}
local computeDeaths = {}
local inWaiting = {}
local inGame = {}
local maxGames = 100
local maxInGroups = 5
local Queue = { 
    ["solo"] = { playersInQueue = 0, Players = 1, MaxPlayers = 10 },
    ["squad"] = { playersInQueue = 0, Players = 5, MaxPlayers = 10 },
}

local Maps = {
    ["predio"] = { 
        maxRounds = 16,
        spawnTeamA = vec3(82.41,-865.04,133.76),
        spawnTeamB = vec3(118.57,-877.91,133.76),
    },
    ["fazenda"] = { 
        maxRounds = 16,
        spawnTeamA = vec3(1455.25,1183.03,113.07), 
        spawnTeamB = vec3(1455.97,1128.66,113.33),
    }
}

RegisterServerEvent("clutch-game:addGroup",function(source,nsource)
    if source and nsource then
        if source == nsource then return end
        if inGame[source] or inGame[nsource] then return end
        if InQueue[source] or InQueue[nsource] then return end
        
        if InGroup[source] and InGroup[nsource] then
            if InGroup[source][1] == source then
                if #InGroup[nsource] <= 1 then
                    if #InGroup[source] < maxInGroups then
                        TriggerEvent("clutch-game:exitGroup",nsource,true) 
                        table.insert(InGroup[source],nsource)
                        InGroup[nsource] = InGroup[source]
                        SendToLobby(InGroup[source],parseInt(source+25000))
                        print("[^2WARNING^7] Grupo atualizado:",json.encode(InGroup[source]))
                    end
                end
            end
        end
    end
end)

RegisterServerEvent("clutch-game:exitGroup",function(source,status)
    if source then
        if inGame[source] then return end
        if InGroup[source] then
            if InQueue[source] then
                local Mode = InQueue[source].Queue
                TriggerEvent("clutch-game:Queue",source,Mode)      
            end
        
            for k, v in pairs(InGroup) do
                for i, playerId in ipairs(v) do
                    if playerId == source then
                        if InGroup[source][1] == source then
                            deleteGroup(InGroup[source])
                            return
                        end
                        
                        table.remove(InGroup[k], i)
                        local myBucket = GetPlayerRoutingBucket(source)
                        SendToLobby(InGroup[k],myBucket)
                        if not status and type(InGroup[k]) == "table" and next(InGroup[k]) ~= nil then
                            print("[^2WARNING^7] Grupo atualizado:", json.encode(InGroup[k]))
                        end
                        ResetGroup(source,1)
                        break
                    end
                end
            end
        end
    end
end)

RegisterServerEvent("clutch-game:Queue",function(source,Mode)
    if source then
        if inGame[source] then return end
        local trydelete = false
        local tables = countTables(gamesActives)
        if tables >= maxGames then return end

        if Queue[Mode] then
            if #InGroup[source] == Queue[Mode].Players then 
                if not InQueue[source] then
                    InQueue[source] = { inQueue = true, Queue = Mode, groupQueue = InGroup[source] }
                    Queue[Mode].playersInQueue = Queue[Mode].playersInQueue + #InQueue[source].groupQueue
                else
                    LastMode = InQueue[source].Queue
                    if Mode ~= LastMode then
                        InQueue[source] = { inQueue = true, Queue = Mode, groupQueue = InGroup[source] }
                        Queue[LastMode].playersInQueue = Queue[LastMode].playersInQueue - #InQueue[source].groupQueue
                        Queue[Mode].playersInQueue = Queue[Mode].playersInQueue + #InQueue[source].groupQueue
                    else
                        Queue[Mode].playersInQueue = Queue[Mode].playersInQueue - #InQueue[source].groupQueue
                        trydelete = true
                    end
                end
    
                print("[^2WARNING^7] Fila atualizada:", json.encode({[Mode] = Queue[Mode]}))
                for k,v in pairs(InGroup[source]) do
                    if trydelete then
                        InQueue[v] = nil
                    else
                        if v ~= source then
                            InQueue[v] = { inQueue = true, Queue = Mode, groupQueue = InQueue[source].groupQueue }
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15000)
        for k,v in pairs(Queue) do
            if Queue[k].playersInQueue >= Queue[k].MaxPlayers then
                local sortedMap = sortMap(Maps)
                local sortedKey = sortKey()
                local playersOnTeamA = 0
                local playersOnTeamB = 0
                local playersA = {}
                local playersB = {}
                for key,value in pairs(InQueue) do
                    if key then
                        if InQueue[key].Queue == k then
                            local spawnTeam = nil
                            if playersOnTeamA < maxInGroups then
                                table.insert(playersA,key)
                                spawnTeam = "spawnTeamA"
                                playersOnTeamA = playersOnTeamA + 1
                            else
                                table.insert(playersB,key)
                                spawnTeam = "spawnTeamB"
                                playersOnTeamB = playersOnTeamB + 1
                            end
                            
                            Queue[k].playersInQueue = Queue[k].playersInQueue - 1
                            inGame[key] = { gameMap = sortedMap, gameKey = sortedKey, gameSpawn = Maps[sortedMap][spawnTeam], gameTeam = spawnTeam, gameKiils = 0, gameDeaths = 0 }
                            InQueue[key] = nil
                            InGroup[key] = {}
                            startRound(key)
                        end
                    end
                end
                
                gamesActives[sortedKey] = { gameMap = sortedMap, gameKey = sortedKey, gameTeamA = playersA, gameTeamB = playersB, gameRoundsA = 0, gameRoundsB = 0, gameTotalRounds = 0, gamePlayersA = #playersA, gamePlayersB = #playersB }
                print("[^2WARNING^7] Jogo criado:",json.encode(gamesActives[sortedKey]))
            end
        end
    end    
end)

function startRound(key)
    local source = key
    local gameKey = inGame[key].gameKey

    computeDeaths[gameKey] = {}
    SetPlayerRoutingBucket(source,parseInt(gameKey))
    TriggerClientEvent("clutch-game:InitRound",source,inGame[key])
end

function sortMap(mapa)
    local keys = {}

    for key in pairs(mapa) do
        table.insert(keys, key)
    end

    local index = math.random(1, #keys)
    return keys[index]
end


local keysAlreadySelected = {}
function sortKey()
    local keys = {}

    for key = 1, maxGames do
        if not keysAlreadySelected[key] then
            table.insert(keys, key)
        end
    end

    if #keys == 0 then return nil end

    local index = math.random(1, #keys)
    local selectedKey = keys[index]
    keysAlreadySelected[selectedKey] = true
    return selectedKey
end

function countTables(tabela)
    local contador = 0
    for chave, valor in pairs(tabela) do
        if type(valor) == "table" and next(valor) ~= nil then
            contador = contador + 1
        end
    end
    return contador
end


RegisterCommand("jogos",function(source,args,rawCommand)
    if source ~= 0 then return end

    local tables = countTables(gamesActives)
    if tables <= 0 then
        print("[^1WARNING^7] Nenhum jogo ativo.")
    else
        for k,v in pairs(gamesActives) do
            print("[^2WARNING^7] Jogo ativo:",json.encode(gamesActives[k]))
        end
    end
end)

RegisterCommand("filas",function(source,args,rawCommand)
    if source ~= 0 then return end

    for k,v in pairs(Queue) do
        if v.playersInQueue <= 0 then
            print("[^1WARNING^7] Nenhuma fila ativa no modo "..k..".")
        else
            print("[^2WARNING^7] Fila ativa:",json.encode({[k] = Queue[k]}))
        end
    end
end)

RegisterCommand("grupos",function(source,args,rawCommand)
    if source ~= 0 then return end

    local tables = countTables(InGroup)
    if tables <= 0 then
        print("[^1WARNING^7] Nenhum grupo criado.")
    else
        for k,v in pairs(InGroup) do
            print("[^2WARNING^7] Grupo criado:",json.encode(InGroup[k]))
        end    
    end
end)

RegisterCommand("delete",function(source,args,rawCommand)
    if source ~= 0 then return end

    if args[1] then
        local key = parseInt(args[1])
        if gamesActives[key] then
            FinishMatch(key)
        else
            print("[^1WARNING^7] Partida "..key.." nao encontrado.")
        end
    else
        print("[^1WARNING^7] Key da Partida nao especificada.")
    end
end)

RegisterCommand("buscar",function(source,args,rawCommand)
    if source then
        TriggerEvent("clutch-game:Queue",source,args[1]) 
    end
end)

RegisterCommand("adicionar",function(source,args,rawCommand)
    local nsource = vRP.getUserSource(args[1])
    if source and nsource then
        TriggerEvent("clutch-game:addGroup",source,nsource) 
    end
end)

RegisterCommand("sair",function(source,args,rawCommand)
    if source then
        TriggerEvent("clutch-game:exitGroup",source) 
    end
end)


RegisterCommand("forcelobby",function(source,args,rawCommand)
    local nsource = vRP.getUserSource(parseInt(args[1]))
    if nsource then
        if not inGame[nsource] and not InQueue[nsource] then
            if not InGroup[nsource] or #InGroup[nsource] <= 0 then
                ResetGroup(nsource,1)
            end
        end
    end
end)

AddEventHandler("vRP:playerLeave",function(userId,source)
    if source then
        if InQueue[source] or InGroup[source] then
            TriggerEvent("clutch-game:exitGroup",source,true)
        end

        if inGame[source] then
            local gameKey = inGame[source].gameKey
            local gameTeam = inGame[source].gameTeam

            if gameTeam == "spawnTeamA" then
                gamesActives[gameKey].gamePlayersA = gamesActives[gameKey].gamePlayersA - 1
            elseif gameTeam == "spawnTeamB" then
                gamesActives[gameKey].gamePlayersB = gamesActives[gameKey].gamePlayersB - 1
            end

            TriggerEvent("clutch-game:RegisterDeath",source,source)
            inWaiting[userId] = source
        end
    end
end)

AddEventHandler("vRP:playerSpawn",function(userId,source)
    if source then
        Citizen.SetTimeout(2000,function()
            ResetGroup(source,1)
        end)
        Citizen.SetTimeout(5000,function()
            if inWaiting[userId] then
                local oldSource = inWaiting[userId]
                if inGame[oldSource] then
                    local oldKey = inGame[oldSource].gameKey
                    if gamesActives[oldKey] then
                        inGame[source] = {}
                        inGame[source] = inGame[oldSource]
                        local gameKey = inGame[source].gameKey
                        local gameTeam = inGame[source].gameTeam
                        if gameTeam == "spawnTeamA" then
                            gamesActives[gameKey].gamePlayersA = gamesActives[gameKey].gamePlayersA + 1
                        elseif gameTeam == "spawnTeamB" then
                            gamesActives[gameKey].gamePlayersB = gamesActives[gameKey].gamePlayersB + 1
                        end
                        ReconnectGame(gameKey)
        
                        local game = gamesActives[gameKey]
                        for key, value in pairs(game) do
                            if type(value) == "table" then
                                for index, player in ipairs(value) do
                                    if player == oldSource then
                                        game[key][index] = source
                                    end
                                end
                            end
                        end
                        
                        gamesActives[gameKey] = {
                            gameMap = game.gameMap,
                            gameKey = game.gameKey,
                            gameTeamA = game.gameTeamA,
                            gameTeamB = game.gameTeamB,
                            gameRoundsA = game.gameRoundsA,
                            gameRoundsB = game.gameRoundsB,
                            gameTotalRounds = game.gameTotalRounds,
                        }
        
                        InGroup[source] = {}
                        inGame[oldSource] = {}
                        inWaiting[userId] = {}
                    else
                        inWaiting[userId] = {}
                    end
                else
                    inWaiting[userId] = {}
                end
            end
        end)
    end
end)

function ReconnectGame(gameKey)
    for key,value in pairs(inGame) do
        if gameKey == inGame[key].gameKey then
            startRound(key)
        end
    end
end

function ResetGroup(source,pos)
    InGroup[source] = {}
    local userId = vRP.getUserId(source)
    if userId then
        table.insert(InGroup[source],source)
        TriggerClientEvent("clutch-game:lobby",source,pos)
    end
end

function SendToLobby(group,dimension)
    local count = 0
    for key,value in pairs(group) do
        if value then
            count = count + 1
            TriggerClientEvent("clutch-game:lobby",value,count,dimension)
        end
    end
end

function deleteGroup(group)
    for key,value in pairs(group) do
        if value then
            ResetGroup(value,1)
        end
        group = {}
    end
end

RegisterServerEvent("clutch-game:setInDimension",function(status)
    local source = source
    if source then
        if not status then
            SetPlayerRoutingBucket(source,parseInt(source+300))
        else
            SetPlayerRoutingBucket(source,status)
        end
    end
end)

RegisterServerEvent("clutch-game:RegisterDeath",function(source,nsource)
    if inGame[source] and inGame[nsource] then
        local gameKeyKiller = inGame[source].gameKey
        if gamesActives[gameKeyKiller] then
            local gameKeyVictim = inGame[nsource].gameKey
            local teamKiller = inGame[source].gameTeam
            local teamVictim = inGame[nsource].gameTeam
            local alreadyExists = false
    
            if gameKeyKiller == gameKeyVictim then
                if not computeDeaths[gameKeyKiller][teamVictim] then
                    computeDeaths[gameKeyKiller][teamVictim] = {}
                end
    
                if #computeDeaths[gameKeyKiller][teamVictim] >= 1 then
                    for _, value in ipairs(computeDeaths[gameKeyKiller][teamVictim]) do
                        if value == source then
                            alreadyExists = true
                            break
                        end
                    end
                end
    
                if not alreadyExists then
                    local map = gamesActives[gameKeyKiller].gameMap
                    local maxRounds = Maps[map].maxRounds
                    if teamKiller == teamVictim then
                        inGame[source].gameKiils = inGame[source].gameKiils - 1
                        inGame[nsource].gameDeaths = inGame[nsource].gameDeaths + 1
                    else
                        inGame[source].gameKiils = inGame[source].gameKiils + 1
                        inGame[nsource].gameDeaths = inGame[nsource].gameDeaths + 1
                    end
    
                    table.insert(computeDeaths[gameKeyKiller][teamVictim],nsource)
                    
                    local team = nil
                    if teamVictim == "spawnTeamA" then
                        team = gamesActives[gameKeyKiller].gamePlayersA
                    elseif teamVictim == "spawnTeamB" then
                        team = gamesActives[gameKeyKiller].gamePlayersB
                    end
    
                    if team == 0 then
                        FinishMatch(gameKeyKiller)
                        return
                    end
    
                    if #computeDeaths[gameKeyKiller][teamVictim] >= team then
                        if teamKiller == "spawnTeamA" then
                            gamesActives[gameKeyKiller].gameRoundsA = gamesActives[gameKeyKiller].gameRoundsA + 1
                        elseif teamKiller == "spawnTeamB" then
                            gamesActives[gameKeyKiller].gameRoundsB = gamesActives[gameKeyKiller].gameRoundsB + 1
                        end
                        
                        gamesActives[gameKeyKiller].gameTotalRounds = gamesActives[gameKeyKiller].gameTotalRounds + 1
                        if gamesActives[gameKeyKiller].gameRoundsA <= maxRounds and gamesActives[gameKeyKiller].gameRoundsB <= maxRounds then
                            Citizen.Wait(3000)
                            for key,value in pairs(inGame) do
                                if gameKeyKiller == inGame[key].gameKey then
                                    startRound(key)
                                end
                            end
                        else
                            FinishMatch(gameKeyKiller)
                        end
                    end
                end
            end
        end
    end
end)

function FinishMatch(gameKey)
    Citizen.Wait(3000)
    computeDeaths[gameKey] = {}
    for k,v in pairs(inGame) do
        if gameKey == v.gameKey then
            inGame[k] = nil
            ResetGroup(k,1)
        end
    end
    print("[^2WARNING^7] Partida "..gameKey.." finalizado.")
    gamesActives[gameKey] = {} 
    keysAlreadySelected[gameKey] = nil
end