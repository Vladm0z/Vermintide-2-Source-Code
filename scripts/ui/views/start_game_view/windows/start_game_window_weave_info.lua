-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_info.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_info_definitions")
local var_0_1 = var_0_0.create_objective_widget
local var_0_2 = var_0_0.top_widgets
local var_0_3 = var_0_0.bottom_widgets
local var_0_4 = var_0_0.bottom_hdr_widgets
local var_0_5 = var_0_0.scenegraph_definition
local var_0_6 = var_0_0.animation_definitions
local var_0_7 = false
local var_0_8 = 1.5

StartGameWindowWeaveInfo = class(StartGameWindowWeaveInfo)
StartGameWindowWeaveInfo.NAME = "StartGameWindowWeaveInfo"

StartGameWindowWeaveInfo.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowWeaveInfo")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui = var_1_0.ingame_ui
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._network_lobby = var_1_0.network_lobby
	arg_1_0._is_server = var_1_0.is_server
	arg_1_0._is_in_inn = var_1_0.is_in_inn
	arg_1_0._ui_hdr_renderer = arg_1_0._parent:hdr_renderer()
	arg_1_0._my_player = var_1_0.player

	local var_1_1 = Managers.player:local_player()

	if var_1_1 then
		arg_1_0._stats_id = var_1_1:stats_id()
	end

	arg_1_0._enable_play = false
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_start_transition_animation("on_enter")
end

StartGameWindowWeaveInfo._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = arg_2_0._widgets_by_name
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_5, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

StartGameWindowWeaveInfo._create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_5)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_2) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_1[#var_3_1 + 1] = var_3_2
		var_3_0[iter_3_0] = var_3_2
	end

	local var_3_3 = {}

	for iter_3_2, iter_3_3 in pairs(var_0_3) do
		local var_3_4 = UIWidget.init(iter_3_3)

		var_3_3[#var_3_3 + 1] = var_3_4
		var_3_0[iter_3_2] = var_3_4
	end

	local var_3_5 = {}

	for iter_3_4, iter_3_5 in pairs(var_0_4) do
		local var_3_6 = UIWidget.init(iter_3_5)

		var_3_5[#var_3_5 + 1] = var_3_6
		var_3_0[iter_3_4] = var_3_6
	end

	arg_3_0._top_widgets = var_3_1
	arg_3_0._bottom_widgets = var_3_3
	arg_3_0._bottom_hdr_widgets = var_3_5
	arg_3_0._widgets_by_name = var_3_0

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_6)

	local var_3_7 = arg_3_0._parent:is_private_option_enabled()

	var_3_0.private_checkbox.content.button_hotspot.is_selected = var_3_7
	var_3_0.play_button.content.button_hotspot.disable_button = true

	arg_3_0:_align_private_checkbox()
	arg_3_0:_setup_input_buttons()
end

StartGameWindowWeaveInfo._setup_input_buttons = function (arg_4_0)
	local var_4_0 = arg_4_0._parent:window_input_service()
	local var_4_1 = UISettings.get_gamepad_input_texture_data(var_4_0, "refresh_press", true)
	local var_4_2 = arg_4_0._widgets_by_name.play_button_console
	local var_4_3 = var_4_2.style.input_texture

	var_4_3.horizontal_alignment = "center"
	var_4_3.vertical_alignment = "center"
	var_4_3.texture_size = {
		var_4_1.size[1],
		var_4_1.size[2]
	}
	var_4_2.content.input_texture = var_4_1.texture
end

StartGameWindowWeaveInfo.on_exit = function (arg_5_0, arg_5_1)
	print("[StartGameWindow] Exit Substate StartGameWindowWeaveInfo")

	arg_5_0._ui_animator = nil
end

StartGameWindowWeaveInfo.update = function (arg_6_0, arg_6_1, arg_6_2)
	if var_0_7 then
		var_0_7 = false

		arg_6_0:_create_ui_elements()
	end

	arg_6_0:_update_can_play()
	arg_6_0:_handle_gamepad_activity()
	arg_6_0:_update_selected_weave()
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_update_party_status(arg_6_1)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:draw(arg_6_1)
end

StartGameWindowWeaveInfo._handle_gamepad_activity = function (arg_7_0)
	local var_7_0 = arg_7_0.gamepad_active_last_frame == nil

	if Managers.input:is_device_active("gamepad") then
		if not arg_7_0.gamepad_active_last_frame or var_7_0 then
			arg_7_0.gamepad_active_last_frame = true

			local var_7_1 = arg_7_0._widgets_by_name

			var_7_1.play_button.content.visible = false
			var_7_1.play_button_console.content.visible = true
		end
	elseif arg_7_0.gamepad_active_last_frame or var_7_0 then
		arg_7_0.gamepad_active_last_frame = false

		local var_7_2 = arg_7_0._widgets_by_name

		var_7_2.play_button.content.visible = true
		var_7_2.play_button_console.content.visible = false
	end
end

StartGameWindowWeaveInfo._update_can_play = function (arg_8_0)
	local var_8_0 = arg_8_0._widgets_by_name
	local var_8_1 = Managers.matchmaking:is_game_matchmaking()
	local var_8_2 = arg_8_0._is_matchmaking

	arg_8_0._is_matchmaking = var_8_1

	if var_8_1 ~= var_8_2 then
		if var_8_1 then
			var_8_0.play_button.content.button_hotspot.disable_button = true

			arg_8_0._parent:set_input_description("cancel_matchmaking_lock")
		else
			arg_8_0._parent:set_input_description("play_available_lock")
		end
	end

	local var_8_3 = arg_8_0._widgets_by_name.play_button_console

	if var_8_1 then
		var_8_3.content.text = Localize("cancel_matchmaking")

		if arg_8_0._is_server then
			var_8_3.content.locked = false
		else
			var_8_3.content.locked = true
		end
	elseif arg_8_0._selected_weave_name and LevelUnlockUtils.weave_disabled(arg_8_0._selected_weave_name) then
		var_8_0.play_button.content.button_hotspot.disable_button = true
		var_8_0.play_button.content.locked = true
		var_8_3.content.locked = true
	else
		var_8_3.content.locked = false
		var_8_0.play_button.content.button_hotspot.disable_button = false
		var_8_0.play_button.content.locked = false
		var_8_3.content.text = Localize("start_game_window_play")
	end
end

StartGameWindowWeaveInfo.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	return
end

StartGameWindowWeaveInfo._update_animations = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._ui_animations
	local var_10_1 = arg_10_0._animations
	local var_10_2 = arg_10_0._ui_animator

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		UIAnimation.update(iter_10_1, arg_10_1)

		if UIAnimation.completed(iter_10_1) then
			var_10_0[iter_10_0] = nil
		end
	end

	var_10_2:update(arg_10_1)

	for iter_10_2, iter_10_3 in pairs(var_10_1) do
		if var_10_2:is_animation_completed(iter_10_3) then
			var_10_2:stop_animation(iter_10_3)

			var_10_1[iter_10_2] = nil
		end
	end

	arg_10_0:_update_wind_icon_animation(arg_10_1)

	local var_10_3 = arg_10_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_10_3.play_button, arg_10_1)
	UIWidgetUtils.animate_default_button(var_10_3.private_checkbox, arg_10_1)
end

StartGameWindowWeaveInfo._is_button_pressed = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	if var_11_0.on_release then
		var_11_0.on_release = false

		return true
	end
end

StartGameWindowWeaveInfo._is_button_released = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	if var_12_0.on_release then
		var_12_0.on_release = false

		return true
	end
end

StartGameWindowWeaveInfo._is_stepper_button_pressed = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1.content
	local var_13_1 = var_13_0.button_hotspot_left
	local var_13_2 = var_13_0.button_hotspot_right

	if var_13_1.on_release then
		var_13_1.on_release = false

		return true, -1
	elseif var_13_2.on_release then
		var_13_2.on_release = false

		return true, 1
	end
end

StartGameWindowWeaveInfo._is_button_hover_enter = function (arg_14_0, arg_14_1)
	return arg_14_1.content.button_hotspot.on_hover_enter
end

StartGameWindowWeaveInfo._is_button_hover_exit = function (arg_15_0, arg_15_1)
	return arg_15_1.content.button_hotspot.on_hover_exit
end

StartGameWindowWeaveInfo._is_button_selected = function (arg_16_0, arg_16_1)
	return arg_16_1.content.button_hotspot.is_selected
end

StartGameWindowWeaveInfo._handle_input = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._parent
	local var_17_1 = arg_17_0._widgets_by_name
	local var_17_2 = Managers.input:is_device_active("gamepad")
	local var_17_3 = arg_17_0._parent:window_input_service()
	local var_17_4 = var_17_1.play_button
	local var_17_5 = var_17_1.private_checkbox

	if arg_17_0:_is_button_hover_enter(var_17_4) then
		arg_17_0:_play_sound("Play_hud_hover")
	end

	local var_17_6 = var_17_2 and var_17_3:get("right_stick_press")

	if arg_17_0:_is_button_released(var_17_5) or var_17_6 then
		local var_17_7 = var_17_5.content

		var_17_7.button_hotspot.is_selected = not var_17_7.button_hotspot.is_selected

		var_17_0:set_private_option_enabled(var_17_7.button_hotspot.is_selected)
		arg_17_0:_play_sound("play_gui_lobby_button_play")
	end

	local var_17_8 = var_17_2 and arg_17_0._enable_play and var_17_3:get("refresh_press")

	if arg_17_0:_is_button_released(var_17_4) or var_17_8 then
		var_17_0:play(arg_17_2, "weave")
		arg_17_0:_play_sound("menu_wind_level_choose_wind")
	end
end

local var_0_9 = {
	Localize("menu_weave_play_find_party"),
	(Localize("menu_weave_play_find_party_cancel"))
}

StartGameWindowWeaveInfo._update_party_status = function (arg_18_0, arg_18_1)
	local var_18_0 = Managers.matchmaking
	local var_18_1 = var_18_0:is_game_matchmaking()
	local var_18_2 = var_18_0:active_game_mode()
	local var_18_3 = var_18_2 and var_18_2 == "weave"
	local var_18_4 = var_18_1 and var_18_3

	arg_18_0._is_matchmaking_for_weave = var_18_4

	local var_18_5 = arg_18_0._widgets_by_name.play_button.content
	local var_18_6 = var_18_5.button_hotspot

	if not var_18_5.locked then
		var_18_6.disable_button = var_18_4
	end
end

StartGameWindowWeaveInfo._play_sound = function (arg_19_0, arg_19_1)
	arg_19_0._parent:play_sound(arg_19_1)
end

StartGameWindowWeaveInfo._update_selected_weave = function (arg_20_0)
	local var_20_0 = arg_20_0._params.selected_weave_template

	if not var_20_0 then
		local var_20_1 = arg_20_0._parent:get_selected_weave_id()

		var_20_0 = WeaveSettings.templates_ordered[var_20_1]
	end

	local var_20_2 = arg_20_0._widgets_by_name

	if var_20_0 then
		local var_20_3 = var_20_0.name

		if var_20_3 and var_20_3 ~= arg_20_0._selected_weave_name then
			arg_20_0._selected_weave_name = var_20_3

			local var_20_4 = var_20_0.objectives
			local var_20_5 = var_20_0.display_name

			var_20_2.title.content.text = var_20_5

			local var_20_6 = var_20_4[1].level_id
			local var_20_7 = LevelSettings[var_20_6].display_name

			var_20_2.level_title.content.text = var_20_7

			local var_20_8 = var_20_0.wind
			local var_20_9 = WindSettings[var_20_8]
			local var_20_10 = var_20_2.wind_title
			local var_20_11 = var_20_2.wind_icon

			var_20_10.content.text = var_20_9.lore_display_name

			arg_20_0:_set_wind_icon_by_name(var_20_8)
			arg_20_0:_set_colors_by_wind(var_20_8)

			local var_20_12 = var_20_9.mutator
			local var_20_13 = MutatorTemplates[var_20_12]
			local var_20_14 = var_20_2.mutator_icon
			local var_20_15 = var_20_2.mutator_title_text
			local var_20_16 = var_20_2.mutator_description_text

			var_20_14.content.texture_id = var_20_13.icon
			var_20_15.content.text = var_20_13.display_name
			var_20_16.content.text = var_20_13.description

			local var_20_17 = 10
			local var_20_18 = 0
			local var_20_19 = "objective"
			local var_20_20 = var_0_5[var_20_19].size
			local var_20_21 = var_0_1(var_20_19, var_20_20)
			local var_20_22 = {}

			for iter_20_0 = 1, #var_20_4 do
				local var_20_23 = UIWidget.init(var_20_21)

				var_20_22[#var_20_22 + 1] = var_20_23

				local var_20_24 = var_20_4[iter_20_0]
				local var_20_25 = var_20_24.conflict_settings == "weave_disabled"
				local var_20_26 = var_20_25 and "menu_weave_play_next_end_event_title" or "menu_weave_play_main_objective_title"
				local var_20_27 = var_20_24.display_name
				local var_20_28 = var_20_25 and "objective_icon_boss" or "objective_icon_general"
				local var_20_29 = arg_20_0:_assign_objective(var_20_23, var_20_26, var_20_27, var_20_28, var_20_17)

				var_20_23.offset[2] = -var_20_18
				var_20_18 = var_20_18 + var_20_29 + var_20_17
			end

			arg_20_0._objective_widgets = var_20_22
		end

		if not var_20_2.play_button.content.locked then
			var_20_2.play_button.content.button_hotspot.disable_button = false
		end
	end
end

StartGameWindowWeaveInfo._update_wind_icon_animation = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._wind_icon_animation_time

	if not var_21_0 then
		return
	end

	local var_21_1 = math.max(var_21_0 - arg_21_1, 0)
	local var_21_2 = math.clamp(1 - var_21_1 / var_0_8, 0, 1)
	local var_21_3 = math.lerp(0, 1, var_21_2)
	local var_21_4 = arg_21_0._widgets_by_name.wind_icon
	local var_21_5 = arg_21_0._ui_hdr_renderer.gui
	local var_21_6 = var_21_4.content.texture_id
	local var_21_7 = Gui.material(var_21_5, var_21_6)

	Material.set_scalar(var_21_7, "progress", var_21_3)

	local var_21_8 = math.easeInCubic(var_21_2)

	var_21_4.style.texture_id.color[1] = 255 * var_21_8

	if var_21_2 == 1 then
		arg_21_0._wind_icon_animation_time = nil
	else
		arg_21_0._wind_icon_animation_time = var_21_1
	end
end

local var_0_10 = {
	shadow = 2,
	fire = 4,
	beasts = 5,
	life = 0,
	death = 3,
	light = 6,
	heavens = 1,
	metal = 7
}

StartGameWindowWeaveInfo._set_wind_icon_by_name = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._widgets_by_name.wind_icon
	local var_22_1 = var_0_10[arg_22_1]
	local var_22_2 = arg_22_0._ui_renderer.gui
	local var_22_3 = arg_22_0._ui_hdr_renderer.gui
	local var_22_4 = var_22_0.content.texture_id
	local var_22_5 = Gui.material(var_22_3, var_22_4)

	Material.set_scalar(var_22_5, "texture_index", var_22_1)

	arg_22_0._wind_icon_animation_time = var_0_8
end

StartGameWindowWeaveInfo._set_colors_by_wind = function (arg_23_0, arg_23_1)
	local var_23_0 = Colors.get_color_table_with_alpha(arg_23_1, 255)
	local var_23_1 = arg_23_0._widgets_by_name

	arg_23_0:_apply_color_values(var_23_1.wind_title.style.text.text_color, var_23_0)
	arg_23_0:_apply_color_values(var_23_1.wind_icon.style.texture_id.color, var_23_0)
end

StartGameWindowWeaveInfo._align_private_checkbox = function (arg_24_0)
	local var_24_0 = Managers.input:is_device_active("gamepad")
	local var_24_1 = arg_24_0._widgets_by_name.private_checkbox
	local var_24_2 = var_24_1.content
	local var_24_3 = var_24_1.offset
	local var_24_4 = var_24_1.style
	local var_24_5 = var_24_2.button_hotspot
	local var_24_6 = var_24_4.button_hotspot.size
	local var_24_7 = var_24_4.text
	local var_24_8 = var_24_7.offset[1]
	local var_24_9 = arg_24_0._ui_renderer
	local var_24_10 = var_24_8 + UIUtils.get_text_width(var_24_9, var_24_7, var_24_5.text)

	var_24_3[1] = -var_24_10 / 2
	var_24_3[2] = var_24_0 and 40 or 0

	local var_24_11 = var_24_4.additional_option_info
	local var_24_12 = var_24_11.max_width

	var_24_11.offset[1] = -(var_24_12 / 2 - var_24_10 / 2)
	var_24_6[1] = var_24_10
end

StartGameWindowWeaveInfo._apply_color_values = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	arg_25_3 = arg_25_3 or 1

	if arg_25_4 then
		arg_25_1[1] = arg_25_2[1]
	end

	arg_25_1[2] = math.floor(arg_25_2[2] * arg_25_3)
	arg_25_1[3] = math.floor(arg_25_2[3] * arg_25_3)
	arg_25_1[4] = math.floor(arg_25_2[4] * arg_25_3)
end

StartGameWindowWeaveInfo._assign_objective = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	local var_26_0 = arg_26_1.scenegraph_id
	local var_26_1 = arg_26_1.content
	local var_26_2 = arg_26_1.style
	local var_26_3 = var_0_5[var_26_0].size

	var_26_1.icon = arg_26_4 or "trial_gem"
	var_26_1.title_text = arg_26_2 or "-"
	var_26_1.text = arg_26_3 or "-"

	local var_26_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_26_1.icon).size
	local var_26_5 = var_26_2.icon
	local var_26_6 = var_26_5.texture_size
	local var_26_7 = var_26_5.default_offset
	local var_26_8 = var_26_5.offset

	var_26_6[1] = var_26_4[1]
	var_26_6[2] = var_26_4[2]
	var_26_8[1] = var_26_7[1] - var_26_6[1] / 2
	var_26_8[2] = var_26_7[2]

	local var_26_9 = var_26_2.text
	local var_26_10 = arg_26_0._ui_renderer
	local var_26_11 = UIUtils.get_text_width(var_26_10, var_26_9, var_26_1.text)
	local var_26_12 = UIUtils.get_text_height(var_26_10, var_26_3, var_26_9, var_26_1.text)

	arg_26_5 = arg_26_5 or 0

	return math.max(var_26_12, 50) + arg_26_5
end

StartGameWindowWeaveInfo._exit = function (arg_27_0, arg_27_1)
	arg_27_0.exit = true
	arg_27_0.exit_level_id = arg_27_1
end

StartGameWindowWeaveInfo.draw = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._ui_renderer
	local var_28_1 = arg_28_0._ui_top_renderer
	local var_28_2 = arg_28_0._ui_hdr_renderer
	local var_28_3 = arg_28_0._ui_scenegraph
	local var_28_4 = arg_28_0._render_settings
	local var_28_5 = arg_28_0._parent:window_input_service()

	UIRenderer.begin_pass(var_28_1, var_28_3, var_28_5, arg_28_1, nil, var_28_4)

	for iter_28_0, iter_28_1 in ipairs(arg_28_0._top_widgets) do
		UIRenderer.draw_widget(var_28_1, iter_28_1)
	end

	local var_28_6 = arg_28_0._objective_widgets

	if var_28_6 then
		for iter_28_2, iter_28_3 in ipairs(var_28_6) do
			UIRenderer.draw_widget(var_28_1, iter_28_3)
		end
	end

	UIRenderer.end_pass(var_28_1)
	UIRenderer.begin_pass(var_28_0, var_28_3, var_28_5, arg_28_1, nil, var_28_4)

	for iter_28_4, iter_28_5 in ipairs(arg_28_0._bottom_widgets) do
		UIRenderer.draw_widget(var_28_0, iter_28_5)
	end

	UIRenderer.end_pass(var_28_0)
	UIRenderer.begin_pass(var_28_2, var_28_3, var_28_5, arg_28_1, nil, var_28_4)

	for iter_28_6, iter_28_7 in ipairs(arg_28_0._bottom_hdr_widgets) do
		UIRenderer.draw_widget(var_28_2, iter_28_7)
	end

	UIRenderer.end_pass(var_28_2)
end

StartGameWindowWeaveInfo._play_sound = function (arg_29_0, arg_29_1)
	arg_29_0._parent:play_sound(arg_29_1)
end

StartGameWindowWeaveInfo._animate_pulse = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5))
end

StartGameWindowWeaveInfo._animate_element_by_time = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, math.ease_out_quad))
end

StartGameWindowWeaveInfo._animate_element_by_catmullrom = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7, arg_32_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7, arg_32_8))
end

StartGameWindowWeaveInfo._format_time = function (arg_33_0, arg_33_1)
	local var_33_0 = math.floor

	return (string.format("%.2d:%.2d:%.2d", var_33_0(arg_33_1 / 3600), var_33_0(arg_33_1 / 60) % 60, var_33_0(arg_33_1) % 60))
end

StartGameWindowWeaveInfo._get_save_data_by_weave_name = function (arg_34_0, arg_34_1)
	return nil
end
