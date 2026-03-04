-- chunkname: @scripts/ui/views/ingame_ui_settings.lua

local var_0_0 = {
	adventure = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	},
	versus = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	},
	deus = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	}
}
local var_0_1 = {
	adventure = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	},
	versus = {
		matchmaking = true,
		matchmaking_ready = true,
		not_matchmaking = true
	},
	deus = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	}
}
local var_0_2 = {
	leave_group = function (arg_1_0)
		arg_1_0:_cancel_popup()

		local var_1_0 = Managers.state.network.network_server

		if var_1_0 and not var_1_0:are_all_peers_ingame(nil, true) then
			local var_1_1 = Localize("player_join_block_exit_game")

			arg_1_0.popup_id = Managers.popup:queue_popup(var_1_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			local var_1_2 = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")
			local var_1_3 = var_1_2 ~= nil and var_1_2.is_allowed() and Localize("leave_game_popup_text") .. "\n\n" .. Localize(var_1_2.message) or Localize("leave_game_popup_text")

			arg_1_0.popup_id = Managers.popup:queue_popup(var_1_3, Localize("popup_leave_game_topic"), "leave_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		end
	end,
	leave_group_hero_view = function (arg_2_0)
		arg_2_0:_cancel_popup()

		local var_2_0 = Managers.state.network.network_server

		if var_2_0 and not var_2_0:are_all_peers_ingame(nil, true) then
			local var_2_1 = Localize("player_join_block_exit_game")

			arg_2_0.popup_id = Managers.popup:queue_popup(var_2_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local var_2_2 = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")
			local var_2_3 = var_2_2 ~= nil and var_2_2.is_allowed() and Localize("leave_game_popup_text") .. "\n\n" .. Localize(var_2_2.message) or Localize("leave_game_popup_text")

			arg_2_0.popup_id = Managers.popup:queue_popup(var_2_3, Localize("popup_leave_game_topic"), "leave_game_hero_view", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	quit_game = function (arg_3_0)
		arg_3_0:_cancel_popup()

		local var_3_0 = Managers.state.network.network_server
		local var_3_1 = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")

		if var_3_0 and var_3_0:num_active_peers() > 1 and var_3_0:are_all_peers_ingame(nil, true) then
			local var_3_2 = var_3_1 ~= nil and var_3_1.is_allowed() and Localize("exit_game_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players") .. "\n\n\n" .. Localize(var_3_1.message) or Localize("exit_game_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players")

			arg_3_0.popup_id = Managers.popup:queue_popup(var_3_2, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))

			return
		end

		local var_3_3 = var_3_1 ~= nil and var_3_1.is_allowed() and Localize("exit_game_popup_text") .. "\n\n" .. Localize(var_3_1.message) or Localize("quit_game_popup_text")

		arg_3_0.popup_id = Managers.popup:queue_popup(var_3_3, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end,
	quit_game_hero_view = function (arg_4_0)
		arg_4_0:_cancel_popup()

		local var_4_0 = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")
		local var_4_1 = var_4_0 ~= nil and var_4_0.is_allowed() and Localize("exit_game_popup_text") .. "\n\n" .. Localize(var_4_0.message) or Localize("quit_game_popup_text")

		arg_4_0.popup_id = Managers.popup:queue_popup(var_4_1, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
	end,
	quit_game_hero_view_legacy = function (arg_5_0)
		arg_5_0:_cancel_popup()

		local var_5_0 = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")
		local var_5_1 = var_5_0 ~= nil and var_5_0.is_allowed() and Localize("exit_game_popup_text") .. "\n\n" .. Localize(var_5_0.message) or Localize("quit_game_popup_text")

		arg_5_0.popup_id = Managers.popup:queue_popup(var_5_1, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end,
	return_to_title_screen = function (arg_6_0)
		arg_6_0:_cancel_popup()

		local var_6_0 = Managers.state.network.network_server

		if var_6_0 then
			if not var_6_0:are_all_peers_ingame(nil, true) then
				local var_6_1 = Localize("player_join_block_exit_game")

				arg_6_0.popup_id = Managers.popup:queue_popup(var_6_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))

				return
			elseif var_6_0:num_active_peers() > 1 then
				local var_6_2 = Localize("exit_game_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players")

				arg_6_0.popup_id = Managers.popup:queue_popup(var_6_2, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))

				return
			end
		end

		local var_6_3 = Localize("exit_to_title_popup_text")

		arg_6_0.popup_id = Managers.popup:queue_popup(var_6_3, Localize("popup_exit_to_title_topic"), "do_return_to_title_screen", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end,
	return_to_title_screen_hero_view = function (arg_7_0)
		arg_7_0:_cancel_popup()

		local var_7_0 = Managers.state.network.network_server

		if var_7_0 and not var_7_0:are_all_peers_ingame(nil, true) then
			local var_7_1 = Localize("player_join_block_exit_game")

			arg_7_0.popup_id = Managers.popup:queue_popup(var_7_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local var_7_2 = Localize("exit_to_title_popup_text")

			arg_7_0.popup_id = Managers.popup:queue_popup(var_7_2, Localize("popup_exit_to_title_topic"), "do_return_to_title_screen_hero_view", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	return_to_demo_title_screen = function (arg_8_0)
		arg_8_0:_cancel_popup()

		local var_8_0 = Managers.state.network.network_server

		if var_8_0 and not var_8_0:are_all_peers_ingame(nil, true) then
			local var_8_1 = Localize("player_join_block_exit_game")

			arg_8_0.popup_id = Managers.popup:queue_popup(var_8_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			local var_8_2 = Localize("exit_to_title_popup_text")

			arg_8_0.popup_id = Managers.popup:queue_popup(var_8_2, Localize("popup_exit_to_title_topic"), "do_return_to_demo_title_screen", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		end
	end,
	return_to_demo_title_screen_hero_view = function (arg_9_0)
		arg_9_0:_cancel_popup()

		local var_9_0 = Managers.state.network.network_server

		if var_9_0 and not var_9_0:are_all_peers_ingame(nil, true) then
			local var_9_1 = Localize("player_join_block_exit_game")

			arg_9_0.popup_id = Managers.popup:queue_popup(var_9_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local var_9_2 = Localize("exit_to_title_popup_text")

			arg_9_0.popup_id = Managers.popup:queue_popup(var_9_2, Localize("popup_exit_to_title_topic"), "do_return_to_demo_title_screen", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	restart_demo = function (arg_10_0)
		arg_10_0:_cancel_popup()

		local var_10_0 = Managers.state.network.network_server

		if var_10_0 and not var_10_0:are_all_peers_ingame(nil, true) then
			local var_10_1 = Localize("player_join_block_restart_demo")

			arg_10_0.popup_id = Managers.popup:queue_popup(var_10_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			local var_10_2 = Localize("restart_demo_popup_text")

			arg_10_0.popup_id = Managers.popup:queue_popup(var_10_2, Localize("popup_restart_demo_topic"), "do_restart_demo", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		end
	end,
	restart_demo_hero_view = function (arg_11_0)
		arg_11_0:_cancel_popup()

		local var_11_0 = Managers.state.network.network_server

		if var_11_0 and not var_11_0:are_all_peers_ingame(nil, true) then
			local var_11_1 = Localize("player_join_block_restart_demo")

			arg_11_0.popup_id = Managers.popup:queue_popup(var_11_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local var_11_2 = Localize("restart_demo_popup_text")

			arg_11_0.popup_id = Managers.popup:queue_popup(var_11_2, Localize("popup_restart_demo_topic"), "do_restart_demo", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	demo_invert_controls = function (arg_12_0)
		local var_12_0 = arg_12_0.views.hero_view:current_state()._active_windows[4].layout_logic.active_button_data
		local var_12_1
		local var_12_2

		for iter_12_0, iter_12_1 in pairs(var_12_0) do
			if iter_12_1.transition == "demo_invert_controls" then
				var_12_1 = iter_12_1
				var_12_2 = iter_12_1.display_name

				break
			end
		end

		local var_12_3 = Managers.input:get_service("Player")

		if IS_WINDOWS then
			local var_12_4 = "win32"
			local var_12_5 = var_12_3:get_active_filters(var_12_4).look.function_data

			var_12_5.filter_type = var_12_5.filter_type == "scale_vector3" and "scale_vector3_invert_y" or "scale_vector3"
		end

		local var_12_6 = IS_PS4 and "ps4" or "xb1"
		local var_12_7 = var_12_3:get_active_filters(var_12_6)
		local var_12_8 = var_12_7.look_controller.function_data

		var_12_8.filter_type = var_12_8.filter_type == "scale_vector3_xy_accelerated_x" and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"

		local var_12_9 = var_12_7.look_controller_ranged.function_data

		var_12_9.filter_type = var_12_9.filter_type == "scale_vector3_xy_accelerated_x" and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"

		local var_12_10 = var_12_7.look_controller_melee.function_data

		var_12_10.filter_type = var_12_10.filter_type == "scale_vector3_xy_accelerated_x" and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"

		local var_12_11 = var_12_7.look_controller_zoom.function_data

		var_12_11.filter_type = var_12_11.filter_type == "scale_vector3_xy_accelerated_x" and "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
		var_12_1.display_name = var_12_2 == "menu_invert_controls" and "menu_non_invert_controls" or "menu_invert_controls"
	end,
	end_game = function (arg_13_0)
		Application.force_silent_exit_policy()
		arg_13_0.input_manager:block_device_except_service(nil, "keyboard", 1)
		arg_13_0.input_manager:block_device_except_service(nil, "mouse", 1)
		arg_13_0.input_manager:block_device_except_service(nil, "gamepad", 1)

		local var_13_0 = arg_13_0.views.telemetry_survey
		local var_13_1 = Managers.state.game_mode:level_key()
		local var_13_2 = LevelSettings[var_13_1]
		local var_13_3 = TelemetrySettings.send and TelemetrySettings.use_session_survey
		local var_13_4 = var_13_0:is_survey_answered()
		local var_13_5 = var_13_0:is_survey_timed_out()
		local var_13_6 = Managers.backend

		local function var_13_7()
			if var_13_3 and (var_13_4 or var_13_5) or not var_13_3 or var_13_2.hub_level then
				arg_13_0.quit_game = true
				arg_13_0.current_view = nil
			else
				arg_13_0.current_view = "telemetry_survey"

				var_13_0:set_transition("end_game")
			end
		end

		if not var_13_6:on_shutdown(var_13_7) then
			local var_13_8 = Managers.time:time("ui")

			arg_13_0.quit_game_retry = true
			arg_13_0.delay_quit_game_retry = var_13_8 + 1
		end
	end,
	do_return_to_title_screen = function (arg_15_0)
		arg_15_0:_cancel_popup()

		local var_15_0 = Managers.state.network.network_server

		if var_15_0 and not var_15_0:are_all_peers_ingame(nil, true) then
			local var_15_1 = Localize("player_join_block_exit_game")

			arg_15_0.popup_id = Managers.popup:queue_popup(var_15_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		elseif Managers.matchmaking:is_joining_friend() then
			local var_15_2 = Localize("player_join_block_exit_game")

			arg_15_0.popup_id = Managers.popup:queue_popup(var_15_2, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			arg_15_0.input_manager:block_device_except_service(nil, "keyboard", 1)
			arg_15_0.input_manager:block_device_except_service(nil, "mouse", 1)
			arg_15_0.input_manager:block_device_except_service(nil, "gamepad", 1)

			arg_15_0.return_to_title_screen = true
		end
	end,
	do_return_to_title_screen_hero_view = function (arg_16_0)
		arg_16_0:_cancel_popup()

		local var_16_0 = Managers.state.network.network_server

		if var_16_0 and not var_16_0:are_all_peers_ingame(nil, true) then
			local var_16_1 = Localize("player_join_block_exit_game")

			arg_16_0.popup_id = Managers.popup:queue_popup(var_16_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		elseif Managers.matchmaking:is_joining_friend() then
			local var_16_2 = Localize("player_join_block_exit_game")

			arg_16_0.popup_id = Managers.popup:queue_popup(var_16_2, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			arg_16_0.input_manager:block_device_except_service(nil, "keyboard", 1)
			arg_16_0.input_manager:block_device_except_service(nil, "mouse", 1)
			arg_16_0.input_manager:block_device_except_service(nil, "gamepad", 1)

			arg_16_0.return_to_title_screen = true
		end
	end,
	do_return_to_demo_title_screen = function (arg_17_0)
		arg_17_0.return_to_demo_title_screen = true
	end,
	do_restart_demo = function (arg_18_0)
		arg_18_0.restart_demo = true
	end,
	do_return_to_pc_menu = function (arg_19_0)
		local var_19_0 = Managers.state.network.network_server

		if var_19_0 and var_19_0:are_all_peers_ingame(nil, true) then
			arg_19_0.return_to_pc_menu = true
		elseif not var_19_0 then
			arg_19_0.return_to_pc_menu = true
		end
	end,
	leave_game = function (arg_20_0)
		arg_20_0:_cancel_popup()

		local var_20_0 = Managers.state.network.network_server

		if var_20_0 and not var_20_0:are_all_peers_ingame(nil, true) then
			local var_20_1 = Localize("player_join_block_exit_game")

			arg_20_0.popup_id = Managers.popup:queue_popup(var_20_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		elseif Managers.matchmaking:is_joining_friend() then
			local var_20_2 = Localize("player_join_block_exit_game")

			arg_20_0.popup_id = Managers.popup:queue_popup(var_20_2, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			arg_20_0.input_manager:block_device_except_service(nil, "keyboard", 1)
			arg_20_0.input_manager:block_device_except_service(nil, "mouse", 1)
			arg_20_0.input_manager:block_device_except_service(nil, "gamepad", 1)

			arg_20_0.leave_game = true
		end
	end,
	leave_game_hero_view = function (arg_21_0)
		arg_21_0:_cancel_popup()

		local var_21_0 = Managers.state.network.network_server

		if var_21_0 and not var_21_0:are_all_peers_ingame(nil, true) then
			local var_21_1 = Localize("player_join_block_exit_game")

			arg_21_0.popup_id = Managers.popup:queue_popup(var_21_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		elseif Managers.matchmaking:is_joining_friend() then
			local var_21_2 = Localize("player_join_block_exit_game")

			arg_21_0.popup_id = Managers.popup:queue_popup(var_21_2, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			arg_21_0.input_manager:block_device_except_service(nil, "keyboard", 1)
			arg_21_0.input_manager:block_device_except_service(nil, "mouse", 1)
			arg_21_0.input_manager:block_device_except_service(nil, "gamepad", 1)

			arg_21_0.leave_game = true
		end
	end,
	return_to_pc_menu = function (arg_22_0)
		arg_22_0:_cancel_popup()

		local var_22_0 = Managers.state.network.network_server

		if var_22_0 then
			if not var_22_0:are_all_peers_ingame(nil, true) then
				local var_22_1 = Localize("player_join_block_exit_game")

				arg_22_0.popup_id = Managers.popup:queue_popup(var_22_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))

				return
			elseif var_22_0:num_active_peers() > 1 then
				local var_22_2 = Localize("exit_to_title_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players")

				arg_22_0.popup_id = Managers.popup:queue_popup(var_22_2, Localize("popup_exit_game_topic"), "do_return_to_pc_menu", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))

				return
			end
		end

		local var_22_3 = Localize("exit_to_title_popup_text")

		arg_22_0.popup_id = Managers.popup:queue_popup(var_22_3, Localize("popup_exit_to_title_topic"), "do_return_to_pc_menu", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end,
	return_to_pc_menu_hero_view = function (arg_23_0)
		arg_23_0:_cancel_popup()

		local var_23_0 = Managers.state.network.network_server

		if var_23_0 and not var_23_0:are_all_peers_ingame(nil, true) then
			local var_23_1 = Localize("player_join_block_exit_game")

			arg_23_0.popup_id = Managers.popup:queue_popup(var_23_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local var_23_2 = Localize("exit_to_title_popup_text")

			arg_23_0.popup_id = Managers.popup:queue_popup(var_23_2, Localize("popup_exit_to_title_topic"), "do_return_to_pc_menu", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	ingame_menu = function (arg_24_0)
		arg_24_0.menu_active = true
		arg_24_0.current_view = "ingame_menu"
	end,
	chat_view = function (arg_25_0)
		arg_25_0.current_view = "chat_view"
	end,
	chat_view_force = function (arg_26_0)
		arg_26_0.current_view = "chat_view"
		arg_26_0.views[arg_26_0.current_view].exit_to_game = true
	end,
	hero_view_force = function (arg_27_0)
		arg_27_0.current_view = "hero_view"
		arg_27_0.views[arg_27_0.current_view].exit_to_game = true
	end,
	hero_view = function (arg_28_0)
		arg_28_0.current_view = "hero_view"
	end,
	spoils_of_war = function (arg_29_0)
		arg_29_0.current_view = "hero_view"
	end,
	start_game_view_force = function (arg_30_0)
		arg_30_0.current_view = "start_game_view"
		arg_30_0.views[arg_30_0.current_view].exit_to_game = true
	end,
	start_game_view = function (arg_31_0)
		arg_31_0.current_view = "start_game_view"
	end,
	start_menu_view_force = function (arg_32_0)
		arg_32_0.current_view = "start_menu_view"
		arg_32_0.views[arg_32_0.current_view].exit_to_game = true
	end,
	start_menu_view = function (arg_33_0)
		arg_33_0.current_view = "start_menu_view"
	end,
	initial_start_menu_view_force = function (arg_34_0)
		arg_34_0.current_view = "start_menu_view"
		arg_34_0.initial_profile_view = true
		arg_34_0.views[arg_34_0.current_view].exit_to_game = true
	end,
	exit_initial_start_menu_view = function (arg_35_0)
		arg_35_0.menu_active = false
		arg_35_0.current_view = nil
		arg_35_0.initial_profile_view = nil
		arg_35_0.has_left_menu = true
	end,
	character_selection_force = function (arg_36_0)
		arg_36_0.current_view = "character_selection"
		arg_36_0.views[arg_36_0.current_view].exit_to_game = true
	end,
	character_selection = function (arg_37_0)
		arg_37_0.current_view = "character_selection"
	end,
	initial_character_selection_force = function (arg_38_0, arg_38_1)
		arg_38_0.current_view = "character_selection"
		arg_38_0.initial_profile_view = true
		arg_38_0.views[arg_38_0.current_view].exit_to_game = true

		if arg_38_1.back_to_vs_preview then
			arg_38_0.views[arg_38_0.current_view].back_to_vs_preview = arg_38_1.back_to_vs_preview
		end
	end,
	exit_initial_character_selection = function (arg_39_0)
		arg_39_0.menu_active = false
		arg_39_0.current_view = nil
		arg_39_0.initial_profile_view = nil
	end,
	join_lobby = function (arg_40_0, arg_40_1)
		arg_40_0.input_manager:block_device_except_service(nil, "keyboard", 1)
		arg_40_0.input_manager:block_device_except_service(nil, "mouse", 1)
		arg_40_0.input_manager:block_device_except_service(nil, "gamepad", 1)

		arg_40_0.join_lobby = arg_40_1
		arg_40_0.menu_active = false
		arg_40_0.current_view = nil
	end,
	exit_menu = function (arg_41_0)
		local var_41_0 = arg_41_0.ingame_hud:component("LevelCountdownUI")

		if not (var_41_0 and var_41_0:is_enter_game()) and not Managers.chat:chat_is_focused() and not arg_41_0:get_active_popup("profile_picker") then
			arg_41_0.input_manager:device_unblock_all_services("keyboard", 1)
			arg_41_0.input_manager:device_unblock_all_services("mouse", 1)
			arg_41_0.input_manager:device_unblock_all_services("gamepad", 1)
		end

		arg_41_0.menu_active = false
		arg_41_0.current_view = nil
	end,
	cancel_popup = function (arg_42_0)
		arg_42_0.popup_id = nil

		arg_42_0.input_manager:block_device_except_service("ingame_menu", "keyboard", 1)
		arg_42_0.input_manager:block_device_except_service("ingame_menu", "mouse", 1)
		arg_42_0.input_manager:block_device_except_service("ingame_menu", "gamepad", 1)
	end,
	cancel_popup_hero_view = function (arg_43_0)
		arg_43_0.popup_id = nil

		arg_43_0.input_manager:block_device_except_service("hero_view", "keyboard", 1)
		arg_43_0.input_manager:block_device_except_service("hero_view", "mouse", 1)
		arg_43_0.input_manager:block_device_except_service("hero_view", "gamepad", 1)
	end,
	credits_menu = function (arg_44_0)
		arg_44_0.current_view = "credits_view"
	end,
	options_menu = function (arg_45_0)
		arg_45_0.current_view = "options_view"
	end,
	console_friends_menu = function (arg_46_0)
		arg_46_0.current_view = "console_friends_view"
	end,
	restart_game = function (arg_47_0)
		arg_47_0.input_manager:device_unblock_all_services("keyboard", 1)
		arg_47_0.input_manager:device_unblock_all_services("mouse", 1)
		arg_47_0.input_manager:device_unblock_all_services("gamepad", 1)

		arg_47_0.restart_game = true
	end,
	close_active = function (arg_48_0)
		if arg_48_0.popup_id then
			Managers.popup:cancel_popup(arg_48_0.popup_id)

			arg_48_0.popup_id = nil
		end

		arg_48_0.menu_active = nil
		arg_48_0.current_view = nil
	end
}
local var_0_3 = {
	ui_renderer_function = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
		local var_49_0 = {
			"material",
			"materials/ui/ui_1080p_hud_atlas_textures",
			"material",
			"materials/ui/ui_1080p_hud_single_textures",
			"material",
			"materials/ui/ui_1080p_menu_atlas_textures",
			"material",
			"materials/ui/ui_1080p_menu_single_textures",
			"material",
			"materials/ui/ui_1080p_common",
			"material",
			"materials/ui/ui_1080p_versus_available_common",
			"material",
			"materials/ui/ui_1080p_chat",
			"material",
			"materials/fonts/gw_fonts"
		}

		if arg_49_2 then
			var_49_0[#var_49_0 + 1] = "material"
			var_49_0[#var_49_0 + 1] = "materials/ui/ui_1080p_achievement_atlas_textures"
			var_49_0[#var_49_0 + 1] = "material"
			var_49_0[#var_49_0 + 1] = "materials/ui/ui_1080p_inn_single_textures"
			var_49_0[#var_49_0 + 1] = "material"
			var_49_0[#var_49_0 + 1] = "materials/ui/ui_1080p_lock_test"
			var_49_0[#var_49_0 + 1] = "material"
			var_49_0[#var_49_0 + 1] = "materials/ui/ui_1080p_pose_cosmetics"
			var_49_0[#var_49_0 + 1] = "material"
			var_49_0[#var_49_0 + 1] = "video/tutorial_videos/tutorial_videos"

			for iter_49_0, iter_49_1 in pairs(AreaSettings) do
				local var_49_1 = iter_49_1.video_settings

				if var_49_1 then
					var_49_0[#var_49_0 + 1] = "material"
					var_49_0[#var_49_0 + 1] = var_49_1.resource
				end
			end

			for iter_49_2, iter_49_3 in pairs(DLCSettings) do
				local var_49_2 = iter_49_3.ui_materials_in_inn
				local var_49_3 = iter_49_3.ui_materials_in_inn_condition

				if var_49_2 and (not var_49_3 or var_49_3(arg_49_1, arg_49_2, arg_49_3)) then
					for iter_49_4, iter_49_5 in ipairs(var_49_2) do
						var_49_0[#var_49_0 + 1] = "material"
						var_49_0[#var_49_0 + 1] = iter_49_5
					end
				end
			end
		end

		for iter_49_6, iter_49_7 in pairs(DLCSettings) do
			local var_49_4 = iter_49_7.ui_materials
			local var_49_5 = iter_49_7.ui_materials_condition

			if var_49_4 and (not var_49_5 or var_49_5(arg_49_1, arg_49_2, arg_49_3)) then
				for iter_49_8, iter_49_9 in ipairs(var_49_4) do
					var_49_0[#var_49_0 + 1] = "material"
					var_49_0[#var_49_0 + 1] = iter_49_9
				end
			end
		end

		if arg_49_1 then
			var_49_0[#var_49_0 + 1] = "material"
			var_49_0[#var_49_0 + 1] = "materials/ui/ui_1080p_tutorial_textures"
		end

		for iter_49_10, iter_49_11 in pairs(CareerSettings) do
			local var_49_6 = iter_49_11.video

			if var_49_6 then
				var_49_0[#var_49_0 + 1] = "material"
				var_49_0[#var_49_0 + 1] = var_49_6.resource
			end
		end

		if IS_WINDOWS then
			var_49_0[#var_49_0 + 1] = "material"
			var_49_0[#var_49_0 + 1] = "video/ui_option"
		end

		if IS_WINDOWS then
			return UIRenderer.create(arg_49_0, unpack(var_49_0))
		else
			return UIRenderer.create(arg_49_0, unpack(var_49_0))
		end
	end,
	ui_top_renderer_function = function (arg_50_0, arg_50_1, arg_50_2)
		local var_50_0 = {
			"material",
			"materials/ui/ui_1080p_hud_atlas_textures",
			"material",
			"materials/ui/ui_1080p_hud_single_textures",
			"material",
			"materials/ui/ui_1080p_menu_atlas_textures",
			"material",
			"materials/ui/ui_1080p_menu_single_textures",
			"material",
			"materials/ui/ui_1080p_common",
			"material",
			"materials/ui/ui_1080p_versus_available_common",
			"material",
			"materials/ui/ui_1080p_chat",
			"material",
			"materials/fonts/gw_fonts"
		}

		if arg_50_2 then
			var_50_0[#var_50_0 + 1] = "material"
			var_50_0[#var_50_0 + 1] = "materials/ui/ui_1080p_achievement_atlas_textures"
			var_50_0[#var_50_0 + 1] = "material"
			var_50_0[#var_50_0 + 1] = "materials/ui/ui_1080p_inn_single_textures"
			var_50_0[#var_50_0 + 1] = "material"
			var_50_0[#var_50_0 + 1] = "materials/ui/ui_1080p_pose_cosmetics"

			for iter_50_0, iter_50_1 in pairs(AreaSettings) do
				local var_50_1 = iter_50_1.video_settings

				if var_50_1 then
					var_50_0[#var_50_0 + 1] = "material"
					var_50_0[#var_50_0 + 1] = var_50_1.resource
				end
			end

			for iter_50_2, iter_50_3 in pairs(DLCSettings) do
				local var_50_2 = iter_50_3.ui_materials_in_inn

				if var_50_2 then
					for iter_50_4, iter_50_5 in ipairs(var_50_2) do
						var_50_0[#var_50_0 + 1] = "material"
						var_50_0[#var_50_0 + 1] = iter_50_5
					end
				end
			end
		end

		for iter_50_6, iter_50_7 in pairs(DLCSettings) do
			local var_50_3 = iter_50_7.ui_materials

			if var_50_3 then
				for iter_50_8, iter_50_9 in ipairs(var_50_3) do
					var_50_0[#var_50_0 + 1] = "material"
					var_50_0[#var_50_0 + 1] = iter_50_9
				end
			end
		end

		if arg_50_1 then
			var_50_0[#var_50_0 + 1] = "material"
			var_50_0[#var_50_0 + 1] = "materials/ui/ui_1080p_tutorial_textures"
		end

		for iter_50_10, iter_50_11 in pairs(CareerSettings) do
			local var_50_4 = iter_50_11.video

			var_50_0[#var_50_0 + 1] = "material"
			var_50_0[#var_50_0 + 1] = var_50_4.resource
		end

		if IS_WINDOWS then
			return UIRenderer.create(world, unpack(var_50_0))
		else
			return UIRenderer.create(world, unpack(var_50_0))
		end
	end,
	views_function = function (arg_51_0)
		local var_51_0 = {
			credits_view = CreditsView:new(arg_51_0),
			telemetry_survey = TelemetrySurveyView:new(arg_51_0),
			options_view = OptionsView:new(arg_51_0),
			hero_view = HeroView:new(arg_51_0),
			character_selection = CharacterSelectionView:new(arg_51_0),
			start_menu_view = StartMenuView:new(arg_51_0),
			start_game_view = StartGameView:new(arg_51_0),
			ingame_menu = IngameView:new(arg_51_0),
			chat_view = IS_WINDOWS and ChatView:new(arg_51_0) or nil,
			console_friends_view = ConsoleFriendsView:new(arg_51_0)
		}

		for iter_51_0, iter_51_1 in pairs(DLCSettings) do
			if iter_51_1.ui_views then
				local var_51_1 = Managers.mechanism:current_mechanism_name()

				for iter_51_2, iter_51_3 in ipairs(iter_51_1.ui_views) do
					local var_51_2 = iter_51_3.name
					local var_51_3 = iter_51_3.class_name

					if var_51_2 and var_51_3 then
						fassert(var_51_0[var_51_2] == nil, "view name (%s) already exists", var_51_2)

						local var_51_4 = iter_51_3.mechanism_filter

						if (not var_51_4 or var_51_4[var_51_1] == true) and (not iter_51_3.only_in_inn or arg_51_0.is_in_inn) and (not iter_51_3.only_in_game or not arg_51_0.is_in_inn) then
							var_51_0[var_51_2] = _G[var_51_3]:new(arg_51_0)
						end
					end
				end
			end
		end

		return var_51_0
	end,
	hotkey_mapping = {
		hotkey_hero = {
			in_transition = "character_selection_force",
			error_message = "matchmaking_ready_interaction_message_profile_view",
			view = "character_selection",
			transition_state = "character",
			in_transition_menu = "character_selection_view",
			disable_for_mechanism = var_0_0
		},
		hotkey_map = {
			can_interact_func = "_handle_versus_matchmaking",
			in_transition = "start_game_view_force",
			error_message = "matchmaking_ready_interaction_message_map",
			view = "start_game_view",
			transition_state = "play",
			in_transition_menu = "start_game_view",
			disable_for_mechanism = {
				adventure = {
					matchmaking = true,
					matchmaking_ready = true,
					not_matchmaking = false
				},
				versus = {
					matchmaking = false,
					matchmaking_ready = true,
					not_matchmaking = false
				},
				deus = {
					matchmaking = true,
					matchmaking_ready = true,
					not_matchmaking = false
				}
			},
			inject_transition_params_func = function (arg_52_0)
				if Managers.matchmaking:is_in_versus_custom_game_lobby() then
					arg_52_0.menu_sub_state_name = "versus_player_hosted_lobby"
					arg_52_0.panel_title_buttons_hidden = true
					arg_52_0.ignore_sub_state_on_exit = true
				end
			end
		},
		hotkey_inventory = {
			in_transition = "hero_view_force",
			error_message = "matchmaking_ready_interaction_message_inventory",
			view = "hero_view",
			transition_state = "overview",
			in_transition_menu = "hero_view",
			disable_for_mechanism = var_0_0
		},
		hotkey_loot = {
			can_interact_func = "not_in_modded",
			in_transition = "hero_view_force",
			error_message = "matchmaking_ready_interaction_message_loot",
			view = "hero_view",
			transition_state = "loot",
			in_transition_menu = "hero_view",
			disable_for_mechanism = var_0_1
		},
		hotkey_achievements = {
			in_transition = "hero_view_force",
			error_message = "matchmaking_ready_interaction_message_achievements",
			view = "hero_view",
			transition_state = "achievements",
			in_transition_menu = "hero_view",
			disable_for_mechanism = var_0_0
		},
		hotkey_weave_forge = {
			can_interact_func = "weaves_requirements_fulfilled",
			in_transition = "hero_view_force",
			error_message = "matchmaking_ready_interaction_message_weave_forge",
			view = "hero_view",
			transition_state = "weave_forge",
			required_dlc = "scorpion",
			in_transition_menu = "hero_view",
			disable_for_mechanism = var_0_1
		},
		hotkey_weave_play = {
			transition_sub_state = "weave_quickplay",
			in_transition = "start_game_view_force",
			can_interact_func = "weaves_requirements_fulfilled",
			view = "start_game_view",
			in_transition_menu = "start_game_view",
			error_message = "matchmaking_ready_interaction_message_weave_play",
			transition_state = "play",
			required_dlc = "scorpion",
			disable_for_mechanism = var_0_1
		},
		hotkey_weave_leaderboard = {
			can_interact_func = "weaves_requirements_fulfilled",
			in_transition = "start_game_view_force",
			error_message = "matchmaking_ready_interaction_message_weave_leaderboard",
			view = "start_game_view",
			transition_state = "leaderboard",
			required_dlc = "scorpion",
			in_transition_menu = "start_game_view",
			disable_for_mechanism = {
				adventure = {
					matchmaking = false,
					matchmaking_ready = true,
					not_matchmaking = false
				},
				versus = {
					matchmaking = true,
					matchmaking_ready = true,
					not_matchmaking = true
				},
				deus = {
					matchmaking = true,
					matchmaking_ready = true,
					not_matchmaking = true
				}
			}
		}
	},
	blocked_transitions = {}
}

DLCUtils.map_list("ui_views", function (arg_53_0)
	if arg_53_0.transitions then
		for iter_53_0, iter_53_1 in pairs(arg_53_0.transitions) do
			fassert(not var_0_2[iter_53_0], "Transition %q already exists", iter_53_0)

			var_0_2[iter_53_0] = iter_53_1
		end
	end
end)
DLCUtils.merge("hotkey_mapping", var_0_3.hotkey_mapping)
DLCUtils.merge("ui_transitions", var_0_2)

return {
	transitions = var_0_2,
	view_settings = var_0_3
}
