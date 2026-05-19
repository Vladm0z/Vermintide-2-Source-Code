-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_adventure_mode_settings.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_adventure_mode_settings_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

StartGameWindowAdventureModeSettings = class(StartGameWindowAdventureModeSettings)
StartGameWindowAdventureModeSettings.NAME = "StartGameWindowAdventureModeSettings"

function StartGameWindowAdventureModeSettings.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowAdventureModeSettings")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._enable_play = false
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_update_difficulty_option()
	arg_1_0:_update_next_level_option()
end

function StartGameWindowAdventureModeSettings.create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = UISceneGraph.init_scenegraph(var_0_2)

	arg_2_0.ui_scenegraph = var_2_0

	local var_2_1 = {}
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_3 = UIWidget.init(iter_2_1)

		var_2_1[#var_2_1 + 1] = var_2_3
		var_2_2[iter_2_0] = var_2_3
	end

	arg_2_0._widgets = var_2_1
	arg_2_0._widgets_by_name = var_2_2

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(var_2_0, var_0_3)

	if arg_2_2 then
		local var_2_4 = var_2_0.window.local_position

		var_2_4[1] = var_2_4[1] + arg_2_2[1]
		var_2_4[2] = var_2_4[2] + arg_2_2[2]
		var_2_4[3] = var_2_4[3] + arg_2_2[3]
	end

	var_2_2.play_button.content.button_hotspot.disable_button = true
	var_2_2.game_option_next_mission.content.button_hotspot.disable_button = false

	local var_2_5 = var_2_2.game_option_difficulty
	local var_2_6 = arg_2_0:_animate_pulse(var_2_5.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(var_2_5, var_2_6)
end

function StartGameWindowAdventureModeSettings.on_exit(arg_3_0, arg_3_1)
	print("[StartGameWindow] Exit Substate StartGameWindowAdventureModeSettings")

	arg_3_0.ui_animator = nil
end

function StartGameWindowAdventureModeSettings.update(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_update_difficulty_option()
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:draw(arg_4_1)
end

function StartGameWindowAdventureModeSettings.post_update(arg_5_0, arg_5_1, arg_5_2)
	return
end

function StartGameWindowAdventureModeSettings._update_animations(arg_6_0, arg_6_1)
	arg_6_0:_update_game_options_hover_effect()

	local var_6_0 = arg_6_0._ui_animations

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			var_6_0[iter_6_0] = nil
		end
	end

	local var_6_1 = arg_6_0.ui_animator

	var_6_1:update(arg_6_1)

	local var_6_2 = arg_6_0._animations

	for iter_6_2, iter_6_3 in pairs(var_6_2) do
		if var_6_1:is_animation_completed(iter_6_3) then
			var_6_1:stop_animation(iter_6_3)

			var_6_2[iter_6_2] = nil
		end
	end
end

function StartGameWindowAdventureModeSettings._is_button_released(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		return true
	end
end

function StartGameWindowAdventureModeSettings._is_button_hover_enter(arg_8_0, arg_8_1)
	return arg_8_1.content.button_hotspot.on_hover_enter
end

function StartGameWindowAdventureModeSettings._is_button_hover_exit(arg_9_0, arg_9_1)
	return arg_9_1.content.button_hotspot.on_hover_exit
end

function StartGameWindowAdventureModeSettings._handle_input(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._widgets_by_name

	if arg_10_0:_is_button_hover_enter(var_10_0.game_option_difficulty) or arg_10_0:_is_button_hover_enter(var_10_0.play_button) then
		arg_10_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	local var_10_1 = arg_10_0.parent

	if arg_10_0:_is_button_released(var_10_0.game_option_difficulty) then
		var_10_1:set_layout_by_name("difficulty_selection_adventure")
	end

	local var_10_2 = arg_10_0.parent:window_input_service()
	local var_10_3 = Managers.input:is_device_active("gamepad") and arg_10_0._enable_play and var_10_2:get("refresh_press")

	if arg_10_0:_is_button_released(var_10_0.play_button) or var_10_3 then
		var_10_1:set_private_option_enabled(true)
		var_10_1:play(arg_10_2, "adventure_mode")
	end
end

function StartGameWindowAdventureModeSettings._play_sound(arg_11_0, arg_11_1)
	arg_11_0.parent:play_sound(arg_11_1)
end

function StartGameWindowAdventureModeSettings._update_difficulty_option(arg_12_0)
	local var_12_0 = arg_12_0.parent
	local var_12_1 = var_12_0:get_difficulty_option()

	if var_12_1 == nil then
		var_12_0:set_difficulty_option(DefaultAdventureModeStartingDifficulty)
	end

	if var_12_1 ~= arg_12_0._difficulty_key then
		arg_12_0:_set_difficulty_option(var_12_1)

		arg_12_0._difficulty_key = var_12_1
		arg_12_0._enable_play = DifficultySettings[var_12_1] ~= nil and rawget(LevelSettings, arg_12_0._selected_level_id) ~= nil
		arg_12_0._widgets_by_name.play_button.content.button_hotspot.disable_button = not arg_12_0._enable_play

		if arg_12_0._enable_play then
			arg_12_0.parent:set_input_description("play_available")
		else
			arg_12_0.parent:set_input_description(nil)
		end
	end
end

function StartGameWindowAdventureModeSettings._update_next_level_option(arg_13_0)
	local var_13_0 = LevelUnlockUtils.get_next_adventure_level(arg_13_0.statistics_db, arg_13_0._stats_id)

	arg_13_0.parent:set_selected_level_id(var_13_0)
	arg_13_0:_set_selected_level(var_13_0)
end

function StartGameWindowAdventureModeSettings._set_selected_level(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._widgets_by_name.game_option_next_mission
	local var_14_1 = "n/a"

	if arg_14_1 then
		local var_14_2 = LevelSettings[arg_14_1]
		local var_14_3 = var_14_2.display_name
		local var_14_4 = var_14_2.level_image

		var_14_1 = Localize(var_14_3)

		local var_14_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_14_4)
		local var_14_6 = var_14_0.style.icon.texture_size

		var_14_6[1] = var_14_5.size[1]
		var_14_6[2] = var_14_5.size[2]
		var_14_0.content.icon = var_14_4

		local var_14_7 = LevelUnlockUtils.completed_level_difficulty_index(arg_14_0.statistics_db, arg_14_0._stats_id, arg_14_1) or 0
		local var_14_8 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_14_7)

		var_14_0.content.icon_frame = var_14_8
	end

	var_14_0.content.option_text = var_14_1
end

function StartGameWindowAdventureModeSettings._set_difficulty_option(arg_15_0, arg_15_1)
	local var_15_0 = DifficultySettings[arg_15_1]
	local var_15_1 = var_15_0 and var_15_0.display_name
	local var_15_2 = var_15_0 and var_15_0.display_image
	local var_15_3 = var_15_0 and var_15_0.completed_frame_texture or "map_frame_00"
	local var_15_4 = arg_15_0._widgets_by_name

	var_15_4.game_option_difficulty.content.option_text = var_15_1 and Localize(var_15_1) or ""
	var_15_4.game_option_difficulty.content.icon = var_15_2 or nil
	var_15_4.game_option_difficulty.content.icon_frame = var_15_3
end

function StartGameWindowAdventureModeSettings.draw(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.ui_renderer
	local var_16_1 = arg_16_0.ui_scenegraph
	local var_16_2 = arg_16_0.parent:window_input_service()

	UIRenderer.begin_pass(var_16_0, var_16_1, var_16_2, arg_16_1, nil, arg_16_0.render_settings)

	local var_16_3 = arg_16_0._widgets

	for iter_16_0 = 1, #var_16_3 do
		local var_16_4 = var_16_3[iter_16_0]

		UIRenderer.draw_widget(var_16_0, var_16_4)
	end

	UIRenderer.end_pass(var_16_0)
end

function StartGameWindowAdventureModeSettings._play_sound(arg_17_0, arg_17_1)
	arg_17_0.parent:play_sound(arg_17_1)
end

function StartGameWindowAdventureModeSettings._update_game_options_hover_effect(arg_18_0)
	local var_18_0 = arg_18_0._widgets_by_name.game_option_difficulty

	if arg_18_0:_is_button_hover_enter(var_18_0) then
		arg_18_0:_on_option_button_hover_enter(var_18_0, 1)
	elseif arg_18_0:_is_button_hover_exit(var_18_0) then
		arg_18_0:_on_option_button_hover_exit(var_18_0, 1)
	end
end

function StartGameWindowAdventureModeSettings._on_option_button_hover_enter(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0:_create_style_animation_enter(arg_19_1, 255, "glow", arg_19_2, arg_19_3)
	arg_19_0:_create_style_animation_enter(arg_19_1, 255, "icon_glow", arg_19_2, arg_19_3)
	arg_19_0:_create_style_animation_exit(arg_19_1, 0, "button_hover_rect", arg_19_2, arg_19_3)
end

function StartGameWindowAdventureModeSettings._on_option_button_hover_exit(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0:_create_style_animation_exit(arg_20_1, 0, "glow", arg_20_2, arg_20_3)
	arg_20_0:_create_style_animation_exit(arg_20_1, 0, "icon_glow", arg_20_2, arg_20_3)
	arg_20_0:_create_style_animation_enter(arg_20_1, 30, "button_hover_rect", arg_20_2, arg_20_3)
end

function StartGameWindowAdventureModeSettings._create_style_animation_enter(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	local var_21_0 = arg_21_1.style[arg_21_3]

	if not var_21_0 then
		return
	end

	local var_21_1 = var_21_0.color[1]
	local var_21_2 = arg_21_2
	local var_21_3 = 0.2
	local var_21_4 = (1 - var_21_1 / var_21_2) * var_21_3

	if var_21_4 > 0 and not arg_21_5 then
		arg_21_0._ui_animations[("game_option_" .. arg_21_3) .. "_hover_" .. arg_21_4] = arg_21_0:_animate_element_by_time(var_21_0.color, 1, var_21_1, var_21_2, var_21_4)
	else
		var_21_0.color[1] = var_21_2
	end
end

function StartGameWindowAdventureModeSettings._create_style_animation_exit(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	local var_22_0 = arg_22_1.style[arg_22_3]

	if not var_22_0 then
		return
	end

	local var_22_1 = var_22_0.color[1]
	local var_22_2 = arg_22_2
	local var_22_3 = 0.2
	local var_22_4 = var_22_1 / 255 * var_22_3

	if var_22_4 > 0 and not arg_22_5 then
		arg_22_0._ui_animations[("game_option_" .. arg_22_3) .. "_hover_" .. arg_22_4] = arg_22_0:_animate_element_by_time(var_22_0.color, 1, var_22_1, var_22_2, var_22_4)
	else
		var_22_0.color[1] = var_22_2
	end
end

function StartGameWindowAdventureModeSettings._animate_pulse(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5))
end

function StartGameWindowAdventureModeSettings._animate_element_by_time(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, math.ease_out_quad))
end
