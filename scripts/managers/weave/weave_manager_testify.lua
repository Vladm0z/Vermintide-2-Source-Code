-- chunkname: @scripts/managers/weave/weave_manager_testify.lua

require("scripts/settings/weave_settings")

return {
	set_next_weave = function(arg_1_0, arg_1_1)
		arg_1_0._remaining_time = WeaveSettings.starting_time

		arg_1_0:set_next_weave(arg_1_1)
		arg_1_0:set_next_objective(1)
	end,
	get_weave_end_zone = function(arg_2_0, arg_2_1)
		return WeaveSettings.templates_ordered[arg_2_1].objectives[1].end_zone_name
	end,
	weave_remaining_time = function(arg_3_0)
		return arg_3_0._remaining_time
	end,
	get_active_weave_phase = function(arg_4_0)
		return arg_4_0:get_active_weave_phase()
	end
}
