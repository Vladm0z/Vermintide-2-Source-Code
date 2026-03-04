-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_fire_projectile_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFireProjectileAction = class(BTFireProjectileAction, BTNode)

BTFireProjectileAction.init = function (arg_1_0, ...)
	BTFireProjectileAction.super.init(arg_1_0, ...)
end

BTFireProjectileAction.name = "BTFireProjectileAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

BTFireProjectileAction = class(BTFireProjectileAction, BTNode)
BTFireProjectileAction.name = "BTFireProjectileAction"

BTFireProjectileAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTFireProjectileAction
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.anim_cb_spawn_projectile = nil

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

	arg_3_2.aim_cooldown = arg_3_3 + math.random(var_3_0.aim_cooldown[1], var_3_0.aim_cooldown[2])
	arg_3_2.start_check_for_dodge_t = arg_3_2.aim_cooldown - var_3_0.dodge_window
	arg_3_2.ranged_state = "aiming"
	arg_3_2.move_state = "attacking"

	Managers.state.network:anim_event(arg_3_1, var_3_0.aim_animation)
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)
	arg_3_0:_check_for_volley_attack(arg_3_2, arg_3_1, arg_3_3)

	arg_3_2.attacking_target = arg_3_2.volley_target_unit or arg_3_2.target_unit
	arg_3_2.target_unit_status_extension = ScriptUnit.has_extension(arg_3_2.attacking_target, "status_system")

	local var_3_1 = ScriptUnit.extension_input(arg_3_1, "dialogue_system")
	local var_3_2 = FrameTable.alloc_table()

	var_3_1:trigger_networked_dialogue_event(arg_3_2.action.leader_fire_volley_dialogue_event, var_3_2)
end

BTFireProjectileAction._check_for_volley_attack = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_1.target_unit
	local var_4_1 = {}

	if arg_4_1.is_volley_leader or not arg_4_1.has_volley_target then
		local var_4_2 = arg_4_1.group_blackboard.broadphase
		local var_4_3 = arg_4_1.archer_broadphase_results
		local var_4_4 = 15
		local var_4_5 = POSITION_LOOKUP[arg_4_2]
		local var_4_6 = Broadphase.query(var_4_2, var_4_5, var_4_4, var_4_3)
		local var_4_7 = arg_4_1.fire_volley_at_t or arg_4_3 + 1 + math.random()
		local var_4_8 = Vector3(0, 0, 0)

		if var_4_6 >= 3 then
			for iter_4_0 = 1, var_4_6 do
				local var_4_9 = var_4_3[iter_4_0]
				local var_4_10 = BLACKBOARDS[var_4_9]
				local var_4_11 = var_4_10.breed
				local var_4_12 = POSITION_LOOKUP[var_4_9]

				if var_4_11.is_archer then
					var_4_1[#var_4_1 + 1] = var_4_10
					var_4_8 = var_4_8 + var_4_12
				end
			end
		end

		local var_4_13 = #var_4_1

		if var_4_13 >= 3 then
			local var_4_14 = 0

			for iter_4_1 = 1, var_4_13 do
				local var_4_15 = var_4_1[iter_4_1]

				if var_4_15.unit ~= arg_4_2 then
					var_4_15.volley_target_unit = var_4_0
					var_4_15.has_volley_target = true

					local var_4_16 = var_4_7 + Math.random_range(0.15, 1.5)

					var_4_15.fire_volley_at_t = var_4_16

					if var_4_14 < var_4_16 then
						var_4_14 = var_4_16
					end

					if not var_4_15.confirmed_player_sighting then
						AiUtils.activate_unit(var_4_15)
					end
				end
			end

			arg_4_1.volley_target_unit = var_4_0
			arg_4_1.fire_volley_at_t = var_4_14 + Math.random_range(0.15, 0.3)

			local var_4_17 = Managers.state.entity:system("audio_system")
			local var_4_18 = arg_4_1.action.group_volley_sound
			local var_4_19 = var_4_8 / var_4_13

			var_4_17:play_audio_position_event(var_4_18, var_4_19)

			arg_4_1.is_volley_leader = true
			arg_4_1.nearby_archers = var_4_1
		end
	end
end

BTFireProjectileAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = AiUtils.get_default_breed_move_speed(arg_5_1, arg_5_2)
	local var_5_1 = arg_5_2.navigation_extension

	var_5_1:set_enabled(true)
	var_5_1:set_max_speed(var_5_0)
	arg_5_2.locomotion_extension:set_rotation_speed(nil)

	arg_5_2.action = nil
	arg_5_2.active_node = nil
	arg_5_2.aim_cooldown = nil
	arg_5_2.anim_cb_spawn_projectile = nil
	arg_5_2.attack_aborted = nil
	arg_5_2.attack_success = nil
	arg_5_2.attacking_target = nil
	arg_5_2.fire_volley_at_t = nil
	arg_5_2.ranged_state = nil
	arg_5_2.shoot_cooldown = nil
	arg_5_2.target_is_dodging = nil
	arg_5_2.target_unit_status_extension = nil
	arg_5_2.volley_target_unit = nil
	arg_5_2.ranged_state = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_5_1, true)
end

BTFireProjectileAction.run = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_2.attacking_target

	if not Unit.alive(var_6_0) then
		return "done"
	end

	if arg_6_2.attack_aborted then
		return "done"
	end

	if arg_6_2.start_check_for_dodge_t and arg_6_3 > arg_6_2.start_check_for_dodge_t then
		arg_6_2.target_is_dodging = arg_6_2.target_unit_status_extension and arg_6_2.target_unit_status_extension:get_is_dodging()

		if arg_6_2.anim_cb_spawn_projectile then
			arg_6_2.start_check_for_dodge_t = nil
		end
	end

	local var_6_1 = Unit.world_rotation(arg_6_1, 0)
	local var_6_2 = Vector3.flat(Quaternion.forward(var_6_1))
	local var_6_3 = Vector3.normalize(var_6_2)
	local var_6_4 = POSITION_LOOKUP[var_6_0]
	local var_6_5 = POSITION_LOOKUP[arg_6_1]
	local var_6_6 = Vector3.flat(var_6_4 - var_6_5)
	local var_6_7 = Vector3.normalize(var_6_6)

	if Vector3.dot(var_6_7, var_6_3) < math.inverse_sqrt_2 then
		local var_6_8 = LocomotionUtils.rotation_towards_unit_flat(arg_6_1, var_6_0)

		arg_6_2.locomotion_extension:set_wanted_rotation(var_6_8)
	end

	local var_6_9 = Managers.state.network
	local var_6_10 = arg_6_2.ranged_state
	local var_6_11 = arg_6_2.action

	if var_6_10 == "aiming" then
		if arg_6_2.has_volley_target or arg_6_2.is_volley_leader then
			if arg_6_3 >= arg_6_2.aim_cooldown and arg_6_2.fire_volley_at_t and arg_6_3 > arg_6_2.fire_volley_at_t then
				arg_6_2.ranged_state = "shooting"

				var_6_9:anim_event(arg_6_1, var_6_11.shoot_animation)
			elseif arg_6_3 >= arg_6_2.aim_cooldown and not arg_6_2.fire_volley_at_t then
				arg_6_2.ranged_state = "shooting"

				var_6_9:anim_event(arg_6_1, var_6_11.shoot_animation)
			end
		elseif arg_6_3 >= arg_6_2.aim_cooldown and arg_6_2.has_line_of_sight then
			arg_6_2.ranged_state = "shooting"

			var_6_9:anim_event(arg_6_1, var_6_11.shoot_animation)
		elseif arg_6_3 >= arg_6_2.aim_cooldown then
			arg_6_2.ranged_state = "aftermath"
			arg_6_2.shoot_cooldown = arg_6_3
		end
	elseif var_6_10 == "shooting" then
		if arg_6_2.anim_cb_spawn_projectile then
			arg_6_0:_fire_projectile(arg_6_1, arg_6_2, arg_6_4)

			arg_6_2.shoot_cooldown = arg_6_3 + var_6_11.shoot_cooldown
			arg_6_2.ranged_state = "aftermath"
		end
	elseif arg_6_3 > arg_6_2.shoot_cooldown then
		return "done"
	end

	return "running"
end

BTFireProjectileAction._fire_from_position_direction = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0
	local var_7_1 = arg_7_1.attacking_target

	if Unit.has_node(var_7_1, "j_neck") then
		local var_7_2 = Unit.node(var_7_1, "j_neck")

		var_7_0 = Unit.world_position(var_7_1, var_7_2)
	else
		var_7_0 = POSITION_LOOKUP[var_7_1] + Vector3(0, 0, 1.5)
	end

	local var_7_3 = Unit.node(arg_7_2, "j_lefthand")
	local var_7_4 = Unit.world_position(arg_7_2, var_7_3)
	local var_7_5 = ScriptUnit.has_extension(var_7_1, "locomotion_system")
	local var_7_6 = var_7_5.small_sample_size_average_velocity and var_7_5:small_sample_size_average_velocity() or Vector3.zero()
	local var_7_7 = Vector3.length(var_7_6)

	if var_7_7 > 4 then
		var_7_6 = var_7_6 * (4 / var_7_7)
	end

	local var_7_8, var_7_9 = WeaponHelper.angle_to_hit_moving_target(var_7_4, var_7_0, arg_7_4, var_7_6, arg_7_5, 0.1)
	local var_7_10 = var_7_9 - var_7_4

	if var_7_8 then
		Vector3.set_z(var_7_10, 0)

		local var_7_11 = Vector3.normalize(var_7_10)
		local var_7_12 = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(var_7_11, Vector3.up()), var_7_8), var_7_11) * arg_7_4

		return var_7_4, var_7_10, var_7_12
	end

	return false
end

local var_0_1 = math.pi
local var_0_2 = var_0_1 * 2

BTFireProjectileAction._fire_projectile = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_2.action
	local var_8_1 = var_8_0.projectile_speed
	local var_8_2 = var_8_0.projectile_gravity
	local var_8_3, var_8_4, var_8_5 = arg_8_0:_fire_from_position_direction(arg_8_2, arg_8_1, arg_8_3, var_8_1, var_8_2)

	if not var_8_3 then
		return false
	end

	local var_8_6 = var_8_0.light_weight_projectile_template_name
	local var_8_7 = LightWeightProjectiles[var_8_6]
	local var_8_8 = "filter_enemy_player_afro_ray_projectile"
	local var_8_9 = var_8_0.difficulty_hit_chance
	local var_8_10 = Managers.state.difficulty:get_difficulty_rank()
	local var_8_11 = var_8_7.attack_power_level[var_8_10] or var_8_7.attack_power_level[2]
	local var_8_12 = arg_8_2.target_is_dodging
	local var_8_13 = not arg_8_2.fired_first_shot and var_8_7.first_shot_spread
	local var_8_14 = true

	if var_8_10 and var_8_9 then
		var_8_14 = (var_8_9[var_8_10] or var_8_9[2]) >= math.random()

		if not var_8_14 or var_8_13 then
			var_8_8 = "filter_enemy_player_afro_ray_projectile_no_hitbox"
		end
	end

	local var_8_15 = Vector3.length(Vector3.flat(var_8_5))
	local var_8_16 = Vector3.normalize(var_8_5)
	local var_8_17 = var_8_7.spread
	local var_8_18 = var_8_7.dodge_spread
	local var_8_19 = Math.random() * (var_8_13 or var_8_12 and var_8_18 or var_8_17)

	var_8_19 = var_8_14 and var_8_19 or var_8_7.miss_spread or 0

	local var_8_20 = Quaternion(Vector3.right(), var_8_19)
	local var_8_21 = Quaternion(Vector3.forward(), (Math.random() - 0.5) * var_0_1)
	local var_8_22 = Quaternion.look(var_8_16, Vector3.up())
	local var_8_23 = Quaternion.multiply(Quaternion.multiply(var_8_22, var_8_21), var_8_20)
	local var_8_24 = Quaternion.forward(var_8_23)
	local var_8_25 = {
		power_level = var_8_11,
		damage_profile = var_8_7.damage_profile,
		hit_effect = var_8_7.hit_effect,
		player_push_velocity = Vector3Box(var_8_16 * var_8_7.impact_push_speed),
		projectile_linker = var_8_7.projectile_linker,
		first_person_hit_flow_events = var_8_7.first_person_hit_flow_events
	}
	local var_8_26 = Managers.state.entity:system("projectile_system")
	local var_8_27 = var_8_2
	local var_8_28 = Network.peer_id()

	var_8_26:create_light_weight_projectile(arg_8_2.breed.name, arg_8_1, var_8_3, var_8_24, var_8_7.projectile_speed, var_8_27, var_8_15, var_8_7.projectile_max_range, var_8_8, var_8_25, var_8_7.light_weight_projectile_effect, var_8_28)

	arg_8_2.fired_first_shot = true
end
