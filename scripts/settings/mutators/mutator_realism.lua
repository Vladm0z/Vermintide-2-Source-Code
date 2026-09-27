-- chunkname: @scripts/settings/mutators/mutator_realism.lua

return {
	description = "description_mutator_realism",
	display_name = "display_name_mutator_realism",
	icon = "mutator_icon_realism",
	client_start_function = function (arg_1_0, arg_1_1)
		-- function 1
		Managers.state.entity:system("outline_system"):set_disabled(true)
	end,
	client_stop_function = function (self, arg_2_1)
		-- function 2
		if not self.is_destroy then
			Managers.state.entity:system("outline_system"):set_disabled(false)
		end
	end
}
