local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONEXÃO ]-----------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/rem_lacars","DELETE FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP.prepare("vRP/rem_lahouses","DELETE FROM vrp_homes_permissions WHERE user_id = @user_id")
vRP.prepare("vRP/get_lavehicles","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")

------------------------------------------------------------------------------------------------------------------------------
--[ WEBHOOK ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local logAdminRenomear = ""
local logsAdminCar = ""
local logsAdminGod = ""
local logsAdminWL = ""
local logsAdminGeral = ""
local logsAdminMoney = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

------------------------------------------------------------------------------------------------------------------------------
--[ VROUPAS ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local player_customs = {}
RegisterCommand('vroupas',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local custom = vRPclient.getCustomization(source)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
        if player_customs[source] then
            player_customs[source] = nil
            vRPclient._removeDiv(source,"customization")
        else 
            local content = ""
            for k,v in pairs(custom) do
                content = content..k.." => "..json.encode(v).."<br/>" 
            end

            player_customs[source] = true
            vRPclient._setDiv(source,"customization",".div_customization{ margin: auto; padding: 4px; width: 250px; margin-top: 200px; margin-right: 50px; background: rgba(15,15,15,0.7); color: #ffff; font-weight: bold; }",content)
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ ESTOQUE ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('estoque',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
        if args[1] and args[2] then
            vRP.execute("creative/set_estoque",{ vehicle = args[1], quantidade = args[2] })
            TriggerClientEvent("Notify",source,"sucesso","Voce colocou mais <b>"..args[2].."</b> no estoque, para o carro <b>"..args[1].."</b>.") 
            SendWebhookMessage(logsAdminCar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ ADD-CAR ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('addcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserId(parseInt(args[2]))
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            vRP.execute("creative/add_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) }) 
            --vRP.execute("creative/set_ipva",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) })
            TriggerClientEvent("Notify",source,"sucesso","Voce adicionou o veículo <b>"..args[1].."</b> para o Passaporte: <b>"..parseInt(args[2]).."</b>.") 
            SendWebhookMessage(logsAdminCar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ REM-CAR ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('remcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserId(parseInt(args[2]))
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            vRP.execute("creative/rem_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time())  }) 
            TriggerClientEvent("Notify",source,"sucesso","Voce removeu o veículo <b>"..args[1].."</b> do Passaporte: <b>"..parseInt(args[2]).."</b>.") 
            SendWebhookMessage(logsAdminCar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ UNCUFF ]------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('uncuff',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
			TriggerClientEvent("admcuff",source)
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ SYNCAREA ]----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limpararea',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
        TriggerClientEvent("syncarea",-1,x,y,z)
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ APAGAO ]------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('apagao',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"dono.permissao") and args[1] ~= nil then
            local cond = tonumber(args[1])
            --TriggerEvent("cloud:setApagao",cond)
            TriggerClientEvent("cloud:setApagao",-1,cond)                    
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ RAIOS ]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('raios', function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"dono.permissao") and args[1] ~= nil then
            local vezes = tonumber(args[1])
            TriggerClientEvent("cloud:raios",-1,vezes)           
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ DEBUG ]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('debug',function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		if vRP.hasPermission(user_id,"dono.permissao") then
			TriggerClientEvent("ToggleDebug",player)
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ NEW-LIFE ]----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('newlife',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
        if user_id then
            if args[1] then
                local identity = vRP.getUserIdentity(parseInt(args[1]))
                if vRP.request(source,"Deseja dar uma Nova Vida ao Passaporte: <b>"..args[1].." "..identity.name.." "..identity.firstname.."</b> ?",30) then
                    local id = vRP.getUserSource(parseInt(args[1]))
                    if id then  
                        vRP.kick(id,"Você acaba de ganhar uma Nova Vida.")
                    end
                    local myHomes = vRP.query("homes/get_homeuserid",{ user_id = parseInt(args[1]) })
                    if parseInt(#myHomes) >= 1 then
                        for k,v in pairs(myHomes) do
                            local ownerHomes = vRP.query("homes/get_homeuserowner",{ user_id = parseInt(args[1]), home = tostring(v.home) })
                            if ownerHomes[1] then
                                for k,i in pairs(ownerHomes) do
                                    vRP.execute("creative/rem_srv_data",{ dkey = "chest:"..tostring(i.home) })
                                    vRP.execute("creative/rem_srv_data",{ dkey = "outfit:"..tostring(i.home) })
                                    vRP.execute("homes/rem_lapermissions",{ home = tostring(i.home) })
                                end
                                vRP.execute("homes/rem_permissions",{ home = tostring(v.home), user_id = parseInt(args[1]) })
                                vRP.execute("vRP/rem_lahouses",{ user_id = parseInt(args[1]) })
                            end
                        end
                    end
                    local myCars = vRP.query("vRP/get_lavehicles",{ user_id = parseInt(args[1]) })
                    if parseInt(#myCars) >= 1 then
                        for k,v in pairs(myCars) do
                            vRP.execute("creative/rem_srv_data",{ dkey = "chest:u"..parseInt(args[1]).."veh_"..tostring(v.vehicle) })
                            vRP.execute("creative/rem_srv_data",{ dkey = "custom:u"..parseInt(args[1]).."veh_"..tostring(v.vehicle) })
                            vRP.execute("vRP/rem_lacars",{ user_id = parseInt(args[1]) })
                        end
                    end
                    vRP.setUData(parseInt(args[1]),"vRP:datatable",json.encode(vRP.getUserDataTable(parseInt(args[1]))))
                    vRP.setUData(parseInt(args[1]),"vRP:multas",parseInt(0))
                    vRP.setUData(parseInt(args[1]),"vRP:paypal",parseInt(0))
                    vRP.setUData(parseInt(args[1]),"vRP:prisao",parseInt(-1))
                    vRP.setUData(parseInt(args[1]),"vRP:spawnController",parseInt(0))
                    vRP.setUData(parseInt(args[1]),"vRP:tattoos",json.encode(vRP.getUserDataTable(parseInt(args[1]))))
                    vRP.execute("vRP/set_money",{ user_id = parseInt(args[1]), wallet = 5000, bank = 25000 })
                    TriggerClientEvent("Notify",source,"sucesso","Você deu uma Nova Vida ao Passaporte: <b>"..parseInt(args[1]).." "..identity.name.." "..identity.firstname.."</b>.")
                end          
            end
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ TRYDELETEOBJ ]------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj",function(index)
    TriggerClientEvent("syncdeleteobj",-1,index)
end)

------------------------------------------------------------------------------------------------------------------------------
--[ GOD ]---------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('god',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.killGod(nplayer)
                vRPclient.setHealth(nplayer,400)
                TriggerClientEvent("resetBleeding",nplayer)
                TriggerClientEvent("resetDiagnostic",nplayer)
                SendWebhookMessage(logsAdminGod,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DEU GOD EM]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            end
        else
            vRPclient.killGod(source)
            vRPclient.setHealth(source,400)
            TriggerClientEvent("resetBleeding",source)
            TriggerClientEvent("resetDiagnostic",source)
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ FIX ]---------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fix',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local vehicle = vRPclient.getNearestVehicle(source,11)
	if vehicle then
        if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
			TriggerClientEvent('reparar',source)
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ HASH ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('hash',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
		TriggerClientEvent('vehash',source)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ TUNING ]------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tuning',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
        if vehicle then
            local oficialid = vRP.getUserIdentity(user_id)
            SendWebhookMessage(logsAdminCar,"```prolog\n[STAFF]: "..oficialid.name.." "..oficialid.firstname.." "..user_id.." \n[UTILIZOU O COMANDO]: /tuning \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
			TriggerClientEvent('vehtuning',source,vehicle)
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ WL ]----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('wl',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        if args[1] then
            vRP.setWhitelisted(parseInt(args[1]),true)
            TriggerClientEvent("Notify",source,"sucesso","Voce aprovou o passaporte <b>"..args[1].."</b> na whitelist.")
            SendWebhookMessage(logsAdminWL,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APROVOU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ UNWL ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unwl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		if args[1] then
			vRP.setWhitelisted(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce retirou o passaporte <b>"..args[1].."</b> da whitelist.")
			SendWebhookMessage(logsAdminWL,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ KICK ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		if args[1] then
			local id = vRP.getUserSource(parseInt(args[1]))
            if id then
				vRP.kick(id,"Você foi expulso da cidade.")
				TriggerClientEvent("Notify",source,"sucesso","Voce kickou o passaporte <b>"..args[1].."</b> da cidade.")
				SendWebhookMessage(logsAdminGeral,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[KICKOU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ KICK-ALL ]----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kickall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
        local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
                vRP.kick(id,"Você foi vitima do terremoto.")
                SendWebhookMessage(logsAdminGeral,"```\n[STAFF]: "..oficialid.name.." "..oficialid.firstname.." "..user_id.." \n[UTILIZOU O COMANDO]: /kickall \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
            end
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ BAN ]---------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),true)
			TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte <b>"..args[1].."</b> da cidade.")
			SendWebhookMessage(logsAdminGeral,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[BANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ MONEY ]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('money',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"dono.permissao") then
		if args[1] then
			vRP.giveMoney(user_id,parseInt(args[1]))
			SendWebhookMessage(logsAdminMoney,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[FEZ]: $"..vRP.format(parseInt(args[1])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ NC ]----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		vRPclient.toggleNoclip(source)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ TPCDS ]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpcds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
		local fcoords = vRP.prompt(source,"Cordenadas:","")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ CDS ]---------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		heading = GetEntityHeading(GetPlayerPed(-1))
		vRP.prompt(source,"Cordenadas:","['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z))
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ CDS2 ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds2',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:",tD(x)..", "..tD(y)..", "..tD(z))
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ CDS3 ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds3',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:","{name='ATM', id=277, x="..tD(x)..", y="..tD(y)..", z="..tD(z).."},")
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ CDS4 ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds4',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:","x = "..tD(x)..", y = "..tD(y)..", z = "..tD(z))
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ CDS5 ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds5',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
        local x,y,z = vRPclient.getPosition(source)
        vRP.prompt(source,"Cordenadas:",x..","..y..","..z)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ CDSH ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cdsh',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
        local x,y,z = vRPclient.getPosition(source)
        local lugar = vRP.prompt(source,"Lugar:","")
        if lugar == "" then
            return
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ CDS-CORRIDA ]-------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("cds:corridas")
AddEventHandler("cds:corridas",function()
local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
	end
end)

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end

------------------------------------------------------------------------------------------------------------------------------
--[ GROUP ]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('group',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		if args[1] and args[2] then
			vRP.addUserGroup(parseInt(args[1]),args[2])
			TriggerClientEvent("Notify",source,"sucesso","Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")
			SendWebhookMessage(logsAdminGroups,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ UNGROUP ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ungroup',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		if args[1] and args[2] then
			vRP.removeUserGroup(parseInt(args[1]),args[2])
			TriggerClientEvent("Notify",source,"sucesso","Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.")
			SendWebhookMessage(logsAdminGroups,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ TPTOME ]------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tptome',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			local x,y,z = vRPclient.getPosition(source)
			if tplayer then
				vRPclient.teleport(tplayer,x,y,z)
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ TPTO ]--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpto',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			if tplayer then
				vRPclient.teleport(source,vRPclient.getPosition(tplayer))
			end
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ TPWAY ]-------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpway',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		TriggerClientEvent('tptoway',source)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ CAR ]---------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('car',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		if args[1] then
			TriggerClientEvent('spawnarveiculo',source,args[1])
			SendWebhookMessage(logsAdminCar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SPAWNOU]: "..(args[1]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ ANUNCIO ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adm',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[MENSAGEM]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(255,50,50,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 10%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: Administrador")
		SetTimeout(60000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)

------------------------------------------------------------------------------------------------------------------------------
--[ PLAYERSON ]-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pon',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"dono.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
        local users = vRP.getUsers()
        local players = ""
        local quantidade = 0
        for k,v in pairs(users) do
            if k ~= #users then
                players = players..", "
            end
            players = players..k
            quantidade = quantidade + 1
        end
        TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{255,160,0},quantidade)
        TriggerClientEvent('chatMessage',source,"ID's ONLINE",{255,160,0},players)
    end
end)