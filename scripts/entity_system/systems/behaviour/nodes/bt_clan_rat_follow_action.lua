-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_clan_rat_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTClanRatFollowAction = class(BTClanRatFollowAction, BTNode)

local num = 36
local num_2 = 16
local num_3 = 0.01
local num_4 = 3
local num_5 = 2
local num_6 = 10
local num_7 = 2
local num_8 = 1
local num_9 = 0.05
local POSITION_LOOKUP = POSITION_LOOKUP
local num_10 = 7
local num_11 = 30
local num_12 = 3

BTClanRatFollowAction.init = function (self, ...)
	-- function 1
	BTClanRatFollowAction.super.init(self, ...)

	self.next_time_to_trigger_running_dialogue = 0
	self.triggered_units = {}
end

BTClanRatFollowAction.name = "BTClanRatFollowAction"

local num_13 = 0.0001

BTClanRatFollowAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.active_node = self
	arg_2_2.time_to_next_evaluate = arg_2_3 + 0.5

	if not arg_2_2.sneaky then
		arg_2_2.time_to_next_friend_alert = arg_2_3 + 99999
	else
		arg_2_2.time_to_next_friend_alert = arg_2_3 + 0.3
	end

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_2_1, true)

	local target_unit = arg_2_2.target_unit
	local locomotion_extension = arg_2_2.locomotion_extension
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_2_1, target_unit)

	locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)

	local var_2_4 = POSITION_LOOKUP[arg_2_1]
	local breed = arg_2_2.breed
	local num

	if not breed.enter_walk_distance then
		num = breed.enter_walk_distance^2

		if not num then
			-- Nothing
		end
	end

	num = num_2

	::label_2_0::

	local destination = arg_2_2.navigation_extension:destination()
	local _should_walk = self:_should_walk(destination, var_2_4, num, rotation_towards_unit_flat)
	local _slow_approach = self:_slow_approach(destination, var_2_4, action_data, rotation_towards_unit_flat)

	if _should_walk or not _slow_approach then
		arg_2_2.walking = true

		if not _slow_approach then
			arg_2_2.walk_timer = arg_2_3 + action_data.slow_approach_time
		else
			local walk_time = action_data.walk_time

			walk_time = walk_time or 3 + 1 * Math.random()
			arg_2_2.walk_timer = arg_2_3 + walk_time
		end
	end

	if not (not action_data.skip_start_anim_if_moving and arg_2_2.move_state ~= "moving") then
		arg_2_2.skip_start_anim = true
	end
end

BTClanRatFollowAction._should_walk = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local num = arg_3_1 - arg_3_2
	local dot = Vector3.dot(Quaternion.forward(arg_3_4), num)
	local dot_2 = Vector3.dot(Quaternion.right(arg_3_4), num)

	return arg_3_3 > dot * dot + dot_2 * num_3 * (dot_2 * num_3)
end

BTClanRatFollowAction._slow_approach = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local slow_approach_distance_sq = arg_4_3.slow_approach_distance_sq

	if not slow_approach_distance_sq then
		return false
	end

	local num = arg_4_1 - arg_4_2
	local dot = Vector3.dot(Quaternion.forward(arg_4_4), num)
	local dot_2 = Vector3.dot(Quaternion.right(arg_4_4), num)

	return slow_approach_distance_sq < dot^2 + (dot_2 * num_3)^2
end

BTClanRatFollowAction.leave = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	arg_5_2.active_node = nil

	if not arg_5_2.locomotion_extension._engine_extension_id then
		return
	end

	if not Managers.state.network:in_game_session() then
		self:set_start_move_animation_lock(arg_5_1, arg_5_2, false)
	end

	if not arg_5_2.is_turning then
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

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_5_1, arg_5_2)

	arg_5_2.navigation_extension:set_max_speed(get_default_breed_move_speed)

	self.triggered_units[arg_5_1] = nil
end

local alive = Unit.alive

BTClanRatFollowAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not alive(arg_6_2.target_unit) then
		return "done"
	end

	if arg_6_2.spawn_to_running or not arg_6_2.skip_start_anim then
		arg_6_2.spawn_to_running = nil
		arg_6_2.start_anim_done = true
		arg_6_2.move_state = "moving"
		arg_6_2.start_anim_locked = nil
		arg_6_2.skip_start_anim = nil

		self:set_start_move_animation_lock(arg_6_1, arg_6_2, false)
	end

	if not arg_6_2.walking then
		self:_update_walking(arg_6_1, arg_6_2, arg_6_4, arg_6_3)
	end

	if not (arg_6_2.walking or arg_6_2.start_anim_done) then
		if not arg_6_2.start_anim_locked then
			self:start_move_animation(arg_6_1, arg_6_2)

			arg_6_2.anim_lock_fallback_time = arg_6_3 + 2.5
		end

		if not arg_6_2.anim_cb_rotation_start then
			self:start_move_rotation(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		end

		if not ((arg_6_2.anim_cb_move or not arg_6_2.anim_lock_fallback_time) and not (arg_6_3 >= arg_6_2.anim_lock_fallback_time)) then
			arg_6_2.anim_cb_move = false
			arg_6_2.move_state = "moving"
			arg_6_2.anim_lock_fallback_time = nil

			self:set_start_move_animation_lock(arg_6_1, arg_6_2, false)

			arg_6_2.start_anim_locked = nil
			arg_6_2.start_anim_done = true
		end
	else
		self:follow(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		self:do_dialogue(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	end

	local var_6_0
	local navigation_extension = arg_6_2.navigation_extension

	if arg_6_3 > arg_6_2.time_to_next_evaluate or not navigation_extension:has_reached_destination() then
		local flag = arg_6_2.have_slot ~= 1 or arg_6_2.attacks_done == 0

		var_6_0 = "evaluate"

		local num

		if not flag then
			num = arg_6_3 + 0.1

			if not num then
				-- Nothing
			end
		end

		num = arg_6_3 + 0.5

		::label_6_0::

		arg_6_2.time_to_next_evaluate = num
	end

	return "running", var_6_0
end

BTClanRatFollowAction._update_walking = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local target_unit = arg_7_2.target_unit
	local locomotion_extension = arg_7_2.locomotion_extension
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, target_unit)

	locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)

	local action = arg_7_2.action
	local var_7_4 = POSITION_LOOKUP[arg_7_1]
	local has_extension = ScriptUnit.has_extension(target_unit, "locomotion_system")

	if not has_extension then
		-- Nothing
	end

	::label_7_0::

	local average_velocity = has_extension.average_velocity

	average_velocity = not average_velocity and Vector3.dot(has_extension:average_velocity(), Vector3.normalize(POSITION_LOOKUP[target_unit] - var_7_4))

	::label_7_1::

	local destination = arg_7_2.navigation_extension:destination()
	local flag = arg_7_4 > arg_7_2.walk_timer
	local _slow_approach = self:_slow_approach(destination, var_7_4, action, rotation_towards_unit_flat)
	local breed = arg_7_2.breed
	local leave_walk_distance = breed.leave_walk_distance
	local num_2

	if not leave_walk_distance then
		num_2 = leave_walk_distance * leave_walk_distance

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = num

	::label_7_2::

	local _should_walk = self:_should_walk(destination, var_7_4, num_2, rotation_towards_unit_flat)
	local flag_2 = not not _slow_approach or not _should_walk
	local flag_3 = not not _slow_approach or not average_velocity or not (average_velocity > num_4) or not action.ignore_target_velocity
	local custom_is_tired_function = arg_7_2.action.custom_is_tired_function

	custom_is_tired_function = not custom_is_tired_function and arg_7_2.action.custom_is_tired_function(arg_7_1, arg_7_2)

	local alt_tired_anim

	if not custom_is_tired_function then
		alt_tired_anim = arg_7_2.action.alt_tired_anim

		if not alt_tired_anim then
			-- Nothing
		end
	end

	alt_tired_anim = "move_fwd"

	::label_7_3::

	if (not breed.force_walk_while_tired and custom_is_tired_function or _should_walk or not flag) and flag_2 or not flag_3 then
		arg_7_2.walking = false
		arg_7_2.walking_direction = nil

		Managers.state.network:anim_event(arg_7_1, alt_tired_anim)

		return
	end

	local walk_anims = action.walk_anims
	local desired_velocity = arg_7_2.navigation_extension:desired_velocity()
	local _calculate_walk_dir = self:_calculate_walk_dir(Quaternion.right(rotation_towards_unit_flat), Quaternion.forward(rotation_towards_unit_flat), desired_velocity, var_7_4, walk_anims)

	if _calculate_walk_dir ~= arg_7_2.walking_direction then
		local _calculate_walk_animation = self:_calculate_walk_animation(_calculate_walk_dir, walk_anims)

		if not (not arg_7_2.action.alt_walk_anim and custom_is_tired_function) then
			Managers.state.network:anim_event(arg_7_1, arg_7_2.action.alt_walk_anim)
		else
			Managers.state.network:anim_event(arg_7_1, _calculate_walk_animation)
		end

		arg_7_2.move_state = "moving"
		arg_7_2.walking_direction = _calculate_walk_dir
	end
end

local function fn(self)
	-- function 8
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTClanRatFollowAction._calculate_walk_animation = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0

	if arg_9_1 == "right" then
		var_9_0 = "move_right_walk"
	elseif arg_9_1 == "left" then
		var_9_0 = "move_left_walk"
	elseif arg_9_1 == "forward" then
		var_9_0 = not arg_9_2 and fn(arg_9_2) and "move_fwd_walk"
	else
		var_9_0 = "move_bwd_walk"
	end

	return var_9_0
end

BTClanRatFollowAction._calculate_walk_dir = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local dot = Vector3.dot(arg_10_1, arg_10_3)
	local dot_2 = Vector3.dot(arg_10_2, arg_10_3)
	local abs = math.abs(dot)
	local abs_2 = math.abs(dot_2)

	arg_10_3 = (not (abs_2 < abs) or not (dot > 0) or not "right" or not (abs_2 < abs)) and (not "left" or not (dot_2 > 0) or not "forward" or "backward")

	return arg_10_3
end

BTClanRatFollowAction.follow = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local breed = arg_11_2.breed
	local target_unit = arg_11_2.target_unit
	local target_dist = arg_11_2.target_dist
	local follow_reach = breed.follow_reach

	if not follow_reach then
		follow_reach = breed.weapon_reach
		follow_reach = follow_reach or 2
	end

	local has_extension = ScriptUnit.has_extension(target_unit, "locomotion_system")
	local locomotion_extension = arg_11_2.locomotion_extension
	local length = Vector3.length(locomotion_extension:current_velocity())

	if not (not breed.use_big_boy_turning and arg_11_2.move_state ~= "moving") then
		if not arg_11_2.is_turning then
			LocomotionUtils.update_turning(arg_11_1, arg_11_3, arg_11_4, arg_11_2)
		else
			LocomotionUtils.check_start_turning(arg_11_1, arg_11_3, arg_11_4, arg_11_2)
		end
	end

	local var_11_7

	if not arg_11_2.walking then
		arg_11_2.deacceleration_factor = nil
		var_11_7 = breed.walk_speed
	else
		local match_speed_distance = breed.match_speed_distance

		match_speed_distance = match_speed_distance or 2 * follow_reach

		if target_dist < match_speed_distance then
			arg_11_2.deacceleration_factor = nil

			local num = math.max((target_dist - follow_reach) / follow_reach, 0) * 0.4
			local average_velocity

			if not has_extension and not has_extension.average_velocity then
				average_velocity = has_extension:average_velocity()

				if not average_velocity then
					-- Nothing
				end
			end

			average_velocity = Vector3.zero()

			::label_11_0::

			local length_2 = Vector3.length(average_velocity)

			length_2 = length_2 or 0

			local flag = not (length_2 > breed.walk_speed) or not length_2 or breed.walk_speed

			var_11_7 = math.lerp(flag, breed.run_speed, num)
		elseif not ((length > breed.run_speed + 0.1 or not arg_11_2.deacceleration_factor) and not (target_dist < 2 * follow_reach + num_8)) then
			local num_3 = target_dist - follow_reach

			if not arg_11_2.deacceleration_factor then
				arg_11_2.deacceleration_factor = (length - breed.run_speed) / num_3
			end

			var_11_7 = arg_11_2.deacceleration_factor * num_3 + breed.run_speed
		else
			arg_11_2.deacceleration_factor = nil

			local run_speed_interpolation_factor = arg_11_2.breed.run_speed_interpolation_factor

			run_speed_interpolation_factor = run_speed_interpolation_factor or num_9

			local _calculate_run_speed = self:_calculate_run_speed(arg_11_1, target_unit, arg_11_2, has_extension)
			local sign = math.sign(_calculate_run_speed - length)

			if not (not (sign > 0) or not (length < breed.run_speed)) then
				local match_speed_distance_2 = breed.match_speed_distance

				match_speed_distance_2 = match_speed_distance_2 or follow_reach
				length = not (target_dist > match_speed_distance_2 + 0.5) or not breed.run_speed or length
			end

			var_11_7 = math.min(length + sign * run_speed_interpolation_factor * arg_11_4, _calculate_run_speed)
		end
	end

	local action = arg_11_2.action

	if not action.custom_is_tired_function and not action.custom_is_tired_function(arg_11_1, arg_11_2) then
		arg_11_2.walking = true
		arg_11_2.walk_timer = arg_11_3 + 2.5
	end

	if not arg_11_2.walking then
		local num_5

		if not breed.enter_walk_distance then
			num_5 = breed.enter_walk_distance^2

			if not num_5 then
				-- Nothing
			end
		end

		num_5 = num_2

		::label_11_1::

		local destination = arg_11_2.navigation_extension:destination()
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_11_1, arg_11_2.target_unit)
		local var_11_22 = POSITION_LOOKUP[arg_11_1]

		if not self:_should_walk(destination, var_11_22, num_5, rotation_towards_unit_flat) then
			local num_6 = 0

			if not action.ignore_target_velocity then
				local average_velocity_2

				if not has_extension and not has_extension.average_velocity then
					average_velocity_2 = has_extension:average_velocity()

					if not average_velocity_2 then
						-- Nothing
					end
				end

				average_velocity_2 = Vector3.zero()

				::label_11_2::

				num_6 = Vector3.length(average_velocity_2) or 0
			end

			if num_6 < num_4 then
				arg_11_2.walking = true
				arg_11_2.walk_timer = arg_11_3 + 2.5
			end
		end
	end

	arg_11_2.navigation_extension:set_max_speed(var_11_7)

	if arg_11_3 > arg_11_2.time_to_next_friend_alert then
		arg_11_2.time_to_next_friend_alert = arg_11_3 + 0.5

		local min_alert_friends_distance = breed.min_alert_friends_distance

		min_alert_friends_distance = min_alert_friends_distance or num_10

		if min_alert_friends_distance < target_dist then
			local max_alert_friends_distance = breed.max_alert_friends_distance

			max_alert_friends_distance = max_alert_friends_distance or num_11

			if not (target_dist < max_alert_friends_distance) then
				-- Nothing
			end
		end

		do
			local flag_2 = false

			goto label_11_4
		end

		::label_11_3::

		flag_2 = true

		::label_11_4::

		if not flag_2 then
			local get_data = World.get_data(arg_11_2.world, "physics_world")
			local var_11_29 = POSITION_LOOKUP[arg_11_1]
			local num_7 = POSITION_LOOKUP[target_unit] - var_11_29
			local num_13 = var_11_29 + Vector3(0, 0, 1)

			if Vector3.length_squared(num_7) > 0 then
				local immediate_raycast, var_11_33, var_11_34, var_11_35 = PhysicsWorld.immediate_raycast(get_data, num_13, num_7, arg_11_2.target_dist, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

				if not immediate_raycast then
					local alert_nearby_friends_of_enemy = AiUtils.alert_nearby_friends_of_enemy
					local var_11_37 = arg_11_1
					local broadphase = arg_11_2.group_blackboard.broadphase
					local var_11_39 = target_unit
					local friends_alert_range = breed.friends_alert_range

					friends_alert_range = friends_alert_range or num_12

					alert_nearby_friends_of_enemy(var_11_37, broadphase, var_11_39, friends_alert_range)
				end
			end
		end
	end
end

BTClanRatFollowAction._calculate_run_speed = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local target_dist = arg_12_3.target_dist
	local destination_dist = arg_12_3.destination_dist
	local num = 0

	if not (not arg_12_4 and not arg_12_4.average_velocity and not (destination_dist > num_5) or not (target_dist < num_6)) then
		local var_12_3 = POSITION_LOOKUP[arg_12_1]
		local destination = arg_12_3.navigation_extension:destination()
		local average_velocity = arg_12_4:average_velocity()
		local normalize = Vector3.normalize(destination - var_12_3)
		local normalize_2 = Vector3.normalize(average_velocity)
		local dot = Vector3.dot(normalize_2, normalize)

		num = math.clamp(dot, 0, 1)
	end

	return arg_12_3.breed.run_speed + num_7 * num
end

BTClanRatFollowAction.start_move_animation = function (self, arg_13_1, arg_13_2)
	-- function 13
	self:set_start_move_animation_lock(arg_13_1, arg_13_2, true)

	local var_13_0 = POSITION_LOOKUP[arg_13_2.target_unit]
	local var_13_1
	local action = arg_13_2.action

	if not action.start_alt_tired_anims_name and not action.custom_is_tired_function(arg_13_1, arg_13_2) then
		var_13_1 = action.start_alt_tired_anims_name
	else
		var_13_1 = arg_13_2.action.start_anims_name
	end

	local get_start_move_animation = AiAnimUtils.get_start_move_animation(arg_13_1, var_13_0, var_13_1)

	Managers.state.network:anim_event(arg_13_1, get_start_move_animation)

	arg_13_2.move_animation_name = get_start_move_animation
	arg_13_2.start_anim_locked = true
end

BTClanRatFollowAction.start_move_rotation = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	if not (arg_14_2.move_animation_name == "move_start_fwd" or arg_14_2.move_animation_name ~= "move_start_fwd_jog") then
		self:set_start_move_animation_lock(arg_14_1, arg_14_2, false)

		local locomotion_extension = arg_14_2.locomotion_extension
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_14_1, arg_14_2.target_unit)

		locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	else
		arg_14_2.anim_cb_rotation_start = false

		local var_14_2 = POSITION_LOOKUP[arg_14_2.target_unit]
		local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_14_1, var_14_2, arg_14_2.move_animation_name, arg_14_2.action.start_anims_data)

		LocomotionUtils.set_animation_rotation_scale(arg_14_1, get_animation_rotation_scale)
	end
end

BTClanRatFollowAction.set_start_move_animation_lock = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local locomotion_extension = arg_15_2.locomotion_extension

	if not arg_15_3 then
		locomotion_extension:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_15_1, true, false, false)
	else
		locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_15_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_15_1, 1)
	end
end

local tbl = {}

BTClanRatFollowAction.do_dialogue = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	if not (not (arg_16_3 > self.next_time_to_trigger_running_dialogue) or self.triggered_units[arg_16_1] ~= nil) then
		local ceil = math.ceil(Vector3.distance(POSITION_LOOKUP[arg_16_1], POSITION_LOOKUP[arg_16_2.target_unit]))

		if ceil < 15 then
			local var_16_1 = POSITION_LOOKUP[arg_16_1]
			local broadphase_query = AiUtils.broadphase_query(var_16_1, 10, tbl)

			self.next_time_to_trigger_running_dialogue = arg_16_3 + 1
			self.triggered_units[arg_16_1] = true

			local extension_input = ScriptUnit.extension_input(arg_16_1, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			alloc_table.distance = ceil
			alloc_table.num_units = broadphase_query - 1

			extension_input:trigger_networked_dialogue_event("running", alloc_table)
		end
	end
end
