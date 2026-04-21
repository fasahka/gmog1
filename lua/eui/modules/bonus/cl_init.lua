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

local roundedBox = (paint and paint.roundedBoxes).roundedBox
local simpleText = (draw and draw.SimpleText)

local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)
local scrW, scrH = ScrW(), ScrH()
local gft = Material("eui/bonus/(gift and gift.png)")

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.bonus):OnScreenSizeChanged', function(_, _, w, h)
    scrW, scrH = w, h
end)

local playerTime, seconds = 0, 0
(hook and hook.Add)('HUDPaint', '(eui and eui.bonus):HUDPaint', function()
    -- local pl = LocalPlayer()

    -- if pl:GetNetVar('(eui and eui.bonus):Win') then return end
    
    -- local after = (seconds + (eui and eui.bonus).time) - CurTime() - playerTime
    -- print(playerTime, seconds)
    -- local hours = (math and math.floor)(after / 3600)
    -- local minutes = (math and math.floor)((after % 3600) / 60)
    
    -- local x, y = scrW - sh(344), sh(523)
    -- local w, h = sh(329), sh(97)

    -- roundedBox(5, x, y, w, h, {(eui and eui.Color)('FF4C77', 0), (eui and eui.Color)('FF4C77', 40), (eui and eui.Color)('FF4C77', 40), (eui and eui.Color)('FF4C77', 0)})
    -- (eui and eui.DrawMaterial)((eui and eui.Material)('bonus', 'gift'), x + w - sh(100), y, sh(97), sh(100))

    -- simpleText('ОТЫГРАЙ 3 ЧАСА', (eui and eui.Font)('16:SemiBold'), x + w - sh(116), y + sh(16), color_white, 2)
    -- local y1 = y + sh(35)
    -- local x1 = x + w - sh(116)
    -- local w1 = simpleText(' ДОНАТА', (eui and eui.Font)('13:Medium'), x1, y1, color_white, 2)
    -- local w2 = simpleText(' 100Р', (eui and eui.Font)('13:Bold'), x1 - w1, y1, color_white, 2)
    -- simpleText('ПОЛУЧИ', (eui and eui.Font)('13:Medium'), x1 - w1 - w2, y1, color_white, 2)

    -- roundedBox(5, x + sh(53), y + h - sh(35), sh(160), sh(25), {(eui and eui.Color)('992E47'), (eui and eui.Color)('FF4C77'), (eui and eui.Color)('FF4C77'), (eui and eui.Color)('992E47')})

    -- local w1, w2 = (eui and eui.GetTextSize)('Осталось:', (eui and eui.Font)('12:Medium')) (eui and eui.GetTextSize)(hours .. ':' .. minutes, (eui and eui.Font)('12:Bold'))

    -- local totalSize = w1 + w2 + 2
    -- local mainX = x + sh(127) - totalSize / 2

    -- simpleText('Осталось:', (eui and eui.Font)('12:Medium'), mainX, y + h - sh(35) + sh(12), color_white, 0, 1)
    -- simpleText(hours .. ':' .. minutes, (eui and eui.Font)('12:Bold'), mainX + w1 + 5, y + h - sh(35) + sh(12), color_white, 0, 1)
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
