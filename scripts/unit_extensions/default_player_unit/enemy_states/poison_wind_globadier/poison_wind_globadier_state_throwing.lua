-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/poison_wind_globadier/poison_wind_globadier_state_throwing.lua

PoisonWindGlobadierStateThrowing = class(PoisonWindGlobadierStateThrowing, EnemyCharacterState)

PoisonWindGlobadierStateThrowing.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "globadier_throwing")

	self.current_movement_speed_scale = 0
	self.last_input_direction = Vector3Box(0, 0, 0)
	self._angle = 0
	self._position = Vector3Box()
	self._spline = nil
	self._num_segments = 0
	self._indicator_fx_unit_name = "fx/units/aoe_globadier"
	self._impact_data = {}
	self._right_wpn_particle_name = "fx/wpnfx_globadier_enemy_in_range_1p"
	self._right_wpn_particle_node_name = "e_globe"
end

local POSITION_LOOKUP = POSITION_LOOKUP

PoisonWindGlobadierStateThrowing.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	table.clear(self._temp_params)

	self._unit = arg_2_1
	self._first_person_extension = ScriptUnit.has_extension(arg_2_1, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_2_1, "status_system")
	self._career_extension = ScriptUnit.extension(arg_2_1, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_2_1, "buff_system")
	self._locomotion_extension = ScriptUnit.extension(arg_2_1, "locomotion_system")
	self._input_extension = ScriptUnit.has_extension(arg_2_1, "input_system")
	self._inventory_extension = ScriptUnit.has_extension(arg_2_1, "inventory_system")
	self._is_server = Managers.player.is_server

	local get_data = Unit.get_data(arg_2_1, "breed")

	self._breed = get_data
	self._previous_state = arg_2_6

	table.clear(self._impact_data)

	self._impact_data.position = Vector3Box()
	self._impact_data.direction = Vector3Box()
	self._impact_data.hit_normal = Vector3Box()
	self._wind_up_movement_speed = get_data.wind_up_movement_speed

	local _first_person_extension = self._first_person_extension

	_first_person_extension:unhide_weapons("catapulted")
	CharacterStateHelper.show_inventory_3p(arg_2_1, true, false, self._is_server, self._inventory_extension)
	CharacterStateHelper.play_animation_event(arg_2_1, "globe_charge")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "globe_charge")

	self._done_priming = false
	self._prime_time = arg_2_5 + get_data.globe_throw_prime_time
	self._max_prime_time = get_data.globe_throw_prime_time

	if not self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end

	self:set_breed_action("throw_poison_globe")
end

PoisonWindGlobadierStateThrowing.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self._throw_ready = nil
	self._throw_time = nil
	self._finish_time = nil
	self._done_priming = false
	self._prime_time = nil

	self:set_breed_action("n/a")
	self:_set_priming_progress(0)
	self:_destroy_indicator_unit()
end

PoisonWindGlobadierStateThrowing.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension

	if not self._done_priming then
		self:_update_priming(arg_4_1, arg_4_5, arg_4_3)
	end

	if arg_4_5 > self._prime_time then
		self._done_priming = true
	end

	if not self._done_priming then
		if not self._throw_time then
			self:_calculate_trajectory()
			self:_update_indicator_unit()
		end

		self:_update_movement(arg_4_1, arg_4_5, arg_4_3)
	end

	local flag = false

	if not ScriptUnit.extension(arg_4_1, "ghost_mode_system"):is_in_ghost_mode() then
		self:_stop_priming()

		flag = true
	elseif not self._throw_time then
		flag = self:_throw_anim_update(arg_4_5)
	end

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		if not flag then
			self:_stop_priming()
		end

		return
	end

	if not flag then
		if not _locomotion_extension:is_on_ground() then
			_csm:change_state("walking")
			_first_person_extension:change_state("walking")

			return
		end

		if _locomotion_extension:current_velocity().z <= 0 then
			_csm:change_state("falling", self._temp_params)
			_first_person_extension:change_state("falling")

			return
		end

		_first_person_extension:animation_set_variable("armed", 0)
		_csm:change_state("standing")

		return
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return
	end

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return
	end

	if not CharacterStateHelper.is_block_broken(_status_extension) then
		_status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		_csm:change_state("stunned", parry_broken)

		return
	end

	local _input_extension = self._input_extension

	if not _input_extension then
		return
	end

	local get = _input_extension:get("dark_pact_action_one_release")
	local flag_2 = false

	if not get then
		self._throw_ready = true
	end

	local get_2 = _input_extension:get("dark_pact_action_two")

	if not ((flag_2 or not get_2) and self._throw_time) then
		self:_stop_priming()
		_csm:change_state("standing")

		return
	end

	if not (not self._throw_ready and self._throw_time) then
		self:_set_throw_start(arg_4_5)
		self._career_extension:start_activated_ability_cooldown()
	end

	local globe_throw_look_sense = self._breed.globe_throw_look_sense

	CharacterStateHelper.look(self._input_extension, self._player.viewport_name, self._first_person_extension, self._status_extension, self._inventory_extension, globe_throw_look_sense)
end

PoisonWindGlobadierStateThrowing._calculate_trajectory = function (self)
	-- function 5
	local _first_person_unit = self._first_person_unit
	local _breed = self._breed
	local local_rotation = Unit.local_rotation(_first_person_unit, 0)
	local pitch_from_rotation = ActionUtils.pitch_from_rotation(local_rotation)
	local node = Unit.node(_first_person_unit, "root_point")
	local world_position = Unit.world_position(_first_person_unit, node)
	local var_5_6 = world_position
	local unbox = self._position:unbox()

	if not (not Vector3.equal(world_position, unbox) and pitch_from_rotation ~= self._angle) then
		return
	end

	self._position:store(world_position)

	self._angle = pitch_from_rotation

	local degrees_to_radians = math.degrees_to_radians(pitch_from_rotation)
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(local_rotation)))
	local normalize_2 = Vector3.normalize(normalize + Vector3(0, 0, _breed.globe_throw_upwards_amount))
	local num = _breed.globe_throw_speed * 0.01
	local default = ProjectileGravitySettings.default
	local _physics_world = self._physics_world
	local num_2 = 0.5
	local tbl = {
		WeaponHelper:position_on_trajectory(world_position, normalize_2, num, degrees_to_radians, default, 0)
	}
	local num_3 = 0.05
	local num_4 = 5
	local network = Managers.state.network

	for i = num_2, 10, num_2 do
		local position_on_trajectory = WeaponHelper:position_on_trajectory(world_position, normalize_2, num, degrees_to_radians, default, i)
		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(_physics_world, var_5_6, position_on_trajectory, num_3, num_4, "collision_filter", "filter_player_ray_projectile_static_only")
		local count

		if not linear_sphere_sweep then
			count = #linear_sphere_sweep

			if not count then
				-- Nothing
			end
		end

		count = 0

		::label_5_0::

		if count > 0 then
			local flag = false

			for j = 1, count do
				local var_5_23 = linear_sphere_sweep[j]
				local position = var_5_23.position
				local normal = var_5_23.normal
				local actor = var_5_23.actor
				local distance = var_5_23.distance
				local normalize_3 = Vector3.normalize(position - var_5_6)

				if distance > 0 then
					local unit = Actor.unit(actor)

					if not network:level_object_id(unit) then
						tbl[#tbl + 1] = position

						local num_5 = var_5_6 - WeaponHelper:position_on_trajectory(world_position, normalize_2, num, degrees_to_radians, default, i + num_2)
						local length = Vector3.length(num_5)
						local num_6 = 0.2
						local num_7 = i - (num_2 - distance / length * num_2) + num_6
						local _impact_data = self._impact_data

						_impact_data.position:store(position)
						_impact_data.hit_normal:store(normal)
						_impact_data.direction:store(normalize_3)

						_impact_data.hit_unit = unit

						local num_actors = Unit.num_actors(unit)
						local actor_2 = Unit.actor
						local var_5_37

						for k = 0, num_actors - 1 do
							if actor == actor_2(unit, k) then
								var_5_37 = k

								break
							end
						end

						_impact_data.actor_index = var_5_37
						_impact_data.time = num_7
						flag = true

						break
					end
				end
			end

			if not flag then
				break
			end
		end

		var_5_6 = position_on_trajectory
	end

	if #tbl > 1 then
		self._spline = SplineCurve:new(tbl, "Hermite", "SplineMovementMetered", "GlobadierProjectileTrajectory")
		self._num_segments = #tbl
	end
end

PoisonWindGlobadierStateThrowing._update_priming = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if arg_6_2 > self._prime_time then
		self._done_priming = true

		self:_create_indicator_unit()

		local _unit = self._unit
		local _first_person_extension = self._first_person_extension

		if not self._thrown then
			CharacterStateHelper.play_animation_event(_unit, "globe_charge_hold")
			CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "globe_charge_hold")
		end
	end

	if not not self._done_priming then
		local _prime_time = self._prime_time
		local _max_prime_time = self._max_prime_time
		local num = _max_prime_time - (_prime_time - arg_6_2)
		local clamp = math.clamp(num / _max_prime_time, 0, 1)

		self:_set_priming_progress(clamp)
		self:_update_movement(arg_6_1, arg_6_2, arg_6_3, clamp)
	end
end

PoisonWindGlobadierStateThrowing._set_priming_progress = function (self, arg_7_1)
	-- function 7
	local _career_extension = self._career_extension
	local str = "fire"
	local ability_id = _career_extension:ability_id(str)

	_career_extension:get_activated_ability_data(ability_id).priming_progress = arg_7_1
end

PoisonWindGlobadierStateThrowing._stop_priming = function (self)
	-- function 8
	local _unit = self._unit
	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.play_animation_event(_unit, "globe_charge_cancel")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "globe_charge_cancel")

	self._done_priming = false
end

PoisonWindGlobadierStateThrowing._set_throw_start = function (self, arg_9_1)
	-- function 9
	local _unit = self._unit
	local _breed = self._breed
	local _first_person_unit = self._first_person_unit
	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.play_animation_event(_unit, "globe_throw")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "globe_throw")
	_first_person_extension:animation_set_variable("armed", 0)

	self._throw_time = arg_9_1 + _breed.globe_throw_spawn_globe_time
	self._finish_time = arg_9_1 + _breed.globe_throw_finish_time
	self._thrown = false
	self._throw_rotation_box = QuaternionBox(Unit.local_rotation(_first_person_unit, 0))

	local node = Unit.node(_first_person_unit, "j_rightweaponattach")
	local world_position = Unit.world_position(_first_person_unit, node)

	self._throw_position_box = Vector3Box(world_position)
end

PoisonWindGlobadierStateThrowing._throw_anim_update = function (self, arg_10_1)
	-- function 10
	local _throw_time = self._throw_time

	if not (not _throw_time and self._thrown or not (_throw_time <= arg_10_1)) then
		self:_throw()
	end

	local _finish_time = self._finish_time

	if not (not _finish_time and not (_finish_time <= arg_10_1)) then
		return true
	end

	self._locomotion_extension:set_disable_rotation_update()

	return false
end

PoisonWindGlobadierStateThrowing._throw = function (self)
	-- function 11
	local _unit = self._unit
	local _breed = self._breed

	self._first_person_extension:hide_weapons("catapulted")
	CharacterStateHelper.show_inventory_3p(_unit, false, true, Managers.player.is_server, self._inventory_extension)
	self._status_extension:set_unarmed(true)

	local unbox = self._throw_rotation_box:unbox()
	local unbox_2 = self._throw_position_box:unbox()
	local pitch_from_rotation = ActionUtils.pitch_from_rotation(unbox)
	local globe_throw_speed = _breed.globe_throw_speed
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(unbox)))
	local normalize_2 = Vector3.normalize(normalize + Vector3(0, 0, _breed.globe_throw_upwards_amount))
	local globe_throw_impact_difficulty_damage = _breed.globe_throw_impact_difficulty_damage
	local globe_throw_dot_difficulty_damage = _breed.globe_throw_dot_difficulty_damage
	local globe_throw_dot_damage_interval = _breed.globe_throw_dot_damage_interval
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local globe_throw_aoe_radius = _breed.globe_throw_aoe_radius
	local globe_throw_initial_radius = _breed.globe_throw_initial_radius
	local globe_throw_aoe_life_time = _breed.globe_throw_aoe_life_time
	local str = "vs_poison_wind_globadier"
	local var_11_16 = globe_throw_dot_difficulty_damage[get_difficulty_rank]

	if not var_11_16 then
		var_11_16 = globe_throw_dot_difficulty_damage[2]
		var_11_16 = var_11_16 or 5
	end

	local calculate_damage = DamageUtils.calculate_damage(var_11_16)
	local var_11_18 = globe_throw_impact_difficulty_damage[get_difficulty_rank]

	if not var_11_18 then
		var_11_18 = globe_throw_impact_difficulty_damage[2]
		var_11_18 = var_11_18 or 7
	end

	local calculate_damage_2 = DamageUtils.calculate_damage(var_11_18)
	local flag = true
	local flag_2 = false
	local _impact_data = self._impact_data
	local var_11_23

	if not _impact_data.time then
		var_11_23 = table.clone(_impact_data)
	end

	Managers.state.entity:system("projectile_system"):spawn_globadier_globe(unbox_2, normalize_2, pitch_from_rotation, globe_throw_speed, globe_throw_initial_radius, globe_throw_aoe_radius, globe_throw_aoe_life_time, _unit, str, calculate_damage, calculate_damage_2, globe_throw_dot_damage_interval, flag, flag_2, var_11_23)

	self._thrown = true
end

PoisonWindGlobadierStateThrowing._update_indicator_unit = function (self)
	-- function 12
	if not self._indicator_unit then
		local unbox = self._impact_data.position:unbox()

		Unit.set_local_position(self._indicator_unit, 0, unbox)

		local var_12_1 = POSITION_LOOKUP[Managers.player:local_player().player_unit]
		local multiply = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.pi * 0.5), Quaternion.look(var_12_1 - unbox, Vector3.up()))

		Unit.set_local_rotation(self._indicator_unit, 0, multiply)
		self:check_enemies_in_range_vfx(unbox)
	end
end

PoisonWindGlobadierStateThrowing._create_indicator_unit = function (self)
	-- function 13
	local _world = self._world
	local _indicator_fx_unit_name = self._indicator_fx_unit_name

	self._indicator_unit = World.spawn_unit(_world, _indicator_fx_unit_name, Vector3.zero())

	local globe_throw_aoe_radius = self._breed.globe_throw_aoe_radius

	Unit.set_local_scale(self._indicator_unit, 0, Vector3(globe_throw_aoe_radius, globe_throw_aoe_radius, globe_throw_aoe_radius))
end

PoisonWindGlobadierStateThrowing._destroy_indicator_unit = function (self)
	-- function 14
	local _world = self._world

	if not Unit.alive(self._indicator_unit) then
		World.destroy_unit(_world, self._indicator_unit)

		self._indicator_unit = nil
	end
end

PoisonWindGlobadierStateThrowing._update_movement = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local _input_extension = self._input_extension
	local _buff_extension = self._buff_extension
	local _first_person_extension = self._first_person_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_15_1)
	local get_movement_input = CharacterStateHelper.get_movement_input(_input_extension)
	local has_move_input = CharacterStateHelper.has_move_input(_input_extension)
	local current_movement_speed_scale = self.current_movement_speed_scale

	if not self.is_bot then
		local _breed = self._breed

		_breed = not _breed and self._breed.breed_move_acceleration_up

		local _breed_2 = self._breed

		_breed_2 = not _breed_2 and self._breed.breed_move_acceleration_down

		local num = _breed * arg_15_3

		num = num or get_movement_settings_table.move_acceleration_up * arg_15_3

		local num_2 = _breed_2 * arg_15_3

		num_2 = num_2 or get_movement_settings_table.move_acceleration_down * arg_15_3

		if not has_move_input then
			current_movement_speed_scale = math.min(1, current_movement_speed_scale + num)
		else
			current_movement_speed_scale = math.max(0, current_movement_speed_scale - num_2)
		end
	else
		current_movement_speed_scale = not has_move_input and 1 and 0
	end

	local lerp = math.lerp(self._wind_up_movement_speed, 0.6, (arg_15_4 or 1)^2)
	local num_3 = _buff_extension:apply_buffs_to_value(lerp, "movement_speed") * current_movement_speed_scale * get_movement_settings_table.player_speed_scale
	local var_15_13 = Vector3(0, 0, 0)

	if not get_movement_input then
		var_15_13 = var_15_13 + get_movement_input
	end

	local var_15_14
	local normalize = Vector3.normalize(var_15_13)

	if Vector3.length(normalize) == 0 then
		normalize = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize)
	end

	local get_move_animation = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, self._status_extension, self.move_anim_3p)

	if get_move_animation ~= self.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_15_1, get_move_animation)

		self.move_anim_3p = get_move_animation
	end

	if not ((self._previous_state == "jumping" or self._previous_state == "falling") and self._locomotion_extension:is_on_ground()) then
		CharacterStateHelper.move_in_air_pactsworn(self._first_person_extension, _input_extension, self._locomotion_extension, num_3, arg_15_1)
	else
		CharacterStateHelper.move_on_ground(_first_person_extension, _input_extension, self._locomotion_extension, normalize, num_3, arg_15_1)
	end

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, self._status_extension, self._inventory_extension)

	self.current_movement_speed_scale = current_movement_speed_scale
end
