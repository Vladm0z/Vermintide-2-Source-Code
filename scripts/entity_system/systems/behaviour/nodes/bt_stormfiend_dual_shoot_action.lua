-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_stormfiend_dual_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTStormfiendDualShootAction = class(BTStormfiendDualShootAction, BTNode)

function BTStormfiendDualShootAction.init(arg_1_0, ...)
	BTStormfiendDualShootAction.super.init(arg_1_0, ...)
end

BTStormfiendDualShootAction.name = "BTStormfiendDualShootAction"

local var_0_0 = 0.4
local var_0_1 = 10
local var_0_2 = Unit.alive

function BTStormfiendDualShootAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.world

	arg_2_2.action = var_2_0
	arg_2_2.active_node = BTStormfiendDualShootAction
	arg_2_2.attack_finished = false
	arg_2_2.shoot_data = arg_2_2.shoot_data or {}
	arg_2_2.physics_world = arg_2_2.physics_world or World.get_data(var_2_1, "physics_world")
	arg_2_2.anim_locked = arg_2_3 + var_2_0.attack_duration
	arg_2_2.move_state = "attacking"
	arg_2_2.attack_aborted = false
	arg_2_2.keep_target = true
	arg_2_2.find_new_shoot_position = nil
	arg_2_2.left_muzzle_node = Unit.node(arg_2_1, "fx_left_muzzle")
	arg_2_2.right_muzzle_node = Unit.node(arg_2_1, "fx_right_muzzle")
	arg_2_2.weapon_setup = var_2_0.weapon_setup
	arg_2_2.shoot_data.start_firing_t = arg_2_3 + var_2_0.start_firing_t

	Managers.state.network:anim_event(arg_2_1, var_2_0.attack_animation)

	arg_2_2.rotation_time = arg_2_3 + var_2_0.rotation_time

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_2_2 = arg_2_2.target_unit

	AiUtils.add_attack_intensity(var_2_2, var_2_0, arg_2_2)
end

function BTStormfiendDualShootAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.action = nil
	arg_3_2.active_node = nil
	arg_3_2.anim_locked = nil
	arg_3_2.attack_aborted = nil
	arg_3_2.attack_rotation = nil
	arg_3_2.attack_started_at_t = nil
	arg_3_2.keep_target = nil
	arg_3_2.weapon_setup = nil
	arg_3_2.bot_threats_data = nil
	arg_3_2.current_bot_threat_index = nil
	arg_3_2.create_bot_threat_at_t = nil
	arg_3_2.bot_threat_range = nil
	arg_3_2.shoot_sfx_id = nil
end

function BTStormfiendDualShootAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.attack_aborted or not var_0_2(arg_4_2.target_unit) then
		return "failed"
	end

	if arg_4_3 < arg_4_2.rotation_time then
		local var_4_0 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, arg_4_2.target_unit)
		local var_4_1 = arg_4_2.action.rotation_speed

		if var_4_1 then
			arg_4_2.locomotion_extension:use_lerp_rotation(true)
			arg_4_2.locomotion_extension:set_rotation_speed(var_4_1)
		end

		arg_4_2.locomotion_extension:set_wanted_rotation(var_4_0)
	end

	if arg_4_3 < arg_4_2.anim_locked then
		local var_4_2 = arg_4_2.shoot_data
		local var_4_3 = arg_4_2.weapon_setup

		if arg_4_3 < var_4_2.start_firing_t then
			-- block empty
		elseif not var_4_2.firing_initiated then
			arg_4_0:initiate_firing(arg_4_2, arg_4_3)
		elseif arg_4_3 < var_4_2.stop_firing_t then
			if var_4_3 and var_4_3 == "ratling_gun" then
				arg_4_0:_update_ratling_gun(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
			else
				arg_4_0:shoot_hit_check(arg_4_1, arg_4_2)
			end
		elseif var_4_2.is_firing then
			if var_4_3 and var_4_3 == "warpfire_thrower" then
				arg_4_0:_stop_beam_sfx(arg_4_1, arg_4_2, var_4_2)
			end

			if arg_4_2.shoot_sfx_id_1 then
				WwiseWorld.stop_event(Managers.world:wwise_world(arg_4_2.world), arg_4_2.shoot_sfx_id_1)
				WwiseWorld.stop_event(Managers.world:wwise_world(arg_4_2.world), arg_4_2.shoot_sfx_id_2)

				arg_4_2.shoot_sfx_id_1 = nil
				arg_4_2.shoot_sfx_id_2 = nil
			end

			var_4_2.is_firing = false
		end

		if arg_4_2.attack_finished then
			arg_4_2.attack_finished = nil

			local var_4_4 = arg_4_2.action

			if var_4_4.stop_shoot_sfx then
				WwiseUtils.trigger_unit_event(arg_4_2.world, var_4_4.stop_shoot_sfx, arg_4_1, Unit.node(arg_4_1, "fx_left_muzzle"))
				WwiseUtils.trigger_unit_event(arg_4_2.world, var_4_4.stop_shoot_sfx, arg_4_1, Unit.node(arg_4_1, "fx_right_muzzle"))
			end
		end

		return "running"
	else
		return "done"
	end
end

function BTStormfiendDualShootAction.create_firewall(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.firewall_start_position:unbox()
	local var_5_1 = arg_5_2.direction:unbox()
	local var_5_2 = {
		area_damage_system = {
			liquid_template = "stormfiend_firewall",
			flow_dir = var_5_1,
			source_unit = arg_5_1
		}
	}
	local var_5_3 = "units/hub_elements/empty"
	local var_5_4 = Managers.state.unit_spawner:spawn_network_unit(var_5_3, "liquid_aoe_unit", var_5_2, var_5_0)

	ScriptUnit.extension(var_5_4, "area_damage_system"):ready()
end

function BTStormfiendDualShootAction.shoot_hit_check(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.action
	local var_6_1 = arg_6_2.shoot_data
	local var_6_2 = var_6_1.attack_arm
	local var_6_3 = var_6_0.muzzle_nodes[var_6_2]
	local var_6_4 = Unit.node(arg_6_1, var_6_3)
	local var_6_5 = Unit.world_position(arg_6_1, var_6_4)
	local var_6_6 = var_6_1.current_aim_position:unbox()
	local var_6_7 = arg_6_2.physics_world
	local var_6_8 = var_0_0
	local var_6_9 = var_0_1
	local var_6_10 = PhysicsWorld.linear_sphere_sweep(var_6_7, var_6_5, var_6_6, var_6_8, var_6_9, "collision_filter", "filter_enemy_player_ray_projectile", "report_initial_overlap")

	if var_6_10 then
		local var_6_11 = var_6_0.immune_breeds
		local var_6_12 = #var_6_10

		for iter_6_0 = 1, var_6_12 do
			local var_6_13 = var_6_10[iter_6_0]
			local var_6_14 = var_6_13.actor
			local var_6_15 = Actor.unit(var_6_14)
			local var_6_16 = var_6_13.position

			if not DamageUtils.is_character(var_6_15) then
				break
			end

			local var_6_17 = HEALTH_ALIVE[var_6_15]

			if var_6_15 ~= arg_6_1 and var_6_17 then
				local var_6_18 = DamageUtils.is_player_unit(var_6_15)
				local var_6_19 = var_6_1.hit_enemies
				local var_6_20 = not var_6_18 and Unit.get_data(var_6_15, "breed")

				if var_6_18 then
					if not ScriptUnit.extension(var_6_15, "buff_system"):has_buff_type("stormfiend_warpfire_face") then
						Managers.state.entity:system("buff_system"):add_buff(var_6_15, "stormfiend_warpfire_face_base", arg_6_1)
					end
				elseif var_6_20 and not var_6_11[var_6_20.name] and not var_6_19[var_6_15] then
					local var_6_21 = arg_6_1
					local var_6_22 = var_6_20.armor_category or 1
					local var_6_23 = var_6_0.damage_type
					local var_6_24 = var_6_0.damage[var_6_22]
					local var_6_25 = var_6_1.direction:unbox()
					local var_6_26 = arg_6_2.breed.name

					DamageUtils.add_damage_network(var_6_15, var_6_21, var_6_24, "torso", var_6_23, var_6_16, var_6_25, var_6_26, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, iter_6_0)

					var_6_19[var_6_15] = true
				end
			end
		end
	end
end

function BTStormfiendDualShootAction._stop_beam_sfx(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2.action
	local var_7_1 = arg_7_3.attack_arm
	local var_7_2 = var_7_0.muzzle_nodes[var_7_1]
	local var_7_3 = var_7_0.beam_sfx_stop_event

	Managers.state.entity:system("audio_system"):play_audio_unit_event(var_7_3, arg_7_1, var_7_2)
end

function BTStormfiendDualShootAction._fire_from_position_direction(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_2.action
	local var_8_1 = Unit.node(arg_8_1, arg_8_5)
	local var_8_2 = Unit.world_position(arg_8_1, var_8_1)
	local var_8_3 = Unit.world_rotation(arg_8_1, var_8_1)
	local var_8_4

	if arg_8_5 == "fx_right_muzzle" then
		var_8_4 = Quaternion.look(Vector3.right())
	else
		var_8_4 = Quaternion.look(Vector3.right() + Vector3.up() * 0.2)
	end

	local var_8_5 = Quaternion.multiply(var_8_3, var_8_4)
	local var_8_6 = var_8_2 + Quaternion.forward(var_8_5)
	local var_8_7 = Vector3.normalize(var_8_6 - var_8_2)

	return var_8_2 - Vector3.normalize(var_8_7) * 1.25, var_8_7
end

function BTStormfiendDualShootAction._update_ratling_gun(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_2.shoot_data
	local var_9_1 = arg_9_3 - var_9_0.start_firing_t
	local var_9_2 = math.clamp(var_9_1 / var_9_0.firing_duration * var_9_0.max_fire_rate_at_percentage_modifier, 0, 1)
	local var_9_3 = math.lerp(var_9_0.time_between_shots_at_start, var_9_0.time_between_shots_at_end, var_9_2)
	local var_9_4 = math.floor(var_9_1 / var_9_3) + 1 - var_9_0.shots_fired

	for iter_9_0 = 1, var_9_4 do
		var_9_0.shots_fired = var_9_0.shots_fired + 1

		arg_9_0:_shoot_ratling_gun(arg_9_1, arg_9_2, arg_9_3, arg_9_4, "fx_left_muzzle")
		arg_9_0:_shoot_ratling_gun(arg_9_1, arg_9_2, arg_9_3, arg_9_4, "fx_right_muzzle")
	end

	local var_9_5 = arg_9_2.action

	if var_9_5.shoot_sfx and not arg_9_2.shoot_sfx_id_1 then
		arg_9_2.shoot_sfx_id_1 = WwiseUtils.trigger_unit_event(arg_9_2.world, var_9_5.shoot_sfx, arg_9_1, Unit.node(arg_9_1, "fx_left_muzzle"))
		arg_9_2.shoot_sfx_id_2 = WwiseUtils.trigger_unit_event(arg_9_2.world, var_9_5.shoot_sfx, arg_9_1, Unit.node(arg_9_1, "fx_right_muzzle"))
	end
end

local var_0_3 = math.pi * 2

function BTStormfiendDualShootAction._shoot_ratling_gun(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = arg_10_2.action
	local var_10_1 = arg_10_2.shoot_data
	local var_10_2 = var_10_0.light_weight_projectile_template_name
	local var_10_3 = LightWeightProjectiles[var_10_2]
	local var_10_4, var_10_5 = arg_10_0:_fire_from_position_direction(arg_10_1, arg_10_2, var_10_1, arg_10_4, arg_10_5)
	local var_10_6 = Vector3.normalize(var_10_5)
	local var_10_7 = Math.random() * var_10_3.spread
	local var_10_8 = Quaternion.look(var_10_6, Vector3.up())
	local var_10_9 = Quaternion(Vector3.right(), var_10_7)
	local var_10_10 = Quaternion(Vector3.forward(), Math.random() * var_0_3)
	local var_10_11 = Quaternion.multiply(Quaternion.multiply(var_10_8, var_10_10), var_10_9)
	local var_10_12 = Quaternion.forward(var_10_11)
	local var_10_13 = "filter_enemy_player_ray_projectile"
	local var_10_14 = Managers.state.difficulty:get_difficulty_rank()
	local var_10_15 = var_10_3.attack_power_level[var_10_14] or var_10_3.attack_power_level[2]
	local var_10_16 = {
		power_level = var_10_15,
		damage_profile = var_10_3.damage_profile,
		hit_effect = var_10_3.hit_effect,
		player_push_velocity = Vector3Box(var_10_6 * var_10_3.impact_push_speed),
		projectile_linker = var_10_3.projectile_linker,
		first_person_hit_flow_events = var_10_3.first_person_hit_flow_events
	}
	local var_10_17 = Managers.state.entity:system("projectile_system")
	local var_10_18 = Network.peer_id()

	var_10_17:create_light_weight_projectile(arg_10_2.breed.name, arg_10_1, var_10_4, var_10_12, var_10_3.projectile_speed, nil, nil, var_10_3.projectile_max_range, var_10_13, var_10_16, var_10_3.light_weight_projectile_effect, var_10_18)
end

function BTStormfiendDualShootAction.initiate_firing(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1.action
	local var_11_1 = arg_11_1.shoot_data

	var_11_1.firing_duration = var_11_0.firing_duration
	var_11_1.shots_fired = 0
	var_11_1.time_between_shots_at_start = 1 / var_11_0.fire_rate_at_start
	var_11_1.time_between_shots_at_end = 1 / var_11_0.fire_rate_at_end
	var_11_1.max_fire_rate_at_percentage_modifier = 1 / var_11_0.max_fire_rate_at_percentage
	var_11_1.current_gun_aim_position = Vector3Box(POSITION_LOOKUP[arg_11_1.target_unit])
	var_11_1.start_firing_t = arg_11_2
	var_11_1.stop_firing_t = arg_11_2 + var_11_0.firing_duration
	var_11_1.firing_initiated = true
	var_11_1.is_firing = true
end
