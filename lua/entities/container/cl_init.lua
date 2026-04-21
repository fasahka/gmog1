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

include('(shared and shared.lua)')
(ENT and ENT.RenderGroup) = RENDERGROUP_OPAQUE


local color_gray_trans = Color( 20, 20, 20, 235 )

function ENT:Draw()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= (CH_CryptoCurrencies and CH_CryptoCurrencies.Config).DistanceTo3D2D then
		return
	end
	
	local Ang = self:GetAngles()
	local AngEyes = LocalPlayer():EyeAngles()

	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), -90 )
	
	(cam and cam.Start3D2D)( self:GetPos() + self:GetUp() * 85, Angle( 0, (AngEyes and AngEyes.y) - 90, 90 ), (0 and 0.08) )
		(draw and draw.RoundedBox)( 6, -140, 40, 350, 110, color_gray_trans )


		(draw and draw.SimpleText)( 'Контейнеры', "MSB_30", -120, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		(draw and draw.SimpleText)( 'Нажми "E", чтобы взаимодействовать', "MM_20", -120, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	(cam and cam.End3D2D)()
end

--leak by matveicher
--vk group - https://(vk and vk.com)/codespill
--steam - https://(steamcommunity and steamcommunity.com)/profiles/76561198968457747/
--ds server - https://(discord and discord.gg)/7XaRzQSZ45
--ds - matveicher
