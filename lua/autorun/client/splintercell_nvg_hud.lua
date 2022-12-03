
if (SERVER) then
	AddCSLuaFile("goggles/splintercell_nvg_test.lua");
	AddCSLuaFile("goggles/splintercell_nvg_thermal.lua");
	AddCSLuaFile("goggles/splintercell_nvg_sonar.lua");
	AddCSLuaFile("goggles/splintercell_nvg_night.lua");
	AddCSLuaFile("goggles/splintercell_nvg_motion.lua");
	AddCSLuaFile("goggles/splintercell_nvg_enhanced.lua");
	AddCSLuaFile("goggles/splintercell_nvg_electrotracker.lua");
	AddCSLuaFile("goggles/splintercell_nvg_electro.lua");
end

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

-- Include files. This needs to be called after setting up the static
-- table inorder to work properly. Each file will add its own functions to the table.
include("goggles/splintercell_nvg_test.lua");
include("goggles/splintercell_nvg_thermal.lua");
include("goggles/splintercell_nvg_sonar.lua");
include("goggles/splintercell_nvg_night.lua");
include("goggles/splintercell_nvg_motion.lua");
include("goggles/splintercell_nvg_enhanced.lua");
include("goggles/splintercell_nvg_electrotracker.lua");
include("goggles/splintercell_nvg_electro.lua");

-- Constants.
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
function SPLINTERCELL_NVG_GOGGLES:DrawOverlay(overlay)

	local transition = math.Clamp(self.Transition - 1, 0, 1);

	-- Vignetting effect.
	surface.SetMaterial(nvgVignette);
	surface.SetDrawColor(255, 255, 255, transition * 255);
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH());

	-- Animated overlay texture.
	surface.SetMaterial(overlay);
	surface.SetDrawColor(255, 255, 255, transition * 255);
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH());
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

--! 
--! Draw hook entry point for all goggles. This will use the network var currently set on the player
--! to determine which goggle to use.
--!
hook.Add("PreDrawHUD", "SPLINTERCELL_NVG_SHADER", function()

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

			-- Play goggle mode switch sound only clientside.
			if (currentGoggle != SPLINTERCELL_NVG_GOGGLES.CurrentGoggles) then
				SPLINTERCELL_NVG_GOGGLES.CurrentGoggles = currentGoggle;
				surface.PlaySound("splinter_cell/goggles/standard/goggles_mode.wav");
			end

			if (CurTime() > SPLINTERCELL_NVG_GOGGLES.NextTransition) then

				-- Begin rendering screen space effects of the current goggles.
				local goggles = SPLINTERCELL_NVG_GOGGLES;
				goggles[currentConfig.Hud](SPLINTERCELL_NVG_GOGGLES);

				-- Handle material overrides for the goggle being used.
				if (currentConfig.Filter != nil) then
					SPLINTERCELL_NVG_GOGGLES:HandleMaterialOverrides(currentConfig);
				end

				-- Play activate sound on client only after delay expired.
				if (!SPLINTERCELL_NVG_GOGGLES.ToggledSound) then
					SPLINTERCELL_NVG_GOGGLES.ToggledSound = true;
					surface.PlaySound(currentConfig.Sounds.Activate);
				end
			end
		else

			-- Transition lens out.
			SPLINTERCELL_NVG_GOGGLES:TransitionOut(nvgOverlayAnim);

			-- Reset defaults for next toggle.
			SPLINTERCELL_NVG_GOGGLES.Toggled = false;
			SPLINTERCELL_NVG_GOGGLES.ToggledSound = false;
			SPLINTERCELL_NVG_GOGGLES:CleanupMaterials();
		end

		-- This is always called but will not interfere with other addons.
		SPLINTERCELL_NVG_GOGGLES:DrawOverlay(currentConfig.MaterialOverlay);
	cam.End2D();
end);