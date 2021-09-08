local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
spawnselector = Tunnel.getInterface("spawnselector")
local SpawnLocation = {}






RegisterCommand('tp',function()
    TriggerEvent("b2k-character:normalSpawn")
end)


RegisterNetEvent('vrp:ToogleLoginMenu')
AddEventHandler('vrp:ToogleLoginMenu', function()
    SetTimecycleModifier('hud_def_blur')
    SendNUIMessage({action = "display"})
    SetNuiFocus(true, true)
end)


function getTime()
    local hour = GetClockHours()
    if hour >= 6 and hour < 20 then
        return "dia"
    end
    return "noite"
end

local SPAWNS = {
    ["airport"] = vector3(-1037.74,-2738.04,20.1693),
    ["mrpd"] = vector3(425.06,-979.67,30.71),
    ["hospital"] = vector3(283.83,-578.6,43.21),
    ["mirror"] = vector3(1630.27, -85.42, 166.82),
    ["sandy"] = vector3(1877.17,3705.23,33.22),
    ["motel"] = vector3(314.94, -236.77, 53.97),
    ["paleto"] = vector3(-123.46,6449.06,31.43),
    ["praca"] = vector3(162.18, -1003.27, 29.36),
    ["ponte"] = vector3(1141.67, -2578.87, 32.73),
    ["beach"] = vector3(-1735.97,-1113.86,13.06)
}

RegisterNUICallback('spawn', function(data, cb)
    local SpawnName = data.location
 
    if SpawnName == "last" then
        local coords = spawnselector.ultimaposicao()
        SPAWNS["last"] = vector3(coords.x,coords.y,coords.z) 
    end
    SpawnLocation = SPAWNS[SpawnName]
    TriggerEvent("ToogleBackCharacter")
	TriggerEvent("status:hud",false)
    CameraPos(SpawnLocation.x,SpawnLocation.y,SpawnLocation.z)
end)

RegisterNUICallback('time', function(data, cb)
    SendNUIMessage({action = getTime()})
end)

function CameraPos(x,y,z)
    local pos = {x = x, y = y, z = z}
    SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
    DoScreenFadeIn(500)
    SetTimecycleModifier('default')
    SetNuiFocus(false, false)
    Citizen.Wait(500)
    local cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam2, pos.x,pos.y,pos.z+200)
    SetCamActiveWithInterp(cam2, cam, 900, true, true)
    Citizen.Wait(900)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+200, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam, pos.x,pos.y,pos.z+2)
    SetCamActiveWithInterp(cam, cam2, 3700, true, true)
    Citizen.Wait(3700)
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, true, true)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    DoScreenFadeIn(1000)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    DisplayHud(true)
    DisplayRadar(true)
end
