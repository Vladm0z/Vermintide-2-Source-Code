-- chunkname: @scripts/flow/flow_callbacks_ai.lua

local flow_return_table = Boot.flow_return_table

function flow_callback_activate_ai_spawner(self)
	-- function 1
	local spawner_unit = self.spawner_unit

	Managers.state.event:trigger("activate_ai_spawner", spawner_unit)
end

function flow_callback_deactivate_ai_spawner(self)
	-- function 2
	local spawner_unit = self.spawner_unit

	Managers.state.event:trigger("deactivate_ai_spawner", spawner_unit)
end

function flow_callback_hibernate_spawner(self)
	-- function 3
	local spawner_unit = self.spawner_unit
	local hibernate = self.hibernate

	Managers.state.entity:system("spawner_system"):hibernate_spawner(spawner_unit, hibernate)
end

function flow_callback_ai_move_group_command(arg_4_0)
	-- function 4
	error("'flow_callback_ai_move_group_command' is not deprecated")
end

function flow_callback_ai_move_single_command(self)
	-- function 5
	local move_unit = self.move_unit
	local target_unit = self.target_unit

	BLACKBOARDS[move_unit].goal_destination = Vector3Box(Unit.local_position(target_unit, 0))
end

function flow_callback_ai_override_breed_in_roamer_spawn_pool(self)
	-- function 6
	if not Managers.player.is_server then
		return
	end

	local tbl = {
		self.override_breed1,
		self.override_breed2,
		self.override_breed3
	}

	Managers.state.conflict.enemy_recycler:patch_override_breed(self.breed_name, tbl)
end

function flow_callback_ai_despawn(self)
	-- function 7
	local spawner_unit = self.spawner_unit

	ScriptUnit.extension(spawner_unit, "spawner_system"):despawn()
end

function flow_callback_ai_kill(self)
	-- function 8
	local hit_unit = self.hit_unit
	local get_data = Unit.get_data(hit_unit, "breed")

	if not get_data then
		return
	end

	local hit_actor = self.hit_actor
	local node = Actor.node(hit_actor)
	local name = get_data.hit_zones_lookup[node].name
	local damage_type = self.damage_type
	local num = -self.hit_normal

	AiUtils.kill_unit(hit_unit, hit_unit, name, damage_type, num)
end

function flow_callback_ai_load_breed_package(self)
	-- function 9
	if not Managers.player.is_server then
		return
	end

	local breed_name = self.breed_name
	local enemy_package_loader = Managers.level_transition_handler.enemy_package_loader

	if not enemy_package_loader:is_breed_processed(breed_name) then
		local flag = true

		enemy_package_loader:request_breed(breed_name, flag)
	end
end

function flow_callback_ai_lock_breed_package(self)
	-- function 10
	if not Managers.player.is_server then
		return
	end

	local breed_name = self.breed_name

	Managers.level_transition_handler.enemy_package_loader:lock_breed_package(breed_name)
end

function flow_callback_ai_unlock_breed_package(self)
	-- function 11
	print("Trying to unlock package")

	if not Managers.player.is_server then
		return
	end

	local breed_name = self.breed_name

	Managers.level_transition_handler.enemy_package_loader:unlock_breed_package(breed_name)
end

function flow_callback_spawn_ai_and_move_to_unit(self)
	-- function 12
	if not Managers.player.is_server then
		return
	end

	local breed_name = self.breed_name
	local spawn_unit = self.spawn_unit
	local move_to_unit1 = self.move_to_unit1
	local move_to_unit2 = self.move_to_unit2
	local move_to_unit3 = self.move_to_unit3
	local tbl = {}

	tbl[#tbl + 1] = move_to_unit1

	if not move_to_unit2 then
		tbl[#tbl + 1] = move_to_unit2
	end

	if not move_to_unit3 then
		tbl[#tbl + 1] = move_to_unit3
	end

	local var_12_6 = tbl[math.random(1, #tbl)]
	local var_12_7 = Vector3Box(Unit.world_position(spawn_unit, 0))
	local var_12_8 = Vector3Box(Unit.world_position(var_12_6, 0))
	local var_12_9 = Breeds[breed_name]
	local tbl_2 = {
		move_to_position = var_12_8,
		spawned_func = function (arg_13_0, arg_13_1, arg_13_2)
			-- function 13
			local var_13_0 = BLACKBOARDS[arg_13_0]

			var_13_0.goal_destination = arg_13_2.move_to_position
			var_13_0.move_and_place_standard = true
			var_13_0.ignore_standard_pickup = true
		end
	}

	Managers.state.conflict:spawn_queued_unit(var_12_9, var_12_7, QuaternionBox(Quaternion.identity()), "terror_event", nil, "terror_event", tbl_2)
end

function flow_callback_spawn_ai_with_animation_and_move_to_unit(self)
	-- function 14
	if not Managers.player.is_server then
		return
	end

	local breed_name = self.breed_name
	local spawn_unit = self.spawn_unit
	local move_to_unit1 = self.move_to_unit1
	local move_to_unit2 = self.move_to_unit2
	local move_to_unit3 = self.move_to_unit3
	local on_spawn_event_name = self.on_spawn_event_name

	if on_spawn_event_name == "" then
		on_spawn_event_name = nil
	end

	local tbl = {}

	tbl[#tbl + 1] = move_to_unit1

	if not move_to_unit2 then
		tbl[#tbl + 1] = move_to_unit2
	end

	if not move_to_unit3 then
		tbl[#tbl + 1] = move_to_unit3
	end

	local var_14_7 = tbl[math.random(1, #tbl)]
	local var_14_8 = Vector3Box(Unit.world_position(spawn_unit, 0))
	local var_14_9 = Vector3Box(Unit.world_position(var_14_7, 0))
	local var_14_10 = Breeds[breed_name]
	local spawn_anim = self.spawn_anim
	local flag = not spawn_anim and Vector3.flat(Vector3.normalize(var_14_9:unbox() - var_14_8:unbox()))
	local flag_2 = not spawn_anim and QuaternionBox(Quaternion.look(flag, Vector3.up()))
	local go_to_combat = self.go_to_combat
	local optional_spawn_exit_time = self.optional_spawn_exit_time

	optional_spawn_exit_time = not optional_spawn_exit_time and self.optional_spawn_exit_time + Managers.time:time("game")

	local tbl_2 = {
		move_to_position = var_14_9,
		ignore_passive_on_patrol = go_to_combat,
		spawn_anim = spawn_anim,
		spawn_rot = flag_2,
		spawn_exit_time = optional_spawn_exit_time,
		spawned_func = function (arg_15_0, arg_15_1, arg_15_2)
			-- function 15
			local var_15_0 = BLACKBOARDS[arg_15_0]

			var_15_0.goal_destination = arg_15_2.move_to_position
			var_15_0.move_and_place_standard = true
			var_15_0.ignore_standard_pickup = true
			var_15_0.ignore_passive_on_patrol = arg_15_2.ignore_passive_on_patrol
			var_15_0.spawn_exit_time = optional_spawn_exit_time

			if not arg_15_2.spawn_anim then
				var_15_0.spawn_animation_override = true
				var_15_0.spawn_animation = arg_15_2.spawn_anim

				local unbox = arg_15_2.spawn_rot:unbox()

				Unit.set_local_rotation(arg_15_0, 0, unbox)
			end

			if not on_spawn_event_name then
				local world = Managers.state.conflict:world()
				local current_level = LevelHelper:current_level(world)

				Level.trigger_event(current_level, on_spawn_event_name)
			end
		end
	}
	local spawn_queued_unit = Managers.state.conflict:spawn_queued_unit(var_14_10, var_14_8, QuaternionBox(Quaternion.identity()), "terror_event", nil, "terror_event", tbl_2)

	flow_return_table.spawn_handle = spawn_queued_unit

	return flow_return_table
end

function flow_callback_get_spawned_unit(self)
	-- function 16
	local spawn_handle = self.spawn_handle
	local get_spawned_unit = Managers.state.conflict:get_spawned_unit(spawn_handle)

	flow_return_table.unit = get_spawned_unit

	return flow_return_table
end

function trigger_ai_equipment_flow_event(self)
	-- function 17
	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")

	if not has_extension then
		local inventory_item_units = has_extension.inventory_item_units
		local flow_event = Unit.flow_event

		for i = 1, has_extension.inventory_items_n do
			flow_event(inventory_item_units[i], self.event)
		end
	end
end

function flow_callback_ai_follow_path(self)
	-- function 18
	error("'flow_callback_ai_follow_path' is deprecated")

	local ai_entity = self.ai_entity
	local spline_name = self.spline_name
	local finish_event = self.finish_event

	if not ScriptUnit.has_extension(ai_entity, "spawner_system") then
		local extension = ScriptUnit.extension(ai_entity, "spawner_system")
		local conflict = Managers.state.conflict

		for k, v in pairs(extension:spawned_units()) do
			-- Nothing
		end
	end
end

function flow_callback_ai_patrol_path(self)
	-- function 19
	error("'flow_callback_ai_patrol_path' is deprecated")

	local ai_entity = self.ai_entity
	local spline_name = self.spline_name

	if not ScriptUnit.has_extension(ai_entity, "spawner_system") then
		local extension = ScriptUnit.extension(ai_entity, "spawner_system")
		local conflict = Managers.state.conflict

		for k, v in pairs(extension:spawned_units()) do
			-- Nothing
		end
	end
end

function flow_callback_ai_move_to_command(self)
	-- function 20
	local ai_entity = self.ai_entity
	local waypoint_unit = self.waypoint_unit
	local finish_event = self.finish_event

	if not ScriptUnit.has_extension(ai_entity, "spawner_system") then
		local extension = ScriptUnit.extension(ai_entity, "spawner_system")
		local conflict = Managers.state.conflict

		for k, v in pairs(extension:spawned_units()) do
			local get_spawned_unit = conflict:get_spawned_unit(v)

			BLACKBOARDS[get_spawned_unit].goal_destination = Vector3Box(Unit.local_position(waypoint_unit, 0))
		end
	else
		BLACKBOARDS[ai_entity].goal_destination = Vector3Box(Unit.local_position(waypoint_unit, 0))
	end
end

function flow_callback_ai_detect_player(self)
	-- function 21
	local ai_entity = self.ai_entity
	local player_unit = Managers.player:player_from_peer_id(Network.peer_id()).player_unit

	if not ScriptUnit.has_extension(ai_entity, "spawner_system") then
		local extension = ScriptUnit.extension(ai_entity, "spawner_system")
		local conflict = Managers.state.conflict

		for k, v in pairs(extension:spawned_units()) do
			local get_spawned_unit = conflict:get_spawned_unit(v)

			ScriptUnit.extension(get_spawned_unit, "ai_system"):blackboard().players[player_unit] = true
		end
	else
		ScriptUnit.extension(ai_entity, "ai_system"):blackboard().players[player_unit] = true
	end
end

function flow_callback_ai_hold_position(self)
	-- function 22
	local ai_entity = self.ai_entity

	if not ScriptUnit.has_extension(ai_entity, "spawner_system") then
		local extension = ScriptUnit.extension(ai_entity, "spawner_system")
		local conflict = Managers.state.conflict

		for k, v in pairs(extension:spawned_units()) do
			local get_spawned_unit = conflict:get_spawned_unit(v)
			local extension_2 = ScriptUnit.extension(get_spawned_unit, "ai_system")

			extension_2:steering():reset()

			local brain = extension_2:brain()

			brain:change_behaviour("avoidance", "nil_tree")
			brain:change_behaviour("pathing", "nil_tree")
		end
	else
		local extension_3 = ScriptUnit.extension(ai_entity, "ai_system")

		extension_3:steering():reset()

		local brain_2 = extension_3:brain()

		brain_2:change_behaviour("avoidance", "nil_tree")
		brain_2:change_behaviour("pathing", "nil_tree")
	end
end

function flow_callback_set_ai_properties(self)
	-- function 23
	local ai_entity = self.ai_entity

	self.ai_entity = nil

	if not ScriptUnit.has_extension(ai_entity, "spawner_system") then
		local extension = ScriptUnit.extension(ai_entity, "spawner_system")
		local conflict = Managers.state.conflict

		for k, v in pairs(extension:spawned_units()) do
			local get_spawned_unit = conflict:get_spawned_unit(v)

			ScriptUnit.extension(get_spawned_unit, "ai_system"):set_properties(self)
		end
	else
		ScriptUnit.extension(ai_entity, "ai_system"):set_properties(self)
	end
end

function flow_callback_set_ai_perception(self)
	-- function 24
	local ai_entity = self.ai_entity

	if not ScriptUnit.has_extension(ai_entity, "spawner_system") then
		local extension = ScriptUnit.extension(ai_entity, "spawner_system")
		local conflict = Managers.state.conflict

		for k, v in pairs(extension:spawned_units()) do
			local get_spawned_unit = conflict:get_spawned_unit(v)

			ScriptUnit.extension(get_spawned_unit, "ai_system"):perception():set_config(self)
		end
	else
		ScriptUnit.extension(ai_entity, "ai_system"):perception():set_config(self)
	end
end

function flow_callback_ai_set_waypoint(self)
	-- function 25
	local waypoint_name = self.waypoint_name
	local waypoint_unit = self.waypoint_unit
	local world = Managers.world:world("level_world")
	local current_level = LevelHelper:current_level(world)

	Level.set_flow_variable(current_level, waypoint_name, waypoint_unit)
end

function flow_callback_ai_set_areas(arg_26_0)
	-- function 26
	flow_callback_set_ai_properties(arg_26_0)
end

function flow_callback_set_ai_spawner_mode(self)
	-- function 27
	Managers.state.entity:system("spawner_system"):set_deterministic(self.deterministic)
end

function flow_callback_force_terror_event(self)
	-- function 28
	if Managers.player.is_server or not LEVEL_EDITOR_TEST then
		Managers.state.conflict:start_terror_event(self.event_type, self.seed, self.origin_unit)
	end

	local next_random = Math.next_random
	local seed = self.seed

	seed = seed or 0

	local var_28_2 = next_random(seed)

	flow_return_table.new_seed = var_28_2

	return flow_return_table
end

function flow_callback_override_player_respawning(self)
	-- function 29
	if Managers.player.is_server or not LEVEL_EDITOR_TEST then
		Managers.state.game_mode:set_override_respawn_group(self.respawn_group_name, self.active)
	end
end

function flow_callback_disable_player_respawning(self)
	-- function 30
	if Managers.player.is_server or not LEVEL_EDITOR_TEST then
		Managers.state.game_mode:set_respawn_group_enabled(self.respawn_group_name, not self.active)
	end
end

function flow_callback_disable_player_respawning_gate(self)
	-- function 31
	if Managers.player.is_server or not LEVEL_EDITOR_TEST then
		Managers.state.game_mode:set_respawn_gate_enabled(self.unit, not self.active)
	end
end

function flow_callback_change_spawner_id(self)
	-- function 32
	Managers.state.entity:system("spawner_system"):change_spawner_id(self.unit, self.spawner_id, self.new_spawner_id)
end

function flow_callback_stop_terror_event(self)
	-- function 33
	if Managers.player.is_server or not LEVEL_EDITOR_TEST then
		local event_type = self.event_type

		TerrorEventMixer.stop_event(event_type)
	end
end

function flow_callback_force_random_terror_event(self)
	-- function 34
	if Managers.player.is_server or not LEVEL_EDITOR_TEST then
		TerrorEventMixer.start_random_event(self.event_chunk)
	end
end

function flow_callback_bot_nav_transition_entered(self)
	-- function 35
	local bot_unit = self.bot_unit
	local transition_unit = self.transition_unit
	local bot_actor = self.bot_actor
	local has_extension = ScriptUnit.has_extension(bot_unit, "ai_navigation_system")

	has_extension = not has_extension and ScriptUnit.extension(bot_unit, "ai_navigation_system")

	if not has_extension then
		if not has_extension.flow_cb_entered_nav_transition then
			has_extension:flow_cb_entered_nav_transition(transition_unit, bot_actor)
		end
	else
		Application.warning(string.format("[flow_callback_bot_nav_transition_left] Unit: %s missing extension \"ai_navigation_system\"", tostring(bot_unit)))
	end
end

function flow_callback_bot_nav_transition_left(self)
	-- function 36
	local bot_unit = self.bot_unit
	local transition_unit = self.transition_unit
	local bot_actor = self.bot_actor
	local has_extension = ScriptUnit.has_extension(bot_unit, "ai_navigation_system")

	has_extension = not has_extension and ScriptUnit.extension(bot_unit, "ai_navigation_system")

	if not has_extension then
		if not has_extension.flow_cb_left_nav_transition then
			has_extension:flow_cb_left_nav_transition(transition_unit, bot_actor)
		end
	else
		Application.warning(string.format("[flow_callback_bot_nav_transition_left] Unit: %s missing extension \"ai_navigation_system\"", tostring(bot_unit)))
	end
end

function flow_callback_player_bot_hold_position(self)
	-- function 37
	if not Managers.player.is_server then
		return
	end

	local player_unit = self.player_unit
	local has_extension = ScriptUnit.has_extension(player_unit, "ai_bot_group_system")

	if not has_extension then
		if not self.should_hold_position then
			local nav_world = Managers.state.entity:system("ai_system"):nav_world()
			local position = self.position

			position = position or Unit.local_position(player_unit, 0)

			local num = 0.5
			local num_2 = 2
			local triangle_from_position, var_37_7 = GwNavQueries.triangle_from_position(nav_world, position, num, num_2)

			if not triangle_from_position then
				local max_allowed_distance_from_position = self.max_allowed_distance_from_position

				max_allowed_distance_from_position = max_allowed_distance_from_position or 0
				position = Vector3(position.x, position.y, var_37_7)

				has_extension:set_hold_position(position, max_allowed_distance_from_position)
			else
				Application.warning(string.format("[flow_callback_player_bot_hold_position] %s could not hold position %s since it is not near navmesh!", tostring(player_unit), tostring(position)))
			end
		else
			has_extension:set_hold_position(nil)
		end
	else
		Application.warning(string.format("[flow_callback_player_bot_hold_position] Unit: %s is missing ai_bot_group_extension", tostring(player_unit)))
	end
end

function flow_callback_overcharge_explode_player_bot(self)
	-- function 38
	if not Managers.player.is_server then
		return
	end

	local player_unit = self.player_unit

	if not Unit.alive(player_unit) then
		local has_extension = ScriptUnit.has_extension(player_unit, "overcharge_system")

		fassert(has_extension, "Tried to overcharge explode unit %s from flow but the unit has no overcharge extension", player_unit)

		local get_max_value = has_extension:get_max_value()

		has_extension:add_charge(get_max_value)
		has_extension:add_charge(get_max_value)
	end
end

function flow_callback_broadphase_ai_set_goal_destination(self)
	-- function 39
	if not Managers.player.is_server then
		return
	end

	local goal_unit = self.goal_unit
	local local_position = Unit.local_position(goal_unit, 0)
	local var_39_2
	local num = 1
	local num_2 = 5
	local system = Managers.state.entity:system("ai_system")
	local nav_world = system:nav_world()
	local triangle_from_position, var_39_8 = GwNavQueries.triangle_from_position(nav_world, local_position, num, num_2)

	if not triangle_from_position then
		var_39_2 = Vector3(local_position.x, local_position.y, var_39_8)
	else
		local num_3 = 5
		local num_4 = 0.1

		var_39_2 = GwNavQueries.inside_position_from_outside_position(nav_world, local_position, num, num_2, num_3, num_4)
	end

	if not var_39_2 then
		local broadphase_radius = self.broadphase_radius
		local broadphase_start_unit = self.broadphase_start_unit
		local local_position_2 = Unit.local_position(broadphase_start_unit, 0)
		local BLACKBOARDS = BLACKBOARDS
		local affected_breed = self.affected_breed
		local alloc_table = FrameTable.alloc_table()
		local query = Broadphase.query(system.broadphase, local_position_2, broadphase_radius, alloc_table)

		for i = 1, query do
			local var_39_18 = alloc_table[i]
			local var_39_19 = BLACKBOARDS[var_39_18]

			if var_39_19.breed.name ~= affected_breed or not HEALTH_ALIVE[var_39_18] then
				if var_39_19.goal_destination == nil then
					var_39_19.goal_destination = Vector3Box(var_39_2)
				else
					Application.warning(string.format("[flow_callback_broadphase_ai_set_goal_destination] Unit: %s already have a goal destination!", tostring(var_39_18)))
				end
			end
		end
	else
		Application.warning(string.format("[flow_callback_broadphase_ai_set_goal_destination] Couldn't find nearby navmesh for Goal Unit: %s", tostring(goal_unit)))
	end
end

function flow_callback_get_crossroad_path_id(self)
	-- function 40
	local crossroad_id = self.crossroad_id
	local var_40_1 = Managers.state.conflict.level_analysis.chosen_crossroads[crossroad_id]

	flow_return_table.path_id = var_40_1

	return flow_return_table
end
