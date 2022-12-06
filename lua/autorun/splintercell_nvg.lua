
--! 
--! Main input entry point for the goggles. Will process the toggle and cycle key.
--!
hook.Add("PlayerButtonDown", "SPLINTERCELL_NVG_INPUT", function(player, button)

	-- Server only code.
	if (!SERVER) then return; end

	-- If whitelist system is on, make sure the player is whitelisted before.
	-- The only way to bypass the whitelist if it is on, is if the player already has his
	-- goggles active while his allowed goggles list changed, in that case, we allow to run
	-- to prevent him getting stuck in his active goggles.
	local whitelist = _G:SCNVG_IsWhitelistOn();
	if (whitelist && !player:SCNVG_IsWhitelisted() && !player:SCNVG_IsGoggleActive()) then return; end

	-- If not already done, prepare networking data on the player.
	player:SCNVG_SetupNetworking();

	-- Toggle goggle on/off.
	if (player:SCNVG_CanToggleGoggle(button)) then

		if (whitelist) then
			player:SetBodygroup(1, 0);
			player:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_ARM, true);
		end

		player:SCNVG_ToggleGoggle();
	end

	-- Cycle between different goggle modes.
	if (player:SCNVG_CanSwitchGoggle(button)) then
		player:SCNVG_SwitchToNextGoggle();
	end
end);

--! 
--! Simple hook to remove goggle on death.
--!
hook.Add("PlayerDeath", "SPLINTERCELL_NVG_DEATH", function(victim, inflictor, attacker)
	victim:SCNVG_ToggleGoggle(true, 0);
end);