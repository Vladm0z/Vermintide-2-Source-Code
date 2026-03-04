-- chunkname: @scripts/settings/mutators/mutator_easier_hordes.lua

local var_0_0 = 0.5

return {
	hide_from_player_ui = true,
	update_conflict_settings = function (arg_1_0, arg_1_1)
		CurrentPacing.multiple_hordes = 2

		MutatorUtils.update_conflict_settings_horde_size_modifier(var_0_0)
	end
}
