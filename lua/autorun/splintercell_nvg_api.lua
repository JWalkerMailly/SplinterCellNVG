
-- Server side whitelist convar.
if (SERVER) then
	CreateConVar("SPLINTERCELL_NVG_WHITELIST", "1");
	util.AddNetworkString("SPLINTERCELL_NVG_TOGGLE_ANIM");
end

net.Receive("SPLINTERCELL_NVG_TOGGLE_ANIM", function()

	local player = net.ReadEntity();
	local gogglesActive = net.ReadBool();
	local anim = net.ReadInt(14);

	if (IsValid(player)) then
		player:SetBodygroup(1, !gogglesActive && 0 || 1);
		player:AnimRestartGesture(GESTURE_SLOT_CUSTOM, anim, true);
	end
end);

-- Setup convars to determine which key to use for the goggles. By default:
-- * KEY_N (24): Toggle goggle.
-- * KEY_M (23): Cycle goggle.
CreateClientConVar("SPLINTERCELL_NVG_INPUT", "24", true, true, "Which key to toggle goggle. Must be a number, refer to: https://wiki.facepunch.com/gmod/Enums/KEY.", 1, 159);
CreateClientConVar("SPLINTERCELL_NVG_CYCLE", "23", true, true, "Which key to cycle goggle. Must be a number, refer to: https://wiki.facepunch.com/gmod/Enums/KEY.", 1, 159);

-- Setup toggle and cycle commands for goggles.
CreateClientConVar("SPLINTERCELL_NVG_TOGGLE", "0", false, true);

--!
--! @brief      Utility function to determine if player model whitelisting is on.
--!
--! @return     True if it is, False otherwise.
--!
function _G:SCNVG_IsWhitelistOn()
	return GetConVar("SPLINTERCELL_NVG_WHITELIST"):GetBool();
end

-- Constants used to delay player input using the goggles to avoid epilepsy.
local __ToggleDelay = 0.5;
local __SwitchDelay = 0.5;

local player = FindMetaTable("Player");

--!
--! @brief      Utility function, must be called once of the player. This will setup
--!             all the necessary network data on the player.
--!
function player:SCNVG_SetupNetworking()

	if (self:GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 0) == 0) then
		self:SetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 1);
	end

	if (self:GetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", 0) == 0) then
		self:SetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", 1);
	end

	if (self:GetNWFloat("SPLINTERCELL_NVG_NEXT_TOGGLE", 0) == 0) then
		self:SetNWFloat("SPLINTERCELL_NVG_NEXT_TOGGLE", CurTime());
	end

	if (self:GetNWFloat("SPLINTERCELL_NVG_NEXT_SWITCH", 0) == 0) then
		self:SetNWFloat("SPLINTERCELL_NVG_NEXT_SWITCH", CurTime());
	end
end

--!
--! @return     Returns the player's toggle key.
--!
function player:SCNVG_GetGoggleToggleKey()
	return self:GetInfoNum("SPLINTERCELL_NVG_INPUT", 24);
end

--!
--! @return     Return's the player's cycle mode key.
--!
function player:SCNVG_GetGoggleSwitchKey()
	return self:GetInfoNum("SPLINTERCELL_NVG_CYCLE", 23);
end

--!
--! @return     Returns the next time the goggle and be toggled. If you are comparing against
--!             this value, simply check that CurTime() is greater for "can toggle".
--!
function player:SCNVG_GetNextToggleTime()
	return self:GetNWFloat("SPLINTERCELL_NVG_NEXT_TOGGLE", CurTime());
end

--!
--! @return     Returns the next time the goggle and be switched. If you are comparing against
--!             this value, simply check that CurTime() is greater for "can switch".
--!
function player:SCNVG_GetNextSwitchTime()
	return self:GetNWFloat("SPLINTERCELL_NVG_NEXT_SWITCH", CurTime());
end

--!
--! @return     True if the goggles are currently toggled on, False otherwise.
--!
function player:SCNVG_IsGoggleActive()
	return self:GetInfoNum("SPLINTERCELL_NVG_TOGGLE", 0) == 1;
end

--!
--! @brief      Utility function to toggle a player's goggles.
--!
--! @param      silent  Optional, if set to true, will not emit a sound to other players.
--! @param      force   Optional, used to override the state to on (1) or off (0).
--!
function player:SCNVG_ToggleGoggle(silent, force)

	local toggled = self:SCNVG_IsGoggleActive();

	-- Failsafe if the goggle has changed to one that we don't have access to. A good example
	-- of this would be a gamemode where player model whitelisting is on and the player has
	-- switched teams mid game. The new model or team might not have access to the last goggle he used.
	if (_G:SCNVG_IsWhitelistOn() && !toggled && !self:SCNVG_IsWhitelisted(self:GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE"))) then
		self:SCNVG_SwitchToNextGoggle();
	end

	if (force != nil) then
		self:ConCommand("SPLINTERCELL_NVG_TOGGLE " .. force);
		self:SetNWFloat("SPLINTERCELL_NVG_NEXT_TOGGLE", CurTime() + __ToggleDelay);
	else
		self:ConCommand("SPLINTERCELL_NVG_TOGGLE " .. (!toggled && 1 || 0));
		self:SetNWFloat("SPLINTERCELL_NVG_NEXT_TOGGLE", CurTime() + __ToggleDelay);
	end

	if (!silent) then
		local goggle = self:SCNVG_GetGoggle();
		if (!toggled) then self:EmitSound(goggle.Sounds.ToggleOn, 75, 100, 1, CHAN_ITEM);
		else self:EmitSound(goggle.Sounds.ToggleOff, 75, 100, 1, CHAN_ITEM); end
	end
end

--!
--! @brief      Utility function to switch to the next goggle. If whitelisting is on,
--!             will switch to the next goggle the user has access to. If whitelisting
--!             is off, will cycle through all the goggles.
--!
function player:SCNVG_SwitchToNextGoggle()

	local current = self:GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE");
	self:SetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", current);

	if (!_G:SCNVG_IsWhitelistOn()) then

		-- Whitelist mode is not on, cycle through all the goggles normally.
		current = current + 1;
		if (current > #SPLINTERCELL_NVG_CONFIG) then current = 1; end
		self:SetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", current);
		self:SetNWFloat("SPLINTERCELL_NVG_NEXT_SWITCH", CurTime() + __SwitchDelay);
	else

		local model = self:GetModel();
		for k,v in ipairs(SPLINTERCELL_NVG_CONFIG) do

			-- Skip the goggle we are using and find the next according to the whitelists.
			if (k == current) then continue; end
			for x,y in pairs(v.Whitelist) do
				if (y == model) then
					self:SetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", k);
					self:SetNWFloat("SPLINTERCELL_NVG_NEXT_SWITCH", CurTime() + __SwitchDelay);
					return;
				end
			end
		end
	end
end

--!
--! @brief      Utility function to determine if the player can toggle their goggles. If no
--!             key is provided, will only take into account timing since last toggle.
--!
--! @param      key   Optional, the key code used to toggle the goggles.
--!
--! @return     True if can be toggled, False otherwise.
--!
function player:SCNVG_CanToggleGoggle(key)
	if (key == nil) then return CurTime() > self:SCNVG_GetNextToggleTime(); end
	return key == self:SCNVG_GetGoggleToggleKey() && CurTime() > self:SCNVG_GetNextToggleTime();
end

--!
--! @brief      Utility function to determine if the player can switch their goggles. If no
--!             key is provided, will only take into account timing since last switch.
--!
--! @param      key   Optional, the key code used to switch the goggles.
--!
--! @return     True if can be switched, False otherwise.
--!
function player:SCNVG_CanSwitchGoggle(key)
	local toggled = self:SCNVG_IsGoggleActive();
	if (key == nil) then return toggled && CurTime() > self:SCNVG_GetNextSwitchTime(); end
	return toggled && key == self:SCNVG_GetGoggleSwitchKey() && CurTime() > self:SCNVG_GetNextSwitchTime();
end

--!
--! @brief      Return the table config of the player's current goggle.
--!
--! @return     NVG Table.
--! @debug      lua_run PrintTable(Entity(1):SCNVG_GetGoggle())
--!
function player:SCNVG_GetGoggle()
	local goggle = self:GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 0);
	if (goggle == 0) then return nil; end
	return SPLINTERCELL_NVG_CONFIG[goggle];
end

--!
--! @brief      Utility function to set a goggle on the player. Does not toggle the
--!             goggle, will simply set the reference for the next toggle.
--!
--! @param      name  The name of the goggle to use when toggling.
--!
--! @return     True on success, False otherwise.
--! @debug      lua_run print(Entity(1):SCNVG_SetGoggle("Thermal"))
--!
function player:SCNVG_SetGoggle(name)

	local goggle = nil
	for k,v in pairs(SPLINTERCELL_NVG_CONFIG) do if (v.Name == name) then goggle = k; end end
	if (goggle == nil) then return false; end

	self:SetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", goggle);
	return true;
end

--!
--! @brief      Return the table config of the player's last goggle.
--!
--! @return     NVG Table.
--! @debug      lua_run PrintTable(Entity(1):SCNVG_GetPreviousGoggle())
--!
function player:SCNVG_GetPreviousGoggle()
	local goggle = self:GetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", 0);
	if (goggle == 0) then return nil; end
	return SPLINTERCELL_NVG_CONFIG[goggle];
end

--!
--! @brief      Determines if the player is whitelisted for a goggle according to his playermodel.
--!             If no goggle is supplied, will do a general check to see if he can use the goggle feature.
--!
--! @param      goggle  The goggle to test against (key, or nil for a general check. 
--!
--! @return     True if whitelisted, False otherwise.
--! @debug 		lua_run print(Entity(1):SCNVG_IsWhitelisted())
--! @debug 		lua_run print(Entity(1):SCNVG_IsWhitelisted(1))
--!
function player:SCNVG_IsWhitelisted(goggle)

	local model = self:GetModel();
	if (goggle == nil) then
		for k,v in ipairs(SPLINTERCELL_NVG_CONFIG) do
			for x,y in pairs(v.Whitelist) do
				if (model == y) then return true; end
			end
		end
	else
		for k,v in pairs(SPLINTERCELL_NVG_CONFIG[goggle].Whitelist) do
			if (model == v) then return true; end
		end
	end

	return false;
end