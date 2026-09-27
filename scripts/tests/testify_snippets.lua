-- chunkname: @scripts/tests/testify_snippets.lua

local tbl = {
	load_level = function (arg_1_0)
		-- function 1
		Testify:make_request("load_level", arg_1_0)
		Testify:make_request("wait_for_level_to_be_loaded")
	end
}

tbl.disable_level_intro_dialogue = function ()
	-- function 2
	tbl.set_script_data({
		disable_level_intro_dialogue = true
	})
end

tbl.set_player_profile = function (arg_3_0, arg_3_1)
	-- function 3
	Testify:make_request("set_player_profile", {
		profile_name = arg_3_0,
		career_name = arg_3_1
	})
	Testify:make_request("wait_for_player_to_spawn")
end

tbl.set_bot_profile = function (arg_4_0, arg_4_1)
	-- function 4
	Testify:make_request("set_bot_profile", {
		profile_name = arg_4_0,
		career_name = arg_4_1
	})
	Testify:make_request("disable_bots")
	Testify:make_request("enable_bots")
	Testify:make_request("wait_for_bots_to_spawn")
end

tbl.set_script_data = function (arg_5_0)
	-- function 5
	Testify:make_request("set_script_data", arg_5_0)
end

tbl.wait = function (arg_6_0)
	-- function 6
	local clock = os.clock()

	while arg_6_0 > os.clock() - clock do
		coroutine.yield()
	end
end

tbl.load_weave = function (arg_7_0)
	-- function 7
	Testify:make_request("set_next_weave", arg_7_0)
	Testify:make_request("load_weave", arg_7_0)
	Testify:make_request("wait_for_level_to_be_loaded")
end

tbl.disable_ai = function ()
	-- function 8
	tbl.set_script_data({
		ai_mini_patrol_disabled = true,
		disable_plague_sorcerer = true,
		ai_roaming_spawning_disabled = true,
		disable_gutter_runner = true,
		ai_boss_spawning_disabled = true,
		ai_bots_disabled = true,
		ai_roaming_patrols_disabled = true,
		ai_terror_events_disabled = true,
		ai_critter_spawning_disabled = true,
		disable_globadier = true,
		disable_warpfire_thrower = true,
		ai_pacing_disabled = true,
		disable_pack_master = true,
		ai_rush_intervention_disabled = true,
		disable_ratling_gunner = true,
		disable_vortex_sorcerer = true,
		ai_horde_spawning_disabled = true,
		ai_specials_spawning_disabled = true,
		ai_champion_spawn_debug = true
	})
end

tbl.open_hero_view = function ()
	-- function 9
	local tbl = {
		transition = "hero_view_force",
		transition_params = {
			menu_state_name = "overview"
		}
	}

	Testify:make_request("transition_with_fade", tbl)
	Testify:make_request("wait_for_hero_view")
end

tbl.open_cosmetics_inventory = function ()
	-- function 10
	Testify:make_request("set_hero_window_layout", 4)
	Testify:make_request("wait_for_cosmetics_inventory_window")
end

tbl.equip_hats = function ()
	-- function 11
	local content = Testify:make_request("get_hero_window_cosmetics_inventory_item_grid")._widget.content
	local rows = content.rows
	local columns = content.columns

	for i = 1, rows do
		for j = 1, columns do
			local str = "_" .. i .. "_" .. j
			local str_2 = "hotspot" .. str
			local var_11_5 = content[str_2]
			local reserved = var_11_5.reserved
			local unwieldable = var_11_5.unwieldable

			if not (reserved or unwieldable) then
				local tbl = {
					value = true,
					hotspot_name = str_2
				}

				Testify:make_request("set_slot_hotspot_on_right_click", tbl)
			end
		end
	end
end

tbl.versus_server_wait_for_full_server = function ()
	-- function 12
	Testify:make_request("wait_for_game_mode_state", {
		state = "dedicated_server_waiting_for_fully_reserved",
		game_mode = "inn_vs"
	})
	Testify:make_request("wait_for_game_mode_state", {
		state = "dedicated_server_starting_game",
		game_mode = "inn_vs"
	})
end

tbl.versus_client_wait_for_full_server = function ()
	-- function 13
	Testify:make_request("wait_for_matchmaking_substate", {
		substate = "waiting_for_join_message",
		state = "MatchmakingStateReserveLobby"
	})
	Testify:make_request("wait_for_matchmaking_state", "MatchmakingStateRequestJoinGame")
	Testify:make_request("wait_for_matchmaking_state", "MatchmakingStateJoinGame")
end

tbl.versus_complete_all_objectives = function ()
	-- function 14
	local flag = false

	Testify:make_request("wait_for_objectives_to_activate")

	local var_14_1 = tonumber(Testify:make_request("get_current_main_objective"))
	local var_14_2 = tonumber(Testify:make_request("get_num_main_objectives"))

	while not (not var_14_1 and not (var_14_1 <= var_14_2)) do
		tbl.versus_complete_next_objective()
		tbl.wait(1)

		if not Testify:make_request("versus_party_won_early") then
			return true
		end

		var_14_1 = Testify:make_request("get_current_main_objective")
	end

	return false
end

tbl.versus_complete_next_objective = function ()
	-- function 15
	local make_request = Testify:make_request("versus_objective_type")

	if not (tonumber(Testify:make_request("num_human_players_on_side", "heroes")) == 0 or make_request ~= "objective_not_supported") then
		tbl.wait(1)
		Testify:make_request("versus_complete_objectives")
		tbl.wait(1)
	elseif not (make_request == "objective_volume" or make_request ~= "objective_capture_point") then
		local var_15_1

		if make_request == "objective_volume" then
			var_15_1 = Testify:make_request("versus_volume_objective_get_num_players_inside")
		else
			var_15_1 = Testify:make_request("versus_capture_point_objective_get_num_players_inside")
		end

		if var_15_1 < 1 then
			local make_request_2 = Testify:make_request("versus_current_objective_position")
			local var_15_3
			local main_path_position = make_request_2.main_path_position
			local random_position = make_request_2.random_position

			if Vector3.distance(main_path_position, random_position) > 10 then
				var_15_3 = Vector3Box(random_position)
			else
				var_15_3 = Vector3Box(main_path_position)
			end

			Testify:make_request("teleport_all_players_to_position", var_15_3)
		end
	elseif make_request == "objective_interact" then
		local make_request_3 = Testify:make_request("versus_current_objective_position")
		local var_15_7 = Vector3Box(make_request_3.position)

		Testify:make_request("teleport_all_players_to_position", var_15_7)
		Testify:make_request("versus_objective_simulate_interaction")
	end
end

return tbl
