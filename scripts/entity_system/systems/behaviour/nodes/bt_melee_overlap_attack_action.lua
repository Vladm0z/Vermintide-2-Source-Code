-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_melee_overlap_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

BTMeleeOverlapAttackAction = class(BTMeleeOverlapAttackAction, BTNode)

BTMeleeOverlapAttackAction.init = function (arg_1_0, ...)
	-- function 1
	BTMeleeOverlapAttackAction.super.init(arg_1_0, ...)
end

BTMeleeOverlapAttackAction.name = "BTMeleeOverlapAttackAction"

local dot = Vector3.dot

local function fn(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local num = arg_2_0 - arg_2_1
	local num_2 = arg_2_2 - arg_2_1
	local var_2_2 = dot(num, num_2)

	if var_2_2 <= 0 then
		return arg_2_1, var_2_2 < 0
	end

	local var_2_3 = dot(num_2, num_2)

	if var_2_3 <= var_2_2 then
		return arg_2_2, var_2_3 < var_2_2
	end

	return arg_2_1 + var_2_2 / var_2_3 * num_2, false
end

BTMeleeOverlapAttackAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTMeleeOverlapAttackAction
	arg_3_2.attack_token = true

	local override_target_unit = arg_3_2.override_target_unit

	override_target_unit = override_target_unit or arg_3_2.target_unit
	arg_3_2.locked_target_unit = override_target_unit

	if not self:_init_attack(arg_3_1, override_target_unit, arg_3_2, action_data, arg_3_3, 1) then
		arg_3_2.attack_finished = true
	else
		arg_3_2.attack_finished = false
	end

	arg_3_2.move_state = "attacking"
	arg_3_2.attack_aborted = false
	arg_3_2.keep_target = true
	arg_3_2.past_damage_in_attack = false

	local var_3_2 = Managers.state.side.side_by_unit[arg_3_1]

	if not (not var_3_2 and var_3_2.side_id == Managers.state.conflict.default_enemy_side_id) then
		local freeze_intensity_decay_time = arg_3_2.attack.freeze_intensity_decay_time

		freeze_intensity_decay_time = freeze_intensity_decay_time or 15

		if freeze_intensity_decay_time > 0 then
			Managers.state.conflict:freeze_intensity_decay(freeze_intensity_decay_time)
		end
	end

	AiUtils.add_attack_intensity(override_target_unit, action_data, arg_3_2)
end

local function fn_2(...)
	-- function 4
	if not script_data.debug_ai_attack then
		print("BTMeleeOverlapAttackAction:", ...)
	end
end

local function fn_3(self)
	-- function 5
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

local function fn_4(self, arg_6_1)
	-- function 6
	if type(self) == "table" then
		if not arg_6_1.attack_random_index then
			arg_6_1.attack_random_index = arg_6_1.attack_random_index % #self + 1
		else
			arg_6_1.attack_random_index = 1
		end

		return self[arg_6_1.attack_random_index]
	else
		return self
	end
end

BTMeleeOverlapAttackAction._init_attack = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	if not arg_7_3.last_combo_attack then
		arg_7_3.last_combo_attack = nil

		return false
	end

	local locomotion_extension = arg_7_3.locomotion_extension

	arg_7_3.target_unit_status_extension = ScriptUnit.has_extension(arg_7_2, "status_system")

	local var_7_1

	if not arg_7_4.running_attacks then
		local has_extension = ScriptUnit.has_extension(arg_7_2, "locomotion_system")
		local current_velocity

		if not has_extension then
			current_velocity = has_extension:current_velocity()

			if not current_velocity then
				-- Nothing
			end
		end

		current_velocity = Vector3.zero()

		::label_7_0::

		local target_running_velocity_threshold = arg_7_4.target_running_velocity_threshold
		local target_running_distance_threshold = arg_7_4.target_running_distance_threshold
		local num = POSITION_LOOKUP[arg_7_2] - POSITION_LOOKUP[arg_7_1]
		local length = Vector3.length(num)
		local normalize = Vector3.normalize(num)
		local dot = Vector3.dot(current_velocity, normalize)
		local flag = dot > 0.5
		local var_7_11

		if not target_running_distance_threshold then
			var_7_11 = target_running_distance_threshold < length
		else
			var_7_11 = not (target_running_velocity_threshold < dot) or flag
		end

		local self_running_speed_threshold = arg_7_4.self_running_speed_threshold

		if not (not self_running_speed_threshold and var_7_11) then
			local current_velocity_2 = locomotion_extension:current_velocity()

			var_7_1 = Vector3.length_squared(current_velocity_2) > self_running_speed_threshold^2
		else
			var_7_1 = var_7_11
		end
	end

	local running_attacks

	if not var_7_1 then
		running_attacks = arg_7_4.running_attacks

		if not running_attacks then
			-- Nothing
		end
	end

	running_attacks = arg_7_4.attacks

	::label_7_1::

	local var_7_15

	if not arg_7_4.is_combo_attack then
		var_7_15 = running_attacks[arg_7_6 or arg_7_3.next_combo_index]
		arg_7_3.next_combo_index = var_7_15.next_combo_index

		if not arg_7_3.next_combo_index then
			arg_7_3.last_combo_attack = true
		end
	else
		var_7_15 = fn_3(running_attacks)
	end

	local anim_driven = var_7_15.anim_driven
	local rotation_time = var_7_15.rotation_time
	local var_7_18
	local var_7_19

	if not var_7_15.multi_attack_anims then
		local var_7_20 = POSITION_LOOKUP[arg_7_2]

		var_7_18 = AiAnimUtils.get_start_move_animation(arg_7_1, var_7_20, var_7_15.multi_attack_anims)

		if not (not var_7_18 and var_7_18 ~= var_7_15.multi_attack_anims.fwd) then
			anim_driven = false
			var_7_18 = var_7_15.multi_attack_anims.fwd
		else
			local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_7_1, var_7_20, var_7_18, var_7_15.multi_anims_data)

			LocomotionUtils.set_animation_rotation_scale(arg_7_1, get_animation_rotation_scale)

			anim_driven = true
			rotation_time = 0
		end
	else
		var_7_18 = fn_4(var_7_15.attack_anim, arg_7_3)
	end

	if not var_7_15.enable_nav_extension then
		local navigation_extension = arg_7_3.navigation_extension

		navigation_extension:stop()
		navigation_extension:set_enabled(false)
		locomotion_extension:set_wanted_velocity_flat(Vector3.zero())
	end

	arg_7_3.anim_locked = arg_7_5 + var_7_15.attack_time
	arg_7_3.attack = var_7_15
	arg_7_3.attack_anim_driven = anim_driven
	arg_7_3.attack_rotation_update_timer = arg_7_5 + rotation_time
	arg_7_3.attacking_target = arg_7_2
	arg_7_3.attack_started_at_t = arg_7_5

	local physics_world = arg_7_3.physics_world

	physics_world = physics_world or World.get_data(arg_7_3.world, "physics_world")
	arg_7_3.physics_world = physics_world
	arg_7_3.anim_cb_damage_triggered_this_attack = nil

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_2)

	arg_7_3.attack_rotation = QuaternionBox(rotation_towards_unit_flat)

	local animation_translation_scale = var_7_15.animation_translation_scale

	if not anim_driven and not animation_translation_scale then
		LocomotionUtils.set_animation_translation_scale(arg_7_1, Vector3(animation_translation_scale, animation_translation_scale, animation_translation_scale))
	end

	local flag_2 = true
	local flag_3 = rotation_time > 0

	if not (not anim_driven and not var_7_15.blend_time and arg_7_3.attack_blend_end_t) then
		arg_7_3.attack_blend_end_t = arg_7_5 + var_7_15.blend_time
	else
		LocomotionUtils.set_animation_driven_movement(arg_7_1, anim_driven, flag_2, flag_3)
	end

	locomotion_extension:use_lerp_rotation(not anim_driven)

	arg_7_3.chosen_attack_anim = var_7_18

	Managers.state.network:anim_event(arg_7_1, var_7_18)

	local continious_overlap = var_7_15.continious_overlap

	if not continious_overlap then
		local var_7_29 = continious_overlap[var_7_18]
		local var_7_30

		if not var_7_29.use_inventory_unit then
			local default_inventory_template = arg_7_3.breed.default_inventory_template

			var_7_30 = ScriptUnit.extension(arg_7_1, "ai_inventory_system"):get_unit(default_inventory_template)
		end

		local flag_4 = var_7_30 or arg_7_1
		local base_node_name = var_7_29.base_node_name
		local node = Unit.node(flag_4, base_node_name)
		local tip_node_name = var_7_29.tip_node_name
		local node_2 = Unit.node(flag_4, tip_node_name)
		local continous_overlap_data = arg_7_3.continous_overlap_data

		continous_overlap_data = continous_overlap_data or {}
		arg_7_3.continous_overlap_data = continous_overlap_data

		local continous_overlap_data_2 = arg_7_3.continous_overlap_data

		continous_overlap_data_2.weapon_unit = flag_4
		continous_overlap_data_2.start_time = arg_7_5 + var_7_29.start_time
		continous_overlap_data_2.base_node = node
		continous_overlap_data_2.tip_node = node_2
		continous_overlap_data_2.hit_units = {
			[arg_7_1] = true
		}
		continous_overlap_data_2.perform_overlap = true
	end

	local wall_collision = var_7_15.wall_collision

	if not wall_collision then
		local wall_collision_data = arg_7_3.wall_collision_data

		wall_collision_data = wall_collision_data or {}
		arg_7_3.wall_collision_data = wall_collision_data

		local wall_collision_data_2 = arg_7_3.wall_collision_data

		wall_collision_data_2.animation = wall_collision.animation
		wall_collision_data_2.stun_time = wall_collision.stun_time
		wall_collision_data_2.check_range = wall_collision.check_range
		wall_collision_data_2.check_time = arg_7_5 + wall_collision.start_check_time
		wall_collision_data_2.perform_check = true
	end

	local push_units_in_the_way = var_7_15.push_units_in_the_way

	if not push_units_in_the_way then
		self:push_close_units(arg_7_1, arg_7_3, arg_7_5, push_units_in_the_way)
	end

	local flag_5 = false
	local bot_threats = var_7_15.bot_threats

	if not bot_threats then
		bot_threats = var_7_15.bot_threats[var_7_18]

		if not bot_threats then
			bot_threats = var_7_15.bot_threats[1]
			bot_threats = not bot_threats and var_7_15.bot_threats
		end
	end

	if not bot_threats then
		local num_2 = 1
		local var_7_46 = bot_threats[num_2]
		local calculate_bot_threat_time, var_7_48 = AiUtils.calculate_bot_threat_time(var_7_46)

		arg_7_3.create_bot_threat_at_t = arg_7_5 + calculate_bot_threat_time
		arg_7_3.current_bot_threat_index = num_2
		arg_7_3.bot_threat_duration = var_7_48
		arg_7_3.bot_threats_data = bot_threats

		for i = 1, #bot_threats do
			if not (bot_threats[i].collision_type == nil or bot_threats[i].collision_type ~= "oobb") then
				flag_5 = true

				break
			end
		end
	end

	arg_7_3.has_any_oobb_threat = flag_5

	local damage_done_time = var_7_15.damage_done_time

	if not damage_done_time then
		if type(damage_done_time) == "table" then
			arg_7_3.damage_done_time = arg_7_5 + damage_done_time[var_7_18]
		else
			arg_7_3.damage_done_time = arg_7_5 + damage_done_time
		end
	end

	local lock_attack_time = var_7_15.lock_attack_time

	if not lock_attack_time then
		arg_7_3.attack_locked_in_t = arg_7_5 + lock_attack_time
	end

	if not arg_7_3.breed.use_backstab_vo then
		self:_backstab_sound(arg_7_1, arg_7_3)
	end

	return true
end

BTMeleeOverlapAttackAction.leave = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local locomotion_extension = arg_8_2.locomotion_extension

	if not arg_8_5 then
		if not arg_8_2.attack.enable_nav_extension then
			locomotion_extension:set_rotation_speed(nil)
			arg_8_2.navigation_extension:set_enabled(true)
		else
			arg_8_2.navigation_extension:reset_destination()
		end

		local wall_collision_data = arg_8_2.wall_collision_data

		if not arg_8_2.attack_anim_driven then
			LocomotionUtils.set_animation_rotation_scale(arg_8_1, 1)
			LocomotionUtils.set_animation_driven_movement(arg_8_1, false)
			locomotion_extension:use_lerp_rotation(true)

			local flag = not wall_collision_data and wall_collision_data.is_stunned

			if arg_8_2.attack.animation_translation_scale or not flag then
				LocomotionUtils.set_animation_translation_scale(arg_8_1, Vector3(1, 1, 1))
			end
		end

		if not wall_collision_data then
			table.clear(wall_collision_data)
		end
	end

	arg_8_2.action = nil
	arg_8_2.active_node = nil
	arg_8_2.attack_token = nil
	arg_8_2.anim_locked = nil
	arg_8_2.attack = nil
	arg_8_2.attack_anim_driven = nil
	arg_8_2.attack_rotation = nil
	arg_8_2.attack_rotation_update_timer = nil
	arg_8_2.attacking_target = nil
	arg_8_2.attack_started_at_t = nil
	arg_8_2.keep_target = nil
	arg_8_2.target_unit_status_extension = nil
	arg_8_2.last_combo_attack = nil
	arg_8_2.create_bot_threat_at_t = nil
	arg_8_2.current_bot_threat_index = nil
	arg_8_2.bot_threats_data = nil
	arg_8_2.bot_threat_duration = nil
	arg_8_2.has_any_oobb_threat = nil
	arg_8_2.damage_done_time = nil
	arg_8_2.attack_finished = nil
	arg_8_2.attack_aborted = nil
	arg_8_2.locked_target_unit = nil
	arg_8_2.past_damage_in_attack = nil
	arg_8_2.attack_locked_in_t = nil
	arg_8_2.backstab_attack_trigger = nil
	arg_8_2.attack_blend_end_t = nil
	arg_8_2.anim_cb_damage_triggered_this_attack = nil
	arg_8_2.chosen_attack_anim = nil

	if not arg_8_2.continous_overlap_data then
		table.clear(arg_8_2.continous_overlap_data)
	end
end

BTMeleeOverlapAttackAction._attack_finished = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local action = arg_9_2.action

	if not action.is_combo_attack and not ALIVE[arg_9_2.locked_target_unit] then
		return not self:_init_attack(arg_9_1, arg_9_2.locked_target_unit, arg_9_2, action, arg_9_3)
	end

	return true
end

BTMeleeOverlapAttackAction._calculate_cylinder_collision = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local radius = arg_10_2.radius

	radius = radius or arg_10_1.radius

	local height = arg_10_2.height

	height = height or arg_10_1.height

	local offset_up = arg_10_2.offset_up

	offset_up = offset_up or arg_10_1.offset_up

	local offset_forward = arg_10_2.offset_forward

	offset_forward = offset_forward or arg_10_1.offset_forward

	local offset_right = arg_10_2.offset_right

	if not offset_right then
		offset_right = arg_10_1.offset_right
		offset_right = offset_right or 0
	end

	local num = height * 0.5
	local var_10_6 = Vector3(0, radius, num)
	local forward = Quaternion.forward(arg_10_4)
	local up = Quaternion.up(arg_10_4)
	local right = Quaternion.right(arg_10_4)
	local num_2 = arg_10_3 + forward * offset_forward + up * (num + offset_up) + right * offset_right
	local look = Quaternion.look(up, Vector3.up())

	return num_2, look, var_10_6
end

BTMeleeOverlapAttackAction._calculate_oobb_collision = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local range = arg_11_2.range

	range = range or arg_11_1.range

	local height = arg_11_2.height

	height = height or arg_11_1.height

	local width = arg_11_2.width

	width = width or arg_11_1.width

	local offset_up = arg_11_2.offset_up

	offset_up = offset_up or arg_11_1.offset_up

	local offset_forward = arg_11_2.offset_forward

	offset_forward = offset_forward or arg_11_1.offset_forward

	local num = width * 0.5
	local num_2 = range * 0.5
	local num_3 = height * 0.5
	local var_11_8 = Vector3(num, num_2, num_3)
	local num_4 = Quaternion.rotate(arg_11_4, Vector3.forward()) * (offset_forward + num_2)
	local num_5 = Vector3.up() * (offset_up + num_3)

	return arg_11_3 + num_4 + num_5, arg_11_4, var_11_8
end

BTMeleeOverlapAttackAction._create_bot_aoe_threat = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local var_12_0 = POSITION_LOOKUP[arg_12_1]
	local system = Managers.state.entity:system("ai_bot_group_system")

	if arg_12_4.collision_type == "cylinder" then
		local _calculate_cylinder_collision, var_12_3, var_12_4 = self:_calculate_cylinder_collision(arg_12_3, arg_12_4, var_12_0, arg_12_2)

		system:aoe_threat_created(_calculate_cylinder_collision, "cylinder", var_12_4, nil, arg_12_5, "Melee Overlap")
	elseif not (arg_12_4.collision_type == "oobb" or arg_12_4.collision_type) then
		local _calculate_oobb_collision, var_12_6, var_12_7 = self:_calculate_oobb_collision(arg_12_3, arg_12_4, var_12_0, arg_12_2)

		system:aoe_threat_created(_calculate_oobb_collision, "oobb", var_12_7, var_12_6, arg_12_5, "Melee Overlap")
	end
end

BTMeleeOverlapAttackAction._check_wall_collision = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local num = 1
	local num_2 = 1
	local nav_world = arg_13_2.nav_world
	local var_13_3 = POSITION_LOOKUP[arg_13_1]
	local triangle_from_position, var_13_5 = GwNavQueries.triangle_from_position(nav_world, var_13_3, num, num_2)

	if not triangle_from_position then
		return true
	end

	local current_velocity = arg_13_2.locomotion_extension:current_velocity()
	local length = Vector3.length(current_velocity)
	local var_13_8

	if length > 0.01 then
		var_13_8 = Vector3.normalize(current_velocity)
	else
		local local_rotation = Unit.local_rotation(arg_13_1, 0)

		var_13_8 = Quaternion.forward(local_rotation)
	end

	local num_3 = var_13_3 + var_13_8 * (arg_13_3 + arg_13_4 * length)
	local triangle_from_position_2, var_13_12 = GwNavQueries.triangle_from_position(nav_world, num_3, num, num_2)

	if not triangle_from_position_2 then
		return true
	end

	local var_13_13 = Vector3(var_13_3.x, var_13_3.y, var_13_5)
	local var_13_14 = Vector3(num_3.x, num_3.y, var_13_12)

	return not GwNavQueries.raycango(nav_world, var_13_13, var_13_14)
end

BTMeleeOverlapAttackAction.run = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	if not ALIVE[arg_14_2.locked_target_unit] and not arg_14_2.attack_aborted then
		if not (not arg_14_2.attack_locked_in_t and not (arg_14_3 <= arg_14_2.attack_locked_in_t)) then
			return "running"
		else
			return "done"
		end
	end

	if not (not arg_14_2.attack_blend_end_t and not (arg_14_3 > arg_14_2.attack_blend_end_t)) then
		local attack = arg_14_2.attack
		local rotation_time = attack.rotation_time

		rotation_time = not rotation_time and attack.rotation_time > 0
		arg_14_2.attack_blend_end_t = nil
		arg_14_2.attack_rotation_update_timer = attack.rotation_time + arg_14_3

		LocomotionUtils.set_animation_driven_movement(arg_14_1, true, true, rotation_time)
	end

	if arg_14_3 <= arg_14_2.anim_locked then
		local attack_2 = arg_14_2.attack

		if not arg_14_2.attack_rotation_update_timer then
			local locomotion_extension = arg_14_2.locomotion_extension
			local target_unit_status_extension = arg_14_2.target_unit_status_extension
			local flag = not target_unit_status_extension and Managers.player:owner(target_unit_status_extension.unit)

			if not (not (arg_14_3 < arg_14_2.attack_rotation_update_timer) or not target_unit_status_extension or target_unit_status_extension:is_invisible() or attack_2.ignores_dodging or not target_unit_status_extension:get_is_dodging() or not flag or flag:is_player_controlled() or not arg_14_2.has_any_oobb_threat or not (arg_14_3 < arg_14_2.create_bot_threat_at_t)) then
				local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_14_1, arg_14_2.locked_target_unit)
				local rotation_speed = attack_2.rotation_speed

				if not rotation_speed then
					locomotion_extension:use_lerp_rotation(true)
					locomotion_extension:set_rotation_speed(rotation_speed)
				end

				locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
				arg_14_2.attack_rotation:store(Unit.local_rotation(arg_14_1, 0))
			else
				arg_14_2.attack_rotation_update_timer = nil

				locomotion_extension:set_wanted_rotation(Unit.local_rotation(arg_14_1, 0))

				if not (not arg_14_2.attack_anim_driven and arg_14_2.attack_blend_end_t) then
					locomotion_extension:set_animation_driven(true, true, false)
				end
			end
		end

		local continous_overlap_data = arg_14_2.continous_overlap_data

		if not (not arg_14_2.damage_done_time and not (arg_14_3 > arg_14_2.damage_done_time) or not continous_overlap_data or continous_overlap_data.perform_overlap) then
			arg_14_2.attacking_target = nil
			arg_14_2.damage_done_time = nil
		end

		local wall_collision_data = arg_14_2.wall_collision_data

		if not wall_collision_data then
			if not wall_collision_data.is_stunned then
				return "running"
			elseif not wall_collision_data.perform_check and not (arg_14_3 > wall_collision_data.check_time) or not self:_check_wall_collision(arg_14_1, arg_14_2, wall_collision_data.check_range, arg_14_4) then
				arg_14_2.anim_locked = arg_14_3 + wall_collision_data.stun_time
				arg_14_2.attacking_target = nil
				wall_collision_data.is_stunned = true

				Managers.state.network:anim_event(arg_14_1, fn_3(wall_collision_data.animation))
				LocomotionUtils.set_animation_translation_scale(arg_14_1, Vector3.zero())
			end
		end

		local push_units_in_the_way_continuous = attack_2.push_units_in_the_way_continuous

		if not push_units_in_the_way_continuous then
			self:push_close_units(arg_14_1, arg_14_2, arg_14_3, push_units_in_the_way_continuous)
		end

		local create_bot_threat_at_t = arg_14_2.create_bot_threat_at_t

		if not (not create_bot_threat_at_t and not (create_bot_threat_at_t < arg_14_3)) then
			local unbox = arg_14_2.attack_rotation:unbox()
			local bot_threats_data = arg_14_2.bot_threats_data
			local current_bot_threat_index = arg_14_2.current_bot_threat_index
			local var_14_15 = bot_threats_data[current_bot_threat_index]
			local bot_threat_duration = arg_14_2.bot_threat_duration

			self:_create_bot_aoe_threat(arg_14_1, unbox, attack_2, var_14_15, bot_threat_duration)

			local num = current_bot_threat_index + 1
			local var_14_18 = bot_threats_data[num]

			if not var_14_18 then
				local attack_started_at_t = arg_14_2.attack_started_at_t
				local calculate_bot_threat_time, var_14_21 = AiUtils.calculate_bot_threat_time(var_14_18)

				arg_14_2.create_bot_threat_at_t = attack_started_at_t + calculate_bot_threat_time
				arg_14_2.bot_threat_duration = var_14_21
				arg_14_2.current_bot_threat_index = num
			else
				arg_14_2.create_bot_threat_at_t = nil
				arg_14_2.bot_threat_duration = nil
				arg_14_2.current_bot_threat_index = nil
			end
		end

		if not (not continous_overlap_data and not continous_overlap_data.perform_overlap and not (arg_14_3 > continous_overlap_data.start_time)) then
			local action = arg_14_2.action
			local physics_world = arg_14_2.physics_world

			self:weapon_sweep_overlap(arg_14_1, arg_14_2, action, attack_2, continous_overlap_data, physics_world, arg_14_3, arg_14_4)
		end

		if not arg_14_2.attack_locked_in_t and not (arg_14_3 >= arg_14_2.attack_locked_in_t) or not arg_14_2.attack_finished then
			arg_14_2.attack_finished = false

			if not self:_attack_finished(arg_14_1, arg_14_2, arg_14_3, arg_14_4) then
				return "done"
			end
		end

		return "running"
	elseif not arg_14_2.attack_locked_in_t and not (arg_14_3 >= arg_14_2.attack_locked_in_t) or not self:_attack_finished(arg_14_1, arg_14_2, arg_14_3, arg_14_4) then
		return "done"
	end
end

BTMeleeOverlapAttackAction.push_player = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local var_15_0 = POSITION_LOOKUP[arg_15_1]
	local num = POSITION_LOOKUP[arg_15_2] - var_15_0
	local num_2 = arg_15_3 * Vector3.normalize(num)

	if not arg_15_4 then
		Vector3.set_z(num_2, arg_15_4)
	end

	if not arg_15_5 then
		StatusUtils.set_catapulted_network(arg_15_2, true, num_2)
	else
		ScriptUnit.extension(arg_15_2, "locomotion_system"):add_external_velocity(num_2)
	end
end

BTMeleeOverlapAttackAction.hit_player = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	-- function 16
	local has_extension = ScriptUnit.has_extension(arg_16_3, "status_system")
	local attack_directions = arg_16_4.attack_directions

	attack_directions = not attack_directions and arg_16_4.attack_directions[arg_16_2.attack_anim]

	local flag = false

	if not DamageUtils.check_block(arg_16_1, arg_16_3, arg_16_4.fatigue_type, attack_directions) then
		if not arg_16_4.ignore_shield_block then
			local check_ranged_block = DamageUtils.check_ranged_block
			local var_16_4 = arg_16_1
			local var_16_5 = arg_16_3
			local shield_blocked_fatigue_type = arg_16_4.shield_blocked_fatigue_type

			shield_blocked_fatigue_type = shield_blocked_fatigue_type or "shield_blocked_slam"

			if not check_ranged_block(var_16_4, var_16_5, shield_blocked_fatigue_type) then
				self:push_player(arg_16_1, arg_16_3, arg_16_5.player_push_speed_blocked, arg_16_5.player_push_speed_blocked_z, false)

				goto label_16_0
			end
		end

		if not arg_16_4.blocked_damage then
			AiUtils.damage_target(arg_16_3, arg_16_1, arg_16_4, arg_16_4.blocked_damage)

			flag = true
		end

		if not (not arg_16_5.player_push_speed_blocked and has_extension.knocked_down) then
			self:push_player(arg_16_1, arg_16_3, arg_16_5.player_push_speed_blocked, arg_16_5.player_push_speed_blocked_z, arg_16_5.catapult_player)
		end
	else
		AiUtils.damage_target(arg_16_3, arg_16_1, arg_16_4, arg_16_4.damage)

		flag = true

		if not (not arg_16_5.player_push_speed and has_extension.knocked_down) then
			self:push_player(arg_16_1, arg_16_3, arg_16_5.player_push_speed, arg_16_5.player_push_speed_z, arg_16_5.catapult_player)
		end
	end

	::label_16_0::

	if not arg_16_5.hit_player_func then
		arg_16_5.hit_player_func(arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, flag)
	end
end

BTMeleeOverlapAttackAction.hit_ai = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	-- function 17
	local push_ai = arg_17_4.push_ai
	local immune_breeds = arg_17_4.immune_breeds
	local damage_target_only = arg_17_4.damage_target_only
	local var_17_3 = BLACKBOARDS[arg_17_2]

	if not var_17_3.is_illusion then
		return
	end

	if not immune_breeds then
		local breed = var_17_3.breed

		breed = not breed and var_17_3.breed.name

		if not immune_breeds[breed] then
			return
		end
	end

	if not push_ai then
		local calculate_stagger, var_17_6 = DamageUtils.calculate_stagger(push_ai.stagger_impact, push_ai.stagger_duration, arg_17_2, arg_17_1)

		if calculate_stagger > 0 then
			local var_17_7 = POSITION_LOOKUP[arg_17_1]
			local var_17_8 = POSITION_LOOKUP[arg_17_2]
			local normalize = Vector3.normalize(var_17_8 - var_17_7)
			local flag = true
			local flag_2 = not arg_17_5.commander_unit

			AiUtils.stagger(arg_17_2, var_17_3, arg_17_1, normalize, push_ai.stagger_distance, calculate_stagger, var_17_6, nil, arg_17_6, nil, nil, nil, flag_2)
		end
	end

	if not (arg_17_2 == arg_17_5.attacking_target or arg_17_3.ignore_ai_damage) then
		AiUtils.damage_target(arg_17_2, arg_17_1, arg_17_3, arg_17_3.damage)
	end

	if not arg_17_4.hit_ai_func then
		arg_17_4.hit_ai_func(arg_17_1, arg_17_5, arg_17_2, arg_17_3, arg_17_4)
	end

	if not arg_17_3.hit_ai_func then
		arg_17_3.hit_ai_func(arg_17_1, arg_17_5, arg_17_2, arg_17_3, arg_17_4)
	end
end

BTMeleeOverlapAttackAction.anim_cb_frenzy_damage = function (self, arg_18_1, arg_18_2)
	-- function 18
	self:anim_cb_damage(arg_18_1, arg_18_2)
end

BTMeleeOverlapAttackAction.anim_cb_damage = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not arg_19_2.attacking_target then
		return
	end

	local action = arg_19_2.action
	local attack = arg_19_2.attack

	arg_19_2.anim_cb_damage_triggered_this_attack = true

	local width = attack.width
	local range = attack.range
	local height = attack.height
	local offset_up = attack.offset_up
	local offset_forward = attack.offset_forward
	local num = width * 0.5
	local num_2 = range * 0.5
	local num_3 = height * 0.5
	local var_19_10 = Vector3(num, num_2, num_3)
	local local_rotation = Unit.local_rotation(arg_19_1, 0)
	local num_4 = Quaternion.rotate(local_rotation, Vector3.forward()) * (offset_forward + num_2)
	local var_19_13 = POSITION_LOOKUP[arg_19_1]
	local num_5 = Vector3.up() * (offset_up + num_3)
	local num_6 = var_19_13 + num_4 + num_5
	local time = Managers.time:time("game")
	local physics_world = arg_19_2.physics_world
	local max = math.max(range, math.max(height, width))
	local alloc_table = FrameTable.alloc_table()

	alloc_table[arg_19_1] = true

	self:overlap_checks(arg_19_1, arg_19_2, physics_world, time, action, attack, num_6, local_rotation, var_19_10, alloc_table, max)

	local push_units_in_the_way = attack.push_units_in_the_way

	if not attack.push_close_units_during_attack and not push_units_in_the_way then
		self:push_close_units(arg_19_1, arg_19_2, time, push_units_in_the_way)
	end

	arg_19_2.past_damage_in_attack = (not not attack.triggers_anim_cb_damage_multiple_times or not action.is_combo_attack) and arg_19_2.last_combo_attack
end

BTMeleeOverlapAttackAction.push_close_units = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	local local_rotation = Unit.local_rotation(arg_20_1, 0)
	local forward = Quaternion.forward(local_rotation)
	local num = POSITION_LOOKUP[arg_20_1] + forward * arg_20_4.push_forward_offset
	local ahead_dist = arg_20_4.ahead_dist
	local num_2 = num + forward * ahead_dist
	local num_3 = math.max(arg_20_4.push_width, ahead_dist) * 1.5
	local num_4 = num_3 * num_3
	local alloc_table = FrameTable.alloc_table()
	local broadphase_query = AiUtils.broadphase_query(num, num_3, alloc_table)
	local num_5 = arg_20_4.push_width^2
	local BLACKBOARDS = BLACKBOARDS

	for i = 1, broadphase_query do
		local var_20_11 = alloc_table[i]

		if var_20_11 ~= arg_20_1 then
			local var_20_12 = POSITION_LOOKUP[var_20_11]
			local var_20_13, var_20_14 = fn(var_20_12, num, num_2)
			local num_6 = var_20_12 - var_20_13

			if not (var_20_14 or not (num_5 > Vector3.length_squared(num_6))) then
				local calculate_stagger, var_20_17 = DamageUtils.calculate_stagger(arg_20_4.push_stagger_impact, arg_20_4.push_stagger_duration, var_20_11, arg_20_1)

				if calculate_stagger > scripts_utils_stagger_types.none then
					local normalize = Vector3.normalize(num_6)
					local var_20_19 = BLACKBOARDS[var_20_11]

					AiUtils.stagger(var_20_11, var_20_19, arg_20_1, normalize, arg_20_4.push_stagger_distance, calculate_stagger, var_20_17, nil, arg_20_3)
				end
			end
		end
	end

	local ENEMY_PLAYER_AND_BOT_UNITS = arg_20_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for j = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_20_21 = ENEMY_PLAYER_AND_BOT_UNITS[j]
		local var_20_22 = POSITION_LOOKUP[var_20_21]
		local num_7 = var_20_22 - num

		if num_4 > Vector3.length_squared(num_7) then
			local var_20_24, var_20_25 = fn(var_20_22, num, num_2)
			local num_8 = var_20_22 - var_20_24

			if not (var_20_25 or not (num_5 > Vector3.length_squared(num_8)) or ScriptUnit.has_extension(var_20_21, "status_system").knocked_down) then
				local num_9 = arg_20_4.player_pushed_speed * Vector3.normalize(num_7)

				ScriptUnit.extension(var_20_21, "locomotion_system"):add_external_velocity(num_9)
			end
		end
	end
end

BTMeleeOverlapAttackAction.weapon_sweep_overlap = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	-- function 21
	if not arg_21_2.is_illusion then
		return
	end

	local weapon_unit = arg_21_5.weapon_unit
	local var_21_1
	local tip_node = arg_21_5.tip_node
	local world_position = Unit.world_position(weapon_unit, tip_node)

	if not arg_21_5.tip_node_pos then
		var_21_1 = arg_21_5.tip_node_pos:unbox() - world_position

		arg_21_5.tip_node_pos:store(world_position)
	else
		var_21_1 = Vector3.zero()
		arg_21_5.tip_node_pos = Vector3Box(world_position)
	end

	local length = Vector3.length(var_21_1)
	local base_node = arg_21_5.base_node
	local world_position_2 = Unit.world_position(arg_21_5.weapon_unit, base_node)
	local num = arg_21_4.width + length
	local range = arg_21_4.range
	local height = arg_21_4.height
	local offset_up = arg_21_4.offset_up
	local offset_forward = arg_21_4.offset_forward
	local num_2 = num * 0.5
	local num_3 = range * 0.5
	local num_4 = height * 0.5
	local var_21_15 = Vector3(num_2, num_3, num_4)
	local var_21_16
	local num_5 = world_position - world_position_2
	local var_21_18
	local var_21_19

	if base_node == tip_node then
		var_21_16 = Unit.local_rotation(weapon_unit, base_node)
		var_21_18 = Quaternion.up(var_21_16) * (offset_up + num_4)
		var_21_19 = Quaternion.forward(var_21_16) * (offset_forward + num_3)
	else
		var_21_16 = Quaternion.look(num_5, Vector3.up())
		var_21_18 = Quaternion.up(var_21_16) * offset_up
		var_21_19 = Quaternion.forward(var_21_16) * offset_forward
	end

	local num_6 = world_position_2 + num_5 * 0.5 + var_21_18 + var_21_19 + var_21_1 * 0.5
	local max = math.max(range, math.max(height, num))
	local hit_units = arg_21_5.hit_units
	local overlap_checks = self:overlap_checks(arg_21_1, arg_21_2, arg_21_6, arg_21_7, arg_21_3, arg_21_4, num_6, var_21_16, var_21_15, hit_units, max)

	if not (arg_21_4.hit_multiple_targets or not (overlap_checks > 0)) then
		arg_21_5.perform_overlap = false
	end
end

local tbl = {
	mode = "retained",
	name = "BTMeleeOverlapAttackAction"
}

BTMeleeOverlapAttackAction.overlap_checks = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11)
	-- function 22
	if not arg_22_2.is_illusion then
		return 0
	end

	local flag

	flag = not arg_22_6.hit_only_players and "filter_player_hit_box_check" and "filter_player_and_enemy_hit_box_check"

	PhysicsWorld.prepare_actors_for_overlap(arg_22_3, arg_22_7, arg_22_11)

	local immediate_overlap, var_22_2 = PhysicsWorld.immediate_overlap(arg_22_3, "position", arg_22_7, "rotation", arg_22_8, "size", arg_22_9, "shape", "oobb", "types", "dynamics", "collision_filter", flag)

	if not Development.parameter("debug_weapons") then
		local drawer = Managers.state.debug:drawer(tbl)

		drawer:reset()

		local from_quaternion_position = Matrix4x4.from_quaternion_position(arg_22_8, arg_22_7)

		drawer:box(from_quaternion_position, arg_22_9)
	end

	local var_22_5 = POSITION_LOOKUP[arg_22_1]
	local local_rotation = Unit.local_rotation(arg_22_1, 0)
	local forward = Quaternion.forward(local_rotation)
	local hit_multiple_targets = arg_22_6.hit_multiple_targets
	local damage_target_only = arg_22_6.damage_target_only
	local num = 0
	local allow_friendly_fire = arg_22_5.allow_friendly_fire
	local side = Managers.state.side

	for i = 1, var_22_2 do
		local var_22_13 = immediate_overlap[i]
		local flag_2 = not var_22_13 and Actor.unit(var_22_13)

		if not (not Unit.alive(flag_2) and arg_22_10[flag_2]) then
			local var_22_15 = POSITION_LOOKUP[flag_2]

			if not var_22_15 then
				local flag_3 = true

				if not allow_friendly_fire then
					flag_3 = Managers.state.side:is_enemy(arg_22_1, flag_2)
				end

				if not flag_3 then
					local normalize = Vector3.normalize(var_22_15 - var_22_5)

					if not (not arg_22_6.ignore_targets_behind and not (Vector3.dot(normalize, forward) > 0)) then
						if not Managers.player:owner(flag_2) then
							self:hit_player(arg_22_1, arg_22_2, flag_2, arg_22_5, arg_22_6)

							arg_22_10[flag_2] = true
							num = num + 1

							if not hit_multiple_targets then
								break
							end
						elseif not Unit.has_data(flag_2, "breed") then
							self:hit_ai(arg_22_1, flag_2, arg_22_5, arg_22_6, arg_22_2, arg_22_4)

							arg_22_10[flag_2] = true
							num = num + 1

							if not hit_multiple_targets then
								break
							end
						end
					end
				end
			else
				print("BTMeleeOverlapAttackAction: HIT UNIT MISSING POSITION_LOOKUP ENTRY!", flag_2)
			end
		end
	end

	return num
end

BTMeleeOverlapAttackAction.anim_cb_attack_overlap_done = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	arg_23_2.continous_overlap_data.perform_overlap = nil
end

BTMeleeOverlapAttackAction.anim_cb_attack_grabbed_smash = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	local action = arg_24_2.action

	AiUtils.damage_target(arg_24_2.victim_grabbed, arg_24_1, action, action.damage)
end

BTMeleeOverlapAttackAction._backstab_sound = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local breed = arg_25_2.breed
	local locked_target_unit = arg_25_2.locked_target_unit

	if not (not arg_25_2.target_unit_status_extension and locked_target_unit) then
		return
	end

	local unit_owner = Managers.player:unit_owner(locked_target_unit)

	if not unit_owner and not unit_owner.bot_player then
		return
	end

	if not AiUtils.unit_is_flanking_player(arg_25_1, locked_target_unit) then
		return
	end

	if not unit_owner.local_player then
		local extension = ScriptUnit.extension(arg_25_1, "dialogue_system")
		local make_unit_auto_source, var_25_5 = WwiseUtils.make_unit_auto_source(arg_25_2.world, arg_25_1, extension.voice_node)
		local backstab_player_sound_event = breed.backstab_player_sound_event

		Managers.state.entity:system("audio_system"):_play_event_with_source(var_25_5, backstab_player_sound_event, make_unit_auto_source)
	else
		local network = Managers.state.network
		local network_transmit = network.network_transmit
		local unit_game_object_id = network:unit_game_object_id(arg_25_1)
		local network_id = unit_owner:network_id()

		network_transmit:send_rpc("rpc_check_trigger_backstab_sfx", network_id, unit_game_object_id)
	end

	arg_25_2.backstab_attack_trigger = true
end
