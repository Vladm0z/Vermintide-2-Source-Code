-- chunkname: @scripts/managers/game_mode/versus_win_conditions.lua

local var_0_0 = script_data.testify and require("scripts/managers/game_mode/versus_win_conditions_testify")
local var_0_1 = require("scripts/entity_system/systems/objective/objective_types")
local var_0_2 = DLCSettings.carousel

VersusWinConditions = class(VersusWinConditions)

local var_0_3 = {
	"rpc_versus_set_score"
}

VersusWinConditions.init = function (arg_1_0, arg_1_1)
	arg_1_0._current_round = 0
	arg_1_0._current_set = 0
	arg_1_0._win_data = {}
	arg_1_0.mechanism = arg_1_1
	arg_1_0._round_almost_over_time_breakpoint = GameModeSettings.versus.round_almost_over_time_breakpoint
	arg_1_0._distance_to_winning_objective_breakpoint = GameModeSettings.versus.distance_to_winning_objective_breakpoint
	arg_1_0._num_sections_completed = 0
	arg_1_0.party_won_early = nil
	arg_1_0._current_objective_marker_positions = {}
	arg_1_0._early_win_data = {}
end

VersusWinConditions._reset_set_score = function (arg_2_0, arg_2_1)
	local var_2_0 = VersusObjectiveSettings[arg_2_1]

	if var_2_0 then
		local var_2_1 = var_2_0.num_sets

		arg_2_0._has_objectives = false

		local var_2_2 = Managers.party:parties()

		for iter_2_0 = 1, #var_2_2 do
			if var_2_2[iter_2_0].game_participating then
				local var_2_3 = {}

				for iter_2_1 = 1, var_2_1 do
					local var_2_4 = ObjectiveLists[var_2_0.objective_lists[iter_2_1]]

					var_2_3[iter_2_1] = {
						distance_traveled = 0,
						claimed_points = 0,
						max_points = var_2_4.max_score
					}
					arg_2_0._has_objectives = true
				end

				arg_2_0._win_data[iter_2_0] = var_2_3
			end
		end

		arg_2_0._set_score_is_setup = true
	end
end

VersusWinConditions.hot_join_sync = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._current_round
	local var_3_1 = arg_3_0._current_set
	local var_3_2 = PEER_ID_TO_CHANNEL[arg_3_1]

	for iter_3_0, iter_3_1 in pairs(arg_3_0._win_data) do
		local var_3_3 = arg_3_0._win_data[iter_3_0]

		for iter_3_2 = 1, #var_3_3 do
			local var_3_4 = var_3_3[iter_3_2]

			RPC.rpc_versus_set_score(var_3_2, iter_3_0, var_3_4.claimed_points, iter_3_2, var_3_1, var_3_0)
		end
	end
end

VersusWinConditions.register_rpcs = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_1:register(arg_4_0, unpack(var_0_3))

	arg_4_0._network_event_delegate = arg_4_1
end

VersusWinConditions.unregister_rpcs = function (arg_5_0)
	arg_5_0._network_event_delegate:unregister(arg_5_0)

	arg_5_0._network_event_delegate = nil
end

VersusWinConditions.setup_round = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.mechanism:get_objective_settings()

	arg_6_0._round_timer = var_6_0.round_timer or 36000
	arg_6_0._early_win_enabled = true

	if arg_6_0.mechanism:custom_settings_enabled() then
		arg_6_0._early_win_enabled = arg_6_0.mechanism:get_custom_game_setting("early_win_enabled")

		local var_6_1 = arg_6_0.mechanism:get_custom_game_setting("round_time_limit")

		if var_6_1 then
			arg_6_0._round_timer = var_6_1 * 60
			arg_6_0._custom_round_time_limit = true
		end
	end

	arg_6_0._is_server = arg_6_1
	arg_6_0._current_round = arg_6_0._current_round + 1

	if arg_6_0._current_round % 2 == 1 then
		arg_6_0._current_set = arg_6_0._current_set + 1
	end

	arg_6_0._final_round = arg_6_0.mechanism:is_last_set() and arg_6_0.mechanism:get_state() == "round_2"
	arg_6_0._round_over = false
	arg_6_0._level_id = var_6_0.level_id
	arg_6_0._level_id = Managers.level_transition_handler:get_current_level_key()
	arg_6_0._current_level_progress = 0
	arg_6_0._round_started = false
	arg_6_0._heroes_close_to_winning = false
	arg_6_0._heroes_close_to_safe_zone = false
	arg_6_0._num_sections_completed = 0
	arg_6_0._pactsworn_party_id = Managers.state.side:get_side_from_name("dark_pact").party.party_id
	arg_6_0._hero_party_id = Managers.state.side:get_side_from_name("heroes").party.party_id

	if arg_6_0._current_round == 1 or not arg_6_0._set_score_is_setup then
		arg_6_0:_reset_set_score(arg_6_0._level_id)
	end

	Managers.state.event:register(arg_6_0, "gm_event_round_started", "on_round_started")
	Managers.state.event:register(arg_6_0, "gm_event_end_conditions_met", "on_end_conditions_met")
	Managers.state.event:register(arg_6_0, "gm_event_initial_peers_spawned", "on_initial_peers_spawned")
	Managers.state.event:register(arg_6_0, "objective_completed", "on_objective_completed")
	Managers.state.event:register(arg_6_0, "obj_objective_section_completed", "on_objective_section_completed")
end

VersusWinConditions.on_game_mode_data_created = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._game_session = arg_7_1
	arg_7_0._go_id = arg_7_2

	if arg_7_1 and not arg_7_0._is_server then
		arg_7_0._round_timer = GameSession.game_object_field(arg_7_1, arg_7_2, "round_timer")
	end
end

VersusWinConditions.round_ended = function (arg_8_0)
	return
end

VersusWinConditions.on_game_mode_data_destroyed = function (arg_9_0)
	arg_9_0._game_session = nil
	arg_9_0._go_id = nil
	arg_9_0._round_timer = nil
end

VersusWinConditions.server_update = function (arg_10_0, arg_10_1, arg_10_2)
	if script_data.testify then
		arg_10_0:update_testify(arg_10_2, arg_10_1)
	end

	arg_10_0:_server_update_round_timer(arg_10_2)

	if Managers.state.game_mode:is_round_started() then
		arg_10_0:update_early_win_conditions()
	end
end

VersusWinConditions._server_update_round_timer = function (arg_11_0, arg_11_1)
	if not arg_11_0._round_started then
		return
	end

	local var_11_0 = Network.game_session()

	if not var_11_0 then
		return
	end

	arg_11_0._round_timer = math.max(arg_11_0._round_timer - arg_11_1, 0)

	GameSession.set_game_object_field(var_11_0, arg_11_0._go_id, "round_timer", arg_11_0._round_timer)

	if arg_11_0._custom_round_time_limit then
		arg_11_0:custom_game_round_timer()
	end
end

VersusWinConditions.client_update = function (arg_12_0, arg_12_1, arg_12_2)
	if script_data.testify then
		arg_12_0:update_testify(arg_12_2, arg_12_1)
	end

	if not arg_12_0._go_id then
		return
	end

	if not arg_12_0._round_started then
		return
	end

	local var_12_0 = Network.game_session()

	if not var_12_0 then
		return
	end

	arg_12_0._round_timer = GameSession.game_object_field(var_12_0, arg_12_0._go_id, "round_timer")
	arg_12_0._heroes_close_to_winning = GameSession.game_object_field(var_12_0, arg_12_0._go_id, "heroes_close_to_winning")
	arg_12_0._heroes_close_to_safe_zone = GameSession.game_object_field(var_12_0, arg_12_0._go_id, "heroes_close_to_safe_zone")

	if script_data.debug_early_win then
		Debug.text("Heroes about to win: %s", arg_12_0._heroes_close_to_winning)
	end

	if arg_12_0._custom_round_time_limit then
		arg_12_0:custom_game_round_timer()
	end
end

VersusWinConditions.is_heroes_close_to_win = function (arg_13_0)
	return arg_13_0._close_to_winning
end

VersusWinConditions.on_round_started = function (arg_14_0)
	arg_14_0._round_started = true

	if arg_14_0._is_server then
		local var_14_0 = Network.game_session()

		GameSession.set_game_object_field(var_14_0, arg_14_0._go_id, "round_timer", arg_14_0._round_timer)
	end
end

VersusWinConditions.on_end_conditions_met = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_0._round_over = true

	Managers.state.event:unregister("gm_event_round_started", arg_15_0)
	Managers.state.event:unregister("gm_event_end_conditions_met", arg_15_0)
	Managers.state.event:unregister("gm_event_initial_peers_spawned", arg_15_0)
	Managers.state.event:unregister("obj_objective_section_completed", arg_15_0)
	Managers.state.event:unregister("objective_completed", arg_15_0)

	local var_15_0 = {}
	local var_15_1 = Managers.player

	for iter_15_0, iter_15_1 in pairs(arg_15_3) do
		local var_15_2 = var_15_1:player_from_unique_id(iter_15_0)

		if var_15_2 then
			local var_15_3 = var_15_2:get_party()
			local var_15_4 = var_15_0[var_15_3.party_id] or {
				distance = 0,
				num_players = 0
			}

			var_15_4.num_players = var_15_4.num_players + 1
			var_15_4.distance = var_15_4.distance + iter_15_1
			var_15_0[var_15_3.party_id] = var_15_4
		end
	end

	local var_15_5 = arg_15_0.mechanism:get_current_set()

	for iter_15_2, iter_15_3 in pairs(var_15_0) do
		arg_15_0._win_data[iter_15_2][var_15_5].distance_traveled = iter_15_3.distance / iter_15_3.num_players
	end
end

VersusWinConditions.current_set_data = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._win_data[arg_16_1]

	if not var_16_0 then
		return
	end

	local var_16_1 = arg_16_0.mechanism:get_current_set()

	return var_16_0[var_16_1], var_16_1
end

VersusWinConditions.get_sets_data_for_party = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._win_data[arg_17_1]

	if not var_17_0 then
		return nil
	end

	return var_17_0
end

VersusWinConditions.on_initial_peers_spawned = function (arg_18_0)
	arg_18_0._objective_system = Managers.state.entity:system("objective_system")
end

VersusWinConditions.on_objective_completed = function (arg_19_0, arg_19_1, arg_19_2)
	Managers.state.achievement:trigger_event("register_objective_completed", arg_19_2, arg_19_0._hero_party_id, arg_19_1)

	if not arg_19_0._is_server then
		return
	end

	arg_19_0._main_path_distance_to_winning_objective = nil

	arg_19_0:add_time(arg_19_1:get_time_for_completion())
	arg_19_0:add_score(arg_19_1:get_score_for_completion(), arg_19_1)

	local var_19_0 = arg_19_0:_get_current_objective_data()

	if var_19_0 and var_19_0.close_to_win_on_sub_objective then
		arg_19_0._num_sections_completed = arg_19_0._num_sections_completed + 1
	end

	if not arg_19_0._heroes_close_to_winning then
		arg_19_0:_check_heroes_close_to_win_conditions_met()
	end

	local var_19_1 = arg_19_0:_has_nested_parent_objectives(arg_19_2)

	if not (arg_19_1:get_total_sections() > 1 or var_19_1) then
		arg_19_0._objective_system:objective_section_completed_telemetry()
	end
end

VersusWinConditions._get_current_objective_data = function (arg_20_0)
	local var_20_0 = Managers.state.game_mode:game_mode():get_current_objective_data()
	local var_20_1, var_20_2 = next(var_20_0)

	return var_20_2
end

VersusWinConditions._get_next_objective_data = function (arg_21_0)
	local var_21_0 = Managers.state.game_mode:game_mode():get_next_objective_data()

	if not var_21_0 then
		return
	end

	local var_21_1, var_21_2 = next(var_21_0)

	return var_21_2
end

VersusWinConditions.on_objective_section_completed = function (arg_22_0, arg_22_1)
	if not arg_22_0._is_server then
		return
	end

	arg_22_0:add_time(arg_22_1:get_time_per_section())
	arg_22_0:add_score(arg_22_1:get_score_per_section(), arg_22_1)

	local var_22_0 = arg_22_1:get_current_section()
	local var_22_1 = arg_22_1:get_total_sections()

	if not arg_22_0._heroes_close_to_winning then
		arg_22_0:_check_heroes_close_to_win_conditions_met(var_22_0, var_22_1)
	end

	if var_22_1 > 1 then
		arg_22_0._objective_system:objective_section_completed_telemetry(var_22_0, var_22_1)
	end
end

VersusWinConditions._check_heroes_close_to_win_conditions_met = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0:_get_hero_early_win_data(false)
	local var_23_1
	local var_23_2

	if arg_23_1 and arg_23_2 and arg_23_1 < arg_23_2 then
		var_23_1 = arg_23_0:_get_current_objective_data()
	else
		var_23_1 = arg_23_0:_get_next_objective_data()
	end

	if not var_23_1 then
		return
	end

	local var_23_3, var_23_4 = arg_23_0:_has_nested_parent_objectives(var_23_1)

	if var_23_3 then
		local var_23_5, var_23_6 = next(var_23_1.sub_objectives)

		var_23_2 = var_23_6.score_for_completion
		arg_23_2 = var_23_4
	end

	arg_23_2 = arg_23_2 or var_23_1.num_sockets or var_23_1.num_sections or nil
	var_23_2 = var_23_2 or var_23_1.score_per_section or var_23_1.score_per_socket or nil

	local var_23_7 = arg_23_2 and var_23_2 and arg_23_2 >= 10
	local var_23_8 = 0
	local var_23_9 = var_23_0.other_party_score_potential

	if var_23_1.score_for_completion then
		var_23_8 = var_23_0.score + var_23_1.score_for_completion
	elseif var_23_7 then
		var_23_8 = var_23_0.score + var_23_2 * arg_23_2 - (arg_23_0._num_sections_completed or 0 * var_23_2)
	elseif arg_23_2 and var_23_2 and arg_23_2 then
		var_23_8 = var_23_0.score + var_23_2
	end

	local var_23_10 = var_23_9 < var_23_8

	if script_data.debug_early_win then
		Debug.text("Potential score needed for close to win: %s / %s", var_23_8, var_23_9)
		Debug.text("Heroes about to win: %s", var_23_10)
	end

	local var_23_11 = arg_23_0:_get_current_objective_data()
	local var_23_12 = var_23_11 and var_23_11.close_to_win_on_sub_objective

	if not var_23_10 and not arg_23_0._heroes_close_to_safe_zone then
		if var_23_1.close_to_win_on_completion then
			arg_23_0._heroes_close_to_safe_zone = true
		elseif var_23_12 then
			arg_23_0._heroes_close_to_safe_zone = (arg_23_0._num_sections_completed or 0) >= var_23_11.close_to_win_on_sub_objective
		elseif var_23_1.close_to_win_on_section then
			arg_23_0._heroes_close_to_safe_zone = arg_23_0._num_sections_completed >= var_23_1.close_to_win_on_section
		elseif var_23_1.objective_type and var_23_1.objective_type == var_0_1.objective_safehouse then
			arg_23_0._heroes_close_to_safe_zone = true
		end
	end

	if arg_23_0._heroes_close_to_safe_zone then
		local var_23_13 = Network.game_session()

		GameSession.set_game_object_field(var_23_13, arg_23_0._go_id, "heroes_close_to_safe_zone", true)
	end

	if var_23_10 then
		arg_23_0:_trigger_about_to_early_win_vo()

		arg_23_0._heroes_close_to_winning = true

		local var_23_14 = Network.game_session()

		GameSession.set_game_object_field(var_23_14, arg_23_0._go_id, "heroes_close_to_winning", true)
	end
end

VersusWinConditions._trigger_about_to_early_win_vo = function (arg_24_0)
	if Managers.state.game_mode:game_mode():is_about_to_end_game_early() then
		return
	end

	if arg_24_0._about_to_early_win_vo_played then
		return
	end

	arg_24_0._about_to_early_win_vo_played = true

	local var_24_0 = Managers.state.entity:system("dialogue_system")

	var_24_0:queue_mission_giver_event("vs_mg_about_to_early_win", nil, "heroes")
	var_24_0:queue_mission_giver_event("vs_mg_about_to_early_loss", nil, "dark_pact")
end

VersusWinConditions._has_nested_parent_objectives = function (arg_25_0, arg_25_1)
	if not arg_25_1.sub_objectives then
		return false
	end

	local var_25_0 = table.size(arg_25_1.sub_objectives)
	local var_25_1, var_25_2 = next(arg_25_1.sub_objectives)

	return var_25_2.sub_objectives, var_25_2.sub_objectives and var_25_0 or nil
end

VersusWinConditions.rpc_versus_set_score = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	if arg_26_5 ~= 0 then
		arg_26_0._current_set = arg_26_5
	end

	if arg_26_6 ~= 0 then
		arg_26_0._current_round = arg_26_6
	end

	local var_26_0 = arg_26_0._win_data[arg_26_2]

	if not var_26_0 then
		return
	end

	var_26_0[arg_26_4].claimed_points = arg_26_3

	Presence.set_presence("score", PresenceHelper.get_game_score())
end

VersusWinConditions.is_round_timer_started = function (arg_27_0)
	return arg_27_0._round_started
end

VersusWinConditions.is_round_timer_over = function (arg_28_0)
	return arg_28_0._round_timer <= 0
end

VersusWinConditions.is_round_almost_over = function (arg_29_0)
	return arg_29_0._round_timer <= arg_29_0._round_almost_over_time_breakpoint
end

VersusWinConditions.heroes_close_to_safe_zone = function (arg_30_0)
	return arg_30_0._heroes_close_to_safe_zone
end

VersusWinConditions.round_timer = function (arg_31_0)
	return arg_31_0._round_timer
end

VersusWinConditions._get_round_timer_formatted = function (arg_32_0)
	if not arg_32_0._round_timer then
		return
	end

	local var_32_0 = math.floor(arg_32_0._round_timer / 60)
	local var_32_1 = math.floor(arg_32_0._round_timer % 60)

	if var_32_1 < 10 then
		var_32_1 = string.format("0%s", var_32_1)
	end

	if var_32_0 < 10 then
		var_32_0 = string.format("0%s", var_32_0)
	end

	return string.format("%s:%s", var_32_0, var_32_1)
end

VersusWinConditions.custom_game_round_timer = function (arg_33_0)
	if arg_33_0:is_round_timer_started() then
		local var_33_0 = arg_33_0:_get_round_timer_formatted()

		if arg_33_0._formatted_round_timer ~= var_33_0 then
			Managers.state.event:trigger("ui_update_round_timer", arg_33_0:_get_round_timer_formatted())

			arg_33_0._formatted_round_timer = var_33_0
		end
	end
end

VersusWinConditions.is_final_round = function (arg_34_0)
	return arg_34_0._final_round
end

VersusWinConditions.get_current_round = function (arg_35_0)
	return arg_35_0._current_round
end

VersusWinConditions.add_time = function (arg_36_0, arg_36_1)
	arg_36_0._round_timer = arg_36_0._round_timer + arg_36_1

	local var_36_0 = Network.game_session()

	GameSession.set_game_object_field(var_36_0, arg_36_0._go_id, "round_timer", arg_36_0._round_timer)
end

VersusWinConditions.set_time = function (arg_37_0, arg_37_1)
	arg_37_0._round_timer = arg_37_1

	local var_37_0 = Network.game_session()

	GameSession.set_game_object_field(var_37_0, arg_37_0._go_id, "round_timer", arg_37_0._round_timer)
end

VersusWinConditions.add_score = function (arg_38_0, arg_38_1, arg_38_2)
	if arg_38_0._is_server then
		arg_38_0:_add_points_collected(arg_38_0._hero_party_id, arg_38_1)

		if not DEDICATED_SERVER then
			Presence.set_presence("score", PresenceHelper.get_game_score())
		end

		arg_38_0:play_score_sfx(arg_38_2)
	end
end

VersusWinConditions.set_data = function (arg_39_0, arg_39_1)
	return arg_39_0._win_data[arg_39_1] or {}
end

VersusWinConditions.play_score_sfx = function (arg_40_0, arg_40_1)
	local var_40_0 = "Play_hud_versus_score_points"

	if arg_40_0._early_win_enabled then
		local var_40_1 = var_0_2.versus_close_to_win_score_ticks
		local var_40_2 = arg_40_0:_get_hero_early_win_data(false)
		local var_40_3 = var_40_2.other_party_score_potential - var_40_2.score + 1
		local var_40_4 = 0
		local var_40_5 = arg_40_1:get_num_sections_left()
		local var_40_6 = arg_40_1:get_score_per_section()
		local var_40_7 = arg_40_0._objective_system:get_remaining_objectives_list()
		local var_40_8 = #var_40_1
		local var_40_9 = 0

		if var_40_5 > 0 and var_40_6 > 0 then
			for iter_40_0 = 1, var_40_5 do
				var_40_4 = var_40_4 + 1
				var_40_3 = var_40_3 - var_40_6
				var_40_9 = var_40_9 + 1

				if var_40_3 <= 0 or var_40_9 == var_40_8 then
					break
				end
			end
		end

		if var_40_3 > 0 then
			for iter_40_1, iter_40_2 in ipairs(var_40_7) do
				local var_40_10, var_40_11 = next(iter_40_2)
				local var_40_12 = var_40_11.score_per_section or var_40_11.score_per_socket or var_40_11.score_for_completion or 0
				local var_40_13 = var_40_11.num_sockets or var_40_11.num_sections or 1

				for iter_40_3 = 1, var_40_13 do
					var_40_3 = var_40_3 - var_40_12
					var_40_4 = var_40_4 + 1
					var_40_9 = var_40_9 + 1

					if var_40_3 <= 0 or var_40_9 == var_40_8 then
						break
					end
				end

				if var_40_3 <= 0 or var_40_9 == var_40_8 then
					break
				end
			end
		end

		if var_40_3 <= 0 and var_40_1[var_40_4 + 1] then
			var_40_0 = var_40_1[var_40_4 + 1]
		end
	end

	local var_40_14 = NetworkLookup.sound_events[var_40_0]

	Managers.state.network.network_transmit:send_rpc_clients("rpc_play_2d_audio_event", var_40_14)

	if not DEDICATED_SERVER then
		local var_40_15 = Managers.world:world("level_world")
		local var_40_16 = Managers.world:wwise_world(var_40_15)

		WwiseWorld.trigger_event(var_40_16, var_40_0)
	end
end

VersusWinConditions._add_points_collected = function (arg_41_0, arg_41_1, arg_41_2)
	local var_41_0, var_41_1 = arg_41_0:current_set_data(arg_41_1)

	if not var_41_0 then
		return
	end

	local var_41_2 = arg_41_0._current_set
	local var_41_3 = arg_41_0._current_round

	var_41_0.claimed_points = var_41_0.claimed_points + arg_41_2

	Managers.state.network.network_transmit:send_rpc_clients("rpc_versus_set_score", arg_41_1, var_41_0.claimed_points, var_41_1, var_41_2, var_41_3)
end

VersusWinConditions.save_points_collected = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = arg_42_0._win_data[arg_42_1]

	if not var_42_0 then
		return
	end

	var_42_0[arg_42_2].claimed_points = arg_42_3
end

VersusWinConditions.update_early_win_conditions = function (arg_43_0)
	if not arg_43_0._early_win_enabled then
		return
	end

	if not arg_43_0._has_objectives then
		return
	end

	if script_data.debug_early_win and Network.game_session() then
		arg_43_0:_check_heroes_close_to_win_conditions_met()
	end

	local var_43_0 = arg_43_0:_get_hero_early_win_data(false)
	local var_43_1 = var_43_0.score > var_43_0.other_party_score_potential
	local var_43_2 = var_43_0.score_potential < var_43_0.other_party_score

	if not arg_43_0.party_won_early then
		if var_43_1 or var_43_2 then
			table.dump(var_43_0, "self.party_won_early")
		end

		if var_43_1 then
			arg_43_0.party_won_early = var_43_0
		elseif var_43_2 then
			local var_43_3 = arg_43_0._hero_party_id == 1 and 2 or 1

			arg_43_0.party_won_early = {
				party_id = var_43_3,
				score = var_43_0.other_score,
				score_potential = var_43_0.other_party_score_potential,
				other_party_score = var_43_0.score,
				other_party_score_potential = var_43_0.score_potential
			}

			table.dump(arg_43_0.party_won_early, "pactsworn_early_win_data")
		end

		if arg_43_0.party_won_early then
			printf("[VersusWinConditions] Party %s (%s) won early due to score %s being higher than opponent potential score %s", arg_43_0.party_won_early.party_id, arg_43_0.party_won_early.party_id == arg_43_0._hero_party_id and "heroes" or "pact_sworn", arg_43_0.party_won_early.score, arg_43_0.party_won_early.other_party_score_potential)
			arg_43_0:_get_hero_early_win_data(true)
		end
	end

	return var_43_1 or var_43_2, arg_43_0.party_won_early
end

local var_0_4 = 10

VersusWinConditions._get_hero_early_win_data = function (arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._hero_party_id
	local var_44_1 = arg_44_0.mechanism:get_current_set()
	local var_44_2 = var_44_0 == 1 and 2 or 1
	local var_44_3 = arg_44_0:get_total_score(var_44_0)
	local var_44_4 = arg_44_0:get_total_score(var_44_2)
	local var_44_5 = Managers.party:get_party(var_44_0)
	local var_44_6 = 0
	local var_44_7 = Managers.state.side:get_side_from_name(var_44_5.name).PLAYER_AND_BOT_UNITS
	local var_44_8 = var_44_5.num_slots - #var_44_7

	if var_44_8 > 0 then
		var_44_6 = var_44_8 * var_0_4

		if arg_44_1 then
			printf("[VersusWinConditions] There are %s dead heroes resulting in %s less potential score", var_44_8, var_44_6)
		end
	end

	local var_44_9 = arg_44_0._win_data[var_44_0]
	local var_44_10 = var_44_9[var_44_1].max_points

	if arg_44_1 then
		printf("[VersusWinConditions] Counting %s hero points from set %s", var_44_10, var_44_1)
	end

	for iter_44_0 = var_44_1 + 1, #var_44_9 do
		local var_44_11 = var_44_9[iter_44_0].max_points - var_44_9[iter_44_0].claimed_points

		var_44_10 = var_44_10 + var_44_11

		if arg_44_1 then
			printf("[VersusWinConditions] Counting %s hero points from set %s", var_44_11, iter_44_0)
		end
	end

	local var_44_12 = var_44_3 + var_44_10 - var_44_6

	if arg_44_1 then
		printf("[VersusWinConditions] Counted %s potential score for heroes", var_44_12)
	end

	local var_44_13 = arg_44_0._win_data[var_44_2]
	local var_44_14 = 0

	if arg_44_0._current_round % 2 == 1 then
		local var_44_15 = var_44_13[var_44_1].max_points - var_44_13[var_44_1].claimed_points

		var_44_14 = var_44_14 + var_44_15

		if arg_44_1 then
			printf("[VersusWinConditions] Counting %s pactsworn points from set %s", var_44_15, var_44_1)
		end
	end

	for iter_44_1 = var_44_1 + 1, #var_44_13 do
		local var_44_16 = var_44_13[iter_44_1].max_points - var_44_13[iter_44_1].claimed_points

		var_44_14 = var_44_14 + var_44_16

		if arg_44_1 then
			printf("[VersusWinConditions] Counting %s pactsworn points from set %s", var_44_16, var_44_1)
		end
	end

	local var_44_17 = var_44_4 + var_44_14

	if arg_44_1 then
		printf("[VersusWinConditions] Counted %s potential score for pactsworn", var_44_17)
	end

	arg_44_0._early_win_data.party_id = var_44_0
	arg_44_0._early_win_data.score = var_44_3
	arg_44_0._early_win_data.score_potential = var_44_12
	arg_44_0._early_win_data.other_party_score = var_44_4
	arg_44_0._early_win_data.other_party_score_potential = var_44_17

	return arg_44_0._early_win_data
end

VersusWinConditions.set_score = function (arg_45_0, arg_45_1)
	arg_45_0:current_set_data(arg_45_0._hero_party_id).claimed_points = arg_45_1

	if arg_45_0._is_server then
		local var_45_0 = false
		local var_45_1 = Managers.state.network.network_transmit
		local var_45_2 = arg_45_0.mechanism:get_current_set()

		var_45_1:send_rpc_clients("rpc_versus_set_score", arg_45_0._hero_party_id, arg_45_1, var_45_2, 0, 0)
	end
end

VersusWinConditions.get_current_score = function (arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0:current_set_data(arg_46_1)

	return var_46_0 and var_46_0.claimed_points or 0
end

VersusWinConditions.get_total_score = function (arg_47_0, arg_47_1)
	local var_47_0 = 0
	local var_47_1 = arg_47_0._win_data[arg_47_1]

	if not var_47_1 then
		return 0
	end

	for iter_47_0 = 1, #var_47_1 do
		var_47_0 = var_47_0 + var_47_1[iter_47_0].claimed_points
	end

	return var_47_0
end

VersusWinConditions.get_total_scores = function (arg_48_0)
	local var_48_0 = arg_48_0._win_data
	local var_48_1 = {}

	for iter_48_0 in pairs(var_48_0) do
		var_48_1[iter_48_0] = arg_48_0:get_total_score(iter_48_0)
	end

	return var_48_1
end

VersusWinConditions.get_match_results = function (arg_49_0)
	local var_49_0
	local var_49_1 = 0
	local var_49_2 = Managers.party:get_num_game_participating_parties()

	for iter_49_0 = 1, var_49_2 do
		local var_49_3 = arg_49_0:get_total_score(iter_49_0)

		if var_49_1 < var_49_3 then
			var_49_0 = iter_49_0
			var_49_1 = var_49_3
		elseif var_49_3 == var_49_1 then
			var_49_0 = nil
		end
	end

	local var_49_4

	return var_49_0 == 1 and "party_one_won" or var_49_0 == 2 and "party_two_won" or "draw"
end

VersusWinConditions.get_side_close_to_winning = function (arg_50_0)
	if arg_50_0._heroes_close_to_winning then
		return "heroes"
	end

	if not arg_50_0._round_timer then
		return nil
	end

	if arg_50_0._round_timer <= arg_50_0._round_almost_over_time_breakpoint then
		return arg_50_0._final_round and "dark_pact" or "NONE"
	end

	return nil
end

VersusWinConditions.has_party_won_early = function (arg_51_0)
	return arg_51_0.party_won_early ~= nil
end

VersusWinConditions.update_testify = function (arg_52_0, arg_52_1, arg_52_2)
	Testify:poll_requests_through_handler(var_0_0, arg_52_0)
end

VersusWinConditions.get_current_set = function (arg_53_0)
	return arg_53_0._current_set
end
