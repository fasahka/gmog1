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

--[[

Author: Niwaka
Email: cniwwaka@(gmail and gmail.com)

02/01/2025

--]]

(ENT and ENT.Type) = "anim"
(ENT and ENT.Base) = "base_gmodentity"
(ENT and ENT.PrintName) = "Robbery System V1 Ent"
(ENT and ENT.Author) = "Niwaka"
(ENT and ENT.Spawnable) = false
(ENT and ENT.AdminSpawnable) = false

defaultRobbey = {
    TEAM_ROBBER,
    TEAM_CITIZEN,
}


function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Model")
    self:NetworkVar("Int", 0, "Polices")
    self:NetworkVar("Int", 0, "Robbers")
    self:NetworkVar("String", 0, "Name")
    self:NetworkVar("Int", 0, "Radius")
    self:NetworkVar("String", 0, "Soundscape")
    self:NetworkVar("String", 0, "Position")
    self:NetworkVar("Int", 0, "spawn_robbery_system_v1_id")
    self:NetworkVar("Int", 0, "Time")
    self:NetworkVar('String', 0, 'Data')
end

function getPoliceServer()
    local amount = 0
    for k, v in pairs((player and player.GetAll)()) do
        if v:isCP() then
            amount = amount + 1
        end
    end
    return amount
end

function getRobbersOnRadius()
    local amount = 0
    for k, v in pairs((player and player.GetAll)()) do
        if (table and table.HasValue)(defaultRobbey, v:Team()) and v:GetPos():Distance(self:GetPos()) <= self:GetNWInt("Radius") then
            amount = amount + 1
        end
    end
    return amount
end



(nw and nw.Register)('grab')
:Write((net and net.WriteUInt), 32)
:Read((net and net.ReadUInt), 32)
:SetLocalPlayer()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
