
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Base = "astw2_base"

SWEP.PrintName = "OrgSen Goggles"
SWEP.Category = "ASTW2 - Brute Force DLC"
SWEP.Slot = 4
SWEP.Author = "Dopey"
SWEP.Contact = "/id/ArcticWinterZzZ/"
SWEP.Purpose = "These goggles give all characters Thermal vision."
SWEP.Instructions = "Equip for Thermal vision."

if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID( "vgui/brute_force/org_sensor" )
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false
killicon.Add( "astw2_bf_org_sensor", "vgui/brute_force/org_sensor", Color( 255, 255, 255, 255 ) )
end

SWEP.ViewModel = nil
SWEP.WorldModel = "models/weapons/brute_force/orgsen.mdl"

SWEP.Primary.Damage = 12
SWEP.Primary.Delay = 1
SWEP.Primary.Acc = 1 / 55
SWEP.Primary.Recoil = 350
SWEP.Primary.RecoilAcc = 100
SWEP.Primary.Num = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.ClipSize = -1

SWEP.Sound = ""
SWEP.Sound_Vol = 75
SWEP.Sound_Pitch = 100
SWEP.Melee = false
SWEP.NPCUnusable = true
SWEP.NoCrosshair = true
SWEP.UniqueFiremode = "CBRN"
SWEP.InfAmmo = true
SWEP.SpeedMult = 1
SWEP.Secondary.Ammo = nil
SWEP.IgnoreSpeedMult = true
SWEP.MagDrop = ""

SWEP.ReloadTime = 0
SWEP.CannotChamber = true
SWEP.Special = "detonator"

SWEP.CanRest = false
SWEP.IsGasMask = false
SWEP.Sound_Draw = "weapons/brute_force/orgsen_activate.wav"
SWEP.Sound_Holster = "weapons/brute_force/orgsen_deactivate.wav"
SWEP.HoldType_Lowered = "slam"
SWEP.HoldType_Aim = "slam"
SWEP.Anim_Shoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM
SWEP.NightScope = true
function SWEP:PrimaryAttack()
    return
end

function SWEP:OnHolster()
hook.Remove( "RenderScreenspaceEffects", "TexturizeShader") 
local targets = ents.FindInSphere(self:GetPos(), 9999999999)
        for _, k in pairs(targets) do
		local mat = k:GetMaterial()
            if k:IsPlayer() then
				k:SetMaterial(mat)
			else
		if k:IsNPC() or scripted_ents.IsBasedOn( k:GetClass(), "base_entity" ) then
		k:SetMaterial(mat)
				 end
		 if (k:IsValid() and scripted_ents.IsBasedOn( k:GetClass(), "base_nextbot" )) then
                    k:SetMaterial(mat)
                end
            end
        end
end



function SWEP:DrawHUD()

    if self:IsValid() then

        if self.HasVisibleLaser and !(GetConVar("astw2_hipfire_crosshair"):GetBool() and !self:GetNWBool( "insights" )) then
            local laser = self:GetHomingTrace()
            if laser.Hit then
                cam.Start3D() -- Start the 3D function so we can draw onto the screen.
                    render.SetMaterial( self.LaserTexture ) -- Tell render what material we want, in this case the flash from the gravgun
                    render.DrawSprite( laser.HitPos, math.random(40, 50), math.random(40, 50), Color(255, 255, 255) ) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
                cam.End3D()
            end
        end

        -- if self.Melee then return end
		local mat_color = Material( "pp/colour" )
		local mat_noise = Material( "effects/brute_force/interlace_overlay" )
		-- local mat_noise2 = Material( "effects/brute_force/noise" )
        local w = ScrW()
        local h = ScrH()

        if self.NightScope then
				local pattern = Material("effects/brute_force/gradient.png")
		hook.Add( "RenderScreenspaceEffects", "TexturizeShader", function()

			DrawTexturize( 1, pattern )

		end )
            local dlight = DynamicLight(self:EntIndex())
            dlight.r = 255
            dlight.g = 255
            dlight.b = 255
            dlight.minlight = 0
            dlight.style = 1
            dlight.Brightness = 1
            dlight.Pos = EyePos()
            dlight.Size = 8192
            dlight.Decay = 8000
            dlight.DieTime = CurTime() + 0.05

            render.UpdateScreenEffectTexture()

            mat_color:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

            mat_color:SetFloat( "$pp_colour_addr", 0 )
            mat_color:SetFloat( "$pp_colour_addg", 0 )
            mat_color:SetFloat( "$pp_colour_addb", 0 )
            mat_color:SetFloat( "$pp_colour_mulr", 0 )
            mat_color:SetFloat( "$pp_colour_mulg", 0 )
            mat_color:SetFloat( "$pp_colour_mulb", 0 )
            mat_color:SetFloat( "$pp_colour_brightness", 0.01 )
            mat_color:SetFloat( "$pp_colour_contrast", 2 )
            mat_color:SetFloat( "$pp_colour_colour", 1 )

            render.SetMaterial( mat_color )
            render.DrawScreenQuad()


			surface.SetMaterial( mat_noise )
            surface.SetDrawColor( 155, 155, 155, 128 )
            surface.DrawTexturedRect( 0 + math.Rand(-1,1), 0 + math.Rand(-1,1), w, h )

        end
		
		local targets = ents.FindInSphere(self:GetPos(), 2048)
        for _, k in pairs(targets) do
		local mat = k:GetMaterial()
		
            if k:IsPlayer() then
				k:SetMaterial("effects/brute_force/orgsen_overlay")
			else
		if k:IsNPC() or scripted_ents.IsBasedOn( k:GetClass(), "base_entity" ) then
		k:SetMaterial("effects/brute_force/orgsen_overlay")
				 end
		 if (k:IsValid() and scripted_ents.IsBasedOn( k:GetClass(), "base_nextbot" )) then
                    k:SetMaterial("effects/brute_force/orgsen_overlay")
                end
            end
        end

        local delta = CurTime() - self.LastRaiseTime
        delta = delta / self.DeployTime

        if GetConVar("astw2_hipfire_crosshair"):GetBool() then
            delta = 1
        end

        if GetConVar("astw2_blur"):GetBool() and !self.TrueScope then
            local height = Lerp( delta, 0, ScrH() / 4 )
            DrawToyTown(2, height)
        end

        local hit = util.TraceLine ({
            start = self:GetShootPosASTW(),
            endpos = self:GetShootPosASTW() + (LocalPlayer():EyeAngles() + self.Fire_AngleOffset):Forward() * 8196,
            filter = LocalPlayer(),
            mask = MASK_SHOT
        })

        if GetConVar("astw2_camera_truescopes"):GetBool() and self.TrueScope and !(GetConVar("astw2_hipfire_crosshair"):GetBool() and !self:GetNWBool( "insights" )) then
            local aimvector = Lerp(0.3, self.last_aimvector, LocalPlayer():GetAimVector())
            self.last_aimvector = aimvector
            local screenpos = (self:GetShootPosASTW() + aimvector * self.TrueScopeStab * 256):ToScreen()

            local x = screenpos.x
            local y = screenpos.y

            local scopesize = ScrH()
            if ScrW() < scopesize then
                scopesize = ScrW()
            end

            scopesize = math.ceil(Lerp( delta, 0, scopesize))

            local scopeposx = x - ( scopesize / 2 )
            local scopeposy = y - ( scopesize / 2 )

            if scopeposx > ScrW() or scopeposx < 0 - scopesize or scopeposy > ScrH() or scopeposy < 0 - scopesize then

                surface.SetDrawColor( 0, 0, 0 )

                surface.DrawRect( 0, 0, ScrW(), ScrH() )

            else

                surface.SetDrawColor( 0, 0, 0 )

                surface.DrawRect( scopeposx - ScrW(), scopeposy - ScrH(), 4 * ScrW(), ScrH() )
                surface.DrawRect( scopeposx - ScrW(), scopeposy + scopesize , 4 * ScrW(), ScrH() )

                surface.DrawRect( scopeposx - ScrW(), scopeposy - ScrH(), ScrW(), 4 * ScrH() )
                surface.DrawRect( scopeposx + scopesize, scopeposy - ScrH() , ScrW(), 4 * ScrH() )

                surface.SetDrawColor( 255, 255, 255 )

                surface.SetMaterial( self.TrueScopeImage )
                surface.DrawTexturedRect( scopeposx, scopeposy, scopesize, scopesize )

            end
        else
            if !GetConVar("astw2_crosshair_enable"):GetBool() or self.NoCrosshair or self.Owner:InVehicle() then return end

            local screenpos = hit.HitPos:ToScreen()

            local x = screenpos.x
            local y = screenpos.y
            local size = GetConVar("astw2_crosshair_size"):GetInt() * self.CrosshairSizeOverride

            local alpha = Lerp( delta, 0, 255 )

            local image = GetConVar("astw2_crosshair_image"):GetString()

            if (self.Projectile or self.Primary.Num > 1) and (!GetConVar("astw2_crosshair_nocircle"):GetBool() and !(self:GetNWBool("insights", false) and self.Special == "ubgl")) then
                image = "crosshairs/circle.png"
            end

            if self.CrosshairOverride then
                image = self.CrosshairOverride
            end

            if image != lastcrossimage then
                lastcrossimage = image
                lastcrossmat = Material(lastcrossimage)
            end

            surface.SetMaterial( lastcrossmat )

            local r = GetConVar("astw2_crosshair_r"):GetInt()
            local g = GetConVar("astw2_crosshair_g"):GetInt()
            local b = GetConVar("astw2_crosshair_b"):GetInt()

            local a_r = GetConVar("astw2_crosshair_aim_r"):GetInt()
            local a_g = GetConVar("astw2_crosshair_aim_g"):GetInt()
            local a_b = GetConVar("astw2_crosshair_aim_b"):GetInt()

            local color = Color( r, g, b, alpha )

			
		-- astw2_crosshair.vehicles = {
			-- "npc_iv04_hce_marine",
			-- "npc_iv04_hcea_marine"
    -- }
			
		
            if hit.Entity:IsNPC() or (hit.Entity:IsValid() and scripted_ents.IsBasedOn( hit.Entity:GetClass(), "base_nextbot" )) then
                color = Color( a_r, a_g, a_b, alpha )
            end
		
		 if (hit.Entity:IsPlayer() and hit.Entity:IsValid()) then
			local class = hit.Entity:GetClass()
			local isplayer = hit.Entity:IsPlayer()
			local team, selfteam
					if isplayer then
						selfteam = self.Owner:Team()
						team = hit.Entity:Team()
					end
				if ( isplayer && selfteam ~= team ) then
					color = Color( a_r, a_g, a_b, alpha )
				elseif (isplayer && selfteam == team ) then
					color = Color( 0, 255, 0, alpha )
				else
					
					color = Color( 255, 250, 200 )
				end
		end
			
	     if (hit.Entity:IsValid() and scripted_ents.IsBasedOn( hit.Entity:GetClass(), "base_nextbot" )) and (hit.Entity.FriendlyToPlayers) then
                color = Color( 0, 255, 0, alpha )
            end
			
	    if hit.Entity:IsValid() and (hit.Entity:IsVehicle() or hit.Entity:GetClass() == "sl_gow_mech" or scripted_ents.IsBasedOn( hit.Entity:GetClass(), "gow_sentinel_base" ) or scripted_ents.IsBasedOn( hit.Entity:GetClass(), "gow_sentinel_base" )) then
                color = Color( 0, 0, 255, alpha )
            end 
	
			
	    if hit.Entity:IsValid() and hit.Entity:IsWeapon() then
                color = Color( 255, 255, 0, alpha )
            end

            surface.SetDrawColor( color )

            surface.DrawTexturedRect( x - (size / 2), y - (size / 2), size, size )

        end
	

		
	else
	-- hook.Remove( "RenderScreenspaceEffects", "TexturizeShader")
	local targets = ents.FindInSphere(self:GetPos(), 9999999999)
        for _, k in pairs(targets) do
		local mat = k:GetMaterial()
            if k:IsPlayer() then
				k:SetMaterial(mat)
			else
		if k:IsNPC() or scripted_ents.IsBasedOn( k:GetClass(), "base_entity" ) then
		k:SetMaterial(mat)
				 end
		 if (k:IsValid() and scripted_ents.IsBasedOn( k:GetClass(), "base_nextbot" )) then
                    k:SetMaterial(mat)
                end
            end
        end

    end

    self:OnDrawHUD()
	hook.Remove( "RenderScreenspaceEffects", "TexturizeShader") 
end