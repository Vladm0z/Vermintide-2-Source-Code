-- chunkname: @scripts/settings/mutators/mutator_blessing_of_shallya.lua

require("scripts/settings/dlcs/morris/deus_blessing_settings")

return {
	display_name = DeusBlessingSettings.blessing_of_shallya.display_name,
	description = DeusBlessingSettings.blessing_of_shallya.description,
	icon = DeusBlessingSettings.blessing_of_shallya.icon,
	server_update_function = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		MutatorUtils.apply_buff_to_alive_player_units(arg_1_0, arg_1_1, "blessing_of_shallya_buff")
	end
}
