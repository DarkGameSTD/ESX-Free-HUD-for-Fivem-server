CreateThread(function()
    while not ESX do
        Wait(5)
    end
	ESX.RegisterUsableItem("nitrous", function(source)
		TriggerClientEvent('RV_HuD:LoadNitrous', source)
	end)
    ESX.RegisterServerCallback('RV_HuD:DeleteItem', function(source, cb, data)
        local xPlayer = ESX.GetPlayerFromId(source)
        local ItemName = data.name
        local count = data.reqAmount
        local xItem = xPlayer.getInventoryItem(ItemName)   
        if xItem.count >= count then
            xPlayer.removeInventoryItem(ItemName, count)
            cb(true)
        else
            cb(false)
        end
    end)

    RegisterNetEvent('RV_HuD:server:removeItem', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem("nitrous", 1)
    end)
end)

RegisterNetEvent('RV_HuD:server:LoadNitrous', function(Plate)
    TriggerClientEvent('RV_HuD:client:LoadNitrous', -1, Plate)
end)

RegisterNetEvent('RV_HuD:server:SyncFlames', function(netId)
    TriggerClientEvent('RV_HuD:client:SyncFlames', -1, netId, source)
end)

RegisterNetEvent('RV_HuD:server:UnloadNitrous', function(Plate)
    TriggerClientEvent('RV_HuD:client:UnloadNitrous', -1, Plate)
end)

RegisterNetEvent('RV_HuD:server:UpdateNitroLevel', function(Plate, level)
    TriggerClientEvent('RV_HuD:client:UpdateNitroLevel', -1, Plate, level)
end)

RegisterNetEvent('RV_HuD:server:StopSync', function(plate)
    TriggerClientEvent('RV_HuD:client:StopSync', -1, plate)
end)

