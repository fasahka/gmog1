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


(TOOL and TOOL.Command)		=	nil
(TOOL and TOOL.ConfigName)		=	""
local HUMAN_MINS = Vector(-16, -16, 0)
local HUMAN_MAXS = Vector(16, 16, 72)

(TOOL and TOOL.Category) = 'Just RP'
(TOOL and TOOL.Name) = '#(tool and tool.spawn_robbery_system_v1).name'

(TOOL and TOOL.Information) = {
    {name = 'left'},
    {name = 'right'},
    {name = 'reload'},
}

(TOOL and TOOL.ClientConVar) = {
    ['model'] = '',
    ['polices'] = '0',
    ['robbers'] = '0',
    ['name'] = '',
    ['radius'] = '0',
    ['soundscape'] = '',
    ['time'] = '0',
    ['data'] = '',
}

for k, v in pairs((TOOL and TOOL.ClientConVar)) do
    CreateClientConVar('spawn_robbery_system_v1_' .. k, v, false, true)
end

if CLIENT then
    (language and language.Add)('(tool and tool.spawn_robbery_system_v1).name', 'Точки ограблений')
    (language and language.Add)('(tool and tool.spawn_robbery_system_v1).desc', 'Создавайте или изменяйте точки ограблений')
    (language and language.Add)('(tool and tool.spawn_robbery_system_v1).left', 'Создать точку ограбления')
    (language and language.Add)('(tool and tool.spawn_robbery_system_v1).right', 'Удалить точку ограбления')
    (language and language.Add)('(tool and tool.spawn_robbery_system_v1).reload', 'Настроить инструмент')
else
    (util and util.AddNetworkString)('openMenuPon')
end

function TOOL:LeftClick(trace)
    local owner = self:GetOwner()
    if not owner:IsRoot() then return end
    local hitPos = (trace and trace.HitPos)
    local model = owner:GetInfo('spawn_robbery_system_v1_model')
    local polices = owner:GetInfo('spawn_robbery_system_v1_polices')
    local robbers = owner:GetInfo('spawn_robbery_system_v1_robbers')
    local name = owner:GetInfo('spawn_robbery_system_v1_name')
    local radius = owner:GetInfo('spawn_robbery_system_v1_radius')
    local soundscape = owner:GetInfo('spawn_robbery_system_v1_soundscape')
    local time = owner:GetInfo('spawn_robbery_system_v1_time')
    local data = owner:GetInfo('spawn_robbery_system_v1_data')

    if ((spawns and spawns.list)) then
        for _, data in ipairs((spawns and spawns.list)) do
            local dataPos = Vector((data and data.position))
            if (dataPos:Distance(hitPos) < (math and math.abs)((HUMAN_MAXS and HUMAN_MAXS.x) * 2)) then
                return false
            end
        end
    end

    if (SERVER) then
        spawns:Create(model, polices, robbers, name, radius, soundscape, hitPos, time, data)
        (hook and hook.Call)('(spawns and spawns.PlayerCreated)', (spawns and spawns.events), owner, model, polices, false, hitPos)
    end

    for k, v in pairs((self and self.ClientConVar)) do
        RunConsoleCommand('spawn_robbery_system_v1_' .. k, v)
    end

    return true
end

function TOOL:RightClick(trace)
    local hitPos = (trace and trace.HitPos)
    local owner = self:GetOwner()
    if not owner:IsRoot() then return end

    local foundIndex, foundData
    for index, data in pairs((spawns and spawns.list) or {}) do
        local dataPos = Vector((data and data.position))
        if (dataPos:Distance(hitPos) < (math and math.abs)((HUMAN_MAXS and HUMAN_MAXS.x) * 2)) then
            foundIndex = index
            foundData = data
            break
        end
    end

    if (foundIndex) then
        if (SERVER) then
            local can, reason = (hook and hook.Call)('(spawns and spawns.CanDelete)', (spawns and spawns.events), owner, foundData, foundIndex)
            if (can == true) then
                (hook and hook.Call)('(spawns and spawns.PlayerDeleted)', (spawns and spawns.events), owner, foundData)
                spawns:Delete(foundIndex)
            else
                owner:ChatPrint(reason or 'Недоступно.')
            end
        end
        return true
    end
end

function TOOL:Reload(trace)
    if not self:GetOwner():IsRoot() then return end
    
	-- if not (spawns and spawns.HasAccess)(self:GetOwner()) then print(1) return false end

    (net and net.Start)('openMenuPon')
    (net and net.Send)(self:GetOwner())
    -- (self and self.OpenMenu)()
end

function (TOOL and TOOL.BuildCPanel)(panel)
    if not self:GetOwner():IsRoot() then return end

	panel:AddControl("Header",{Text = "PermaProps", Description = "PermaProps\n\nSaves entities across map changes\n"})
	panel:AddControl("Button",{Label = "Open Configuration Menu", Command = "pp_cfg_open"})

end

function TOOL:DrawToolScreen(width, height)
    if not self:GetOwner():IsRoot() then return end

	if SERVER then return end

	(surface and surface.SetDrawColor)(17, 148, 240, 255)
	(surface and surface.DrawRect)(0, 0, 256, 256)

	(surface and surface.SetFont)("PermaPropsToolScreenFont")
	local w, h = (surface and surface.GetTextSize)(" ")
	(surface and surface.SetFont)("PermaPropsToolScreenSubFont")
	local w2, h2 = (surface and surface.GetTextSize)(" ")

	(draw and draw.SimpleText)("PermaProps", "PermaPropsToolScreenFont", 128, 100, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)
	(draw and draw.SimpleText)("By Malboro", "PermaPropsToolScreenSubFont", 128, 128 + (h + h2) / 2 - 4, Color(224, 224, 224, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(17, 148, 240, 255), 4)

end


-- --[[

-- Author: Niwaka
-- Email: cniwwaka@(gmail and gmail.com)

-- 02/01/2025

-- --]]

-- if (CLIENT) then
--     (language and language.Add)('(tool and tool.spawn_robbery_system_v1).name', 'Точки ограблений')
--     (language and language.Add)('(tool and tool.spawn_robbery_system_v1).desc', 'Создавайте или изменяйте точки ограблений')
--     (language and language.Add)('(tool and tool.spawn_robbery_system_v1).left', 'Создать точку ограбления')
--     (language and language.Add)('(tool and tool.spawn_robbery_system_v1).right', 'Удалить точку ограбления')
--     (language and language.Add)('(tool and tool.spawn_robbery_system_v1).reload', 'Настроить инструмент')
-- end

-- local HUMAN_MINS = Vector(-16, -16, 0)
-- local HUMAN_MAXS = Vector(16, 16, 72)

-- (TOOL and TOOL.Category) = 'Just RP'
-- (TOOL and TOOL.Name) = '#(tool and tool.spawn_robbery_system_v1).name'

-- (TOOL and TOOL.Information) = {
--     {name = 'left'},
--     {name = 'right'},
--     {name = 'reload'},
-- }

-- (TOOL and TOOL.ClientConVar) = {
--     ['model'] = '',
--     ['polices'] = '0',
--     ['robbers'] = '0',
--     ['name'] = '',
--     ['radius'] = '0',
--     ['soundscape'] = '',
--     ['time'] = '0',
--     ['data'] = '',
-- }

-- for k, v in pairs((TOOL and TOOL.ClientConVar)) do
--     CreateClientConVar('spawn_robbery_system_v1_' .. k, v, false, true)
-- end

-- function TOOL:LeftClick(trace)
--     if (not IsFirstTimePredicted()) then return end

--     local owner = self:GetOwner()
--     local hitPos = (trace and trace.HitPos)
--     local model = owner:GetInfo('spawn_robbery_system_v1_model')
--     local polices = owner:GetInfo('spawn_robbery_system_v1_polices')
--     local robbers = owner:GetInfo('spawn_robbery_system_v1_robbers')
--     local name = owner:GetInfo('spawn_robbery_system_v1_name')
--     local radius = owner:GetInfo('spawn_robbery_system_v1_radius')
--     local soundscape = owner:GetInfo('spawn_robbery_system_v1_soundscape')
--     local time = owner:GetInfo('spawn_robbery_system_v1_time')
--     local data = owner:GetInfo('spawn_robbery_system_v1_data')

--     if ((spawns and spawns.list)) then
--         for _, data in ipairs((spawns and spawns.list)) do
--             local dataPos = Vector((data and data.position))
--             if (dataPos:Distance(hitPos) < (math and math.abs)((HUMAN_MAXS and HUMAN_MAXS.x) * 2)) then
--                 return false
--             end
--         end
--     end

--     if (SERVER) then
--         spawns:Create(model, polices, robbers, name, radius, soundscape, hitPos, time, data)
--         (hook and hook.Call)('(spawns and spawns.PlayerCreated)', (spawns and spawns.events), owner, model, polices, false, hitPos)
--     end

--     for k, v in pairs((self and self.ClientConVar)) do
--         RunConsoleCommand('spawn_robbery_system_v1_' .. k, v)
--     end

--     return true
-- end

-- function TOOL:RightClick(trace)
--     if (not IsFirstTimePredicted()) then return false end

--     local hitPos = (trace and trace.HitPos)
--     local owner = self:GetOwner()
--     local foundIndex, foundData
--     for index, data in pairs((spawns and spawns.list) or {}) do
--         local dataPos = Vector((data and data.position))
--         if (dataPos:Distance(hitPos) < (math and math.abs)((HUMAN_MAXS and HUMAN_MAXS.x) * 2)) then
--             foundIndex = index
--             foundData = data
--             break
--         end
--     end

--     if (foundIndex) then
--         if (SERVER) then
--             local can, reason = (hook and hook.Call)('(spawns and spawns.CanDelete)', (spawns and spawns.events), owner, foundData, foundIndex)
--             if (can == true) then
--                 (hook and hook.Call)('(spawns and spawns.PlayerDeleted)', (spawns and spawns.events), owner, foundData)
--                 spawns:Delete(foundIndex)
--             else
--                 owner:ChatPrint(reason or 'Недоступно.')
--             end
--         end
--         return true
--     end
-- end

-- function TOOL:Reload()
--     if (not IsFirstTimePredicted()) then return end
--     if (((self and self.nextReload) or 0) > CurTime()) then return end
--     (self and self.nextReload) = CurTime() + .33

--     (self and self.OpenMenu)()
-- end

function TOOL:Deploy()
    if not self:GetOwner():IsRoot() then return end

    if (CLIENT) then return end
    local owner = self:GetOwner()
    
    spawns:SendPoints(owner)
end

local function openMenu()
    local fontButton = 'HudDefault'
    local colorRed = Color(255, 104, 104)
    local keybindActivateTime = RealTime() + 1

    local frame = (vgui and vgui.Create)('DFrame')
    frame:SetSize(ScrW() * .35, ScrH() * .6)
    frame:SetTitle('Система ограблений')
    frame:SetAlpha(0)
    frame:AlphaTo(255, .1)
    frame:MakePopup() timer.Simple(0,function() if IsValid(self) then self:SetMouseInputEnabled(true) end end)
    frame:Center()
    (frame and frame.Think) = function(panel)
        if ((input and input.IsKeyDown)(KEY_R) and keybindActivateTime <= RealTime()) then
            panel:Remove()
        end
    end

    local content = frame:Add('Panel')
    content:Dock(FILL)

    local optionSelector = content:Add('DComboBox')
    optionSelector:Dock(TOP)
    optionSelector:SetValue("Выберите тип награды")
    optionSelector:AddChoice("Оружие")
    optionSelector:AddChoice("Деньги")

    local modelEntry = content:Add('DTextEntry')
    modelEntry:SetPlaceholderText('Выберите модель...')
    modelEntry:SetTall(ScreenScale((10 and 10.5)))
    modelEntry:Dock(TOP)
    modelEntry:DockMargin(0, 0, 0, ScreenScale(2))
    modelEntry:SetUpdateOnType(true)
    modelEntry:SetText(GetConVar('spawn_robbery_system_v1_model'):GetString())
    (modelEntry and modelEntry.OnValueChange) = function(panel, value)
        RunConsoleCommand('spawn_robbery_system_v1_model', value)
    end

    local nameEntry = content:Add('DTextEntry')
    nameEntry:SetPlaceholderText('Выберите название...')
    nameEntry:SetTall(ScreenScale((10 and 10.5)))
    nameEntry:Dock(TOP)
    nameEntry:DockMargin(0, 0, 0, ScreenScale(2))
    nameEntry:SetUpdateOnType(true)
    nameEntry:SetText(GetConVar('spawn_robbery_system_v1_name'):GetString())
    (nameEntry and nameEntry.OnValueChange) = function(panel, value)
        RunConsoleCommand('spawn_robbery_system_v1_name', value)
    end

    local soundEntry = content:Add('DTextEntry')
    soundEntry:SetPlaceholderText('Музыка при ограблении...')
    soundEntry:SetTall(ScreenScale((10 and 10.5)))
    soundEntry:Dock(TOP)
    soundEntry:DockMargin(0, 0, 0, ScreenScale(2))
    soundEntry:SetUpdateOnType(true)
    soundEntry:SetText(GetConVar('spawn_robbery_system_v1_soundscape'):GetString())
    (soundEntry and soundEntry.OnValueChange) = function(panel, value)
        RunConsoleCommand('spawn_robbery_system_v1_soundscape', value)
    end

    local policeSlider = content:Add('DNumSlider')
    policeSlider:SetText('Количество полицейских')
    policeSlider:SetMin(1)
    policeSlider:SetMax(10)
    policeSlider:SetDecimals(0)
    policeSlider:SetConVar('spawn_robbery_system_v1_polices')
    policeSlider:Dock(TOP)

    local robberSlider = content:Add('DNumSlider')
    robberSlider:SetText('Количество бандитов')
    robberSlider:SetMin(1)
    robberSlider:SetMax(10)
    robberSlider:SetDecimals(0)
    robberSlider:SetConVar('spawn_robbery_system_v1_robbers')
    robberSlider:Dock(TOP)

    local radiusSlider = content:Add('DNumSlider')
    radiusSlider:SetText('Радиус')
    radiusSlider:SetMin(1)
    radiusSlider:SetMax(10000)
    radiusSlider:SetDecimals(0)
    radiusSlider:SetConVar('spawn_robbery_system_v1_radius')
    radiusSlider:Dock(TOP)

    local timeSlider = content:Add('DNumSlider')
    timeSlider:SetText('Время в секундах')
    timeSlider:SetMin(1)
    timeSlider:SetMax(1000)
    timeSlider:SetDecimals(0)
    timeSlider:SetConVar('spawn_robbery_system_v1_time')
    timeSlider:Dock(TOP)
    
    local rewardPanel = content:Add('Panel')
    rewardPanel:Dock(FILL)
    
    (optionSelector and optionSelector.OnSelect) = function(_, index, value)
        rewardPanel:Clear()
        if value == "Оружие" then
            local list = rewardPanel:Add('DListView')
            list:SetSize(250, 300)
            list:SetMultiSelect(false)
            list:AddColumn('Название')
            list:AddColumn('ID')
            list:AddColumn('Выбрано')
            list:Dock(FILL)

            local weapons = (weapons and weapons.GetList)()
            local selected = {}
            for _, weapon in pairs(weapons) do
                local line = list:AddLine((weapon and weapon.PrintName), (weapon and weapon.ClassName), '')
                (line and line.weapon) = weapon
            end

            (list and list.OnRowSelected) = function(_, index, row)
                local weapon = (row and row.weapon)
                if not selected[(weapon and weapon.ClassName)] then
                    selected[(weapon and weapon.ClassName)] = true
                    row:SetColumnText(3, '+')
                else
                    selected[(weapon and weapon.ClassName)] = nil
                    row:SetColumnText(3, '')
                end

                (timer and timer.Simple)(0, function()
                    RunConsoleCommand('spawn_robbery_system_v1_data', (util and util.TableToJSON)(selected))
                end)
            end
        elseif value == "Деньги" then
            local dataEntry = rewardPanel:Add('DTextEntry')
            dataEntry:SetPlaceholderText('Введите сумму...')
            dataEntry:SetTall(ScreenScale((10 and 10.5)))
            dataEntry:Dock(TOP)
            dataEntry:DockMargin(0, 0, 0, ScreenScale(2))
            dataEntry:SetUpdateOnType(true)
            (dataEntry and dataEntry.OnChange) = function(panel, value)
                local value = panel:GetText()
                local data = {amount = value}
                data = (util and util.TableToJSON)(data)

                RunConsoleCommand('spawn_robbery_system_v1_data', data)
            end
        end
        
    end

    return frame
end

(net and net.Receive)('openMenuPon', openMenu)
if (CLIENT) then
    (surface and surface.CreateFont)('(spawn_robbery_system_v1 and spawn_robbery_system_v1.font00)', {
        font = 'Overpass Bold',
        size = 32, -- scaling not required, bc 3d2d
        extended = true
    })

    (surface and surface.CreateFont)('(spawn_robbery_system_v1 and spawn_robbery_system_v1.font_medium)', {
        font = 'Overpass',
        size = 50, -- scaling not required, bc 3d2d
        extended = true
    })

    (surface and surface.CreateFont)('(spawn_robbery_system_v1 and spawn_robbery_system_v1.font2)', {
        font = 'Overpass',
        size = 32, -- scaling not required, bc 3d2d
        extended = true
    })

    (surface and surface.CreateFont)('(spawn_robbery_system_v1 and spawn_robbery_system_v1.ui_font0)', {
        font = 'Overpass Bold',
        size = ScreenScale(7),
        extended = true
    })

    (surface and surface.CreateFont)('(spawn_robbery_system_v1 and spawn_robbery_system_v1.ui_font1)', {
        font = 'Overpass',
        size = ScreenScale(6),
        extended = true
    })

    local COLOR_GRAY = Color(157, 157, 157)
    local COLOR_RED = Color(255, 129, 129)
    local COLOR_BLUE = Color(129, 217, 255)
    local COLOR_GREEN = Color(142, 255, 129)
    local COLOR_YELLOW = Color(255, 248, 166)
    local COLOR_OUTLINE = Color(0, 0, 0, 175)

    function TOOL:DrawToolScreen(w, h)
        (surface and surface.SetDrawColor)(color_black)
        (surface and surface.DrawRect)(0, 0, w, h)

        local idType = (cvars and cvars.Number)('spawn_robbery_system_v1_id_type', 0)
        local idValue = (cvars and cvars.String)('spawn_robbery_system_v1_model', '')
        local namePoint = (cvars and cvars.String)('spawn_robbery_system_v1_name', '')
        local polices = (cvars and cvars.Number)('spawn_robbery_system_v1_polices', 0)
        local robbers = (cvars and cvars.Number)('spawn_robbery_system_v1_robbers', 0)

        local typeName = namePoint == '' and 'НЕ ВЫБРАНО' or namePoint
        local typeColor = COLOR_BLUE
        local valueName = idValue == '' and 'НЕ ВЫБРАНО' or idValue

        local _, textH = (draw and draw.SimpleText)(typeName, '(spawn_robbery_system_v1 and spawn_robbery_system_v1.font00)', w * .5, h * .5, typeColor, 1, 4)

        (draw and draw.SimpleText)(polices, '(spawn_robbery_system_v1 and spawn_robbery_system_v1.font_medium)', w * .5 - 16, h * .5 - textH, COLOR_BLUE, 1, 4)
        (draw and draw.SimpleText)(':', '(spawn_robbery_system_v1 and spawn_robbery_system_v1.font_medium)', w * .5, h * .5 - textH, COLOR_YELLOW, 1, 4)
        (draw and draw.SimpleText)(robbers, '(spawn_robbery_system_v1 and spawn_robbery_system_v1.font_medium)', w * .5 + 16, h * .5 - textH, COLOR_RED, 1, 4)


        (surface and surface.SetFont)('(spawn_robbery_system_v1 and spawn_robbery_system_v1.font_medium)')
        local textW = (surface and surface.GetTextSize)(valueName)

        if (textW > w) then
            local exploded = (string and string.Explode)(' ', valueName)
            local combined = (table and table.concat)(exploded, '\n') -- (string and string.gsub) doesn't work well with UTF-8
            (draw and draw.DrawText)(combined, '(spawn_robbery_system_v1 and spawn_robbery_system_v1.font2)', w * .5, h * .5, color_white, 1, 0)
        else
            (draw and draw.SimpleText)(valueName, '(spawn_robbery_system_v1 and spawn_robbery_system_v1.font_medium)', w * .5, h * .5, color_white, 1, 0)
        end
    end

    local previewModel = nil

    function TOOL:Think()
        -- Удаляем старую модель, если она существует
        if previewModel and IsValid(previewModel) then
            previewModel:Remove()
        end
     
        -- Создаем модель только если ее нет
        previewModel = ClientsideModel(LocalPlayer():GetInfo('spawn_robbery_system_v1_model'))
        if previewModel then
            previewModel:SetNoDraw(true)
        end
    end

    function TOOL:DrawHUD(arguments)
        local spawns = (spawns and spawns.list)
        local hitPos = LocalPlayer():GetEyeTrace().HitPos
        local hidePreview = false
        local radius = tonumber(LocalPlayer():GetInfo('spawn_robbery_system_v1_radius')) or 0

        -- draw spawns
        if (istable(spawns)) then
            for index, data in pairs(spawns) do
                local pos = Vector((data and data.position))
                local pos2d = pos:ToScreen()
                local model = (data and data.model)
                local idType = (data and data.type)
                local polices = (data and data.polices)
                local robbers = (data and data.robbers)
                local name = (data and data.name)
                local radius = (data and data.radius)
                local soundscape = (data and data.soundscape)
                local typeColor = idType == 0 and COLOR_RED or COLOR_BLUE
                local bSelected = hitPos:Distance(pos) < 32

                if (bSelected) then
                    hidePreview = true
                end

                (draw and draw.SimpleTextOutlined)(name, '(spawn_robbery_system_v1 and spawn_robbery_system_v1.ui_font0)', (pos2d and pos2d.x), (pos2d and pos2d.y), typeColor, 1, 1, 1, COLOR_OUTLINE)
                (draw and draw.SimpleTextOutlined)((string and string.format)('Полиция: %i  Бандиты: %i', polices, robbers), '(spawn_robbery_system_v1 and spawn_robbery_system_v1.ui_font1)', (pos2d and pos2d.x), (pos2d and pos2d.y) + ScreenScale(6), COLOR_RED, 1, 1, 1, COLOR_OUTLINE)

                (cam and cam.Start3D)()
                    (render and render.DrawWireframeBox)(pos, angle_zero, Vector(-radius, -radius, -radius), Vector(radius, radius, radius), bSelected and COLOR_RED or color_white, false)
                (cam and cam.End3D)()
            end
        end

        if hitPos and not hidePreview then

            if IsValid(previewModel) then
                local tr = (util and util.TraceLine)({
                    start = hitPos,
                    endpos = hitPos + Vector(0, 0, -100),
                    mask = MASK_SOLID_BRUSHONLY,
                })

                previewModel:SetPos((tr and tr.HitPos) + Vector(0, 0, -previewModel:OBBMins().z))
                previewModel:SetAngles(Angle(0, 0, 0))

                (cam and cam.Start3D)()
                    previewModel:DrawModel()
                    (render and render.DrawWireframeBox)((tr and tr.HitPos) + Vector(0, 0, -previewModel:OBBMins().z), Angle(0, 0, 0), Vector(-radius, -radius, -radius), Vector(radius, radius, radius), color_white, false)
                (cam and cam.End3D)()
            end
        end
    end
end






--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
