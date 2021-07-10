ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
	   Citizen.Wait(0)

	   if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "anim@gangops@facility@servers@bodysearch@", "player_search", 3) then
              DisableAllControlActions(0, true)
	   end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(GetPlayerPed(), ped)
        for k in pairs(Config.Scrappos) do
          DrawMarker(1, Config.Scrappos[k].x, Config.Scrappos[k].y, Config.Scrappos[k].z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.2001, 0, 173, 255, 47 ,0 ,0 ,0 ,0)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Scrappos[k].x, Config.Scrappos[k].y, Config.Scrappos[k].z)
        if dist <= 1.1 then
           Draw3DText(Config.Scrappos[k].x, Config.Scrappos[k].y, Config.Scrappos[k].z, tostring('Press ~b~[E]~w~ to search this spot'))
           if IsControlJustPressed(0,38) then
              scrap()
              Citizen.Wait(Config.WaitingTime)
              TriggerServerEvent('scrapjob:scrap:find')
           end
        end
    end
end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(GetPlayerPed(), ped)
        for k in pairs(Config.Scrapsell) do
          DrawMarker(1, Config.Scrapsell[k].x, Config.Scrapsell[k].y, Config.Scrapsell[k].z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.2001, 50, 205, 50, 80 ,0 ,0 ,0 ,0)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Scrapsell[k].x, Config.Scrapsell[k].y, Config.Scrapsell[k].z)
        if dist <= 1.1 then
           Draw3DText(Config.Scrapsell[k].x, Config.Scrapsell[k].y, Config.Scrapsell[k].z, tostring('Press ~g~[E]~w~ to sell scraps'))
           if IsControlJustPressed(0,38) then
              TriggerServerEvent('scrapjob:scrap:sell')
              DeleteEntity(carseat)
              DeleteEntity(tv)
              DeleteEntity(cardoor)
              DeleteEntity(wheel)
              ClearPedTasks(ped)
           end
        end
    end
end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Scrappos) do
		local blip = AddBlipForCoord(Config.Scrappos[k].x, Config.Scrappos[k].y, Config.Scrappos[k].z)

		SetBlipSprite(blip, 365)
		SetBlipScale(blip, 0.90)
        SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('scrap Area')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
    for k in pairs(Config.Npc) do
       RequestModel(GetHashKey("s_m_m_dockwork_01"))
       while not HasModelLoaded(GetHashKey("s_m_m_dockwork_01")) do
         Citizen.Wait(1)
       end
       local ped =  CreatePed(4, GetHashKey("s_m_m_dockwork_01"), Config.Npc[k].x, Config.Npc[k].y, Config.Npc[k].z, Config.Npc[k].h, false, true)
       TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, 1)
       FreezeEntityPosition(ped, true)
       SetEntityHeading(ped, Config.Npc[k].h, true)
       SetEntityInvincible(ped, true)
       SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

function scrap()
    Citizen.CreateThread(function()
        local impacts = 0
        local ped = GetPlayerPed(-1)
        local PedCoords = GetEntityCoords(GetPlayerPed(-1))
        local time = math.random(1,4)
        while impacts < 3 do
            Citizen.Wait(1)
            RequestAnimDict("anim@gangops@facility@servers@bodysearch@")
              Citizen.Wait(100)
              TaskPlayAnim(ped, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0)
              FreezeEntityPosition(ped, true)
              Citizen.Wait(2500)
              ClearPedTasks(ped)
              impacts = impacts+1
              print('search loop->',impacts)
            if impacts == 3 then
               impacts = 0
               exports.pNotify:SendNotification({text = "you found some scrap type, go ahead to sell this scrap to the dealer nearby", type = "success", timeout = 10000, layout = "centerRight", queue = "right"})
               FreezeEntityPosition(ped, false)
               break
            end   
        end

        if time == 1 then
           cardoor = CreateObject(GetHashKey('prop_car_door_01'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	       AttachEntityToEntity(cardoor , GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 60309),  0.025, 0.00, 0.355, -75.0, 470.0, 0.0, true, true, false, true, 1, true)
	       LoadDict('anim@heists@box_carry@')
	       TaskPlayAnim(ped, 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
           Citizen.Wait(9000)
        elseif time == 2 then
           tv = CreateObject(GetHashKey('prop_rub_monitor'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	       AttachEntityToEntity(tv , GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 60309),  0.020, 0.00, 0.255, -70.0, 470.0, 0.0, true, true, false, true, 1, true)
	       LoadDict('anim@heists@box_carry@')
	       TaskPlayAnim(ped, 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
           Citizen.Wait(9000)
        elseif time == 3 then
           carseat = CreateObject(GetHashKey('prop_car_seat'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	       AttachEntityToEntity(carseat , GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 60309),  0.020, 0.00, 0.255, -70.0, 470.0, 0.0, true, true, false, true, 1, true)
	       LoadDict('anim@heists@box_carry@')
	       TaskPlayAnim(ped, 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
           Citizen.Wait(9000)
        else
          wheel = CreateObject(GetHashKey('prop_rub_tyre_03'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	      AttachEntityToEntity(wheel , GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 60309),  0.30, 0.35, 0.365, -045.0, 480.0, 0.0, true, true, false, true, 1, true)
	      LoadDict('anim@heists@box_carry@')
	      TaskPlayAnim(ped, 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
          Citizen.Wait(9000)
        end
    end)
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
       SetTextFont(0)
       SetTextProportional(0)
       SetTextScale(0.32, 0.32)
       SetTextColour(255, 255, 255, 255)
       SetTextDropShadow(0, 0, 0, 0, 255)
       SetTextEdge(1, 0, 0, 0, 255)
       SetTextDropShadow()
       SetTextOutline()
       SetTextCentre(1)
       SetTextEntry("STRING")
       AddTextComponentString(text)
       DrawText(0.475, 0.88)
    end
end
