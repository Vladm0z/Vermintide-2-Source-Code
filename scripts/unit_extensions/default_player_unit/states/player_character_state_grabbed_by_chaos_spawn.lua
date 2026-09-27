-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_chaos_spawn.lua

PlayerCharacterStateGrabbedByChaosSpawn = class(PlayerCharacterStateGrabbedByChaosSpawn, PlayerCharacterState)

local POSITION_LOOKUP = POSITION_LOOKUP
local play_animation_event = CharacterStateHelper.play_animation_event

PlayerCharacterStateGrabbedByChaosSpawn.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "grabbed_by_chaos_spawn")
end

PlayerCharacterStateGrabbedByChaosSpawn.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	local inventory_extension = self.inventory_extension
	local career_extension = self.career_extension

	CharacterStateHelper.stop_weapon_actions(inventory_extension, "grabbed")
	CharacterStateHelper.stop_career_abilities(career_extension, "grabbed")
	inventory_extension:check_and_drop_pickups("grabbed_by_chaos_spawn")
	self.first_person_extension:set_first_person_mode(false)

	local status_extension = self.status_extension
	local grabbed_by_chaos_spawn_unit = status_extension.grabbed_by_chaos_spawn_unit

	self.chaos_spawn_unit = grabbed_by_chaos_spawn_unit
	self.breed = Unit.get_data(grabbed_by_chaos_spawn_unit, "breed")

	local player = self.player

	player = not player and self.player.bot_player
	self.is_bot = player

	CharacterStateHelper.change_camera_state(self.player, "chaos_spawn_grabbed")
	self.inventory_extension:show_third_person_inventory(false)

	self.camera_state = "third_person"

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:enable_script_driven_no_mover_movement()
	locomotion_extension:enable_rotation_towards_velocity(false)

	local grabbed_by_chaos_spawn_status, var_2_7 = CharacterStateHelper.grabbed_by_chaos_spawn_status(status_extension)
	local states = PlayerCharacterStateGrabbedByChaosSpawn.states

	if not states[grabbed_by_chaos_spawn_status].enter then
		states[grabbed_by_chaos_spawn_status].enter(self, arg_2_1, arg_2_5)
	end

	self.grabbed_by_chaos_spawn_status = grabbed_by_chaos_spawn_status
	self.status_count = var_2_7

	LocomotionUtils.enable_linked_movement(self.world, arg_2_1, self.chaos_spawn_unit, 0, Vector3.zero())

	local flag = self.camera_state ~= "first_person" or false

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self.is_server, self.inventory_extension)

	self.grabbed_screen_space_particle_1 = self.first_person_extension:create_screen_particles("fx/screenspace_chaos_spawn_tentacles_02")

	if not self.is_bot then
		Wwise.set_state("spawn_catch_player", "true")
	end
end

PlayerCharacterStateGrabbedByChaosSpawn.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local status_extension = self.status_extension
	local var_3_1 = ALIVE[self.chaos_spawn_unit]
	local var_3_2

	if not var_3_1 and not status_extension:is_catapulted() then
		local node = Unit.node(arg_3_1, "j_leftfoot")
		local node_2 = Unit.node(arg_3_1, "j_rightfoot")

		var_3_2 = (Unit.world_position(arg_3_1, node) + Unit.world_position(arg_3_1, node_2)) / 2
	else
		var_3_2 = Unit.world_position(arg_3_1, Unit.node(arg_3_1, "root_point"))
	end

	LocomotionUtils.disable_linked_movement(arg_3_1)

	local locomotion_extension = self.locomotion_extension
	local current_rotation = locomotion_extension:current_rotation()

	locomotion_extension:teleport_to(var_3_2, current_rotation)

	if not self.is_server and not var_3_1 then
		StatusUtils.set_grabbed_by_chaos_spawn_network(arg_3_1, false, self.chaos_spawn_unit)
	else
		status_extension:set_grabbed_by_chaos_spawn(false)
	end

	local flag = self.camera_state ~= "first_person" or false

	CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self.is_server, self.inventory_extension)
	CharacterStateHelper.change_camera_state(self.player, "follow")
	self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

	local player = self.player

	Managers.state.entity:system("camera_system"):set_follow_unit(player)

	self.camera_state = nil
	self.grabbed_by_chaos_spawn_status = nil
	self.status_count = nil

	local inventory_extension = self.inventory_extension

	if not (not inventory_extension and inventory_extension:get_wielded_slot_name() ~= "slot_career_skill_weapon") then
		inventory_extension:wield_previous_weapon()
	else
		inventory_extension:rewield_wielded_slot()
	end

	locomotion_extension:reset_maximum_upwards_velocity()
	locomotion_extension:enable_script_driven_movement()
	locomotion_extension:enable_rotation_towards_velocity(true)

	if not self.is_bot then
		Wwise.set_state("spawn_catch_player", "false")
	end
end

PlayerCharacterStateGrabbedByChaosSpawn.states = {
	grabbed = {
		enter = function (arg_4_0, arg_4_1, arg_4_2)
			-- function 4
			play_animation_event(arg_4_1, "attack_grab_player")
		end,
		run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			-- function 5
			return
		end,
		leave = function (arg_6_0, arg_6_1)
			-- function 6
			return
		end
	},
	beating_with = {
		enter = function (arg_7_0, arg_7_1, arg_7_2)
			-- function 7
			play_animation_event(arg_7_1, "attack_grabbed_smash")
		end,
		run = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			-- function 8
			return
		end,
		leave = function (arg_9_0, arg_9_1)
			-- function 9
			return
		end
	},
	thrown_away = {
		enter = function (arg_10_0, arg_10_1, arg_10_2)
			-- function 10
			play_animation_event(arg_10_1, "attack_grabbed_throw")
		end,
		run = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			-- function 11
			return
		end,
		leave = function (arg_12_0, arg_12_1)
			-- function 12
			return
		end
	},
	chewed_on = {
		enter = function (self, arg_13_1, arg_13_2)
			-- function 13
			play_animation_event(arg_13_1, "attack_grabbed_eat_start")

			self.roar_screen_space_particle_timer = arg_13_2 + 1.1
		end,
		run = function (self, arg_14_1, arg_14_2, arg_14_3)
			-- function 14
			if not (self.roar_screen_space_particle_1 or not (arg_14_2 > self.roar_screen_space_particle_timer)) then
				self.roar_screen_space_particle_1 = self.first_person_extension:create_screen_particles("fx/screenspace_chaos_spawn_tentacles_01")
			end
		end,
		leave = function (self, arg_15_1)
			-- function 15
			if not self.roar_screen_space_particle_1 then
				self.first_person_extension:stop_spawning_screen_particles(self.roar_screen_space_particle_1)

				self.roar_screen_space_particle_1 = nil
			end
		end
	},
	idle = {
		enter = function (arg_16_0, arg_16_1, arg_16_2)
			-- function 16
			play_animation_event(arg_16_1, "idle_grabbed")
		end,
		run = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
			-- function 17
			return
		end,
		leave = function (arg_18_0, arg_18_1)
			-- function 18
			return
		end
	}
}

PlayerCharacterStateGrabbedByChaosSpawn.update = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	local csm = self.csm
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local chaos_spawn_unit = self.chaos_spawn_unit
	local is_catapulted, var_19_5 = CharacterStateHelper.is_catapulted(status_extension)

	if not is_catapulted then
		local tbl = {
			sound_event = "Play_enemy_sorcerer_vortex_throw_player",
			direction = var_19_5
		}

		csm:change_state("catapulted", tbl)

		return
	end

	if not (not status_extension.grabbed_by_chaos_spawn and HEALTH_ALIVE[chaos_spawn_unit]) then
		if not CharacterStateHelper.is_waiting_for_assisted_respawn(status_extension) then
			csm:change_state("waiting_for_assisted_respawn")
		else
			csm:change_state("standing")
		end

		return
	end

	local grabbed_by_chaos_spawn_status, var_19_8 = CharacterStateHelper.grabbed_by_chaos_spawn_status(status_extension)
	local states = PlayerCharacterStateGrabbedByChaosSpawn.states

	if var_19_8 ~= self.status_count then
		local grabbed_by_chaos_spawn_status_2 = self.grabbed_by_chaos_spawn_status

		if not states[grabbed_by_chaos_spawn_status_2].leave then
			states[grabbed_by_chaos_spawn_status_2].leave(self, arg_19_1)
		end

		if not states[grabbed_by_chaos_spawn_status].enter then
			states[grabbed_by_chaos_spawn_status].enter(self, arg_19_1, arg_19_5)
		end

		self.grabbed_by_chaos_spawn_status = grabbed_by_chaos_spawn_status
		self.status_count = var_19_8
	end

	if not CharacterStateHelper.is_knocked_down(status_extension) then
		csm:change_state("knocked_down")

		return
	elseif not CharacterStateHelper.is_dead(status_extension) then
		csm:change_state("dead")

		return
	end

	states[grabbed_by_chaos_spawn_status].run(self, arg_19_1, arg_19_5, arg_19_3)

	local local_rotation = Unit.local_rotation(chaos_spawn_unit, 0)

	Unit.set_local_rotation(arg_19_1, 0, local_rotation)

	local player = self.player

	CharacterStateHelper.look(input_extension, player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end
