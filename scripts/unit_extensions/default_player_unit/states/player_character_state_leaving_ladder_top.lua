-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_leaving_ladder_top.lua

PlayerCharacterStateLeavingLadderTop = class(PlayerCharacterStateLeavingLadderTop, PlayerCharacterState)

PlayerCharacterStateLeavingLadderTop.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "leaving_ladder_top")

	local var_1_0 = arg_1_1

	self.is_server = Managers.player.is_server
	self.wanted_forward_bonus_velocity = Vector3Box()
end

PlayerCharacterStateLeavingLadderTop.on_enter_animation_event = function (self, arg_2_1)
	-- function 2
	local unit = self.unit

	CharacterStateHelper.play_animation_event_with_variable_float(unit, "climb_top_exit_ladder", "climb_enter_exit_speed", arg_2_1)
end

PlayerCharacterStateLeavingLadderTop.on_enter = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local unit = self.unit
	local input_extension = self.input_extension
	local first_person_extension = self.first_person_extension
	local ladder_unit = arg_3_7.ladder_unit

	self.ladder_unit = ladder_unit
	self.movement_speed = 1

	local leaving_ladder_top_animation_time = PlayerUnitMovementSettings.get_movement_settings_table(unit).ladder.leaving_ladder_top_animation_time

	self.finish_time = arg_3_5 + leaving_ladder_top_animation_time

	self.wanted_forward_bonus_velocity:store(Quaternion.forward(Unit.local_rotation(ladder_unit, 0)))
	self:on_enter_animation_event(2 / leaving_ladder_top_animation_time)

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:enable_script_driven_ladder_transition_movement()
	locomotion_extension:set_mover_filter_property("ladder", true)
end

PlayerCharacterStateLeavingLadderTop.on_exit = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	-- function 4
	local unit_game_object_id = Managers.state.network:unit_game_object_id(self.unit)
	local flag = false

	CharacterStateHelper.show_inventory_3p(arg_4_1, true, flag, self.is_server, self.inventory_extension)

	local first_person_extension = self.first_person_extension

	first_person_extension:unhide_weapons("climbing")
	first_person_extension:play_animation_event("idle")

	if not arg_4_6 and not Managers.state.network:game() then
		CharacterStateHelper.play_animation_event(arg_4_1, "climb_end_ladder")
		CharacterStateHelper.set_is_on_ladder(self.ladder_unit, arg_4_1, false, self.is_server, self.status_extension)
	end

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:enable_script_driven_movement()
	locomotion_extension:enable_rotation_towards_velocity(true)
	locomotion_extension:set_mover_filter_property("ladder", false)
end

PlayerCharacterStateLeavingLadderTop.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
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
	end

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local degrees_to_radians = math.degrees_to_radians(get_movement_settings_table.ladder.look_horizontal_max_degrees)
	local local_rotation = Unit.local_rotation(self.ladder_unit, 0)

	CharacterStateHelper.look_limited_rotation_freedom(input_extension, self.player.viewport_name, self.first_person_extension, unit, local_rotation, degrees_to_radians, nil, status_extension, self.inventory_extension)
end
