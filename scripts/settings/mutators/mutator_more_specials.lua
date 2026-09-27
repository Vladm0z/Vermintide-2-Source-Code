-- chunkname: @scripts/settings/mutators/mutator_more_specials.lua

local num = 2
local num_2 = 1

return {
	description = "description_mutator_more_specials",
	icon = "mutator_icon_specials_frequency",
	display_name = "display_name_mutator_more_specials",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		-- function 1
		MutatorUtils.update_conflict_settings_specials_frequency(num, num_2)
	end
}
