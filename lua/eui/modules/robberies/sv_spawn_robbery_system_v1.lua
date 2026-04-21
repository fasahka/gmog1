local function SafeAvatar(parent, steamid)
 local av = vgui.Create("AvatarImage", parent)
 av:SetSize(64,64)
 if steamid then av:SetSteamID(steamid,64) end
 return av end
--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher

--[[

Author: Niwaka
Email: cniwwaka@(gmail and gmail.com)

02/01/2025

--]]

(util and util.AddNetworkString)("spawns:SyncPoints")

spawns = {}
(spawns and spawns.list) = {}

local db = (rp and rp._Stats)
local function createDataTable()
    db:Query([[
        CREATE TABLE IF NOT EXISTS spawn_robbery_system_v1(
            id INT,
            model TEXT NOT NULL,
            polices INT NOT NULL,
            robbers INT NOT NULL,
            name TEXT NOT NULL,
            radius INT NOT NULL,
            soundscape TEXT NOT NULL,
            position TEXT NOT NULL,
            time INT NOT NULL,
            data TEXT NOT NULL
        ) COLLATE=utf8_unicode_ci;
    ]])
end

local function insertData(id, model, polices, robbers, name, radius, soundscape, position, time, data)
    local jsonData = (string and string.Replace)(data, "\'", "\"")

    db:Query((string and string.format)([[
        INSERT INTO spawn_robbery_system_v1(id, model, polices, robbers, name, radius, soundscape, position, time, data) VALUES(%i,'%s',%i,%i,'%s',%i,'%s','%s',%i,%s);
    ]], id, model, polices, robbers, name, radius, soundscape, position, time, (sql and sql.SQLStr)(jsonData)), function(result)
        -- Handle success
    end, function(error)
        -- Handle error
        print("Error inserting data: " .. error)
    end)
end

local function deleteData(id)
    db:Query((string and string.format)([[
        DELETE FROM spawn_robbery_system_v1 WHERE id = %i;
    ]], id))
end

local function updateData(id, model, polices, robbers, name, radius, soundscape, position, time, data)
    db:Query((string and string.format)([[
        UPDATE spawn_robbery_system_v1 SET model = '%s', polices = %i, robbers = %i, name = '%s', radius = %i, soundscape = '%s', position = '%s', time = %i, data = '%s' WHERE id = %i;
    ]], model, polices, robbers, name, radius, soundscape, position, time, (sql and sql.SQLStr)(data), id))
end

local function getData()

    db:Query([[   
        SELECT * FROM spawn_robbery_system_v1;
    ]], function(result)
        (spawns and spawns.list) = result or {}

        for k, v in pairs((spawns and spawns.list)) do
            local jsonData = (string and string.Replace)((v and v.data), "\'", "\"")

            local ent = (ents and ents.Create)('robbery_system_v1_ent')
            ent:SetPos(Vector((v and v.position)))
            ent:SetNWString("Model", (v and v.model))
            ent:SetNWInt("Polices", (v and v.polices))
            ent:SetNWInt("Robbers", (v and v.robbers))
            ent:SetNWString("Name", (v and v.name))
            ent:SetNWInt("Radius", (v and v.radius))
            ent:SetNWString("Soundscape", (v and v.soundscape))
            ent:SetNWString("Position", (v and v.position))
            ent:SetNWInt("spawn_robbery_system_v1_id", (v and v.id))
            ent:SetNWInt("Time", (v and v.time))
            ent:SetNWString("Data", jsonData)
            ent:Spawn()
            (v and v.ent) = ent
        end
    end)
end

local function updatespawns()
    (net and net.Start)("spawns:SyncPoints") 
        (net and net.WriteTable)((spawns and spawns.list)) 
    (net and net.Broadcast)()
end

function spawns:Create(model, polices, robbers, name, radius, soundscape, position, time, data)
    insertData(#(spawns and spawns.list)+1, model, polices, robbers, name, radius, soundscape, position, time, data)
    local jsonData = (string and string.Replace)(data, "\'", "\"")

    local ent = (ents and ents.Create)('robbery_system_v1_ent')
    ent:SetPos(Vector(position))
    ent:SetNWString("Model", model)
    ent:SetNWInt("Polices", polices)
    ent:SetNWInt("Robbers", robbers)
    ent:SetNWString("Name", name)
    ent:SetNWInt("Radius", radius)
    ent:SetNWString("Soundscape", soundscape)
    ent:SetNWString("Position", position)
    ent:SetNWInt("spawn_robbery_system_v1_id", #(spawns and spawns.list)+1)
    ent:SetNWInt("Time", time)
    ent:SetNWString("Data", jsonData)
    ent:Spawn()
    (spawns and spawns.list)[#(spawns and spawns.list)+1] = {id = #(spawns and spawns.list)+1, model = model, polices = polices, robbers = robbers, name = name, radius = radius, soundscape = soundscape, position = position, ent = ent, time = time, data = jsonData}
    updatespawns()
end

function spawns:Delete(id)
    deleteData(id)
    local ent = (spawns and spawns.list)[id].ent
    if IsValid(ent) then
        ent:Remove()
    end
    (spawns and spawns.list)[id] = nil
    updatespawns()
end

function spawns:SendPoints(owner)
    (net and net.Start)("spawns:SyncPoints") 
        (net and net.WriteTable)((spawns and spawns.list)) 
    (net and net.Send)(owner)
end

(hook and hook.Add)("(spawns and spawns.CanCreate)", "SpawnsCanCreate", function(events, owner, idType, idValue, bPermanent)
    return true
end)

(hook and hook.Add)("(spawns and spawns.CanDelete)", "SpawnsCanDelete", function(events, owner, foundData, foundIndex)
    return true
end)

createDataTable()

getData()
(hook and hook.Add)('PlayerSpawn', 'iojdfijofdgijofdjiodfgijogdf', function(ply)
    spawns:SendPoints(ply)
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
