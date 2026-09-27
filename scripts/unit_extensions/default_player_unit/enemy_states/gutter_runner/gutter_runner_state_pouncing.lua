-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_pouncing.lua

GutterRunnerStatePouncing = class(GutterRunnerStatePouncing, EnemyCharacterState)

GutterRunnerStatePouncing.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterState.init(arg_1_0, arg_1_1, "pouncing")
end

local POSITION_LOOKUP = POSITION_LOOKUP

GutterRunnerStatePouncing.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	table.clear(self._temp_params)

	local _player = self._player
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local _inventory_extension = self._inventory_extension
	local _first_person_extension = self._first_person_extension

	self._breed = Unit.get_data(arg_2_1, "breed")
	self._physics_world = World.physics_world(self._world)

	local do_pounce = _status_extension.do_pounce

	do_pounce.starting_pos = Vector3Box(POSITION_LOOKUP[arg_2_1])
	do_pounce.sfx_event_jump = "Play_versus_gutterrunner_jump_attack_release"
	do_pounce.sfx_event_land = "Play_versus_pactsworn_jump_land"
	do_pounce.sfx_event_jump_end = "Play_versus_gutterrunner_leap_stop"
	self._pounce_data = do_pounce
	_status_extension.do_pounce = false

	local unbox = do_pounce.initial_velocity:unbox()

	self:_start_pounce(arg_2_1, unbox, arg_2_5)
	CharacterStateHelper.ghost_mode(self._ghost_mode_extension, _input_extension)
	CharacterStateHelper.look(_input_extension, _player.viewport_name, _first_person_extension, _status_extension, self._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, _input_extension, _inventory_extension, self._health_extension)

	local var_2_8 = POSITION_LOOKUP[arg_2_1]

	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	local z = POSITION_LOOKUP[arg_2_1].z

	_status_extension:set_falling_height(z)
	_status_extension:set_gutter_runner_leaping(true)

	self._entered_in_ghostmode = _status_extension:get_in_ghost_mode()
	self._played_landing_event = nil

	CharacterStateHelper.play_animation_event(arg_2_1, "jump_start")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "jump_start")

	local var_2_10 = BLACKBOARDS[arg_2_1]

	var_2_10.starting_pos_boxed = Vector3Box(POSITION_LOOKUP[arg_2_1])
	var_2_10.pounce_start_time = arg_2_5

	self:set_breed_action("jump")
	self._ghost_mode_extension:set_external_no_spawn_reason("pouncing", true)
end

GutterRunnerStatePouncing.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _status_extension = self._status_extension

	_locomotion_extension:reset_maximum_upwards_velocity()

	local extension = ScriptUnit.extension(arg_3_1, "career_system")
	local ability_id = extension:ability_id("pounce")

	extension:start_activated_ability_cooldown(ability_id)

	local sfx_event_jump_end = self._pounce_data.sfx_event_jump_end

	if not sfx_event_jump_end then
		_first_person_extension:play_unit_sound_event(sfx_event_jump_end, arg_3_1, 0)
	end

	if not (arg_3_6 == "walking" or arg_3_6 ~= "standing") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	elseif not (not arg_3_6 and arg_3_6 == "falling") then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end

	if not arg_3_6 and not Managers.state.network:game() then
		if arg_3_6 == "pinning_enemy" then
			CharacterStateHelper.play_animation_event(arg_3_1, "jump_attack")
			CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "attack_finished")
		else
			CharacterStateHelper.play_animation_event(arg_3_1, "jump_fail")
			CharacterStateHelper.play_animation_event(arg_3_1, "to_combat")
			CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "attack_finished")
		end
	end

	CharacterStateHelper.play_animation_event(self._unit, "to_upright")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "to_upright")
	_first_person_extension:set_wanted_player_height("stand", arg_3_5)
	_locomotion_extension:set_active_mover("standing")
	self:set_breed_action("n/a")

	if not arg_3_7 then
		return
	end

	self._ghost_mode_extension:set_external_no_spawn_reason("pouncing", nil)
	_status_extension:set_gutter_runner_leaping(false)
end

GutterRunnerStatePouncing.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension
	local _breed = self._breed

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

	if not self:_update_movement(arg_4_1, arg_4_3, arg_4_5) then
		self:_finish(arg_4_1, arg_4_5)

		if not self._pounce_target then
			local _pounce_target = self._pounce_target

			self._temp_params.target_unit = _pounce_target

			_csm:change_state("pinning_enemy", self._temp_params)
			_first_person_extension:change_state("pinning_enemy")

			return
		end

		if not CharacterStateHelper.is_colliding_down(arg_4_1) then
			_csm:change_state("walking", self._temp_params)
			_first_person_extension:change_state("walking")

			return
		end

		if not (self._csm.state_next or not (_locomotion_extension:current_velocity().z <= 0)) then
			_csm:change_state("falling", self._temp_params)
			_first_person_extension:change_state("falling")

			return
		end
	end

	local pounce_look_sense = _breed.pounce_look_sense

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension, pounce_look_sense)
end

GutterRunnerStatePouncing._update_movement = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local _locomotion_extension = self._locomotion_extension
	local _previous_speed = self._previous_speed

	self._pounce_target = nil

	if not self._entered_in_ghostmode then
		local pounce_hit_radius = self._breed.pounce_hit_radius
		local alloc_table = FrameTable.alloc_table()
		local system = Managers.state.entity:system("proximity_system")
		local var_5_5 = POSITION_LOOKUP[arg_5_1]
		local player_units_broadphase = system.player_units_broadphase

		Broadphase.query(player_units_broadphase, var_5_5, pounce_hit_radius, alloc_table)

		local var_5_7

		for k, v in pairs(alloc_table) do
			local extension = ScriptUnit.extension(v, "status_system")

			if v == arg_5_1 or not CharacterStateHelper.is_viable_stab_target(arg_5_1, v, extension) then
				local world_position = Unit.world_position(v, Unit.node(v, "j_spine"))
				local distance = Vector3.distance(world_position, var_5_5)

				if not var_5_7 and not (distance < var_5_7) or not PerceptionUtils.is_position_in_line_of_sight(nil, var_5_5, world_position, self._physics_world) then
					var_5_7 = distance
					self._pounce_target = v
				end
			end
		end
	end

	if CharacterStateHelper.is_colliding_down(arg_5_1) or CharacterStateHelper.is_colliding_sides(arg_5_1) or not self._pounce_target then
		return true
	end

	local length = Vector3.length(_locomotion_extension:current_velocity())

	self._previous_speed = length

	local _status_extension = self._status_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_5_1)
	local num = length * get_movement_settings_table.player_air_speed_scale_pouncing

	self:_move_during_pounce(num, arg_5_1, arg_5_2)
end

GutterRunnerStatePouncing._move_during_pounce = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local _input_extension = self._input_extension
	local get_movement_input = CharacterStateHelper.get_movement_input(_input_extension)

	if not get_movement_input then
		return
	end

	local _locomotion_extension = self._locomotion_extension
	local _first_person_extension = self._first_person_extension
	local _breed = self._breed
	local normalize = Vector3.normalize(get_movement_input)
	local current_rotation = _first_person_extension:current_rotation()
	local normalize_2 = Vector3.normalize(Vector3.flat(Quaternion.rotate(current_rotation, normalize)))
	local flat = Vector3.flat(_locomotion_extension:current_velocity())
	local current_velocity = _locomotion_extension:current_velocity()
	local num = flat + normalize_2 * arg_6_1
	local num_2 = current_velocity.z - _breed.pounce_gravity * arg_6_3
	local length = Vector3.length(num)
	local clamp = math.clamp(length, 0, math.huge)
	local num_3 = Vector3.normalize(num) * clamp

	num_3.z = num_2

	_locomotion_extension:set_forced_velocity(num_3)

	local num_4 = 0.5
	local look = Quaternion.look(num_3, Vector3.up())
	local pitch = Quaternion.pitch(look)

	if pitch < Quaternion.pitch(current_rotation) then
		local look_2 = Quaternion.look(current_velocity, Vector3.up())
		local pitch_2 = Quaternion.pitch(look_2)
		local radian_lerp = math.radian_lerp(pitch_2, pitch, num_4)
		local right = Quaternion.right(current_rotation)
		local axis_angle = Quaternion.axis_angle(right, radian_lerp - pitch_2)
		local multiply = Quaternion.multiply(axis_angle, current_rotation)

		_first_person_extension:set_rotation(multiply)
	end
end

GutterRunnerStatePouncing._finish = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _world = self._world
	local _locomotion_extension = self._locomotion_extension
	local _first_person_extension = self._first_person_extension
	local var_7_3 = Vector3(0, 0, 0)

	_locomotion_extension:set_forced_velocity(var_7_3)
	_first_person_extension:play_camera_effect_sequence("landed_hard", arg_7_2)

	local sfx_event_land = self._pounce_data.sfx_event_land

	if not ((self._pounce_target or not sfx_event_land) and self._played_landing_event) then
		_first_person_extension:play_unit_sound_event(sfx_event_land, arg_7_1, 0)

		self._played_landing_event = true
	end

	CharacterStateHelper.play_animation_event(arg_7_1, "jump_land")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "jump_land")

	PlayerUnitMovementSettings.get_movement_settings_table(arg_7_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration
end

GutterRunnerStatePouncing._start_pounce = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local _world = self._world
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension

	self._previous_speed = 0

	_first_person_extension:play_camera_effect_sequence("jump", arg_8_3)

	local sfx_event_jump = self._pounce_data.sfx_event_jump

	if not sfx_event_jump then
		_first_person_extension:play_unit_sound_event(sfx_event_jump, arg_8_1, 0)
	end

	local _breed = self._breed
	local pounce_start_forward_offset = _breed.pounce_start_forward_offset
	local pounce_start_up_offset = _breed.pounce_start_up_offset
	local var_8_7 = POSITION_LOOKUP[arg_8_1]
	local current_rotation = _first_person_extension:current_rotation()
	local num = Vector3.normalize(Vector3.flat(Quaternion.forward(current_rotation))) * pounce_start_forward_offset

	num.z = pounce_start_up_offset

	_locomotion_extension:teleport_to(var_8_7 + num)
	_locomotion_extension:set_maximum_upwards_velocity(arg_8_2.z)
	_locomotion_extension:set_forced_velocity(arg_8_2)
	_locomotion_extension:set_wanted_velocity(arg_8_2)

	PlayerUnitMovementSettings.get_movement_settings_table(arg_8_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration_gutter_runner_pounce
end
