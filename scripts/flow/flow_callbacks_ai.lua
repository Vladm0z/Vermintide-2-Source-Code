-- chunkname: @scripts/flow/flow_callbacks_ai.lua

local var_0_0 = Boot.flow_return_table

function flow_callback_activate_ai_spawner(arg_1_0)
	local var_1_0 = arg_1_0.spawner_unit

	Managers.state.event:trigger("activate_ai_spawner", var_1_0)
end

function flow_callback_deactivate_ai_spawner(arg_2_0)
	local var_2_0 = arg_2_0.spawner_unit

	Managers.state.event:trigger("deactivate_ai_spawner", var_2_0)
end

function flow_callback_hibernate_spawner(arg_3_0)
	local var_3_0 = arg_3_0.spawner_unit
	local var_3_1 = arg_3_0.hibernate

	Managers.state.entity:system("spawner_system"):hibernate_spawner(var_3_0, var_3_1)
end

function flow_callback_ai_move_group_command(arg_4_0)
	error("'flow_callback_ai_move_group_command' is not deprecated")
end

function flow_callback_ai_move_single_command(arg_5_0)
	local var_5_0 = arg_5_0.move_unit
	local var_5_1 = arg_5_0.target_unit

	BLACKBOARDS[var_5_0].goal_destination = Vector3Box(Unit.local_position(var_5_1, 0))
end

function flow_callback_ai_override_breed_in_roamer_spawn_pool(arg_6_0)
	if not Managers.player.is_server then
		return
	end

	local var_6_0 = {
		arg_6_0.override_breed1,
		arg_6_0.override_breed2,
		arg_6_0.override_breed3
	}

	Managers.state.conflict.enemy_recycler:patch_override_breed(arg_6_0.breed_name, var_6_0)
end

function flow_callback_ai_despawn(arg_7_0)
	local var_7_0 = arg_7_0.spawner_unit

	ScriptUnit.extension(var_7_0, "spawner_system"):despawn()
end

function flow_callback_ai_kill(arg_8_0)
	local var_8_0 = arg_8_0.hit_unit
	local var_8_1 = Unit.get_data(var_8_0, "breed")

	if not var_8_1 then
		return
	end

	local var_8_2 = arg_8_0.hit_actor
	local var_8_3 = Actor.node(var_8_2)
	local var_8_4 = var_8_1.hit_zones_lookup[var_8_3].name
	local var_8_5 = arg_8_0.damage_type
	local var_8_6 = -arg_8_0.hit_normal

	AiUtils.kill_unit(var_8_0, var_8_0, var_8_4, var_8_5, var_8_6)
end

function flow_callback_ai_load_breed_package(arg_9_0)
	if not Managers.player.is_server then
		return
	end

	local var_9_0 = arg_9_0.breed_name
	local var_9_1 = Managers.level_transition_handler.enemy_package_loader

	if not var_9_1:is_breed_processed(var_9_0) then
		local var_9_2 = true

		var_9_1:request_breed(var_9_0, var_9_2)
	end
end

function flow_callback_ai_lock_breed_package(arg_10_0)
	if not Managers.player.is_server then
		return
	end

	local var_10_0 = arg_10_0.breed_name

	Managers.level_transition_handler.enemy_package_loader:lock_breed_package(var_10_0)
end

function flow_callback_ai_unlock_breed_package(arg_11_0)
	print("Trying to unlock package")

	if not Managers.player.is_server then
		return
	end

	local var_11_0 = arg_11_0.breed_name

	Managers.level_transition_handler.enemy_package_loader:unlock_breed_package(var_11_0)
end

function flow_callback_spawn_ai_and_move_to_unit(arg_12_0)
	if not Managers.player.is_server then
		return
	end

	local var_12_0 = arg_12_0.breed_name
	local var_12_1 = arg_12_0.spawn_unit
	local var_12_2 = arg_12_0.move_to_unit1
	local var_12_3 = arg_12_0.move_to_unit2
	local var_12_4 = arg_12_0.move_to_unit3
	local var_12_5 = {}

	var_12_5[#var_12_5 + 1] = var_12_2

	if var_12_3 then
		var_12_5[#var_12_5 + 1] = var_12_3
	end

	if var_12_4 then
		var_12_5[#var_12_5 + 1] = var_12_4
	end

	local var_12_6 = var_12_5[math.random(1, #var_12_5)]
	local var_12_7 = Vector3Box(Unit.world_position(var_12_1, 0))
	local var_12_8 = Vector3Box(Unit.world_position(var_12_6, 0))
	local var_12_9 = Breeds[var_12_0]
	local var_12_10 = {
		move_to_position = var_12_8,
		spawned_func = function (arg_13_0, arg_13_1, arg_13_2)
			local var_13_0 = BLACKBOARDS[arg_13_0]

			var_13_0.goal_destination = arg_13_2.move_to_position
			var_13_0.move_and_place_standard = true
			var_13_0.ignore_standard_pickup = true
		end
	}

	Managers.state.conflict:spawn_queued_unit(var_12_9, var_12_7, QuaternionBox(Quaternion.identity()), "terror_event", nil, "terror_event", var_12_10)
end

function flow_callback_spawn_ai_with_animation_and_move_to_unit(arg_14_0)
	if not Managers.player.is_server then
		return
	end

	local var_14_0 = arg_14_0.breed_name
	local var_14_1 = arg_14_0.spawn_unit
	local var_14_2 = arg_14_0.move_to_unit1
	local var_14_3 = arg_14_0.move_to_unit2
	local var_14_4 = arg_14_0.move_to_unit3
	local var_14_5 = arg_14_0.on_spawn_event_name

	if var_14_5 == "" then
		var_14_5 = nil
	end

	local var_14_6 = {}

	var_14_6[#var_14_6 + 1] = var_14_2

	if var_14_3 then
		var_14_6[#var_14_6 + 1] = var_14_3
	end

	if var_14_4 then
		var_14_6[#var_14_6 + 1] = var_14_4
	end

	local var_14_7 = var_14_6[math.random(1, #var_14_6)]
	local var_14_8 = Vector3Box(Unit.world_position(var_14_1, 0))
	local var_14_9 = Vector3Box(Unit.world_position(var_14_7, 0))
	local var_14_10 = Breeds[var_14_0]
	local var_14_11 = arg_14_0.spawn_anim
	local var_14_12 = var_14_11 and Vector3.flat(Vector3.normalize(var_14_9:unbox() - var_14_8:unbox()))
	local var_14_13 = var_14_11 and QuaternionBox(Quaternion.look(var_14_12, Vector3.up()))
	local var_14_14 = arg_14_0.go_to_combat
	local var_14_15 = arg_14_0.optional_spawn_exit_time and arg_14_0.optional_spawn_exit_time + Managers.time:time("game")
	local var_14_16 = {
		move_to_position = var_14_9,
		ignore_passive_on_patrol = var_14_14,
		spawn_anim = var_14_11,
		spawn_rot = var_14_13,
		spawn_exit_time = var_14_15,
		spawned_func = function (arg_15_0, arg_15_1, arg_15_2)
			local var_15_0 = BLACKBOARDS[arg_15_0]

			var_15_0.goal_destination = arg_15_2.move_to_position
			var_15_0.move_and_place_standard = true
			var_15_0.ignore_standard_pickup = true
			var_15_0.ignore_passive_on_patrol = arg_15_2.ignore_passive_on_patrol
			var_15_0.spawn_exit_time = var_14_15

			if arg_15_2.spawn_anim then
				var_15_0.spawn_animation_override = true
				var_15_0.spawn_animation = arg_15_2.spawn_anim

				local var_15_1 = arg_15_2.spawn_rot:unbox()

				Unit.set_local_rotation(arg_15_0, 0, var_15_1)
			end

			if var_14_5 then
				local var_15_2 = Managers.state.conflict:world()
				local var_15_3 = LevelHelper:current_level(var_15_2)

				Level.trigger_event(var_15_3, var_14_5)
			end
		end
	}
	local var_14_17 = Managers.state.conflict:spawn_queued_unit(var_14_10, var_14_8, QuaternionBox(Quaternion.identity()), "terror_event", nil, "terror_event", var_14_16)

	var_0_0.spawn_handle = var_14_17

	return var_0_0
end

function flow_callback_get_spawned_unit(arg_16_0)
	local var_16_0 = arg_16_0.spawn_handle
	local var_16_1 = Managers.state.conflict:get_spawned_unit(var_16_0)

	var_0_0.unit = var_16_1

	return var_0_0
end

function trigger_ai_equipment_flow_event(arg_17_0)
	local var_17_0 = arg_17_0.unit
	local var_17_1 = ScriptUnit.has_extension(var_17_0, "ai_inventory_system")

	if var_17_1 then
		local var_17_2 = var_17_1.inventory_item_units
		local var_17_3 = Unit.flow_event

		for iter_17_0 = 1, var_17_1.inventory_items_n do
			var_17_3(var_17_2[iter_17_0], arg_17_0.event)
		end
	end
end

function flow_callback_ai_follow_path(arg_18_0)
	error("'flow_callback_ai_follow_path' is deprecated")

	local var_18_0 = arg_18_0.ai_entity
	local var_18_1 = arg_18_0.spline_name
	local var_18_2 = arg_18_0.finish_event

	if ScriptUnit.has_extension(var_18_0, "spawner_system") then
		local var_18_3 = ScriptUnit.extension(var_18_0, "spawner_system")
		local var_18_4 = Managers.state.conflict

		for iter_18_0, iter_18_1 in pairs(var_18_3:spawned_units()) do
			-- Nothing
		end
	end
end

function flow_callback_ai_patrol_path(arg_19_0)
	error("'flow_callback_ai_patrol_path' is deprecated")

	local var_19_0 = arg_19_0.ai_entity
	local var_19_1 = arg_19_0.spline_name

	if ScriptUnit.has_extension(var_19_0, "spawner_system") then
		local var_19_2 = ScriptUnit.extension(var_19_0, "spawner_system")
		local var_19_3 = Managers.state.conflict

		for iter_19_0, iter_19_1 in pairs(var_19_2:spawned_units()) do
			-- Nothing
		end
	end
end

function flow_callback_ai_move_to_command(arg_20_0)
	local var_20_0 = arg_20_0.ai_entity
	local var_20_1 = arg_20_0.waypoint_unit
	local var_20_2 = arg_20_0.finish_event

	if ScriptUnit.has_extension(var_20_0, "spawner_system") then
		local var_20_3 = ScriptUnit.extension(var_20_0, "spawner_system")
		local var_20_4 = Managers.state.conflict

		for iter_20_0, iter_20_1 in pairs(var_20_3:spawned_units()) do
			local var_20_5 = var_20_4:get_spawned_unit(iter_20_1)

			BLACKBOARDS[var_20_5].goal_destination = Vector3Box(Unit.local_position(var_20_1, 0))
		end
	else
		BLACKBOARDS[var_20_0].goal_destination = Vector3Box(Unit.local_position(var_20_1, 0))
	end
end

function flow_callback_ai_detect_player(arg_21_0)
	local var_21_0 = arg_21_0.ai_entity
	local var_21_1 = Managers.player:player_from_peer_id(Network.peer_id()).player_unit

	if ScriptUnit.has_extension(var_21_0, "spawner_system") then
		local var_21_2 = ScriptUnit.extension(var_21_0, "spawner_system")
		local var_21_3 = Managers.state.conflict

		for iter_21_0, iter_21_1 in pairs(var_21_2:spawned_units()) do
			local var_21_4 = var_21_3:get_spawned_unit(iter_21_1)

			ScriptUnit.extension(var_21_4, "ai_system"):blackboard().players[var_21_1] = true
		end
	else
		ScriptUnit.extension(var_21_0, "ai_system"):blackboard().players[var_21_1] = true
	end
end

function flow_callback_ai_hold_position(arg_22_0)
	local var_22_0 = arg_22_0.ai_entity

	if ScriptUnit.has_extension(var_22_0, "spawner_system") then
		local var_22_1 = ScriptUnit.extension(var_22_0, "spawner_system")
		local var_22_2 = Managers.state.conflict

		for iter_22_0, iter_22_1 in pairs(var_22_1:spawned_units()) do
			local var_22_3 = var_22_2:get_spawned_unit(iter_22_1)
			local var_22_4 = ScriptUnit.extension(var_22_3, "ai_system")

			var_22_4:steering():reset()

			local var_22_5 = var_22_4:brain()

			var_22_5:change_behaviour("avoidance", "nil_tree")
			var_22_5:change_behaviour("pathing", "nil_tree")
		end
	else
		local var_22_6 = ScriptUnit.extension(var_22_0, "ai_system")

		var_22_6:steering():reset()

		local var_22_7 = var_22_6:brain()

		var_22_7:change_behaviour("avoidance", "nil_tree")
		var_22_7:change_behaviour("pathing", "nil_tree")
	end
end

function flow_callback_set_ai_properties(arg_23_0)
	local var_23_0 = arg_23_0.ai_entity

	arg_23_0.ai_entity = nil

	if ScriptUnit.has_extension(var_23_0, "spawner_system") then
		local var_23_1 = ScriptUnit.extension(var_23_0, "spawner_system")
		local var_23_2 = Managers.state.conflict

		for iter_23_0, iter_23_1 in pairs(var_23_1:spawned_units()) do
			local var_23_3 = var_23_2:get_spawned_unit(iter_23_1)

			ScriptUnit.extension(var_23_3, "ai_system"):set_properties(arg_23_0)
		end
	else
		ScriptUnit.extension(var_23_0, "ai_system"):set_properties(arg_23_0)
	end
end

function flow_callback_set_ai_perception(arg_24_0)
	local var_24_0 = arg_24_0.ai_entity

	if ScriptUnit.has_extension(var_24_0, "spawner_system") then
		local var_24_1 = ScriptUnit.extension(var_24_0, "spawner_system")
		local var_24_2 = Managers.state.conflict

		for iter_24_0, iter_24_1 in pairs(var_24_1:spawned_units()) do
			local var_24_3 = var_24_2:get_spawned_unit(iter_24_1)

			ScriptUnit.extension(var_24_3, "ai_system"):perception():set_config(arg_24_0)
		end
	else
		ScriptUnit.extension(var_24_0, "ai_system"):perception():set_config(arg_24_0)
	end
end

function flow_callback_ai_set_waypoint(arg_25_0)
	local var_25_0 = arg_25_0.waypoint_name
	local var_25_1 = arg_25_0.waypoint_unit
	local var_25_2 = Managers.world:world("level_world")
	local var_25_3 = LevelHelper:current_level(var_25_2)

	Level.set_flow_variable(var_25_3, var_25_0, var_25_1)
end

function flow_callback_ai_set_areas(arg_26_0)
	flow_callback_set_ai_properties(arg_26_0)
end

function flow_callback_set_ai_spawner_mode(arg_27_0)
	Managers.state.entity:system("spawner_system"):set_deterministic(arg_27_0.deterministic)
end

function flow_callback_force_terror_event(arg_28_0)
	if Managers.player.is_server or LEVEL_EDITOR_TEST then
		Managers.state.conflict:start_terror_event(arg_28_0.event_type, arg_28_0.seed, arg_28_0.origin_unit)
	end

	local var_28_0 = Math.next_random(arg_28_0.seed or 0)

	var_0_0.new_seed = var_28_0

	return var_0_0
end

function flow_callback_override_player_respawning(arg_29_0)
	if Managers.player.is_server or LEVEL_EDITOR_TEST then
		Managers.state.game_mode:set_override_respawn_group(arg_29_0.respawn_group_name, arg_29_0.active)
	end
end

function flow_callback_disable_player_respawning(arg_30_0)
	if Managers.player.is_server or LEVEL_EDITOR_TEST then
		Managers.state.game_mode:set_respawn_group_enabled(arg_30_0.respawn_group_name, not arg_30_0.active)
	end
end

function flow_callback_disable_player_respawning_gate(arg_31_0)
	if Managers.player.is_server or LEVEL_EDITOR_TEST then
		Managers.state.game_mode:set_respawn_gate_enabled(arg_31_0.unit, not arg_31_0.active)
	end
end

function flow_callback_change_spawner_id(arg_32_0)
	Managers.state.entity:system("spawner_system"):change_spawner_id(arg_32_0.unit, arg_32_0.spawner_id, arg_32_0.new_spawner_id)
end

function flow_callback_stop_terror_event(arg_33_0)
	if Managers.player.is_server or LEVEL_EDITOR_TEST then
		local var_33_0 = arg_33_0.event_type

		TerrorEventMixer.stop_event(var_33_0)
	end
end

function flow_callback_force_random_terror_event(arg_34_0)
	if Managers.player.is_server or LEVEL_EDITOR_TEST then
		TerrorEventMixer.start_random_event(arg_34_0.event_chunk)
	end
end

function flow_callback_bot_nav_transition_entered(arg_35_0)
	local var_35_0 = arg_35_0.bot_unit
	local var_35_1 = arg_35_0.transition_unit
	local var_35_2 = arg_35_0.bot_actor
	local var_35_3 = ScriptUnit.has_extension(var_35_0, "ai_navigation_system") and ScriptUnit.extension(var_35_0, "ai_navigation_system")

	if var_35_3 then
		if var_35_3.flow_cb_entered_nav_transition then
			var_35_3:flow_cb_entered_nav_transition(var_35_1, var_35_2)
		end
	else
		Application.warning(string.format("[flow_callback_bot_nav_transition_left] Unit: %s missing extension \"ai_navigation_system\"", tostring(var_35_0)))
	end
end

function flow_callback_bot_nav_transition_left(arg_36_0)
	local var_36_0 = arg_36_0.bot_unit
	local var_36_1 = arg_36_0.transition_unit
	local var_36_2 = arg_36_0.bot_actor
	local var_36_3 = ScriptUnit.has_extension(var_36_0, "ai_navigation_system") and ScriptUnit.extension(var_36_0, "ai_navigation_system")

	if var_36_3 then
		if var_36_3.flow_cb_left_nav_transition then
			var_36_3:flow_cb_left_nav_transition(var_36_1, var_36_2)
		end
	else
		Application.warning(string.format("[flow_callback_bot_nav_transition_left] Unit: %s missing extension \"ai_navigation_system\"", tostring(var_36_0)))
	end
end

function flow_callback_player_bot_hold_position(arg_37_0)
	if not Managers.player.is_server then
		return
	end

	local var_37_0 = arg_37_0.player_unit
	local var_37_1 = ScriptUnit.has_extension(var_37_0, "ai_bot_group_system")

	if var_37_1 then
		if arg_37_0.should_hold_position then
			local var_37_2 = Managers.state.entity:system("ai_system"):nav_world()
			local var_37_3 = arg_37_0.position or Unit.local_position(var_37_0, 0)
			local var_37_4 = 0.5
			local var_37_5 = 2
			local var_37_6, var_37_7 = GwNavQueries.triangle_from_position(var_37_2, var_37_3, var_37_4, var_37_5)

			if var_37_6 then
				local var_37_8 = arg_37_0.max_allowed_distance_from_position or 0

				var_37_3 = Vector3(var_37_3.x, var_37_3.y, var_37_7)

				var_37_1:set_hold_position(var_37_3, var_37_8)
			else
				Application.warning(string.format("[flow_callback_player_bot_hold_position] %s could not hold position %s since it is not near navmesh!", tostring(var_37_0), tostring(var_37_3)))
			end
		else
			var_37_1:set_hold_position(nil)
		end
	else
		Application.warning(string.format("[flow_callback_player_bot_hold_position] Unit: %s is missing ai_bot_group_extension", tostring(var_37_0)))
	end
end

function flow_callback_overcharge_explode_player_bot(arg_38_0)
	if not Managers.player.is_server then
		return
	end

	local var_38_0 = arg_38_0.player_unit

	if Unit.alive(var_38_0) then
		local var_38_1 = ScriptUnit.has_extension(var_38_0, "overcharge_system")

		fassert(var_38_1, "Tried to overcharge explode unit %s from flow but the unit has no overcharge extension", var_38_0)

		local var_38_2 = var_38_1:get_max_value()

		var_38_1:add_charge(var_38_2)
		var_38_1:add_charge(var_38_2)
	end
end

function flow_callback_broadphase_ai_set_goal_destination(arg_39_0)
	if not Managers.player.is_server then
		return
	end

	local var_39_0 = arg_39_0.goal_unit
	local var_39_1 = Unit.local_position(var_39_0, 0)
	local var_39_2
	local var_39_3 = 1
	local var_39_4 = 5
	local var_39_5 = Managers.state.entity:system("ai_system")
	local var_39_6 = var_39_5:nav_world()
	local var_39_7, var_39_8 = GwNavQueries.triangle_from_position(var_39_6, var_39_1, var_39_3, var_39_4)

	if var_39_7 then
		var_39_2 = Vector3(var_39_1.x, var_39_1.y, var_39_8)
	else
		local var_39_9 = 5
		local var_39_10 = 0.1

		var_39_2 = GwNavQueries.inside_position_from_outside_position(var_39_6, var_39_1, var_39_3, var_39_4, var_39_9, var_39_10)
	end

	if var_39_2 then
		local var_39_11 = arg_39_0.broadphase_radius
		local var_39_12 = arg_39_0.broadphase_start_unit
		local var_39_13 = Unit.local_position(var_39_12, 0)
		local var_39_14 = BLACKBOARDS
		local var_39_15 = arg_39_0.affected_breed
		local var_39_16 = FrameTable.alloc_table()
		local var_39_17 = Broadphase.query(var_39_5.broadphase, var_39_13, var_39_11, var_39_16)

		for iter_39_0 = 1, var_39_17 do
			local var_39_18 = var_39_16[iter_39_0]
			local var_39_19 = var_39_14[var_39_18]

			if var_39_19.breed.name == var_39_15 and HEALTH_ALIVE[var_39_18] then
				if var_39_19.goal_destination == nil then
					var_39_19.goal_destination = Vector3Box(var_39_2)
				else
					Application.warning(string.format("[flow_callback_broadphase_ai_set_goal_destination] Unit: %s already have a goal destination!", tostring(var_39_18)))
				end
			end
		end
	else
		Application.warning(string.format("[flow_callback_broadphase_ai_set_goal_destination] Couldn't find nearby navmesh for Goal Unit: %s", tostring(var_39_0)))
	end
end

function flow_callback_get_crossroad_path_id(arg_40_0)
	local var_40_0 = arg_40_0.crossroad_id
	local var_40_1 = Managers.state.conflict.level_analysis.chosen_crossroads[var_40_0]

	var_0_0.path_id = var_40_1

	return var_0_0
end
