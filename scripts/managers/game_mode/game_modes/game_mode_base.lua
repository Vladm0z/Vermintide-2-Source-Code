-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_base.lua

GameModeBase = class(GameModeBase)

GameModeBase.init = function (self, settings, world, network_handler, is_server, profile_synchronizer, level_key, statistics_db, game_mode_settings)
	-- function 1
	self._network_server = is_server and (network_handler or nil) or not is_server and nil
	self._settings = settings
	self._world = world
	self._is_server = is_server
	self._profile_synchronizer = profile_synchronizer
	self._level_completed = false
	self._level_failed = false
	self._lose_condition_disabled = script_data.lose_condition_disabled
	self._end_level_areas = {}
	self._debug_end_level_areas = {}
	self._is_about_to_end_game_early = false
	self._initial_peers_ready = false
	self._level_key = level_key
	self._statistics_db = statistics_db
	self._player_spawners = {}
	self._pending_bot_remove = {}
	self._num_pending_bot_remove = 0

	local new_state = "initial_state"

	if DEDICATED_SERVER then
		cprintf("[GameMode] State Changed from '%s' to '%s'", self._game_mode_state, new_state)
	end

	self._game_mode_state = new_state
end

GameModeBase.destroy = function (self)
	-- function 2
	return
end

GameModeBase.cleanup_game_mode_units = function (self)
	-- function 3
	return
end

GameModeBase.register_rpcs = function (self, network_event_delegate, network_transmit)
	-- function 4
	self._network_event_delegate = network_event_delegate
	self._network_transmit = network_transmit
end

GameModeBase.unregister_rpcs = function (self)
	-- function 5
	self._network_event_delegate = nil
	self._network_transmit = nil
end

GameModeBase._register_player_spawner = function (self, player_spawner)
	-- function 6
	self._player_spawners[#self._player_spawners + 1] = player_spawner
end

GameModeBase.settings = function (self)
	-- function 7
	return self._settings
end

GameModeBase.setup_done = function (self)
	-- function 8
	return
end

GameModeBase.fail_level = function (self)
	-- function 9
	self._level_failed = true
end

GameModeBase._is_time_up = function (self)
	-- function 10
	if LEVEL_EDITOR_TEST then
		return false
	end

	local network_time = Managers.state.network:network_time()
	local max_time = NetworkConstants.clock_time.max
	local time_up = network_time / max_time > 0.9

	return time_up
end

GameModeBase._add_bot_to_party = function (self, party_id, profile_index, career_index, optional_slot_id)
	-- function 11
	local local_peer_id = Network.peer_id()
	local local_player_id = Managers.player:next_available_local_player_id(local_peer_id, profile_index)
	local slot_id = optional_slot_id
	local is_bot = true

	Managers.party:assign_peer_to_party(local_peer_id, local_player_id, party_id, slot_id, is_bot)

	local profile = SPProfiles[profile_index]
	local career_index = self:_verify_career(profile_index, career_index)
	local bot_player = Managers.player:add_bot_player(profile.display_name, local_peer_id, "default", profile_index, career_index, local_player_id)

	bot_player:create_game_object()
	self._profile_synchronizer:assign_full_profile(local_peer_id, local_player_id, profile_index, career_index, is_bot)

	local event_manager = Managers.state.event

	if event_manager then
		event_manager:trigger("on_bot_added", bot_player)
	end

	return bot_player
end

GameModeBase._verify_career = function (self, profile_index, career_index)
	-- function 12
	local profile = SPProfiles[profile_index]
	local careers = profile and profile.careers
	local career = careers and careers[career_index]
	local career_unlocked, reason, dlc_name = career:is_unlocked_function(profile.display_name, ExperienceSettings.max_level)

	if not career_unlocked then
		Application.warning("############################################################################################")
		Application.warning("[GameModeBase] Selected career for bot is not unlocked -> Defaulting to default career")
		Application.warning(string.format("Profile: %q - Career: %q - Reason: %q - DLC: %q", profile and profile.display_name or not profile and profile_index, career and Localize(career.display_name) or not career and career_index, reason and Localize(reason) or not reason and "-", tostring(dlc_name)))
		Application.warning("############################################################################################")
	end

	return career_unlocked and (career_index or 1) or not career_unlocked and 1
end

GameModeBase._remove_bot_instant = function (self, bot_player)
	-- function 13
	local event_manager = Managers.state.event

	if event_manager then
		event_manager:trigger("on_bot_removed", bot_player)
	end

	if bot_player.player_unit then
		bot_player:despawn()
	end

	local peer_id = bot_player:network_id()
	local local_player_id = bot_player:local_player_id()

	self._profile_synchronizer:unassign_profiles_of_peer(peer_id, local_player_id)

	local status = Managers.party:get_player_status(peer_id, local_player_id)

	if status.party_id then
		Managers.party:remove_peer_from_party(peer_id, local_player_id, status.party_id)
	end

	Managers.player:remove_player(peer_id, local_player_id)
end

GameModeBase._remove_bot_update_safe = function (self, bot_player)
	-- function 14
	if not Unit.alive(bot_player.player_unit) then
		self:_remove_bot_instant(bot_player)

		return
	end

	local event_manager = Managers.state.event

	if event_manager then
		event_manager:trigger("on_bot_removed", bot_player)
	end

	self._num_pending_bot_remove = self._num_pending_bot_remove + 1
	self._pending_bot_remove[self._num_pending_bot_remove] = bot_player

	Managers.state.spawn:delayed_despawn(bot_player)
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

GameModeBase.ended = function (self, reason)
	-- function 18
	return
end

GameModeBase.game_won = function (self)
	-- function 19
	return
end

GameModeBase.game_lost = function (self)
	-- function 20
	return
end

GameModeBase.gm_event_end_conditions_met = function (self, reason, checkpoint_available, percentages_completed)
	-- function 21
	return
end

GameModeBase.pre_update = function (self, t, dt)
	-- function 22
	return
end

GameModeBase.server_update = function (self, t, dt)
	-- function 23
	self:_update_bot_remove()
end

GameModeBase._update_bot_remove = function (self)
	-- function 24
	local pending_bot_remove = self._pending_bot_remove
	local num_pending_bot_remove = self._num_pending_bot_remove

	for i = num_pending_bot_remove, 1, -1 do
		local bot_player = pending_bot_remove[i]

		if not bot_player.player_unit then
			self:_remove_bot_instant(bot_player)

			local last = pending_bot_remove[num_pending_bot_remove]

			pending_bot_remove[i] = last
			pending_bot_remove[last] = nil
			num_pending_bot_remove = num_pending_bot_remove - 1
		end
	end

	self._num_pending_bot_remove = num_pending_bot_remove
end

GameModeBase.evaluate_end_conditions = function (self)
	-- function 25
	return false, nil
end

GameModeBase.ready_to_transition = function (self)
	-- function 26
	if Managers.level_transition_handler:has_next_level() then
		Managers.level_transition_handler:promote_next_level_data()
	end
end

GameModeBase.wanted_transition = function (self)
	-- function 27
	return
end

GameModeBase.hot_join_sync = function (self, sender)
	-- function 28
	return
end

GameModeBase.mutators = function (self)
	-- function 29
	local deed_mutators = Managers.deed:mutators()

	if deed_mutators then
		return table.clone(deed_mutators)
	end

	local mutators_list = {}
	local weekly_events_game_mode_data = Managers.matchmaking

	if weekly_events_game_mode_data and weekly_events_game_mode_data.mutators then
		table.append(mutators_list, weekly_events_game_mode_data.mutators)
	end

	self:append_live_event_mutators(mutators_list)

	return mutators_list
end

GameModeBase.append_live_event_mutators = function (self, mutators_list)
	-- function 30
	local level_settings = LevelSettings[self._level_key]

	if not level_settings or level_settings.hub_level or level_settings.tutorial_level then
		return
	end

	local live_event_interface = Managers.backend:get_interface("live_events")
	local special_events = live_event_interface:get_special_events()

	if not special_events then
		return
	end

	for i = 1, #special_events do
		local special_event_data = special_events[i]
		local valid_levels = special_event_data.level_keys

		if not valid_levels or table.is_empty(valid_levels) or table.contains(valid_levels, self._level_key) then
			local weekly_override_type = special_event_data.weekly_event

			if weekly_override_type then
				if weekly_override_type == "override" then
					table.clear(mutators_list)
					table.append(mutators_list, special_event_data.mutators)
				elseif weekly_override_type == "append" then
					table.append(mutators_list, special_event_data.mutators)
				end
			end
		end
	end
end

GameModeBase.spawning_update = function (self)
	-- function 31
	return
end

GameModeBase.ready_to_spawn = function (self, status)
	-- function 32
	return
end

GameModeBase.player_entered_game_session = function (self, peer_id, local_player_id)
	-- function 33
	local player_spawners = self._player_spawners

	for i = 1, #player_spawners do
		player_spawners[i]:player_entered_game_session(peer_id, local_player_id)
	end
end

GameModeBase.player_left_game_session = function (self, peer_id, local_player_id)
	-- function 34
	return
end

GameModeBase.all_peers_ready = function (self)
	-- function 35
	self._initial_peers_ready = true
end

GameModeBase.player_joined_party = function (self, peer_id, local_player_id, new_party_id, slot_id, old_party_id)
	-- function 36
	local player_spawners = self._player_spawners

	for i = 1, #player_spawners do
		player_spawners[i]:player_joined_party(peer_id, local_player_id, new_party_id, slot_id, old_party_id)
	end
end

GameModeBase.player_left_party = function (self, peer_id, local_player_id, party_id, slot_id, old_slot_data)
	-- function 37
	local player_spawners = self._player_spawners

	for i = 1, #player_spawners do
		player_spawners[i]:player_left_party(peer_id, local_player_id, party_id, slot_id, old_slot_data)
	end
end

GameModeBase.game_mode_state = function (self)
	-- function 38
	return self._game_mode_state
end

GameModeBase.change_game_mode_state = function (self, state_name)
	-- function 39
	printf("[GameMode] Changing game mode state to %s", state_name)

	if DEDICATED_SERVER then
		cprintf("[GameMode] State Changed from '%s' to '%s'", tostring(self._game_mode_state), state_name)
	end

	if self._is_server then
		Managers.state.game_mode:change_game_mode_state(state_name)

		if self._lobby_host then
			self._lobby_host:set_lobby_data({
				game_state = state_name
			})
		end
	end

	local old_state = self._game_mode_state

	self._game_mode_state = state_name

	self:_game_mode_state_changed(state_name, old_state)
end

GameModeBase._game_mode_state_changed = function (self, state_name)
	-- function 40
	return
end

GameModeBase.disable_player_spawning = function (self)
	-- function 41
	return
end

GameModeBase.enable_player_spawning = function (self, safe_position, safe_rotation)
	-- function 42
	return
end

GameModeBase.teleport_despawned_players = function (self, position)
	-- function 43
	return
end

GameModeBase.respawn_unit_spawned = function (self, unit)
	-- function 44
	return
end

GameModeBase.respawn_gate_unit_spawned = function (self, unit)
	-- function 45
	return
end

GameModeBase.get_respawn_handler = function (self)
	-- function 46
	return nil
end

GameModeBase.flow_callback_add_spawn_point = function (self, unit)
	-- function 47
	return
end

GameModeBase.profile_changed = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 48
	return
end

GameModeBase.force_respawn = function (self, peer_id, local_player_id)
	-- function 49
	return
end

GameModeBase.force_respawn_dead_players = function (self)
	-- function 50
	return
end

local empty_table = {}

GameModeBase.get_active_respawn_units = function (self)
	-- function 51
	return empty_table
end

GameModeBase.get_available_and_active_respawn_units = function (self)
	-- function 52
	return empty_table
end

GameModeBase.get_player_wounds = function (self, profile)
	-- function 53
	return 5
end

GameModeBase.get_initial_inventory = function (self, healthkit, potion, grenade, additional_items, profile)
	-- function 54
	local initial_inventory = {
		slot_packmaster_claw = "packmaster_claw",
		slot_healthkit = healthkit,
		slot_potion = potion,
		slot_grenade = grenade,
		additional_items = additional_items
	}

	return initial_inventory
end

GameModeBase.activate_end_level_area = function (self, unit, object, from, to)
	-- function 55
	local extents = (to - from) * 0.5
	local offset = (from + to) * 0.5

	self._end_level_areas[unit] = {
		object = object,
		extents = Vector3Box(extents),
		offset = Vector3Box(offset)
	}
end

GameModeBase.debug_end_level_area = function (self, unit, object, from, to)
	-- function 56
	local extents = (to - from) * 0.5
	local offset = (from + to) * 0.5

	self._debug_end_level_areas[unit] = {
		object = object,
		extents = Vector3Box(extents),
		offset = Vector3Box(offset)
	}
end

GameModeBase.disable_end_level_area = function (self, unit)
	-- function 57
	self._end_level_areas[unit] = nil
end

GameModeBase.trigger_end_level_area_events = function (self)
	-- function 58
	for unit, _ in pairs(self._end_level_areas) do
		Unit.flow_event(unit, "lua_level_completed_triggered")
	end
end

GameModeBase.update_end_level_areas = function (self)
	-- function 59
	for unit, data in pairs(self._debug_end_level_areas) do
		local node = Unit.node(unit, data.object)
		local rot = Unit.world_rotation(unit, node)
		local right = Quaternion.right(rot)
		local fwd = Quaternion.forward(rot)
		local up = Quaternion.up(rot)
		local object_pos = Unit.world_position(unit, node)
		local offset = data.offset:unbox()
		local pos = object_pos + right * offset.x + fwd * offset.y + up * offset.z
		local pose = Matrix4x4.from_quaternion_position(rot, pos)
		local extents = data.extents:unbox()

		QuickDrawer:quaternion(object_pos, rot)

		local enabled = self._end_level_areas[unit]

		QuickDrawer:box(pose, extents, enabled and Color(0, 255, 0) or not enabled and Color(255, 0, 0))
	end

	if table.is_empty(self._end_level_areas) then
		return false
	else
		local dot = Vector3.dot
		local abs = math.abs
		local num_non_disabled_players = 0

		for _, player in pairs(Managers.player:human_players()) do
			local player_unit = player.player_unit
			local non_disabled = Unit.alive(player_unit)

			if non_disabled then
				num_non_disabled_players = num_non_disabled_players + 1

				local pos = POSITION_LOOKUP[player_unit]
				local in_end_area = false

				for unit, data in pairs(self._end_level_areas) do
					local node = Unit.node(unit, data.object)
					local object_pos = Unit.world_position(unit, node)
					local object_rot = Unit.world_rotation(unit, node)
					local right, forward, up = Quaternion.right(object_rot), Quaternion.forward(object_rot), Quaternion.up(object_rot)
					local offset = data.offset:unbox()
					local center_pos = object_pos + right * offset.x + forward * offset.y + up * offset.z
					local extents = data.extents:unbox()
					local player_offset = pos - center_pos

					if abs(dot(player_offset, right)) < abs(extents.x) and abs(dot(player_offset, forward)) < abs(extents.y) and abs(dot(player_offset, up)) < abs(extents.z) then
						in_end_area = true

						break
					end
				end

				if not in_end_area then
					return false
				end
			end
		end

		return num_non_disabled_players > 0
	end
end

GameModeBase.get_end_screen_config = function (self, game_won, game_lost, player)
	-- function 60
	return "none", {}
end

GameModeBase.local_player_ready_to_start = function (self, player)
	-- function 61
	return true
end

GameModeBase.local_player_game_starts = function (self, player, loading_context)
	-- function 62
	return
end

GameModeBase.is_about_to_end_game_early = function (self)
	-- function 63
	return self._about_to_end_game_early
end

GameModeBase.set_about_to_end_game_early = function (self, about_to_end_game_early)
	-- function 64
	Managers.state.entity:system("dialogue_system"):set_global_context("game_about_to_end", about_to_end_game_early and 1 or not about_to_end_game_early and 0)

	self._about_to_end_game_early = about_to_end_game_early
end

GameModeBase.game_mode_hud_disabled = function (self)
	-- function 65
	return self._hud_disabled
end

GameModeBase.disable_hud = function (self, disable)
	-- function 66
	self._hud_disabled = disable
end

GameModeBase.photomode_enabled = function (self)
	-- function 67
	return self._photomode_enabled
end

GameModeBase.set_photomode_enabled = function (self, enabled)
	-- function 68
	self._photomode_enabled = enabled
end

GameModeBase.projectile_hit_character = function (self, attacker_player, source_attacker_unit, attacker_unit, hit_unit, hit_position, hit_breed, attack_direction, predicted_damage)
	-- function 69
	return
end

GameModeBase.is_reservable = function (self)
	-- function 70
	return true
end

GameModeBase.is_joinable = function (self)
	-- function 71
	return true
end
