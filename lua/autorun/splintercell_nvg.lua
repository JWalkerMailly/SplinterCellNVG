
--! 
--! Main input entry point for the goggles. Will process the toggle and cycle key.
--!
hook.Add("PlayerButtonDown", "SPLINTERCELL_NVG_INPUT", function(player, button)

	-- Server only code.
	if (!SERVER) then return; end

	local whitelist = _G:SCNVG_IsWhitelistOn();
	local playerWhitelisted = player:SCNVG_IsWhitelisted();
	local gogglesActive = player:SCNVG_IsGoggleActive();

	-- If whitelist system is on, make sure the player is whitelisted before.
	-- The only way to bypass the whitelist if it is on, is if the player already has his
	-- goggles active while his allowed goggles list changed, in that case, we allow to run
	-- to prevent him getting stuck in his active goggles.
	if (whitelist && !playerWhitelisted && !gogglesActive) then return; end

	-- If not already done, prepare networking data on the player.
	player:SCNVG_SetupNetworking();

	-- Toggle goggle on/off.
	if (player:SCNVG_CanToggleGoggle(button)) then

		-- Play toggle animation.
		if (playerWhitelisted) then

			local anim = ACT_DISARM;
			if (!gogglesActive) then anim = ACT_ARM; end

			-- Will only play server side.
			player:SetBodygroup(1, !gogglesActive && 0 || 1);
			player:AnimRestartGesture(GESTURE_SLOT_CUSTOM, anim, true);

			-- Send out net message to play animation on client.
			net.Start("SPLINTERCELL_NVG_TOGGLE_ANIM");
				net.WriteEntity(player);
				net.WriteBool(gogglesActive);
				net.WriteInt(anim, 14);
			net.Broadcast();
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