-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_in_hanging_cage.lua

PlayerCharacterStateInHangingCage = class(PlayerCharacterStateInHangingCage, PlayerCharacterState)

PlayerCharacterStateInHangingCage.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "in_hanging_cage")
end

PlayerCharacterStateInHangingCage.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "in_hanging_cage")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "in_hanging_cage")

	local cage_unit = arg_2_7.cage_unit

	self.cage_unit = cage_unit

	LocomotionUtils.enable_linked_movement(self.world, arg_2_1, cage_unit, 0, Vector3.zero())

	local flag = true

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self.is_server, self.inventory_extension)

	local animations = arg_2_7.animations
	local idle = animations.idle

	CharacterStateHelper.play_animation_event(arg_2_1, idle)

	self.falling_animation = animations.falling
	self.landing_animation = animations.landing
	self.state = "hanging"
end

PlayerCharacterStateInHangingCage.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self.status_extension:set_in_hanging_cage(false)
end

PlayerCharacterStateInHangingCage.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local status_extension = self.status_extension
	local state = self.state
	local in_hanging_cage_state = status_extension.in_hanging_cage_state
	local cage_unit = self.cage_unit
	local local_rotation = Unit.local_rotation(cage_unit, 0)

	Unit.set_local_rotation(arg_4_1, 0, local_rotation)

	if state ~= in_hanging_cage_state then
		if in_hanging_cage_state == "falling" then
			local falling_animation = self.falling_animation

			if not falling_animation then
				CharacterStateHelper.play_animation_event(arg_4_1, falling_animation)
			end
		elseif in_hanging_cage_state == "landed" then
			local landing_animation = self.landing_animation

			CharacterStateHelper.play_animation_event(arg_4_1, landing_animation)
			LocomotionUtils.disable_linked_movement(arg_4_1)

			local var_4_8 = POSITION_LOOKUP[arg_4_1]
			local locomotion_extension = self.locomotion_extension

			locomotion_extension:teleport_to(var_4_8)
			locomotion_extension:enable_script_driven_movement()
			self.health_extension:knock_down(arg_4_1)
			csm:change_state("knocked_down", {
				already_in_ko_anim = true
			})
		end

		self.state = in_hanging_cage_state
	end
end
