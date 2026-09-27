-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_stormfiend_dual_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTStormfiendDualShootAction = class(BTStormfiendDualShootAction, BTNode)

BTStormfiendDualShootAction.init = function (arg_1_0, ...)
	-- function 1
	BTStormfiendDualShootAction.super.init(arg_1_0, ...)
end

BTStormfiendDualShootAction.name = "BTStormfiendDualShootAction"

local num = 0.4
local num_2 = 10
local alive = Unit.alive

BTStormfiendDualShootAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local world = arg_2_2.world

	arg_2_2.action = action_data
	arg_2_2.active_node = BTStormfiendDualShootAction
	arg_2_2.attack_finished = false

	local shoot_data = arg_2_2.shoot_data

	shoot_data = shoot_data or {}
	arg_2_2.shoot_data = shoot_data

	local physics_world = arg_2_2.physics_world

	physics_world = physics_world or World.get_data(world, "physics_world")
	arg_2_2.physics_world = physics_world
	arg_2_2.anim_locked = arg_2_3 + action_data.attack_duration
	arg_2_2.move_state = "attacking"
	arg_2_2.attack_aborted = false
	arg_2_2.keep_target = true
	arg_2_2.find_new_shoot_position = nil
	arg_2_2.left_muzzle_node = Unit.node(arg_2_1, "fx_left_muzzle")
	arg_2_2.right_muzzle_node = Unit.node(arg_2_1, "fx_right_muzzle")
	arg_2_2.weapon_setup = action_data.weapon_setup
	arg_2_2.shoot_data.start_firing_t = arg_2_3 + action_data.start_firing_t

	Managers.state.network:anim_event(arg_2_1, action_data.attack_animation)

	arg_2_2.rotation_time = arg_2_3 + action_data.rotation_time

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local target_unit = arg_2_2.target_unit

	AiUtils.add_attack_intensity(target_unit, action_data, arg_2_2)
end

BTStormfiendDualShootAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
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

BTStormfiendDualShootAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not (arg_4_2.attack_aborted or alive(arg_4_2.target_unit)) then
		return "failed"
	end

	if arg_4_3 < arg_4_2.rotation_time then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, arg_4_2.target_unit)
		local rotation_speed = arg_4_2.action.rotation_speed

		if not rotation_speed then
			arg_4_2.locomotion_extension:use_lerp_rotation(true)
			arg_4_2.locomotion_extension:set_rotation_speed(rotation_speed)
		end

		arg_4_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	end

	if arg_4_3 < arg_4_2.anim_locked then
		local shoot_data = arg_4_2.shoot_data
		local weapon_setup = arg_4_2.weapon_setup

		if arg_4_3 < shoot_data.start_firing_t then
			-- Nothing
		elseif not shoot_data.firing_initiated then
			self:initiate_firing(arg_4_2, arg_4_3)
		elseif arg_4_3 < shoot_data.stop_firing_t then
			if not (not weapon_setup and weapon_setup ~= "ratling_gun") then
				self:_update_ratling_gun(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
			else
				self:shoot_hit_check(arg_4_1, arg_4_2)
			end
		elseif not shoot_data.is_firing then
			if not (not weapon_setup and weapon_setup ~= "warpfire_thrower") then
				self:_stop_beam_sfx(arg_4_1, arg_4_2, shoot_data)
			end

			if not arg_4_2.shoot_sfx_id_1 then
				WwiseWorld.stop_event(Managers.world:wwise_world(arg_4_2.world), arg_4_2.shoot_sfx_id_1)
				WwiseWorld.stop_event(Managers.world:wwise_world(arg_4_2.world), arg_4_2.shoot_sfx_id_2)

				arg_4_2.shoot_sfx_id_1 = nil
				arg_4_2.shoot_sfx_id_2 = nil
			end

			shoot_data.is_firing = false
		end

		if not arg_4_2.attack_finished then
			arg_4_2.attack_finished = nil

			local action = arg_4_2.action

			if not action.stop_shoot_sfx then
				WwiseUtils.trigger_unit_event(arg_4_2.world, action.stop_shoot_sfx, arg_4_1, Unit.node(arg_4_1, "fx_left_muzzle"))
				WwiseUtils.trigger_unit_event(arg_4_2.world, action.stop_shoot_sfx, arg_4_1, Unit.node(arg_4_1, "fx_right_muzzle"))
			end
		end

		return "running"
	else
		return "done"
	end
end

BTStormfiendDualShootAction.create_firewall = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local unbox = arg_5_2.firewall_start_position:unbox()
	local unbox_2 = arg_5_2.direction:unbox()
	local tbl = {
		area_damage_system = {
			liquid_template = "stormfiend_firewall",
			flow_dir = unbox_2,
			source_unit = arg_5_1
		}
	}
	local str = "units/hub_elements/empty"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, unbox)

	ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
end

BTStormfiendDualShootAction.shoot_hit_check = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local action = arg_6_2.action
	local shoot_data = arg_6_2.shoot_data
	local attack_arm = shoot_data.attack_arm
	local var_6_3 = action.muzzle_nodes[attack_arm]
	local node = Unit.node(arg_6_1, var_6_3)
	local world_position = Unit.world_position(arg_6_1, node)
	local unbox = shoot_data.current_aim_position:unbox()
	local physics_world = arg_6_2.physics_world
	local var_6_8 = num
	local var_6_9 = num_2
	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(physics_world, world_position, unbox, var_6_8, var_6_9, "collision_filter", "filter_enemy_player_ray_projectile", "report_initial_overlap")

	if not linear_sphere_sweep then
		local immune_breeds = action.immune_breeds
		local count = #linear_sphere_sweep

		for i = 1, count do
			local var_6_13 = linear_sphere_sweep[i]
			local actor = var_6_13.actor
			local unit = Actor.unit(actor)
			local position = var_6_13.position

			if not DamageUtils.is_character(unit) then
				break
			end

			local var_6_17 = HEALTH_ALIVE[unit]

			if unit == arg_6_1 or not var_6_17 then
				local is_player_unit = DamageUtils.is_player_unit(unit)
				local hit_enemies = shoot_data.hit_enemies
				local flag = not not is_player_unit or Unit.get_data(unit, "breed")

				if not is_player_unit then
					if not ScriptUnit.extension(unit, "buff_system"):has_buff_type("stormfiend_warpfire_face") then
						Managers.state.entity:system("buff_system"):add_buff(unit, "stormfiend_warpfire_face_base", arg_6_1)
					end
				elseif not (not flag and immune_breeds[flag.name] or hit_enemies[unit]) then
					local var_6_21 = arg_6_1
					local armor_category = flag.armor_category

					armor_category = armor_category or 1

					local damage_type = action.damage_type
					local var_6_24 = action.damage[armor_category]
					local unbox_2 = shoot_data.direction:unbox()
					local name = arg_6_2.breed.name

					DamageUtils.add_damage_network(unit, var_6_21, var_6_24, "torso", damage_type, position, unbox_2, name, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, i)

					hit_enemies[unit] = true
				end
			end
		end
	end
end

BTStormfiendDualShootAction._stop_beam_sfx = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local action = arg_7_2.action
	local attack_arm = arg_7_3.attack_arm
	local var_7_2 = action.muzzle_nodes[attack_arm]
	local beam_sfx_stop_event = action.beam_sfx_stop_event

	Managers.state.entity:system("audio_system"):play_audio_unit_event(beam_sfx_stop_event, arg_7_1, var_7_2)
end

BTStormfiendDualShootAction._fire_from_position_direction = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local action = arg_8_2.action
	local node = Unit.node(arg_8_1, arg_8_5)
	local world_position = Unit.world_position(arg_8_1, node)
	local world_rotation = Unit.world_rotation(arg_8_1, node)
	local var_8_4

	if arg_8_5 == "fx_right_muzzle" then
		var_8_4 = Quaternion.look(Vector3.right())
	else
		var_8_4 = Quaternion.look(Vector3.right() + Vector3.up() * 0.2)
	end

	local multiply = Quaternion.multiply(world_rotation, var_8_4)
	local num = world_position + Quaternion.forward(multiply)
	local normalize = Vector3.normalize(num - world_position)

	return world_position - Vector3.normalize(normalize) * 1.25, normalize
end

BTStormfiendDualShootAction._update_ratling_gun = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local shoot_data = arg_9_2.shoot_data
	local num = arg_9_3 - shoot_data.start_firing_t
	local clamp = math.clamp(num / shoot_data.firing_duration * shoot_data.max_fire_rate_at_percentage_modifier, 0, 1)
	local lerp = math.lerp(shoot_data.time_between_shots_at_start, shoot_data.time_between_shots_at_end, clamp)
	local num_2 = math.floor(num / lerp) + 1 - shoot_data.shots_fired

	for i = 1, num_2 do
		shoot_data.shots_fired = shoot_data.shots_fired + 1

		self:_shoot_ratling_gun(arg_9_1, arg_9_2, arg_9_3, arg_9_4, "fx_left_muzzle")
		self:_shoot_ratling_gun(arg_9_1, arg_9_2, arg_9_3, arg_9_4, "fx_right_muzzle")
	end

	local action = arg_9_2.action

	if not (not action.shoot_sfx and arg_9_2.shoot_sfx_id_1) then
		arg_9_2.shoot_sfx_id_1 = WwiseUtils.trigger_unit_event(arg_9_2.world, action.shoot_sfx, arg_9_1, Unit.node(arg_9_1, "fx_left_muzzle"))
		arg_9_2.shoot_sfx_id_2 = WwiseUtils.trigger_unit_event(arg_9_2.world, action.shoot_sfx, arg_9_1, Unit.node(arg_9_1, "fx_right_muzzle"))
	end
end

local num_3 = math.pi * 2

BTStormfiendDualShootAction._shoot_ratling_gun = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local action = arg_10_2.action
	local shoot_data = arg_10_2.shoot_data
	local light_weight_projectile_template_name = action.light_weight_projectile_template_name
	local var_10_3 = LightWeightProjectiles[light_weight_projectile_template_name]
	local _fire_from_position_direction, var_10_5 = self:_fire_from_position_direction(arg_10_1, arg_10_2, shoot_data, arg_10_4, arg_10_5)
	local normalize = Vector3.normalize(var_10_5)
	local num = Math.random() * var_10_3.spread
	local look = Quaternion.look(normalize, Vector3.up())
	local var_10_9 = Quaternion(Vector3.right(), num)
	local var_10_10 = Quaternion(Vector3.forward(), Math.random() * num_3)
	local multiply = Quaternion.multiply(Quaternion.multiply(look, var_10_10), var_10_9)
	local forward = Quaternion.forward(multiply)
	local str = "filter_enemy_player_ray_projectile"
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_10_15 = var_10_3.attack_power_level[get_difficulty_rank]

	var_10_15 = var_10_15 or var_10_3.attack_power_level[2]

	local tbl = {
		power_level = var_10_15,
		damage_profile = var_10_3.damage_profile,
		hit_effect = var_10_3.hit_effect,
		player_push_velocity = Vector3Box(normalize * var_10_3.impact_push_speed),
		projectile_linker = var_10_3.projectile_linker,
		first_person_hit_flow_events = var_10_3.first_person_hit_flow_events
	}
	local system = Managers.state.entity:system("projectile_system")
	local peer_id = Network.peer_id()

	system:create_light_weight_projectile(arg_10_2.breed.name, arg_10_1, _fire_from_position_direction, forward, var_10_3.projectile_speed, nil, nil, var_10_3.projectile_max_range, str, tbl, var_10_3.light_weight_projectile_effect, peer_id)
end

BTStormfiendDualShootAction.initiate_firing = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local action = arg_11_1.action
	local shoot_data = arg_11_1.shoot_data

	shoot_data.firing_duration = action.firing_duration
	shoot_data.shots_fired = 0
	shoot_data.time_between_shots_at_start = 1 / action.fire_rate_at_start
	shoot_data.time_between_shots_at_end = 1 / action.fire_rate_at_end
	shoot_data.max_fire_rate_at_percentage_modifier = 1 / action.max_fire_rate_at_percentage
	shoot_data.current_gun_aim_position = Vector3Box(POSITION_LOOKUP[arg_11_1.target_unit])
	shoot_data.start_firing_t = arg_11_2
	shoot_data.stop_firing_t = arg_11_2 + action.firing_duration
	shoot_data.firing_initiated = true
	shoot_data.is_firing = true
end
