
if (SERVER) then
	util.AddNetworkString("NVGBASE_TOGGLE_ANIM");
end

--! 
--! Used to handle animations clientside since the input handler will only be serverside.
--!
net.Receive("NVGBASE_TOGGLE_ANIM", function()

	local player = net.ReadEntity();
	local gogglesActive = net.ReadBool();
	local anim = net.ReadInt(14);
	local bodygroup = net.ReadInt(14);
	local bodygroupOn = net.ReadInt(14);
	local bodygroupOff = net.ReadInt(14);

	player:NVGBASE_AnimGoggle(gogglesActive, anim, bodygroup, bodygroupOn, bodygroupOff);
end);

--! 
--! Main input entry point for the goggles. Will process the toggle and cycle key.
--!
hook.Add("PlayerButtonDown", "NVGBASE_INPUT", function(player, button)

	-- Server only code.
	if (!SERVER) then return; end

	-- Do nothing if the player is not using a loadout at the moment.
	local loadout = player:NVGBASE_GetLoadout();
	if (loadout == nil) then return; end

	local whitelist = _G:NVGBASE_IsWhitelistOn();
	local playerWhitelisted = player:NVGBASE_IsWhitelisted(loadout);
	local gogglesActive = player:NVGBASE_IsGoggleActive();

	-- If whitelist system is on, make sure the player is whitelisted before.
	-- The only way to bypass the whitelist if it is on, is if the player already has his
	-- goggles active while his allowed goggles list changed, in that case, we allow to run
	-- to prevent him getting stuck in his active goggles.
	if (whitelist && !playerWhitelisted && !gogglesActive) then return; end

	-- Toggle goggle on/off.
	if (player:NVGBASE_CanToggleGoggle(button)) then

		-- Play toggle animation.
		if (loadout.Settings.Gestures != nil && playerWhitelisted) then

			local anim = loadout.Settings.Gestures.Off;
			if (!gogglesActive) then anim = loadout.Settings.Gestures.On; end

			local bodygroup = loadout.Settings.BodyGroups.Group;
			local bodygroupOn = loadout.Settings.BodyGroups.Values.On;
			local bodygroupOff = loadout.Settings.BodyGroups.Values.Off;

			-- Will only play server side.
			player:NVGBASE_AnimGoggle(gogglesActive, anim, bodygroup, bodygroupOn, bodygroupOff);

			-- Send out net message to play animation on client.
			net.Start("NVGBASE_TOGGLE_ANIM");
				net.WriteEntity(player);
				net.WriteBool(gogglesActive);
				net.WriteInt(anim, 14);
				net.WriteInt(bodygroup, 14);
				net.WriteInt(bodygroupOn, 14);
				net.WriteInt(bodygroupOff, 14);
			net.Broadcast();
		end

		player:NVGBASE_ToggleGoggle(loadout);
	end

	-- Cycle between different goggle modes.
	if (player:NVGBASE_CanSwitchGoggle(button)) then
		player:NVGBASE_SwitchToNextGoggle(loadout);
	end
end);

--! 
--! Simple hook to remove goggle on death.
--!
hook.Add("PlayerDeath", "NVGBASE_DEATH", function(victim, inflictor, attacker)

	-- Do nothing if the player is not using a loadout at the moment.
	local loadout = victim:NVGBASE_GetLoadout();
	if (loadout == nil) then return; end
	victim:NVGBASE_ToggleGoggle(loadout, true, 0);
end);