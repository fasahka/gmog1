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

(eui and eui.battlepass) = (eui and eui.battlepass) or {}

(eui and eui.battlepass).exp = 1000 // сколько exp нужно получить чтобы лвлапнуться
(eui and eui.battlepass).missionsOnDay = 10 // сколько миссий генерируется на день
(eui and eui.battlepass).minPrice = 300 // сколько минимум очков нужно купить
(eui and eui.battlepass).expPrice = 2 // сколько DP стоит один exp

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
