-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_custom_game.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_custom_game_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.selector_input_definition
local var_0_5 = "refresh_press"
local var_0_6 = "confirm_press"

StartGameWindowVersusCustomGame = class(StartGameWindowVersusCustomGame)
StartGameWindowVersusCustomGame.NAME = "StartGameWindowVersusCustomGame"

function StartGameWindowVersusCustomGame.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowVersusCustomGame")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._mechanism_name = Managers.mechanism:current_mechanism_name()
	arg_1_0._stats_id = Managers.player:local_player():stats_id()
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0._input_index = arg_1_1.input_index or 1

	arg_1_0:_handle_new_selection(arg_1_0._input_index)

	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._previous_can_play = nil

	local var_1_1 = not Managers.account:offline_mode()

	arg_1_0._is_online = var_1_1

	if var_1_1 then
		arg_1_0._parent:change_generic_actions("default_custom_game")
	else
		arg_1_0._parent:change_generic_actions("offline_custom_game")
	end

	arg_1_0:_start_transition_animation("on_enter")
end

function StartGameWindowVersusCustomGame._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function StartGameWindowVersusCustomGame._create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = UISceneGraph.init_scenegraph(var_0_1)

	arg_3_0._ui_scenegraph = var_3_0

	local var_3_1 = {}
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_2) do
		local var_3_3 = UIWidget.init(iter_3_1)

		var_3_1[#var_3_1 + 1] = var_3_3
		var_3_2[iter_3_0] = var_3_3
	end

	arg_3_0._widgets = var_3_1
	arg_3_0._widgets_by_name = var_3_2

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(var_3_0, var_0_3)

	if arg_3_2 then
		local var_3_4 = arg_3_0._ui_scenegraph.window.local_position

		var_3_4[1] = var_3_4[1] + arg_3_2[1]
		var_3_4[2] = var_3_4[2] + arg_3_2[2]
		var_3_4[3] = var_3_4[3] + arg_3_2[3]
	end
end

function StartGameWindowVersusCustomGame.on_exit(arg_4_0, arg_4_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowVersusCustomGame")

	arg_4_0._ui_animator = nil

	if arg_4_0._play_button_pressed then
		arg_4_1.input_index = nil
	else
		arg_4_1.input_index = arg_4_0._input_index
	end
end

function StartGameWindowVersusCustomGame.set_focus(arg_5_0, arg_5_1)
	arg_5_0._is_focused = arg_5_1
end

function StartGameWindowVersusCustomGame.update(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.input:is_device_active("gamepad")

	arg_6_0:_update_can_play()
	arg_6_0:_update_animations(arg_6_1)

	if arg_6_0._is_focused then
		arg_6_0:_handle_input(arg_6_1, arg_6_2)
		arg_6_0:_update_play_button_texture(var_6_0)
	end

	arg_6_0:_draw(arg_6_1)
end

function StartGameWindowVersusCustomGame.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function StartGameWindowVersusCustomGame._update_can_play(arg_8_0)
	local var_8_0 = arg_8_0:_can_play()

	if arg_8_0._previous_can_play ~= var_8_0 then
		arg_8_0._previous_can_play = var_8_0

		local var_8_1 = arg_8_0._widgets_by_name.play_button

		var_8_1.content.button_hotspot.disable_button = not var_8_0
		var_8_1.content.disabled = not var_8_0

		if var_8_0 then
			arg_8_0._parent:set_input_description("play_available")
		else
			arg_8_0._parent:set_input_description(nil)
		end
	end
end

function StartGameWindowVersusCustomGame._handle_input(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._parent
	local var_9_1 = var_9_0:window_input_service()

	if var_9_1:get(var_0_6, true) then
		arg_9_0:_option_selected(arg_9_0._input_index, arg_9_2)
	end

	local var_9_2 = arg_9_0._input_index

	if var_9_1:get("move_down") then
		var_9_2 = var_9_2 + 1
	elseif var_9_1:get("move_up") then
		var_9_2 = var_9_2 - 1
	end

	if var_9_2 ~= arg_9_0._input_index then
		arg_9_0:_handle_new_selection(var_9_2)
	end

	local var_9_3 = arg_9_0._widgets_by_name

	for iter_9_0 = 1, #var_0_4 do
		local var_9_4 = var_9_3[var_0_4[iter_9_0]]

		if not var_9_4.content.is_selected and UIUtils.is_button_hover_enter(var_9_4) then
			arg_9_0:_handle_new_selection(iter_9_0)
		end

		if UIUtils.is_button_pressed(var_9_4) then
			arg_9_0:_option_selected(arg_9_0._input_index, arg_9_2)
		end
	end

	if arg_9_0:_can_play() then
		if UIUtils.is_button_hover_enter(var_9_3.play_button) then
			arg_9_0._parent:play_sound("Play_hud_hover")
		end

		if var_9_1:get(var_0_5) or UIUtils.is_button_pressed(var_9_3.play_button) then
			arg_9_0._play_button_pressed = true

			arg_9_0:_play()
		end
	end

	local var_9_5 = true

	if var_9_1:get("right_stick_press", var_9_5) and arg_9_0._is_online then
		var_9_0:set_window_input_focus("versus_additional_custom_settings")
	end
end

function StartGameWindowVersusCustomGame._can_play(arg_10_0)
	local var_10_0 = Managers.player:local_player():network_id()
	local var_10_1
	local var_10_2
	local var_10_3 = Managers.party:get_local_player_party()
	local var_10_4 = var_10_3 and var_10_3.num_used_slots == 1

	if DEDICATED_SERVER then
		var_10_2 = Managers.party:client_is_friend_party_leader(var_10_0) or Managers.party:is_leader(var_10_0)
	else
		var_10_2 = Managers.party:is_leader(var_10_0) or arg_10_0._ingame_ui_context.is_server
	end

	return var_10_4 or var_10_2
end

function StartGameWindowVersusCustomGame._play(arg_11_0)
	arg_11_0._parent:play_sound("Play_vs_hud_play_menu_host_lobby")
	arg_11_0._parent:set_layout_by_name("versus_player_hosted_lobby")

	local var_11_0 = arg_11_0._parent:get_selected_level_id() or "any"
	local var_11_1 = arg_11_0._parent:is_private_option_enabled()
	local var_11_2 = Managers.state.network:lobby()
	local var_11_3 = {
		player_hosted = true,
		matchmaking_start_state = "MatchmakingStatePlayerHostedGame",
		dedicated_server = false,
		matchmaking_type = "custom",
		mechanism = "versus",
		quick_game = false,
		difficulty = "versus_base",
		mission_id = var_11_0,
		any_level = var_11_0 == "any",
		private_game = var_11_1 or false,
		party_lobby_host = var_11_2,
		max_num_players = GameModeSettings.versus.max_num_players
	}

	Managers.matchmaking:find_game(var_11_3)
end

function StartGameWindowVersusCustomGame._option_selected(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._parent
	local var_12_1 = var_12_0:get_custom_game_settings(arg_12_0._mechanism_name) or var_12_0:get_custom_game_settings("adventure")
	local var_12_2 = var_0_4[arg_12_1]

	if var_12_2 == "mission_setting" then
		arg_12_0._parent:set_layout_by_name(var_12_1.layout_name)
	elseif var_12_2 == "difficulty_setting" then
		arg_12_0._parent:set_layout_by_name("difficulty_selection_custom")
	elseif var_12_2 == "play_button" then
		arg_12_0._play_button_pressed = true

		arg_12_0:_play()
	else
		ferror("Unknown selector_input_definition: %s", var_12_2)
	end
end

function StartGameWindowVersusCustomGame._handle_new_selection(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._widgets_by_name
	local var_13_1 = #var_0_4

	arg_13_1 = math.clamp(arg_13_1, 1, var_13_1)

	if var_13_0[var_0_4[arg_13_1]].content.disabled then
		return
	end

	for iter_13_0 = 1, #var_0_4 do
		local var_13_2 = var_13_0[var_0_4[iter_13_0]]
		local var_13_3 = iter_13_0 == arg_13_1 and arg_13_0._gamepad_active

		var_13_2.content.is_selected = var_13_3
	end

	if arg_13_0._input_index ~= arg_13_1 then
		arg_13_0._parent:play_sound("play_gui_lobby_button_02_mission_act_click")
	end

	arg_13_0._input_index = arg_13_1
end

function StartGameWindowVersusCustomGame._update_animations(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._ui_animator

	var_14_0:update(arg_14_1)

	local var_14_1 = arg_14_0._animations

	for iter_14_0, iter_14_1 in pairs(var_14_1) do
		if var_14_0:is_animation_completed(iter_14_1) then
			var_14_0:stop_animation(iter_14_1)

			var_14_1[iter_14_0] = nil
		end
	end

	local var_14_2 = arg_14_0._widgets_by_name

	if not var_14_2.play_button.content.button_hotspot.disable_button then
		UIWidgetUtils.animate_play_button(var_14_2.play_button, arg_14_1)
	end
end

function StartGameWindowVersusCustomGame._draw(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._ui_top_renderer
	local var_15_1 = arg_15_0._ui_scenegraph
	local var_15_2 = arg_15_0._parent:window_input_service()
	local var_15_3 = arg_15_0._render_settings
	local var_15_4

	UIRenderer.begin_pass(var_15_0, var_15_1, var_15_2, arg_15_1, var_15_4, var_15_3)

	local var_15_5 = arg_15_0._widgets

	for iter_15_0 = 1, #var_15_5 do
		local var_15_6 = var_15_5[iter_15_0]

		UIRenderer.draw_widget(var_15_0, var_15_6)
	end

	UIRenderer.end_pass(var_15_0)
end

function StartGameWindowVersusCustomGame._update_play_button_texture(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._widgets_by_name

	if arg_16_0._gamepad_active ~= arg_16_1 then
		arg_16_0._gamepad_active = arg_16_1

		if arg_16_1 then
			local var_16_1 = arg_16_0._parent:window_input_service()
			local var_16_2 = "refresh"
			local var_16_3 = UISettings.get_gamepad_input_texture_data(var_16_1, var_16_2, arg_16_1)

			if var_16_3 then
				var_16_0.play_button.content.texture_icon_id = var_16_3.texture
			end
		else
			var_16_0.play_button.content.texture_icon_id = "options_button_icon_quickplay"
		end

		arg_16_0:_handle_new_selection(arg_16_0._input_index)
	end
end
