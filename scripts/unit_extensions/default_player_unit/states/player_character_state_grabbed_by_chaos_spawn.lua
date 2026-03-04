-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_chaos_spawn.lua

PlayerCharacterStateGrabbedByChaosSpawn = class(PlayerCharacterStateGrabbedByChaosSpawn, PlayerCharacterState)

local var_0_0 = POSITION_LOOKUP
local var_0_1 = CharacterStateHelper.play_animation_event

PlayerCharacterStateGrabbedByChaosSpawn.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "grabbed_by_chaos_spawn")
end

PlayerCharacterStateGrabbedByChaosSpawn.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	local var_2_0 = arg_2_0.inventory_extension
	local var_2_1 = arg_2_0.career_extension

	CharacterStateHelper.stop_weapon_actions(var_2_0, "grabbed")
	CharacterStateHelper.stop_career_abilities(var_2_1, "grabbed")
	var_2_0:check_and_drop_pickups("grabbed_by_chaos_spawn")
	arg_2_0.first_person_extension:set_first_person_mode(false)

	local var_2_2 = arg_2_0.status_extension
	local var_2_3 = var_2_2.grabbed_by_chaos_spawn_unit

	arg_2_0.chaos_spawn_unit = var_2_3
	arg_2_0.breed = Unit.get_data(var_2_3, "breed")
	arg_2_0.is_bot = arg_2_0.player and arg_2_0.player.bot_player

	CharacterStateHelper.change_camera_state(arg_2_0.player, "chaos_spawn_grabbed")
	arg_2_0.inventory_extension:show_third_person_inventory(false)

	arg_2_0.camera_state = "third_person"

	local var_2_4 = arg_2_0.locomotion_extension

	var_2_4:enable_script_driven_no_mover_movement()
	var_2_4:enable_rotation_towards_velocity(false)

	local var_2_5, var_2_6 = CharacterStateHelper.grabbed_by_chaos_spawn_status(var_2_2)
	local var_2_7 = PlayerCharacterStateGrabbedByChaosSpawn.states

	if var_2_7[var_2_5].enter then
		var_2_7[var_2_5].enter(arg_2_0, arg_2_1, arg_2_5)
	end

	arg_2_0.grabbed_by_chaos_spawn_status = var_2_5
	arg_2_0.status_count = var_2_6

	LocomotionUtils.enable_linked_movement(arg_2_0.world, arg_2_1, arg_2_0.chaos_spawn_unit, 0, Vector3.zero())

	local var_2_8 = arg_2_0.camera_state ~= "first_person" or false

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_8, arg_2_0.is_server, arg_2_0.inventory_extension)

	arg_2_0.grabbed_screen_space_particle_1 = arg_2_0.first_person_extension:create_screen_particles("fx/screenspace_chaos_spawn_tentacles_02")

	if not arg_2_0.is_bot then
		Wwise.set_state("spawn_catch_player", "true")
	end
end

PlayerCharacterStateGrabbedByChaosSpawn.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0.status_extension
	local var_3_1 = ALIVE[arg_3_0.chaos_spawn_unit]
	local var_3_2

	if var_3_1 and var_3_0:is_catapulted() then
		local var_3_3 = Unit.node(arg_3_1, "j_leftfoot")
		local var_3_4 = Unit.node(arg_3_1, "j_rightfoot")

		var_3_2 = (Unit.world_position(arg_3_1, var_3_3) + Unit.world_position(arg_3_1, var_3_4)) / 2
	else
		var_3_2 = Unit.world_position(arg_3_1, Unit.node(arg_3_1, "root_point"))
	end

	LocomotionUtils.disable_linked_movement(arg_3_1)

	local var_3_5 = arg_3_0.locomotion_extension
	local var_3_6 = var_3_5:current_rotation()

	var_3_5:teleport_to(var_3_2, var_3_6)

	if arg_3_0.is_server and var_3_1 then
		StatusUtils.set_grabbed_by_chaos_spawn_network(arg_3_1, false, arg_3_0.chaos_spawn_unit)
	else
		var_3_0:set_grabbed_by_chaos_spawn(false)
	end

	local var_3_7 = arg_3_0.camera_state ~= "first_person" or false

	CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_7, arg_3_0.is_server, arg_3_0.inventory_extension)
	CharacterStateHelper.change_camera_state(arg_3_0.player, "follow")
	arg_3_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

	local var_3_8 = arg_3_0.player

	Managers.state.entity:system("camera_system"):set_follow_unit(var_3_8)

	arg_3_0.camera_state = nil
	arg_3_0.grabbed_by_chaos_spawn_status = nil
	arg_3_0.status_count = nil

	local var_3_9 = arg_3_0.inventory_extension

	if var_3_9 and var_3_9:get_wielded_slot_name() == "slot_career_skill_weapon" then
		var_3_9:wield_previous_weapon()
	else
		var_3_9:rewield_wielded_slot()
	end

	var_3_5:reset_maximum_upwards_velocity()
	var_3_5:enable_script_driven_movement()
	var_3_5:enable_rotation_towards_velocity(true)

	if not arg_3_0.is_bot then
		Wwise.set_state("spawn_catch_player", "false")
	end
end

PlayerCharacterStateGrabbedByChaosSpawn.states = {
	grabbed = {
		enter = function (arg_4_0, arg_4_1, arg_4_2)
			var_0_1(arg_4_1, "attack_grab_player")
		end,
		run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			return
		end,
		leave = function (arg_6_0, arg_6_1)
			return
		end
	},
	beating_with = {
		enter = function (arg_7_0, arg_7_1, arg_7_2)
			var_0_1(arg_7_1, "attack_grabbed_smash")
		end,
		run = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			return
		end,
		leave = function (arg_9_0, arg_9_1)
			return
		end
	},
	thrown_away = {
		enter = function (arg_10_0, arg_10_1, arg_10_2)
			var_0_1(arg_10_1, "attack_grabbed_throw")
		end,
		run = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			return
		end,
		leave = function (arg_12_0, arg_12_1)
			return
		end
	},
	chewed_on = {
		enter = function (arg_13_0, arg_13_1, arg_13_2)
			var_0_1(arg_13_1, "attack_grabbed_eat_start")

			arg_13_0.roar_screen_space_particle_timer = arg_13_2 + 1.1
		end,
		run = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			if not arg_14_0.roar_screen_space_particle_1 and arg_14_2 > arg_14_0.roar_screen_space_particle_timer then
				arg_14_0.roar_screen_space_particle_1 = arg_14_0.first_person_extension:create_screen_particles("fx/screenspace_chaos_spawn_tentacles_01")
			end
		end,
		leave = function (arg_15_0, arg_15_1)
			if arg_15_0.roar_screen_space_particle_1 then
				arg_15_0.first_person_extension:stop_spawning_screen_particles(arg_15_0.roar_screen_space_particle_1)

				arg_15_0.roar_screen_space_particle_1 = nil
			end
		end
	},
	idle = {
		enter = function (arg_16_0, arg_16_1, arg_16_2)
			var_0_1(arg_16_1, "idle_grabbed")
		end,
		run = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
			return
		end,
		leave = function (arg_18_0, arg_18_1)
			return
		end
	}
}

PlayerCharacterStateGrabbedByChaosSpawn.update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	local var_19_0 = arg_19_0.csm
	local var_19_1 = arg_19_0.input_extension
	local var_19_2 = arg_19_0.status_extension
	local var_19_3 = arg_19_0.chaos_spawn_unit
	local var_19_4, var_19_5 = CharacterStateHelper.is_catapulted(var_19_2)

	if var_19_4 then
		local var_19_6 = {
			sound_event = "Play_enemy_sorcerer_vortex_throw_player",
			direction = var_19_5
		}

		var_19_0:change_state("catapulted", var_19_6)

		return
	end

	if not var_19_2.grabbed_by_chaos_spawn or not HEALTH_ALIVE[var_19_3] then
		if CharacterStateHelper.is_waiting_for_assisted_respawn(var_19_2) then
			var_19_0:change_state("waiting_for_assisted_respawn")
		else
			var_19_0:change_state("standing")
		end

		return
	end

	local var_19_7, var_19_8 = CharacterStateHelper.grabbed_by_chaos_spawn_status(var_19_2)
	local var_19_9 = PlayerCharacterStateGrabbedByChaosSpawn.states

	if var_19_8 ~= arg_19_0.status_count then
		local var_19_10 = arg_19_0.grabbed_by_chaos_spawn_status

		if var_19_9[var_19_10].leave then
			var_19_9[var_19_10].leave(arg_19_0, arg_19_1)
		end

		if var_19_9[var_19_7].enter then
			var_19_9[var_19_7].enter(arg_19_0, arg_19_1, arg_19_5)
		end

		arg_19_0.grabbed_by_chaos_spawn_status = var_19_7
		arg_19_0.status_count = var_19_8
	end

	if CharacterStateHelper.is_knocked_down(var_19_2) then
		var_19_0:change_state("knocked_down")

		return
	elseif CharacterStateHelper.is_dead(var_19_2) then
		var_19_0:change_state("dead")

		return
	end

	var_19_9[var_19_7].run(arg_19_0, arg_19_1, arg_19_5, arg_19_3)

	local var_19_11 = Unit.local_rotation(var_19_3, 0)

	Unit.set_local_rotation(arg_19_1, 0, var_19_11)

	local var_19_12 = arg_19_0.player

	CharacterStateHelper.look(var_19_1, var_19_12.viewport_name, arg_19_0.first_person_extension, var_19_2, arg_19_0.inventory_extension)
end
