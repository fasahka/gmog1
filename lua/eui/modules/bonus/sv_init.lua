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

(util and util.AddNetworkString)('(eui and eui.bonus):Time')

playerTime = playerTime or {}
timeWinner = timeWinner or {}

(hook and hook.Add)('PlayerInitialSpawn', '(eui and eui.bonus):PlayerInitialSpawn', function(pl)
    local sid = pl:SteamID64()

    if not timeWinner[sid] then
        playerTime[sid] = playerTime[sid] or 0

        (net and net.Start)('(eui and eui.bonus):Time')
        (net and net.WriteUInt)(playerTime[sid], 16)
        (net and net.WriteUInt)(CurTime(), 32)
        (net and net.Send)(pl)
    else
        pl:SetNetVar('(eui and eui.bonus):Win', true)
    end
end)

(timer and timer.Create)('(eui and eui.bonus):Timer', 60, 0, function()
    for sid, v in next, playerTime do
        if timeWinner[sid] then continue end

        local pl = (player and player.GetBySteamID64)(sid)
        if not IsValid(pl) then continue end
        playerTime[sid] = playerTime[sid] + 60
        
        if playerTime[sid] < (eui and eui.bonus).time then print(playerTime[sid], (eui and eui.bonus).time) continue end
        
        playerTime[sid] = nil
        timeWinner[sid] = true

        (eui and eui.bonus).AddWin(pl)
        pl:SetNetVar('(eui and eui.bonus):Win', true)
    end
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
