-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_grabbed_by_pack_master.lua

PlayerCharacterStateGrabbedByPackMaster = class(PlayerCharacterStateGrabbedByPackMaster, PlayerCharacterState)

local var_0_0 = POSITION_LOOKUP

function PlayerCharacterStateGrabbedByPackMaster.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "grabbed_by_pack_master")

	arg_1_0.move_target_index = 0
	arg_1_0.desired_distance = 2
	arg_1_0.last_valid_position = Vector3Box()
	arg_1_0._drag_delta_move = Vector3Box()
	arg_1_0.next_hanging_damage_time = 0
	arg_1_0._mechanism_name = Managers.mechanism:current_mechanism_name()
end

function PlayerCharacterStateGrabbedByPackMaster.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.inventory_extension
	local var_2_1 = arg_2_0.career_extension

	CharacterStateHelper.stop_weapon_actions(var_2_0, "grabbed")
	CharacterStateHelper.stop_career_abilities(var_2_1, "grabbed")
	var_2_0:check_and_drop_pickups("grabbed_by_pack_master")
	CharacterStateHelper.change_camera_state(arg_2_0.player, "follow_third_person")

	local var_2_2 = arg_2_0.first_person_extension

	var_2_2:set_first_person_mode(false)
	arg_2_0.locomotion_extension:enable_rotation_towards_velocity(false)

	local var_2_3 = arg_2_0.status_extension
	local var_2_4 = var_2_3:get_pack_master_grabber()

	arg_2_0.packmaster_unit = var_2_4
	arg_2_0.packmaster_is_player = Managers.player:is_player_unit(var_2_4)

	if arg_2_0.packmaster_is_player then
		arg_2_0.packmaster_claw_left_hand_constraint = Unit.animation_find_constraint_target(var_2_4, "claw_target_left_hand")
		arg_2_0.packmaster_claw_right_hand_constraint = Unit.animation_find_constraint_target(var_2_4, "claw_target_right_hand")
		arg_2_0.packmaster_claw = ScriptUnit.extension(var_2_4, "inventory_system"):get_weapon_unit()
		arg_2_0.claw_left_hand_node = Unit.node(arg_2_0.packmaster_claw, "a_left_hand")
		arg_2_0.claw_right_hand_node = Unit.node(arg_2_0.packmaster_claw, "a_right_hand")
	end

	local var_2_5 = var_0_0[var_2_4]
	local var_2_6 = var_0_0[arg_2_1]
	local var_2_7 = Unit.node(var_2_4, "j_rightweaponcomponent10")
	local var_2_8 = Unit.world_position(var_2_4, var_2_7)
	local var_2_9 = var_2_8 + Vector3(0, 2, 0)

	arg_2_0._pole = {
		pole_length = 2,
		apos = Vector3Box(var_2_8),
		bpos = Vector3Box(var_2_9)
	}
	arg_2_0.move_target_index = 1

	if arg_2_0.ai_extension == nil then
		local var_2_10 = Managers.world:wwise_world(arg_2_0.world)
		local var_2_11, var_2_12 = WwiseWorld.trigger_event(var_2_10, "start_strangled_state", var_2_2:get_first_person_unit())
	end

	arg_2_0.last_valid_position:store(var_2_6)
	arg_2_0.locomotion_extension:set_wanted_pos(var_2_6)

	arg_2_0.packmaster_grab_state_initialized = false
	arg_2_0.pack_master_status = CharacterStateHelper.pack_master_status(var_2_3)

	local var_2_13 = PlayerCharacterStateGrabbedByPackMaster.states

	if arg_2_0.pack_master_status == "pack_master_pulling" then
		arg_2_0._initial_pull_t = arg_2_5 + 0.75
	else
		arg_2_0._initial_pull_t = arg_2_5
	end

	if var_2_13[arg_2_0.pack_master_status].enter then
		var_2_13[arg_2_0.pack_master_status].enter(arg_2_0, arg_2_1)
	end
end

function PlayerCharacterStateGrabbedByPackMaster.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0.first_person_extension
	local var_3_1 = arg_3_0.status_extension

	if not var_3_1:is_knocked_down() and not var_3_1:is_dead() then
		CharacterStateHelper.change_camera_state(arg_3_0.player, "follow")
		var_3_0:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

		local var_3_2 = arg_3_0.locomotion_extension

		var_3_2:enable_script_driven_movement()
		var_3_2:enable_rotation_towards_velocity(true)
	end

	local var_3_3 = arg_3_0.inventory_extension

	if var_3_3:get_wielded_slot_name() == "slot_packmaster_claw" and Managers.state.network:game() then
		var_3_3:wield_previous_weapon()
	end

	if arg_3_0.ai_extension == nil then
		local var_3_4 = Managers.world:wwise_world(arg_3_0.world)
		local var_3_5, var_3_6 = WwiseWorld.trigger_event(var_3_4, "stop_strangled_state", var_3_0:get_first_person_unit())
	end

	if var_3_1:is_blocking() then
		if not LEVEL_EDITOR_TEST and Managers.state.network:game() then
			local var_3_7 = Managers.state.unit_storage:go_id(arg_3_1)

			if arg_3_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_3_7, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_3_7, false)
			end
		end

		var_3_1:set_blocking(false)
	end
end

function fix_mover(arg_4_0, arg_4_1)
	local var_4_0 = Unit.mover(arg_4_1)
	local var_4_1 = POSITION_LOOKUP[arg_4_1]

	Mover.set_position(var_4_0, var_4_1 + Vector3(0, 0, 1.5))
	Mover.move(var_4_0, Vector3(0, 0, -1.5), 0.03333333333333333)

	if script_data.debug_ai_movement then
		local var_4_2 = Mover.position(var_4_0)

		QuickDrawerStay:sphere(var_4_1, 0.3, Color(245, 0, 0))
		QuickDrawerStay:line(var_4_1, var_4_2, Color(245, 0, 0))
		QuickDrawerStay:sphere(var_4_2, 0.3, Color(245, 245, 0))
	end
end

function update_mover(arg_5_0, arg_5_1)
	local var_5_0 = Unit.mover(arg_5_1)

	Mover.move(var_5_0, Vector3(0, 0, -1.5), 0.03333333333333333)
end

local function var_0_1(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0.packmaster_grab_state_initialized then
		return false
	end

	arg_6_0.packmaster_grab_state_initialized = true

	if arg_6_2 == "pack_master_hoisting" then
		arg_6_0.locomotion_extension:enable_wanted_position_movement()
	end

	local var_6_0 = arg_6_0.inventory_extension

	if var_6_0:get_wielded_slot_name() ~= "slot_packmaster_claw" then
		var_6_0:wield("slot_packmaster_claw", true)
	else
		CharacterStateHelper.show_inventory_3p(arg_6_1, true, true, Managers.player.is_server, arg_6_0.inventory_extension)
	end
end

PlayerCharacterStateGrabbedByPackMaster.states = {
	pack_master_pulling = {
		enter = function(arg_7_0, arg_7_1)
			arg_7_0.locomotion_extension:enable_animation_driven_movement()
			var_0_1(arg_7_0, arg_7_1, "pack_master_pulling")
			Managers.state.network:anim_event(arg_7_1, "packmaster_hooked")
		end,
		run = function(arg_8_0, arg_8_1)
			arg_8_0.last_valid_position:store(var_0_0[arg_8_1])
		end
	},
	pack_master_dragging = {
		enter = function(arg_9_0, arg_9_1)
			arg_9_0.locomotion_extension:enable_wanted_position_movement()
			var_0_1(arg_9_0, arg_9_1, "pack_master_dragging")

			arg_9_0.dragged_move_anim = "move_bwd"

			CharacterStateHelper.play_animation_event_first_person(arg_9_0.first_person_extension, "move_bwd")
		end,
		run = function(arg_10_0, arg_10_1)
			local var_10_0 = arg_10_0._drag_delta_move:unbox()
			local var_10_1 = Vector3.length(var_10_0)

			if arg_10_0.packmaster_is_player then
				local var_10_2 = Unit.world_position(arg_10_0.packmaster_claw, arg_10_0.claw_left_hand_node)
				local var_10_3 = Unit.world_position(arg_10_0.packmaster_claw, arg_10_0.claw_right_hand_node)

				Unit.animation_set_constraint_target(arg_10_0.packmaster_unit, arg_10_0.packmaster_claw_left_hand_constraint, var_10_2)
				Unit.animation_set_constraint_target(arg_10_0.packmaster_unit, arg_10_0.packmaster_claw_right_hand_constraint, var_10_3)
			end

			if var_10_1 == 0 and arg_10_0.dragged_move_anim == "move_bwd" then
				Managers.state.network:anim_event(arg_10_1, "packmaster_hooked_idle")

				arg_10_0.dragged_move_anim = "packmaster_hooked_idle"
			elseif var_10_1 > 0 and arg_10_0.dragged_move_anim == "packmaster_hooked_idle" then
				Managers.state.network:anim_event(arg_10_1, "move_bwd")

				arg_10_0.dragged_move_anim = "move_bwd"
			end

			return true
		end,
		leave = function(arg_11_0, arg_11_1)
			local var_11_0 = arg_11_1 and var_0_0[arg_11_1]

			if var_11_0 then
				arg_11_0.locomotion_extension:teleport_to(var_11_0)

				if script_data.vs_debug_hoist then
					QuickDrawerStay:sphere(var_11_0, 0.5, Colors.get("yellow"))
				end
			end
		end
	},
	pack_master_unhooked = {
		run = function(arg_12_0, arg_12_1)
			arg_12_0.last_valid_position:store(var_0_0[arg_12_1])
		end,
		enter = function(arg_13_0, arg_13_1)
			CharacterStateHelper.show_inventory_3p(arg_13_1, false, true, Managers.player.is_server, arg_13_0.inventory_extension)

			local var_13_0 = arg_13_0.status_extension

			if CharacterStateHelper.is_dead(var_13_0) then
				CharacterStateHelper.play_animation_event(arg_13_1, "packmaster_release_death")
			elseif CharacterStateHelper.is_knocked_down(var_13_0) then
				arg_13_0.temp_params.already_in_ko_anim = true

				CharacterStateHelper.play_animation_event(arg_13_1, "packmaster_release_ko")
			else
				if not LEVEL_EDITOR_TEST and Managers.state.network:game() then
					local var_13_1 = Managers.state.unit_storage:go_id(arg_13_1)

					if arg_13_0.is_server then
						Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_13_1, true)
					else
						Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_13_1, true)
					end
				end

				var_13_0:set_blocking(true)
				CharacterStateHelper.play_animation_event(arg_13_1, "packmaster_release")
			end

			arg_13_0.locomotion_extension:enable_animation_driven_movement()
		end
	},
	pack_master_hoisting = {
		enter = function(arg_14_0, arg_14_1)
			var_0_1(arg_14_0, arg_14_1, "pack_master_hoisting")

			local var_14_0 = ScriptUnit.extension(arg_14_1, "inventory_system")
			local var_14_1 = var_14_0:equipment().right_hand_wielded_unit_3p

			if not (var_14_0:get_wielded_slot_name() == "slot_packmaster_claw" and var_14_1) then
				var_14_0:wield("slot_packmaster_claw")
			end

			local var_14_2 = Managers.player:owner(arg_14_1):profile_index()
			local var_14_3 = SPProfiles[var_14_2].unit_name
			local var_14_4 = "attack_grab_hang_" .. var_14_3

			Managers.state.entity:system("inventory_system"):weapon_anim_event(arg_14_1, var_14_4)
			Managers.state.network:anim_event(arg_14_1, "packmaster_hang_start")

			local var_14_5 = arg_14_0.status_extension:get_pack_master_grabber()

			if ALIVE[var_14_5] then
				Managers.state.network:anim_event(var_14_5, var_14_4)
			end

			local function var_14_6()
				if ALIVE[arg_14_1] and ALIVE[var_14_5] then
					local var_15_0 = World.get_data(arg_14_0.world, "physics_world")
					local var_15_1 = PactswornUtils.get_hoist_position(var_15_0, arg_14_1, var_14_5)

					if script_data.vs_debug_hoist then
						QuickDrawerStay:sphere(var_15_1, 0.5, Colors.get("magenta"))
					end

					arg_14_0.locomotion_extension:teleport_to(var_15_1, nil)
				end
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_14_6)
		end,
		run = function(arg_16_0, arg_16_1)
			return
		end
	},
	pack_master_hanging = {
		enter = function(arg_17_0, arg_17_1)
			return
		end,
		run = function(arg_18_0, arg_18_1)
			return
		end
	},
	pack_master_dropping = {
		enter = function(arg_19_0, arg_19_1)
			CharacterStateHelper.show_inventory_3p(arg_19_1, false, true, Managers.player.is_server, arg_19_0.inventory_extension)

			local var_19_0 = arg_19_0.status_extension

			if CharacterStateHelper.is_dead(var_19_0) then
				CharacterStateHelper.play_animation_event(arg_19_1, "packmaster_hang_release_death")
			elseif CharacterStateHelper.is_knocked_down(var_19_0) then
				arg_19_0.temp_params.already_in_ko_anim = true

				CharacterStateHelper.play_animation_event(arg_19_1, "packmaster_hang_release_ko")
			else
				if not LEVEL_EDITOR_TEST and Managers.state.network:game() then
					local var_19_1 = Managers.state.unit_storage:go_id(arg_19_1)

					if arg_19_0.is_server then
						Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_19_1, true)
					else
						Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_19_1, true)
					end
				end

				var_19_0:set_blocking(true)
				CharacterStateHelper.play_animation_event(arg_19_1, "packmaster_hang_release")
			end

			arg_19_0.locomotion_extension:enable_animation_driven_movement()
		end,
		run = function(arg_20_0, arg_20_1)
			return
		end
	},
	pack_master_released = {
		run = function(arg_21_0, arg_21_1)
			return
		end,
		enter = function(arg_22_0, arg_22_1)
			arg_22_0.locomotion_extension:enable_script_driven_movement()
			CharacterStateHelper.show_inventory_3p(arg_22_1, true, true, Managers.player.is_server, arg_22_0.inventory_extension)

			local var_22_0 = arg_22_0.status_extension
			local var_22_1 = arg_22_0.csm

			if CharacterStateHelper.is_dead(var_22_0) then
				var_22_1:change_state("dead")
			elseif CharacterStateHelper.is_knocked_down(var_22_0) then
				if arg_22_0.inventory_extension:get_wielded_slot_name() == "slot_packmaster_claw" then
					arg_22_0.inventory_extension:wield_previous_weapon()
				end

				var_22_1:change_state("knocked_down", arg_22_0.temp_params)
			else
				if arg_22_0.inventory_extension:get_wielded_slot_name() == "slot_packmaster_claw" then
					arg_22_0.inventory_extension:wield_previous_weapon()
				end

				var_22_1:change_state("standing")
			end
		end
	}
}

function PlayerCharacterStateGrabbedByPackMaster.update(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	local var_23_0 = arg_23_0.csm
	local var_23_1 = arg_23_0.unit
	local var_23_2 = arg_23_0.input_extension
	local var_23_3 = arg_23_0.status_extension
	local var_23_4 = arg_23_0.first_person_extension
	local var_23_5 = PlayerUnitMovementSettings.get_movement_settings_table(var_23_1)
	local var_23_6 = CharacterStateHelper.pack_master_status(arg_23_0.status_extension)

	CharacterStateHelper.look(var_23_2, arg_23_0.player.viewport_name, arg_23_0.first_person_extension, var_23_3, arg_23_0.inventory_extension)

	if arg_23_0._mechanism_name == "versus" and CharacterStateHelper.is_ledge_hanging(arg_23_0.world, var_23_1, arg_23_0.temp_params) then
		local var_23_7 = var_23_3:get_pack_master_grabber()

		StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", var_23_1, false, var_23_7)
		var_23_0:change_state("ledge_hanging", arg_23_0.temp_params)

		return
	end

	local var_23_8 = PlayerCharacterStateGrabbedByPackMaster.states
	local var_23_9 = arg_23_0.pack_master_status

	if var_23_6 ~= var_23_9 then
		if var_23_8[var_23_9].leave then
			var_23_8[var_23_9].leave(arg_23_0, var_23_1)
		end

		if var_23_8[var_23_6].enter then
			var_23_8[var_23_6].enter(arg_23_0, var_23_1)
		end

		arg_23_0.pack_master_status = var_23_6
	end

	local var_23_10 = var_23_3:get_pack_master_grabber()

	if not var_23_8[var_23_6].run(arg_23_0, var_23_1) or not Unit.alive(var_23_10) then
		if var_23_6 == "pack_master_pulling" then
			if arg_23_5 > arg_23_0._initial_pull_t and not arg_23_0._pull_lerp then
				arg_23_0.locomotion_extension:enable_wanted_position_movement()

				arg_23_0._pull_lerp = true
				arg_23_0._pull_lerp_dif = math.huge
			end

			if arg_23_0._pull_lerp then
				local var_23_11 = arg_23_0._pole
				local var_23_12 = Unit.node(var_23_1, "j_neck")
				local var_23_13 = Unit.world_position(var_23_1, var_23_12)
				local var_23_14 = var_0_0[var_23_1] - var_23_13
				local var_23_15 = Unit.node(var_23_10, "j_rightweaponcomponent10")
				local var_23_16 = Unit.world_position(var_23_10, var_23_15)
				local var_23_17 = var_23_16 + Vector3.normalize(var_23_13 - var_23_16) * var_23_11.pole_length + var_23_14

				if arg_23_0._pull_lerp then
					local var_23_18 = Unit.world_position(var_23_1, 0)
					local var_23_19 = var_23_17 - var_23_18
					local var_23_20 = Vector3.normalize(var_23_19) * arg_23_3 * 0.5

					if Vector3.length_squared(var_23_19) < arg_23_0._pull_lerp_dif then
						arg_23_0._pull_lerp_dif = Vector3.length_squared(var_23_19)
						var_23_17 = var_23_18 + var_23_20
					else
						arg_23_0._pull_lerp = nil
					end
				end

				arg_23_0.locomotion_extension:set_wanted_pos(var_23_17)
			end
		end

		return
	end

	local var_23_21 = var_0_0[var_23_10]
	local var_23_22 = var_0_0[var_23_1]
	local var_23_23
	local var_23_24 = arg_23_0._pole
	local var_23_25 = Unit.node(var_23_1, "j_neck")
	local var_23_26 = Unit.world_position(var_23_1, var_23_25)
	local var_23_27 = var_23_22 - var_23_26
	local var_23_28 = Unit.node(var_23_10, "j_rightweaponcomponent10")
	local var_23_29 = Unit.world_position(var_23_10, var_23_28)
	local var_23_30 = Vector3.normalize(var_23_26 - var_23_29) * var_23_24.pole_length
	local var_23_31 = var_23_29 + var_23_30
	local var_23_32 = var_23_31 + var_23_27 or var_23_22
	local var_23_33 = var_23_32 - var_23_22

	var_23_33.z = 0

	arg_23_0._drag_delta_move:store(var_23_33)

	local var_23_34 = Vector3.flat(var_23_21 - var_23_22)
	local var_23_35 = Quaternion.look(-var_23_34)
	local var_23_36 = Unit.local_rotation(var_23_1, 0)
	local var_23_37 = Quaternion.lerp(var_23_36, var_23_35, 0.1)

	Unit.set_local_rotation(var_23_1, 0, var_23_37)
	arg_23_0.locomotion_extension:set_wanted_pos(var_23_32)

	if script_data.vs_debug_hoist then
		QuickDrawer:sphere(var_23_32, 0.5, Colors.get("green"))
		QuickDrawer:sphere(var_23_29, 0.5, Colors.get("blue"))
		QuickDrawer:line(var_23_29, var_23_29 + var_23_30, Colors.get("blue"))
		QuickDrawer:sphere(var_23_31, 0.5, Colors.get("yellow"))
	end

	local var_23_38 = World.get_data(arg_23_0.world, "physics_world")
	local var_23_39 = 0.9
	local var_23_40 = 0.6
	local var_23_41 = Vector3(var_23_39, var_23_40, var_23_39)
	local var_23_42 = var_23_40 - var_23_39 > 0 and "capsule" or "sphere"
	local var_23_43, var_23_44 = PhysicsWorld.immediate_overlap(var_23_38, "shape", var_23_42, "position", var_23_22 + Vector3(0, 0, 0.9), "size", var_23_41, "collision_filter", "filter_player_mover")

	if var_23_44 == 0 then
		arg_23_0.last_valid_position:store(var_23_22)
	end
end
