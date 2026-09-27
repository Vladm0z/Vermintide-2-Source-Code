-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_tunneling.lua

EnemyCharacterStateTunneling = class(EnemyCharacterStateTunneling, EnemyCharacterState)

local tbl = {
	chimney = {
		"enter_teleporter_1m",
		false
	},
	window = {
		"enter_teleporter_1m",
		true
	},
	well = {
		"enter_teleporter_1m",
		false
	},
	pipe = {
		"enter_teleporter_1m",
		true
	},
	manhole = {
		"enter_teleporter_1m",
		false
	}
}
local tbl_2 = {
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

EnemyCharacterStateTunneling.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterStateTunneling.super.init(arg_1_0, arg_1_1, "tunneling")
end

EnemyCharacterStateTunneling.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local _input_extension = self._input_extension
	local _first_person_extension = self._first_person_extension
	local _status_extension = self._status_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension
	local _locomotion_extension = self._locomotion_extension
	local _interactor_extension = self._interactor_extension

	self.pactsworn_video_transition_view = Managers.state.game_mode:game_mode().pactsworn_video_transition_view
	self.transition_manager = Managers.transition

	local interactable_unit = _interactor_extension:interactable_unit()
	local extension = ScriptUnit.extension(interactable_unit, "door_system")
	local partner_unit = extension.partner_unit

	self.id = extension.id

	assert(partner_unit, "Crawl Space is missing a partner unit. Either it has no partner, or the id is wrong.")

	local extension_2 = ScriptUnit.extension(partner_unit, "door_system")

	self.exit_unit = partner_unit
	self.enter_pos = extension.enter_pos

	local enter_rot = extension.enter_rot

	self.enter_rot = enter_rot

	local num = -Vector3Box.unbox(extension_2.enter_rot)

	self.exit_rot = QuaternionBox(Quaternion.look(num))
	self.wanted_rot = self.enter_rot

	local entrance_type = extension.entrance_type
	local entrance_type_2 = extension_2.entrance_type

	self._player = Managers.player:owner(arg_2_1)
	self.exit_anim = tbl_2[entrance_type_2][1]
	self.forward_offset = tbl_2[entrance_type_2][2]
	self.height_offset = tbl_2[entrance_type_2][3]

	local var_2_15 = tbl[entrance_type][2]
	local var_2_16

	if not var_2_15 then
		var_2_16 = self.enter_pos:unbox()
	else
		local num_2 = Unit.local_position(interactable_unit, 0) + Vector3.normalize(enter_rot:unbox()) * 0.5
		local z = self.enter_pos.z
		local flag

		flag = entrance_type ~= "manhole" or not 1 or 0
		num_2.z = z + flag

		local num_3 = POSITION_LOOKUP[arg_2_1] - num_2

		num_3.z = 0

		local num_4 = 1.5

		var_2_16 = num_2 + Vector3.normalize(num_3) * num_4
		self.wanted_rot = Vector3Box(-num_3)
	end

	self.alignment_vector = Vector3Box(var_2_16 - POSITION_LOOKUP[arg_2_1])
	self.alignment_total_t = 0.25
	self.alignment_time_t = self.alignment_total_t

	_locomotion_extension:enable_animation_driven_movement_with_rotation_no_mover()

	local var_2_22 = tbl[entrance_type][1]

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_22)
	CharacterStateHelper.change_camera_state(self._player, "follow_third_person_tunneling")

	local flag_2 = false
	local var_2_24
	local flag_3 = false

	if not _status_extension:get_unarmed() then
		flag_3 = true
	end

	_first_person_extension:set_first_person_mode(flag_2, var_2_24, flag_3)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, _input_extension, _inventory_extension, _health_extension)
	_status_extension:set_should_tunnel(false)
	self:set_breed_action("tunneling")

	self.state = "init"
end

EnemyCharacterStateTunneling.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local var_3_0 = BLACKBOARDS[arg_3_1]
	local _csm = self._csm
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _inventory_extension = self._inventory_extension

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension)

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if self.alignment_time_t > 0 then
		local num = Vector3Box.unbox(self.alignment_vector) * arg_3_3 / self.alignment_total_t
		local var_3_8 = POSITION_LOOKUP[arg_3_1]
		local mover = Unit.mover(arg_3_1)

		Mover.set_position(mover, var_3_8 + num)
		Unit.set_local_position(arg_3_1, 0, var_3_8 + num)

		self.alignment_time_t = self.alignment_time_t - arg_3_3
	end

	if self.state ~= "init" or not var_3_0.tunneling_begin then
		self.fade_t = arg_3_5 + 0.5

		local num_2 = 5

		self.transition_manager:fade_in(num_2)

		self.state = "fade_in"
	end

	if not (self.state ~= "fade_in" or not (arg_3_5 > self.fade_t)) then
		local unbox = QuaternionBox.unbox(self.exit_rot)

		self._first_person_extension:force_look_rotation(unbox)

		local forward = Quaternion.forward(unbox)

		self.wanted_rot = Vector3Box(forward)

		local num_3 = forward * self.forward_offset + Vector3.up() * self.height_offset
		local num_4 = Unit.local_position(self.exit_unit, 0) + num_3
		local mover_2 = Unit.mover(arg_3_1)

		Mover.set_position(mover_2, num_4)
		Unit.set_local_position(arg_3_1, 0, num_4)
		_status_extension:set_invisible(true, nil, "tunneling")
		_locomotion_extension:set_mover_filter_property("dark_pact_noclip", true)

		self.state = "transition_video"
		self.sub_state = "start_video"
	end

	if self.state == "transition_video" then
		if self.sub_state == "start_video" then
			local num_5 = 5
			local num_6 = self.id % 4 + 1

			self.transition_manager:fade_out(num_5)
			self.pactsworn_video_transition_view:play_video(num_6)
			self.pactsworn_video_transition_view:enable_video(true)

			self.sub_state = "playing_video"
			self.end_video_t = arg_3_5 + 3
		elseif self.sub_state == "playing_video" then
			if self.end_video_t - arg_3_5 < 0.25 then
				local num_7 = 10

				self.transition_manager:fade_in(num_7)

				self.sub_state = "end_video"
			end
		elseif not (self.sub_state ~= "end_video" or not (arg_3_5 > self.end_video_t)) then
			self.fade_t = arg_3_5 + 0.25

			local num_8 = 5

			self.transition_manager:fade_out(num_8)
			self.pactsworn_video_transition_view:enable_video(false)

			local system = Managers.state.entity:system("camera_system")
			local unbox_2 = QuaternionBox.unbox(self.exit_rot)
			local num_9 = Quaternion.forward(unbox_2) + Quaternion.right(unbox_2) + Vector3.up() * 0.5
			local num_10 = Unit.local_position(self.exit_unit, 0) + num_9 * 2

			system:update_tunnel_camera_position(self._player, num_10)

			local exit_anim = self.exit_anim

			CharacterStateHelper.play_animation_event(arg_3_1, exit_anim)
			CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension, nil, Vector3(-2, 0, 0))

			self.end_video_t = nil
			self.state = "fade_out"
		end
	end

	if not (self.state ~= "fade_out" or not (arg_3_5 > self.fade_t)) then
		_status_extension:set_invisible(false, nil, "tunneling")

		self.state = "end"
	end

	if self.state ~= "end" or not var_3_0.tunneling_finished then
		_locomotion_extension:set_mover_filter_property("dark_pact_noclip", false)
		_first_person_extension:force_look_rotation(QuaternionBox.unbox(self.exit_rot), 0.1)
		self:start_camera_transition()
		self:to_movement_state()
	end

	local unbox_3 = self.wanted_rot:unbox()

	Unit.set_local_rotation(arg_3_1, 0, Quaternion.look(unbox_3))
end

EnemyCharacterStateTunneling.on_exit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local var_4_0 = BLACKBOARDS[arg_4_1]

	if not var_4_0 then
		var_4_0.tunneling_begin = nil
		var_4_0.tunneling_finished = nil
	end

	if not self._status_extension:get_unarmed() then
		CharacterStateHelper.play_animation_event(arg_4_1, "to_unarmed")
	end

	self:grant_control_to_player()
	self:set_breed_action("n/a")

	ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

EnemyCharacterStateTunneling.grant_control_to_player = function (self)
	-- function 5
	local _locomotion_extension = self._locomotion_extension
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(self._unit)

	_locomotion_extension:teleport_to(Matrix4x4.translation(animation_wanted_root_pose))
	_locomotion_extension:set_wanted_velocity(Vector3.zero())
	_locomotion_extension:enable_script_driven_movement()
	_locomotion_extension:set_animation_translation_scale(Vector3(1, 1, 1))
	_locomotion_extension:force_on_ground(true)
end

EnemyCharacterStateTunneling.start_camera_transition = function (self)
	-- function 6
	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.change_camera_state(self._player, "follow")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "idle")
	_first_person_extension:toggle_visibility(0.4)
end
