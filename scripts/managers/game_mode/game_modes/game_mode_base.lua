-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_base.lua

GameModeBase = class(GameModeBase)

GameModeBase.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	arg_1_0._network_server = arg_1_4 and arg_1_3 or nil
	arg_1_0._settings = arg_1_1
	arg_1_0._world = arg_1_2
	arg_1_0._is_server = arg_1_4
	arg_1_0._profile_synchronizer = arg_1_5
	arg_1_0._level_completed = false
	arg_1_0._level_failed = false
	arg_1_0._lose_condition_disabled = script_data.lose_condition_disabled or false
	arg_1_0._end_level_areas = {}
	arg_1_0._debug_end_level_areas = {}
	arg_1_0._is_about_to_end_game_early = false
	arg_1_0._initial_peers_ready = false
	arg_1_0._level_key = arg_1_6
	arg_1_0._statistics_db = arg_1_7
	arg_1_0._player_spawners = {}
	arg_1_0._pending_bot_remove = {}
	arg_1_0._num_pending_bot_remove = 0

	local var_1_0 = "initial_state"

	if DEDICATED_SERVER then
		cprintf("[GameMode] State Changed from '%s' to '%s'", arg_1_0._game_mode_state or "None", var_1_0)
	end

	arg_1_0._game_mode_state = var_1_0
end

GameModeBase.destroy = function (arg_2_0)
	return
end

GameModeBase.cleanup_game_mode_units = function (arg_3_0)
	return
end

GameModeBase.register_rpcs = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._network_event_delegate = arg_4_1
	arg_4_0._network_transmit = arg_4_2
end

GameModeBase.unregister_rpcs = function (arg_5_0)
	arg_5_0._network_event_delegate = nil
	arg_5_0._network_transmit = nil
end

GameModeBase._register_player_spawner = function (arg_6_0, arg_6_1)
	arg_6_0._player_spawners[#arg_6_0._player_spawners + 1] = arg_6_1
end

GameModeBase.settings = function (arg_7_0)
	return arg_7_0._settings
end

GameModeBase.setup_done = function (arg_8_0)
	return
end

GameModeBase.fail_level = function (arg_9_0)
	arg_9_0._level_failed = true
end

GameModeBase._is_time_up = function (arg_10_0)
	if LEVEL_EDITOR_TEST then
		return false
	end

	return Managers.state.network:network_time() / NetworkConstants.clock_time.max > 0.9
end

GameModeBase._add_bot_to_party = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = Network.peer_id()
	local var_11_1 = Managers.player:next_available_local_player_id(var_11_0, arg_11_2)
	local var_11_2 = arg_11_4
	local var_11_3 = true

	Managers.party:assign_peer_to_party(var_11_0, var_11_1, arg_11_1, var_11_2, var_11_3)

	local var_11_4 = SPProfiles[arg_11_2]
	local var_11_5 = arg_11_0:_verify_career(arg_11_2, arg_11_3)
	local var_11_6 = Managers.player:add_bot_player(var_11_4.display_name, var_11_0, "default", arg_11_2, var_11_5, var_11_1)

	var_11_6:create_game_object()
	arg_11_0._profile_synchronizer:assign_full_profile(var_11_0, var_11_1, arg_11_2, var_11_5, var_11_3)

	local var_11_7 = Managers.state.event

	if var_11_7 then
		var_11_7:trigger("on_bot_added", var_11_6)
	end

	return var_11_6
end

GameModeBase._verify_career = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = SPProfiles[arg_12_1]
	local var_12_1 = var_12_0 and var_12_0.careers
	local var_12_2 = var_12_1 and var_12_1[arg_12_2]
	local var_12_3, var_12_4, var_12_5 = var_12_2:is_unlocked_function(var_12_0.display_name, ExperienceSettings.max_level)

	if not var_12_3 then
		Application.warning("############################################################################################")
		Application.warning("[GameModeBase] Selected career for bot is not unlocked -> Defaulting to default career")
		Application.warning(string.format("Profile: %q - Career: %q - Reason: %q - DLC: %q", var_12_0 and var_12_0.display_name or arg_12_1, var_12_2 and Localize(var_12_2.display_name) or arg_12_2, var_12_4 and Localize(var_12_4) or "-", tostring(var_12_5)))
		Application.warning("############################################################################################")
	end

	return var_12_3 and arg_12_2 or 1
end

GameModeBase._remove_bot_instant = function (arg_13_0, arg_13_1)
	local var_13_0 = Managers.state.event

	if var_13_0 then
		var_13_0:trigger("on_bot_removed", arg_13_1)
	end

	if arg_13_1.player_unit then
		arg_13_1:despawn()
	end

	local var_13_1 = arg_13_1:network_id()
	local var_13_2 = arg_13_1:local_player_id()

	arg_13_0._profile_synchronizer:unassign_profiles_of_peer(var_13_1, var_13_2)

	local var_13_3 = Managers.party:get_player_status(var_13_1, var_13_2)

	if var_13_3.party_id then
		Managers.party:remove_peer_from_party(var_13_1, var_13_2, var_13_3.party_id)
	end

	Managers.player:remove_player(var_13_1, var_13_2)
end

GameModeBase._remove_bot_update_safe = function (arg_14_0, arg_14_1)
	if not Unit.alive(arg_14_1.player_unit) then
		arg_14_0:_remove_bot_instant(arg_14_1)

		return
	end

	local var_14_0 = Managers.state.event

	if var_14_0 then
		var_14_0:trigger("on_bot_removed", arg_14_1)
	end

	arg_14_0._num_pending_bot_remove = arg_14_0._num_pending_bot_remove + 1
	arg_14_0._pending_bot_remove[arg_14_0._num_pending_bot_remove] = arg_14_1

	Managers.state.spawn:delayed_despawn(arg_14_1)
end

GameModeBase.disable_lose_condition = function (arg_15_0)
	arg_15_0._lose_condition_disabled = true
end

GameModeBase.level_completed = function (arg_16_0)
	return arg_16_0._level_completed
end

GameModeBase.complete_level = function (arg_17_0)
	arg_17_0._level_completed = true
end

GameModeBase.ended = function (arg_18_0, arg_18_1)
	return
end

GameModeBase.game_won = function (arg_19_0)
	return
end

GameModeBase.game_lost = function (arg_20_0)
	return
end

GameModeBase.gm_event_end_conditions_met = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	return
end

GameModeBase.pre_update = function (arg_22_0, arg_22_1, arg_22_2)
	return
end

GameModeBase.server_update = function (arg_23_0, arg_23_1, arg_23_2)
	arg_23_0:_update_bot_remove()
end

GameModeBase._update_bot_remove = function (arg_24_0)
	local var_24_0 = arg_24_0._pending_bot_remove
	local var_24_1 = arg_24_0._num_pending_bot_remove

	for iter_24_0 = var_24_1, 1, -1 do
		local var_24_2 = var_24_0[iter_24_0]

		if not var_24_2.player_unit then
			arg_24_0:_remove_bot_instant(var_24_2)

			local var_24_3 = var_24_0[var_24_1]

			var_24_0[iter_24_0] = var_24_3
			var_24_0[var_24_3] = nil
			var_24_1 = var_24_1 - 1
		end
	end

	arg_24_0._num_pending_bot_remove = var_24_1
end

GameModeBase.evaluate_end_conditions = function (arg_25_0)
	return false, nil
end

GameModeBase.ready_to_transition = function (arg_26_0)
	if Managers.level_transition_handler:has_next_level() then
		Managers.level_transition_handler:promote_next_level_data()
	end
end

GameModeBase.wanted_transition = function (arg_27_0)
	return
end

GameModeBase.hot_join_sync = function (arg_28_0, arg_28_1)
	return
end

GameModeBase.mutators = function (arg_29_0)
	local var_29_0 = Managers.deed:mutators()

	if var_29_0 then
		return table.clone(var_29_0)
	end

	local var_29_1 = {}
	local var_29_2 = Managers.matchmaking and Managers.matchmaking:game_mode_event_data()

	if var_29_2 and var_29_2.mutators then
		table.append(var_29_1, var_29_2.mutators)
	end

	arg_29_0:append_live_event_mutators(var_29_1)

	return var_29_1
end

GameModeBase.append_live_event_mutators = function (arg_30_0, arg_30_1)
	local var_30_0 = LevelSettings[arg_30_0._level_key]

	if not var_30_0 or var_30_0.hub_level or var_30_0.tutorial_level then
		return
	end

	local var_30_1 = Managers.backend:get_interface("live_events"):get_special_events()

	if not var_30_1 then
		return
	end

	for iter_30_0 = 1, #var_30_1 do
		local var_30_2 = var_30_1[iter_30_0]
		local var_30_3 = var_30_2.level_keys

		if not var_30_3 or table.is_empty(var_30_3) or table.contains(var_30_3, arg_30_0._level_key) then
			local var_30_4 = var_30_2.weekly_event

			if var_30_4 then
				if var_30_4 == "override" then
					table.clear(arg_30_1)
					table.append(arg_30_1, var_30_2.mutators)
				elseif var_30_4 == "append" then
					table.append(arg_30_1, var_30_2.mutators)
				end
			end
		end
	end
end

GameModeBase.spawning_update = function (arg_31_0)
	return
end

GameModeBase.ready_to_spawn = function (arg_32_0, arg_32_1)
	return
end

GameModeBase.player_entered_game_session = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._player_spawners

	for iter_33_0 = 1, #var_33_0 do
		var_33_0[iter_33_0]:player_entered_game_session(arg_33_1, arg_33_2)
	end
end

GameModeBase.player_left_game_session = function (arg_34_0, arg_34_1, arg_34_2)
	return
end

GameModeBase.all_peers_ready = function (arg_35_0)
	arg_35_0._initial_peers_ready = true
end

GameModeBase.player_joined_party = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
	local var_36_0 = arg_36_0._player_spawners

	for iter_36_0 = 1, #var_36_0 do
		var_36_0[iter_36_0]:player_joined_party(arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
	end
end

GameModeBase.player_left_party = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	local var_37_0 = arg_37_0._player_spawners

	for iter_37_0 = 1, #var_37_0 do
		var_37_0[iter_37_0]:player_left_party(arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	end
end

GameModeBase.game_mode_state = function (arg_38_0)
	return arg_38_0._game_mode_state
end

GameModeBase.change_game_mode_state = function (arg_39_0, arg_39_1)
	printf("[GameMode] Changing game mode state to %s", arg_39_1)

	if DEDICATED_SERVER then
		cprintf("[GameMode] State Changed from '%s' to '%s'", tostring(arg_39_0._game_mode_state), arg_39_1)
	end

	if arg_39_0._is_server then
		Managers.state.game_mode:change_game_mode_state(arg_39_1)

		if arg_39_0._lobby_host then
			arg_39_0._lobby_host:set_lobby_data({
				game_state = arg_39_1
			})
		end
	end

	local var_39_0 = arg_39_0._game_mode_state

	arg_39_0._game_mode_state = arg_39_1

	arg_39_0:_game_mode_state_changed(arg_39_1, var_39_0)
end

GameModeBase._game_mode_state_changed = function (arg_40_0, arg_40_1)
	return
end

GameModeBase.disable_player_spawning = function (arg_41_0)
	return
end

GameModeBase.enable_player_spawning = function (arg_42_0, arg_42_1, arg_42_2)
	return
end

GameModeBase.teleport_despawned_players = function (arg_43_0, arg_43_1)
	return
end

GameModeBase.respawn_unit_spawned = function (arg_44_0, arg_44_1)
	return
end

GameModeBase.respawn_gate_unit_spawned = function (arg_45_0, arg_45_1)
	return
end

GameModeBase.get_respawn_handler = function (arg_46_0)
	return nil
end

GameModeBase.flow_callback_add_spawn_point = function (arg_47_0, arg_47_1)
	return
end

GameModeBase.profile_changed = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	return
end

GameModeBase.force_respawn = function (arg_49_0, arg_49_1, arg_49_2)
	return
end

GameModeBase.force_respawn_dead_players = function (arg_50_0)
	return
end

local var_0_0 = {}

GameModeBase.get_active_respawn_units = function (arg_51_0)
	return var_0_0
end

GameModeBase.get_available_and_active_respawn_units = function (arg_52_0)
	return var_0_0
end

GameModeBase.get_player_wounds = function (arg_53_0, arg_53_1)
	return 5
end

GameModeBase.get_initial_inventory = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	return {
		slot_packmaster_claw = "packmaster_claw",
		slot_healthkit = arg_54_1,
		slot_potion = arg_54_2,
		slot_grenade = arg_54_3,
		additional_items = arg_54_4
	}
end

GameModeBase.activate_end_level_area = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	local var_55_0 = (arg_55_4 - arg_55_3) * 0.5
	local var_55_1 = (arg_55_3 + arg_55_4) * 0.5

	arg_55_0._end_level_areas[arg_55_1] = {
		object = arg_55_2,
		extents = Vector3Box(var_55_0),
		offset = Vector3Box(var_55_1)
	}
end

GameModeBase.debug_end_level_area = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	local var_56_0 = (arg_56_4 - arg_56_3) * 0.5
	local var_56_1 = (arg_56_3 + arg_56_4) * 0.5

	arg_56_0._debug_end_level_areas[arg_56_1] = {
		object = arg_56_2,
		extents = Vector3Box(var_56_0),
		offset = Vector3Box(var_56_1)
	}
end

GameModeBase.disable_end_level_area = function (arg_57_0, arg_57_1)
	arg_57_0._end_level_areas[arg_57_1] = nil
end

GameModeBase.trigger_end_level_area_events = function (arg_58_0)
	for iter_58_0, iter_58_1 in pairs(arg_58_0._end_level_areas) do
		Unit.flow_event(iter_58_0, "lua_level_completed_triggered")
	end
end

GameModeBase.update_end_level_areas = function (arg_59_0)
	for iter_59_0, iter_59_1 in pairs(arg_59_0._debug_end_level_areas) do
		local var_59_0 = Unit.node(iter_59_0, iter_59_1.object)
		local var_59_1 = Unit.world_rotation(iter_59_0, var_59_0)
		local var_59_2 = Quaternion.right(var_59_1)
		local var_59_3 = Quaternion.forward(var_59_1)
		local var_59_4 = Quaternion.up(var_59_1)
		local var_59_5 = Unit.world_position(iter_59_0, var_59_0)
		local var_59_6 = iter_59_1.offset:unbox()
		local var_59_7 = var_59_5 + var_59_2 * var_59_6.x + var_59_3 * var_59_6.y + var_59_4 * var_59_6.z
		local var_59_8 = Matrix4x4.from_quaternion_position(var_59_1, var_59_7)
		local var_59_9 = iter_59_1.extents:unbox()

		QuickDrawer:quaternion(var_59_5, var_59_1)

		local var_59_10 = arg_59_0._end_level_areas[iter_59_0]

		QuickDrawer:box(var_59_8, var_59_9, var_59_10 and Color(0, 255, 0) or Color(255, 0, 0))
	end

	if table.is_empty(arg_59_0._end_level_areas) then
		return false
	else
		local var_59_11 = Vector3.dot
		local var_59_12 = math.abs
		local var_59_13 = 0

		for iter_59_2, iter_59_3 in pairs(Managers.player:human_players()) do
			local var_59_14 = iter_59_3.player_unit

			if Unit.alive(var_59_14) and not ScriptUnit.extension(var_59_14, "status_system"):is_disabled() then
				var_59_13 = var_59_13 + 1

				local var_59_15 = POSITION_LOOKUP[var_59_14]
				local var_59_16 = false

				for iter_59_4, iter_59_5 in pairs(arg_59_0._end_level_areas) do
					local var_59_17 = Unit.node(iter_59_4, iter_59_5.object)
					local var_59_18 = Unit.world_position(iter_59_4, var_59_17)
					local var_59_19 = Unit.world_rotation(iter_59_4, var_59_17)
					local var_59_20 = Quaternion.right(var_59_19)
					local var_59_21 = Quaternion.forward(var_59_19)
					local var_59_22 = Quaternion.up(var_59_19)
					local var_59_23 = iter_59_5.offset:unbox()
					local var_59_24 = var_59_18 + var_59_20 * var_59_23.x + var_59_21 * var_59_23.y + var_59_22 * var_59_23.z
					local var_59_25 = iter_59_5.extents:unbox()
					local var_59_26 = var_59_15 - var_59_24

					if var_59_12(var_59_11(var_59_26, var_59_20)) < var_59_12(var_59_25.x) and var_59_12(var_59_11(var_59_26, var_59_21)) < var_59_12(var_59_25.y) and var_59_12(var_59_11(var_59_26, var_59_22)) < var_59_12(var_59_25.z) then
						var_59_16 = true

						break
					end
				end

				if not var_59_16 then
					return false
				end
			end
		end

		return var_59_13 > 0
	end
end

GameModeBase.get_end_screen_config = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	return "none", {}
end

GameModeBase.local_player_ready_to_start = function (arg_61_0, arg_61_1)
	return true
end

GameModeBase.local_player_game_starts = function (arg_62_0, arg_62_1, arg_62_2)
	return
end

GameModeBase.is_about_to_end_game_early = function (arg_63_0)
	return arg_63_0._about_to_end_game_early
end

GameModeBase.set_about_to_end_game_early = function (arg_64_0, arg_64_1)
	Managers.state.entity:system("dialogue_system"):set_global_context("game_about_to_end", arg_64_1 and 1 or 0)

	arg_64_0._about_to_end_game_early = arg_64_1
end

GameModeBase.game_mode_hud_disabled = function (arg_65_0)
	return arg_65_0._hud_disabled
end

GameModeBase.disable_hud = function (arg_66_0, arg_66_1)
	arg_66_0._hud_disabled = arg_66_1
end

GameModeBase.photomode_enabled = function (arg_67_0)
	return arg_67_0._photomode_enabled
end

GameModeBase.set_photomode_enabled = function (arg_68_0, arg_68_1)
	arg_68_0._photomode_enabled = arg_68_1
end

GameModeBase.projectile_hit_character = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5, arg_69_6, arg_69_7, arg_69_8)
	return
end

GameModeBase.is_reservable = function (arg_70_0)
	return true
end

GameModeBase.is_joinable = function (arg_71_0)
	return true
end
