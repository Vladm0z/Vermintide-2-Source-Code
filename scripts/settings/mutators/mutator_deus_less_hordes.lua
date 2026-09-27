-- chunkname: @scripts/settings/mutators/mutator_deus_less_hordes.lua

local num = 1
local num_2 = -0.4
local num_3 = -0.4
local num_4 = -0.4
local num_5 = -0.4

return {
	description = "mutator_deus_less_hordes_desc",
	display_name = "mutator_deus_less_hordes_name",
	hide_from_player_ui = true,
	icon = "mutator_icon_deus_less_hordes",
	update_conflict_settings = function (arg_1_0, arg_1_1)
		-- function 1
		MutatorUtils.update_conflict_settings_horde_size_modifier(num)
		MutatorUtils.update_conflict_settings_horde_frequency(num_2, num_3, num_4, num_5)
	end
}
