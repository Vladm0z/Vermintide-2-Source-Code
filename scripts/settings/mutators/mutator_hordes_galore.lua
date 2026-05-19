-- chunkname: @scripts/settings/mutators/mutator_hordes_galore.lua

local var_0_0 = 0.9
local var_0_1 = 0.9
local var_0_2 = 0.7
local var_0_3 = 0.7

return {
	description = "description_mutator_hordes_galore",
	icon = "mutator_icon_hordes_galore",
	display_name = "display_name_mutator_hordes_galore",
	update_conflict_settings = function(arg_1_0, arg_1_1)
		MutatorUtils.update_conflict_settings_horde_frequency(var_0_0, var_0_1, var_0_2, var_0_3)
	end
}
