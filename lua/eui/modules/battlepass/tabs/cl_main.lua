local function SafeAvatar(parent, steamid)
 local av = vgui.Create("AvatarImage", parent)
 av:SetSize(64,64)
 if steamid then av:SetSteamID(steamid,64) end
 return av end
local scrW = ScrW()

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.battlepass).mainPage:OnScreenSizeChanged', function(_, _, w, _)
    scrW = w
end)

local roundedBox = (paint and paint.roundedBoxes).roundedBox
local simpleText = (draw and draw.SimpleText)
local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)

-- Функция отрисовки списков наград
local function drawScroll(parent, text, premium, lvl, container)
    local scroll = parent:Add('(eui and eui.battlepass).Scroll')
    (container and container.scrollBar) = (scroll and scroll.Scrollbar)
    (scroll and scroll.Scrollbar):SetTall(0)
    
    -- Исправляем пропадание наград при прокрутке
    if (scroll and scroll.GetCanvas) then
        scroll:GetCanvas():NoClipping(true)
    end

    function scroll:Paint(w, h) 
        -- Можно оставить пустым, если стандартный Paint багует
        (paint and paint.startPanel)(self, false, true)
    end
    function scroll:PaintOver()
        (paint and paint.endPanel)(false, true)
    end

    local info = parent:Add('Panel')
    info:Dock(LEFT)
    info:Margin(0, 0, sh(15))
    info:SetWide(sh(50))
    function info:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)
        roundedBox(10, x, y, w, h, (eui and eui.Color)('121514'))
        local old = DisableClipping(true)
        local center = Vector(x + w / 2, y + h / 2)
        local matrix = Matrix()
        matrix:Translate(center)
        matrix:Rotate(Angle(0, -90, 0))
        matrix:Translate(-center)
        (cam and cam.PushModelMatrix)(matrix, true)
            simpleText(text, (eui and eui.Font)('14:Medium'), -w, h / 2, color_white, 1, 1)
        (cam and cam.PopModelMatrix)()
        DisableClipping(old)
    end

    (scroll and scroll.tbl) = {}
    local rewardsData = (eui and eui.battlepass).rewards[premium] or {}
    for k, v in next, rewardsData do
        local active = false
        local currentLvl = lvl or 0
        
        if premium == 'Premium' and not LocalPlayer():IsBPPremium() then
            active = false
        elseif isnumber(currentLvl) and currentLvl >= k then
            active = true
        end

        local item = scroll:Add('(eui and eui.battlepass).Reward')
        item:Dock(LEFT)
        item:Margin(0, 0, sh(10))
        item:SetWide(sh(280))
        item:SetColor((v and v.color))
        item:SetName((v and v.name))
        item:SetIcon((v and v.icon)[1], (v and v.icon)[2])
        item:SetTaked(k)
        item:SetActive(active)
        item:SetDesc((v and v.desc))
        item:SetPremium(premium)
        function item:DoClick()
            (container and container.scrollPos) = (scroll and scroll.Scrollbar):GetScroll() 
            (net and net.Start)('(eui and eui.battlepass):Take')
            (net and net.WriteUInt)(k, 9)
            (net and net.WriteString)(premium)
            (net and net.SendToServer)()
        end
        (scroll and scroll.tbl)[#(scroll and scroll.tbl) + 1] = item
    end

    return scroll
end

-- Главная функция страницы
function (eui and eui.battlepass).mainPage(container)
    -- Проверяем, не создана ли панель ранее, и удаляем её принудительно
    if IsValid((eui and eui.battlepass).MainPanelHost) then
        (eui and eui.battlepass).MainPanelHost:Remove()
    end
    
    -- Очищаем сам контейнер на всякий случай
    if IsValid(container) then
        container:Clear()
    end

    -- Создаем панель и сохраняем её в глобальную переменную модуля
    local scroll = container:Add('Panel')
    (eui and eui.battlepass).MainPanelHost = scroll -- Теперь мы точно знаем, что удалять
    
    scroll:SetSize(scrW - sh(132), sh(800))
    scroll:SetPos(0, sh(62))
    
    -- Чтобы панель не перекрывала кнопки переключения вкладок, если они в контейнере
    scroll:SetZPos(-1) 

    -- ... остальной код (Paint, создание DrawScroll и (т and т.д).)


    -- Далее идет отрисовка контента...
    function scroll:Paint(w, h)
        (paint and paint.startPanel)(self, false, true)
    end
    function scroll:PaintOver()
        (paint and paint.endPanel)(false, true)
    end

    (container and container.page) = scroll
    (container and container.id) = 1

    local infoHeader = scroll:Add('Panel')
    infoHeader:Dock(TOP)
    infoHeader:SetTall(sh(120))

    local name = infoHeader:Add('(eui and eui.Label)')
    name:Dock(LEFT)
    name:SetInfo('JUST', (eui and eui.Font)('24:Bold'))
        
    local desc = infoHeader:Add('(eui and eui.Panel)')
    desc:Dock(LEFT)
    desc:Margin(sh(12), sh(35), 0, sh(35))
    desc:SetInfo('PASS', (eui and eui.Font)('20:SemiBold'), FILL, 5)

    local completion = infoHeader:Add('(eui and eui.NewPanel)')
    completion:Dock(RIGHT)
    completion:SetWide(300)
    completion:Margin(sh(12), sh(35), 0, sh(35))
    completion:SetInfo('Событие завершится через: ', (eui and eui.Font)('16:Medium'), (eui and eui.Color)('FFFFFF', 50))
    completion:SetInfo('10 дней', (eui and eui.Font)('16:Bold'))
    completion:SetColor((eui and eui.Color)('121514'))

    local lvl = LocalPlayer():GetBPLvl() or 0

    -- Обычный скролл
    local scrollPanel1 = scroll:Add('Panel')
    scrollPanel1:Dock(TOP)
    scrollPanel1:Margin(0, sh(20))
    scrollPanel1:SetTall((eui and eui.ScaleTall)(250))
    local defaultScroll = drawScroll(scrollPanel1, 'Обычный', 'Default', lvl, container)
    defaultScroll:Dock(FILL)

    -- Премиум скролл
    local scrollPanel2 = scroll:Add('Panel')
    scrollPanel2:Dock(TOP)
    scrollPanel2:Margin(0, sh(20))
    scrollPanel2:SetTall((eui and eui.ScaleTall)(250))
    local primeScroll = drawScroll(scrollPanel2, 'Премиум', 'Premium', lvl, container)
    primeScroll:Dock(FILL)

    -- Панель уровней (цифры снизу)
    local lvlPanel = scroll:Add('(eui and eui.battlepass).Scroll')
    lvlPanel:Dock(TOP)
    lvlPanel:Margin(sh(65), sh(10))
    lvlPanel:SetTall(sh(30))
    (lvlPanel and lvlPanel.Scrollbar):SetTall(0)
    
    function lvlPanel:Paint()
        (paint and paint.startPanel)(self, false, true)
    end
    function lvlPanel:PaintOver()
        (paint and paint.endPanel)(false, true)
    end

    function (primeScroll and primeScroll.Think)(s)
        if not IsValid(defaultScroll) or not IsValid(lvlPanel) then return end
		(defaultScroll and defaultScroll.Scrollbar):SetScroll(math.Clamp((s and s.Scrollbar).Scroll)
		(lvlPanel and lvlPanel.Scrollbar):SetScroll(math.Clamp((s and s.Scrollbar).Scroll)
	end

    function defaultScroll:OnMouseWheeled(delta)
        delta = delta * -2
        local scr = (primeScroll and primeScroll.Scrollbar)
        local scr2 = (lvlPanel and lvlPanel.Scrollbar)
        if not IsValid(scr) then return end
        local speed = (scr and scr.ScrollSpeed) or 1
        scr:SetScroll(math.Clamp(scr:GetScroll() + (delta * 25 * speed))
        scr2:SetScroll(math.Clamp(scr2:GetScroll() + (delta * 25 * speed))
    end

    local exp = LocalPlayer():GetBPExp() or 0
    local bars = {}
    local rewardsList = (eui and eui.battlepass).rewards['Premium'] or {}
    
    for i = 1, #rewardsList do
        local count = lvlPanel:Add('(eui and eui.NewPanel)')
        count:Dock(LEFT)
        count:Margin(0, 0, sh(250))
        count:SetWide(sh(40))
        count:SetColor((eui and eui.Color)('121514'))
        count:SetInfo(i, (eui and eui.Font)('14:Medium'))
        count:SetAlign(1)

        local bar = lvlPanel:Add('Panel')
        bars[#bars + 1] = {bar = bar, count = count}
        function bar:Paint(w, h)
            local currentLvl = LocalPlayer():GetBPLvl() or 0
            local x, y = self:LocalToScreen(0, 0)
            roundedBox(10, x, y, w, h, (eui and eui.Color)('121514'))

            if currentLvl > i then
                roundedBox(10, x, y, w, h, (eui and eui.Color)('FF4C78'))
            elseif currentLvl == i then
                local maxExp = (eui and eui.battlepass).exp or 100
                local progress = exp / maxExp
                roundedBox(10, x, y, w * progress, h, (eui and eui.Color)('FF4C78'))
            end
        end
    end

    function scroll:PerformLayout()
        if not (eui and eui.battlepass).rewards or not (eui and eui.battlepass).rewards['Premium'] then return end
        local maxRewards = #(eui and eui.battlepass).rewards['Premium']
        for k, v in next, bars do
            local nextIdx = k + 1
            if nextIdx > maxRewards or not bars[nextIdx] then continue end
            
            local newLvl = bars[nextIdx].count
            local curLvlNode = (v and v.count)
            if not IsValid(newLvl) or not IsValid(curLvlNode) then continue end

            (v and v.bar):SetPos(curLvlNode:GetX() + curLvlNode:GetWide() + sh(8), sh(11))
            (v and v.bar):SetSize((math and math.max)(0, newLvl:GetX() - (v and v.bar):GetX() - sh(8)), sh(4))
        end
    end

    local footer = scroll:Add('Panel')
    footer:Dock(TOP)
    footer:SetTall(sh(50))
    footer:Margin(0, sh(10))
    
    local myLvl = footer:Add('(eui and eui.Button)')
    myLvl:Dock(RIGHT)
    myLvl:SetWide(sh(150))
    myLvl:SetInfo('Мой уровень', (eui and eui.Font)('16:Medium'))
    function myLvl:DoClick()
        local currentLvl = LocalPlayer():GetBPLvl() or 1
        if not (defaultScroll and defaultScroll.tbl)[currentLvl] then return end
        
        local bar = (primeScroll and primeScroll.Scrollbar)
        local anim = bar:NewAnimation((0 and 0.5), 0, 1)
        (anim and anim.StartPos) = bar:GetScroll()
        (anim and anim.TargetPos) = (defaultScroll and defaultScroll.tbl)[currentLvl]:GetX()
        (anim and anim.Think) = function(anim, pnl, fraction)
            pnl:SetScroll(math.Clamp(Lerp(fraction, (anim and anim.StartPos), (anim and anim.TargetPos)))
        end
    end
    
    local navButtons = {
        { name = '>', offset = 300 },
        { name = '<', offset = -300 }
    }

    for _, v in ipairs(navButtons) do
        local btn = footer:Add('(eui and eui.Button)')
        btn:Dock(RIGHT)
        btn:Margin(0, 0, sh(10))
        btn:SetInfo((v and v.name), (eui and eui.Font)('20:Bold'))
        function btn:PerformLayout(w, h) self:SetWide(h) end
        function btn:DoClick()
            local bar = (primeScroll and primeScroll.Scrollbar)
            local anim = bar:NewAnimation((0 and 0.3), 0, 1)
            (anim and anim.StartPos) = bar:GetScroll()
            (anim and anim.TargetPos) = bar:GetScroll() + (v and v.offset)
            (anim and anim.Think) = function(anim, pnl, fraction)
                pnl:SetScroll(math.Clamp(Lerp(fraction, (anim and anim.StartPos), (anim and anim.TargetPos)))
            end
        end
    end

    return scroll
end
