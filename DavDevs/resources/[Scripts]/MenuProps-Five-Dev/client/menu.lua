ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    PlayerData = ESX.GetPlayerData()
    if PlayerData.job.name == 'police' then
        arme = true
    end
    if PlayerData.job.name == 'unemployed' then
        arme = true
    end
    if PlayerData.job.name == 'gruppe6' then
        gruppe6 = true
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    
    if PlayerData.job.name == 'police' then
        arme = true
    end
    if PlayerData.job.name == 'unemployed' then
        arme = true
    end
    if PlayerData.job.name == 'gruppe6' then
        gruppe6 = true
    end
end)

RMenu.Add('LSPD', 'main', RageUI.CreateMenu("Menu Props", " "))
RMenu:Get('LSPD', 'main'):SetSubtitle("Categorias :")
RMenu:Get('LSPD', 'main').EnableMouse = false
RMenu:Get('LSPD', 'main').Closed = function()
    -- TODO Perform action
end;


RMenu.Add('LSPD', 'object', RageUI.CreateSubMenu(RMenu:Get('LSPD', 'main'), "Props", "Appuyer sur [~g~E~w~] pour poser les objet"))
RMenu.Add('LSPD', 'object2', RageUI.CreateSubMenu(RMenu:Get('LSPD', 'main'), "Props", "Appuyer sur [~g~E~w~] pour poser les objet"))
RMenu.Add('LSPD', 'object3', RageUI.CreateSubMenu(RMenu:Get('LSPD', 'main'), "Props", "Appuyer sur [~g~E~w~] pour poser les objet"))
RMenu.Add('LSPD', 'object4', RageUI.CreateSubMenu(RMenu:Get('LSPD', 'main'), "Props", "Appuyer sur [~g~E~w~] pour poser les objet"))
RMenu.Add('LSPD', 'object5', RageUI.CreateSubMenu(RMenu:Get('LSPD', 'main'), "Props", "Appuyer sur [~g~E~w~] pour poser les objet"))
RMenu.Add('LSPD', 'object6', RageUI.CreateSubMenu(RMenu:Get('LSPD', 'main'), "Props", "Appuyer sur [~g~E~w~] pour poser les objet"))
RMenu.Add('LSPD', 'object7', RageUI.CreateSubMenu(RMenu:Get('LSPD', 'main'), "Props", "Appuyer sur [~g~E~w~] pour poser les objet"))
RMenu.Add('LSPD', 'objectlist', RageUI.CreateSubMenu(RMenu:Get('LSPD', 'object'), "Suppression d'objets", "~b~Suppression d'objets"))

object = {}
OtherItems = {}local inventaire = false
local status = true

RageUI.CreateWhile(1.0, function()
    if IsControlJustPressed(1, 57) then
        RageUI.Visible(RMenu:Get('LSPD', 'main'), not RageUI.Visible(RMenu:Get('LSPD', 'main')))
    end

    if RageUI.Visible(RMenu:Get('LSPD', 'main')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false }, function()

            RageUI.Button("Civil", "Appuyer sur [~g~E~w~] pour poser les objet", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('LSPD', 'object'))

            RageUI.Button("LSPD", "Appuyer sur [~g~E~w~] pour poser les objet", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('LSPD', 'object4'))

            RageUI.Button("EMS", "Appuyer sur [~g~E~w~] pour poser les objet", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('LSPD', 'object2'))

            RageUI.Button("Mecano", "Appuyer sur [~g~E~w~] pour poser les objet", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('LSPD', 'object7'))

            RageUI.Button("Gang", "Appuyer sur [~g~E~w~] pour poser les objet", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('LSPD', 'object3'))

            RageUI.Button("Armes", "Appuyer sur [~g~E~w~] pour poser les objet", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('LSPD', 'object5'))

            RageUI.Button("Drogue", "Appuyer sur [~g~E~w~] pour poser les objet", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('LSPD', 'object6'))

            RageUI.Button("Mode suppression", "Supprimer des objets", { RightLabel = "XXX" }, true, function(Hovered, Active, Selected)
            end, RMenu:Get('LSPD', 'objectlist'))

        end, function()
            ---Panels
        end)
    end

-- Civil
    if RageUI.Visible(RMenu:Get('LSPD', 'object')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false }, function()

        	RageUI.Button("Chaise", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("apa_mp_h_din_chair_12")
                end
            end)

        	RageUI.Button("Carton", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_cardbordbox_04a")
                end
            end)

            RageUI.Button("Sac", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_cs_heist_bag_02")
                end
            end)

            RageUI.Button("Table 1", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_rub_table_02")
                end
            end)

            RageUI.Button("Table 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_table_04")
                end
            end)

            RageUI.Button("Table 3", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_table_01b")
                end
            end)

            RageUI.Button("Petite Chaise", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_clubhouse_chair_01")
                end
            end)

            RageUI.Button("Ordinateur", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_clubhouse_laptop_01a")
                end
            end)

            RageUI.Button("Chaise Bureau", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_clubhouse_offchair_01a")
                end
            end)

            RageUI.Button("Lit Bunker", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("gr_prop_bunker_bed_01")
                end
            end)

            RageUI.Button("Lit Biker", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("gr_prop_gr_campbed_01")
                end
            end)

            RageUI.Button("Chaise Peche", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("hei_prop_hei_skid_chair")
                end
            end)

        end, function()
            ---Panels
        end)
    end

-- Mecano
if RageUI.Visible(RMenu:Get('LSPD', 'object7')) then
    RageUI.DrawContent({ header = true, glare = true, instructionalButton = false }, function()

        RageUI.Button("Outils", nil, {}, true, function(Hovered, Active, Selected)
            if Selected then
                SpawnObj("prop_cs_trolley_01")
            end
        end)
        
        RageUI.Button("Outils mecano", nil, {}, true, function(Hovered, Active, Selected)
            if Selected then
                SpawnObj("prop_carcreeper")
            end
        end)

        RageUI.Button("Sac à outils", nil, {}, true, function(Hovered, Active, Selected)
            if Selected then
                SpawnObj("prop_cs_heist_bag_02")
            end
        end)

    end, function()
        ---Panels
    end)
end

-- EMS
    if RageUI.Visible(RMenu:Get('LSPD', 'object2')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false }, function()

            RageUI.Button("Sac mortuaire", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("xm_prop_body_bag")
                end
            end)

            RageUI.Button("Trousse médical 1", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("xm_prop_smug_crate_s_medical")
                end
            end)

            RageUI.Button("Trousse médical 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("xm_prop_x17_bag_med_01a")
                end
            end)

        end, function()
            ---Panels
        end)
    end

-- Gang
    if RageUI.Visible(RMenu:Get('LSPD', 'object3')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false }, function()

            RageUI.Button("Chaise", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_chair_01a")
                end
            end)

            RageUI.Button("Sac pour arme", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_gun_case_01")
                end
            end)

            RageUI.Button("Cash", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("hei_prop_cash_crate_half_full")
                end
            end)

            RageUI.Button("Valise de cash", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_cash_case_02")
                end
            end)

            RageUI.Button("Petite pile de cash", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_cash_crate_01")
                end
            end)

            RageUI.Button("Poubelle", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_cs_dumpster_01a")
                end
            end)

            RageUI.Button("Canapé", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("v_tre_sofa_mess_c_s")
                end
            end)

            RageUI.Button("Canapé 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("v_res_tre_sofa_mess_a")
                end
            end)

            RageUI.Button("Pile de cash", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_bkr_cashpile_04")
                end
            end)

            RageUI.Button("Pile de cash 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_bkr_cashpile_05")
                end
            end)
            
        end, function()
            ---Panels
        end)
    end

-- LSPD
    if RageUI.Visible(RMenu:Get('LSPD', 'object4')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false }, function()

            RageUI.Button("Cone", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_roadcone02a")
                end
            end)
            RageUI.Button("Barrière", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_barrier_work05")
                end
            end)
            
            RageUI.Button("Gros carton", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("prop_boxpile_07d")
                end
            end)

            RageUI.Button("Herse", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("p_ld_stinger_s")
                end
            end)

        end, function()
            ---Panels
        end)
    end

-- Armes
    if RageUI.Visible(RMenu:Get('LSPD', 'object5')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false }, function()
            
            RageUI.Button("Malette Armes", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_biker_gcase_s")
                end
            end)

            RageUI.Button("Caisse Batteuses", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("ex_office_swag_guns04")
                end
            end)

            RageUI.Button("Caisse Armes", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("ex_prop_crate_ammo_bc")
                end
            end)

            RageUI.Button("Caisse Batteuses 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("ex_prop_crate_ammo_sc")
                end
            end)

            RageUI.Button("Caisse Fermé", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("ex_prop_adv_case_sm_03")
                end
            end)

            RageUI.Button("Petite Caisse", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("ex_prop_adv_case_sm_flash")
                end
            end)

            RageUI.Button("Caisse Explosif", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("ex_prop_crate_expl_bc")
                end
            end)

            RageUI.Button("Caisse Vetements", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("ex_prop_crate_expl_sc")
                end
            end)

            RageUI.Button("Caisse Chargeurs", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("gr_prop_gr_crate_mag_01a")
                end
            end)

            RageUI.Button("Grosse Caisse Armes", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("gr_prop_gr_crates_rifles_01a")
                end
            end)

            RageUI.Button("Grosse Caisse Armes 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("gr_prop_gr_crates_weapon_mix_01a")
                end
            end)

        end, function()
            ---Panels
        end)
    end

-- Drogue
    if RageUI.Visible(RMenu:Get('LSPD', 'object6')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false }, function()

            RageUI.Button("Cocaine Block", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_coke_block_01a")
                end
            end)

            RageUI.Button("Cocaine Pallet", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_coke_pallet_01a")
                end
            end)

            RageUI.Button("Balance Cocaine", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_coke_scale_01")
                end
            end)

            RageUI.Button("Spatule Cocaine", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_coke_spatula_04")
                end
            end)

            RageUI.Button("Table Cocaine", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_coke_table01a")
                end
            end)

            RageUI.Button("Caisse", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_crate_set_01a")
                end
            end)

            RageUI.Button("Palette Weed", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_fertiliser_pallet_01a")
                end
            end)

            RageUI.Button("Palette 1", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_fertiliser_pallet_01b")
                end
            end)

            RageUI.Button("Palette 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_fertiliser_pallet_01c")
                end
            end)

            RageUI.Button("Palette 3", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_fertiliser_pallet_01d")
                end
            end)

            RageUI.Button("Acetone Meth", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_acetone")
                end
            end)

            RageUI.Button("Bidon Meth", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_ammonia")
                end
            end)

            RageUI.Button("Bac Meth", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_bigbag_01a")
                end
            end)

            RageUI.Button("Bac Meth 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_bigbag_02a")
                end
            end)

            RageUI.Button("Bac Meth 3", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_bigbag_03a")
                end
            end)

            RageUI.Button("Lithium Meth", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_lithium")
                end
            end)

            RageUI.Button("Phosphorus Meth", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_phosphorus")
                end
            end)

            RageUI.Button("Pseudoephedrine", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_pseudoephedrine")
                end
            end)

            RageUI.Button("Meth Smash", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_smashedtray_01")
                end
            end)

            RageUI.Button("Machine a sous", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_money_counter")
                end
            end)

            RageUI.Button("Acetone Meth", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_acetone")
                end
            end)

            RageUI.Button("Pot Weed", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_01_small_01b")
                end
            end)

            RageUI.Button("Packet Weed", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_bigbag_03a")
                end
            end)

            RageUI.Button("Packet Weed Ouvert", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_bigbag_open_01a")
                end
            end)

            RageUI.Button("Pot Weed 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_bucket_01d")
                end
            end)

            RageUI.Button("Weed", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_drying_01a")
                end
            end)

            RageUI.Button("Weed Plante", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_lrg_01b")
                end
            end)

            RageUI.Button("Weed Plante 2", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_med_01b")
                end
            end)

            RageUI.Button("Table Weed", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_drying_01a")
                end
            end)

            RageUI.Button("Weed Pallet", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("hei_prop_heist_weed_pallet")
                end
            end)

            RageUI.Button("Coke", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("imp_prop_impexp_boxcoke_01")
                end
            end)

            RageUI.Button("Coke en bouteille", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_coke_bottle_01a")
                end
            end)

            RageUI.Button("Coke coupé", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_coke_cut_01")
                end
            end)

            RageUI.Button("Bol de coke", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_coke_fullmetalbowl_02")
                end
            end)

            RageUI.Button("Prop meth", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_pseudoephedrine")
                end
            end)

            RageUI.Button("Sac de meth ouvert", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_openbag_01a")
                end
            end)

            RageUI.Button("Gros sac de meth", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_meth_bigbag_04a")
                end
            end)

            RageUI.Button("Gros sac de weed", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_bigbag_03a")
                end
            end)

            RageUI.Button("Weed plante", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_01_small_01a")
                end
            end)

            RageUI.Button("Weed", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_dry_02b")
                end
            end)

            RageUI.Button("Table de weed", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_weed_table_01a")
                end
            end)

            RageUI.Button("Block de coke", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnObj("bkr_prop_coke_block_01a")
                end
            end)
            
        end, function()
            ---Panels
        end)
    end

    if RageUI.Visible(RMenu:Get('LSPD', 'objectlist')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false }, function()

            for k,v in pairs(object) do
                if GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))) == 0 then table.remove(object, k) end
                RageUI.Button("Object: "..GoodName(GetEntityModel(NetworkGetEntityFromNetworkId(v))).." ["..v.."]", nil, {}, true, function(Hovered, Active, Selected)
                    if Active then
                        local entity = NetworkGetEntityFromNetworkId(v)
                        local ObjCoords = GetEntityCoords(entity)
                        DrawMarker(0, ObjCoords.x, ObjCoords.y, ObjCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 1, 0, 2, 1, nil, nil, 0)
                    end
                    if Selected then
                        RemoveObj(v, k)
                    end
                end)
            end
            
        end, function()
            ---Panels
        end)
    end

end, 1)

RegisterCommand('props', function()
    RageUI.Visible(RMenu:Get('LSPD', 'main'), true)
end, true)