-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_stormfiend_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTStormfiendShootAction = class(BTStormfiendShootAction, BTNode)

function BTStormfiendShootAction.init(arg_1_0, ...)
	BTStormfiendShootAction.super.init(arg_1_0, ...)

	arg_1_0.unit_ids = {}
end

BTStormfiendShootAction.name = "BTStormfiendShootAction"

local function var_0_0(...)
	if script_data.debug_stormfiend then
		print("BTStormfiendShootAction:", ...)
	end
end

local var_0_1 = 0.4
local var_0_2 = 10

function BTStormfiendShootAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.unit_ids[arg_3_1] = Managers.state.network.unit_storage:go_id(arg_3_1)
	arg_3_0.network_transmit = arg_3_0.network_transmit or Managers.state.network.network_transmit

	local var_3_0 = arg_3_0._tree_node.action_data
	local var_3_1 = arg_3_2.world

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTStormfiendShootAction
	arg_3_2.attack_finished = false
	arg_3_2.shoot_data = arg_3_2.shoot_data or {}
	arg_3_2.physics_world = arg_3_2.physics_world or World.get_data(var_3_1, "physics_world")
	arg_3_2.attacking_target = arg_3_2.target_unit

	if arg_3_0:init_attack(arg_3_1, arg_3_2, var_3_0, arg_3_3) then
		local var_3_2 = arg_3_2.shoot_data

		arg_3_2.anim_locked = arg_3_3 + var_3_0.attack_anims_data[var_3_2.attack_animation].full_animation_t
		arg_3_2.move_state = "attacking"
		arg_3_2.attack_aborted = false
		arg_3_2.keep_target = true
		arg_3_2.find_new_shoot_position = nil

		arg_3_0:set_global_environment_intensity(arg_3_1, arg_3_2.group_blackboard, var_3_0)

		if var_3_0.use_demo_flow_event then
			AiBreedSnippets.on_stormfiend_demo_shoot(arg_3_1, arg_3_2)
		end
	else
		arg_3_2.attack_aborted = true

		if not arg_3_2.navigation_extension:is_following_path() then
			arg_3_2.find_new_shoot_position = true
		end

		var_0_0("ATTACK WAS NOT OK [Aborting]")
	end

	local var_3_3 = arg_3_2.target_unit

	AiUtils.add_attack_intensity(var_3_3, var_3_0, arg_3_2)
end

function BTStormfiendShootAction.set_global_environment_intensity(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_3.environment_max_intensity
	local var_4_1 = arg_4_2.firewall_environment_intensity or 0
	local var_4_2 = math.min(var_4_1 + arg_4_3.environment_intensity_increase_per_firewall, var_4_0)
	local var_4_3 = arg_4_3.global_sound_parameter

	Managers.state.entity:system("audio_system"):set_global_parameter_with_lerp(var_4_3, var_4_2)

	local var_4_4 = var_4_2 / var_4_0
	local var_4_5 = Managers.state.network.network_transmit
	local var_4_6 = NetworkLookup.global_parameter_names[var_4_3]

	var_4_5:send_rpc_clients("rpc_client_audio_set_global_parameter_with_lerp", var_4_6, var_4_4)

	arg_4_2.firewall_environment_intensity = var_4_2
end

function BTStormfiendShootAction._calculate_attack_animation(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = Vector3.dot(arg_5_1, arg_5_3)
	local var_5_1 = Vector3.dot(arg_5_2, arg_5_3)
	local var_5_2 = math.abs(var_5_0)
	local var_5_3 = math.abs(var_5_1)
	local var_5_4
	local var_5_5
	local var_5_6
	local var_5_7 = var_5_3 < var_5_2
	local var_5_8

	if var_5_7 and var_5_0 > 0.5 then
		var_5_6 = "attack_right"
		var_5_5 = arg_5_4.right[var_5_6]
		var_5_8 = true
	elseif var_5_7 and var_5_0 < -0.5 then
		var_5_6 = "attack_left"
		var_5_5 = arg_5_4.left[var_5_6]
		var_5_8 = true
	elseif var_5_1 > 0 then
		var_5_6 = NetworkLookup.attack_arm[math.random(1, 2)]
		var_5_5 = arg_5_4.fwd[var_5_6]
		var_5_8 = false
	else
		var_5_6 = "attack_left"
		var_5_5 = arg_5_4.bwd[var_5_6]
		var_5_8 = true
	end

	return var_5_5, var_5_6, var_5_8
end

function BTStormfiendShootAction._calculate_aim(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	local var_6_0 = arg_6_7.muzzle_nodes[arg_6_3]
	local var_6_1 = Unit.node(arg_6_1, var_6_0)
	local var_6_2 = Unit.world_position(arg_6_1, var_6_1)

	if arg_6_5 then
		local var_6_3 = Vector3.flat_angle(arg_6_4, arg_6_10)
		local var_6_4 = Quaternion.axis_angle(Vector3.up(), var_6_3)
		local var_6_5 = var_6_2 - arg_6_2

		var_6_2 = arg_6_2 + Quaternion.rotate(var_6_4, var_6_5)
	end

	local var_6_6 = arg_6_7.shoulder_nodes[arg_6_3]
	local var_6_7 = Unit.node(arg_6_1, var_6_6)
	local var_6_8 = Unit.world_position(arg_6_1, var_6_7)
	local var_6_9 = var_6_2 - var_6_8
	local var_6_10 = Vector3.normalize(var_6_9)
	local var_6_11 = Vector3.length(var_6_9)
	local var_6_12 = arg_6_6.physics_world

	if PhysicsWorld.immediate_raycast(var_6_12, var_6_8, var_6_10, var_6_11, "any", "collision_filter", "filter_ai_line_of_sight_check") then
		return nil, nil, nil
	end

	local var_6_13 = arg_6_7.start_distance
	local var_6_14 = arg_6_7.maximum_length
	local var_6_15 = arg_6_2 + arg_6_10 * var_6_13
	local var_6_16 = var_6_15 + arg_6_10 * var_6_14
	local var_6_17 = 1
	local var_6_18 = 2
	local var_6_19 = arg_6_6.nav_world
	local var_6_20 = arg_6_6.navigation_extension:traverse_logic()
	local var_6_21 = arg_6_7.minimum_length^2
	local var_6_22 = var_6_21 < Vector3.distance_squared(var_6_15, arg_6_9)
	local var_6_23
	local var_6_24

	if var_6_22 then
		var_6_24 = LocomotionUtils.ray_can_go_on_mesh(var_6_19, arg_6_2, var_6_15, var_6_20, var_6_17, var_6_18) and LocomotionUtils.ray_can_go_on_mesh(var_6_19, var_6_15, arg_6_9, var_6_20, var_6_17, var_6_18)
	end

	local var_6_25 = false
	local var_6_26
	local var_6_27

	if var_6_24 then
		var_6_25 = true
	else
		local var_6_28 = Unit.node(arg_6_8, "c_head")
		local var_6_29 = Unit.world_position(arg_6_8, var_6_28)
		local var_6_30 = PhysicsWorld.linear_sphere_sweep(var_6_12, var_6_2, var_6_29, var_0_1, var_0_2, "collision_filter", "filter_enemy_player_ray_projectile", "report_initial_overlap")

		if var_6_30 then
			local var_6_31 = #var_6_30

			for iter_6_0 = 1, var_6_31 do
				local var_6_32 = var_6_30[iter_6_0].actor
				local var_6_33 = Actor.unit(var_6_32)

				if not DamageUtils.is_character(var_6_33) then
					break
				elseif var_6_33 == arg_6_8 then
					var_6_25 = true
					var_6_27 = var_6_29

					break
				end
			end
		end
	end

	local var_6_34

	if var_6_25 then
		local var_6_35, var_6_36, var_6_37, var_6_38 = LocomotionUtils.raycast_on_navmesh(var_6_19, var_6_15, var_6_16, var_6_20, var_6_17, var_6_18)

		var_6_34 = var_6_21 < (var_6_36 and Vector3.distance_squared(var_6_36, var_6_38) or 0) and var_6_36 or nil
		var_6_26 = var_6_36
		var_6_27 = var_6_27 or var_6_38
	end

	local var_6_39 = arg_6_7.aim_start_offset
	local var_6_40 = (var_6_26 or var_6_15) + arg_6_10 * var_6_39

	return var_6_34, var_6_40, var_6_27
end

function BTStormfiendShootAction.init_attack(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_2.action

	if var_7_0.switch_between_weapon_setups then
		local var_7_1 = arg_7_2.target_dist
		local var_7_2 = var_7_0.warpfire_switch_range
		local var_7_3 = var_7_0.ratling_gun_switch_range

		if var_7_1 < var_7_2 then
			arg_7_2.weapon_setup = "warpfire_thrower"
		else
			arg_7_2.weapon_setup = "ratling_gun"
		end
	else
		arg_7_2.weapon_setup = var_7_0.weapon_setup or "warpfire_thrower"
	end

	local var_7_4 = POSITION_LOOKUP[arg_7_1]
	local var_7_5 = arg_7_2.attacking_target
	local var_7_6 = POSITION_LOOKUP[var_7_5]
	local var_7_7 = Vector3.normalize(var_7_6 - var_7_4)
	local var_7_8 = var_7_0.attack_anims
	local var_7_9 = Unit.world_rotation(arg_7_1, 0)
	local var_7_10 = Quaternion.forward(var_7_9)
	local var_7_11 = Quaternion.right(var_7_9)
	local var_7_12, var_7_13, var_7_14 = arg_7_0:_calculate_attack_animation(var_7_11, var_7_10, var_7_7, var_7_8, var_7_4)
	local var_7_15, var_7_16, var_7_17 = arg_7_0:_calculate_aim(arg_7_1, var_7_4, var_7_13, var_7_10, var_7_14, arg_7_2, var_7_0, var_7_5, var_7_6, var_7_7)
	local var_7_18 = var_7_17 ~= nil

	if var_7_18 then
		arg_7_2.navigation_extension:stop()
		arg_7_2.locomotion_extension:use_lerp_rotation(not var_7_14)
		LocomotionUtils.set_animation_driven_movement(arg_7_1, var_7_14)

		local var_7_19 = var_7_0.attack_anims_data

		if var_7_14 then
			local var_7_20 = AiAnimUtils.get_animation_rotation_scale(arg_7_1, var_7_6, var_7_12, var_7_19)

			LocomotionUtils.set_animation_rotation_scale(arg_7_1, var_7_20)
		end

		local var_7_21 = Managers.state.network

		var_7_21:anim_event(arg_7_1, var_7_12)

		local var_7_22 = arg_7_2.shoot_data
		local var_7_23 = var_7_19[var_7_12]

		var_7_22.start_firing_t = arg_7_4 + var_7_23.start_firing_t
		var_7_22.stop_firing_t = arg_7_4 + var_7_23.stop_firing_t
		var_7_22.aim_start_t = arg_7_4 + var_7_23.aim_start_t
		var_7_22.firing_duration = var_7_22.stop_firing_t - var_7_22.start_firing_t
		var_7_22.firing_initiated = false

		local var_7_24 = var_7_0.aim_constraint_target[var_7_13]

		var_7_22.aim_start_position = Vector3Box(var_7_16)
		var_7_22.current_aim_position = Vector3Box(var_7_16)
		var_7_22.aim_end_position = Vector3Box(var_7_17)
		var_7_22.firewall_start_position = var_7_15 and Vector3Box(var_7_15) or nil
		var_7_22.direction = Vector3Box(var_7_7)
		var_7_22.aim_constraint_target_var = Unit.animation_find_constraint_target(arg_7_1, var_7_24)
		var_7_22.attack_arm = var_7_13
		var_7_22.firing_time = var_7_0.firing_time
		var_7_22.attack_animation = var_7_12
		var_7_22.aim_constraint_animations = var_7_0.aim_constraint_animations[var_7_13]
		var_7_22.hit_enemies = {}
		var_7_22.shoot_threat = {
			rotation = QuaternionBox()
		}

		local var_7_25 = var_7_21:game()
		local var_7_26 = Managers.state.unit_storage:go_id(arg_7_1)

		if var_7_25 and var_7_26 then
			local var_7_27 = NetworkLookup.attack_arm[var_7_13]

			GameSession.set_game_object_field(var_7_25, var_7_26, "attack_arm", var_7_27)
		end

		local var_7_28 = LocomotionUtils.look_at_position_flat(arg_7_1, var_7_16)

		arg_7_2.attack_rotation = QuaternionBox(var_7_28)
		arg_7_2.attack_started_at_t = arg_7_4

		local var_7_29 = var_7_0.bot_threats and (var_7_0.bot_threats[var_7_12] or var_7_0.bot_threats[1] and var_7_0.bot_threats)

		if var_7_29 then
			local var_7_30 = 1
			local var_7_31 = var_7_29[var_7_30]

			arg_7_2.create_bot_threat_at_t = arg_7_4 + var_7_31.start_time
			arg_7_2.current_bot_threat_index = var_7_30
			arg_7_2.bot_threats_data = var_7_29

			local var_7_32 = Vector3.flat(var_7_17 - var_7_4)

			arg_7_2.bot_threat_range = Vector3.length(var_7_32) - var_7_31.offset_forward + 1.5 * var_0_1
		end
	end

	return var_7_18
end

function BTStormfiendShootAction.leave(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_2.shoot_data
	local var_8_1 = Managers.state.network

	if var_8_0.aim_constraint_animations then
		local var_8_2 = var_8_0.aim_constraint_animations.off

		var_8_1:anim_event(arg_8_1, var_8_2)
	else
		var_8_1:anim_event(arg_8_1, "aim_at_right_off")
		var_8_1:anim_event(arg_8_1, "aim_at_left_off")
	end

	local var_8_3 = arg_8_2.weapon_setup

	if var_8_0.beam_active then
		local var_8_4 = arg_8_0.unit_ids[arg_8_1]
		local var_8_5 = NetworkLookup.attack_arm[var_8_0.attack_arm]

		arg_8_0.network_transmit:send_rpc_all("rpc_set_stormfiend_beam", var_8_4, var_8_5, false)

		var_8_0.beam_active = false
	end

	arg_8_0.unit_ids[arg_8_1] = nil
	var_8_0.ratling_gun_active = false

	arg_8_0:_stop_beam_sfx(arg_8_1, arg_8_2, var_8_0)

	local var_8_6 = arg_8_2.action
	local var_8_7 = var_8_0.attack_arm

	if var_8_7 then
		local var_8_8 = var_8_6.muzzle_nodes[var_8_7]
		local var_8_9 = Unit.node(arg_8_1, var_8_8)

		if var_8_6.stop_shoot_sfx then
			WwiseUtils.trigger_unit_event(arg_8_2.world, var_8_6.stop_shoot_sfx, arg_8_1, var_8_9)
		end
	end

	if var_8_0.shoot_threat and var_8_0.shoot_threat.handle then
		Managers.state.entity:system("ai_bot_group_system"):remove_threat(var_8_0.shoot_threat.handle)
	end

	table.clear(var_8_0)

	if not arg_8_5 then
		arg_8_2.locomotion_extension:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_8_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_8_1, 1)
	end

	arg_8_2.action = nil
	arg_8_2.active_node = nil
	arg_8_2.anim_locked = nil
	arg_8_2.attack_aborted = nil
	arg_8_2.attack_rotation = nil
	arg_8_2.attack_started_at_t = nil
	arg_8_2.keep_target = nil
	arg_8_2.weapon_setup = nil
	arg_8_2.bot_threats_data = nil
	arg_8_2.current_bot_threat_index = nil
	arg_8_2.create_bot_threat_at_t = nil
	arg_8_2.bot_threat_range = nil
	arg_8_2.shoot_sfx_id = nil
	arg_8_2.attacking_target = nil
end

function BTStormfiendShootAction.run(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if arg_9_2.attack_aborted or not Unit.alive(arg_9_2.attacking_target) then
		return "failed"
	end

	if arg_9_3 < arg_9_2.anim_locked then
		local var_9_0 = arg_9_2.shoot_data
		local var_9_1 = arg_9_2.weapon_setup

		if arg_9_3 < var_9_0.aim_start_t then
			-- block empty
		elseif not var_9_0.aim_constrained then
			arg_9_0:constrain_aim(arg_9_1, arg_9_2)

			var_9_0.aim_constrained = true
		elseif arg_9_3 < var_9_0.start_firing_t then
			-- block empty
		elseif not var_9_0.firing_initiated then
			if var_9_1 and var_9_1 == "ratling_gun" then
				arg_9_0:initiate_firing_ratling_gun(arg_9_2)
			else
				arg_9_0:initiate_firing_warpfire_thrower(arg_9_1, arg_9_2)

				local var_9_2 = arg_9_0.unit_ids[arg_9_1]
				local var_9_3 = NetworkLookup.attack_arm[var_9_0.attack_arm]

				arg_9_0.network_transmit:send_rpc_all("rpc_set_stormfiend_beam", var_9_2, var_9_3, true)

				var_9_0.beam_active = true
			end
		elseif arg_9_3 < var_9_0.stop_firing_t then
			if var_9_1 and var_9_1 == "ratling_gun" then
				arg_9_0:_update_ratling_gun(arg_9_1, arg_9_2, arg_9_3, arg_9_4)
			else
				arg_9_0:shoot_hit_check(arg_9_1, arg_9_2)
			end
		elseif var_9_0.is_firing then
			if var_9_0.beam_active then
				local var_9_4 = arg_9_0.unit_ids[arg_9_1]
				local var_9_5 = NetworkLookup.attack_arm[var_9_0.attack_arm]

				arg_9_0.network_transmit:send_rpc_all("rpc_set_stormfiend_beam", var_9_4, var_9_5, false)

				var_9_0.beam_active = false
			end

			if var_9_0.aim_constrained then
				local var_9_6 = Managers.state.network

				if var_9_0.aim_constraint_animations then
					local var_9_7 = var_9_0.aim_constraint_animations.off

					var_9_6:anim_event(arg_9_1, var_9_7)
				else
					var_9_6:anim_event(arg_9_1, "aim_at_right_off")
					var_9_6:anim_event(arg_9_1, "aim_at_left_off")
				end

				var_9_0.aim_constraint_animations = nil
			end

			if arg_9_2.shoot_sfx_id then
				WwiseWorld.stop_event(Managers.world:wwise_world(arg_9_2.world), arg_9_2.shoot_sfx_id)

				arg_9_2.shoot_sfx_id = nil
			end

			var_9_0.is_firing = false
		end

		local var_9_8 = arg_9_2.create_bot_threat_at_t

		if var_9_8 and var_9_8 < arg_9_3 then
			local var_9_9

			if var_9_0.current_gun_aim_position then
				local var_9_10, var_9_11 = arg_9_0:_fire_from_position_direction(arg_9_1, arg_9_2, var_9_0, arg_9_4)

				var_9_9 = Quaternion.look(var_9_11)
			else
				var_9_9 = arg_9_2.attack_rotation:unbox()
			end

			local var_9_12 = arg_9_2.bot_threats_data
			local var_9_13 = arg_9_2.current_bot_threat_index
			local var_9_14 = var_9_12[var_9_13]
			local var_9_15 = arg_9_2.bot_threat_range

			arg_9_0:_create_bot_aoe_threat(arg_9_1, var_9_9, var_9_14, var_9_15, var_9_0)

			local var_9_16 = var_9_13 + 1
			local var_9_17 = var_9_12[var_9_16]

			if var_9_17 then
				arg_9_2.create_bot_threat_at_t = arg_9_2.attack_started_at_t + var_9_17.start_time
				arg_9_2.current_bot_threat_index = var_9_16
			else
				arg_9_2.create_bot_threat_at_t = nil
				arg_9_2.current_bot_threat_index = nil
			end
		elseif var_9_0.shoot_threat.handle then
			local var_9_18

			if var_9_0.current_gun_aim_position then
				local var_9_19, var_9_20 = arg_9_0:_fire_from_position_direction(arg_9_1, arg_9_2, var_9_0, arg_9_4)

				var_9_18 = Quaternion.look(var_9_20)
			else
				var_9_18 = arg_9_2.attack_rotation:unbox()
			end

			if Quaternion.angle(var_9_18, var_9_0.shoot_threat.rotation:unbox()) > math.pi * 0.025 then
				local var_9_21 = var_9_0.shoot_threat.bot_threat
				local var_9_22 = var_9_0.shoot_threat.bot_threat_range

				arg_9_0:_create_bot_aoe_threat(arg_9_1, var_9_18, var_9_21, var_9_22, var_9_0)
			end
		end

		return "running"
	else
		return "done"
	end
end

function BTStormfiendShootAction._calculate_oobb_collision(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2
	local var_10_1 = arg_10_1.height
	local var_10_2 = arg_10_1.width
	local var_10_3 = arg_10_1.offset_up
	local var_10_4 = arg_10_1.offset_forward
	local var_10_5 = var_10_2 * 0.5
	local var_10_6 = var_10_0 * 0.5
	local var_10_7 = var_10_1 * 0.5
	local var_10_8 = Vector3(var_10_5, var_10_6, var_10_7)
	local var_10_9 = Quaternion.rotate(arg_10_4, Vector3.forward()) * (var_10_4 + var_10_6)
	local var_10_10 = Vector3.up() * (var_10_3 + var_10_7)

	return arg_10_3 + var_10_9 + var_10_10, arg_10_4, var_10_8
end

function BTStormfiendShootAction._create_bot_aoe_threat(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = Managers.state.entity:system("ai_bot_group_system")
	local var_11_1 = POSITION_LOOKUP[arg_11_1]
	local var_11_2 = arg_11_5.shoot_threat

	if var_11_2.handle then
		var_11_0:remove_threat(var_11_2.handle)
	end

	local var_11_3, var_11_4, var_11_5 = arg_11_0:_calculate_oobb_collision(arg_11_3, arg_11_4, var_11_1, arg_11_2)

	var_11_2.handle = var_11_0:aoe_threat_created(var_11_3, "oobb", var_11_5, var_11_4, math.huge, "Stormfiend")

	var_11_2.rotation:store(arg_11_2)

	var_11_2.bot_threat = arg_11_3
	var_11_2.bot_threat_range = arg_11_4
end

function BTStormfiendShootAction.constrain_aim(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_2.shoot_data

	if var_12_0 and var_12_0.aim_constraint_animations then
		local var_12_1 = arg_12_2.shoot_data
		local var_12_2 = Managers.state.network
		local var_12_3 = var_12_1.aim_constraint_animations.on

		var_12_2:anim_event(arg_12_1, var_12_3)

		var_12_1.aiming_started = true
	end
end

function BTStormfiendShootAction.create_firewall(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_3.firewall_start_position:unbox()
	local var_13_1 = arg_13_2.nav_world
	local var_13_2, var_13_3 = GwNavQueries.triangle_from_position(var_13_1, var_13_0, 1, 1)

	if var_13_2 then
		var_13_0 = Vector3.copy(var_13_0)
		var_13_0.z = var_13_3
	else
		var_13_0 = GwNavQueries.inside_position_from_outside_position(var_13_1, var_13_0, 3, 3, 1, 1)
	end

	if not var_13_0 then
		return
	end

	local var_13_4 = arg_13_3.direction:unbox()
	local var_13_5 = {
		area_damage_system = {
			liquid_template = "stormfiend_firewall",
			flow_dir = var_13_4,
			source_unit = arg_13_1
		}
	}
	local var_13_6 = "units/hub_elements/empty"
	local var_13_7 = Managers.state.unit_spawner:spawn_network_unit(var_13_6, "liquid_aoe_unit", var_13_5, var_13_0)

	ScriptUnit.extension(var_13_7, "area_damage_system"):ready()
end

function BTStormfiendShootAction.shoot_hit_check(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_2.action
	local var_14_1 = arg_14_2.shoot_data
	local var_14_2 = var_14_1.attack_arm
	local var_14_3 = var_14_0.muzzle_nodes[var_14_2]
	local var_14_4 = Unit.node(arg_14_1, var_14_3)
	local var_14_5 = Unit.world_position(arg_14_1, var_14_4)
	local var_14_6 = var_14_1.current_aim_position:unbox()
	local var_14_7 = arg_14_2.physics_world
	local var_14_8 = var_0_1
	local var_14_9 = var_0_2
	local var_14_10 = PhysicsWorld.linear_sphere_sweep(var_14_7, var_14_5, var_14_6, var_14_8, var_14_9, "collision_filter", "filter_enemy_player_ray_projectile", "report_initial_overlap")

	if var_14_10 then
		local var_14_11 = var_14_0.immune_breeds
		local var_14_12 = #var_14_10

		for iter_14_0 = 1, var_14_12 do
			local var_14_13 = var_14_10[iter_14_0]
			local var_14_14 = var_14_13.actor
			local var_14_15 = Actor.unit(var_14_14)
			local var_14_16 = var_14_13.position

			if not DamageUtils.is_character(var_14_15) then
				break
			end

			local var_14_17 = HEALTH_ALIVE[var_14_15]

			if var_14_15 ~= arg_14_1 and var_14_17 then
				local var_14_18 = DamageUtils.is_player_unit(var_14_15)
				local var_14_19 = var_14_1.hit_enemies
				local var_14_20 = not var_14_18 and Unit.get_data(var_14_15, "breed")

				if var_14_18 then
					if not ScriptUnit.extension(var_14_15, "buff_system"):has_buff_type("stormfiend_warpfire_face") then
						Managers.state.entity:system("buff_system"):add_buff(var_14_15, "stormfiend_warpfire_face_base", arg_14_1)

						arg_14_2.has_dealt_burn_damage = true
					end
				elseif var_14_20 and not var_14_11[var_14_20.name] and not var_14_19[var_14_15] then
					local var_14_21 = arg_14_1
					local var_14_22 = var_14_20.armor_category or 1
					local var_14_23 = var_14_0.damage_type
					local var_14_24 = var_14_0.damage[var_14_22]
					local var_14_25 = var_14_1.direction:unbox()
					local var_14_26 = arg_14_2.breed.name

					DamageUtils.add_damage_network(var_14_15, var_14_21, var_14_24, "torso", var_14_23, var_14_16, var_14_25, var_14_26, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, iter_14_0)

					var_14_19[var_14_15] = true
				end
			end
		end
	end
end

function BTStormfiendShootAction._stop_beam_sfx(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_2.action
	local var_15_1 = arg_15_3.attack_arm
	local var_15_2 = var_15_0.muzzle_nodes[var_15_1]
	local var_15_3 = var_15_0.beam_sfx_stop_event

	Managers.state.entity:system("audio_system"):play_audio_unit_event(var_15_3, arg_15_1, var_15_2)
end

function BTStormfiendShootAction.initiate_firing_warpfire_thrower(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_2.action
	local var_16_1 = arg_16_2.shoot_data

	if var_16_1.firewall_start_position then
		arg_16_0:create_firewall(arg_16_1, arg_16_2, var_16_1)
	end

	local var_16_2 = var_16_1.attack_arm
	local var_16_3 = var_16_0.muzzle_nodes[var_16_2]
	local var_16_4 = var_16_0.beam_sfx_start_event

	Managers.state.entity:system("audio_system"):play_audio_unit_event(var_16_4, arg_16_1, var_16_3)

	var_16_1.firing_initiated = true
	var_16_1.is_firing = true
end

function BTStormfiendShootAction._fire_from_position_direction(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = arg_17_2.action
	local var_17_1 = arg_17_3.attack_arm
	local var_17_2 = var_17_0.muzzle_nodes[var_17_1]
	local var_17_3 = Unit.node(arg_17_1, var_17_2)
	local var_17_4 = Unit.world_position(arg_17_1, var_17_3)
	local var_17_5 = Unit.world_position(arg_17_2.attacking_target, Unit.node(arg_17_2.attacking_target, "j_spine"))
	local var_17_6 = arg_17_3.current_gun_aim_position:unbox()
	local var_17_7 = math.min(arg_17_4 * 6, 1)
	local var_17_8 = Vector3.lerp(var_17_6, var_17_5, var_17_7)
	local var_17_9 = Vector3.normalize(var_17_8 - var_17_4)

	arg_17_3.current_gun_aim_position:store(var_17_8)

	return var_17_4 - Vector3.normalize(var_17_9) * 1.25, var_17_9
end

function BTStormfiendShootAction._update_ratling_gun(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = arg_18_2.shoot_data
	local var_18_1 = arg_18_3 - var_18_0.start_firing_t
	local var_18_2 = math.clamp(var_18_1 / var_18_0.firing_duration * var_18_0.max_fire_rate_at_percentage_modifier, 0, 1)
	local var_18_3 = math.lerp(var_18_0.time_between_shots_at_start, var_18_0.time_between_shots_at_end, var_18_2)
	local var_18_4 = math.floor(var_18_1 / var_18_3) + 1 - var_18_0.shots_fired

	for iter_18_0 = 1, var_18_4 do
		var_18_0.shots_fired = var_18_0.shots_fired + 1

		arg_18_0:_shoot_ratling_gun(arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	end
end

local var_0_3 = math.pi * 2

function BTStormfiendShootAction._shoot_ratling_gun(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_2.action
	local var_19_1 = arg_19_2.shoot_data
	local var_19_2 = var_19_0.light_weight_projectile_template_name
	local var_19_3 = LightWeightProjectiles[var_19_2]
	local var_19_4, var_19_5 = arg_19_0:_fire_from_position_direction(arg_19_1, arg_19_2, var_19_1, arg_19_4)
	local var_19_6 = Vector3.normalize(var_19_5)
	local var_19_7 = Math.random() * var_19_3.spread
	local var_19_8 = Quaternion.look(var_19_6, Vector3.up())
	local var_19_9 = Quaternion(Vector3.right(), var_19_7)
	local var_19_10 = Quaternion(Vector3.forward(), Math.random() * var_0_3)
	local var_19_11 = Quaternion.multiply(Quaternion.multiply(var_19_8, var_19_10), var_19_9)
	local var_19_12 = Quaternion.forward(var_19_11)
	local var_19_13 = "filter_enemy_player_ray_projectile"
	local var_19_14 = Managers.state.difficulty:get_difficulty_rank()
	local var_19_15 = var_19_3.attack_power_level[var_19_14] or var_19_3.attack_power_level[2]
	local var_19_16 = {
		power_level = var_19_15,
		damage_profile = var_19_3.damage_profile,
		hit_effect = var_19_3.hit_effect,
		player_push_velocity = Vector3Box(var_19_6 * var_19_3.impact_push_speed),
		projectile_linker = var_19_3.projectile_linker,
		first_person_hit_flow_events = var_19_3.first_person_hit_flow_events
	}
	local var_19_17 = var_19_1.attack_arm
	local var_19_18 = var_19_0.muzzle_nodes[var_19_17]
	local var_19_19 = Unit.node(arg_19_1, var_19_18)

	if var_19_0.shoot_sfx and not arg_19_2.shoot_sfx_id then
		arg_19_2.shoot_sfx_id = WwiseUtils.trigger_unit_event(arg_19_2.world, var_19_0.shoot_sfx, arg_19_1, var_19_19)
	end

	local var_19_20 = Managers.state.entity:system("projectile_system")
	local var_19_21 = Network.peer_id()

	var_19_20:create_light_weight_projectile(Unit.get_data(arg_19_1, "breed").name, arg_19_1, var_19_4, var_19_12, var_19_3.projectile_speed, nil, nil, var_19_3.projectile_max_range, var_19_13, var_19_16, var_19_3.light_weight_projectile_effect, var_19_21)
end

function BTStormfiendShootAction.initiate_firing_ratling_gun(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.action
	local var_20_1 = arg_20_1.shoot_data

	var_20_1.shots_fired = 0
	var_20_1.time_between_shots_at_start = 1 / var_20_0.fire_rate_at_start
	var_20_1.time_between_shots_at_end = 1 / var_20_0.fire_rate_at_end
	var_20_1.max_fire_rate_at_percentage_modifier = 1 / var_20_0.max_fire_rate_at_percentage
	var_20_1.current_gun_aim_position = Vector3Box(POSITION_LOOKUP[arg_20_1.attacking_target])
	var_20_1.firing_initiated = true
	var_20_1.is_firing = true
end

function BTStormfiendShootAction._debug_firewall(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	if script_data.debug_stormfiend then
		local var_21_0 = Managers.state.debug:drawer({
			mode = "retained",
			name = "BTStormfiendShootAction"
		})
		local var_21_1 = Colors.get("green")
		local var_21_2 = Colors.get("yellow")
		local var_21_3 = Colors.get("red")
		local var_21_4 = arg_21_4 and Vector3.distance(arg_21_4, arg_21_5) or 0
		local var_21_5 = arg_21_4 or arg_21_2
		local var_21_6 = arg_21_5 or arg_21_3
		local var_21_7 = arg_21_3 - var_21_5

		var_21_0:sphere(var_21_5, 0.25, arg_21_4 and var_21_1 or var_21_3)
		var_21_0:vector(var_21_5, var_21_7, var_21_2)
		var_21_0:sphere(var_21_6, 0.25, arg_21_1 < var_21_4 and var_21_1 or var_21_3)
		var_0_0("FIREWALL DISTANCE", var_21_4, "MINIMUM DISTANCE", arg_21_1)
	end
end

function BTStormfiendShootAction._debug_fire_beam(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	if script_data.debug_stormfiend then
		local var_22_0
		local var_22_1
		local var_22_2
		local var_22_3
		local var_22_4
		local var_22_5

		if arg_22_6 == "retained" then
			var_22_1, var_22_2 = Colors.get("green"), Colors.get("red")
			var_22_3, var_22_4, var_22_5 = Colors.get("gold"), Colors.get("dark_orange"), Colors.get("gray")
			var_22_0 = Managers.state.debug:drawer({
				mode = "retained",
				name = "BTStormfiendShootAction"
			})
		else
			var_22_1, var_22_2 = Colors.get("light_green"), Colors.get("indian_red")
			var_22_3, var_22_4, var_22_5 = Colors.get("yellow"), Colors.get("orange"), Colors.get("light_gray")
			var_22_0 = QuickDrawer
		end

		var_22_0:sphere(arg_22_1, var_0_1, arg_22_3 and var_22_1 or var_22_2)
		var_22_0:line(arg_22_1, arg_22_2, arg_22_3 and var_22_1 or var_22_2)
		var_22_0:sphere(arg_22_2, var_0_1, arg_22_3 and var_22_1 or var_22_2)

		if arg_22_5 then
			local var_22_6 = #arg_22_5
			local var_22_7 = Vector3.normalize(arg_22_2 - arg_22_1)

			for iter_22_0 = 1, var_22_6 do
				local var_22_8 = arg_22_5[iter_22_0]
				local var_22_9 = var_22_8.distance
				local var_22_10 = var_22_8.position
				local var_22_11 = arg_22_1 + var_22_7 * var_22_9
				local var_22_12

				if arg_22_4 == nil or iter_22_0 < arg_22_4 then
					var_22_12 = var_22_3
				elseif iter_22_0 == arg_22_4 then
					var_22_12 = var_22_4
				else
					var_22_12 = var_22_5
				end

				var_22_0:sphere(var_22_11, var_0_1, var_22_12)
				var_22_0:sphere(var_22_10, 0.05, var_22_12)
			end
		end
	end
end

function BTStormfiendShootAction._debug_colliding_arm(arg_23_0, arg_23_1, arg_23_2)
	if script_data.debug_stormfiend then
		local var_23_0 = Managers.state.debug:drawer({
			mode = "retained",
			name = "BTStormfiendShootAction"
		})

		var_23_0:sphere(arg_23_1, 0.1, Colors.get("black"))
		var_23_0:line(arg_23_1, arg_23_2, Colors.get("black"))
		var_23_0:sphere(arg_23_2, 0.1, Colors.get("black"))
	end
end
