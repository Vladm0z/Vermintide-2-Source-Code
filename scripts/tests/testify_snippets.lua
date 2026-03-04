-- chunkname: @scripts/tests/testify_snippets.lua

local var_0_0 = {
	load_level = function (arg_1_0)
		Testify:make_request("load_level", arg_1_0)
		Testify:make_request("wait_for_level_to_be_loaded")
	end
}

var_0_0.disable_level_intro_dialogue = function ()
	var_0_0.set_script_data({
		disable_level_intro_dialogue = true
	})
end

var_0_0.set_player_profile = function (arg_3_0, arg_3_1)
	Testify:make_request("set_player_profile", {
		profile_name = arg_3_0,
		career_name = arg_3_1
	})
	Testify:make_request("wait_for_player_to_spawn")
end

var_0_0.set_bot_profile = function (arg_4_0, arg_4_1)
	Testify:make_request("set_bot_profile", {
		profile_name = arg_4_0,
		career_name = arg_4_1
	})
	Testify:make_request("disable_bots")
	Testify:make_request("enable_bots")
	Testify:make_request("wait_for_bots_to_spawn")
end

var_0_0.set_script_data = function (arg_5_0)
	Testify:make_request("set_script_data", arg_5_0)
end

var_0_0.wait = function (arg_6_0)
	local var_6_0 = os.clock()

	while arg_6_0 > os.clock() - var_6_0 do
		coroutine.yield()
	end
end

var_0_0.load_weave = function (arg_7_0)
	Testify:make_request("set_next_weave", arg_7_0)
	Testify:make_request("load_weave", arg_7_0)
	Testify:make_request("wait_for_level_to_be_loaded")
end

var_0_0.disable_ai = function ()
	var_0_0.set_script_data({
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

var_0_0.open_hero_view = function ()
	local var_9_0 = {
		transition = "hero_view_force",
		transition_params = {
			menu_state_name = "overview"
		}
	}

	Testify:make_request("transition_with_fade", var_9_0)
	Testify:make_request("wait_for_hero_view")
end

var_0_0.open_cosmetics_inventory = function ()
	Testify:make_request("set_hero_window_layout", 4)
	Testify:make_request("wait_for_cosmetics_inventory_window")
end

var_0_0.equip_hats = function ()
	local var_11_0 = Testify:make_request("get_hero_window_cosmetics_inventory_item_grid")._widget.content
	local var_11_1 = var_11_0.rows
	local var_11_2 = var_11_0.columns

	for iter_11_0 = 1, var_11_1 do
		for iter_11_1 = 1, var_11_2 do
			local var_11_3 = "_" .. iter_11_0 .. "_" .. iter_11_1
			local var_11_4 = "hotspot" .. var_11_3
			local var_11_5 = var_11_0[var_11_4]
			local var_11_6 = var_11_5.reserved
			local var_11_7 = var_11_5.unwieldable

			if not var_11_6 and not var_11_7 then
				local var_11_8 = {
					value = true,
					hotspot_name = var_11_4
				}

				Testify:make_request("set_slot_hotspot_on_right_click", var_11_8)
			end
		end
	end
end

var_0_0.versus_server_wait_for_full_server = function ()
	Testify:make_request("wait_for_game_mode_state", {
		state = "dedicated_server_waiting_for_fully_reserved",
		game_mode = "inn_vs"
	})
	Testify:make_request("wait_for_game_mode_state", {
		state = "dedicated_server_starting_game",
		game_mode = "inn_vs"
	})
end

var_0_0.versus_client_wait_for_full_server = function ()
	Testify:make_request("wait_for_matchmaking_substate", {
		substate = "waiting_for_join_message",
		state = "MatchmakingStateReserveLobby"
	})
	Testify:make_request("wait_for_matchmaking_state", "MatchmakingStateRequestJoinGame")
	Testify:make_request("wait_for_matchmaking_state", "MatchmakingStateJoinGame")
end

var_0_0.versus_complete_all_objectives = function ()
	local var_14_0 = false

	Testify:make_request("wait_for_objectives_to_activate")

	local var_14_1 = tonumber(Testify:make_request("get_current_main_objective"))
	local var_14_2 = tonumber(Testify:make_request("get_num_main_objectives"))

	while var_14_1 and var_14_1 <= var_14_2 do
		var_0_0.versus_complete_next_objective()
		var_0_0.wait(1)

		if Testify:make_request("versus_party_won_early") then
			return true
		end

		var_14_1 = Testify:make_request("get_current_main_objective")
	end

	return false
end

var_0_0.versus_complete_next_objective = function ()
	local var_15_0 = Testify:make_request("versus_objective_type")

	if tonumber(Testify:make_request("num_human_players_on_side", "heroes")) == 0 or var_15_0 == "objective_not_supported" then
		var_0_0.wait(1)
		Testify:make_request("versus_complete_objectives")
		var_0_0.wait(1)
	elseif var_15_0 == "objective_volume" or var_15_0 == "objective_capture_point" then
		local var_15_1

		if var_15_0 == "objective_volume" then
			var_15_1 = Testify:make_request("versus_volume_objective_get_num_players_inside")
		else
			var_15_1 = Testify:make_request("versus_capture_point_objective_get_num_players_inside")
		end

		if var_15_1 < 1 then
			local var_15_2 = Testify:make_request("versus_current_objective_position")
			local var_15_3
			local var_15_4 = var_15_2.main_path_position
			local var_15_5 = var_15_2.random_position

			if Vector3.distance(var_15_4, var_15_5) > 10 then
				var_15_3 = Vector3Box(var_15_5)
			else
				var_15_3 = Vector3Box(var_15_4)
			end

			Testify:make_request("teleport_all_players_to_position", var_15_3)
		end
	elseif var_15_0 == "objective_interact" then
		local var_15_6 = Testify:make_request("versus_current_objective_position")
		local var_15_7 = Vector3Box(var_15_6.position)

		Testify:make_request("teleport_all_players_to_position", var_15_7)
		Testify:make_request("versus_objective_simulate_interaction")
	end
end

return var_0_0
