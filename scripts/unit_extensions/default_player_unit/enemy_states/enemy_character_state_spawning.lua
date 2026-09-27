-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_spawning.lua

EnemyCharacterStateSpawning = class(EnemyCharacterStateSpawning, EnemyCharacterState)

local tbl = {
	chimney = {
		"exit_teleporter_chimney",
		0,
		-0.5
	},
	window = {
		"exit_teleporter_window",
		-0.5,
		-0.5
	},
	well = {
		"exit_teleporter_well",
		0,
		-2.5
	},
	pipe = {
		"exit_teleporter_pipe_run",
		0,
		-0.5
	},
	manhole = {
		"exit_teleporter_manhole",
		0,
		-1.5
	}
}

EnemyCharacterStateSpawning.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterStateSpawning.super.init(arg_1_0, arg_1_1, "spawning")
end

EnemyCharacterStateSpawning.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local _input_extension = self._input_extension
	local _first_person_extension = self._first_person_extension
	local _status_extension = self._status_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension
	local _locomotion_extension = self._locomotion_extension
	local interactable_unit = self._interactor_extension:interactable_unit()
	local extension = ScriptUnit.extension(interactable_unit, "door_system")

	self.enter_unit = interactable_unit
	self.transition_manager = Managers.transition
	self.enter_pos = extension.enter_pos
	self.enter_rot = extension.enter_rot

	local unbox = Vector3Box.unbox(self.enter_rot)

	self.exit_rot = QuaternionBox(Quaternion.look(-unbox))
	self.wanted_rot = self.enter_rot

	local entrance_type = extension.entrance_type

	self._player = Managers.player:owner(arg_2_1)
	self.exit_anim = tbl[entrance_type][1]
	self.forward_offset = tbl[entrance_type][2]
	self.height_offset = tbl[entrance_type][3]
	self.fade_t = arg_2_5 + 0.5

	local num = 5

	self.transition_manager:fade_in(num)
	_locomotion_extension:enable_animation_driven_movement_with_rotation_no_mover()

	local flag = false
	local var_2_12
	local flag_2 = false

	if not _status_extension:get_unarmed() then
		flag_2 = true
	end

	_first_person_extension:set_first_person_mode(flag, var_2_12, flag_2)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, _input_extension, _inventory_extension, _health_extension)
	_status_extension:set_should_spawn(false)
	self:set_breed_action("spawning")
end

EnemyCharacterStateSpawning.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local var_3_0 = BLACKBOARDS[arg_3_1]
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _inventory_extension = self._inventory_extension

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)

	if not (not self.fade_t and not (arg_3_5 > self.fade_t)) then
		local unbox = QuaternionBox.unbox(self.exit_rot)

		self._first_person_extension:force_look_rotation(unbox)

		local forward = Quaternion.forward(unbox)

		self.wanted_rot = Vector3Box(forward)

		local num = forward * self.forward_offset + Vector3.up() * self.height_offset
		local num_2 = Unit.local_position(self.enter_unit, 0) + num
		local mover = Unit.mover(arg_3_1)

		Mover.set_position(mover, num_2)
		Unit.set_local_position(arg_3_1, 0, num_2)
		CharacterStateHelper.change_camera_state(self._player, "follow_third_person_tunneling")

		local exit_anim = self.exit_anim

		CharacterStateHelper.play_animation_event(arg_3_1, exit_anim)
		CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension, nil, Vector3(-2, 0, 0))

		local system = Managers.state.entity:system("camera_system")
		local num_3 = -forward + Vector3.up()
		local num_4 = Vector3Box.unbox(self.enter_pos) + num_3 * 2

		system:update_tunnel_camera_position(self._player, num_4)

		local extension = ScriptUnit.extension(arg_3_1, "ghost_mode_system")
		local flag = true

		extension:try_leave_ghost_mode(flag)

		local num_5 = 5

		self.transition_manager:fade_out(num_5)

		self.fade_t = nil
	end

	if not var_3_0.tunneling_finished then
		_first_person_extension:force_look_rotation(QuaternionBox.unbox(self.exit_rot), 0.1)
		self:start_camera_transition()
		self:to_movement_state()

		var_3_0.tunneling_finished = nil
	end

	Unit.set_local_rotation(arg_3_1, 0, Quaternion.look(Vector3Box.unbox(self.wanted_rot)))
end

EnemyCharacterStateSpawning.on_exit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	if not self._status_extension:get_unarmed() then
		CharacterStateHelper.play_animation_event(arg_4_1, "to_unarmed")
	end

	self:grant_control_to_player()
	self:set_breed_action("n/a")

	ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

EnemyCharacterStateSpawning.grant_control_to_player = function (self)
	-- function 5
	local _locomotion_extension = self._locomotion_extension
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(self._unit)

	_locomotion_extension:teleport_to(Matrix4x4.translation(animation_wanted_root_pose))
	_locomotion_extension:set_wanted_velocity(Vector3.zero())
	_locomotion_extension:enable_script_driven_movement()
	_locomotion_extension:set_animation_translation_scale(Vector3(1, 1, 1))
	_locomotion_extension:force_on_ground(true)
end

EnemyCharacterStateSpawning.start_camera_transition = function (self)
	-- function 6
	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.change_camera_state(self._player, "follow")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "idle")
	_first_person_extension:toggle_visibility(0.4)
end
