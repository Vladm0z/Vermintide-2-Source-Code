-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_prowling.lua

GutterRunnerStateProwling = class(GutterRunnerStateProwling, EnemyCharacterState)

GutterRunnerStateProwling.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "gutter_runner_prowling")

	local var_1_0 = arg_1_1

	self.current_movement_speed_scale = 0
	self.latest_valid_navmesh_position = Vector3Box(math.huge, math.huge, math.huge)
	self.last_input_direction = Vector3Box(0, 0, 0)
end

GutterRunnerStateProwling.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self._pounce_ready = false

	local _unit = self._unit
	local _input_extension = self._input_extension
	local _first_person_extension = self._first_person_extension
	local _status_extension = self._status_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension
	local current_velocity = self._locomotion_extension:current_velocity()

	self._breed = Unit.get_data(_unit, "breed")

	local owner = Managers.player:owner(_unit)
	local flag = not owner and owner.bot_player

	if arg_2_6 == "standing" then
		self.current_movement_speed_scale = 0
	else
		self.current_movement_speed_scale = 1
	end

	if not flag then
		local normalize = Vector3.normalize(Vector3.flat(current_velocity))
		local current_rotation = _first_person_extension:current_rotation()
		local dot = Vector3.dot(Quaternion.right(current_rotation), normalize)
		local dot_2 = Vector3.dot(Vector3.normalize(Vector3.flat(Quaternion.forward(current_rotation))), normalize)
		local var_2_13 = Vector3(dot, dot_2, 0)

		self.last_input_direction:store(var_2_13)
	end

	local get_move_animation, var_2_15 = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, _status_extension, self.move_anim_3p)

	self.move_anim_3p = get_move_animation
	self.move_anim_1p = var_2_15

	CharacterStateHelper.play_animation_event(_unit, get_move_animation)
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_2_15)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, _unit, _input_extension, _inventory_extension, _health_extension)
	_first_person_extension:play_unit_sound_event("Play_versus_gutterrunner_jump_attack_enter", _unit, 0)

	self.is_bot = flag

	self:_start_priming(arg_2_5)

	self._exit_with_priming = true

	self:set_breed_action("prepare_crazy_jump")

	self._left_wpn_particle_name = "fx/wpnfx_gutter_runner_enemy_in_range_1p"
	self._left_wpn_particle_node_name = "g_wpn_left_claw"
	self._right_wpn_particle_name = "fx/wpnfx_gutter_runner_enemy_in_range_1p"
	self._right_wpn_particle_node_name = "g_wpn_right_claw"

	self._ghost_mode_extension:set_external_no_spawn_reason("prowling", true)
end

GutterRunnerStateProwling.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	EnemyCharacterState.on_exit(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)

	if not (arg_3_7 or Managers.state.network:game()) then
		return
	end

	self._pounce_ready = nil

	if not self._exit_with_priming then
		self:_stop_priming(arg_3_5)
	end

	self:_set_priming_progress(0)
	self:set_breed_action("n/a")
	self._ghost_mode_extension:set_external_no_spawn_reason("prowling", nil)
end

GutterRunnerStateProwling.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local _world = self._world
	local _unit = self._unit
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(_unit)
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _health_extension = self._health_extension
	local _inventory_extension = self._inventory_extension

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		self._exit_with_priming = false

		return
	end

	local flag = false

	if not _input_extension:get("dark_pact_action_one_release") then
		self:_update_priming(arg_4_5, arg_4_3, true)

		if not self._done_priming then
			self:_start_pounce()

			return
		else
			flag = true
		end

		self._pounce_ready = true
	else
		self:_update_priming(arg_4_5, arg_4_3, false)
	end

	if _input_extension:get("dark_pact_action_two") or not flag then
		_first_person_extension:play_hud_sound_event("Stop_versus_gutterrunner_jump_charge_loop")

		self._exit_with_priming = false

		_csm:change_state("walking")

		return
	end

	local current_movement_speed_scale = self.current_movement_speed_scale
	local CharacterStateHelper = CharacterStateHelper

	if not _locomotion_extension:is_on_ground() then
		ScriptUnit.extension(_unit, "whereabouts_system"):set_is_onground()
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

	if not _locomotion_extension:is_animation_driven() then
		return
	end

	local is_device_active = Managers.input:is_device_active("gamepad")

	if not (_csm.state_next or _locomotion_extension:is_on_ground()) then
		_csm:change_state("falling", self._temp_params)
		_first_person_extension:change_state("falling")

		return
	end

	local owner = Managers.player:owner(_unit)
	local get_movement_input = CharacterStateHelper.get_movement_input(_input_extension)
	local has_move_input = CharacterStateHelper.has_move_input(_input_extension)

	if not self.is_bot then
		local _breed = self._breed

		_breed = not _breed and self._breed.breed_move_acceleration_up

		local _breed_2 = self._breed

		_breed_2 = not _breed_2 and self._breed.breed_move_acceleration_down

		local num = _breed * arg_4_3

		num = num or get_movement_settings_table.move_acceleration_up * arg_4_3

		local num_2 = _breed_2 * arg_4_3

		num_2 = num_2 or get_movement_settings_table.move_acceleration_down * arg_4_3

		if not has_move_input then
			current_movement_speed_scale = math.min(1, current_movement_speed_scale + num)

			if not is_device_active then
				current_movement_speed_scale = Vector3.length(get_movement_input) * current_movement_speed_scale
			end
		else
			current_movement_speed_scale = math.max(0, current_movement_speed_scale - num_2)
		end
	else
		current_movement_speed_scale = not has_move_input and 1 and 0
	end

	local num_3 = get_movement_settings_table.crouch_move_speed * _status_extension:current_move_speed_multiplier() * current_movement_speed_scale * get_movement_settings_table.player_speed_scale
	local normalize = Vector3.normalize(get_movement_input)

	if Vector3.length_squared(get_movement_input) == 0 then
		normalize = self.last_input_direction:unbox()
	else
		self.last_input_direction:store(normalize)
	end

	CharacterStateHelper.move_on_ground(_first_person_extension, _input_extension, _locomotion_extension, normalize, num_3, _unit)
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)

	local get_move_animation, var_4_25 = CharacterStateHelper.get_move_animation(_locomotion_extension, _input_extension, _status_extension, self.move_anim_3p)

	if get_move_animation ~= self.move_anim_3p then
		CharacterStateHelper.play_animation_event(_unit, get_move_animation)

		self.move_anim_3p = get_move_animation
	end

	if var_4_25 ~= self.move_anim_1p then
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_4_25)

		self.move_anim_1p = var_4_25
	end

	self.current_movement_speed_scale = current_movement_speed_scale
end

GutterRunnerStateProwling._start_priming = function (self, arg_5_1)
	-- function 5
	local _first_person_extension = self._first_person_extension

	_first_person_extension:play_hud_sound_event("Play_versus_gutterrunner_jump_charge_loop")
	CharacterStateHelper.play_animation_event(self._unit, "to_crouch")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "to_crouch")

	local _locomotion_extension = self._locomotion_extension

	self._done_priming = false
	self._prime_time = arg_5_1 + self._breed.pounce_prime_time

	_first_person_extension:set_wanted_player_height("crouch", arg_5_1, self._breed.pounce_prime_time)
	_locomotion_extension:set_active_mover("crouch")
end

GutterRunnerStateProwling._set_priming_progress = function (self, arg_6_1)
	-- function 6
	local _career_extension = self._career_extension
	local str = "pounce"
	local ability_id = _career_extension:ability_id(str)

	_career_extension:get_activated_ability_data(ability_id).priming_progress = arg_6_1

	self._first_person_extension:animation_set_variable("pounce_charge", arg_6_1, true)
end

local num = 0.025

GutterRunnerStateProwling._update_priming = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not ((arg_7_1 > self._prime_time or not arg_7_3) and not (arg_7_1 > self._prime_time - num)) then
		if not self._done_priming then
			self._first_person_extension:play_hud_sound_event("Play_versus_gutterrunner_jump_charge_end")
		end

		self._done_priming = true
	end

	local pounce_prime_time = self._breed.pounce_prime_time
	local num_2 = math.min(pounce_prime_time - (self._prime_time - arg_7_1), pounce_prime_time) / pounce_prime_time

	self:_set_priming_progress(num_2)
end

GutterRunnerStateProwling._stop_priming = function (self, arg_8_1)
	-- function 8
	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.play_animation_event(self._unit, "to_upright")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "to_upright")

	local _locomotion_extension = self._locomotion_extension

	_first_person_extension:set_wanted_player_height("stand", arg_8_1)
	_locomotion_extension:set_active_mover("standing")
end

GutterRunnerStateProwling._start_pounce = function (self)
	-- function 9
	if not self._locomotion_extension:is_on_ground() then
		return
	end

	local _first_person_extension = self._first_person_extension
	local _world = self._world
	local _is_server = self._is_server
	local local_player = self.local_player
	local _status_extension = self._status_extension
	local _breed = self._breed
	local pounce_speed = _breed.pounce_speed
	local current_rotation = _first_person_extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)
	local num = Vector3.normalize(forward + Vector3(0, 0, _breed.pounce_upwards_amount)) * pounce_speed

	_status_extension.do_pounce = {
		anim_start_event = "to_crouch",
		initial_velocity = Vector3Box(num)
	}

	local _career_extension = self._career_extension
	local ability_id = _career_extension:ability_id("pounce")

	if not _career_extension:can_use_activated_ability(ability_id) then
		self._csm:change_state("pouncing")
	end
end
