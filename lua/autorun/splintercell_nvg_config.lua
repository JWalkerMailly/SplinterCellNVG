
-- This acts like a static class.
SPLINTERCELL_NVG_CONFIG = {};

----------------------------------------------------------------
-- Test goggle, will be removed before production
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[1] = {
	Name = "Test",
	Hud = "DrawTestVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Sounds = {
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav"
	}
};

----------------------------------------------------------------
-- Night vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[2] = {
	Name = "Night",
	Hud = "DrawNightVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Sounds = {
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav"
	}
};

----------------------------------------------------------------
-- Thermal vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[3] = {
	Name = "Thermal",
	Hud = "DrawThermalVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Sounds = {
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav"
	}
};

----------------------------------------------------------------
-- Electromagnetic vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[4] = {
	Name = "Electromagnetic",
	Hud = "DrawElectromagneticVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Sounds = {
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav"
	}
};

----------------------------------------------------------------
-- Enhanced Night vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[5] = {
	Name = "Enhanced Night",
	Hud = "DrawEnhancedVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Sounds = {
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav"
	}
};

----------------------------------------------------------------
-- Motion Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[6] = {
	Name = "Motion Tracking",
	Hud = "DrawMotionTrackerVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Sounds = {
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav"
	}
};

----------------------------------------------------------------
-- Electromagnetic Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[7] = {
	Name = "Electromagnetic Tracking",
	Hud = "DrawElectroTrackerVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Sounds = {
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav"
	}
};

----------------------------------------------------------------
-- Sonar vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[8] = {
	Name = "Sonar",
	Hud = "DrawSonarVision",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Sounds = {
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav"
	}
};