
--! 
--! Main input entry point for the goggles. Will process the toggle and cycle key.
--!
hook.Add("PlayerButtonDown", "SPLINTERCELL_NVG_INPUT", function(player, button)

	-- Server only code. If whitelist system is on, make sure the player is whitelisted before.
	-- The only way to bypass the whitelist if it is on, is if the player already has his
	-- goggles active while his allowed goggles list changed, in that case, we allow to run
	-- to prevent him getting stuck in his active goggles.
	if (!SERVER) then return; end
	if (GAMEMODE:SCNVG_IsWhitelistOn() && !player:SCNVG_IsWhitelisted() && !player:SCNVG_IsGoggleActive()) then return; end

	-- If not already done, prepare networking data on the player.
	player:SCNVG_SetupNetworking();

	-- Toggle goggle on/off.
	if (player:SCNVG_CanToggleGoggle(button)) then
		player:SCNVG_ToggleGoggle();
	end

	-- Cycle between different goggle modes.
	if (player:SCNVG_CanSwitchGoggle(button)) then
		player:SCNVG_SwitchToNextGoggle();
	end
end);

--! 
--! Simple hook to handle goggle third person animations when toggling on/off.
--!
hook.Add("CalcMainActivity", "SPLINTERCELL_NVG_ANIMATIONS", function(player, velocity)

	-- This hook only belongs to Splinter Cell player models.
	if (!player:SCNVG_IsWhitelisted()) then return; end

	local toggled = player:SCNVG_IsGoggleActive();

	-- Goggles down animation.
	if (toggled && !player:SCNVG_CanToggleGoggle()) then
		return ACT_ARM, -1;
	end

	-- Goggles up animation.
	if (!toggled && !player:SCNVG_CanToggleGoggle()) then
		return ACT_DISARM, -1;
	end
end);

--! 
--! Simple hook to remove goggle on death.
--!
hook.Add("PlayerDeath", "SPLINTERCELL_NVG_DEATH", function(victim, inflictor, attacker)
	victim:SCNVG_ToggleGoggle(true, 0);
end);