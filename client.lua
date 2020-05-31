ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5000)
    end
end)

local holdingPackage          = false
local dropkey 	= 246 
local closestEntity = 0

attachPropList = {
	{["model"] = 'prop_roadcone02a',				["name"] = "cone", 		["bone"] = 28422, ["x"] = 0.6,	["y"] = -0.15,	["z"] = -0.1,	["xR"] = 315.0,	["yR"] = 288.0, ["zR"] = 0.0, 	["anim"] = 'pick' }, -- Done
    {["model"] = 'prop_cs_trolley_01',				["name"] = "trolley", 		["bone"] = 28422, ["x"] = 0.0,	["y"] = -0.6,	["z"] = -0.8,	["xR"] = -180.0,["yR"] = -165.0,["zR"] = 90.0, 	["anim"] = 'hold' }, -- Done
	{["model"] = 'prop_table_03',					["name"] = "mesa", 		["bone"] = 28422, ["x"] = 0.0,	["y"] = -0.8,	["z"] = -0.7,	["xR"] = -180.0,["yR"] = -165.0,["zR"] = 90.0, 	["anim"] = 'hold' }, -- Done
	{["model"] = 'prop_tool_box_04',				["name"] = "ferramentas", 	["bone"] = 28422, ["x"] = 0.4,	["y"] = -0.1,	["z"] = -0.1,	["xR"] = 315.0,	["yR"] = 288.0, ["zR"] = 0.0, 	["anim"] = 'pick' }, -- Done
	{["model"] = "xm_prop_smug_crate_s_medical",			["name"] = "MedBox", 		["bone"] = 28422, ["x"] = 0.0,	["y"] = -0.1,	["z"] = -0.1,	["xR"] = 0.0,	["yR"] = 0.0, 	["zR"] = 0.0, 	["anim"] = 'hold' }, -- Done
	{["model"] = 'xm_prop_x17_bag_med_01a',				["name"] = "MedBag", 		["bone"] = 28422, ["x"] = 0.4,	["y"] = -0.1,	["z"] = -0.1,	["xR"] = 315.0,	["yR"] = 298.0, ["zR"] = 0.0, 	["anim"] = 'pick' }, -- Done
    {["model"] = "prop_table_03_chr",				["name"] = "cadeira", 		["bone"] = 28422, ["x"] = 0.0,	["y"] = -0.2,	["z"] = -0.6,	["xR"] = 0.0,	["yR"] = 0.0, 	["zR"] = 0.0 , 	["anim"] = 'hold' }, -- Done
    {["model"] = 'prop_cs_cardbox_01',				["name"] = "caixa", 		["bone"] = 28422, ["x"] = 0.01,	["y"] = 0.01,	["z"] = 0.0,	["xR"] = -255.0,["yR"] = -120.0,["zR"] = 40.0, 	["anim"] = 'hold' }, -- Done
	{["model"] = "imp_prop_impexp_lappy_01a",			["name"] = "portatil", 		["bone"] = 28422, ["x"] = 0.0,	["y"] = 0.0,	["z"] = -0.15,	["xR"] = 0.0,	["yR"] = 0.0, 	["zR"] = 0.0 , 	["anim"] = 'hold' }, -- Done
	{["model"] = 'xm_prop_x17_bag_01a',				["name"] = "saco", 		["bone"] = 28422, ["x"] = 0.4,	["y"] = -0.1,	["z"] = -0.1,	["xR"] = 315.0,	["yR"] = 298.0, ["zR"] = 0.0, 	["anim"] = 'pick' }, -- Done
	{["model"] = "p_ld_soc_ball_01",				["name"] = "bola", 		["bone"] = 28422, ["x"] = 0.0,	["y"] = 0.0,	["z"] = 0.0,	["xR"] = 0.0,	["yR"] = 0.0, 	["zR"] = 0.0 , 	["anim"] = 'hold' }, -- Done
	{["model"] = "prop_mp_drug_package",				["name"] = "droga", 		["bone"] = 28422, ["x"] = 0.0,	["y"] = -0.25,	["z"] = -0.05,	["xR"] = 0.0,	["yR"] = 0.0, 	["zR"] = 0.0 , 	["anim"] = 'hold' },
	{["model"] = 'prop_premier_fence_01',				["name"] = "fence", 		["bone"] = 28422, ["x"] = 0.0,	["y"] = -0.6,	["z"] = -0.8,	["xR"] = -180.0,["yR"] = -165.0,["zR"] = 90.0, 	["anim"] = 'hold' }, -- Done
	{["model"] = 'prop_kino_light_02',				["name"] = "luz", 		["bone"] = 28422, ["x"] = 0.0,	["y"] = -0.6,	["z"] = -0.8,	["xR"] = -180.0,["yR"] = -165.0,["zR"] = 90.0, 	["anim"] = 'hold' }, -- Done
	{["model"] = "prop_cash_case_01",				["name"] = "maladinheiro", 	["bone"] = 28422, ["x"] = 0.0,	["y"] = -0.1,	["z"] = -0.1,	["xR"] = 0.0,	["yR"] = 0.0, 	["zR"] = 0.0, 	["anim"] = 'hold' }, -- Done
}

RegisterNetEvent('inrp_propsystem:attachProp')
AddEventHandler('inrp_propsystem:attachProp', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	notifi("~r~Y~w~ pour prendre/déplacer l'objet et ~r~ /r~w~ pour l'enlever manuellement", true, false, 120)
    closestEntity = 0
    holdingPackage = true
    local attachModel = GetHashKey(attachModelSent)
    SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263) 
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumberSent)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Citizen.Wait(0)
    end
    closestEntity = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	for i=1 ,#attachPropList , 1 do
		if (attachPropList[i].model == attachModelSent) and (attachPropList[i].anim == 'hold') then
			holdAnim()
		end
	end
	Citizen.Wait(200)
    AttachEntityToEntity(closestEntity, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, true, 2, 1)
end)

function notifi(text)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayHelp(0, false, false, 3000)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

function randPickupAnim()
  local randAnim = math.random(7)
    loadAnimDict('random@domestic')
    TaskPlayAnim(GetPlayerPed(-1),'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
end

function holdAnim()
    loadAnimDict( "anim@heists@box_carry@" )
	TaskPlayAnim((GetPlayerPed(-1)),"anim@heists@box_carry@","idle",4.0, 1.0, -1,49,0, 0, 0, 0)
end

Citizen.CreateThread( function()
    while true do 
		Citizen.Wait(10)		
		if IsPedOnFoot(GetPlayerPed(-1)) and not IsPedDeadOrDying(GetPlayerPed(-1)) then
			if IsControlJustReleased(0, dropkey) then
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local closestDistance = -1
				closestEntity   = 0
				for i=1, #attachPropList, 1 do
					local object = GetClosestObjectOfType(coords, 1.5, GetHashKey(attachPropList[i].model), false, false, false)
					if DoesEntityExist(object) then
						local objCoords = GetEntityCoords(object)
						local distance  = GetDistanceBetweenCoords(coords, objCoords, true)
						if closestDistance == -1 or closestDistance > distance then
							closestDistance = distance
							closestEntity   = object
							if not holdingPackage then
								local dst = GetDistanceBetweenCoords(GetEntityCoords(closestEntity) ,GetEntityCoords(GetPlayerPed(-1)),true)                 
								if dst < 2 then
									holdingPackage = true
									if attachPropList[i].anim == 'pick' then
										randPickupAnim()
									elseif attachPropList[i].anim == 'hold' then
										holdAnim()
									end
									Citizen.Wait(550)
									NetworkRequestControlOfEntity(closestEntity)
									while not NetworkHasControlOfEntity(closestEntity) do
										Wait(0)
									end
									SetEntityAsMissionEntity(closestEntity, true, true)
									while not IsEntityAMissionEntity(closestEntity) do
										Wait(0)
									end
									SetEntityHasGravity(closestEntity, true)
									AttachEntityToEntity(closestEntity, GetPlayerPed(-1),GetPedBoneIndex(GetPlayerPed(-1), attachPropList[i].bone), attachPropList[i].x, attachPropList[i].y, attachPropList[i].z, attachPropList[i].xR, attachPropList[i].yR, attachPropList[i].zR, 1, 1, 0, true, 2, 1)
								end
							else
								holdingPackage = false
								if attachPropList[i].anim == 'pick' then
									randPickupAnim()
								end
								Citizen.Wait(350)
								DetachEntity(closestEntity)
								ClearPedTasks(GetPlayerPed(-1))
								ClearPedSecondaryTask(GetPlayerPed(-1))
							end
						end
						break
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function removeAttachedProp()
    if DoesEntityExist(closestEntity) then
        DeleteEntity(closestEntity)
    end
end

function attach(prop)
    TriggerEvent("inrp_propsystem:attachItem",prop)
end

function removeall()
    TriggerEvent("RemoveItems",false)
	ClearPedTasks(GetPlayerPed(-1))
	ClearPedSecondaryTask(GetPlayerPed(-1))
end

RegisterNetEvent('inrp_propsystem:attachItem')
AddEventHandler('inrp_propsystem:attachItem', function(item)
	for i=1 ,#attachPropList , 1 do
		if (attachPropList[i].model == item) then
			TriggerEvent("inrp_propsystem:attachProp",attachPropList[i].model, attachPropList[i].bone, attachPropList[i].x, attachPropList[i].y, attachPropList[i].z, attachPropList[i].xR, attachPropList[i].yR, attachPropList[i].zR)
		end
	end
end)

RegisterNetEvent("RemoveItems")
AddEventHandler("RemoveItems", function(sentinfo)
    SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("weapon_unarmed"), 1)
	removeAttachedProp()
	holdingPackage = false
end)


Citizen.CreateThread( function()
	RegisterCommand("r", function()
		removeall()
	end, false)
			
	for i=1, #attachPropList, 1 do
		RegisterCommand(attachPropList[i].name, function(source, args, raw)
			local arg = args[1]

			if arg == nil then
				attach(attachPropList[i].model)
			end
			
		end, false)
	end
	
end)

local PropsMenu = {
    Base = { Title = "Menu Props" },
    Data = { currentMenu = "Vous pouvez posez vos objets" },
    Events = {
        onSelected = function(self, _, btn, CMenu, menuData, currentButton, currentSlt, result)
            if btn.name == "Plot" then
                ExecuteCommand('cone')
                ESX.ShowNotification('Vous avez poser un plot.')
            end
            if btn.name == "Caisse à outils" then
                ExecuteCommand('trolley')
                ESX.ShowNotification('Vous avez poser une caisse à outils.')
            end
            if btn.name == "Table" then
                ExecuteCommand('mesa')
                ESX.ShowNotification('Vous avez poser une Table.')
            end
            if btn.name == "Petite caisse" then
                ExecuteCommand('ferramentas')
                ESX.ShowNotification('Vous avez poser une petite caisse.')
            end
            if btn.name == "MediKit" then
                ExecuteCommand('MedBox')
                ESX.ShowNotification('Vous avez poser un sac.')
            end
            if btn.name == "Sac Médecin" then
                ExecuteCommand('MedBag')
                ESX.ShowNotification('Vous avez poser un sac.')
            end
            if btn.name == "Chaise" then
                ExecuteCommand('cadeira')
                ESX.ShowNotification('Vous avez poser une chaise.')
            end
            if btn.name == "Boîte en carton" then
                ExecuteCommand('caixa')
                ESX.ShowNotification('Vous avez poser une boîte.')
            end
            if btn.name == "Sac" then
                ExecuteCommand('saco')
                ESX.ShowNotification('Vous avez pris un Sac.')
            end
            if btn.name == "Ballon" then
                ExecuteCommand('bola')
                ESX.ShowNotification('Vous avez poser un Ballon.')
            end
            if btn.name == "Drogues" then
                ExecuteCommand('droga')
                ESX.ShowNotification('Vous avez poser une malette de drogue.')
            end
            if btn.name == "Barrière" then
                ExecuteCommand('fence')
                ESX.ShowNotification('Vous avez poser une bannière.')
            end
            if btn.name == "Lumière" then
                ExecuteCommand('luz')
                ESX.ShowNotification('Vous avez poser une lumière.')
            end
            if btn.name == "Enlever l'objet" then
                ExecuteCommand('r')
                ESX.ShowNotification('Vous retirer votre objet.')
            end
            if btn.name == "Comment ça marche ?" then
                PlaySoundFrontend(-1, "Hit_In", "PLAYER_SWITCH_CUSTOM_SOUNDSET", true)
                ESX.ShowAdvancedNotification("Comment ça marche ?", "Menu Props", "Pour poser votre objet appuyez sur ~b~Y ~w~ et pour supprimez faites ~b~/r ~w~dans le chat.", "CHAR_HUMANDEFAULT", 1)
            end
        end,
    },

    Menu = {
        ["Vous pouvez posez vos objets"] = {
            b = {
                {name = "Objets", ask = ">", askX = true},
                {name = "Enlever l'objet",  askX = true},
                {name = "Comment ça marche ?", ask = ">", askX = true},
            }
        },
        ["objets"] = {
            b = {
                {name = "Plot", askX = true},
                {name = "Caisse à outils", askX = true},
                {name = "Table", askX = true},
                {name = "Petite caisse", askX = true},
                {name = "MediKit", askX = true},
                {name = "Sac Médecin", askX = true},
                {name = "Chaise", askX = true},
                {name = "Boîte en carton", askX = true},
                {name = "Sac", askX = true},
                {name = "Ballon", askX = true},
                {name = "Drogues", askX = true},
                {name = "Barrière", askX = true},
                {name = "Lumière", askX = true},
            }
        },
    }
}

RegisterCommand("propsmenu", function()
    CreateMenu(PropsMenu)
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if IsControlJustReleased(0, 83) then
            CreateMenu(PropsMenu)
        end  
    end
end)

Citizen.CreateThread(function() while true do Citizen.Wait(30000) collectgarbage() end end) 
