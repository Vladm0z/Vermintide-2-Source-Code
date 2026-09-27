-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_corruptor.lua

PlayerCharacterStateGrabbedByCorruptor = class(PlayerCharacterStateGrabbedByCorruptor, PlayerCharacterState)

local POSITION_LOOKUP = POSITION_LOOKUP

PlayerCharacterStateGrabbedByCorruptor.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "grabbed_by_corruptor")

	self.next_hanging_damage_time = 0
end

PlayerCharacterStateGrabbedByCorruptor.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local inventory_extension = self.inventory_extension
	local career_extension = self.career_extension

	CharacterStateHelper.stop_weapon_actions(inventory_extension, "grabbed")
	CharacterStateHelper.stop_career_abilities(career_extension, "grabbed")
	inventory_extension:check_and_drop_pickups("grabbed_by_corruptor")
	CharacterStateHelper.play_animation_event(arg_2_1, "to_corruptor")
	CharacterStateHelper.change_camera_state(self.player, "follow_third_person")

	local first_person_extension = self.first_person_extension

	first_person_extension:set_first_person_mode(false)

	if self.ai_extension == nil then
		local wwise_world = Managers.world:wwise_world(self.world)
		local trigger_event, var_2_5 = WwiseWorld.trigger_event(wwise_world, "start_strangled_state", first_person_extension:get_first_person_unit())

		self.grabbed_by_corruptor_start_sound_event = "chaos_corruptor_corrupting"
		self.grabbed_by_corruptor_stop_sound_event = "chaos_corruptor_corrupting_stop"

		WwiseUtils.trigger_unit_event(self.world, self.grabbed_by_corruptor_start_sound_event, arg_2_1, 0)
	end

	local status_extension = self.status_extension

	self.corruptor_status = CharacterStateHelper.corruptor_status(status_extension)

	local states = PlayerCharacterStateGrabbedByCorruptor.states

	if not states[self.corruptor_status].enter then
		states[self.corruptor_status].enter(self, arg_2_1)
	end

	ScriptUnit.extension(arg_2_1, "locomotion_system"):enable_rotation_towards_velocity(false)
	CharacterStateHelper.show_inventory_3p(arg_2_1, false, true, Managers.player.is_server, self.inventory_extension)
end

PlayerCharacterStateGrabbedByCorruptor.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local first_person_extension = self.first_person_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension

	if not (status_extension:is_knocked_down() or status_extension:is_dead()) then
		CharacterStateHelper.change_camera_state(self.player, "follow")
		first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
		locomotion_extension:enable_script_driven_movement()
	end

	locomotion_extension:enable_rotation_towards_velocity(true)

	if self.ai_extension == nil then
		local wwise_world = Managers.world:wwise_world(self.world)
		local trigger_event, var_3_5 = WwiseWorld.trigger_event(wwise_world, "stop_strangled_state", first_person_extension:get_first_person_unit())

		WwiseUtils.trigger_unit_event(self.world, self.grabbed_by_corruptor_stop_sound_event, arg_3_1, 0)
	end

	local inventory_extension = self.inventory_extension

	if not inventory_extension then
		if inventory_extension:get_wielded_slot_name() == "slot_career_skill_weapon" then
			inventory_extension:wield_previous_weapon()
		else
			inventory_extension:rewield_wielded_slot()
		end
	end
end

PlayerCharacterStateGrabbedByCorruptor.states = {
	chaos_corruptor_grabbed = {
		enter = function (self, arg_4_1)
			-- function 4
			local extension = ScriptUnit.extension(arg_4_1, "locomotion_system")
			local corruptor_unit = self.status_extension.corruptor_unit

			if not Unit.alive(corruptor_unit) then
				local var_4_2 = POSITION_LOOKUP[corruptor_unit]
				local var_4_3 = POSITION_LOOKUP[arg_4_1]
				local normalize = Vector3.normalize(var_4_2 - var_4_3)

				extension:set_wanted_velocity(Vector3.zero())
				Unit.set_local_rotation(arg_4_1, 0, Quaternion.look(normalize))
				extension:enable_rotation_towards_velocity(true, Quaternion.look(normalize), 1)
			end
		end,
		run = function (self, arg_5_1)
			-- function 5
			local corruptor_unit = self.status_extension.corruptor_unit

			if not Unit.alive(corruptor_unit) then
				local extension = ScriptUnit.extension(arg_5_1, "locomotion_system")
				local var_5_2 = POSITION_LOOKUP[corruptor_unit]
				local var_5_3 = POSITION_LOOKUP[arg_5_1]
				local distance = Vector3.distance(var_5_2, var_5_3)
				local num = var_5_2 - var_5_3
				local num_2 = Vector3.normalize(num) * 2

				extension:set_maximum_upwards_velocity(num_2.z)
				extension:set_forced_velocity(num_2)
			end
		end
	},
	chaos_corruptor_dragging = {
		enter = function (arg_6_0, arg_6_1)
			-- function 6
			return
		end,
		run = function (self, arg_7_1)
			-- function 7
			local corruptor_unit = self.status_extension.corruptor_unit

			if not Unit.alive(corruptor_unit) then
				local extension = ScriptUnit.extension(arg_7_1, "locomotion_system")

				extension:set_disable_rotation_update()

				local var_7_2 = POSITION_LOOKUP[corruptor_unit]
				local var_7_3 = POSITION_LOOKUP[arg_7_1]
				local distance = Vector3.distance(var_7_2, var_7_3)
				local num = Vector3.normalize(var_7_2 - var_7_3) * 4

				if distance > 1.5 then
					extension:set_forced_velocity(num)
				else
					extension:set_wanted_velocity(Vector3.zero())
				end
			end

			return true
		end
	},
	chaos_corruptor_released = {
		run = function (arg_8_0, arg_8_1)
			-- function 8
			return
		end,
		enter = function (self, arg_9_1)
			-- function 9
			self.locomotion_extension:enable_script_driven_movement()

			local status_extension = self.status_extension
			local csm = self.csm
			local status_extension_2 = self.status_extension

			if not CharacterStateHelper.is_dead(status_extension_2) then
				csm:change_state("dead")
			elseif not CharacterStateHelper.is_knocked_down(status_extension_2) then
				local inventory_extension = self.inventory_extension

				if not (not inventory_extension and inventory_extension:get_wielded_slot_name() ~= "slot_career_skill_weapon") then
					inventory_extension:wield_previous_weapon()
				else
					inventory_extension:rewield_wielded_slot()
				end

				csm:change_state("knocked_down", self.temp_params)
			else
				local inventory_extension_2 = self.inventory_extension

				if not (not inventory_extension_2 and inventory_extension_2:get_wielded_slot_name() ~= "slot_career_skill_weapon") then
					inventory_extension_2:wield_previous_weapon()
				else
					inventory_extension_2:rewield_wielded_slot()
				end

				csm:change_state("standing")
			end

			CharacterStateHelper.show_inventory_3p(arg_9_1, true, true, Managers.player.is_server, self.inventory_extension)
		end
	}
}

PlayerCharacterStateGrabbedByCorruptor.update = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local corruptor_status = CharacterStateHelper.corruptor_status(self.status_extension)
	local states = PlayerCharacterStateGrabbedByCorruptor.states
	local corruptor_status_2 = self.corruptor_status

	if corruptor_status ~= corruptor_status_2 then
		if not states[corruptor_status_2].leave then
			states[corruptor_status_2].leave(self, unit)
		end

		if not states[corruptor_status].enter then
			states[corruptor_status].enter(self, unit)
		end

		self.corruptor_status = corruptor_status
	end

	if not states[corruptor_status].run(self, unit) then
		return
	end

	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end
