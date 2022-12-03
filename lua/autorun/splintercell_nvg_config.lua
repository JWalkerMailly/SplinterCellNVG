
-- This acts like a static class.
SPLINTERCELL_NVG_CONFIG = {};

SPLINTERCELL_NVG_CONFIG[1] = {
	Name = "Test",
	Hud = "DrawTestVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay"
};

SPLINTERCELL_NVG_CONFIG[2] = {
	Name = "Night",
	Hud = "DrawNightVision"
};

SPLINTERCELL_NVG_CONFIG[3] = {
	Name = "Thermal",
	Hud = "DrawThermalVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay"
};

SPLINTERCELL_NVG_CONFIG[4] = {
	Name = "Electromagnetic",
	Hud = "DrawElectromagneticVision"
};

SPLINTERCELL_NVG_CONFIG[5] = {
	Name = "Enhanced",
	Hud = "DrawEnhancedVision"
};

SPLINTERCELL_NVG_CONFIG[6] = {
	Name = "MotionTracker",
	Hud = "DrawMotionTrackerVision"
};

SPLINTERCELL_NVG_CONFIG[7] = {
	Name = "ElectroTracker",
	Hud = "DrawElectroTrackerVision"
};

SPLINTERCELL_NVG_CONFIG[8] = {
	Name = "Sonar",
	Hud = "DrawSonarVision"
};