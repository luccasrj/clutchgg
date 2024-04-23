-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEDIMENSION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("clutch-core:SetDimension",function(number)
    local source = source
    SetPlayerRoutingBucket(source,parseInt(number))
    TriggerClientEvent("clutch-core:client:SetDimension",source,parseInt(number)) 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDIMENSION
-----------------------------------------------------------------------------------------------------------------------------------------
function src.getDimension()
    local source = source
    return GetPlayerRoutingBucket(source)
end