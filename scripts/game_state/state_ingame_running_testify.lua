-- chunkname: @scripts/game_state/state_ingame_running_testify.lua

local function var_0_0(arg_1_0)
	return arg_1_0.has_setup_end_of_level == true
end

local function var_0_1(arg_2_0)
	if not var_0_0(arg_2_0) then
		return Testify.RETRY
	end
end

return {
	level_end_screen_displayed = function(arg_3_0)
		return var_0_0(arg_3_0)
	end,
	has_lost = function(arg_4_0)
		return arg_4_0.game_lost
	end,
	start_measure_fps = function(arg_5_0)
		arg_5_0._fps_reporter_testify = FPSReporter:new()
	end,
	stop_measure_fps = function(arg_6_0, arg_6_1)
		local var_6_0 = arg_6_0._fps_reporter_testify:avg_fps()
		local var_6_1, var_6_2 = Managers.free_flight:camera_position_rotation(1)

		Managers.telemetry_events:fps_at_point(arg_6_1, var_6_1, var_6_2, var_6_0)

		arg_6_0._fps_reporter_testify = nil
	end,
	memory_usage = function(arg_7_0, arg_7_1)
		local var_7_0 = Memory.usage()

		Managers.telemetry_events:memory_usage(arg_7_1, var_7_0)
	end,
	wait_for_level_to_be_loaded = function(arg_8_0)
		if not arg_8_0._game_started_current_frame then
			return Testify.RETRY
		end
	end,
	fail_test = function(arg_9_0, arg_9_1)
		assert(false, arg_9_1)
	end,
	set_camera_to_observe_first_bot = function(arg_10_0)
		return var_0_1(arg_10_0)
	end,
	update_camera_to_follow_first_bot_rotation = function(arg_11_0)
		return var_0_1(arg_11_0)
	end,
	set_player_unit_not_visible = function(arg_12_0)
		return var_0_1(arg_12_0)
	end,
	teleport_player_to_main_path_point = function(arg_13_0)
		return var_0_1(arg_13_0)
	end,
	teleport_bots_forward_on_main_path_if_blocked = function(arg_14_0)
		return var_0_1(arg_14_0)
	end,
	total_main_path_distance = function(arg_15_0)
		return var_0_1(arg_15_0)
	end,
	is_end_zone_activated = function(arg_16_0)
		return var_0_1(arg_16_0)
	end,
	spawn_essence_on_first_bot_position = function(arg_17_0)
		return var_0_1(arg_17_0)
	end,
	make_players_invicible = function(arg_18_0)
		return var_0_1(arg_18_0)
	end,
	are_bots_blocked = function(arg_19_0)
		return var_0_1(arg_19_0)
	end,
	make_player_and_one_bot_invicible = function(arg_20_0)
		return var_0_1(arg_20_0)
	end,
	get_active_weave_phase = function(arg_21_0)
		return var_0_1(arg_21_0)
	end,
	teleport_player_randomly_on_main_path = function(arg_22_0)
		return var_0_1(arg_22_0)
	end,
	teleport_player_to_end_zone_position = function(arg_23_0)
		return var_0_1(arg_23_0)
	end
}
