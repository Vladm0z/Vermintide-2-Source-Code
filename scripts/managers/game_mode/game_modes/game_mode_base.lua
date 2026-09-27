-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_base.lua

GameModeBase = class(GameModeBase)

GameModeBase.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	self._network_server = not arg_1_4 and arg_1_3 and nil
	self._settings = arg_1_1
	self._world = arg_1_2
	self._is_server = arg_1_4
	self._profile_synchronizer = arg_1_5
	self._level_completed = false
	self._level_failed = false

	local lose_condition_disabled = script_data.lose_condition_disabled

	lose_condition_disabled = lose_condition_disabled or false
	self._lose_condition_disabled = lose_condition_disabled
	self._end_level_areas = {}
	self._debug_end_level_areas = {}
	self._is_about_to_end_game_early = false
	self._initial_peers_ready = false
	self._level_key = arg_1_6
	self._statistics_db = arg_1_7
	self._player_spawners = {}
	self._pending_bot_remove = {}
	self._num_pending_bot_remove = 0

	local str = "initial_state"

	if not DEDICATED_SERVER then
		local cprintf = cprintf
		local str_2 = "[GameMode] State Changed from '%s' to '%s'"
		local _game_mode_state = self._game_mode_state

		_game_mode_state = _game_mode_state or "None"

		cprintf(str_2, _game_mode_state, str)
	end

	self._game_mode_state = str
end

GameModeBase.destroy = function (arg_2_0)
	-- function 2
	return
end

GameModeBase.cleanup_game_mode_units = function (arg_3_0)
	-- function 3
	return
end

GameModeBase.register_rpcs = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._network_event_delegate = arg_4_1
	self._network_transmit = arg_4_2
end

GameModeBase.unregister_rpcs = function (self)
	-- function 5
	self._network_event_delegate = nil
	self._network_transmit = nil
end

GameModeBase._register_player_spawner = function (arg_6_0, arg_6_1)
	-- function 6
	arg_6_0._player_spawners[#arg_6_0._player_spawners + 1] = arg_6_1
end

GameModeBase.settings = function (self)
	-- function 7
	return self._settings
end

GameModeBase.setup_done = function (arg_8_0)
	-- function 8
	return
end

GameModeBase.fail_level = function (self)
	-- function 9
	self._level_failed = true
end

GameModeBase._is_time_up = function (arg_10_0)
	-- function 10
	if not LEVEL_EDITOR_TEST then
		return false
	end

	return Managers.state.network:network_time() / NetworkConstants.clock_time.max > 0.9
end

GameModeBase._add_bot_to_party = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local peer_id = Network.peer_id()
	local next_available_local_player_id = Managers.player:next_available_local_player_id(peer_id, arg_11_2)
	local var_11_2 = arg_11_4
	local flag = true

	Managers.party:assign_peer_to_party(peer_id, next_available_local_player_id, arg_11_1, var_11_2, flag)

	local var_11_4 = SPProfiles[arg_11_2]
	local _verify_career = self:_verify_career(arg_11_2, arg_11_3)
	local add_bot_player = Managers.player:add_bot_player(var_11_4.display_name, peer_id, "default", arg_11_2, _verify_career, next_available_local_player_id)

	add_bot_player:create_game_object()
	self._profile_synchronizer:assign_full_profile(peer_id, next_available_local_player_id, arg_11_2, _verify_career, flag)

	local event = Managers.state.event

	if not event then
		event:trigger("on_bot_added", add_bot_player)
	end

	return add_bot_player
end

GameModeBase._verify_career = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local var_12_0 = SPProfiles[arg_12_1]
	local flag = not var_12_0 and var_12_0.careers
	local flag_2 = not flag and flag[arg_12_2]
	local is_unlocked_function, var_12_4, var_12_5 = flag_2:is_unlocked_function(var_12_0.display_name, ExperienceSettings.max_level)

	if not is_unlocked_function then
		Application.warning("############################################################################################")
		Application.warning("[GameModeBase] Selected career for bot is not unlocked -> Defaulting to default career")

		local warning = Application.warning
		local format = string.format
		local str = "Profile: %q - Career: %q - Reason: %q - DLC: %q"
		local display_name

		if not var_12_0 then
			display_name = var_12_0.display_name

			if not display_name then
				-- Nothing
			end
		end

		display_name = arg_12_1

		do
			local var_12_10
		end

		::label_12_0::

		if not flag_2 then
			var_12_10 = Localize(flag_2.display_name)

			if not var_12_10 then
				-- Nothing
			end
		end

		var_12_10 = arg_12_2

		do
			local var_12_11
		end

		::label_12_1::

		if not var_12_4 then
			var_12_11 = Localize(var_12_4)

			if not var_12_11 then
				-- Nothing
			end
		end

		var_12_11 = "-"

		::label_12_2::

		warning(format(str, display_name, var_12_10, var_12_11, tostring(var_12_5)))
		Application.warning("############################################################################################")
	end

	return not is_unlocked_function and arg_12_2 and 1
end

GameModeBase._remove_bot_instant = function (self, arg_13_1)
	-- function 13
	local event = Managers.state.event

	if not event then
		event:trigger("on_bot_removed", arg_13_1)
	end

	if not arg_13_1.player_unit then
		arg_13_1:despawn()
	end

	local network_id = arg_13_1:network_id()
	local local_player_id = arg_13_1:local_player_id()

	self._profile_synchronizer:unassign_profiles_of_peer(network_id, local_player_id)

	local get_player_status = Managers.party:get_player_status(network_id, local_player_id)

	if not get_player_status.party_id then
		Managers.party:remove_peer_from_party(network_id, local_player_id, get_player_status.party_id)
	end

	Managers.player:remove_player(network_id, local_player_id)
end

GameModeBase._remove_bot_update_safe = function (self, arg_14_1)
	-- function 14
	if not Unit.alive(arg_14_1.player_unit) then
		self:_remove_bot_instant(arg_14_1)

		return
	end

	local event = Managers.state.event

	if not event then
		event:trigger("on_bot_removed", arg_14_1)
	end

	self._num_pending_bot_remove = self._num_pending_bot_remove + 1
	self._pending_bot_remove[self._num_pending_bot_remove] = arg_14_1

	Managers.state.spawn:delayed_despawn(arg_14_1)
end

GameModeBase.disable_lose_condition = function (self)
	-- function 15
	self._lose_condition_disabled = true
end

GameModeBase.level_completed = function (self)
	-- function 16
	return self._level_completed
end

GameModeBase.complete_level = function (self)
	-- function 17
	self._level_completed = true
end

GameModeBase.ended = function (arg_18_0, arg_18_1)
	-- function 18
	return
end

GameModeBase.game_won = function (arg_19_0)
	-- function 19
	return
end

GameModeBase.game_lost = function (arg_20_0)
	-- function 20
	return
end

GameModeBase.gm_event_end_conditions_met = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	return
end

GameModeBase.pre_update = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	return
end

GameModeBase.server_update = function (self, arg_23_1, arg_23_2)
	-- function 23
	self:_update_bot_remove()
end

GameModeBase._update_bot_remove = function (self)
	-- function 24
	local _pending_bot_remove = self._pending_bot_remove
	local _num_pending_bot_remove = self._num_pending_bot_remove

	for i = _num_pending_bot_remove, 1, -1 do
		local var_24_2 = _pending_bot_remove[i]

		if not var_24_2.player_unit then
			self:_remove_bot_instant(var_24_2)

			local var_24_3 = _pending_bot_remove[_num_pending_bot_remove]

			_pending_bot_remove[i] = var_24_3
			_pending_bot_remove[var_24_3] = nil
			_num_pending_bot_remove = _num_pending_bot_remove - 1
		end
	end

	self._num_pending_bot_remove = _num_pending_bot_remove
end

GameModeBase.evaluate_end_conditions = function (arg_25_0)
	-- function 25
	return false, nil
end

GameModeBase.ready_to_transition = function (arg_26_0)
	-- function 26
	if not Managers.level_transition_handler:has_next_level() then
		Managers.level_transition_handler:promote_next_level_data()
	end
end

GameModeBase.wanted_transition = function (arg_27_0)
	-- function 27
	return
end

GameModeBase.hot_join_sync = function (arg_28_0, arg_28_1)
	-- function 28
	return
end

GameModeBase.mutators = function (self)
	-- function 29
	local mutators = Managers.deed:mutators()

	if not mutators then
		return table.clone(mutators)
	end

	local tbl = {}
	local matchmaking = Managers.matchmaking

	matchmaking = not matchmaking and Managers.matchmaking:game_mode_event_data()

	if not matchmaking and not matchmaking.mutators then
		table.append(tbl, matchmaking.mutators)
	end

	self:append_live_event_mutators(tbl)

	return tbl
end

GameModeBase.append_live_event_mutators = function (self, arg_30_1)
	-- function 30
	local var_30_0 = LevelSettings[self._level_key]

	if not var_30_0 and var_30_0.hub_level or not var_30_0.tutorial_level then
		return
	end

	local get_special_events = Managers.backend:get_interface("live_events"):get_special_events()

	if not get_special_events then
		return
	end

	for i = 1, #get_special_events do
		local var_30_2 = get_special_events[i]
		local level_keys = var_30_2.level_keys

		if not level_keys and table.is_empty(level_keys) or not table.contains(level_keys, self._level_key) then
			local weekly_event = var_30_2.weekly_event

			if not weekly_event then
				if weekly_event == "override" then
					table.clear(arg_30_1)
					table.append(arg_30_1, var_30_2.mutators)
				elseif weekly_event == "append" then
					table.append(arg_30_1, var_30_2.mutators)
				end
			end
		end
	end
end

GameModeBase.spawning_update = function (arg_31_0)
	-- function 31
	return
end

GameModeBase.ready_to_spawn = function (arg_32_0, arg_32_1)
	-- function 32
	return
end

GameModeBase.player_entered_game_session = function (self, arg_33_1, arg_33_2)
	-- function 33
	local _player_spawners = self._player_spawners

	for i = 1, #_player_spawners do
		_player_spawners[i]:player_entered_game_session(arg_33_1, arg_33_2)
	end
end

GameModeBase.player_left_game_session = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	return
end

GameModeBase.all_peers_ready = function (self)
	-- function 35
	self._initial_peers_ready = true
end

GameModeBase.player_joined_party = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
	-- function 36
	local _player_spawners = self._player_spawners

	for i = 1, #_player_spawners do
		_player_spawners[i]:player_joined_party(arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
	end
end

GameModeBase.player_left_party = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	-- function 37
	local _player_spawners = self._player_spawners

	for i = 1, #_player_spawners do
		_player_spawners[i]:player_left_party(arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	end
end

GameModeBase.game_mode_state = function (self)
	-- function 38
	return self._game_mode_state
end

GameModeBase.change_game_mode_state = function (self, arg_39_1)
	-- function 39
	printf("[GameMode] Changing game mode state to %s", arg_39_1)

	if not DEDICATED_SERVER then
		cprintf("[GameMode] State Changed from '%s' to '%s'", tostring(self._game_mode_state), arg_39_1)
	end

	if not self._is_server then
		Managers.state.game_mode:change_game_mode_state(arg_39_1)

		if not self._lobby_host then
			self._lobby_host:set_lobby_data({
				game_state = arg_39_1
			})
		end
	end

	local _game_mode_state = self._game_mode_state

	self._game_mode_state = arg_39_1

	self:_game_mode_state_changed(arg_39_1, _game_mode_state)
end

GameModeBase._game_mode_state_changed = function (arg_40_0, arg_40_1)
	-- function 40
	return
end

GameModeBase.disable_player_spawning = function (arg_41_0)
	-- function 41
	return
end

GameModeBase.enable_player_spawning = function (arg_42_0, arg_42_1, arg_42_2)
	-- function 42
	return
end

GameModeBase.teleport_despawned_players = function (arg_43_0, arg_43_1)
	-- function 43
	return
end

GameModeBase.respawn_unit_spawned = function (arg_44_0, arg_44_1)
	-- function 44
	return
end

GameModeBase.respawn_gate_unit_spawned = function (arg_45_0, arg_45_1)
	-- function 45
	return
end

GameModeBase.get_respawn_handler = function (arg_46_0)
	-- function 46
	return nil
end

GameModeBase.flow_callback_add_spawn_point = function (arg_47_0, arg_47_1)
	-- function 47
	return
end

GameModeBase.profile_changed = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	-- function 48
	return
end

GameModeBase.force_respawn = function (arg_49_0, arg_49_1, arg_49_2)
	-- function 49
	return
end

GameModeBase.force_respawn_dead_players = function (arg_50_0)
	-- function 50
	return
end

local tbl = {}

GameModeBase.get_active_respawn_units = function (arg_51_0)
	-- function 51
	return tbl
end

GameModeBase.get_available_and_active_respawn_units = function (arg_52_0)
	-- function 52
	return tbl
end

GameModeBase.get_player_wounds = function (arg_53_0, arg_53_1)
	-- function 53
	return 5
end

GameModeBase.get_initial_inventory = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	-- function 54
	return {
		slot_packmaster_claw = "packmaster_claw",
		slot_healthkit = arg_54_1,
		slot_potion = arg_54_2,
		slot_grenade = arg_54_3,
		additional_items = arg_54_4
	}
end

GameModeBase.activate_end_level_area = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	-- function 55
	local num = (arg_55_4 - arg_55_3) * 0.5
	local num_2 = (arg_55_3 + arg_55_4) * 0.5

	arg_55_0._end_level_areas[arg_55_1] = {
		object = arg_55_2,
		extents = Vector3Box(num),
		offset = Vector3Box(num_2)
	}
end

GameModeBase.debug_end_level_area = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	-- function 56
	local num = (arg_56_4 - arg_56_3) * 0.5
	local num_2 = (arg_56_3 + arg_56_4) * 0.5

	arg_56_0._debug_end_level_areas[arg_56_1] = {
		object = arg_56_2,
		extents = Vector3Box(num),
		offset = Vector3Box(num_2)
	}
end

GameModeBase.disable_end_level_area = function (arg_57_0, arg_57_1)
	-- function 57
	arg_57_0._end_level_areas[arg_57_1] = nil
end

GameModeBase.trigger_end_level_area_events = function (self)
	-- function 58
	for k, v in pairs(self._end_level_areas) do
		Unit.flow_event(k, "lua_level_completed_triggered")
	end
end

GameModeBase.update_end_level_areas = function (self)
	-- function 59
	for k, v in pairs(self._debug_end_level_areas) do
		local node = Unit.node(k, v.object)
		local world_rotation = Unit.world_rotation(k, node)
		local right = Quaternion.right(world_rotation)
		local forward = Quaternion.forward(world_rotation)
		local up = Quaternion.up(world_rotation)
		local world_position = Unit.world_position(k, node)
		local unbox = v.offset:unbox()
		local num = world_position + right * unbox.x + forward * unbox.y + up * unbox.z
		local from_quaternion_position = Matrix4x4.from_quaternion_position(world_rotation, num)
		local unbox_2 = v.extents:unbox()

		QuickDrawer:quaternion(world_position, world_rotation)

		local var_59_10 = self._end_level_areas[k]
		local QuickDrawer = QuickDrawer
		local var_59_12 = QuickDrawer
		local box = QuickDrawer.box
		local var_59_14 = from_quaternion_position
		local var_59_15 = unbox_2
		local var_59_16

		if not var_59_10 then
			var_59_16 = Color(0, 255, 0)

			if not var_59_16 then
				-- Nothing
			end
		end

		var_59_16 = Color(255, 0, 0)

		::label_59_0::

		box(var_59_12, var_59_14, var_59_15, var_59_16)
	end

	if not table.is_empty(self._end_level_areas) then
		return false
	else
		local dot = Vector3.dot
		local abs = math.abs
		local num_2 = 0

		for k_2, v_2 in pairs(Managers.player:human_players()) do
			local player_unit = v_2.player_unit
			local alive = Unit.alive(player_unit)

			alive = not alive and not ScriptUnit.extension(player_unit, "status_system"):is_disabled()

			if not alive then
				num_2 = num_2 + 1

				local var_59_22 = POSITION_LOOKUP[player_unit]
				local flag = false

				for k_3, v_3 in pairs(self._end_level_areas) do
					local node_2 = Unit.node(k_3, v_3.object)
					local world_position_2 = Unit.world_position(k_3, node_2)
					local world_rotation_2 = Unit.world_rotation(k_3, node_2)
					local right_2 = Quaternion.right(world_rotation_2)
					local forward_2 = Quaternion.forward(world_rotation_2)
					local up_2 = Quaternion.up(world_rotation_2)
					local unbox_3 = v_3.offset:unbox()
					local num_3 = world_position_2 + right_2 * unbox_3.x + forward_2 * unbox_3.y + up_2 * unbox_3.z
					local unbox_4 = v_3.extents:unbox()
					local num_4 = var_59_22 - num_3

					if not (not (abs(dot(num_4, right_2)) < abs(unbox_4.x)) or not (abs(dot(num_4, forward_2)) < abs(unbox_4.y)) or not (abs(dot(num_4, up_2)) < abs(unbox_4.z))) then
						flag = true

						break
					end
				end

				if not flag then
					return false
				end
			end
		end

		return num_2 > 0
	end
end

GameModeBase.get_end_screen_config = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	-- function 60
	return "none", {}
end

GameModeBase.local_player_ready_to_start = function (arg_61_0, arg_61_1)
	-- function 61
	return true
end

GameModeBase.local_player_game_starts = function (arg_62_0, arg_62_1, arg_62_2)
	-- function 62
	return
end

GameModeBase.is_about_to_end_game_early = function (self)
	-- function 63
	return self._about_to_end_game_early
end

GameModeBase.set_about_to_end_game_early = function (self, arg_64_1)
	-- function 64
	local system = Managers.state.entity:system("dialogue_system")
	local var_64_1 = system
	local set_global_context = system.set_global_context
	local str = "game_about_to_end"
	local flag

	flag = not arg_64_1 and 1 and 0

	set_global_context(var_64_1, str, flag)

	self._about_to_end_game_early = arg_64_1
end

GameModeBase.game_mode_hud_disabled = function (self)
	-- function 65
	return self._hud_disabled
end

GameModeBase.disable_hud = function (self, arg_66_1)
	-- function 66
	self._hud_disabled = arg_66_1
end

GameModeBase.photomode_enabled = function (self)
	-- function 67
	return self._photomode_enabled
end

GameModeBase.set_photomode_enabled = function (self, arg_68_1)
	-- function 68
	self._photomode_enabled = arg_68_1
end

GameModeBase.projectile_hit_character = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5, arg_69_6, arg_69_7, arg_69_8)
	-- function 69
	return
end

GameModeBase.is_reservable = function (arg_70_0)
	-- function 70
	return true
end

GameModeBase.is_joinable = function (arg_71_0)
	-- function 71
	return true
end
