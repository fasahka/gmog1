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

(rp and rp.cladman) = (rp and rp.cladman) or {}

(rp and rp.cladman).zalog = 4500
(rp and rp.cladman).max_bags = 10
(rp and rp.cladman).money_for_bag = 850

(nw and nw.Register)("(rp and rp.cladman)"):Write((net and net.WriteInt), 5):Read((net and net.ReadInt), 5):SetLocalPlayer()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
