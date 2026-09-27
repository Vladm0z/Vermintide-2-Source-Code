-- chunkname: @scripts/managers/weave/weave_manager_testify.lua

require("scripts/settings/weave_settings")

return {
	set_next_weave = function (self, arg_1_1)
		-- function 1
		self._remaining_time = WeaveSettings.starting_time

		self:set_next_weave(arg_1_1)
		self:set_next_objective(1)
	end,
	get_weave_end_zone = function (arg_2_0, arg_2_1)
		-- function 2
		return WeaveSettings.templates_ordered[arg_2_1].objectives[1].end_zone_name
	end,
	weave_remaining_time = function (self)
		-- function 3
		return self._remaining_time
	end,
	get_active_weave_phase = function (self)
		-- function 4
		return self:get_active_weave_phase()
	end
}
