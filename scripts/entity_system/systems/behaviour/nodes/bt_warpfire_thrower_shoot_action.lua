-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_warpfire_thrower_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

BTWarpfireThrowerShootAction = class(BTWarpfireThrowerShootAction, BTNode)

BTWarpfireThrowerShootAction.init = function (arg_1_0, ...)
	-- function 1
	BTWarpfireThrowerShootAction.super.init(arg_1_0, ...)
end

BTWarpfireThrowerShootAction.name = "BTWarpfireThrowerShootAction"

local tbl = {}

BTWarpfireThrowerShootAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.attack_finished = false

	local world = arg_2_2.world
	local physics_world = arg_2_2.physics_world

	physics_world = physics_world or World.get_data(world, "physics_world")
	arg_2_2.physics_world = physics_world

	local attack_pattern_data = arg_2_2.attack_pattern_data

	attack_pattern_data = attack_pattern_data or {}
	arg_2_2.attack_pattern_data = attack_pattern_data

	local default_inventory_template = arg_2_2.breed.default_inventory_template

	attack_pattern_data.warpfire_gun_unit = ScriptUnit.extension(arg_2_1, "ai_inventory_system"):get_unit(default_inventory_template)
	attack_pattern_data.state = "align"

	local local_rotation = Unit.local_rotation(arg_2_1, 0)
	local forward = Quaternion.forward(local_rotation)

	attack_pattern_data.shoot_direction_box = Vector3Box(forward)

	arg_2_2.navigation_extension:stop()
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local constraint_target = attack_pattern_data.constraint_target

	constraint_target = constraint_target or Unit.animation_find_constraint_target(arg_2_1, "aim_target")
	attack_pattern_data.constraint_target = constraint_target

	local target_unit = arg_2_2.target_unit

	self:_start_align_towards_target(arg_2_1, arg_2_2, attack_pattern_data, target_unit)

	arg_2_2.move_state = "attacking"
	arg_2_2.attack_aborted = false
	arg_2_2.line_of_sight_raycast_timer = arg_2_3 + 0.5
	arg_2_2.close_attack_cooldown = 0

	local warpfire_data = arg_2_2.warpfire_data

	warpfire_data = warpfire_data or {}
	arg_2_2.warpfire_data = warpfire_data
	warpfire_data.is_firing = false

	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_started(arg_2_1, target_unit, "warpfire_thrower_fire")
end

BTWarpfireThrowerShootAction._init_attack = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local var_3_0 = POSITION_LOOKUP[arg_3_2]
	local var_3_1

	if not var_3_0 then
		local var_3_2 = POSITION_LOOKUP[arg_3_1]
		local minimum_length = arg_3_4.minimum_length

		var_3_1 = Vector3.distance_squared(var_3_2, var_3_0) > minimum_length^2
	else
		var_3_1 = false
	end

	return var_3_1
end

BTWarpfireThrowerShootAction._abort_shooting = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	arg_4_2.blob_extension:stop_placing_blobs(arg_4_1)

	arg_4_2.is_firing = false
end

BTWarpfireThrowerShootAction.leave = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local warpfire_data = arg_5_2.warpfire_data

	if not warpfire_data.is_firing then
		self:_abort_shooting(arg_5_3, warpfire_data)
	end

	Managers.state.network:anim_event(arg_5_1, "attack_shoot_end")

	local target_unit = arg_5_2.target_unit

	Managers.state.entity:system("ai_bot_group_system"):ranged_attack_ended(arg_5_1, target_unit, "warpfire_thrower_fire")

	arg_5_2.action = nil
	arg_5_2.attack_aborted = nil
	arg_5_2.anim_cb_attack_shoot_random_shot = nil
	arg_5_2.create_bot_threat_at_t = nil

	for k, v in pairs(tbl) do
		tbl[k] = nil
	end
end

BTWarpfireThrowerShootAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not arg_6_2.attack_aborted then
		return "failed"
	end

	local action = arg_6_2.action
	local target_unit = arg_6_2.target_unit
	local warpfire_data = arg_6_2.warpfire_data
	local attack_pattern_data = arg_6_2.attack_pattern_data

	if attack_pattern_data.state == "align" then
		local old_target_unit = arg_6_2.old_target_unit

		if not (not old_target_unit and target_unit ~= old_target_unit) then
			self:_start_align_towards_target(arg_6_1, arg_6_2, attack_pattern_data, target_unit)

			arg_6_2.old_target_unit = target_unit
		end

		if not self:_update_align_towards_target(arg_6_1, arg_6_2, attack_pattern_data, target_unit, arg_6_4) then
			self:_end_align_towards_target(arg_6_1, warpfire_data, attack_pattern_data, arg_6_2, arg_6_3)

			local bot_threat_start_time = action.bot_threat_start_time

			if not bot_threat_start_time then
				arg_6_2.create_bot_threat_at_t = arg_6_3 + bot_threat_start_time
			end
		end

		return "running"
	elseif attack_pattern_data.state == "ready" then
		local create_bot_threat_at_t = arg_6_2.create_bot_threat_at_t

		if not (not create_bot_threat_at_t and not (create_bot_threat_at_t < arg_6_3)) then
			self:_create_bot_aoe_threat(arg_6_1, action)

			arg_6_2.create_bot_threat_at_t = nil
		end

		if not arg_6_2.anim_cb_attack_shoot_random_shot then
			if arg_6_3 < warpfire_data.stop_firing_t then
				if not warpfire_data.is_firing then
					if not self:_init_attack(arg_6_1, target_unit, arg_6_2, action) then
						self:_attack_fire(arg_6_1, warpfire_data, action, arg_6_2, arg_6_3)

						arg_6_2.warpfire_face_timer = arg_6_3 + arg_6_2.target_dist * 0.08

						local var_6_7 = POSITION_LOOKUP[arg_6_1]
						local flat = Vector3.flat(POSITION_LOOKUP[target_unit] - var_6_7)
						local normalize = Vector3.normalize(flat)
						local flat_2 = Vector3.flat(Quaternion.forward(Unit.local_rotation(arg_6_1, 0)))
						local normalize_2 = Vector3.normalize(flat_2)
						local dot = Vector3.dot(normalize, normalize_2)

						if dot < 0 then
							arg_6_2.warpfire_face_timer = arg_6_2.warpfire_face_timer + math.abs(dot)
						end
					else
						return "done"
					end
				else
					if not (not self:_close_range_attack_check(arg_6_2, action, arg_6_3) and not arg_6_2.warpfire_face_timer and not (arg_6_3 > arg_6_2.warpfire_face_timer)) then
						self:_close_range_attack(arg_6_1, attack_pattern_data, arg_6_2, action, arg_6_3)
					end

					local _aim_at_target, var_6_14 = self:_aim_at_target(arg_6_1, target_unit, attack_pattern_data, arg_6_2, action, arg_6_3, arg_6_4)

					if not var_6_14 then
						arg_6_2.warpfire_face_timer = arg_6_3 + arg_6_2.target_dist * 0.08
					end

					if not _aim_at_target then
						return "done"
					end

					self:_move_warpfire_blob(arg_6_1, warpfire_data, arg_6_2, action, arg_6_4)

					return "running"
				end
			else
				return "done"
			end
		end
	end

	return "running"
end

BTWarpfireThrowerShootAction._move_warpfire_blob = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local blob_unit = arg_7_2.blob_unit
	local var_7_1 = POSITION_LOOKUP[blob_unit]

	if not blob_unit and not var_7_1 then
		local target_unit = arg_7_3.target_unit
		local target_dist = arg_7_3.target_dist
		local var_7_4 = POSITION_LOOKUP[target_unit]
		local var_7_5
		local var_7_6
		local close_attack_range = arg_7_4.close_attack_range
		local warpfire_follow_target_speed = arg_7_4.warpfire_follow_target_speed

		if close_attack_range < target_dist then
			var_7_5 = math.min(arg_7_5 * warpfire_follow_target_speed, 1)
			var_7_6 = var_7_4
		else
			var_7_5 = math.min(arg_7_5 * warpfire_follow_target_speed * 6, 1)

			local var_7_9 = POSITION_LOOKUP[arg_7_1]

			var_7_6 = var_7_9 + Vector3.normalize(var_7_4 - var_7_9) * close_attack_range
		end

		local lerp = Vector3.lerp(var_7_1, var_7_6, var_7_5)

		Unit.set_local_position(blob_unit, 0, lerp)
	end
end

BTWarpfireThrowerShootAction._end_align_towards_target = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	arg_8_3.state = "ready"
	arg_8_3.shoot_direction_start = nil
	arg_8_3.current_aim_rotation = QuaternionBox(Quaternion.look(arg_8_3.shoot_direction_box:unbox(), Vector3.up()))
	arg_8_2.stop_firing_t = arg_8_5 + arg_8_4.action.firing_time

	Managers.state.network:anim_event(arg_8_1, "attack_shoot_start")

	arg_8_4.close_attack_cooldown = 0
end

BTWarpfireThrowerShootAction._start_align_towards_target = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	arg_9_3.state = "align"
	arg_9_3.align_speed = 0
	arg_9_3.current_aim_rotation = nil
	arg_9_2.anim_cb_attack_shoot_random_shot = nil

	local action = arg_9_2.action
	local _calculate_wanted_target_position, var_9_2, var_9_3 = self:_calculate_wanted_target_position(arg_9_1, arg_9_4)
	local normalize = Vector3.normalize(Vector3.flat(_calculate_wanted_target_position - var_9_3))
	local world_rotation = Unit.world_rotation(arg_9_1, 0)
	local forward = Quaternion.forward(world_rotation)
	local right = Quaternion.right(world_rotation)
	local _calculate_align_animation = self:_calculate_align_animation(right, forward, normalize, action.attack_anims, var_9_3)

	Managers.state.network:anim_event(arg_9_1, _calculate_align_animation)
end

local pi = math.pi
local num = pi * 2
local num_2 = pi * 24
local num_3 = pi * 6
local num_4 = pi / 32
local num_5 = 0.7

BTWarpfireThrowerShootAction._remaining_angle = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local forward = Quaternion.forward(arg_10_1)
	local forward_2 = Quaternion.forward(arg_10_2)
	local atan2 = math.atan2(forward.y, forward.x)
	local atan2_2 = math.atan2(forward_2.y, forward_2.x)
	local var_10_4 = pi
	local num = var_10_4 * 2

	return ((atan2_2 - atan2) % num + var_10_4) % num - var_10_4
end

BTWarpfireThrowerShootAction._angle_to_speed = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	if arg_11_2 > 0 then
		return arg_11_1
	else
		return -arg_11_1
	end
end

BTWarpfireThrowerShootAction._update_align_towards_target = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local _calculate_wanted_target_position, var_12_1, var_12_2 = self:_calculate_wanted_target_position(arg_12_1, arg_12_4)
	local action = arg_12_2.action
	local local_rotation = Unit.local_rotation(arg_12_1, 0)
	local _remaining_angle = self:_remaining_angle(local_rotation, var_12_1)
	local _angle_to_speed = self:_angle_to_speed(action.rotation_speed, _remaining_angle)
	local align_speed = arg_12_3.align_speed

	if not (_angle_to_speed ~= 0 or not (align_speed > 0)) then
		align_speed = math.max(align_speed - num_3 * arg_12_5, 0)
	elseif not (_angle_to_speed ~= 0 or not (align_speed < 0)) then
		align_speed = math.min(align_speed + num_3 * arg_12_5, 0)
	elseif not (not (align_speed < _angle_to_speed) or not (_angle_to_speed > 0)) then
		align_speed = math.min(align_speed + num_2 * arg_12_5, _angle_to_speed)
	elseif not (not (_angle_to_speed < align_speed) or not (_angle_to_speed < 0)) then
		align_speed = math.max(align_speed - num_2 * arg_12_5, _angle_to_speed)
	elseif not (not (align_speed < _angle_to_speed) or not (_angle_to_speed < 0)) then
		align_speed = math.min(align_speed + num_3 * arg_12_5, _angle_to_speed)
	else
		align_speed = math.max(align_speed - num_2 * arg_12_5, _angle_to_speed)
	end

	arg_12_3.align_speed = align_speed

	local num = align_speed * arg_12_5
	local multiply = Quaternion.multiply(local_rotation, Quaternion(Vector3.up(), num))

	arg_12_2.locomotion_extension:set_wanted_rotation(multiply)

	local min = math.min(arg_12_5 * 3, 1)
	local lerp = Vector3.lerp(arg_12_3.shoot_direction_box:unbox(), Quaternion.forward(multiply), min)

	arg_12_3.shoot_direction_box:store(lerp)

	return math.abs(_remaining_angle) < num_4
end

BTWarpfireThrowerShootAction._close_range_attack_check = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	return not (arg_13_1.target_dist < arg_13_2.close_attack_range) or arg_13_3 > arg_13_1.close_attack_cooldown
end

BTWarpfireThrowerShootAction._close_range_attack = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local muzzle_node = arg_14_4.muzzle_node
	local warpfire_gun_unit = arg_14_2.warpfire_gun_unit
	local node = Unit.node(warpfire_gun_unit, muzzle_node)
	local world_position = Unit.world_position(warpfire_gun_unit, node)
	local var_14_4 = POSITION_LOOKUP[arg_14_3.target_unit]
	local flat = Vector3.flat(var_14_4 - world_position)
	local length = Vector3.length(flat)
	local warpfire_gun_unit_2 = arg_14_2.warpfire_gun_unit
	local flat_2 = Vector3.flat(Quaternion.forward(Unit.world_rotation(warpfire_gun_unit_2, node)))
	local normalize = Vector3.normalize(flat_2)
	local num = world_position + normalize * arg_14_4.close_attack_range
	local num_2 = world_position - normalize * 0.5
	local physics_world = arg_14_3.physics_world
	local hit_radius = arg_14_4.hit_radius
	local num_3 = 10
	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(physics_world, num_2, num, hit_radius, num_3, "collision_filter", "filter_character_trigger", "report_initial_overlap")
	local system = Managers.state.entity:system("buff_system")

	if not linear_sphere_sweep then
		local count = #linear_sphere_sweep

		for i = 1, count do
			local actor = linear_sphere_sweep[i].actor
			local unit = Actor.unit(actor)

			if unit ~= arg_14_1 then
				local is_enemy = DamageUtils.is_enemy(arg_14_3.target_unit, unit)
				local is_player_unit = DamageUtils.is_player_unit(unit)

				if not (is_enemy or is_player_unit) and not ScriptUnit.has_extension(unit, "buff_system") then
					local buff_name = arg_14_4.buff_name

					if not is_enemy and tbl[unit] or not HEALTH_ALIVE[unit] then
						local ai_push_data = arg_14_4.ai_push_data
						local stagger_impact = ai_push_data.stagger_impact
						local stagger_duration = ai_push_data.stagger_duration
						local stagger_distance = ai_push_data.stagger_distance
						local calculate_stagger, var_14_28 = DamageUtils.calculate_stagger(stagger_impact, stagger_duration, unit, arg_14_1)
						local var_14_29 = POSITION_LOOKUP[unit]
						local normalize_2 = Vector3.normalize(var_14_29 - num_2)
						local var_14_31 = BLACKBOARDS[unit]

						if calculate_stagger > scripts_utils_stagger_types.none then
							AiUtils.stagger(unit, var_14_31, arg_14_1, normalize_2, stagger_distance, calculate_stagger, var_14_28, nil, arg_14_5)
						end

						tbl[unit] = true
					end

					if not is_player_unit then
						local has_extension = ScriptUnit.has_extension(arg_14_3.target_unit, "status_system")
						local has_buff_perk = ScriptUnit.has_extension(arg_14_3.target_unit, "buff_system"):has_buff_perk("power_block")
						local is_blocking, var_14_35 = has_extension:is_blocking()
						local normalize_3 = Vector3.normalize(flat)
						local dot = Vector3.dot(normalize_3, normalize)
						local flag = dot > 0.99 or not (length < arg_14_4.aim_rotation_override_distance) or dot > 0.55

						if not flag and not has_buff_perk and not is_blocking and not var_14_35 then
							flag = not DamageUtils.check_ranged_block(arg_14_1, unit, "blocked_berzerker")
						end

						if not flag then
							system:add_buff(unit, buff_name, arg_14_1)
						end
					elseif not HEALTH_ALIVE[unit] then
						system:add_buff(unit, buff_name, arg_14_1)
					end
				end
			end
		end
	end

	arg_14_3.close_attack_cooldown = arg_14_5 + arg_14_4.close_attack_cooldown
end

BTWarpfireThrowerShootAction._aim_at_target = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
	-- function 15
	local _calculate_wanted_target_position, var_15_1, var_15_2, var_15_3 = self:_calculate_wanted_target_position(arg_15_1, arg_15_2)
	local has_extension = ScriptUnit.has_extension(arg_15_4.target_unit, "status_system")
	local flag = not has_extension and has_extension:get_is_dodging()
	local aim_rotation_override_distance = arg_15_5.aim_rotation_override_distance
	local aim_rotation_override_speed_multiplier = arg_15_5.aim_rotation_override_speed_multiplier
	local aim_rotation_dodge_multipler = arg_15_5.aim_rotation_dodge_multipler
	local var_15_9 = POSITION_LOOKUP[arg_15_1]
	local num = var_15_9 + Vector3(0, 0, num_5)
	local num_2 = _calculate_wanted_target_position - num
	local look = Quaternion.look(num_2, Vector3.up())
	local unbox = arg_15_3.current_aim_rotation:unbox()
	local distance = Vector3.distance(var_15_9, var_15_3)
	local flag_2 = (not (distance < aim_rotation_override_distance) or not aim_rotation_override_speed_multiplier or not flag) and (aim_rotation_dodge_multipler or math.max(1 - distance / arg_15_5.close_attack_range, 0.1))
	local num_3 = arg_15_5.radial_speed_upper_body_shooting * math.min(flag_2, aim_rotation_override_speed_multiplier)
	local _rotate_from_to = self:_rotate_from_to(unbox, look, num_3, arg_15_7)
	local num_4 = num + Quaternion.forward(_rotate_from_to) * Vector3.length(num_2)

	arg_15_3.current_aim_rotation:store(_rotate_from_to)

	local local_rotation = Unit.local_rotation(arg_15_1, 0)
	local _rotate_from_to_2 = self:_rotate_from_to(local_rotation, var_15_1, arg_15_5.radial_speed_feet_shooting, arg_15_7)

	arg_15_4.locomotion_extension:set_wanted_rotation(_rotate_from_to_2)
	arg_15_3.shoot_direction_box:store(num_4 - num)

	local physics_world = arg_15_4.physics_world

	PhysicsWorld.prepare_actors_for_raycast(physics_world, num, Vector3.normalize(num_4 - num), arg_15_5.spread)

	local flag_3 = false

	if arg_15_4.target_dist > arg_15_5.target_switch_distance then
		flag_3 = true
	elseif arg_15_6 > arg_15_4.line_of_sight_raycast_timer then
		local str = "filter_ai_line_of_sight_check"
		local num_6 = var_15_3 - var_15_9
		local immediate_raycast, var_15_26 = PhysicsWorld.immediate_raycast(physics_world, var_15_9 + Vector3.up(), Vector3.normalize(num_6), Vector3.length(num_6), "closest", "collision_filter", str)

		if not immediate_raycast then
			flag_3 = true
		end

		arg_15_4.line_of_sight_raycast_timer = arg_15_6 + 0.5
	end

	local flag_4 = false

	if arg_15_4.old_target_unit ~= arg_15_2 then
		flag_4 = true
		arg_15_4.old_target_unit = arg_15_2
	end

	return flag_3, flag_4
end

BTWarpfireThrowerShootAction._rotate_from_to = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local dot = Quaternion.dot(arg_16_2, arg_16_1)
	local num_2 = 2 * math.acos(math.clamp(dot, -1, 1))
	local num_3 = arg_16_3 * arg_16_4
	local flag

	flag = num_2 ~= 0 or not 1 or math.min(num_3 / num_2, 1)

	local abs = math.abs((num_2 % num + pi) % num - pi)

	return Quaternion.lerp(arg_16_1, arg_16_2, flag), math.max(abs - num_3, 0)
end

BTWarpfireThrowerShootAction._calculate_wanted_target_position = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local world_position = Unit.world_position(arg_17_1, Unit.node(arg_17_1, "c_spine"))
	local num = POSITION_LOOKUP[arg_17_2] + Vector3.up()
	local num_2 = world_position + (num - world_position) * 0.5
	local length = Vector3.length(num - world_position)

	num_2.z = num_2.z + length * 0.01

	if length < 2 then
		num_2 = num
	end

	local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_17_1, num_2)

	return num_2, look_at_position_flat, world_position, num
end

BTWarpfireThrowerShootAction._calculate_align_animation = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local dot = Vector3.dot(arg_18_1, arg_18_3)
	local dot_2 = Vector3.dot(arg_18_2, arg_18_3)
	local abs = math.abs(dot)
	local abs_2 = math.abs(dot_2)
	local var_18_4
	local flag = abs_2 < abs

	if not (not flag and not (dot > 0.5)) then
		var_18_4 = arg_18_4.right
	elseif not (not flag and not (dot < -0.5)) then
		var_18_4 = arg_18_4.left
	elseif dot_2 > 0 then
		var_18_4 = arg_18_4.fwd
	else
		var_18_4 = arg_18_4.bwd
	end

	return var_18_4
end

BTWarpfireThrowerShootAction._attack_fire = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	self:_create_warpfire_blob(arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)

	arg_19_2.is_firing = true
	arg_19_4.has_fired = true
end

BTWarpfireThrowerShootAction._create_warpfire_blob = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local attack_pattern_data = arg_20_4.attack_pattern_data
	local warpfire_data = arg_20_4.warpfire_data
	local warpfire_gun_unit = attack_pattern_data.warpfire_gun_unit
	local target_unit = arg_20_4.target_unit
	local var_20_4 = POSITION_LOOKUP[target_unit]
	local var_20_5 = POSITION_LOOKUP[arg_20_1]
	local tbl = {
		area_damage_system = {
			damage_blob_template_name = "warpfire",
			source_unit = arg_20_1
		}
	}
	local str = "units/hub_elements/empty"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "damage_blob_unit", tbl, var_20_4)
	local extension = ScriptUnit.extension(spawn_network_unit, "area_damage_system")

	warpfire_data.blob_unit = spawn_network_unit
	warpfire_data.blob_extension = extension

	local num = Vector3.length(var_20_4 - var_20_5) / 10

	extension:start_placing_blobs(num, arg_20_5)
end

BTWarpfireThrowerShootAction._calculate_cylinder_collision = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local bot_threat_radius = arg_21_1.bot_threat_radius
	local bot_threat_height = arg_21_1.bot_threat_height
	local bot_threat_offset_up = arg_21_1.bot_threat_offset_up
	local bot_threat_offset_forward = arg_21_1.bot_threat_offset_forward
	local num = bot_threat_height * 0.5
	local var_21_5 = Vector3(0, bot_threat_radius, num)
	local forward = Quaternion.forward(arg_21_3)
	local up = Quaternion.up(arg_21_3)

	return arg_21_2 + forward * bot_threat_offset_forward + up * (num + bot_threat_offset_up), var_21_5
end

BTWarpfireThrowerShootAction._create_bot_aoe_threat = function (self, arg_22_1, arg_22_2)
	-- function 22
	local var_22_0 = POSITION_LOOKUP[arg_22_1]
	local local_rotation = Unit.local_rotation(arg_22_1, 0)
	local bot_threat_duration = arg_22_2.bot_threat_duration
	local system = Managers.state.entity:system("ai_bot_group_system")
	local _calculate_cylinder_collision, var_22_5 = self:_calculate_cylinder_collision(arg_22_2, var_22_0, local_rotation)

	system:aoe_threat_created(_calculate_cylinder_collision, "cylinder", var_22_5, nil, bot_threat_duration, "Warpfire Shoot")
end
