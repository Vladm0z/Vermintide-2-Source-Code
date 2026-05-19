-- chunkname: @scripts/entity_system/systems/ai/ai_group_templates/ai_group_templates.lua

AIGroupTemplates = AIGroupTemplates or {}

local var_0_0 = ScriptUnit.extension
local var_0_1 = BLACKBOARDS

AIGroupTemplates.mini_patrol = {
	pre_unit_init = function(arg_1_0, arg_1_1)
		var_0_1[arg_1_0].sneaky = true
	end,
	init = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		return
	end,
	update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		return
	end,
	destroy = function(arg_4_0, arg_4_1, arg_4_2)
		Managers.state.conflict:mini_patrol_killed(arg_4_2.id)
	end
}
AIGroupTemplates.horde = {
	pre_unit_init = function(arg_5_0, arg_5_1)
		if arg_5_1.sneaky then
			var_0_1[arg_5_0].sneaky = true
		end
	end,
	init = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		Managers.state.conflict.horde_spawner:set_horde_has_spawned(arg_6_2.id)
	end,
	update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		if arg_7_2 and arg_7_2.group_data then
			-- block empty
		end
	end,
	destroy = function(arg_8_0, arg_8_1, arg_8_2)
		Managers.state.conflict:horde_killed(arg_8_2.group_data and arg_8_2.group_data.horde_wave or "?")
		Managers.state.conflict.horde_spawner:set_horde_is_done(arg_8_2.id)
	end
}
AIGroupTemplates.boss_door_closers = {
	pre_unit_init = function(arg_9_0, arg_9_1)
		return
	end,
	init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		return
	end,
	update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		return
	end,
	destroy = function(arg_12_0, arg_12_1, arg_12_2)
		return
	end
}
AIGroupTemplates.resurrected = {
	pre_unit_init = function(arg_13_0, arg_13_1)
		local var_13_0 = var_0_1[arg_13_0]

		var_13_0.ignore_interest_points = true
		var_13_0.ignore_passive_on_patrol = true
	end,
	init = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		return
	end,
	update = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		return
	end,
	destroy = function(arg_16_0, arg_16_1, arg_16_2)
		print("Group is destroyed", arg_16_2)

		if arg_16_2 then
			arg_16_2.commanding_player.resurrected_group_id = nil
			arg_16_2.commanding_player = nil
		end
	end
}
AIGroupTemplates.encampment = {
	pre_unit_init = function(arg_17_0, arg_17_1)
		ScriptUnit.extension(arg_17_0, "ai_system"):set_perception("perception_regular", "pick_encampment_target_idle")

		var_0_1[arg_17_0].ignore_interest_points = true
	end,
	setup_group = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		arg_18_2.idle = true
	end,
	init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		return
	end,
	update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		local var_20_0 = arg_20_2.group_data
		local var_20_1 = arg_20_3 > var_20_0.spawn_time + 10

		Debug.text(string.format("Encampment size: %d/%d awake %s", arg_20_2.members_n, arg_20_2.size, tostring(var_20_1)))

		local var_20_2 = Managers.state.side:get_side(arg_20_2.side_id):get_enemy_sides()[1]
		local var_20_3 = var_20_2.PLAYER_POSITIONS
		local var_20_4 = var_20_2.PLAYER_UNITS

		if arg_20_2.idle and var_20_1 then
			local var_20_5 = var_20_0.encampment.pos:unbox()

			for iter_20_0 = 1, #var_20_3 do
				local var_20_6 = var_20_3[iter_20_0]

				if Vector3.distance(var_20_5, var_20_6) < 15 then
					AIGroupTemplates.encampment.wake_up_encampment(arg_20_2, var_20_4[iter_20_0])

					break
				end
			end
		end
	end,
	destroy = function(arg_21_0, arg_21_1, arg_21_2)
		print("Encampment killed")
	end,
	wake_up_encampment = function(arg_22_0, arg_22_1)
		arg_22_0.idle = false, Managers.state.entity:system("ai_group_system"):run_func_on_all_members(arg_22_0, AIGroupTemplates.encampment.wake_up_unit, arg_22_1)
	end,
	wake_up_unit = function(arg_23_0, arg_23_1, arg_23_2)
		local var_23_0 = var_0_0(arg_23_0, "ai_system")

		var_23_0:enemy_aggro(nil, arg_23_2)

		local var_23_1 = var_23_0._breed

		var_23_0:set_perception(var_23_1.perception, var_23_1.target_selection)
	end
}
AIGroupTemplates.spawn_test = {
	pre_unit_init = function(arg_24_0, arg_24_1)
		var_0_1[arg_24_0].far_off_despawn_immunity = true
	end,
	init = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
		arg_25_2.kill_after_time = arg_25_3 + 2
		arg_25_2.check_size = arg_25_2.num_spawned_members
	end,
	setup_group = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
		return
	end,
	update = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		if arg_27_3 > arg_27_2.kill_after_time then
			for iter_27_0, iter_27_1 in pairs(arg_27_2.members) do
				if HEALTH_ALIVE[iter_27_0] then
					Managers.state.conflict:destroy_unit(iter_27_0, var_0_1[iter_27_0], "test")

					arg_27_2.check_size = arg_27_2.check_size - 1
				end
			end

			local var_27_0 = Managers.state.entity:system("spawner_system")

			var_27_0.tests_running = var_27_0.tests_running - 1
		end
	end,
	destroy = function(arg_28_0, arg_28_1, arg_28_2)
		if arg_28_2.check_size ~= 0 then
			local var_28_0 = arg_28_2.group_data.spawner_unit

			print(string.format("### DESTROY Bad spawner: %s at %s", tostring(var_28_0), tostring(Unit.local_position(var_28_0, 0))))
		else
			print("spawner id ", arg_28_2.id, "is ok!")
		end
	end
}

DLCUtils.merge("ai_group_templates", AIGroupTemplates)
