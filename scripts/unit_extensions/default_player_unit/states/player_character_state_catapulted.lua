-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_catapulted.lua

require("scripts/settings/player_movement_settings")

PlayerCharacterStateCatapulted = class(PlayerCharacterStateCatapulted, PlayerCharacterState)

local var_0_0 = POSITION_LOOKUP
local var_0_1 = PlayerUnitMovementSettings.catapulted.directions

function PlayerCharacterStateCatapulted.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "catapulted")
end

function PlayerCharacterStateCatapulted.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "stunned")
	CharacterStateHelper.stop_career_abilities(arg_2_0.career_extension, "stunned")

	local var_2_0 = arg_2_7.direction

	if arg_2_6 == "grabbed_by_chaos_spawn" then
		var_2_0 = "forward_thrown"
	end

	local var_2_1 = arg_2_0.status_extension.catapulted_velocity:unbox()
	local var_2_2 = arg_2_0.locomotion_extension

	var_2_2:set_maximum_upwards_velocity(var_2_1.z)
	var_2_2:set_forced_velocity(var_2_1)
	var_2_2:set_wanted_velocity(var_2_1)

	arg_2_0._direction = var_2_0

	local var_2_3 = var_0_1[var_2_0].start_animation
	local var_2_4 = var_0_1[var_2_0].start_animation_1p

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_3)
	CharacterStateHelper.play_animation_event_first_person(arg_2_0.first_person_extension, var_2_4 or var_2_3)

	local var_2_5 = arg_2_0.first_person_extension

	var_2_5:hide_weapons("catapulted")

	local var_2_6 = false

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_6, arg_2_0.is_server, arg_2_0.inventory_extension)

	local var_2_7 = arg_2_7.sound_event

	if var_2_7 then
		var_2_5:play_hud_sound_event(var_2_7)
	end

	arg_2_0.start_catapulted_height = var_0_0[arg_2_1].z
end

function PlayerCharacterStateCatapulted.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0._direction = nil

	arg_3_0.status_extension:set_catapulted(false)
	arg_3_0.first_person_extension:unhide_weapons("catapulted")
	arg_3_0.locomotion_extension:reset_maximum_upwards_velocity()

	if Managers.state.network:game() then
		local var_3_0 = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_0, arg_3_0.is_server, arg_3_0.inventory_extension)
		CharacterStateHelper.play_animation_event(arg_3_1, "airtime_end")
	end

	arg_3_0.status_extension:set_falling_height(nil, arg_3_0.start_catapulted_height)
end

function PlayerCharacterStateCatapulted.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.unit
	local var_4_2 = arg_4_0.world
	local var_4_3 = arg_4_0.input_extension
	local var_4_4 = arg_4_0.status_extension

	if var_0_0[var_4_1].z < -240 then
		print("Player has fallen outside the world -- kill meeeee ", var_0_0[var_4_1].z)

		if arg_4_0.is_server then
			Managers.state.entity:system("health_system"):suicide(var_4_1)
		else
			local var_4_5 = arg_4_0.unit_storage:go_id(var_4_1)

			arg_4_0.network_transmit:send_rpc_server("rpc_suicide", var_4_5)
		end
	end

	if CharacterStateHelper.is_ledge_hanging(var_4_2, var_4_1, arg_4_0.temp_params) then
		var_4_0:change_state("ledge_hanging", arg_4_0.temp_params)

		return
	end

	if CharacterStateHelper.is_dead(var_4_4) then
		var_4_0:change_state("dead")

		return
	end

	if CharacterStateHelper.is_pounced_down(var_4_4) then
		var_4_0:change_state("pounced_down")

		return
	end

	if CharacterStateHelper.is_in_vortex(var_4_4) then
		var_4_0:change_state("in_vortex")

		return
	end

	if CharacterStateHelper.is_block_broken(var_4_4) then
		var_4_4:set_block_broken(false)
	end

	if CharacterStateHelper.is_colliding_down(var_4_1) and arg_4_0.locomotion_extension:current_velocity().z < 0 then
		local var_4_6 = var_0_1[arg_4_0._direction].land_animation

		CharacterStateHelper.play_animation_event(var_4_1, var_4_6)

		if CharacterStateHelper.has_move_input(var_4_3) then
			var_4_0:change_state("walking")
		else
			var_4_0:change_state("standing")
		end

		return
	end

	if CharacterStateHelper.is_colliding_down(var_4_1) and arg_4_0.locomotion_extension:is_on_ground() and arg_4_0.locomotion_extension:current_velocity().z >= 0 then
		local var_4_7 = var_0_1[arg_4_0._direction].land_animation

		CharacterStateHelper.play_animation_event(var_4_1, var_4_7)

		if CharacterStateHelper.has_move_input(var_4_3) then
			var_4_0:change_state("walking")
		else
			var_4_0:change_state("standing")
		end

		arg_4_0.locomotion_extension:add_external_velocity(arg_4_0.locomotion_extension:current_velocity() * 0.2)

		return
	end

	if CharacterStateHelper.is_colliding_sides(var_4_1) then
		local var_4_8 = var_0_1[arg_4_0._direction].wall_collide_animation

		CharacterStateHelper.play_animation_event(var_4_1, var_4_8)
		var_4_0:change_state("standing")

		return
	end

	local var_4_9 = arg_4_0.first_person_extension

	CharacterStateHelper.look(var_4_3, arg_4_0.player.viewport_name, var_4_9, var_4_4, arg_4_0.inventory_extension)
end
