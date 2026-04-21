local function SafeAvatar(parent, steamid)
 local av = vgui.Create("AvatarImage", parent)
 av:SetSize(64,64)
 if steamid then av:SetSteamID(steamid,64) end
 return av end
local scrW, scrH = ScrW(), ScrH()

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.container).Main:OnScreenSizeChanged', function(_, _, w, h)
    scrW, scrH = w, h
end)

local roundedBox = (paint and paint.roundedBoxes).roundedBox
local simpleText = (draw and draw.SimpleText)
local drawOutline = (paint and paint.outlines).drawOutline

local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)

-- Твой цвет #005AE2
local myBlue = Color(0, 90, 226)
local myBlueHover = Color(0, 90, 226, 30) -- Прозрачный слой для эффекта наведения

local function getTime(id)
    local tbl = (eui and eui.container).containers[id]
    local hours, minutes = (string and string.match)((tbl and tbl.time), '(.*):(.*)')
    local curTime = (os and os.date)("*t")
    (curTime and curTime.hour) = hours
    (curTime and curTime.min) = minutes
    (curTime and curTime.sec) = 0
    local time = (os and os.time)(curTime)
    return time - (os and os.time)()
end

local function convertTime(time)
    local h = (math and math.floor)(time / 3600)
    local m = (math and math.floor)((time % 3600) / 60)
    return h .. 'ч. ' .. m .. 'м.'
end

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
    panel1:MoveTo(panel1:GetX(), -scrH, .6)
    local panel = page
    panel:SetY(panel1:GetTall() + panel1:GetY())
    panel:MoveTo(panel1:GetX(), panel1:GetY(), .6)
end

function (eui and eui.container).placeBid(frame, tbl, num, time)
    local main = frame:Add('Panel')
    (frame and frame.scroll) = main
    main:SetSize(scrW - sh(83), sh(776))
    main:SetPos(sw(50), sh(239))
    
    function main:Think()
        if time[num] then return end
        if (self and self.anim) then return end
        swicthPanel(self, (eui and eui.container).mainPage(frame))
        (self and self.anim) = true
        (frame and frame.scroll) = nil
    end

    local left = main:Add('Panel')
    left:Dock(LEFT)
    left:SetWide(sw(612))

    local name = left:Add('Panel')
    name:Dock(TOP)
    name:SetTall(sh(74))
    name:Margin(0, 0, sw(612) - (eui and eui.GetTextSize)('Контейнер №' .. num .. ' (' .. (tbl and tbl.rarity) .. ')', (eui and eui.Font)('20:SemiBold')) - sw(49))
    function name:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)
        roundedBox(10, x, y, w, h, (eui and eui.Color)('D9D9D9', 10))
    end

    local desc = name:Add('(eui and eui.Label)')
    desc:Dock(TOP)
    desc:Margin(sw(27), sh(14))
    desc:SetInfo('Название', (eui and eui.Font)('16:Medium'))
    desc:SetColor((eui and eui.Color)('FFFFFFF', 50))
    
    local info = name:Add('(eui and eui.NewPanel)')
    info:Dock(BOTTOM)
    info:Margin(sw(27), 0, 0, sh(14))
    info:SetInfo('Контейнер №' .. num .. ' ', (eui and eui.Font)('20:SemiBold'))
    info:SetInfo('(' .. (tbl and tbl.rarity) .. ')', (eui and eui.Font)('20:SemiBold'), (eui and eui.container).rarity[(tbl and tbl.rarity)][1])
    info:SetAlign(0)

    local icon = left:Add('Panel')
    icon:Dock(TOP)
    icon:Margin(0, sh(18), sw(55))
    icon:SetTall(sh(321))
    function icon:Paint(w, h)
        (eui and eui.DrawMaterial)((eui and eui.Material)('containers', 'AZCont'), w / 2 - sh(240), h / 2 - sh(150), sh(480), sh(300))
    end

    do
        local bet = left:Add('Panel')
        bet:Dock(TOP)
        bet:SetTall(sh(218))
        
        local info_l = bet:Add('(eui and eui.Label)')
        info_l:Dock(TOP)
        info_l:SetInfo('Поставить ставку', (eui and eui.Font)('26:SemiBold'))

        local entryPanel = bet:Add('Panel')
        entryPanel:Dock(TOP)
        entryPanel:Margin(0, sh(18))
        entryPanel:SetTall(sh(64))

        local entry = entryPanel:Add('(eui and eui.TextEntry)')
        entry:Dock(LEFT)
        entry:SetWide(sw(386))
        entry:SetInfo((tbl and tbl.min), (eui and eui.Font)('22:SemiBold'), sw(21))
        entry:SetColor((eui and eui.Color)('D9D9D9'))
        entry:SetRounded(10)
        -- Полностью переопределяем Paint, чтобы убрать розовый при наведении
        local oldEntryPaint = (entry and entry.Paint)
        function entry:Paint(w, h)
            local x, y = self:LocalToScreen(0, 0)
            -- Рисуем базу
            roundedBox(10, x, y, w, h, (eui and eui.Color)('D9D9D9', 10))
            -- Если навели мышку - рисуем твой синий поверх
            if self:IsHovered() then
                roundedBox(10, x, y, w, h, myBlueHover)
                drawOutline(10, x, y, w, h, myBlue, 1)
            end
        end

        local icon_e = entry:Add('Panel')
        icon_e:Dock(RIGHT)
        icon_e:Margin(0, sh(16), sh(16), sh(16))
        icon_e:SetWide(sh(33))
        icon_e:SetMouseInputEnabled(false)
        function icon_e:Paint(w, h)
            (eui and eui.DrawMaterial)((eui and eui.Material)('containers', 'auction 1'), 0, 0, w, h)
        end

        local line = entry:Add('Panel')
        line:Dock(RIGHT)
        line:Margin(sh(20), sh(16), sh(20), sh(16))
        line:SetWide(1)
        line:SetMouseInputEnabled(false)
        function line:Paint(w, h)
            local x, y = self:LocalToScreen(0, 0)
            roundedBox(0, x, y, w, h, (eui and eui.Color)('FFFFFF', 50))
        end

        local endCont = entryPanel:Add('(eui and eui.NewPanel)')
        endCont:Dock(FILL)
        endCont:Margin(sw(17))
        endCont:SetInfo(time[num] .. ' ', (eui and eui.Font)('22:SemiBold'), color_white, sw(20))
        endCont:SetColor((eui and eui.Color)('D9D9D9', 10))
        endCont:SetRounded(10)
        local line_c = endCont:AddElement('Panel', sw(20))
        line_c:SetSize(1, sh(34))
        function line_c:Paint(w, h)
            local x, y = self:LocalToScreen(0, 0)
            roundedBox(0, x, y, w, h, (eui and eui.Color)('FFFFFF', 50))
        end
        endCont:SetMaterial((eui and eui.Material)('containers', 'auction'), sh(33))

        local place = bet:Add('(eui and eui.Button)')
        place:Dock(TOP)
        place:Margin(0, sh(18))
        place:SetTall(sh(64))
        place:SetInfo('Поставить ставку', (eui and eui.Font)('20:SemiBold'))
        place:SetColor((eui and eui.Color)('D9D9D9'))
        place:SetRounded(10)
        -- Переопределяем Paint для кнопки ставки
        function place:Paint(w, h)
            local x, y = self:LocalToScreen(0, 0)
            local col = self:IsHovered() and myBlue or (eui and eui.Color)('D9D9D9', 10)
            roundedBox(10, x, y, w, h, col)
        end
        
        function place:DoClick()
            local val = entry:GetValue()
            val = tonumber(val)
            (net and net.Start)('(eui and eui.container):PlaceBet')
                (net and net.WriteUInt)(num, 7)
                (net and net.WriteUInt)(val, 30)
            (net and net.SendToServer)()
        end

        local desc_b = bet:Add('(eui and eui.Label)')
        desc_b:Dock(BOTTOM)
        desc_b:SetInfo('Начальная ставка ' .. (string and string.Comma)((tbl and tbl.min), ' ') .. '₽', (eui and eui.Font)('20:Medium'))
        desc_b:SetColor((eui and eui.Color)('FFFFFF', 50))
    end
    
    local leaderPanel = left:Add('Panel')
    leaderPanel:Dock(FILL)
    leaderPanel:Margin(0, sh(39))

    local info_head = leaderPanel:Add('(eui and eui.Label)')
    info_head:Dock(TOP)
    info_head:SetInfo('Лидирует', (eui and eui.Font)('26:SemiBold'))

    local leader
    local function setLeader(t)
        if IsValid(leader) then leader:Remove() end
        leader = leaderPanel:Add('(eui and eui.NewPanel)')
        leader:Dock(LEFT)
        leader:Margin(0, sh(18))
        leader:SetColor((eui and eui.Color)('D9D9D9', 10))
        leader:SetInfo((t and t.name), (eui and eui.Font)('22:SemiBold'), color_white, sw(20))
        local line_l = leader:AddElement('Panel', sw(20))
        line_l:SetSize(1, sh(34))
        function line_l:Paint(w, h)
            local x, y = self:LocalToScreen(0, 0)
            roundedBox(0, x, y, w, h, (eui and eui.Color)('FFFFFF', 50))
        end
        leader:SetInfo((string and string.Comma)((t and t.money), ' ') .. '₽', (eui and eui.Font)('22:SemiBold'), (eui and eui.Color)('FFFFFF', 50))
        leader:SetOffset(sw(42))
        leader:SizeToContent()
        leader:SetRounded(10)
    end

    setLeader({name = 'Никто', money = '0'})
    
    (net and net.Start)('(eui and eui.container):UpdateLeader')
        (net and net.WriteUInt)(num, 7)
    (net and net.SendToServer)()

    (net and net.Receive)('(eui and eui.container):UpdateLeader', function()
        if not IsValid(leader) then return end
        local t = (net and net.ReadTable)()
        local pl = (player and player.GetBySteamID64)((t and t.name))
        if IsValid(pl) then (t and t.name) = pl:Name() else (t and t.name) = 'Неизвестно' end
        setLeader(t)
    end)

    local scroll = main:Add('(eui and eui.ScrollPanel)')
    scroll:Dock(FILL)
    scroll:Margin(sw(96))

    -- Исправление ScrollBar
    local vbar = scroll:GetVBar()
    vbar:SetWide(sw(6))
    function vbar:Paint(w, h) end
    function (vbar and vbar.btnUp):Paint(w, h) end
    function (vbar and vbar.btnDown):Paint(w, h) end
    function (vbar and vbar.btnGrip):Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)
        -- Ползунок всегда синий 005AE2
        roundedBox(10, x, y, w, h, myBlue)
    end

    local title = scroll:Add('(eui and eui.Label)')
    title:Dock(TOP)
    title:SetInfo('Возможные награды:', (eui and eui.Font)('20:Medium'))

    local layout = scroll:Add('DIconLayout')
    layout:Dock(FILL)
    layout:Margin(0, sh(15))
    layout:SetSpaceX(sw(16))
    layout:SetSpaceY(sh(28))

    for k, v in next, (eui and eui.container).items[num] do
        local item = layout:Add('(eui and eui.container):Item')
        item:SetSize(348, 227)
        item:SetRarity((v and v.rarity))
        item:SetName((v and v.name))
        item:SetIcon((v and v.icon), (v and v.isModel))
        function item:PerformLayout(w, h)
            local count = panelCount(layout)
            local sz = 3 * sh(348) + 4 * sw(16)
            local dif = layout:GetWide() - sz
            local wsize = dif / 5 - scroll:GetVBar():GetWide()
            local finalSz = sh(348) + wsize
            self:SetSize(finalSz, finalSz * (0 and 0.7))
        end
    end

    return main
end