
local SPLINTERCELL_NVG = {};
SPLINTERCELL_NVG.Goggles = {};

-- Base settings.
SPLINTERCELL_NVG.Settings = {

	Gestures = {
		On = ACT_ARM,
		Off = ACT_DISARM
	},

	BodyGroups = {
		Group = 1,
		Values = {
			On = 1,
			Off = 0
		}
	},

	Overlays = {
		First = Material("vgui/splinter_cell/overlay_vignette"),
		Second = Material("vgui/splinter_cell/nvg_turnon_static")
	},

	Transition = {
		Rate = 5,
		Delay = 0.225,
		Switch = 0.5,
		Sound = "splinter_cell/goggles/standard/goggles_mode.wav"
	}
};

----------------------------------------------------------------
-- Night vision
----------------------------------------------------------------
SPLINTERCELL_NVG.Goggles[1] = {

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
		Brightness = 1,
		Size       = 200,
		Decay      = 200,
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

	PostProcess = function(self)
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, 1, 155 / 255, 155 / 255, 155 / 255);
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
	end
};

----------------------------------------------------------------
-- Thermal vision
----------------------------------------------------------------
SPLINTERCELL_NVG.Goggles[2] = {

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

	PostProcess = function(self)

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
SPLINTERCELL_NVG.Goggles[3] = {

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

	PostProcess = function(self)

		-- Sobel must be applied first to avoid darkening the result.
		DrawSobel(0.6);

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
SPLINTERCELL_NVG.Goggles[4] = {

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
		Brightness = 4,
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

	PostProcess = function(self)
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
	end
};

----------------------------------------------------------------
-- Motion Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG.Goggles[5] = {

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

	TagMinVelocity = 100,
	UntagDelay = 3,

	Sounds = {
		Loop      = "splinter_cell/goggles/tracking/motion_tracking_lp.wav",
		ToggleOn  = "splinter_cell/goggles/tracking/toggle_off.wav",
		ToggleOff = "splinter_cell/goggles/tracking/toggle_off.wav",
		Activate  = "splinter_cell/goggles/tracking/toggle_on.wav",
		Alert     = "splinter_cell/goggles/tracking/motion_alert.wav"
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

	PostProcess = function(self)

		-- Render first bloom pass and apply texurizer to achieve thermal effect.
		DrawBloom(0.07, 0.1, 1.75, 0.5, 2, -99.00, 155 / 255, 155 / 255, 155 / 255);
		DrawTexturize(1, Material("effects/splinter_cell/motiontracking.png"));

		-- Final bloom pass with motion blur to give a glowing ghosting effect.
		DrawBloom(0.07, 0.1, 1.75, 0.5, 2, -99.00, 155 / 255, 155 / 255, 155 / 255);
		DrawMotionBlur(0.3, 1.0, 0);
	end,

	OffscreenRendering = function(self, texture)

		for k,v in pairs(ents.GetAll()) do

			-- Make sure the entity is visible and passing the motion tracking filter.
			if (!self.Filter(v) || !LocalPlayer():NVGBASE_IsBoundingBoxVisible(v, 2048)) then
				v.NVGBASE_MotionTagged = nil;
				continue;
			end

			-- Tag targets only if velocity is greater and a certain threshold.
			if (v:GetVelocity():Length() > self.TagMinVelocity) then

				-- Play sound if tagged for the first time.
				if (v.NVGBASE_MotionTagged == nil) then
					surface.PlaySound(self.Sounds.Alert);
				end

				v.NVGBASE_MotionTagged = CurTime() + self.UntagDelay;
			else

				-- Target tag expired, reset flag.
				if (v.NVGBASE_MotionTagged != nil && CurTime() > v.NVGBASE_MotionTagged) then
					v.NVGBASE_MotionTagged = nil;
				end
			end

			-- Entity not tagged, do not render.
			if (v.NVGBASE_MotionTagged == nil) then return; end

			-- Setup rendering bounds for target.
			local mins, maxs = v:GetModelBounds();
			local pos = v:GetPos() + Vector(0, 0, mins[3]);
			local right = EyeAngles():Right();

			-- Compute render dimensions.
			local diff = maxs - mins;
			local span = right * diff[1] / 2;
			local height = pos + Vector(0, 0, diff[3]);

			-- Calculate lower-left, lower-right, upper-left and upper-right bounds in view space.
			local ll = (pos - span):ToScreen();
			local lr = (pos + span):ToScreen();
			local ul = (height - span):ToScreen();
			local ur = (height + span):ToScreen();

			-- Calculate UVs from view space bounds.
			local llu = ll.x / ScrW();
			local llv = ll.y / ScrH();
			local lru = lr.x / ScrW();
			local lrv = lr.y / ScrH();
			local ulu = ul.x / ScrW();
			local ulv = ul.y / ScrH();
			local uru = ur.x / ScrW();
			local urv = ur.y / ScrH();

			-- Coords table for surface poly rendering.
			local coords = {
				{ x = ll.x, y = ll.y, u = llu, v = llv },
				{ x = ul.x, y = ul.y, u = ulu, v = ulv },
				{ x = ur.x, y = ur.y, u = uru, v = urv },
				{ x = lr.x, y = lr.y, u = lru, v = lrv }
			};

			-- Render unprocessed texture over entity.
			surface.SetMaterial(texture)
			surface.SetDrawColor(Color(255, 255, 255, 255));
			surface.DrawPoly(coords);
		end
	end
};

----------------------------------------------------------------
-- Electromagnetic Tracking vision
----------------------------------------------------------------
SPLINTERCELL_NVG.Goggles[6] = {

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
		ent:GetClass() == "npc_combinegunship" || ent:GetClass() == "npc_helicopter" || ent:GetClass() == "npc_combinedropship" || ent:GetClass() == "npc_dog" || ent:GetClass() == "hl2_npc_turret_ground" ||
		(ent:IsPlayer() && ent:NVGBASE_IsGoggleActive());
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

	PostProcess = function(self)

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
SPLINTERCELL_NVG.Goggles[7] = {

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

	TagFadeOut = 2,
	TagDuration = 6,
	PingInterval = 10,
	PingMaxDistance = 1200,
	PingUnitsPerSecond = 400,

	Sounds = {
		Loop      = nil,
		ToggleOn  = "splinter_cell/goggles/sonar/sonar_goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/sonar/sonar_goggles_toggle_off.wav",
		Ping      = "splinter_cell/goggles/sonar/sonar_goggles_scan.wav"
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

	PostProcess = function(self)

		DrawBloom(2, 3.10, 1.75, 0.5, 2, -99.00, 155 / 255, 155 / 255, 155 / 255);
		DrawTexturize(1, Material("effects/splinter_cell/sonar.png"));
		DrawSharpen(10, 0.25)

		-- Final bloom pass with motion blur to give a glowing ghosting effect.
		DrawBloom(2, 3.10, 1.75, 0.5, 2, -99.00, 155 / 255, 155 / 255, 155 / 255);
		DrawMotionBlur(0.55, 0.8, 0);
	end,

	PreDrawOpaque = function(self)

		-- First sonar ping, play sound and raise flag.
		if (self.SonarPing == nil) then
			self.SonarPing = CurTime();
			surface.PlaySound(self.Sounds.Ping);
		end

		-- Calculate ping travel for entity processing later.
		local pingTime = CurTime() - self.SonarPing;
		local pingTravel = pingTime * self.PingUnitsPerSecond;
		if (pingTravel > self.PingMaxDistance) then pingTravel = 0; end

		-- Render sonar ping sphere.
		render.CullMode(MATERIAL_CULLMODE_CW);
		render.SetMaterial(Material("effects/splinter_cell/bright_white_alpha"));
		render.DrawSphere(EyePos(), pingTravel, 64, 64, Color(255, 255, 255));
		render.CullMode(MATERIAL_CULLMODE_CCW);

		-- Ping interval elapsed, reset flags for next ping.
		if (pingTime > self.PingInterval) then
			self.SonarPing = nil;
		end

		for k,v in pairs(ents.GetAll()) do

			-- Make sure the entity is visible and passing the motion tracking filter.
			if (!self.Filter(v)) then
				continue;
			end

			-- Save rendering options for later.
			v:NVGBASE_SaveRenderingSettings();

			-- Reset entity rendering if it is visible.
			if (LocalPlayer():NVGBASE_IsBoundingBoxVisible(v, 2048)) then
				v:NVGBASE_ResetRenderingSettings()
				continue;
			end

			-- Distance test against sonar ping travel.
			if (v.NVGBASE_SonarTagTime == nil && v:GetPos():Distance(LocalPlayer():GetPos()) < pingTravel) then
				v.NVGBASE_SonarTagTime = CurTime() + self.TagDuration;
			end

			-- Handle sonar target rendering. 
			if (v.NVGBASE_SonarTagTime == nil) then
				v:SetColor(Color(255, 255, 255, 0));
			else
				local alpha = Lerp(math.Clamp((CurTime() - v.NVGBASE_SonarTagTime) / self.TagFadeOut, 0, 1), 255, 0);
				v:SetColor(Color(255, 255, 255, alpha));
				if (alpha == 0) then v.NVGBASE_SonarTagTime = nil; end
			end

			v:SetRenderMode(RENDERMODE_TRANSALPHA);
		end
	end
};

----------------------------------------------------------------
-- Thermal vision (Splinter Cell Double Agent)
----------------------------------------------------------------
SPLINTERCELL_NVG.Goggles[8] = {

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

	PostProcess = function(self)

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
SPLINTERCELL_NVG.Goggles[9] = {

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

	PostProcess = function(self)
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
	end
};

----------------------------------------------------------------
-- High-Frequency Night
----------------------------------------------------------------

SPLINTERCELL_NVG.Goggles[10] = {

	Name = "High-Frequency Night",
	Whitelist = {
		"models/splinter_cell_4/player/john_hodge.mdl",
		"models/splinter_cell_4/player/sam_d.mdl",
		"models/splinter_cell_4/player/sam_f.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/interlace_overlay"),
	InterlaceColor    = Color(155, 155, 155, 64),

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
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 1,
		Size       = 200,
		Decay      = 200,
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
		ColorAdd   = Color(0, 0.7, 0),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 0.2,
		Contrast   = 1,
		Brightness = 0.05
	},

	PostProcess = function(self)
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
	end
};

----------------------------------------------------------------
-- High-Frequency Thermal
----------------------------------------------------------------

SPLINTERCELL_NVG.Goggles[11] = {

	Name = "High-Frequency Thermal",
	Whitelist = {
		"models/splinter_cell_4/player/john_hodge.mdl",
		"models/splinter_cell_4/player/sam_d.mdl",
		"models/splinter_cell_4/player/sam_f.mdl"
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

	PostProcess = function(self)

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
-- Thermal Goggles RSV2
----------------------------------------------------------------

SPLINTERCELL_NVG.Goggles[12] = {

	Name = "Thermal Goggles",
	Whitelist = {
		"models/rainbow_six_vegas_2/player/bishop_male_1.mdl",
		"models/rainbow_six_vegas_2/player/bishop_male_2.mdl",
		"models/rainbow_six_vegas_2/player/bishop_female_1.mdl",
		"models/rainbow_six_vegas_2/player/bishop_female_2.mdl"
	},

	MaterialOverlay   = Material("vgui/r6v2/scope_mask"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/r6v2/NvComb"),
	InterlaceColor    = Color(125, 55, 155, 2),

	MaterialOverride  = "effects/r6v2/motion_radius",
	Filter = function(ent)
		return ent:IsPlayer() || ent:IsNPC() || ent:IsNextBot();
	end,

	Sounds = {
		Loop      = "r6v2/goggles/r6_nvg_loop.wav",
		ToggleOn  = "r6v2/goggles/r6_nvg_on.wav",
		ToggleOff = "r6v2/goggles/r6_nvg_off.wav",
		Activate  = "r6v2/goggles/activate.wav"
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

	ProjectedTexture = {
		FOV        = 140,
		VFOV       = 100, -- Vertical FOV
		Brightness = 20,
		Distance   = 1024
	},

	PostProcess = function(self)

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
		DrawTexturize(1, Material("effects/r6v2/HvMapping.png"));

		-- Final bloom pass with motion blur to give a glowing ghosting effect.
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, 1, 155 / 255, 155 / 255, 155 / 255);
		-- DrawMotionBlur(0.3, 1.0, 0);
	end
};

----------------------------------------------------------------
-- Night Goggles RSV2
----------------------------------------------------------------

SPLINTERCELL_NVG.Goggles[13] = {

	Name = "Night",
	Whitelist = {
		"models/rainbow_six_vegas_2/player/bishop_male_1.mdl",
		"models/rainbow_six_vegas_2/player/bishop_male_2.mdl",
		"models/rainbow_six_vegas_2/player/bishop_female_1.mdl",
		"models/rainbow_six_vegas_2/player/bishop_female_2.mdl"
	},

	MaterialOverlay   = Material("vgui/r6v2/scope_mask"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/r6v2/NvComb"),
	InterlaceColor    = Color(155, 155, 155, 160),

	MaterialOverride  = nil,
	Filter = function(ent)
		return;
	end,

	Sounds = {
		Loop      = "r6v2/goggles/r6_nvg_loop.wav",
		ToggleOn  = "r6v2/goggles/r6_nvg_on.wav",
		ToggleOff = "r6v2/goggles/r6_nvg_off.wav",
		Activate  = "r6v2/goggles/activate.wav"
	},

	Lighting = {
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 1,
		Size       = 200,
		Decay      = 200,
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
		ColorAdd   = Color(0.1, 0.35, 0.05),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 0.25,
		Contrast   = 1,
		Brightness = 0.05
	},

	PostProcess = function(self)
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, 1, 155 / 255, 155 / 255, 155 / 255);
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
	end
};

-- Register the splinter cell NVG into the NVGBASE Goggless.
NVGBASE_LOADOUTS.Register("Splinter Cell", SPLINTERCELL_NVG);