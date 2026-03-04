-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_twitch_game_settings.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_game_settings_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.other_options_widgets
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions

StartGameWindowTwitchGameSettings = class(StartGameWindowTwitchGameSettings)
StartGameWindowTwitchGameSettings.NAME = "StartGameWindowTwitchGameSettings"

StartGameWindowTwitchGameSettings.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowTwitchGameSettings")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._network_lobby = var_1_0.network_lobby
	arg_1_0._mechanism_name = Managers.mechanism:current_mechanism_name()

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._enable_play = false
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0._twitch_active = nil

	arg_1_0:_update_difficulty_option()
end

StartGameWindowTwitchGameSettings.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = UISceneGraph.init_scenegraph(var_0_3)

	arg_2_0.ui_scenegraph = var_2_0

	local var_2_1 = arg_2_0._network_lobby:is_dedicated_server()
	local var_2_2 = {}
	local var_2_3 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_4 = UIWidget.init(iter_2_1)

		var_2_2[#var_2_2 + 1] = var_2_4
		var_2_3[iter_2_0] = var_2_4
	end

	local var_2_5 = {}

	for iter_2_2, iter_2_3 in pairs(var_0_2) do
		local var_2_6 = UIWidget.init(iter_2_3)

		var_2_6.content.visible = not var_2_1
		var_2_5[#var_2_5 + 1] = var_2_6
		var_2_3[iter_2_2] = var_2_6
	end

	arg_2_0._widgets = var_2_2
	arg_2_0._other_options_widgets = var_2_5
	arg_2_0._widgets_by_name = var_2_3

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(var_2_0, var_0_4)

	if arg_2_2 then
		local var_2_7 = var_2_0.window.local_position

		var_2_7[1] = var_2_7[1] + arg_2_2[1]
		var_2_7[2] = var_2_7[2] + arg_2_2[2]
		var_2_7[3] = var_2_7[3] + arg_2_2[3]
	end

	var_2_3.play_button.content.button_hotspot.disable_button = true
	var_2_3.game_option_2.content.button_hotspot.disable_button = true

	arg_2_0:_set_additional_options_enabled_state(false)
	arg_2_0:_update_additional_options(true)

	local var_2_8 = var_2_3.game_option_1
	local var_2_9 = arg_2_0:_animate_pulse(var_2_8.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(var_2_8, var_2_9)

	local var_2_10 = var_2_3.game_option_2
	local var_2_11 = arg_2_0:_animate_pulse(var_2_10.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(var_2_10, var_2_11)
end

StartGameWindowTwitchGameSettings._set_additional_options_enabled_state = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._widgets_by_name

	var_3_0.additional_option.content.button_hotspot.disable_button = not arg_3_1
	var_3_0.private_button.content.button_hotspot.disable_button = not arg_3_1
	var_3_0.host_button.content.button_hotspot.disable_button = not arg_3_1
	var_3_0.strict_matchmaking_button.content.button_hotspot.disable_button = not arg_3_1
	arg_3_0._additional_option_enabled = arg_3_1
end

StartGameWindowTwitchGameSettings.on_exit = function (arg_4_0, arg_4_1)
	print("[StartGameWindow] Exit Substate StartGameWindowTwitchGameSettings")

	arg_4_0.ui_animator = nil
end

StartGameWindowTwitchGameSettings.update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_update_mission_selection()

	if arg_5_0._additional_option_enabled then
		arg_5_0:_update_additional_options()
	end

	arg_5_0:_update_difficulty_option()
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:draw(arg_5_1)
end

StartGameWindowTwitchGameSettings.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	return
end

StartGameWindowTwitchGameSettings._update_animations = function (arg_7_0, arg_7_1)
	arg_7_0:_update_game_options_hover_effect()

	local var_7_0 = arg_7_0._ui_animations

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		UIAnimation.update(iter_7_1, arg_7_1)

		if UIAnimation.completed(iter_7_1) then
			var_7_0[iter_7_0] = nil
		end
	end

	arg_7_0.ui_animator:update(arg_7_1)
end

StartGameWindowTwitchGameSettings._is_button_released = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.content.button_hotspot

	if var_8_0.on_release then
		var_8_0.on_release = false

		return true
	end
end

StartGameWindowTwitchGameSettings._is_button_hover_enter = function (arg_9_0, arg_9_1)
	return arg_9_1.content.button_hotspot.on_hover_enter
end

StartGameWindowTwitchGameSettings._is_button_hover_exit = function (arg_10_0, arg_10_1)
	return arg_10_1.content.button_hotspot.on_hover_exit
end

StartGameWindowTwitchGameSettings._is_other_option_button_selected = function (arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0:_is_button_released(arg_11_1) then
		local var_11_0 = not arg_11_2

		if var_11_0 then
			arg_11_0:_play_sound("play_gui_lobby_button_03_private")
		else
			arg_11_0:_play_sound("play_gui_lobby_button_03_public")
		end

		return var_11_0
	end

	return nil
end

StartGameWindowTwitchGameSettings._handle_input = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.parent
	local var_12_1 = arg_12_0._widgets_by_name

	if arg_12_0._additional_option_enabled then
		local var_12_2 = var_12_1.private_button

		UIWidgetUtils.animate_default_checkbox_button(var_12_2, arg_12_1)

		local var_12_3 = arg_12_0:_is_other_option_button_selected(var_12_2, arg_12_0._private_enabled)

		if var_12_3 ~= nil then
			var_12_0:set_private_option_enabled(var_12_3)
		end

		local var_12_4 = var_12_1.host_button
		local var_12_5 = var_12_1.strict_matchmaking_button

		UIWidgetUtils.animate_default_checkbox_button(var_12_4, arg_12_1)
		UIWidgetUtils.animate_default_checkbox_button(var_12_5, arg_12_1)

		if arg_12_0:_is_button_hover_enter(var_12_1.game_option_1) or arg_12_0:_is_button_hover_enter(var_12_1.game_option_2) or arg_12_0:_is_button_hover_enter(var_12_1.play_button) then
			arg_12_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
		end

		local var_12_6 = arg_12_0:_is_other_option_button_selected(var_12_4, arg_12_0._always_host_enabled)

		if var_12_6 ~= nil then
			var_12_0:set_always_host_option_enabled(var_12_6)
		end

		local var_12_7 = arg_12_0:_is_other_option_button_selected(var_12_5, arg_12_0._strict_matchmaking_enabled)

		if var_12_7 ~= nil then
			var_12_0:set_strict_matchmaking_option_enabled(var_12_7)
		end
	end

	local var_12_8 = var_12_0:get_twitch_settings(arg_12_0._mechanism_name) or var_12_0:get_twitch_settings("adventure")

	if arg_12_0:_is_button_released(var_12_1.game_option_1) then
		var_12_0:set_layout_by_name(var_12_8.layout_name)
	elseif arg_12_0:_is_button_released(var_12_1.game_option_2) then
		var_12_0:set_layout_by_name("difficulty_selection_twitch")
	end

	if arg_12_0:_is_button_released(var_12_1.play_button) then
		var_12_0:play(arg_12_2, var_12_8.game_mode_type)
	end
end

StartGameWindowTwitchGameSettings._play_sound = function (arg_13_0, arg_13_1)
	arg_13_0.parent:play_sound(arg_13_1)
end

StartGameWindowTwitchGameSettings._update_game_options_hover_effect = function (arg_14_0)
	local var_14_0 = arg_14_0._widgets_by_name
	local var_14_1 = "game_option_"

	for iter_14_0 = 1, 2 do
		local var_14_2 = var_14_0[var_14_1 .. iter_14_0]

		if arg_14_0:_is_button_hover_enter(var_14_2) then
			arg_14_0:_on_option_button_hover_enter(iter_14_0)
		elseif arg_14_0:_is_button_hover_exit(var_14_2) then
			arg_14_0:_on_option_button_hover_exit(iter_14_0)
		end
	end
end

StartGameWindowTwitchGameSettings._on_option_button_hover_enter = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._widgets_by_name["game_option_" .. arg_15_1]

	arg_15_0:_create_style_animation_enter(var_15_0, 255, "glow", arg_15_1, arg_15_2)
	arg_15_0:_create_style_animation_enter(var_15_0, 255, "icon_glow", arg_15_1, arg_15_2)
	arg_15_0:_create_style_animation_exit(var_15_0, 0, "button_hover_rect", arg_15_1, arg_15_2)
end

StartGameWindowTwitchGameSettings._on_option_button_hover_exit = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._widgets_by_name["game_option_" .. arg_16_1]

	arg_16_0:_create_style_animation_exit(var_16_0, 0, "glow", arg_16_1, arg_16_2)
	arg_16_0:_create_style_animation_exit(var_16_0, 0, "icon_glow", arg_16_1, arg_16_2)
	arg_16_0:_create_style_animation_enter(var_16_0, 30, "button_hover_rect", arg_16_1, arg_16_2)
end

StartGameWindowTwitchGameSettings._update_additional_options = function (arg_17_0, arg_17_1)
	local var_17_0 = true
	local var_17_1 = true
	local var_17_2 = false
	local var_17_3 = Managers.twitch and Managers.twitch:is_connected()
	local var_17_4 = arg_17_0._network_lobby:members():get_member_count() == 1

	if arg_17_1 or var_17_4 ~= arg_17_0._is_alone or var_17_0 ~= arg_17_0._private_enabled or var_17_1 ~= arg_17_0._always_host_enabled or var_17_2 ~= arg_17_0._strict_matchmaking_enabled or var_17_3 ~= arg_17_0._twitch_active then
		local var_17_5 = arg_17_0._widgets_by_name
		local var_17_6 = true
		local var_17_7 = true
		local var_17_8 = false
		local var_17_9 = var_17_5.private_button

		var_17_9.content.button_hotspot.disable_button = true
		var_17_9.content.button_hotspot.is_selected = var_17_6
		var_17_9.style.hover_glow.color[1] = 0

		local var_17_10 = var_17_5.host_button

		var_17_10.content.button_hotspot.disable_button = true
		var_17_10.content.button_hotspot.is_selected = var_17_7
		var_17_10.style.hover_glow.color[1] = 0

		local var_17_11 = var_17_5.strict_matchmaking_button

		var_17_11.content.button_hotspot.disable_button = true
		var_17_11.content.button_hotspot.is_selected = var_17_8
		var_17_11.style.hover_glow.color[1] = 0
		arg_17_0._private_enabled = var_17_0
		arg_17_0._always_host_enabled = var_17_1
		arg_17_0._strict_matchmaking_enabled = var_17_2
		arg_17_0._twitch_active = var_17_3
		arg_17_0._is_alone = var_17_4
	end
end

StartGameWindowTwitchGameSettings._update_difficulty_option = function (arg_18_0)
	local var_18_0 = arg_18_0.parent:get_difficulty_option()
	local var_18_1 = Managers.twitch and Managers.twitch:is_connected()

	if var_18_0 ~= arg_18_0._difficulty_key or var_18_1 ~= arg_18_0._twitch_active then
		arg_18_0:_set_difficulty_option(var_18_0)

		arg_18_0._difficulty_key = var_18_0

		local var_18_2 = DifficultySettings[var_18_0] ~= nil and rawget(LevelSettings, arg_18_0._selected_level_id) ~= nil
		local var_18_3 = arg_18_0._widgets_by_name

		arg_18_0._enable_play = var_18_2 and var_18_1
		var_18_3.play_button.content.button_hotspot.disable_button = not arg_18_0._enable_play

		if arg_18_0._enable_play then
			arg_18_0.parent:set_input_description("play_available")
		else
			arg_18_0.parent:set_input_description(nil)
		end
	end
end

StartGameWindowTwitchGameSettings._set_difficulty_option = function (arg_19_0, arg_19_1)
	local var_19_0 = DifficultySettings[arg_19_1]
	local var_19_1 = var_19_0 and var_19_0.display_name
	local var_19_2 = var_19_0 and var_19_0.display_image
	local var_19_3 = var_19_0 and var_19_0.completed_frame_texture or "map_frame_00"
	local var_19_4 = arg_19_0._widgets_by_name

	var_19_4.game_option_2.content.option_text = var_19_1 and Localize(var_19_1) or ""
	var_19_4.game_option_2.content.icon = var_19_2 or nil
	var_19_4.game_option_2.content.icon_frame = var_19_3
end

StartGameWindowTwitchGameSettings._update_mission_selection = function (arg_20_0)
	local var_20_0 = arg_20_0.parent:get_selected_level_id()

	if not var_20_0 or var_20_0 ~= arg_20_0._selected_level_id then
		arg_20_0:_set_selected_level(var_20_0)

		arg_20_0._selected_level_id = var_20_0
	end

	arg_20_0._widgets_by_name.game_option_2.content.button_hotspot.disable_button = var_20_0 == nil
end

StartGameWindowTwitchGameSettings._set_selected_level = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._widgets_by_name.game_option_1
	local var_21_1 = "n/a"

	if arg_21_1 then
		local var_21_2 = LevelSettings[arg_21_1]
		local var_21_3 = var_21_2.display_name
		local var_21_4 = var_21_2.level_image

		var_21_1 = Localize(var_21_3)

		local var_21_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_21_4)
		local var_21_6 = var_21_0.style.icon.texture_size

		var_21_6[1] = var_21_5.size[1]
		var_21_6[2] = var_21_5.size[2]
		var_21_0.content.icon = var_21_4

		local var_21_7 = arg_21_0.parent:get_completed_level_difficulty_index(arg_21_0.statistics_db, arg_21_0._stats_id, arg_21_1)
		local var_21_8 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_21_7)

		var_21_0.content.icon_frame = var_21_8
	end

	var_21_0.content.option_text = var_21_1
end

StartGameWindowTwitchGameSettings.draw = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.ui_renderer
	local var_22_1 = arg_22_0.ui_scenegraph
	local var_22_2 = arg_22_0.parent:window_input_service()

	UIRenderer.begin_pass(var_22_0, var_22_1, var_22_2, arg_22_1, nil, arg_22_0.render_settings)

	local var_22_3 = arg_22_0._widgets

	for iter_22_0 = 1, #var_22_3 do
		local var_22_4 = var_22_3[iter_22_0]

		UIRenderer.draw_widget(var_22_0, var_22_4)
	end

	local var_22_5 = arg_22_0._other_options_widgets

	for iter_22_1 = 1, #var_22_5 do
		local var_22_6 = var_22_5[iter_22_1]

		UIRenderer.draw_widget(var_22_0, var_22_6)
	end

	UIRenderer.end_pass(var_22_0)
end

StartGameWindowTwitchGameSettings._play_sound = function (arg_23_0, arg_23_1)
	arg_23_0.parent:play_sound(arg_23_1)
end

StartGameWindowTwitchGameSettings._create_style_animation_enter = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	local var_24_0 = arg_24_1.style[arg_24_3]

	if not var_24_0 then
		return
	end

	local var_24_1 = var_24_0.color[1]
	local var_24_2 = arg_24_2
	local var_24_3 = 0.2
	local var_24_4 = (1 - var_24_1 / var_24_2) * var_24_3

	if var_24_4 > 0 and not arg_24_5 then
		arg_24_0._ui_animations[("game_option_" .. arg_24_3) .. "_hover_" .. arg_24_4] = arg_24_0:_animate_element_by_time(var_24_0.color, 1, var_24_1, var_24_2, var_24_4)
	else
		var_24_0.color[1] = var_24_2
	end
end

StartGameWindowTwitchGameSettings._create_style_animation_exit = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0 = arg_25_1.style[arg_25_3]

	if not var_25_0 then
		return
	end

	local var_25_1 = var_25_0.color[1]
	local var_25_2 = arg_25_2
	local var_25_3 = 0.2
	local var_25_4 = var_25_1 / 255 * var_25_3

	if var_25_4 > 0 and not arg_25_5 then
		arg_25_0._ui_animations[("game_option_" .. arg_25_3) .. "_hover_" .. arg_25_4] = arg_25_0:_animate_element_by_time(var_25_0.color, 1, var_25_1, var_25_2, var_25_4)
	else
		var_25_0.color[1] = var_25_2
	end
end

StartGameWindowTwitchGameSettings._animate_pulse = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5))
end

StartGameWindowTwitchGameSettings._animate_element_by_time = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, math.ease_out_quad))
end
