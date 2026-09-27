-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_fire_projectile_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFireProjectileAction = class(BTFireProjectileAction, BTNode)

BTFireProjectileAction.init = function (arg_1_0, ...)
	-- function 1
	BTFireProjectileAction.super.init(arg_1_0, ...)
end

BTFireProjectileAction.name = "BTFireProjectileAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTFireProjectileAction = class(BTFireProjectileAction, BTNode)
BTFireProjectileAction.name = "BTFireProjectileAction"

BTFireProjectileAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTFireProjectileAction
	arg_3_2.attack_finished = false
	arg_3_2.attack_aborted = false
	arg_3_2.anim_cb_spawn_projectile = nil

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

	arg_3_2.aim_cooldown = arg_3_3 + math.random(action_data.aim_cooldown[1], action_data.aim_cooldown[2])
	arg_3_2.start_check_for_dodge_t = arg_3_2.aim_cooldown - action_data.dodge_window
	arg_3_2.ranged_state = "aiming"
	arg_3_2.move_state = "attacking"

	Managers.state.network:anim_event(arg_3_1, action_data.aim_animation)
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)
	self:_check_for_volley_attack(arg_3_2, arg_3_1, arg_3_3)

	local volley_target_unit = arg_3_2.volley_target_unit

	volley_target_unit = volley_target_unit or arg_3_2.target_unit
	arg_3_2.attacking_target = volley_target_unit
	arg_3_2.target_unit_status_extension = ScriptUnit.has_extension(arg_3_2.attacking_target, "status_system")

	local extension_input = ScriptUnit.extension_input(arg_3_1, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event(arg_3_2.action.leader_fire_volley_dialogue_event, alloc_table)
end

BTFireProjectileAction._check_for_volley_attack = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local target_unit = arg_4_1.target_unit
	local tbl = {}

	if not (arg_4_1.is_volley_leader or arg_4_1.has_volley_target) then
		local broadphase = arg_4_1.group_blackboard.broadphase
		local archer_broadphase_results = arg_4_1.archer_broadphase_results
		local num = 15
		local var_4_5 = POSITION_LOOKUP[arg_4_2]
		local query = Broadphase.query(broadphase, var_4_5, num, archer_broadphase_results)
		local fire_volley_at_t = arg_4_1.fire_volley_at_t

		fire_volley_at_t = fire_volley_at_t or arg_4_3 + 1 + math.random()

		local var_4_8 = Vector3(0, 0, 0)

		if query >= 3 then
			for i = 1, query do
				local var_4_9 = archer_broadphase_results[i]
				local var_4_10 = BLACKBOARDS[var_4_9]
				local breed = var_4_10.breed
				local var_4_12 = POSITION_LOOKUP[var_4_9]

				if not breed.is_archer then
					tbl[#tbl + 1] = var_4_10
					var_4_8 = var_4_8 + var_4_12
				end
			end
		end

		local count = #tbl

		if count >= 3 then
			local num_2 = 0

			for j = 1, count do
				local var_4_15 = tbl[j]

				if var_4_15.unit ~= arg_4_2 then
					var_4_15.volley_target_unit = target_unit
					var_4_15.has_volley_target = true

					local num_3 = fire_volley_at_t + Math.random_range(0.15, 1.5)

					var_4_15.fire_volley_at_t = num_3

					if num_2 < num_3 then
						num_2 = num_3
					end

					if not var_4_15.confirmed_player_sighting then
						AiUtils.activate_unit(var_4_15)
					end
				end
			end

			arg_4_1.volley_target_unit = target_unit
			arg_4_1.fire_volley_at_t = num_2 + Math.random_range(0.15, 0.3)

			local system = Managers.state.entity:system("audio_system")
			local group_volley_sound = arg_4_1.action.group_volley_sound
			local num_4 = var_4_8 / count

			system:play_audio_position_event(group_volley_sound, num_4)

			arg_4_1.is_volley_leader = true
			arg_4_1.nearby_archers = tbl
		end
	end
end

BTFireProjectileAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_5_1, arg_5_2)
	local navigation_extension = arg_5_2.navigation_extension

	navigation_extension:set_enabled(true)
	navigation_extension:set_max_speed(get_default_breed_move_speed)
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

BTFireProjectileAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local attacking_target = arg_6_2.attacking_target

	if not Unit.alive(attacking_target) then
		return "done"
	end

	if not arg_6_2.attack_aborted then
		return "done"
	end

	if not (not arg_6_2.start_check_for_dodge_t and not (arg_6_3 > arg_6_2.start_check_for_dodge_t)) then
		local target_unit_status_extension = arg_6_2.target_unit_status_extension

		target_unit_status_extension = not target_unit_status_extension and arg_6_2.target_unit_status_extension:get_is_dodging()
		arg_6_2.target_is_dodging = target_unit_status_extension

		if not arg_6_2.anim_cb_spawn_projectile then
			arg_6_2.start_check_for_dodge_t = nil
		end
	end

	local world_rotation = Unit.world_rotation(arg_6_1, 0)
	local flat = Vector3.flat(Quaternion.forward(world_rotation))
	local normalize = Vector3.normalize(flat)
	local var_6_5 = POSITION_LOOKUP[attacking_target]
	local var_6_6 = POSITION_LOOKUP[arg_6_1]
	local flat_2 = Vector3.flat(var_6_5 - var_6_6)
	local normalize_2 = Vector3.normalize(flat_2)

	if Vector3.dot(normalize_2, normalize) < math.inverse_sqrt_2 then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_6_1, attacking_target)

		arg_6_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	end

	local network = Managers.state.network
	local ranged_state = arg_6_2.ranged_state
	local action = arg_6_2.action

	if ranged_state == "aiming" then
		if arg_6_2.has_volley_target or not arg_6_2.is_volley_leader then
			if not ((not (arg_6_3 >= arg_6_2.aim_cooldown) or not arg_6_2.fire_volley_at_t) and not (arg_6_3 > arg_6_2.fire_volley_at_t)) then
				arg_6_2.ranged_state = "shooting"

				network:anim_event(arg_6_1, action.shoot_animation)
			elseif not (not (arg_6_3 >= arg_6_2.aim_cooldown) or arg_6_2.fire_volley_at_t) then
				arg_6_2.ranged_state = "shooting"

				network:anim_event(arg_6_1, action.shoot_animation)
			end
		elseif not (arg_6_3 >= arg_6_2.aim_cooldown) or not arg_6_2.has_line_of_sight then
			arg_6_2.ranged_state = "shooting"

			network:anim_event(arg_6_1, action.shoot_animation)
		elseif arg_6_3 >= arg_6_2.aim_cooldown then
			arg_6_2.ranged_state = "aftermath"
			arg_6_2.shoot_cooldown = arg_6_3
		end
	elseif ranged_state == "shooting" then
		if not arg_6_2.anim_cb_spawn_projectile then
			self:_fire_projectile(arg_6_1, arg_6_2, arg_6_4)

			arg_6_2.shoot_cooldown = arg_6_3 + action.shoot_cooldown
			arg_6_2.ranged_state = "aftermath"
		end
	elseif arg_6_3 > arg_6_2.shoot_cooldown then
		return "done"
	end

	return "running"
end

BTFireProjectileAction._fire_from_position_direction = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local var_7_0
	local attacking_target = arg_7_1.attacking_target

	if not Unit.has_node(attacking_target, "j_neck") then
		local node = Unit.node(attacking_target, "j_neck")

		var_7_0 = Unit.world_position(attacking_target, node)
	else
		var_7_0 = POSITION_LOOKUP[attacking_target] + Vector3(0, 0, 1.5)
	end

	local node_2 = Unit.node(arg_7_2, "j_lefthand")
	local world_position = Unit.world_position(arg_7_2, node_2)
	local has_extension = ScriptUnit.has_extension(attacking_target, "locomotion_system")
	local small_sample_size_average_velocity

	if not has_extension.small_sample_size_average_velocity then
		small_sample_size_average_velocity = has_extension:small_sample_size_average_velocity()

		if not small_sample_size_average_velocity then
			-- Nothing
		end
	end

	small_sample_size_average_velocity = Vector3.zero()

	::label_7_0::

	local length = Vector3.length(small_sample_size_average_velocity)

	if length > 4 then
		small_sample_size_average_velocity = small_sample_size_average_velocity * (4 / length)
	end

	local angle_to_hit_moving_target, var_7_9 = WeaponHelper.angle_to_hit_moving_target(world_position, var_7_0, arg_7_4, small_sample_size_average_velocity, arg_7_5, 0.1)
	local num = var_7_9 - world_position

	if not angle_to_hit_moving_target then
		Vector3.set_z(num, 0)

		local normalize = Vector3.normalize(num)
		local num_2 = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(normalize, Vector3.up()), angle_to_hit_moving_target), normalize) * arg_7_4

		return world_position, num, num_2
	end

	return false
end

local pi = math.pi
local num = pi * 2

BTFireProjectileAction._fire_projectile = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local action = arg_8_2.action
	local projectile_speed = action.projectile_speed
	local projectile_gravity = action.projectile_gravity
	local _fire_from_position_direction, var_8_4, var_8_5 = self:_fire_from_position_direction(arg_8_2, arg_8_1, arg_8_3, projectile_speed, projectile_gravity)

	if not _fire_from_position_direction then
		return false
	end

	local light_weight_projectile_template_name = action.light_weight_projectile_template_name
	local var_8_7 = LightWeightProjectiles[light_weight_projectile_template_name]
	local str = "filter_enemy_player_afro_ray_projectile"
	local difficulty_hit_chance = action.difficulty_hit_chance
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_8_11 = var_8_7.attack_power_level[get_difficulty_rank]

	var_8_11 = var_8_11 or var_8_7.attack_power_level[2]

	local target_is_dodging = arg_8_2.target_is_dodging
	local flag = not not arg_8_2.fired_first_shot or var_8_7.first_shot_spread
	local flag_2 = true

	if not get_difficulty_rank and not difficulty_hit_chance then
		local var_8_15 = difficulty_hit_chance[get_difficulty_rank]

		var_8_15 = var_8_15 or difficulty_hit_chance[2]
		flag_2 = var_8_15 >= math.random()

		if not flag_2 and not flag then
			str = "filter_enemy_player_afro_ray_projectile_no_hitbox"
		end
	end

	local length = Vector3.length(Vector3.flat(var_8_5))
	local normalize = Vector3.normalize(var_8_5)
	local spread = var_8_7.spread
	local dodge_spread = var_8_7.dodge_spread
	local num = Math.random() * (flag or not target_is_dodging or dodge_spread or spread)

	num = not flag_2 and num and var_8_7.miss_spread or 0

	local var_8_21 = Quaternion(Vector3.right(), num)
	local var_8_22 = Quaternion(Vector3.forward(), (Math.random() - 0.5) * pi)
	local look = Quaternion.look(normalize, Vector3.up())
	local multiply = Quaternion.multiply(Quaternion.multiply(look, var_8_22), var_8_21)
	local forward = Quaternion.forward(multiply)
	local tbl = {
		power_level = var_8_11,
		damage_profile = var_8_7.damage_profile,
		hit_effect = var_8_7.hit_effect,
		player_push_velocity = Vector3Box(normalize * var_8_7.impact_push_speed),
		projectile_linker = var_8_7.projectile_linker,
		first_person_hit_flow_events = var_8_7.first_person_hit_flow_events
	}
	local system = Managers.state.entity:system("projectile_system")
	local var_8_28 = projectile_gravity
	local peer_id = Network.peer_id()

	system:create_light_weight_projectile(arg_8_2.breed.name, arg_8_1, _fire_from_position_direction, forward, var_8_7.projectile_speed, var_8_28, length, var_8_7.projectile_max_range, str, tbl, var_8_7.light_weight_projectile_effect, peer_id)

	arg_8_2.fired_first_shot = true
end
