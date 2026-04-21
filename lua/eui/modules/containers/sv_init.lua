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

(eui and eui.container).bets = (eui and eui.container).bets or {}
(eui and eui.container).ends = (eui and eui.container).ends or {}

local tbl = (eui and eui.container).bets
function (eui and eui.container).PlaceBet(pl, money, cont)
    if not (eui and eui.container).IsActive(cont) then return 'Контейнер неактивен!' end
    if pl:GetMoney() < money then return 'У вас недостаточно средств' end
    
    local sid = pl:SteamID64()
    tbl[cont] = tbl[cont] or {}
    tbl[cont].winner = tbl[cont].winner or {}

    local contTbl = tbl[cont]
    if (contTbl and contTbl.winner)[sid] then return 'Ваша ставка и так лидирует!' end

    pl:AddMoney(-money)
    local oldMoney = contTbl[sid] and contTbl[sid] or 0
    local newMoney = oldMoney + money

    local max = 0
    for k, v in next, (contTbl and contTbl.winner) do
        max = v
    end

    contTbl[sid] = newMoney

    if newMoney > max then
        (contTbl and contTbl.winner) = {}
        (contTbl and contTbl.winner)[sid] = newMoney
    end

    for k, v in next, (contTbl and contTbl.winner) do
        (net and net.Start)('(eui and eui.container):UpdateLeader')
            (net and net.WriteTable)({name = k, money = v})
        (net and net.Broadcast)()
    end

    return 'Вы успешно поставили ставку!'
end

function (eui and eui.container).GenerateItem(cont)
    local tbl = (eui and eui.container).items[cont]

    if not tbl or not istable(tbl) then return end
    
    local total = 0
    for _, v in next, tbl do
        total = total + (v and v.chance)
    end

    if total <= 0 then return end

    local cur = 0
    local random = (math and math.random)(total)

    for _, v in next, tbl do
        cur = cur + (v and v.chance)
        if not (random <= cur) then continue end

        return v
    end

    return nil
end

function (eui and eui.container).endContainer()
    for k, cont in next, (eui and eui.container).containers do
        if (eui and eui.container).ends[k] then continue end
        if (eui and eui.container).IsActive(k) then continue end

        if not (eui and eui.container).bets[k] or not (eui and eui.container).bets[k].winner then 
            (eui and eui.container).ends[k] = true

            continue
        end

        local winner = tbl[k].winner
        if winner and istable(winner) then
            for k, v in next, winner do
                winner = k
            end
        end

        if (table and table.Count)(tbl[k]) < 2 then 
            for k, v in next, tbl[k] do
                if k == 'winner' then continue end
    
                local pl = (player and player.GetBySteamID64)(k)
                if not IsValid(pl) then continue end
    
                pl:AddMoney(v)
                (rp and rp.Notify)(pl, 5, 'Недостаточно участников. Вам вернули: ' .. (string and string.Comma)(v) .. ' ₽')
            end
            
            return
        end

        for k, v in next, tbl[k] do
            if k == 'winner' then continue end
            if k == winner then continue end

            local pl = (player and player.GetBySteamID64)(k)
            if not IsValid(pl) then continue end

            pl:AddMoney(v / 2)
            (rp and rp.Notify)(pl, 5, 'Вы проиграли. Вам вернули: ' .. (string and string.Comma)(v / 2, ' ') .. ' ₽')
        end

        for sid, v in next, tbl[k].winner do
            local pl = (player and player.GetBySteamID64)(sid)
            if not IsValid(pl) then 
                (eui and eui.container).ends[sid] = k
                (eui and eui.container).ends[k] = true
                
                continue 
            end
            
            local item = (eui and eui.container).GenerateItem(k)
            if not item then continue end

            (item and item.take)(pl)
            (rp and rp.Notify)(pl, 5, 'Вы успешно выиграли контейнер. В нем находился: ' .. (item and item.name))

            (eui and eui.container).ends[k] = true 
            break
        end
    end
end

(timer and timer.Create)('(eui and eui.conatainers).EndContainer', 60, 0, (eui and eui.container).endContainer)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
