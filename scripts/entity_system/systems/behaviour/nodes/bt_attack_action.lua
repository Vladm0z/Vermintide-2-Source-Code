-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTAttackAction = class(BTAttackAction, BTNode)

BTAttackAction.init = function (arg_1_0, ...)
	BTAttackAction.super.init(arg_1_0, ...)
end

BTAttackAction.name = "BTAttackAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

local var_0_1 = 1.5
local var_0_2 = {}

BTAttackAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTAttackAction
	arg_3_2.attack_aborted = false
	arg_3_2.attack_finished = false
	arg_3_2.attack_finished_t = nil
	arg_3_2.attack_token = true
	arg_3_2.locked_attack_rotation = false
	arg_3_2.moving_attack = var_3_0.moving_attack
	arg_3_2.past_damage_in_attack = false
	arg_3_2.target_speed = 0

	local var_3_1 = arg_3_2.target_unit
	local var_3_2 = ScriptUnit.has_extension(var_3_1, "status_system")
	local var_3_3 = ScriptUnit.has_extension(var_3_1, "ai_slot_system")
	local var_3_4 = arg_3_0:_select_attack(var_3_0, arg_3_1, var_3_1, arg_3_2, var_3_2)

	arg_3_2.attack_anim = var_0_0(var_3_4.anims)

	if var_3_0.blocked_anim then
		arg_3_2.blocked_anim = var_3_0.blocked_anim
	end

	local var_3_5 = var_3_4.damage_box_range

	if var_3_5 then
		arg_3_2.attack_range_up = var_3_5.up
		arg_3_2.attack_range_down = var_3_5.down
		arg_3_2.attack_range_flat = var_3_5.flat
	end

	if arg_3_2.attack_token and var_3_2 then
		local var_3_6 = arg_3_2.breed

		if var_3_6.use_backstab_vo and var_3_3 and var_3_3.num_occupied_slots <= 5 then
			local var_3_7 = Managers.player:unit_owner(var_3_1)

			if var_3_7 and not var_3_7.bot_player then
				local var_3_8 = AiUtils.unit_is_flanking_player(arg_3_1, var_3_1)

				if var_3_8 then
					arg_3_2.backstab_attack_trigger = true
				end

				if var_3_7.local_player then
					if var_3_8 then
						local var_3_9 = ScriptUnit.extension(arg_3_1, "dialogue_system")
						local var_3_10, var_3_11 = WwiseUtils.make_unit_auto_source(arg_3_2.world, arg_3_1, var_3_9.voice_node)
						local var_3_12 = var_3_6.backstab_player_sound_event

						Managers.state.entity:system("audio_system"):_play_event_with_source(var_3_11, var_3_12, var_3_10)
					end
				else
					local var_3_13 = Managers.state.network
					local var_3_14 = var_3_13.network_transmit
					local var_3_15 = var_3_13:unit_game_object_id(arg_3_1)
					local var_3_16 = var_3_7:network_id()

					var_3_14:send_rpc("rpc_check_trigger_backstab_sfx", var_3_16, var_3_15)
				end
			end
		end
	end

	arg_3_2.target_unit_status_extension = var_3_2
	arg_3_2.attack_setup_delayed = true
	arg_3_2.attacking_target = var_3_1
	arg_3_2.spawn_to_running = nil

	local var_3_17 = LocomotionUtils.rotation_towards_unit_flat(arg_3_1, var_3_1)

	arg_3_2.attack_rotation = QuaternionBox(var_3_17)
	arg_3_2.attack_rotation_lock_timer = arg_3_3

	local var_3_18 = var_3_0.dodge_window_start
	local var_3_19 = var_3_0.dodge_window_duration or var_0_2
	local var_3_20 = Managers.state.difficulty:get_difficulty()

	if var_3_18 and type(var_3_18) == "table" then
		var_3_18 = var_3_18[var_3_20]
	end

	arg_3_2.attack_dodge_window_start = var_3_18 and var_3_18 + arg_3_3 or arg_3_3
	arg_3_2.attack_dodge_window_duration = var_3_19[var_3_20] or var_0_1

	if var_3_0.attack_finished_duration then
		local var_3_21 = var_3_0.attack_finished_duration[var_3_20]

		if var_3_21 then
			arg_3_2.attack_finished_t = arg_3_3 + Math.random_range(var_3_21[1], var_3_21[2])
		end
	end

	AiUtils.add_attack_intensity(var_3_1, var_3_0, arg_3_2)

	if arg_3_2.moving_attack and ScriptUnit.has_extension(arg_3_1, "ai_slot_system") then
		Managers.state.entity:system("ai_slot_system"):set_release_slot_lock(arg_3_1, true)

		arg_3_2.keep_target = true
	end

	local var_3_22 = ScriptUnit.has_extension(var_3_1, "attack_intensity_system")

	if var_3_22 then
		arg_3_2.target_unit_attack_intensity_extension = var_3_22
	end
end

BTAttackAction._select_attack = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = Unit.get_data(arg_4_3, "target_type")
	local var_4_1 = var_4_0 and arg_4_1.target_type_exceptions and arg_4_1.target_type_exceptions[var_4_0]

	if var_4_1 then
		return var_4_1
	else
		local var_4_2 = POSITION_LOOKUP[arg_4_2]
		local var_4_3 = POSITION_LOOKUP[arg_4_3] or Unit.world_position(arg_4_2, 0)
		local var_4_4 = var_4_3.z - var_4_2.z
		local var_4_5 = Vector3.distance(Vector3.flat(var_4_2), Vector3.flat(var_4_3))
		local var_4_6 = arg_4_1.default_attack
		local var_4_7 = arg_4_1.high_attack
		local var_4_8 = arg_4_1.mid_attack
		local var_4_9 = arg_4_1.low_attack
		local var_4_10 = arg_4_1.step_attack
		local var_4_11 = arg_4_1.step_attack_with_callback
		local var_4_12 = arg_4_1.knocked_down_attack

		if var_4_7 and var_4_4 > var_4_7.z_threshold then
			return var_4_7
		elseif var_4_8 and var_4_4 < var_4_8.z_threshold and var_4_5 > var_4_8.flat_threshold then
			return var_4_8
		elseif var_4_9 and var_4_4 < var_4_9.z_threshold then
			return var_4_9
		elseif var_4_12 and var_4_4 < var_4_12.z_threshold and arg_4_5 and arg_4_5:is_knocked_down() then
			return var_4_12
		elseif var_4_11 and (arg_4_4.target_speed_away > (var_4_11.step_speed_moving or 1) and var_4_5 > (var_4_11.step_distance_moving or 1.5) or var_4_5 > (var_4_11.step_distance_stationary or 2.5)) then
			arg_4_4.moving_attack_with_callback = true

			if var_4_11.attack_hit_animation then
				arg_4_4.attack_hit_animation = var_4_11.attack_hit_animation
			end

			return var_4_11
		elseif var_4_10 and (arg_4_4.target_speed_away > (var_4_10.step_speed_moving or 1) and var_4_5 > (var_4_10.step_distance_moving or 1.5) or var_4_5 > (var_4_10.step_distance_stationary or 2.5)) then
			arg_4_4.moving_attack = var_4_10.moving_attack

			return var_4_10
		else
			return var_4_6
		end
	end
end

BTAttackAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = AiUtils.get_default_breed_move_speed(arg_5_1, arg_5_2)
	local var_5_1 = arg_5_2.navigation_extension

	var_5_1:set_enabled(true)
	var_5_1:set_max_speed(var_5_0)

	if arg_5_2.move_state ~= "idle" and HEALTH_ALIVE[arg_5_1] then
		arg_5_2.move_state = "idle"
	end

	if arg_5_2.moving_attack and ScriptUnit.has_extension(arg_5_1, "ai_slot_system") then
		Managers.state.entity:system("ai_slot_system"):set_release_slot_lock(arg_5_1, false)

		arg_5_2.keep_target = nil
	end

	if ScriptUnit.has_extension(arg_5_1, "ai_shield_system") then
		ScriptUnit.extension(arg_5_1, "ai_shield_system"):set_is_blocking(true)
	end

	arg_5_0:clear_blackboard(arg_5_1, arg_5_2, arg_5_3)
end

BTAttackAction.clear_blackboard = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_2.action.use_box_range then
		arg_6_2.attack_range_up = nil
		arg_6_2.attack_range_down = nil
		arg_6_2.attack_range_flat = nil
	end

	arg_6_2.action = nil
	arg_6_2.active_node = nil
	arg_6_2.anim_cb_attack_cooldown = nil
	arg_6_2.anim_cb_damage = nil
	arg_6_2.anim_cb_running_attack_end = nil
	arg_6_2.anim_cb_running_attack_start = nil
	arg_6_2.anim_cb_stagger_immune = nil
	arg_6_2.attack_aborted = nil
	arg_6_2.attack_anim = nil
	arg_6_2.attack_dodge_window_start = nil
	arg_6_2.attack_dodge_window_duration = nil
	arg_6_2.attack_finished = nil
	arg_6_2.attack_finished_duration = nil
	arg_6_2.attack_finished_t = nil
	arg_6_2.attack_hit_animation = nil
	arg_6_2.attack_rotation = nil
	arg_6_2.attack_rotation_lock_timer = nil
	arg_6_2.attack_token = nil
	arg_6_2.attacking_target = nil
	arg_6_2.backstab_attack_trigger = nil
	arg_6_2.locked_attack_rotation = nil
	arg_6_2.moving_attack = nil
	arg_6_2.moving_attack_with_callback = nil
	arg_6_2.past_damage_in_attack = nil
	arg_6_2.target_speed = 0
	arg_6_2.target_unit_attack_intensity_extension = nil
	arg_6_2.target_unit_status_extension = nil
end

BTAttackAction.run = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if not Unit.alive(arg_7_2.attacking_target) then
		return "done"
	end

	if arg_7_2.attack_aborted then
		return "done"
	end

	if arg_7_2.anim_cb_damage then
		arg_7_2.anim_cb_damage = nil
		arg_7_2.past_damage_in_attack = true

		if arg_7_2.moving_attack then
			arg_7_2.navigation_extension:set_enabled(false)
			arg_7_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
		end

		if ScriptUnit.has_extension(arg_7_1, "ai_shield_system") then
			ScriptUnit.extension(arg_7_1, "ai_shield_system"):set_is_blocking(false)
		end
	end

	if arg_7_2.anim_cb_attack_cooldown and arg_7_2.attack_finished_t and arg_7_3 > arg_7_2.attack_finished_t or not arg_7_2.attack_finished_t and arg_7_2.attack_finished then
		return "done"
	end

	if arg_7_2.moving_attack then
		local var_7_0 = arg_7_2.breed
		local var_7_1 = arg_7_2.destination_dist
		local var_7_2 = arg_7_2.target_speed_away_small_sample
		local var_7_3 = var_7_0.run_speed

		if var_7_1 > 0.5 then
			if arg_7_2.locked_attack_rotation then
				var_7_2 = var_7_3 * 0.85
			else
				var_7_2 = var_7_3 * 1.1
			end
		elseif arg_7_2.locked_attack_rotation then
			var_7_2 = var_7_3 * 0.65
		else
			var_7_2 = var_7_2 * 1.2
		end

		if math.abs(var_7_2 - arg_7_2.target_speed) > 0.25 then
			arg_7_2.target_speed = var_7_2

			arg_7_2.navigation_extension:set_max_speed(math.clamp(var_7_2, 0, var_7_3))
		end
	end

	if arg_7_2.attack_setup_delayed then
		if not arg_7_2.moving_attack then
			arg_7_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
			arg_7_2.navigation_extension:set_enabled(false)
		end

		arg_7_2.attack_setup_delayed = false
	end

	if arg_7_2.moving_attack_with_callback then
		if arg_7_2.anim_cb_running_attack_start then
			arg_7_2.navigation_extension:set_enabled(true)

			arg_7_2.anim_cb_running_attack_start = nil
		elseif arg_7_2.anim_cb_running_attack_end then
			arg_7_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
			arg_7_2.navigation_extension:set_enabled(false)

			arg_7_2.anim_cb_running_attack_end = nil
		end
	end

	arg_7_0:_attack(arg_7_1, arg_7_3, arg_7_4, arg_7_2)
	arg_7_0:_handle_movement(arg_7_1, arg_7_3, arg_7_4, arg_7_2)

	return "running"
end

BTAttackAction.attack_cooldown = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = Managers.time:time("game")

	arg_8_2.is_in_attack_cooldown, arg_8_2.attack_cooldown_at = arg_8_0:_get_attack_cooldown_finished_at(arg_8_1, arg_8_2, var_8_0)
end

BTAttackAction.attack_success = function (arg_9_0, arg_9_1, arg_9_2)
	if arg_9_2.breed.use_backstab_vo and arg_9_2.backstab_attack_trigger then
		Managers.state.entity:system("dialogue_system"):trigger_backstab_hit(arg_9_2.target_unit, arg_9_1)

		arg_9_2.backstab_attack_trigger = false
	end

	if arg_9_2.attack_hit_animation then
		Managers.state.network:anim_event(arg_9_1, arg_9_2.attack_hit_animation)
		arg_9_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
		arg_9_2.navigation_extension:set_enabled(false)
	end
end

BTAttackAction.attack_blocked = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_2.action
	local var_10_1 = arg_10_2.attacking_target
	local var_10_2 = var_10_0.player_push_speed_blocked

	if var_10_2 then
		local var_10_3 = ScriptUnit.has_extension(var_10_1, "status_system")

		if var_10_3 and not var_10_3:is_disabled() then
			local var_10_4 = POSITION_LOOKUP[arg_10_1] or Unit.world_position(arg_10_1, 0)
			local var_10_5 = POSITION_LOOKUP[var_10_1] or Unit.local_position(var_10_1, 0)
			local var_10_6 = Vector3.normalize(var_10_5 - var_10_4)
			local var_10_7 = ScriptUnit.has_extension(var_10_1, "locomotion_system")

			if var_10_7 then
				var_10_7:add_external_velocity(var_10_2 * var_10_6, var_10_0.max_player_push_speed)
			end
		end
	end
end

BTAttackAction._attack = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_4

	if var_11_0.move_state ~= "attacking" then
		var_11_0.move_state = "attacking"

		Managers.state.network:anim_event(arg_11_1, var_11_0.attack_anim)
	end
end

local var_0_3 = 4

BTAttackAction._handle_movement = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_4
	local var_12_1 = arg_12_4.target_dist

	if var_12_0.attack_dodge_window_start and arg_12_2 > var_12_0.attack_dodge_window_start and not var_12_0.past_damage_in_attack then
		local var_12_2 = var_12_0.target_unit_status_extension

		if var_12_2 then
			local var_12_3 = var_12_2:get_is_dodging() or var_12_2:is_invisible()
			local var_12_4 = not var_12_3 and arg_12_2 > var_12_0.attack_rotation_lock_timer
			local var_12_5 = var_12_3 and not var_12_0.locked_attack_rotation and var_12_1 < var_0_3

			if var_12_4 then
				local var_12_6 = LocomotionUtils.rotation_towards_unit_flat(arg_12_1, var_12_0.attacking_target)

				var_12_0.attack_rotation:store(var_12_6)

				if var_12_0.locked_attack_rotation then
					var_12_0.locked_attack_rotation = false
				end
			elseif var_12_5 then
				var_12_0.attack_rotation_lock_timer = arg_12_2 + arg_12_4.attack_dodge_window_duration
				var_12_0.locked_attack_rotation = true
			end
		end

		var_12_0.locomotion_extension:set_wanted_rotation(arg_12_4.attack_rotation:unbox())
	else
		var_12_0.locomotion_extension:set_wanted_rotation(arg_12_4.attack_rotation:unbox())
	end

	if var_12_0.locked_attack_rotation and var_12_0.attack_rotation_lock_timer and arg_12_2 > var_12_0.attack_rotation_lock_timer or var_12_1 > var_0_3 then
		var_12_0.locked_attack_rotation = false
	end
end

BTAttackAction._get_attack_cooldown_finished_at = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_2.attacking_target

	if not Unit.alive(var_13_0) then
		return false, 0
	end

	local var_13_1 = arg_13_2.action.diminishing_damage

	if not var_13_1 then
		return false, 0
	end

	local var_13_2 = ScriptUnit.has_extension(var_13_0, "ai_slot_system")

	if not var_13_2 or not var_13_2.has_slots_attached then
		return false, 0
	end

	local var_13_3 = var_13_2.num_occupied_slots

	if var_13_3 == 0 then
		return false, 0
	end

	local var_13_4 = var_13_1[math.min(var_13_3, 9)]

	if not var_13_4 then
		local var_13_5 = arg_13_2.action
		local var_13_6 = Managers.state.difficulty:get_difficulty()

		if var_13_5.diminishing_damage and var_13_5.difficulty_diminishing_damage then
			var_13_4 = var_13_5.difficulty_diminishing_damage[var_13_6][math.min(var_13_3, 9)]
		end
	end

	local var_13_7 = var_13_4.cooldown
	local var_13_8 = AiUtils.random(var_13_7[1], var_13_7[2])

	return true, var_13_8 + arg_13_3
end

BTAttackAction.anim_cb_attack_vce = function (arg_14_0, arg_14_1, arg_14_2)
	if Managers.state.network:game() and arg_14_2.target_unit_status_extension then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_14_2, arg_14_2.target_unit, arg_14_1, false, false)
	end
end

BTAttackAction.anim_cb_attack_vce_long = function (arg_15_0, arg_15_1, arg_15_2)
	if Managers.state.network:game() and arg_15_2.target_unit_status_extension then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_15_2, arg_15_2.target_unit, arg_15_1, false, true)
	end
end

BTAttackAction.anim_cb_running_attack_start = function (arg_16_0, arg_16_1, arg_16_2)
	if Managers.state.network:game() then
		arg_16_2.anim_cb_running_attack_start = true
	end
end

BTAttackAction.anim_cb_attack_finished = function (arg_17_0, arg_17_1, arg_17_2)
	if arg_17_2.attack_finished then
		return
	end

	if Managers.state.network:game() then
		arg_17_2.attacks_done = arg_17_2.attacks_done + 1
		arg_17_2.attack_finished = true
	end
end
