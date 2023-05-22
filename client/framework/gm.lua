local utils = require 'client.utils'
local groups = { 'job', 'job2' }
local playerGroups = {}
local playerItems = utils.getItems()

local function setPlayerData(playerData)
    table.wipe(playerGroups)
    table.wipe(playerItems)

    for i = 1, #groups do
        local group = groups[i]
        local data = playerData[group]

        if data then
            playerGroups[group] = data
        end
    end
end

SetTimeout(0, function()
    local GM = exports.GameMode:getSharedObject()
    if GM.PlayerLoaded then
        setPlayerData(GM.PlayerData)
    end
end)

RegisterNetEvent('gm:playerLoaded', function(data)
    if source == '' then return end
    setPlayerData(data)
end)

RegisterNetEvent('gm:setJob', function(job)
    if source == '' then return end
    playerGroups.job = job
end)

RegisterNetEvent('gm:setJob2', function(job)
    if source == '' then return end
    playerGroups.job2 = job
end)

RegisterNetEvent('gm:addInventoryItem', function(name, count)
    playerItems[name] = count
end)

RegisterNetEvent('gm:removeInventoryItem', function(name, count)
    playerItems[name] = count
end)

---@diagnostic disable-next-line: duplicate-set-field
function utils.hasPlayerGotGroup(filter)
    local _type = type(filter)
    for i = 1, #groups do
        local group = groups[i]

        if _type == 'string' then
            local data = playerGroups[group]

            if filter == data?.name then
                return true
            end
        elseif _type == 'table' then
            local tabletype = table.type(filter)

            if tabletype == 'hash' then
                for name, grade in pairs(filter) do
                    local data = playerGroups[group]

                    if data?.name == name and grade <= data.grade then
                        return true
                    end
                end
            elseif tabletype == 'array' then
                for j = 1, #filter do
                    local name = filter[j]
                    local data = playerGroups[group]

                    if data?.name == name then
                        return true
                    end
                end
            end
        end
    end
end
