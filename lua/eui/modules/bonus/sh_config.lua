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

(eui and eui.bonus) = (eui and eui.bonus) or {}

(eui and eui.bonus).time = 3600 * 5 // сколько секунд нужно отыграть чтобы получить приз

function (eui and eui.bonus).AddWin(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl:SteamID(), 2500)
    pl:ChatPrint('Вы получили награду за отыгрыш 5 часов!')
end

(nw and nw.Register)('(eui and eui.bonus):Time')
:Write((net and net.WriteUInt), 32)
:Read((net and net.ReadUInt), 32)
:SetLocalPlayer()

(nw and nw.Register)('(eui and eui.bonus):Win')
:Write((net and net.WriteBool))
:Read((net and net.ReadBool))
:SetLocalPlayer()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
