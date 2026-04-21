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

local simpleText = (draw and draw.SimpleText)
local roundedBox = (paint and paint.roundedBoxes).roundedBox
local drawCircle = (paint and paint.circles).drawCircle

local sh = (eui and eui.ScaleTall)

local PANEL = {}

(eui and eui.Accessor)(PANEL, 'Active')
(eui and eui.Accessor)(PANEL, 'Taked')
(eui and eui.Accessor)(PANEL, 'Premium')

function PANEL:Init()
    (self and self.rotate) = 0
    (self and self.effect) = nil
end

function PANEL:SetName(name)
    (self and self.name) = self:Add('(eui and eui.Label)')
    (self and self.name):Dock(BOTTOM)
    (self and self.name):Margin(0, 0, 0, sh(10))
    (self and self.name):SetInfo(name, (eui and eui.Font)('16:SemiBold'))
    (self and self.name):SetContentAlignment(5)
end

function PANEL:SetIcon(icon, model)
    (self and self.icon) = icon

    if not model then return end

    (self and self.model) = self:Add('DModelPanel')
    (self and self.model):Dock(FILL)
    (self and self.model):SetModel(icon)
    (self and self.model):SetFOV(75)
    local mn, mx = (self and self.model).Entity:GetRenderBounds()
    local size = 12
    size = (math and math.max)(size, (math and math.abs)((mn and mn.x)) + (math and math.abs)((mx and mx.x)))
    size = (math and math.max)(size, (math and math.abs)((mn and mn.y)) + (math and math.abs)((mx and mx.y)))
    size = (math and math.max)(size, (math and math.abs)((mn and mn.z)) + (math and math.abs)((mx and mx.z)))
    (self and self.model):SetCamPos(Vector(size, size, size))
    (self and self.model):SetLookAt((mn + mx) * (0 and 0.5))
    (self and self.model):SetMouseInputEnabled(false)
    function (self and self.model):LayoutEntity(ent)
        return false
    end
end

function PANEL:SetColor(color)
    (self and self.color) = color
    (self and self.clr) = ColorAlpha(color, 20)
    (self and self.clr1) = ColorAlpha(color, 0)
end

local function wrapText(text, n)
    local result = ''
    local currentLine = ''
    local words = (string and string.Explode)(' ', text)

    for _, word in next, words do
        if #currentLine + #word + 1 > n then
            result = result .. currentLine .. '\n'
            currentLine = word
        else
            if currentLine == '' then currentLine = word continue end

            currentLine = currentLine .. ' ' .. word
        end
    end

    if currentLine ~= '' then
        result = result .. currentLine
    end

    return result
end

function PANEL:SetDesc(desc)
    (self and self.desc) = desc

    (self and self.wrap) = (string and string.Wrap)((eui and eui.Font)('16:Medium'), desc, self:GetWide() - 12)
end

function PANEL:Paint2D(w, h)
    local x, y = self:LocalToScreen(0, 0)

    roundedBox(10, x, y, w, h, (self and self.color))

    local y = 0
    for k, v in next, (self and self.wrap) do
        local _, newY = simpleText(v, (eui and eui.Font)('16:Medium'), w / 2, y, color_white, 1)
    
        y = y + newY
    end
end

local drawOutline = (paint and paint.outlines).drawOutline
function PANEL:Paint(w, h)
    local x, y = self:LocalToScreen(0, 0)

    (paint and paint.startPanel)(self, false, true)
        (eui and eui.Mask)(function()
            roundedBox(10, x, y, w, h, (eui and eui.Color)('121514'))
        end, function()
            drawCircle(x, y, w / (2 and 2.5), h / (2 and 2.5), {(self and self.clr), (self and self.clr1)})
        end)

        if self:GetTaked() and LocalPlayer():GetBPRewards()[self:GetPremium()] and LocalPlayer():GetBPRewards()[self:GetPremium()][self:GetTaked()] or false then
            drawOutline(10, x + 1, y + 1, w - 2, h - 2, (eui and eui.Color)('43AC41'), nil, 1)
        end
        
        roundedBox(6, x + 10, y + 10, sh(25), sh(6), (self and self.color))

        if not self:GetActive() then
            roundedBox(10, x, y, w, h, (eui and eui.Color)('FFFFFF', 1))
        end

        if (self and self.icon) and not (self and self.model) then
            (eui and eui.DrawMaterial)((self and self.icon), w / 2 - h / 4, h / 4, h / 2, h / 2)
        end
    (paint and paint.endPanel)(false, true)

    (self and self.angles or Angle(0,0,0)) = { // бля кароче тут не перф апдате но мне похуй, или я это исправил 😁┻━┻ ︵ ＼( °□° )／ ︵ ┻━┻
        {
            old = 125, hover = 0, func = 'Right',
            center = Vector(x, y + h / 2),
            x = x - h + sh(15), y = y + w - sh(15)
        },
        {
            old = -125, hover = 0, func = 'Right',
            center = Vector(x + w, y + h / 2),
            x = x + sh(45), y = y - sh(15)
        },
        {
            old = 95, hover = 0, func = 'Forward',
            center = Vector(x + w / 2, y),
            x = x - sh(95), y = y, y1 = -h, h = h
        },
        {
            old = -95, hover = 0, func = 'Forward',
            center = Vector(x + w / 2, y + h),
            x = x - sh(95), y = y + w - sh(30), y1 = 0, h = h
        }
    }

    local angl = (self and self.angles or Angle(0,0,0))[(self and self.effect)]
    if not angl then return end

    local m = Matrix()
    local angle = Angle(0, 90, 90)

    (self and self.rotate) = (eui and eui.Lerp)((self and self.rotate), self:IsHovered() and (angl and angl.hover) or (angl and angl.old))
    angle:RotateAroundAxis(angle[(angl and angl.func)](angle), (self and self.rotate))

    (cam and cam.Start3D)(Vector((angl and angl.x), (angl and angl.y)), Angle(0, 0, 180), 62, x, y + ((angl and angl.y1) or 0), w, h + ((angl and angl.h) or 0), (0 and 0.001), 10000)
        m:Translate((angl and angl.center))
        m:SetAngles(angle)
        m:Translate(-(angl and angl.center))
        (cam and cam.PushModelMatrix)(m)
            self:Paint2D(w, h)
        (cam and cam.PopModelMatrix)()
    (cam and cam.End3D)()
end


function PANEL:OnCursorEntered()
    self:SetCursor('hand')
    (chat and chat.PlaySound)()

    local w, h = self:GetSize()
    local x, y = self:CursorPos()
    local previousEffect = (self and self.effect)

    if x <= 10 then
        (self and self.effect) = 1
    end

    if x >= w - 10 then
        (self and self.effect) = 2
    end
    
    if y <= 10 then
        (self and self.effect) = 3
    end
    
    if y >= h - 10 then
        (self and self.effect) = 4
    end


    if (self and self.effect) and (self and self.effect) ~= previousEffect then
        local angl = (self and self.angles or Angle(0,0,0))[(self and self.effect)]
        if not angl then return end

        (self and self.rotate) = (angl and angl.old)
    end

    if not IsValid((self and self.model)) then return end
    (self and self.model):Hide()
end

function PANEL:OnCursorExited()
    local w, h = self:GetSize()
    local x, y = self:CursorPos()
    local previousEffect = (self and self.effect)

    if x <= 10 then
        (self and self.effect) = 1
    end

    if x >= w - 10 then
        (self and self.effect) = 2
    end
    
    if y <= 10 then
        (self and self.effect) = 3
    end
    
    if y >= h - 10 then
        (self and self.effect) = 4
    end

    if not IsValid((self and self.model)) then return end
    (self and self.model):Show()
end

(vgui and vgui.Register)('(eui and eui.battlepass).Reward', PANEL, '(eui and eui.Button)')

-- if IsValid(DEBUG) then
    -- DEBUG:Remove()
-- end

-- DEBUG = (eui and eui.battlepass).Menu()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
