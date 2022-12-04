
-- Setup convars to determine which key to use for the goggles. By default:
-- * KEY_N (24): Toggle goggle.
-- * KEY_M (23): Cycle goggle.
CreateClientConVar("SPLINTERCELL_NVG_INPUT", "24", true, true, "Which key to toggle goggle. Must be a number, refer to: https://wiki.facepunch.com/gmod/Enums/KEY.", 1, 159);
CreateClientConVar("SPLINTERCELL_NVG_CYCLE", "23", true, true, "Which key to cycle goggle. Must be a number, refer to: https://wiki.facepunch.com/gmod/Enums/KEY.", 1, 159);

-- Setup toggle and cycle commands for goggles.
CreateClientConVar("SPLINTERCELL_NVG_TOGGLE", "0", false, false);

-- Constants used to delay player input using the goggles to avoid epilepsy.
local __ToggleDelay = 1.5;
local __SwitchDelay = 0.5;

--!
--! @brief      Internal function. Creates the necessary network integers on the client.
--!
--! @param      player  The player to setup netowrking on.
--!
local function __SetupDefaults(player)

	if (player:GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 0) == 0) then
		player:SetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 1);
	end

	if (player:GetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", 0) == 0) then
		player:SetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", 1);
	end

	if (player:GetNWFloat("SPLINTERCELL_NVG_NEXT_TOGGLE", 0) == 0) then
		player:SetNWFloat("SPLINTERCELL_NVG_NEXT_TOGGLE", CurTime());
	end

	if (player:GetNWFloat("SPLINTERCELL_NVG_NEXT_SWITCH", 0) == 0) then
		player:SetNWFloat("SPLINTERCELL_NVG_NEXT_SWITCH", CurTime());
	end
end

--! 
--! Main input entry point for the goggles. Will process the toggle and cycle key.
--!
hook.Add("PlayerButtonDown", "SPLINTERCELL_NVG_INPUT", function(player, button)

	if (!SERVER) then return; end

	__SetupDefaults(player);

	-- Stop current goggle reference as the last one used.
	local toggle = GetConVar("SPLINTERCELL_NVG_TOGGLE"):GetBool();
	local current = player:GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE");

	-- Timing data.
	local nextToggle = player:GetNWInt("SPLINTERCELL_NVG_NEXT_TOGGLE");
	local nextSwitch = player:GetNWInt("SPLINTERCELL_NVG_NEXT_SWITCH");

	-- Current configuration.
	local goggle = SPLINTERCELL_NVG_CONFIG[current];

	-- Toggle on and off.
	if (button == GetConVar("SPLINTERCELL_NVG_INPUT"):GetInt() && CurTime() > nextToggle) then

		-- Emit sound on toggle on/off based on the goggle's config.
		if (!toggle) then
			player:EmitSound(goggle.Sounds.ToggleOn, 75, 100, 1, CHAN_ITEM);
		else
			player:EmitSound(goggle.Sounds.ToggleOff, 75, 100, 1, CHAN_ITEM);
		end

		-- Send out command to toggle the goggles.
		player:ConCommand("SPLINTERCELL_NVG_TOGGLE " .. (!toggle && 1 || 0));
		player:SetNWFloat("SPLINTERCELL_NVG_NEXT_TOGGLE", CurTime() + __ToggleDelay);
	end

	-- Cycle between different goggle modes.
	if (toggle && button == GetConVar("SPLINTERCELL_NVG_CYCLE"):GetInt() && CurTime() > nextSwitch) then

		player:SetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", current);

		-- Loop around the modes if we have gone past the last config.
		current = current + 1;
		if (current > #SPLINTERCELL_NVG_CONFIG) then current = 1; end
		player:SetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", current);
		player:SetNWFloat("SPLINTERCELL_NVG_NEXT_SWITCH", CurTime() + __SwitchDelay);
	end
end);

--! 
--! Simple hook to remove goggle on death.
--!
hook.Add("PlayerDeath", "SPLINTERCELL_NVG_DEATH", function(victim, inflictor, attacker)
	victim:ConCommand("SPLINTERCELL_NVG_TOGGLE 0");
end);