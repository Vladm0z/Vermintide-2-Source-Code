-- chunkname: @scripts/settings/mutators/mutator_realism.lua

return {
	description = "description_mutator_realism",
	display_name = "display_name_mutator_realism",
	icon = "mutator_icon_realism",
	client_start_function = function (context, data)
		-- function 1
		local outline_system = Managers.state.entity:system("outline_system")

		outline_system:set_disabled(true)
	end,
	client_stop_function = function (context, data)
		-- function 2
		if not context.is_destroy then
			local outline_system = Managers.state.entity:system("outline_system")

			outline_system:set_disabled(false)
		end
	end
}
