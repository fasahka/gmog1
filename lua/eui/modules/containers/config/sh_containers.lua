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

local container = (eui and eui.container)

(container and container.containers) = {}

function container:AddContainer(rarity, time, min)
    local tbl = {
        rarity = rarity,
        time = time,
        min = min
    }

    (self and self.containers)[#(self and self.containers) + 1] = tbl
end

container:AddContainer('Обычный', '12:45', 25000)
container:AddContainer('Редкий', '14:15', 50000)
container:AddContainer('Эпический', '15:45', 70000)
container:AddContainer('Мифический', '16:30', 300000)
container:AddContainer('Легендарный', '18:00', 1500000)
container:AddContainer('Неизвестный', '20:00', 4000000)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
