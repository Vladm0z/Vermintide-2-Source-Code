-- chunkname: @scripts/managers/weave/weave_manager_testify.lua

require("scripts/settings/weave_settings")

local WeaveManagerTestify = {
	set_next_weave = function (weave_manager, weave_name)
		-- function 1
		weave_manager._remaining_time = WeaveSettings.starting_time

		weave_manager:set_next_weave(weave_name)
		weave_manager:set_next_objective(1)
	end,
	get_weave_end_zone = function (weave_manager, weave_number)
		-- function 2
		local weave_template = WeaveSettings.templates_ordered[weave_number]

		return weave_template.objectives[1].end_zone_name
	end,
	weave_remaining_time = function (weave_manager)
		-- function 3
		return weave_manager._remaining_time
	end,
	get_active_weave_phase = function (weave_manager)
		-- function 4
		return weave_manager:get_active_weave_phase()
	end
}

return WeaveManagerTestify
