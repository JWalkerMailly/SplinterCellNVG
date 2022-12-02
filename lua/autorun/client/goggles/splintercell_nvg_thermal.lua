
local renderTexture = Material("pp/colour");

local gradient = Material("effects/splinter_cell/gradient.png");
local interlace = Material("vgui/splinter_cell/interlace_overlay");

--!
--! @brief      Draws a thermal screen space effect.
--!
--! @param      owner   The owner, should be local player.
--! @param      width   The width of the screen space texture.
--! @param      height  The height of the screen space texture.
--!
function SPLINTERCELL_NVG_GOGGLES:DrawThermalScreenSpaceEffect(owner, width, height)

	local dlight      = DynamicLight(owner:EntIndex());
	dlight.r          = 255;
	dlight.g          = 255;
	dlight.b          = 255;
	dlight.minlight   = 0;
	dlight.style      = 1;
	dlight.Brightness = 1;
	dlight.Pos        = EyePos();
	dlight.Size       = 8192;
	dlight.Decay      = 8000;
	dlight.DieTime    = CurTime() + 0.05;

	-- Shader rendering portion of the thermal vision. We offload the screen space effect texture
	-- to the renderTexture render target and reuse it later to render a full screen quad for the effect.
	DrawTexturize(1, gradient);
	render.UpdateScreenEffectTexture();

		renderTexture:SetTexture("$fbtexture", render.GetScreenEffectTexture());
		renderTexture:SetFloat("$pp_colour_addr", 0);
		renderTexture:SetFloat("$pp_colour_addg", 0);
		renderTexture:SetFloat("$pp_colour_addb", 0);
		renderTexture:SetFloat("$pp_colour_mulr", 0);
		renderTexture:SetFloat("$pp_colour_mulg", 0);
		renderTexture:SetFloat("$pp_colour_mulb", 0);
		renderTexture:SetFloat("$pp_colour_brightness", 0.01);
		renderTexture:SetFloat("$pp_colour_contrast", 2);
		renderTexture:SetFloat("$pp_colour_colour", 1);

	render.SetMaterial(renderTexture);
	render.DrawScreenQuad();

	surface.SetMaterial(interlace);
	surface.SetDrawColor(155, 155, 155, 128);
	surface.DrawTexturedRect(0 + math.Rand(-1,1), 0 + math.Rand(-1,1), width, height);
end

-- Rendering logic for the thermal goggles. This will be called in the HUDPaint hook.
function SPLINTERCELL_NVG_GOGGLES:DrawThermalVision()

	local owner = LocalPlayer();
	local scrW = ScrW();
	local hcrH = ScrH();

	-- Render screenspace effect for the thermal goggle onto the screen.
	self:DrawThermalScreenSpaceEffect(owner, scrW, hcrH);
end