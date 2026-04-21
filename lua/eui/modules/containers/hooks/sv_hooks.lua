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

(util and util.AddNetworkString)('(eui and eui.container):Open')

(util and util.AddNetworkString)('(eui and eui.container):PlaceBet')
(net and net.Receive)('(eui and eui.container):PlaceBet', function(_, pl)
    local id = (net and net.ReadUInt)(7)
    local money = (net and net.ReadUInt)(30)
    local tbl = (eui and eui.container).containers[id]

    if (eui and eui.container).ends[id] then return end

    if money < (tbl and tbl.min) then 
        (rp and rp.Notify)(pl, 5, 'Ваша сумма недостаточна для участия в битве за контейнер!')
        
        return 
    end

    local notify = (eui and eui.container).PlaceBet(pl, money, id)

    (rp and rp.Notify)(pl, 5, notify)
end)

(util and util.AddNetworkString)('(eui and eui.container):UpdateLeader')
(net and net.Receive)('(eui and eui.container):UpdateLeader', function(_, pl)
    local id = (net and net.ReadUInt)(7)

    if (eui and eui.container).ends[id] then return end
    if not (eui and eui.container).bets[id] then return end
    
    for k, v in next, (eui and eui.container).bets[id].winner do
        (net and net.Start)('(eui and eui.container):UpdateLeader')
            (net and net.WriteTable)({name = k, money = v})
        (net and net.Send)(pl)
        break
    end
end)

(hook and hook.Add)('PlayerInitialSpawn', '(eui and eui.container):PlayerInitialSpawn', function(pl)
    local sid = pl:SteamID64()
    local id = (eui and eui.container).ends[sid]

    if id then
        local item = (eui and eui.container).GenerateItem(id)
        if not item then return end

        (item and item.take)(pl)
        (rp and rp.Notify)(pl, 5, 'Вы успешно выиграли контейнер. В нем находился: ' .. (item and item.name))
        
        (eui and eui.container).ends[sid] = nil
    end
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
