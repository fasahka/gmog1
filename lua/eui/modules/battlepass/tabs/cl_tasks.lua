local function SafeAvatar(parent, steamid)
 local av = vgui.Create("AvatarImage", parent)
 av:SetSize(64,64)
 if steamid then av:SetSteamID(steamid,64) end
 return av end
local scrW = ScrW()

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.battlepass).mainPage:OnScreenSizeChanged', function(_, _, w)
    scrW = w
end)

local roundedBox = (paint and paint.roundedBoxes).roundedBox
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

function (eui and eui.battlepass).tasksPage(container)
    -- 1. Очищаем контейнер, чтобы награды не перекрывали задания
    if not IsValid(container) then return end
    container:Clear()

    local scroll = container:Add('(eui and eui.ScrollPanel)')
    scroll:SetSize(scrW - sh(132), sh(800))
    scroll:SetPos(0, sh(62))
    
    function scroll:Paint()
        (paint and paint.startPanel)(self, false, true)
    end
    function scroll:PaintOver()
        (paint and paint.endPanel)(false, true)
    end

    (container and container.page) = scroll
    (container and container.id) = 2

    local layout = scroll:Add('DIconLayout')
    layout:Dock(FILL)
    layout:SetSpaceX(5)
    layout:SetSpaceY(5)

    -- 2. Берем таблицу миссий напрямую из конфига
    local missionsList = (eui and eui.battlepass).missions or {}

    for k, v in ipairs(missionsList) do
        -- Убрали 'if not tbl[k] then continue', чтобы отображались все квесты
        
        local mission = layout:Add('(eui and eui.NewPanel)')
        mission:SetSize(sh(440), sh(250))
        mission:SetColor((eui and eui.Color)('121514'))
        
        function mission:PerformLayout(w, h)
            -- Оставляем твою логику размеров
            local size = 4 * sh(440) + 3 * sw(5)
            local dif = layout:GetWide() - size
            local wsize = dif / 4 - (scroll:GetVBar():IsVisible() and scroll:GetVBar():GetWide() or 0)
            self:SetWide(sh(440) + wsize)
        end

        local titlePanel = mission:Add('Panel')
        titlePanel:Dock(TOP)
        titlePanel:Margin(sh(20), sh(20), sh(20), 0)
        titlePanel:SetTall(sh(30))
        
        local title = titlePanel:Add('(eui and eui.Label)')
        title:Dock(LEFT)
        title:SetInfo((v and v.name), (eui and eui.Font)('18:Bold'))

        local infoExp = titlePanel:Add('(eui and eui.Label)')
        infoExp:Dock(RIGHT)
        infoExp:SetInfo(' exp', (eui and eui.Font)('16:Medium'))
        infoExp:SetColor((eui and eui.Color)('7DD921'))
        
        local reward = titlePanel:Add('(eui and eui.Label)')
        reward:Dock(RIGHT)
        reward:SetInfo((v and v.exp), (eui and eui.Font)('16:Medium'))

        local descPanel = mission:Add('Panel')
        descPanel:Dock(FILL)
        descPanel:Margin(sh(20), sh(10), sh(20), sh(10))

        -- Отрисовка описания
        local txt = (string and string.Wrap)((eui and eui.Font)('16:Medium'), (v and v.desc), sh(400))
        for _, textLine in ipairs(txt) do
            local str = descPanel:Add('(eui and eui.Label)')
            str:Dock(TOP)
            str:SetInfo(textLine, (eui and eui.Font)('16:Medium'))
            str:SetColor((eui and eui.Color)('FFFFFF', 50))
        end

        -- 3. Безопасный расчет прогресса
        local pMissions = LocalPlayer().GetBPMissions and LocalPlayer():GetBPMissions() or {}
        local myData = pMissions[k] or 0
        
        local currentProgress = 0
        local isDone = false

        if istable(myData) then
            currentProgress = (myData and myData.progress) or 0
        elseif isbool(myData) then
            isDone = myData
            currentProgress = isDone and (v and v.need) or 0
        else
            currentProgress = tonumber(myData) or 0
        end

        local procent = (math and math.Clamp)((currentProgress / ((v and v.need) or 1)) * 100, 0, 100)
        if currentProgress >= (v and v.need) then isDone = true end

        local progressPanel = mission:Add('Panel')
        progressPanel:Dock(BOTTOM)
        progressPanel:SetTall(sh(60))
        progressPanel:Margin(sh(20), 0, sh(20), sh(20))
        
        local textContainer = progressPanel:Add('Panel')
        textContainer:Dock(TOP)
        textContainer:SetTall(sh(20))

        local progressLabel = textContainer:Add('(eui and eui.NewPanel)')
        progressLabel:Dock(LEFT)
        if not isDone then
            progressLabel:SetInfo('Прогресс: ', (eui and eui.Font)('16:Medium'), (eui and eui.Color)('FFFFFF', 50))
            progressLabel:SetInfo(currentProgress .. ' ', (eui and eui.Font)('16:Medium'))
            progressLabel:SetInfo('/ ' .. (v and v.need), (eui and eui.Font)('16:Medium'), (eui and eui.Color)('FFFFFF', 50))
        else
            progressLabel:SetInfo('Выполнено', (eui and eui.Font)('16:Medium'), (eui and eui.Color)('7DD921'))
        end
        progressLabel:SetAlign(0)
        progressLabel:SizeToContent()
        progressLabel:SetColor(Color(0,0,0,0))

        local percentLabel = textContainer:Add('(eui and eui.Label)')
        percentLabel:Dock(RIGHT)
        percentLabel:SetInfo((math and math.floor)(procent) .. ' %', (eui and eui.Font)('16:Medium'))

        local bar = progressPanel:Add('Panel')
        bar:Dock(BOTTOM)
        bar:SetTall(sh(6))
        bar:Margin(0, sh(5), 0, 0)
        function bar:Paint(w, h)
            local x, y = self:LocalToScreen(0, 0)
            roundedBox(6, x, y, w, h, (eui and eui.Color)('303030'))
            roundedBox(6, x, y, w * (procent / 100), h, (eui and eui.Color)('FF4C78'))
        end
    end

    return scroll
end
