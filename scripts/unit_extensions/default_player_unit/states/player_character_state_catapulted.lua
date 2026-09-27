-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_catapulted.lua

require("scripts/settings/player_movement_settings")

PlayerCharacterStateCatapulted = class(PlayerCharacterStateCatapulted, PlayerCharacterState)

local POSITION_LOOKUP = POSITION_LOOKUP
local directions = PlayerUnitMovementSettings.catapulted.directions

PlayerCharacterStateCatapulted.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "catapulted")
end

PlayerCharacterStateCatapulted.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "stunned")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "stunned")

	local direction = arg_2_7.direction

	if arg_2_6 == "grabbed_by_chaos_spawn" then
		direction = "forward_thrown"
	end

	local unbox = self.status_extension.catapulted_velocity:unbox()
	local locomotion_extension = self.locomotion_extension

	locomotion_extension:set_maximum_upwards_velocity(unbox.z)
	locomotion_extension:set_forced_velocity(unbox)
	locomotion_extension:set_wanted_velocity(unbox)

	self._direction = direction

	local start_animation = directions[direction].start_animation
	local start_animation_1p = directions[direction].start_animation_1p

	CharacterStateHelper.play_animation_event(arg_2_1, start_animation)
	CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, start_animation_1p or start_animation)

	local first_person_extension = self.first_person_extension

	first_person_extension:hide_weapons("catapulted")

	local flag = false

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self.is_server, self.inventory_extension)

	local sound_event = arg_2_7.sound_event

	if not sound_event then
		first_person_extension:play_hud_sound_event(sound_event)
	end

	self.start_catapulted_height = POSITION_LOOKUP[arg_2_1].z
end

PlayerCharacterStateCatapulted.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self._direction = nil

	self.status_extension:set_catapulted(false)
	self.first_person_extension:unhide_weapons("catapulted")
	self.locomotion_extension:reset_maximum_upwards_velocity()

	if not Managers.state.network:game() then
		local flag = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self.is_server, self.inventory_extension)
		CharacterStateHelper.play_animation_event(arg_3_1, "airtime_end")
	end

	self.status_extension:set_falling_height(nil, self.start_catapulted_height)
end

PlayerCharacterStateCatapulted.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local unit = self.unit
	local world = self.world
	local input_extension = self.input_extension
	local status_extension = self.status_extension

	if POSITION_LOOKUP[unit].z < -240 then
		print("Player has fallen outside the world -- kill meeeee ", POSITION_LOOKUP[unit].z)

		if not self.is_server then
			Managers.state.entity:system("health_system"):suicide(unit)
		else
			local go_id = self.unit_storage:go_id(unit)

			self.network_transmit:send_rpc_server("rpc_suicide", go_id)
		end
	end

	if not CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if not CharacterStateHelper.is_dead(status_extension) then
		csm:change_state("dead")

		return
	end

	if not CharacterStateHelper.is_pounced_down(status_extension) then
		csm:change_state("pounced_down")

		return
	end

	if not CharacterStateHelper.is_in_vortex(status_extension) then
		csm:change_state("in_vortex")

		return
	end

	if not CharacterStateHelper.is_block_broken(status_extension) then
		status_extension:set_block_broken(false)
	end

	if not (not CharacterStateHelper.is_colliding_down(unit) and not (self.locomotion_extension:current_velocity().z < 0)) then
		local land_animation = directions[self._direction].land_animation

		CharacterStateHelper.play_animation_event(unit, land_animation)

		if not CharacterStateHelper.has_move_input(input_extension) then
			csm:change_state("walking")
		else
			csm:change_state("standing")
		end

		return
	end

	if not (not CharacterStateHelper.is_colliding_down(unit) and not self.locomotion_extension:is_on_ground() and not (self.locomotion_extension:current_velocity().z >= 0)) then
		local land_animation_2 = directions[self._direction].land_animation

		CharacterStateHelper.play_animation_event(unit, land_animation_2)

		if not CharacterStateHelper.has_move_input(input_extension) then
			csm:change_state("walking")
		else
			csm:change_state("standing")
		end

		self.locomotion_extension:add_external_velocity(self.locomotion_extension:current_velocity() * 0.2)

		return
	end

	if not CharacterStateHelper.is_colliding_sides(unit) then
		local wall_collide_animation = directions[self._direction].wall_collide_animation

		CharacterStateHelper.play_animation_event(unit, wall_collide_animation)
		csm:change_state("standing")

		return
	end

	local first_person_extension = self.first_person_extension

	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, self.inventory_extension)
end
