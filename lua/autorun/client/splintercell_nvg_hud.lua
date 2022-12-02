
-- This acts like a static class.
SPLINTERCELL_NVG_GOGGLES = {};

if (SERVER) then
	AddCSLuaFile("goggles/splintercell_nvg_thermal.lua");
end

include("goggles/splintercell_nvg_thermal.lua");

-- Entry point for all HUD rendering operations.
hook.Add("HUDPaint", "SPLINTERCELL_NVG_DRAWHUD", function()

	local goggle = SPLINTERCELL_NVG_CONFIG["Thermal"].Hud;

	-- Delegate call to the configuration file for which goggle to render.
	SPLINTERCELL_NVG_GOGGLES[goggle]();
end);