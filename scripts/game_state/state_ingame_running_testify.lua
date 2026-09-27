-- chunkname: @scripts/game_state/state_ingame_running_testify.lua

local function fn(self)
	-- function 1
	return self.has_setup_end_of_level == true
end

local function fn_2(arg_2_0)
	-- function 2
	if not fn(arg_2_0) then
		return Testify.RETRY
	end
end

return {
	level_end_screen_displayed = function (arg_3_0)
		-- function 3
		return fn(arg_3_0)
	end,
	has_lost = function (self)
		-- function 4
		return self.game_lost
	end,
	start_measure_fps = function (self)
		-- function 5
		self._fps_reporter_testify = FPSReporter:new()
	end,
	stop_measure_fps = function (self, arg_6_1)
		-- function 6
		local avg_fps = self._fps_reporter_testify:avg_fps()
		local camera_position_rotation, var_6_2 = Managers.free_flight:camera_position_rotation(1)

		Managers.telemetry_events:fps_at_point(arg_6_1, camera_position_rotation, var_6_2, avg_fps)

		self._fps_reporter_testify = nil
	end,
	memory_usage = function (arg_7_0, arg_7_1)
		-- function 7
		local usage = Memory.usage()

		Managers.telemetry_events:memory_usage(arg_7_1, usage)
	end,
	wait_for_level_to_be_loaded = function (self)
		-- function 8
		if not self._game_started_current_frame then
			return Testify.RETRY
		end
	end,
	fail_test = function (arg_9_0, arg_9_1)
		-- function 9
		assert(false, arg_9_1)
	end,
	set_camera_to_observe_first_bot = function (arg_10_0)
		-- function 10
		return fn_2(arg_10_0)
	end,
	update_camera_to_follow_first_bot_rotation = function (arg_11_0)
		-- function 11
		return fn_2(arg_11_0)
	end,
	set_player_unit_not_visible = function (arg_12_0)
		-- function 12
		return fn_2(arg_12_0)
	end,
	teleport_player_to_main_path_point = function (arg_13_0)
		-- function 13
		return fn_2(arg_13_0)
	end,
	teleport_bots_forward_on_main_path_if_blocked = function (arg_14_0)
		-- function 14
		return fn_2(arg_14_0)
	end,
	total_main_path_distance = function (arg_15_0)
		-- function 15
		return fn_2(arg_15_0)
	end,
	is_end_zone_activated = function (arg_16_0)
		-- function 16
		return fn_2(arg_16_0)
	end,
	spawn_essence_on_first_bot_position = function (arg_17_0)
		-- function 17
		return fn_2(arg_17_0)
	end,
	make_players_invicible = function (arg_18_0)
		-- function 18
		return fn_2(arg_18_0)
	end,
	are_bots_blocked = function (arg_19_0)
		-- function 19
		return fn_2(arg_19_0)
	end,
	make_player_and_one_bot_invicible = function (arg_20_0)
		-- function 20
		return fn_2(arg_20_0)
	end,
	get_active_weave_phase = function (arg_21_0)
		-- function 21
		return fn_2(arg_21_0)
	end,
	teleport_player_randomly_on_main_path = function (arg_22_0)
		-- function 22
		return fn_2(arg_22_0)
	end,
	teleport_player_to_end_zone_position = function (arg_23_0)
		-- function 23
		return fn_2(arg_23_0)
	end
}
