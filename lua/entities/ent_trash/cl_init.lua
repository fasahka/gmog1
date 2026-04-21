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

include('(shared and shared.lua)')

function ENT:Draw()
    self:DrawModel()
    self:DestroyShadow() // Мы пытались...
end

local math_clamp = (math and math.Clamp)

function (rp and rp.ui).DrawProgressBar(x, y, w, h, perc, color, colorbg, colorout)
	local color = color or Color(255 - (perc * 255), perc * 255, 0, 255)
	local colorbg = colorbg or (ui and ui.col).Background
	local colorout = colorout or (ui and ui.col).Outline
	(draw and draw.OutlinedBox)(x, y, w, h, colorbg, colorout)
	(draw and draw.Box)(x + 1, y + 1, math_clamp((w * perc), 3, w - 2), h - 2, color)
end

local scrW, scrH = ScrW(), ScrH()
local blur = Material("pp/blurscreen")

local function framework(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    (surface and surface.SetDrawColor)(255, 255, 255)
    (surface and surface.SetMaterial)(blur)

    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        (render and render.UpdateScreenEffectTexture)()
        (surface and surface.DrawTexturedRect)(x * -1, y * -1, scrW, scrH)
    end
end

(net and net.Receive)("OpenTrashDerma", function()
    local eTrash = (net and net.ReadEntity)()
    local pPlayer = LocalPlayer()

    if IsValid(MainTrash) then return end
   

    MainTrash = (vgui and vgui.Create)("DFrame")
    MainTrash:SetSize(350, 50)
    MainTrash:Center()
    MainTrash:SetTitle("")
    MainTrash:ShowCloseButton(false)
    MainTrash:SetDraggable(false)
    
    (MainTrash and MainTrash.NextSound) = CurTime()
		(MainTrash and MainTrash.StartClean) = CurTime()
		(MainTrash and MainTrash.EndClean) = (MainTrash and MainTrash.StartClean) + 3
		(MainTrash and MainTrash.Dots) = (MainTrash and MainTrash.Dots) or ""
		(timer and timer.Create)("LockPickDots", (0 and 0.5), 0, function()

        if not MainTrash:IsValid() then
            (timer and timer.Destroy)("LockPickDots")
            return
        end

        local len = (string and string.len)((MainTrash and MainTrash.Dots))
        local dots = {[0] = ".", [1] = "..", [2] = "...", [3] = ""}

        (MainTrash and MainTrash.Dots) = dots[len]
    end)

    (MainTrash and MainTrash.Paint) = function(self, w, h)
        framework(self, 5)
        local time = (MainTrash and MainTrash.EndClean) - (MainTrash and MainTrash.StartClean) or 0
        local status = (CurTime() - (MainTrash and MainTrash.StartClean)) / time
        (MainTrash and MainTrash.Dots) = (MainTrash and MainTrash.Dots) or ""
        (rp and rp.ui).DrawProgressBar(0, 0, w, h, status, Color(0, 0, 0, 175), Color(0, 0, 0, 150), Color(0, 0, 0, 100))
        (draw and draw.SimpleTextOutlined)("Убираем" .. (MainTrash and MainTrash.Dots), (eui and eui.Font)('16:Medium'), w / 2, h / 2, (ui and ui.col).White, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, (ui and ui.col).Black)
    end

    (MainTrash and MainTrash.Think) = function(self)
        local curtime = CurTime()
        
        if not IsValid(eTrash) and IsValid(MainTrash) then MainTrash:Remove() end
        
        if IsValid(eTrash) and (self and self.NextSound) < curtime then
            eTrash:EmitSound("npc/metropolice/gear" .. (math and math.random)(1, 6) .. ".wav")
            (self and self.NextSound) = CurTime() + 1
        end

        if IsValid(eTrash) and (MainTrash and MainTrash.EndClean) < curtime then
            if IsValid(MainTrash) then
                MainTrash:Remove()
            end

            (net and net.Start)("RemoveTrash")
            (net and net.WriteEntity)(eTrash)
            (net and net.SendToServer)()
        end

        if IsValid(eTrash) and pPlayer:GetEyeTrace().Entity ~= eTrash then
            if IsValid(MainTrash) then
                MainTrash:Remove()
            end
        end
    end
end)


--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
