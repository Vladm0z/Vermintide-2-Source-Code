-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_stormfiend_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTStormfiendShootAction = class(BTStormfiendShootAction, BTNode)

BTStormfiendShootAction.init = function (self, ...)
	-- function 1
	BTStormfiendShootAction.super.init(self, ...)

	self.unit_ids = {}
end

BTStormfiendShootAction.name = "BTStormfiendShootAction"

local function fn(...)
	-- function 2
	if not script_data.debug_stormfiend then
		print("BTStormfiendShootAction:", ...)
	end
end

local num = 0.4
local num_2 = 10

BTStormfiendShootAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	self.unit_ids[arg_3_1] = Managers.state.network.unit_storage:go_id(arg_3_1)

	local network_transmit = self.network_transmit

	network_transmit = network_transmit or Managers.state.network.network_transmit
	self.network_transmit = network_transmit

	local action_data = self._tree_node.action_data
	local world = arg_3_2.world

	arg_3_2.action = action_data
	arg_3_2.active_node = BTStormfiendShootAction
	arg_3_2.attack_finished = false

	local shoot_data = arg_3_2.shoot_data

	shoot_data = shoot_data or {}
	arg_3_2.shoot_data = shoot_data

	local physics_world = arg_3_2.physics_world

	physics_world = physics_world or World.get_data(world, "physics_world")
	arg_3_2.physics_world = physics_world
	arg_3_2.attacking_target = arg_3_2.target_unit

	if not self:init_attack(arg_3_1, arg_3_2, action_data, arg_3_3) then
		local shoot_data_2 = arg_3_2.shoot_data

		arg_3_2.anim_locked = arg_3_3 + action_data.attack_anims_data[shoot_data_2.attack_animation].full_animation_t
		arg_3_2.move_state = "attacking"
		arg_3_2.attack_aborted = false
		arg_3_2.keep_target = true
		arg_3_2.find_new_shoot_position = nil

		self:set_global_environment_intensity(arg_3_1, arg_3_2.group_blackboard, action_data)

		if not action_data.use_demo_flow_event then
			AiBreedSnippets.on_stormfiend_demo_shoot(arg_3_1, arg_3_2)
		end
	else
		arg_3_2.attack_aborted = true

		if not arg_3_2.navigation_extension:is_following_path() then
			arg_3_2.find_new_shoot_position = true
		end

		fn("ATTACK WAS NOT OK [Aborting]")
	end

	local target_unit = arg_3_2.target_unit

	AiUtils.add_attack_intensity(target_unit, action_data, arg_3_2)
end

BTStormfiendShootAction.set_global_environment_intensity = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local environment_max_intensity = arg_4_3.environment_max_intensity
	local firewall_environment_intensity = arg_4_2.firewall_environment_intensity

	firewall_environment_intensity = firewall_environment_intensity or 0

	local min = math.min(firewall_environment_intensity + arg_4_3.environment_intensity_increase_per_firewall, environment_max_intensity)
	local global_sound_parameter = arg_4_3.global_sound_parameter

	Managers.state.entity:system("audio_system"):set_global_parameter_with_lerp(global_sound_parameter, min)

	local num = min / environment_max_intensity
	local network_transmit = Managers.state.network.network_transmit
	local var_4_6 = NetworkLookup.global_parameter_names[global_sound_parameter]

	network_transmit:send_rpc_clients("rpc_client_audio_set_global_parameter_with_lerp", var_4_6, num)

	arg_4_2.firewall_environment_intensity = min
end

BTStormfiendShootAction._calculate_attack_animation = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local dot = Vector3.dot(arg_5_1, arg_5_3)
	local dot_2 = Vector3.dot(arg_5_2, arg_5_3)
	local abs = math.abs(dot)
	local abs_2 = math.abs(dot_2)
	local var_5_4
	local var_5_5
	local var_5_6
	local flag = abs_2 < abs
	local flag_2

	if not (not flag and not (dot > 0.5)) then
		var_5_6 = "attack_right"
		var_5_5 = arg_5_4.right[var_5_6]
		flag_2 = true
	elseif not (not flag and not (dot < -0.5)) then
		var_5_6 = "attack_left"
		var_5_5 = arg_5_4.left[var_5_6]
		flag_2 = true
	elseif dot_2 > 0 then
		var_5_6 = NetworkLookup.attack_arm[math.random(1, 2)]
		var_5_5 = arg_5_4.fwd[var_5_6]
		flag_2 = false
	else
		var_5_6 = "attack_left"
		var_5_5 = arg_5_4.bwd[var_5_6]
		flag_2 = true
	end

	return var_5_5, var_5_6, flag_2
end

BTStormfiendShootAction._calculate_aim = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	-- function 6
	local var_6_0 = arg_6_7.muzzle_nodes[arg_6_3]
	local node = Unit.node(arg_6_1, var_6_0)
	local world_position = Unit.world_position(arg_6_1, node)

	if not arg_6_5 then
		local flat_angle = Vector3.flat_angle(arg_6_4, arg_6_10)
		local axis_angle = Quaternion.axis_angle(Vector3.up(), flat_angle)
		local num_3 = world_position - arg_6_2

		world_position = arg_6_2 + Quaternion.rotate(axis_angle, num_3)
	end

	local var_6_6 = arg_6_7.shoulder_nodes[arg_6_3]
	local node_2 = Unit.node(arg_6_1, var_6_6)
	local world_position_2 = Unit.world_position(arg_6_1, node_2)
	local num_4 = world_position - world_position_2
	local normalize = Vector3.normalize(num_4)
	local length = Vector3.length(num_4)
	local physics_world = arg_6_6.physics_world

	if not PhysicsWorld.immediate_raycast(physics_world, world_position_2, normalize, length, "any", "collision_filter", "filter_ai_line_of_sight_check") then
		return nil, nil, nil
	end

	local start_distance = arg_6_7.start_distance
	local maximum_length = arg_6_7.maximum_length
	local num_5 = arg_6_2 + arg_6_10 * start_distance
	local num_6 = num_5 + arg_6_10 * maximum_length
	local num_7 = 1
	local num_8 = 2
	local nav_world = arg_6_6.nav_world
	local traverse_logic = arg_6_6.navigation_extension:traverse_logic()
	local num_9 = arg_6_7.minimum_length^2
	local flag = num_9 < Vector3.distance_squared(num_5, arg_6_9)
	local var_6_23
	local var_6_24

	if not flag then
		var_6_24 = not LocomotionUtils.ray_can_go_on_mesh(nav_world, arg_6_2, num_5, traverse_logic, num_7, num_8) and LocomotionUtils.ray_can_go_on_mesh(nav_world, num_5, arg_6_9, traverse_logic, num_7, num_8)
	end

	local flag_2 = false
	local var_6_26
	local var_6_27

	if not var_6_24 then
		flag_2 = true
	else
		local node_3 = Unit.node(arg_6_8, "c_head")
		local world_position_3 = Unit.world_position(arg_6_8, node_3)
		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(physics_world, world_position, world_position_3, num, num_2, "collision_filter", "filter_enemy_player_ray_projectile", "report_initial_overlap")

		if not linear_sphere_sweep then
			local count = #linear_sphere_sweep

			for i = 1, count do
				local actor = linear_sphere_sweep[i].actor
				local unit = Actor.unit(actor)

				if not DamageUtils.is_character(unit) then
					break
				elseif unit == arg_6_8 then
					flag_2 = true
					var_6_27 = world_position_3

					break
				end
			end
		end
	end

	local var_6_34

	if not flag_2 then
		local raycast_on_navmesh, var_6_36, var_6_37, var_6_38 = LocomotionUtils.raycast_on_navmesh(nav_world, num_5, num_6, traverse_logic, num_7, num_8)
		local distance_squared

		if not var_6_36 then
			distance_squared = Vector3.distance_squared(var_6_36, var_6_38)

			if not distance_squared then
				-- Nothing
			end
		end

		distance_squared = 0

		::label_6_0::

		var_6_34 = not (num_9 < distance_squared) or not var_6_36 or nil
		var_6_26 = var_6_36
		var_6_27 = var_6_27 or var_6_38
	end

	local aim_start_offset = arg_6_7.aim_start_offset
	local num_10 = (var_6_26 or num_5) + arg_6_10 * aim_start_offset

	return var_6_34, num_10, var_6_27
end

BTStormfiendShootAction.init_attack = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local action = arg_7_2.action

	if not action.switch_between_weapon_setups then
		local target_dist = arg_7_2.target_dist
		local warpfire_switch_range = action.warpfire_switch_range
		local ratling_gun_switch_range = action.ratling_gun_switch_range

		if target_dist < warpfire_switch_range then
			arg_7_2.weapon_setup = "warpfire_thrower"
		else
			arg_7_2.weapon_setup = "ratling_gun"
		end
	else
		local weapon_setup = action.weapon_setup

		weapon_setup = weapon_setup or "warpfire_thrower"
		arg_7_2.weapon_setup = weapon_setup
	end

	local var_7_5 = POSITION_LOOKUP[arg_7_1]
	local attacking_target = arg_7_2.attacking_target
	local var_7_7 = POSITION_LOOKUP[attacking_target]
	local normalize = Vector3.normalize(var_7_7 - var_7_5)
	local attack_anims = action.attack_anims
	local world_rotation = Unit.world_rotation(arg_7_1, 0)
	local forward = Quaternion.forward(world_rotation)
	local right = Quaternion.right(world_rotation)
	local _calculate_attack_animation, var_7_14, var_7_15 = self:_calculate_attack_animation(right, forward, normalize, attack_anims, var_7_5)
	local _calculate_aim, var_7_17, var_7_18 = self:_calculate_aim(arg_7_1, var_7_5, var_7_14, forward, var_7_15, arg_7_2, action, attacking_target, var_7_7, normalize)
	local flag = var_7_18 ~= nil

	if not flag then
		arg_7_2.navigation_extension:stop()
		arg_7_2.locomotion_extension:use_lerp_rotation(not var_7_15)
		LocomotionUtils.set_animation_driven_movement(arg_7_1, var_7_15)

		local attack_anims_data = action.attack_anims_data

		if not var_7_15 then
			local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_7_1, var_7_7, _calculate_attack_animation, attack_anims_data)

			LocomotionUtils.set_animation_rotation_scale(arg_7_1, get_animation_rotation_scale)
		end

		local network = Managers.state.network

		network:anim_event(arg_7_1, _calculate_attack_animation)

		local shoot_data = arg_7_2.shoot_data
		local var_7_24 = attack_anims_data[_calculate_attack_animation]

		shoot_data.start_firing_t = arg_7_4 + var_7_24.start_firing_t
		shoot_data.stop_firing_t = arg_7_4 + var_7_24.stop_firing_t
		shoot_data.aim_start_t = arg_7_4 + var_7_24.aim_start_t
		shoot_data.firing_duration = shoot_data.stop_firing_t - shoot_data.start_firing_t
		shoot_data.firing_initiated = false

		local var_7_25 = action.aim_constraint_target[var_7_14]

		shoot_data.aim_start_position = Vector3Box(var_7_17)
		shoot_data.current_aim_position = Vector3Box(var_7_17)
		shoot_data.aim_end_position = Vector3Box(var_7_18)

		local var_7_26

		if not _calculate_aim then
			var_7_26 = Vector3Box(_calculate_aim)

			if not var_7_26 then
				-- Nothing
			end
		end

		var_7_26 = nil

		::label_7_0::

		shoot_data.firewall_start_position = var_7_26
		shoot_data.direction = Vector3Box(normalize)
		shoot_data.aim_constraint_target_var = Unit.animation_find_constraint_target(arg_7_1, var_7_25)
		shoot_data.attack_arm = var_7_14
		shoot_data.firing_time = action.firing_time
		shoot_data.attack_animation = _calculate_attack_animation
		shoot_data.aim_constraint_animations = action.aim_constraint_animations[var_7_14]
		shoot_data.hit_enemies = {}
		shoot_data.shoot_threat = {
			rotation = QuaternionBox()
		}

		local game = network:game()
		local go_id = Managers.state.unit_storage:go_id(arg_7_1)

		if not game and not go_id then
			local var_7_29 = NetworkLookup.attack_arm[var_7_14]

			GameSession.set_game_object_field(game, go_id, "attack_arm", var_7_29)
		end

		local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_7_1, var_7_17)

		arg_7_2.attack_rotation = QuaternionBox(look_at_position_flat)
		arg_7_2.attack_started_at_t = arg_7_4

		local bot_threats = action.bot_threats

		if not bot_threats then
			bot_threats = action.bot_threats[_calculate_attack_animation]

			if not bot_threats then
				bot_threats = action.bot_threats[1]
				bot_threats = not bot_threats and action.bot_threats
			end
		end

		if not bot_threats then
			local num_2 = 1
			local var_7_33 = bot_threats[num_2]

			arg_7_2.create_bot_threat_at_t = arg_7_4 + var_7_33.start_time
			arg_7_2.current_bot_threat_index = num_2
			arg_7_2.bot_threats_data = bot_threats

			local flat = Vector3.flat(var_7_18 - var_7_5)

			arg_7_2.bot_threat_range = Vector3.length(flat) - var_7_33.offset_forward + 1.5 * num
		end
	end

	return flag
end

BTStormfiendShootAction.leave = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local shoot_data = arg_8_2.shoot_data
	local network = Managers.state.network

	if not shoot_data.aim_constraint_animations then
		local off = shoot_data.aim_constraint_animations.off

		network:anim_event(arg_8_1, off)
	else
		network:anim_event(arg_8_1, "aim_at_right_off")
		network:anim_event(arg_8_1, "aim_at_left_off")
	end

	local weapon_setup = arg_8_2.weapon_setup

	if not shoot_data.beam_active then
		local var_8_4 = self.unit_ids[arg_8_1]
		local var_8_5 = NetworkLookup.attack_arm[shoot_data.attack_arm]

		self.network_transmit:send_rpc_all("rpc_set_stormfiend_beam", var_8_4, var_8_5, false)

		shoot_data.beam_active = false
	end

	self.unit_ids[arg_8_1] = nil
	shoot_data.ratling_gun_active = false

	self:_stop_beam_sfx(arg_8_1, arg_8_2, shoot_data)

	local action = arg_8_2.action
	local attack_arm = shoot_data.attack_arm

	if not attack_arm then
		local var_8_8 = action.muzzle_nodes[attack_arm]
		local node = Unit.node(arg_8_1, var_8_8)

		if not action.stop_shoot_sfx then
			WwiseUtils.trigger_unit_event(arg_8_2.world, action.stop_shoot_sfx, arg_8_1, node)
		end
	end

	if not shoot_data.shoot_threat and not shoot_data.shoot_threat.handle then
		Managers.state.entity:system("ai_bot_group_system"):remove_threat(shoot_data.shoot_threat.handle)
	end

	table.clear(shoot_data)

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

BTStormfiendShootAction.run = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	if not (arg_9_2.attack_aborted or Unit.alive(arg_9_2.attacking_target)) then
		return "failed"
	end

	if arg_9_3 < arg_9_2.anim_locked then
		local shoot_data = arg_9_2.shoot_data
		local weapon_setup = arg_9_2.weapon_setup

		if arg_9_3 < shoot_data.aim_start_t then
			-- Nothing
		elseif not shoot_data.aim_constrained then
			self:constrain_aim(arg_9_1, arg_9_2)

			shoot_data.aim_constrained = true
		elseif arg_9_3 < shoot_data.start_firing_t then
			-- Nothing
		elseif not shoot_data.firing_initiated then
			if not (not weapon_setup and weapon_setup ~= "ratling_gun") then
				self:initiate_firing_ratling_gun(arg_9_2)
			else
				self:initiate_firing_warpfire_thrower(arg_9_1, arg_9_2)

				local var_9_2 = self.unit_ids[arg_9_1]
				local var_9_3 = NetworkLookup.attack_arm[shoot_data.attack_arm]

				self.network_transmit:send_rpc_all("rpc_set_stormfiend_beam", var_9_2, var_9_3, true)

				shoot_data.beam_active = true
			end
		elseif arg_9_3 < shoot_data.stop_firing_t then
			if not (not weapon_setup and weapon_setup ~= "ratling_gun") then
				self:_update_ratling_gun(arg_9_1, arg_9_2, arg_9_3, arg_9_4)
			else
				self:shoot_hit_check(arg_9_1, arg_9_2)
			end
		elseif not shoot_data.is_firing then
			if not shoot_data.beam_active then
				local var_9_4 = self.unit_ids[arg_9_1]
				local var_9_5 = NetworkLookup.attack_arm[shoot_data.attack_arm]

				self.network_transmit:send_rpc_all("rpc_set_stormfiend_beam", var_9_4, var_9_5, false)

				shoot_data.beam_active = false
			end

			if not shoot_data.aim_constrained then
				local network = Managers.state.network

				if not shoot_data.aim_constraint_animations then
					local off = shoot_data.aim_constraint_animations.off

					network:anim_event(arg_9_1, off)
				else
					network:anim_event(arg_9_1, "aim_at_right_off")
					network:anim_event(arg_9_1, "aim_at_left_off")
				end

				shoot_data.aim_constraint_animations = nil
			end

			if not arg_9_2.shoot_sfx_id then
				WwiseWorld.stop_event(Managers.world:wwise_world(arg_9_2.world), arg_9_2.shoot_sfx_id)

				arg_9_2.shoot_sfx_id = nil
			end

			shoot_data.is_firing = false
		end

		local create_bot_threat_at_t = arg_9_2.create_bot_threat_at_t

		if not (not create_bot_threat_at_t and not (create_bot_threat_at_t < arg_9_3)) then
			local var_9_9

			if not shoot_data.current_gun_aim_position then
				local _fire_from_position_direction, var_9_11 = self:_fire_from_position_direction(arg_9_1, arg_9_2, shoot_data, arg_9_4)

				var_9_9 = Quaternion.look(var_9_11)
			else
				var_9_9 = arg_9_2.attack_rotation:unbox()
			end

			local bot_threats_data = arg_9_2.bot_threats_data
			local current_bot_threat_index = arg_9_2.current_bot_threat_index
			local var_9_14 = bot_threats_data[current_bot_threat_index]
			local bot_threat_range = arg_9_2.bot_threat_range

			self:_create_bot_aoe_threat(arg_9_1, var_9_9, var_9_14, bot_threat_range, shoot_data)

			local num = current_bot_threat_index + 1
			local var_9_17 = bot_threats_data[num]

			if not var_9_17 then
				arg_9_2.create_bot_threat_at_t = arg_9_2.attack_started_at_t + var_9_17.start_time
				arg_9_2.current_bot_threat_index = num
			else
				arg_9_2.create_bot_threat_at_t = nil
				arg_9_2.current_bot_threat_index = nil
			end
		elseif not shoot_data.shoot_threat.handle then
			local var_9_18

			if not shoot_data.current_gun_aim_position then
				local _fire_from_position_direction_2, var_9_20 = self:_fire_from_position_direction(arg_9_1, arg_9_2, shoot_data, arg_9_4)

				var_9_18 = Quaternion.look(var_9_20)
			else
				var_9_18 = arg_9_2.attack_rotation:unbox()
			end

			if Quaternion.angle(var_9_18, shoot_data.shoot_threat.rotation:unbox()) > math.pi * 0.025 then
				local bot_threat = shoot_data.shoot_threat.bot_threat
				local bot_threat_range_2 = shoot_data.shoot_threat.bot_threat_range

				self:_create_bot_aoe_threat(arg_9_1, var_9_18, bot_threat, bot_threat_range_2, shoot_data)
			end
		end

		return "running"
	else
		return "done"
	end
end

BTStormfiendShootAction._calculate_oobb_collision = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local var_10_0 = arg_10_2
	local height = arg_10_1.height
	local width = arg_10_1.width
	local offset_up = arg_10_1.offset_up
	local offset_forward = arg_10_1.offset_forward
	local num = width * 0.5
	local num_2 = var_10_0 * 0.5
	local num_3 = height * 0.5
	local var_10_8 = Vector3(num, num_2, num_3)
	local num_4 = Quaternion.rotate(arg_10_4, Vector3.forward()) * (offset_forward + num_2)
	local num_5 = Vector3.up() * (offset_up + num_3)

	return arg_10_3 + num_4 + num_5, arg_10_4, var_10_8
end

BTStormfiendShootAction._create_bot_aoe_threat = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local system = Managers.state.entity:system("ai_bot_group_system")
	local var_11_1 = POSITION_LOOKUP[arg_11_1]
	local shoot_threat = arg_11_5.shoot_threat

	if not shoot_threat.handle then
		system:remove_threat(shoot_threat.handle)
	end

	local _calculate_oobb_collision, var_11_4, var_11_5 = self:_calculate_oobb_collision(arg_11_3, arg_11_4, var_11_1, arg_11_2)

	shoot_threat.handle = system:aoe_threat_created(_calculate_oobb_collision, "oobb", var_11_5, var_11_4, math.huge, "Stormfiend")

	shoot_threat.rotation:store(arg_11_2)

	shoot_threat.bot_threat = arg_11_3
	shoot_threat.bot_threat_range = arg_11_4
end

BTStormfiendShootAction.constrain_aim = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local shoot_data = arg_12_2.shoot_data

	if not shoot_data and not shoot_data.aim_constraint_animations then
		local shoot_data_2 = arg_12_2.shoot_data
		local network = Managers.state.network
		local on = shoot_data_2.aim_constraint_animations.on

		network:anim_event(arg_12_1, on)

		shoot_data_2.aiming_started = true
	end
end

BTStormfiendShootAction.create_firewall = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local unbox = arg_13_3.firewall_start_position:unbox()
	local nav_world = arg_13_2.nav_world
	local triangle_from_position, var_13_3 = GwNavQueries.triangle_from_position(nav_world, unbox, 1, 1)

	if not triangle_from_position then
		unbox = Vector3.copy(unbox)
		unbox.z = var_13_3
	else
		unbox = GwNavQueries.inside_position_from_outside_position(nav_world, unbox, 3, 3, 1, 1)
	end

	if not unbox then
		return
	end

	local unbox_2 = arg_13_3.direction:unbox()
	local tbl = {
		area_damage_system = {
			liquid_template = "stormfiend_firewall",
			flow_dir = unbox_2,
			source_unit = arg_13_1
		}
	}
	local str = "units/hub_elements/empty"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "liquid_aoe_unit", tbl, unbox)

	ScriptUnit.extension(spawn_network_unit, "area_damage_system"):ready()
end

BTStormfiendShootAction.shoot_hit_check = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local action = arg_14_2.action
	local shoot_data = arg_14_2.shoot_data
	local attack_arm = shoot_data.attack_arm
	local var_14_3 = action.muzzle_nodes[attack_arm]
	local node = Unit.node(arg_14_1, var_14_3)
	local world_position = Unit.world_position(arg_14_1, node)
	local unbox = shoot_data.current_aim_position:unbox()
	local physics_world = arg_14_2.physics_world
	local var_14_8 = num
	local var_14_9 = num_2
	local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(physics_world, world_position, unbox, var_14_8, var_14_9, "collision_filter", "filter_enemy_player_ray_projectile", "report_initial_overlap")

	if not linear_sphere_sweep then
		local immune_breeds = action.immune_breeds
		local count = #linear_sphere_sweep

		for i = 1, count do
			local var_14_13 = linear_sphere_sweep[i]
			local actor = var_14_13.actor
			local unit = Actor.unit(actor)
			local position = var_14_13.position

			if not DamageUtils.is_character(unit) then
				break
			end

			local var_14_17 = HEALTH_ALIVE[unit]

			if unit == arg_14_1 or not var_14_17 then
				local is_player_unit = DamageUtils.is_player_unit(unit)
				local hit_enemies = shoot_data.hit_enemies
				local flag = not not is_player_unit or Unit.get_data(unit, "breed")

				if not is_player_unit then
					if not ScriptUnit.extension(unit, "buff_system"):has_buff_type("stormfiend_warpfire_face") then
						Managers.state.entity:system("buff_system"):add_buff(unit, "stormfiend_warpfire_face_base", arg_14_1)

						arg_14_2.has_dealt_burn_damage = true
					end
				elseif not (not flag and immune_breeds[flag.name] or hit_enemies[unit]) then
					local var_14_21 = arg_14_1
					local armor_category = flag.armor_category

					armor_category = armor_category or 1

					local damage_type = action.damage_type
					local var_14_24 = action.damage[armor_category]
					local unbox_2 = shoot_data.direction:unbox()
					local name = arg_14_2.breed.name

					DamageUtils.add_damage_network(unit, var_14_21, var_14_24, "torso", damage_type, position, unbox_2, name, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, i)

					hit_enemies[unit] = true
				end
			end
		end
	end
end

BTStormfiendShootAction._stop_beam_sfx = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local action = arg_15_2.action
	local attack_arm = arg_15_3.attack_arm
	local var_15_2 = action.muzzle_nodes[attack_arm]
	local beam_sfx_stop_event = action.beam_sfx_stop_event

	Managers.state.entity:system("audio_system"):play_audio_unit_event(beam_sfx_stop_event, arg_15_1, var_15_2)
end

BTStormfiendShootAction.initiate_firing_warpfire_thrower = function (self, arg_16_1, arg_16_2)
	-- function 16
	local action = arg_16_2.action
	local shoot_data = arg_16_2.shoot_data

	if not shoot_data.firewall_start_position then
		self:create_firewall(arg_16_1, arg_16_2, shoot_data)
	end

	local attack_arm = shoot_data.attack_arm
	local var_16_3 = action.muzzle_nodes[attack_arm]
	local beam_sfx_start_event = action.beam_sfx_start_event

	Managers.state.entity:system("audio_system"):play_audio_unit_event(beam_sfx_start_event, arg_16_1, var_16_3)

	shoot_data.firing_initiated = true
	shoot_data.is_firing = true
end

BTStormfiendShootAction._fire_from_position_direction = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	local action = arg_17_2.action
	local attack_arm = arg_17_3.attack_arm
	local var_17_2 = action.muzzle_nodes[attack_arm]
	local node = Unit.node(arg_17_1, var_17_2)
	local world_position = Unit.world_position(arg_17_1, node)
	local world_position_2 = Unit.world_position(arg_17_2.attacking_target, Unit.node(arg_17_2.attacking_target, "j_spine"))
	local unbox = arg_17_3.current_gun_aim_position:unbox()
	local min = math.min(arg_17_4 * 6, 1)
	local lerp = Vector3.lerp(unbox, world_position_2, min)
	local normalize = Vector3.normalize(lerp - world_position)

	arg_17_3.current_gun_aim_position:store(lerp)

	return world_position - Vector3.normalize(normalize) * 1.25, normalize
end

BTStormfiendShootAction._update_ratling_gun = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local shoot_data = arg_18_2.shoot_data
	local num = arg_18_3 - shoot_data.start_firing_t
	local clamp = math.clamp(num / shoot_data.firing_duration * shoot_data.max_fire_rate_at_percentage_modifier, 0, 1)
	local lerp = math.lerp(shoot_data.time_between_shots_at_start, shoot_data.time_between_shots_at_end, clamp)
	local num_2 = math.floor(num / lerp) + 1 - shoot_data.shots_fired

	for i = 1, num_2 do
		shoot_data.shots_fired = shoot_data.shots_fired + 1

		self:_shoot_ratling_gun(arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	end
end

local num_3 = math.pi * 2

BTStormfiendShootAction._shoot_ratling_gun = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local action = arg_19_2.action
	local shoot_data = arg_19_2.shoot_data
	local light_weight_projectile_template_name = action.light_weight_projectile_template_name
	local var_19_3 = LightWeightProjectiles[light_weight_projectile_template_name]
	local _fire_from_position_direction, var_19_5 = self:_fire_from_position_direction(arg_19_1, arg_19_2, shoot_data, arg_19_4)
	local normalize = Vector3.normalize(var_19_5)
	local num = Math.random() * var_19_3.spread
	local look = Quaternion.look(normalize, Vector3.up())
	local var_19_9 = Quaternion(Vector3.right(), num)
	local var_19_10 = Quaternion(Vector3.forward(), Math.random() * num_3)
	local multiply = Quaternion.multiply(Quaternion.multiply(look, var_19_10), var_19_9)
	local forward = Quaternion.forward(multiply)
	local str = "filter_enemy_player_ray_projectile"
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_19_15 = var_19_3.attack_power_level[get_difficulty_rank]

	var_19_15 = var_19_15 or var_19_3.attack_power_level[2]

	local tbl = {
		power_level = var_19_15,
		damage_profile = var_19_3.damage_profile,
		hit_effect = var_19_3.hit_effect,
		player_push_velocity = Vector3Box(normalize * var_19_3.impact_push_speed),
		projectile_linker = var_19_3.projectile_linker,
		first_person_hit_flow_events = var_19_3.first_person_hit_flow_events
	}
	local attack_arm = shoot_data.attack_arm
	local var_19_18 = action.muzzle_nodes[attack_arm]
	local node = Unit.node(arg_19_1, var_19_18)

	if not (not action.shoot_sfx and arg_19_2.shoot_sfx_id) then
		arg_19_2.shoot_sfx_id = WwiseUtils.trigger_unit_event(arg_19_2.world, action.shoot_sfx, arg_19_1, node)
	end

	local system = Managers.state.entity:system("projectile_system")
	local peer_id = Network.peer_id()

	system:create_light_weight_projectile(Unit.get_data(arg_19_1, "breed").name, arg_19_1, _fire_from_position_direction, forward, var_19_3.projectile_speed, nil, nil, var_19_3.projectile_max_range, str, tbl, var_19_3.light_weight_projectile_effect, peer_id)
end

BTStormfiendShootAction.initiate_firing_ratling_gun = function (arg_20_0, arg_20_1)
	-- function 20
	local action = arg_20_1.action
	local shoot_data = arg_20_1.shoot_data

	shoot_data.shots_fired = 0
	shoot_data.time_between_shots_at_start = 1 / action.fire_rate_at_start
	shoot_data.time_between_shots_at_end = 1 / action.fire_rate_at_end
	shoot_data.max_fire_rate_at_percentage_modifier = 1 / action.max_fire_rate_at_percentage
	shoot_data.current_gun_aim_position = Vector3Box(POSITION_LOOKUP[arg_20_1.attacking_target])
	shoot_data.firing_initiated = true
	shoot_data.is_firing = true
end

BTStormfiendShootAction._debug_firewall = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	if not script_data.debug_stormfiend then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "BTStormfiendShootAction"
		})
		local get = Colors.get("green")
		local get_2 = Colors.get("yellow")
		local get_3 = Colors.get("red")
		local distance

		if not arg_21_4 then
			distance = Vector3.distance(arg_21_4, arg_21_5)

			if not distance then
				-- Nothing
			end
		end

		distance = 0

		::label_21_0::

		local flag = arg_21_4 or arg_21_2
		local flag_2 = arg_21_5 or arg_21_3
		local num = arg_21_3 - flag

		drawer:sphere(flag, 0.25, not arg_21_4 and get and get_3)
		drawer:vector(flag, num, get_2)
		drawer:sphere(flag_2, 0.25, not (arg_21_1 < distance) or not get or get_3)
		fn("FIREWALL DISTANCE", distance, "MINIMUM DISTANCE", arg_21_1)
	end
end

BTStormfiendShootAction._debug_fire_beam = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	-- function 22
	if not script_data.debug_stormfiend then
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

		var_22_0:sphere(arg_22_1, num, not arg_22_3 and var_22_1 and var_22_2)
		var_22_0:line(arg_22_1, arg_22_2, not arg_22_3 and var_22_1 and var_22_2)
		var_22_0:sphere(arg_22_2, num, not arg_22_3 and var_22_1 and var_22_2)

		if not arg_22_5 then
			local count = #arg_22_5
			local normalize = Vector3.normalize(arg_22_2 - arg_22_1)

			for i = 1, count do
				local var_22_8 = arg_22_5[i]
				local distance = var_22_8.distance
				local position = var_22_8.position
				local num_2 = arg_22_1 + normalize * distance
				local var_22_12

				if not (arg_22_4 == nil or not (i < arg_22_4)) then
					var_22_12 = var_22_3
				elseif i == arg_22_4 then
					var_22_12 = var_22_4
				else
					var_22_12 = var_22_5
				end

				var_22_0:sphere(num_2, num, var_22_12)
				var_22_0:sphere(position, 0.05, var_22_12)
			end
		end
	end
end

BTStormfiendShootAction._debug_colliding_arm = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	if not script_data.debug_stormfiend then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "BTStormfiendShootAction"
		})

		drawer:sphere(arg_23_1, 0.1, Colors.get("black"))
		drawer:line(arg_23_1, arg_23_2, Colors.get("black"))
		drawer:sphere(arg_23_2, 0.1, Colors.get("black"))
	end
end
