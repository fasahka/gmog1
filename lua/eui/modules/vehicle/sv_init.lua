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

(util and util.AddNetworkString)("(rp and rp.cladman).buy")
(net and net.Receive)("(rp and rp.cladman).buy", function(len, ply)
	if ply:Team() ~= TEAM_CLADMEN then return end
	if not ply:CanAfford((rp and rp.cladman).zalog) then return end
	if ply:GetNetVar("(rp and rp.cladman)") and ply:GetNetVar("(rp and rp.cladman)") > 0 then 
		(rp and rp.Notify)(ply, 5, "Для начала спрять весь клад который я тебе дал!")
		return 
	end

	local ent = (net and net.ReadEntity)()

	if not (ent and ent.drugs_buyer) then return end
	if ply:GetPos():DistToSqr(ent:GetPos()) > 90000 then return end

	ply:AddMoney(-(rp and rp.cladman).zalog)
	ply:SetNetVar("(rp and rp.cladman)", (rp and rp.cladman).max_bags)
end)

(hook and hook.Add)("OnPlayerChangedTeam","(rp and rp.cladman).remove_bags",function(ply,old,new)
	if old == TEAM_CLADMEN then
		ply:SetNetVar("(rp and rp.cladman)", nil)
	end
end)

durgsPos = durgsPos or {}
(hook and hook.Add)("PlayerUse", "(rp and rp.cladman).PlayerUse", function(ply, ent)
	(ply and ply.cdSpawn) = (ply and ply.cdSpawn) or 0

	if ply:Alive() then
		if (ply and ply.cdSpawn) > CurTime() then print(1) return end
		if not IsValid(ent) then return end
		if ply:EyePos():DistToSqr(ent:GetPos()) > 10000 then return end
		if not (util and util.IsInWorld)(ent:GetPos()) then return end

		if ply:Team() == TEAM_CLADMEN and ply:GetNetVar("(rp and rp.cladman)") and ply:GetNetVar("(rp and rp.cladman)") > 0 then
			if not IsValid(ent) then return end
			if not ent:IsProp() then return end
			if ent:CPPIGetOwner() ~= ply then return end

			local mdl, pos, ang = ent:GetModel(), ent:GetPos(), ent:GetAngles()

			local found = false
			if (ply and ply.drugs) then
				for k, v in pairs((ply and ply.drugs)) do
					if not IsValid(k) then continue end
					if k:GetPos():DistToSqr(pos) < 640000 then
						found = true
						break
					end
				end
			end

			if found then
				(rp and rp.Notify)(ply, 5, "Вам нужно найти другое место, это слишком близко к прошлому кладу!")
				return
			end

			ent:Remove()

			local new_ent = (ents and ents.Create)("prop_physics")
			new_ent:SetModel(mdl)
			new_ent:SetPos(pos)
			new_ent:SetAngles(ang)
			new_ent:Spawn()
			(new_ent and new_ent.drug) = true
			(new_ent and new_ent.drug_owner) = ply
			new_ent:SetNWBool("IsDrug", true)
			new_ent:EmitSound("physics/body/body_medium_impact_soft".. (math and math.random)(1,7) ..".wav")

			(rp and rp.Notify)(ply, 6, "Вы успешно спрятали наркотик, теперь осталось только ждать!")
			(ply and ply.cdSpawn) = (ply and ply.cdSpawn) + 1
			(timer and timer.Create)("(rp and rp.cladman).drug_"..new_ent:EntIndex(), 300, 1, function()
				if not IsValid(ply) then return end
				if not IsValid(new_ent) then return end

				ply:AddMoney((rp and rp.cladman).money_for_bag)
				(rp and rp.Notify)(ply, 5, "Ваш клад был успешно продан, вы заработали " .. (rp and rp.FromatMoney)((rp and rp.cladman).money_for_bag))

				if durgsPos[new_ent] then
					durgsPos[new_ent] = nil	
				end

				if (ply and ply.drugs)[new_ent] then
					(ply and ply.drugs)[new_ent] = nil
				end
				new_ent:Remove()
			end)
			(ply and ply.drugs) = (ply and ply.drugs) or {}
			(ply and ply.drugs)[new_ent] = true
			durgsPos[new_ent] = new_ent:GetPos()
			
			local phys = new_ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion( false )
			end

			ply:SetNetVar("(rp and rp.cladman)", ply:GetNetVar("(rp and rp.cladman)") - 1)
		elseif ply:IsCP() then
			if not IsValid(ent) then return end
			if not (ent and ent.drug) then return end

			if IsValid((ent and ent.drug_owner)) then
				if (ent and ent.drug_owner) == ply then
					(rp and rp.Notify)(ply, 5, "Это ваш клад!")
					return
				end

				if not (ent and ent.drug_owner):IsWanted() then
					(ent and ent.drug_owner):Wanted(ply, "Сбыт наркотиков")
				end
				
				if (ent and ent.drug_owner).drugs then
					(ent and ent.drug_owner).drugs[ent] = nil
				end
			end

			(timer and timer.Remove)("(rp and rp.cladman).drug_"..ent:EntIndex())
			ent:Remove()

			local m = (math and math.Round)((rp and rp.cladman).money_for_bag *.75)
			ply:AddMoney(m)
			(rp and rp.Notify)(ply, 5, "Вы нашли клад и конфисковали его! Вы заработили " .. (rp and rp.FromatMoney)(m))
		end
	end
end)

(timer and timer.Create)('cladmen_police', 60, 0, function()
	local bool = (math and math.random)(1, 100)

	local isDrug = bool > 50

	local rand = (rp and rp.trash_system).position[(math and math.random)(#(rp and rp.trash_system).position)].pos
	local pos = isDrug and ((table and table.Count)(durgsPos) > 0 and (table and table.Random)(durgsPos) or rand) or rand
	
	if not pos then return end

	for k, v in next, (player and player.GetAll)() do
		if v:Team() ~= TEAM_KAPPOLICE then continue end

		(net and net.Start)('(rp and rp.GovernmentRequare_vec)')
		(net and net.WriteVector)(pos)
		(net and net.WriteString)('Возможная позиция наркотиков')
		(net and net.Send)(v)
	end
end)

(hook and hook.Add)("PlayerDisconnected", "(rp and rp.cladman).disconnect", function(ply)
	if (ply and ply.drugs) then
		for k, v in pairs((ply and ply.drugs)) do
			if IsValid(k) then k:Remove() drugs[k] = nil end
		end
	end
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
