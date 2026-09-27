-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_melee_slam_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMeleeSlamAction = class(BTMeleeSlamAction, BTNode)

BTMeleeSlamAction.init = function (arg_1_0, ...)
	-- function 1
	BTMeleeSlamAction.super.init(arg_1_0, ...)
end

BTMeleeSlamAction.name = "BTMeleeSlamAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTMeleeSlamAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTMeleeSlamAction

	self:init_attack(arg_3_1, arg_3_2, action_data, arg_3_3)

	arg_3_2.attack_cooldown = arg_3_3 + action_data.cooldown
	arg_3_2.anim_locked = arg_3_3 + action_data.attack_time
	arg_3_2.move_state = "attacking"
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.keep_target = true
	arg_3_2.rotate_towards_target = true

	Managers.state.conflict:freeze_intensity_decay(15)

	local target_unit = arg_3_2.target_unit

	AiUtils.add_attack_intensity(target_unit, action_data, arg_3_2)
end

BTMeleeSlamAction.init_attack = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local get_attack_anim, var_4_1 = LocomotionUtils.get_attack_anim(arg_4_1, arg_4_2, arg_4_3.attack_anims)

	var_4_1 = var_4_1 or arg_4_3.anim_driven or false
	arg_4_2.attack_anim_driven = var_4_1

	LocomotionUtils.set_animation_driven_movement(arg_4_1, var_4_1, false, false)

	if not var_4_1 then
		arg_4_2.locomotion_extension:use_lerp_rotation(false)
	else
		arg_4_2.navigation_extension:stop()
	end

	local var_4_2 = fn(get_attack_anim or arg_4_3.attack_anim)

	Managers.state.network:anim_event(arg_4_1, var_4_2)

	local target_unit = arg_4_2.target_unit

	arg_4_2.attacking_target = target_unit
	arg_4_2.attack_started_at_t = arg_4_4

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, target_unit)

	arg_4_2.attack_rotation = QuaternionBox(rotation_towards_unit_flat)

	local bot_threats = arg_4_3.bot_threats

	if not bot_threats then
		bot_threats = arg_4_3.bot_threats[var_4_2]

		if not bot_threats then
			bot_threats = arg_4_3.bot_threats[1]
			bot_threats = not bot_threats and arg_4_3.bot_threats
		end
	end

	if not bot_threats then
		local num = 1

		arg_4_2.create_bot_threat_at_t = arg_4_4 + bot_threats[num].start_time
		arg_4_2.current_bot_threat_index = num
		arg_4_2.bot_threats_data = bot_threats
	end
end

BTMeleeSlamAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if not (not arg_5_2.attack_anim_driven and arg_5_5) then
		local locomotion_extension = arg_5_2.locomotion_extension

		LocomotionUtils.set_animation_driven_movement(arg_5_1, false)
		locomotion_extension:use_lerp_rotation(true)
	end

	arg_5_2.attack_anim_driven = nil
	arg_5_2.action = nil
	arg_5_2.active_node = nil
	arg_5_2.attack_rotation = nil
	arg_5_2.attacking_target = nil
	arg_5_2.attack_started_at_t = nil
	arg_5_2.keep_target = nil
	arg_5_2.create_bot_threat_at_t = nil
	arg_5_2.current_bot_threat_index = nil
	arg_5_2.bot_threats_data = nil
	arg_5_2.attack_aborted = nil
	arg_5_2.rotate_towards_target = nil
end

BTMeleeSlamAction._calculate_collision = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local height = arg_6_1.height
	local num = arg_6_2 + arg_6_3 * arg_6_1.forward_offset + Vector3(0, 0, height * 0.5)
	local var_6_2 = Vector3(arg_6_1.radius, height, arg_6_1.radius)
	local look = Quaternion.look(Vector3.up(), Vector3.up())

	return num, look, var_6_2
end

BTMeleeSlamAction._calculate_cylinder_collision = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local radius = arg_7_2.radius

	radius = radius or arg_7_1.radius

	local height = arg_7_2.height

	height = height or arg_7_1.height

	local offset_forward = arg_7_2.offset_forward

	offset_forward = offset_forward or arg_7_1.forward_offset

	local num = height * 0.5
	local var_7_4 = Vector3(0, radius, num)
	local forward = Quaternion.forward(arg_7_4)
	local up = Quaternion.up(arg_7_4)
	local num_2 = arg_7_3 + forward * offset_forward + up * num
	local look = Quaternion.look(up, Vector3.up())

	return num_2, look, var_7_4
end

BTMeleeSlamAction._create_bot_aoe_threat = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local duration = arg_8_4.duration
	local var_8_1 = POSITION_LOOKUP[arg_8_1]
	local system = Managers.state.entity:system("ai_bot_group_system")
	local _calculate_cylinder_collision, var_8_4, var_8_5 = self:_calculate_cylinder_collision(arg_8_3, arg_8_4, var_8_1, arg_8_2)

	system:aoe_threat_created(_calculate_cylinder_collision, "cylinder", var_8_5, nil, duration, "Melee Slam")
end

BTMeleeSlamAction.anim_cb_damage = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not arg_9_2.is_illusion then
		arg_9_2.rotate_towards_target = false

		return
	end

	local world = arg_9_2.world
	local get_data = World.get_data(world, "physics_world")
	local action = arg_9_2.action
	local forward = Quaternion.forward(Unit.local_rotation(arg_9_1, 0))
	local var_9_4 = POSITION_LOOKUP[arg_9_1]
	local _calculate_collision, var_9_6, var_9_7 = self:_calculate_collision(action, var_9_4, forward)
	local flag

	flag = not (var_9_7.y - var_9_7.x > 0) or not "capsule" or "sphere"

	PhysicsWorld.prepare_actors_for_overlap(get_data, _calculate_collision, math.max(action.radius, action.height))

	local immediate_overlap, var_9_10 = PhysicsWorld.immediate_overlap(get_data, "shape", flag, "position", _calculate_collision, "rotation", var_9_6, "size", var_9_7, "types", "both", "collision_filter", "filter_rat_ogre_melee_slam")
	local time = Managers.time:time("game")
	local alloc_table = FrameTable.alloc_table()

	for i = 1, var_9_10 do
		local var_9_13 = immediate_overlap[i]
		local unit = Actor.unit(var_9_13)

		if not (unit == arg_9_1 or alloc_table[unit]) then
			local var_9_15
			local has_extension = ScriptUnit.has_extension(unit, "status_system")

			if not has_extension then
				local var_9_17
				local flat = Vector3.flat(POSITION_LOOKUP[unit] - _calculate_collision)

				if not (not has_extension.is_dodging and not (Vector3.length_squared(flat) > action.dodge_mitigation_radius_squared)) then
					var_9_17 = true
				end

				if not var_9_17 then
					local attack_directions = action.attack_directions

					attack_directions = not attack_directions and action.attack_directions[arg_9_2.attack_anim]

					if not has_extension:is_disabled() then
						var_9_15 = action.damage
					else
						local check_ranged_block = DamageUtils.check_ranged_block
						local var_9_21 = arg_9_1
						local var_9_22 = unit
						local shield_blocked_fatigue_type = action.shield_blocked_fatigue_type

						shield_blocked_fatigue_type = shield_blocked_fatigue_type or "shield_blocked_slam"

						if not check_ranged_block(var_9_21, var_9_22, shield_blocked_fatigue_type) then
							local num = action.player_push_speed_blocked * Vector3.normalize(POSITION_LOOKUP[unit] - var_9_4)

							ScriptUnit.extension(unit, "locomotion_system"):add_external_velocity(num)
						elseif not DamageUtils.check_block(arg_9_1, unit, action.fatigue_type, attack_directions) then
							local num_2 = action.player_push_speed_blocked * Vector3.normalize(POSITION_LOOKUP[unit] - var_9_4)

							ScriptUnit.extension(unit, "locomotion_system"):add_external_velocity(num_2)

							var_9_15 = action.blocked_damage
						else
							var_9_15 = action.damage
						end
					end
				end

				if not action.hit_player_func and not var_9_15 then
					action.hit_player_func(arg_9_1, arg_9_2, unit, var_9_15)
				end
			elseif not Unit.has_data(unit, "breed") then
				local flat_2 = Vector3.flat(POSITION_LOOKUP[unit] - var_9_4)
				local var_9_27

				if Vector3.length_squared(flat_2) < 0.0001 then
					var_9_27 = forward
				else
					var_9_27 = Vector3.normalize(flat_2)
				end

				AiUtils.stagger_target(arg_9_1, unit, action.stagger_distance, action.stagger_impact, var_9_27, time)

				var_9_15 = action.damage

				if not BLACKBOARDS[unit].is_illusion then
					var_9_15 = nil
				end
			elseif not ScriptUnit.has_extension(unit, "ladder_system") then
				ScriptUnit.extension(unit, "ladder_system"):shake()
			end

			if not var_9_15 then
				AiUtils.damage_target(unit, arg_9_1, action, var_9_15)
			end

			alloc_table[unit] = true
		end
	end

	arg_9_2.rotate_towards_target = false
end

BTMeleeSlamAction.run = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local attacking_target = arg_10_2.attacking_target

	if (arg_10_2.attack_finished or not Unit.alive(attacking_target)) and not arg_10_2.attack_aborted then
		return "done"
	end

	if arg_10_3 < arg_10_2.anim_locked then
		if arg_10_2.attack_anim_driven or not arg_10_2.rotate_towards_target then
			local locomotion_extension = arg_10_2.locomotion_extension
			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_10_1, attacking_target)

			locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
			arg_10_2.attack_rotation:store(rotation_towards_unit_flat)
		end

		local create_bot_threat_at_t = arg_10_2.create_bot_threat_at_t

		if not (not create_bot_threat_at_t and not (create_bot_threat_at_t < arg_10_3)) then
			local unbox = arg_10_2.attack_rotation:unbox()
			local action = arg_10_2.action
			local bot_threats_data = arg_10_2.bot_threats_data
			local current_bot_threat_index = arg_10_2.current_bot_threat_index
			local var_10_8 = bot_threats_data[current_bot_threat_index]

			self:_create_bot_aoe_threat(arg_10_1, unbox, action, var_10_8)

			local num = current_bot_threat_index + 1
			local var_10_10 = bot_threats_data[num]

			if not var_10_10 then
				arg_10_2.create_bot_threat_at_t = arg_10_2.attack_started_at_t + var_10_10.start_time
				arg_10_2.current_bot_threat_index = num
			else
				arg_10_2.create_bot_threat_at_t = nil
				arg_10_2.current_bot_threat_index = nil
			end
		end

		return "running"
	end

	return "done"
end
