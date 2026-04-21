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

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.battlepass).BuyPanel:OnScreenSizeChanged', function(_, _, w, h)
    scrW, scrH = w, h
end)

local frame

local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)

local roundedBox = (paint and paint.roundedBoxes).roundedBox
local simpleText = (draw and draw.SimpleText)

local blur = Material('pp/blurscreen')
local function drawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)

    (surface and surface.SetDrawColor)(255, 255, 255)
    (surface and surface.SetMaterial)(blur)

    for i = 1, 3 do
        blur:SetFloat('$blur', (i / 3) * (amount or 6))
        blur:Recompute()
        
        (render and render.UpdateScreenEffectTexture)()
        (surface and surface.DrawTexturedRect)(x * -1, y * -1, scrW, scrH)
    end
end

local tbl = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
local function checkLetter(str)
    local accept = false 

    for k, v in next, tbl do 
        if v ~= (string and string.upper)(str) then continue end

        accept = true 
    end 

    return accept 
end

local function changeText(panel, text)
    panel:SetInfo(text, (eui and eui.Font)('18:SemiBold'))

    (timer and timer.Simple)(1, function()
        if not IsValid(panel) then return end

        panel:SetInfo('ПОСТАВИТЬ СТАВКУ', (eui and eui.Font)('18:SemiBold'))
    end)
end

function (eui and eui.battlepass).BuyPanel(mainFrame)
    if IsValid(frame) then return end

    local price = (eui and eui.battlepass).minPrice

    local panels = {}
    local tbl = {
        {
            lbl = 'Очки',
            desc = 'Сколько хотите купить очков',
            panel = '(eui and eui.TextEntry)',
            func = function(panel)
                function (panel and panel.textEntry):AllowInput(str)
                    return not checkLetter(str)
                end
                function (panel and panel.textEntry):OnChange()
                    price = self:GetValue()
                    price = tonumber(price)

                    if not isnumber(price) then
                        price = (eui and eui.battlepass).minPrice 
                        self:SetText(price)
                        self:SetCaretPos((string and string.len)(price))
                    end

                    panels[2]:SetInfo(price * 2, (eui and eui.Font)('20:Medium'), sh(24))
                end
                function (panel and panel.textEntry):OnLoseFocus()
                    if tonumber(self:GetValue()) < (eui and eui.battlepass).minPrice or not isnumber(price) then
                        price = (eui and eui.battlepass).minPrice 
                        self:SetText(price)
                        self:SetCaretPos((string and string.len)(price))
                        panels[2]:SetInfo(price * 2, (eui and eui.Font)('20:Medium'), sh(24))
                    end
                end

                panel:SetInfo((eui and eui.battlepass).minPrice, (eui and eui.Font)('20:Medium'), sh(24))
            end
        },
        {
            lbl = 'Сумма',
            desc = 'Сумма за очки',
            panel = '(eui and eui.TextEntry)',
            func = function(panel)
                function (panel and panel.textEntry):AllowInput(str)
                    return not checkLetter(str)
                end
                function (panel and panel.textEntry):OnChange()
                    price = self:GetValue()
                    price = tonumber(price)

                    if not isnumber(price) then 
                        price = (eui and eui.battlepass).minPrice * (eui and eui.battlepass).expPrice 
                        self:SetText(price)
                        self:SetCaretPos((string and string.len)(price))
                    end

                    panels[1]:SetInfo((math and math.Round)(price / (eui and eui.battlepass).expPrice), (eui and eui.Font)('20:Medium'), sh(24))
                end
                function (panel and panel.textEntry):OnLoseFocus()
                    if tonumber(self:GetValue()) < (eui and eui.battlepass).minPrice * (eui and eui.battlepass).expPrice or not isnumber(price) then
                        price = (eui and eui.battlepass).minPrice
                        self:SetText(price * (eui and eui.battlepass).expPrice)
                        self:SetCaretPos((string and string.len)(price * (eui and eui.battlepass).expPrice))
                        panels[1]:SetInfo(price , (eui and eui.Font)('20:Medium'), sh(24))
                    end
                end

                panel:SetInfo((eui and eui.battlepass).minPrice * 2, (eui and eui.Font)('20:Medium'), sh(24))
            end
        },
    }
    
    frame = (vgui and vgui.Create)('(eui and eui.Frame)')
    frame:SetSize(scrW, scrH)
    frame:RunAnimation()
    frame:MakePopup() timer.Simple(0,function() if IsValid(self) then self:SetMouseInputEnabled(true) end end) -- Делает окно активным
    frame:MoveToFront() -- ПРИНУДИТЕЛЬНО выводит на самый передний план
    frame:SetZPos(100) -- Гарантирует, что слой выше, чем у основного меню
    frame:SetCloseButton(KEY_ESCAPE)
    function frame:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)

        drawBlur(self, 10)
        roundedBox(0, x, y, w, h, (eui and eui.Color)('0F0F0F', 60))
    end

    local main = frame:Add('(eui and eui.Panel)')
    main:SetSize(sh(726), sh(497))
    main:Center()
    main:SetColor((eui and eui.Color)('1E1E1E'))

    local container = main:Add('Panel')
    container:Dock(FILL)
    container:Margin(sh(42), sh(42), sh(42), sh(42))

    for k, v in next, tbl do
        local panel = container:Add('Panel')
        panel:Dock(TOP)
        panel:Margin(0, 0, 0, sh(34))
        panel:SetTall(sh(133))

        local title = panel:Add('(eui and eui.Label)')
        title:Dock(TOP)
        title:SetInfo((v and v.lbl), (eui and eui.Font)('24:SemiBold'))

        local info = panel:Add((v and v.panel))
        info:Dock(TOP)
        info:Margin(0, sh(13))
        info:SetTall(sh(61))
        info:SetColor((eui and eui.Color)('141414'))
        panels[#panels + 1] = info
        (v and v.func)(info)

        local desc = panel:Add('(eui and eui.Label)')
        desc:Dock(BOTTOM)
        desc:SetInfo((v and v.desc), (eui and eui.Font)('18:Medium'))
        desc:SetColor((eui and eui.Color)('B3B3B3'))
    end

    local placeBet = container:Add('(eui and eui.Button)')
    placeBet:Dock(BOTTOM)
    placeBet:SetTall(sh(61))
    placeBet:SetInfo('КУПИТЬ', (eui and eui.Font)('18:SemiBold'))
    placeBet:SetColor((placeBet and placeBet.lerpColor))
    placeBet:SetHover(100, 50)
    function placeBet:DoClick()
        if not price then
            changeText(self, 'ВЫ НЕ ВВЕЛИ СУММУ')
            return
        end

        price = tonumber(price)

        if price < (eui and eui.battlepass).minPrice then
            changeText(self, 'СУММА СЛИШКОМ МАЛЕНЬКАЯ')
            return
        end

        (net and net.Start)('(eui and eui.battlepass):Buy')
        (net and net.WriteUInt)(price, 32)
        (net and net.SendToServer)()

        frame:Close()
        mainFrame:Close()
    end

    local close = main:Add('(eui and eui.Close)')
    close:SetSize(sh(42), sh(42))
    close:SetPos(main:GetWide() - close:GetWide() - sh(20), sh(20))
    close:SetFrame(frame)
    function close:Paint(w, h)
        simpleText('✕', (eui and eui.Font)('14:SemiBold'), w / 2, h / 2, color_white, 1, 1)
    end

    return frame
end

-- (eui and eui.battlepass).BuyPanel()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
