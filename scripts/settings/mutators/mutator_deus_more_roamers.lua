-- chunkname: @scripts/settings/mutators/mutator_deus_more_roamers.lua

local var_0_0 = 2

return {
	description = "mutator_deus_more_roamers_desc",
	display_name = "mutator_deus_more_roamers_name",
	hide_from_player_ui = true,
	icon = "mutator_icon_deus_more_roamers",
	tweak_pack_spawning_settings = function (arg_1_0, arg_1_1)
		MutatorUtils.tweak_pack_spawning_settings_density_multiplier(arg_1_1, var_0_0)
	end
}
