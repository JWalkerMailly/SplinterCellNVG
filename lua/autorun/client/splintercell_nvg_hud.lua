
-- This acts like a static class.
SPLINTERCELL_NVG_GOGGLES = {};
SPLINTERCELL_NVG_GOGGLES.ShouldCleanupMaterials = false;

if (SERVER) then
	AddCSLuaFile("goggles/splintercell_nvg_thermal.lua");
	AddCSLuaFile("goggles/splintercell_nvg_sonar.lua");
	AddCSLuaFile("goggles/splintercell_nvg_night.lua");
	AddCSLuaFile("goggles/splintercell_nvg_motion.lua");
	AddCSLuaFile("goggles/splintercell_nvg_enhanced.lua");
	AddCSLuaFile("goggles/splintercell_nvg_electrotracker.lua");
	AddCSLuaFile("goggles/splintercell_nvg_electro.lua");
end

-- Used for debuggin at the moment, will eventually be replaced for something more suited for the job.
if (CLIENT) then
	CreateClientConVar("SPLINTERCELL_NVG_GOGGLES_ENABLE", "0", false, false);
end

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
	-- For testing purposes, this value is hard coded but will be handled correctly later on.
	local nwVar = "Thermal";
	local goggle = SPLINTERCELL_NVG_CONFIG[nwVar];

	-- Delegate call to the configuration file for which goggle to render.
	if (GetConVar("SPLINTERCELL_NVG_GOGGLES_ENABLE"):GetBool()) then
		SPLINTERCELL_NVG_GOGGLES[goggle.Hud](SPLINTERCELL_NVG_GOGGLES);
		SPLINTERCELL_NVG_GOGGLES:HandleMaterialOverrides(goggle);
	else
		SPLINTERCELL_NVG_GOGGLES:CleanupMaterials();
	end
end);