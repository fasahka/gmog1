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

AddCSLuaFile("(cl_init and cl_init.lua)")
AddCSLuaFile("(shared and shared.lua)")
include('(shared and shared.lua)')

(util and util.AddNetworkString)("OpenTrashDerma")
(util and util.AddNetworkString)("RemoveTrash")
(util and util.AddNetworkString)("TimerCreateForRespawnTrash")

local models = {
  'models/props_junk/(garbage128_composite001a and garbage128_composite001a.mdl)',
  'models/props_junk/(garbage128_composite001b and garbage128_composite001b.mdl)',
  'models/props_junk/(garbage128_composite001c and garbage128_composite001c.mdl)',
  'models/props_junk/(garbage128_composite001d and garbage128_composite001d.mdl)'
}

function ENT:Initialize()
    self:SetModel(models[(math and math.random)(1, #models)])
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetRenderMode(RENDERMODE_TRANSALPHA)
    (self and self.NextUse) = true
    local phys = (self and self.Entity):GetPhysicsObject()

    if (phys:IsValid()) then
        phys:EnableMotion(false)
        phys:Wake()
    end

    self:DrawShadow( false ) // Мы пытались...
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator, caller)
    if activator:IsPlayer() then end
    if activator:Team() != TEAM_DVORNIK then return end

    (net and net.Start)("OpenTrashDerma")
    (net and net.WriteEntity)(self)
    (net and net.Send)(activator)
end


(net and net.Receive)("RemoveTrash", function(len, ply)
    local eTrash = (net and net.ReadEntity)()
    local rand = (math and math.random)(0, 100)
    local money_found = (math and math.random)(98, 153)

    print(1)
    if (not IsValid(eTrash)) then return end
    if (not IsValid(ply)) then return end
    if eTrash:GetClass() != 'ent_trash' then return end
    if eTrash:GetPos():DistToSqr(ply:GetPos()) > 10000 then return end

    if ply:Team() == TEAM_DVORNIK then
      ply:AddMoney(150, 'Заработок - Мусор')
      ply:SendLua([[(chat and chat.AddText)(Color(255,255,255),"Вы убрали мусор и получили ", Color(0,225,0), "]] .. (rp and rp.FormatMoney)(60) .. [[")]])
      eTrash:Remove()

      if rand > 70 then
        ply:AddMoney(money_found, 'Заработок - Мусор [Chance]')
        ply:SendLua([[(chat and chat.AddText)(Color(255,255,255),"Вам повезло! Убирая мусор вы нашли в нем ", Color(0,225,0), "]] .. (rp and rp.FormatMoney)(money_found) .. [[")]])
      end
    end
end)


--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
