-- chunkname: @scripts/settings/mutators/mutator_deus_less_roamers.lua

local num = 0.5

return {
	description = "mutator_deus_less_roamers_desc",
	display_name = "mutator_deus_less_roamers_name",
	hide_from_player_ui = true,
	icon = "mutator_icon_deus_less_roamers",
	tweak_pack_spawning_settings = function (arg_1_0, arg_1_1)
		-- function 1
		MutatorUtils.tweak_pack_spawning_settings_density_multiplier(arg_1_1, num)
	end
}
