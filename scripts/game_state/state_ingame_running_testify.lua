-- chunkname: @scripts/game_state/state_ingame_running_testify.lua

local function is_level_end_screen_displayed(state_ingame_running)
	-- function 1
	return state_ingame_running.has_setup_end_of_level == true
end

local function retry_if_end_screen_not_displayed(state_ingame_running)
	-- function 2
	local end_screen_displayed = is_level_end_screen_displayed(state_ingame_running)

	if not end_screen_displayed then
		return Testify.RETRY
	end
end

local StateInGameRunningTestify = {
	level_end_screen_displayed = function (state_ingame_running)
		-- function 3
		return is_level_end_screen_displayed(state_ingame_running)
	end,
	has_lost = function (state_ingame_running)
		-- function 4
		return state_ingame_running.game_lost
	end,
	start_measure_fps = function (state_ingame_running)
		-- function 5
		state_ingame_running._fps_reporter_testify = FPSReporter:new()
	end,
	stop_measure_fps = function (state_ingame_running, point_id)
		-- function 6
		local avg_fps = state_ingame_running._fps_reporter_testify:avg_fps()
		local cam_pos, cam_rot = Managers.free_flight:camera_position_rotation(1)

		Managers.telemetry_events:fps_at_point(point_id, cam_pos, cam_rot, avg_fps)

		state_ingame_running._fps_reporter_testify = nil
	end,
	memory_usage = function (_, index)
		-- function 7
		local memory_usage = Memory.usage()

		Managers.telemetry_events:memory_usage(index, memory_usage)
	end,
	wait_for_level_to_be_loaded = function (state_ingame_running)
		-- function 8
		if not state_ingame_running._game_started_current_frame then
			return Testify.RETRY
		end
	end,
	fail_test = function (_, message)
		-- function 9
		assert(false, message)
	end,
	set_camera_to_observe_first_bot = function (state_ingame_running)
		-- function 10
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	update_camera_to_follow_first_bot_rotation = function (state_ingame_running)
		-- function 11
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	set_player_unit_not_visible = function (state_ingame_running)
		-- function 12
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	teleport_player_to_main_path_point = function (state_ingame_running)
		-- function 13
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	teleport_bots_forward_on_main_path_if_blocked = function (state_ingame_running)
		-- function 14
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	total_main_path_distance = function (state_ingame_running)
		-- function 15
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	is_end_zone_activated = function (state_ingame_running)
		-- function 16
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	spawn_essence_on_first_bot_position = function (state_ingame_running)
		-- function 17
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	make_players_invicible = function (state_ingame_running)
		-- function 18
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	are_bots_blocked = function (state_ingame_running)
		-- function 19
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	make_player_and_one_bot_invicible = function (state_ingame_running)
		-- function 20
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	get_active_weave_phase = function (state_ingame_running)
		-- function 21
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	teleport_player_randomly_on_main_path = function (state_ingame_running)
		-- function 22
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end,
	teleport_player_to_end_zone_position = function (state_ingame_running)
		-- function 23
		return retry_if_end_screen_not_displayed(state_ingame_running)
	end
}

return StateInGameRunningTestify
