local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPNserver = Tunnel.getInterface("vrp_trunkchest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local invOpen = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(data)
	--StopScreenEffect("MenuMGSelectionIn")
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideMenu" })
	invOpen = false
	vRPNserver.chestClose()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN TRUNK CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("trunkchest:Open")
AddEventHandler("trunkchest:Open",function()
	if not invOpen then
		--StartScreenEffect("MenuMGSelectionIn", 0, true)
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showMenu" })
		invOpen = true
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeItem",function(data, cb)
	vRPNserver.takeItem(data.item,data.amount, data.send)
	cb({success = true})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeItem",function(data, cb)
	vRPNserver.storeItem(data.item,data.amount, data.send)
	cb({success = true})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM/TAKEITEM BULKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("bulkItems",function(data, cb)
	vRPNserver.bulkItems(data.items, data.take)
	cb({success = true})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMochila",function(data,cb)
	local inventario,inventario2,peso,maxpeso,peso2,maxpeso2 = vRPNserver.Mochila()
	if inventario then
		cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2 })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTO-UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Creative:UpdateTrunk")
AddEventHandler("Creative:UpdateTrunk",function(action)
	SendNUIMessage({ action = action })
end)