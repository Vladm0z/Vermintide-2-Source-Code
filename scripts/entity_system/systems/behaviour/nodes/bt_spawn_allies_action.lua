-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_spawn_allies_action.lua

BTSpawnAllies = class(BTSpawnAllies, BTNode)

function BTSpawnAllies.init(arg_1_0, ...)
	BTSpawnAllies.super.init(arg_1_0, ...)
end

BTSpawnAllies.name = "BTSpawnAllies"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTSpawnAllies.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTSpawnAllies
	arg_3_2.disable_improve_slot_position = true

	local var_3_1 = var_3_0.stay_still
	local var_3_2 = var_3_0.find_spawn_points
	local var_3_3
	local var_3_4

	if arg_3_2.has_call_position then
		var_3_4 = arg_3_2.spawning_allies
		var_3_3 = var_3_0.stay_still or var_3_4.call_position:unbox()
		arg_3_2.has_call_position = false
	elseif var_3_2 then
		var_3_4 = {
			end_time = math.huge
		}
		arg_3_2.spawning_allies = var_3_4
		var_3_3 = BTSpawnAllies.find_spawn_point(arg_3_1, arg_3_2, var_3_0, var_3_4)
	end

	if arg_3_2.override_spawn_allies_call_position then
		var_3_3 = arg_3_2.override_spawn_allies_call_position:unbox()

		var_3_4.call_position:store(var_3_3)

		var_3_1 = false
	end

	if var_3_1 then
		if var_3_0.animation then
			Managers.state.network:anim_event(arg_3_1, var_0_0(var_3_0.animation))
		end

		arg_3_2.navigation_extension:set_enabled(false)
		arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	else
		local var_3_5 = arg_3_2.navigation_extension

		var_3_5:set_max_speed(var_3_0.run_to_spawn_speed)
		var_3_5:move_to(var_3_3)

		arg_3_2.run_speed_overridden = true

		if arg_3_2.move_state ~= "moving" then
			local var_3_6, var_3_7 = LocomotionUtils.get_start_anim(arg_3_1, arg_3_2, var_3_0.start_anims)

			if var_3_7 then
				LocomotionUtils.set_animation_driven_movement(arg_3_1, true, false, false)
				arg_3_2.locomotion_extension:use_lerp_rotation(false)

				arg_3_2.follow_animation_locked = var_3_7
				arg_3_2.anim_cb_rotation_start = nil
				arg_3_2.move_animation_name = var_3_6

				local var_3_8 = AiAnimUtils.get_animation_rotation_scale(arg_3_1, POSITION_LOOKUP[arg_3_2.target_unit], var_3_6, var_3_0.start_anims_data)

				LocomotionUtils.set_animation_rotation_scale(arg_3_1, var_3_8)

				arg_3_2.move_animation_name = nil
			end

			Managers.state.network:anim_event(arg_3_1, var_3_6 or var_3_0.move_anim)

			arg_3_2.move_state = "moving"
		end
	end

	if var_3_0.has_ward then
		arg_3_0:_activate_ward(arg_3_1, arg_3_2)
	end

	local var_3_9 = var_3_0.stinger_name

	if var_3_9 and not arg_3_2.played_stinger then
		local var_3_10 = Managers.world:wwise_world(arg_3_2.world)
		local var_3_11, var_3_12 = WwiseWorld.trigger_event(var_3_10, var_3_9)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_server_audio_event", NetworkLookup.sound_events[var_3_9])

		arg_3_2.played_stinger = true
	end
end

function BTSpawnAllies.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.navigation_extension

	var_4_0:set_enabled(true)

	arg_4_2.disable_improve_slot_position = false

	if arg_4_2.action.stay_still then
		if arg_4_2.action.defensive_mode_duration then
			if type(arg_4_2.action.defensive_mode_duration) == "table" then
				local var_4_1 = Managers.state.difficulty:get_difficulty_rank()

				arg_4_2.defensive_mode_duration = arg_4_2.action.defensive_mode_duration[var_4_1] or arg_4_2.action.defensive_mode_duration[2]
			else
				arg_4_2.defensive_mode_duration = arg_4_2.action.defensive_mode_duration
			end
		end

		arg_4_2.action = nil
		arg_4_2.spawning_allies = nil
		arg_4_2.spawned_allies_wave = arg_4_2.spawned_allies_wave + 1
	else
		var_4_0:set_max_speed(arg_4_2.run_speed)

		arg_4_2.run_speed_overridden = nil

		if arg_4_2.action.defensive_mode_duration and type(arg_4_2.action.defensive_mode_duration) == "table" then
			local var_4_2 = Managers.state.difficulty:get_difficulty_rank()

			arg_4_2.defensive_mode_duration = arg_4_2.action.defensive_mode_duration[var_4_2] or arg_4_2.action.defensive_mode_duration[2]
		else
			arg_4_2.defensive_mode_duration = arg_4_2.action.defensive_mode_duration or 20
		end

		arg_4_2.action = nil
		arg_4_2.spawning_allies = nil
		arg_4_2.spawned_allies_wave = arg_4_2.spawned_allies_wave + 1
	end

	if arg_4_2.follow_animation_locked then
		arg_4_0:_release_animation_lock(arg_4_1, arg_4_2)
	end

	arg_4_2.active_node = nil
end

function BTSpawnAllies._activate_ward(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.action.ward_function

	if not arg_5_2.ward_active then
		arg_5_2.ward_active = true

		var_5_0(arg_5_1, true, true)
	end
end

local function var_0_1(arg_6_0, ...)
	if script_data.ai_champion_spawn_debug then
		QuickDrawerStay[arg_6_0](QuickDrawerStay, ...)
	end
end

local function var_0_2(...)
	if script_data.ai_champion_spawn_debug then
		print(...)
	end
end

local var_0_3 = {}

function BTSpawnAllies.find_spawn_point(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_4 or arg_8_2.optional_go_to_spawn or arg_8_2.spawn_group
	local var_8_1 = Managers.state.entity:system("spawner_system")
	local var_8_2 = var_8_1._id_lookup[var_8_0]

	if not var_8_2 and arg_8_2.use_fallback_spawners then
		var_8_2 = var_8_1._enabled_spawners
	end

	fassert(var_8_2, "Level %s is lacking spawners of spawner group %s, this is necessary to use BTSpawnAllies behaviour in breed %s", Managers.state.game_mode:level_key(), var_8_0, arg_8_1.breed.name)

	local var_8_3 = table.clone(var_8_2)
	local var_8_4 = arg_8_1.side
	local var_8_5 = var_8_4.ENEMY_PLAYER_AND_BOT_POSITIONS
	local var_8_6 = var_8_4.ENEMY_PLAYER_AND_BOT_UNITS
	local var_8_7 = Vector3(0, 0, 0)
	local var_8_8 = 0

	for iter_8_0, iter_8_1 in ipairs(var_8_5) do
		local var_8_9 = var_8_6[iter_8_0]

		if not ScriptUnit.extension(var_8_9, "status_system"):is_disabled() then
			var_8_8 = var_8_8 + 1
			var_8_7 = var_8_7 + iter_8_1
		end
	end

	local var_8_10 = Vector3.distance_squared
	local var_8_11 = POSITION_LOOKUP[arg_8_0]

	if var_8_8 > 0 then
		local var_8_12 = Vector3.flat(var_8_7 / var_8_8)
		local var_8_13 = -math.huge
		local var_8_14
		local var_8_15 = #var_8_3

		for iter_8_2 = 1, var_8_15 do
			local var_8_16 = var_8_3[iter_8_2]
			local var_8_17 = ScriptUnit.extension(var_8_16, "spawner_system"):spawn_position()

			var_0_3[iter_8_2] = var_8_17

			local var_8_18 = var_8_10(Vector3.flat(var_8_17), var_8_12)

			if var_8_13 < var_8_18 then
				var_8_13 = var_8_18
				var_8_14 = iter_8_2
			end
		end

		for iter_8_3, iter_8_4 in pairs(var_0_3) do
			var_0_1("sphere", iter_8_4, 0.05, Color(255, 255, 255))
		end

		local var_8_19 = var_0_3[var_8_14]
		local var_8_20
		local var_8_21 = math.huge

		for iter_8_5 = 1, var_8_15 do
			if iter_8_5 ~= var_8_14 then
				local var_8_22 = var_0_3[iter_8_5]
				local var_8_23 = var_8_10(Vector3.flat(var_8_22), Vector3.flat(var_8_19))

				if var_8_23 < var_8_21 then
					var_8_20 = iter_8_5
					var_8_21 = var_8_23
				end
			end
		end

		local var_8_24 = var_8_3[var_8_14]
		local var_8_25 = var_8_3[var_8_20]
		local var_8_26 = Vector3.normalize(Vector3.flat(Quaternion.forward(ScriptUnit.extension(var_8_24, "spawner_system"):spawn_rotation()) + Quaternion.forward(ScriptUnit.extension(var_8_25, "spawner_system"):spawn_rotation())))
		local var_8_27 = var_0_3[var_8_14]
		local var_8_28 = var_0_3[var_8_20]

		var_0_1("sphere", var_8_27, 0.34, Color(0, 255, 255))
		var_0_1("sphere", var_8_28, 0.34, Color(0, 255, 255))

		local var_8_29 = (var_0_3[var_8_14] + var_0_3[var_8_20]) * 0.5

		var_8_29.z = math.max(var_0_3[var_8_14].z, var_0_3[var_8_20].z)

		var_0_1("sphere", var_8_29, 0.34, Color(0, 255, 255))
		var_0_1("line", var_8_27, var_8_28, Color(0, 255, 255))

		local var_8_30 = 0.25
		local var_8_31 = arg_8_1.nav_world
		local var_8_32 = var_8_29 + var_8_26 * 1.5
		local var_8_33 = 0.25
		local var_8_34 = 10
		local var_8_35
		local var_8_36

		var_0_1("line", var_8_29, var_8_32, Color(0, 255, 255))

		for iter_8_6 = 1, 10 do
			local var_8_37 = var_8_32

			var_8_32 = var_8_32 + var_8_30 * var_8_26

			local var_8_38, var_8_39 = GwNavQueries.triangle_from_position(var_8_31, var_8_32, var_8_33, var_8_34)
			local var_8_40 = var_8_39

			if var_8_38 then
				var_8_11 = Vector3(var_8_32.x, var_8_32.y, var_8_40)

				var_0_2("success")
				var_0_1("line", var_8_37, var_8_11, Color(0, 255, 0))
				var_0_1("sphere", var_8_11, 0.34, Color(0, 255, 255))

				break
			else
				var_0_2("fail")
				var_0_1("line", var_8_37, var_8_32, Color(255, 0, 0))
				var_0_1("sphere", var_8_32, 0.34, Color(255, 0, 0))
			end
		end

		arg_8_3.spawn_forward = Vector3Box(var_8_26)
		arg_8_3.spawners = {
			var_8_3[var_8_14],
			var_8_3[var_8_20]
		}

		table.clear(var_0_3)
	else
		arg_8_3.spawn_forward = Vector3Box(Quaternion.forward(Unit.local_rotation(arg_8_0, 0)))
		arg_8_3.spawners = {
			var_8_3[1],
			var_8_3[2]
		}
	end

	arg_8_3.call_position = Vector3Box(var_8_11)

	return var_8_11
end

function BTSpawnAllies._spawn(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_3.action

	if var_9_0.animation then
		Managers.state.network:anim_event(arg_9_1, var_0_0(var_9_0.animation))
	end

	arg_9_3.navigation_extension:set_enabled(false)

	local var_9_1 = arg_9_3.side.side_id
	local var_9_2 = arg_9_3.locomotion_extension

	var_9_2:set_wanted_velocity(Vector3.zero())
	var_9_2:use_lerp_rotation(true)

	if not var_9_0.dont_rotate then
		var_9_2:set_wanted_rotation(Quaternion.look(arg_9_2.spawn_forward:unbox(), Vector3.up()))
	end

	local var_9_3 = Managers.state.difficulty:get_difficulty()

	if var_9_0.difficulty_spawn_list or var_9_0.spawn_list then
		local var_9_4 = var_9_0.difficulty_spawn_list or var_9_0.difficulty_spawn_list[var_9_3] or var_9_0.spawn_list
		local var_9_5 = arg_9_2.spawners

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_9_1, "enemy_attack", DialogueSettings.enemy_spawn_allies, "attack_tag", "spawn_allies")

		local var_9_6 = Managers.state.entity:system("spawner_system")

		for iter_9_0 = 1, #var_9_4 do
			local var_9_7 = var_9_5[(iter_9_0 - 1) % #var_9_5 + 1]

			var_9_6:spawn_horde(var_9_7, {
				var_9_4[iter_9_0]
			}, var_9_1)
		end
	end

	local var_9_8

	if var_9_0.phase_spawn then
		local var_9_9, var_9_10, var_9_11, var_9_12, var_9_13 = arg_9_3.health_extension:respawn_thresholds()

		var_9_8 = var_9_0.phase_spawn[var_9_13]
	else
		var_9_8 = var_9_0.difficulty_spawn and var_9_0.difficulty_spawn[var_9_3] or var_9_0.spawn
	end

	if var_9_8 then
		local var_9_14 = true
		local var_9_15 = true
		local var_9_16 = var_9_8
		local var_9_17 = var_9_0.limit_spawners
		local var_9_18 = var_9_0.use_closest_spawners
		local var_9_19 = arg_9_1
		local var_9_20 = var_9_0.terror_event_id
		local var_9_21 = Managers.state.conflict
		local var_9_22 = {
			size = 0,
			template = "horde",
			id = Managers.state.entity:system("ai_group_system"):generate_group_id()
		}

		arg_9_3.spawn_allies_horde = var_9_21.horde_spawner:execute_event_horde(arg_9_4, var_9_20, var_9_1, var_9_16, var_9_17, var_9_15, var_9_22, var_9_14, nil, var_9_18, var_9_19)
	end
end

function BTSpawnAllies.run(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2.spawning_allies

	if not var_10_0 then
		return "done"
	end

	if arg_10_3 > var_10_0.end_time then
		arg_10_2.played_stinger = nil

		return "done"
	else
		local var_10_1 = arg_10_2.action

		if not var_10_0.spawned and (var_10_1.stay_still or Vector3.distance_squared(POSITION_LOOKUP[arg_10_1], var_10_0.call_position:unbox()) < 0.5 or arg_10_2.navigation_extension:number_failed_move_attempts() > 1) then
			var_10_0.spawned = true
			var_10_0.end_time = arg_10_3 + var_10_1.duration

			if arg_10_2.follow_animation_locked then
				arg_10_0:_release_animation_lock(arg_10_1, arg_10_2)
			end

			arg_10_0:_spawn(arg_10_1, var_10_0, arg_10_2, arg_10_3)
		elseif var_10_0.spawned then
			arg_10_2.locomotion_extension:set_wanted_rotation(Quaternion.look(var_10_0.spawn_forward:unbox(), Vector3.up()))
		elseif arg_10_2.follow_animation_locked and arg_10_2.anim_cb_rotation_start then
			arg_10_0:_release_animation_lock(arg_10_1, arg_10_2)
		end

		return "running"
	end
end

function BTSpawnAllies._release_animation_lock(arg_11_0, arg_11_1, arg_11_2)
	arg_11_2.follow_animation_locked = nil

	LocomotionUtils.set_animation_driven_movement(arg_11_1, false)
	arg_11_2.locomotion_extension:use_lerp_rotation(true)
end
