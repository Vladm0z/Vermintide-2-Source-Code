-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_leave_ledge_hanging_falling.lua

PlayerCharacterStateLeaveLedgeHangingFalling = class(PlayerCharacterStateLeaveLedgeHangingFalling, PlayerCharacterState)

PlayerCharacterStateLeaveLedgeHangingFalling.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "leave_ledge_hanging_falling")

	local var_1_0 = arg_1_1

	self.is_server = Managers.player.is_server
end

PlayerCharacterStateLeaveLedgeHangingFalling.on_enter_animation = function (self)
	-- function 2
	CharacterStateHelper.play_animation_event(self.unit, "jump_idle")
end

PlayerCharacterStateLeaveLedgeHangingFalling.on_enter = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local unit = self.unit
	local ledge_unit = arg_3_7.ledge_unit

	self.ledge_unit = ledge_unit

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)

	self.finish_time = arg_3_5 + get_movement_settings_table.ledge_hanging.falling_kill_timer

	local node = Unit.node(ledge_unit, "g_gameplay_ledge_finger_box")
	local world_rotation = Unit.world_rotation(ledge_unit, node)
	local forward = Quaternion.forward(world_rotation)
	local num = Unit.local_position(unit, 0) - forward * get_movement_settings_table.ledge_hanging.leaving_falling_forward_push_constant

	self.locomotion_extension:enable_script_driven_movement()
	self.locomotion_extension:teleport_to(num)
	self:on_enter_animation()
end

PlayerCharacterStateLeaveLedgeHangingFalling.on_exit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	if not arg_4_6 and arg_4_6 == "falling" or not Managers.state.network:game() then
		CharacterStateHelper.play_animation_event(arg_4_1, "land_still")
		CharacterStateHelper.play_animation_event(arg_4_1, "to_onground")
	end
end

PlayerCharacterStateLeaveLedgeHangingFalling.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)

	if not CharacterStateHelper.is_dead(status_extension) then
		csm:change_state("dead")

		return
	end

	if not CharacterStateHelper.is_pounced_down(status_extension) then
		csm:change_state("pounced_down")

		return
	end

	local is_catapulted, var_5_7 = CharacterStateHelper.is_catapulted(status_extension)

	if not is_catapulted then
		local tbl = {
			sound_event = "Play_hit_by_ratogre",
			direction = var_5_7
		}

		csm:change_state("catapulted", tbl)

		return
	end

	if arg_5_5 >= self.finish_time then
		if not script_data.ledge_hanging_fall_and_die_turned_off then
			csm:change_state("falling")
		else
			local go_id = self.unit_storage:go_id(unit)

			if self.is_server or not LEVEL_EDITOR_TEST then
				Managers.state.entity:system("health_system"):suicide(unit)
				csm:change_state("dead")
			else
				self.network_transmit:send_rpc_server("rpc_suicide", go_id)
			end
		end

		return
	end

	if not self.locomotion_extension:is_colliding_down() then
		csm:change_state("walking")

		return
	end

	self.locomotion_extension:set_forced_velocity(Vector3(0, 0, -3))
	self.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end
