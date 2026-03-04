-- chunkname: @scripts/tests/test_cases.lua

local var_0_0 = require("scripts/tests/testify_input")
local var_0_1 = require("scripts/tests/testify_snippets")

TestCases = {}

TestCases.smoke = function ()
	Testify:run_case(function (arg_2_0, arg_2_1)
		var_0_1.load_level({
			level_key = "inn_level"
		})
	end)
end

TestCases.load_level = function (arg_3_0, arg_3_1, arg_3_2)
	Testify:run_case(function (arg_4_0, arg_4_1)
		var_0_1.load_level({
			level_key = arg_3_0
		})

		if not arg_3_1 then
			Testify:make_request("wait_for_cutscene_to_finish")
		end

		if arg_3_2 then
			Testify:make_request("wait_for_player_to_spawn")
		end
	end)
end

TestCases.wait_for_state_ingame_reached = function ()
	Testify:run_case(function (arg_6_0, arg_6_1)
		Testify:make_request("wait_for_state_ingame_reached")
	end)
end

TestCases.equip_weapons = function (arg_7_0)
	Testify:run_case(function (arg_8_0, arg_8_1)
		if arg_7_0 then
			Testify:make_request("set_game_mode_to_weave")
			var_0_1.load_weave("weave_1")
		else
			var_0_1.load_level({
				level_key = "military"
			})
			Testify:make_request("wait_for_cutscene_to_finish")
		end

		Testify:make_request("clear_backend_inventory")
		Testify:make_request("wait_for_players_inventory_ready")
		var_0_1.set_script_data({
			ai_bots_disabled = true,
			allow_same_bots = true
		})

		local var_8_0 = {}
		local var_8_1 = Testify:make_request("request_profiles", "heroes")

		for iter_8_0, iter_8_1 in ipairs(var_8_1) do
			for iter_8_2, iter_8_3 in ipairs(iter_8_1.careers) do
				var_0_1.set_player_profile(iter_8_1.name, iter_8_3)
				var_0_1.set_bot_profile(iter_8_1.name, iter_8_3)
				Testify:make_request("add_all_weapon_skins")
				Testify:make_request("wait_for_players_inventory_ready")

				local var_8_2

				if arg_7_0 then
					var_8_2 = Testify:make_request("request_magic_weapons_for_career", iter_8_3)
				else
					var_8_2 = Testify:make_request("request_non_magic_weapons_for_career", iter_8_3)
				end

				for iter_8_4, iter_8_5 in pairs(var_8_2) do
					local var_8_3 = iter_8_5.backend_id

					if not var_8_0[var_8_3] then
						printf("[Testify] Wielding weapon %s (%s)", iter_8_5.data.display_name, var_8_3)

						var_8_0[var_8_3] = true

						Testify:make_request("player_wield_weapon", iter_8_5)
						Testify:make_request("wait_for_inventory_to_be_loaded")
						Testify:make_request("bot_wield_weapon", iter_8_5)
					end
				end
			end
		end
	end)
end

TestCases.equip_magic_weapons = function ()
	TestCases.equip_weapons(true)
end

TestCases.load_all_weaves = function ()
	Testify:run_case(function ()
		Testify:make_request("set_game_mode_to_weave")

		for iter_11_0 = 1, 160 do
			local var_11_0 = "weave_" .. iter_11_0

			print("[Testify] Loading " .. var_11_0)
			var_0_1.load_weave(var_11_0)
			var_0_1.wait(4)
		end
	end)
end

TestCases.load_weave = function (arg_12_0)
	Testify:run_case(function ()
		Testify:make_request("set_game_mode_to_weave")

		local var_13_0 = "weave_" .. arg_12_0

		var_0_1.load_weave(var_13_0)
		var_0_1.wait(4)
	end)
end

TestCases.run_through_level = function (arg_14_0, arg_14_1)
	Testify:run_case(function (arg_15_0, arg_15_1)
		local var_15_0 = ""

		var_0_1.set_script_data({
			power_level_override = 1600,
			ai_bots_disabled = false
		})

		local var_15_1 = cjson.decode(arg_14_0 or "{}")
		local var_15_2 = var_15_1.level_key
		local var_15_3 = var_15_1.memory_usage

		var_0_1.load_level({
			level_key = var_15_2
		})

		if not arg_14_1 then
			Testify:make_request("wait_for_cutscene_to_finish")
		end

		local var_15_4 = 0
		local var_15_5 = Testify:make_request("total_main_path_distance")
		local var_15_6 = os.clock()
		local var_15_7 = 2 * GLOBAL_TIME_SCALE
		local var_15_8 = 0
		local var_15_9 = 3
		local var_15_10 = (var_15_5 - 10) / (var_15_9 - 1)
		local var_15_11 = 0
		local var_15_12 = {}

		for iter_15_0 = 1, 3 do
			var_15_12[iter_15_0] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local var_15_13 = {
			main_path_point = 0,
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = var_15_12
		}

		while not Testify:make_request("level_end_screen_displayed") and var_15_4 < var_15_5 - 10 do
			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")

			local var_15_14 = os.clock() - var_15_6

			var_15_6 = os.clock()

			local var_15_15 = Testify:make_request("closest_travel_distance_to_player")

			var_15_4 = var_15_4 < var_15_15 and var_15_15 or var_15_4
			var_15_4 = var_15_4 + var_15_7 * var_15_14

			Testify:make_request("teleport_player_to_main_path_point", var_15_4)
			Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", var_15_13)

			var_15_13.main_path_point = var_15_4

			if var_15_3 and var_15_11 < var_15_4 and var_15_8 < var_15_9 then
				var_15_8 = var_15_8 + 1
				var_15_11 = var_15_11 + var_15_10

				Testify:make_request("memory_usage", var_15_8)
			end

			Testify:make_request("make_player_and_two_bots_invicible")

			local var_15_16 = 0

			while var_15_16 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				var_15_16 = var_15_16 + arg_15_0
			end
		end

		if Testify:make_request("level_end_screen_displayed") then
			if Testify:make_request("has_lost") then
				var_15_0 = var_15_0 .. "Defeated"
			else
				var_15_0 = var_15_0 .. "Victorious"
			end

			Testify:make_request("close_level_end_screen")
		else
			var_15_0 = var_15_0 .. "End of level reached"
		end

		Testify:make_request("post_telemetry_events")
		var_0_1.wait(5)
		print("[Testify] Level finished!")

		return var_15_0
	end)
end

TestCases.run_through_weave = function (arg_16_0)
	Testify:run_case(function (arg_17_0, arg_17_1)
		local var_17_0 = ""

		var_0_1.set_script_data({
			power_level_override = 1600,
			ai_bots_disabled = false
		})

		local var_17_1 = cjson.decode(arg_16_0 or "{}")
		local var_17_2 = var_17_1.memory_usage
		local var_17_3 = var_17_1.weave_number
		local var_17_4 = "weave_" .. var_17_3
		local var_17_5 = Testify:make_request("get_weave_end_zone", var_17_3)

		Testify:make_request("set_game_mode_to_weave")
		var_0_1.load_weave(var_17_4)

		local var_17_6 = false
		local var_17_7 = 0
		local var_17_8 = Testify:make_request("total_main_path_distance")
		local var_17_9 = os.clock()
		local var_17_10 = 1 * GLOBAL_TIME_SCALE
		local var_17_11 = 0
		local var_17_12 = 3
		local var_17_13 = (var_17_8 - 10) / (var_17_12 - 1)
		local var_17_14 = 0
		local var_17_15 = {}

		for iter_17_0 = 1, 3 do
			var_17_15[iter_17_0] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local var_17_16 = {
			main_path_point = 0,
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = var_17_15
		}

		while not Testify:make_request("level_end_screen_displayed") and var_17_7 < var_17_8 - 10 do
			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")
			Testify:make_request("teleport_player_to_main_path_point", var_17_7)
			Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", var_17_16)

			var_17_7 = var_17_7 + (os.clock() - var_17_9) * var_17_10
			var_17_9 = os.clock()
			var_17_16.main_path_point = var_17_7

			if var_17_2 and var_17_14 < var_17_7 and var_17_11 < var_17_12 then
				var_17_11 = var_17_11 + 1
				var_17_14 = var_17_14 + var_17_13

				Testify:make_request("memory_usage", var_17_11)
			end

			Testify:make_request("make_players_invicible")

			local var_17_17 = 0

			while var_17_17 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				var_17_17 = var_17_17 + arg_17_0
			end
		end

		if Testify:make_request("level_end_screen_displayed") then
			if Testify:make_request("weave_remaining_time") == 0 then
				var_17_0 = var_17_0 .. "Out of time, Phase 1"
			else
				var_17_0 = var_17_0 .. "Defeated Phase 1"
			end
		end

		if not Testify:make_request("is_end_zone_activated", var_17_5) then
			var_17_0 = var_17_0 .. "Cheat to complete objectives\n"
		end

		while not Testify:make_request("is_end_zone_activated", var_17_5) do
			var_17_6 = Testify:make_request("level_end_screen_displayed")

			if var_17_6 then
				if Testify:make_request("weave_remaining_time") == 0 then
					var_17_0 = var_17_0 .. "Out of time, Phase 1"

					break
				end

				var_17_0 = var_17_0 .. "Defeated Phase 1"

				break
			end

			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")
			Testify:make_request("weave_spawn_essence_on_first_bot_position")
			Testify:make_request("make_players_invicible")

			local var_17_18 = 0

			while var_17_18 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				var_17_18 = var_17_18 + arg_17_0
			end
		end

		Testify:make_request("teleport_player_to_end_zone_position", var_17_5)

		while not var_17_6 do
			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")

			if Testify:make_request("are_bots_blocked", var_17_16) and Testify:make_request("get_active_weave_phase") == 2 then
				Testify:make_request("teleport_player_randomly_on_main_path")
			end

			Testify:make_request("make_players_invicible")

			local var_17_19 = 0

			while var_17_19 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				var_17_19 = var_17_19 + arg_17_0
			end

			if Testify:make_request("level_end_screen_displayed") then
				if Testify:make_request("weave_remaining_time") == 0 then
					var_17_0 = var_17_0 .. "Out of time, Phase 2"
				elseif Testify:make_request("has_lost") then
					var_17_0 = var_17_0 .. "Defeated Phase 2"
				else
					var_17_0 = var_17_0 .. "Victorious"
				end

				var_17_6 = true
			end
		end

		Testify:make_request("post_telemetry_events")
		Testify:make_request("make_game_ready_for_next_weave")

		return var_17_0
	end)
end

TestCases.load_level_environment_variations = function (arg_18_0)
	Testify:run_case(function ()
		local var_19_0 = "Variations loaded:\n"
		local var_19_1 = Testify:make_request("get_level_weather_variations", arg_18_0)

		if type(var_19_1) ~= "table" or next(var_19_1) == nil then
			var_19_0 = var_19_0 .. "None"

			print(var_19_0)

			return var_19_0
		end

		for iter_19_0, iter_19_1 in ipairs(var_19_1) do
			local var_19_2 = {
				level_key = arg_18_0,
				environment_variation_id = iter_19_0
			}

			var_0_1.load_level(var_19_2)
			Testify:make_request("wait_for_cutscene_to_finish")

			var_19_0 = var_19_0 .. iter_19_1 .. " "
		end

		print(var_19_0)

		return var_19_0
	end)
end

TestCases.measure_performance = function (arg_20_0, arg_20_1)
	Testify:run_case(function ()
		var_0_1.disable_ai()
		var_0_1.disable_level_intro_dialogue()
		var_0_1.load_level({
			level_key = arg_20_0
		})

		if not arg_20_1 then
			Testify:make_request("wait_for_cutscene_to_finish")
		end

		local var_21_0 = 10
		local var_21_1 = 2
		local var_21_2 = {
			{
				z = -90,
				x = 0,
				y = 0
			},
			{
				z = 0,
				x = 0,
				y = 0
			},
			{
				z = 90,
				x = 0,
				y = 0
			},
			{
				z = 180,
				x = 0,
				y = 0
			}
		}
		local var_21_3 = Testify:make_request("get_main_path_points", var_21_0)

		Testify:make_request("activate_free_flight")

		for iter_21_0 = 1, var_21_0 do
			for iter_21_1 = 1, #var_21_2 do
				Testify:make_request("move_free_flight_camera", {
					position = var_21_3[iter_21_0],
					rotation = var_21_2[iter_21_1]
				})
				Testify:make_request("start_measure_fps")
				var_0_1.wait(var_21_1)

				local var_21_4 = string.format("%d.%d", iter_21_0, iter_21_1)

				Testify:make_request("stop_measure_fps", var_21_4)
			end
		end

		Testify:make_request("post_telemetry_events")
	end)
end

TestCases.measure_deus_performance = function (arg_22_0)
	TestCases.measure_performance(arg_22_0, true)
end

TestCases.run_through_deus_level = function (arg_23_0)
	TestCases.run_through_level(arg_23_0, true)
end

TestCases.run_through_deus_level_terror_event = function (arg_24_0, arg_24_1, arg_24_2)
	Testify:run_case(function (arg_25_0, arg_25_1)
		arg_24_1 = arg_24_1 or "deus_TEST_ALL_BREED"
		arg_24_2 = arg_24_2 or 10

		local var_25_0 = ""

		var_0_1.load_level({
			level_key = arg_24_0
		})
		var_0_1.set_script_data({
			insta_death = true,
			disable_external_velocity = true,
			disable_vortex_attraction = true,
			disable_catapulting = true,
			ai_terror_events_disabled = true,
			debug_terror = true,
			ai_bots_disabled = false,
			infinite_ammo = true,
			power_level_override = 1600,
			only_allowed_terror_event = arg_24_1
		})

		local var_25_1 = Managers.state.entity:system("ai_system"):nav_world()
		local var_25_2 = Testify:make_request("peaks")
		local var_25_3 = var_25_2[#var_25_2] + arg_24_2
		local var_25_4 = Testify:make_request("total_main_path_distance")
		local var_25_5 = math.clamp(var_25_3, 0, var_25_4 - 1)
		local var_25_6 = {}

		for iter_25_0 = 1, 3 do
			var_25_6[iter_25_0] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local var_25_7 = {
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = var_25_6,
			main_path_point = var_25_5
		}

		Testify:make_request("make_players_invicible")
		Testify:make_request("set_player_unit_not_visible")
		Testify:make_request("set_camera_to_observe_first_bot")
		Testify:make_request("teleport_player_to_main_path_point", var_25_5)

		local var_25_8 = 0

		while var_25_8 < 0.1 do
			Testify:make_request("update_camera_to_follow_first_bot_rotation")

			var_25_8 = var_25_8 + arg_25_0
		end

		Testify:make_request("add_buffs_to_heroes", {
			"ledge_rescue",
			"disable_rescue"
		})
		Testify:make_request("start_terror_event", arg_24_1)

		local var_25_9 = os.clock()
		local var_25_10 = vector_string(Testify:make_request("get_player_current_position"))

		printf("[Testify] Terror event triggered at position: %s", var_25_10)

		while true do
			if Testify:make_request("terror_event_finished", arg_24_1) then
				break
			end

			local var_25_11 = MainPathUtils.point_on_mainpath(nil, var_25_5)
			local var_25_12 = ConflictUtils.get_spawn_pos_on_circle(var_25_1, var_25_11, 15, 7, 15)

			if var_25_12 then
				local var_25_13 = Vector3Box(var_25_12)

				Testify:make_request("teleport_player_to_position", var_25_13)
			end

			Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", var_25_7)

			if Testify:make_request("level_end_screen_displayed") then
				if Testify:make_request("has_lost") then
					Testify:make_request("fail_test", "Test failed due to players/bot dying to the AI")
				else
					Testify:make_request("fail_test", "Test failed due to level ending before terror event finished")
				end
			end

			var_0_1.wait(2)
		end

		local var_25_14 = os.clock() - var_25_9
		local var_25_15 = var_25_0 .. string.format("Terror event finished after %ss", var_25_14)

		var_0_1.wait(5)
		print("[Testify] Level finished!")

		return var_25_15
	end)
end

TestCases.run_through_pvp_level = function (arg_26_0)
	Testify:run_case(function (arg_27_0, arg_27_1)
		local var_27_0 = ""

		var_0_1.set_script_data({
			power_level_override = 1600,
			ai_bots_disabled = false
		})

		local var_27_1 = cjson.decode(arg_26_0 or "{}")
		local var_27_2 = var_27_1.level_key
		local var_27_3 = var_27_1.memory_usage

		var_0_1.load_level({
			level_key = var_27_2
		})

		local var_27_4 = 0
		local var_27_5 = Testify:make_request("total_main_path_distance")
		local var_27_6 = os.clock()
		local var_27_7 = 2 * GLOBAL_TIME_SCALE
		local var_27_8 = 0
		local var_27_9 = 3
		local var_27_10 = (var_27_5 - 10) / (var_27_9 - 1)
		local var_27_11 = 0
		local var_27_12 = {}

		for iter_27_0 = 1, 3 do
			var_27_12[iter_27_0] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local var_27_13 = {
			main_path_point = 0,
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = var_27_12
		}

		Testify:make_request("versus_objective_add_time", 3000)

		local var_27_14 = false

		while not var_27_14 and var_27_4 < var_27_5 - 10 do
			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")
			Testify:make_request("teleport_player_to_main_path_point", var_27_4)
			Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", var_27_13)

			var_27_4 = var_27_4 + (os.clock() - var_27_6) * var_27_7
			var_27_6 = os.clock()
			var_27_13.main_path_point = var_27_4

			if var_27_3 and var_27_11 < var_27_4 and var_27_8 < var_27_9 then
				var_27_8 = var_27_8 + 1
				var_27_11 = var_27_11 + var_27_10

				Testify:make_request("memory_usage", var_27_8)
			end

			Testify:make_request("make_player_and_two_bots_invicible")

			local var_27_15 = Testify:make_request("versus_objective_type")
			local var_27_16 = Testify:make_request("versus_current_objective_position")

			if var_27_15 == "objective_not_supported" then
				var_0_1.wait(1)
				Testify:make_request("versus_complete_objectives")
				var_0_1.wait(1)
			elseif var_27_4 > var_27_16.main_path_point then
				local var_27_17 = Vector3Box(var_27_16.position)

				Testify:make_request("teleport_player_to_position", var_27_17)

				if var_27_15 == "objective_capture_point" then
					local var_27_18 = Testify:make_request("versus_objective_name")

					while var_27_18 == Testify:make_request("versus_objective_name") do
						Testify:make_request("update_camera_to_follow_first_bot_rotation")

						if Testify:make_request("versus_has_lost") then
							break
						end
					end
				elseif var_27_15 == "objective_interact" then
					Testify:make_request("versus_objective_simulate_interaction")
				end
			end

			local var_27_19 = 0

			while var_27_19 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				var_27_19 = var_27_19 + arg_27_0
			end

			var_27_14 = Testify:make_request("versus_has_lost") == true
		end

		if var_27_14 then
			var_27_0 = var_27_0 .. "Defeated"
		else
			var_27_0 = var_27_0 .. "End of level reached"
		end

		if var_27_3 then
			Testify:make_request("post_telemetry_events")
		end

		var_0_1.wait(5)
		print("[Testify] Level finished!")

		return var_27_0
	end)
end

TestCases.spawn_all_enemies = function (arg_28_0)
	Testify:run_case(function (arg_29_0, arg_29_1)
		local var_29_0 = ""
		local var_29_1 = {}
		local var_29_2 = {}
		local var_29_3 = cjson.decode(arg_28_0 or "{}")
		local var_29_4 = var_29_3.kill_timer or 30
		local var_29_5 = var_29_3.spawn_simultaneously or true
		local var_29_6 = var_29_3.difficulty or "hard"

		Testify:make_request("set_difficulty", var_29_6)
		var_0_1.load_level({
			level_key = "plaza"
		})
		Testify:make_request("wait_for_cutscene_to_finish")
		var_0_1.set_script_data({
			power_level_override = 1600,
			ai_bots_disabled = false
		})
		Testify:make_request("make_players_invicible")

		local var_29_7 = Testify:make_request("get_player_current_position")
		local var_29_8 = {
			z = 1,
			x = 8,
			y = -1
		}
		local var_29_9 = Vector3Box(var_29_7.x + var_29_8.x, var_29_7.y + var_29_8.y, var_29_7.z + var_29_8.z)
		local var_29_10 = Testify:make_request("get_all_breeds")

		for iter_29_0, iter_29_1 in pairs(var_29_10) do
			local var_29_11 = {
				breed_name = iter_29_0,
				breed_data = iter_29_1,
				boxed_spawn_position = var_29_9
			}

			printf("[Testify] " .. iter_29_0 .. " spawned")
			Testify:make_request("spawn_unit", var_29_11)

			var_29_11.unit = Testify:make_request("get_unit_of_breed", iter_29_0)

			if var_29_5 then
				table.insert(var_29_2, var_29_11)
			else
				local var_29_12
				local var_29_13 = os.clock()

				while var_29_4 > os.clock() - var_29_13 do
					var_29_12 = Testify:make_request("is_unit_alive", var_29_11.unit)

					if not var_29_12 then
						break
					end
				end

				if var_29_12 then
					local var_29_14 = Testify:make_request("get_unit_health_values", var_29_11.unit)
					local var_29_15 = iter_29_0 .. " " .. var_29_14.current_health .. "/" .. var_29_14.max_health

					printf("[Testify] " .. iter_29_0 .. " has been executed")
					Testify:make_request("kill_unit", var_29_11.unit)
					table.insert(var_29_1, var_29_15)
				end
			end
		end

		local var_29_16 = var_29_5 and var_29_4 or 5

		var_0_1.wait(var_29_16)

		if var_29_5 then
			for iter_29_2, iter_29_3 in pairs(var_29_2) do
				if Testify:make_request("is_unit_alive", iter_29_3.unit) then
					local var_29_17 = iter_29_3.breed_name
					local var_29_18 = Testify:make_request("get_unit_health_values", iter_29_3.unit)
					local var_29_19 = var_29_17 .. " " .. var_29_18.current_health .. "/" .. var_29_18.max_health

					printf("[Testify] " .. var_29_17 .. " has been executed")
					Testify:make_request("kill_unit", iter_29_3.unit)
					table.insert(var_29_1, var_29_19)
				end
			end

			Testify:make_request("destroy_all_units")
		end

		if not var_29_5 and not table.is_empty(var_29_1) then
			var_29_0 = "-Bots were unable to kill: " .. table.concat(var_29_1, ", ")
		end

		if var_29_0 == "" then
			var_29_0 = "All minion units were spawned and killed"
		end

		return var_29_0
	end)
end

TestCases.equip_deus_power_ups = function (arg_30_0)
	Testify:run_case(function (arg_31_0, arg_31_1)
		local var_31_0 = cjson.decode(arg_30_0 or "{}")
		local var_31_1 = var_31_0.power_up_type
		local var_31_2 = var_31_0.terror_event_name
		local var_31_3 = var_31_0.level_key
		local var_31_4 = var_31_0.profile_name
		local var_31_5 = var_31_0.career_name

		Testify:make_request("wait_for_state_ingame_reached")
		var_0_1.load_level({
			level_key = var_31_3
		})
		var_0_1.set_script_data({
			disable_catapulting = true,
			disable_external_velocity = true,
			disable_vortex_attraction = true,
			ai_terror_events_disabled = true,
			debug_terror = true,
			ai_bots_disabled = false,
			infinite_ammo = true,
			power_level_override = 1600,
			only_allowed_terror_event = var_31_2
		})

		local var_31_6 = Managers.state.entity:system("ai_system"):nav_world()
		local var_31_7 = Testify:make_request("peaks")
		local var_31_8 = var_31_7[#var_31_7]
		local var_31_9 = Testify:make_request("total_main_path_distance")
		local var_31_10 = math.clamp(var_31_8, 0, var_31_9 - 1)
		local var_31_11 = {}

		for iter_31_0 = 1, 3 do
			var_31_11[iter_31_0] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local var_31_12 = {
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = var_31_11,
			main_path_point = var_31_10
		}
		local var_31_13

		if var_31_1 == "talent" then
			var_31_13 = Testify:make_request("get_available_deus_talent_power_up_tests")
		elseif var_31_1 == "generic" then
			var_31_13 = Testify:make_request("get_available_deus_generic_power_up_tests")
		end

		for iter_31_1, iter_31_2 in pairs(var_31_13) do
			for iter_31_3, iter_31_4 in pairs(iter_31_2) do
				var_0_1.set_player_profile(var_31_4, var_31_5)
				var_0_1.set_bot_profile(var_31_4, var_31_5)
				Testify:make_request("wait_for_players_inventory_ready")
				Testify:make_request("add_buffs_to_heroes", {
					"ledge_rescue",
					"disable_rescue",
					"blessing_of_isha_invincibility"
				})

				local var_31_14 = {
					power_up_name = iter_31_3,
					rarity = iter_31_1
				}

				Testify:make_request("activate_bots_deus_power_up", var_31_14)
				Testify:make_request("activate_player_deus_power_up", var_31_14)
				printf("[Testify] Testing %s: for career %s", iter_31_3, var_31_5)
				iter_31_4(var_31_6, var_31_2, var_31_10, var_31_12)
				Testify:make_request("reset_deus_power_ups")
			end
		end

		print("[Testify] All deus power ups were tested!")

		return (string.format("All %s power-ups were test", var_31_1))
	end)
end

TestCases.write_morris_levels_to_file = function ()
	Testify:run_case(function (arg_33_0, arg_33_1)
		local var_33_0 = "C:\\deus_erb_variables.yaml"
		local var_33_1 = io.open(var_33_0, "w")

		var_33_1:write("# Generated by running the test TestCases.write_morris_levels_to_file()", "\n")
		var_33_1:write("variables:", "\n")
		var_33_1:write("  deus_levels:", "\n")

		local var_33_2 = {}
		local var_33_3 = require("levels/honduras_dlcs/morris/level_settings_morris")

		for iter_33_0, iter_33_1 in pairs(var_33_3) do
			local var_33_4 = iter_33_1.level_key

			if var_33_4 and iter_33_0 == var_33_4 then
				table.insert(var_33_2, "    - " .. var_33_4)
			end
		end

		for iter_33_2 = 1, #var_33_2 do
			var_33_1:write(var_33_2[iter_33_2], "\n")
		end

		var_33_1:flush()
		var_33_1:close()
	end)
end

TestCases.equip_hats = function ()
	Testify:run_case(function (arg_35_0, arg_35_1)
		var_0_1.load_level({
			level_key = "inn_level"
		})
		Testify:make_request("add_all_hats")
		Testify:make_request("wait_for_playfab_response", "devGrantItems")

		local var_35_0 = Testify:make_request("request_profiles", "heroes")

		for iter_35_0, iter_35_1 in ipairs(var_35_0) do
			for iter_35_2, iter_35_3 in ipairs(iter_35_1.careers) do
				var_0_1.set_player_profile(iter_35_1.name, iter_35_3)
				Testify:make_request("wait_for_players_inventory_ready")
				var_0_1.open_hero_view()
				var_0_1.open_cosmetics_inventory()
				var_0_1.equip_hats()
				Testify:make_request("close_hero_view")
			end
		end
	end)
end

TestCases.versus_multiplayer_server = function (arg_36_0)
	Testify:run_case(function (arg_37_0, arg_37_1)
		local var_37_0 = cjson.decode(arg_36_0 or "{}")
		local var_37_1 = var_37_0.do_early_win or false
		local var_37_2 = var_37_0.match_outcome or "draw"

		fassert(var_37_2 == "party_one" or var_37_2 == "party_two" or var_37_2 == "draw", "Unexpected 'match_outcome' setting. Expected 'party_one', 'party_two' or 'draw'")
		fassert(not var_37_1 or var_37_2 ~= "draw", "Unable to do early win and expect a draw")
		var_0_1.set_script_data({
			player_invincible = true,
			disable_gamemode_end = not var_37_1,
			versus_config = {
				filter_on_server_name = true
			}
		})
		Testify:make_request("wait_for_game_mode_state", {
			state = "dedicated_server_waiting_for_fully_reserved",
			game_mode = "inn_vs"
		})
		Testify:make_request("wait_for_game_mode_state", {
			state = "dedicated_server_starting_game",
			game_mode = "inn_vs"
		})
		Testify:make_request("wait_for_game_mode_state", {
			state = "pre_start_round_state",
			game_mode = "versus"
		})

		local var_37_3 = Testify:make_request("versus_get_num_sets")

		for iter_37_0 = 1, var_37_3 * 2 do
			print(string.format("TESTIFY - start of loop | i = %d | %d", iter_37_0, var_37_3 * 2))
			var_0_1.set_script_data({
				disable_gamemode_end = true
			})

			local var_37_4 = iter_37_0 % 2
			local var_37_5 = var_37_2 == "draw" or var_37_2 == "party_one" and var_37_4 == 1 or var_37_2 == "party_two" and var_37_4 == 0

			Testify:make_request("wait_for_game_mode_state", {
				state = "pre_start_round_state",
				game_mode = "versus"
			})
			Testify:make_request("versus_wait_for_initial_peers_spawned")
			var_0_1.wait(1)
			Testify:make_request("game_mode_start_round")
			Testify:make_request("wait_for_game_mode_state", {
				state = "match_running_state",
				game_mode = "versus"
			})

			local var_37_6

			if var_37_5 then
				var_37_6 = var_0_1.versus_complete_all_objectives()
			end

			var_0_1.set_script_data({
				disable_gamemode_end = false
			})
			Testify:make_request("versus_set_time", 0)

			if var_37_6 or iter_37_0 >= var_37_3 * 2 then
				Testify:make_request("wait_for_transition_state", "restart_game_server")

				break
			else
				Testify:make_request("wait_for_game_mode_state", {
					state = "post_round_state",
					game_mode = "versus"
				})
			end

			print(string.format("TESTIFY - end of loop | i = %d | %d", iter_37_0, var_37_3 * 2))
		end

		print("TESTIFY - out of loop")
	end)
end

TestCases.versus_multiplayer_client = function (arg_38_0)
	Testify:run_case(function (arg_39_0, arg_39_1)
		var_0_1.set_script_data({
			player_invincible = true,
			versus_config = {
				filter_on_server_name = true
			}
		})
		Testify:make_request("wait_for_game_mode", "inn_vs")
		Testify:make_request("wait_for_player_to_spawn")
		Testify:make_request("request_vote", {
			private_game = false,
			player_hosted = false,
			dedicated_servers_aws = false,
			join_method = "party",
			request_type = "versus_quickplay",
			matchmaking_type = "standard",
			mechanism = "versus",
			quick_game = true,
			difficulty = "versus_base",
			dedicated_servers_win = true
		})
		Testify:make_request("wait_for_matchmaking_substate", {
			substate = "waiting_for_join_message",
			state = "MatchmakingStateReserveLobby"
		})
		Testify:make_request("wait_for_matchmaking_state", "MatchmakingStateRequestJoinGame")
		Testify:make_request("wait_for_matchmaking_state", "MatchmakingStateJoinGame")
		Testify:make_request("wait_for_level_to_be_loaded")
		Testify:make_request("wait_for_game_mode_state", {
			state = "character_selection_state",
			game_mode = "versus"
		})
		Testify:make_request("versus_wait_for_local_player_hero_picking_turn")
		Testify:make_request("versus_select_random_available_hero")

		local var_39_0 = Testify:make_request("versus_get_num_sets")

		for iter_39_0 = 1, var_39_0 * 2 do
			print(string.format("TESTIFY - start of loop | i = %d | %d", iter_39_0, var_39_0 * 2))
			Testify:make_request("wait_for_game_mode_state", {
				state = "match_running_state",
				game_mode = "versus"
			})
			Testify:make_request("wait_for_game_mode_state", {
				state = "post_round_state",
				game_mode = "versus"
			})
			print(string.format("TESTIFY - end of loop | i = %d | %d", iter_39_0, var_39_0 * 2))

			if Testify:make_request("versus_party_won_early") then
				break
			end
		end

		print("TESTIFY - out of loop")
	end)
end
