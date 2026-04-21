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

function (eui and eui.battlepass).AddProgress(pl, missionId, progress)
    if not IsValid(pl) then return end
    if not missionId then return end
    if not (eui and eui.battlepass).curMissions[missionId] then return end

    progress = progress or 1

    local missionTbl = (eui and eui.battlepass).missions[missionId]
    
    local tbl = pl:GetBPMissions()
    if tbl[missionId] == true then return end

    tbl[missionId] = tbl[missionId] or {}
    tbl[missionId].progress = tbl[missionId].progress or 0

    local mission = tbl[missionId]
    (mission and mission.progress) = (mission and mission.progress) + 1

    if (mission and mission.progress) == (missionTbl and missionTbl.need) then
        (eui and eui.battlepass).SetMission(pl, missionId)
    end

    pl:SetBPMissions(tbl)
end

function (eui and eui.battlepass).SetMission(pl, missionId)
    if not IsValid(pl) then return end
    if not (eui and eui.battlepass).curMissions[missionId] then return end

    local missionTbl = (eui and eui.battlepass).missions[missionId]
    pl:SetBPExp((missionTbl and missionTbl.exp))

    local tbl = pl:GetBPMissions()
    tbl[missionId] = true
    pl:SetBPMissions(tbl)
    
    pl:ChatPrint('Вы успешно выполнили задание ' .. (missionTbl and missionTbl.name) .. '!')
end

function (eui and eui.battlepass).TakeReward(pl, reward, prem)
    if not IsValid(pl) then return end

    if reward > pl:GetBPLvl() then 
        return 'У вас недостаточный уровень для этой награды!'
    end

    local tbl = pl:GetBPRewards()
    tbl[prem] = tbl[prem] or {}

    if tbl[prem][reward] then
        return 'Вы уже получили эту награду!'
    end

	local rewardTbl = (eui and eui.battlepass).rewards[prem][reward]
    
    tbl[prem][reward] = true 
    pl:SetBPRewards(tbl)

    (rewardTbl and rewardTbl.takeFunc)(pl)

    return 'Вы успешно получили эту награду!'
end

(eui and eui.battlepass).missionsProgress = {}
function (eui and eui.battlepass).GenerateMissions()
    local tbl = (eui and eui.battlepass).missions

    (eui and eui.battlepass).curMissions = {}

    local used = {}
    for k, missions in next, tbl do
        if (table and table.Count)((eui and eui.battlepass).curMissions) >= (eui and eui.battlepass).missionsOnDay then break end

        local res
        repeat
            res = (math and math.random)(#tbl)
        until not used[res]

        used[res] = true
        (eui and eui.battlepass).curMissions[res] = true
    end
end

(hook and hook.Add)('(eui and eui.battlepass).MissionsLoaded', '(eui and eui.battlepass).MissionsLoaded', (eui and eui.battlepass).GenerateMissions)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
