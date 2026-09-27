-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state.lua

require("scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_helper")

EnemyCharacterState = class(EnemyCharacterState)

EnemyCharacterState.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local unit = arg_1_1.unit
	local get_data = Unit.get_data(unit, "breed")

	self.name = arg_1_2
	self._world = arg_1_1.world
	self._physics_world = World.get_data(self._world, "physics_world")
	self._wwise_world = Managers.world:wwise_world(self._world)
	self._unit = unit
	self._breed = get_data
	self._csm = arg_1_1.csm
	self._player = arg_1_1.player
	self._network_transmit = arg_1_1.network_transmit
	self._unit_storage = arg_1_1.unit_storage
	self._nav_world = arg_1_1.nav_world
	self._is_server = Managers.player.is_server
	self._temp_params = {}
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._input_extension = ScriptUnit.extension(unit, "input_system")
	self._interactor_extension = ScriptUnit.extension(unit, "interactor_system")
	self._inventory_extension = ScriptUnit.extension(unit, "inventory_system")
	self._career_extension = ScriptUnit.extension(unit, "career_system")
	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._status_extension = ScriptUnit.extension(unit, "status_system")
	self._ghost_mode_extension = ScriptUnit.extension(unit, "ghost_mode_system")
	self._overcharge_extension = ScriptUnit.extension(unit, "overcharge_system")
	self._first_person_unit = self._first_person_extension:get_first_person_unit()
	self._particle_ids = {}
	self._left_wpn_particle_name = nil
	self._left_wpn_particle_node_name = nil
	self._right_wpn_particle_name = nil
	self._right_wpn_particle_node_name = nil
	self._weighted_taunt_values = {}
	self._taunt_timer = 0
	self._max_taunt_distance = 30
	self._taunt_cooldown = 20
end

EnemyCharacterState.on_exit = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	self:destroy_particles()
end

EnemyCharacterState.handle_disabled_ghost_mode = function (self)
	-- function 3
	local _ghost_mode_extension = self._ghost_mode_extension

	if not _ghost_mode_extension:is_in_ghost_mode() and not Development.parameter("disable_ghost_mode") then
		local flag = true

		_ghost_mode_extension:try_leave_ghost_mode(flag)
	end
end

EnemyCharacterState.set_breed_action = function (self, arg_4_1)
	-- function 4
	local name = Unit.get_data(self._unit, "breed").name

	if not Managers.state.network:game() then
		return
	end

	if not self._is_server then
		self._status_extension:set_breed_action(name, arg_4_1)
	else
		local var_4_1 = NetworkLookup.breeds[name]
		local var_4_2 = NetworkLookup.bt_action_names[arg_4_1]
		local go_id = Managers.state.unit_storage:go_id(self._unit)

		Managers.state.network.network_transmit:send_rpc_server("rpc_set_action_data", go_id, var_4_1, var_4_2)
	end
end

EnemyCharacterState.has_move_input = function (self)
	-- function 5
	local _input_extension = self._input_extension

	return CharacterStateHelper.has_move_input(_input_extension)
end

EnemyCharacterState.has_jump_input = function (self)
	-- function 6
	local _input_extension = self._input_extension
	local get = _input_extension:get("jump")

	get = get or _input_extension:get("jump_only")

	return get
end

EnemyCharacterState.has_movement_input = function (self)
	-- function 7
	local flag = false

	flag = flag or self:has_move_input()
	flag = flag or self:has_jump_input()

	return flag
end

EnemyCharacterState.to_movement_state = function (self)
	-- function 8
	local _csm = self._csm
	local _locomotion_extension = self._locomotion_extension

	if not self:has_move_input() then
		_csm:change_state("walking")
	elseif not self:has_jump_input() and not _locomotion_extension:jump_allowed() then
		local _first_person_extension = self._first_person_extension

		_csm:change_state("jumping")
		_first_person_extension:change_state("jumping")
	else
		_csm:change_state("standing")
	end
end

EnemyCharacterState.update_movement = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	-- function 9
	local _input_extension = self._input_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_9_1)
	local has_move_input = CharacterStateHelper.has_move_input(_input_extension)
	local current_movement_speed_scale = self.current_movement_speed_scale

	current_movement_speed_scale = current_movement_speed_scale or 0

	if not self.is_bot then
		local num = get_movement_settings_table.move_acceleration_up * arg_9_3
		local num_2 = get_movement_settings_table.move_acceleration_down * arg_9_3

		if not has_move_input then
			current_movement_speed_scale = math.min(1, current_movement_speed_scale + num)
		else
			current_movement_speed_scale = math.max(0, current_movement_speed_scale - num_2)
		end
	else
		current_movement_speed_scale = not has_move_input and 1 and 0
	end

	local var_9_6 = arg_9_4
	local num_3 = self._buff_extension:apply_buffs_to_value(var_9_6, "movement_speed") * current_movement_speed_scale * get_movement_settings_table.player_speed_scale
	local var_9_8 = Vector3(0, 0, 0)
	local get_movement_input = CharacterStateHelper.get_movement_input(_input_extension)

	if not get_movement_input then
		var_9_8 = var_9_8 + get_movement_input
	end

	local _first_person_extension = self._first_person_extension
	local normalize = Vector3.normalize(var_9_8)

	CharacterStateHelper.move_on_ground(_first_person_extension, _input_extension, self._locomotion_extension, normalize, num_3, arg_9_1)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, self._status_extension, self._inventory_extension)

	if arg_9_5 or not arg_9_6 then
		local get_move_animation, var_9_13 = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, self._status_extension, self.move_anim_3p)

		if not (not arg_9_5 and get_move_animation == self.move_anim_3p) then
			CharacterStateHelper.play_animation_event(arg_9_1, get_move_animation)

			self.move_anim_3p = get_move_animation
		end

		if not (not arg_9_6 and var_9_13 == self.move_anim_1p) then
			CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_9_13)

			self.move_anim_1p = var_9_13
		end
	end

	self.current_movement_speed_scale = current_movement_speed_scale
end

EnemyCharacterState.create_particles = function (self)
	-- function 10
	if #self._particle_ids == 0 then
		local get_all_weapon_unit, var_10_1 = self._inventory_extension:get_all_weapon_unit()

		if not get_all_weapon_unit and not self._left_wpn_particle_name then
			self:_create_particle_for_weapon(get_all_weapon_unit, self._left_wpn_particle_name, self._left_wpn_particle_node_name)
		end

		if not var_10_1 and not self._right_wpn_particle_name then
			self:_create_particle_for_weapon(var_10_1, self._right_wpn_particle_name, self._right_wpn_particle_node_name)
		end
	end
end

EnemyCharacterState._create_particle_for_weapon = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local node

	if not arg_11_3 then
		node = Unit.node(arg_11_1, arg_11_3)

		if not node then
			-- Nothing
		end
	end

	node = 0

	::label_11_0::

	local create_particles_linked = ScriptWorld.create_particles_linked(self._world, arg_11_2, arg_11_1, node, "destroy")

	self._particle_ids[#self._particle_ids + 1] = create_particles_linked
end

EnemyCharacterState.destroy_particles = function (self)
	-- function 12
	local _particle_ids = self._particle_ids

	for i = 1, #_particle_ids do
		local var_12_1 = _particle_ids[i]

		World.stop_spawning_particles(self._world, var_12_1)
	end

	table.clear(_particle_ids)
end

EnemyCharacterState.check_enemies_in_range_vfx = function (self, ...)
	-- function 13
	if not EnemyCharacterStateHelper.get_enemies_in_line_of_sight(self._unit, self._first_person_unit, self._physics_world, ...) then
		self:create_particles()
	else
		self:destroy_particles()
	end
end

EnemyCharacterState._update_taunt_dialogue = function (self, arg_14_1)
	-- function 14
	if not self._ghost_mode_extension:is_in_ghost_mode() then
		return
	end

	if arg_14_1 <= self._taunt_timer then
		return
	end

	self._taunt_timer = arg_14_1 + self._taunt_cooldown

	local _first_person_unit = self._first_person_unit
	local _unit = self._unit
	local player = Managers.player
	local var_14_3 = POSITION_LOOKUP[_first_person_unit]
	local world_rotation = Unit.world_rotation(_first_person_unit, 0)
	local normalize = Vector3.normalize(Quaternion.forward(world_rotation))
	local VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS = Managers.state.side.side_by_unit[_unit].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local tbl = {}

	for k, v in pairs(VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS) do
		local world_position = Unit.world_position(k, Unit.node(k, "c_spine"))
		local distance = Vector3.distance(world_position, var_14_3)

		if not (distance <= self._max_taunt_distance) or not EnemyCharacterStateHelper.is_infront_player(var_14_3, normalize, world_position) then
			local normalize_2 = Vector3.normalize(world_position - var_14_3)
			local immediate_raycast, var_14_12, var_14_13, var_14_14, var_14_15 = PhysicsWorld.immediate_raycast(self._physics_world, var_14_3, normalize_2, distance, "closest", "collision_filter", "filter_husk_in_line_of_sight")

			if not immediate_raycast then
				tbl[#tbl + 1] = k
			end
		end
	end

	local tbl_2 = {}

	for i, v_2 in ipairs(tbl) do
		local profile_display_name = player:owner(v_2):profile_display_name()
		local var_14_18 = self._weighted_taunt_values[profile_display_name]

		if not var_14_18 then
			var_14_18 = 1
			self._weighted_taunt_values[profile_display_name] = var_14_18
		end

		tbl_2[i] = 1 / var_14_18
	end

	if #tbl_2 > 0 then
		local var_14_19, var_14_20 = LoadedDice.create(tbl_2, false)
		local var_14_21 = tbl[LoadedDice.roll(var_14_19, var_14_20)]
		local profile_display_name_2 = player:owner(var_14_21):profile_display_name()

		self._weighted_taunt_values[profile_display_name_2] = self._weighted_taunt_values[profile_display_name_2] + 1

		local extension_input = ScriptUnit.extension_input(self._unit, "dialogue_system")
		local str = "taunting_" .. profile_display_name_2
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event(str, alloc_table)
	end
end

EnemyCharacterState.debug_display_ratling_gunner_ammo = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	Managers.state.event:trigger("on_dark_pact_ammo_changed", arg_15_1, arg_15_2)
end
