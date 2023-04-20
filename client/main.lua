local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("qb-crates:SpawnCrate")
AddEventHandler("qb-crates:SpawnCrate", function(pos, model)
    
    if not HasModelLoaded(model) then
        RequestModel(model)

        while not HasModelLoaded(model) do
            Wait(0)
        end
    end

    obj = CreateObject(model, pos, true)
    SetEntityHeading(obj, 90.0)
    FreezeEntityPosition(obj, true)
    PlaceObjectOnGroundProperly(obj)
    SetEntityInvincible(obj, true)

    exports['qb-target']:AddEntityZone("maryweathercrate", obj, {
        name = "maryweathercrate",
        debugPoly = false,
    }, {
        options = {
            {
                type = "client",
                event = "qb-crates:robBox",
                icon = "fa-solid fa-gun",
                label = 'Weapons Crate',
            },
        },
        distance = 2.0
    })
    
end)

AddEventHandler("qb-crates:robBox", function()

    QBCore.Functions.Progressbar("search", "Searching Crate...", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
        }, {}, {}, {}, function()
            -- Do animation

            TriggerServerEvent('QBCore:Server:AddItem', "weapon_pistol", 1)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["weapon_pistol"], 'add')

            DeleteEntity(obj)
            
        end, function()
            -- Do something if cancled?
            -- Cancel animation
    end)

end)

RegisterNetEvent("PedSpawned")
AddEventHandler("PedSpawned", function(location)

	QBCore.Functions.TriggerCallback('qb-crates:server:SpawnNPC', function(netIds)

        Wait(1000)
        local ped = PlayerPedId()

        for i = 1, #netIds, 1 do

            local npc = NetworkGetEntityFromNetworkId(netIds[i])
            SetPedDropsWeaponsWhenDead(npc, false)
            GiveWeaponToPed(npc, Config.MaryWeapons[math.random(#Config.MaryWeapons)], 250, false, true)
            SetPedMaxHealth(npc, 750)
            SetPedArmour(npc, 500)
            SetCanAttackFriendly(npc, false, true)
            TaskCombatPed(npc, ped, 0, 16)
            SetPedCombatAttributes(npc, 46, true)
            SetPedCombatAttributes(npc, 0, false)
            SetPedCombatAbility(npc, 100)
            SetPedAsCop(npc, true)
            SetPedRelationshipGroupHash(npc, `HATES_PLAYER`)
            SetPedAccuracy(npc, 60)
            SetPedFleeAttributes(npc, 0, 0)
            SetPedKeepTask(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)

        end

    end, location)
    
end)

AddEventHandler('onResourceStop', function(resourceName)
    
    if (GetCurrentResourceName() ~= resourceName) then return end

    exports["qb-target"]:RemoveZone("maryweathercrate")
    DeleteEntity(obj)

end)

--[[
local function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = string.len(text) / 370
    DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

CreateThread(function()

    while true do

        local sleep = 1000

        local pos = GetEntityCoords(PlayerPedId()) -- Player that started the mission

        for k, v in pairs(Config.PhoneBooths) do

            local phone = GetClosestObjectOfType(pos, 20.0, v, false, false, false)

            if phone ~= 0 then

                local phonePos = GetEntityCoords(phone)

                if #(pos - phonePos) < 1.5 then

                    sleep = 0

                    DrawText3Ds(phonePos.x, phonePos.y, phonePos.z + 1.0, "Phone")

                end

            end

        end

        Wait(sleep)

    end

end)
]]--