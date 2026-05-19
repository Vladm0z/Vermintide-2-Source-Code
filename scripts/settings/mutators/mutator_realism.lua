-- chunkname: @scripts/settings/mutators/mutator_realism.lua

return {
	description = "description_mutator_realism",
	display_name = "display_name_mutator_realism",
	icon = "mutator_icon_realism",
	client_start_function = function(arg_1_0, arg_1_1)
		Managers.state.entity:system("outline_system"):set_disabled(true)
	end,
	client_stop_function = function(arg_2_0, arg_2_1)
		if not arg_2_0.is_destroy then
			Managers.state.entity:system("outline_system"):set_disabled(false)
		end
	end
}
