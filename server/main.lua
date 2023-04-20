local QBCore = exports['qb-core']:GetCoreObject()

local models = {
    `s_m_y_blackops_01`,
    `s_m_y_blackops_02`,
    `s_m_y_blackops_03`
}

QBCore.Functions.CreateCallback('qb-crates:server:SpawnNPC', function(source, cb, location)
    
    local netIds = {}
    local netId
    local npc
    local setModel = math.floor(math.random(#models))

    for i = 1, #Config.Location[location].positions, 1 do
        
        local npc = CreatePed(30, models[setModel], Config.Location[location].positions[i], true, false)

        while not DoesEntityExist(npc) do Wait(10) end
        netId = NetworkGetNetworkIdFromEntity(npc)
        netIds[#netIds+1] = netId

    end

    TriggerClientEvent('qb-crates:SpawnCrate', -1, Config.Location[location].cratePos, Config.Location[location].model)

    cb(netIds)

end)

QBCore.Commands.Add('crate', "Spawn an object", {{ name = "location", help = "warehouse/government" }}, true, function(source, args)

    TriggerClientEvent("PedSpawned", source, args[1])

end, 'admin')