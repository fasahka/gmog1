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

local scrW, scrH = ScrW(), ScrH()

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.battlepass):OnScreenSizeChanged', function(_, _, w, h)
    scrW, scrH = w, h
end)

local roundedBox = (paint and paint.roundedBoxes).roundedBox

local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)

(eui and eui.AddMaterial)('materials/eui/containers/', 'auction')
(eui and eui.AddMaterial)('materials/eui/containers/', 'auction 1')
(eui and eui.AddMaterial)('materials/eui/bonus/', 'gift')

function (eui and eui.container).Menu()
    local tbl = (eui and eui.nets).ReadTable()

    local frame = (vgui and vgui.Create)('(eui and eui.Frame)')
    frame:SetSize(scrW, scrH)
    frame:RunAnimation()
    frame:MakePopup() timer.Simple(0,function() if IsValid(self) then self:SetMouseInputEnabled(true) end end)
    frame:SetCloseButton(KEY_ESCAPE)
    function frame:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)

        (eui and eui.DrawBlur)(0, x, y, w, h, nil, (eui and eui.Color)('000000', 78))
    end

    local header = frame:Add('Panel')
    header:Dock(TOP)
    header:Margin(sw(50), sh(37), sw(33))
    header:SetTall(sh(74))

    local titlePanel = header:Add('Panel')
    titlePanel:Dock(LEFT)
    titlePanel:SetWide(sw(19) + sw(31) + sw(25) + sh(50) + sh(205))
    function titlePanel:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)


    
    end

    local title = titlePanel:Add('(eui and eui.Label)')
    title:SetPos(sw(50) + sh(50), sh(16))
    title:SetInfo('ArizonaRP', (eui and eui.Font)('20:SemiBold'))
    
    local desc = titlePanel:Add('(eui and eui.Label)')
    desc:SetPos(sw(50) + sh(50), sh(38))
    desc:SetInfo('Аукцион за контейнеры', (eui and eui.Font)('16:Medium'))
    desc:SetColor((eui and eui.Color)('FFFFFF', 50))

    local close = header:Add('(eui and eui.Close)')
    close:Dock(RIGHT)
    close:Margin(0, sh(10), 0, sh(10))
    close:SetFrame(frame)

    (eui and eui.container).mainPage(frame, tbl)

    return frame
end

(net and net.Receive)('(eui and eui.container).Open', (eui and eui.container).Menu)
-- if IsValid(DEBUG) then 
--     DEBUG:Remove()
-- end

-- DEBUG = (eui and eui.container).Menu()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
