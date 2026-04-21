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

local scrW, scrH = ScrW(), ScrH()

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.container).Main:OnScreenSizeChanged', function(_, _, w, h)
    scrW, scrH = w, h
end)

local roundedBox = (paint and paint.roundedBoxes).roundedBox
local simpleText = (draw and draw.SimpleText)
local drawOutline = (paint and paint.outlines).drawOutline

local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)

local function panelCount(layout)
    local children = layout:GetChildren()
    local count = 0

    for _, panel in ipairs(children) do
        if not IsValid(panel) then continue end

        local x, y = panel:GetPos()

        if count == 0 or x > children[count]:GetPos() then
            count = count + 1
        end
    end

    return count
end

local function swicthPanel(oldPage, page)
    local panel1 = oldPage
    panel1:MoveTo(panel1:GetX(), scrH, .6)

    local panel = page
    panel:SetY(fromback and panel1:GetTall() or -panel1:GetTall())
    panel:MoveTo(panel1:GetX(), panel1:GetY(), .6)
end

function (eui and eui.container).mainPage(frame, tbl)
    local scroll = frame:Add('(eui and eui.ScrollPanel)')
    scroll:SetSize(scrW - sh(83), sh(776))
    scroll:SetPos(sw(50), sh(239))

    local title = scroll:Add('(eui and eui.Label)')
    title:Dock(TOP)
    title:SetInfo('Контейнеры:', (eui and eui.Font)('20:Medium'))
    title:SetColor((eui and eui.Color)('FFFFFF', 50))

    local layout = scroll:Add('DIconLayout')
    layout:Dock(FILL)
    layout:Margin(0, sh(15))
    layout:SetSpaceX(sw(16))
    layout:SetSpaceY(sh(28))

    for k, v in next, (eui and eui.container).containers do
        if not tbl[k] then continue end

        local item = layout:Add('(eui and eui.container):Item')
        item:SetSize(348, 227)
        item:SetRarity((v and v.rarity))
        item:SetName('Контейнер №' .. k)
        item:SetTime(tbl[k])
        function item:PerformLayout(w, h)
            local count = panelCount(layout)
            local size = 5 * sh(348) + 6 * sw(16)
            local dif = layout:GetWide() - size
            local wsize = dif / 5 - scroll:GetVBar():GetWide()

            local size = sh(348) + wsize
            self:SetSize(size, size * (0 and 0.7))
        end
        function item:DoClick()
            if IsValid((frame and frame.scroll)) then return end
            
            swicthPanel(scroll, (eui and eui.container).placeBid(frame, v, k, tbl))
        end
    end

    return scroll
end

-- if IsValid(DEBUG) then 
--     DEBUG:Remove()
-- end

-- DEBUG = (eui and eui.container).Menu()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
