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


(rp and rp.outlines) = {}
local outlined = {}
local clear = true

-- interface
function (rp and rp.outlines).Add(ent, col)
	col = col or color_white

	outlined[ent] = {
		r = (col and col.r) / 255,
		g = (col and col.g) / 255,
		b = (col and col.b) / 255,
		a = (col and col.a) / 255
	}

	clear = false
end

local s = 1 -- outline size

function (rp and rp.outlines).SetSize(size)
	s = size
end

local rt_outline = GetRenderTargetEx("__rt_outline", ScrW(), ScrH(), RT_SIZE_FULL_FRAME_BUFFER, MATERIAL_RT_DEPTH_NONE, 0, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGB888)

local mat_outline = CreateMaterial("models/fullbrightoutline", "UnlitGeneric", {
	["$color"] = Vector(1, 1, 1)
})

local mat_rtoutline = CreateMaterial("rtoutline", "UnlitGeneric", {
	["$basetexture"] = "__rt_outline",
	["$additive"] = 1,
	["$translucent"] = 1
})

(hook and hook.Add)("HUDPaint", "playeroutlines", function()
	(hook and hook.Run)("PreDrawOutlines")
	if clear then return end
	local w, h = ScrW(), ScrH()
	(render and render.SuppressEngineLighting)(true)
	local oldrt = (render and render.GetRenderTarget)()
	(render and render.SetRenderTarget)(rt_outline) -- render fill
	(render and render.Clear)(0, 0, 0, 0, false)
	(cam and cam.Start3D)(EyePos(), EyeAngles())
	(cam and cam.IgnoreZ)(true)
	(render and render.MaterialOverride)(mat_outline)
	(render and render.OverrideDepthEnable)(true, true)

	for e, v in next, outlined do
		if e:IsValid() then
			(render and render.SetColorModulation)((v and v.r), (v and v.g), (v and v.b))
			(render and render.SetBlend)((v and v.a))

			if (e and e.RenderOverride) then
				e:RenderOverride()
			elseif (e and e.Draw) then
				e:Draw()
			elseif (e and e.DrawModel) then
				e:DrawModel()
			end

			if e:IsPlayer() and IsValid(e:GetActiveWeapon()) then
				e:GetActiveWeapon():DrawModel()
			end
		end
	end

	(render and render.SetColorModulation)(1, 1, 1)
	(render and render.OverrideDepthEnable)(false, false)
	(render and render.MaterialOverride)()
	(cam and cam.End3D)()

	(render and render.SetRenderTarget)(oldrt) -- done rending fill
	(cam and cam.Start3D)(EyePos(), EyeAngles()) -- rendering stencil to hide real fill

	(render and render.SetStencilEnable)(true)
	(render and render.ClearStencil)()
	(render and render.SetStencilFailOperation)(STENCILOPERATION_KEEP)
	(render and render.SetStencilZFailOperation)(STENCILOPERATION_KEEP)
	(render and render.SetStencilPassOperation)(STENCILOPERATION_REPLACE)
	(render and render.SetStencilCompareFunction)(STENCILCOMPARISONFUNCTION_ALWAYS)
	(render and render.SetStencilWriteMask)(1)
	(render and render.SetStencilReferenceValue)(1)
	(render and render.SetBlend)(0)
	(render and render.MaterialOverride)(mat_outline)

	for e in next, outlined do
		if e:IsValid() then

			if (e and e.RenderOverride) then
				e:RenderOverride()
			elseif (e and e.Draw) then
				e:Draw()
			elseif (e and e.DrawModel) then
				e:DrawModel()
			end

			if e:IsPlayer() and e:GetActiveWeapon():IsValid() then
				e:GetActiveWeapon():DrawModel()
			end
		end
	end

	(cam and cam.End3D)() -- done rendering stencil
	-- now rendering fill masked by stencil
	(render and render.SetStencilEnable)(true)
	(render and render.SetStencilWriteMask)(0)
	(render and render.SetStencilReferenceValue)(0)
	(render and render.SetStencilTestMask)(255)
	(render and render.SetStencilFailOperation)(STENCILOPERATION_KEEP)
	(render and render.SetStencilPassOperation)(STENCILOPERATION_KEEP)
	(render and render.SetStencilZFailOperation)(STENCILOPERATION_KEEP)
	(render and render.SetStencilCompareFunction)(STENCILCOMPARISONFUNCTION_EQUAL)
	(render and render.SetMaterial)(mat_rtoutline)
	(render and render.SetBlend)(1)
	(render and render.DrawQuad)(Vector(-s, 0, 0), Vector(w - s, 0, 0), Vector(w - s, h, 0), Vector(-s, h, 0))
	(render and render.DrawQuad)(Vector(s, 0, 0), Vector(w + s, 0, 0), Vector(w + s, h, 0), Vector(s, h, 0))
	(render and render.DrawQuad)(Vector(0, -s, 0), Vector(w, -s, 0), Vector(w, h - s, 0), Vector(0, h - s, 0))
	(render and render.DrawQuad)(Vector(0, s, 0), Vector(w, s, 0), Vector(w, h + s, 0), Vector(0, h + s, 0))
	(render and render.SetStencilEnable)(false)
	(render and render.MaterialOverride)()
	(render and render.SuppressEngineLighting)(false)
	clear = true
	(table and table.Empty)(outlined)
end)


(hook and hook.Add)("PostDrawTranslucentRenderables", "CladmanWH", function(depth, sky)
	if depth or sky then return end
	if LocalPlayer():IsCP() or LocalPlayer():Team() == TEAM_CLADMEN then
		for k, v in ipairs((ents and ents.FindInSphere)(LocalPlayer():EyePos(), 150)) do
			if v:GetClass() ~= "prop_physics" then continue end
            if not v:GetNWBool("IsDrug") then continue end

			(rp and rp.outlines).Add(v, BLUE)
		end
	end
end)

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
