
-- This acts like a static class.
SPLINTERCELL_NVG_GOGGLES = {};

if (SERVER) then
	AddCSLuaFile("goggles/splintercell_nvg_thermal.lua");
	AddCSLuaFile("goggles/splintercell_nvg_sonar.lua");
	AddCSLuaFile("goggles/splintercell_nvg_night.lua");
	AddCSLuaFile("goggles/splintercell_nvg_motion.lua");
	AddCSLuaFile("goggles/splintercell_nvg_enhanced.lua");
	AddCSLuaFile("goggles/splintercell_nvg_electrotracker.lua");
	AddCSLuaFile("goggles/splintercell_nvg_electro.lua");
end

include("goggles/splintercell_nvg_thermal.lua");
include("goggles/splintercell_nvg_sonar.lua");
include("goggles/splintercell_nvg_night.lua");
include("goggles/splintercell_nvg_motion.lua");
include("goggles/splintercell_nvg_enhanced.lua");
include("goggles/splintercell_nvg_electrotracker.lua");
include("goggles/splintercell_nvg_electro.lua");

-- Entry point for all HUD rendering operations.
hook.Add("HUDPaint", "SPLINTERCELL_NVG_DRAWHUD", function()

	-- This is the autoload logic for the network var. Network vars will be handled serverside.
	-- For testing purposes, this value is hard coded but will be handled correctly later on.
	local nwVar = "Thermal";
	local goggle = SPLINTERCELL_NVG_CONFIG[nwVar].Hud;

	-- Delegate call to the configuration file for which goggle to render.
	SPLINTERCELL_NVG_GOGGLES[goggle](SPLINTERCELL_NVG_GOGGLES);
end);