-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_bulwark_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBulwarkFollowAction = class(BTBulwarkFollowAction, BTNode)

local var_0_0 = 36
local var_0_1 = 16
local var_0_2 = 0.01
local var_0_3 = 3
local var_0_4 = 2
local var_0_5 = 10
local var_0_6 = 2
local var_0_7 = 1
local var_0_8 = 0.05
local var_0_9 = POSITION_LOOKUP
local var_0_10 = 7
local var_0_11 = 30
local var_0_12 = 3

BTBulwarkFollowAction.init = function (arg_1_0, ...)
	BTBulwarkFollowAction.super.init(arg_1_0, ...)

	arg_1_0.next_time_to_trigger_running_dialogue = 0
	arg_1_0.triggered_units = {}
end

BTBulwarkFollowAction.name = "BTBulwarkFollowAction"

local var_0_13 = 0.0001

BTBulwarkFollowAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.active_node = arg_2_0
	arg_2_2.time_to_next_evaluate = arg_2_3 + 0.5

	if arg_2_2.sneaky then
		arg_2_2.time_to_next_friend_alert = arg_2_3 + 99999
	else
		arg_2_2.time_to_next_friend_alert = arg_2_3 + 0.3
	end

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_2_1, true)

	local var_2_1 = arg_2_2.target_unit
	local var_2_2 = arg_2_2.locomotion_extension
	local var_2_3 = LocomotionUtils.rotation_towards_unit_flat(arg_2_1, var_2_1)

	var_2_2:set_wanted_rotation(var_2_3)

	local var_2_4 = var_0_9[arg_2_1]
	local var_2_5 = arg_2_2.breed
	local var_2_6 = var_2_5.enter_walk_distance and var_2_5.enter_walk_distance^2 or var_0_1
	local var_2_7 = arg_2_2.navigation_extension:destination()

	if arg_2_0:_should_walk(var_2_7, var_2_4, var_2_6, var_2_3, arg_2_2) then
		arg_2_2.walking = true
		arg_2_2.walk_timer = arg_2_3 + (var_2_0.walk_time or 3 + 1 * Math.random())
	end

	if var_2_0.skip_start_anim_if_moving and arg_2_2.move_state == "moving" then
		arg_2_2.skip_start_anim = true
	end

	arg_2_2.lerp_into_follow_t = arg_2_2.lerp_into_follow and arg_2_3
	arg_2_2.lerp_into_follow = nil
end

BTBulwarkFollowAction._should_walk = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_5.is_charging then
		return false
	end

	local var_3_0 = arg_3_1 - arg_3_2
	local var_3_1 = Vector3.dot(Quaternion.forward(arg_3_4), var_3_0)
	local var_3_2 = Vector3.dot(Quaternion.right(arg_3_4), var_3_0)
	local var_3_3 = var_3_1 * var_3_1 + var_3_2 * var_0_2 * (var_3_2 * var_0_2)

	arg_3_5.is_charging = not (var_3_3 < arg_3_3)

	return var_3_3 < arg_3_3
end

BTBulwarkFollowAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.active_node = nil
	arg_4_2.is_charging = nil

	if not arg_4_2.locomotion_extension._engine_extension_id then
		return
	end

	if Managers.state.network:in_game_session() then
		arg_4_0:set_start_move_animation_lock(arg_4_1, arg_4_2, false)
	end

	if arg_4_2.is_turning then
		LocomotionUtils.reset_turning(arg_4_1, arg_4_2)

		arg_4_2.is_turning = nil
	end

	arg_4_2.start_anim_locked = nil
	arg_4_2.anim_cb_rotation_start = nil
	arg_4_2.anim_cb_move = nil
	arg_4_2.start_anim_done = nil
	arg_4_2.anim_lock_fallback_time = nil
	arg_4_2.deacceleration_factor = nil
	arg_4_2.walking = nil
	arg_4_2.walking_direction = nil
	arg_4_2.skip_start_anim = nil
	arg_4_2.lerp_into_follow_t = nil

	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(var_4_0)

	arg_4_0.triggered_units[arg_4_1] = nil
end

local var_0_14 = Unit.alive

BTBulwarkFollowAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not var_0_14(arg_5_2.target_unit) then
		return "done"
	end

	if arg_5_2.spawn_to_running or arg_5_2.skip_start_anim then
		arg_5_2.spawn_to_running = nil
		arg_5_2.start_anim_done = true
		arg_5_2.move_state = "moving"
		arg_5_2.start_anim_locked = nil
		arg_5_2.skip_start_anim = nil

		arg_5_0:set_start_move_animation_lock(arg_5_1, arg_5_2, false)
	end

	if arg_5_2.walking then
		arg_5_0:_update_walking(arg_5_1, arg_5_2, arg_5_4, arg_5_3)
	end

	if not arg_5_2.walking and not arg_5_2.start_anim_done then
		if not arg_5_2.start_anim_locked then
			arg_5_0:start_move_animation(arg_5_1, arg_5_2)

			arg_5_2.anim_lock_fallback_time = arg_5_3 + 2.5
		end

		if arg_5_2.anim_cb_rotation_start then
			arg_5_0:start_move_rotation(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		end

		if arg_5_2.anim_cb_move or arg_5_2.anim_lock_fallback_time and arg_5_3 >= arg_5_2.anim_lock_fallback_time then
			arg_5_2.anim_cb_move = false
			arg_5_2.move_state = "moving"
			arg_5_2.anim_lock_fallback_time = nil

			arg_5_0:set_start_move_animation_lock(arg_5_1, arg_5_2, false)

			arg_5_2.start_anim_locked = nil
			arg_5_2.start_anim_done = true
		end
	else
		arg_5_0:follow(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		arg_5_0:do_dialogue(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	end

	local var_5_0
	local var_5_1 = arg_5_2.navigation_extension

	if arg_5_3 > arg_5_2.time_to_next_evaluate or var_5_1:has_reached_destination() then
		local var_5_2 = arg_5_2.have_slot == 1 and arg_5_2.attacks_done == 0

		var_5_0 = "evaluate"
		arg_5_2.time_to_next_evaluate = var_5_2 and arg_5_3 + 0.1 or arg_5_3 + 0.5
	end

	local var_5_3 = arg_5_2.breed
	local var_5_4 = arg_5_2.lerp_into_follow_t
	local var_5_5 = var_5_3.lerp_alerted_into_follow_speed

	if arg_5_2.is_charging and var_5_4 and arg_5_3 < var_5_4 + var_5_5 then
		local var_5_6 = var_5_3.run_speed - var_5_3.walk_speed
		local var_5_7 = var_5_3.walk_speed + var_5_6 * math.inv_lerp(var_5_4, var_5_4 + var_5_5, arg_5_3)

		var_5_1:set_max_speed(var_5_7)
	end

	return "running", var_5_0
end

BTBulwarkFollowAction._update_walking = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_2.target_unit
	local var_6_1 = arg_6_2.locomotion_extension
	local var_6_2 = LocomotionUtils.rotation_towards_unit_flat(arg_6_1, var_6_0)

	var_6_1:set_wanted_rotation(var_6_2)

	local var_6_3 = arg_6_2.action
	local var_6_4 = var_0_9[arg_6_1]
	local var_6_5 = ScriptUnit.has_extension(var_6_0, "locomotion_system")
	local var_6_6 = var_6_5 and var_6_5.average_velocity and Vector3.dot(var_6_5:average_velocity(), Vector3.normalize(var_0_9[var_6_0] - var_6_4))
	local var_6_7 = arg_6_2.navigation_extension:destination()
	local var_6_8 = arg_6_4 > arg_6_2.walk_timer
	local var_6_9 = arg_6_2.breed.leave_walk_distance
	local var_6_10 = var_6_9 and var_6_9 * var_6_9 or var_0_0
	local var_6_11 = arg_6_0:_should_walk(var_6_7, var_6_4, var_6_10, var_6_2, arg_6_2)
	local var_6_12 = not var_6_11
	local var_6_13 = var_6_6 and var_6_6 > var_0_3 and not var_6_3.ignore_target_velocity

	if not var_6_11 and var_6_8 or var_6_12 or var_6_13 then
		arg_6_2.walking = false
		arg_6_2.walking_direction = nil

		Managers.state.network:anim_event(arg_6_1, "move_start_fwd")

		return
	end

	local var_6_14 = var_6_3.walk_anims
	local var_6_15 = arg_6_2.navigation_extension:desired_velocity()
	local var_6_16 = arg_6_0:_calculate_walk_dir(Quaternion.right(var_6_2), Quaternion.forward(var_6_2), var_6_15, var_6_4, var_6_14)

	if var_6_16 ~= arg_6_2.walking_direction then
		local var_6_17 = arg_6_0:_calculate_walk_animation(var_6_16, var_6_14)

		if arg_6_2.action.alt_walk_anim then
			Managers.state.network:anim_event(arg_6_1, arg_6_2.action.alt_walk_anim)
		else
			Managers.state.network:anim_event(arg_6_1, var_6_17)
		end

		arg_6_2.move_state = "moving"
		arg_6_2.walking_direction = var_6_16
	end
end

local function var_0_15(arg_7_0)
	if type(arg_7_0) == "table" then
		return arg_7_0[Math.random(1, #arg_7_0)]
	else
		return arg_7_0
	end
end

BTBulwarkFollowAction._calculate_walk_animation = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0

	if arg_8_1 == "right" then
		var_8_0 = "move_right_walk"
	elseif arg_8_1 == "left" then
		var_8_0 = "move_left_walk"
	elseif arg_8_1 == "forward" then
		var_8_0 = arg_8_2 and var_0_15(arg_8_2) or "move_fwd_walk"
	else
		var_8_0 = "move_bwd_walk"
	end

	return var_8_0
end

BTBulwarkFollowAction._calculate_walk_dir = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	local var_9_0 = Vector3.dot(arg_9_1, arg_9_3)
	local var_9_1 = Vector3.dot(arg_9_2, arg_9_3)
	local var_9_2 = math.abs(var_9_0)
	local var_9_3 = math.abs(var_9_1)

	arg_9_3 = var_9_3 < var_9_2 and var_9_0 > 0 and "right" or var_9_3 < var_9_2 and "left" or var_9_1 > 0 and "forward" or "backward"

	return arg_9_3
end

BTBulwarkFollowAction.follow = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2.breed
	local var_10_1 = arg_10_2.target_unit
	local var_10_2 = arg_10_2.target_dist
	local var_10_3 = var_10_0.follow_reach or var_10_0.weapon_reach or 2
	local var_10_4 = ScriptUnit.has_extension(var_10_1, "locomotion_system")
	local var_10_5 = arg_10_2.locomotion_extension
	local var_10_6 = Vector3.length(var_10_5:current_velocity())

	if var_10_0.use_big_boy_turning and arg_10_2.move_state == "moving" then
		if arg_10_2.is_turning then
			LocomotionUtils.update_turning(arg_10_1, arg_10_3, arg_10_4, arg_10_2)
		else
			LocomotionUtils.check_start_turning(arg_10_1, arg_10_3, arg_10_4, arg_10_2)
		end
	end

	local var_10_7

	if arg_10_2.walking then
		arg_10_2.deacceleration_factor = nil
		var_10_7 = var_10_0.walk_speed
	elseif var_10_2 < (var_10_0.match_speed_distance or 2 * var_10_3) then
		arg_10_2.deacceleration_factor = nil

		local var_10_8 = math.max((var_10_2 - var_10_3) / var_10_3, 0) * 0.4
		local var_10_9 = var_10_4 and var_10_4.average_velocity and var_10_4:average_velocity() or Vector3.zero()
		local var_10_10 = Vector3.length(var_10_9) or 0
		local var_10_11 = var_10_10 > var_10_0.walk_speed and var_10_10 or var_10_0.walk_speed

		var_10_7 = math.lerp(var_10_11, var_10_0.run_speed, var_10_8)
	elseif (var_10_6 > var_10_0.run_speed + 0.1 or arg_10_2.deacceleration_factor) and var_10_2 < 2 * var_10_3 + var_0_7 then
		local var_10_12 = var_10_2 - var_10_3

		if not arg_10_2.deacceleration_factor then
			arg_10_2.deacceleration_factor = (var_10_6 - var_10_0.run_speed) / var_10_12
		end

		var_10_7 = arg_10_2.deacceleration_factor * var_10_12 + var_10_0.run_speed
	else
		arg_10_2.deacceleration_factor = nil

		local var_10_13 = arg_10_2.breed.run_speed_interpolation_factor or var_0_8
		local var_10_14 = arg_10_0:_calculate_run_speed(arg_10_1, var_10_1, arg_10_2, var_10_4)
		local var_10_15 = math.sign(var_10_14 - var_10_6)

		var_10_6 = var_10_15 > 0 and var_10_6 < var_10_0.run_speed and var_10_2 > (var_10_0.match_speed_distance or var_10_3) + 0.5 and var_10_0.run_speed or var_10_6
		var_10_7 = math.min(var_10_6 + var_10_15 * var_10_13 * arg_10_4, var_10_14)
	end

	local var_10_16 = arg_10_2.action

	if not arg_10_2.walking then
		local var_10_17 = var_10_0.enter_walk_distance and var_10_0.enter_walk_distance^2 or var_0_1
		local var_10_18 = arg_10_2.navigation_extension:destination()
		local var_10_19 = LocomotionUtils.rotation_towards_unit_flat(arg_10_1, arg_10_2.target_unit)
		local var_10_20 = var_0_9[arg_10_1]

		if arg_10_0:_should_walk(var_10_18, var_10_20, var_10_17, var_10_19, arg_10_2) then
			local var_10_21 = 0

			if not var_10_16.ignore_target_velocity then
				local var_10_22 = var_10_4 and var_10_4.average_velocity and var_10_4:average_velocity() or Vector3.zero()

				var_10_21 = Vector3.length(var_10_22) or 0
			end

			if var_10_21 < var_0_3 then
				arg_10_2.walking = true
				arg_10_2.walk_timer = arg_10_3 + 2.5
			end
		end
	end

	arg_10_2.navigation_extension:set_max_speed(var_10_7)

	if arg_10_3 > arg_10_2.time_to_next_friend_alert then
		arg_10_2.time_to_next_friend_alert = arg_10_3 + 0.5

		if var_10_2 > (var_10_0.min_alert_friends_distance or var_0_10) and var_10_2 < (var_10_0.max_alert_friends_distance or var_0_11) then
			local var_10_23 = World.get_data(arg_10_2.world, "physics_world")
			local var_10_24 = var_0_9[arg_10_1]
			local var_10_25 = var_0_9[var_10_1] - var_10_24
			local var_10_26 = var_10_24 + Vector3(0, 0, 1)

			if Vector3.length_squared(var_10_25) > 0 then
				local var_10_27, var_10_28, var_10_29, var_10_30 = PhysicsWorld.immediate_raycast(var_10_23, var_10_26, var_10_25, arg_10_2.target_dist, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

				if not var_10_27 then
					AiUtils.alert_nearby_friends_of_enemy(arg_10_1, arg_10_2.group_blackboard.broadphase, var_10_1, var_10_0.friends_alert_range or var_0_12)
				end
			end
		end
	end
end

BTBulwarkFollowAction._calculate_run_speed = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_3.target_dist
	local var_11_1 = arg_11_3.destination_dist
	local var_11_2 = 0

	if arg_11_4 and arg_11_4.average_velocity and var_11_1 > var_0_4 and var_11_0 < var_0_5 then
		local var_11_3 = var_0_9[arg_11_1]
		local var_11_4 = arg_11_3.navigation_extension:destination()
		local var_11_5 = arg_11_4:average_velocity()
		local var_11_6 = Vector3.normalize(var_11_4 - var_11_3)
		local var_11_7 = Vector3.normalize(var_11_5)
		local var_11_8 = Vector3.dot(var_11_7, var_11_6)

		var_11_2 = math.clamp(var_11_8, 0, 1)
	end

	return arg_11_3.breed.run_speed + var_0_6 * var_11_2
end

BTBulwarkFollowAction.start_move_animation = function (arg_12_0, arg_12_1, arg_12_2)
	arg_12_0:set_start_move_animation_lock(arg_12_1, arg_12_2, true)

	local var_12_0 = var_0_9[arg_12_2.target_unit]
	local var_12_1 = arg_12_2.action.start_anims_name
	local var_12_2 = AiAnimUtils.get_start_move_animation(arg_12_1, var_12_0, var_12_1)

	Managers.state.network:anim_event(arg_12_1, var_12_2)

	arg_12_2.move_animation_name = var_12_2
	arg_12_2.start_anim_locked = true
end

BTBulwarkFollowAction.start_move_rotation = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	if arg_13_2.move_animation_name == "move_start_fwd" or arg_13_2.move_animation_name == "move_start_fwd_jog" then
		arg_13_0:set_start_move_animation_lock(arg_13_1, arg_13_2, false)

		local var_13_0 = arg_13_2.locomotion_extension
		local var_13_1 = LocomotionUtils.rotation_towards_unit_flat(arg_13_1, arg_13_2.target_unit)

		var_13_0:set_wanted_rotation(var_13_1)
	else
		arg_13_2.anim_cb_rotation_start = false

		local var_13_2 = var_0_9[arg_13_2.target_unit]
		local var_13_3 = AiAnimUtils.get_animation_rotation_scale(arg_13_1, var_13_2, arg_13_2.move_animation_name, arg_13_2.action.start_anims_data)

		LocomotionUtils.set_animation_rotation_scale(arg_13_1, var_13_3)
	end
end

BTBulwarkFollowAction.set_start_move_animation_lock = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_2.locomotion_extension

	if arg_14_3 then
		var_14_0:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_14_1, true, false, false)
	else
		var_14_0:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_14_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_14_1, 1)
	end
end

local var_0_16 = {}

BTBulwarkFollowAction.do_dialogue = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if arg_15_3 > arg_15_0.next_time_to_trigger_running_dialogue and arg_15_0.triggered_units[arg_15_1] == nil then
		local var_15_0 = math.ceil(Vector3.distance(var_0_9[arg_15_1], var_0_9[arg_15_2.target_unit]))

		if var_15_0 < 15 then
			local var_15_1 = var_0_9[arg_15_1]
			local var_15_2 = AiUtils.broadphase_query(var_15_1, 10, var_0_16)

			arg_15_0.next_time_to_trigger_running_dialogue = arg_15_3 + 1
			arg_15_0.triggered_units[arg_15_1] = true

			local var_15_3 = ScriptUnit.extension_input(arg_15_1, "dialogue_system")
			local var_15_4 = FrameTable.alloc_table()

			var_15_4.distance = var_15_0
			var_15_4.num_units = var_15_2 - 1

			var_15_3:trigger_networked_dialogue_event("running", var_15_4)
		end
	end
end
