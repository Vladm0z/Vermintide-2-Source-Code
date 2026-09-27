-- chunkname: @scripts/entity_system/systems/ai/ai_group_templates/ai_group_templates.lua

local AIGroupTemplates = AIGroupTemplates

AIGroupTemplates = AIGroupTemplates or {}
AIGroupTemplates = AIGroupTemplates

local extension = ScriptUnit.extension
local BLACKBOARDS = BLACKBOARDS

AIGroupTemplates.mini_patrol = {
	pre_unit_init = function (arg_1_0, arg_1_1)
		-- function 1
		BLACKBOARDS[arg_1_0].sneaky = true
	end,
	init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		return
	end,
	update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		return
	end,
	destroy = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		Managers.state.conflict:mini_patrol_killed(arg_4_2.id)
	end
}
AIGroupTemplates.horde = {
	pre_unit_init = function (arg_5_0, arg_5_1)
		-- function 5
		if not arg_5_1.sneaky then
			BLACKBOARDS[arg_5_0].sneaky = true
		end
	end,
	init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		Managers.state.conflict.horde_spawner:set_horde_has_spawned(arg_6_2.id)
	end,
	update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		if not (not arg_7_2 and arg_7_2.group_data) then
			-- Nothing
		end
	end,
	destroy = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		local conflict = Managers.state.conflict
		local var_8_1 = conflict
		local horde_killed = conflict.horde_killed
		local horde_wave

		if not arg_8_2.group_data then
			horde_wave = arg_8_2.group_data.horde_wave

			if not horde_wave then
				-- Nothing
			end
		end

		horde_wave = "?"

		::label_8_0::

		horde_killed(var_8_1, horde_wave)
		Managers.state.conflict.horde_spawner:set_horde_is_done(arg_8_2.id)
	end
}
AIGroupTemplates.boss_door_closers = {
	pre_unit_init = function (arg_9_0, arg_9_1)
		-- function 9
		return
	end,
	init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		-- function 10
		return
	end,
	update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		-- function 11
		return
	end,
	destroy = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		return
	end
}
AIGroupTemplates.resurrected = {
	pre_unit_init = function (arg_13_0, arg_13_1)
		-- function 13
		local var_13_0 = BLACKBOARDS[arg_13_0]

		var_13_0.ignore_interest_points = true
		var_13_0.ignore_passive_on_patrol = true
	end,
	init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		-- function 14
		return
	end,
	update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		-- function 15
		return
	end,
	destroy = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		print("Group is destroyed", arg_16_2)

		if not arg_16_2 then
			arg_16_2.commanding_player.resurrected_group_id = nil
			arg_16_2.commanding_player = nil
		end
	end
}
AIGroupTemplates.encampment = {
	pre_unit_init = function (arg_17_0, arg_17_1)
		-- function 17
		ScriptUnit.extension(arg_17_0, "ai_system"):set_perception("perception_regular", "pick_encampment_target_idle")

		BLACKBOARDS[arg_17_0].ignore_interest_points = true
	end,
	setup_group = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		-- function 18
		arg_18_2.idle = true
	end,
	init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
		-- function 19
		return
	end,
	update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		-- function 20
		local group_data = arg_20_2.group_data
		local flag = arg_20_3 > group_data.spawn_time + 10

		Debug.text(string.format("Encampment size: %d/%d awake %s", arg_20_2.members_n, arg_20_2.size, tostring(flag)))

		local var_20_2 = Managers.state.side:get_side(arg_20_2.side_id):get_enemy_sides()[1]
		local PLAYER_POSITIONS = var_20_2.PLAYER_POSITIONS
		local PLAYER_UNITS = var_20_2.PLAYER_UNITS

		if not arg_20_2.idle and not flag then
			local unbox = group_data.encampment.pos:unbox()

			for i = 1, #PLAYER_POSITIONS do
				local var_20_6 = PLAYER_POSITIONS[i]

				if Vector3.distance(unbox, var_20_6) < 15 then
					AIGroupTemplates.encampment.wake_up_encampment(arg_20_2, PLAYER_UNITS[i])

					break
				end
			end
		end
	end,
	destroy = function (arg_21_0, arg_21_1, arg_21_2)
		-- function 21
		print("Encampment killed")
	end,
	wake_up_encampment = function (self, arg_22_1)
		-- function 22
		self.idle = false, Managers.state.entity:system("ai_group_system"):run_func_on_all_members(self, AIGroupTemplates.encampment.wake_up_unit, arg_22_1)
	end,
	wake_up_unit = function (arg_23_0, arg_23_1, arg_23_2)
		-- function 23
		local var_23_0 = extension(arg_23_0, "ai_system")

		var_23_0:enemy_aggro(nil, arg_23_2)

		local _breed = var_23_0._breed

		var_23_0:set_perception(_breed.perception, _breed.target_selection)
	end
}
AIGroupTemplates.spawn_test = {
	pre_unit_init = function (arg_24_0, arg_24_1)
		-- function 24
		BLACKBOARDS[arg_24_0].far_off_despawn_immunity = true
	end,
	init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
		-- function 25
		arg_25_2.kill_after_time = arg_25_3 + 2
		arg_25_2.check_size = arg_25_2.num_spawned_members
	end,
	setup_group = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
		-- function 26
		return
	end,
	update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		-- function 27
		if arg_27_3 > arg_27_2.kill_after_time then
			for k, v in pairs(arg_27_2.members) do
				if not HEALTH_ALIVE[k] then
					Managers.state.conflict:destroy_unit(k, BLACKBOARDS[k], "test")

					arg_27_2.check_size = arg_27_2.check_size - 1
				end
			end

			local system = Managers.state.entity:system("spawner_system")

			system.tests_running = system.tests_running - 1
		end
	end,
	destroy = function (arg_28_0, arg_28_1, arg_28_2)
		-- function 28
		if arg_28_2.check_size ~= 0 then
			local spawner_unit = arg_28_2.group_data.spawner_unit

			print(string.format("### DESTROY Bad spawner: %s at %s", tostring(spawner_unit), tostring(Unit.local_position(spawner_unit, 0))))
		else
			print("spawner id ", arg_28_2.id, "is ok!")
		end
	end
}

DLCUtils.merge("ai_group_templates", AIGroupTemplates)
