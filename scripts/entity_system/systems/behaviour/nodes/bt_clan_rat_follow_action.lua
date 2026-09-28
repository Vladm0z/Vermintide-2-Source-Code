-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_clan_rat_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTClanRatFollowAction = class(BTClanRatFollowAction, BTNode)

local LEAVE_WALK_DISTANCE_SQ = 36
local ENTER_WALK_DISTANCE_SQ = 16
local LATERAL_DISTANCE_FACTOR = 0.01
local WALK_MAX_TARGET_VELOCITY = 3
local CHASE_MIN_REQUIRED_MOVEMENT_DISTANCE = 2
local CHASE_MAX_TARGET_DISTANCE = 10
local CHASE_MAX_SPEED_INCREASE = 2
local CHASE_DEACCELERATION_DISTANCE = 1
local RUN_SPEED_INTERPOLATION_FACTOR = 0.05
local POSITION_LOOKUP = POSITION_LOOKUP
local DEFAULT_MIN_ALERT_FRIENDS_DIST = 7
local DEFAULT_MAX_ALERT_FRIENDS_DIST = 30
local DEFAULT_FRIENDS_ALERT_RANGE = 3

BTClanRatFollowAction.init = function (self, ...)
	-- function 1
	BTClanRatFollowAction.super.init(self, ...)

	self.next_time_to_trigger_running_dialogue = 0
	self.triggered_units = {}
end

BTClanRatFollowAction.name = "BTClanRatFollowAction"

local EPSILON_SQ = 0.0001

BTClanRatFollowAction.enter = function (self, unit, blackboard, t)
	-- function 2
	local action_data = self._tree_node.action_data

	blackboard.action = action_data
	blackboard.active_node = self
	blackboard.time_to_next_evaluate = t + 0.5

	if blackboard.sneaky then
		blackboard.time_to_next_friend_alert = t + 99999
	else
		blackboard.time_to_next_friend_alert = t + 0.3
	end

	local ai_slot_system = Managers.state.entity:system("ai_slot_system")

	ai_slot_system:do_slot_search(unit, true)

	local target_unit = blackboard.target_unit
	local locomotion_extension = blackboard.locomotion_extension
	local rotation = LocomotionUtils.rotation_towards_unit_flat(unit, target_unit)

	locomotion_extension:set_wanted_rotation(rotation)

	local position = POSITION_LOOKUP[unit]
	local breed = blackboard.breed
	local num

	if breed.enter_walk_distance then
		num = breed.enter_walk_distance^2

		if not num then
			-- Nothing
		end
	end

	num = ENTER_WALK_DISTANCE_SQ

	local enter_walk_dist_sq = num

	::label_2_0::

	local navigation_extension = blackboard.navigation_extension
	local destination = navigation_extension:destination()
	local should_walk = self:_should_walk(destination, position, enter_walk_dist_sq, rotation)
	local use_slow_approach = self:_slow_approach(destination, position, action_data, rotation)

	if should_walk or use_slow_approach then
		blackboard.walking = true

		if use_slow_approach then
			blackboard.walk_timer = t + action_data.slow_approach_time
		else
			local walk_time = action_data.walk_time

			walk_time = not not walk_time or not not (3 + 1 * Math.random())
			blackboard.walk_timer = t + walk_time
		end
	end

	if action_data.skip_start_anim_if_moving and blackboard.move_state == "moving" then
		blackboard.skip_start_anim = true
	end
end

BTClanRatFollowAction._should_walk = function (self, destination, self_pos, max_distance_sq, rotation_towards_target)
	-- function 3
	local diff_vector = destination - self_pos
	local direct_distance = Vector3.dot(Quaternion.forward(rotation_towards_target), diff_vector)
	local lateral_distance = Vector3.dot(Quaternion.right(rotation_towards_target), diff_vector)
	local distance_sq = direct_distance * direct_distance + lateral_distance * LATERAL_DISTANCE_FACTOR * (lateral_distance * LATERAL_DISTANCE_FACTOR)

	return distance_sq < max_distance_sq
end

BTClanRatFollowAction._slow_approach = function (self, destination, self_pos, action_data, rotation_towards_target)
	-- function 4
	local breed = action_data
	local slow_approach_distance_sq = breed.slow_approach_distance_sq

	if not slow_approach_distance_sq then
		return false
	end

	local diff_vector = destination - self_pos
	local direct_distance = Vector3.dot(Quaternion.forward(rotation_towards_target), diff_vector)
	local lateral_distance = Vector3.dot(Quaternion.right(rotation_towards_target), diff_vector)
	local distance_sq = direct_distance^2 + (lateral_distance * LATERAL_DISTANCE_FACTOR)^2
	local use_slow_approach = slow_approach_distance_sq < distance_sq

	return use_slow_approach
end

BTClanRatFollowAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 5
	blackboard.active_node = nil

	local locomotion_extension = blackboard.locomotion_extension

	if not locomotion_extension._engine_extension_id then
		return
	end

	if Managers.state.network:in_game_session() then
		self:set_start_move_animation_lock(unit, blackboard, false)
	end

	if blackboard.is_turning then
		LocomotionUtils.reset_turning(unit, blackboard)

		blackboard.is_turning = nil
	end

	blackboard.start_anim_locked = nil
	blackboard.anim_cb_rotation_start = nil
	blackboard.anim_cb_move = nil
	blackboard.start_anim_done = nil
	blackboard.anim_lock_fallback_time = nil
	blackboard.deacceleration_factor = nil
	blackboard.walking = nil
	blackboard.walking_direction = nil
	blackboard.skip_start_anim = nil

	local default_move_speed = AiUtils.get_default_breed_move_speed(unit, blackboard)
	local navigation_extension = blackboard.navigation_extension

	navigation_extension:set_max_speed(default_move_speed)

	self.triggered_units[unit] = nil
end

local Unit_alive = Unit.alive

BTClanRatFollowAction.run = function (self, unit, blackboard, t, dt)
	-- function 6
	if not Unit_alive(blackboard.target_unit) then
		return "done"
	end

	if blackboard.spawn_to_running or blackboard.skip_start_anim then
		blackboard.spawn_to_running = nil
		blackboard.start_anim_done = true
		blackboard.move_state = "moving"
		blackboard.start_anim_locked = nil
		blackboard.skip_start_anim = nil

		self:set_start_move_animation_lock(unit, blackboard, false)
	end

	if blackboard.walking then
		self:_update_walking(unit, blackboard, dt, t)
	end

	if not blackboard.walking and not blackboard.start_anim_done then
		if not blackboard.start_anim_locked then
			self:start_move_animation(unit, blackboard)

			blackboard.anim_lock_fallback_time = t + 2.5
		end

		if blackboard.anim_cb_rotation_start then
			self:start_move_rotation(unit, blackboard, t, dt)
		end

		if blackboard.anim_cb_move or blackboard.anim_lock_fallback_time and t >= blackboard.anim_lock_fallback_time then
			blackboard.anim_cb_move = false
			blackboard.move_state = "moving"
			blackboard.anim_lock_fallback_time = nil

			self:set_start_move_animation_lock(unit, blackboard, false)

			blackboard.start_anim_locked = nil
			blackboard.start_anim_done = true
		end
	else
		self:follow(unit, blackboard, t, dt)
		self:do_dialogue(unit, blackboard, t, dt)
	end

	local should_evaluate
	local navigation_extension = blackboard.navigation_extension

	if t > blackboard.time_to_next_evaluate or navigation_extension:has_reached_destination() then
		local prioritized_update = blackboard.have_slot == 1 and blackboard.attacks_done == 0

		should_evaluate = "evaluate"

		local num

		if prioritized_update then
			num = t + 0.1

			if not num then
				-- Nothing
			end
		end

		num = t + 0.5

		::label_6_0::

		blackboard.time_to_next_evaluate = num
	end

	return "running", should_evaluate
end

BTClanRatFollowAction._update_walking = function (self, unit, blackboard, dt, t)
	-- function 7
	local target = blackboard.target_unit
	local locomotion_extension = blackboard.locomotion_extension
	local rotation = LocomotionUtils.rotation_towards_unit_flat(unit, target)

	locomotion_extension:set_wanted_rotation(rotation)

	local action_data = blackboard.action
	local self_pos = POSITION_LOOKUP[unit]
	local target_locomotion = ScriptUnit.has_extension(target, "locomotion_system")

	if target_locomotion then
		-- Nothing
	end

	::label_7_0::

	local average_velocity = target_locomotion.average_velocity

	if average_velocity then
		-- Nothing
	end

	average_velocity = Vector3.dot(target_locomotion:average_velocity(), Vector3.normalize(POSITION_LOOKUP[target] - self_pos))

	local velocity_away = average_velocity

	::label_7_1::

	local destination = blackboard.navigation_extension:destination()
	local walk_timer_finished = t > blackboard.walk_timer
	local use_slow_approach = self:_slow_approach(destination, self_pos, action_data, rotation)
	local breed = blackboard.breed
	local leave_walk_distance = breed.leave_walk_distance
	local num

	if leave_walk_distance then
		num = leave_walk_distance * leave_walk_distance

		if not num then
			-- Nothing
		end
	end

	num = LEAVE_WALK_DISTANCE_SQ

	local leave_walk_dist_sq = num

	::label_7_2::

	local should_walk = self:_should_walk(destination, self_pos, leave_walk_dist_sq, rotation)
	local run = not use_slow_approach and not not not should_walk
	local target_moving_fast = not use_slow_approach and not not velocity_away and velocity_away > WALK_MAX_TARGET_VELOCITY and not not not action_data.ignore_target_velocity
	local custom_is_tired_function = blackboard.action.custom_is_tired_function

	if custom_is_tired_function then
		-- Nothing
	end

	custom_is_tired_function = blackboard.action.custom_is_tired_function(unit, blackboard)

	local is_tired = custom_is_tired_function

	do
		local alt_tired_anim
	end

	::label_7_3::

	if is_tired then
		alt_tired_anim = blackboard.action.alt_tired_anim

		if not alt_tired_anim then
			-- Nothing
		end
	end

	alt_tired_anim = "move_fwd"

	local run_anim = alt_tired_anim

	::label_7_4::

	if (not breed.force_walk_while_tired or not is_tired) and (should_walk or not walk_timer_finished) and (run or target_moving_fast) then
		blackboard.walking = false
		blackboard.walking_direction = nil

		Managers.state.network:anim_event(unit, run_anim)

		return
	end

	local walk_anims = action_data.walk_anims
	local dir = blackboard.navigation_extension:desired_velocity()
	local walk_dir = self:_calculate_walk_dir(Quaternion.right(rotation), Quaternion.forward(rotation), dir, self_pos, walk_anims)

	if walk_dir ~= blackboard.walking_direction then
		local walk_anim = self:_calculate_walk_animation(walk_dir, walk_anims)

		if blackboard.action.alt_walk_anim and not is_tired then
			Managers.state.network:anim_event(unit, blackboard.action.alt_walk_anim)
		else
			Managers.state.network:anim_event(unit, walk_anim)
		end

		blackboard.move_state = "moving"
		blackboard.walking_direction = walk_dir
	end
end

local function randomize(event)
	-- function 8
	if type(event) == "table" then
		return event[Math.random(1, #event)]
	else
		return event
	end
end

BTClanRatFollowAction._calculate_walk_animation = function (self, walk_dir, walk_anims)
	-- function 9
	local anim

	if walk_dir == "right" then
		anim = "move_right_walk"
	elseif walk_dir == "left" then
		anim = "move_left_walk"
	elseif walk_dir == "forward" then
		anim = (not walk_anims or not randomize(walk_anims)) and not not "move_fwd_walk"
	else
		anim = "move_bwd_walk"
	end

	return anim
end

BTClanRatFollowAction._calculate_walk_dir = function (self, right_vector, forward_vector, dir, pos, walk_anims)
	-- function 10
	local right_dot = Vector3.dot(right_vector, dir)
	local fwd_dot = Vector3.dot(forward_vector, dir)
	local abs_right = math.abs(right_dot)
	local abs_fwd = math.abs(fwd_dot)

	dir = (not (abs_fwd < abs_right) or not (right_dot > 0) or not "right") and (not (abs_fwd < abs_right) or not "left") and (not (fwd_dot > 0) or not "forward") and not not "backward"

	return dir
end

BTClanRatFollowAction.follow = function (self, unit, blackboard, t, dt)
	-- function 11
	local breed = blackboard.breed
	local target_unit = blackboard.target_unit
	local target_distance = blackboard.target_dist
	local follow_reach = breed.follow_reach

	if not follow_reach then
		-- Nothing
	end

	follow_reach = breed.weapon_reach

	if not follow_reach then
		-- Nothing
	end

	follow_reach = 2

	local weapon_reach = follow_reach

	::label_11_0::

	local target_locomotion = ScriptUnit.has_extension(target_unit, "locomotion_system")
	local locomotion_extension = blackboard.locomotion_extension
	local current_speed = Vector3.length(locomotion_extension:current_velocity())

	if breed.use_big_boy_turning and blackboard.move_state == "moving" then
		local is_turning = blackboard.is_turning

		if is_turning then
			LocomotionUtils.update_turning(unit, t, dt, blackboard)
		else
			LocomotionUtils.check_start_turning(unit, t, dt, blackboard)
		end
	end

	local new_speed

	if blackboard.walking then
		blackboard.deacceleration_factor = nil
		new_speed = breed.walk_speed
	else
		local match_speed_distance = breed.match_speed_distance

		match_speed_distance = not not match_speed_distance or not not (2 * weapon_reach)

		if target_distance < match_speed_distance then
			blackboard.deacceleration_factor = nil

			local lerp_value = math.max((target_distance - weapon_reach) / weapon_reach, 0) * 0.4
			local average_velocity

			if target_locomotion and target_locomotion.average_velocity then
				average_velocity = target_locomotion:average_velocity()

				if not average_velocity then
					-- Nothing
				end
			end

			average_velocity = Vector3.zero()

			local target_velocity = average_velocity

			::label_11_1::

			local length = Vector3.length(target_velocity)

			if not length then
				-- Nothing
			end

			length = 0

			local target_speed = length

			::label_11_2::

			local wanted_speed = (not (target_speed > breed.walk_speed) or not target_speed) and not not breed.walk_speed

			new_speed = math.lerp(wanted_speed, breed.run_speed, lerp_value)
		elseif (current_speed > breed.run_speed + 0.1 or blackboard.deacceleration_factor) and target_distance < 2 * weapon_reach + CHASE_DEACCELERATION_DISTANCE then
			local deaccelearation_distance_left = target_distance - weapon_reach

			if not blackboard.deacceleration_factor then
				blackboard.deacceleration_factor = (current_speed - breed.run_speed) / deaccelearation_distance_left
			end

			new_speed = blackboard.deacceleration_factor * deaccelearation_distance_left + breed.run_speed
		else
			blackboard.deacceleration_factor = nil

			local run_speed_interpolation_factor = blackboard.breed.run_speed_interpolation_factor

			if not run_speed_interpolation_factor then
				-- Nothing
			end

			run_speed_interpolation_factor = RUN_SPEED_INTERPOLATION_FACTOR

			local interpolation_factor = run_speed_interpolation_factor

			::label_11_3::

			local wanted_speed = self:_calculate_run_speed(unit, target_unit, blackboard, target_locomotion)
			local sign = math.sign(wanted_speed - current_speed)

			if sign > 0 and current_speed < breed.run_speed then
				local match_speed_distance_2 = breed.match_speed_distance

				match_speed_distance_2 = not not match_speed_distance_2 or not not weapon_reach

				if target_distance > match_speed_distance_2 + 0.5 and not breed.run_speed then
					-- Nothing
				end
			end

			new_speed = math.min(current_speed + sign * interpolation_factor * dt, wanted_speed)
		end
	end

	local action = blackboard.action

	if action.custom_is_tired_function and action.custom_is_tired_function(unit, blackboard) then
		blackboard.walking = true
		blackboard.walk_timer = t + 2.5
	end

	if not blackboard.walking then
		local num

		if breed.enter_walk_distance then
			num = breed.enter_walk_distance^2

			if not num then
				-- Nothing
			end
		end

		num = ENTER_WALK_DISTANCE_SQ

		local enter_walk_dist_sq = num

		::label_11_4::

		local destination = blackboard.navigation_extension:destination()
		local rotation = LocomotionUtils.rotation_towards_unit_flat(unit, blackboard.target_unit)
		local position = POSITION_LOOKUP[unit]
		local should_walk = self:_should_walk(destination, position, enter_walk_dist_sq, rotation)

		if should_walk then
			local target_speed = 0

			if not action.ignore_target_velocity then
				local average_velocity_2

				if target_locomotion and target_locomotion.average_velocity then
					average_velocity_2 = target_locomotion:average_velocity()

					if not average_velocity_2 then
						-- Nothing
					end
				end

				average_velocity_2 = Vector3.zero()

				local target_velocity = average_velocity_2

				::label_11_5::

				target_speed = not not Vector3.length(target_velocity) or not not 0
			end

			if target_speed < WALK_MAX_TARGET_VELOCITY then
				blackboard.walking = true
				blackboard.walk_timer = t + 2.5
			end
		end
	end

	local navigation_extension = blackboard.navigation_extension

	navigation_extension:set_max_speed(new_speed)

	if t > blackboard.time_to_next_friend_alert then
		blackboard.time_to_next_friend_alert = t + 0.5

		local min_alert_friends_distance = breed.min_alert_friends_distance

		min_alert_friends_distance = not not min_alert_friends_distance or not not DEFAULT_MIN_ALERT_FRIENDS_DIST

		if min_alert_friends_distance < target_distance then
			local max_alert_friends_distance = breed.max_alert_friends_distance

			max_alert_friends_distance = not not max_alert_friends_distance or not not DEFAULT_MAX_ALERT_FRIENDS_DIST

			if not (target_distance < max_alert_friends_distance) then
				-- Nothing
			end
		end

		do
			local flag = false

			goto label_11_7
		end

		::label_11_6::

		flag = true

		local is_within_range = flag

		::label_11_7::

		if is_within_range then
			local physics_world = World.get_data(blackboard.world, "physics_world")
			local unit_pos = POSITION_LOOKUP[unit]
			local direction = POSITION_LOOKUP[target_unit] - unit_pos
			local raycast_pos = unit_pos + Vector3(0, 0, 1)

			if Vector3.length_squared(direction) > 0 then
				local result, hit_pos, hit_distance, normal = PhysicsWorld.immediate_raycast(physics_world, raycast_pos, direction, blackboard.target_dist, "closest", "types", "statics", "collision_filter", "filter_ai_line_of_sight_check")

				if not result then
					local alert_nearby_friends_of_enemy = AiUtils.alert_nearby_friends_of_enemy
					local var_11_12 = unit
					local broadphase = blackboard.group_blackboard.broadphase
					local var_11_14 = target_unit
					local friends_alert_range = breed.friends_alert_range

					friends_alert_range = not not friends_alert_range or not not DEFAULT_FRIENDS_ALERT_RANGE

					alert_nearby_friends_of_enemy(var_11_12, broadphase, var_11_14, friends_alert_range)
				end
			end
		end
	end
end

BTClanRatFollowAction._calculate_run_speed = function (self, unit, target_unit, blackboard, target_locomotion)
	-- function 12
	local target_distance = blackboard.target_dist
	local destination_distance = blackboard.destination_dist
	local chase_factor = 0

	if target_locomotion and target_locomotion.average_velocity and destination_distance > CHASE_MIN_REQUIRED_MOVEMENT_DISTANCE and target_distance < CHASE_MAX_TARGET_DISTANCE then
		local current_position = POSITION_LOOKUP[unit]
		local navigation_extension = blackboard.navigation_extension
		local destination = navigation_extension:destination()
		local target_velocity = target_locomotion:average_velocity()
		local move_direction = Vector3.normalize(destination - current_position)
		local target_move_direction = Vector3.normalize(target_velocity)
		local dot = Vector3.dot(target_move_direction, move_direction)

		chase_factor = math.clamp(dot, 0, 1)
	end

	local breed = blackboard.breed
	local new_speed = breed.run_speed + CHASE_MAX_SPEED_INCREASE * chase_factor

	return new_speed
end

BTClanRatFollowAction.start_move_animation = function (self, unit, blackboard)
	-- function 13
	self:set_start_move_animation_lock(unit, blackboard, true)

	local target_pos = POSITION_LOOKUP[blackboard.target_unit]
	local start_anims_name
	local action = blackboard.action

	if action.start_alt_tired_anims_name and action.custom_is_tired_function(unit, blackboard) then
		start_anims_name = action.start_alt_tired_anims_name
	else
		start_anims_name = blackboard.action.start_anims_name
	end

	local animation_name = AiAnimUtils.get_start_move_animation(unit, target_pos, start_anims_name)

	Managers.state.network:anim_event(unit, animation_name)

	blackboard.move_animation_name = animation_name
	blackboard.start_anim_locked = true
end

BTClanRatFollowAction.start_move_rotation = function (self, unit, blackboard, t, dt)
	-- function 14
	if blackboard.move_animation_name == "move_start_fwd" or blackboard.move_animation_name == "move_start_fwd_jog" then
		self:set_start_move_animation_lock(unit, blackboard, false)

		local locomotion_extension = blackboard.locomotion_extension
		local rot = LocomotionUtils.rotation_towards_unit_flat(unit, blackboard.target_unit)

		locomotion_extension:set_wanted_rotation(rot)
	else
		blackboard.anim_cb_rotation_start = false

		local target_pos = POSITION_LOOKUP[blackboard.target_unit]
		local rot_scale = AiAnimUtils.get_animation_rotation_scale(unit, target_pos, blackboard.move_animation_name, blackboard.action.start_anims_data)

		LocomotionUtils.set_animation_rotation_scale(unit, rot_scale)
	end
end

BTClanRatFollowAction.set_start_move_animation_lock = function (self, unit, blackboard, should_lock_ani)
	-- function 15
	local locomotion_extension = blackboard.locomotion_extension

	if should_lock_ani then
		locomotion_extension:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(unit, true, false, false)
	else
		locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(unit, false)
		LocomotionUtils.set_animation_rotation_scale(unit, 1)
	end
end

local nearby_units = {}

BTClanRatFollowAction.do_dialogue = function (self, unit, blackboard, t, dt)
	-- function 16
	if t > self.next_time_to_trigger_running_dialogue and self.triggered_units[unit] == nil then
		local distance = math.ceil(Vector3.distance(POSITION_LOOKUP[unit], POSITION_LOOKUP[blackboard.target_unit]))

		if distance < 15 then
			local position = POSITION_LOOKUP[unit]
			local num_nearby_units = AiUtils.broadphase_query(position, 10, nearby_units)

			self.next_time_to_trigger_running_dialogue = t + 1
			self.triggered_units[unit] = true

			local dialogue_input = ScriptUnit.extension_input(unit, "dialogue_system")
			local event_data = FrameTable.alloc_table()

			event_data.distance = distance
			event_data.num_units = num_nearby_units - 1

			dialogue_input:trigger_networked_dialogue_event("running", event_data)
		end
	end
end
