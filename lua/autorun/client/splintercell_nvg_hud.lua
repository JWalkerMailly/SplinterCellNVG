
-- This acts like a static class.
SPLINTERCELL_NVG_GOGGLES = {};
SPLINTERCELL_NVG_GOGGLES.CurrentGoggles = nil;
SPLINTERCELL_NVG_GOGGLES.ShouldCleanupMaterials = false;

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

include("goggles/splintercell_nvg_test.lua");
include("goggles/splintercell_nvg_thermal.lua");
include("goggles/splintercell_nvg_sonar.lua");
include("goggles/splintercell_nvg_night.lua");
include("goggles/splintercell_nvg_motion.lua");
include("goggles/splintercell_nvg_enhanced.lua");
include("goggles/splintercell_nvg_electrotracker.lua");
include("goggles/splintercell_nvg_electro.lua");

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
--! Draw hook entry point for all goggles. This will use the network var currently set on the player
--! to determine which goggle to use.
--!
hook.Add("HUDPaint", "SPLINTERCELL_NVG_SHADER", function()

	-- This is the autoload logic for the network var. Network vars will be handled serverside.
	local currentGoggle = LocalPlayer():GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 0);
	local lastGoggle = LocalPlayer():GetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", 0);

	-- Do nothing if no goggle is currently toggled.
	if (currentGoggle == 0 || lastGoggle == 0) then return; end

	-- This is only used clientside to handle animations and sounds. It has nothing to
	-- do with the network var found on the client entity.
	if (SPLINTERCELL_NVG_GOGGLES.CurrentGoggles == nil) then
		SPLINTERCELL_NVG_GOGGLES.CurrentGoggles = currentGoggle;
	end

	local currentConfig = SPLINTERCELL_NVG_CONFIG[currentGoggle];
	--local lastConfig = SPLINTERCELL_NVG_CONFIG[lastGoggle];

	-- Delegate call to the configuration file for which goggle to render.
	if (GetConVar("SPLINTERCELL_NVG_TOGGLE"):GetBool()) then

		local goggles = SPLINTERCELL_NVG_GOGGLES;
		goggles[currentConfig.Hud](SPLINTERCELL_NVG_GOGGLES);

		-- Handle material overrides for the goggle being used.
		if (currentConfig.Filter != nil) then
			SPLINTERCELL_NVG_GOGGLES:HandleMaterialOverrides(currentConfig);
		end

		-- Play goggle mode switch sound only clientside.
		if (currentGoggle != SPLINTERCELL_NVG_GOGGLES.CurrentGoggles) then
			SPLINTERCELL_NVG_GOGGLES.CurrentGoggles = currentGoggle;
			surface.PlaySound("splinter_cell/goggles/standard/goggles_mode.wav");
		end
	else
		SPLINTERCELL_NVG_GOGGLES:CleanupMaterials();
	end
end);