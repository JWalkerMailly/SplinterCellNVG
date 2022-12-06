
-- This acts like a static class.
SPLINTERCELL_NVG_CONFIG = {};

----------------------------------------------------------------
-- Night vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[1] = {

	Name = "Night",
	Whitelist = {
		"models/splinter_cell_3/player/sam_a.mdl",
		"models/splinter_cell_3/player/sam_b.mdl",
		"models/splinter_cell_3/player/sam_c.mdl",
		"models/splinter_cell_3/player/sam_d.mdl",

		"models/splinter_cell_4/player/sam_a.mdl",
		"models/splinter_cell_4/player/sam_b.mdl",
		"models/splinter_cell_4/player/sam_c.mdl",

		"models/splinter_cell_3/player/coop_agent_one.mdl",
		"models/splinter_cell_3/player/coop_agent_two.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/noise"),
	InterlaceColor    = Color(155, 155, 155, 64),

	MaterialOverride  = nil,
	Filter = function(ent)
		return;
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
		Brightness = 1.5,
		Size       = 16000,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ProjectedTexture = {
		FOV        = 140,
		VFOV       = 100, -- Vertical FOV
		Brightness = 2,
		Distance   = 2500
	},

	PhotoSensitive = 0.9,

	ColorCorrection = {
		ColorAdd   = Color(0.2, 0.4, 0.05),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 0.25,
		Contrast   = 1,
		Brightness = 0.05
	},

	PostProcess = function()
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, 1, 155 / 255, 155 / 255, 155 / 255);
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
	end
};

----------------------------------------------------------------
-- Thermal vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[2] = {

	Name = "Thermal",
	Whitelist = {
		"models/splinter_cell_3/player/sam_a.mdl",
		"models/splinter_cell_3/player/sam_b.mdl",
		"models/splinter_cell_3/player/sam_c.mdl",
		"models/splinter_cell_3/player/sam_d.mdl",

		"models/splinter_cell_4/player/sam_a.mdl",
		"models/splinter_cell_4/player/sam_b.mdl",
		"models/splinter_cell_4/player/sam_c.mdl",

		"models/splinter_cell_3/player/coop_agent_one.mdl",
		"models/splinter_cell_3/player/coop_agent_two.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/noise"),
	InterlaceColor    = Color(155, 155, 155, 64),

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
	Whitelist = {
		"models/splinter_cell_3/player/sam_a.mdl",
		"models/splinter_cell_3/player/sam_b.mdl",
		"models/splinter_cell_3/player/sam_c.mdl",
		"models/splinter_cell_3/player/sam_d.mdl",

		"models/splinter_cell_4/player/sam_a.mdl",
		"models/splinter_cell_4/player/sam_b.mdl",
		"models/splinter_cell_4/player/sam_c.mdl",
		"models/splinter_cell_4/player/sam_d.mdl",
		"models/splinter_cell_4/player/sam_e.mdl",
		"models/splinter_cell_4/player/sam_f.mdl",

		"models/splinter_cell_3/player/coop_agent_one.mdl",
		"models/splinter_cell_3/player/coop_agent_two.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = true,

	MaterialInterlace = Material("vgui/splinter_cell/noise"),
	InterlaceColor    = Color(55, 100, 155, 128),

	MaterialOverride  = "effects/splinter_cell/bright_white",
	Filter = function(ent)
		return ent:IsScripted() || ent:IsVehicle() || ent:GetClass() == "npc_manhack" || ent:GetClass() == "npc_cscanner" || ent:GetClass() == "npc_clawscanner" || 
		ent:GetClass() == "npc_rollermine" || ent:GetClass() == "npc_rollermine" || ent:GetClass() == "combine_mine" || ent:GetClass() == "gmod_lamp" ||
		ent:GetClass() == "gmod_light" || ent:GetClass() == "prop_thumper" || ent:GetClass() == "hl2_thumper_large" || ent:GetClass() == "hl2_thumper_large" ||
		ent:GetClass() == "npc_turret_floor" || ent:GetClass() == "npc_combine_camera" || ent:GetClass() == "npc_turret_ceiling" || ent:GetClass() == "hl2_npc_turret_ground" ||
		ent:GetClass() == "item_suitcharger" || ent:GetClass() == "item_healthcharger" || ent:GetClass() == "point_spotlight" || ent:GetClass() == "grenade_helicopter" ||
		ent:GetClass() == "weapon_striderbuster" || ent:GetClass() == "item_battery" || ent:GetClass() == "npc_combine_s" || ent:GetClass() == "npc_strider" || 
		ent:GetClass() == "npc_combinegunship" || ent:GetClass() == "npc_helicopter" || ent:GetClass() == "npc_combinedropship" || ent:GetClass() == "npc_dog" || ent:GetClass() == "hl2_npc_turret_ground";
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
		
		-- DrawColorModify({
			-- ["$pp_colour_addr"]       = 0   * 0.02, -- * 0.02 is important.
			-- ["$pp_colour_addg"]       = 0   * 0.02, -- * 0.02 is important.
			-- ["$pp_colour_addb"]       = 0   * 0.02, -- * 0.02 is important.
			-- ["$pp_colour_mulr"]       = 155 * 0.1, -- * 0.1 is important.
			-- ["$pp_colour_mulg"]       = 110 * 0.1, -- * 0.1 is important.
			-- ["$pp_colour_mulb"]       = 45  * 0.1, -- * 0.1 is important.
			-- ["$pp_colour_brightness"] = 0.04,
			-- ["$pp_colour_contrast"]   = 0.15,
			-- ["$pp_colour_colour"]     = 0.0
		-- });

		-- Render first bloom pass and apply texurizer to achieve thermal effect.
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, -7, 155 / 255, 155 / 255, 155 / 255);
		DrawTexturize(1, Material("effects/splinter_cell/emp.png"));

		-- Final bloom pass with motion blur to give a glowing ghosting effect.
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, 1, 155 / 255, 155 / 255, 155 / 255);
		DrawMotionBlur(0.3, 1.0, 0);
	end
};

----------------------------------------------------------------
-- Enhanced Night vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[4] = {

	Name = "Enhanced Night",
	Whitelist = {
		"models/splinter_cell_1/player/sam_a.mdl",
		"models/splinter_cell_1/player/sam_b.mdl",
		"models/splinter_cell_1/player/sam_c.mdl",

		"models/splinter_cell_3/player/spec_ops_b.mdl",

		"models/splinter_cell_3/player/nka_special_forces.mdl",
		"models/splinter_cell_3/player/nka_special_forces_b.mdl",

		"models/splinter_cell_1/player/georgian_elite.mdl",
		"models/splinter_cell_1/player/georgian_elite_b.mdl",

		"models/splinter_cell_1/player/spetsnaz.mdl",
		"models/splinter_cell_1/player/spetsnaz_b.mdl",

		"models/splinter_cell_1/player/terrorist.mdl",
		"models/splinter_cell_1/player/terrorist_b.mdl",

		"models/splinter_cell_3/player/mercenary_pro.mdl",
		"models/splinter_cell_3/player/mercenary_pro_b.mdl",

		"models/splinter_cell_svm/player/spynet_spy.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/overlay_interlace"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/noise"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = nil,
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
		Color      = Color(45, 60, 15),
		Min        = 0,
		Style      = 0,
		Brightness = 0.8,
		Size       = 64000,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0.25, 0.23, 0.05),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 0.18,
		Contrast   = 1,
		Brightness = 0.15
	},

	PostProcess = function()
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
	end
};

----------------------------------------------------------------
-- Motion Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[5] = {

	Name = "Motion Tracking",
	Whitelist = {
		"models/splinter_cell_svm/player/argus_merc.mdl", 
		"models/splinter_cell_svm/player/argus_merc_b.mdl",

		"models/splinter_cell_3/player/ronin_troop.mdl",
		"models/splinter_cell_3/player/ronin_troop_b.mdl",

		"models/splinter_cell_1/player/merc_custom.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/overlay_honeycomb"),
	OverlayFirst      = true,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = "effects/splinter_cell/thermal_radius",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop      = "splinter_cell/goggles/tracking/motion_tracking_lp.wav",
		ToggleOn  = "splinter_cell/goggles/tracking/toggle_off.wav",
		ToggleOff = "splinter_cell/goggles/tracking/toggle_off.wav",
		Activate  = "splinter_cell/goggles/tracking/toggle_on.wav"
	},

	Lighting = {
		Color      = Color(5, 5, 5),
		Min        = 0,
		Style      = 0,
		Brightness = 0.1,
		Size       = 16000,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0.1, 0.3, 0.45),
		ColorMul   = Color(0.4, 0.4, 1),
		ColorMod   = 2.5,
		Contrast   = -2.5,
		Brightness = 0
	},

	PostProcess = function()

		-- Render first bloom pass and apply texurizer to achieve thermal effect.
		DrawBloom(0.07, 0.1, 1.75, 0.5, 2, -99.00, 155 / 255, 155 / 255, 155 / 255);
		DrawTexturize(1, Material("effects/splinter_cell/motiontracking.png"));

		-- Final bloom pass with motion blur to give a glowing ghosting effect.
		DrawBloom(0.07, 0.1, 1.75, 0.5, 2, -99.00, 155 / 255, 155 / 255, 155 / 255);
		DrawMotionBlur(0.3, 1.0, 0);
	end
};

----------------------------------------------------------------
-- Electromagnetic Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[6] = {

	Name = "Electromagnetic Tracking",
	Whitelist = {
		"models/splinter_cell_svm/player/argus_merc.mdl", 
		"models/splinter_cell_svm/player/argus_merc_b.mdl",

		"models/splinter_cell_3/player/ronin_troop.mdl",
		"models/splinter_cell_3/player/ronin_troop_b.mdl",

		"models/splinter_cell_1/player/merc_custom.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/overlay_honeycomb"),
	OverlayFirst      = true,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = "effects/splinter_cell/bright_white",
	Filter = function(ent)
		return ent:IsScripted() || ent:IsVehicle() || ent:GetClass() == "npc_manhack" || ent:GetClass() == "npc_cscanner" || ent:GetClass() == "npc_clawscanner" || 
		ent:GetClass() == "npc_rollermine" || ent:GetClass() == "npc_rollermine" || ent:GetClass() == "combine_mine" || ent:GetClass() == "gmod_lamp" ||
		ent:GetClass() == "gmod_light" || ent:GetClass() == "prop_thumper" || ent:GetClass() == "hl2_thumper_large" || ent:GetClass() == "hl2_thumper_large" ||
		ent:GetClass() == "npc_turret_floor" || ent:GetClass() == "npc_combine_camera" || ent:GetClass() == "npc_turret_ceiling" || ent:GetClass() == "hl2_npc_turret_ground" ||
		ent:GetClass() == "item_suitcharger" || ent:GetClass() == "item_healthcharger" || ent:GetClass() == "point_spotlight" || ent:GetClass() == "grenade_helicopter" ||
		ent:GetClass() == "weapon_striderbuster" || ent:GetClass() == "item_battery" || ent:GetClass() == "npc_combine_s" || ent:GetClass() == "npc_strider" || 
		ent:GetClass() == "npc_combinegunship" || ent:GetClass() == "npc_helicopter" || ent:GetClass() == "npc_combinedropship" || ent:GetClass() == "npc_dog" || ent:GetClass() == "hl2_npc_turret_ground";
	end,

	Sounds = {
		Loop      = "splinter_cell/goggles/tracking/emp_tracking_lp.wav",
		ToggleOn  = "splinter_cell/goggles/tracking/toggle_off.wav",
		ToggleOff = "splinter_cell/goggles/tracking/toggle_off.wav",
		Activate  = "splinter_cell/goggles/tracking/toggle_on.wav"
	},

	Lighting = {
		Color      = Color(5, 5, 5),
		Min        = 0,
		Style      = 0,
		Brightness = 0.1,
		Size       = 16000,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0, 0, 0.45),
		ColorMul   = Color(0, 0, 1),
		ColorMod   = 0.15,
		Contrast   = 1,
		Brightness = -0.05
	},

	PostProcess = function()

		-- Render first bloom pass and apply texurizer to achieve thermal effect.
		DrawBloom(1, 9000, 1.75, 0.5, 0, 5000, 155 / 255, 155 / 255, 155 / 255);
		DrawTexturize(1, Material("effects/splinter_cell/emptracking.png"));

		-- Final bloom pass with motion blur to give a glowing ghosting effect.
		DrawBloom(1, 9000, 1.75, 0.5, 0, 5000, 155 / 255, 155 / 255, 155 / 255);
		DrawMotionBlur(0.3, 1.0, 0);
	end
};

----------------------------------------------------------------
-- Sonar vision
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[7] = {

	Name = "Sonar",
	Whitelist = {
		"models/splinter_cell_1/player/spy_custom.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_filter2"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/noise"),
	InterlaceColor    = Color(155, 155, 155, 64),

	MaterialOverride  = "effects/splinter_cell/bright_white_noz",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot() || ent:IsScripted() || ent:IsVehicle();
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

		DrawBloom(2, 3.10, 1.75, 0.5, 2, -99.00, 155 / 255, 155 / 255, 155 / 255);
		DrawTexturize(1, Material("effects/splinter_cell/sonar.png"));
		DrawSharpen(10, 0.25)

		-- Final bloom pass with motion blur to give a glowing ghosting effect.
		DrawBloom(2, 3.10, 1.75, 0.5, 2, -99.00, 155 / 255, 155 / 255, 155 / 255);
		DrawMotionBlur(0.55, 0.8, 0);
	end
};

----------------------------------------------------------------
-- Thermal vision (Splinter Cell Double Agent)
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[8] = {

	Name = "Epsilon Thermal",
	Whitelist = {
		"models/splinter_cell_4/player/pawnspy_one.mdl",
		"models/splinter_cell_4/player/pawnspy_zero.mdl"
	},

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
		DrawTexturize(1, Material("effects/splinter_cell/gradient.png"));

		-- Final bloom pass with motion blur to give a glowing ghosting effect.
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, 1, 155 / 255, 155 / 255, 155 / 255);
		DrawMotionBlur(0.3, 1.0, 0);
	end
};

----------------------------------------------------------------
-- Night vision (Splinter Cell Double Agent MP)
----------------------------------------------------------------
SPLINTERCELL_NVG_CONFIG[9] = {

	Name = "Epsilon Night",
	Whitelist = {
		"models/splinter_cell_4/player/pawnspy_one.mdl",
		"models/splinter_cell_4/player/pawnspy_zero.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/overlay_goggles"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/noise"),
	InterlaceColor    = Color(155, 155, 155, 128),

	MaterialOverride  = nil,
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
		Color      = Color(45, 60, 15),
		Min        = 0,
		Style      = 0,
		Brightness = 1.8,
		Size       = 64000,
		Decay      = 16000,
		DieTime    = 0.05
	},

	ColorCorrection = {
		ColorAdd   = Color(0.25, 0.23, 0.05),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 0,
		Contrast   = 1,
		Brightness = -0.1
	},

	PostProcess = function()
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
	end
};