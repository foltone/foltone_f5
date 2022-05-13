local personalf5 = {
	ItemSelected = {},
	ItemIndex = {},
	WeaponData = {},
	Ped = PlayerPedId(),
	billing = {},
	bank = nil,
    sale = nil,
	handsUp = false,
}

local PlayerProps = {}

local societymoney, societymoney2 = nil, nil

local stylevide = { BackgroundColor={255, 255, 255, 0}, Line = {250, 250 ,250, 250}, Line2 = {250, 250 ,250, 250}}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(500)
	end

	RefreshMoney()

	personalf5.WeaponData = ESX.GetWeaponList()

	for i = 1, #personalf5.WeaponData, 1 do
		if personalf5.WeaponData[i].name == 'WEAPON_UNARMED' then
			personalf5.WeaponData[i] = nil
		else
			personalf5.WeaponData[i].hash = GetHashKey(personalf5.WeaponData[i].name)
		end
	end
	personalf5.Menu = false
end)


----- menu f5 ---

local Foltonef5 = RageUI.CreateMenu("Menu Interaction", 'Menu F5');
Foltonef5.EnableMouse = false;

local inventaire = RageUI.CreateSubMenu(Foltonef5, "Inventaire", "Inventaire")
local inventaireselec = RageUI.CreateSubMenu(inventaire, "Gestion", "Gestion")

local armes = RageUI.CreateSubMenu(Foltonef5, "Armes", "Armes")
local armesselec = RageUI.CreateSubMenu(armes, "Gestion", "Gestion")

local portefeuille = RageUI.CreateSubMenu(Foltonef5, "Porte-Feuille", "Porte-Feuille")
local facture = RageUI.CreateSubMenu(portefeuille, "Facture", "Facture")
local papiers = RageUI.CreateSubMenu(portefeuille, "Papiers", "Papiers")
local gestionsos = RageUI.CreateSubMenu(portefeuille, "Societé", "Societe")
local liquide = RageUI.CreateSubMenu(portefeuille, "Gestion", "Gestion")
local sale = RageUI.CreateSubMenu(portefeuille, "Gestion", "Gestion")

local vehicule = RageUI.CreateSubMenu(Foltonef5, "Vehicule", "Vehicule")
local apparenceveh = RageUI.CreateSubMenu(vehicule, "Gestion", "Gestion")
local porte = RageUI.CreateSubMenu(apparenceveh, "Porte", "Porte")
local fenetre = RageUI.CreateSubMenu(apparenceveh, "Fenetre", "Fenetre")
local extra = RageUI.CreateSubMenu(apparenceveh, "Extra", "Extra")
local limitateur = RageUI.CreateSubMenu(vehicule, "Limitateur", "Limitateur")

--------------- fuction ---------------


RegisterNetEvent('foltone:Weapon_addAmmoToPedC')
AddEventHandler('foltone:Weapon_addAmmoToPedC', function(value, quantity)
  local weaponHash = GetHashKey(value)

    if HasPedGotWeapon(PlayerPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
        AddAmmoToPed(PlayerPed, value, quantity)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	end
end)


function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
  
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
    	Citizen.Wait(500)
    end
  
    if UpdateOnscreenKeyboard() ~= 2 then
    	local result = GetOnscreenKeyboardResult()
    	Citizen.Wait(500)
    	return result
    else
    	Citizen.Wait(500)
    	return nil
    end
end

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	  ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
end)

function CheckQuantity(number)
	number = tonumber(number)
  
	if type(number) == 'number' then
	  number = ESX.Math.Round(number)
  
	  if number > 0 then
		return true, number
	  end
	end
  
	return false, number
end

--------------- fin fuction ---------------


Keys.Register("F5", "F5", "Test", function()
	RefreshMoney()
	RageUI.Visible(Foltonef5, not RageUI.Visible(Foltonef5))
end)

function RageUI.PoolMenus:Example()
	Foltonef5:IsVisible(function(Items)

		-- Items:AddButton("Inventaire", nil, {Color = {HightLightColor = { 255, 255, 255, 255}}, {BackgroundColor ={ 255, 255, 255, 255}}, RightLabel = ">", IsDisabled = false }, function(onSelected)
	
		-- end, inventaire)
		Items:AddSeparator("~b~Votre ID : ~o~"..GetPlayerServerId(PlayerId()))

		Items:AddButton("Inventaire", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, inventaire)

		Items:AddButton("Armes", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, armes)

		Items:AddButton("Porte-Feuille", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, portefeuille)

		Items:AddButton("Vehicule", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, vehicule)

	end, function(Panels)
	end)

--------------- inventaire ---------------
	inventaire:IsVisible(function(Items)
		menuinventaire()
	end, function()
	end)

	inventaireselec:IsVisible(function(Items)
		gestionitem()
	end, function()
	end)
--------------- fin inventaire ---------------

--------------- armes ---------------
	armes:IsVisible(function(Items)
		menuarmes()
	end, function()
	end)

	armesselec:IsVisible(function(Items)
		gestionarmes()
	end, function()
	end)
--------------- fin armes ---------------

--------------- porte feuille ---------------
	portefeuille:IsVisible(function(Items)
		menuportefeuille()
	end, function()
	end)

	facture:IsVisible(function(Items)
		menufacture()
	end, function()
	end)

	papiers:IsVisible(function(Items)
		menupapiers()
	end, function()
	end)
	gestionsos:IsVisible(function(Items)
		menugestionsos()
	end, function()
	end)

	liquide:IsVisible(function(Items)
		menuliquide()
	end, function()
	end)
	sale:IsVisible(function(Items)
		menusale()
	end, function()
	end)

--------------- fin porte feuille ---------------

--------------- vehicule ---------------
	vehicule:IsVisible(function(Items)
		menuvehicule()
	end, function()
	end)
	apparenceveh:IsVisible(function(Items)
		menuapparenceveh()
	end, function()
	end)
	porte:IsVisible(function(Items)
		menuporte()
	end, function()
	end)
	fenetre:IsVisible(function(Items)
		menufenetre()
	end, function()
	end)
	extra:IsVisible(function(Items)
		menuextra()
	end, function()
	end)
	limitateur:IsVisible(function(Items)
		menulimitateur()
	end, function()
	end)

--------------- fin vehicule ---------------

end


--------------- inventaire ---------------
function gestionitem()
	Items:AddButton("Utiliser", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			utiliseritem()
		end
	end)
	Items:AddButton("Donner", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			donneritem()
		end
	end)
	Items:AddButton("Jeter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			jeteritem()
		end
	end)
end
function menuinventaire()
    ESX.PlayerData = ESX.GetPlayerData()
    local countInventaire = 0;
    for i = 1, #ESX.PlayerData.inventory do
        if ESX.PlayerData.inventory[i].count > 0 then
            countInventaire = countInventaire + ESX.PlayerData.inventory[i].count
            Items:AddButton('[~b~' ..ESX.PlayerData.inventory[i].count.. '~s~] - ~s~' ..ESX.PlayerData.inventory[i].label, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
                	personalf5.ItemSelected = ESX.PlayerData.inventory[i]
				end
			end, inventaireselec)
        end
    end
    if countInventaire == 0 then
        RageUI.Line(stylevide, "~r~Inventaire vide")
    end	
end


function utiliseritem()
	if personalf5.ItemSelected.usable then
		TriggerServerEvent('esx:useItem', personalf5.ItemSelected.name)
	else
		ESX.ShowNotification("~r~L'items n'est pas utilisable")
	end
end

function donneritem()
local sonner,quantity = CheckQuantity(KeyboardInput("Nombres d'items que vous voulez donner", "Nombres d'items que vous voulez donner", '', 10))
local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
local pPed = GetPlayerPed(-1)
local coords = GetEntityCoords(pPed)
local x,y,z = table.unpack(coords)
	DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
	if sonner then
		if closestDistance ~= -1 and closestDistance <= 3 then
			local closestPed = GetPlayerPed(closestPlayer)
			if IsPedOnFoot(closestPed) then
					TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', personalf5.ItemSelected.name, quantity)
				else
					ESX.ShowNotification("~r~Nombres d'items invalid!")
				end
		else
			ESX.ShowNotification("~r~Aucun joueur proche!")
		end
	end
end

function jeteritem()
	if personalf5.ItemSelected.canRemove then
		local post,quantity = CheckQuantity(KeyboardInput("Nombres d'items que vous voulez jeter", "Nombres d'items que vous voulez jeter", '', 10))
		if post then
			if not IsPedSittingInAnyVehicle(PlayerPed) then
				TriggerServerEvent('esx:removeInventoryItem', 'item_standard', personalf5.ItemSelected.name, quantity)
			end
		end
	end
end

--------------- fin inventaire ---------------

--------------- armes ---------------
function gestionarmes()
	Items:AddButton("Donner des munition", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			donnermun()
		end
	end)
	Items:AddButton("Donner", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			donnerarmes()
		end
	end)
	Items:AddButton("Jeter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			jeterarmes()
		end
	end)
end
function donnermun()
	local post, quantity = CheckQuantity(KeyboardInput('Nombre de munitions', 'Nombre de munitions'), '', 10)
    
	if post then
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

		if closestDistance ~= -1 and closestDistance <= 3 then
			local closestPed = GetPlayerPed(closestPlayer)
			local pPed = GetPlayerPed(-1)
			local coords = GetEntityCoords(pPed)
			local x,y,z = table.unpack(coords)
			DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)

			if IsPedOnFoot(closestPed) then
				local ammo = GetAmmoInPedWeapon(personalf5.Ped, personalf5.ItemSelected.hash)

				if ammo > 0 then
					if quantity <= ammo and quantity >= 0 then
						local finalAmmo = math.floor(ammo - quantity)
						SetPedAmmo(personalf5.Ped, personalf5.ItemSelected.name, finalAmmo)

						TriggerServerEvent('foltone:Weapon_addAmmoToPedS', GetPlayerServerId(closestPlayer), personalf5.ItemSelected.name, quantity)
						ESX.ShowNotification('Vous avez donné x%s munitions à %s', quantity, GetPlayerName(closestPlayer))
						--RageUI.CloseAll()
					else
						ESX.ShowNotification('Vous ne possédez pas autant de munitions')
					end
				else
					ESX.ShowNotification("Vous n'avez pas de munition")
				end
			else
				ESX.ShowNotification('Vous ne pouvez pas donner des munitions dans un ~~r~véhicule~s~', personalf5.ItemSelected.label)
			end
		else
			ESX.ShowNotification('Aucun joueur ~r~proche~s~ !')
		end
	else
		ESX.ShowNotification('Nombre de munition ~r~invalid')
	end
end

function menuarmes()
	ESX.PlayerData = ESX.GetPlayerData()
	local countArmes = 0;
	for i = 1, #personalf5.WeaponData, 1 do
		if HasPedGotWeapon(personalf5.Ped, personalf5.WeaponData[i].hash, false) then
			countArmes = countArmes + 1
			local ammo = GetAmmoInPedWeapon(personalf5.Ped, personalf5.WeaponData[i].hash)
			if ammo == 0 then
				ammo = ammo +1
			end
			Items:AddButton('[~b~' ..ammo.. '~s~] - ~s~' ..personalf5.WeaponData[i].label, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					personalf5.ItemSelected = personalf5.WeaponData[i]
				end
			end, armesselec)
		end
	end
	if countArmes == 0 then
		RageUI.Line(stylevide, "~r~Aucune arme")
	end
end

function donnerarmes()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestDistance ~= -1 and closestDistance <= 3 then
		local closestPed = GetPlayerPed(closestPlayer)
		local pPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(pPed)
		local x,y,z = table.unpack(coords)
		DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)

		if IsPedOnFoot(closestPed) then
			local ammo = GetAmmoInPedWeapon(personalf5.Ped, personalf5.ItemSelected.hash)
			TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', personalf5.ItemSelected.name, ammo)
		else
			ESX.ShowNotification('~r~Impossible~s~ de donner une arme dans un véhicule', personalf5.ItemSelected.label)
		end
	else
		ESX.ShowNotification('Aucun joueur ~r~proche !')
	end
end

function jeterarmes()
	if IsPedOnFoot(personalf5.Ped) then
		TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', personalf5.ItemSelected.name)
		--RageUI.CloseAll()
	else
		ESX.ShowNotification("~r~Impossible~s~ de jeter l'armes dans un véhicule", mpersonalf5enu.ItemSelected.label)
	end
end
--------------- fin armes ---------------

--------------- porte feuille ---------------
function menuportefeuille()
	Items:AddSeparator("~b~Métier : ~o~"..ESX.PlayerData.job.label)

	Items:AddButton("Facture", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
	end, facture)

	Items:AddButton("Papiers", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
	end, papiers)

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		Items:AddButton("Gestion societé : ~o~"..ESX.PlayerData.job.label, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, gestionsos)
	end
	
	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'bank'  then
			Items:AddButton("Banque : ~b~".. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$", nil, { RightLabel = "", IsDisabled = false }, function(onSelected)
			end)
		end
	end

	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'money'  then
			Items:AddButton("Liquide : ~g~".. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			end, liquide)
		end
	end

	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'black_money'  then
			Items:AddButton("Sale : ~r~".. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			end, sale)
		end
	end
end

function menufacture()
	ESX.TriggerServerCallback('VInventory:billing', function(bills) personalf5.billing = bills end)

	if #personalf5.billing == 0 then
		RageUI.Line(stylevide, "~r~Aucune facture")
	end
	for i = 1, #personalf5.billing, 1 do
		Items:AddButton(personalf5.billing[i].label, nil, { RightLabel = '[~g~$' .. ESX.Math.GroupDigits(personalf5.billing[i].amount.."~s~] →"), IsDisabled = false }, function(onSelected)
			if (onSelected) then
				ESX.TriggerServerCallback('esx_billing:payBill', function()
				ESX.TriggerServerCallback('VInventory:billing', function(bills) personalf5.billing = bills end)
				end, personalf5.billing[i].id)
			end
		end)
	end
end

function menupapiers()
	Items:AddList("Carte d'identitée", Papier.liste, Papier.carteidentite.Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
		if (onListChange) then
			Papier.carteidentite.Index = Index;
		end
		if (onSelected) then
			Papier.carteidentite[Index]()
		end
	end)
	Items:AddList("Permis de conduire", Papier.liste, Papier.permis.Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
		if (onListChange) then
			Papier.permis.Index = Index;
		end
		if (onSelected) then
			Papier.permis[Index]()
		end
	end)
	Items:AddList("Permis de port d'arme", Papier.liste, Papier.ppa.Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
		if (onListChange) then
			Papier.ppa.Index = Index;
		end
		if (onSelected) then
			Papier.ppa[Index]()
		end
	end)
end
Papier = {
    liste = {
        'Regarder',
        'Montrer'
    },
    carteidentite =  {

        Index = 1,
        [1] = function()TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId())) end,
        [2] = function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		    if closestDistance ~= -1 and closestDistance <= 3.0 then
		        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
		    else
			    ESX.ShowNotification("Aucun joueur a proximité")
		    end
        end
    },
    permis = {
        Index = 1,
        [1] = function()TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')end,
        [2] = function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
            else
                ESX.ShowNotification("Aucun joueur a proximité")
            end
        end,
    },
    ppa = {
        Index = 1,
        [1] = function()TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')end,
        [2] = function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
            else
                ESX.ShowNotification("Aucun joueur a proximité")
            end
        end,
    },
}

function menugestionsos()
	if societymoney ~= nil then
		Items:AddSeparator("Societé : ~o~"..societymoney.."$")
	end
	Items:AddButton("Recruter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			if ESX.PlayerData.job.grade_name == 'boss' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification('Aucun joueur proche')
				else
					TriggerServerEvent('foltone:Boss_recruterplayer', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
				end
			else
				ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
			end
		end
	end)

	Items:AddButton("virer", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			if ESX.PlayerData.job.grade_name == 'boss' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification('Aucun joueur proche')
				else
					TriggerServerEvent('foltone:Boss_virerplayer', GetPlayerServerId(closestPlayer))
				end
			else
				ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
			end
		end
	end)

	Items:AddButton("Promouvoir", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			if ESX.PlayerData.job.grade_name == 'boss' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification('Aucun joueur proche')
				else
					TriggerServerEvent('foltone:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer))
			end
			else
				ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
			end
		end
	end)

	Items:AddButton("Destituer", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			if ESX.PlayerData.job.grade_name == 'boss' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification('Aucun joueur proche')
				else
					TriggerServerEvent('foltone:Boss_destituerplayer', GetPlayerServerId(closestPlayer))
				end
			else
				ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
			end
		end
	end)
end

function menuliquide()
	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'money' then
			Items:AddButton("Donner", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					local money, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", "Somme d'argent que vous voulez donner", '', 10))
						if money then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
					if closestDistance ~= -1 and closestDistance <= 3 then
						local closestPed = GetPlayerPed(closestPlayer)
	
						if not IsPedSittingInAnyVehicle(closestPed) then
							TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
						else
						   ESX.ShowNotification(_U('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles'))
						end
					else
					   ESX.ShowNotification('Aucun joueur proche !')
					end
					else
					ESX.ShowNotification('Somme invalid')
					end
				end
			end)
		end
	end
	
	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'money' then
			Items:AddButton("Jeter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					local money, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez jeter", "Somme d'argent que vous voulez jeter", '', 10))
					if money then
						if not IsPedSittingInAnyVehicle(PlayerPed) then
							TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
						else
							ESX.ShowNotification('Vous pouvez pas jeter', 'de l\'argent')
						end
					else
						ESX.ShowNotification('Somme Invalid')
					end
				end
			end)
		end
	end
end

function menusale()
	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'black_money' then
			Items:AddButton("Donner", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", "Somme d'argent que vous voulez donner", '', 10))
						if black then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3 then
						local closestPed = GetPlayerPed(closestPlayer)

						if not IsPedSittingInAnyVehicle(closestPed) then
							TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
							--RageUI.CloseAll()
						else
						   ESX.ShowNotification(_U('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles'))
						end
					else
					   ESX.ShowNotification('Aucun joueur proche !')
					end
					else
					ESX.ShowNotification('Somme invalid')
					end
				end
			end)
		end
	end

	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'black_money' then
			Items:AddButton("Jeter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez jeter", "Somme d'argent que vous voulez jeter", '', 10))
					if black then
						if not IsPedSittingInAnyVehicle(PlayerPed) then
							TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
					-- RageUI.CloseAll()
						else
							ESX.ShowNotification('Vous pouvez pas jeter', 'de l\'argent')
						end
					else
						ESX.ShowNotification('Somme Invalid')
					end
				end
			end)
		end
	end
end

--------------- fin porte feuille ---------------

--------------- vehicule ---------------
function menuvehicule()
	local pPed = GetPlayerPed(-1)
	local pInVeh = IsPedInAnyVehicle(pPed, false)
	if pInVeh then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
		if isInRightSeat then
			Items:AddButton("Gestion apparence", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			end, apparenceveh)
			Items:AddButton("Limitateur", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			end, limitateur)
		else
			RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
		end
	else
		RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
	end
end

function menuapparenceveh()
	local pPed = GetPlayerPed(-1)
	local pInVeh = IsPedInAnyVehicle(pPed, false)
	if pInVeh then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
		if isInRightSeat then
			Items:AddButton("Porte", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			end, porte)
			Items:AddButton("Fenêtre", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			end, fenetre)
			Items:AddButton("Extra", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			end, extra)
		else
			RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
		end
	else
		RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
	end
end

function menuporte()
	local pPed = GetPlayerPed(-1)
	local pInVeh = IsPedInAnyVehicle(pPed, false)
	if pInVeh then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
		if isInRightSeat then
			if vehicle.angledoor(0) then 
				Items:AddButton("~r~Fermé~s~ la porte avant gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.closedoor(0)
					end
				end)
			else
				Items:AddButton("~g~Ouvrir~s~ la porte avant gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.opendoor(0)
					end
				end)
			end
			if vehicle.angledoor(1) then 
				Items:AddButton("~r~Fermé~s~ la porte avant droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.closedoor(1)
					end
				end)
			else
				Items:AddButton("~g~Ouvrir~s~ la porte avant droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.opendoor(1)
					end
				end)
			end
			if vehicle.angledoor(2) then 
				Items:AddButton("~r~Fermé~s~ la porte arrière gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.closedoor(2)
					end
				end)
			else
				Items:AddButton("~g~Ouvrir~s~ la porte arrière gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.opendoor(2)
					end
				end)
			end
			if vehicle.angledoor(3) then 
				Items:AddButton("~r~Fermé~s~ la porte arrière droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.closedoor(3)
					end
				end)
			else
				Items:AddButton("~g~Ouvrir~s~ la porte arrière droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.opendoor(3)
					end
				end)
			end
			if vehicle.angledoor(4) then 
				Items:AddButton("~r~Fermé~s~ le capot", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.closedoor(4)
					end
				end)
			else
				Items:AddButton("~g~Ouvrir~s~ le capot", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.opendoor(4)
					end
				end)
			end
			if vehicle.angledoor(5) then 
				Items:AddButton("~r~Fermé~s~ le coffre", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.closedoor(5)
					end
				end)
			else
				Items:AddButton("~g~Ouvrir~s~ le coffre", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						vehicle.opendoor(5)
					end
				end)
			end
		else
			RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
		end
	else
		RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
	end
end

function menufenetre()
	local pPed = GetPlayerPed(-1)
	local pInVeh = IsPedInAnyVehicle(pPed, false)
	if pInVeh then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
		if isInRightSeat then
		Items:AddButton("~g~Descendre~s~ la fenêtre avant gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				vehicle.downwindo(0)
			end
		end)
		Items:AddButton("~g~Descendre~s~ la fenêtre avant droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				vehicle.downwindo(1)
			end
		end)
		Items:AddButton("~g~Descendre~s~ la fenêtre arrière gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				vehicle.downwindo(2)
			end
		end)
		Items:AddButton("~g~Descendre~s~ la fenêtre arrière droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				vehicle.downwindo(3)
			end
		end)

		Items:AddButton("~r~Monter~s~ toute les fenetres", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				vehicle.upwindo(0)
				vehicle.upwindo(1)
				vehicle.upwindo(2)
				vehicle.upwindo(3)
			end
		end)
		else
			RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
		end
	else
		RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
	end
end

function menuextra()
	local pPed = GetPlayerPed(-1)
	local pInVeh = IsPedInAnyVehicle(pPed, false)
	if pInVeh then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
		if isInRightSeat then
			for i = 1, 9 do
				if DoesExtraExist(pVeh, i) then
					if IsVehicleExtraTurnedOn(pVeh, i) then
						Items:AddButton("~r~Désactiver~s~ l'extra " .. i, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
							if (onSelected) then
								SetVehicleExtra(pVeh, i, true)
							end
						end)
					else
						Items:AddButton("~g~Activer~s~ l'extra " .. i, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
							if (onSelected) then
								SetVehicleExtra(pVeh, i, false)
							end
						end)
					end
				end
			end
		else
			RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
		end
	else
		RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
	end
end

local limit, speedLimitActive, door, hood, chest = "Aucune Limitation", false, 1, 1, 1

function menulimitateur()
	local pPed = GetPlayerPed(-1)
	local pInVeh = IsPedInAnyVehicle(pPed, false)
	CarSpeed = GetEntitySpeed(plyVehicle) * 3.6
	if pInVeh then
		local pVeh = GetVehiclePedIsIn(pPed, false)
		local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
		if isInRightSeat then
			Items:AddButton("Limitation ~o~personalisé", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					local speedlimit = KeyboardInput("Rentrer une vitesse", "Rentrer une vitesse")
					if speedlimit ~= "" then
						SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), speedlimit/3.7)
					end
				end
			end)
			Items:AddButton("Limitation ~g~30km/h", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 8.1)
				end
			end)
			Items:AddButton("Limitation ~g~50km/h", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 13.7)
				end
			end)
			Items:AddButton("Limitation ~g~80km/h", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 22.0)
				end
			end)
			Items:AddButton("Limitation ~g~120km/h", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 33.0)
				end
			end)
			Items:AddButton("~r~Désactiver la limitation", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)
				end
			end)
		else
			RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
		end
	else
		RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
	end
end



function angledoor(arg)
	return GetVehicleDoorAngleRatio(vehicle.currentVehicle(), arg) > 0.0
end
vehicle = {

    ped = function()
        return GetPlayerPed(-1)
    end,

    currentVehicle = function()
        return GetVehiclePedIsIn(GetPlayerPed(-1), false)
    end,

    Temp = function ()
         return GetVehicleEngineTemperature(vehicle.currentVehicle())
    end,

    Health = function ()
        return GetVehicleEngineHealth(vehicle.currentVehicle())
    end,

    vehicleOn = function ()
        return SetVehicleEngineOn(vehicle.currentVehicle(), true, false, true)
    end,
    
    vehicleOff = function ()
        return SetVehicleEngineOn(vehicle.currentVehicle(), false, false, true)
    end,

    Oil = function ()
        return GetVehicleOilLevel(vehicle.currentVehicle())
    end,

    vehicleengine = function ()
        return GetIsVehicleEngineRunning(vehicle.currentVehicle())
    end,
    

    pedinvehicle = function()
        return  IsPedSittingInAnyVehicle( vehicle.ped() )
    end,

    angledoor = function(arg)
        return GetVehicleDoorAngleRatio(vehicle.currentVehicle(), arg) > 0.0
        
    end,

    opendoor = function(arg)
        return SetVehicleDoorOpen(vehicle.currentVehicle(), arg, false)
    end,

    closedoor = function(arg)
        return SetVehicleDoorShut(vehicle.currentVehicle(), arg, false)
    end,

    downwindo = function(arg)
          window = RollDownWindow(vehicle.currentVehicle(),arg) 
    end,

    upwindo = function(arg)
        return RollUpWindow(vehicle.currentVehicle(),arg)
    end,
}
--------------- fin vehicule ---------------