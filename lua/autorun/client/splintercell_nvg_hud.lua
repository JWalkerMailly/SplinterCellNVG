
-- This acts like a static class.
SPLINTERCELL_NVG_GOGGLES = {};
SPLINTERCELL_NVG_GOGGLES.SoundsCacheReady = false;

-- Toggle flags use to switch animation states.
SPLINTERCELL_NVG_GOGGLES.Toggled = nil;
SPLINTERCELL_NVG_GOGGLES.ToggledSound = false;

-- State vars for rendering and cleanup.
SPLINTERCELL_NVG_GOGGLES.CurrentGoggles = nil;
SPLINTERCELL_NVG_GOGGLES.ShouldCleanupMaterials = false;

-- Used to handle transition and blending. NextTransition
-- is only used to delay the screenspace effects and overlays.
SPLINTERCELL_NVG_GOGGLES.Transition = 0;
SPLINTERCELL_NVG_GOGGLES.NextTransition = 0;
SPLINTERCELL_NVG_GOGGLES.ScreenspaceReady = false;

local __RenderTarget = Material("pp/colour");
local __TransitionRate = 5;
local __TransitionDelay = 0.225;

local nvgVignette = Material("vgui/splinter_cell/overlay_vignette");
local nvgOverlayAnim = Material("vgui/splinter_cell/nvg_turnon_static");

--!
--! @brief      Utility function to cleanup goggle model material overrides.
--!             If you are modifying the material of a model in your goggle draw hook,
--!             you must raise the flag SPLINTERCELL_NVG_MATERIALOVERRIDE on it for
--!             it to be processed in this hook since we don't want to break other addons.
--!
function SPLINTERCELL_NVG_GOGGLES:CleanupMaterials()

	-- Do nothing if no cleanup is required.
	if (!self.ShouldCleanupMaterials) then return; end

	-- Reset entity material.
	for k,v in pairs(ents.GetAll()) do

		if (!v.SPLINTERCELL_NVG_MATERIALOVERRIDE) then continue; end

		v:SetMaterial(v:GetMaterial());
		v.SPLINTERCELL_NVG_MATERIALOVERRIDE = false;
	end

	-- Cleanup finished, reset flag to avoid using unnecessary CPU time.
	self.ShouldCleanupMaterials = false;
end

--!
--! @brief      Utility function to handle model material override when using a goggle.
--!             It works by using the filter function found in the goggle's config
--!             to determine if the entity should receive the material. We also raise a flag on the
--!             entity for eventual cleanup. This way we'll only use CPU time when necessary.
--!
--! @param      goggle  The goggle config being processed.
--!
function SPLINTERCELL_NVG_GOGGLES:HandleMaterialOverrides(goggle)

	for k,v in pairs(ents.GetAll()) do

		-- Do nothing if the entity does not pass the filter.
		if (!goggle.Filter(v)) then continue; end

		v:SetMaterial(goggle.MaterialOverride);
		v.SPLINTERCELL_NVG_MATERIALOVERRIDE = true;
	end

	-- Raise the cleanup flag for later use.
	SPLINTERCELL_NVG_GOGGLES.ShouldCleanupMaterials = true;
end

--!
--! @brief      Used to render the lens transitioning in view.
--!
function SPLINTERCELL_NVG_GOGGLES:TransitionIn()

	-- Render lens coming in.
	self.Transition = Lerp(FrameTime() * __TransitionRate, self.Transition, 2);

	local transition = math.Clamp(self.Transition, 0, 1);
	if (transition < 0.9) then
		surface.SetMaterial(nvgOverlayAnim);
		surface.SetDrawColor(255, 255, 255, transition * 255);
		surface.DrawTexturedRect(0, -ScrH() + (ScrH() * 1.3 * transition), ScrW(), ScrH());
	end
end

--!
--! @brief      Used to render the lens transitioning out of view.
--!
function SPLINTERCELL_NVG_GOGGLES:TransitionOut()

	-- Render lens going out.
	self.Transition = Lerp(FrameTime() * __TransitionRate, self.Transition, 0);

	local transition = math.Clamp(self.Transition - 1, 0, 1);
	if (transition > 0.1) then
		surface.SetMaterial(nvgOverlayAnim);
		surface.SetDrawColor(255, 255, 255, transition * 255);
		surface.DrawTexturedRect(0, -ScrH() + (ScrH() * 1.3 * transition), ScrW(), ScrH());
	end
end

--!
--! @brief      Renders the overlay effect for vignette and animated lens.
--!
function SPLINTERCELL_NVG_GOGGLES:DrawOverlay(overlay, swap)

	local transition = math.Clamp(self.Transition - 1, 0, 1);

	-- Vignetting effect.
	if (!swap) then
		surface.SetMaterial(nvgVignette);
		surface.SetDrawColor(255, 255, 255, transition * 255);
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH());
	end

	-- Animated overlay texture.
	surface.SetMaterial(overlay);
	surface.SetDrawColor(255, 255, 255, transition * 255);
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH());

	-- Vignetting effect.
	if (swap) then
		surface.SetMaterial(nvgVignette);
		surface.SetDrawColor(255, 255, 255, transition * 255);
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH());
	end
end

--!
--! @brief      Creates a sound cache client side to handle looping sounds for
--!             all goggle types. Each sound will be a CSoundPatch. 
--!
function SPLINTERCELL_NVG_GOGGLES:SetupLoopingSounds()

	if (self.SoundsCacheReady) then return; end

	-- Initialize looping sound cache, this 
	for k,v in pairs(SPLINTERCELL_NVG_CONFIG) do
		if (v.SoundsCache == nil) then v.SoundsCache = {}; end
		if (v.Sounds.Loop == nil) then continue; end
		v.SoundsCache["Loop"] = CreateSound(LocalPlayer(), Sound(v.Sounds.Loop));
	end

	self.SoundsCacheReady = true;
end

function SPLINTERCELL_NVG_GOGGLES:PlayLoopingSound(config, fadeIn)

	if (config.SoundsCache != nil && config.SoundsCache["Loop"] != nil) then
		config.SoundsCache["Loop"]:Play();
		config.SoundsCache["Loop"]:ChangeVolume(0);
		config.SoundsCache["Loop"]:ChangeVolume(1, fadeIn);
	end
end

function SPLINTERCELL_NVG_GOGGLES:StopLoopingSound(config, fadeOut)

	if (config.SoundsCache != nil && config.SoundsCache["Loop"] != nil) then
		config.SoundsCache["Loop"]:FadeOut(fadeOut)
	end
end

--!
--! @brief      Sets up rendering space quad on top of the screen for the current goggle.
--!             This will copy the postprocessing color texture for upcoming render operations.
--!
--! @param      config  The current goggle configuration.
--!
function SPLINTERCELL_NVG_GOGGLES:Render(config)

	-- Setup lighting from configuration.
	local lighting    = config.Lighting;
	local dlight      = DynamicLight(LocalPlayer():EntIndex());
	dlight.r          = lighting.Color.r;
	dlight.g          = lighting.Color.g;
	dlight.b          = lighting.Color.b;
	dlight.minlight   = lighting.Min;
	dlight.style      = lighting.Style;
	dlight.Brightness = lighting.Brightness;
	dlight.Pos        = EyePos();
	dlight.Size       = lighting.Size;
	dlight.Decay      = lighting.Decay;
	dlight.DieTime    = CurTime() + lighting.DieTime;

	-- Offload to rendertarget.
	render.UpdateScreenEffectTexture();

		local colorCorrect = config.ColorCorrection;
		__RenderTarget:SetTexture("$fbtexture",          render.GetScreenEffectTexture());
		__RenderTarget:SetFloat("$pp_colour_addr",       colorCorrect.ColorAdd.r);
		__RenderTarget:SetFloat("$pp_colour_addg",       colorCorrect.ColorAdd.g);
		__RenderTarget:SetFloat("$pp_colour_addb",       colorCorrect.ColorAdd.b);
		__RenderTarget:SetFloat("$pp_colour_mulr",       colorCorrect.ColorMul.r);
		__RenderTarget:SetFloat("$pp_colour_mulg",       colorCorrect.ColorMul.g);
		__RenderTarget:SetFloat("$pp_colour_mulb",       colorCorrect.ColorMul.b);
		__RenderTarget:SetFloat("$pp_colour_brightness", colorCorrect.Brightness);
		__RenderTarget:SetFloat("$pp_colour_contrast",   colorCorrect.Contrast);
		__RenderTarget:SetFloat("$pp_colour_colour",     colorCorrect.ColorMod);

	render.SetMaterial(__RenderTarget);
	render.DrawScreenQuad();

	-- Render interlace material over screen, if provided.
	if (config.MaterialInterlace != nil) then
		local interlaceColor = config.InterlaceColor;
		surface.SetMaterial(config.MaterialInterlace);
		surface.SetDrawColor(interlaceColor.r, interlaceColor.g, interlaceColor.b, interlaceColor.a);
		surface.DrawTexturedRect(0 + math.Rand(-1,1), 0 + math.Rand(-1,1), ScrW(), ScrH());
	end
end

--! 
--! Goggle screenspace rendering hook.
--!
hook.Add("RenderScreenspaceEffects", "SPLINTERCELL_NVG_SHADER", function()

	-- This is the autoload logic for the network var. Network vars will be handled serverside.
	local currentGoggle = LocalPlayer():GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 0);
	if (currentGoggle == 0) then return; end

	-- Render post processing effects for current goggles.
	if (SPLINTERCELL_NVG_GOGGLES.ScreenspaceReady) then
		SPLINTERCELL_NVG_CONFIG[currentGoggle].PostProcess();
	end
end);

--! 
--! Draw hook entry point for all goggles. This will use the network var currently set on the player
--! to determine which goggle to use.
--!
hook.Add("PreDrawHUD", "SPLINTERCELL_NVG_HUD", function()

	-- Initializes the looping sound cache.
	SPLINTERCELL_NVG_GOGGLES:SetupLoopingSounds();

	-- This is the autoload logic for the network var. Network vars will be handled serverside.
	local currentGoggle = LocalPlayer():GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 0);
	if (currentGoggle == 0) then return; end

	-- This is gets clientside to handle animations and sounds.
	local toggle = GetConVar("SPLINTERCELL_NVG_TOGGLE"):GetBool();
	if (SPLINTERCELL_NVG_GOGGLES.Toggled == nil) then
		SPLINTERCELL_NVG_GOGGLES.Toggled = toggle;
		SPLINTERCELL_NVG_GOGGLES.CurrentGoggles = currentGoggle;
	end

	cam.Start2D();

		-- Delegate call to the configuration file for which goggle to render.
		local currentConfig = SPLINTERCELL_NVG_CONFIG[currentGoggle];
		if (toggle) then

			SPLINTERCELL_NVG_GOGGLES:TransitionIn(nvgOverlayAnim);

			-- Play the toggle sound specific to the goggles.
			if (!SPLINTERCELL_NVG_GOGGLES.Toggled) then
				SPLINTERCELL_NVG_GOGGLES.NextTransition = CurTime() + __TransitionDelay;
				SPLINTERCELL_NVG_GOGGLES.Toggled = true;
			end

			-- Goggles don't match with the cache, use must've switched goggles.
			if (currentGoggle != SPLINTERCELL_NVG_GOGGLES.CurrentGoggles) then

				-- Stop looping sound of previous goggles and cleanup materials.
				local previousConfig = SPLINTERCELL_NVG_CONFIG[SPLINTERCELL_NVG_GOGGLES.CurrentGoggles];
				SPLINTERCELL_NVG_GOGGLES:CleanupMaterials();
				SPLINTERCELL_NVG_GOGGLES:StopLoopingSound(previousConfig, 0.5);

				-- Play goggle mode switch sound only clientside and start looping sound.
				SPLINTERCELL_NVG_GOGGLES.CurrentGoggles = currentGoggle;
				SPLINTERCELL_NVG_GOGGLES:PlayLoopingSound(currentConfig, 1.5);
				surface.PlaySound("splinter_cell/goggles/standard/goggles_mode.wav");
			end

			if (CurTime() > SPLINTERCELL_NVG_GOGGLES.NextTransition) then

				-- Render screen space effects of current config.
				SPLINTERCELL_NVG_GOGGLES.ScreenspaceReady = true;
				SPLINTERCELL_NVG_GOGGLES:Render(currentConfig);

				-- Handle material overrides for the goggle being used.
				if (currentConfig.Filter != nil) then
					SPLINTERCELL_NVG_GOGGLES:HandleMaterialOverrides(currentConfig);
				end

				-- Play activate sound on client only after delay expired and start looping sound.
				if (!SPLINTERCELL_NVG_GOGGLES.ToggledSound) then
					SPLINTERCELL_NVG_GOGGLES.ToggledSound = true;
					SPLINTERCELL_NVG_GOGGLES:PlayLoopingSound(currentConfig, 1.5);
					surface.PlaySound(currentConfig.Sounds.Activate);
				end
			end
		else

			-- Transition lens out.
			SPLINTERCELL_NVG_GOGGLES:TransitionOut(nvgOverlayAnim);

			-- Reset defaults for next toggle.
			SPLINTERCELL_NVG_GOGGLES.Toggled = false;
			SPLINTERCELL_NVG_GOGGLES.ToggledSound = false;
			SPLINTERCELL_NVG_GOGGLES.ScreenspaceReady = false;

			-- Restore default materials on entities.
			SPLINTERCELL_NVG_GOGGLES:CleanupMaterials();
			SPLINTERCELL_NVG_GOGGLES:StopLoopingSound(currentConfig, 0);
		end

		-- This is always called but will not interfere with other addons.
		SPLINTERCELL_NVG_GOGGLES:DrawOverlay(currentConfig.MaterialOverlay, currentConfig.OverlayFirst);
	cam.End2D();
end);