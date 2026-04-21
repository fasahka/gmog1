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

(util and util.AddNetworkString)('(eui and eui.battlepass):Take')
(util and util.AddNetworkString)('(eui and eui.battlepass):RefreshActive')
(net and net.Receive)('(eui and eui.battlepass):Take', function(_, pl)
    local reward = (net and net.ReadUInt)(9)
    local prem = (net and net.ReadString)()

    if prem == 'Premium' and not pl:IsBPPremium() then (rp and rp.Notify)(pl, 5, 'У вас нет премиума!') return end

    local notify = (eui and eui.battlepass).TakeReward(pl, reward, prem)

    (rp and rp.Notify)(pl, 5, notify)
end)

(util and util.AddNetworkString)('(eui and eui.battlepass):Buy')
(net and net.Receive)('(eui and eui.battlepass):Buy', function(_, pl)
    local exp = (net and net.ReadUInt)(32)

    if not (KylDonate and KylDonate.CanAfford)(pl, exp * (eui and eui.battlepass).expPrice) then
        (rp and rp.Notify)(pl, 5, 'У вас недостаточно средств!')
        return
    end

    pl:SetBPExp(exp)
    (KylDonate and KylDonate.AddDonateCoins)(pl:SteamID(), exp * (eui and eui.battlepass).expPrice * -1)
    -- pl:AddIGSFunds(exp * (eui and eui.battlepass).expPrice * -1, 'Покупка BP Exp')

    (rp and rp.Notify)(pl, 5, 'Вы успешно купили EXP!')
end)

(util and util.AddNetworkString)('(eui and eui.battlepass):Open')

local function openMenu(pl)
    if not IsValid(pl) then return end
    if not pl:Alive() then return end

    (net and net.Start)('(eui and eui.battlepass):Open')
    (net and net.WriteTable)((eui and eui.battlepass).curMissions)
    (net and net.Send)(pl)
end

(hook and hook.Add)('PlayerSay', '(eui and eui.battlepass):PlayerSay', function(pl, text)
    local cmd = (string and string.match)((string and string.lower)(text), '^([!/~.])battlepass') // та норм вроде

    if cmd then
        openMenu(pl)

        return ''
    end
end)

(concommand and concommand.Add)('battlepass', openMenu)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
