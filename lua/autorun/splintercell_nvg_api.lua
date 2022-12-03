
local player = FindMetaTable("Player");

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