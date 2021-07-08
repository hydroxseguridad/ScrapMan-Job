ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('scrapjob:scrap:find')
AddEventHandler('scrapjob:scrap:find', function()
   local _source = source
   local xPlayer = ESX.GetPlayerFromId(source)
   xPlayer.addInventoryItem('scrap', 1)
end)



RegisterServerEvent('scrapjob:scrap:sell')
AddEventHandler('scrapjob:scrap:sell', function()
   local _source = source
   local xPlayer = ESX.GetPlayerFromId(source)
   local scrapQuantity = xPlayer.getInventoryItem('scrap').count
   if scrapQuantity >= 1 then
       xPlayer.removeInventoryItem('scrap', 1)
       local addmoney = math.random (100, 250) -- change here the price of the scrap sell

       xPlayer.addMoney(addmoney)
       TriggerClientEvent("pNotify:SendNotification", source, {
          text = "you sold a scrap type for <b style=color:#1588d4>"  .. addmoney .. " keep working</b>",
          type = "success",
          queue = "lmao",
          timeout = 7000,
          layout = "Centerleft"
       })
   elseif scrapQuantity then
      	TriggerClientEvent("pNotify:SendNotification", source, {
          text = "you dont have any scrap type",
          type = "success",
          queue = "lmao",
          timeout = 7000,
          layout = "Centerleft"
         })
   end
end)