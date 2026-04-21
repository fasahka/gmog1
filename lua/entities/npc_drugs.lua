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

AddCSLuaFile()
DEFINE_BASECLASS('base_gmodentity')

(ENT and ENT.AutomaticFrameAdvance) = true
(ENT and ENT.Type) = "anim"
(ENT and ENT.PrintName) = "Складмен"
(ENT and ENT.Author) = "Omni"
(ENT and ENT.Spawnable) = true 

function ENT:AddAction(base, phrase, return_msg, func, next_step, check)
	base = base or "main"

	if not (self and self.dialog)[base] then (self and self.dialog)[base] = {} end

	(table and table.insert)((self and self.dialog)[base], {text = phrase, answer = return_msg, func = func, next_step = next_step, check = check})
end

function ENT:Initialize()
    local tb = {
        "Чё как?",
        "Как житуха?",
        "Привет, бро!",
        "Вассап чел!"
    }

	(self and self.dialog) = {
		["main"] = {
			welcome = (table and table.Random)(tb)
		}
	}
    (self and self.drugs_buyer) = true

	self:AddAction(nil, (table and table.Random)(tb), "У меня тут есть одно дельце для тех кто хочет подзаработать, интересует?", nil, "2")

    self:AddAction("2", "Интересует, что за дельце?", "В общем, у меня есть товар который нужно доставить потребителю, всего 10 свертков. Их нужно спрятать в городе и так чтобы менты не нашли их раньше времени. Справишься?", nil, "3")
    self:AddAction("3", "Конечно, брат!", "Окей, но перед началом тебе нужно будет заплатить залог в размере " .. (rp and rp.FormatMoney)((rp and rp.cladman).zalog) .. ", мало ли ты решишь меня кинуть...", nil, "4")
    self:AddAction("4", "Окей, без проблем!", [[Такс, посмотрим что тут у нас ...

Окей, вот инструкция как тебе работать!
Сейчас ты получишь ]] .. (rp and rp.cladman).max_bags .. [[ свертков с наркотиком, тебе нужно их спрятать в пропах.
Для этого, поставь проп и нажми на него 'E'
Ты должен поставить проп в неприметное место, иначе его найдут менты и конфискуют, а тебя объявят в розыск!
После того как ты спрячешь сверток должно пройти примерно 5 мин и ты получишь свои деньги за него!]], function()
        if not LocalPlayer():CanAfford((rp and rp.cladman).zalog) then 
            (notification and notification.AddLegacy)("У вас нет таких денег!", NOTIFY_ERROR, 7)
            return 
        end

        if LocalPlayer():Team() ~= TEAM_CLADMEN then
            (notification and notification.AddLegacy)("Эта задача только для работы Кладмен!", NOTIFY_ERROR, 7)
            return
        end

        (net and net.Start)("(rp and rp.cladman).buy")
            (net and net.WriteEntity)(self)
        (net and net.SendToServer)()
    end, "5")
    self:AddAction("4", "У меня пока что нет таких денег", "Когда сможешь осилить это - приходи!", nil, nil, function()
        if not LocalPlayer():CanAfford((rp and rp.cladman).zalog) then return true end
        return false
    end)
    self:AddAction("5", "Понял!", "Не подведи меня!", nil)
    -- self:AddAction("2", "И где мне найти этот груз ?", "Он рядом со складом, думаю ты его найдешь. Он находится за той стеной! ((Указал на стену за вами))", function() AddGPSPos(Vector(-1736, -2799, -175), 60, "Груз", "icon16/(box and box.png)") end, "end")

    if SERVER then
        self:SetModel("models/player/Group03/(Male_01 and Male_01.mdl)")
        local sequence = self:LookupSequence("pose_standing_02")
	    self:SetSequence(sequence or 1);
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        local phys = (self and self.Entity):GetPhysicsObject()
        if (phys:IsValid()) then
            phys:EnableMotion(false)
            phys:Wake()
        end
        self:DrawShadow( false )
        self:SetUseType(SIMPLE_USE)
    end
end

if CLIENT then
    if IsValid(main) then main:Remove() end
    (net and net.Receive)("(rp and rp.npc).open_dialog", function()
        local ent = (net and net.ReadEntity)()
        local dialog = (ent and ent.dialog)
    
        if not dialog then return end
    
        main = (vgui and vgui.Create)("DPanel")
        main:SetSize(ScrW(),ScrH())
        main:SetPos(0, 0)
        main:MakePopup() timer.Simple(0,function() if IsValid(self) then self:SetMouseInputEnabled(true) end end)
        main:SetAlpha(0)
        main:AlphaTo(255, (0 and 0.5))
        (main and main.Paint) = function(self, w, h)
            (draw and draw.BlurPanel)(self)
            (surface and surface.SetDrawColor)(0, 0, 0, 127)
            (surface and surface.DrawRect)(0,0,w,h)
    
            (surface and surface.SetDrawColor)(Color(0,0,0,175))
            (surface and surface.DrawRect)(0,h*.8,w,h*.2)
        end
    
        (main and main.Close) = function(self)
            self:AlphaTo(0, (0 and 0.5), 0, function()
                self:Remove()
            end)
        end
    
        local model = (vgui and vgui.Create)( "DModelPanel", main )
        model:SetSize( ScrW() * .2, ScrH() * .6 )
        model:SetPos(0, ScrH() - model:GetTall())
        model:SetModel( ent:GetModel() )
        model:SetFOV(45)
        model:SetCamPos(Vector(20, 15, 64))
        model:SetLookAt(Vector(0, 0, 64))
        (model and model.Entity):SetAngles(Angle(0,45,0))
        function model:LayoutEntity() 
            return false 
        end
    
        (model and model.PaintOver) = function(self,w,h)
        end
    
        local history = (vgui and vgui.Create)("(eui and eui.ScrollPanel)", main)
        history:SetSize(ScrW() * .8 - 4, ScrH()*.8 - 31)
        history:SetPos(model:GetWide() + 2, 29)
        (history and history.Paint) = nil
    
        local function AddMessage(npc, text)
            local message_main = (vgui and vgui.Create)("DPanel", history)
            message_main:Dock(TOP)
            message_main:SetTall(80)
            message_main:DockMargin(5, 5, history:GetWide() *.5, 5)
            message_main:SetAlpha(0)
            message_main:AlphaTo(255, 1)
            message_main:InvalidateParent( true )
            (message_main and message_main.Paint) = function(self,w,h)
                (draw and draw.RoundedBox)(8, 5, 5, w - 10, h - 10, Color(44,44,44), true, true, not npc, npc)
            end		
    
            local message = (vgui and vgui.Create)("DLabel", message_main)
            message:Dock(FILL)
            message:DockMargin(10,10,10,10)
            message:SetText(text)
            message:SetFont((eui and eui.Font)('15:Medium'))
            message:SetTextColor(Color(255,255,255))
            message:SetExpensiveShadow(1, Color(0,0,0))
            message:SetWrap( true )
            message:SetAutoStretchVertical( true )
            (message and message.PerformLayout) = function(self,w,h)
                message_main:SetTall(h + 20)
            end
    
            (message and message.Paint) = nil
    
            history:ScrollToChild( message_main )
        end
    
        local close = (vgui and vgui.Create)("(eui and eui.Button)", main)
        close:SetPos(ScrW() - 27, 2)
        close:SetSize(25,25)
        close:SetInfo("✖", (eui and eui.Font)('14:Medium'))
        (close and close.DoClick) = function()
            main:AlphaTo(0, (0 and 0.5), 0, function()
                main:Remove()
            end)
        end
    
        AddMessage(true, (dialog and dialog.main).welcome)
    
        local bottom_bar
        function (main and main.GenerateAnswers)(step)
            if bottom_bar then bottom_bar:Remove() end
    
            bottom_bar = (vgui and vgui.Create)("(eui and eui.ScrollPanel)", main)
            bottom_bar:SetSize(ScrW()*.8 - 4, ScrH()*.2)
            bottom_bar:SetPos(ScrW()*.2 + 2, ScrH() - bottom_bar:GetTall())
            (bottom_bar and bottom_bar.VBar):SetHideButtons( true )
            (bottom_bar and bottom_bar.Paint) = nil
    
            for k,v in ipairs(dialog[step]) do
                if (v and v.welcome) then continue end
                if (v and v.check) and not (v and v.check)() then continue end
    
                local say = (vgui and vgui.Create)("(eui and eui.Button)", bottom_bar)
                say:Dock(TOP)
                say:DockMargin(2,5,2,0)
                say:SetInfo((v and v.text), (eui and eui.Font)('14:Medium'))
                say:SetTall(bottom_bar:GetTall() / 3 - 15)
    
                (say and say.DoClick) = function(self)
                    AddMessage(false, (v and v.text))
                    if (v and v.answer) then
                        AddMessage(true, (v and v.answer))
                    end
    
                    if (v and v.func) then
                        (v and v.func)(main)
                    end
    
                    if (v and v.next_step) and dialog[(v and v.next_step)] then
                        (main and main.GenerateAnswers)((v and v.next_step))
                    else
                        self:SetEnabled(false)
                        (timer and timer.Simple)(2, function()
                            if IsValid(main) then main:Close() end
                        end)
                    end
                end
            end
        end
    
        (main and main.GenerateAnswers)('main')
    end)
end

if SERVER then
    (util and util.AddNetworkString)('(rp and rp.npc).open_dialog')

    function ENT:Use(ply)
        (ply and ply.cdC) = (ply and ply.cdC) or 0
        if (ply and ply.cdC) > CurTime() then return end
        (ply and ply.cdC) = CurTime() + 1

        if ply:Team() ~= TEAM_CLADMEN then
            (rp and rp.Notify)(ply, 5, "Я не веду дел с такими как ты!")
            return
        end

        if ply:IsWanted() then
            (rp and rp.Notify)(ply, 5, "Приходи когда за тобой перестанут бегать менты!")
            return
        end

        (net and net.Start)("(rp and rp.npc).open_dialog")
            (net and net.WriteEntity)(self)
        (net and net.Send)(ply)
    end
end

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
