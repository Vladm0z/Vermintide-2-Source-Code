-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_leave_ledge_hanging_pull_up.lua

PlayerCharacterStateLeaveLedgeHangingPullUp = class(PlayerCharacterStateLeaveLedgeHangingPullUp, PlayerCharacterState)

PlayerCharacterStateLeaveLedgeHangingPullUp.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "leave_ledge_hanging_pull_up")

	local var_1_0 = arg_1_1

	self.is_server = Managers.player.is_server
	self.end_position = Vector3Box()
end

PlayerCharacterStateLeaveLedgeHangingPullUp.on_enter_animation_event = function (self)
	-- function 2
	local unit = self.unit

	CharacterStateHelper.play_animation_event(unit, "hanging_exit")
end

PlayerCharacterStateLeaveLedgeHangingPullUp.on_enter = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local unit = self.unit
	local input_extension = self.input_extension
	local first_person_extension = self.first_person_extension
	local ledge_unit = arg_3_7.ledge_unit

	self.start_rotation_box, self.ledge_unit = arg_3_7.start_rotation_box, ledge_unit

	self:calculate_end_position()
	self.locomotion_extension:enable_animation_driven_movement_with_rotation_no_mover()
	self:on_enter_animation_event()

	self.finish_time = arg_3_5 + PlayerUnitMovementSettings.get_movement_settings_table(unit).ledge_hanging.leaving_animation_time
end

PlayerCharacterStateLeaveLedgeHangingPullUp.on_exit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local status_extension = self.status_extension

	self.start_rotation_box = nil

	if not arg_4_6 then
		self.locomotion_extension:enable_script_driven_movement()
		self.locomotion_extension:set_forced_velocity(nil)
		self.locomotion_extension:set_wanted_velocity(Vector3:zero())
		self.locomotion_extension:teleport_to(self.end_position:unbox())
	end

	if not Managers.state.network:game() then
		StatusUtils.set_pulled_up_network(arg_4_1, false)
		CharacterStateHelper.set_is_on_ledge(self.ledge_unit, arg_4_1, false, self.is_server, self.status_extension)
	end

	CharacterStateHelper.change_camera_state(self.player, "follow")
	self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

	status_extension.start_climb_rotation = nil

	local flag = false

	CharacterStateHelper.show_inventory_3p(arg_4_1, true, flag, self.is_server, self.inventory_extension)
end

PlayerCharacterStateLeaveLedgeHangingPullUp.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension

	if not CharacterStateHelper.is_dead(status_extension) then
		csm:change_state("dead")

		return
	end

	if not CharacterStateHelper.is_knocked_down(status_extension) then
		csm:change_state("knocked_down")

		return
	end

	if not CharacterStateHelper.is_pounced_down(status_extension) then
		csm:change_state("pounced_down")

		return
	end

	local is_catapulted, var_5_6 = CharacterStateHelper.is_catapulted(status_extension)

	if not is_catapulted then
		local tbl = {
			sound_event = "Play_hit_by_ratogre",
			direction = var_5_6
		}

		csm:change_state("catapulted", tbl)

		return
	end

	if arg_5_5 > self.finish_time then
		csm:change_state("walking")

		return
	end

	if not status_extension.start_climb_rotation then
		local unbox = self.start_rotation_box:unbox()
		local local_rotation = Unit.local_rotation(unit, 0)
		local lerp = Quaternion.lerp(local_rotation, unbox, math.min(arg_5_3 * 2, 1))

		Unit.set_local_rotation(unit, 0, lerp)
	end

	self.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end

PlayerCharacterStateLeaveLedgeHangingPullUp.calculate_end_position = function (self)
	-- function 6
	local unit = self.unit
	local ledge_unit = self.ledge_unit
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local node = Unit.node(ledge_unit, "g_gameplay_ledge_finger_box")
	local world_position = Unit.world_position(ledge_unit, node)
	local world_rotation = Unit.world_rotation(ledge_unit, node)
	local local_position = Unit.local_position(unit, 0)
	local right = Quaternion.right(world_rotation)
	local num = local_position - world_position
	local dot = Vector3.dot(right, num)
	local node_2 = Unit.node(ledge_unit, "g_gameplay_ledge_respawn_box")
	local world_position_2 = Unit.world_position(ledge_unit, node_2)
	local world_rotation_2 = Unit.world_rotation(ledge_unit, node_2)
	local num_2 = world_position_2 + Quaternion.right(world_rotation_2) * dot
	local get_hang_ledge_spawn_position = ScriptUnit.extension(unit, "whereabouts_system"):get_hang_ledge_spawn_position()
	local flag = Vector3.distance(num_2, get_hang_ledge_spawn_position) < 4

	if not get_hang_ledge_spawn_position and not flag then
		num_2 = get_hang_ledge_spawn_position
	end

	self.end_position:store(num_2)
end
