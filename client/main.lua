ESX, currentStation, opened = nil, nil, false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(1)
    end
end) 

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local currentStation = nil
        for k, v in pairs(Config.Stations) do
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - v.ticketBuy)
            if distance < 12.0 and not IsPedInAnyVehicle(playerPed, false) then
	            DrawMarker(1, v.ticketBuy, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize, Config.RGB[1], Config.RGB[2], Config.RGB[3], 100, false, true, 2, false, false, false, false)
                currentStation = v.stationNumber
            end
            if distance < 1.5 and not opened then
                SetTextComponentFormat('STRING')
			    AddTextComponentString("Press ~INPUT_CONTEXT~ to buy a ~y~Metro Ticket~s~")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(0, 38) then
                    OpenStationsMenu(currentStation)
                    currentStation = nil
                end
            end
        end
        if currentStation == nil then
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

RegisterNUICallback("action", function(data, cb)
	if data.action == "close" then
		CloseStationsMenu()
	elseif data.action == "transport" then
        if data.station ~= currentStation then
            for k, v in pairs(Config.Stations) do
                if v.stationNumber == data.station then
                    ESX.TriggerServerCallback("vms_subway:getMoney", function(get)
                        if get then
                            Teleport(v.exitMetro)
                        else
                            ESX.ShowNotification("You dont have money.")
                        end
                    end, v.price)
                end
                CloseStationsMenu()
            end
        end
	end
end)

OpenStationsMenu = function(crntStation)
    opened = true
    SetNuiFocus(true, true)
    SendNUIMessage({action = "open", station = Config.Stations, currentNumber = crntStation})
end

CloseStationsMenu = function()
    opened = false
    SetNuiFocus(false, false)
    SendNUIMessage({action = "close"})
end

Teleport = function(spawnCoords)
    DoScreenFadeOut(1000)
    Citizen.Wait(575)
    SendNUIMessage({action = "enter"})
    local finished = nil
    CreateThread(function()
        local start = GetGameTimer()/1000
        while GetGameTimer()/1000 - start < Config.SubwayTimer do
            Wait(1000)
        end
        finished = true
		SetEntityCoords(PlayerPedId(), spawnCoords)
        DoScreenFadeIn(1000)
        Citizen.Wait(575)
        SendNUIMessage({action = "exit"})
    end)
    while finished == nil or not finished do
        Wait(0)
    end
    return
end