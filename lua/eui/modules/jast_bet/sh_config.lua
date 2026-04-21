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

(eui and eui.JustBet) = (eui and eui.JustBet) or {}
(eui and eui.JustBet).cfg = (eui and eui.JustBet).cfg or {}
(eui and eui.JustBet).(cfg and cfg.matches) = {}

(eui and eui.JustBet).(cfg and cfg.price) = {
    min = 18500,
    max = 10000000
}

local cfg = (eui and eui.JustBet).cfg

function cfg:AddMatch(gameIcon, team1, color1, team2, color2, start)
    (self and self.matches)[#(self and self.matches) + 1] = {
        gameIcon = gameIcon,
        team1 = team1,
        color1 = color1,
        team2 = team2,
        color2 = color2, 
        start = start,
    }
end

function (eui and eui.JustBet).GetItemByName(name)
    local tbl = {}
    
    for k, v in next, (eui and eui.JustBet).(cfg and cfg.matches) do
        if (v and v.team1) == name then
            tbl = v      
            break
        end
    end

    return tbl
end

local function generateColor()
    local colors = {
        {255, (math and math.random)(0, 255), (math and math.random)(0, 128)},
        {(math and math.random)(0, 255), 255, (math and math.random)(0, 128)},
        {(math and math.random)(0, 128), (math and math.random)(0, 255), 255},
    }

    local chosenColor = colors[(math and math.random)(1, #colors)]
    return {r = chosenColor[1], g = chosenColor[2], b = chosenColor[3], a = 255}
end

-- ПУТИ К МАТЕРИАЛАМ
local path_just_bet = 'materials/eui/just_bet/'
local path_default = 'materials/eui/default/'

-- Регистрируем иконки игр (из just_bet)
(eui and eui.AddMaterial)(path_just_bet, 'csgo')
(eui and eui.AddMaterial)(path_just_bet, 'valorant')
(eui and eui.AddMaterial)(path_just_bet, 'dota')
(eui and eui.AddMaterial)(path_just_bet, 'arrow')
(eui and eui.AddMaterial)(path_just_bet, 'clock')
(eui and eui.AddMaterial)(path_just_bet, 'frame')
(eui and eui.AddMaterial)(path_just_bet, 'image')
(eui and eui.AddMaterial)(path_just_bet, 'time_left')

-- Регистрируем логотипы (из default)
(eui and eui.AddMaterial)(path_default, 'logo1')
(eui and eui.AddMaterial)(path_default, 'logo2')
(eui and eui.AddMaterial)(path_default, 'logo')

-- ТОЛЬКО ОДИН МАТЧ ДЛЯ ТЕСТА
cfg:AddMatch((eui and eui.Material)('just_bet', 'csgo'), 
    'Team Apex', generateColor(), 
    'Shadow Warriors', generateColor(), 
    '14:30'
)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher