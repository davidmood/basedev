local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
src = Tunnel.getInterface("vrp_player",src)

RegisterNetEvent( 'lafa2k_flag:fps20' )
AddEventHandler( 'lafa2k_flag:fps20', function()   
    SetTimecycleModifier("int_hospital2_dm")
end)



Citizen.CreateThread(function()
	while true do
		--Citizen.Wait(1)
		local idle = 300
		if not IsPedInAnyVehicle(PlayerPedId()) then
			idle = 4
			if IsControlJustPressed(0,47) then
				TriggerServerEvent("vrp_policia:algemar")
			end
			if IsControlJustPressed(0,74) then
				TriggerServerEvent("vrp_policia:carregar")
			end
		end
		Wait(idle)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ AGACHAR ]------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        DisableControlAction(0,36,true)
        if not IsPedInAnyVehicle(ped) then
            RequestAnimSet("move_ped_crouched")
            RequestAnimSet("move_ped_crouched_strafing")
            if IsDisabledControlJustPressed(0,36) then
                if agachar then
                    ResetPedStrafeClipset(ped)
                    ResetPedMovementClipset(ped,0.25)
                    agachar = false
                else
                    SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
                    SetPedMovementClipset(ped,"move_ped_crouched",0.25)
                    agachar = true
                end
            end
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ ANIMACAO DA BOCA AO FALAR ]-----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function GetPlayers()
  local players = {}
  for i = 0, 256 do
      if NetworkIsPlayerActive(i) then
          players[#players + 1] = i
      end
  end
  return players
end

Citizen.CreateThread(function()
  RequestAnimDict("facials@gen_male@variations@normal")
  RequestAnimDict("mp_facial")

  local talkingPlayers = {}
  while true do
      Citizen.Wait(300)

      for k,v in pairs(GetPlayers()) do
          local boolTalking = NetworkIsPlayerTalking(v)
          if v ~= PlayerId() then
              if boolTalking and not talkingPlayers[v] then
                  PlayFacialAnim(GetPlayerPed(v), "mic_chatter", "mp_facial")
                  talkingPlayers[v] = true
              elseif not boolTalking and talkingPlayers[v] then
                  PlayFacialAnim(GetPlayerPed(v), "mood_normal_1", "facials@gen_male@variations@normal")
                  talkingPlayers[v] = nil
              end
          end
      end
  end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ NOCARJACK ]---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
			local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
			if GetVehicleDoorLockStatus(veh) >= 2 or GetPedInVehicleSeat(veh,-1) then
				TriggerServerEvent("TryDoorsEveryone",veh,2,GetVehicleNumberPlateText(veh))
			end
		end
	end
end)

RegisterNetEvent("SyncDoorsEveryone")
AddEventHandler("SyncDoorsEveryone",function(veh,doors)
	SetVehicleDoorsLocked(veh,doors)
end)

------------------------------------------------------------------------------------------------------------------------------
--[ BEBIDAS-ENERGETICAS ]-----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local energetico = false
RegisterNetEvent('energeticos')
AddEventHandler('energeticos',function(status)
	energetico = status
	if energetico then
		SetRunSprintMultiplierForPlayer(PlayerId(),1.15)
	else
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if energetico then
			RestorePlayerStamina(PlayerId(),1.0)
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ CANCELANDO O F6 ]---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local cancelando = false
RegisterNetEvent('cancelando')
AddEventHandler('cancelando',function(status)
    cancelando = status
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if cancelando then
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,29,true)
			DisableControlAction(0,38,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,137,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,169,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,245,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,344,true)			
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ AFKSYSTEM ]---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        if x == px and y == py then
            if tempo > 0 then
                tempo = tempo - 1
                if tempo == 60 then
                    TriggerEvent("Notify","importante","Você vai ser desconectado em <b>60 segundos</b>.",8000)
                end
            else
                TriggerServerEvent("kickAFK")
            end
        else
            tempo = 1800
        end
        px = x
        py = y
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ ABRIR PORTA-MALAS DO VEICULO ]--------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("trunk",function(source,args)
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("trytrunk",VehToNet(vehicle))
	end
end)

RegisterNetEvent("synctrunk")
AddEventHandler("synctrunk",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,5)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if isopen == 0 then
					SetVehicleDoorOpen(v,5,0,0)
				else
					SetVehicleDoorShut(v,5,0)
				end
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ ABRIR CAPO DO VEICULO ]---------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hood",function(source,args)
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("tryhood",VehToNet(vehicle))
	end
end)

RegisterNetEvent("synchood")
AddEventHandler("synchood",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,4)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if isopen == 0 then
					SetVehicleDoorOpen(v,4,0,0)
				else
					SetVehicleDoorShut(v,4,0)
				end
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ ABRE E FECHA OS VIDROS ]--------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local vidros = false
RegisterCommand("wins",function(source,args)
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("trywins",VehToNet(vehicle))
	end
end)

RegisterNetEvent("syncwins")
AddEventHandler("syncwins",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if vidros then
					vidros = false
					RollUpWindow(v,0)
					RollUpWindow(v,1)
					RollUpWindow(v,2)
					RollUpWindow(v,3)
				else
					vidros = true
					RollDownWindow(v,0)
					RollDownWindow(v,1)
					RollDownWindow(v,2)
					RollDownWindow(v,3)
				end
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ ABRIR PORTAS DO VEICULO ]-------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("doors",function(source,args)
	local vehicle = vRP.getNearestVehicle(7)
	if IsEntityAVehicle(vehicle) then
		if parseInt(args[1]) == 5 then
			TriggerServerEvent("trytrunk",VehToNet(vehicle))
		else
			TriggerServerEvent("trydoors",VehToNet(vehicle),args[1])
		end
	end
end)

RegisterNetEvent("syncdoors")
AddEventHandler("syncdoors",function(index,door)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,0) and GetVehicleDoorAngleRatio(v,1)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if door == "1" then
					if GetVehicleDoorAngleRatio(v,0) == 0 then
						SetVehicleDoorOpen(v,0,0,0)
					else
						SetVehicleDoorShut(v,0,0)
					end
				elseif door == "2" then
					if GetVehicleDoorAngleRatio(v,1) == 0 then
						SetVehicleDoorOpen(v,1,0,0)
					else
						SetVehicleDoorShut(v,1,0)
					end
				elseif door == "3" then
					if GetVehicleDoorAngleRatio(v,2) == 0 then
						SetVehicleDoorOpen(v,2,0,0)
					else
						SetVehicleDoorShut(v,2,0)
					end
				elseif door == "4" then
					if GetVehicleDoorAngleRatio(v,3) == 0 then
						SetVehicleDoorOpen(v,3,0,0)
					else
						SetVehicleDoorShut(v,3,0)
					end
				elseif door == nil then
					if isopen == 0 then
						SetVehicleDoorOpen(v,0,0,0)
						SetVehicleDoorOpen(v,1,0,0)
						SetVehicleDoorOpen(v,2,0,0)
						SetVehicleDoorOpen(v,3,0,0)
					else
						SetVehicleDoorShut(v,0,0)
						SetVehicleDoorShut(v,1,0)
						SetVehicleDoorShut(v,2,0)
						SetVehicleDoorShut(v,3,0)
					end
				end
			end
		end
	end
end)

RegisterNetEvent("synctrunk")
AddEventHandler("synctrunk",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local isopen = GetVehicleDoorAngleRatio(v,5)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if isopen == 0 then
					SetVehicleDoorOpen(v,5,0,0)
				else
					SetVehicleDoorShut(v,5,0)
				end
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /ROLL ]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('roll',function(source,args)
	rolls = 1
	if args[1] ~= nil and tonumber(args[1]) then
		rolls = tonumber(args[1])
	end

	local die = 6
	if args[2] ~= nil and tonumber(args[2]) then
		die = tonumber(args[2])
	end

	local number = 0
	local text = "Resultado: "
	for i = rolls,1,-1 do
		number = number + math.random(1,die)
		text = ""..text.." ~g~"..number.." ~w~/ ~g~"..die..""
	end

	vRP._playAnim(true,{{"anim@mp_player_intcelebrationmale@wank","wank"}},false)
	Citizen.Wait(1500)
	TriggerServerEvent('ChatRoll',text)
	ClearPedTasks(PlayerId())
end)

local DisplayRoll = false
RegisterNetEvent('DisplayRoll')
AddEventHandler('DisplayRoll',function(text,source)
	local DisplayRoll = true
	local id = GetPlayerFromServerId(source)
    Citizen.CreateThread(function()
        while DisplayRoll do
            Wait(1)
            local coordsMe = GetEntityCoords(GetPlayerPed(id),false)
			local coords = GetEntityCoords(PlayerPedId(),false)
            local distance = Vdist2(coordsMe,coords)
            if distance <= 30 then
                DrawText3Ds(coordsMe['x'],coordsMe['y'],coordsMe['z']+0.10,text)
            end
        end
    end)
    Wait(7000)
    DisplayRoll = false
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /ME ]---------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('me', function(source, args, rawCommand)
    local text = '*' .. rawCommand:sub(4) .. '*'
    TriggerServerEvent('ChatMe', text)
end)

local DisplayMe = false
RegisterNetEvent('DisplayMe')
AddEventHandler('DisplayMe',function(text,source)
	local DisplayMe = true
	local id = GetPlayerFromServerId(source)
    Citizen.CreateThread(function()
        while DisplayMe do
            Wait(1)
            local coordsMe = GetEntityCoords(GetPlayerPed(id),false)
			local coords = GetEntityCoords(PlayerPedId(),false)
            local distance = Vdist2(coordsMe,coords)
            if distance <= 30 then
                DrawText3Ds(coordsMe['x'],coordsMe['y'],coordsMe['z']+0.90,text)
            end
        end
    end)
    Wait(7000)
    DisplayMe = false
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /MASCARA ]----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("mascara")
AddEventHandler("mascara",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		vRP.playAnim(true,{{"misscommon@std_take_off_masks","take_off_mask_ps",1}},false)
		Wait(700)
		ClearPedTasks(ped)
		SetPedComponentVariation(ped,1,0,0,2)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") or GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		vRP.playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps",1}},false)
		Wait(1500)
		ClearPedTasks(ped)
		SetPedComponentVariation(ped,1,parseInt(index),parseInt(color),2)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /BLUSA ]----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("blusa")
AddEventHandler("blusa",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		SetPedComponentVariation(ped,8,15,0,2)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped,8,parseInt(index),parseInt(color),2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped,8,parseInt(index),parseInt(color),2)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /JAQUETA ]----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("jaqueta")
AddEventHandler("jaqueta",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		SetPedComponentVariation(ped,11,15,0,2)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped,11,parseInt(index),parseInt(color),2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped,11,parseInt(index),parseInt(color),2)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /CALCA]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("calca")
AddEventHandler("calca",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,4,18,0,2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,4,15,0,2)
		end
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped,4,parseInt(index),parseInt(color),2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped,4,parseInt(index),parseInt(color),2)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /MAOS ]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("maos")
AddEventHandler("maos",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		SetPedComponentVariation(ped,3,15,0,2)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped,3,parseInt(index),parseInt(color),2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped,3,parseInt(index),parseInt(color),2)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /ACESSORIOS ]-------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("acessorios")
AddEventHandler("acessorios",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		SetPedComponentVariation(ped,7,0,0,2)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped,7,parseInt(index),parseInt(color),2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped,7,parseInt(index),parseInt(color),2)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /SAPATOS ]----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("sapatos")
AddEventHandler("sapatos",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
			SetPedComponentVariation(ped,6,34,0,2)
		elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
			SetPedComponentVariation(ped,6,35,0,2)
		end
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(ped,6,parseInt(index),parseInt(color),2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		SetPedComponentVariation(ped,6,parseInt(index),parseInt(color),2)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /CHAPEU ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chapeu")
AddEventHandler("chapeu",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		vRP.playAnim(true,{{"veh@common@fp_helmet@","take_off_helmet_stand",1}},false)
		Wait(700)
		ClearPedProp(ped,0)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		vRP.playAnim(true,{{"veh@common@fp_helmet@","put_on_helmet",1}},false)
		Wait(1700)
		SetPedPropIndex(ped,0,parseInt(index),parseInt(color),2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		vRP.playAnim(true,{{"veh@common@fp_helmet@","put_on_helmet",1}},false)
		Wait(1700)
		SetPedPropIndex(ped,0,parseInt(index),parseInt(color),2)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /OCULOS ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("oculos")
AddEventHandler("oculos",function(index,color)
	local ped = GetPlayerPed(-1)
	if index == nil then
		vRP.playAnim(true,{{"misscommon@std_take_off_masks","take_off_mask_ps",1}},false)
		Wait(400)
		ClearPedTasks(ped)
		ClearPedProp(ped,1)
		return
	end
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		vRP.playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps",1}},false)
		Wait(800)
		ClearPedTasks(ped)
		SetPedPropIndex(ped,1,parseInt(index),parseInt(color),2)
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		vRP.playAnim(true,{{"misscommon@van_put_on_masks","put_on_mask_ps",1}},false)
		Wait(800)
		ClearPedTasks(ped)
		SetPedPropIndex(ped,1,parseInt(index),parseInt(color),2)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ /TOW ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local reboque = nil
local rebocado = nil
RegisterCommand("tow",function(source,args)
    local vehicle = GetPlayersLastVehicle()
    local vehicletow = IsVehicleModel(vehicle,GetHashKey("flatbed"))

    if vehicletow and not IsPedInAnyVehicle(PlayerPedId()) then
        rebocado = getVehicleInDirection(GetEntityCoords(PlayerPedId()),GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,5.0,0.0))
        if IsEntityAVehicle(vehicle) and IsEntityAVehicle(rebocado) then
            TriggerServerEvent("trytow",VehToNet(vehicle),VehToNet(rebocado))
        end
    end
end)

RegisterNetEvent('synctow')
AddEventHandler('synctow',function(vehid,rebid)
    if NetworkDoesNetworkIdExist(vehid) and NetworkDoesNetworkIdExist(rebid) then
        local vehicle = NetToVeh(vehid)
        local rebocado = NetToVeh(rebid)
        if DoesEntityExist(vehicle) and DoesEntityExist(rebocado) then
            if reboque == nil then
                if vehicle ~= rebocado then
                    local min,max = GetModelDimensions(GetEntityModel(rebocado))
                    AttachEntityToEntity(rebocado,vehicle,GetEntityBoneIndexByName(vehicle,"bodyshell"),0,-2.2,0.4-min.z,0,0,0,1,1,0,1,0,1)
                    reboque = rebocado
                end
            else
                AttachEntityToEntity(reboque,vehicle,20,-0.5,-15.0,-0.3,0.0,0.0,0.0,false,false,true,false,20,true)
                DetachEntity(reboque,false,false)
                PlaceObjectOnGroundProperly(reboque)
                reboque = nil
                rebocado = nil
            end
        end
    end
end)

function getVehicleInDirection(coordsfrom,coordsto)
	local handle = CastRayPointToPoint(coordsfrom.x,coordsfrom.y,coordsfrom.z,coordsto.x,coordsto.y,coordsto.z,10,PlayerPedId(),false)
	local a,b,c,d,vehicle = GetRaycastResult(handle)
	return vehicle
end

------------------------------------------------------------------------------------------------------------------------------
--[ /CARREGAR ]---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local carregado = false
RegisterCommand("carregar",function(source,args)
	local ped = PlayerPedId()
	local randomico,npcs = FindFirstPed()
	repeat
		local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),GetEntityCoords(npcs),true)
		if not IsPedAPlayer(npcs) and distancia <= 3 and not IsPedInAnyVehicle(ped) and not IsPedInAnyVehicle(npcs) then
			if carregado then
				ClearPedTasksImmediately(carregado)
				DetachEntity(carregado,true,true)
				TaskWanderStandard(carregado,10.0,10)
				Citizen.InvokeNative(0xAD738C3085FE7E11,carregado,true,true)
				carregado = false
			else
				Citizen.InvokeNative(0xAD738C3085FE7E11,npcs,true,true)
				AttachEntityToEntity(npcs,ped,4103,11816,0.48,0.0,0.0,0.0,0.0,0.0,false,false,true,false,2,true)
				carregado = npcs
				sucess = true
			end
		end
	sucess,npcs = FindNextPed(randomico)
	until not sucess
	EndFindPed(randomico)
end)

------------------------------------------------------------------------------------------------------------------------------
--[ SEQUESTRO2 ]--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local sequestrado = nil
RegisterCommand("sequestro2",function(source,args)
	local ped = PlayerPedId()
	local random,npc = FindFirstPed()
	repeat
		local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),GetEntityCoords(npc),true)
		if not IsPedAPlayer(npc) and distancia <= 3 and not IsPedInAnyVehicle(npc) then
			vehicle = vRP.getNearestVehicle(7)
			if IsEntityAVehicle(vehicle) then
				if vRP.getCarroClass(vehicle) then
					if sequestrado then
						AttachEntityToEntity(sequestrado,vehicle,GetEntityBoneIndexByName(vehicle,"bumper_r"),0.6,-1.2,-0.6,60.0,-90.0,180.0,false,false,false,true,2,true)
						DetachEntity(sequestrado,true,true)
						SetEntityVisible(sequestrado,true)
						SetEntityInvincible(sequestrado,false)
						Citizen.InvokeNative(0xAD738C3085FE7E11,sequestrado,true,true)
						ClearPedTasksImmediately(sequestrado)
						sequestrado = nil
					elseif not sequestrado then
						Citizen.InvokeNative(0xAD738C3085FE7E11,npc,true,true)
						AttachEntityToEntity(npc,vehicle,GetEntityBoneIndexByName(vehicle,"bumper_r"),0.6,-0.4,-0.1,60.0,-90.0,180.0,false,false,false,true,2,true)
						SetEntityVisible(npc,false)
						SetEntityInvincible(npc,true)
						sequestrado = npc
						complet = true
					end
					TriggerServerEvent("trymala",VehToNet(vehicle))
				end
			end
		end
		complet,npc = FindNextPed(random)
	until not complet
	EndFindPed(random)
end)


RegisterCommand("checkhash",function(source,args)
    local ped = PlayerPedId()
    if ped then
        local xesquedele = GetHashKey("mp_m_freemode_01") 
        print(xesquedele)
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ EMPURRAR ]----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc,moveFunc,disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = { handle = iter, destructor = disposeFunc }
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next,id = moveFunc(iter)
		until not next

		enum.destructor,enum.handle = nil,nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle,FindNextVehicle,EndFindVehicle)
end

function GetVeh()
    local vehicles = {}
    for vehicle in EnumerateVehicles() do
        table.insert(vehicles,vehicle)
    end
    return vehicles
end

function GetClosestVeh(coords)
	local vehicles = GetVeh()
	local closestDistance = -1
	local closestVehicle = -1
	local coords = coords

	if coords == nil then
		local ped = PlayerPedId()
		coords = GetEntityCoords(ped)
	end

	for i=1,#vehicles,1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance = GetDistanceBetweenCoords(vehicleCoords,coords.x,coords.y,coords.z,true)
		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end
	return closestVehicle,closestDistance
end

local First = vector3(0.0,0.0,0.0)
local Second = vector3(5.0,5.0,5.0)
local Vehicle = { Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil }

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local closestVehicle,Distance = GetClosestVeh()
		if Distance < 6.1 and not IsPedInAnyVehicle(ped) then
			Vehicle.Coords = GetEntityCoords(closestVehicle)
			Vehicle.Dimensions = GetModelDimensions(GetEntityModel(closestVehicle),First,Second)
			Vehicle.Vehicle = closestVehicle
			Vehicle.Distance = Distance
			if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
				Vehicle.IsInFront = false
			else
				Vehicle.IsInFront = true
			end
		else
			Vehicle = { Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil }
		end
		Citizen.Wait(500)
	end
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(500)
		if Vehicle.Vehicle ~= nil then
			local ped = PlayerPedId()
			if IsControlPressed(0,244) and GetEntityHealth(ped) > 100 and IsVehicleSeatFree(Vehicle.Vehicle,-1) and not IsEntityInAir(ped) and not IsPedBeingStunned(ped) and not IsEntityAttachedToEntity(ped,Vehicle.Vehicle) and not (GetEntityRoll(Vehicle.Vehicle) > 75.0 or GetEntityRoll(Vehicle.Vehicle) < -75.0) then
				RequestAnimDict('missfinale_c2ig_11')
				TaskPlayAnim(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0,-8.0,-1,35,0,0,0,0)
				NetworkRequestControlOfEntity(Vehicle.Vehicle)

				if Vehicle.IsInFront then
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y*-1+0.1,Vehicle.Dimensions.z+1.0,0.0,0.0,180.0,0.0,false,false,true,false,true)
				else
					AttachEntityToEntity(ped,Vehicle.Vehicle,GetPedBoneIndex(6286),0.0,Vehicle.Dimensions.y-0.3,Vehicle.Dimensions.z+1.0,0.0,0.0,0.0,0.0,false,false,true,false,true)
				end

				while true do
					Citizen.Wait(5)
					if IsDisabledControlPressed(0,34) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,11,100)
					end

					if IsDisabledControlPressed(0,9) then
						TaskVehicleTempAction(ped,Vehicle.Vehicle,10,100)
					end

					if Vehicle.IsInFront then
						SetVehicleForwardSpeed(Vehicle.Vehicle,-1.0)
					else
						SetVehicleForwardSpeed(Vehicle.Vehicle,1.0)
					end

					if not IsDisabledControlPressed(0,244) then
						DetachEntity(ped,false,false)
						StopAnimTask(ped,'missfinale_c2ig_11','pushcar_offcliff_m',2.0)
						break
					end
				end
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ UPDATE ROUPAS ]-----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("updateRoupas")
AddEventHandler("updateRoupas",function(custom)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if custom[1] == -1 then
			SetPedComponentVariation(ped,1,0,0,2)
		else
			SetPedComponentVariation(ped,1,custom[1],custom[2],2)
		end

		if custom[3] == -1 then
			SetPedComponentVariation(ped,5,0,0,2)
		else
			SetPedComponentVariation(ped,5,custom[3],custom[4],2)
		end

		if custom[5] == -1 then
			SetPedComponentVariation(ped,7,0,0,2)
		else
			SetPedComponentVariation(ped,7,custom[5],custom[6],2)
		end

		if custom[7] == -1 then
			SetPedComponentVariation(ped,3,15,0,2)
		else
			SetPedComponentVariation(ped,3,custom[7],custom[8],2)
		end

		if custom[9] == -1 then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				SetPedComponentVariation(ped,4,18,0,2)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				SetPedComponentVariation(ped,4,15,0,2)
			end
		else
			SetPedComponentVariation(ped,4,custom[9],custom[10],2)
		end

		if custom[11] == -1 then
			SetPedComponentVariation(ped,8,15,0,2)
		else
			SetPedComponentVariation(ped,8,custom[11],custom[12],2)
		end

		if custom[13] == -1 then
			if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
				SetPedComponentVariation(ped,6,34,0,2)
			elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
				SetPedComponentVariation(ped,6,35,0,2)
			end
		else
			SetPedComponentVariation(ped,6,custom[13],custom[14],2)
		end

		if custom[15] == -1 then
			SetPedComponentVariation(ped,11,15,0,2)
		else
			SetPedComponentVariation(ped,11,custom[15],custom[16],2)
		end

		if custom[17] == -1 then
			SetPedComponentVariation(ped,9,0,0,2)
		else
			SetPedComponentVariation(ped,9,custom[17],custom[18],2)
		end

		if custom[19] == -1 then
			SetPedComponentVariation(ped,10,0,0,2)
		else
			SetPedComponentVariation(ped,10,custom[19],custom[20],2)
		end

		if custom[21] == -1 then
			ClearPedProp(ped,0)
		else
			SetPedPropIndex(ped,0,custom[21],custom[22],2)
		end

		if custom[23] == -1 then
			ClearPedProp(ped,1)
		else
			SetPedPropIndex(ped,1,custom[23],custom[24],2)
		end

		if custom[25] == -1 then
			ClearPedProp(ped,2)
		else
			SetPedPropIndex(ped,2,custom[25],custom[26],2)
		end

		if custom[27] == -1 then
			ClearPedProp(ped,6)
		else
			SetPedPropIndex(ped,6,custom[27],custom[28],2)
		end

		if custom[29] == -1 then
			ClearPedProp(ped,7)
		else
			SetPedPropIndex(ped,7,custom[29],custom[30],2)
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ DRAWTEXT3DS ]-------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(0)
	SetTextScale(0.50,0.50)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/300
	--DrawRect(_x,_y+0.0125,0.01+factor,0.1,0,0,0,80)
end