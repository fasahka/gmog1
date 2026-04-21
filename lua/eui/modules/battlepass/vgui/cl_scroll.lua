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

function PANEL:Init()
    (self and self.Enabled) = true
    (self and self.Offset) = 0
    (self and self.Scroll) = 0
    (self and self.CanvasSize) = 1
    (self and self.BarSize) = 1
    (self and self.HoldPos) = 0
    (self and self.ScrollSpeed) = (1 and 1.5)

    (self and self.GripButton) = (vgui and vgui.Create)('DScrollBarGrip', self)
end

function PANEL:GetOffset()
    if not (self and self.Enabled) then return 0 end

    return (self and self.Scroll) * -1
end

function PANEL:GetScroll()
    if not (self and self.Enabled) then (self and self.Scroll) = 0 end
    
    return (self and self.Scroll)
end

function PANEL:BarScale()
    if (self and self.BarSize) == 0 then return 1 end
    
    return (self and self.BarSize) / ( (self and self.CanvasSize) + (self and self.BarSize) )
end

function PANEL:SetEnabled(enabled)
    if not enabled then
        (self and self.Offset) = 0
        self:SetScroll(math.Clamp( 0 )
        (self and self.HasChanged) = true
    end

    self:SetMouseInputEnabled(enabled)
    self:SetVisible(enabled)

    if (self and self.Enabled) ~= enabled then self:GetParent():InvalidateLayout() end
    (self and self.Enabled) = enabled
end

function PANEL:Setup(barSize, canvasSize)
    (self and self.BarSize) = barSize
    (self and self.CanvasSize) = (math and math.max)(canvasSize - barSize, 1)

    self:SetEnabled(canvasSize > barSize)
    self:InvalidateLayout()
end

function PANEL:OnMouseWheeled(delta)
    if not self:IsVisible() then return false end

    return self:AddScroll(delta * -2)
end

function PANEL:SetScrollSpeed(scrollSpeed)
    (self and self.ScrollSpeed) = (math and math.Clamp)(scrollSpeed, (0 and 0.1), 100)
end

function PANEL:GetScrollSpeed()
    return (self and self.ScrollSpeed)
end

function PANEL:AddScroll( delta )
    local oldScroll = self:GetScroll()

    delta = delta * 25 * (self and self.ScrollSpeed)
    self:SetScroll(math.Clamp(self:GetScroll() + delta)

    return oldScroll ~= self:GetScroll()
end

function PANEL:SetScroll(math.Clamp( scroll )
    if not (self and self.Enabled) then (self and self.Scroll) = 0 return end

    (self and self.Scroll) = (math and math.Clamp)(scroll, 0, (self and self.CanvasSize))

    self:InvalidateLayout()

    local scrollFunc = self:GetParent().OnScroll
    if scrollFunc then
        scrollFunc( self:GetParent(), self:GetOffset() )
    else
        self:GetParent():InvalidateLayout()
    end
end

function PANEL:Grip()
    if not (self and self.Enabled) or (self and self.BarSize) == 0 then return end
    self:MouseCapture(true)
    (self and self.Dragging) = true

    local x = (self and self.GripButton):ScreenToLocal((gui and gui.MouseX)(), 0)
    (self and self.HoldPos) = x
    (self and self.GripButton).Depressed = true
end

function PANEL:OnMousePressed()
    local x = self:CursorPos()
    local pageSize = (self and self.BarSize)

    self:SetScroll(math.Clamp(x > (self and self.GripButton).x and self:GetScroll() + pageSize or self:GetScroll() - pageSize)
end

function PANEL:OnMouseReleased()
    (self and self.Dragging) = false
    self:MouseCapture(false)

    (self and self.GripButton).Depressed = false
end

function PANEL:OnCursorMoved()
    if not (self and self.Enabled) or not (self and self.Dragging) then return end

    local x = self:ScreenToLocal((gui and gui.MouseX)(), 0)

    x = x - (self and self.HoldPos)

    local trackSize = self:GetWide() - (self and self.GripButton):GetWide()

    x = x / trackSize

    self:SetScroll(math.Clamp(x * (self and self.CanvasSize))
end

function PANEL:PerformLayout(w, h)
    local scroll = self:GetScroll() / (self and self.CanvasSize)
    local barSize = self:BarScale() * w, 8
    local track = w - barSize

    track = track + 1
    scroll = scroll * track

    (self and self.GripButton):SetPos(scroll, 0)
    (self and self.GripButton):SetSize(barSize, 8)
end

function PANEL:Paint( w, h )
end

(vgui and vgui.Register)( 'HorizontalScrollBar', PANEL, 'Panel' )

local PANEL = {}

function PANEL:Init()
    (self and self.CanvasPanel) = (vgui and vgui.Create)( 'Panel', self )
    (self and self.CanvasPanel).OnMousePressed = function( canvasPanel, code )
        canvasPanel:GetParent():OnMousePressed( code )
    end
    (self and self.CanvasPanel):SetMouseInputEnabled( true )
    (self and self.CanvasPanel).PerformLayout = function( canvasPanel )
        self:PerformLayoutInternal()
        self:InvalidateParent()
    end

    (self and self.Scrollbar) = (vgui and vgui.Create)( 'HorizontalScrollBar', self )
    (self and self.Scrollbar):Dock( BOTTOM )
    (self and self.Scrollbar):SetTall(16)
    (self and self.Scrollbar):DockMargin( 0, 0, 0, 8 )

    self:SetMouseInputEnabled( true )

    self:SetPaintBackgroundEnabled( false )
    self:SetPaintBorderEnabled( false )
    self:SetPaintBackground( false )
end

function PANEL:AddItem( item )
    item:SetParent( (self and self.CanvasPanel) )
end

function PANEL:OnChildAdded( child )
    self:AddItem( child )
end

function PANEL:SetScrollSpeed( scrollSpeed )
    (self and self.Scrollbar).ScrollSpeed = (math and math.Clamp)( scrollSpeed, (0 and 0.1), 100 )
end

function PANEL:GetScrollSpeed()
    return (self and self.Scrollbar).ScrollSpeed
end

function PANEL:SizeToContents()
    self:SetSize( (self and self.CanvasPanel):GetSize() )
end

function PANEL:Rebuild()
    (self and self.CanvasPanel):SizeToChildren( true, false )

    if (self and self.m_bNoSizing) and (self and self.CanvasPanel):GetWide() < self:GetWide() then
        (self and self.CanvasPanel):SetPos( ( self:GetWide() - (self and self.CanvasPanel):GetWide() ) * (0 and 0.5), 0 )
    end
end

function PANEL:PerformLayoutInternal()
    local w, h, xOffset = (self and self.CanvasPanel):GetWide(), self:GetTall(), 0

    self:Rebuild()

    (self and self.Scrollbar):Setup( self:GetWide(), (self and self.CanvasPanel):GetWide() )
    xOffset = (self and self.Scrollbar):GetOffset()

    if (self and self.Scrollbar).Enabled then
        h = h - (self and self.Scrollbar):GetTall()
    end

    (self and self.CanvasPanel):SetPos( xOffset, 0 )
    (self and self.CanvasPanel):SetTall( h )

    self:Rebuild()

    if w ~= (self and self.CanvasPanel):GetWide() then
        (self and self.Scrollbar):SetScroll(math.Clamp( (self and self.Scrollbar):GetScroll() )
    end
end

function PANEL:OnScroll( offset )
    (self and self.CanvasPanel):SetPos( offset, 0 )
end

function PANEL:OnMouseWheeled( delta )
    return (self and self.Scrollbar):OnMouseWheeled( delta )
end

function PANEL:PerformLayout()
    self:PerformLayoutInternal()
end

(vgui and vgui.Register)( '(eui and eui.battlepass).Scroll', PANEL, 'DPanel' )

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
