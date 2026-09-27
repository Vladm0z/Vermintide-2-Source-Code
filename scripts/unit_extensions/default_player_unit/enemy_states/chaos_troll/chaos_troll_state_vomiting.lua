-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/chaos_troll/chaos_troll_state_vomiting.lua

ChaosTrollStateVomiting = class(ChaosTrollStateVomiting, EnemyCharacterState)

ChaosTrollStateVomiting.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "troll_vomiting")

	self._vomit_ability_id = self._career_extension:ability_id("vomit")
	self.current_movement_speed_scale = 0
	self.last_input_direction = Vector3Box(0, 0, 0)
	self._vomit_ability_id = self._career_extension:ability_id("vomit")
	self._indicator_fx_unit_name = "fx/units/aoe_globadier"
	self._position = Vector3Box()
	self._angle = 0
	self._impact_data = {}

	self._safe_pos_puke_callback = function ()
		-- function 2
		if not ALIVE[self._unit] then
			local _get_vomit_position, var_2_1, var_2_2 = self:_get_vomit_position(self._unit)
			local var_2_3 = self
			local var_2_4

			if not _get_vomit_position then
				var_2_4 = Vector3Box(_get_vomit_position)

				if not var_2_4 then
					-- Nothing
				end
			end

			var_2_4 = nil

			::label_2_0::

			var_2_3._puke_position_on_nav = var_2_4

			local var_2_5 = self
			local var_2_6

			if not var_2_2 then
				var_2_6 = Vector3Box(var_2_2)

				if not var_2_6 then
					-- Nothing
				end
			end

			var_2_6 = nil

			::label_2_1::

			var_2_5._puke_direction = var_2_6
			self._puke_distance_sq = not var_2_1 and var_2_1 and nil
		end
	end
end

ChaosTrollStateVomiting.on_enter = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	self._unit = arg_3_1
	self._status_extension.is_vomiting = true
	self._puke_direction = Vector3Box(0, 0, 0)
	self._state_end = arg_3_5 + 2.5
	self._state = "priming"

	local viewport_name = Managers.player:local_player().viewport_name
	local viewport = ScriptWorld.viewport(self._world, viewport_name, true)

	self._camera = ScriptViewport.camera(viewport)
	self._max_dist = self._breed.max_vomit_distance
	self._troll_head_node = Unit.node(arg_3_1, "j_head")

	local str = "attack_vomit_into"

	Managers.state.network:anim_event(arg_3_1, str)
	CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, str)

	self._puke_position_on_nav = nil
	self._puke_direction = nil
	self._puke_distance_sq = nil
	self._ray_hit_pos = nil
	self._ray_hit_distance = nil

	table.clear(self._impact_data)

	self._impact_data.position = Vector3Box()
	self._impact_data.direction = Vector3Box()
	self._impact_data.hit_normal = Vector3Box()
end

ChaosTrollStateVomiting.handle_hit_indicator = function (self)
	-- function 4
	local _indicator_fx_unit_name = self._indicator_fx_unit_name

	if not self._impact_data.position and not self._puke_position_on_nav then
		local unbox = self._impact_data.position:unbox()

		if not self._indicator_unit then
			Unit.set_local_position(self._indicator_unit, 0, unbox)
		else
			self._indicator_unit = World.spawn_unit(self._world, _indicator_fx_unit_name, unbox)

			local puke_in_face_indicator_raidus = self._breed.puke_in_face_indicator_raidus

			Unit.set_local_scale(self._indicator_unit, 0, Vector3(puke_in_face_indicator_raidus, puke_in_face_indicator_raidus, puke_in_face_indicator_raidus))
		end
	else
		self:destroy_indicator_unit()
	end
end

ChaosTrollStateVomiting.destroy_indicator_unit = function (self)
	-- function 5
	if not Unit.alive(self._indicator_unit) then
		World.destroy_unit(self._world, self._indicator_unit)

		self._indicator_unit = nil
	end
end

ChaosTrollStateVomiting.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local _csm = self._csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_1)
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _inventory_extension = self._inventory_extension
	local _state = self._state

	if not _input_extension then
		return
	end

	Debug.text("PUKE STATE: %s", self._state)

	if self._state == "fail" then
		self:destroy_indicator_unit()
		self._career_extension:reduce_activated_ability_cooldown_percent(1, self._vomit_ability_id)
		Managers.state.network:anim_event(arg_6_1, "interrupt")
		CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, "interrupt")
		_csm:change_state("walking")

		return
	elseif self._state == "priming" then
		if not _input_extension:get("dark_pact_action_one_release") then
			self._state = "fail"

			return
		end

		self:_calculate_trajectory()
		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(self._safe_pos_puke_callback)

		if not self._impact_data.position and not self._puke_position_on_nav then
			local unbox = self._impact_data.position:unbox()

			if not self._indicator_unit then
				local var_6_8 = POSITION_LOOKUP[Managers.player:local_player().player_unit]
				local multiply = Quaternion.multiply(Quaternion.axis_angle(Vector3.up(), math.pi * 0.5), Quaternion.look(var_6_8 - unbox, Vector3.up()))

				Unit.set_local_rotation(self._indicator_unit, 0, multiply)
			end
		end

		if not not _input_extension:get("dark_pact_action_two_hold") then
			if not ALIVE[self._unit] then
				if not (not self._puke_position_on_nav and self._puke_direction) then
					self._state = "fail"
				else
					self._state = "start_vomit"
				end
			end

			self._attack_started_at_t = arg_6_5
			self._vomit_end_time = arg_6_5 + 1.9
		end

		self:handle_hit_indicator()
		self:_update_movement(arg_6_1, arg_6_3, arg_6_5)
	elseif self._state == "start_vomit" then
		if not self:_init_puke_attack(arg_6_1, arg_6_5) then
			self._state = "fail"
		else
			self._locomotion_extension:set_wanted_velocity(Vector3.zero())
			self:destroy_indicator_unit()

			if not ALIVE[self._unit] then
				self:spawn_vomit(arg_6_1)

				self._state = "vomiting"

				self._career_extension:start_activated_ability_cooldown(self._vomit_ability_id)
			end

			self._do_sweep_for_heroes = true
			self._check_puke_time = arg_6_5 + 100
		end
	elseif self._state == "vomiting" then
		if not self._do_sweep_for_heroes then
			self._do_sweep_for_heroes = false

			self:player_vomit_hit_check(arg_6_1, self._impact_data.position:unbox(), self._physics_world)
		end

		if arg_6_5 > self._vomit_end_time then
			self._state = "done"
		end
	elseif not (self._state == "done" or not (arg_6_5 > self._state_end)) then
		_csm:change_state("standing")

		return
	end

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
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

	local look_sense_override = self._breed.look_sense_override

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension, look_sense_override)
end

ChaosTrollStateVomiting.on_exit = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	self._status_extension.is_vomiting = false

	self:destroy_indicator_unit()
end

local num = 0.3

ChaosTrollStateVomiting._calculate_trajectory = function (self)
	-- function 8
	local _first_person_unit = self._first_person_unit
	local _breed = self._breed
	local local_rotation = Unit.local_rotation(_first_person_unit, 0)
	local pitch_from_rotation = ActionUtils.pitch_from_rotation(local_rotation)
	local world_position = Unit.world_position(_first_person_unit, self._troll_head_node)
	local var_8_5 = world_position
	local unbox = self._position:unbox()

	if not (not Vector3.equal(world_position, unbox) and pitch_from_rotation ~= self._angle) then
		return
	end

	self._position:store(world_position)

	self._angle = pitch_from_rotation

	local degrees_to_radians = math.degrees_to_radians(pitch_from_rotation)
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(local_rotation)))
	local normalize_2 = Vector3.normalize(normalize + Vector3(0, 0, _breed.vomit_upwards_amount))
	local vomit_projectile_speed = _breed.vomit_projectile_speed
	local default = ProjectileGravitySettings.default
	local _physics_world = self._physics_world
	local num_2 = 0.05
	local num_3 = 5
	local network = Managers.state.network
	local flag = false

	self._impact_data.sweep_positions = {}

	local sweep_positions = self._impact_data.sweep_positions

	sweep_positions[1] = Vector3Box(world_position)

	for i = num, 10, num do
		local position_on_trajectory = WeaponHelper:position_on_trajectory(world_position, normalize_2, vomit_projectile_speed, degrees_to_radians, default, i)

		sweep_positions[#sweep_positions + 1] = Vector3Box(position_on_trajectory)

		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(_physics_world, var_8_5, position_on_trajectory, num_2, num_3, "collision_filter", "filter_player_ray_projectile_static_only")
		local count

		if not linear_sphere_sweep then
			count = #linear_sphere_sweep

			if not count then
				-- Nothing
			end
		end

		count = 0

		::label_8_0::

		if count > 0 then
			local flag_2 = false

			for j = 1, count do
				local var_8_22 = linear_sphere_sweep[j]
				local position = var_8_22.position
				local normal = var_8_22.normal
				local actor = var_8_22.actor
				local distance = var_8_22.distance
				local normalize_3 = Vector3.normalize(position - var_8_5)

				if distance > 0 then
					local unit = Actor.unit(actor)

					if not network:level_object_id(unit) then
						local _impact_data = self._impact_data

						_impact_data.position:store(position)

						flag = true

						_impact_data.hit_normal:store(normal)
						_impact_data.direction:store(normalize_3)

						_impact_data.num_intervals = i
						_impact_data.hit_unit = unit
						flag_2 = true

						break
					end
				end
			end

			if not flag_2 then
				break
			end
		end

		var_8_5 = position_on_trajectory

		if not flag then
			self._impact_data.position:store(Vector3(0, 0, 0))
		end
	end
end

ChaosTrollStateVomiting._sweep_trajectory_for_heroes = function (self)
	-- function 9
	local tbl = {}
	local _physics_world = self._physics_world
	local puke_in_face_sweep_radius = self._breed.puke_in_face_sweep_radius
	local num = 10
	local sweep_positions = self._impact_data.sweep_positions

	for i = 1, #sweep_positions - 1 do
		local unbox = sweep_positions[i]:unbox()
		local unbox_2 = sweep_positions[i + 1]:unbox()
		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(_physics_world, unbox, unbox_2, puke_in_face_sweep_radius, num, "collision_filter", "filter_player")
		local count

		if not linear_sphere_sweep then
			count = #linear_sphere_sweep

			if not count then
				-- Nothing
			end
		end

		count = 0

		::label_9_0::

		if count > 0 then
			local num_2 = 1

			for j = 1, count do
				local actor = linear_sphere_sweep[j].actor
				local unit = Actor.unit(actor)

				if not (not Managers.state.side:versus_is_hero(unit) and table.contains(tbl, unit)) then
					tbl[num_2] = unit
					num_2 = num_2 + 1
				end
			end
		end
	end

	return tbl
end

ChaosTrollStateVomiting._init_puke_attack = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not (not self._puke_position_on_nav and not self._puke_distance_sq and self._puke_direction) then
		return false
	end

	local unbox = self._puke_position_on_nav:unbox()
	local _puke_distance_sq = self._puke_distance_sq
	local unbox_2 = self._puke_direction:unbox()
	local dot = Vector3.dot(unbox_2, Vector3.down())
	local num = 25
	local num_2 = 0.45
	local flag = false
	local flag_2 = not (num_2 <= dot) or not (_puke_distance_sq < num) or not flag
	local var_10_8

	if not flag_2 then
		var_10_8 = "attack_vomit"
		self._near_vomit = true
	else
		var_10_8 = "attack_vomit_high"
	end

	Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_10_1, "enemy_attack", DialogueSettings.pounced_down_broadcast_range, "attack_tag", "before_puke")
	Managers.state.network:anim_event(arg_10_1, var_10_8)
	CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, var_10_8)

	self._attack_started_at_t = arg_10_2

	return true
end

local num_2 = 10

ChaosTrollStateVomiting.player_vomit_hit_check = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local world_position = Unit.world_position(arg_11_1, self._troll_head_node)
	local num = arg_11_2 + (2 * Vector3.normalize(arg_11_2 - POSITION_LOOKUP[arg_11_1]) + Vector3(0, 0, 1)) - world_position
	local normalize = Vector3.normalize(num)
	local length = Vector3.length(num)
	local vomit_in_face_sweep_radius = self._breed.vomit_in_face_sweep_radius
	local _sweep_trajectory_for_heroes = self:_sweep_trajectory_for_heroes()

	if not (not _sweep_trajectory_for_heroes and table.is_empty(_sweep_trajectory_for_heroes)) then
		local count = #_sweep_trajectory_for_heroes
		local system = Managers.state.entity:system("buff_system")

		for i = 1, count do
			local var_11_8 = _sweep_trajectory_for_heroes[i]

			if not ScriptUnit.extension(var_11_8, "buff_system"):has_buff_type("vs_troll_bile_face") then
				system:add_buff(var_11_8, "vs_bile_troll_vomit_face_base", arg_11_1)
				Managers.state.achievement:trigger_event("on_troll_vomit_hit", var_11_8, arg_11_1)
			end
		end
	end
end

ChaosTrollStateVomiting.position_on_navmesh = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local triangle_from_position, var_12_1 = GwNavQueries.triangle_from_position(arg_12_1, self, arg_12_2 or 0.5, arg_12_3 or 1)

	if not triangle_from_position then
		self = Vector3.copy(self)
		self.z = var_12_1
	else
		arg_12_2 = 1.5
		arg_12_3 = 4

		local num = 4
		local num_2 = 0.5

		self = GwNavQueries.inside_position_from_outside_position(arg_12_1, self, arg_12_2, arg_12_3, num, num_2)
	end

	return self
end

ChaosTrollStateVomiting.spawn_vomit = function (self, arg_13_1)
	-- function 13
	local unbox = self._puke_position_on_nav:unbox()

	if not unbox then
		local unbox_2 = self._puke_direction:unbox()
		local look = Quaternion.look(unbox_2)
		local flag

		flag = not self._near_vomit and 1 and 2

		Managers.state.unit_spawner:request_spawn_template_unit("troll_puke", unbox, look, arg_13_1, flag)
	end
end

ChaosTrollStateVomiting._get_vomit_position = function (self, arg_14_1)
	-- function 14
	local world_position = Unit.world_position(arg_14_1, self._troll_head_node)
	local position = ScriptCamera.position(self._camera)
	local rotation = ScriptCamera.rotation(self._camera)
	local forward = Quaternion.forward(rotation)
	local _max_dist = self._max_dist
	local var_14_5
	local var_14_6
	local var_14_7
	local num = 1
	local num_2 = 5
	local position_on_navmesh = ChaosTrollStateVomiting.position_on_navmesh(self._impact_data.position:unbox(), self._nav_world, num, num_2)
	local var_14_11

	if not position_on_navmesh then
		local num_3 = position_on_navmesh - world_position

		var_14_7 = Vector3.normalize(num_3)
		var_14_6 = Vector3.length_squared(num_3)
	end

	return position_on_navmesh, var_14_6, var_14_7
end

ChaosTrollStateVomiting._update_movement = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	local _input_extension = self._input_extension
	local _buff_extension = self._buff_extension
	local _first_person_extension = self._first_person_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_15_1)
	local get_movement_input = CharacterStateHelper.get_movement_input(_input_extension)
	local has_move_input = CharacterStateHelper.has_move_input(_input_extension)
	local current_movement_speed_scale = self.current_movement_speed_scale

	if not self.is_bot then
		local num = get_movement_settings_table.move_acceleration_up * arg_15_3
		local num_2 = get_movement_settings_table.move_acceleration_down * arg_15_3

		if not has_move_input then
			current_movement_speed_scale = math.min(1, current_movement_speed_scale + num)
		else
			current_movement_speed_scale = math.max(0, current_movement_speed_scale - num_2)
		end
	else
		current_movement_speed_scale = not has_move_input and 1 and 0
	end

	local vomit_movement_speed = self._breed.vomit_movement_speed
	local lerp = math.lerp(0.6, vomit_movement_speed, (arg_15_4 or 1)^2)
	local num_3 = _buff_extension:apply_buffs_to_value(lerp, "movement_speed") * current_movement_speed_scale * get_movement_settings_table.player_speed_scale
	local var_15_12 = Vector3(0, 0, 0)

	if not get_movement_input then
		var_15_12 = var_15_12 + get_movement_input
	end

	local var_15_13
	local normalize = Vector3.normalize(var_15_12)

	if Vector3.length(normalize) == 0 then
		normalize = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize)
	end

	local get_move_animation, var_15_16 = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, self._status_extension, self.move_anim_3p)

	if get_move_animation ~= self.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_15_1, get_move_animation)

		self.move_anim_3p = get_move_animation
	end

	if var_15_16 ~= self.move_anim_1p then
		self.move_anim_1p = var_15_16

		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_15_16)
	end

	if not (self._previous_state == "jumping" or self._previous_state ~= "falling") then
		CharacterStateHelper.move_in_air_pactsworn(self._first_person_extension, _input_extension, self._locomotion_extension, num_3, arg_15_1)
	else
		CharacterStateHelper.move_on_ground(_first_person_extension, _input_extension, self._locomotion_extension, normalize, num_3, arg_15_1)
	end

	self.current_movement_speed_scale = current_movement_speed_scale
end
