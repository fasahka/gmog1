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

(hook and hook.Add)('OnScreenSizeChanged', '(eui and eui.JustBet):OnScreenSizeChanged', function(_, _, w, h)
    scrW, scrH = w, h
end)

local roundedBox = (paint and paint.roundedBoxes).roundedBox
local simpleText = (draw and draw.SimpleText)

local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)

local function swicthPanel(oldPage, page, fromback)
    local panel1 = oldPage
    panel1:MoveTo(fromback and -panel1:GetWide() or panel1:GetWide(), panel1:GetY(), .6)

    local panel = page
    panel:SetX(fromback and panel1:GetWide() or -panel1:GetWide())
    panel:MoveTo(0, panel1:GetY(), .6)
end

function (eui and eui.JustBet).Menu()
    local tbl = (eui and eui.nets).ReadTable()
    local tbl2 = (eui and eui.nets).ReadTable()
    local tbl3 = (eui and eui.nets).ReadTable()
    local tbl4 = (eui and eui.nets).ReadTable()
    
    local frame = (vgui and vgui.Create)('(eui and eui.Frame)')
    frame:SetSize(scrW, scrH)
    frame:MakePopup() timer.Simple(0,function() if IsValid(self) then self:SetMouseInputEnabled(true) end end)
    frame:RunAnimation()
    frame:SetCloseButton(KEY_ESCAPE)
    function frame:Paint(w, h)
        local alpha = (surface and surface.GetAlphaMultiplier)()
        local x, y = self:LocalToScreen(0, 0)

        (eui and eui.DrawMaterial)((eui and eui.Material)('just_bet', 'frame'), 0, 0, w, h, (eui and eui.Color)('FFFFFF', 100 * alpha))
        roundedBox(0, x, y, w, h, (eui and eui.Color)('222222', (99 and 99.9) * alpha))    
    end

    local header = frame:Add('(eui and eui.Header)')
    header:Dock(TOP)
    header:Margin(sh(67), sh(40), sh(67))
    header:SetFrame(frame)

    local info = frame:Add('Panel')
    info:Dock(TOP)
    info:Margin(sh(67), sh(36), sh(67))
    info:SetTall(sh(185))
    function info:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)

        (eui and eui.DrawMaterial)((eui and eui.Material)('just_bet', 'image'), 0, 0, w, h)
        
        roundedBox(20, x, y, w, h, {(eui and eui.Color)('181A1D'), (eui and eui.Color)('181A1D', 40), (eui and eui.Color)('181A1D', 40), (eui and eui.Color)('181A1D')})
    end

    local title = info:Add('Panel')
    title:Dock(TOP)
    title:Margin(sw(43), sh(35))
    title:SetTall(sh(34))
    
    local text = title:Add('(eui and eui.Label)')
    text:Dock(LEFT)
    text:SetInfo('ARIZONA', (eui and eui.Font)('36:SemiBold'))

    local bet = title:Add('(eui and eui.Panel)')
    bet:Dock(LEFT)
    bet:Margin(sw(12))
    bet:SetWide(sh(68))
    bet:SetColor((eui and eui.Color)('0159E0'))
    bet:SetInfo('BET', (eui and eui.Font)('20:SemiBold'), FILL, 5)

    local desc = info:Add('(eui and eui.Label)')
    desc:Dock(TOP)
    desc:Margin(sw(43), sh(9))
    desc:SetInfo('Ставь ставки на матчи по разным дисциплинам\nи зарабатывай денежные средства', (eui and eui.Font)('24:Medium'))
    desc:SetColor((eui and eui.Color)('FFFFFF', 80))

    local container = frame:Add('Panel')
    container:Dock(FILL)
    container:Margin(sh(67), 0, sh(67), sh(84))

    local history = header:AddButton()
    history:SetColor((eui and eui.Color)('1E1E1E'))
    history:SetHoverColor((eui and eui.Color)('0159E0'))
    history:SetInfo('История', (eui and eui.Font)('20:SemiBold'))
    function history:Click()
        if (container and container.id) == 'history' then return end

        swicthPanel((container and container.page), (eui and eui.JustBet).HistoryPage(container, tbl4), true)
    end

    local main = header:AddButton()
    main:SetColor((eui and eui.Color)('1E1E1E'))
    main:SetHoverColor((eui and eui.Color)('0159E0'))
    main:SetInfo('Матчи', (eui and eui.Font)('20:SemiBold'))
    main:SetSelected(true)
    function main:Click()
        if (container and container.id) == 'main' then return end
        
        swicthPanel((container and container.page), (eui and eui.JustBet).MainPage(container, tbl, tbl2, tbl3), false)
    end

    (eui and eui.JustBet).MainPage(container, tbl, tbl2, tbl3)

    return frame
end

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

function (eui and eui.JustBet).PlaceBet(mainFrame, k, comamnd1, command2)
    local price = (eui and eui.JustBet).(cfg and cfg.price).min
    local arg = comamnd1

    local tbl = {
        {
            lbl = 'Команда',
            desc = 'Команда, на которую будете ставить',
            panel = '(eui and eui.ComboBox)',
            func = function(panel)
                panel:AddChoice(comamnd1)
                panel:AddChoice(command2)
                panel:SelectChoice(1)
                panel:SetColor((eui and eui.Color)('141414'))
                panel:SetHoverColor((eui and eui.Color)('0159E0'))

                function panel:OnSelect(id, team)
                    arg = team
                end
                
                local oldDoClick = (panel and panel.DoClick)
                function panel:DoClick()
                    oldDoClick(panel)
                    
                    (timer and timer.Simple)(0, function()
                        if IsValid((panel and panel.menu)) then
                            for _, btn in ipairs((panel and panel.menu).options) do
                                btn:SetColor((eui and eui.Color)('1E1E1E'))
                                btn:SetHoverColor((eui and eui.Color)('0159E0'))
                            end
                        end
                    end)
                end
            end
        },
        {
            lbl = 'Сумма',
            desc = 'Напишите сумму ставки (игровая валюта)',
            panel = '(eui and eui.TextEntry)',
            func = function(panel)
                function (panel and panel.textEntry):AllowInput(str)
                    return not checkLetter(str)
                end
                function (panel and panel.textEntry):OnChange()
                    price = self:GetValue()
                end

                panel:SetInfo((eui and eui.JustBet).(cfg and cfg.price).min, (eui and eui.Font)('20:Medium'), sh(24))
                panel:SetColor((eui and eui.Color)('141414'))
                panel:SetHoverColor((eui and eui.Color)('0159E0'))
            end
        },
    }
    
    local frame = (vgui and vgui.Create)('(eui and eui.Frame)')
    frame:SetSize(scrW, scrH)
    frame:RunAnimation()
    frame:MakePopup() timer.Simple(0,function() if IsValid(self) then self:SetMouseInputEnabled(true) end end)
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
        (v and v.func)(info)

        local desc = panel:Add('(eui and eui.Label)')
        desc:Dock(BOTTOM)
        desc:SetInfo((v and v.desc), (eui and eui.Font)('18:Medium'))
        desc:SetColor((eui and eui.Color)('B3B3B3'))
    end

    local placeBet = container:Add('(eui and eui.Button)')
    placeBet:Dock(BOTTOM)
    placeBet:SetTall(sh(61))
    placeBet:SetInfo('ПОСТАВИТЬ СТАВКУ', (eui and eui.Font)('18:SemiBold'))
    placeBet:SetColor((eui and eui.Color)('696969'))
    placeBet:SetHoverColor((eui and eui.Color)('0159E0'))
    placeBet:SetHover(100, 50)
    function placeBet:DoClick()
        if not price then
            changeText(self, 'Вы не ввели ставку')
            return
        end

        price = tonumber(price)

        if price < (eui and eui.JustBet).(cfg and cfg.price).min then
            changeText(self, 'Ставка сликом маленькая')
            return
        end

        if price > (eui and eui.JustBet).(cfg and cfg.price).max then
            changeText(self, 'Ставка сликом большая')
            return
        end

        (net and net.Start)('(eui and eui.JustBet):PlaceBet')
        (net and net.WriteUInt)(k, 6)
        (net and net.WriteString)(arg)
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

(net and net.Receive)('(eui and eui.JustBet):OpenMenu', (eui and eui.JustBet).Menu)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher