ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('vms_subway:getMoney', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = math.abs(price) -- simple protection against cheaters
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        cb(true)
    else
        cb(false)
    end
end)