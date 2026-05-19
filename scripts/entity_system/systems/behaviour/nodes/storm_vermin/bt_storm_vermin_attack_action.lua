-- chunkname: @scripts/entity_system/systems/behaviour/nodes/storm_vermin/bt_storm_vermin_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTStormVerminAttackAction = class(BTStormVerminAttackAction, BTNode)

function BTStormVerminAttackAction.init(arg_1_0, ...)
	BTStormVerminAttackAction.super.init(arg_1_0, ...)
end

BTStormVerminAttackAction.name = "BTStormVerminAttackAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTStormVerminAttackAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTStormVerminAttackAction
	arg_3_2.attack_range = var_3_0.range
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.target_speed = 0
	arg_3_2.attack_token = true
	arg_3_2.play_sound_delay = arg_3_3 + (var_3_0.sound_delay or 0)

	if var_3_0.blocked_anim then
		arg_3_2.blocked_anim = var_3_0.blocked_anim
	end

	local var_3_1 = arg_3_2.target_unit
	local var_3_2 = ScriptUnit.has_extension(var_3_1, "status_system") or nil

	arg_3_2.target_unit_status_extension = var_3_2
	arg_3_2.attacking_target = arg_3_2.target_unit

	arg_3_0:_init_attack(arg_3_1, arg_3_2, arg_3_3)

	if not arg_3_2.moving_attack then
		arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
		arg_3_2.navigation_extension:set_enabled(false)
	end

	arg_3_2.spawn_to_running = nil

	if var_3_2 then
		local var_3_3 = arg_3_2.breed

		if var_3_3.use_backstab_vo then
			local var_3_4 = Managers.player:unit_owner(var_3_1)

			if var_3_4 and not var_3_4.bot_player then
				local var_3_5 = AiUtils.unit_is_flanking_player(arg_3_1, var_3_1)

				if var_3_4.local_player then
					if var_3_5 then
						local var_3_6 = ScriptUnit.extension(arg_3_1, "dialogue_system")
						local var_3_7, var_3_8 = WwiseUtils.make_unit_auto_source(arg_3_2.world, arg_3_1, var_3_6.voice_node)
						local var_3_9 = var_3_3.backstab_player_sound_event

						Managers.state.entity:system("audio_system"):_play_event_with_source(var_3_8, var_3_9, var_3_7)
					end
				else
					local var_3_10 = Managers.state.network
					local var_3_11 = var_3_10.network_transmit
					local var_3_12 = var_3_10:unit_game_object_id(arg_3_1)
					local var_3_13 = var_3_4:network_id()

					var_3_11:send_rpc("rpc_check_trigger_backstab_sfx", var_3_13, var_3_12)
				end
			end
		end

		AiUtils.add_attack_intensity(var_3_1, var_3_0, arg_3_2)

		if arg_3_2.moving_attack and ScriptUnit.has_extension(arg_3_1, "ai_slot_system") then
			Managers.state.entity:system("ai_slot_system"):set_release_slot_lock(arg_3_1, true)

			arg_3_2.keep_target = true
		end
	end

	arg_3_2.attacking_target_is_ai_breed = var_3_2 == nil

	if var_3_0.attack_finished_duration then
		local var_3_14 = Managers.state.difficulty:get_difficulty()
		local var_3_15 = var_3_0.attack_finished_duration[var_3_14]

		if var_3_15 then
			arg_3_2.attack_finished_t = arg_3_3 + Math.random_range(var_3_15[1], var_3_15[2])
		end
	end
end

function BTStormVerminAttackAction._init_attack(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_2.action

	arg_4_2.move_state = "attacking"

	local var_4_1

	if arg_4_2.target_unit_status_extension and arg_4_2.target_unit_status_extension:is_knocked_down() and var_4_0.knocked_down_attack_anim then
		local var_4_2 = POSITION_LOOKUP[arg_4_1]

		if (POSITION_LOOKUP[arg_4_2.target_unit] or Unit.world_position(arg_4_1, 0)).z - var_4_2.z < var_4_0.knocked_down_attack_threshold then
			var_4_1 = var_0_0(var_4_0.knocked_down_attack_anim)
		else
			var_4_1 = var_0_0(var_4_0.attack_anim)
		end
	elseif var_4_0.step_attack_anim then
		local var_4_3 = POSITION_LOOKUP[arg_4_1]
		local var_4_4 = POSITION_LOOKUP[arg_4_2.target_unit] or Unit.world_position(arg_4_1, 0)
		local var_4_5 = Vector3.distance(Vector3.flat(var_4_3), Vector3.flat(var_4_4))
		local var_4_6 = var_4_0.step_attack_target_speed_away or 1
		local var_4_7 = var_4_0.step_attack_distance or 1.5
		local var_4_8 = var_4_0.step_attack_target_speed_away_override or 2
		local var_4_9 = var_4_0.step_attack_distance_override or 3
		local var_4_10 = arg_4_2.target_speed_away_small_sample

		if var_4_6 < var_4_10 and var_4_7 < var_4_5 or var_4_8 < var_4_10 or var_4_9 < var_4_5 then
			arg_4_2.moving_attack = true
			var_4_1 = var_0_0(var_4_0.step_attack_anim)
		else
			var_4_1 = var_0_0(var_4_0.attack_anim)
		end
	else
		arg_4_2.moving_attack = var_4_0.moving_attack
		var_4_1 = var_0_0(var_4_0.attack_anim)
	end

	Managers.state.network:anim_event(arg_4_1, var_4_1)

	local var_4_11 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, arg_4_2.attacking_target)

	arg_4_2.attack_rotation = QuaternionBox(var_4_11)

	if arg_4_2.moving_attack and var_4_0.rotation_time_step then
		arg_4_2.attack_rotation_update_timer = arg_4_3 + var_4_0.rotation_time_step
	else
		arg_4_2.attack_rotation_update_timer = arg_4_3 + var_4_0.rotation_time
	end

	if var_4_0.bot_threat_duration and not var_4_0.bot_threat_start_time then
		arg_4_0:_create_bot_threat(arg_4_1, arg_4_2)
	elseif var_4_0.bot_threat_start_time then
		if arg_4_2.moving_attack and var_4_0.bot_threat_start_time_step then
			arg_4_2.bot_threat_at_t = arg_4_3 + var_4_0.bot_threat_start_time_step
		else
			arg_4_2.bot_threat_at_t = arg_4_3 + var_4_0.bot_threat_start_time
		end
	end
end

function BTStormVerminAttackAction.leave(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_2.navigation_extension:set_enabled(true)

	arg_5_2.active_node = nil
	arg_5_2.anim_cb_stagger_immune = nil
	arg_5_2.attack_aborted = nil
	arg_5_2.attack_finished_at_t = nil
	arg_5_2.attack_rotation = nil
	arg_5_2.attack_rotation_update_timer = nil
	arg_5_2.reset_attack = nil
	arg_5_2.target_unit_status_extension = nil

	if arg_5_2.moving_attack and ScriptUnit.has_extension(arg_5_1, "ai_slot_system") then
		Managers.state.entity:system("ai_slot_system"):set_release_slot_lock(arg_5_1, false)

		arg_5_2.keep_target = nil
	end

	arg_5_2.anim_cb_attack_cooldown = nil
	arg_5_2.attack_finished_t = nil
	arg_5_2.attack_token = nil
	arg_5_2.attacking_target = nil
	arg_5_2.moving_attack = nil
	arg_5_2.reset_attack = nil
	arg_5_2.reset_attack_animation_locked = nil
	arg_5_2.reset_attack_delay = nil
	arg_5_2.past_damage_in_attack = nil
	arg_5_2.bot_threat_at_t = nil

	if arg_5_2.action.reset_stagger_count then
		ScriptUnit.extension(arg_5_1, "ai_system"):reset_stagger_count()
	end

	arg_5_2.action = nil
end

function BTStormVerminAttackAction.run(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	arg_6_0:update_reset_attack(arg_6_1, arg_6_3, arg_6_4, arg_6_2)

	if arg_6_2.attack_aborted then
		return "done"
	end

	local var_6_0 = Unit.alive(arg_6_2.attacking_target)

	if var_6_0 then
		arg_6_0:attack(arg_6_1, arg_6_3, arg_6_4, arg_6_2)
	else
		return "done"
	end

	if arg_6_2.catapult_hit then
		BTStormVerminAttackAction.catapult_enemies(arg_6_1, arg_6_2)
	end

	if arg_6_2.anim_cb_attack_cooldown and arg_6_2.attack_finished_t and arg_6_3 > arg_6_2.attack_finished_t or not arg_6_2.attack_finished_t and arg_6_2.attack_finished then
		return "done"
	end

	if arg_6_2.play_sound_delay and arg_6_3 > arg_6_2.play_sound_delay then
		local var_6_1 = arg_6_2.action.sound_event

		if var_6_1 then
			Managers.state.entity:system("audio_system"):play_audio_unit_event(var_6_1, arg_6_1)
		end

		arg_6_2.play_sound_delay = nil
	end

	if arg_6_2.moving_attack then
		local var_6_2 = arg_6_2.breed
		local var_6_3 = arg_6_2.navigation_extension
		local var_6_4 = arg_6_2.target_dist
		local var_6_5 = arg_6_2.target_speed_away_small_sample

		if var_6_4 > 2.5 then
			if arg_6_2.set_dodge_rotation_timer then
				var_6_5 = var_6_2.run_speed * 0.25
			else
				var_6_5 = var_6_2.run_speed
			end
		elseif var_6_4 > 1.5 then
			var_6_5 = arg_6_2.set_dodge_rotation_timer and 0 or var_6_5 * 1.15
		end

		if math.abs(var_6_5 - arg_6_2.target_speed) > 0.25 then
			arg_6_2.target_speed = var_6_5

			var_6_3:set_max_speed(math.clamp(var_6_5, 0, var_6_2.run_speed))
		end
	end

	if var_6_0 and arg_6_2.bot_threat_at_t and arg_6_3 > arg_6_2.bot_threat_at_t then
		arg_6_0:_create_bot_threat(arg_6_1, arg_6_2)

		arg_6_2.bot_threat_at_t = nil
	end

	return "running"
end

function BTStormVerminAttackAction._create_bot_threat(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.action
	local var_7_1 = var_7_0.bot_threat_duration

	if var_7_1 then
		if var_7_0.collision_type == "cylinder" then
			local var_7_2 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_2.attacking_target)
			local var_7_3 = arg_7_0:_calculate_cylinder_collision(var_7_0, POSITION_LOOKUP[arg_7_1], var_7_2)
			local var_7_4 = Vector3(0, var_7_0.radius, var_7_0.height * 0.5)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_7_3, "cylinder", var_7_4, nil, var_7_1, "Storm Vermin")
		elseif var_7_0.collision_type == "oobb" or not var_7_0.collision_type then
			local var_7_5 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_2.attacking_target)
			local var_7_6, var_7_7, var_7_8 = arg_7_0:_calculate_oobb_collision(var_7_0, POSITION_LOOKUP[arg_7_1], var_7_5)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_7_6, "oobb", var_7_8, var_7_7, var_7_1, "Storm Vermin")
		end
	end
end

function BTStormVerminAttackAction.anim_cb_attack_vce(arg_8_0, arg_8_1, arg_8_2)
	if Managers.state.network:game() and arg_8_2.target_unit_status_extension then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_8_2, arg_8_2.target_unit, arg_8_1, false, false)
	end
end

function BTStormVerminAttackAction.anim_cb_attack_vce_long(arg_9_0, arg_9_1, arg_9_2)
	if Managers.state.network:game() and arg_9_2.target_unit_status_extension then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_9_2, arg_9_2.target_unit, arg_9_1, false, true)
	end
end

function BTStormVerminAttackAction.update_reset_attack(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_4.action
	local var_10_1 = arg_10_4.reset_attack
	local var_10_2 = arg_10_4.reset_attack_delay
	local var_10_3 = arg_10_4.reset_attack_animation_locked

	if var_10_1 and not var_10_3 then
		local var_10_4 = var_0_0(var_10_0.reset_attack_animations)

		Managers.state.network:anim_event_with_variable_float(arg_10_1, var_10_4, "reset_speed", 0.1)

		arg_10_4.reset_attack = false
	end

	if var_10_2 then
		arg_10_4.reset_attack_delay = var_10_2 - arg_10_3

		if var_10_2 < 0 then
			local var_10_5 = var_10_0.reset_attack_animation_speed

			fassert(var_10_5, "no reset_attack_animation_speed for action %s", var_10_0.name)
			Managers.state.network:anim_set_variable_float(arg_10_1, "reset_speed", var_10_5)

			arg_10_4.reset_attack_delay = nil
		end
	end
end

function BTStormVerminAttackAction.attack(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = ScriptUnit.extension(arg_11_1, "locomotion_system")
	local var_11_1 = arg_11_4.target_unit_status_extension

	if var_11_1 and (var_11_1:get_is_dodging() or var_11_1:is_invisible()) then
		arg_11_4.attack_rotation_update_timer = arg_11_2
	end

	if arg_11_2 < arg_11_4.attack_rotation_update_timer then
		local var_11_2 = LocomotionUtils.rotation_towards_unit_flat(arg_11_1, arg_11_4.attacking_target)

		arg_11_4.attack_rotation = QuaternionBox(var_11_2)
	end

	arg_11_4.locomotion_extension:set_wanted_rotation(arg_11_4.attack_rotation:unbox())
end

local var_0_1 = {
	mode = "retained",
	name = "BTStormVerminAttackAction"
}

function BTStormVerminAttackAction.anim_cb_damage(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2.action

	arg_12_2.past_damage_in_attack = true

	local var_12_1 = Unit.world(arg_12_1)
	local var_12_2 = World.get_data(var_12_1, "physics_world")
	local var_12_3 = var_12_0.range
	local var_12_4 = var_12_0.height
	local var_12_5 = var_12_0.width
	local var_12_6 = var_12_0.offset_up
	local var_12_7 = var_12_0.offset_forward
	local var_12_8 = var_12_3 * 0.5
	local var_12_9 = var_12_4 * 0.5
	local var_12_10 = Vector3(var_12_5 * 0.5, var_12_8, var_12_9)
	local var_12_11 = Unit.local_position(arg_12_1, 0)
	local var_12_12 = Unit.local_rotation(arg_12_1, 0)
	local var_12_13 = Quaternion.rotate(var_12_12, Vector3.forward()) * (var_12_7 + var_12_8)
	local var_12_14 = Vector3.up() * (var_12_9 + var_12_6)
	local var_12_15 = var_12_11 + var_12_13 + var_12_14
	local var_12_16, var_12_17 = PhysicsWorld.immediate_overlap(var_12_2, "position", var_12_15, "rotation", var_12_12, "size", var_12_10, "shape", "oobb", "types", "dynamics", "collision_filter", "filter_player_hit_box_check")

	if Development.parameter("debug_weapons") then
		local var_12_18 = Managers.state.debug:drawer(var_0_1)

		var_12_18:reset()

		local var_12_19 = Matrix4x4.from_quaternion_position(var_12_12, var_12_15)

		var_12_18:box(var_12_19, var_12_10)
	end

	local var_12_20 = FrameTable.alloc_table()

	if arg_12_2.moving_attack then
		arg_12_2.navigation_extension:set_enabled(false)
		arg_12_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
	else
		local var_12_21 = Managers.time:time("game")
	end

	for iter_12_0, iter_12_1 in ipairs(var_12_16) do
		var_12_20[Actor.unit(iter_12_1)] = true
	end

	for iter_12_2, iter_12_3 in pairs(var_12_20) do
		if not Unit.alive(iter_12_2) then
			return
		end

		local var_12_22 = var_12_0.attack_directions and var_12_0.attack_directions[arg_12_2.attack_anim]
		local var_12_23 = DamageUtils.check_block(arg_12_1, iter_12_2, var_12_0.fatigue_type, var_12_22)

		if var_12_0.damage then
			if not var_12_23 then
				AiUtils.damage_target(iter_12_2, arg_12_1, var_12_0, var_12_0.damage)
			elseif var_12_23 and var_12_0.blocked_damage then
				AiUtils.damage_target(iter_12_2, arg_12_1, var_12_0, var_12_0.blocked_damage)
			end

			if DamageUtils.is_player_unit(iter_12_2) and var_12_23 and var_12_0.fatigue_type == "complete" then
				SurroundingAwareSystem.add_event(iter_12_2, "breaking_hit", DialogueSettings.grabbed_broadcast_range, "profile_name", ScriptUnit.extension(iter_12_2, "dialogue_system").context.player_profile)
			end
		end

		if var_12_0.catapult then
			BTStormVerminAttackAction.tag_catapult_enemy(arg_12_1, arg_12_2, var_12_0, iter_12_2, var_12_23)
		end

		if var_12_0.push then
			local var_12_24 = POSITION_LOOKUP[arg_12_1]
			local var_12_25 = POSITION_LOOKUP[iter_12_2]
			local var_12_26 = Vector3.normalize(var_12_25 - var_12_24)
			local var_12_27 = DamageUtils.is_player_unit(iter_12_2)
			local var_12_28 = var_12_0.player_push_speed

			if var_12_27 and var_12_28 and not ScriptUnit.extension(iter_12_2, "status_system").knocked_down then
				ScriptUnit.extension(iter_12_2, "locomotion_system"):add_external_velocity(var_12_28 * var_12_26, var_12_0.max_player_push_speed)
			end
		end
	end

	if arg_12_2.attacking_target_is_ai_breed then
		AiUtils.damage_target(arg_12_2.attacking_target, arg_12_1, var_12_0, var_12_0.damage)
	end
end

function BTStormVerminAttackAction.anim_cb_attack_finished(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2.attack_finished = true
end

function BTStormVerminAttackAction._calculate_cylinder_collision(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_1.radius
	local var_14_1 = arg_14_1.height
	local var_14_2 = arg_14_1.offset_up
	local var_14_3 = arg_14_1.offset_forward
	local var_14_4 = arg_14_1.offset_right
	local var_14_5 = var_14_1 * 0.5
	local var_14_6 = Vector3(var_14_0, var_14_5, var_14_0)
	local var_14_7 = Quaternion.forward(arg_14_3)
	local var_14_8 = Quaternion.up(arg_14_3)
	local var_14_9 = Quaternion.right(arg_14_3)
	local var_14_10 = arg_14_2 + var_14_7 * (var_14_0 + var_14_3) + var_14_8 * (var_14_5 + var_14_2) + var_14_9 * var_14_4
	local var_14_11 = Quaternion.look(var_14_8, Vector3.up())

	return var_14_10, var_14_6, var_14_11
end

function BTStormVerminAttackAction._calculate_oobb_collision(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_1.range
	local var_15_1 = arg_15_1.height
	local var_15_2 = arg_15_1.width
	local var_15_3 = arg_15_1.offset_up
	local var_15_4 = arg_15_1.offset_forward
	local var_15_5 = var_15_0 * 0.5
	local var_15_6 = var_15_1 * 0.5
	local var_15_7 = Vector3(var_15_2 * 0.5, var_15_5, var_15_6)
	local var_15_8 = Quaternion.rotate(arg_15_3, Vector3.forward()) * (var_15_4 + var_15_5)
	local var_15_9 = Vector3.up() * (var_15_6 + var_15_3)

	return arg_15_2 + var_15_8 + var_15_9, arg_15_3, var_15_7
end

function BTStormVerminAttackAction.tag_catapult_enemy(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	arg_16_1.catapult_list = arg_16_1.catapult_list or {}
	arg_16_1.catapult_list[arg_16_3] = arg_16_4
	arg_16_1.catapult_hit = true
end

function BTStormVerminAttackAction.catapult_enemies(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.catapult_list

	if var_17_0 then
		local var_17_1 = BTStormVerminAttackAction.catapult_enemy
		local var_17_2 = arg_17_1.action

		for iter_17_0, iter_17_1 in pairs(var_17_0) do
			if Unit.alive(iter_17_0) then
				var_17_1(arg_17_0, arg_17_1, var_17_2, iter_17_0, iter_17_1)
			end

			var_17_0[iter_17_0] = nil
		end
	end

	arg_17_1.catapult_hit = false
end

function BTStormVerminAttackAction.catapult_enemy(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	if not arg_18_2.catapult then
		return
	end

	if arg_18_4 then
		-- block empty
	else
		AiUtils.damage_target(arg_18_3, arg_18_0, arg_18_2, arg_18_2.damage)
	end

	if not ScriptUnit.extension(arg_18_3, "status_system").knocked_down then
		local var_18_0 = POSITION_LOOKUP[arg_18_0]
		local var_18_1 = POSITION_LOOKUP[arg_18_3]
		local var_18_2 = Vector3.normalize(var_18_1 - var_18_0) * arg_18_2.shove_speed

		Vector3.set_z(var_18_2, arg_18_2.shove_z_speed)
		StatusUtils.set_catapulted_network(arg_18_3, true, var_18_2)
	end
end
