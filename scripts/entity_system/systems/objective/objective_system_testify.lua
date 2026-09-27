-- chunkname: @scripts/entity_system/systems/objective/objective_system_testify.lua

return {
	versus_objective_add_time = function (arg_1_0, arg_1_1)
		-- function 1
		Managers.mechanism:game_mechanism():win_conditions():add_time(arg_1_1)
	end,
	versus_current_objective_position = function (self)
		-- function 2
		local var_2_0, var_2_1 = next(self:active_leaf_objectives())

		if not self:extension_by_objective_name(var_2_1) then
			return
		end

		local tbl = {}
		local current_objectives_position = self:current_objectives_position()
		local var_2_4, var_2_5 = next(current_objectives_position)
		local random_range = Math.random_range(-10, 10)
		local random_range_2 = Math.random_range(-10, 10)
		local num = var_2_5 + Vector3(random_range, random_range_2, 0)
		local closest_pos_at_main_path, var_2_10, var_2_11, var_2_12, var_2_13 = EngineOptimized.closest_pos_at_main_path(num)

		tbl.objective_position = var_2_5
		tbl.random_position = num
		tbl.main_path_position = closest_pos_at_main_path

		return tbl
	end,
	versus_complete_objectives = function (self)
		-- function 3
		local active_objectives = self:active_objectives()

		for i, v in ipairs(active_objectives) do
			self:extension_by_objective_name(v)._completed = true
		end
	end,
	versus_objective_name = function (self)
		-- function 4
		local var_4_0, var_4_1 = next(self:active_objectives())

		return self:extension_by_objective_name(var_4_1):objective_name()
	end,
	versus_objective_type = function (self)
		-- function 5
		local var_5_0, var_5_1 = next(self:active_objectives())
		local extension_by_objective_name = self:extension_by_objective_name(var_5_1)

		if not extension_by_objective_name then
			local var_5_3, var_5_4 = next(self._objective_lists[#self._objective_lists])

			if not extension_by_objective_name then
				return "objective_not_supported"
			end
		end

		local NAME = extension_by_objective_name.NAME

		if NAME == "VersusCapturePointObjectiveExtension" then
			return "objective_capture_point"
		end

		if NAME == "VersusInteractObjectiveExtension" then
			return "objective_interact"
		end

		if NAME == "VersusVolumeObjectiveExtension" then
			return "objective_volume"
		end

		return "objective_not_supported"
	end,
	weave_spawn_essence_on_first_bot_position = function (self)
		-- function 6
		local player_unit = Managers.player:bots()[1].player_unit

		if not player_unit then
			local num = Unit.local_position(player_unit, 0) + Vector3(0, 0, 0.2)

			self:weave_essence_handler():spawn_essence_unit(num)
		end

		Managers.weave:increase_bar_score(2)
	end,
	get_num_main_objectives = function (self)
		-- function 7
		return self:num_main_objectives()
	end,
	get_current_main_objective = function (self)
		-- function 8
		local current_objective_index = self:current_objective_index()

		if current_objective_index < self:num_main_objectives() then
			return current_objective_index
		end

		local var_8_1 = next(self._objective_lists[current_objective_index])

		if not self:extension_by_objective_name(var_8_1):is_done() then
			return
		end

		return current_objective_index
	end,
	wait_for_objectives_to_activate = function (self)
		-- function 9
		return self:is_active()
	end
}
