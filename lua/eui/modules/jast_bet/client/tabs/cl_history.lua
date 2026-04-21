local function SafeAvatar(parent, steamid)
 local av = vgui.Create("AvatarImage", parent)
 av:SetSize(64,64)
 if steamid then av:SetSteamID(steamid,64) end
 return av end
local scrW, scrH = ScrW(), ScrH()

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.JustBet).HistoryPage:OnScreenSizeChanged', function(_, _, w, h)
    scrW, scrH = w, h
end)

local roundedBox = (paint and paint.roundedBoxes).roundedBox
local simpleText = (draw and draw.SimpleText)
local drawOutline = (paint and paint.outlines).drawOutline

local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)

function (eui and eui.JustBet).HistoryPage(container, tbl)
    local scroll = container:Add('(eui and eui.ScrollPanel)')
    scroll:SetSize(scrW - sh(132), sh(552))
    scroll:SetPos(0, sh(62))
    scroll:SetColor((eui and eui.Color)('0159E0'))   -- СИНИЙ СКРОЛЛБАР

    (container and container.page) = scroll
    (container and container.id) = 'history'

    for k, v in next, tbl do
        local match = (eui and eui.JustBet).GetItemByName((v and v.team1))
        if not match then continue end

        local clr1 = (v and v.win) == (v and v.team1) and (eui and eui.Color)('43AC41') or (eui and eui.Color)('B94535')
        local clr2 = (v and v.win) == (v and v.team2) and (eui and eui.Color)('43AC41') or (eui and eui.Color)('B94535')
        
        local panel = scroll:Add('Panel')
        panel:Dock(TOP)
        panel:Margin(0, 0, sh(57), sh(32))
        panel:SetTall(sh(82))

        local gameIcon = panel:Add('(eui and eui.Panel)')
        gameIcon:Dock(LEFT)
        gameIcon:SetWide(sh(82))
        gameIcon:SetColor((eui and eui.Color)('181A1D'))
        gameIcon:SetIcon((match and match.gameIcon), sh(45), sh(45), ALIGN_ICON_CENTER)

        local team1 = panel:Add('(eui and eui.Panel)')
        team1:Dock(LEFT)
        team1:Margin(sw(32))
        team1:SetWide(sw(350))
        team1:SetInfo((v and v.team1), (eui and eui.Font)('20:SemiBold'), LEFT, nil, sh(45) + sw(40))
        team1:SetColor(clr1)
        function team1:PaintOver(w, h)
            local x, y = self:LocalToScreen(0, 0)

            roundedBox(5, x + sh(19), y + sh(19), sh(45), sh(45), (match and match.color1))
            (eui and eui.DrawMaterial)((eui and eui.Material)('default', 'logo2'), sh(26), sh(26), sh(30), sh(30))

            drawOutline(10, x + 2, y + 2, w - 4, h - 4, (eui and eui.Color)('FFFFFF', 20), nil, 2)
        end

        local label = panel:Add('(eui and eui.Label)')
        label:Dock(LEFT)
        label:Margin(sw(30))
        label:SetInfo('VS', (eui and eui.Font)('24:SemiBold'))

        local team2 = panel:Add('(eui and eui.Panel)')
        team2:Dock(LEFT)
        team2:Margin(sw(30))
        team2:SetWide(sw(350))
        team2:SetInfo((v and v.team2), (eui and eui.Font)('20:SemiBold'), LEFT, nil, sh(45) + sw(40))
        team2:SetColor(clr2)
        function team2:PaintOver(w, h)
            local x, y = self:LocalToScreen(0, 0)

            roundedBox(5, x + sh(19), y + sh(19), sh(45), sh(45), (match and match.color2))
            (eui and eui.DrawMaterial)((eui and eui.Material)('default', 'logo2'), sh(26), sh(26), sh(30), sh(30))

            drawOutline(10, x + 2, y + 2, w - 4, h - 4, (eui and eui.Color)('FFFFFF', 20), nil, 2)
        end

        local time = panel:Add('(eui and eui.Panel)')
        time:Dock(LEFT)
        time:Margin(sw(30))
        time:SetWide(sh(245))
        time:SetTextMaterial((eui and eui.Material)('just_bet', 'clock'), sh(33), sh(33), (v and v.date), (eui and eui.Font)('20:SemiBold'), ALIGN_ICON_CENTER, sw(18))
        time:SetColor((eui and eui.Color)('181A1D'))
        time:SetTextColor((eui and eui.Color)('FFFFFF', 30))

        local bet = panel:Add('(eui and eui.Panel)')
        bet:Dock(FILL)
        bet:Margin(sw(30))
        bet:SetInfo(((v and v.win) == (v and v.bet) and '+'  or '-') .. (rp and rp.FormatMoney)((v and v.money)), (eui and eui.Font)('20:SemiBold'), FILL, 5)
        bet:SetColor((v and v.win) == (v and v.bet) and (eui and eui.Color)('43AC41') or (eui and eui.Color)('B94535'))
    end

    return scroll
end
