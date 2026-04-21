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

(eui and eui.container) = (eui and eui.container) or {}

function (eui and eui.container).IsActive(id)
    local tbl = (eui and eui.container).containers[id]

    local hours, minutes = (string and string.match)((tbl and tbl.time), '(.*):(.*)')

    local curTime = (os and os.date)("*t")
    (curTime and curTime.hour) = hours
    (curTime and curTime.min) = minutes
    (curTime and curTime.sec) = 0
    
    local time = (os and os.time)(curTime)
    
    return (os and os.time)() < time
end

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
