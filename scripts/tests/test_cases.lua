-- chunkname: @scripts/tests/test_cases.lua

local scripts_tests_testify_input = require("scripts/tests/testify_input")
local scripts_tests_testify_snippets = require("scripts/tests/testify_snippets")

TestCases = {}

TestCases.smoke = function ()
	-- function 1
	Testify:run_case(function (arg_2_0, arg_2_1)
		-- function 2
		scripts_tests_testify_snippets.load_level({
			level_key = "inn_level"
		})
	end)
end

TestCases.load_level = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	Testify:run_case(function (arg_4_0, arg_4_1)
		-- function 4
		scripts_tests_testify_snippets.load_level({
			level_key = arg_3_0
		})

		if not arg_3_1 then
			Testify:make_request("wait_for_cutscene_to_finish")
		end

		if not arg_3_2 then
			Testify:make_request("wait_for_player_to_spawn")
		end
	end)
end

TestCases.wait_for_state_ingame_reached = function ()
	-- function 5
	Testify:run_case(function (arg_6_0, arg_6_1)
		-- function 6
		Testify:make_request("wait_for_state_ingame_reached")
	end)
end

TestCases.equip_weapons = function (arg_7_0)
	-- function 7
	Testify:run_case(function (arg_8_0, arg_8_1)
		-- function 8
		if not arg_7_0 then
			Testify:make_request("set_game_mode_to_weave")
			scripts_tests_testify_snippets.load_weave("weave_1")
		else
			scripts_tests_testify_snippets.load_level({
				level_key = "military"
			})
			Testify:make_request("wait_for_cutscene_to_finish")
		end

		Testify:make_request("clear_backend_inventory")
		Testify:make_request("wait_for_players_inventory_ready")
		scripts_tests_testify_snippets.set_script_data({
			ai_bots_disabled = true,
			allow_same_bots = true
		})

		local tbl = {}
		local make_request = Testify:make_request("request_profiles", "heroes")

		for i, v in ipairs(make_request) do
			for i_2, v_2 in ipairs(v.careers) do
				scripts_tests_testify_snippets.set_player_profile(v.name, v_2)
				scripts_tests_testify_snippets.set_bot_profile(v.name, v_2)
				Testify:make_request("add_all_weapon_skins")
				Testify:make_request("wait_for_players_inventory_ready")

				local var_8_2

				if not arg_7_0 then
					var_8_2 = Testify:make_request("request_magic_weapons_for_career", v_2)
				else
					var_8_2 = Testify:make_request("request_non_magic_weapons_for_career", v_2)
				end

				for k, v_3 in pairs(var_8_2) do
					local backend_id = v_3.backend_id

					if not tbl[backend_id] then
						printf("[Testify] Wielding weapon %s (%s)", v_3.data.display_name, backend_id)

						tbl[backend_id] = true

						Testify:make_request("player_wield_weapon", v_3)
						Testify:make_request("wait_for_inventory_to_be_loaded")
						Testify:make_request("bot_wield_weapon", v_3)
					end
				end
			end
		end
	end)
end

TestCases.equip_magic_weapons = function ()
	-- function 9
	TestCases.equip_weapons(true)
end

TestCases.load_all_weaves = function ()
	-- function 10
	Testify:run_case(function ()
		-- function 11
		Testify:make_request("set_game_mode_to_weave")

		for i = 1, 160 do
			local str = "weave_" .. i

			print("[Testify] Loading " .. str)
			scripts_tests_testify_snippets.load_weave(str)
			scripts_tests_testify_snippets.wait(4)
		end
	end)
end

TestCases.load_weave = function (arg_12_0)
	-- function 12
	Testify:run_case(function ()
		-- function 13
		Testify:make_request("set_game_mode_to_weave")

		local str = "weave_" .. arg_12_0

		scripts_tests_testify_snippets.load_weave(str)
		scripts_tests_testify_snippets.wait(4)
	end)
end

TestCases.run_through_level = function (arg_14_0, arg_14_1)
	-- function 14
	Testify:run_case(function (arg_15_0, arg_15_1)
		-- function 15
		local str = ""

		scripts_tests_testify_snippets.set_script_data({
			power_level_override = 1600,
			ai_bots_disabled = false
		})

		local decode = cjson.decode
		local var_15_2 = arg_14_0

		var_15_2 = var_15_2 or "{}"

		local var_15_3 = decode(var_15_2)
		local level_key = var_15_3.level_key
		local memory_usage = var_15_3.memory_usage

		scripts_tests_testify_snippets.load_level({
			level_key = level_key
		})

		if not arg_14_1 then
			Testify:make_request("wait_for_cutscene_to_finish")
		end

		local num = 0
		local make_request = Testify:make_request("total_main_path_distance")
		local clock = os.clock()
		local num_2 = 2 * GLOBAL_TIME_SCALE
		local num_3 = 0
		local num_4 = 3
		local num_5 = (make_request - 10) / (num_4 - 1)
		local num_6 = 0
		local tbl = {}

		for i = 1, 3 do
			tbl[i] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local tbl_2 = {
			main_path_point = 0,
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = tbl
		}

		while not (Testify:make_request("level_end_screen_displayed") or not (num < make_request - 10)) do
			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")

			local num_7 = os.clock() - clock

			clock = os.clock()

			local make_request_2 = Testify:make_request("closest_travel_distance_to_player")

			num = not (num < make_request_2) or not make_request_2 or num
			num = num + num_2 * num_7

			Testify:make_request("teleport_player_to_main_path_point", num)
			Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", tbl_2)

			tbl_2.main_path_point = num

			if not (not memory_usage and not (num_6 < num) or not (num_3 < num_4)) then
				num_3 = num_3 + 1
				num_6 = num_6 + num_5

				Testify:make_request("memory_usage", num_3)
			end

			Testify:make_request("make_player_and_two_bots_invicible")

			local num_8 = 0

			while num_8 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				num_8 = num_8 + arg_15_0
			end
		end

		if not Testify:make_request("level_end_screen_displayed") then
			if not Testify:make_request("has_lost") then
				str = str .. "Defeated"
			else
				str = str .. "Victorious"
			end

			Testify:make_request("close_level_end_screen")
		else
			str = str .. "End of level reached"
		end

		Testify:make_request("post_telemetry_events")
		scripts_tests_testify_snippets.wait(5)
		print("[Testify] Level finished!")

		return str
	end)
end

TestCases.run_through_weave = function (arg_16_0)
	-- function 16
	Testify:run_case(function (arg_17_0, arg_17_1)
		-- function 17
		local str = ""

		scripts_tests_testify_snippets.set_script_data({
			power_level_override = 1600,
			ai_bots_disabled = false
		})

		local decode = cjson.decode
		local var_17_2 = arg_16_0

		var_17_2 = var_17_2 or "{}"

		local var_17_3 = decode(var_17_2)
		local memory_usage = var_17_3.memory_usage
		local weave_number = var_17_3.weave_number
		local str_2 = "weave_" .. weave_number
		local make_request = Testify:make_request("get_weave_end_zone", weave_number)

		Testify:make_request("set_game_mode_to_weave")
		scripts_tests_testify_snippets.load_weave(str_2)

		local flag = false
		local num = 0
		local make_request_2 = Testify:make_request("total_main_path_distance")
		local clock = os.clock()
		local num_2 = 1 * GLOBAL_TIME_SCALE
		local num_3 = 0
		local num_4 = 3
		local num_5 = (make_request_2 - 10) / (num_4 - 1)
		local num_6 = 0
		local tbl = {}

		for i = 1, 3 do
			tbl[i] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local tbl_2 = {
			main_path_point = 0,
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = tbl
		}

		while not (Testify:make_request("level_end_screen_displayed") or not (num < make_request_2 - 10)) do
			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")
			Testify:make_request("teleport_player_to_main_path_point", num)
			Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", tbl_2)

			num = num + (os.clock() - clock) * num_2
			clock = os.clock()
			tbl_2.main_path_point = num

			if not (not memory_usage and not (num_6 < num) or not (num_3 < num_4)) then
				num_3 = num_3 + 1
				num_6 = num_6 + num_5

				Testify:make_request("memory_usage", num_3)
			end

			Testify:make_request("make_players_invicible")

			local num_7 = 0

			while num_7 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				num_7 = num_7 + arg_17_0
			end
		end

		if not Testify:make_request("level_end_screen_displayed") then
			if Testify:make_request("weave_remaining_time") == 0 then
				str = str .. "Out of time, Phase 1"
			else
				str = str .. "Defeated Phase 1"
			end
		end

		if not Testify:make_request("is_end_zone_activated", make_request) then
			str = str .. "Cheat to complete objectives\n"
		end

		while not Testify:make_request("is_end_zone_activated", make_request) do
			flag = Testify:make_request("level_end_screen_displayed")

			if not flag then
				if Testify:make_request("weave_remaining_time") == 0 then
					str = str .. "Out of time, Phase 1"

					break
				end

				str = str .. "Defeated Phase 1"

				break
			end

			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")
			Testify:make_request("weave_spawn_essence_on_first_bot_position")
			Testify:make_request("make_players_invicible")

			local num_8 = 0

			while num_8 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				num_8 = num_8 + arg_17_0
			end
		end

		Testify:make_request("teleport_player_to_end_zone_position", make_request)

		while not flag do
			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")

			if not (not Testify:make_request("are_bots_blocked", tbl_2) and Testify:make_request("get_active_weave_phase") ~= 2) then
				Testify:make_request("teleport_player_randomly_on_main_path")
			end

			Testify:make_request("make_players_invicible")

			local num_9 = 0

			while num_9 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				num_9 = num_9 + arg_17_0
			end

			if not Testify:make_request("level_end_screen_displayed") then
				if Testify:make_request("weave_remaining_time") == 0 then
					str = str .. "Out of time, Phase 2"
				elseif not Testify:make_request("has_lost") then
					str = str .. "Defeated Phase 2"
				else
					str = str .. "Victorious"
				end

				flag = true
			end
		end

		Testify:make_request("post_telemetry_events")
		Testify:make_request("make_game_ready_for_next_weave")

		return str
	end)
end

TestCases.load_level_environment_variations = function (arg_18_0)
	-- function 18
	Testify:run_case(function ()
		-- function 19
		local str = "Variations loaded:\n"
		local make_request = Testify:make_request("get_level_weather_variations", arg_18_0)

		if not (type(make_request) ~= "table" or next(make_request) ~= nil) then
			str = str .. "None"

			print(str)

			return str
		end

		for i, v in ipairs(make_request) do
			local tbl = {
				level_key = arg_18_0,
				environment_variation_id = i
			}

			scripts_tests_testify_snippets.load_level(tbl)
			Testify:make_request("wait_for_cutscene_to_finish")

			str = str .. v .. " "
		end

		print(str)

		return str
	end)
end

TestCases.measure_performance = function (arg_20_0, arg_20_1)
	-- function 20
	Testify:run_case(function ()
		-- function 21
		scripts_tests_testify_snippets.disable_ai()
		scripts_tests_testify_snippets.disable_level_intro_dialogue()
		scripts_tests_testify_snippets.load_level({
			level_key = arg_20_0
		})

		if not arg_20_1 then
			Testify:make_request("wait_for_cutscene_to_finish")
		end

		local num = 10
		local num_2 = 2
		local tbl = {
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
		local make_request = Testify:make_request("get_main_path_points", num)

		Testify:make_request("activate_free_flight")

		for i = 1, num do
			for j = 1, #tbl do
				Testify:make_request("move_free_flight_camera", {
					position = make_request[i],
					rotation = tbl[j]
				})
				Testify:make_request("start_measure_fps")
				scripts_tests_testify_snippets.wait(num_2)

				local format = string.format("%d.%d", i, j)

				Testify:make_request("stop_measure_fps", format)
			end
		end

		Testify:make_request("post_telemetry_events")
	end)
end

TestCases.measure_deus_performance = function (arg_22_0)
	-- function 22
	TestCases.measure_performance(arg_22_0, true)
end

TestCases.run_through_deus_level = function (arg_23_0)
	-- function 23
	TestCases.run_through_level(arg_23_0, true)
end

TestCases.run_through_deus_level_terror_event = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	Testify:run_case(function (arg_25_0, arg_25_1)
		-- function 25
		local var_25_0 = arg_24_1

		var_25_0 = var_25_0 or "deus_TEST_ALL_BREED"
		arg_24_1 = var_25_0

		local var_25_1 = arg_24_2

		var_25_1 = var_25_1 or 10
		arg_24_2 = var_25_1

		local str = ""

		scripts_tests_testify_snippets.load_level({
			level_key = arg_24_0
		})
		scripts_tests_testify_snippets.set_script_data({
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

		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local make_request = Testify:make_request("peaks")
		local num = make_request[#make_request] + arg_24_2
		local make_request_2 = Testify:make_request("total_main_path_distance")
		local clamp = math.clamp(num, 0, make_request_2 - 1)
		local tbl = {}

		for i = 1, 3 do
			tbl[i] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local tbl_2 = {
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = tbl,
			main_path_point = clamp
		}

		Testify:make_request("make_players_invicible")
		Testify:make_request("set_player_unit_not_visible")
		Testify:make_request("set_camera_to_observe_first_bot")
		Testify:make_request("teleport_player_to_main_path_point", clamp)

		local num_2 = 0

		while num_2 < 0.1 do
			Testify:make_request("update_camera_to_follow_first_bot_rotation")

			num_2 = num_2 + arg_25_0
		end

		Testify:make_request("add_buffs_to_heroes", {
			"ledge_rescue",
			"disable_rescue"
		})
		Testify:make_request("start_terror_event", arg_24_1)

		local clock = os.clock()
		local var_25_12 = vector_string(Testify:make_request("get_player_current_position"))

		printf("[Testify] Terror event triggered at position: %s", var_25_12)

		while true do
			if not Testify:make_request("terror_event_finished", arg_24_1) then
				break
			end

			local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, clamp)
			local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(nav_world, point_on_mainpath, 15, 7, 15)

			if not get_spawn_pos_on_circle then
				local var_25_15 = Vector3Box(get_spawn_pos_on_circle)

				Testify:make_request("teleport_player_to_position", var_25_15)
			end

			Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", tbl_2)

			if not Testify:make_request("level_end_screen_displayed") then
				if not Testify:make_request("has_lost") then
					Testify:make_request("fail_test", "Test failed due to players/bot dying to the AI")
				else
					Testify:make_request("fail_test", "Test failed due to level ending before terror event finished")
				end
			end

			scripts_tests_testify_snippets.wait(2)
		end

		local num_3 = os.clock() - clock
		local str_2 = str .. string.format("Terror event finished after %ss", num_3)

		scripts_tests_testify_snippets.wait(5)
		print("[Testify] Level finished!")

		return str_2
	end)
end

TestCases.run_through_pvp_level = function (arg_26_0)
	-- function 26
	Testify:run_case(function (arg_27_0, arg_27_1)
		-- function 27
		local str = ""

		scripts_tests_testify_snippets.set_script_data({
			power_level_override = 1600,
			ai_bots_disabled = false
		})

		local decode = cjson.decode
		local var_27_2 = arg_26_0

		var_27_2 = var_27_2 or "{}"

		local var_27_3 = decode(var_27_2)
		local level_key = var_27_3.level_key
		local memory_usage = var_27_3.memory_usage

		scripts_tests_testify_snippets.load_level({
			level_key = level_key
		})

		local num = 0
		local make_request = Testify:make_request("total_main_path_distance")
		local clock = os.clock()
		local num_2 = 2 * GLOBAL_TIME_SCALE
		local num_3 = 0
		local num_4 = 3
		local num_5 = (make_request - 10) / (num_4 - 1)
		local num_6 = 0
		local tbl = {}

		for i = 1, 3 do
			tbl[i] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local tbl_2 = {
			main_path_point = 0,
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = tbl
		}

		Testify:make_request("versus_objective_add_time", 3000)

		local flag = false

		while not (flag or not (num < make_request - 10)) do
			Testify:make_request("set_player_unit_not_visible")
			Testify:make_request("set_camera_to_observe_first_bot")
			Testify:make_request("teleport_player_to_main_path_point", num)
			Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", tbl_2)

			num = num + (os.clock() - clock) * num_2
			clock = os.clock()
			tbl_2.main_path_point = num

			if not (not memory_usage and not (num_6 < num) or not (num_3 < num_4)) then
				num_3 = num_3 + 1
				num_6 = num_6 + num_5

				Testify:make_request("memory_usage", num_3)
			end

			Testify:make_request("make_player_and_two_bots_invicible")

			local make_request_2 = Testify:make_request("versus_objective_type")
			local make_request_3 = Testify:make_request("versus_current_objective_position")

			if make_request_2 == "objective_not_supported" then
				scripts_tests_testify_snippets.wait(1)
				Testify:make_request("versus_complete_objectives")
				scripts_tests_testify_snippets.wait(1)
			elseif num > make_request_3.main_path_point then
				local var_27_19 = Vector3Box(make_request_3.position)

				Testify:make_request("teleport_player_to_position", var_27_19)

				if make_request_2 == "objective_capture_point" then
					local make_request_4 = Testify:make_request("versus_objective_name")

					while make_request_4 == Testify:make_request("versus_objective_name") do
						Testify:make_request("update_camera_to_follow_first_bot_rotation")

						if not Testify:make_request("versus_has_lost") then
							break
						end
					end
				elseif make_request_2 == "objective_interact" then
					Testify:make_request("versus_objective_simulate_interaction")
				end
			end

			local num_7 = 0

			while num_7 < 0.1 do
				Testify:make_request("update_camera_to_follow_first_bot_rotation")

				num_7 = num_7 + arg_27_0
			end

			flag = Testify:make_request("versus_has_lost") == true
		end

		if not flag then
			str = str .. "Defeated"
		else
			str = str .. "End of level reached"
		end

		if not memory_usage then
			Testify:make_request("post_telemetry_events")
		end

		scripts_tests_testify_snippets.wait(5)
		print("[Testify] Level finished!")

		return str
	end)
end

TestCases.spawn_all_enemies = function (arg_28_0)
	-- function 28
	Testify:run_case(function (arg_29_0, arg_29_1)
		-- function 29
		local str = ""
		local tbl = {}
		local tbl_2 = {}
		local decode = cjson.decode
		local var_29_4 = arg_28_0

		var_29_4 = var_29_4 or "{}"

		local var_29_5 = decode(var_29_4)
		local kill_timer = var_29_5.kill_timer

		kill_timer = kill_timer or 30

		local spawn_simultaneously = var_29_5.spawn_simultaneously

		spawn_simultaneously = spawn_simultaneously or true

		local difficulty = var_29_5.difficulty

		difficulty = difficulty or "hard"

		Testify:make_request("set_difficulty", difficulty)
		scripts_tests_testify_snippets.load_level({
			level_key = "plaza"
		})
		Testify:make_request("wait_for_cutscene_to_finish")
		scripts_tests_testify_snippets.set_script_data({
			power_level_override = 1600,
			ai_bots_disabled = false
		})
		Testify:make_request("make_players_invicible")

		local make_request = Testify:make_request("get_player_current_position")
		local tbl_3 = {
			z = 1,
			x = 8,
			y = -1
		}
		local var_29_11 = Vector3Box(make_request.x + tbl_3.x, make_request.y + tbl_3.y, make_request.z + tbl_3.z)
		local make_request_2 = Testify:make_request("get_all_breeds")

		for k, v in pairs(make_request_2) do
			local tbl_4 = {
				breed_name = k,
				breed_data = v,
				boxed_spawn_position = var_29_11
			}

			printf("[Testify] " .. k .. " spawned")
			Testify:make_request("spawn_unit", tbl_4)

			tbl_4.unit = Testify:make_request("get_unit_of_breed", k)

			if not spawn_simultaneously then
				table.insert(tbl_2, tbl_4)
			else
				local var_29_14
				local clock = os.clock()

				while kill_timer > os.clock() - clock do
					var_29_14 = Testify:make_request("is_unit_alive", tbl_4.unit)

					if not var_29_14 then
						break
					end
				end

				if not var_29_14 then
					local make_request_3 = Testify:make_request("get_unit_health_values", tbl_4.unit)
					local str_2 = k .. " " .. make_request_3.current_health .. "/" .. make_request_3.max_health

					printf("[Testify] " .. k .. " has been executed")
					Testify:make_request("kill_unit", tbl_4.unit)
					table.insert(tbl, str_2)
				end
			end
		end

		local flag = not spawn_simultaneously and kill_timer and 5

		scripts_tests_testify_snippets.wait(flag)

		if not spawn_simultaneously then
			for k_2, v_2 in pairs(tbl_2) do
				if not Testify:make_request("is_unit_alive", v_2.unit) then
					local breed_name = v_2.breed_name
					local make_request_4 = Testify:make_request("get_unit_health_values", v_2.unit)
					local str_3 = breed_name .. " " .. make_request_4.current_health .. "/" .. make_request_4.max_health

					printf("[Testify] " .. breed_name .. " has been executed")
					Testify:make_request("kill_unit", v_2.unit)
					table.insert(tbl, str_3)
				end
			end

			Testify:make_request("destroy_all_units")
		end

		if not (spawn_simultaneously or table.is_empty(tbl)) then
			str = "-Bots were unable to kill: " .. table.concat(tbl, ", ")
		end

		if str == "" then
			str = "All minion units were spawned and killed"
		end

		return str
	end)
end

TestCases.equip_deus_power_ups = function (arg_30_0)
	-- function 30
	Testify:run_case(function (arg_31_0, arg_31_1)
		-- function 31
		local decode = cjson.decode
		local var_31_1 = arg_30_0

		var_31_1 = var_31_1 or "{}"

		local var_31_2 = decode(var_31_1)
		local power_up_type = var_31_2.power_up_type
		local terror_event_name = var_31_2.terror_event_name
		local level_key = var_31_2.level_key
		local profile_name = var_31_2.profile_name
		local career_name = var_31_2.career_name

		Testify:make_request("wait_for_state_ingame_reached")
		scripts_tests_testify_snippets.load_level({
			level_key = level_key
		})
		scripts_tests_testify_snippets.set_script_data({
			disable_catapulting = true,
			disable_external_velocity = true,
			disable_vortex_attraction = true,
			ai_terror_events_disabled = true,
			debug_terror = true,
			ai_bots_disabled = false,
			infinite_ammo = true,
			power_level_override = 1600,
			only_allowed_terror_event = terror_event_name
		})

		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local make_request = Testify:make_request("peaks")
		local var_31_10 = make_request[#make_request]
		local make_request_2 = Testify:make_request("total_main_path_distance")
		local clamp = math.clamp(var_31_10, 0, make_request_2 - 1)
		local tbl = {}

		for i = 1, 3 do
			tbl[i] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local tbl_2 = {
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = tbl,
			main_path_point = clamp
		}
		local var_31_15

		if power_up_type == "talent" then
			var_31_15 = Testify:make_request("get_available_deus_talent_power_up_tests")
		elseif power_up_type == "generic" then
			var_31_15 = Testify:make_request("get_available_deus_generic_power_up_tests")
		end

		for k, v in pairs(var_31_15) do
			for k_2, v_2 in pairs(v) do
				scripts_tests_testify_snippets.set_player_profile(profile_name, career_name)
				scripts_tests_testify_snippets.set_bot_profile(profile_name, career_name)
				Testify:make_request("wait_for_players_inventory_ready")
				Testify:make_request("add_buffs_to_heroes", {
					"ledge_rescue",
					"disable_rescue",
					"blessing_of_isha_invincibility"
				})

				local tbl_3 = {
					power_up_name = k_2,
					rarity = k
				}

				Testify:make_request("activate_bots_deus_power_up", tbl_3)
				Testify:make_request("activate_player_deus_power_up", tbl_3)
				printf("[Testify] Testing %s: for career %s", k_2, career_name)
				v_2(nav_world, terror_event_name, clamp, tbl_2)
				Testify:make_request("reset_deus_power_ups")
			end
		end

		print("[Testify] All deus power ups were tested!")

		return (string.format("All %s power-ups were test", power_up_type))
	end)
end

TestCases.write_morris_levels_to_file = function ()
	-- function 32
	Testify:run_case(function (arg_33_0, arg_33_1)
		-- function 33
		local str = "C:\\deus_erb_variables.yaml"
		local open = io.open(str, "w")

		open:write("# Generated by running the test TestCases.write_morris_levels_to_file()", "\n")
		open:write("variables:", "\n")
		open:write("  deus_levels:", "\n")

		local tbl = {}
		local levels_honduras_dlcs_morris_level_settings_morris = require("levels/honduras_dlcs/morris/level_settings_morris")

		for k, v in pairs(levels_honduras_dlcs_morris_level_settings_morris) do
			local level_key = v.level_key

			if not level_key and not (k == level_key) then
				table.insert(tbl, "    - " .. level_key)
			end
		end

		for k_2 = 1, #tbl do
			open:write(tbl[k_2], "\n")
		end

		open:flush()
		open:close()
	end)
end

TestCases.equip_hats = function ()
	-- function 34
	Testify:run_case(function (arg_35_0, arg_35_1)
		-- function 35
		scripts_tests_testify_snippets.load_level({
			level_key = "inn_level"
		})
		Testify:make_request("add_all_hats")
		Testify:make_request("wait_for_playfab_response", "devGrantItems")

		local make_request = Testify:make_request("request_profiles", "heroes")

		for i, v in ipairs(make_request) do
			for i_2, v_2 in ipairs(v.careers) do
				scripts_tests_testify_snippets.set_player_profile(v.name, v_2)
				Testify:make_request("wait_for_players_inventory_ready")
				scripts_tests_testify_snippets.open_hero_view()
				scripts_tests_testify_snippets.open_cosmetics_inventory()
				scripts_tests_testify_snippets.equip_hats()
				Testify:make_request("close_hero_view")
			end
		end
	end)
end

TestCases.versus_multiplayer_server = function (arg_36_0)
	-- function 36
	Testify:run_case(function (arg_37_0, arg_37_1)
		-- function 37
		local decode = cjson.decode
		local var_37_1 = arg_36_0

		var_37_1 = var_37_1 or "{}"

		local var_37_2 = decode(var_37_1)
		local do_early_win = var_37_2.do_early_win

		do_early_win = do_early_win or false

		local match_outcome = var_37_2.match_outcome

		match_outcome = match_outcome or "draw"

		fassert(match_outcome == "party_one" or match_outcome == "party_two" or match_outcome == "draw", "Unexpected 'match_outcome' setting. Expected 'party_one', 'party_two' or 'draw'")
		fassert(not do_early_win and match_outcome ~= "draw", "Unable to do early win and expect a draw")
		scripts_tests_testify_snippets.set_script_data({
			player_invincible = true,
			disable_gamemode_end = not do_early_win,
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

		local make_request = Testify:make_request("versus_get_num_sets")

		for i = 1, make_request * 2 do
			print(string.format("TESTIFY - start of loop | i = %d | %d", i, make_request * 2))
			scripts_tests_testify_snippets.set_script_data({
				disable_gamemode_end = true
			})

			local num = i % 2
			local flag = (match_outcome == "draw" or match_outcome ~= "party_one" or num ~= 1) and match_outcome ~= "party_two" or num == 0

			Testify:make_request("wait_for_game_mode_state", {
				state = "pre_start_round_state",
				game_mode = "versus"
			})
			Testify:make_request("versus_wait_for_initial_peers_spawned")
			scripts_tests_testify_snippets.wait(1)
			Testify:make_request("game_mode_start_round")
			Testify:make_request("wait_for_game_mode_state", {
				state = "match_running_state",
				game_mode = "versus"
			})

			local var_37_8

			if not flag then
				var_37_8 = scripts_tests_testify_snippets.versus_complete_all_objectives()
			end

			scripts_tests_testify_snippets.set_script_data({
				disable_gamemode_end = false
			})
			Testify:make_request("versus_set_time", 0)

			if not (var_37_8 or not (i >= make_request * 2)) then
				Testify:make_request("wait_for_transition_state", "restart_game_server")

				break
			else
				Testify:make_request("wait_for_game_mode_state", {
					state = "post_round_state",
					game_mode = "versus"
				})
			end

			print(string.format("TESTIFY - end of loop | i = %d | %d", i, make_request * 2))
		end

		print("TESTIFY - out of loop")
	end)
end

TestCases.versus_multiplayer_client = function (arg_38_0)
	-- function 38
	Testify:run_case(function (arg_39_0, arg_39_1)
		-- function 39
		scripts_tests_testify_snippets.set_script_data({
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

		local make_request = Testify:make_request("versus_get_num_sets")

		for i = 1, make_request * 2 do
			print(string.format("TESTIFY - start of loop | i = %d | %d", i, make_request * 2))
			Testify:make_request("wait_for_game_mode_state", {
				state = "match_running_state",
				game_mode = "versus"
			})
			Testify:make_request("wait_for_game_mode_state", {
				state = "post_round_state",
				game_mode = "versus"
			})
			print(string.format("TESTIFY - end of loop | i = %d | %d", i, make_request * 2))

			if not Testify:make_request("versus_party_won_early") then
				break
			end
		end

		print("TESTIFY - out of loop")
	end)
end
