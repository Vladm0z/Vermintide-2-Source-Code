-- chunkname: @scripts/managers/weave/weave_manager.lua

require("scripts/managers/conflict_director/weave_spawner")
require("scripts/settings/wind_settings")
require("scripts/settings/weave_settings")

local testify = script_data.testify

testify = not testify and require("scripts/managers/weave/weave_manager_testify")
WeaveManager = class(WeaveManager)

local tbl = {
	"rpc_set_active_weave",
	"rpc_weave_objective_completed",
	"rpc_weave_final_objective_completed",
	"rpc_sync_end_of_weave_data",
	"rpc_sync_player_count",
	"rpc_bar_cutoff_reached"
}
local tbl_2 = {
	"conflict_director_setup_done",
	"event_conflict_director_setup_done"
}

WeaveManager.init = function (self)
	-- function 1
	self:_reset()
end

WeaveManager.initiate = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	if arg_2_4 == "weave" then
		self:_setup_weave_data(arg_2_3)
		self:_setup_data(arg_2_1, arg_2_3)
		self:_register_events()
		self:_register_rpcs(arg_2_2)

		self._initiated = true
	else
		self:_reset()
	end
end

WeaveManager._reset = function (self)
	-- function 3
	self._world = nil
	self._initiated = false
	self._is_server = true
	self._bar_score = 0
	self._score = 0
	self._bar_filled = false
	self._objective_ui_mission_name = nil
	self._num_players = nil

	self:clear_weave_name()

	self._player_ids = {}
	self._saved_game_mode_data = {}
	self._remaining_time = WeaveSettings.starting_time
	self._damage_taken = 0
	self._weave_spawner = nil
	self._final_data_synced = false
	self._has_reset_challenge_stats = false
	self._pause_timer = true
	self._track_kills = false
	self._num_enemies_killed = 0
	self._enemies_killed = {}
	self._active_weave_phase = 1
end

WeaveManager.clear_weave_data = function (self)
	-- function 4
	self._bar_score = 0
	self._bar_filled = false
	self._remaining_time = WeaveSettings.starting_time
	self._damage_taken = 0
	self._final_data_synced = false
	self._active_weave_phase = 1

	table.clear(self._saved_game_mode_data)

	self._track_kills = false
	self._num_enemies_killed = 0

	table.clear(self._enemies_killed)
end

WeaveManager.clear_weave_name = function (self)
	-- function 5
	self._active_weave_name = nil
	self._next_weave_name = nil
	self._active_objective_index = nil
	self._next_objective_index = nil
end

WeaveManager._setup_data = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._world = arg_6_1
	self._is_server = arg_6_2
	self._bar_filled = false
	self._objective_ui_mission_name = nil
	self._next_weave_name = nil
	self._final_data_synced = false
	self._pause_timer = true
	self._next_objective_index = nil
	self._track_kills = false
	self._num_enemies_killed = 0

	table.clear(self._enemies_killed)

	if not self._is_server then
		self._weave_spawner = WeaveSpawner:new(self._world, nil)
	else
		self._weave_spawner = nil
	end
end

WeaveManager.weave_spawner = function (self)
	-- function 7
	return self._weave_spawner
end

WeaveManager._setup_weave_data = function (self, arg_8_1)
	-- function 8
	if not arg_8_1 then
		return
	end

	local _next_weave_name = self._next_weave_name

	_next_weave_name = _next_weave_name or Development.parameter("weave_name")

	local _next_objective_index = self._next_objective_index

	if not _next_objective_index then
		_next_objective_index = Development.parameter("weave_name")
		_next_objective_index = not _next_objective_index and 1
	end

	local _remaining_time = self._remaining_time

	_remaining_time = _remaining_time or WeaveSettings.starting_time

	local _damage_taken = self._damage_taken

	_damage_taken = _damage_taken or 0

	local _player_ids = self._player_ids

	self:_set_active_weave(_next_weave_name)
	self:_set_active_objective(_next_objective_index)
	self:_set_time_left(_remaining_time)
	self:_set_damage_taken(_damage_taken)
	self:_set_player_ids(_player_ids)
	self:_create_game_object()
	Development.set_parameter("weave_name", nil)
end

WeaveManager._register_events = function (arg_9_0)
	-- function 9
	Managers.state.event:register(arg_9_0, unpack(tbl_2))
end

WeaveManager._unregister_events = function (self)
	-- function 10
	local event = Managers.state.event

	if not event and not self._initiated then
		for i = 1, #tbl_2, 2 do
			local var_10_1 = tbl_2[i]

			event:unregister(var_10_1, self)
		end
	end
end

WeaveManager._register_rpcs = function (self, arg_11_1)
	-- function 11
	self._network_event_delegate = arg_11_1

	arg_11_1:register(self, unpack(tbl))
end

WeaveManager._unregister_rpcs = function (self)
	-- function 12
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end
end

WeaveManager.reset_statistics_for_challenges = function (self)
	-- function 13
	if not self._has_reset_challenge_stats then
		return
	end

	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()

	if ScorpionSeasonalSettings.current_season_id == 1 then
		local str = "weave_life_stepped_in_bush"

		statistics_db:set_stat(stats_id, "season_1", str, 0)

		local str_2 = "weave_death_hit_by_spirit"

		statistics_db:set_stat(stats_id, "season_1", str_2, 0)

		local str_3 = "weave_beasts_destroyed_totems"

		statistics_db:set_stat(stats_id, "season_1", str_3, 0)

		local str_4 = "weave_light_low_curse"

		statistics_db:set_stat(stats_id, "season_1", str_4, 0)

		local str_5 = "weave_shadow_kill_no_shrouded"

		statistics_db:set_stat(stats_id, "season_1", str_5, 0)
	end

	self._has_reset_challenge_stats = true
end

WeaveManager.teardown = function (self)
	-- function 14
	self:_unregister_rpcs()
	self:_unregister_events()

	self._go_id = nil
	self._initiated = false
end

WeaveManager.destroy = function (self)
	-- function 15
	self:_unregister_rpcs()
	self:_unregister_events()
end

WeaveManager.update = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end

	if not self._initiated then
		return
	end

	if not (not self:get_active_weave() and self._final_data_synced) then
		local get_active_objective_template = self:get_active_objective_template()

		if not self._is_server then
			if not self._pause_timer then
				self._remaining_time = math.max(self._remaining_time - arg_16_1, 0)
			end

			self._score = self:_calculate_score()
		end

		local game = Managers.state.network:game()

		if not game and not self._go_id then
			if not self._is_server then
				local floor = math.floor(self._remaining_time)

				GameSession.set_game_object_field(game, self._go_id, "remaining_time", floor)

				if not (not (self._bar_score >= get_active_objective_template.bar_cutoff) or self._bar_filled) then
					self:_objective_completed()
					Managers.state.network.network_transmit:send_rpc_clients("rpc_weave_objective_completed")
				end
			else
				self._remaining_time = GameSession.game_object_field(game, self._go_id, "remaining_time")
			end
		end

		if not (self._remaining_time ~= 0 or self._objective_ui_mission_name == "weave_time_out") then
			if not self._objective_ui_mission_name then
				Managers.state.event:trigger("ui_event_complete_mission", self._objective_ui_mission_name, true)
			end

			Managers.state.event:trigger("ui_event_add_mission_objective", "weave_time_out", Localize("weave_time_out"))

			self._objective_ui_mission_name = "weave_time_out"
		end

		if not self._weave_spawner then
			self._weave_spawner:update(arg_16_2, arg_16_1, get_active_objective_template)
		end
	end
end

WeaveManager.event_conflict_director_setup_done = function (self)
	-- function 17
	if not self:get_active_weave() and not self._is_server then
		local get_active_objective_template = self:get_active_objective_template()
		local flag = not get_active_objective_template and get_active_objective_template.spawning_seed

		if not flag then
			self._weave_spawner:set_seed(flag)
		end

		self._weave_spawner.conflict_director_setup_done = true
	end
end

WeaveManager._set_player_ids = function (self, arg_18_1)
	-- function 18
	if not arg_18_1 then
		return
	end

	self._player_ids = arg_18_1
end

WeaveManager.store_player_ids = function (self)
	-- function 19
	if not table.is_empty(self._player_ids) then
		return
	end

	local lobby = Managers.state.network:lobby()
	local get_members = lobby:members():get_members()

	for k, v in pairs(get_members) do
		self._player_ids[v] = true
	end

	local lobby_data = lobby:lobby_data("matchmaking")
	local lobby_data_2 = lobby:lobby_data("is_private")

	if lobby_data == "true" then
		self._num_players = 4
	elseif lobby_data_2 == "false" then
		self._num_players = 4
	else
		self._num_players = table.size(self._player_ids)
	end

	Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_player_count", self._num_players)
end

WeaveManager.get_saved_game_mode_data = function (self)
	-- function 20
	if not self._is_server then
		return
	end

	return table.clone(self._saved_game_mode_data)
end

WeaveManager.store_saved_game_mode_data = function (self)
	-- function 21
	if not self._is_server then
		return
	end

	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:get_saved_game_mode_data()

	if not game_mode then
		for k, v in pairs(game_mode) do
			v.spawn_state = nil
			v.position = nil
			v.rotation = nil
		end
	end

	self._saved_game_mode_data = game_mode
end

WeaveManager.get_player_ids = function (self)
	-- function 22
	return self._player_ids
end

WeaveManager.set_next_weave = function (self, arg_23_1)
	-- function 23
	self._next_weave_name = arg_23_1
end

WeaveManager.set_next_objective = function (self, arg_24_1)
	-- function 24
	self._next_objective_index = arg_24_1
end

WeaveManager.get_next_weave = function (self)
	-- function 25
	return self._next_weave_name
end

WeaveManager.get_next_objective = function (self)
	-- function 26
	return self._next_objective_index
end

WeaveManager.get_time_left = function (self)
	-- function 27
	return self._remaining_time
end

WeaveManager.get_damage_taken = function (self)
	-- function 28
	return self._damage_taken
end

WeaveManager._set_active_weave = function (self, arg_29_1)
	-- function 29
	self._active_weave_name = arg_29_1
end

WeaveManager._report_telemetry = function (self)
	-- function 30
	local get_active_wind = self:get_active_wind()
	local get_weave_tier = self:get_weave_tier()

	Managers.telemetry_events:weave_activated(get_active_wind, get_weave_tier)
end

WeaveManager._set_active_objective = function (self, arg_31_1)
	-- function 31
	self._active_objective_index = arg_31_1
end

WeaveManager.get_active_objective = function (self)
	-- function 32
	return self._active_objective_index
end

WeaveManager._set_time_left = function (self, arg_33_1)
	-- function 33
	self._remaining_time = arg_33_1
end

WeaveManager._set_damage_taken = function (self, arg_34_1)
	-- function 34
	self._damage_taken = arg_34_1
end

WeaveManager.get_active_weave = function (self)
	-- function 35
	return self._active_weave_name
end

WeaveManager.get_active_weave_phase = function (self)
	-- function 36
	return self._active_weave_phase
end

WeaveManager.set_active_weave_phase = function (self, arg_37_1)
	-- function 37
	self._active_weave_phase = arg_37_1
end

WeaveManager.get_active_wind = function (self)
	-- function 38
	if not self._active_weave_name then
		return
	end

	local var_38_0 = WeaveSettings.templates[self._active_weave_name]

	return not var_38_0 and var_38_0.wind
end

WeaveManager.get_active_wind_settings = function (self)
	-- function 39
	if not self._active_weave_name then
		return
	end

	local var_39_0 = WeaveSettings.templates[self._active_weave_name]
	local flag = not var_39_0 and var_39_0.wind

	return WindSettings[flag]
end

WeaveManager.get_scaling_value = function (self, arg_40_1)
	-- function 40
	local lobby = Managers.state.network:lobby()
	local flag = not lobby and lobby:lobby_data("weave_quick_game") == "true" or Managers.venture.quickplay:is_quick_game()
	local var_40_2 = WeaveSettings.templates[self._active_weave_name]
	local scaling_settings = var_40_2.scaling_settings
	local flag_2 = (not not flag or not scaling_settings) and scaling_settings[arg_40_1]
	local tier = var_40_2.tier
	local num = 0

	if not flag_2 then
		for i, v in ipairs(WeaveSettings.difficulty_increases) do
			if tier <= v.breakpoint then
				local num_2 = (tier - num) / (v.breakpoint - num)
				local var_40_8 = flag_2[1]
				local var_40_9 = flag_2[2]

				return (math.lerp(var_40_8, var_40_9, num_2))
			else
				num = v.breakpoint
			end
		end
	end

	return 0
end

WeaveManager.start_timer = function (self)
	-- function 41
	self._pause_timer = false
end

WeaveManager.calculate_next_objective_index = function (self)
	-- function 42
	if not self._active_weave_name then
		return
	end

	local _active_objective_index = self._active_objective_index

	if _active_objective_index == #WeaveSettings.templates[self._active_weave_name].objectives then
		return
	end

	return _active_objective_index + 1
end

WeaveManager.sync_end_of_weave_data = function (self)
	-- function 43
	self._final_data_synced = true

	local _score = self._score
	local _remaining_time = self._remaining_time
	local _num_players = self._num_players
	local _damage_taken = self._damage_taken

	Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_end_of_weave_data", _score, _remaining_time, _num_players, _damage_taken)
end

WeaveManager.hot_join_sync = function (self, arg_44_1)
	-- function 44
	if Managers.state.game_mode:game_mode_key() ~= "weave" then
		return
	end

	local network_transmit = Managers.state.network.network_transmit
	local _active_weave_name = self._active_weave_name

	if not _active_weave_name then
		local var_44_2 = NetworkLookup.weave_names[_active_weave_name]
		local _active_objective_index = self._active_objective_index

		network_transmit:send_rpc("rpc_set_active_weave", arg_44_1, var_44_2, _active_objective_index)
	end

	local _num_players = self._num_players

	if not _num_players then
		network_transmit:send_rpc("rpc_sync_player_count", arg_44_1, _num_players)
	end
end

local tbl_3 = {}

WeaveManager.mutators = function (self)
	-- function 45
	table.clear(tbl_3)

	local _active_weave_name = self._active_weave_name

	if not _active_weave_name then
		return tbl_3
	end

	local var_45_1 = WeaveSettings.templates[_active_weave_name]

	if var_45_1.wind_strength == 0 then
		return tbl_3
	end

	local wind = var_45_1.wind
	local mutator = WindSettings[wind].mutator

	tbl_3[#tbl_3 + 1] = mutator

	return tbl_3
end

WeaveManager.start_objective = function (self)
	-- function 46
	local get_active_objective_template = self:get_active_objective_template()
	local objective_start_flow_event = get_active_objective_template.objective_start_flow_event
	local objective_settings = get_active_objective_template.objective_settings
	local var_46_3 = ObjectiveLists[not objective_settings and objective_settings.objective_lists]

	if not objective_start_flow_event then
		LevelHelper:flow_event(self._world, objective_start_flow_event)
	end

	self._track_kills = get_active_objective_template.track_kills

	if not var_46_3 and not self._is_server then
		local system = Managers.state.entity:system("objective_system")

		system:server_register_objectives(objective_settings.objective_lists)
		system:server_activate_first_objective()
	end

	local display_name = get_active_objective_template.display_name

	Managers.state.event:trigger("ui_event_add_mission_objective", "objective", Localize(display_name))

	self._objective_ui_mission_name = "objective"

	Managers.state.event:trigger("weave_objective_synced")
	self:_report_telemetry()
end

WeaveManager.player_damaged = function (self, arg_47_1)
	-- function 47
	self._damage_taken = math.min(WeaveSettings.max_damage_taken, self._damage_taken + arg_47_1)
end

WeaveManager.current_bar_score = function (self)
	-- function 48
	local game = Managers.state.network:game()

	if not game and not self._go_id then
		local game_object_field = GameSession.game_object_field(game, self._go_id, "bar_score")
		local _bar_score = self._bar_score

		return not (game_object_field < _bar_score) or not _bar_score or game_object_field
	else
		return 0
	end
end

WeaveManager.increase_bar_score = function (self, arg_49_1)
	-- function 49
	fassert(self._is_server, "can't increase weave score as a client")

	local get_active_objective_template = self:get_active_objective_template()

	if not get_active_objective_template then
		local bar_multiplier = get_active_objective_template.bar_multiplier
		local bar_cutoff = get_active_objective_template.bar_cutoff

		arg_49_1 = arg_49_1 * bar_multiplier

		local game = Managers.state.network:game()

		if not game and not self._go_id then
			self._bar_score = math.min(math.max(self._bar_score + arg_49_1, 0), bar_cutoff)

			if self._bar_score == bar_cutoff then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_bar_cutoff_reached")
			end

			GameSession.set_game_object_field(game, self._go_id, "bar_score", self._bar_score)
		end
	end
end

WeaveManager.show_bar = function (self)
	-- function 50
	local get_active_objective_template = self:get_active_objective_template()

	if not (not get_active_objective_template and not get_active_objective_template.show_bar and self._bar_filled) then
		return true
	end

	return false
end

WeaveManager.get_active_objective_template = function (self)
	-- function 51
	if not self._active_objective_index then
		return
	end

	local _active_objective_index = self._active_objective_index

	return WeaveSettings.templates[self._active_weave_name].objectives[_active_objective_index]
end

WeaveManager.get_scaling_difficulty_index = function (arg_52_0)
	-- function 52
	return
end

WeaveManager.get_active_weave_template = function (self)
	-- function 53
	if not self._active_weave_name then
		return
	end

	return WeaveSettings.templates[self._active_weave_name]
end

WeaveManager.start_terror_event = function (self, arg_54_1, arg_54_2)
	-- function 54
	local get_active_weave_template = self:get_active_weave_template()
	local get_active_objective_template = self:get_active_objective_template()
	local _active_objective_index = self._active_objective_index

	fassert(get_active_weave_template ~= nil, "Tried to start terror event from WeaveManager without any active weave")
	fassert(get_active_objective_template.terror_events ~= nil, string.format("%q does not contain a terror_events table for objective %s", get_active_weave_template.name, _active_objective_index))
	fassert(table.contains(get_active_objective_template.terror_events, arg_54_1), string.format("%q's terror_event table does not contain terror event '%q'", get_active_weave_template.name, arg_54_1))
	self._weave_spawner:start_terror_event_from_template(arg_54_1, arg_54_2)
end

WeaveManager.stop_terror_event = function (self, arg_55_1, arg_55_2)
	-- function 55
	local get_active_weave_template = self:get_active_weave_template()
	local get_active_objective_template = self:get_active_objective_template()
	local _active_objective_index = self._active_objective_index

	fassert(get_active_weave_template ~= nil, "Tried to start terror event from WeaveManager without any active weave")
	fassert(get_active_objective_template.terror_events ~= nil, string.format("%q does not contain a terror_events table for objective %s", get_active_weave_template.name, _active_objective_index))
	fassert(table.contains(get_active_objective_template.terror_events, arg_55_1), string.format("%q's terror_event table does not contain terror event '%q'", get_active_weave_template.name, arg_55_1))

	local format = string.format("%s_%s", arg_55_1, arg_55_2)

	TerrorEventMixer.stop_event(format)
end

WeaveManager.get_wind_strength = function (self)
	-- function 56
	local var_56_0 = WeaveSettings.templates[self._active_weave_name]
	local wind_strength

	if not var_56_0 then
		wind_strength = var_56_0.wind_strength

		if not wind_strength then
			-- Nothing
		end
	end

	wind_strength = 1

	::label_56_0::

	return wind_strength
end

WeaveManager._create_game_object = function (self)
	-- function 57
	local tbl = {
		go_type = NetworkLookup.go_types.weave,
		bar_score = self._bar_score,
		remaining_time = self._remaining_time
	}
	local var_57_1 = callback(self, "cb_game_session_disconnect")

	self._go_id = Managers.state.network:create_game_object("weave", tbl, var_57_1)
end

WeaveManager.game_object_created = function (self, arg_58_1)
	-- function 58
	self._go_id = arg_58_1
end

WeaveManager.game_object_destroyed = function (self)
	-- function 59
	self._go_id = nil
end

WeaveManager.cb_game_session_disconnect = function (self)
	-- function 60
	self._go_id = nil
end

WeaveManager.final_objective_completed = function (self)
	-- function 61
	if not self._is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_weave_final_objective_completed")

		self._pause_timer = true
	end

	if not self._objective_ui_mission_name then
		Managers.state.event:trigger("ui_event_complete_mission", self._objective_ui_mission_name, true)
	end

	local wwise_world = Managers.world:wwise_world(self._world)

	WwiseWorld.trigger_event(wwise_world, "Play_hud_wind_objectives_complete")
	Managers.state.event:trigger("ui_event_add_mission_objective", "weave_victory", Localize("weave_victory"))

	self._objective_ui_mission_name = "weave_victory"
end

WeaveManager._objective_completed = function (self)
	-- function 62
	self._bar_filled = true

	local get_active_objective_template = self:get_active_objective_template()
	local objective_completed_flow_event = get_active_objective_template.objective_completed_flow_event

	if not objective_completed_flow_event then
		LevelHelper:flow_event(self._world, objective_completed_flow_event)
	end

	local end_zone_name = get_active_objective_template.end_zone_name

	if not end_zone_name then
		Managers.state.entity:system("end_zone_system"):activate_end_zone_by_name(end_zone_name)
	end

	if not self._objective_ui_mission_name then
		Managers.state.event:trigger("ui_event_complete_mission", self._objective_ui_mission_name)
	end

	local calculate_next_objective_index = self:calculate_next_objective_index()
	local objectives = WeaveSettings.templates[self._active_weave_name].objectives
	local bonus_time_on_complete = get_active_objective_template.bonus_time_on_complete

	if (self:get_time_left() <= 0 or not bonus_time_on_complete) and not self._is_server then
		self._remaining_time = self._remaining_time + bonus_time_on_complete
	end

	if calculate_next_objective_index == #objectives then
		local wwise_world = Managers.world:wwise_world(self._world)

		WwiseWorld.trigger_event(wwise_world, "Play_hud_wind_objectives_complete")

		local var_62_7 = Localize("reach_final_challenge_text")

		if not bonus_time_on_complete then
			local max = math.max(bonus_time_on_complete, 0)
			local floor = math.floor(max / 60)
			local floor_2 = math.floor(floor / 60)
			local format = string.format("%d:%02d", floor - floor_2 * 60, max % 60)

			var_62_7 = var_62_7 .. "\n+" .. format
		end

		Managers.state.event:trigger("ui_event_add_mission_objective", "objective_complete", var_62_7)

		self._objective_ui_mission_name = "objective_complete"
	end

	Managers.state.entity:system("objective_system"):deactivate_all_objectives()
end

WeaveManager._calculate_score = function (self)
	-- function 63
	local num = WeaveSettings.max_damage_taken - self._damage_taken
	local num_2 = self._remaining_time * WeaveSettings.time_score_weighting

	return (math.floor(math.max(num_2 + num, 0) * 10))
end

WeaveManager.get_bar_score = function (self)
	-- function 64
	return self._bar_score
end

WeaveManager.get_score = function (self)
	-- function 65
	return self._score
end

WeaveManager.get_time_score = function (self)
	-- function 66
	return math.floor(math.max(self:get_score() - self:get_damage_score(), 0))
end

WeaveManager.get_damage_score = function (self)
	-- function 67
	return math.floor((WeaveSettings.max_damage_taken - self._damage_taken) * 10)
end

WeaveManager.get_weave_tier = function (self)
	-- function 68
	return WeaveSettings.templates[self._active_weave_name].tier
end

WeaveManager.get_num_players = function (self)
	-- function 69
	return self._num_players
end

WeaveManager.is_tracking_kills = function (self)
	-- function 70
	return self._track_kills
end

WeaveManager.ai_killed = function (self, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
	-- function 71
	if not self._track_kills then
		self:_track_ai_killed(arg_71_3.breed.name)
	end

	Managers.state.entity:system("objective_system"):on_ai_killed(arg_71_1, arg_71_2, arg_71_3, arg_71_4)
end

WeaveManager._track_ai_killed = function (self, arg_72_1)
	-- function 72
	if not self._is_server then
		local _enemies_killed = self._enemies_killed
		local var_72_1 = self._enemies_killed[arg_72_1]

		var_72_1 = var_72_1 or 0
		_enemies_killed[arg_72_1] = var_72_1
		self._enemies_killed[arg_72_1] = self._enemies_killed[arg_72_1] + 1
		self._num_enemies_killed = self._num_enemies_killed + 1

		local get_difficulty = Managers.state.difficulty:get_difficulty()
		local get_active_objective_template = self:get_active_objective_template()

		if get_active_objective_template == nil then
			return
		end

		local num = 1 / get_active_objective_template.enemy_count[get_difficulty] * 100

		self:increase_bar_score(num)
	end
end

WeaveManager.objective_set_completed = function (arg_73_0)
	-- function 73
	local system = Managers.state.entity:system("mission_system")
	local get_missions = system:get_missions()

	if not get_missions and not get_missions.weave_collect_limited_item_objective then
		system:end_mission("weave_collect_limited_item_objective", true)
	end
end

WeaveManager.rpc_bar_cutoff_reached = function (self, arg_74_1)
	-- function 74
	self._bar_score = self:get_active_objective_template().bar_cutoff
end

WeaveManager.rpc_set_active_weave = function (self, arg_75_1, arg_75_2, arg_75_3)
	-- function 75
	local var_75_0 = NetworkLookup.weave_names[arg_75_2]

	self:reset_statistics_for_challenges()
	self:_set_active_weave(var_75_0)
	self:_set_active_objective(arg_75_3)
	self:start_objective()
	Managers.state.event:trigger("weave_objective_synced")
end

WeaveManager.rpc_weave_objective_completed = function (self, arg_76_1)
	-- function 76
	self:_objective_completed()
end

WeaveManager.rpc_sync_end_of_weave_data = function (self, arg_77_1, arg_77_2, arg_77_3, arg_77_4, arg_77_5)
	-- function 77
	self._score = arg_77_2
	self._remaining_time = arg_77_3
	self._num_players = arg_77_4
	self._damage_taken = arg_77_5
end

WeaveManager.rpc_sync_player_count = function (self, arg_78_1, arg_78_2)
	-- function 78
	self._num_players = arg_78_2
end

WeaveManager.rpc_weave_final_objective_completed = function (self, arg_79_1)
	-- function 79
	self:final_objective_completed()
end
