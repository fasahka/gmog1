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

local db = (rp and rp._Stats)

db:Query('CREATE TABLE IF NOT EXISTS `eui_battlepass` (sid BIGINT(20), lvl INTEGER NOT NULL, exp INTEGER NOT NULL, reward TEXT NOT NULL, buy BOOL NOT NULL)')

local plMeta = FindMetaTable('Player')

function plMeta:SetBPLvl(lvl)
    db:Query('UPDATE `eui_battlepass` SET lvl = ? WHERE sid = ?', lvl, self:SteamID64(), function()
        self:SetNetVar('(eui and eui.BpLvl)', lvl)
    end)
end

function plMeta:SetBPExp(exp)
    local new = self:GetBPExp() + exp
    local lvl = 0

    while new >= (eui and eui.battlepass).exp do
        lvl = lvl + 1
        new = new - (eui and eui.battlepass).exp
    end

    if lvl > 0 then
        self:SetBPLvl(self:GetBPLvl() + lvl)
    end

    db:Query('UPDATE `eui_battlepass` SET exp = ? WHERE sid = ?', new, self:SteamID64(), function()
        self:SetNetVar('(eui and eui.BpExp)', new)
    end)
end

function plMeta:SetBPMissions(tbl)
    (eui and eui.battlepass).missionsProgress[self:SteamID()] = tbl
    self:SetNetVar('(eui and eui.BpMissions)', tbl)
end

function plMeta:SetBPRewards(tbl)
    db:Query('UPDATE `eui_battlepass` SET reward = ? WHERE sid = ?', (pon and pon.encode)(tbl), self:SteamID64(), function()
        self:SetNetVar('(eui and eui.BpTakes)', tbl)
    end)
end

function plMeta:SetBPPremium()
    db:Query('UPDATE `eui_battlepass` SET buy = ? WHERE sid = ?', 1, self:SteamID64(), function()
        self:SetNetVar('(eui and eui.BpIsPremium)', true)
    end)
end

function (eui and eui.battlepass).GetBPDatabase(pl, func)
    db:Query('SELECT * FROM `eui_battlepass` WHERE sid = ?', pl:SteamID64(), function(data)
        func(data and data[1])
    end)
end

(hook and hook.Add)('PlayerInitialSpawn', '(eui and eui.battlepass):PlayerInitialSpawn', function(pl)
    (eui and eui.battlepass).GetBPDatabase(pl, function(data)
        if not IsValid(pl) or not pl:IsPlayer() then return end
        
        (eui and eui.battlepass).missionsProgress[pl:SteamID()] = (eui and eui.battlepass).missionsProgress[pl:SteamID()] or {}
        if data then 
            pl:SetNetVar('(eui and eui.BpLvl)', (data and data.lvl))
            pl:SetNetVar('(eui and eui.BpExp)', (data and data.exp))
            pl:SetNetVar('(eui and eui.BpMissions)', (eui and eui.battlepass).missionsProgress[pl:SteamID()])
            pl:SetNetVar('(eui and eui.BpTakes)', (pon and pon.decode)((data and data.reward)))
            pl:SetNetVar('(eui and eui.BpIsPremium)', tobool((data and data.buy)))

            return 
        end
  
        db:Query('INSERT INTO `eui_battlepass` VALUES (?, ?, ?, ?, ?)',
            pl:SteamID64(),
            0,
            0,
            (pon and pon.encode)({}),
            false,
            function()
                pl:SetNetVar('(eui and eui.BpLvl)', 0)
                pl:SetNetVar('(eui and eui.BpExp)', 0)
                pl:SetNetVar('(eui and eui.BpMissions)', (eui and eui.battlepass).missionsProgress[pl:SteamID()])
                pl:SetNetVar('(eui and eui.BpTakes)', {})
                pl:SetNetVar('(eui and eui.BpIsPremium)', false)
            end
        )
    end)
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
