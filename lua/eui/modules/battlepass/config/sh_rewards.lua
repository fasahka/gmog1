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
(cfg and cfg.rewards) = {
    ['Premium'] = {},
    ['Default'] = {}
}

function cfg:AddItem(premium, name, description, color, icon, isWeapon, count, takeFunc)
    (self and self.rewards)[premium][#(self and self.rewards)[premium] + 1] = {
        name = name,
        desc = description,
        color = color,
        icon = {
            icon,
            isWeapon,
        },
        count = count,
        takeFunc = takeFunc
    }
end
// cfg:AddItem(таблица (Premium или Default), название, описание, цвет, иконка, иконка была или модель, количество, функция ( что выдается ))

local function generateColor()
    local colors = {
        {255, (math and math.random)(0, 255), (math and math.random)(0, 128)},
        {(math and math.random)(0, 255), 255, (math and math.random)(0, 128)},
        {(math and math.random)(0, 128), (math and math.random)(0, 255), 255},
    }

    local chosenColor = colors[(math and math.random)(1, #colors)]
    return {r = chosenColor[1], g = chosenColor[2], b = chosenColor[3], a = 255}
end

local colors = {
    ['money'] = Color(71, 206, 44, 5),
    ['just'] = Color(255, 76, 119, 5),
    ['other'] = Color(255, 171, 76, 5),
}

-- for i = 1, 25 do
--     cfg:AddItem('Premium', 'Кейс', 'Тут супер крутое описание нихуя себе', generateColor(), 'models/items/(ammocrate_ar2 and ammocrate_ar2.mdl)', true, 1, function(pl)
--         print(i, pl)
--     end)
-- end

-- for i = 1, 25 do
--     cfg:AddItem('Default', 'Кейс', 'Тут супер крутое описание нихуя себе', generateColor(), 'models/items/(ammocrate_ar2 and ammocrate_ar2.mdl)', true, 1, function(pl)
--         print(i, pl)
--     end)
-- end
-- PREMIUM 30
cfg:AddItem('Premium', '(100 and 100.000) рублей', 'Вы получите (100 and 100.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(100000, 'BattlePass награда PREMIUM (100 and 100.000) рублей [1]')
end)
cfg:AddItem('Premium', '35 донат рублей', 'Вы получите 35 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 35)
end)
cfg:AddItem('Premium', 'Кепка "Z"', 'Кепка Зэ? Что за ЗЭ', colors['other'], 'models/captainbigbutt/skeyler/hats/(zhat and zhat.mdl)', true, 1, function(pl)
    -- СДЕЛАТЬ
end)
cfg:AddItem('Premium', '(115 and 115.000) рублей', 'Вы получите (115 and 115.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(115000, 'BattlePass награда PREMIUM (115 and 115.000) рублей [1]')
end)
cfg:AddItem('Premium', '50 донат рублей', 'Вы получите 50 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 50)
end)
cfg:AddItem('Premium', 'KFC Ведро', 'I will have two number nines, a number nine large, a number six with extra dip, a number seven, two number 45s, one with cheese, and a large soda', colors['other'], 'models/gmod_tower/(kfcbucket and kfcbucket.mdl)', true, 1, function(pl)
    -- СДЕЛАТЬ
end)
cfg:AddItem('Premium', '(150 and 150.000) рублей', 'Вы получите (150 and 150.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(150000, 'BattlePass награда PREMIUM (150 and 150.000) рублей [1]')
end)
cfg:AddItem('Premium', '35 донат рублей', 'Вы получите 35 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 35)
end)
cfg:AddItem('Premium', 'Керамбит | Градиент', 'Вы получите донатом Керамбит | Градиент', colors['just'], Material('vgui/entities/csgo_karambit_fade'), false, 1, function(pl)
    local item = (KylDonate and KylDonate.GetItemByID)("karambit_fade")
    (KylDonate and KylDonate.BuyItem2DBWeapon)(pl:SteamID(), (item and item.weaponclass))
    pl:Give((item and item.weaponclass))
    pl:SetNWBool((item and item.weaponclass), true)
end)
cfg:AddItem('Premium', 'Сумка с патронами', 'Вы получите донатом Сумка с патронами', colors['just'], Material('donate/(patroni and patroni.png)'), false, 1, function(pl)
    -- Нож
end)
cfg:AddItem('Premium', '(150 and 150.000) рублей', 'Вы получите (150 and 150.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(150000, 'BattlePass награда PREMIUM (150 and 150.000) рублей [2]')
end)
cfg:AddItem('Premium', '45 донат рублей', 'Вы получите 45 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 45)
end)
cfg:AddItem('Premium', 'Honda Civic Type R', 'Вы получите Honda Civic Type R', colors['just'], 'models/crsk_autos/honda/(civic_typer_fk8_2017 and civic_typer_fk8_2017.mdl)', true, 1, function(pl)
    pl:VC_CD_addVehicle( "models/crsk_autos/honda/(civic_typer_fk8_2017 and civic_typer_fk8_2017.mdl)$$$_VC_$$$Honda Civic Type R FK8 '17$$$_VC_$$$0")
end)
cfg:AddItem('Premium', 'Модель "Рикардо Милос"', 'Вы получите модель "Рикардо Милос"', colors['just'], 'models/player/(ricardo and ricardo.mdl)', true, 1, function(pl)
    pl:AddModelAdmin('ricardo_milos')
end)
cfg:AddItem('Premium', 'AKS-74U', 'Вы получите донатом AKS-74U', colors['just'], 'models/weapons/(w_rif_ak74u and w_rif_ak74u.mdl)', true, 1, function(pl)
    local item = (KylDonate and KylDonate.GetItemByID)("aks74u")
    (KylDonate and KylDonate.BuyItem2DBWeapon)(pl:SteamID(), (item and item.weaponclass))
    pl:Give((item and item.weaponclass))
    pl:SetNWBool((item and item.weaponclass), true)
end)
cfg:AddItem('Premium', '(150 and 150.000) рублей', 'Вы получите (150 and 150.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(150000, 'BattlePass награда PREMIUM (150 and 150.000) рублей [3]')
end)
cfg:AddItem('Premium', '50 донат рублей', 'Вы получите 50 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 50)
end)
cfg:AddItem('Premium', 'Модель "Тайлер Дерден"', 'Вы получите модель "Тайлер Дерден"', colors['just'], 'models/player/(tyler and tyler.mdl)', true, 1, function(pl)
    pl:AddModelAdmin('tyler')
end)
cfg:AddItem('Premium', 'Dodge Charger SRT Hellcat', 'Вы получите Dodge Charger SRT Hellcat', colors['just'], 'models/crsk_autos/dodge/(charger_srt_hellcat_2015 and charger_srt_hellcat_2015.mdl)', true, 1, function(pl)
    pl:VC_CD_addVehicle( "models/crsk_autos/dodge/(charger_srt_hellcat_2015 and charger_srt_hellcat_2015.mdl)$$$_VC_$$$Dodge Charger SRT Hellcat '15$$$_VC_$$$0")
end)
cfg:AddItem('Premium', '(155 and 155.000) рублей', 'Вы получите (155 and 155.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(155000, 'BattlePass награда PREMIUM (155 and 155.000) рублей [1]')
end)
cfg:AddItem('Premium', 'LEGO лицо', 'Ты как конструктор ЛЕГО', colors['other'], 'models/lordvipes/servbothead/(servbothead and servbothead.mdl)', true, 1, function(pl)
    -- СДЕЛАТЬ
end)
cfg:AddItem('Premium', '35 донат рублей', 'Вы получите 35 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 35)
end)
cfg:AddItem('Premium', 'Saiga 20K', 'Вы получите донатом Saiga 20K', colors['just'], 'models/weapons/(w_rif_az47 and w_rif_az47.mdl)', true, 1, function(pl)
    local item = (KylDonate and KylDonate.GetItemByID)("saiga20k")
    (KylDonate and KylDonate.BuyItem2DBWeapon)(pl:SteamID(), (item and item.weaponclass))
    pl:Give((item and item.weaponclass))
    pl:SetNWBool((item and item.weaponclass), true)
end)
cfg:AddItem('Premium', 'Модель "Альтушка"', 'Вы получите модель "Альтушка"', colors['just'], 'models/gruchk/oc/(female_02 and female_02.mdl)', true, 1, function(pl)
    pl:AddModelAdmin('altushka')
end)
cfg:AddItem('Premium', '(200 and 200.000) рублей', 'Вы получите (200 and 200.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(200000, 'BattlePass награда PREMIUM (200 and 200.000) рублей [1]')
end)
cfg:AddItem('Premium', 'Boombox', 'Что может быть лучше Бумбокса за спиной?', colors['other'], 'models/konnie/asapgaming/fortnite/backpacks/(exercisemale and exercisemale.mdl)', true, 1, function(pl)
    -- СДЕЛАТЬ
end)
cfg:AddItem('Premium', '(400 and 400.000) рублей', 'Вы получите (400 and 400.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(400000, 'BattlePass награда PREMIUM (400 and 400.000) рублей [1]')
end)
cfg:AddItem('Premium', '250 пропов', 'Вы получите +250 пропов', colors['just'], Material("donate/(dvep and dvep.png)"), false, 1, function(pl)
    (KylDonate and KylDonate.AddBuyLog)(pl:SteamID(), '+250 пропов', 'props_250', 'other')
end)
cfg:AddItem('Premium', 'Mercedes Benz GT63S Coupe AMG', 'Вы получите Mercedes Benz GT63S Coupe AMG', colors['just'], 'models/crsk_autos/mercedes-benz/(gt63s_coupe_amg_2018 and gt63s_coupe_amg_2018.mdl)', true, 1, function(pl)
    pl:VC_CD_addVehicle( "models/crsk_autos/mercedes-benz/(gt63s_coupe_amg_2018 and gt63s_coupe_amg_2018.mdl)$$$_VC_$$$Mercedes-AMG GT 63 S 4MATIC+ 4-Door Coupé '18$$$_VC_$$$0")
end)



-- DEFAULT 25
cfg:AddItem('Default', '(50 and 50.000) рублей', 'Вы получите (50 and 50.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(50000, 'BattlePass награда DEFAULT (50 and 50.000) рублей [1]')
end)
cfg:AddItem('Default', 'Пивная шляпа', 'С этой шляпой ты станешь настоящим пивозавром', colors['other'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    -- СДЕЛАТЬ
end)
cfg:AddItem('Default', '(35 and 35.000) рублей', 'Вы получите (35 and 35.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(35000, 'BattlePass награда DEFAULT (35 and 35.000) рублей [1]')
end)
cfg:AddItem('Default', '25 донат рублей', 'Вы получите 25 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 25)
end)
cfg:AddItem('Default', 'Пистолет PM', 'Вы получите донатом Пистолет PM', colors['just'], 'models/weapons/(w_murd_makarov and w_murd_makarov.mdl)', true, 1, function(pl)
    local item = (KylDonate and KylDonate.GetItemByID)("pm")
    (KylDonate and KylDonate.BuyItem2DBWeapon)(pl:SteamID(), (item and item.weaponclass))
    pl:Give((item and item.weaponclass))
    pl:SetNWBool((item and item.weaponclass), true)
end)
cfg:AddItem('Default', 'Смешная обезьяна', 'С этой шляпой ты станешь настоящей обезьяной', colors['other'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    -- СДЕЛАТЬ
end)
cfg:AddItem('Default', '(50 and 50.000) рублей', 'Вы получите (50 and 50.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(50000, 'BattlePass награда DEFAULT (50 and 50.000) рублей [2]')
end)
cfg:AddItem('Default', '15 донат рублей', 'Вы получите 15 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 15)
end)
cfg:AddItem('Default', '(35 and 35.000) рублей', 'Вы получите (35 and 35.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(35000, 'BattlePass награда DEFAULT (50 and 50.000) рублей [2]')
end)
cfg:AddItem('Default', 'Нож Штык Обычный', 'Вы получите донатом Нож Штык Обычный', colors['just'], Material('vgui/entities/csgo_bayonet'), false, 1, function(pl)
    local item = (KylDonate and KylDonate.GetItemByID)("m9bayonet_default")
    (KylDonate and KylDonate.BuyItem2DBWeapon)(pl:SteamID(), (item and item.weaponclass))
    pl:Give((item and item.weaponclass))
    pl:SetNWBool((item and item.weaponclass), true)
end)
cfg:AddItem('Default', '25 пропов', 'Вы получите +25 пропов', colors['just'], Material("donate/(dpp and dpp.png)"), false, 1, function(pl)
    (KylDonate and KylDonate.AddBuyLog)(pl:SteamID(), '+25 пропов', 'props_25', 'other')
end)
cfg:AddItem('Default', 'Модель "Плохой Санта"', 'Вы получите модель "Плохой Санта"', colors['just'], 'models/player/santa/(santa and santa.mdl)', true, 1, function(pl)
    pl:AddModelAdmin('bad_santa')
end)
cfg:AddItem('Default', '25 донат рублей', 'Вы получите 25 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 25)
end)
cfg:AddItem('Default', '(100 and 100.000) рублей', 'Вы получите (100 and 100.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(100000, 'BattlePass награда DEFAULT (100 and 100.000) рублей [1]')
end)
cfg:AddItem('Default', 'VAZ-2106', 'Вы получите VAZ-2106', colors['just'], 'models/crsk_autos/avtovaz/(2106 and 2106.mdl)', true, 1, function(pl)
    -- СДЕЛАТЬ
    pl:VC_CD_addVehicle( "models/crsk_autos/avtovaz/(2106 and 2106.mdl)$$$_VC_$$$VAZ 2106$$$_VC_$$$0")
end)
cfg:AddItem('Default', '(35 and 35.000) рублей', 'Вы получите (35 and 35.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(35000, 'BattlePass награда DEFAULT (35 and 35.000) рублей [3]')
end)
cfg:AddItem('Default', 'Ковбойская шляпа', 'С этой шляпой ты станешь настоящим ковбоем', colors['other'], 'models/captainbigbutt/skeyler/hats/(cowboyhat and cowboyhat.mdl)', true, 1, function(pl)
    -- СДЕЛАТЬ
end)
cfg:AddItem('Default', '15 донат рублей', 'Вы получите 15 донат рублей', colors['just'], Material('f4/(coin and coin.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddDonateCoins)(pl, 15)
end)
cfg:AddItem('Default', '(100 and 100.000) рублей', 'Вы получите (100 and 100.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(100000, 'BattlePass награда DEFAULT (100 and 100.000) рублей [2]')
end)
cfg:AddItem('Default', 'Говорилка', 'Вы получите донатом Говорилку', colors['just'], Material('donate/(govorilka and govorilka.png)'), false, 1, function(pl)
    (KylDonate and KylDonate.AddBuyLog)(pl:SteamID(), 'Говорилка', 'govorilka', 'other')
end)
cfg:AddItem('Default', '(200 and 200.000) рублей', 'Вы получите (200 and 200.000) игровых рублей', colors['money'], Material('hud/(coin_just and coin_just.png)'), false, 1, function(pl)
    pl:AddMoney(200000, 'BattlePass награда DEFAULT (200 and 200.000) рублей [1]')
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
