
-- Setup convars to determine which key to use for the goggles. By default:
-- * KEY_N (24): Toggle goggle.
-- * KEY_M (23): Cycle goggle.
CreateClientConVar("SPLINTERCELL_NVG_INPUT", "24", true, true, "Which key to toggle goggle. Must be a number, refer to: https://wiki.facepunch.com/gmod/Enums/KEY.", 1, 159);
CreateClientConVar("SPLINTERCELL_NVG_CYCLE", "23", true, true, "Which key to cycle goggle. Must be a number, refer to: https://wiki.facepunch.com/gmod/Enums/KEY.", 1, 159);

-- Setup toggle and cycle commands for goggles.
CreateClientConVar("SPLINTERCELL_NVG_TOGGLE", "0", false, false);

--!
--! @brief      Internal function. Creates the necessary network integers on the client.
--!
--! @param      player  The player to setup netowrking on.
--!
local function __SetupDefaults(player)

	if (player:GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 0) == 0) then
		player:SetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", 3);
	end

	if (player:GetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", 0) == 0) then
		player:SetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", 1);
	end
end

--! 
--! Main input entry point for the goggles. Will process the toggle and cycle key.
--!
hook.Add("PlayerButtonDown", "SPLINTERCELL_NVG_INPUT", function(player, button)

	__SetupDefaults(player);

	-- Toggle on and off.
	if (button == GetConVar("SPLINTERCELL_NVG_INPUT"):GetInt()) then

		local toggle = GetConVar("SPLINTERCELL_NVG_TOGGLE"):GetBool();
		player:ConCommand("SPLINTERCELL_NVG_TOGGLE " .. (!toggle && 1 || 0));
	end

	-- Cycle between different goggle modes.
	if (button == GetConVar("SPLINTERCELL_NVG_CYCLE"):GetInt()) then

		-- Stop current goggle reference as the last one used.
		local current = player:GetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE");
		player:SetNWInt("SPLINTERCELL_NVG_LAST_GOGGLE", current);

		-- Loop around the modes if we have gone past the last config.
		current = current + 1;
		if (current > #SPLINTERCELL_NVG_CONFIG) then current = 1; end
		player:SetNWInt("SPLINTERCELL_NVG_CURRENT_GOGGLE", current);
	end
end);