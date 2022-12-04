
-- This acts like a static class.
SPLINTERCELL_NVG_CONFIG = {};

----------------------------------------------------------------
-- Night vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[1] = {

	Name = "Night",
	Hud = "DrawNightVision",

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = "effects/splinter_cell/orgscan_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop      = nil,
		ToggleOn  = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate  = "splinter_cell/goggles/standard/goggles_activate.wav"
	},

	Lighting = {
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 0.1,
		Size       = 8192,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0, 0, 0),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 1,
		Contrast   = 2,
		Brightness = 0.01
	},

	PostProcess = function()
	end
};

----------------------------------------------------------------
-- Thermal vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[2] = {

	Name = "Thermal",
	Hud = "DrawThermalVision",

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = "effects/splinter_cell/thermal_radius",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop      = nil,
		ToggleOn  = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate  = "splinter_cell/goggles/standard/goggles_activate.wav"
	},

	Lighting = {
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 0.1,
		Size       = 8192,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0, 0, 0),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 1,
		Contrast   = 2,
		Brightness = 0.01
	},

	PostProcess = function()

		-- Sobel must be applied first to avoid darkening the result.
		DrawSobel(0.6);

		-- Color modify now before any other rendering operations. This way
		-- the texturizer will be compounded on top.
		DrawColorModify({
			["$pp_colour_addr"]       = 0   * 0.02, -- * 0.02 is important.
			["$pp_colour_addg"]       = 0   * 0.02, -- * 0.02 is important.
			["$pp_colour_addb"]       = 0   * 0.02, -- * 0.02 is important.
			["$pp_colour_mulr"]       = 155 * 0.1, -- * 0.1 is important.
			["$pp_colour_mulg"]       = 110 * 0.1, -- * 0.1 is important.
			["$pp_colour_mulb"]       = 45  * 0.1, -- * 0.1 is important.
			["$pp_colour_brightness"] = 0.04,
			["$pp_colour_contrast"]   = 0.15,
			["$pp_colour_colour"]     = 0.0
		});

		-- Render first bloom pass and apply texurizer to achieve thermal effect.
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, -7, 155 / 255, 155 / 255, 155 / 255);
		DrawTexturize(1, Material("effects/splinter_cell/thermal.png"));

		-- Final bloom pass with motion blur to give a glowing ghosting effect.
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, 1, 155 / 255, 155 / 255, 155 / 255);
		DrawMotionBlur(0.3, 1.0, 0);
	end
};

----------------------------------------------------------------
-- Electromagnetic vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[3] = {

	Name = "Electromagnetic",
	Hud = "DrawElectromagneticVision",

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = "effects/splinter_cell/orgscan_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop      = nil,
		ToggleOn  = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate  = "splinter_cell/goggles/standard/goggles_activate.wav"
	},

	Lighting = {
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 0.1,
		Size       = 8192,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0, 0, 0),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 1,
		Contrast   = 2,
		Brightness = 0.01
	},

	PostProcess = function()
	end
};

----------------------------------------------------------------
-- Enhanced Night vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[4] = {

	Name = "Enhanced Night",
	Hud = "DrawEnhancedVision",

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = "effects/splinter_cell/orgscan_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop      = nil,
		ToggleOn  = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate  = "splinter_cell/goggles/standard/goggles_activate.wav"
	},

	Lighting = {
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 0.1,
		Size       = 8192,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0, 0, 0),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 1,
		Contrast   = 2,
		Brightness = 0.01
	},

	PostProcess = function()
	end
};

----------------------------------------------------------------
-- Motion Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[5] = {

	Name = "Motion Tracking",
	Hud = "DrawMotionTrackerVision",

	MaterialOverlay   = Material("vgui/splinter_cell/overlay_honeycomb"),
	OverlayFirst      = true,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = "effects/splinter_cell/orgscan_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop      = nil,
		ToggleOn  = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate  = "splinter_cell/goggles/standard/goggles_activate.wav"
	},

	Lighting = {
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 0.1,
		Size       = 8192,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0, 0, 0),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 1,
		Contrast   = 2,
		Brightness = 0.01
	},

	PostProcess = function()
	end
};

----------------------------------------------------------------
-- Electromagnetic Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[6] = {

	Name = "Electromagnetic Tracking",
	Hud = "DrawElectroTrackerVision",

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = "effects/splinter_cell/orgscan_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop      = nil,
		ToggleOn  = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate  = "splinter_cell/goggles/standard/goggles_activate.wav"
	},

	Lighting = {
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 0.1,
		Size       = 8192,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0, 0, 0),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 1,
		Contrast   = 2,
		Brightness = 0.01
	},

	PostProcess = function()
	end
};

----------------------------------------------------------------
-- Sonar vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[7] = {

	Name = "Sonar",
	Hud = "DrawSonarVision",

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = "effects/splinter_cell/orgscan_overlay",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop      = nil,
		ToggleOn  = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate  = "splinter_cell/goggles/standard/goggles_activate.wav"
	},

	Lighting = {
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 0.1,
		Size       = 8192,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0, 0, 0),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 1,
		Contrast   = 2,
		Brightness = 0.01
	},

	PostProcess = function()
	end
};