-- chunkname: @scripts/entity_system/systems/objective/objective_system_testify.lua

return {
	versus_objective_add_time = function(arg_1_0, arg_1_1)
		Managers.mechanism:game_mechanism():win_conditions():add_time(arg_1_1)
	end,
	versus_current_objective_position = function(arg_2_0)
		local var_2_0, var_2_1 = next(arg_2_0:active_leaf_objectives())

		if not arg_2_0:extension_by_objective_name(var_2_1) then
			return
		end

		local var_2_2 = {}
		local var_2_3 = arg_2_0:current_objectives_position()
		local var_2_4, var_2_5 = next(var_2_3)
		local var_2_6 = Math.random_range(-10, 10)
		local var_2_7 = Math.random_range(-10, 10)
		local var_2_8 = var_2_5 + Vector3(var_2_6, var_2_7, 0)
		local var_2_9, var_2_10, var_2_11, var_2_12, var_2_13 = EngineOptimized.closest_pos_at_main_path(var_2_8)

		var_2_2.objective_position = var_2_5
		var_2_2.random_position = var_2_8
		var_2_2.main_path_position = var_2_9

		return var_2_2
	end,
	versus_complete_objectives = function(arg_3_0)
		local var_3_0 = arg_3_0:active_objectives()

		for iter_3_0, iter_3_1 in ipairs(var_3_0) do
			arg_3_0:extension_by_objective_name(iter_3_1)._completed = true
		end
	end,
	versus_objective_name = function(arg_4_0)
		local var_4_0, var_4_1 = next(arg_4_0:active_objectives())

		return arg_4_0:extension_by_objective_name(var_4_1):objective_name()
	end,
	versus_objective_type = function(arg_5_0)
		local var_5_0, var_5_1 = next(arg_5_0:active_objectives())
		local var_5_2 = arg_5_0:extension_by_objective_name(var_5_1)

		if not var_5_2 then
			local var_5_3, var_5_4 = next(arg_5_0._objective_lists[#arg_5_0._objective_lists])

			if not var_5_2 then
				return "objective_not_supported"
			end
		end

		local var_5_5 = var_5_2.NAME

		if var_5_5 == "VersusCapturePointObjectiveExtension" then
			return "objective_capture_point"
		end

		if var_5_5 == "VersusInteractObjectiveExtension" then
			return "objective_interact"
		end

		if var_5_5 == "VersusVolumeObjectiveExtension" then
			return "objective_volume"
		end

		return "objective_not_supported"
	end,
	weave_spawn_essence_on_first_bot_position = function(arg_6_0)
		local var_6_0 = Managers.player:bots()[1].player_unit

		if var_6_0 then
			local var_6_1 = Unit.local_position(var_6_0, 0) + Vector3(0, 0, 0.2)

			arg_6_0:weave_essence_handler():spawn_essence_unit(var_6_1)
		end

		Managers.weave:increase_bar_score(2)
	end,
	get_num_main_objectives = function(arg_7_0)
		return arg_7_0:num_main_objectives()
	end,
	get_current_main_objective = function(arg_8_0)
		local var_8_0 = arg_8_0:current_objective_index()

		if var_8_0 < arg_8_0:num_main_objectives() then
			return var_8_0
		end

		local var_8_1 = next(arg_8_0._objective_lists[var_8_0])

		if arg_8_0:extension_by_objective_name(var_8_1):is_done() then
			return
		end

		return var_8_0
	end,
	wait_for_objectives_to_activate = function(arg_9_0)
		return arg_9_0:is_active()
	end
}
