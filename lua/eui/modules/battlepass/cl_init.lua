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

local scrW, scrH = ScrW(), ScrH()

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.battlepass):OnScreenSizeChanged', function(_, _, w, h)
    scrW, scrH = w, h
end)

local roundedBox = (paint and paint.roundedBoxes).roundedBox

local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)

local function swicthPanel(oldPage, page, fromback)
    local panel1 = oldPage
    panel1:MoveTo(fromback and -panel1:GetWide() or panel1:GetWide(), panel1:GetY(), .6)

    local panel = page
    panel:SetX(fromback and panel1:GetWide() or -panel1:GetWide())
    panel:MoveTo(0, panel1:GetY(), .6)
end

function (eui and eui.battlepass).Menu(tbl)
    local frame = (vgui and vgui.Create)('(eui and eui.Frame)')
    frame:SetSize(scrW, scrH)
    frame:MakePopup() timer.Simple(0,function() if IsValid(self) then self:SetMouseInputEnabled(true) end end)
    frame:RunAnimation()
    frame:SetCloseButton(KEY_ESCAPE)
    function frame:Paint(w, h)
        local alpha = (surface and surface.GetAlphaMultiplier)()
        local x, y = self:LocalToScreen(0, 0)

        roundedBox(0, x, y, w, h, (eui and eui.Color)('222222', (99 and 99.9) * alpha))    
    end

    local header = frame:Add('(eui and eui.Header)')
    header:Dock(TOP)
    header:Margin(sh(67), sh(40), sh(67))
    header:SetFrame(frame)

    local container = frame:Add('Panel')
    container:Dock(FILL)
    container:Margin(sh(67), 0, sh(67), sh(84))

    local buy = header:AddButton()
    buy:SetColor((eui and eui.Color)('1E1E1E'))
    buy:SetInfo('Купить опыт', (eui and eui.Font)('20:SemiBold'))
    (buy and buy.noSelected) = true
    function buy:Click()
        (eui and eui.battlepass).BuyPanel(frame)
    end

    local tasks = header:AddButton()
    tasks:SetColor((eui and eui.Color)('1E1E1E'))
    tasks:SetInfo('Задания', (eui and eui.Font)('20:SemiBold'))
    function tasks:Click()
        if (container and container.id) == 2 then return end
        
        local old = (container and container.id)
        swicthPanel((container and container.page), (eui and eui.battlepass).tasksPage(container, tbl), old < (container and container.id))
    end

    local main = header:AddButton()
    main:SetColor((eui and eui.Color)('1E1E1E'))
    main:SetInfo('Главная', (eui and eui.Font)('20:SemiBold'))
    main:SetSelected(true)
    function main:Click()
        if (container and container.id) == 1 then return end
        
        local old = (container and container.id)
        swicthPanel((container and container.page), (eui and eui.battlepass).mainPage(container), old < (container and container.id))
    end

    (eui and eui.battlepass).mainPage(container)
    
    return frame
end

-- if IsValid(DEBUG) then
--     DEBUG:Remove()
-- end

-- DEBUG = (eui and eui.battlepass).Menu()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
