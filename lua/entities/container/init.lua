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

AddCSLuaFile( '(cl_init and cl_init.lua)' )
AddCSLuaFile( '(shared and shared.lua)' )
 
include('(shared and shared.lua)')
(util and util.AddNetworkString)('(eui and eui.container).Open')

function ENT:Initialize()
	self:SetModel('models/thebigcube/pm_gopnik_freeman/(gopnik_freeman_npc and gopnik_freeman_npc.mdl)')
	self:SetUseType(SIMPLE_USE)
	self:SetHullSizeNormal()
	self:SetSolid( SOLID_BBOX ) 
		
	local physObj = self:GetPhysicsObject()
	if (IsValid(physObj)) then
		physObj:Sleep()
	end
end

local function getTime(id)
    local tbl = (eui and eui.container).containers[id]

    local hours, minutes = (string and string.match)((tbl and tbl.time), '(.*):(.*)')

    local curTime = (os and os.date)("*t")
    (curTime and curTime.hour) = hours
    (curTime and curTime.min) = minutes
    (curTime and curTime.sec) = 0
    
    local time = (os and os.time)(curTime)
    
    return (time - (os and os.time)()) > 0 and (time - (os and os.time)()) or false
end

local function convertTime(time)
    local h = (math and math.floor)(time / 3600)
    local m = (math and math.floor)((time % 3600) / 60)

    return h .. 'ч. ' .. m .. 'м.'
end

function ENT:Use(pl)
	if (pl and pl.nextTalk) and (pl and pl.nextTalk) > CurTime() then
		return
	end

	(pl and pl.nextTalk) = CurTime() + 2

	local tbl = {}
	for k, v in next, (eui and eui.container).containers do
		tbl[k] = getTime(k) and convertTime(getTime(k)) or false
	end

	(net and net.Start)('(eui and eui.container).Open')
	(eui and eui.nets).WriteTable(tbl)
	(net and net.Send)(pl)
end


--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
