
-- This acts like a static class.
SPLINTERCELL_NVG_CONFIG = {};

----------------------------------------------------------------
-- Night vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[1] = {

	Name = "Night",
	Hud = "DrawNightVision",

	MaterialOverlay = Material("vgui/splinter_cell/nvg_anim"),
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop = nil,
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate = "splinter_cell/goggles/standard/goggles_activate.wav"
	}
};

----------------------------------------------------------------
-- Thermal vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[2] = {
	Name = "Thermal",
	Hud = "DrawThermalVision",

	MaterialOverlay = Material("vgui/splinter_cell/nvg_anim"),
	MaterialOverride = "effects/splinter_cell/orgscan_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop = nil,
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate = "splinter_cell/goggles/standard/goggles_activate.wav"
	}
};

----------------------------------------------------------------
-- Electromagnetic vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[3] = {
	Name = "Electromagnetic",
	Hud = "DrawElectromagneticVision",

	MaterialOverlay = Material("vgui/splinter_cell/nvg_anim"),
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop = nil,
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate = "splinter_cell/goggles/standard/goggles_activate.wav"
	}
};

----------------------------------------------------------------
-- Enhanced Night vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[4] = {
	Name = "Enhanced Night",
	Hud = "DrawEnhancedVision",

	MaterialOverlay = Material("vgui/splinter_cell/nvg_anim"),
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop = nil,
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate = "splinter_cell/goggles/standard/goggles_activate.wav"
	}
};

----------------------------------------------------------------
-- Motion Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[5] = {
	Name = "Motion Tracking",
	Hud = "DrawMotionTrackerVision",

	MaterialOverlay = Material("vgui/splinter_cell/nvg_anim"),
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop = "splinter_cell/goggles/tracking/motion_tracking_lp.wav",
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate = "splinter_cell/goggles/standard/goggles_activate.wav"
	}
};

----------------------------------------------------------------
-- Electromagnetic Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[6] = {
	Name = "Electromagnetic Tracking",
	Hud = "DrawElectroTrackerVision",

	MaterialOverlay = Material("vgui/splinter_cell/nvg_anim"),
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop = nil,
		ToggleOn = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate = "splinter_cell/goggles/standard/goggles_activate.wav"
	}
};

----------------------------------------------------------------
-- Sonar vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[7] = {
	Name = "Sonar",
	Hud = "DrawSonarVision",

	MaterialOverlay = Material("vgui/splinter_cell/nvg_anim"),
	MaterialOverride = "effects/splinter_cell/orgsen_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop = nil,
		ToggleOn = "splinter_cell/goggles/sonar/sonar_goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/sonar/sonar_goggles_toggle_off.wav",
		Activate = "splinter_cell/goggles/standard/goggles_activate.wav"
	}
};