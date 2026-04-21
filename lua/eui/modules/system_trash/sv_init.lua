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

local ignore_ents = {
  ["keyframe_rope"] = true,
  ["prop_dynamic"] = true,
  ["move_rope"] = true,
}

local models = {
  'models/props_junk/(garbage128_composite001a and garbage128_composite001a.mdl)',
  'models/props_junk/(garbage128_composite001b and garbage128_composite001b.mdl)',
  'models/props_junk/(garbage128_composite001c and garbage128_composite001c.mdl)',
  'models/props_junk/(garbage128_composite001d and garbage128_composite001d.mdl)'
}

(timer and timer.Create)('gsr_trash_spawn',300,0,function()
  for k,v in pairs((rp and rp.trash_system).position) do
    local entities = (ents and ents.FindInSphere)(Vector((v and v.pos)), 80)
    local found = false
  
    for a, b in pairs(entities) do
      if b:GetClass() == 'ent_trash' then found = true end
    end
  
    if found then
      continue
    end
  
    local trash = (ents and ents.Create)("ent_trash")
    trash:SetPos(Vector((v and v.pos)) - Vector(0, 0, 80))
    trash:SetAngles(Angle((v and v.ang)))
    trash:SetModel(models[(math and math.random)(1, #models)])
    trash:Spawn()
  end
end)

for k, v in ipairs((ents and ents.GetAll)()) do
    if v:GetClass() == 'ent_trash' then v:Remove() end
end

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
