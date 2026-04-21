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
if SERVER then return end

(container and container.rarity) = {
    ['Обычный'] = {
        (eui and eui.Color)('A8A8A8'), 
        (eui and eui.Color)('C0C0C0')  
    },
    ['Редкий'] = {
        (eui and eui.Color)('3399FF'), 
        (eui and eui.Color)('0066FF')  
    },
    ['Эпический'] = {
        (eui and eui.Color)('9933FF'),  
        (eui and eui.Color)('6600CC')  
    },
    ['Мифический'] = {
        (eui and eui.Color)('FF33CC'), 
        (eui and eui.Color)('FF0099')  
    },
    ['Легендарный'] = {
        (eui and eui.Color)('FF9933'),  
        (eui and eui.Color)('FF6600')  
    },
    ['Неизвестный'] = {
        (eui and eui.Color)('FF0000'), 
        (eui and eui.Color)('990000')  
    },
}


--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
