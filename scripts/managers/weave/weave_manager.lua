-- chunkname: @scripts/managers/weave/weave_manager.lua

require("scripts/managers/conflict_director/weave_spawner")
require("scripts/settings/wind_settings")
require("scripts/settings/weave_settings")

local var_0_0 = script_data.testify and require("scripts/managers/weave/weave_manager_testify")

WeaveManager = class(WeaveManager)

local var_0_1 = {
	"rpc_set_active_weave",
	"rpc_weave_objective_completed",
	"rpc_weave_final_objective_completed",
	"rpc_sync_end_of_weave_data",
	"rpc_sync_player_count",
	"rpc_bar_cutoff_reached"
}
local var_0_2 = {
	"conflict_director_setup_done",
	"event_conflict_director_setup_done"
}

function WeaveManager.init(arg_1_0)
	arg_1_0:_reset()
end

function WeaveManager.initiate(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if arg_2_4 == "weave" then
		arg_2_0:_setup_weave_data(arg_2_3)
		arg_2_0:_setup_data(arg_2_1, arg_2_3)
		arg_2_0:_register_events()
		arg_2_0:_register_rpcs(arg_2_2)

		arg_2_0._initiated = true
	else
		arg_2_0:_reset()
	end
end

function WeaveManager._reset(arg_3_0)
	arg_3_0._world = nil
	arg_3_0._initiated = false
	arg_3_0._is_server = true
	arg_3_0._bar_score = 0
	arg_3_0._score = 0
	arg_3_0._bar_filled = false
	arg_3_0._objective_ui_mission_name = nil
	arg_3_0._num_players = nil

	arg_3_0:clear_weave_name()

	arg_3_0._player_ids = {}
	arg_3_0._saved_game_mode_data = {}
	arg_3_0._remaining_time = WeaveSettings.starting_time
	arg_3_0._damage_taken = 0
	arg_3_0._weave_spawner = nil
	arg_3_0._final_data_synced = false
	arg_3_0._has_reset_challenge_stats = false
	arg_3_0._pause_timer = true
	arg_3_0._track_kills = false
	arg_3_0._num_enemies_killed = 0
	arg_3_0._enemies_killed = {}
	arg_3_0._active_weave_phase = 1
end

function WeaveManager.clear_weave_data(arg_4_0)
	arg_4_0._bar_score = 0
	arg_4_0._bar_filled = false
	arg_4_0._remaining_time = WeaveSettings.starting_time
	arg_4_0._damage_taken = 0
	arg_4_0._final_data_synced = false
	arg_4_0._active_weave_phase = 1

	table.clear(arg_4_0._saved_game_mode_data)

	arg_4_0._track_kills = false
	arg_4_0._num_enemies_killed = 0

	table.clear(arg_4_0._enemies_killed)
end

function WeaveManager.clear_weave_name(arg_5_0)
	arg_5_0._active_weave_name = nil
	arg_5_0._next_weave_name = nil
	arg_5_0._active_objective_index = nil
	arg_5_0._next_objective_index = nil
end

function WeaveManager._setup_data(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._world = arg_6_1
	arg_6_0._is_server = arg_6_2
	arg_6_0._bar_filled = false
	arg_6_0._objective_ui_mission_name = nil
	arg_6_0._next_weave_name = nil
	arg_6_0._final_data_synced = false
	arg_6_0._pause_timer = true
	arg_6_0._next_objective_index = nil
	arg_6_0._track_kills = false
	arg_6_0._num_enemies_killed = 0

	table.clear(arg_6_0._enemies_killed)

	if arg_6_0._is_server then
		arg_6_0._weave_spawner = WeaveSpawner:new(arg_6_0._world, nil)
	else
		arg_6_0._weave_spawner = nil
	end
end

function WeaveManager.weave_spawner(arg_7_0)
	return arg_7_0._weave_spawner
end

function WeaveManager._setup_weave_data(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return
	end

	local var_8_0 = arg_8_0._next_weave_name or Development.parameter("weave_name")
	local var_8_1 = arg_8_0._next_objective_index or Development.parameter("weave_name") and 1
	local var_8_2 = arg_8_0._remaining_time or WeaveSettings.starting_time
	local var_8_3 = arg_8_0._damage_taken or 0
	local var_8_4 = arg_8_0._player_ids

	arg_8_0:_set_active_weave(var_8_0)
	arg_8_0:_set_active_objective(var_8_1)
	arg_8_0:_set_time_left(var_8_2)
	arg_8_0:_set_damage_taken(var_8_3)
	arg_8_0:_set_player_ids(var_8_4)
	arg_8_0:_create_game_object()
	Development.set_parameter("weave_name", nil)
end

function WeaveManager._register_events(arg_9_0)
	Managers.state.event:register(arg_9_0, unpack(var_0_2))
end

function WeaveManager._unregister_events(arg_10_0)
	local var_10_0 = Managers.state.event

	if var_10_0 and arg_10_0._initiated then
		for iter_10_0 = 1, #var_0_2, 2 do
			local var_10_1 = var_0_2[iter_10_0]

			var_10_0:unregister(var_10_1, arg_10_0)
		end
	end
end

function WeaveManager._register_rpcs(arg_11_0, arg_11_1)
	arg_11_0._network_event_delegate = arg_11_1

	arg_11_1:register(arg_11_0, unpack(var_0_1))
end

function WeaveManager._unregister_rpcs(arg_12_0)
	if arg_12_0._network_event_delegate then
		arg_12_0._network_event_delegate:unregister(arg_12_0)

		arg_12_0._network_event_delegate = nil
	end
end

function WeaveManager.reset_statistics_for_challenges(arg_13_0)
	if arg_13_0._has_reset_challenge_stats then
		return
	end

	local var_13_0 = Managers.player:statistics_db()
	local var_13_1 = Managers.player:local_player():stats_id()

	if ScorpionSeasonalSettings.current_season_id == 1 then
		local var_13_2 = "weave_life_stepped_in_bush"

		var_13_0:set_stat(var_13_1, "season_1", var_13_2, 0)

		local var_13_3 = "weave_death_hit_by_spirit"

		var_13_0:set_stat(var_13_1, "season_1", var_13_3, 0)

		local var_13_4 = "weave_beasts_destroyed_totems"

		var_13_0:set_stat(var_13_1, "season_1", var_13_4, 0)

		local var_13_5 = "weave_light_low_curse"

		var_13_0:set_stat(var_13_1, "season_1", var_13_5, 0)

		local var_13_6 = "weave_shadow_kill_no_shrouded"

		var_13_0:set_stat(var_13_1, "season_1", var_13_6, 0)
	end

	arg_13_0._has_reset_challenge_stats = true
end

function WeaveManager.teardown(arg_14_0)
	arg_14_0:_unregister_rpcs()
	arg_14_0:_unregister_events()

	arg_14_0._go_id = nil
	arg_14_0._initiated = false
end

function WeaveManager.destroy(arg_15_0)
	arg_15_0:_unregister_rpcs()
	arg_15_0:_unregister_events()
end

function WeaveManager.update(arg_16_0, arg_16_1, arg_16_2)
	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_16_0)
	end

	if not arg_16_0._initiated then
		return
	end

	if arg_16_0:get_active_weave() and not arg_16_0._final_data_synced then
		local var_16_0 = arg_16_0:get_active_objective_template()

		if arg_16_0._is_server then
			if not arg_16_0._pause_timer then
				arg_16_0._remaining_time = math.max(arg_16_0._remaining_time - arg_16_1, 0)
			end

			arg_16_0._score = arg_16_0:_calculate_score()
		end

		local var_16_1 = Managers.state.network:game()

		if var_16_1 and arg_16_0._go_id then
			if arg_16_0._is_server then
				local var_16_2 = math.floor(arg_16_0._remaining_time)

				GameSession.set_game_object_field(var_16_1, arg_16_0._go_id, "remaining_time", var_16_2)

				if arg_16_0._bar_score >= var_16_0.bar_cutoff and not arg_16_0._bar_filled then
					arg_16_0:_objective_completed()
					Managers.state.network.network_transmit:send_rpc_clients("rpc_weave_objective_completed")
				end
			else
				arg_16_0._remaining_time = GameSession.game_object_field(var_16_1, arg_16_0._go_id, "remaining_time")
			end
		end

		if arg_16_0._remaining_time == 0 and arg_16_0._objective_ui_mission_name ~= "weave_time_out" then
			if arg_16_0._objective_ui_mission_name then
				Managers.state.event:trigger("ui_event_complete_mission", arg_16_0._objective_ui_mission_name, true)
			end

			Managers.state.event:trigger("ui_event_add_mission_objective", "weave_time_out", Localize("weave_time_out"))

			arg_16_0._objective_ui_mission_name = "weave_time_out"
		end

		if arg_16_0._weave_spawner then
			arg_16_0._weave_spawner:update(arg_16_2, arg_16_1, var_16_0)
		end
	end
end

function WeaveManager.event_conflict_director_setup_done(arg_17_0)
	if arg_17_0:get_active_weave() and arg_17_0._is_server then
		local var_17_0 = arg_17_0:get_active_objective_template()
		local var_17_1 = var_17_0 and var_17_0.spawning_seed

		if var_17_1 then
			arg_17_0._weave_spawner:set_seed(var_17_1)
		end

		arg_17_0._weave_spawner.conflict_director_setup_done = true
	end
end

function WeaveManager._set_player_ids(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return
	end

	arg_18_0._player_ids = arg_18_1
end

function WeaveManager.store_player_ids(arg_19_0)
	if not table.is_empty(arg_19_0._player_ids) then
		return
	end

	local var_19_0 = Managers.state.network:lobby()
	local var_19_1 = var_19_0:members():get_members()

	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		arg_19_0._player_ids[iter_19_1] = true
	end

	local var_19_2 = var_19_0:lobby_data("matchmaking")
	local var_19_3 = var_19_0:lobby_data("is_private")

	if var_19_2 == "true" then
		arg_19_0._num_players = 4
	elseif var_19_3 == "false" then
		arg_19_0._num_players = 4
	else
		arg_19_0._num_players = table.size(arg_19_0._player_ids)
	end

	Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_player_count", arg_19_0._num_players)
end

function WeaveManager.get_saved_game_mode_data(arg_20_0)
	if not arg_20_0._is_server then
		return
	end

	return table.clone(arg_20_0._saved_game_mode_data)
end

function WeaveManager.store_saved_game_mode_data(arg_21_0)
	if not arg_21_0._is_server then
		return
	end

	local var_21_0 = Managers.state.game_mode and Managers.state.game_mode:get_saved_game_mode_data()

	if var_21_0 then
		for iter_21_0, iter_21_1 in pairs(var_21_0) do
			iter_21_1.spawn_state = nil
			iter_21_1.position = nil
			iter_21_1.rotation = nil
		end
	end

	arg_21_0._saved_game_mode_data = var_21_0
end

function WeaveManager.get_player_ids(arg_22_0)
	return arg_22_0._player_ids
end

function WeaveManager.set_next_weave(arg_23_0, arg_23_1)
	arg_23_0._next_weave_name = arg_23_1
end

function WeaveManager.set_next_objective(arg_24_0, arg_24_1)
	arg_24_0._next_objective_index = arg_24_1
end

function WeaveManager.get_next_weave(arg_25_0)
	return arg_25_0._next_weave_name
end

function WeaveManager.get_next_objective(arg_26_0)
	return arg_26_0._next_objective_index
end

function WeaveManager.get_time_left(arg_27_0)
	return arg_27_0._remaining_time
end

function WeaveManager.get_damage_taken(arg_28_0)
	return arg_28_0._damage_taken
end

function WeaveManager._set_active_weave(arg_29_0, arg_29_1)
	arg_29_0._active_weave_name = arg_29_1
end

function WeaveManager._report_telemetry(arg_30_0)
	local var_30_0 = arg_30_0:get_active_wind()
	local var_30_1 = arg_30_0:get_weave_tier()

	Managers.telemetry_events:weave_activated(var_30_0, var_30_1)
end

function WeaveManager._set_active_objective(arg_31_0, arg_31_1)
	arg_31_0._active_objective_index = arg_31_1
end

function WeaveManager.get_active_objective(arg_32_0)
	return arg_32_0._active_objective_index
end

function WeaveManager._set_time_left(arg_33_0, arg_33_1)
	arg_33_0._remaining_time = arg_33_1
end

function WeaveManager._set_damage_taken(arg_34_0, arg_34_1)
	arg_34_0._damage_taken = arg_34_1
end

function WeaveManager.get_active_weave(arg_35_0)
	return arg_35_0._active_weave_name
end

function WeaveManager.get_active_weave_phase(arg_36_0)
	return arg_36_0._active_weave_phase
end

function WeaveManager.set_active_weave_phase(arg_37_0, arg_37_1)
	arg_37_0._active_weave_phase = arg_37_1
end

function WeaveManager.get_active_wind(arg_38_0)
	if not arg_38_0._active_weave_name then
		return
	end

	local var_38_0 = WeaveSettings.templates[arg_38_0._active_weave_name]

	return var_38_0 and var_38_0.wind
end

function WeaveManager.get_active_wind_settings(arg_39_0)
	if not arg_39_0._active_weave_name then
		return
	end

	local var_39_0 = WeaveSettings.templates[arg_39_0._active_weave_name]
	local var_39_1 = var_39_0 and var_39_0.wind

	return WindSettings[var_39_1]
end

function WeaveManager.get_scaling_value(arg_40_0, arg_40_1)
	local var_40_0 = Managers.state.network:lobby()
	local var_40_1 = var_40_0 and var_40_0:lobby_data("weave_quick_game") == "true" or Managers.venture.quickplay:is_quick_game()
	local var_40_2 = WeaveSettings.templates[arg_40_0._active_weave_name]
	local var_40_3 = var_40_2.scaling_settings
	local var_40_4 = not var_40_1 and var_40_3 and var_40_3[arg_40_1]
	local var_40_5 = var_40_2.tier
	local var_40_6 = 0

	if var_40_4 then
		for iter_40_0, iter_40_1 in ipairs(WeaveSettings.difficulty_increases) do
			if var_40_5 <= iter_40_1.breakpoint then
				local var_40_7 = (var_40_5 - var_40_6) / (iter_40_1.breakpoint - var_40_6)
				local var_40_8 = var_40_4[1]
				local var_40_9 = var_40_4[2]

				return (math.lerp(var_40_8, var_40_9, var_40_7))
			else
				var_40_6 = iter_40_1.breakpoint
			end
		end
	end

	return 0
end

function WeaveManager.start_timer(arg_41_0)
	arg_41_0._pause_timer = false
end

function WeaveManager.calculate_next_objective_index(arg_42_0)
	if not arg_42_0._active_weave_name then
		return
	end

	local var_42_0 = arg_42_0._active_objective_index

	if var_42_0 == #WeaveSettings.templates[arg_42_0._active_weave_name].objectives then
		return
	end

	return var_42_0 + 1
end

function WeaveManager.sync_end_of_weave_data(arg_43_0)
	arg_43_0._final_data_synced = true

	local var_43_0 = arg_43_0._score
	local var_43_1 = arg_43_0._remaining_time
	local var_43_2 = arg_43_0._num_players
	local var_43_3 = arg_43_0._damage_taken

	Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_end_of_weave_data", var_43_0, var_43_1, var_43_2, var_43_3)
end

function WeaveManager.hot_join_sync(arg_44_0, arg_44_1)
	if Managers.state.game_mode:game_mode_key() ~= "weave" then
		return
	end

	local var_44_0 = Managers.state.network.network_transmit
	local var_44_1 = arg_44_0._active_weave_name

	if var_44_1 then
		local var_44_2 = NetworkLookup.weave_names[var_44_1]
		local var_44_3 = arg_44_0._active_objective_index

		var_44_0:send_rpc("rpc_set_active_weave", arg_44_1, var_44_2, var_44_3)
	end

	local var_44_4 = arg_44_0._num_players

	if var_44_4 then
		var_44_0:send_rpc("rpc_sync_player_count", arg_44_1, var_44_4)
	end
end

local var_0_3 = {}

function WeaveManager.mutators(arg_45_0)
	table.clear(var_0_3)

	local var_45_0 = arg_45_0._active_weave_name

	if not var_45_0 then
		return var_0_3
	end

	local var_45_1 = WeaveSettings.templates[var_45_0]

	if var_45_1.wind_strength == 0 then
		return var_0_3
	end

	local var_45_2 = var_45_1.wind
	local var_45_3 = WindSettings[var_45_2].mutator

	var_0_3[#var_0_3 + 1] = var_45_3

	return var_0_3
end

function WeaveManager.start_objective(arg_46_0)
	local var_46_0 = arg_46_0:get_active_objective_template()
	local var_46_1 = var_46_0.objective_start_flow_event
	local var_46_2 = var_46_0.objective_settings
	local var_46_3 = ObjectiveLists[var_46_2 and var_46_2.objective_lists]

	if var_46_1 then
		LevelHelper:flow_event(arg_46_0._world, var_46_1)
	end

	arg_46_0._track_kills = var_46_0.track_kills

	if var_46_3 and arg_46_0._is_server then
		local var_46_4 = Managers.state.entity:system("objective_system")

		var_46_4:server_register_objectives(var_46_2.objective_lists)
		var_46_4:server_activate_first_objective()
	end

	local var_46_5 = var_46_0.display_name

	Managers.state.event:trigger("ui_event_add_mission_objective", "objective", Localize(var_46_5))

	arg_46_0._objective_ui_mission_name = "objective"

	Managers.state.event:trigger("weave_objective_synced")
	arg_46_0:_report_telemetry()
end

function WeaveManager.player_damaged(arg_47_0, arg_47_1)
	arg_47_0._damage_taken = math.min(WeaveSettings.max_damage_taken, arg_47_0._damage_taken + arg_47_1)
end

function WeaveManager.current_bar_score(arg_48_0)
	local var_48_0 = Managers.state.network:game()

	if var_48_0 and arg_48_0._go_id then
		local var_48_1 = GameSession.game_object_field(var_48_0, arg_48_0._go_id, "bar_score")
		local var_48_2 = arg_48_0._bar_score

		return var_48_1 < var_48_2 and var_48_2 or var_48_1
	else
		return 0
	end
end

function WeaveManager.increase_bar_score(arg_49_0, arg_49_1)
	fassert(arg_49_0._is_server, "can't increase weave score as a client")

	local var_49_0 = arg_49_0:get_active_objective_template()

	if var_49_0 then
		local var_49_1 = var_49_0.bar_multiplier
		local var_49_2 = var_49_0.bar_cutoff

		arg_49_1 = arg_49_1 * var_49_1

		local var_49_3 = Managers.state.network:game()

		if var_49_3 and arg_49_0._go_id then
			arg_49_0._bar_score = math.min(math.max(arg_49_0._bar_score + arg_49_1, 0), var_49_2)

			if arg_49_0._bar_score == var_49_2 then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_bar_cutoff_reached")
			end

			GameSession.set_game_object_field(var_49_3, arg_49_0._go_id, "bar_score", arg_49_0._bar_score)
		end
	end
end

function WeaveManager.show_bar(arg_50_0)
	local var_50_0 = arg_50_0:get_active_objective_template()

	if var_50_0 and var_50_0.show_bar and not arg_50_0._bar_filled then
		return true
	end

	return false
end

function WeaveManager.get_active_objective_template(arg_51_0)
	if not arg_51_0._active_objective_index then
		return
	end

	local var_51_0 = arg_51_0._active_objective_index

	return WeaveSettings.templates[arg_51_0._active_weave_name].objectives[var_51_0]
end

function WeaveManager.get_scaling_difficulty_index(arg_52_0)
	return
end

function WeaveManager.get_active_weave_template(arg_53_0)
	if not arg_53_0._active_weave_name then
		return
	end

	return WeaveSettings.templates[arg_53_0._active_weave_name]
end

function WeaveManager.start_terror_event(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_0:get_active_weave_template()
	local var_54_1 = arg_54_0:get_active_objective_template()
	local var_54_2 = arg_54_0._active_objective_index

	fassert(var_54_0 ~= nil, "Tried to start terror event from WeaveManager without any active weave")
	fassert(var_54_1.terror_events ~= nil, string.format("%q does not contain a terror_events table for objective %s", var_54_0.name, var_54_2))
	fassert(table.contains(var_54_1.terror_events, arg_54_1), string.format("%q's terror_event table does not contain terror event '%q'", var_54_0.name, arg_54_1))
	arg_54_0._weave_spawner:start_terror_event_from_template(arg_54_1, arg_54_2)
end

function WeaveManager.stop_terror_event(arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = arg_55_0:get_active_weave_template()
	local var_55_1 = arg_55_0:get_active_objective_template()
	local var_55_2 = arg_55_0._active_objective_index

	fassert(var_55_0 ~= nil, "Tried to start terror event from WeaveManager without any active weave")
	fassert(var_55_1.terror_events ~= nil, string.format("%q does not contain a terror_events table for objective %s", var_55_0.name, var_55_2))
	fassert(table.contains(var_55_1.terror_events, arg_55_1), string.format("%q's terror_event table does not contain terror event '%q'", var_55_0.name, arg_55_1))

	local var_55_3 = string.format("%s_%s", arg_55_1, arg_55_2)

	TerrorEventMixer.stop_event(var_55_3)
end

function WeaveManager.get_wind_strength(arg_56_0)
	local var_56_0 = WeaveSettings.templates[arg_56_0._active_weave_name]

	return var_56_0 and var_56_0.wind_strength or 1
end

function WeaveManager._create_game_object(arg_57_0)
	local var_57_0 = {
		go_type = NetworkLookup.go_types.weave,
		bar_score = arg_57_0._bar_score,
		remaining_time = arg_57_0._remaining_time
	}
	local var_57_1 = callback(arg_57_0, "cb_game_session_disconnect")

	arg_57_0._go_id = Managers.state.network:create_game_object("weave", var_57_0, var_57_1)
end

function WeaveManager.game_object_created(arg_58_0, arg_58_1)
	arg_58_0._go_id = arg_58_1
end

function WeaveManager.game_object_destroyed(arg_59_0)
	arg_59_0._go_id = nil
end

function WeaveManager.cb_game_session_disconnect(arg_60_0)
	arg_60_0._go_id = nil
end

function WeaveManager.final_objective_completed(arg_61_0)
	if arg_61_0._is_server then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_weave_final_objective_completed")

		arg_61_0._pause_timer = true
	end

	if arg_61_0._objective_ui_mission_name then
		Managers.state.event:trigger("ui_event_complete_mission", arg_61_0._objective_ui_mission_name, true)
	end

	local var_61_0 = Managers.world:wwise_world(arg_61_0._world)

	WwiseWorld.trigger_event(var_61_0, "Play_hud_wind_objectives_complete")
	Managers.state.event:trigger("ui_event_add_mission_objective", "weave_victory", Localize("weave_victory"))

	arg_61_0._objective_ui_mission_name = "weave_victory"
end

function WeaveManager._objective_completed(arg_62_0)
	arg_62_0._bar_filled = true

	local var_62_0 = arg_62_0:get_active_objective_template()
	local var_62_1 = var_62_0.objective_completed_flow_event

	if var_62_1 then
		LevelHelper:flow_event(arg_62_0._world, var_62_1)
	end

	local var_62_2 = var_62_0.end_zone_name

	if var_62_2 then
		Managers.state.entity:system("end_zone_system"):activate_end_zone_by_name(var_62_2)
	end

	if arg_62_0._objective_ui_mission_name then
		Managers.state.event:trigger("ui_event_complete_mission", arg_62_0._objective_ui_mission_name)
	end

	local var_62_3 = arg_62_0:calculate_next_objective_index()
	local var_62_4 = WeaveSettings.templates[arg_62_0._active_weave_name].objectives
	local var_62_5 = var_62_0.bonus_time_on_complete

	if not (arg_62_0:get_time_left() <= 0) and var_62_5 and arg_62_0._is_server then
		arg_62_0._remaining_time = arg_62_0._remaining_time + var_62_5
	end

	if var_62_3 == #var_62_4 then
		local var_62_6 = Managers.world:wwise_world(arg_62_0._world)

		WwiseWorld.trigger_event(var_62_6, "Play_hud_wind_objectives_complete")

		local var_62_7 = Localize("reach_final_challenge_text")

		if var_62_5 then
			local var_62_8 = math.max(var_62_5, 0)
			local var_62_9 = math.floor(var_62_8 / 60)
			local var_62_10 = math.floor(var_62_9 / 60)
			local var_62_11 = string.format("%d:%02d", var_62_9 - var_62_10 * 60, var_62_8 % 60)

			var_62_7 = var_62_7 .. "\n+" .. var_62_11
		end

		Managers.state.event:trigger("ui_event_add_mission_objective", "objective_complete", var_62_7)

		arg_62_0._objective_ui_mission_name = "objective_complete"
	end

	Managers.state.entity:system("objective_system"):deactivate_all_objectives()
end

function WeaveManager._calculate_score(arg_63_0)
	local var_63_0 = WeaveSettings.max_damage_taken - arg_63_0._damage_taken
	local var_63_1 = arg_63_0._remaining_time * WeaveSettings.time_score_weighting

	return (math.floor(math.max(var_63_1 + var_63_0, 0) * 10))
end

function WeaveManager.get_bar_score(arg_64_0)
	return arg_64_0._bar_score
end

function WeaveManager.get_score(arg_65_0)
	return arg_65_0._score
end

function WeaveManager.get_time_score(arg_66_0)
	return math.floor(math.max(arg_66_0:get_score() - arg_66_0:get_damage_score(), 0))
end

function WeaveManager.get_damage_score(arg_67_0)
	return math.floor((WeaveSettings.max_damage_taken - arg_67_0._damage_taken) * 10)
end

function WeaveManager.get_weave_tier(arg_68_0)
	return WeaveSettings.templates[arg_68_0._active_weave_name].tier
end

function WeaveManager.get_num_players(arg_69_0)
	return arg_69_0._num_players
end

function WeaveManager.is_tracking_kills(arg_70_0)
	return arg_70_0._track_kills
end

function WeaveManager.ai_killed(arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
	if arg_71_0._track_kills then
		arg_71_0:_track_ai_killed(arg_71_3.breed.name)
	end

	Managers.state.entity:system("objective_system"):on_ai_killed(arg_71_1, arg_71_2, arg_71_3, arg_71_4)
end

function WeaveManager._track_ai_killed(arg_72_0, arg_72_1)
	if arg_72_0._is_server then
		arg_72_0._enemies_killed[arg_72_1] = arg_72_0._enemies_killed[arg_72_1] or 0
		arg_72_0._enemies_killed[arg_72_1] = arg_72_0._enemies_killed[arg_72_1] + 1
		arg_72_0._num_enemies_killed = arg_72_0._num_enemies_killed + 1

		local var_72_0 = Managers.state.difficulty:get_difficulty()
		local var_72_1 = arg_72_0:get_active_objective_template()

		if var_72_1 == nil then
			return
		end

		local var_72_2 = 1 / var_72_1.enemy_count[var_72_0] * 100

		arg_72_0:increase_bar_score(var_72_2)
	end
end

function WeaveManager.objective_set_completed(arg_73_0)
	local var_73_0 = Managers.state.entity:system("mission_system")
	local var_73_1 = var_73_0:get_missions()

	if var_73_1 and var_73_1.weave_collect_limited_item_objective then
		var_73_0:end_mission("weave_collect_limited_item_objective", true)
	end
end

function WeaveManager.rpc_bar_cutoff_reached(arg_74_0, arg_74_1)
	arg_74_0._bar_score = arg_74_0:get_active_objective_template().bar_cutoff
end

function WeaveManager.rpc_set_active_weave(arg_75_0, arg_75_1, arg_75_2, arg_75_3)
	local var_75_0 = NetworkLookup.weave_names[arg_75_2]

	arg_75_0:reset_statistics_for_challenges()
	arg_75_0:_set_active_weave(var_75_0)
	arg_75_0:_set_active_objective(arg_75_3)
	arg_75_0:start_objective()
	Managers.state.event:trigger("weave_objective_synced")
end

function WeaveManager.rpc_weave_objective_completed(arg_76_0, arg_76_1)
	arg_76_0:_objective_completed()
end

function WeaveManager.rpc_sync_end_of_weave_data(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4, arg_77_5)
	arg_77_0._score = arg_77_2
	arg_77_0._remaining_time = arg_77_3
	arg_77_0._num_players = arg_77_4
	arg_77_0._damage_taken = arg_77_5
end

function WeaveManager.rpc_sync_player_count(arg_78_0, arg_78_1, arg_78_2)
	arg_78_0._num_players = arg_78_2
end

function WeaveManager.rpc_weave_final_objective_completed(arg_79_0, arg_79_1)
	arg_79_0:final_objective_completed()
end
