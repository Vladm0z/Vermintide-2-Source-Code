-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_melee_overlap_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = require("scripts/utils/stagger_types")

BTMeleeOverlapAttackAction = class(BTMeleeOverlapAttackAction, BTNode)

BTMeleeOverlapAttackAction.init = function (arg_1_0, ...)
	BTMeleeOverlapAttackAction.super.init(arg_1_0, ...)
end

BTMeleeOverlapAttackAction.name = "BTMeleeOverlapAttackAction"

local var_0_1 = Vector3.dot

local function var_0_2(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0 - arg_2_1
	local var_2_1 = arg_2_2 - arg_2_1
	local var_2_2 = var_0_1(var_2_0, var_2_1)

	if var_2_2 <= 0 then
		return arg_2_1, var_2_2 < 0
	end

	local var_2_3 = var_0_1(var_2_1, var_2_1)

	if var_2_3 <= var_2_2 then
		return arg_2_2, var_2_3 < var_2_2
	end

	return arg_2_1 + var_2_2 / var_2_3 * var_2_1, false
end

BTMeleeOverlapAttackAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTMeleeOverlapAttackAction
	arg_3_2.attack_token = true

	local var_3_1 = arg_3_2.override_target_unit or arg_3_2.target_unit

	arg_3_2.locked_target_unit = var_3_1

	if not arg_3_0:_init_attack(arg_3_1, var_3_1, arg_3_2, var_3_0, arg_3_3, 1) then
		arg_3_2.attack_finished = true
	else
		arg_3_2.attack_finished = false
	end

	arg_3_2.move_state = "attacking"
	arg_3_2.attack_aborted = false
	arg_3_2.keep_target = true
	arg_3_2.past_damage_in_attack = false

	local var_3_2 = Managers.state.side.side_by_unit[arg_3_1]

	if var_3_2 and var_3_2.side_id == Managers.state.conflict.default_enemy_side_id then
		local var_3_3 = arg_3_2.attack.freeze_intensity_decay_time or 15

		if var_3_3 > 0 then
			Managers.state.conflict:freeze_intensity_decay(var_3_3)
		end
	end

	AiUtils.add_attack_intensity(var_3_1, var_3_0, arg_3_2)
end

local function var_0_3(...)
	if script_data.debug_ai_attack then
		print("BTMeleeOverlapAttackAction:", ...)
	end
end

local function var_0_4(arg_5_0)
	if type(arg_5_0) == "table" then
		return arg_5_0[Math.random(1, #arg_5_0)]
	else
		return arg_5_0
	end
end

local function var_0_5(arg_6_0, arg_6_1)
	if type(arg_6_0) == "table" then
		if arg_6_1.attack_random_index then
			arg_6_1.attack_random_index = arg_6_1.attack_random_index % #arg_6_0 + 1
		else
			arg_6_1.attack_random_index = 1
		end

		return arg_6_0[arg_6_1.attack_random_index]
	else
		return arg_6_0
	end
end

BTMeleeOverlapAttackAction._init_attack = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	if arg_7_3.last_combo_attack then
		arg_7_3.last_combo_attack = nil

		return false
	end

	local var_7_0 = arg_7_3.locomotion_extension

	arg_7_3.target_unit_status_extension = ScriptUnit.has_extension(arg_7_2, "status_system")

	local var_7_1

	if arg_7_4.running_attacks then
		local var_7_2 = ScriptUnit.has_extension(arg_7_2, "locomotion_system")
		local var_7_3 = var_7_2 and var_7_2:current_velocity() or Vector3.zero()
		local var_7_4 = arg_7_4.target_running_velocity_threshold
		local var_7_5 = arg_7_4.target_running_distance_threshold
		local var_7_6 = POSITION_LOOKUP[arg_7_2] - POSITION_LOOKUP[arg_7_1]
		local var_7_7 = Vector3.length(var_7_6)
		local var_7_8 = Vector3.normalize(var_7_6)
		local var_7_9 = Vector3.dot(var_7_3, var_7_8)
		local var_7_10 = var_7_9 > 0.5
		local var_7_11

		if var_7_5 then
			var_7_11 = var_7_5 < var_7_7
		else
			var_7_11 = var_7_4 < var_7_9 and var_7_10
		end

		local var_7_12 = arg_7_4.self_running_speed_threshold

		if var_7_12 and not var_7_11 then
			local var_7_13 = var_7_0:current_velocity()

			var_7_1 = Vector3.length_squared(var_7_13) > var_7_12^2
		else
			var_7_1 = var_7_11
		end
	end

	local var_7_14 = var_7_1 and arg_7_4.running_attacks or arg_7_4.attacks
	local var_7_15

	if arg_7_4.is_combo_attack then
		var_7_15 = var_7_14[arg_7_6 or arg_7_3.next_combo_index]
		arg_7_3.next_combo_index = var_7_15.next_combo_index

		if not arg_7_3.next_combo_index then
			arg_7_3.last_combo_attack = true
		end
	else
		var_7_15 = var_0_4(var_7_14)
	end

	local var_7_16 = var_7_15.anim_driven
	local var_7_17 = var_7_15.rotation_time
	local var_7_18
	local var_7_19

	if var_7_15.multi_attack_anims then
		local var_7_20 = POSITION_LOOKUP[arg_7_2]

		var_7_18 = AiAnimUtils.get_start_move_animation(arg_7_1, var_7_20, var_7_15.multi_attack_anims)

		if not var_7_18 or var_7_18 == var_7_15.multi_attack_anims.fwd then
			var_7_16 = false
			var_7_18 = var_7_15.multi_attack_anims.fwd
		else
			local var_7_21 = AiAnimUtils.get_animation_rotation_scale(arg_7_1, var_7_20, var_7_18, var_7_15.multi_anims_data)

			LocomotionUtils.set_animation_rotation_scale(arg_7_1, var_7_21)

			var_7_16 = true
			var_7_17 = 0
		end
	else
		var_7_18 = var_0_5(var_7_15.attack_anim, arg_7_3)
	end

	if not var_7_15.enable_nav_extension then
		local var_7_22 = arg_7_3.navigation_extension

		var_7_22:stop()
		var_7_22:set_enabled(false)
		var_7_0:set_wanted_velocity_flat(Vector3.zero())
	end

	arg_7_3.anim_locked = arg_7_5 + var_7_15.attack_time
	arg_7_3.attack = var_7_15
	arg_7_3.attack_anim_driven = var_7_16
	arg_7_3.attack_rotation_update_timer = arg_7_5 + var_7_17
	arg_7_3.attacking_target = arg_7_2
	arg_7_3.attack_started_at_t = arg_7_5
	arg_7_3.physics_world = arg_7_3.physics_world or World.get_data(arg_7_3.world, "physics_world")
	arg_7_3.anim_cb_damage_triggered_this_attack = nil

	local var_7_23 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_2)

	arg_7_3.attack_rotation = QuaternionBox(var_7_23)

	local var_7_24 = var_7_15.animation_translation_scale

	if var_7_16 and var_7_24 then
		LocomotionUtils.set_animation_translation_scale(arg_7_1, Vector3(var_7_24, var_7_24, var_7_24))
	end

	local var_7_25 = true
	local var_7_26 = var_7_17 > 0

	if var_7_16 and var_7_15.blend_time and not arg_7_3.attack_blend_end_t then
		arg_7_3.attack_blend_end_t = arg_7_5 + var_7_15.blend_time
	else
		LocomotionUtils.set_animation_driven_movement(arg_7_1, var_7_16, var_7_25, var_7_26)
	end

	var_7_0:use_lerp_rotation(not var_7_16)

	arg_7_3.chosen_attack_anim = var_7_18

	Managers.state.network:anim_event(arg_7_1, var_7_18)

	local var_7_27 = var_7_15.continious_overlap

	if var_7_27 then
		local var_7_28 = var_7_27[var_7_18]
		local var_7_29

		if var_7_28.use_inventory_unit then
			local var_7_30 = arg_7_3.breed.default_inventory_template

			var_7_29 = ScriptUnit.extension(arg_7_1, "ai_inventory_system"):get_unit(var_7_30)
		end

		local var_7_31 = var_7_29 or arg_7_1
		local var_7_32 = var_7_28.base_node_name
		local var_7_33 = Unit.node(var_7_31, var_7_32)
		local var_7_34 = var_7_28.tip_node_name
		local var_7_35 = Unit.node(var_7_31, var_7_34)

		arg_7_3.continous_overlap_data = arg_7_3.continous_overlap_data or {}

		local var_7_36 = arg_7_3.continous_overlap_data

		var_7_36.weapon_unit = var_7_31
		var_7_36.start_time = arg_7_5 + var_7_28.start_time
		var_7_36.base_node = var_7_33
		var_7_36.tip_node = var_7_35
		var_7_36.hit_units = {
			[arg_7_1] = true
		}
		var_7_36.perform_overlap = true
	end

	local var_7_37 = var_7_15.wall_collision

	if var_7_37 then
		arg_7_3.wall_collision_data = arg_7_3.wall_collision_data or {}

		local var_7_38 = arg_7_3.wall_collision_data

		var_7_38.animation = var_7_37.animation
		var_7_38.stun_time = var_7_37.stun_time
		var_7_38.check_range = var_7_37.check_range
		var_7_38.check_time = arg_7_5 + var_7_37.start_check_time
		var_7_38.perform_check = true
	end

	local var_7_39 = var_7_15.push_units_in_the_way

	if var_7_39 then
		arg_7_0:push_close_units(arg_7_1, arg_7_3, arg_7_5, var_7_39)
	end

	local var_7_40 = false
	local var_7_41 = var_7_15.bot_threats and (var_7_15.bot_threats[var_7_18] or var_7_15.bot_threats[1] and var_7_15.bot_threats)

	if var_7_41 then
		local var_7_42 = 1
		local var_7_43 = var_7_41[var_7_42]
		local var_7_44, var_7_45 = AiUtils.calculate_bot_threat_time(var_7_43)

		arg_7_3.create_bot_threat_at_t = arg_7_5 + var_7_44
		arg_7_3.current_bot_threat_index = var_7_42
		arg_7_3.bot_threat_duration = var_7_45
		arg_7_3.bot_threats_data = var_7_41

		for iter_7_0 = 1, #var_7_41 do
			if var_7_41[iter_7_0].collision_type == nil or var_7_41[iter_7_0].collision_type == "oobb" then
				var_7_40 = true

				break
			end
		end
	end

	arg_7_3.has_any_oobb_threat = var_7_40

	local var_7_46 = var_7_15.damage_done_time

	if var_7_46 then
		if type(var_7_46) == "table" then
			arg_7_3.damage_done_time = arg_7_5 + var_7_46[var_7_18]
		else
			arg_7_3.damage_done_time = arg_7_5 + var_7_46
		end
	end

	local var_7_47 = var_7_15.lock_attack_time

	if var_7_47 then
		arg_7_3.attack_locked_in_t = arg_7_5 + var_7_47
	end

	if arg_7_3.breed.use_backstab_vo then
		arg_7_0:_backstab_sound(arg_7_1, arg_7_3)
	end

	return true
end

BTMeleeOverlapAttackAction.leave = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_2.locomotion_extension

	if not arg_8_5 then
		if not arg_8_2.attack.enable_nav_extension then
			var_8_0:set_rotation_speed(nil)
			arg_8_2.navigation_extension:set_enabled(true)
		else
			arg_8_2.navigation_extension:reset_destination()
		end

		local var_8_1 = arg_8_2.wall_collision_data

		if arg_8_2.attack_anim_driven then
			LocomotionUtils.set_animation_rotation_scale(arg_8_1, 1)
			LocomotionUtils.set_animation_driven_movement(arg_8_1, false)
			var_8_0:use_lerp_rotation(true)

			local var_8_2 = var_8_1 and var_8_1.is_stunned

			if arg_8_2.attack.animation_translation_scale or var_8_2 then
				LocomotionUtils.set_animation_translation_scale(arg_8_1, Vector3(1, 1, 1))
			end
		end

		if var_8_1 then
			table.clear(var_8_1)
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

	if arg_8_2.continous_overlap_data then
		table.clear(arg_8_2.continous_overlap_data)
	end
end

BTMeleeOverlapAttackAction._attack_finished = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_2.action

	if var_9_0.is_combo_attack and ALIVE[arg_9_2.locked_target_unit] then
		return not arg_9_0:_init_attack(arg_9_1, arg_9_2.locked_target_unit, arg_9_2, var_9_0, arg_9_3)
	end

	return true
end

BTMeleeOverlapAttackAction._calculate_cylinder_collision = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2.radius or arg_10_1.radius
	local var_10_1 = arg_10_2.height or arg_10_1.height
	local var_10_2 = arg_10_2.offset_up or arg_10_1.offset_up
	local var_10_3 = arg_10_2.offset_forward or arg_10_1.offset_forward
	local var_10_4 = arg_10_2.offset_right or arg_10_1.offset_right or 0
	local var_10_5 = var_10_1 * 0.5
	local var_10_6 = Vector3(0, var_10_0, var_10_5)
	local var_10_7 = Quaternion.forward(arg_10_4)
	local var_10_8 = Quaternion.up(arg_10_4)
	local var_10_9 = Quaternion.right(arg_10_4)
	local var_10_10 = arg_10_3 + var_10_7 * var_10_3 + var_10_8 * (var_10_5 + var_10_2) + var_10_9 * var_10_4
	local var_10_11 = Quaternion.look(var_10_8, Vector3.up())

	return var_10_10, var_10_11, var_10_6
end

BTMeleeOverlapAttackAction._calculate_oobb_collision = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_2.range or arg_11_1.range
	local var_11_1 = arg_11_2.height or arg_11_1.height
	local var_11_2 = arg_11_2.width or arg_11_1.width
	local var_11_3 = arg_11_2.offset_up or arg_11_1.offset_up
	local var_11_4 = arg_11_2.offset_forward or arg_11_1.offset_forward
	local var_11_5 = var_11_2 * 0.5
	local var_11_6 = var_11_0 * 0.5
	local var_11_7 = var_11_1 * 0.5
	local var_11_8 = Vector3(var_11_5, var_11_6, var_11_7)
	local var_11_9 = Quaternion.rotate(arg_11_4, Vector3.forward()) * (var_11_4 + var_11_6)
	local var_11_10 = Vector3.up() * (var_11_3 + var_11_7)

	return arg_11_3 + var_11_9 + var_11_10, arg_11_4, var_11_8
end

BTMeleeOverlapAttackAction._create_bot_aoe_threat = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = POSITION_LOOKUP[arg_12_1]
	local var_12_1 = Managers.state.entity:system("ai_bot_group_system")

	if arg_12_4.collision_type == "cylinder" then
		local var_12_2, var_12_3, var_12_4 = arg_12_0:_calculate_cylinder_collision(arg_12_3, arg_12_4, var_12_0, arg_12_2)

		var_12_1:aoe_threat_created(var_12_2, "cylinder", var_12_4, nil, arg_12_5, "Melee Overlap")
	elseif arg_12_4.collision_type == "oobb" or not arg_12_4.collision_type then
		local var_12_5, var_12_6, var_12_7 = arg_12_0:_calculate_oobb_collision(arg_12_3, arg_12_4, var_12_0, arg_12_2)

		var_12_1:aoe_threat_created(var_12_5, "oobb", var_12_7, var_12_6, arg_12_5, "Melee Overlap")
	end
end

BTMeleeOverlapAttackAction._check_wall_collision = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = 1
	local var_13_1 = 1
	local var_13_2 = arg_13_2.nav_world
	local var_13_3 = POSITION_LOOKUP[arg_13_1]
	local var_13_4, var_13_5 = GwNavQueries.triangle_from_position(var_13_2, var_13_3, var_13_0, var_13_1)

	if not var_13_4 then
		return true
	end

	local var_13_6 = arg_13_2.locomotion_extension:current_velocity()
	local var_13_7 = Vector3.length(var_13_6)
	local var_13_8

	if var_13_7 > 0.01 then
		var_13_8 = Vector3.normalize(var_13_6)
	else
		local var_13_9 = Unit.local_rotation(arg_13_1, 0)

		var_13_8 = Quaternion.forward(var_13_9)
	end

	local var_13_10 = var_13_3 + var_13_8 * (arg_13_3 + arg_13_4 * var_13_7)
	local var_13_11, var_13_12 = GwNavQueries.triangle_from_position(var_13_2, var_13_10, var_13_0, var_13_1)

	if not var_13_11 then
		return true
	end

	local var_13_13 = Vector3(var_13_3.x, var_13_3.y, var_13_5)
	local var_13_14 = Vector3(var_13_10.x, var_13_10.y, var_13_12)

	return not GwNavQueries.raycango(var_13_2, var_13_13, var_13_14)
end

BTMeleeOverlapAttackAction.run = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if not ALIVE[arg_14_2.locked_target_unit] or arg_14_2.attack_aborted then
		if arg_14_2.attack_locked_in_t and arg_14_3 <= arg_14_2.attack_locked_in_t then
			return "running"
		else
			return "done"
		end
	end

	if arg_14_2.attack_blend_end_t and arg_14_3 > arg_14_2.attack_blend_end_t then
		local var_14_0 = arg_14_2.attack
		local var_14_1 = var_14_0.rotation_time and var_14_0.rotation_time > 0

		arg_14_2.attack_blend_end_t = nil
		arg_14_2.attack_rotation_update_timer = var_14_0.rotation_time + arg_14_3

		LocomotionUtils.set_animation_driven_movement(arg_14_1, true, true, var_14_1)
	end

	if arg_14_3 <= arg_14_2.anim_locked then
		local var_14_2 = arg_14_2.attack

		if arg_14_2.attack_rotation_update_timer then
			local var_14_3 = arg_14_2.locomotion_extension
			local var_14_4 = arg_14_2.target_unit_status_extension
			local var_14_5 = var_14_4 and Managers.player:owner(var_14_4.unit)

			if arg_14_3 < arg_14_2.attack_rotation_update_timer and (not var_14_4 or not var_14_4:is_invisible() and (var_14_2.ignores_dodging or not var_14_4:get_is_dodging()) and (not var_14_5 or var_14_5:is_player_controlled() or not arg_14_2.has_any_oobb_threat or arg_14_3 < arg_14_2.create_bot_threat_at_t)) then
				local var_14_6 = LocomotionUtils.rotation_towards_unit_flat(arg_14_1, arg_14_2.locked_target_unit)
				local var_14_7 = var_14_2.rotation_speed

				if var_14_7 then
					var_14_3:use_lerp_rotation(true)
					var_14_3:set_rotation_speed(var_14_7)
				end

				var_14_3:set_wanted_rotation(var_14_6)
				arg_14_2.attack_rotation:store(Unit.local_rotation(arg_14_1, 0))
			else
				arg_14_2.attack_rotation_update_timer = nil

				var_14_3:set_wanted_rotation(Unit.local_rotation(arg_14_1, 0))

				if arg_14_2.attack_anim_driven and not arg_14_2.attack_blend_end_t then
					var_14_3:set_animation_driven(true, true, false)
				end
			end
		end

		local var_14_8 = arg_14_2.continous_overlap_data

		if arg_14_2.damage_done_time and arg_14_3 > arg_14_2.damage_done_time and (not var_14_8 or not var_14_8.perform_overlap) then
			arg_14_2.attacking_target = nil
			arg_14_2.damage_done_time = nil
		end

		local var_14_9 = arg_14_2.wall_collision_data

		if var_14_9 then
			if var_14_9.is_stunned then
				return "running"
			elseif var_14_9.perform_check and arg_14_3 > var_14_9.check_time and arg_14_0:_check_wall_collision(arg_14_1, arg_14_2, var_14_9.check_range, arg_14_4) then
				arg_14_2.anim_locked = arg_14_3 + var_14_9.stun_time
				arg_14_2.attacking_target = nil
				var_14_9.is_stunned = true

				Managers.state.network:anim_event(arg_14_1, var_0_4(var_14_9.animation))
				LocomotionUtils.set_animation_translation_scale(arg_14_1, Vector3.zero())
			end
		end

		local var_14_10 = var_14_2.push_units_in_the_way_continuous

		if var_14_10 then
			arg_14_0:push_close_units(arg_14_1, arg_14_2, arg_14_3, var_14_10)
		end

		local var_14_11 = arg_14_2.create_bot_threat_at_t

		if var_14_11 and var_14_11 < arg_14_3 then
			local var_14_12 = arg_14_2.attack_rotation:unbox()
			local var_14_13 = arg_14_2.bot_threats_data
			local var_14_14 = arg_14_2.current_bot_threat_index
			local var_14_15 = var_14_13[var_14_14]
			local var_14_16 = arg_14_2.bot_threat_duration

			arg_14_0:_create_bot_aoe_threat(arg_14_1, var_14_12, var_14_2, var_14_15, var_14_16)

			local var_14_17 = var_14_14 + 1
			local var_14_18 = var_14_13[var_14_17]

			if var_14_18 then
				local var_14_19 = arg_14_2.attack_started_at_t
				local var_14_20, var_14_21 = AiUtils.calculate_bot_threat_time(var_14_18)

				arg_14_2.create_bot_threat_at_t = var_14_19 + var_14_20
				arg_14_2.bot_threat_duration = var_14_21
				arg_14_2.current_bot_threat_index = var_14_17
			else
				arg_14_2.create_bot_threat_at_t = nil
				arg_14_2.bot_threat_duration = nil
				arg_14_2.current_bot_threat_index = nil
			end
		end

		if var_14_8 and var_14_8.perform_overlap and arg_14_3 > var_14_8.start_time then
			local var_14_22 = arg_14_2.action
			local var_14_23 = arg_14_2.physics_world

			arg_14_0:weapon_sweep_overlap(arg_14_1, arg_14_2, var_14_22, var_14_2, var_14_8, var_14_23, arg_14_3, arg_14_4)
		end

		if (not arg_14_2.attack_locked_in_t or arg_14_3 >= arg_14_2.attack_locked_in_t) and arg_14_2.attack_finished then
			arg_14_2.attack_finished = false

			if arg_14_0:_attack_finished(arg_14_1, arg_14_2, arg_14_3, arg_14_4) then
				return "done"
			end
		end

		return "running"
	elseif (not arg_14_2.attack_locked_in_t or arg_14_3 >= arg_14_2.attack_locked_in_t) and arg_14_0:_attack_finished(arg_14_1, arg_14_2, arg_14_3, arg_14_4) then
		return "done"
	end
end

BTMeleeOverlapAttackAction.push_player = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = POSITION_LOOKUP[arg_15_1]
	local var_15_1 = POSITION_LOOKUP[arg_15_2] - var_15_0
	local var_15_2 = arg_15_3 * Vector3.normalize(var_15_1)

	if arg_15_4 then
		Vector3.set_z(var_15_2, arg_15_4)
	end

	if arg_15_5 then
		StatusUtils.set_catapulted_network(arg_15_2, true, var_15_2)
	else
		ScriptUnit.extension(arg_15_2, "locomotion_system"):add_external_velocity(var_15_2)
	end
end

BTMeleeOverlapAttackAction.hit_player = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	local var_16_0 = ScriptUnit.has_extension(arg_16_3, "status_system")
	local var_16_1 = arg_16_4.attack_directions and arg_16_4.attack_directions[arg_16_2.attack_anim]
	local var_16_2 = false

	if DamageUtils.check_block(arg_16_1, arg_16_3, arg_16_4.fatigue_type, var_16_1) then
		if not arg_16_4.ignore_shield_block and DamageUtils.check_ranged_block(arg_16_1, arg_16_3, arg_16_4.shield_blocked_fatigue_type or "shield_blocked_slam") then
			arg_16_0:push_player(arg_16_1, arg_16_3, arg_16_5.player_push_speed_blocked, arg_16_5.player_push_speed_blocked_z, false)
		else
			if arg_16_4.blocked_damage then
				AiUtils.damage_target(arg_16_3, arg_16_1, arg_16_4, arg_16_4.blocked_damage)

				var_16_2 = true
			end

			if arg_16_5.player_push_speed_blocked and not var_16_0.knocked_down then
				arg_16_0:push_player(arg_16_1, arg_16_3, arg_16_5.player_push_speed_blocked, arg_16_5.player_push_speed_blocked_z, arg_16_5.catapult_player)
			end
		end
	else
		AiUtils.damage_target(arg_16_3, arg_16_1, arg_16_4, arg_16_4.damage)

		var_16_2 = true

		if arg_16_5.player_push_speed and not var_16_0.knocked_down then
			arg_16_0:push_player(arg_16_1, arg_16_3, arg_16_5.player_push_speed, arg_16_5.player_push_speed_z, arg_16_5.catapult_player)
		end
	end

	if arg_16_5.hit_player_func then
		arg_16_5.hit_player_func(arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, var_16_2)
	end
end

BTMeleeOverlapAttackAction.hit_ai = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	local var_17_0 = arg_17_4.push_ai
	local var_17_1 = arg_17_4.immune_breeds
	local var_17_2 = arg_17_4.damage_target_only
	local var_17_3 = BLACKBOARDS[arg_17_2]

	if var_17_3.is_illusion then
		return
	end

	if var_17_1 and var_17_1[var_17_3.breed and var_17_3.breed.name] then
		return
	end

	if var_17_0 then
		local var_17_4, var_17_5 = DamageUtils.calculate_stagger(var_17_0.stagger_impact, var_17_0.stagger_duration, arg_17_2, arg_17_1)

		if var_17_4 > 0 then
			local var_17_6 = POSITION_LOOKUP[arg_17_1]
			local var_17_7 = POSITION_LOOKUP[arg_17_2]
			local var_17_8 = Vector3.normalize(var_17_7 - var_17_6)
			local var_17_9 = true
			local var_17_10 = not arg_17_5.commander_unit

			AiUtils.stagger(arg_17_2, var_17_3, arg_17_1, var_17_8, var_17_0.stagger_distance, var_17_4, var_17_5, nil, arg_17_6, nil, nil, nil, var_17_10)
		end
	end

	if arg_17_2 == arg_17_5.attacking_target or not arg_17_3.ignore_ai_damage then
		AiUtils.damage_target(arg_17_2, arg_17_1, arg_17_3, arg_17_3.damage)
	end

	if arg_17_4.hit_ai_func then
		arg_17_4.hit_ai_func(arg_17_1, arg_17_5, arg_17_2, arg_17_3, arg_17_4)
	end

	if arg_17_3.hit_ai_func then
		arg_17_3.hit_ai_func(arg_17_1, arg_17_5, arg_17_2, arg_17_3, arg_17_4)
	end
end

BTMeleeOverlapAttackAction.anim_cb_frenzy_damage = function (arg_18_0, arg_18_1, arg_18_2)
	arg_18_0:anim_cb_damage(arg_18_1, arg_18_2)
end

BTMeleeOverlapAttackAction.anim_cb_damage = function (arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_2.attacking_target then
		return
	end

	local var_19_0 = arg_19_2.action
	local var_19_1 = arg_19_2.attack

	arg_19_2.anim_cb_damage_triggered_this_attack = true

	local var_19_2 = var_19_1.width
	local var_19_3 = var_19_1.range
	local var_19_4 = var_19_1.height
	local var_19_5 = var_19_1.offset_up
	local var_19_6 = var_19_1.offset_forward
	local var_19_7 = var_19_2 * 0.5
	local var_19_8 = var_19_3 * 0.5
	local var_19_9 = var_19_4 * 0.5
	local var_19_10 = Vector3(var_19_7, var_19_8, var_19_9)
	local var_19_11 = Unit.local_rotation(arg_19_1, 0)
	local var_19_12 = Quaternion.rotate(var_19_11, Vector3.forward()) * (var_19_6 + var_19_8)
	local var_19_13 = POSITION_LOOKUP[arg_19_1]
	local var_19_14 = Vector3.up() * (var_19_5 + var_19_9)
	local var_19_15 = var_19_13 + var_19_12 + var_19_14
	local var_19_16 = Managers.time:time("game")
	local var_19_17 = arg_19_2.physics_world
	local var_19_18 = math.max(var_19_3, math.max(var_19_4, var_19_2))
	local var_19_19 = FrameTable.alloc_table()

	var_19_19[arg_19_1] = true

	arg_19_0:overlap_checks(arg_19_1, arg_19_2, var_19_17, var_19_16, var_19_0, var_19_1, var_19_15, var_19_11, var_19_10, var_19_19, var_19_18)

	local var_19_20 = var_19_1.push_units_in_the_way

	if var_19_1.push_close_units_during_attack and var_19_20 then
		arg_19_0:push_close_units(arg_19_1, arg_19_2, var_19_16, var_19_20)
	end

	arg_19_2.past_damage_in_attack = not var_19_1.triggers_anim_cb_damage_multiple_times and (not var_19_0.is_combo_attack or arg_19_2.last_combo_attack)
end

BTMeleeOverlapAttackAction.push_close_units = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = Unit.local_rotation(arg_20_1, 0)
	local var_20_1 = Quaternion.forward(var_20_0)
	local var_20_2 = POSITION_LOOKUP[arg_20_1] + var_20_1 * arg_20_4.push_forward_offset
	local var_20_3 = arg_20_4.ahead_dist
	local var_20_4 = var_20_2 + var_20_1 * var_20_3
	local var_20_5 = math.max(arg_20_4.push_width, var_20_3) * 1.5
	local var_20_6 = var_20_5 * var_20_5
	local var_20_7 = FrameTable.alloc_table()
	local var_20_8 = AiUtils.broadphase_query(var_20_2, var_20_5, var_20_7)
	local var_20_9 = arg_20_4.push_width^2
	local var_20_10 = BLACKBOARDS

	for iter_20_0 = 1, var_20_8 do
		local var_20_11 = var_20_7[iter_20_0]

		if var_20_11 ~= arg_20_1 then
			local var_20_12 = POSITION_LOOKUP[var_20_11]
			local var_20_13, var_20_14 = var_0_2(var_20_12, var_20_2, var_20_4)
			local var_20_15 = var_20_12 - var_20_13

			if not var_20_14 and var_20_9 > Vector3.length_squared(var_20_15) then
				local var_20_16, var_20_17 = DamageUtils.calculate_stagger(arg_20_4.push_stagger_impact, arg_20_4.push_stagger_duration, var_20_11, arg_20_1)

				if var_20_16 > var_0_0.none then
					local var_20_18 = Vector3.normalize(var_20_15)
					local var_20_19 = var_20_10[var_20_11]

					AiUtils.stagger(var_20_11, var_20_19, arg_20_1, var_20_18, arg_20_4.push_stagger_distance, var_20_16, var_20_17, nil, arg_20_3)
				end
			end
		end
	end

	local var_20_20 = arg_20_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_20_1 = 1, #var_20_20 do
		local var_20_21 = var_20_20[iter_20_1]
		local var_20_22 = POSITION_LOOKUP[var_20_21]
		local var_20_23 = var_20_22 - var_20_2

		if var_20_6 > Vector3.length_squared(var_20_23) then
			local var_20_24, var_20_25 = var_0_2(var_20_22, var_20_2, var_20_4)
			local var_20_26 = var_20_22 - var_20_24

			if not var_20_25 and var_20_9 > Vector3.length_squared(var_20_26) and not ScriptUnit.has_extension(var_20_21, "status_system").knocked_down then
				local var_20_27 = arg_20_4.player_pushed_speed * Vector3.normalize(var_20_23)

				ScriptUnit.extension(var_20_21, "locomotion_system"):add_external_velocity(var_20_27)
			end
		end
	end
end

BTMeleeOverlapAttackAction.weapon_sweep_overlap = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	if arg_21_2.is_illusion then
		return
	end

	local var_21_0 = arg_21_5.weapon_unit
	local var_21_1
	local var_21_2 = arg_21_5.tip_node
	local var_21_3 = Unit.world_position(var_21_0, var_21_2)

	if arg_21_5.tip_node_pos then
		var_21_1 = arg_21_5.tip_node_pos:unbox() - var_21_3

		arg_21_5.tip_node_pos:store(var_21_3)
	else
		var_21_1 = Vector3.zero()
		arg_21_5.tip_node_pos = Vector3Box(var_21_3)
	end

	local var_21_4 = Vector3.length(var_21_1)
	local var_21_5 = arg_21_5.base_node
	local var_21_6 = Unit.world_position(arg_21_5.weapon_unit, var_21_5)
	local var_21_7 = arg_21_4.width + var_21_4
	local var_21_8 = arg_21_4.range
	local var_21_9 = arg_21_4.height
	local var_21_10 = arg_21_4.offset_up
	local var_21_11 = arg_21_4.offset_forward
	local var_21_12 = var_21_7 * 0.5
	local var_21_13 = var_21_8 * 0.5
	local var_21_14 = var_21_9 * 0.5
	local var_21_15 = Vector3(var_21_12, var_21_13, var_21_14)
	local var_21_16
	local var_21_17 = var_21_3 - var_21_6
	local var_21_18
	local var_21_19

	if var_21_5 == var_21_2 then
		var_21_16 = Unit.local_rotation(var_21_0, var_21_5)
		var_21_18 = Quaternion.up(var_21_16) * (var_21_10 + var_21_14)
		var_21_19 = Quaternion.forward(var_21_16) * (var_21_11 + var_21_13)
	else
		var_21_16 = Quaternion.look(var_21_17, Vector3.up())
		var_21_18 = Quaternion.up(var_21_16) * var_21_10
		var_21_19 = Quaternion.forward(var_21_16) * var_21_11
	end

	local var_21_20 = var_21_6 + var_21_17 * 0.5 + var_21_18 + var_21_19 + var_21_1 * 0.5
	local var_21_21 = math.max(var_21_8, math.max(var_21_9, var_21_7))
	local var_21_22 = arg_21_5.hit_units
	local var_21_23 = arg_21_0:overlap_checks(arg_21_1, arg_21_2, arg_21_6, arg_21_7, arg_21_3, arg_21_4, var_21_20, var_21_16, var_21_15, var_21_22, var_21_21)

	if not arg_21_4.hit_multiple_targets and var_21_23 > 0 then
		arg_21_5.perform_overlap = false
	end
end

local var_0_6 = {
	mode = "retained",
	name = "BTMeleeOverlapAttackAction"
}

BTMeleeOverlapAttackAction.overlap_checks = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11)
	if arg_22_2.is_illusion then
		return 0
	end

	local var_22_0 = arg_22_6.hit_only_players and "filter_player_hit_box_check" or "filter_player_and_enemy_hit_box_check"

	PhysicsWorld.prepare_actors_for_overlap(arg_22_3, arg_22_7, arg_22_11)

	local var_22_1, var_22_2 = PhysicsWorld.immediate_overlap(arg_22_3, "position", arg_22_7, "rotation", arg_22_8, "size", arg_22_9, "shape", "oobb", "types", "dynamics", "collision_filter", var_22_0)

	if Development.parameter("debug_weapons") then
		local var_22_3 = Managers.state.debug:drawer(var_0_6)

		var_22_3:reset()

		local var_22_4 = Matrix4x4.from_quaternion_position(arg_22_8, arg_22_7)

		var_22_3:box(var_22_4, arg_22_9)
	end

	local var_22_5 = POSITION_LOOKUP[arg_22_1]
	local var_22_6 = Unit.local_rotation(arg_22_1, 0)
	local var_22_7 = Quaternion.forward(var_22_6)
	local var_22_8 = arg_22_6.hit_multiple_targets
	local var_22_9 = arg_22_6.damage_target_only
	local var_22_10 = 0
	local var_22_11 = arg_22_5.allow_friendly_fire
	local var_22_12 = Managers.state.side

	for iter_22_0 = 1, var_22_2 do
		local var_22_13 = var_22_1[iter_22_0]
		local var_22_14 = var_22_13 and Actor.unit(var_22_13)

		if Unit.alive(var_22_14) and not arg_22_10[var_22_14] then
			local var_22_15 = POSITION_LOOKUP[var_22_14]

			if var_22_15 then
				local var_22_16 = true

				if not var_22_11 then
					var_22_16 = Managers.state.side:is_enemy(arg_22_1, var_22_14)
				end

				if var_22_16 then
					local var_22_17 = Vector3.normalize(var_22_15 - var_22_5)

					if not arg_22_6.ignore_targets_behind or Vector3.dot(var_22_17, var_22_7) > 0 then
						if Managers.player:owner(var_22_14) then
							arg_22_0:hit_player(arg_22_1, arg_22_2, var_22_14, arg_22_5, arg_22_6)

							arg_22_10[var_22_14] = true
							var_22_10 = var_22_10 + 1

							if not var_22_8 then
								break
							end
						elseif Unit.has_data(var_22_14, "breed") then
							arg_22_0:hit_ai(arg_22_1, var_22_14, arg_22_5, arg_22_6, arg_22_2, arg_22_4)

							arg_22_10[var_22_14] = true
							var_22_10 = var_22_10 + 1

							if not var_22_8 then
								break
							end
						end
					end
				end
			else
				print("BTMeleeOverlapAttackAction: HIT UNIT MISSING POSITION_LOOKUP ENTRY!", var_22_14)
			end
		end
	end

	return var_22_10
end

BTMeleeOverlapAttackAction.anim_cb_attack_overlap_done = function (arg_23_0, arg_23_1, arg_23_2)
	arg_23_2.continous_overlap_data.perform_overlap = nil
end

BTMeleeOverlapAttackAction.anim_cb_attack_grabbed_smash = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_2.action

	AiUtils.damage_target(arg_24_2.victim_grabbed, arg_24_1, var_24_0, var_24_0.damage)
end

BTMeleeOverlapAttackAction._backstab_sound = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_2.breed
	local var_25_1 = arg_25_2.locked_target_unit

	if not arg_25_2.target_unit_status_extension or not var_25_1 then
		return
	end

	local var_25_2 = Managers.player:unit_owner(var_25_1)

	if not var_25_2 or var_25_2.bot_player then
		return
	end

	if not AiUtils.unit_is_flanking_player(arg_25_1, var_25_1) then
		return
	end

	if var_25_2.local_player then
		local var_25_3 = ScriptUnit.extension(arg_25_1, "dialogue_system")
		local var_25_4, var_25_5 = WwiseUtils.make_unit_auto_source(arg_25_2.world, arg_25_1, var_25_3.voice_node)
		local var_25_6 = var_25_0.backstab_player_sound_event

		Managers.state.entity:system("audio_system"):_play_event_with_source(var_25_5, var_25_6, var_25_4)
	else
		local var_25_7 = Managers.state.network
		local var_25_8 = var_25_7.network_transmit
		local var_25_9 = var_25_7:unit_game_object_id(arg_25_1)
		local var_25_10 = var_25_2:network_id()

		var_25_8:send_rpc("rpc_check_trigger_backstab_sfx", var_25_10, var_25_9)
	end

	arg_25_2.backstab_attack_trigger = true
end
