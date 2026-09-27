-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_animated_jump.lua

EnemyCharacterStateAnimatedJump = class(EnemyCharacterStateAnimatedJump, EnemyCharacterState)

EnemyCharacterStateAnimatedJump.do_the_transition = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	return
end

EnemyCharacterStateAnimatedJump.setup_transition = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	return
end

EnemyCharacterStateAnimatedJump.init = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	EnemyCharacterStateAnimatedJump.super.init(arg_3_0, arg_3_1, arg_3_2)
end

EnemyCharacterStateAnimatedJump.on_enter = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	-- function 4
	local _input_extension = self._input_extension
	local _first_person_extension = self._first_person_extension
	local _status_extension = self._status_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension
	local _locomotion_extension = self._locomotion_extension
	local _breed = self._breed

	Managers.telemetry_events:node_climb(_breed.name, POSITION_LOOKUP[arg_4_1])

	local flag = self._breed.climb_type == "climb"

	self.is_climber = flag
	self._camera_transitioned_back = nil
	self._control_back = nil

	local owner = Managers.player:owner(arg_4_1)

	self._player = owner

	if not _status_extension:get_unarmed() then
		CharacterStateHelper.play_animation_event(arg_4_1, "to_armed")
	end

	CharacterStateHelper.play_animation_event(arg_4_1, "climbing")
	CharacterStateHelper.change_camera_state(owner, "follow_third_person_smart_climbing")

	local flag_2 = false
	local var_4_10
	local flag_3 = false

	if not _status_extension:get_unarmed() then
		flag_3 = true
	end

	_first_person_extension:set_first_person_mode(flag_2, var_4_10, flag_3)

	local jump_data = arg_4_7.jump_data

	if not jump_data then
		error("Missing jump_data")
	end

	_status_extension:set_should_climb(false)
	_status_extension:set_is_climbing(true)

	local swap_entrance_exit = jump_data.swap_entrance_exit
	local jump_object_data = jump_data.jump_object_data
	local var_4_15
	local var_4_16

	if not swap_entrance_exit then
		var_4_15 = Vector3Aux.unbox(jump_object_data.pos1)
		var_4_16 = Vector3Aux.unbox(jump_object_data.pos2)
	else
		var_4_15 = Vector3Aux.unbox(jump_object_data.pos2)
		var_4_16 = Vector3Aux.unbox(jump_object_data.pos1)
	end

	if not flag then
		local normalize = Vector3.normalize(Vector3.flat(var_4_16 - var_4_15))
		local look = Quaternion.look(normalize)

		_locomotion_extension:teleport_to(var_4_16, look)
	elseif not flag then
		local data = jump_object_data.data

		self:setup_transition(arg_4_1, data, var_4_15, var_4_16)

		self._fail_timer = arg_4_5 + 7

		local get_move_animation, var_4_21 = CharacterStateHelper.get_move_animation(self._locomotion_extension, _input_extension, _status_extension)

		self.move_anim_3p = get_move_animation
		self.move_anim_1p = var_4_21

		CharacterStateHelper.play_animation_event(arg_4_1, get_move_animation)
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, var_4_21)

		local var_4_22 = BLACKBOARDS[arg_4_1]

		var_4_22.jump_start_finished = nil
		var_4_22.jump_climb_finished = nil
	end

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_4_5, arg_4_1, _input_extension, _inventory_extension, _health_extension)
	self:set_breed_action("climbing")
end

EnemyCharacterStateAnimatedJump.on_exit = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	local var_5_0 = BLACKBOARDS[arg_5_1]

	if not var_5_0 then
		var_5_0.jump_climb_finished = nil
		var_5_0.jump_camera_transition = nil
		var_5_0.jump_give_control = nil
	end

	local _status_extension = self._status_extension

	_status_extension:set_is_climbing(false)

	if not _status_extension:get_unarmed() then
		CharacterStateHelper.play_animation_event(arg_5_1, "to_unarmed")
	end

	if not self._camera_transitioned_back then
		self:start_camera_transition()
	end

	if not self._control_back then
		self:grant_control_to_player()
	end

	self:set_breed_action("n/a")

	ScriptUnit.extension(arg_5_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

EnemyCharacterStateAnimatedJump.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local _csm = self._csm
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _inventory_extension = self._inventory_extension
	local CharacterStateHelper = CharacterStateHelper

	if not _locomotion_extension:is_on_ground() then
		ScriptUnit.extension(arg_6_1, "whereabouts_system"):set_is_onground()
	end

	local _health_extension = self._health_extension

	CharacterStateHelper.update_weapon_actions(arg_6_5, arg_6_1, _input_extension, _inventory_extension, _health_extension)

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return
	end

	if not self.is_climber then
		self:to_movement_state()

		return
	end

	local var_6_8 = BLACKBOARDS[arg_6_1]

	if not (not var_6_8.jump_camera_transition and self._camera_transitioned_back) then
		self:start_camera_transition()
	end

	if not self:do_the_transition(arg_6_1, arg_6_5, arg_6_3, _locomotion_extension) then
		self:to_movement_state()
	elseif not var_6_8.jump_give_control and self._control_back or not self:has_movement_input() then
		self:to_movement_state()
	end

	if not _locomotion_extension:is_animation_driven() then
		return
	end

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)
end

EnemyCharacterStateAnimatedJump.grant_control_to_player = function (self)
	-- function 7
	local _locomotion_extension = self._locomotion_extension
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(self._unit)

	_locomotion_extension:teleport_to(Matrix4x4.translation(animation_wanted_root_pose))
	_locomotion_extension:set_wanted_velocity(Vector3.zero())
	_locomotion_extension:enable_script_driven_movement()
	_locomotion_extension:set_animation_translation_scale(Vector3(1, 1, 1))
	_locomotion_extension:force_on_ground(true)

	self._control_back = true
end

EnemyCharacterStateAnimatedJump.start_camera_transition = function (self)
	-- function 8
	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.change_camera_state(self._player, "follow")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "idle")
	_first_person_extension:toggle_visibility(0.4)

	self._camera_transitioned_back = true
end
