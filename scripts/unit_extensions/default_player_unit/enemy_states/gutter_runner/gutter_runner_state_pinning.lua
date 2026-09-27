-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/gutter_runner/gutter_runner_state_pinning.lua

GutterRunnerStatePinning = class(GutterRunnerStatePinning, EnemyCharacterState)

GutterRunnerStatePinning.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "pinning_enemy")

	self.lerp_target_position = Vector3Box()
	self.lerp_start_position = Vector3Box()
	self.breed = Unit.get_data(self._unit, "breed")
	self._foff_ability_id = self._career_extension:ability_id("foff")
end

GutterRunnerStatePinning.change_to_third_person_camera = function (self)
	-- function 2
	CharacterStateHelper.change_camera_state(self._player, "follow_third_person")
	self._first_person_extension:set_first_person_mode(false)
end

GutterRunnerStatePinning.pounce_down = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local _locomotion_extension = self._locomotion_extension
	local var_3_1 = POSITION_LOOKUP[arg_3_2]

	_locomotion_extension:set_wanted_velocity(Vector3.zero())

	local mover = Unit.mover(arg_3_1)

	Mover.set_position(mover, var_3_1)
	LocomotionUtils.separate_mover_fallbacks(mover, 1)

	local position = Mover.position(mover)

	_locomotion_extension:teleport_to(position)

	local flat_no_roll = Quaternion.flat_no_roll(Unit.local_rotation(arg_3_1, 0))

	Unit.set_local_rotation(arg_3_1, 0, flat_no_roll)
	self._locomotion_extension:set_disable_rotation_update()

	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_3_1)

	if not Managers.state.network.is_server then
		network.network_transmit:send_rpc_clients("rpc_teleport_unit_to", unit_game_object_id, position, flat_no_roll)
	else
		network.network_transmit:send_rpc_server("rpc_teleport_unit_to", unit_game_object_id, position, flat_no_roll)
	end

	StatusUtils.set_pounced_down_network("pounced_down", arg_3_2, true, arg_3_1)
	ScriptUnit.extension(arg_3_2, "status_system"):add_pacing_intensity(CurrentIntensitySettings.intensity_add_pounced_down)

	local _blackboard = self._blackboard
	local breed = _blackboard.breed
	local num = arg_3_3 - _blackboard.pounce_start_time
	local name = breed.name
	local num_2 = num / breed.pounce_max_damage_time
	local clamp = math.clamp(num_2 * breed.max_pounce_damage, breed.min_pounce_damage, breed.max_pounce_damage)
	local var_3_13

	DamageUtils.add_damage_network(arg_3_2, arg_3_1, clamp, "torso", "cutting", nil, Vector3(1, 0, 0), name, nil, nil, nil, var_3_13, nil, nil, nil, nil, nil, nil, 1)

	local target_pounced = BreedActions.skaven_gutter_runner.target_pounced

	BTTargetPouncedAction.impact_pushback(arg_3_1, var_3_1, target_pounced.close_impact_radius, target_pounced.far_impact_radius, target_pounced.impact_speed_given, _blackboard.target_unit)
end

GutterRunnerStatePinning.on_enter = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	-- function 4
	local _unit = self._unit
	local _first_person_extension = self._first_person_extension
	local target_unit = arg_4_7.target_unit

	self._blackboard = BLACKBOARDS[_unit]
	self._blackboard.start_pouncing_time = arg_4_5

	self:set_breed_action("target_pounced")
	_first_person_extension:play_unit_sound_event("Play_versus_gutterrunner_jump_attack_hit", _unit, 0)
	self:pounce_down(_unit, target_unit, arg_4_5)

	self.target_unit = target_unit
	self.target_status_extension = ScriptUnit.extension(target_unit, "status_system")

	CharacterStateHelper.stop_weapon_actions(self._inventory_extension, "pinning_enemy")
	CharacterStateHelper.stop_career_abilities(self._career_extension, "pinning_enemy")
	self._locomotion_extension:set_forced_velocity(Vector3:zero())
	self:change_to_third_person_camera()

	self._next_stab_time = arg_4_5

	self._status_extension:set_pinning_enemy(true, target_unit)
end

GutterRunnerStatePinning.on_exit = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	CharacterStateHelper.change_camera_state(self._player, "follow")
	self._first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

	if not ALIVE[self.target_unit] then
		StatusUtils.set_pounced_down_network("pounced_down", self.target_unit, false, arg_5_1)
	else
		self._status_extension:set_pinning_enemy(false, self.target_unit)
	end

	self:set_breed_action("n/a")

	local current_ability_cooldown = self._career_extension:current_ability_cooldown(self._foff_ability_id)

	if current_ability_cooldown < 1 then
		self._career_extension:reduce_activated_ability_cooldown((1 - current_ability_cooldown) * -1, self._foff_ability_id)
	end
end

GutterRunnerStatePinning.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local _csm = self._csm
	local _unit = self._unit
	local _locomotion_extension = self._locomotion_extension
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local target_unit = self.target_unit
	local target_status_extension = self.target_status_extension

	if not HEALTH_ALIVE[target_unit] then
		local _temp_params = self._temp_params

		_csm:change_state("standing", _temp_params)

		return
	end

	if not target_status_extension:is_knocked_down() then
		local _temp_params_2 = self._temp_params

		_csm:change_state("standing", _temp_params_2)

		return
	end

	local has_buff_type = self._buff_extension:has_buff_type("vs_gutter_runner_allow_dismount")

	if not CharacterStateHelper.is_viable_stab_target(_unit, target_unit, target_status_extension) and _input_extension:get("jump") or not _input_extension:get("action_two") or not has_buff_type then
		target_status_extension:set_pounced_down(false, _unit)

		local _temp_params_3 = self._temp_params

		_csm:change_state("standing", _temp_params_3)

		return
	end

	self:update_stabbing(arg_6_5, arg_6_3, _unit, target_unit)

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	self._locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, self._first_person_extension, _status_extension, self._inventory_extension)
end

GutterRunnerStatePinning.update_stabbing = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local num = 0.5

	if arg_7_1 > self._next_stab_time then
		local target_pounced = BreedActions.skaven_gutter_runner.target_pounced
		local num_2 = (arg_7_1 - self._blackboard.start_pouncing_time - self.breed.time_before_ramping_damage) / self.breed.time_to_reach_max_damage
		local clamp = math.clamp(num_2, 0, 1)
		local num_3 = self.breed.base_damage * (1 + clamp * self.breed.final_damage_multiplier)

		AiUtils.damage_target(arg_7_4, arg_7_3, target_pounced, num_3)

		self._next_stab_time = arg_7_1 + num
	end
end
