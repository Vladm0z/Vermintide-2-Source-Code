-- chunkname: @scripts/ui/views/ingame_ui_settings.lua

local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
	leave_group = function (self)
		-- function 1
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_1_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_1_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			local mechanism_setting = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")
			local str

			if mechanism_setting == nil or not mechanism_setting.is_allowed() then
				str = Localize("leave_game_popup_text") .. "\n\n" .. Localize(mechanism_setting.message)

				if not str then
					-- Nothing
				end
			end

			str = Localize("leave_game_popup_text")

			::label_1_0::

			self.popup_id = Managers.popup:queue_popup(str, Localize("popup_leave_game_topic"), "leave_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		end
	end,
	leave_group_hero_view = function (self)
		-- function 2
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_2_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_2_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local mechanism_setting = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")
			local str

			if mechanism_setting == nil or not mechanism_setting.is_allowed() then
				str = Localize("leave_game_popup_text") .. "\n\n" .. Localize(mechanism_setting.message)

				if not str then
					-- Nothing
				end
			end

			str = Localize("leave_game_popup_text")

			::label_2_0::

			self.popup_id = Managers.popup:queue_popup(str, Localize("popup_leave_game_topic"), "leave_game_hero_view", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	quit_game = function (self)
		-- function 3
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server
		local mechanism_setting = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")

		if not network_server and not (network_server:num_active_peers() > 1) or not network_server:are_all_peers_ingame(nil, true) then
			local str

			if mechanism_setting == nil or not mechanism_setting.is_allowed() then
				str = Localize("exit_game_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players") .. "\n\n\n" .. Localize(mechanism_setting.message)

				if not str then
					-- Nothing
				end
			end

			str = Localize("exit_game_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players")

			::label_3_0::

			self.popup_id = Managers.popup:queue_popup(str, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))

			return
		end

		local str_2

		if mechanism_setting == nil or not mechanism_setting.is_allowed() then
			str_2 = Localize("exit_game_popup_text") .. "\n\n" .. Localize(mechanism_setting.message)

			if not str_2 then
				-- Nothing
			end
		end

		str_2 = Localize("quit_game_popup_text")

		::label_3_1::

		self.popup_id = Managers.popup:queue_popup(str_2, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end,
	quit_game_hero_view = function (self)
		-- function 4
		self:_cancel_popup()

		local mechanism_setting = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")
		local str

		if mechanism_setting == nil or not mechanism_setting.is_allowed() then
			str = Localize("exit_game_popup_text") .. "\n\n" .. Localize(mechanism_setting.message)

			if not str then
				-- Nothing
			end
		end

		str = Localize("quit_game_popup_text")

		::label_4_0::

		self.popup_id = Managers.popup:queue_popup(str, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
	end,
	quit_game_hero_view_legacy = function (self)
		-- function 5
		self:_cancel_popup()

		local mechanism_setting = Managers.mechanism:mechanism_setting("progress_loss_warning_message_data")
		local str

		if mechanism_setting == nil or not mechanism_setting.is_allowed() then
			str = Localize("exit_game_popup_text") .. "\n\n" .. Localize(mechanism_setting.message)

			if not str then
				-- Nothing
			end
		end

		str = Localize("quit_game_popup_text")

		::label_5_0::

		self.popup_id = Managers.popup:queue_popup(str, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end,
	return_to_title_screen = function (self)
		-- function 6
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not network_server then
			if not network_server:are_all_peers_ingame(nil, true) then
				local var_6_1 = Localize("player_join_block_exit_game")

				self.popup_id = Managers.popup:queue_popup(var_6_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))

				return
			elseif network_server:num_active_peers() > 1 then
				local str = Localize("exit_game_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players")

				self.popup_id = Managers.popup:queue_popup(str, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))

				return
			end
		end

		local var_6_3 = Localize("exit_to_title_popup_text")

		self.popup_id = Managers.popup:queue_popup(var_6_3, Localize("popup_exit_to_title_topic"), "do_return_to_title_screen", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end,
	return_to_title_screen_hero_view = function (self)
		-- function 7
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_7_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_7_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local var_7_2 = Localize("exit_to_title_popup_text")

			self.popup_id = Managers.popup:queue_popup(var_7_2, Localize("popup_exit_to_title_topic"), "do_return_to_title_screen_hero_view", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	return_to_demo_title_screen = function (self)
		-- function 8
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_8_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_8_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			local var_8_2 = Localize("exit_to_title_popup_text")

			self.popup_id = Managers.popup:queue_popup(var_8_2, Localize("popup_exit_to_title_topic"), "do_return_to_demo_title_screen", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		end
	end,
	return_to_demo_title_screen_hero_view = function (self)
		-- function 9
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_9_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_9_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local var_9_2 = Localize("exit_to_title_popup_text")

			self.popup_id = Managers.popup:queue_popup(var_9_2, Localize("popup_exit_to_title_topic"), "do_return_to_demo_title_screen", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	restart_demo = function (self)
		-- function 10
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_10_1 = Localize("player_join_block_restart_demo")

			self.popup_id = Managers.popup:queue_popup(var_10_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			local var_10_2 = Localize("restart_demo_popup_text")

			self.popup_id = Managers.popup:queue_popup(var_10_2, Localize("popup_restart_demo_topic"), "do_restart_demo", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		end
	end,
	restart_demo_hero_view = function (self)
		-- function 11
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_11_1 = Localize("player_join_block_restart_demo")

			self.popup_id = Managers.popup:queue_popup(var_11_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local var_11_2 = Localize("restart_demo_popup_text")

			self.popup_id = Managers.popup:queue_popup(var_11_2, Localize("popup_restart_demo_topic"), "do_restart_demo", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	demo_invert_controls = function (self)
		-- function 12
		local active_button_data = self.views.hero_view:current_state()._active_windows[4].layout_logic.active_button_data
		local var_12_1
		local var_12_2

		for k, v in pairs(active_button_data) do
			if v.transition == "demo_invert_controls" then
				var_12_1 = v
				var_12_2 = v.display_name

				break
			end
		end

		local get_service = Managers.input:get_service("Player")

		if not IS_WINDOWS then
			local str = "win32"
			local function_data = get_service:get_active_filters(str).look.function_data
			local flag

			flag = function_data.filter_type ~= "scale_vector3" or not "scale_vector3_invert_y" or "scale_vector3"
			function_data.filter_type = flag
		end

		local flag_2

		flag_2 = not IS_PS4 and "ps4" and "xb1"

		local get_active_filters = get_service:get_active_filters(flag_2)
		local function_data_2 = get_active_filters.look_controller.function_data
		local flag_3

		flag_3 = function_data_2.filter_type ~= "scale_vector3_xy_accelerated_x" or not "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
		function_data_2.filter_type = flag_3

		local function_data_3 = get_active_filters.look_controller_ranged.function_data
		local flag_4

		flag_4 = function_data_3.filter_type ~= "scale_vector3_xy_accelerated_x" or not "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
		function_data_3.filter_type = flag_4

		local function_data_4 = get_active_filters.look_controller_melee.function_data
		local flag_5

		flag_5 = function_data_4.filter_type ~= "scale_vector3_xy_accelerated_x" or not "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
		function_data_4.filter_type = flag_5

		local function_data_5 = get_active_filters.look_controller_zoom.function_data
		local flag_6

		flag_6 = function_data_5.filter_type ~= "scale_vector3_xy_accelerated_x" or not "scale_vector3_xy_accelerated_x_inverted" or "scale_vector3_xy_accelerated_x"
		function_data_5.filter_type = flag_6

		local flag_7

		flag_7 = var_12_2 ~= "menu_invert_controls" or not "menu_non_invert_controls" or "menu_invert_controls"
		var_12_1.display_name = flag_7
	end,
	end_game = function (self)
		-- function 13
		Application.force_silent_exit_policy()
		self.input_manager:block_device_except_service(nil, "keyboard", 1)
		self.input_manager:block_device_except_service(nil, "mouse", 1)
		self.input_manager:block_device_except_service(nil, "gamepad", 1)

		local telemetry_survey = self.views.telemetry_survey
		local level_key = Managers.state.game_mode:level_key()
		local var_13_2 = LevelSettings[level_key]
		local send = TelemetrySettings.send

		send = not send and TelemetrySettings.use_session_survey

		local is_survey_answered = telemetry_survey:is_survey_answered()
		local is_survey_timed_out = telemetry_survey:is_survey_timed_out()
		local backend = Managers.backend

		local function fn()
			-- function 14
			if not send and is_survey_answered and is_survey_timed_out and not send or not var_13_2.hub_level then
				self.quit_game = true
				self.current_view = nil
			else
				self.current_view = "telemetry_survey"

				telemetry_survey:set_transition("end_game")
			end
		end

		if not backend:on_shutdown(fn) then
			local time = Managers.time:time("ui")

			self.quit_game_retry = true
			self.delay_quit_game_retry = time + 1
		end
	end,
	do_return_to_title_screen = function (self)
		-- function 15
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_15_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_15_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		elseif not Managers.matchmaking:is_joining_friend() then
			local var_15_2 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_15_2, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			self.input_manager:block_device_except_service(nil, "keyboard", 1)
			self.input_manager:block_device_except_service(nil, "mouse", 1)
			self.input_manager:block_device_except_service(nil, "gamepad", 1)

			self.return_to_title_screen = true
		end
	end,
	do_return_to_title_screen_hero_view = function (self)
		-- function 16
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_16_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_16_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		elseif not Managers.matchmaking:is_joining_friend() then
			local var_16_2 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_16_2, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			self.input_manager:block_device_except_service(nil, "keyboard", 1)
			self.input_manager:block_device_except_service(nil, "mouse", 1)
			self.input_manager:block_device_except_service(nil, "gamepad", 1)

			self.return_to_title_screen = true
		end
	end,
	do_return_to_demo_title_screen = function (self)
		-- function 17
		self.return_to_demo_title_screen = true
	end,
	do_restart_demo = function (self)
		-- function 18
		self.restart_demo = true
	end,
	do_return_to_pc_menu = function (self)
		-- function 19
		local network_server = Managers.state.network.network_server

		if not network_server and not network_server:are_all_peers_ingame(nil, true) then
			self.return_to_pc_menu = true
		elseif not network_server then
			self.return_to_pc_menu = true
		end
	end,
	leave_game = function (self)
		-- function 20
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_20_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_20_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		elseif not Managers.matchmaking:is_joining_friend() then
			local var_20_2 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_20_2, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))
		else
			self.input_manager:block_device_except_service(nil, "keyboard", 1)
			self.input_manager:block_device_except_service(nil, "mouse", 1)
			self.input_manager:block_device_except_service(nil, "gamepad", 1)

			self.leave_game = true
		end
	end,
	leave_game_hero_view = function (self)
		-- function 21
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_21_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_21_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		elseif not Managers.matchmaking:is_joining_friend() then
			local var_21_2 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_21_2, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			self.input_manager:block_device_except_service(nil, "keyboard", 1)
			self.input_manager:block_device_except_service(nil, "mouse", 1)
			self.input_manager:block_device_except_service(nil, "gamepad", 1)

			self.leave_game = true
		end
	end,
	return_to_pc_menu = function (self)
		-- function 22
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not network_server then
			if not network_server:are_all_peers_ingame(nil, true) then
				local var_22_1 = Localize("player_join_block_exit_game")

				self.popup_id = Managers.popup:queue_popup(var_22_1, Localize("popup_error_topic"), "cancel_popup", Localize("menu_ok"))

				return
			elseif network_server:num_active_peers() > 1 then
				local str = Localize("exit_to_title_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players")

				self.popup_id = Managers.popup:queue_popup(str, Localize("popup_exit_game_topic"), "do_return_to_pc_menu", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))

				return
			end
		end

		local var_22_3 = Localize("exit_to_title_popup_text")

		self.popup_id = Managers.popup:queue_popup(var_22_3, Localize("popup_exit_to_title_topic"), "do_return_to_pc_menu", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end,
	return_to_pc_menu_hero_view = function (self)
		-- function 23
		self:_cancel_popup()

		local network_server = Managers.state.network.network_server

		if not (not network_server and network_server:are_all_peers_ingame(nil, true)) then
			local var_23_1 = Localize("player_join_block_exit_game")

			self.popup_id = Managers.popup:queue_popup(var_23_1, Localize("popup_error_topic"), "cancel_popup_hero_view", Localize("menu_ok"))
		else
			local var_23_2 = Localize("exit_to_title_popup_text")

			self.popup_id = Managers.popup:queue_popup(var_23_2, Localize("popup_exit_to_title_topic"), "do_return_to_pc_menu", Localize("popup_choice_yes"), "cancel_popup_hero_view", Localize("popup_choice_no"))
		end
	end,
	ingame_menu = function (self)
		-- function 24
		self.menu_active = true
		self.current_view = "ingame_menu"
	end,
	chat_view = function (self)
		-- function 25
		self.current_view = "chat_view"
	end,
	chat_view_force = function (self)
		-- function 26
		self.current_view = "chat_view"
		self.views[self.current_view].exit_to_game = true
	end,
	hero_view_force = function (self)
		-- function 27
		self.current_view = "hero_view"
		self.views[self.current_view].exit_to_game = true
	end,
	hero_view = function (self)
		-- function 28
		self.current_view = "hero_view"
	end,
	spoils_of_war = function (self)
		-- function 29
		self.current_view = "hero_view"
	end,
	start_game_view_force = function (self)
		-- function 30
		self.current_view = "start_game_view"
		self.views[self.current_view].exit_to_game = true
	end,
	start_game_view = function (self)
		-- function 31
		self.current_view = "start_game_view"
	end,
	start_menu_view_force = function (self)
		-- function 32
		self.current_view = "start_menu_view"
		self.views[self.current_view].exit_to_game = true
	end,
	start_menu_view = function (self)
		-- function 33
		self.current_view = "start_menu_view"
	end,
	initial_start_menu_view_force = function (self)
		-- function 34
		self.current_view = "start_menu_view"
		self.initial_profile_view = true
		self.views[self.current_view].exit_to_game = true
	end,
	exit_initial_start_menu_view = function (self)
		-- function 35
		self.menu_active = false
		self.current_view = nil
		self.initial_profile_view = nil
		self.has_left_menu = true
	end,
	character_selection_force = function (self)
		-- function 36
		self.current_view = "character_selection"
		self.views[self.current_view].exit_to_game = true
	end,
	character_selection = function (self)
		-- function 37
		self.current_view = "character_selection"
	end,
	initial_character_selection_force = function (self, arg_38_1)
		-- function 38
		self.current_view = "character_selection"
		self.initial_profile_view = true
		self.views[self.current_view].exit_to_game = true

		if not arg_38_1.back_to_vs_preview then
			self.views[self.current_view].back_to_vs_preview = arg_38_1.back_to_vs_preview
		end
	end,
	exit_initial_character_selection = function (self)
		-- function 39
		self.menu_active = false
		self.current_view = nil
		self.initial_profile_view = nil
	end,
	join_lobby = function (self, arg_40_1)
		-- function 40
		self.input_manager:block_device_except_service(nil, "keyboard", 1)
		self.input_manager:block_device_except_service(nil, "mouse", 1)
		self.input_manager:block_device_except_service(nil, "gamepad", 1)

		self.join_lobby = arg_40_1
		self.menu_active = false
		self.current_view = nil
	end,
	exit_menu = function (self)
		-- function 41
		local component = self.ingame_hud:component("LevelCountdownUI")

		if not (not component and component:is_enter_game() or Managers.chat:chat_is_focused() or self:get_active_popup("profile_picker")) then
			self.input_manager:device_unblock_all_services("keyboard", 1)
			self.input_manager:device_unblock_all_services("mouse", 1)
			self.input_manager:device_unblock_all_services("gamepad", 1)
		end

		self.menu_active = false
		self.current_view = nil
	end,
	cancel_popup = function (self)
		-- function 42
		self.popup_id = nil

		self.input_manager:block_device_except_service("ingame_menu", "keyboard", 1)
		self.input_manager:block_device_except_service("ingame_menu", "mouse", 1)
		self.input_manager:block_device_except_service("ingame_menu", "gamepad", 1)
	end,
	cancel_popup_hero_view = function (self)
		-- function 43
		self.popup_id = nil

		self.input_manager:block_device_except_service("hero_view", "keyboard", 1)
		self.input_manager:block_device_except_service("hero_view", "mouse", 1)
		self.input_manager:block_device_except_service("hero_view", "gamepad", 1)
	end,
	credits_menu = function (self)
		-- function 44
		self.current_view = "credits_view"
	end,
	options_menu = function (self)
		-- function 45
		self.current_view = "options_view"
	end,
	console_friends_menu = function (self)
		-- function 46
		self.current_view = "console_friends_view"
	end,
	restart_game = function (self)
		-- function 47
		self.input_manager:device_unblock_all_services("keyboard", 1)
		self.input_manager:device_unblock_all_services("mouse", 1)
		self.input_manager:device_unblock_all_services("gamepad", 1)

		self.restart_game = true
	end,
	close_active = function (self)
		-- function 48
		if not self.popup_id then
			Managers.popup:cancel_popup(self.popup_id)

			self.popup_id = nil
		end

		self.menu_active = nil
		self.current_view = nil
	end
}
local tbl_4 = {
	ui_renderer_function = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
		-- function 49
		local tbl = {
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

		if not arg_49_2 then
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "materials/ui/ui_1080p_achievement_atlas_textures"
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "materials/ui/ui_1080p_inn_single_textures"
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "materials/ui/ui_1080p_lock_test"
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "materials/ui/ui_1080p_pose_cosmetics"
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "video/tutorial_videos/tutorial_videos"

			for k, v in pairs(AreaSettings) do
				local video_settings = v.video_settings

				if not video_settings then
					tbl[#tbl + 1] = "material"
					tbl[#tbl + 1] = video_settings.resource
				end
			end

			for k_2, v_2 in pairs(DLCSettings) do
				local ui_materials_in_inn = v_2.ui_materials_in_inn
				local ui_materials_in_inn_condition = v_2.ui_materials_in_inn_condition

				if not ui_materials_in_inn and not ui_materials_in_inn_condition and not ui_materials_in_inn_condition(arg_49_1, arg_49_2, arg_49_3) then
					for i, v_3 in ipairs(ui_materials_in_inn) do
						tbl[#tbl + 1] = "material"
						tbl[#tbl + 1] = v_3
					end
				end
			end
		end

		for k_3, v_4 in pairs(DLCSettings) do
			local ui_materials = v_4.ui_materials
			local ui_materials_condition = v_4.ui_materials_condition

			if not ui_materials and not ui_materials_condition and not ui_materials_condition(arg_49_1, arg_49_2, arg_49_3) then
				for i_2, v_5 in ipairs(ui_materials) do
					tbl[#tbl + 1] = "material"
					tbl[#tbl + 1] = v_5
				end
			end
		end

		if not arg_49_1 then
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "materials/ui/ui_1080p_tutorial_textures"
		end

		for k_4, v_6 in pairs(CareerSettings) do
			local video = v_6.video

			if not video then
				tbl[#tbl + 1] = "material"
				tbl[#tbl + 1] = video.resource
			end
		end

		if not IS_WINDOWS then
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "video/ui_option"
		end

		if not IS_WINDOWS then
			return UIRenderer.create(arg_49_0, unpack(tbl))
		else
			return UIRenderer.create(arg_49_0, unpack(tbl))
		end
	end,
	ui_top_renderer_function = function (arg_50_0, arg_50_1, arg_50_2)
		-- function 50
		local tbl = {
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

		if not arg_50_2 then
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "materials/ui/ui_1080p_achievement_atlas_textures"
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "materials/ui/ui_1080p_inn_single_textures"
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "materials/ui/ui_1080p_pose_cosmetics"

			for k, v in pairs(AreaSettings) do
				local video_settings = v.video_settings

				if not video_settings then
					tbl[#tbl + 1] = "material"
					tbl[#tbl + 1] = video_settings.resource
				end
			end

			for k_2, v_2 in pairs(DLCSettings) do
				local ui_materials_in_inn = v_2.ui_materials_in_inn

				if not ui_materials_in_inn then
					for i, v_3 in ipairs(ui_materials_in_inn) do
						tbl[#tbl + 1] = "material"
						tbl[#tbl + 1] = v_3
					end
				end
			end
		end

		for k_3, v_4 in pairs(DLCSettings) do
			local ui_materials = v_4.ui_materials

			if not ui_materials then
				for i_2, v_5 in ipairs(ui_materials) do
					tbl[#tbl + 1] = "material"
					tbl[#tbl + 1] = v_5
				end
			end
		end

		if not arg_50_1 then
			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = "materials/ui/ui_1080p_tutorial_textures"
		end

		for k_4, v_6 in pairs(CareerSettings) do
			local video = v_6.video

			tbl[#tbl + 1] = "material"
			tbl[#tbl + 1] = video.resource
		end

		if not IS_WINDOWS then
			return UIRenderer.create(world, unpack(tbl))
		else
			return UIRenderer.create(world, unpack(tbl))
		end
	end,
	views_function = function (self)
		-- function 51
		local tbl = {
			credits_view = CreditsView:new(self),
			telemetry_survey = TelemetrySurveyView:new(self),
			options_view = OptionsView:new(self),
			hero_view = HeroView:new(self),
			character_selection = CharacterSelectionView:new(self),
			start_menu_view = StartMenuView:new(self),
			start_game_view = StartGameView:new(self),
			ingame_menu = IngameView:new(self)
		}
		local var_51_1

		if not IS_WINDOWS then
			var_51_1 = ChatView:new(self)

			if not var_51_1 then
				-- Nothing
			end
		end

		var_51_1 = nil

		::label_51_0::

		tbl.chat_view = var_51_1
		tbl.console_friends_view = ConsoleFriendsView:new(self)

		for k, v in pairs(DLCSettings) do
			if not v.ui_views then
				local current_mechanism_name = Managers.mechanism:current_mechanism_name()

				for i, v_2 in ipairs(v.ui_views) do
					local name = v_2.name
					local class_name = v_2.class_name

					if not name and not class_name then
						fassert(tbl[name] == nil, "view name (%s) already exists", name)

						local mechanism_filter = v_2.mechanism_filter

						if not (not mechanism_filter and mechanism_filter[current_mechanism_name] ~= true and not v_2.only_in_inn or self.is_in_inn and not v_2.only_in_game and self.is_in_inn) then
							tbl[name] = _G[class_name]:new(self)
						end
					end
				end
			end
		end

		return tbl
	end,
	hotkey_mapping = {
		hotkey_hero = {
			in_transition = "character_selection_force",
			error_message = "matchmaking_ready_interaction_message_profile_view",
			view = "character_selection",
			transition_state = "character",
			in_transition_menu = "character_selection_view",
			disable_for_mechanism = tbl
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
			inject_transition_params_func = function (self)
				-- function 52
				if not Managers.matchmaking:is_in_versus_custom_game_lobby() then
					self.menu_sub_state_name = "versus_player_hosted_lobby"
					self.panel_title_buttons_hidden = true
					self.ignore_sub_state_on_exit = true
				end
			end
		},
		hotkey_inventory = {
			in_transition = "hero_view_force",
			error_message = "matchmaking_ready_interaction_message_inventory",
			view = "hero_view",
			transition_state = "overview",
			in_transition_menu = "hero_view",
			disable_for_mechanism = tbl
		},
		hotkey_loot = {
			can_interact_func = "can_open_loot",
			in_transition = "hero_view_force",
			error_message = "matchmaking_ready_interaction_message_loot",
			view = "hero_view",
			transition_state = "loot",
			in_transition_menu = "hero_view",
			disable_for_mechanism = tbl_2
		},
		hotkey_achievements = {
			in_transition = "hero_view_force",
			error_message = "matchmaking_ready_interaction_message_achievements",
			view = "hero_view",
			transition_state = "achievements",
			in_transition_menu = "hero_view",
			disable_for_mechanism = tbl
		},
		hotkey_weave_forge = {
			can_interact_func = "weaves_requirements_fulfilled",
			in_transition = "hero_view_force",
			error_message = "matchmaking_ready_interaction_message_weave_forge",
			view = "hero_view",
			transition_state = "weave_forge",
			required_dlc = "scorpion",
			in_transition_menu = "hero_view",
			disable_for_mechanism = tbl_2
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
			disable_for_mechanism = tbl_2
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

DLCUtils.map_list("ui_views", function (self)
	-- function 53
	if not self.transitions then
		for k, v in pairs(self.transitions) do
			fassert(not tbl_3[k], "Transition %q already exists", k)

			tbl_3[k] = v
		end
	end
end)
DLCUtils.merge("hotkey_mapping", tbl_4.hotkey_mapping)
DLCUtils.merge("ui_transitions", tbl_3)

return {
	transitions = tbl_3,
	view_settings = tbl_4
}
