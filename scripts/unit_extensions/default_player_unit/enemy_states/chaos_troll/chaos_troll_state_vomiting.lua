-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/chaos_troll/chaos_troll_state_vomiting.lua

ChaosTrollStateVomiting = class(ChaosTrollStateVomiting, EnemyCharacterState)

ChaosTrollStateVomiting.init = function (arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "troll_vomiting")

	arg_1_0._vomit_ability_id = arg_1_0._career_extension:ability_id("vomit")
	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
	arg_1_0._vomit_ability_id = arg_1_0._career_extension:ability_id("vomit")
	arg_1_0._indicator_fx_unit_name = "fx/units/aoe_globadier"
	arg_1_0._position = Vector3Box()
	arg_1_0._angle = 0
	arg_1_0._impact_data = {}

	arg_1_0._safe_pos_puke_callback = function ()
		if ALIVE[arg_1_0._unit] then
			local var_2_0, var_2_1, var_2_2 = arg_1_0:_get_vomit_position(arg_1_0._unit)

			arg_1_0._puke_position_on_nav = var_2_0 and Vector3Box(var_2_0) or nil
			arg_1_0._puke_direction = var_2_2 and Vector3Box(var_2_2) or nil
			arg_1_0._puke_distance_sq = var_2_1 and var_2_1 or nil
		end
	end
end

ChaosTrollStateVomiting.on_enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	arg_3_0._unit = arg_3_1
	arg_3_0._status_extension.is_vomiting = true
	arg_3_0._puke_direction = Vector3Box(0, 0, 0)
	arg_3_0._state_end = arg_3_5 + 2.5
	arg_3_0._state = "priming"

	local var_3_0 = Managers.player:local_player().viewport_name
	local var_3_1 = ScriptWorld.viewport(arg_3_0._world, var_3_0, true)

	arg_3_0._camera = ScriptViewport.camera(var_3_1)
	arg_3_0._max_dist = arg_3_0._breed.max_vomit_distance
	arg_3_0._troll_head_node = Unit.node(arg_3_1, "j_head")

	local var_3_2 = "attack_vomit_into"

	Managers.state.network:anim_event(arg_3_1, var_3_2)
	CharacterStateHelper.play_animation_event_first_person(arg_3_0._first_person_extension, var_3_2)

	arg_3_0._puke_position_on_nav = nil
	arg_3_0._puke_direction = nil
	arg_3_0._puke_distance_sq = nil
	arg_3_0._ray_hit_pos = nil
	arg_3_0._ray_hit_distance = nil

	table.clear(arg_3_0._impact_data)

	arg_3_0._impact_data.position = Vector3Box()
	arg_3_0._impact_data.direction = Vector3Box()
	arg_3_0._impact_data.hit_normal = Vector3Box()
end

ChaosTrollStateVomiting.handle_hit_indicator = function (arg_4_0)
	local var_4_0 = arg_4_0._indicator_fx_unit_name

	if arg_4_0._impact_data.position and arg_4_0._puke_position_on_nav then
		local var_4_1 = arg_4_0._impact_data.position:unbox()

		if arg_4_0._indicator_unit then
			Unit.set_local_position(arg_4_0._indicator_unit, 0, var_4_1)
		else
			arg_4_0._indicator_unit = World.spawn_unit(arg_4_0._world, var_4_0, var_4_1)

			local var_4_2 = arg_4_0._breed.puke_in_face_indicator_raidus

			Unit.set_local_scale(arg_4_0._indicator_unit, 0, Vector3(var_4_2, var_4_2, var_4_2))
		end
	else
		arg_4_0:destroy_indicator_unit()
	end
end

ChaosTrollStateVomiting.destroy_indicator_unit = function (arg_5_0)
	if Unit.alive(arg_5_0._indicator_unit) then
		World.destroy_unit(arg_5_0._world, arg_5_0._indicator_unit)

		arg_5_0._indicator_unit = nil
	end
end

ChaosTrollStateVomiting.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0._csm
	local var_6_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_1)
	local var_6_2 = arg_6_0._input_extension
	local var_6_3 = arg_6_0._status_extension
	local var_6_4 = arg_6_0._first_person_extension
	local var_6_5 = arg_6_0._inventory_extension
	local var_6_6 = arg_6_0._state

	if not var_6_2 then
		return
	end

	Debug.text("PUKE STATE: %s", arg_6_0._state)

	if arg_6_0._state == "fail" then
		arg_6_0:destroy_indicator_unit()
		arg_6_0._career_extension:reduce_activated_ability_cooldown_percent(1, arg_6_0._vomit_ability_id)
		Managers.state.network:anim_event(arg_6_1, "interrupt")
		CharacterStateHelper.play_animation_event_first_person(arg_6_0._first_person_extension, "interrupt")
		var_6_0:change_state("walking")

		return
	elseif arg_6_0._state == "priming" then
		if var_6_2:get("dark_pact_action_one_release") then
			arg_6_0._state = "fail"

			return
		end

		arg_6_0:_calculate_trajectory()
		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(arg_6_0._safe_pos_puke_callback)

		if arg_6_0._impact_data.position and arg_6_0._puke_position_on_nav then
			local var_6_7 = arg_6_0._impact_data.position:unbox()

			if arg_6_0._indicator_unit then
				local var_6_8 = POSITION_LOOKUP[Managers.player:local_player().player_unit]
				local var_6_9 = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.pi * 0.5), Quaternion.look(var_6_8 - var_6_7, Vector3.up()))

				Unit.set_local_rotation(arg_6_0._indicator_unit, 0, var_6_9)
			end
		end

		if not var_6_2:get("dark_pact_action_two_hold") then
			if ALIVE[arg_6_0._unit] then
				if not arg_6_0._puke_position_on_nav or not arg_6_0._puke_direction then
					arg_6_0._state = "fail"
				else
					arg_6_0._state = "start_vomit"
				end
			end

			arg_6_0._attack_started_at_t = arg_6_5
			arg_6_0._vomit_end_time = arg_6_5 + 1.9
		end

		arg_6_0:handle_hit_indicator()
		arg_6_0:_update_movement(arg_6_1, arg_6_3, arg_6_5)
	elseif arg_6_0._state == "start_vomit" then
		if not arg_6_0:_init_puke_attack(arg_6_1, arg_6_5) then
			arg_6_0._state = "fail"
		else
			arg_6_0._locomotion_extension:set_wanted_velocity(Vector3.zero())
			arg_6_0:destroy_indicator_unit()

			if ALIVE[arg_6_0._unit] then
				arg_6_0:spawn_vomit(arg_6_1)

				arg_6_0._state = "vomiting"

				arg_6_0._career_extension:start_activated_ability_cooldown(arg_6_0._vomit_ability_id)
			end

			arg_6_0._do_sweep_for_heroes = true
			arg_6_0._check_puke_time = arg_6_5 + 100
		end
	elseif arg_6_0._state == "vomiting" then
		if arg_6_0._do_sweep_for_heroes then
			arg_6_0._do_sweep_for_heroes = false

			arg_6_0:player_vomit_hit_check(arg_6_1, arg_6_0._impact_data.position:unbox(), arg_6_0._physics_world)
		end

		if arg_6_5 > arg_6_0._vomit_end_time then
			arg_6_0._state = "done"
		end
	elseif arg_6_0._state == "done" or arg_6_5 > arg_6_0._state_end then
		var_6_0:change_state("standing")

		return
	end

	if CharacterStateHelper.do_common_state_transitions(var_6_3, var_6_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_6_3) then
		var_6_0:change_state("using_transport")

		return
	end

	if CharacterStateHelper.is_pushed(var_6_3) then
		var_6_3:set_pushed(false)

		local var_6_10 = var_6_1.stun_settings.pushed

		var_6_10.hit_react_type = var_6_3:hit_react_type() .. "_push"

		var_6_0:change_state("stunned", var_6_10)

		return
	end

	if CharacterStateHelper.is_block_broken(var_6_3) then
		var_6_3:set_block_broken(false)

		local var_6_11 = var_6_1.stun_settings.parry_broken

		var_6_11.hit_react_type = "medium_push"

		var_6_0:change_state("stunned", var_6_11)

		return
	end

	local var_6_12 = arg_6_0._breed.look_sense_override

	CharacterStateHelper.look(var_6_2, arg_6_0._player.viewport_name, var_6_4, var_6_3, var_6_5, var_6_12)
end

ChaosTrollStateVomiting.on_exit = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	arg_7_0._status_extension.is_vomiting = false

	arg_7_0:destroy_indicator_unit()
end

local var_0_0 = 0.3

ChaosTrollStateVomiting._calculate_trajectory = function (arg_8_0)
	local var_8_0 = arg_8_0._first_person_unit
	local var_8_1 = arg_8_0._breed
	local var_8_2 = Unit.local_rotation(var_8_0, 0)
	local var_8_3 = ActionUtils.pitch_from_rotation(var_8_2)
	local var_8_4 = Unit.world_position(var_8_0, arg_8_0._troll_head_node)
	local var_8_5 = var_8_4
	local var_8_6 = arg_8_0._position:unbox()

	if Vector3.equal(var_8_4, var_8_6) and var_8_3 == arg_8_0._angle then
		return
	end

	arg_8_0._position:store(var_8_4)

	arg_8_0._angle = var_8_3

	local var_8_7 = math.degrees_to_radians(var_8_3)
	local var_8_8 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_8_2)))
	local var_8_9 = Vector3.normalize(var_8_8 + Vector3(0, 0, var_8_1.vomit_upwards_amount))
	local var_8_10 = var_8_1.vomit_projectile_speed
	local var_8_11 = ProjectileGravitySettings.default
	local var_8_12 = arg_8_0._physics_world
	local var_8_13 = 0.05
	local var_8_14 = 5
	local var_8_15 = Managers.state.network
	local var_8_16 = false

	arg_8_0._impact_data.sweep_positions = {}

	local var_8_17 = arg_8_0._impact_data.sweep_positions

	var_8_17[1] = Vector3Box(var_8_4)

	for iter_8_0 = var_0_0, 10, var_0_0 do
		local var_8_18 = WeaponHelper:position_on_trajectory(var_8_4, var_8_9, var_8_10, var_8_7, var_8_11, iter_8_0)

		var_8_17[#var_8_17 + 1] = Vector3Box(var_8_18)

		local var_8_19 = PhysicsWorld.linear_sphere_sweep(var_8_12, var_8_5, var_8_18, var_8_13, var_8_14, "collision_filter", "filter_player_ray_projectile_static_only")
		local var_8_20 = var_8_19 and #var_8_19 or 0

		if var_8_20 > 0 then
			local var_8_21 = false

			for iter_8_1 = 1, var_8_20 do
				local var_8_22 = var_8_19[iter_8_1]
				local var_8_23 = var_8_22.position
				local var_8_24 = var_8_22.normal
				local var_8_25 = var_8_22.actor
				local var_8_26 = var_8_22.distance
				local var_8_27 = Vector3.normalize(var_8_23 - var_8_5)

				if var_8_26 > 0 then
					local var_8_28 = Actor.unit(var_8_25)

					if var_8_15:level_object_id(var_8_28) then
						local var_8_29 = arg_8_0._impact_data

						var_8_29.position:store(var_8_23)

						var_8_16 = true

						var_8_29.hit_normal:store(var_8_24)
						var_8_29.direction:store(var_8_27)

						var_8_29.num_intervals = iter_8_0
						var_8_29.hit_unit = var_8_28
						var_8_21 = true

						break
					end
				end
			end

			if var_8_21 then
				break
			end
		end

		var_8_5 = var_8_18

		if not var_8_16 then
			arg_8_0._impact_data.position:store(Vector3(0, 0, 0))
		end
	end
end

ChaosTrollStateVomiting._sweep_trajectory_for_heroes = function (arg_9_0)
	local var_9_0 = {}
	local var_9_1 = arg_9_0._physics_world
	local var_9_2 = arg_9_0._breed.puke_in_face_sweep_radius
	local var_9_3 = 10
	local var_9_4 = arg_9_0._impact_data.sweep_positions

	for iter_9_0 = 1, #var_9_4 - 1 do
		local var_9_5 = var_9_4[iter_9_0]:unbox()
		local var_9_6 = var_9_4[iter_9_0 + 1]:unbox()
		local var_9_7 = PhysicsWorld.linear_sphere_sweep(var_9_1, var_9_5, var_9_6, var_9_2, var_9_3, "collision_filter", "filter_player")
		local var_9_8 = var_9_7 and #var_9_7 or 0

		if var_9_8 > 0 then
			local var_9_9 = 1

			for iter_9_1 = 1, var_9_8 do
				local var_9_10 = var_9_7[iter_9_1].actor
				local var_9_11 = Actor.unit(var_9_10)

				if Managers.state.side:versus_is_hero(var_9_11) and not table.contains(var_9_0, var_9_11) then
					var_9_0[var_9_9] = var_9_11
					var_9_9 = var_9_9 + 1
				end
			end
		end
	end

	return var_9_0
end

ChaosTrollStateVomiting._init_puke_attack = function (arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._puke_position_on_nav or not arg_10_0._puke_distance_sq or not arg_10_0._puke_direction then
		return false
	end

	local var_10_0 = arg_10_0._puke_position_on_nav:unbox()
	local var_10_1 = arg_10_0._puke_distance_sq
	local var_10_2 = arg_10_0._puke_direction:unbox()
	local var_10_3 = Vector3.dot(var_10_2, Vector3.down())
	local var_10_4 = 25
	local var_10_5 = 0.45
	local var_10_6 = false
	local var_10_7 = var_10_5 <= var_10_3 and var_10_1 < var_10_4 and not var_10_6
	local var_10_8

	if var_10_7 then
		var_10_8 = "attack_vomit"
		arg_10_0._near_vomit = true
	else
		var_10_8 = "attack_vomit_high"
	end

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_10_1, "enemy_attack", DialogueSettings.pounced_down_broadcast_range, "attack_tag", "before_puke")
	Managers.state.network:anim_event(arg_10_1, var_10_8)
	CharacterStateHelper.play_animation_event_first_person(arg_10_0._first_person_extension, var_10_8)

	arg_10_0._attack_started_at_t = arg_10_2

	return true
end

local var_0_1 = 10

ChaosTrollStateVomiting.player_vomit_hit_check = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = Unit.world_position(arg_11_1, arg_11_0._troll_head_node)
	local var_11_1 = arg_11_2 + (2 * Vector3.normalize(arg_11_2 - POSITION_LOOKUP[arg_11_1]) + Vector3(0, 0, 1)) - var_11_0
	local var_11_2 = Vector3.normalize(var_11_1)
	local var_11_3 = Vector3.length(var_11_1)
	local var_11_4 = arg_11_0._breed.vomit_in_face_sweep_radius
	local var_11_5 = arg_11_0:_sweep_trajectory_for_heroes()

	if var_11_5 and not table.is_empty(var_11_5) then
		local var_11_6 = #var_11_5
		local var_11_7 = Managers.state.entity:system("buff_system")

		for iter_11_0 = 1, var_11_6 do
			local var_11_8 = var_11_5[iter_11_0]

			if not ScriptUnit.extension(var_11_8, "buff_system"):has_buff_type("vs_troll_bile_face") then
				var_11_7:add_buff(var_11_8, "vs_bile_troll_vomit_face_base", arg_11_1)
				Managers.state.achievement:trigger_event("on_troll_vomit_hit", var_11_8, arg_11_1)
			end
		end
	end
end

ChaosTrollStateVomiting.position_on_navmesh = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0, var_12_1 = GwNavQueries.triangle_from_position(arg_12_1, arg_12_0, arg_12_2 or 0.5, arg_12_3 or 1)

	if var_12_0 then
		arg_12_0 = Vector3.copy(arg_12_0)
		arg_12_0.z = var_12_1
	else
		arg_12_2 = 1.5
		arg_12_3 = 4

		local var_12_2 = 4
		local var_12_3 = 0.5

		arg_12_0 = GwNavQueries.inside_position_from_outside_position(arg_12_1, arg_12_0, arg_12_2, arg_12_3, var_12_2, var_12_3)
	end

	return arg_12_0
end

ChaosTrollStateVomiting.spawn_vomit = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._puke_position_on_nav:unbox()

	if var_13_0 then
		local var_13_1 = arg_13_0._puke_direction:unbox()
		local var_13_2 = Quaternion.look(var_13_1)
		local var_13_3 = arg_13_0._near_vomit and 1 or 2

		Managers.state.unit_spawner:request_spawn_template_unit("troll_puke", var_13_0, var_13_2, arg_13_1, var_13_3)
	end
end

ChaosTrollStateVomiting._get_vomit_position = function (arg_14_0, arg_14_1)
	local var_14_0 = Unit.world_position(arg_14_1, arg_14_0._troll_head_node)
	local var_14_1 = ScriptCamera.position(arg_14_0._camera)
	local var_14_2 = ScriptCamera.rotation(arg_14_0._camera)
	local var_14_3 = Quaternion.forward(var_14_2)
	local var_14_4 = arg_14_0._max_dist
	local var_14_5
	local var_14_6
	local var_14_7
	local var_14_8 = 1
	local var_14_9 = 5
	local var_14_10 = ChaosTrollStateVomiting.position_on_navmesh(arg_14_0._impact_data.position:unbox(), arg_14_0._nav_world, var_14_8, var_14_9)
	local var_14_11

	if var_14_10 then
		local var_14_12 = var_14_10 - var_14_0

		var_14_7 = Vector3.normalize(var_14_12)
		var_14_6 = Vector3.length_squared(var_14_12)
	end

	return var_14_10, var_14_6, var_14_7
end

ChaosTrollStateVomiting._update_movement = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_0._input_extension
	local var_15_1 = arg_15_0._buff_extension
	local var_15_2 = arg_15_0._first_person_extension
	local var_15_3 = PlayerUnitMovementSettings.get_movement_settings_table(arg_15_1)
	local var_15_4 = CharacterStateHelper.get_movement_input(var_15_0)
	local var_15_5 = CharacterStateHelper.has_move_input(var_15_0)
	local var_15_6 = arg_15_0.current_movement_speed_scale

	if not arg_15_0.is_bot then
		local var_15_7 = var_15_3.move_acceleration_up * arg_15_3
		local var_15_8 = var_15_3.move_acceleration_down * arg_15_3

		if var_15_5 then
			var_15_6 = math.min(1, var_15_6 + var_15_7)
		else
			var_15_6 = math.max(0, var_15_6 - var_15_8)
		end
	else
		var_15_6 = var_15_5 and 1 or 0
	end

	local var_15_9 = arg_15_0._breed.vomit_movement_speed
	local var_15_10 = math.lerp(0.6, var_15_9, (arg_15_4 or 1)^2)
	local var_15_11 = var_15_1:apply_buffs_to_value(var_15_10, "movement_speed") * var_15_6 * var_15_3.player_speed_scale
	local var_15_12 = Vector3(0, 0, 0)

	if var_15_4 then
		var_15_12 = var_15_12 + var_15_4
	end

	local var_15_13
	local var_15_14 = Vector3.normalize(var_15_12)

	if Vector3.length(var_15_14) == 0 then
		var_15_14 = arg_15_0.last_input_direction:unbox()
	else
		arg_15_0.last_input_direction:store(var_15_14)
	end

	local var_15_15, var_15_16 = CharacterStateHelper.get_move_animation(arg_15_0._locomotion_extension, var_15_0, arg_15_0._status_extension, arg_15_0.move_anim_3p)

	if var_15_15 ~= arg_15_0.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_15_1, var_15_15)

		arg_15_0.move_anim_3p = var_15_15
	end

	if var_15_16 ~= arg_15_0.move_anim_1p then
		arg_15_0.move_anim_1p = var_15_16

		CharacterStateHelper.play_animation_event_first_person(var_15_2, var_15_16)
	end

	if arg_15_0._previous_state == "jumping" or arg_15_0._previous_state == "falling" then
		CharacterStateHelper.move_in_air_pactsworn(arg_15_0._first_person_extension, var_15_0, arg_15_0._locomotion_extension, var_15_11, arg_15_1)
	else
		CharacterStateHelper.move_on_ground(var_15_2, var_15_0, arg_15_0._locomotion_extension, var_15_14, var_15_11, arg_15_1)
	end

	arg_15_0.current_movement_speed_scale = var_15_6
end
