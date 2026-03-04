-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_standing.lua

EnemyCharacterStateStanding = class(EnemyCharacterStateStanding, EnemyCharacterState)

function EnemyCharacterStateStanding.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "standing")

	arg_1_0.wherabouts_extension = ScriptUnit.extension(arg_1_0._unit, "whereabouts_system")
end

function EnemyCharacterStateStanding.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0._unit
	local var_2_1 = arg_2_0._input_extension

	arg_2_0._locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_2_2 = arg_2_0._inventory_extension
	local var_2_3 = arg_2_0._first_person_extension
	local var_2_4 = arg_2_0._status_extension
	local var_2_5 = var_2_1.toggle_crouch

	CharacterStateHelper.look(var_2_1, arg_2_0._player.viewport_name, var_2_3, var_2_4, arg_2_0._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, var_2_0, var_2_1, var_2_2, arg_2_0._health_extension)

	arg_2_0.time_when_can_be_pushed = arg_2_5 + PlayerUnitMovementSettings.get_movement_settings_table(var_2_0).soft_collision.grace_time_pushed_entering_standing

	if arg_2_6 == "dummy" then
		var_2_3:set_first_person_mode(false)
		var_2_3:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	end

	local var_2_6 = Managers.player:owner(var_2_0)

	CharacterStateHelper.change_camera_state(var_2_6, "follow")

	arg_2_0.side = Managers.state.side.side_by_unit[var_2_0]
	arg_2_0.current_animation = "idle"

	if not var_2_4:get_unarmed() then
		CharacterStateHelper.play_animation_event(var_2_0, "to_combat")
	end

	CharacterStateHelper.play_animation_event(var_2_0, "idle")
	CharacterStateHelper.play_animation_event_first_person(var_2_3, "idle")
end

local var_0_0 = {}
local var_0_1 = {}
local var_0_2 = {}

function EnemyCharacterStateStanding.teleport(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._player.viewport_name
	local var_3_1 = ScriptWorld.viewport(arg_3_0._world, var_3_0)
	local var_3_2 = ScriptViewport.camera(var_3_1)
	local var_3_3 = ScriptCamera.position(var_3_2)
	local var_3_4 = ScriptCamera.rotation(var_3_2)
	local var_3_5 = Quaternion.forward(var_3_4)
	local var_3_6 = 30
	local var_3_7, var_3_8, var_3_9, var_3_10, var_3_11 = PhysicsWorld.immediate_raycast(arg_3_0._physics_world, var_3_3, var_3_5, var_3_6, "closest", "collision_filter", "filter_enemy_ray_projectile")

	if var_3_7 then
		if World.umbra_available(arg_3_0._world) then
			local var_3_12 = var_3_3 + var_3_5 * var_3_6

			var_0_0[1] = var_3_3
			var_0_1[1] = var_3_12
			var_0_0[2] = var_3_3
			var_0_1[2] = var_3_12 + Vector3(0, 0, 0.1)
			var_0_0[3] = var_3_3
			var_0_1[3] = var_3_12 - Vector3(0, 0, 0.1)

			if World.umbra_has_line_of_sight_many(arg_3_0._world, var_0_0, var_0_1, var_0_2) > 0 then
				Debug.string("UMBRA HIT")
			end
		end

		if Vector3.dot(var_3_10, Vector3.up()) > 0.8 then
			QuickDrawer:sphere(var_3_8, 0.25, Color(255, 100, 0))
		else
			QuickDrawer:sphere(var_3_8, 0.25, Color(255, 255, 0))

			local var_3_13 = var_3_8 - var_3_5 * 0.6
			local var_3_14, var_3_15, var_3_16, var_3_17, var_3_18 = PhysicsWorld.immediate_raycast(arg_3_0._physics_world, var_3_13, -Vector3.up(), 6, "closest", "collision_filter", "filter_enemy_ray_projectile")
			local var_3_19 = 0.4

			for iter_3_0 = 1, 10 do
				local var_3_20 = var_3_8 + iter_3_0 * Vector3(0, 0, 0.2)
				local var_3_21, var_3_22, var_3_23, var_3_24, var_3_25 = PhysicsWorld.immediate_raycast(arg_3_0._physics_world, var_3_20, var_3_5, var_3_19, "closest", "collision_filter", "filter_enemy_ray_projectile")

				if not var_3_21 then
					QuickDrawer:line(var_3_20, var_3_20 + var_3_5 * var_3_19)

					local var_3_26 = 0.3

					for iter_3_1 = 1, 4 do
						local var_3_27 = var_3_20 + iter_3_1 * var_3_5 * 0.1
						local var_3_28, var_3_29, var_3_30, var_3_31, var_3_32 = PhysicsWorld.immediate_raycast(arg_3_0._physics_world, var_3_20, -Vector3.up(), var_3_26, "closest", "collision_filter", "filter_enemy_ray_projectile")

						if var_3_28 then
							QuickDrawer:sphere(var_3_29, 0.75, Color(255, 255, 0))

							break
						end
					end

					break
				end
			end

			local var_3_33 = 0.2
			local var_3_34 = 3
			local var_3_35 = var_3_8 + var_3_5 * var_3_33 + Vector3.up() * var_3_34
			local var_3_36, var_3_37, var_3_38, var_3_39, var_3_40 = PhysicsWorld.immediate_raycast(arg_3_0._physics_world, var_3_35, -Vector3.up(), var_3_34, "closest", "collision_filter", "filter_enemy_ray_projectile")

			if var_3_36 then
				local var_3_41 = var_3_37 - var_3_5 * var_3_33
				local var_3_42, var_3_43, var_3_44, var_3_45, var_3_46 = PhysicsWorld.immediate_raycast(arg_3_0._physics_world, var_3_41, var_3_5, var_3_33, "closest", "collision_filter", "filter_enemy_ray_projectile")

				var_3_36 = not var_3_42
			end

			if var_3_14 and var_3_36 then
				if var_3_16 < var_3_38 then
					QuickDrawer:line(var_3_13, var_3_15)
					QuickDrawer:sphere(var_3_15, 0.25, Color(0, 125, 0))
				else
					QuickDrawer:line(var_3_13, var_3_37)
					QuickDrawer:sphere(var_3_37, 0.25, Color(0, 0, 125))
				end
			elseif var_3_14 then
				QuickDrawer:sphere(var_3_15, 0.25, Color(0, 125, 0))
				QuickDrawer:line(var_3_15, var_3_13, Color(0, 125, 0))
			elseif var_3_36 then
				QuickDrawer:sphere(var_3_37, 0.25, Color(0, 0, 125))
				QuickDrawer:line(var_3_37, var_3_35, Color(0, 0, 125))
			end
		end
	else
		local var_3_47 = var_3_3 + var_3_5 * var_3_6
		local var_3_48, var_3_49, var_3_50, var_3_51, var_3_52 = PhysicsWorld.immediate_raycast(arg_3_0._physics_world, var_3_47, -Vector3.up(), 6, "closest", "collision_filter", "filter_enemy_ray_projectile")

		if var_3_48 then
			QuickDrawer:sphere(var_3_49, 0.25, Color(155, 225, 100))
		end
	end
end

function EnemyCharacterStateStanding.common_state_changes(arg_4_0)
	arg_4_0:handle_disabled_ghost_mode()

	local var_4_0 = arg_4_0._csm
	local var_4_1 = arg_4_0._unit
	local var_4_2 = arg_4_0._locomotion_extension
	local var_4_3 = arg_4_0._status_extension
	local var_4_4 = arg_4_0._first_person_extension
	local var_4_5 = CharacterStateHelper
	local var_4_6 = arg_4_0._career_extension:career_settings()
	local var_4_7 = arg_4_0._inventory_extension

	if var_4_2:is_on_ground() then
		arg_4_0.wherabouts_extension:set_is_onground()
	end

	if var_4_5.do_common_state_transitions(var_4_3, var_4_0) then
		return true
	end

	if var_4_5.is_using_transport(var_4_3) then
		var_4_0:change_state("using_transport")

		return true
	end

	if not var_4_0.state_next and var_4_3.do_leap then
		var_4_0:change_state("leaping")

		return true
	end

	if arg_4_0._input_extension:get("character_inspecting") then
		local var_4_8, var_4_9, var_4_10 = var_4_5.get_item_data_and_weapon_extensions(arg_4_0._inventory_extension)

		if not var_4_5.get_current_action_data(var_4_10, var_4_9) then
			var_4_0:change_state("inspecting")

			return true
		end
	end

	return false
end

function EnemyCharacterStateStanding.common_movement(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._csm
	local var_5_1 = arg_5_0._unit
	local var_5_2 = arg_5_0._first_person_extension
	local var_5_3 = arg_5_0._ghost_mode_extension
	local var_5_4 = arg_5_0._input_extension
	local var_5_5 = arg_5_0._locomotion_extension
	local var_5_6 = arg_5_0._status_extension
	local var_5_7 = CharacterStateHelper
	local var_5_8 = Managers.input:is_device_active("gamepad")
	local var_5_9 = var_5_6:is_crouching()

	if (var_5_4:get("jump") or var_5_4:get("jump_only")) and not var_5_6:is_crouching() and (not var_5_9 or var_5_7.can_uncrouch(var_5_1)) and var_5_5:jump_allowed() then
		if var_5_9 then
			var_5_7.uncrouch(var_5_1, arg_5_1, var_5_2, var_5_6)
		end

		var_5_0:change_state("jumping")
		var_5_2:change_state("jumping")

		return
	end

	local var_5_10 = PlayerUnitMovementSettings.get_movement_settings_table(var_5_1)

	if var_5_7.is_pushed(var_5_6) then
		var_5_6:set_pushed(false)

		local var_5_11 = var_5_10.stun_settings.pushed

		var_5_11.hit_react_type = var_5_6:hit_react_type() .. "_push"

		var_5_0:change_state("stunned", var_5_11)

		return true
	end

	if var_5_5:is_animation_driven() then
		var_5_0:change_state("walking")

		return true
	end

	local var_5_12 = arg_5_0._interactor_extension

	if var_5_7.is_starting_interaction(var_5_4, var_5_12) then
		local var_5_13, var_5_14 = InteractionHelper.interaction_action_names(var_5_1)

		var_5_12:start_interaction(var_5_14)

		if var_5_12:allow_movement_during_interaction() then
			return
		end

		local var_5_15 = var_5_12:interaction_config()
		local var_5_16 = arg_5_0._temp_params

		var_5_16.swap_to_3p = var_5_15.swap_to_3p
		var_5_16.show_weapons = var_5_15.show_weapons
		var_5_16.activate_block = var_5_15.activate_block
		var_5_16.allow_rotation_update = var_5_15.allow_rotation_update

		var_5_0:change_state("interacting", var_5_16)

		return true
	end

	if var_5_7.has_move_input(var_5_4) then
		local var_5_17 = arg_5_0._temp_params

		var_5_0:change_state("walking", var_5_17)
		var_5_2:change_state("walking")

		return true
	end

	if not var_5_5:is_on_ground() then
		var_5_0:change_state("falling")
		var_5_2:change_state("falling")

		return true
	end

	if var_5_4:get("character_inspecting") then
		local var_5_18, var_5_19, var_5_20 = var_5_7.get_item_data_and_weapon_extensions(arg_5_0._inventory_extension)

		if not var_5_7.get_current_action_data(var_5_20, var_5_19) then
			var_5_0:change_state("inspecting")

			return true
		end
	end

	local var_5_21 = arg_5_0._inventory_extension
	local var_5_22 = arg_5_0._first_person_extension
	local var_5_23 = var_5_4.toggle_crouch

	if arg_5_1 > arg_5_0.time_when_can_be_pushed and arg_5_0._player:is_player_controlled() then
		arg_5_0.current_animation = var_5_7.update_soft_collision_movement(var_5_22, var_5_6, var_5_5, var_5_1, arg_5_0._world, arg_5_0.current_animation, arg_5_0.side)
	end

	var_5_7.ghost_mode(arg_5_0._ghost_mode_extension, var_5_4)
	var_5_7.look(var_5_4, arg_5_0._player.viewport_name, arg_5_0._first_person_extension, var_5_6, arg_5_0._inventory_extension)

	return false
end

function EnemyCharacterStateStanding.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if arg_6_0:common_state_changes() then
		return
	end

	arg_6_0:_update_taunt_dialogue(arg_6_5)

	local var_6_0 = arg_6_0:common_movement(arg_6_5)
end
