-- chunkname: @scripts/settings/mutators/mutator_no_respawn.lua

return {
	description = "description_mutator_no_respawn",
	icon = "mutator_icon_no_respawn",
	display_name = "display_name_mutator_no_respawn",
	server_start_function = function (arg_1_0, arg_1_1)
		Managers.state.game_mode:set_respawning_enabled(false)
	end
}
