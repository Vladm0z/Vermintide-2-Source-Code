-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_spawn_allies_action.lua

BTSpawnAllies = class(BTSpawnAllies, BTNode)

BTSpawnAllies.init = function (arg_1_0, ...)
	-- function 1
	BTSpawnAllies.super.init(arg_1_0, ...)
end

BTSpawnAllies.name = "BTSpawnAllies"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTSpawnAllies.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTSpawnAllies
	arg_3_2.disable_improve_slot_position = true

	local stay_still = action_data.stay_still
	local find_spawn_points = action_data.find_spawn_points
	local var_3_3
	local var_3_4

	if not arg_3_2.has_call_position then
		var_3_4 = arg_3_2.spawning_allies
		var_3_3 = action_data.stay_still or var_3_4.call_position:unbox()
		arg_3_2.has_call_position = false
	elseif not find_spawn_points then
		var_3_4 = {
			end_time = math.huge
		}
		arg_3_2.spawning_allies = var_3_4
		var_3_3 = BTSpawnAllies.find_spawn_point(arg_3_1, arg_3_2, action_data, var_3_4)
	end

	if not arg_3_2.override_spawn_allies_call_position then
		var_3_3 = arg_3_2.override_spawn_allies_call_position:unbox()

		var_3_4.call_position:store(var_3_3)

		stay_still = false
	end

	if not stay_still then
		if not action_data.animation then
			Managers.state.network:anim_event(arg_3_1, fn(action_data.animation))
		end

		arg_3_2.navigation_extension:set_enabled(false)
		arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	else
		local navigation_extension = arg_3_2.navigation_extension

		navigation_extension:set_max_speed(action_data.run_to_spawn_speed)
		navigation_extension:move_to(var_3_3)

		arg_3_2.run_speed_overridden = true

		if arg_3_2.move_state ~= "moving" then
			local get_start_anim, var_3_7 = LocomotionUtils.get_start_anim(arg_3_1, arg_3_2, action_data.start_anims)

			if not var_3_7 then
				LocomotionUtils.set_animation_driven_movement(arg_3_1, true, false, false)
				arg_3_2.locomotion_extension:use_lerp_rotation(false)

				arg_3_2.follow_animation_locked = var_3_7
				arg_3_2.anim_cb_rotation_start = nil
				arg_3_2.move_animation_name = get_start_anim

				local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_3_1, POSITION_LOOKUP[arg_3_2.target_unit], get_start_anim, action_data.start_anims_data)

				LocomotionUtils.set_animation_rotation_scale(arg_3_1, get_animation_rotation_scale)

				arg_3_2.move_animation_name = nil
			end

			Managers.state.network:anim_event(arg_3_1, get_start_anim or action_data.move_anim)

			arg_3_2.move_state = "moving"
		end
	end

	if not action_data.has_ward then
		self:_activate_ward(arg_3_1, arg_3_2)
	end

	local stinger_name = action_data.stinger_name

	if not (not stinger_name and arg_3_2.played_stinger) then
		local wwise_world = Managers.world:wwise_world(arg_3_2.world)
		local trigger_event, var_3_12 = WwiseWorld.trigger_event(wwise_world, stinger_name)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_event", NetworkLookup.sound_events[stinger_name])

		arg_3_2.played_stinger = true
	end
end

BTSpawnAllies.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local navigation_extension = arg_4_2.navigation_extension

	navigation_extension:set_enabled(true)

	arg_4_2.disable_improve_slot_position = false

	if not arg_4_2.action.stay_still then
		if not arg_4_2.action.defensive_mode_duration then
			if type(arg_4_2.action.defensive_mode_duration) == "table" then
				local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
				local var_4_2 = arg_4_2.action.defensive_mode_duration[get_difficulty_rank]

				var_4_2 = var_4_2 or arg_4_2.action.defensive_mode_duration[2]
				arg_4_2.defensive_mode_duration = var_4_2
			else
				arg_4_2.defensive_mode_duration = arg_4_2.action.defensive_mode_duration
			end
		end

		arg_4_2.action = nil
		arg_4_2.spawning_allies = nil
		arg_4_2.spawned_allies_wave = arg_4_2.spawned_allies_wave + 1
	else
		navigation_extension:set_max_speed(arg_4_2.run_speed)

		arg_4_2.run_speed_overridden = nil

		if not (not arg_4_2.action.defensive_mode_duration and type(arg_4_2.action.defensive_mode_duration) ~= "table") then
			local get_difficulty_rank_2 = Managers.state.difficulty:get_difficulty_rank()
			local var_4_4 = arg_4_2.action.defensive_mode_duration[get_difficulty_rank_2]

			var_4_4 = var_4_4 or arg_4_2.action.defensive_mode_duration[2]
			arg_4_2.defensive_mode_duration = var_4_4
		else
			local defensive_mode_duration = arg_4_2.action.defensive_mode_duration

			defensive_mode_duration = defensive_mode_duration or 20
			arg_4_2.defensive_mode_duration = defensive_mode_duration
		end

		arg_4_2.action = nil
		arg_4_2.spawning_allies = nil
		arg_4_2.spawned_allies_wave = arg_4_2.spawned_allies_wave + 1
	end

	if not arg_4_2.follow_animation_locked then
		self:_release_animation_lock(arg_4_1, arg_4_2)
	end

	arg_4_2.active_node = nil
end

BTSpawnAllies._activate_ward = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local ward_function = arg_5_2.action.ward_function

	if not arg_5_2.ward_active then
		arg_5_2.ward_active = true

		ward_function(arg_5_1, true, true)
	end
end

local function fn_2(arg_6_0, ...)
	-- function 6
	if not script_data.ai_champion_spawn_debug then
		QuickDrawerStay[arg_6_0](QuickDrawerStay, ...)
	end
end

local function fn_3(...)
	-- function 7
	if not script_data.ai_champion_spawn_debug then
		print(...)
	end
end

local tbl = {}

BTSpawnAllies.find_spawn_point = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	if not arg_8_4 then
		-- Nothing
	end

	::label_8_0::

	local optional_go_to_spawn = arg_8_2.optional_go_to_spawn

	optional_go_to_spawn = optional_go_to_spawn or arg_8_2.spawn_group

	::label_8_1::

	local system = Managers.state.entity:system("spawner_system")
	local var_8_2 = system._id_lookup[optional_go_to_spawn]

	if var_8_2 or not arg_8_2.use_fallback_spawners then
		var_8_2 = system._enabled_spawners
	end

	fassert(var_8_2, "Level %s is lacking spawners of spawner group %s, this is necessary to use BTSpawnAllies behaviour in breed %s", Managers.state.game_mode:level_key(), optional_go_to_spawn, arg_8_1.breed.name)

	local clone = table.clone(var_8_2)
	local side = arg_8_1.side
	local ENEMY_PLAYER_AND_BOT_POSITIONS = side.ENEMY_PLAYER_AND_BOT_POSITIONS
	local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS
	local var_8_7 = Vector3(0, 0, 0)
	local num = 0

	for i, v in ipairs(ENEMY_PLAYER_AND_BOT_POSITIONS) do
		local var_8_9 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not ScriptUnit.extension(var_8_9, "status_system"):is_disabled() then
			num = num + 1
			var_8_7 = var_8_7 + v
		end
	end

	local distance_squared = Vector3.distance_squared
	local var_8_11 = POSITION_LOOKUP[arg_8_0]

	if num > 0 then
		local flat = Vector3.flat(var_8_7 / num)
		local num_2 = -math.huge
		local var_8_14
		local count = #clone

		for k = 1, count do
			local var_8_16 = clone[k]
			local spawn_position = ScriptUnit.extension(var_8_16, "spawner_system"):spawn_position()

			tbl[k] = spawn_position

			local var_8_18 = distance_squared(Vector3.flat(spawn_position), flat)

			if num_2 < var_8_18 then
				num_2 = var_8_18
				var_8_14 = k
			end
		end

		for k_2, v_2 in pairs(tbl) do
			fn_2("sphere", v_2, 0.05, Color(255, 255, 255))
		end

		local var_8_19 = tbl[var_8_14]
		local var_8_20
		local huge = math.huge

		for i5 = 1, count do
			if i5 ~= var_8_14 then
				local var_8_22 = tbl[i5]
				local var_8_23 = distance_squared(Vector3.flat(var_8_22), Vector3.flat(var_8_19))

				if var_8_23 < huge then
					var_8_20 = i5
					huge = var_8_23
				end
			end
		end

		local var_8_24 = clone[var_8_14]
		local var_8_25 = clone[var_8_20]
		local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(ScriptUnit.extension(var_8_24, "spawner_system"):spawn_rotation()) + Quaternion.forward(ScriptUnit.extension(var_8_25, "spawner_system"):spawn_rotation())))
		local var_8_27 = tbl[var_8_14]
		local var_8_28 = tbl[var_8_20]

		fn_2("sphere", var_8_27, 0.34, Color(0, 255, 255))
		fn_2("sphere", var_8_28, 0.34, Color(0, 255, 255))

		local num_3 = (tbl[var_8_14] + tbl[var_8_20]) * 0.5

		num_3.z = math.max(tbl[var_8_14].z, tbl[var_8_20].z)

		fn_2("sphere", num_3, 0.34, Color(0, 255, 255))
		fn_2("line", var_8_27, var_8_28, Color(0, 255, 255))

		local num_4 = 0.25
		local nav_world = arg_8_1.nav_world
		local num_5 = num_3 + normalize * 1.5
		local num_6 = 0.25
		local num_7 = 10
		local var_8_35
		local var_8_36

		fn_2("line", num_3, num_5, Color(0, 255, 255))

		for i6 = 1, 10 do
			local var_8_37 = num_5

			num_5 = num_5 + num_4 * normalize

			local triangle_from_position, var_8_39 = GwNavQueries.triangle_from_position(nav_world, num_5, num_6, num_7)
			local var_8_40 = var_8_39

			if not triangle_from_position then
				var_8_11 = Vector3(num_5.x, num_5.y, var_8_40)

				fn_3("success")
				fn_2("line", var_8_37, var_8_11, Color(0, 255, 0))
				fn_2("sphere", var_8_11, 0.34, Color(0, 255, 255))

				break
			else
				fn_3("fail")
				fn_2("line", var_8_37, num_5, Color(255, 0, 0))
				fn_2("sphere", num_5, 0.34, Color(255, 0, 0))
			end
		end

		arg_8_3.spawn_forward = Vector3Box(normalize)
		arg_8_3.spawners = {
			clone[var_8_14],
			clone[var_8_20]
		}

		table.clear(tbl)
	else
		arg_8_3.spawn_forward = Vector3Box(Quaternion.forward(Unit.local_rotation(arg_8_0, 0)))
		arg_8_3.spawners = {
			clone[1],
			clone[2]
		}
	end

	arg_8_3.call_position = Vector3Box(var_8_11)

	return var_8_11
end

BTSpawnAllies._spawn = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local action = arg_9_3.action

	if not action.animation then
		Managers.state.network:anim_event(arg_9_1, fn(action.animation))
	end

	arg_9_3.navigation_extension:set_enabled(false)

	local side_id = arg_9_3.side.side_id
	local locomotion_extension = arg_9_3.locomotion_extension

	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:use_lerp_rotation(true)

	if not action.dont_rotate then
		locomotion_extension:set_wanted_rotation(Quaternion.look(arg_9_2.spawn_forward:unbox(), Vector3.up()))
	end

	local get_difficulty = Managers.state.difficulty:get_difficulty()

	if action.difficulty_spawn_list or not action.spawn_list then
		local difficulty_spawn_list = action.difficulty_spawn_list

		if not difficulty_spawn_list then
			difficulty_spawn_list = action.difficulty_spawn_list[get_difficulty]
			difficulty_spawn_list = difficulty_spawn_list or action.spawn_list
		end

		local spawners = arg_9_2.spawners

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_9_1, "enemy_attack", DialogueSettings.enemy_spawn_allies, "attack_tag", "spawn_allies")

		local system = Managers.state.entity:system("spawner_system")

		for i = 1, #difficulty_spawn_list do
			local var_9_7 = spawners[(i - 1) % #spawners + 1]

			system:spawn_horde(var_9_7, {
				difficulty_spawn_list[i]
			}, side_id)
		end
	end

	local var_9_8

	if not action.phase_spawn then
		local respawn_thresholds, var_9_10, var_9_11, var_9_12, var_9_13 = arg_9_3.health_extension:respawn_thresholds()

		var_9_8 = action.phase_spawn[var_9_13]
	else
		var_9_8 = not action.difficulty_spawn and action.difficulty_spawn[get_difficulty] and action.spawn
	end

	if not var_9_8 then
		local flag = true
		local flag_2 = true
		local var_9_16 = var_9_8
		local limit_spawners = action.limit_spawners
		local use_closest_spawners = action.use_closest_spawners
		local var_9_19 = arg_9_1
		local terror_event_id = action.terror_event_id
		local conflict = Managers.state.conflict
		local tbl = {
			size = 0,
			template = "horde",
			id = Managers.state.entity:system("ai_group_system"):generate_group_id()
		}

		arg_9_3.spawn_allies_horde = conflict.horde_spawner:execute_event_horde(arg_9_4, terror_event_id, side_id, var_9_16, limit_spawners, flag_2, tbl, flag, nil, use_closest_spawners, var_9_19)
	end
end

BTSpawnAllies.run = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local spawning_allies = arg_10_2.spawning_allies

	if not spawning_allies then
		return "done"
	end

	if arg_10_3 > spawning_allies.end_time then
		arg_10_2.played_stinger = nil

		return "done"
	else
		local action = arg_10_2.action

		if not (spawning_allies.spawned or action.stay_still or Vector3.distance_squared(POSITION_LOOKUP[arg_10_1], spawning_allies.call_position:unbox()) < 0.5 or not (arg_10_2.navigation_extension:number_failed_move_attempts() > 1)) then
			spawning_allies.spawned = true
			spawning_allies.end_time = arg_10_3 + action.duration

			if not arg_10_2.follow_animation_locked then
				self:_release_animation_lock(arg_10_1, arg_10_2)
			end

			self:_spawn(arg_10_1, spawning_allies, arg_10_2, arg_10_3)
		elseif not spawning_allies.spawned then
			arg_10_2.locomotion_extension:set_wanted_rotation(Quaternion.look(spawning_allies.spawn_forward:unbox(), Vector3.up()))
		elseif not arg_10_2.follow_animation_locked and not arg_10_2.anim_cb_rotation_start then
			self:_release_animation_lock(arg_10_1, arg_10_2)
		end

		return "running"
	end
end

BTSpawnAllies._release_animation_lock = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	arg_11_2.follow_animation_locked = nil

	LocomotionUtils.set_animation_driven_movement(arg_11_1, false)
	arg_11_2.locomotion_extension:use_lerp_rotation(true)
end
