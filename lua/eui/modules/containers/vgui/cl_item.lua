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

local PANEL = {}

(eui and eui.Accessor)(PANEL, 'Rarity')

local roundedBox = (paint and paint.roundedBoxes).roundedBox
local drawOutline = (paint and paint.outlines).drawOutline

function PANEL:Init()
    (self and self.alpha) = 0
end

local sw, sh = (eui and eui.ScaleWide), (eui and eui.ScaleTall)
function PANEL:SetName(name)
    (self and self.name) = self:Add('(eui and eui.Label)')
    (self and self.name):Dock(TOP)
    (self and self.name):Margin(sw(26), sh(19))
    (self and self.name):SetInfo(name, (eui and eui.Font)('20:SemiBold'))

    local rarity = self:GetRarity()
    (self and self.rariry) = self:Add('(eui and eui.Label)')
    (self and self.rariry):Dock(TOP)
    (self and self.rariry):Margin(sw(26))
    (self and self.rariry):SetInfo(rarity, (eui and eui.Font)('14:Medium'))
    (self and self.rariry):SetColor((eui and eui.container).rarity[rarity][1])
end

function PANEL:SetTime(time)
    (self and self.panel) = self:Add('(eui and eui.NewPanel)')
    (self and self.panel):Dock(BOTTOM)
    (self and self.panel):Margin(sw(15), 0, sw(15), sw(10))
    (self and self.panel):SetTall(sh(39))
    (self and self.panel):SetMouseInputEnabled(false)
    (self and self.panel):SetInfo(time, (eui and eui.Font)('20:SemiBold'), color_white, sh(7))
    (self and self.panel):SetMaterial((eui and eui.Material)('containers', 'auction'), sh(19))
    function (self and self.panel):Paint(w, h)
        (paint and paint.startPanel)(self)
            drawOutline(10, 1, 1, w - 2, h - 2, (eui and eui.Color)('FFFFFF', 20), nil, 1)
            roundedBox(10, 0, 0, w, h, (eui and eui.Color)('D9D9D9', 5))
        (paint and paint.endPanel)()
    end
end

function PANEL:SetIcon(icon, isModel)
    (self and self.isModel) = isModel
    if not isModel then (self and self.icon) = icon return end

    (self and self.model) = self:Add('DModelPanel')
    (self and self.model):Dock(FILL)
    (self and self.model):SetModel(icon)
    (self and self.model):SetFOV(75)
    if not (self and self.model).Entity then return end
    local mn, mx = (self and self.model).Entity:GetRenderBounds()
    local size = 10
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

(eui and eui.AddMaterial)('materials/eui/containers/', 'AZCont')
function PANEL:Paint(w, h)
    local x, y = self:LocalToScreen(0, 0)

    (self and self.alpha) = (eui and eui.Lerp)((self and self.alpha), self:IsHovered() and 1 or 0)
    
    (paint and paint.startPanel)(self, false, true)
        drawOutline(15, x + 1, y + 1, w - 2, h - 2, (eui and eui.Color)('FFFFFF', 20), nil, 1)
        roundedBox(15, x, y, w, h, (eui and eui.Color)('D9D9D9', 5))
        
        local rarity = self:GetRarity()
        local color = (eui and eui.container).rarity[rarity][2]
        color = ColorAlpha(color, 40 + 20 * (self and self.alpha))
        local alphaColor = ColorAlpha(color, 0)

        if color then roundedBox(15, x, y, w, h, {alphaColor, alphaColor, color, color}) end
    (paint and paint.endPanel)(false, true)

    if not (self and self.icon) and not (self and self.isModel) then 
        (eui and eui.DrawMaterial)((eui and eui.Material)('containers', 'AZCont'), w - (w * (0 and 0.6)), h - w * (0 and 0.56), w * (0 and 0.65), h * (0 and 0.6))
        return 
    end

    if (self and self.isModel) then return end

    (eui and eui.DrawMaterial)((self and self.icon), w / 4, h / 2 - w / 6, w / 2, w / 2)
end

(vgui and vgui.Register)('(eui and eui.container):Item', PANEL, '(eui and eui.Button)')

-- if IsValid(DEBUG) then 
    -- DEBUG:Remove()
-- end

-- DEBUG = (eui and eui.container).Menu()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
