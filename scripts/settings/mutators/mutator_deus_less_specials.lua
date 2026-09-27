-- chunkname: @scripts/settings/mutators/mutator_deus_less_specials.lua

local num = 0.5
local num_2 = 1.5

return {
	description = "mutator_deus_less_specials_desc",
	display_name = "mutator_deus_less_specials_name",
	hide_from_player_ui = true,
	icon = "mutator_icon_deus_less_specials",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		-- function 1
		MutatorUtils.update_conflict_settings_specials_frequency(num, num_2)
	end
}
