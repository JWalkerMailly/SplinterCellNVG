
local renderTexture = Material("pp/colour");

local gradient = Material("effects/splinter_cell/emp.png");
local interlace = Material("vgui/splinter_cell/interlace_overlay");

function SPLINTERCELL_NVG_GOGGLES:DrawTestScreenSpaceEffect(owner, width, height)

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

function SPLINTERCELL_NVG_GOGGLES:DrawTestVision()

	local owner = LocalPlayer();
	local scrW = ScrW();
	local hcrH = ScrH();

	self:DrawTestScreenSpaceEffect(owner, scrW, hcrH);
end