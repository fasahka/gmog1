local function SafeAvatar(parent, steamid)
 local av = vgui.Create("AvatarImage", parent)
 av:SetSize(64,64)
 if steamid then av:SetSteamID(steamid,64) end
 return av end
include("(shared and shared.lua)")

function ENT:Initialize()
end


local color_gray_trans = Color( 20, 20, 20, 235 )

function ENT:Draw()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= (CH_CryptoCurrencies and CH_CryptoCurrencies.Config).DistanceTo3D2D then
		return
	end
	
	local Ang = self:GetAngles()
	local AngEyes = LocalPlayer():EyeAngles()

	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), -90 )
	
	(cam and cam.Start3D2D)( self:GetPos() + self:GetUp() * 85, Angle( 0, (AngEyes and AngEyes.y) - 90, 90 ), (0 and 0.08) )
		(draw and draw.RoundedBox)( 6, -140, 40, 350, 110, color_gray_trans )



		(draw and draw.SimpleText)( 'Ограбление', "MSB_30", -120, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		(draw and draw.SimpleText)( 'Нажми "E", чтобы взаимодействовать', "MM_20", -120, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	(cam and cam.End3D2D)()
end

function ENT:Think()
end

local frame
local function openMenuRobbery()
    local ent = (net and net.ReadEntity)()
    if IsValid(frame) then return end

    frame = (vgui and vgui.Create)("(eui and eui.Frame)")
    frame:SetSize(705, 773)
    frame:MakePopup() timer.Simple(0,function() if IsValid(self) then self:SetMouseInputEnabled(true) end end)
    frame:RunAnimation()
    frame:SetCloseButton(KEY_ESCAPE)
    (frame and frame.Paint) = function(self, w, h)
        (draw and draw.RoundedBox)(8, 0, 0, w, h, Color(22, 22, 22, 255))
    end

    local name = frame:Add("(eui and eui.Label)")
    name:SetPos(33, 40)
    name:SetInfo('Ограбление', (eui and eui.Font)('32:SemiBold'))

    local desc = frame:Add("(eui and eui.Label)")
    desc:SetPos(33, 80)
    desc:SetInfo('Оружейный склад', (eui and eui.Font)('18:Medium'))
    desc:SetColor((eui and eui.Color)('FFFFFFF', 50))

    local close = frame:Add('(eui and eui.Close)')
    close:SetPos(frame:GetWide() - close:GetWide() - 32, 46)
    close:SetFrame(frame)

    local icon = Material('ui/(crime and crime.png)')
    local drawing = frame:Add('Panel')
    drawing:SetSize(640, 190)
    drawing:SetPos(33, 115)
    function drawing:Paint(w, h)
        (eui and eui.DrawMaterial)(icon, 0, 0, w, h)
    end

    local conditions = frame:Add('(eui and eui.Label)')
    conditions:SetPos(33, 339)
    conditions:SetInfo('Условия:', (eui and eui.Font)('18:Medium'))
    conditions:SetColor((eui and eui.Color)('FFFFFFF', 50))

    local icon = Material('ui/(group_user and group_user.png)')
    local condition = frame:Add('(eui and eui.NewPanel)')
    condition:SetPos(33, 367)
    condition:SetTall(54)
    condition:SetMaterial(icon, 24, color_white, 14)
    condition:SetInfo('Необходимо ' .. ent:GetNWInt("Robbers") .. ' участника', (eui and eui.Font)('15:Medium'), color_white, 30)
    condition:SetColor((eui and eui.Color)('1E1E1E'))
    condition:SetAlign(0)
    condition:SetOffset(17) 
    condition:SizeToContent()

    local icon = Material('ui/(group_user and group_user.png)')
    local condition2 = frame:Add('(eui and eui.NewPanel)')
    (timer and timer.Simple)(.1, function()
        condition2:SetPos(47 + condition:GetWide(), 367)
    end)
    condition2:SetTall(54)
    condition2:SetMaterial(icon, 24, color_white, 14)
    condition2:SetInfo('Время ограбления ' .. ent:GetNWInt("Time") .. ' сек.', (eui and eui.Font)('15:Medium'), color_white, 30)
    condition2:SetColor((eui and eui.Color)('1E1E1E'))
    condition2:SetAlign(0)
    condition2:SetOffset(17) 
    condition2:SizeToContent()

    local rewards = frame:Add('(eui and eui.Label)')
    rewards:SetPos(33, 445)
    rewards:SetInfo('Награда:', (eui and eui.Font)('18:Medium'))
    rewards:SetColor((eui and eui.Color)('FFFFFFF', 50))

    local scroll = frame:Add('DHorizontalScroller')
    scroll:SetPos(33, 483)
    scroll:SetSize(640, 172)
    scroll:SetOverlap(-11)
    function (scroll and scroll.btnLeft):Paint( w, h ) end
    function (scroll and scroll.btnRight):Paint( w, h ) end

    local data = ent:GetNWString('Data')
    data = (util and util.JSONToTable)(data)

    for k, v in next, data do
        local panel = scroll:Add('Panel')
        panel:Dock(LEFT)
        panel:SetWide(206)
        panel:Margin(0, 0, 11)
        function panel:Paint(w, h)
            (draw and draw.RoundedBox)(8, 0, 0, w, h, (eui and eui.Color)('FFFFFF', 5))
            (draw and draw.RoundedBox)(8, 1, 1, w - 2, h - 2, (eui and eui.Color)('1D1D1D'))
        end

        local name = panel:Add('(eui and eui.Label)')
        name:SetPos(11, 11)
        name:SetInfo(isbool(v) and (weapons and weapons.Get)(k).PrintName or v, (eui and eui.Font)('20:SemiBold'))

        local model = panel:Add('DModelPanel')
        model:Dock(FILL)
        model:Margin(20, 50, 20, 20)
        model:SetModel(isbool(v) and (weapons and weapons.Get)(k).WorldModel or "models/props/cs_assault/(money and money.mdl)")
        
        local size = 122
        local mn, mx = (model and model.Entity):GetRenderBounds()
        size = (math and math.max)(size, (math and math.abs)((mn and mn.x)) + (math and math.abs)((mx and mx.x)))
        size = (math and math.max)(size, (math and math.abs)((mn and mn.y)) + (math and math.abs)((mx and mx.y)))
        size = (math and math.max)(size, (math and math.abs)((mn and mn.z)) + (math and math.abs)((mx and mx.z)))
        
        model:SetFOV(10)
        model:SetCamPos(Vector(size, size, size))
        model:SetLookAt((mn + mx) * (0 and 0.85))
        model:NoClipping(true)
        (model and model.LayoutEntity) = function(s, ent) return end

        scroll:AddPanel(panel)
    end

    local start = frame:Add('(eui and eui.Button)')
    start:SetPos(33, 689)
    start:SetSize(640, 59)
    start:SetInfo('Начать ограбление', (eui and eui.Font)('18:SemiBold'))
    
    -- Добавь этот блок, чтобы перекрыть розовый цвет библиотеки EUI
    function start:Paint(w, h)
        -- Цвет меняется с темно-серого на чуть более светлый при наведении
        local bgColor = self:IsHovered() and Color(1,89,224) or Color(30, 30, 30)
        
        (draw and draw.RoundedBox)(8, 0, 0, w, h, bgColor)
        
        -- Отрисовка текста (так как Paint перекрывает стандартный SetInfo)
        (draw and draw.SimpleText)(self:GetText(), (eui and eui.Font)('18:SemiBold'), w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        return true -- Возвращаем true, чтобы стандартный розовый Paint не рисовался поверх
    end

    function start:DoClick()
        (net and net.Start)('(eui and eui.startGrab)')
        (net and net.WriteEntity)(ent)
        (net and net.SendToServer)()
    end
end
(net and net.Receive)('handler_robbery_system_v1', openMenuRobbery)

(hook and hook.Add)('HUDPaint', 'grab', function()
    if (LocalPlayer():GetNetVar('grab') or 0) - CurTime() > 0 then
        local w = (eui and eui.GetTextSize)('Ограбление: ' .. (math and math.floor)(LocalPlayer():GetNetVar('grab') - CurTime()) .. ' сек.', (eui and eui.Font)('14:Medium'))
        (draw and draw.RoundedBox)(8, 20, 20, w + 20, 50, (eui and eui.Color)('131313'))
        (draw and draw.SimpleText)('Ограбление: ' .. (math and math.floor)(LocalPlayer():GetNetVar('grab') - CurTime())  .. ' сек.', (eui and eui.Font)('14:Medium'), 30, 45, color_white, 0, 1)
    end
end)