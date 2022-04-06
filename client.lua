ESX = nil
Citzen.CreateThread(function()

	while ESX == nil do
		TriggerEvent("esx:getSharedObject",function(obj)
				ESX = obj
			end)
			
		Citzen.Wait(0)
		PlayerData = ESX.GetPlayerData()
		
	end
	
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",function(xPlayer)

	PlayerData = xPlayer
	
end)


RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(job)

	PlayerData.job = job
	
end)
	
