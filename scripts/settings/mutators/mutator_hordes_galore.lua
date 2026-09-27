-- chunkname: @scripts/settings/mutators/mutator_hordes_galore.lua

local num = 0.9
local num_2 = 0.9
local num_3 = 0.7
local num_4 = 0.7

return {
	description = "description_mutator_hordes_galore",
	icon = "mutator_icon_hordes_galore",
	display_name = "display_name_mutator_hordes_galore",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		-- function 1
		MutatorUtils.update_conflict_settings_horde_frequency(num, num_2, num_3, num_4)
	end
}
