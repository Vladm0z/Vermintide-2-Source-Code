-- chunkname: @scripts/settings/mutators/mutator_deus_less_hordes.lua

local var_0_0 = 1
local var_0_1 = -0.4
local var_0_2 = -0.4
local var_0_3 = -0.4
local var_0_4 = -0.4

return {
	description = "mutator_deus_less_hordes_desc",
	display_name = "mutator_deus_less_hordes_name",
	hide_from_player_ui = true,
	icon = "mutator_icon_deus_less_hordes",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		MutatorUtils.update_conflict_settings_horde_size_modifier(var_0_0)
		MutatorUtils.update_conflict_settings_horde_frequency(var_0_1, var_0_2, var_0_3, var_0_4)
	end
}
