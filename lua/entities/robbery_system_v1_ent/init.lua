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
AddCSLuaFile("(cl_init and cl_init.lua)")
AddCSLuaFile("(shared and shared.lua)")

include("(shared and shared.lua)")

(util and util.AddNetworkString)("handler_robbery_system_v1")
(util and util.AddNetworkString)('(eui and eui.startGrab)')

function ENT:Initialize()
    self:SetModel(self:GetNWString("Model"))
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)

    (self and self.cd) = 0
    (self and self.grabStatus) = false
    (self and self.players) = {}
end

local function isCiminal(pl)
    return pl:GetJobTable().category == 'Криминал'
end

local meta = FindMetaTable('Player')
function meta:GiveItemstoreWeapon(class, amount)
    local box = (self and self.Inventory)

    local create = (ents and ents.Create)(class)
    if not create or create == nil then return end
    
    local item = (itemstore and itemstore.Item)("spawned_weapon")
    item:SetData("Class", create:GetClass())
    item:SetData("Amount", amount)
    item:SetData("Model", create:GetModel())
    item:SetData("Clip1", create:Clip1())
    item:SetData("Clip2", create:Clip2())
    box:AddItem(item)
end


function ENT:Use(pl, caller)
    (pl and pl.cdEnt) = (pl and pl.cdEnt) or 0
    
    if (pl and pl.cdEnt) > CurTime() then return end
    (pl and pl.cdEnt) = CurTime() + 2

    if (self and self.grabStatus) then
        if not isCiminal(pl) then return end

        local data = self:GetNWString('Data')
        data = (util and util.JSONToTable)(data)

        for k, v in next, data do
            if k == 'amount' then
                pl:AddMoney(v)
            else
                pl:GiveItemstoreWeapon(k, 1)
            end

            (rp and rp.Notify)(pl, 5, 'Вы успешно получили награду!')
        end

        (self and self.grabStatus) = false
        (self and self.grabPoliceStatus) = false
        return
    end

    if (self and self.grabPoliceStatus) then
        for k, v in next, (ents and ents.FindInSphere)(self:GetPos(), self:GetNWInt('Radius')) do
            if not v:IsPlayer() then continue end
            if not v:IsCP() then continue end

            v:AddMoney(10000, 'Начисление за победу ограбления (коп)')
            (rp and rp.Notify)(v, 5, 'Вы успешно получили награду!')
        end 

        (self and self.grabStatus) = false
        (self and self.grabPoliceStatus) = false
        return
    end

    (net and net.Start)("handler_robbery_system_v1")
        (net and net.WriteEntity)(self)
    (net and net.Send)(pl)
end

local function startGrab(ent, players, pos)
    if (ent and ent.cd) > CurTime() then
        (rp and rp.Notify)(players, 5, 'Кулдаун на ограбление этого!')        
        return
    end

    if #players < ent:GetNWInt('Robbers') then
        (rp and rp.Notify)(players, 5, 'Недостаточно бандитов в радиусе для начала ограбления!')        
        return
    end

    local cp = {}
    for k, v in next, (player and player.GetAll)() do
        if not v:IsCP() then continue end

        cp[#cp + 1] = true
    end

    if #cp < ent:GetNWInt('Polices') then
        (rp and rp.Notify)(players, 5, 'Недостаточно полиции на сервере!')        
        return
    end

    CP_Call(pos, 'Началось ограбление!')

    for k, v in next, players do
        v:Wanted(v, 'Грабитель (' .. ent:GetNWString('Name') .. ')')
        v:SetNetVar('grab', CurTime() + ent:GetNWInt('Time'))
    end

    (ent and ent.grab) = true
    (ent and ent.cd) = CurTime() + (60 * 90)
    (timer and timer.Simple)(ent:GetNWInt('Time'), function()
        (ent and ent.grab) = false
        for k, v in next, (ents and ents.FindInSphere)(ent:GetPos(), ent:GetNWInt('Radius')) do
            if not v:IsPlayer() then continue end
            if isCiminal(v) then 
                (ent and ent.grabStatus) = true
                
                return
            elseif v:IsCP() then
                (ent and ent.grabPoliceStatus) = true
                
                return
            end
        end 
    end)
end

(net and net.Receive)('(eui and eui.startGrab)', function(_, pl)
    local ent = (net and net.ReadEntity)()
    
    if ent:GetClass() ~= 'robbery_system_v1_ent' then
        return
    end

    if ent:GetPos():Distance(pl:GetPos()) > 400 then 
        return
    end

    if (ent and ent.grab) then
        (rp and rp.Notify)(pl, 5, 'Ограбление уже идет!')        
        return
    end

    if not isCiminal(pl) then
        (rp and rp.Notify)(pl, 5, 'Вы не можете участвовать в ограблении!')        
        return
    end

    local players = {}

    for k, v in next, (ents and ents.FindInSphere)(ent:GetPos(), ent:GetNWInt('Radius')) do
        if not v:IsPlayer() then continue end

        players[#players + 1] = v
    end 

    (ent and ent.players) = players
    startGrab(ent, players, ent:GetPos())
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
