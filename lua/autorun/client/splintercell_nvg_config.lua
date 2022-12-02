
-- This acts like a static class.
SPLINTERCELL_NVG_CONFIG = {};

SPLINTERCELL_NVG_CONFIG["Night"] = {
	Hud = "DrawNightVision"
};

SPLINTERCELL_NVG_CONFIG["Thermal"] = {
	Hud = "DrawThermalVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay"
};

SPLINTERCELL_NVG_CONFIG["Electromagnetic"] = {
	Hud = "DrawElectromagneticVision"
};

SPLINTERCELL_NVG_CONFIG["Enhanced"] = {
	Hud = "DrawEnhancedVision"
};

SPLINTERCELL_NVG_CONFIG["MotionTracker"] = {
	Hud = "DrawMotionTrackerVision"
};

SPLINTERCELL_NVG_CONFIG["ElectroTracker"] = {
	Hud = "DrawElectroTrackerVision"
};

SPLINTERCELL_NVG_CONFIG["Sonar"] = {
	Hud = "DrawSonarVision"
};