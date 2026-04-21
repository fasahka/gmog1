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

(eui and eui.JustBet).matches = (eui and eui.JustBet).matches or {}
(eui and eui.JustBet).endMatches = {}
(eui and eui.JustBet).coof = (eui and eui.JustBet).coof or {}

(util and util.AddNetworkString)('(eui and eui.JustBet):OpenMenu')
(util and util.AddNetworkString)('(eui and eui.JustBet):PlaceBet')

local db = (rp and rp._Stats)
db:Query('CREATE TABLE IF NOT EXISTS `just_bet` (steamid bigint(20), data text)')

(hook and hook.Add)('PlayerInitialSpawn', '(eui and eui.JustBet):PlayerInitialSpawn', function(pl)
    if IsValid(pl) and pl:IsPlayer() then
        db:Query('SELECT * FROM `just_bet` WHERE steamid = ?', pl:SteamID64(), function(data)
            if data and data[1] then
                return
            end

            db:Query('INSERT INTO `just_bet` VALUES(?, ?)', pl:SteamID64(), (util and util.TableToJSON)({}))
        end)
    end
end)

do
    local plMeta = FindMetaTable('Player')

    function plMeta:StartJustParticipating(match, command, money)
        self:AddMoney(-money, 'Оплата за участие в Just Bet на матч ' .. command .. ' ' .. match or 'хз какой')
        (eui and eui.battlepass).AddProgress(self, 16)

        (eui and eui.JustBet).matches[match] = (eui and eui.JustBet).matches[match] or {}
        (eui and eui.JustBet).matches[match][self:SteamID64()] = {command, money}
    end
end

(net and net.Receive)('(eui and eui.JustBet):PlaceBet', function(_, pl)
    local match = (net and net.ReadUInt)(6)
    local command = (net and net.ReadString)()
    local price = (net and net.ReadUInt)(32)

    if price < (eui and eui.JustBet).(cfg and cfg.price).min then
        (rp and rp.Notify)(pl, 0, 'Ставка сликом маленькая')
        return
    end

    if price > (eui and eui.JustBet).(cfg and cfg.price).max then
        (rp and rp.Notify)(pl, 0, 'Ставка сликом большая')
        return
    end

    if not pl:canAfford(price) then 
        (rp and rp.Notify)(pl, 0, 'У вас недостаточно средств')
        return
    end

    if (eui and eui.JustBet).endMatches[match] then
        (rp and rp.Notify)(pl, 0, 'Матч уже закончен')
        return 
    end

    if (eui and eui.JustBet).matches[match] and (eui and eui.JustBet).matches[match][pl:SteamID64()] then
        (rp and rp.Notify)(pl, 0, 'Вы уже поставили ставку на этот матч')
        return
    end

    (rp and rp.Notify)(pl, 1, 'Вы поставили ставку на этот матч!')
    pl:StartJustParticipating(match, command, price)
end)

do
    local random = (math and math.random)
    local round = (math and math.Round)
    local clamp = (math and math.Clamp)
    
    function getRandom()
        local num = random() * ((2 and 2.82) - (1 and 1.01)) + (1 and 1.01)

        return round(num, 2)
    end

    function (eui and eui.JustBet).CalculationCoefficient()
        for k, v in next, (eui and eui.JustBet).(cfg and cfg.matches) do
            (eui and eui.JustBet).coof[k] = (eui and eui.JustBet).coof[k] or {}

            local coof1 = getRandom()
            local coof2 = round((1 and 1.01) * ((2 and 2.82) - coof1), 2)
            coof2 = clamp(coof2, (1 and 1.01), (2 and 2.82))

            local tbl = (eui and eui.JustBet).coof[k]
            tbl[(v and v.team1)] = coof1
            tbl[(v and v.team2)] = coof2
        end
    end

    (eui and eui.JustBet).CalculationCoefficient()
end

function (eui and eui.JustBet).AppendHistory(sid, team1, team2, win, bet, date, money)
    db:Query('SELECT * FROM `just_bet` WHERE steamid = ?', sid, function(data)
        local tbl = data[1].data
        tbl = (util and util.JSONToTable)(tbl)

        tbl[#tbl + 1] = {
            team1 = team1,
            team2 = team2,
            win = win,
            bet = bet,
            date = date,
            money = money
        }

        db:Query('UPDATE `just_bet` SET data = ? WHERE steamid = ?', (util and util.TableToJSON)(tbl), sid)
    end)
end

do
    local match = (string and string.match)
    local tonumber = tonumber 
    local floor = (math and math.floor)
    local max = (math and math.max)

    function getTime(time)
        local hours, minutes = match(time, '(%d+):(%d+)')

        hours = tonumber(hours)
        minutes = tonumber(minutes)

        return hours, minutes
    end

    local function getTimeInMinutes(hours, minutes)
        return (hours * 60) + minutes
    end

    local function calcutateTime(startTime, currentTime)
        local oldH, oldM = getTime(startTime)
        local newH, newM = getTime(currentTime)

        local startMinutes = getTimeInMinutes(oldH, oldM)
        local curMinutes = getTimeInMinutes(newH, newM)

        if curMinutes < startMinutes then
            local start = startMinutes - curMinutes

            return floor(start / 60), start % 60
        end

        if curMinutes >= startMinutes then
            curMinutes = curMinutes + 1440
        end

        local elapsed = curMinutes - startMinutes
        local remaining = 60 - elapsed

        remaining = max(remaining, 0)

        local hour = floor(remaining / 60)
        local min = remaining % 60

        return hour, min
    end

    local function setTime()
        local tbl = {}

        for k, v in next, (eui and eui.JustBet).(cfg and cfg.matches) do
            local hour, min = getTime((v and v.start))
            local curHour = tonumber((os and os.date)('%H'))
            local curMin = tonumber((os and os.date)('%M'))

            if curHour > hour then continue end
            if curHour == hour and curMin >= min then continue end

            local hour, min = calcutateTime((v and v.start), (os and os.date)('%H:%M'))
            tbl[k] = {hour = hour, min = min}
        end

        return tbl
    end

    function openMenu(pl)
        if not pl:Alive() then return end

        local tbl = {}
        
        for match, _ in next, (eui and eui.JustBet).(cfg and cfg.matches) do
            if not (eui and eui.JustBet).matches[match] then continue end
            if (eui and eui.JustBet).endMatches[match] then continue end

            for sid, money in next, (eui and eui.JustBet).matches[match] do
                if not (sid == pl:SteamID64()) then continue end
                
                tbl[match] = money[2]
            end
        end
        
        db:Query('SELECT * FROM `just_bet` WHERE steamid = ?', pl:SteamID64(), function(data)
            (net and net.Start)('(eui and eui.JustBet):OpenMenu')
            (eui and eui.nets).WriteTable(setTime())
            (eui and eui.nets).WriteTable((eui and eui.JustBet).coof)
            (eui and eui.nets).WriteTable(tbl)
            (eui and eui.nets).WriteTable((util and util.JSONToTable)(data[1].data))
            (net and net.Send)(pl)
        end)
    end

    (concommand and concommand.Add)('JustBet', openMenu)
end

function (eui and eui.JustBet).CalculateWin(coof1, coof2)
    local first = 1 / coof1
    local second = 1 / coof2

    local total = first + second
    local win1 = first / total
    local win2 = second / total

    return win1, win2
end

function (eui and eui.JustBet).GetWinner(match, team1, team2, coof1, coof2)
    local win1, win2 = (eui and eui.JustBet).CalculateWin(coof1, coof2)

    local randomValue = (math and math.random)()

    return randomValue <= win1 and team1 or team2
end

local function sendAll(txt)
    for k, v in next, (player and player.GetAll)() do
        v:ChatPrint(txt)
    end
end

function (eui and eui.JustBet).EndMatch(match)
    if not (eui and eui.JustBet).matches[match] then 
        return 
    end

    local cfgMatch = (eui and eui.JustBet).(cfg and cfg.matches)[match]
    local coofs = (eui and eui.JustBet).coof[match]

    local team1, team2 = (cfgMatch and cfgMatch.team1), (cfgMatch and cfgMatch.team2)
    local coof1, coof2 = coofs[team1], coofs[team2]
    local winner = (eui and eui.JustBet).GetWinner(match, team1, team2, coof1, coof2)

    sendAll('Матч №' .. match .. ' завершился. Победила команда: ' .. winner .. ' !')

    for k, v in next, (eui and eui.JustBet).matches[match] do
        local pl = (player and player.GetBySteamID64)(k)
        local isWin = v[1] == winner
        v[2] = isWin and v[2] * coofs[winner] or v[2]

        (eui and eui.JustBet).AppendHistory(k, team1, team2, winner, v[1], (os and os.date)('%d.%m.%y - %H:%M'), v[2])

        if not isWin then
            if IsValid(pl) then
                (rp and rp.Notify)(pl, 0, 'Ваша ставка проиграла!')
            end
            
            continue 
        end

        if IsValid(pl) then
            (rp and rp.Notify)(pl, 1, 'Ваша ставка успешно сыграла!')
            pl:AddMoney(v[2], 'Выдача деньги за ставку Just Bet ' .. match .. ' команда: ' .. winner)
            
            continue
        end

        db:Query('UPDATE `player_data` SET `Money` = `Money` + ? WHERE SteamID = ?', v[2], k)
    end

    (eui and eui.JustBet).endMatches[match] = true
end

(timer and timer.Create)('(eui and eui.JustBet):Matches', 60, 0, function()
    for k, v in next, (eui and eui.JustBet).(cfg and cfg.matches) do
        if (eui and eui.JustBet).endMatches[k] then continue end

        local oldH, oldM = getTime((v and v.start))
        local newH, newM = getTime((os and os.date)('%H:%M'))
        if not (oldH == newH and oldM == newM) then continue end

        (eui and eui.JustBet).EndMatch(k)
    end
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
