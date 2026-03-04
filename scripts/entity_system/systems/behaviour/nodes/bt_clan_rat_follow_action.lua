-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_clan_rat_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTClanRatFollowAction = class(BTClanRatFollowAction, BTNode)

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

BTClanRatFollowAction.init = function (arg_1_0, ...)
	BTClanRatFollowAction.super.init(arg_1_0, ...)

	arg_1_0.next_time_to_trigger_running_dialogue = 0
	arg_1_0.triggered_units = {}
end

BTClanRatFollowAction.name = "BTClanRatFollowAction"

local var_0_13 = 0.0001

BTClanRatFollowAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
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
	local var_2_8 = arg_2_0:_should_walk(var_2_7, var_2_4, var_2_6, var_2_3)
	local var_2_9 = arg_2_0:_slow_approach(var_2_7, var_2_4, var_2_0, var_2_3)

	if var_2_8 or var_2_9 then
		arg_2_2.walking = true

		if var_2_9 then
			arg_2_2.walk_timer = arg_2_3 + var_2_0.slow_approach_time
		else
			arg_2_2.walk_timer = arg_2_3 + (var_2_0.walk_time or 3 + 1 * Math.random())
		end
	end

	if var_2_0.skip_start_anim_if_moving and arg_2_2.move_state == "moving" then
		arg_2_2.skip_start_anim = true
	end
end

BTClanRatFollowAction._should_walk = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_1 - arg_3_2
	local var_3_1 = Vector3.dot(Quaternion.forward(arg_3_4), var_3_0)
	local var_3_2 = Vector3.dot(Quaternion.right(arg_3_4), var_3_0)

	return arg_3_3 > var_3_1 * var_3_1 + var_3_2 * var_0_2 * (var_3_2 * var_0_2)
end

BTClanRatFollowAction._slow_approach = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_3.slow_approach_distance_sq

	if not var_4_0 then
		return false
	end

	local var_4_1 = arg_4_1 - arg_4_2
	local var_4_2 = Vector3.dot(Quaternion.forward(arg_4_4), var_4_1)
	local var_4_3 = Vector3.dot(Quaternion.right(arg_4_4), var_4_1)

	return var_4_0 < var_4_2^2 + (var_4_3 * var_0_2)^2
end

BTClanRatFollowAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_2.active_node = nil

	if not arg_5_2.locomotion_extension._engine_extension_id then
		return
	end

	if Managers.state.network:in_game_session() then
		arg_5_0:set_start_move_animation_lock(arg_5_1, arg_5_2, false)
	end

	if arg_5_2.is_turning then
		LocomotionUtils.reset_turning(arg_5_1, arg_5_2)

		arg_5_2.is_turning = nil
	end

	arg_5_2.start_anim_locked = nil
	arg_5_2.anim_cb_rotation_start = nil
	arg_5_2.anim_cb_move = nil
	arg_5_2.start_anim_done = nil
	arg_5_2.anim_lock_fallback_time = nil
	arg_5_2.deacceleration_factor = nil
	arg_5_2.walking = nil
	arg_5_2.walking_direction = nil
	arg_5_2.skip_start_anim = nil

	local var_5_0 = AiUtils.get_default_breed_move_speed(arg_5_1, arg_5_2)

	arg_5_2.navigation_extension:set_max_speed(var_5_0)

	arg_5_0.triggered_units[arg_5_1] = nil
end

local var_0_14 = Unit.alive

BTClanRatFollowAction.run = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if not var_0_14(arg_6_2.target_unit) then
		return "done"
	end

	if arg_6_2.spawn_to_running or arg_6_2.skip_start_anim then
		arg_6_2.spawn_to_running = nil
		arg_6_2.start_anim_done = true
		arg_6_2.move_state = "moving"
		arg_6_2.start_anim_locked = nil
		arg_6_2.skip_start_anim = nil

		arg_6_0:set_start_move_animation_lock(arg_6_1, arg_6_2, false)
	end

	if arg_6_2.walking then
		arg_6_0:_update_walking(arg_6_1, arg_6_2, arg_6_4, arg_6_3)
	end

	if not arg_6_2.walking and not arg_6_2.start_anim_done then
		if not arg_6_2.start_anim_locked then
			arg_6_0:start_move_animation(arg_6_1, arg_6_2)

			arg_6_2.anim_lock_fallback_time = arg_6_3 + 2.5
		end

		if arg_6_2.anim_cb_rotation_start then
			arg_6_0:start_move_rotation(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		end

		if arg_6_2.anim_cb_move or arg_6_2.anim_lock_fallback_time and arg_6_3 >= arg_6_2.anim_lock_fallback_time then
			arg_6_2.anim_cb_move = false
			arg_6_2.move_state = "moving"
			arg_6_2.anim_lock_fallback_time = nil

			arg_6_0:set_start_move_animation_lock(arg_6_1, arg_6_2, false)

			arg_6_2.start_anim_locked = nil
			arg_6_2.start_anim_done = true
		end
	else
		arg_6_0:follow(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		arg_6_0:do_dialogue(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	end

	local var_6_0
	local var_6_1 = arg_6_2.navigation_extension

	if arg_6_3 > arg_6_2.time_to_next_evaluate or var_6_1:has_reached_destination() then
		local var_6_2 = arg_6_2.have_slot == 1 and arg_6_2.attacks_done == 0

		var_6_0 = "evaluate"
		arg_6_2.time_to_next_evaluate = var_6_2 and arg_6_3 + 0.1 or arg_6_3 + 0.5
	end

	return "running", var_6_0
end

BTClanRatFollowAction._update_walking = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_2.target_unit
	local var_7_1 = arg_7_2.locomotion_extension
	local var_7_2 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, var_7_0)

	var_7_1:set_wanted_rotation(var_7_2)

	local var_7_3 = arg_7_2.action
	local var_7_4 = var_0_9[arg_7_1]
	local var_7_5 = ScriptUnit.has_extension(var_7_0, "locomotion_system")
	local var_7_6 = var_7_5 and var_7_5.average_velocity and Vector3.dot(var_7_5:average_velocity(), Vector3.normalize(var_0_9[var_7_0] - var_7_4))
	local var_7_7 = arg_7_2.navigation_extension:destination()
	local var_7_8 = arg_7_4 > arg_7_2.walk_timer
	local var_7_9 = arg_7_0:_slow_approach(var_7_7, var_7_4, var_7_3, var_7_2)
	local var_7_10 = arg_7_2.breed
	local var_7_11 = var_7_10.leave_walk_distance
	local var_7_12 = var_7_11 and var_7_11 * var_7_11 or var_0_0
	local var_7_13 = arg_7_0:_should_walk(var_7_7, var_7_4, var_7_12, var_7_2)
	local var_7_14 = not var_7_9 and not var_7_13
	local var_7_15 = not var_7_9 and var_7_6 and var_7_6 > var_0_3 and not var_7_3.ignore_target_velocity
	local var_7_16 = arg_7_2.action.custom_is_tired_function and arg_7_2.action.custom_is_tired_function(arg_7_1, arg_7_2)
	local var_7_17 = var_7_16 and arg_7_2.action.alt_tired_anim or "move_fwd"

	if (not var_7_10.force_walk_while_tired or not var_7_16) and (not var_7_13 and var_7_8 or var_7_14 or var_7_15) then
		arg_7_2.walking = false
		arg_7_2.walking_direction = nil

		Managers.state.network:anim_event(arg_7_1, var_7_17)

		return
	end

	local var_7_18 = var_7_3.walk_anims
	local var_7_19 = arg_7_2.navigation_extension:desired_velocity()
	local var_7_20 = arg_7_0:_calculate_walk_dir(Quaternion.right(var_7_2), Quaternion.forward(var_7_2), var_7_19, var_7_4, var_7_18)

	if var_7_20 ~= arg_7_2.walking_direction then
		local var_7_21 = arg_7_0:_calculate_walk_animation(var_7_20, var_7_18)

		if arg_7_2.action.alt_walk_anim and not var_7_16 then
			Managers.state.network:anim_event(arg_7_1, arg_7_2.action.alt_walk_anim)
		else
			Managers.state.network:anim_event(arg_7_1, var_7_21)
		end

		arg_7_2.move_state = "moving"
		arg_7_2.walking_direction = var_7_20
	end
end

local function var_0_15(arg_8_0)
	if type(arg_8_0) == "table" then
		return arg_8_0[Math.random(1, #arg_8_0)]
	else
		return arg_8_0
	end
end

BTClanRatFollowAction._calculate_walk_animation = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0

	if arg_9_1 == "right" then
		var_9_0 = "move_right_walk"
	elseif arg_9_1 == "left" then
		var_9_0 = "move_left_walk"
	elseif arg_9_1 == "forward" then
		var_9_0 = arg_9_2 and var_0_15(arg_9_2) or "move_fwd_walk"
	else
		var_9_0 = "move_bwd_walk"
	end

	return var_9_0
end

BTClanRatFollowAction._calculate_walk_dir = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = Vector3.dot(arg_10_1, arg_10_3)
	local var_10_1 = Vector3.dot(arg_10_2, arg_10_3)
	local var_10_2 = math.abs(var_10_0)
	local var_10_3 = math.abs(var_10_1)

	arg_10_3 = var_10_3 < var_10_2 and var_10_0 > 0 and "right" or var_10_3 < var_10_2 and "left" or var_10_1 > 0 and "forward" or "backward"

	return arg_10_3
end

BTClanRatFollowAction.follow = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_2.breed
	local var_11_1 = arg_11_2.target_unit
	local var_11_2 = arg_11_2.target_dist
	local var_11_3 = var_11_0.follow_reach or var_11_0.weapon_reach or 2
	local var_11_4 = ScriptUnit.has_extension(var_11_1, "locomotion_system")
	local var_11_5 = arg_11_2.locomotion_extension
	local var_11_6 = Vector3.length(var_11_5:current_velocity())

	if var_11_0.use_big_boy_turning and arg_11_2.move_state == "moving" then
		if arg_11_2.is_turning then
			LocomotionUtils.update_turning(arg_11_1, arg_11_3, arg_11_4, arg_11_2)
		else
			LocomotionUtils.check_start_turning(arg_11_1, arg_11_3, arg_11_4, arg_11_2)
		end
	end

	local var_11_7

	if arg_11_2.walking then
		arg_11_2.deacceleration_factor = nil
		var_11_7 = var_11_0.walk_speed
	elseif var_11_2 < (var_11_0.match_speed_distance or 2 * var_11_3) then
		arg_11_2.deacceleration_factor = nil

		local var_11_8 = math.max((var_11_2 - var_11_3) / var_11_3, 0) * 0.4
		local var_11_9 = var_11_4 and var_11_4.average_velocity and var_11_4:average_velocity() or Vector3.zero()
		local var_11_10 = Vector3.length(var_11_9) or 0
		local var_11_11 = var_11_10 > var_11_0.walk_speed and var_11_10 or var_11_0.walk_speed

		var_11_7 = math.lerp(var_11_11, var_11_0.run_speed, var_11_8)
	elseif (var_11_6 > var_11_0.run_speed + 0.1 or arg_11_2.deacceleration_factor) and var_11_2 < 2 * var_11_3 + var_0_7 then
		local var_11_12 = var_11_2 - var_11_3

		if not arg_11_2.deacceleration_factor then
			arg_11_2.deacceleration_factor = (var_11_6 - var_11_0.run_speed) / var_11_12
		end

		var_11_7 = arg_11_2.deacceleration_factor * var_11_12 + var_11_0.run_speed
	else
		arg_11_2.deacceleration_factor = nil

		local var_11_13 = arg_11_2.breed.run_speed_interpolation_factor or var_0_8
		local var_11_14 = arg_11_0:_calculate_run_speed(arg_11_1, var_11_1, arg_11_2, var_11_4)
		local var_11_15 = math.sign(var_11_14 - var_11_6)

		var_11_6 = var_11_15 > 0 and var_11_6 < var_11_0.run_speed and var_11_2 > (var_11_0.match_speed_distance or var_11_3) + 0.5 and var_11_0.run_speed or var_11_6
		var_11_7 = math.min(var_11_6 + var_11_15 * var_11_13 * arg_11_4, var_11_14)
	end

	local var_11_16 = arg_11_2.action

	if var_11_16.custom_is_tired_function and var_11_16.custom_is_tired_function(arg_11_1, arg_11_2) then
		arg_11_2.walking = true
		arg_11_2.walk_timer = arg_11_3 + 2.5
	end

	if not arg_11_2.walking then
		local var_11_17 = var_11_0.enter_walk_distance and var_11_0.enter_walk_distance^2 or var_0_1
		local var_11_18 = arg_11_2.navigation_extension:destination()
		local var_11_19 = LocomotionUtils.rotation_towards_unit_flat(arg_11_1, arg_11_2.target_unit)
		local var_11_20 = var_0_9[arg_11_1]

		if arg_11_0:_should_walk(var_11_18, var_11_20, var_11_17, var_11_19) then
			local var_11_21 = 0

			if not var_11_16.ignore_target_velocity then
				local var_11_22 = var_11_4 and var_11_4.average_velocity and var_11_4:average_velocity() or Vector3.zero()

				var_11_21 = Vector3.length(var_11_22) or 0
			end

			if var_11_21 < var_0_3 then
				arg_11_2.walking = true
				arg_11_2.walk_timer = arg_11_3 + 2.5
			end
		end
	end

	arg_11_2.navigation_extension:set_max_speed(var_11_7)

	if arg_11_3 > arg_11_2.time_to_next_friend_alert then
		arg_11_2.time_to_next_friend_alert = arg_11_3 + 0.5

		if var_11_2 > (var_11_0.min_alert_friends_distance or var_0_10) and var_11_2 < (var_11_0.max_alert_friends_distance or var_0_11) then
			local var_11_23 = World.get_data(arg_11_2.world, "physics_world")
			local var_11_24 = var_0_9[arg_11_1]
			local var_11_25 = var_0_9[var_11_1] - var_11_24
			local var_11_26 = var_11_24 + Vector3(0, 0, 1)

			if Vector3.length_squared(var_11_25) > 0 then
				local var_11_27, var_11_28, var_11_29, var_11_30 = PhysicsWorld.immediate_raycast(var_11_23, var_11_26, var_11_25, arg_11_2.target_dist, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

				if not var_11_27 then
					AiUtils.alert_nearby_friends_of_enemy(arg_11_1, arg_11_2.group_blackboard.broadphase, var_11_1, var_11_0.friends_alert_range or var_0_12)
				end
			end
		end
	end
end

BTClanRatFollowAction._calculate_run_speed = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_3.target_dist
	local var_12_1 = arg_12_3.destination_dist
	local var_12_2 = 0

	if arg_12_4 and arg_12_4.average_velocity and var_12_1 > var_0_4 and var_12_0 < var_0_5 then
		local var_12_3 = var_0_9[arg_12_1]
		local var_12_4 = arg_12_3.navigation_extension:destination()
		local var_12_5 = arg_12_4:average_velocity()
		local var_12_6 = Vector3.normalize(var_12_4 - var_12_3)
		local var_12_7 = Vector3.normalize(var_12_5)
		local var_12_8 = Vector3.dot(var_12_7, var_12_6)

		var_12_2 = math.clamp(var_12_8, 0, 1)
	end

	return arg_12_3.breed.run_speed + var_0_6 * var_12_2
end

BTClanRatFollowAction.start_move_animation = function (arg_13_0, arg_13_1, arg_13_2)
	arg_13_0:set_start_move_animation_lock(arg_13_1, arg_13_2, true)

	local var_13_0 = var_0_9[arg_13_2.target_unit]
	local var_13_1
	local var_13_2 = arg_13_2.action

	if var_13_2.start_alt_tired_anims_name and var_13_2.custom_is_tired_function(arg_13_1, arg_13_2) then
		var_13_1 = var_13_2.start_alt_tired_anims_name
	else
		var_13_1 = arg_13_2.action.start_anims_name
	end

	local var_13_3 = AiAnimUtils.get_start_move_animation(arg_13_1, var_13_0, var_13_1)

	Managers.state.network:anim_event(arg_13_1, var_13_3)

	arg_13_2.move_animation_name = var_13_3
	arg_13_2.start_anim_locked = true
end

BTClanRatFollowAction.start_move_rotation = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if arg_14_2.move_animation_name == "move_start_fwd" or arg_14_2.move_animation_name == "move_start_fwd_jog" then
		arg_14_0:set_start_move_animation_lock(arg_14_1, arg_14_2, false)

		local var_14_0 = arg_14_2.locomotion_extension
		local var_14_1 = LocomotionUtils.rotation_towards_unit_flat(arg_14_1, arg_14_2.target_unit)

		var_14_0:set_wanted_rotation(var_14_1)
	else
		arg_14_2.anim_cb_rotation_start = false

		local var_14_2 = var_0_9[arg_14_2.target_unit]
		local var_14_3 = AiAnimUtils.get_animation_rotation_scale(arg_14_1, var_14_2, arg_14_2.move_animation_name, arg_14_2.action.start_anims_data)

		LocomotionUtils.set_animation_rotation_scale(arg_14_1, var_14_3)
	end
end

BTClanRatFollowAction.set_start_move_animation_lock = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_2.locomotion_extension

	if arg_15_3 then
		var_15_0:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_15_1, true, false, false)
	else
		var_15_0:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_15_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_15_1, 1)
	end
end

local var_0_16 = {}

BTClanRatFollowAction.do_dialogue = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	if arg_16_3 > arg_16_0.next_time_to_trigger_running_dialogue and arg_16_0.triggered_units[arg_16_1] == nil then
		local var_16_0 = math.ceil(Vector3.distance(var_0_9[arg_16_1], var_0_9[arg_16_2.target_unit]))

		if var_16_0 < 15 then
			local var_16_1 = var_0_9[arg_16_1]
			local var_16_2 = AiUtils.broadphase_query(var_16_1, 10, var_0_16)

			arg_16_0.next_time_to_trigger_running_dialogue = arg_16_3 + 1
			arg_16_0.triggered_units[arg_16_1] = true

			local var_16_3 = ScriptUnit.extension_input(arg_16_1, "dialogue_system")
			local var_16_4 = FrameTable.alloc_table()

			var_16_4.distance = var_16_0
			var_16_4.num_units = var_16_2 - 1

			var_16_3:trigger_networked_dialogue_event("running", var_16_4)
		end
	end
end
