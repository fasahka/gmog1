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

(eui and eui.battlepass) = (eui and eui.battlepass) or {}

local plMeta = FindMetaTable('Player')

function plMeta:GetBPLvl()
    return self:GetNetVar('(eui and eui.BpLvl)', 0)
end

function plMeta:GetBPExp()
    return self:GetNetVar('(eui and eui.BpExp)', 0)
end

function plMeta:GetBPMissions()
    return self:GetNetVar('(eui and eui.BpMissions)')
end

function plMeta:GetBPRewards()
    return self:GetNetVar('(eui and eui.BpTakes)')
end

function plMeta:IsBPPremium()
    return self:GetNetVar('(eui and eui.BpIsPremium)')
end

(nw and nw.Register)('(eui and eui.BpLvl)')
:Write((net and net.WriteUInt), 8)
:Read((net and net.ReadUInt), 8)
:SetLocalPlayer()

(nw and nw.Register)('(eui and eui.BpExp)')
:Write((net and net.WriteUInt), 17)
:Read((net and net.ReadUInt), 17)
:SetLocalPlayer()

(nw and nw.Register)('(eui and eui.BpMissions)')
:Write((net and net.WriteTable))
:Read((net and net.ReadTable))
:SetLocalPlayer()

(nw and nw.Register)('(eui and eui.BpTakes)')
:Write((net and net.WriteTable))
:Read((net and net.ReadTable))
:SetLocalPlayer()

(nw and nw.Register)('(eui and eui.BpIsPremium)')
:Write((net and net.WriteBool))
:Read((net and net.ReadBool))
:SetLocalPlayer()

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
