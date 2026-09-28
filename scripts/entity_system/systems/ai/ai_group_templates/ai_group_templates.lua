-- chunkname: @scripts/entity_system/systems/ai/ai_group_templates/ai_group_templates.lua

local AIGroupTemplates = AIGroupTemplates

AIGroupTemplates = not not AIGroupTemplates or not not {}
AIGroupTemplates = AIGroupTemplates

local ScriptUnit_extension = ScriptUnit.extension
local BLACKBOARDS = BLACKBOARDS

AIGroupTemplates.mini_patrol = {
	pre_unit_init = function (unit, group)
		-- function 1
		local blackboard = BLACKBOARDS[unit]

		blackboard.sneaky = true
	end,
	init = function (world, nav_world, group, t)
		-- function 2
		return
	end,
	update = function (world, nav_world, group, t)
		-- function 3
		return
	end,
	destroy = function (world, nav_world, group)
		-- function 4
		Managers.state.conflict:mini_patrol_killed(group.id)
	end
}
AIGroupTemplates.horde = {
	pre_unit_init = function (unit, group)
		-- function 5
		if group.sneaky then
			local blackboard = BLACKBOARDS[unit]

			blackboard.sneaky = true
		end
	end,
	init = function (world, nav_world, group, t, unit)
		-- function 6
		Managers.state.conflict.horde_spawner:set_horde_has_spawned(group.id)
	end,
	update = function (world, nav_world, group, t)
		-- function 7
		local group_data = not not group and not not group.group_data

		if group_data then
			-- Nothing
		end
	end,
	destroy = function (world, nav_world, group)
		-- function 8
		local conflict = Managers.state.conflict
		local var_8_1 = conflict
		local horde_killed = conflict.horde_killed
		local horde_wave

		if group.group_data then
			horde_wave = group.group_data.horde_wave

			if not horde_wave then
				-- Nothing
			end
		end

		horde_wave = "?"

		::label_8_0::

		horde_killed(var_8_1, horde_wave)
		Managers.state.conflict.horde_spawner:set_horde_is_done(group.id)
	end
}
AIGroupTemplates.boss_door_closers = {
	pre_unit_init = function (unit, group)
		-- function 9
		return
	end,
	init = function (world, nav_world, group, t, unit)
		-- function 10
		return
	end,
	update = function (world, nav_world, group, t)
		-- function 11
		return
	end,
	destroy = function (world, nav_world, group)
		-- function 12
		return
	end
}
AIGroupTemplates.resurrected = {
	pre_unit_init = function (unit, group)
		-- function 13
		local blackboard = BLACKBOARDS[unit]

		blackboard.ignore_interest_points = true
		blackboard.ignore_passive_on_patrol = true
	end,
	init = function (world, nav_world, group, t, unit)
		-- function 14
		return
	end,
	update = function (world, nav_world, group, t)
		-- function 15
		return
	end,
	destroy = function (world, nav_world, group)
		-- function 16
		print("Group is destroyed", group)

		if group then
			group.commanding_player.resurrected_group_id = nil
			group.commanding_player = nil
		end
	end
}
AIGroupTemplates.encampment = {
	pre_unit_init = function (unit, group)
		-- function 17
		local ai_simple = ScriptUnit.extension(unit, "ai_system")

		ai_simple:set_perception("perception_regular", "pick_encampment_target_idle")

		local blackboard = BLACKBOARDS[unit]

		blackboard.ignore_interest_points = true
	end,
	setup_group = function (world, nav_world, group, first_unit)
		-- function 18
		group.idle = true
	end,
	init = function (world, nav_world, group, t, unit)
		-- function 19
		return
	end,
	update = function (world, nav_world, group, t)
		-- function 20
		local group_data = group.group_data
		local awake = t > group_data.spawn_time + 10

		Debug.text(string.format("Encampment size: %d/%d awake %s", group.members_n, group.size, tostring(awake)))

		local side_manager = Managers.state.side
		local side = side_manager:get_side(group.side_id)
		local enemy_side = side:get_enemy_sides()[1]
		local PLAYER_POSITIONS = enemy_side.PLAYER_POSITIONS
		local PLAYER_UNITS = enemy_side.PLAYER_UNITS

		if group.idle and awake then
			local encampment_pos = group_data.encampment.pos:unbox()

			for i = 1, #PLAYER_POSITIONS do
				local player_pos = PLAYER_POSITIONS[i]

				if Vector3.distance(encampment_pos, player_pos) < 15 then
					AIGroupTemplates.encampment.wake_up_encampment(group, PLAYER_UNITS[i])

					break
				end
			end
		end
	end,
	destroy = function (world, nav_world, group)
		-- function 21
		print("Encampment killed")
	end,
	wake_up_encampment = function (group, prime_target_unit)
		-- function 22
		group.idle = false, Managers.state.entity:system("ai_group_system"):run_func_on_all_members(group, AIGroupTemplates.encampment.wake_up_unit, prime_target_unit)
	end,
	wake_up_unit = function (unit, group, prime_target_unit)
		-- function 23
		local ai_simple = ScriptUnit_extension(unit, "ai_system")

		ai_simple:enemy_aggro(nil, prime_target_unit)

		local breed = ai_simple._breed

		ai_simple:set_perception(breed.perception, breed.target_selection)
	end
}
AIGroupTemplates.spawn_test = {
	pre_unit_init = function (unit, group)
		-- function 24
		local blackboard = BLACKBOARDS[unit]

		blackboard.far_off_despawn_immunity = true
	end,
	init = function (world, nav_world, group, t)
		-- function 25
		group.kill_after_time = t + 2
		group.check_size = group.num_spawned_members
	end,
	setup_group = function (world, nav_world, group, first_unit)
		-- function 26
		return
	end,
	update = function (world, nav_world, group, t)
		-- function 27
		if t > group.kill_after_time then
			for unit, extension in pairs(group.members) do
				if HEALTH_ALIVE[unit] then
					Managers.state.conflict:destroy_unit(unit, BLACKBOARDS[unit], "test")

					group.check_size = group.check_size - 1
				end
			end

			local spawner_system = Managers.state.entity:system("spawner_system")

			spawner_system.tests_running = spawner_system.tests_running - 1
		end
	end,
	destroy = function (world, nav_world, group)
		-- function 28
		if group.check_size ~= 0 then
			local spawner_unit = group.group_data.spawner_unit

			print(string.format("### DESTROY Bad spawner: %s at %s", tostring(spawner_unit), tostring(Unit.local_position(spawner_unit, 0))))
		else
			print("spawner id ", group.id, "is ok!")
		end
	end
}

DLCUtils.merge("ai_group_templates", AIGroupTemplates)
