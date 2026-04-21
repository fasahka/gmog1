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

local cfg = (eui and eui.battlepass)
(cfg and cfg.missions) = {}

function cfg:AddMission(name, desc, need, exp)
    (self and self.missions)[#(self and self.missions) + 1] = {
        name = name,
        desc = desc,
        need = need,
        exp = exp
    }
end

// cfg:AddMission(Название, Описание, сколько нужно раз выполнить, сколько выдаст exp)

-- cfg:AddMission('Сосал', 'Напиши в чат 10 раз слово "Да"', 10, 1000) // это типо первое задание, поэтому в (eui and eui.battlepass).AddProgress мы устанавливаем 1 ( ее ключ в таблице )
cfg:AddMission('Фасовщик', 'Сделать за фасовщика 50 рационов', 50, 300) // 1
cfg:AddMission('Грузчик', 'Отнести за грузчика 50 коробок', 50, 300) // 2
cfg:AddMission('Доставщик', 'Отнести 50 заказов еды', 50, 300) // 3
cfg:AddMission('Военком', 'Призвать 10 людей на службу', 10, 300) // 4
cfg:AddMission('Дурка', 'Посадить 10 людей в дурку', 10, 300) // 5
cfg:AddMission('Гровер', 'Сдать 25 марихуаны', 25, 300) // 6
cfg:AddMission('Инкассатор', 'Инкассировать 60 банкоматов', 60, 300) // 7
cfg:AddMission('Мет', 'Сдать 25 мета', 25, 300) // 8
cfg:AddMission('Киллер', 'Убить 30 заказанных людей', 30, 300) // 9
cfg:AddMission('Месть', 'Заказать 10 людей', 10, 300) // 10
cfg:AddMission('Депутат', 'Сменить 5 раз политическую партию', 5, 300) // 11
cfg:AddMission('Мент', 'Посадить 5 людей с розыском', 5, 300) // 12
cfg:AddMission('Вам приз?', 'Поучаствовать в 3 лотереях', 3, 300) // 13
cfg:AddMission('Делай деньги бл*ть вот так', 'Купить 2 денежных принтера', 2, 300) // 14
cfg:AddMission('777', 'Поиграть 20 раз в казино (любом)', 20, 300) // 15
cfg:AddMission('Один хбэк', 'Поставить 5 ставок в Just Bet', 5, 300) // 16
cfg:AddMission('Билеты', 'Купить 3 билета в F4 - Билеты', 3, 300) // 17
cfg:AddMission('Посмотрите на меня', 'Показать 20 раз паспорт людям', 20, 300) // 18
cfg:AddMission('Домовой', 'Купить 50 дверей', 50, 300) // 19
cfg:AddMission('Модник', 'Приобрести 1 любой аксессуар', 1, 300) // 20
cfg:AddMission('Би бип', 'Приобрести 1 любую машину', 1, 300) // 21
cfg:AddMission('Криптан', 'Купить 10 раз любую монету', 10, 300) // 22
cfg:AddMission('Богач?', 'Передать (10 and 10.000) рублей любому человеку', 10000, 300) // 23
cfg:AddMission('Мятеж', 'Начать 1 мятеж против мэра', 1, 300) // 24
cfg:AddMission('БогаТЫй?', 'Передать (25 and 25.000) рублей любому человеку', 25000, 300) // 25
cfg:AddMission('Везунчик?', 'Поучаствовать в 5 лотереях', 5, 300) // 26
cfg:AddMission('Купи билет', 'Купить 3 билета в F4 - Билеты', 3, 300) // 27
cfg:AddMission('Военком', 'Призвать 20 людей на службу', 20, 300) // 28
cfg:AddMission('Метафентаминовый чел', 'Сдать 35 мета', 35, 300) // 29
cfg:AddMission('Грузчик', 'Отнести за грузчика 70 коробок', 70, 300) // 30
cfg:AddMission('Ревендж', 'Заказать 15 людей', 15, 300) // 31
cfg:AddMission('Карты', 'Открыть 3 карты в F4 - Карты', 3, 300) // 32
cfg:AddMission('Инкассирую', 'Инкассировать 90 банкоматов', 3, 300) // 33
cfg:AddMission('Ворошиловский стрелок', 'Убить 50 заказанных людей', 50, 300) // 34
cfg:AddMission('Ментяра', 'Посадить 10 людей с розыском', 10, 300) // 35
cfg:AddMission('Доставщик', 'Отнести 70 заказов еды', 70, 300) // 36
cfg:AddMission('Криптоинвестор', 'Купить 15 раз любую монету', 15, 300) // 37
cfg:AddMission('Щедрый', 'Передать (50 and 50.000) рублей любому человеку', 50000, 300) // 38


if CLIENT then return end

-- (hook and hook.Add)('PlayerSay', 'sosal', function(pl, text)
--     if text == 'Да' then
--         (eui and eui.battlepass).AddProgress(pl, 1)
--     end

--     if text == 'Сосал?' then
--         (eui and eui.battlepass).AddProgress(pl, 2)
--     end
-- end)

(hook and hook.Add)("VC_CD_playerPurchasedVehicle", "sosal", function(ply)
    (eui and eui.battlepass).AddProgress(ply, 21)
end)

(hook and hook.Run)('(eui and eui.battlepass).MissionsLoaded')

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
