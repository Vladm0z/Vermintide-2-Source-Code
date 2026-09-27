-- chunkname: @scripts/managers/game_mode/versus_win_conditions.lua

local testify = script_data.testify

testify = not testify and require("scripts/managers/game_mode/versus_win_conditions_testify")

local scripts_entity_system_systems_objective_objective_types = require("scripts/entity_system/systems/objective/objective_types")
local carousel = DLCSettings.carousel

VersusWinConditions = class(VersusWinConditions)

local tbl = {
	"rpc_versus_set_score"
}

VersusWinConditions.init = function (self, arg_1_1)
	-- function 1
	self._current_round = 0
	self._current_set = 0
	self._win_data = {}
	self.mechanism = arg_1_1
	self._round_almost_over_time_breakpoint = GameModeSettings.versus.round_almost_over_time_breakpoint
	self._distance_to_winning_objective_breakpoint = GameModeSettings.versus.distance_to_winning_objective_breakpoint
	self._num_sections_completed = 0
	self.party_won_early = nil
	self._current_objective_marker_positions = {}
	self._early_win_data = {}
end

VersusWinConditions._reset_set_score = function (self, arg_2_1)
	-- function 2
	local var_2_0 = VersusObjectiveSettings[arg_2_1]

	if not var_2_0 then
		local num_sets = var_2_0.num_sets

		self._has_objectives = false

		local parties = Managers.party:parties()

		for i = 1, #parties do
			if not parties[i].game_participating then
				local tbl = {}

				for j = 1, num_sets do
					local var_2_4 = ObjectiveLists[var_2_0.objective_lists[j]]

					tbl[j] = {
						distance_traveled = 0,
						claimed_points = 0,
						max_points = var_2_4.max_score
					}
					self._has_objectives = true
				end

				self._win_data[i] = tbl
			end
		end

		self._set_score_is_setup = true
	end
end

VersusWinConditions.hot_join_sync = function (self, arg_3_1)
	-- function 3
	local _current_round = self._current_round
	local _current_set = self._current_set
	local var_3_2 = PEER_ID_TO_CHANNEL[arg_3_1]

	for k, v in pairs(self._win_data) do
		local var_3_3 = self._win_data[k]

		for k_2 = 1, #var_3_3 do
			local var_3_4 = var_3_3[k_2]

			RPC.rpc_versus_set_score(var_3_2, k, var_3_4.claimed_points, k_2, _current_set, _current_round)
		end
	end
end

VersusWinConditions.register_rpcs = function (self, arg_4_1, arg_4_2)
	-- function 4
	arg_4_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_4_1
end

VersusWinConditions.unregister_rpcs = function (self)
	-- function 5
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

VersusWinConditions.setup_round = function (self, arg_6_1)
	-- function 6
	local get_objective_settings = self.mechanism:get_objective_settings()
	local round_timer = get_objective_settings.round_timer

	round_timer = round_timer or 36000
	self._round_timer = round_timer
	self._early_win_enabled = true

	if not self.mechanism:custom_settings_enabled() then
		self._early_win_enabled = self.mechanism:get_custom_game_setting("early_win_enabled")

		local get_custom_game_setting = self.mechanism:get_custom_game_setting("round_time_limit")

		if not get_custom_game_setting then
			self._round_timer = get_custom_game_setting * 60
			self._custom_round_time_limit = true
		end
	end

	self._is_server = arg_6_1
	self._current_round = self._current_round + 1

	if self._current_round % 2 == 1 then
		self._current_set = self._current_set + 1
	end

	local is_last_set = self.mechanism:is_last_set()

	is_last_set = not is_last_set and self.mechanism:get_state() == "round_2"
	self._final_round = is_last_set
	self._round_over = false
	self._level_id = get_objective_settings.level_id
	self._level_id = Managers.level_transition_handler:get_current_level_key()
	self._current_level_progress = 0
	self._round_started = false
	self._heroes_close_to_winning = false
	self._heroes_close_to_safe_zone = false
	self._num_sections_completed = 0
	self._pactsworn_party_id = Managers.state.side:get_side_from_name("dark_pact").party.party_id
	self._hero_party_id = Managers.state.side:get_side_from_name("heroes").party.party_id

	if not (self._current_round == 1 or self._set_score_is_setup) then
		self:_reset_set_score(self._level_id)
	end

	Managers.state.event:register(self, "gm_event_round_started", "on_round_started")
	Managers.state.event:register(self, "gm_event_end_conditions_met", "on_end_conditions_met")
	Managers.state.event:register(self, "gm_event_initial_peers_spawned", "on_initial_peers_spawned")
	Managers.state.event:register(self, "objective_completed", "on_objective_completed")
	Managers.state.event:register(self, "obj_objective_section_completed", "on_objective_section_completed")
end

VersusWinConditions.on_game_mode_data_created = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._game_session = arg_7_1
	self._go_id = arg_7_2

	if not (not arg_7_1 and self._is_server) then
		self._round_timer = GameSession.game_object_field(arg_7_1, arg_7_2, "round_timer")
	end
end

VersusWinConditions.round_ended = function (arg_8_0)
	-- function 8
	return
end

VersusWinConditions.on_game_mode_data_destroyed = function (self)
	-- function 9
	self._game_session = nil
	self._go_id = nil
	self._round_timer = nil
end

VersusWinConditions.server_update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not script_data.testify then
		self:update_testify(arg_10_2, arg_10_1)
	end

	self:_server_update_round_timer(arg_10_2)

	if not Managers.state.game_mode:is_round_started() then
		self:update_early_win_conditions()
	end
end

VersusWinConditions._server_update_round_timer = function (self, arg_11_1)
	-- function 11
	if not self._round_started then
		return
	end

	local game_session = Network.game_session()

	if not game_session then
		return
	end

	self._round_timer = math.max(self._round_timer - arg_11_1, 0)

	GameSession.set_game_object_field(game_session, self._go_id, "round_timer", self._round_timer)

	if not self._custom_round_time_limit then
		self:custom_game_round_timer()
	end
end

VersusWinConditions.client_update = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not script_data.testify then
		self:update_testify(arg_12_2, arg_12_1)
	end

	if not self._go_id then
		return
	end

	if not self._round_started then
		return
	end

	local game_session = Network.game_session()

	if not game_session then
		return
	end

	self._round_timer = GameSession.game_object_field(game_session, self._go_id, "round_timer")
	self._heroes_close_to_winning = GameSession.game_object_field(game_session, self._go_id, "heroes_close_to_winning")
	self._heroes_close_to_safe_zone = GameSession.game_object_field(game_session, self._go_id, "heroes_close_to_safe_zone")

	if not script_data.debug_early_win then
		Debug.text("Heroes about to win: %s", self._heroes_close_to_winning)
	end

	if not self._custom_round_time_limit then
		self:custom_game_round_timer()
	end
end

VersusWinConditions.is_heroes_close_to_win = function (self)
	-- function 13
	return self._close_to_winning
end

VersusWinConditions.on_round_started = function (self)
	-- function 14
	self._round_started = true

	if not self._is_server then
		local game_session = Network.game_session()

		GameSession.set_game_object_field(game_session, self._go_id, "round_timer", self._round_timer)
	end
end

VersusWinConditions.on_end_conditions_met = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	self._round_over = true

	Managers.state.event:unregister("gm_event_round_started", self)
	Managers.state.event:unregister("gm_event_end_conditions_met", self)
	Managers.state.event:unregister("gm_event_initial_peers_spawned", self)
	Managers.state.event:unregister("obj_objective_section_completed", self)
	Managers.state.event:unregister("objective_completed", self)

	local tbl = {}
	local player = Managers.player

	for k, v in pairs(arg_15_3) do
		local player_from_unique_id = player:player_from_unique_id(k)

		if not player_from_unique_id then
			local get_party = player_from_unique_id:get_party()
			local var_15_4 = tbl[get_party.party_id]

			var_15_4 = var_15_4 or {
				distance = 0,
				num_players = 0
			}
			var_15_4.num_players = var_15_4.num_players + 1
			var_15_4.distance = var_15_4.distance + v
			tbl[get_party.party_id] = var_15_4
		end
	end

	local get_current_set = self.mechanism:get_current_set()

	for k_2, v_2 in pairs(tbl) do
		self._win_data[k_2][get_current_set].distance_traveled = v_2.distance / v_2.num_players
	end
end

VersusWinConditions.current_set_data = function (self, arg_16_1)
	-- function 16
	local var_16_0 = self._win_data[arg_16_1]

	if not var_16_0 then
		return
	end

	local get_current_set = self.mechanism:get_current_set()

	return var_16_0[get_current_set], get_current_set
end

VersusWinConditions.get_sets_data_for_party = function (self, arg_17_1)
	-- function 17
	local var_17_0 = self._win_data[arg_17_1]

	if not var_17_0 then
		return nil
	end

	return var_17_0
end

VersusWinConditions.on_initial_peers_spawned = function (self)
	-- function 18
	self._objective_system = Managers.state.entity:system("objective_system")
end

VersusWinConditions.on_objective_completed = function (self, arg_19_1, arg_19_2)
	-- function 19
	Managers.state.achievement:trigger_event("register_objective_completed", arg_19_2, self._hero_party_id, arg_19_1)

	if not self._is_server then
		return
	end

	self._main_path_distance_to_winning_objective = nil

	self:add_time(arg_19_1:get_time_for_completion())
	self:add_score(arg_19_1:get_score_for_completion(), arg_19_1)

	local _get_current_objective_data = self:_get_current_objective_data()

	if not _get_current_objective_data and not _get_current_objective_data.close_to_win_on_sub_objective then
		self._num_sections_completed = self._num_sections_completed + 1
	end

	if not self._heroes_close_to_winning then
		self:_check_heroes_close_to_win_conditions_met()
	end

	local _has_nested_parent_objectives = self:_has_nested_parent_objectives(arg_19_2)

	if not (arg_19_1:get_total_sections() > 1 or _has_nested_parent_objectives) then
		self._objective_system:objective_section_completed_telemetry()
	end
end

VersusWinConditions._get_current_objective_data = function (arg_20_0)
	-- function 20
	local get_current_objective_data = Managers.state.game_mode:game_mode():get_current_objective_data()
	local var_20_1, var_20_2 = next(get_current_objective_data)

	return var_20_2
end

VersusWinConditions._get_next_objective_data = function (arg_21_0)
	-- function 21
	local get_next_objective_data = Managers.state.game_mode:game_mode():get_next_objective_data()

	if not get_next_objective_data then
		return
	end

	local var_21_1, var_21_2 = next(get_next_objective_data)

	return var_21_2
end

VersusWinConditions.on_objective_section_completed = function (self, arg_22_1)
	-- function 22
	if not self._is_server then
		return
	end

	self:add_time(arg_22_1:get_time_per_section())
	self:add_score(arg_22_1:get_score_per_section(), arg_22_1)

	local get_current_section = arg_22_1:get_current_section()
	local get_total_sections = arg_22_1:get_total_sections()

	if not self._heroes_close_to_winning then
		self:_check_heroes_close_to_win_conditions_met(get_current_section, get_total_sections)
	end

	if get_total_sections > 1 then
		self._objective_system:objective_section_completed_telemetry(get_current_section, get_total_sections)
	end
end

VersusWinConditions._check_heroes_close_to_win_conditions_met = function (self, arg_23_1, arg_23_2)
	-- function 23
	local _get_hero_early_win_data = self:_get_hero_early_win_data(false)
	local var_23_1
	local var_23_2

	if not (not arg_23_1 and not arg_23_2 and not (arg_23_1 < arg_23_2)) then
		var_23_1 = self:_get_current_objective_data()
	else
		var_23_1 = self:_get_next_objective_data()
	end

	if not var_23_1 then
		return
	end

	local _has_nested_parent_objectives, var_23_4 = self:_has_nested_parent_objectives(var_23_1)

	if not _has_nested_parent_objectives then
		local var_23_5, var_23_6 = next(var_23_1.sub_objectives)

		var_23_2 = var_23_6.score_for_completion
		arg_23_2 = var_23_4
	end

	arg_23_2 = arg_23_2 or var_23_1.num_sockets or var_23_1.num_sections or nil
	var_23_2 = var_23_2 or var_23_1.score_per_section or var_23_1.score_per_socket or nil

	local flag = not arg_23_2 and not var_23_2 and arg_23_2 >= 10
	local num = 0
	local other_party_score_potential = _get_hero_early_win_data.other_party_score_potential

	if not var_23_1.score_for_completion then
		num = _get_hero_early_win_data.score + var_23_1.score_for_completion
	elseif not flag then
		local num_2 = _get_hero_early_win_data.score + var_23_2 * arg_23_2
		local _num_sections_completed = self._num_sections_completed

		_num_sections_completed = _num_sections_completed or 0 * var_23_2
		num = num_2 - _num_sections_completed
	elseif not arg_23_2 and not var_23_2 and not arg_23_2 then
		num = _get_hero_early_win_data.score + var_23_2
	end

	local flag_2 = other_party_score_potential < num

	if not script_data.debug_early_win then
		Debug.text("Potential score needed for close to win: %s / %s", num, other_party_score_potential)
		Debug.text("Heroes about to win: %s", flag_2)
	end

	local _get_current_objective_data = self:_get_current_objective_data()
	local flag_3 = not _get_current_objective_data and _get_current_objective_data.close_to_win_on_sub_objective

	if not (flag_2 or self._heroes_close_to_safe_zone) then
		if not var_23_1.close_to_win_on_completion then
			self._heroes_close_to_safe_zone = true
		elseif not flag_3 then
			local _num_sections_completed_2 = self._num_sections_completed

			_num_sections_completed_2 = _num_sections_completed_2 or 0
			self._heroes_close_to_safe_zone = _num_sections_completed_2 >= _get_current_objective_data.close_to_win_on_sub_objective
		elseif not var_23_1.close_to_win_on_section then
			self._heroes_close_to_safe_zone = self._num_sections_completed >= var_23_1.close_to_win_on_section
		elseif not (not var_23_1.objective_type and var_23_1.objective_type ~= scripts_entity_system_systems_objective_objective_types.objective_safehouse) then
			self._heroes_close_to_safe_zone = true
		end
	end

	if not self._heroes_close_to_safe_zone then
		local game_session = Network.game_session()

		GameSession.set_game_object_field(game_session, self._go_id, "heroes_close_to_safe_zone", true)
	end

	if not flag_2 then
		self:_trigger_about_to_early_win_vo()

		self._heroes_close_to_winning = true

		local game_session_2 = Network.game_session()

		GameSession.set_game_object_field(game_session_2, self._go_id, "heroes_close_to_winning", true)
	end
end

VersusWinConditions._trigger_about_to_early_win_vo = function (self)
	-- function 24
	if not Managers.state.game_mode:game_mode():is_about_to_end_game_early() then
		return
	end

	if not self._about_to_early_win_vo_played then
		return
	end

	self._about_to_early_win_vo_played = true

	local system = Managers.state.entity:system("dialogue_system")

	system:queue_mission_giver_event("vs_mg_about_to_early_win", nil, "heroes")
	system:queue_mission_giver_event("vs_mg_about_to_early_loss", nil, "dark_pact")
end

VersusWinConditions._has_nested_parent_objectives = function (arg_25_0, arg_25_1)
	-- function 25
	if not arg_25_1.sub_objectives then
		return false
	end

	local size = table.size(arg_25_1.sub_objectives)
	local var_25_1, var_25_2 = next(arg_25_1.sub_objectives)

	return var_25_2.sub_objectives, not var_25_2.sub_objectives and size and nil
end

VersusWinConditions.rpc_versus_set_score = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	-- function 26
	if arg_26_5 ~= 0 then
		self._current_set = arg_26_5
	end

	if arg_26_6 ~= 0 then
		self._current_round = arg_26_6
	end

	local var_26_0 = self._win_data[arg_26_2]

	if not var_26_0 then
		return
	end

	var_26_0[arg_26_4].claimed_points = arg_26_3

	Presence.set_presence("score", PresenceHelper.get_game_score())
end

VersusWinConditions.is_round_timer_started = function (self)
	-- function 27
	return self._round_started
end

VersusWinConditions.is_round_timer_over = function (self)
	-- function 28
	return self._round_timer <= 0
end

VersusWinConditions.is_round_almost_over = function (self)
	-- function 29
	return self._round_timer <= self._round_almost_over_time_breakpoint
end

VersusWinConditions.heroes_close_to_safe_zone = function (self)
	-- function 30
	return self._heroes_close_to_safe_zone
end

VersusWinConditions.round_timer = function (self)
	-- function 31
	return self._round_timer
end

VersusWinConditions._get_round_timer_formatted = function (self)
	-- function 32
	if not self._round_timer then
		return
	end

	local floor = math.floor(self._round_timer / 60)
	local floor_2 = math.floor(self._round_timer % 60)

	if floor_2 < 10 then
		floor_2 = string.format("0%s", floor_2)
	end

	if floor < 10 then
		floor = string.format("0%s", floor)
	end

	return string.format("%s:%s", floor, floor_2)
end

VersusWinConditions.custom_game_round_timer = function (self)
	-- function 33
	if not self:is_round_timer_started() then
		local _get_round_timer_formatted = self:_get_round_timer_formatted()

		if self._formatted_round_timer ~= _get_round_timer_formatted then
			Managers.state.event:trigger("ui_update_round_timer", self:_get_round_timer_formatted())

			self._formatted_round_timer = _get_round_timer_formatted
		end
	end
end

VersusWinConditions.is_final_round = function (self)
	-- function 34
	return self._final_round
end

VersusWinConditions.get_current_round = function (self)
	-- function 35
	return self._current_round
end

VersusWinConditions.add_time = function (self, arg_36_1)
	-- function 36
	self._round_timer = self._round_timer + arg_36_1

	local game_session = Network.game_session()

	GameSession.set_game_object_field(game_session, self._go_id, "round_timer", self._round_timer)
end

VersusWinConditions.set_time = function (self, arg_37_1)
	-- function 37
	self._round_timer = arg_37_1

	local game_session = Network.game_session()

	GameSession.set_game_object_field(game_session, self._go_id, "round_timer", self._round_timer)
end

VersusWinConditions.add_score = function (self, arg_38_1, arg_38_2)
	-- function 38
	if not self._is_server then
		self:_add_points_collected(self._hero_party_id, arg_38_1)

		if not DEDICATED_SERVER then
			Presence.set_presence("score", PresenceHelper.get_game_score())
		end

		self:play_score_sfx(arg_38_2)
	end
end

VersusWinConditions.set_data = function (self, arg_39_1)
	-- function 39
	local var_39_0 = self._win_data[arg_39_1]

	var_39_0 = var_39_0 or {}

	return var_39_0
end

VersusWinConditions.play_score_sfx = function (self, arg_40_1)
	-- function 40
	local str = "Play_hud_versus_score_points"

	if not self._early_win_enabled then
		local versus_close_to_win_score_ticks = carousel.versus_close_to_win_score_ticks
		local _get_hero_early_win_data = self:_get_hero_early_win_data(false)
		local num = _get_hero_early_win_data.other_party_score_potential - _get_hero_early_win_data.score + 1
		local num_2 = 0
		local get_num_sections_left = arg_40_1:get_num_sections_left()
		local get_score_per_section = arg_40_1:get_score_per_section()
		local get_remaining_objectives_list = self._objective_system:get_remaining_objectives_list()
		local count = #versus_close_to_win_score_ticks
		local num_3 = 0

		if not (not (get_num_sections_left > 0) or not (get_score_per_section > 0)) then
			for i = 1, get_num_sections_left do
				num_2 = num_2 + 1
				num = num - get_score_per_section
				num_3 = num_3 + 1

				if not (num <= 0 or num_3 ~= count) then
					break
				end
			end
		end

		if num > 0 then
			for i_2, v in ipairs(get_remaining_objectives_list) do
				local var_40_10, var_40_11 = next(v)
				local score_per_section = var_40_11.score_per_section

				if not score_per_section then
					score_per_section = var_40_11.score_per_socket

					if not score_per_section then
						score_per_section = var_40_11.score_for_completion
						score_per_section = score_per_section or 0
					end
				end

				local num_sockets = var_40_11.num_sockets

				if not num_sockets then
					num_sockets = var_40_11.num_sections
					num_sockets = num_sockets or 1
				end

				for l = 1, num_sockets do
					num = num - score_per_section
					num_2 = num_2 + 1
					num_3 = num_3 + 1

					if not (num <= 0 or num_3 ~= count) then
						break
					end
				end

				if not (num <= 0 or num_3 ~= count) then
					break
				end
			end
		end

		if not (num <= 0) or not versus_close_to_win_score_ticks[num_2 + 1] then
			str = versus_close_to_win_score_ticks[num_2 + 1]
		end
	end

	local var_40_14 = NetworkLookup.sound_events[str]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_play_2d_audio_event", var_40_14)

	if not DEDICATED_SERVER then
		local world = Managers.world:world("level_world")
		local wwise_world = Managers.world:wwise_world(world)

		WwiseWorld.trigger_event(wwise_world, str)
	end
end

VersusWinConditions._add_points_collected = function (self, arg_41_1, arg_41_2)
	-- function 41
	local current_set_data, var_41_1 = self:current_set_data(arg_41_1)

	if not current_set_data then
		return
	end

	local _current_set = self._current_set
	local _current_round = self._current_round

	current_set_data.claimed_points = current_set_data.claimed_points + arg_41_2

	Managers.state.network.network_transmit:send_rpc_clients("rpc_versus_set_score", arg_41_1, current_set_data.claimed_points, var_41_1, _current_set, _current_round)
end

VersusWinConditions.save_points_collected = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local var_42_0 = self._win_data[arg_42_1]

	if not var_42_0 then
		return
	end

	var_42_0[arg_42_2].claimed_points = arg_42_3
end

VersusWinConditions.update_early_win_conditions = function (self)
	-- function 43
	if not self._early_win_enabled then
		return
	end

	if not self._has_objectives then
		return
	end

	if not script_data.debug_early_win and not Network.game_session() then
		self:_check_heroes_close_to_win_conditions_met()
	end

	local _get_hero_early_win_data = self:_get_hero_early_win_data(false)
	local flag = _get_hero_early_win_data.score > _get_hero_early_win_data.other_party_score_potential
	local flag_2 = _get_hero_early_win_data.score_potential < _get_hero_early_win_data.other_party_score

	if not self.party_won_early then
		if flag or not flag_2 then
			table.dump(_get_hero_early_win_data, "self.party_won_early")
		end

		if not flag then
			self.party_won_early = _get_hero_early_win_data
		elseif not flag_2 then
			local flag_3

			flag_3 = self._hero_party_id ~= 1 or not 2 or 1
			self.party_won_early = {
				party_id = flag_3,
				score = _get_hero_early_win_data.other_score,
				score_potential = _get_hero_early_win_data.other_party_score_potential,
				other_party_score = _get_hero_early_win_data.score,
				other_party_score_potential = _get_hero_early_win_data.score_potential
			}

			table.dump(self.party_won_early, "pactsworn_early_win_data")
		end

		if not self.party_won_early then
			local printf = printf
			local str = "[VersusWinConditions] Party %s (%s) won early due to score %s being higher than opponent potential score %s"
			local party_id = self.party_won_early.party_id
			local flag_4

			flag_4 = self.party_won_early.party_id ~= self._hero_party_id or not "heroes" or "pact_sworn"

			printf(str, party_id, flag_4, self.party_won_early.score, self.party_won_early.other_party_score_potential)
			self:_get_hero_early_win_data(true)
		end
	end

	return flag or flag_2, self.party_won_early
end

local num = 10

VersusWinConditions._get_hero_early_win_data = function (self, arg_44_1)
	-- function 44
	local _hero_party_id = self._hero_party_id
	local get_current_set = self.mechanism:get_current_set()
	local flag

	flag = _hero_party_id ~= 1 or not 2 or 1

	local get_total_score = self:get_total_score(_hero_party_id)
	local get_total_score_2 = self:get_total_score(flag)
	local get_party = Managers.party:get_party(_hero_party_id)
	local num_2 = 0
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name(get_party.name).PLAYER_AND_BOT_UNITS
	local num_3 = get_party.num_slots - #PLAYER_AND_BOT_UNITS

	if num_3 > 0 then
		num_2 = num_3 * num

		if not arg_44_1 then
			printf("[VersusWinConditions] There are %s dead heroes resulting in %s less potential score", num_3, num_2)
		end
	end

	local var_44_9 = self._win_data[_hero_party_id]
	local max_points = var_44_9[get_current_set].max_points

	if not arg_44_1 then
		printf("[VersusWinConditions] Counting %s hero points from set %s", max_points, get_current_set)
	end

	for i = get_current_set + 1, #var_44_9 do
		local num_4 = var_44_9[i].max_points - var_44_9[i].claimed_points

		max_points = max_points + num_4

		if not arg_44_1 then
			printf("[VersusWinConditions] Counting %s hero points from set %s", num_4, i)
		end
	end

	local num_5 = get_total_score + max_points - num_2

	if not arg_44_1 then
		printf("[VersusWinConditions] Counted %s potential score for heroes", num_5)
	end

	local var_44_13 = self._win_data[flag]
	local num_6 = 0

	if self._current_round % 2 == 1 then
		local num_7 = var_44_13[get_current_set].max_points - var_44_13[get_current_set].claimed_points

		num_6 = num_6 + num_7

		if not arg_44_1 then
			printf("[VersusWinConditions] Counting %s pactsworn points from set %s", num_7, get_current_set)
		end
	end

	for j = get_current_set + 1, #var_44_13 do
		local num_8 = var_44_13[j].max_points - var_44_13[j].claimed_points

		num_6 = num_6 + num_8

		if not arg_44_1 then
			printf("[VersusWinConditions] Counting %s pactsworn points from set %s", num_8, get_current_set)
		end
	end

	local num_9 = get_total_score_2 + num_6

	if not arg_44_1 then
		printf("[VersusWinConditions] Counted %s potential score for pactsworn", num_9)
	end

	self._early_win_data.party_id = _hero_party_id
	self._early_win_data.score = get_total_score
	self._early_win_data.score_potential = num_5
	self._early_win_data.other_party_score = get_total_score_2
	self._early_win_data.other_party_score_potential = num_9

	return self._early_win_data
end

VersusWinConditions.set_score = function (self, arg_45_1)
	-- function 45
	self:current_set_data(self._hero_party_id).claimed_points = arg_45_1

	if not self._is_server then
		local flag = false
		local network_transmit = Managers.state.network.network_transmit
		local get_current_set = self.mechanism:get_current_set()

		network_transmit:send_rpc_clients("rpc_versus_set_score", self._hero_party_id, arg_45_1, get_current_set, 0, 0)
	end
end

VersusWinConditions.get_current_score = function (self, arg_46_1)
	-- function 46
	local current_set_data = self:current_set_data(arg_46_1)
	local claimed_points

	if not current_set_data then
		claimed_points = current_set_data.claimed_points

		if not claimed_points then
			-- Nothing
		end
	end

	claimed_points = 0

	::label_46_0::

	return claimed_points
end

VersusWinConditions.get_total_score = function (self, arg_47_1)
	-- function 47
	local num = 0
	local var_47_1 = self._win_data[arg_47_1]

	if not var_47_1 then
		return 0
	end

	for i = 1, #var_47_1 do
		num = num + var_47_1[i].claimed_points
	end

	return num
end

VersusWinConditions.get_total_scores = function (self)
	-- function 48
	local _win_data = self._win_data
	local tbl = {}

	for k in pairs(_win_data) do
		tbl[k] = self:get_total_score(k)
	end

	return tbl
end

VersusWinConditions.get_match_results = function (self)
	-- function 49
	local var_49_0
	local num = 0
	local get_num_game_participating_parties = Managers.party:get_num_game_participating_parties()

	for i = 1, get_num_game_participating_parties do
		local get_total_score = self:get_total_score(i)

		if num < get_total_score then
			var_49_0 = i
			num = get_total_score
		elseif get_total_score == num then
			var_49_0 = nil
		end
	end

	local var_49_4
	local flag

	flag = (var_49_0 ~= 1 or not "party_one_won" or var_49_0 ~= 2) and (not "party_two_won" or "draw")

	return flag
end

VersusWinConditions.get_side_close_to_winning = function (self)
	-- function 50
	if not self._heroes_close_to_winning then
		return "heroes"
	end

	if not self._round_timer then
		return nil
	end

	if self._round_timer <= self._round_almost_over_time_breakpoint then
		local flag

		flag = not self._final_round and "dark_pact" and "NONE"

		return flag
	end

	return nil
end

VersusWinConditions.has_party_won_early = function (self)
	-- function 51
	return self.party_won_early ~= nil
end

VersusWinConditions.update_testify = function (arg_52_0, arg_52_1, arg_52_2)
	-- function 52
	Testify:poll_requests_through_handler(testify, arg_52_0)
end

VersusWinConditions.get_current_set = function (self)
	-- function 53
	return self._current_set
end
