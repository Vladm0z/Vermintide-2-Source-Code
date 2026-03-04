-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_difficulty.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_difficulty_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.create_difficulty_button
local var_0_4 = var_0_0.create_dlc_difficulty_divider
local var_0_5 = var_0_0.animation_definitions
local var_0_6 = 1

StartGameWindowDifficulty = class(StartGameWindowDifficulty)
StartGameWindowDifficulty.NAME = "StartGameWindowDifficulty"

StartGameWindowDifficulty.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowDifficulty")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._has_exited = false

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_setup_difficulties()

	local var_1_2 = arg_1_0.parent:get_difficulty_option() or Managers.state.difficulty:get_difficulty()

	arg_1_0:_update_selected_difficulty_option(var_1_2)
	arg_1_0.parent:set_input_description("select_difficulty")
end

StartGameWindowDifficulty.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
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

	arg_2_0.ui_animator = UIAnimator:new(var_2_0, var_0_5)

	if arg_2_2 then
		local var_2_4 = var_2_0.window.local_position

		var_2_4[1] = var_2_4[1] + arg_2_2[1]
		var_2_4[2] = var_2_4[2] + arg_2_2[2]
		var_2_4[3] = var_2_4[3] + arg_2_2[3]
	end
end

StartGameWindowDifficulty._setup_difficulties = function (arg_3_0)
	local var_3_0 = {}
	local var_3_1 = {}
	local var_3_2 = arg_3_0:_get_difficulty_options()
	local var_3_3 = arg_3_0._widgets
	local var_3_4 = arg_3_0._widgets_by_name
	local var_3_5 = 1
	local var_3_6 = "difficulty_option_"
	local var_3_7 = 16
	local var_3_8 = "difficulty_option"
	local var_3_9 = var_0_2[var_3_8].size
	local var_3_10 = var_0_3(var_3_8, var_3_9)
	local var_3_11 = 0
	local var_3_12 = {}

	for iter_3_0 = var_0_6, #var_3_2 do
		local var_3_13 = var_3_2[iter_3_0]
		local var_3_14 = DifficultySettings[var_3_13]

		if var_3_14.dlc_requirement then
			var_3_12[#var_3_12 + 1] = var_3_13
		else
			local var_3_15 = var_3_14.display_name
			local var_3_16 = var_3_14.display_image
			local var_3_17 = UIWidget.init(var_3_10)

			var_3_4[var_3_6 .. var_3_5] = var_3_17
			var_3_3[#var_3_3 + 1] = var_3_17
			var_3_0[#var_3_0 + 1] = var_3_17

			local var_3_18 = var_3_17.offset
			local var_3_19 = var_3_17.content

			var_3_19.difficulty_key = var_3_13
			var_3_19.title_text = Localize(var_3_15)
			var_3_19.icon = var_3_16
			var_3_18[2] = var_3_11
			var_3_11 = var_3_11 - (var_3_9[2] + var_3_7)
			var_3_5 = var_3_5 + 1
		end
	end

	arg_3_0.ui_scenegraph.game_options_left_chain.size[2] = math.abs(var_3_11) - var_3_7
	arg_3_0.ui_scenegraph.game_options_right_chain.size[2] = math.abs(var_3_11) - var_3_7

	if #var_3_12 > 0 then
		local var_3_20 = "dlc_difficulty_divider"
		local var_3_21 = UIWidget.init(var_0_4("divider_01_top", var_3_20))

		var_3_4.dlc_difficulty_divider = var_3_21
		var_3_3[#var_3_3 + 1] = var_3_21
		var_3_21.style.texture_id.offset[2] = var_3_11 + var_3_9[2] * 0.5 + var_3_7 * 1.5

		local var_3_22 = var_3_11 - var_3_9[2] + var_3_7 * 2
		local var_3_23 = "difficulty_option"
		local var_3_24 = var_0_2[var_3_23].size

		for iter_3_1, iter_3_2 in ipairs(var_3_12) do
			local var_3_25 = DifficultySettings[iter_3_2]
			local var_3_26 = var_3_25.display_name
			local var_3_27 = var_3_25.display_image
			local var_3_28 = var_3_25.dlc_requirement
			local var_3_29 = not Managers.unlock:is_dlc_unlocked(var_3_28)
			local var_3_30 = var_3_25.button_textures
			local var_3_31 = var_0_3(var_3_23, var_3_24, var_3_30.lit_texture, var_3_30.unlit_texture, var_3_30.background, var_3_29)
			local var_3_32 = UIWidget.init(var_3_31)

			var_3_4[var_3_6 .. var_3_5] = var_3_32
			var_3_3[#var_3_3 + 1] = var_3_32
			var_3_0[#var_3_0 + 1] = var_3_32

			local var_3_33 = var_3_32.offset
			local var_3_34 = var_3_32.content

			var_3_34.difficulty_key = iter_3_2
			var_3_34.title_text = Localize(var_3_26)
			var_3_34.icon = var_3_27
			var_3_33[2] = var_3_22
			var_3_22 = var_3_22 - (var_3_24[2] + var_3_7)
		end
	end

	arg_3_0._difficulty_widgets = var_3_0
end

StartGameWindowDifficulty._get_difficulty_options = function (arg_4_0)
	return Managers.state.difficulty:get_default_difficulties()
end

StartGameWindowDifficulty.on_exit = function (arg_5_0, arg_5_1)
	print("[StartGameWindow] Exit Substate StartGameWindowDifficulty")

	arg_5_0.ui_animator = nil

	arg_5_0.parent:set_input_description(nil)

	arg_5_0._has_exited = true
end

StartGameWindowDifficulty.update = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_update_difficulty_lock()
	arg_6_0:draw(arg_6_1)
end

StartGameWindowDifficulty.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

StartGameWindowDifficulty._update_animations = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.ui_animator

	var_8_0:update(arg_8_1)

	local var_8_1 = arg_8_0._animations

	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		if var_8_0:is_animation_completed(iter_8_1) then
			var_8_0:stop_animation(iter_8_1)

			var_8_1[iter_8_0] = nil
		end
	end

	local var_8_2 = arg_8_0._difficulty_widgets

	for iter_8_2 = 1, #var_8_2 do
		local var_8_3 = var_8_2[iter_8_2]

		arg_8_0:_animate_difficulty_option_button(var_8_3, arg_8_1)
	end
end

StartGameWindowDifficulty._is_button_pressed = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.on_pressed then
		var_9_0.on_pressed = false

		return true
	end
end

StartGameWindowDifficulty._is_button_released = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.on_release then
		var_10_0.on_release = false

		return true
	end
end

StartGameWindowDifficulty._is_button_hover_enter = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	return var_11_0.on_hover_enter and not var_11_0.is_selected
end

StartGameWindowDifficulty._handle_input = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._difficulty_widgets

	for iter_12_0 = 1, #var_12_0 do
		local var_12_1 = var_12_0[iter_12_0]

		if arg_12_0:_is_button_hover_enter(var_12_1) then
			arg_12_0:_play_sound("play_gui_lobby_button_01_difficulty_select_hover")
		end

		if arg_12_0:_is_button_pressed(var_12_1) then
			local var_12_2 = var_12_1.content.difficulty_key

			arg_12_0:_update_selected_difficulty_option(var_12_2)

			local var_12_3 = UISettings.difficulties_select_sounds
			local var_12_4 = var_12_3[iter_12_0] or var_12_3[#var_12_3]

			arg_12_0:_play_sound(var_12_4)
		end
	end

	local var_12_5 = arg_12_0._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(var_12_5, arg_12_1)

	local var_12_6 = arg_12_0._widgets_by_name.buy_button

	UIWidgetUtils.animate_default_button(var_12_6, arg_12_1)

	local var_12_7 = arg_12_0.parent

	if arg_12_0:_is_button_hover_enter(var_12_5) then
		arg_12_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if arg_12_0:_is_button_hover_enter(var_12_6) then
		arg_12_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if arg_12_0:_is_button_released(var_12_5) then
		if arg_12_0._selected_difficulty_key then
			var_12_7:set_difficulty_option(arg_12_0._selected_difficulty_key)
			arg_12_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_click")
		end

		local var_12_8 = var_12_7:get_selected_game_mode_layout_name()

		var_12_7:set_layout_by_name(var_12_8)
	elseif arg_12_0:_is_button_released(var_12_6) then
		local var_12_9 = var_12_6.content.dlc_name
		local var_12_10 = AreaSettings[var_12_9].store_page_url

		arg_12_0:_show_storepage(var_12_10)
	end
end

StartGameWindowDifficulty._set_selected_difficulty_option = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._difficulty_widgets

	for iter_13_0 = 1, #var_13_0 do
		local var_13_1 = var_13_0[iter_13_0].content
		local var_13_2 = var_13_1.difficulty_key == arg_13_1

		var_13_1.button_hotspot.is_selected = var_13_2
	end
end

StartGameWindowDifficulty._set_info_window = function (arg_14_0, arg_14_1)
	local var_14_0 = DifficultySettings[arg_14_1]
	local var_14_1 = var_14_0.description
	local var_14_2 = var_14_0.display_name
	local var_14_3 = var_14_0.display_image
	local var_14_4 = var_14_0.xp_multiplier
	local var_14_5 = var_14_0.max_chest_power_level
	local var_14_6 = arg_14_0._widgets_by_name

	var_14_6.difficulty_title.content.text = Localize(var_14_2)
	var_14_6.difficulty_texture.content.texture_id = var_14_3
	var_14_6.description_text.content.text = Localize(var_14_1)
	var_14_6.difficulty_chest_info.content.text = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(var_14_5)
end

StartGameWindowDifficulty._update_difficulty_lock = function (arg_15_0)
	local var_15_0 = arg_15_0._widgets_by_name
	local var_15_1 = var_15_0.select_button
	local var_15_2 = var_15_0.buy_button
	local var_15_3 = var_15_0.extreme_difficulty_bg
	local var_15_4 = var_15_0.extremely_hard_text
	local var_15_5 = var_15_0.dlc_lock_text
	local var_15_6 = arg_15_0._selected_difficulty_key

	if var_15_6 then
		local var_15_7 = DifficultySettings[var_15_6]
		local var_15_8, var_15_9, var_15_10, var_15_11 = arg_15_0.parent:is_difficulty_approved(var_15_6)

		if not var_15_8 then
			if var_15_10 then
				var_15_2.content.button_hotspot.disable_button = false
				var_15_2.content.visible = true
				var_15_2.content.dlc_name = var_15_10
				var_15_1.content.visible = false
				var_15_5.content.visible = true
			else
				var_15_2.content.button_hotspot.disable_button = true
				var_15_2.content.visible = false
				var_15_2.content.dlc_name = nil
				var_15_1.content.visible = true
				var_15_5.content.visible = false
			end

			var_15_1.content.button_hotspot.disable_button = true

			if var_15_11 or var_15_9 then
				var_15_0.difficulty_is_locked_text.content.text = Localize("required_power_level_not_met_in_party")

				if var_15_11 then
					local var_15_12 = var_15_7.required_power_level
					local var_15_13 = Localize("required_power_level")

					var_15_0.difficulty_lock_text.content.text = string.format("%s: %s", var_15_13, tostring(UIUtils.presentable_hero_power_level(var_15_12)))
					var_15_0.difficulty_second_lock_text.content.text = var_15_9 and Localize(var_15_9) or ""
				else
					var_15_0.difficulty_lock_text.content.text = var_15_9 and Localize(var_15_9) or ""
				end
			end

			if not arg_15_0._has_exited then
				arg_15_0.parent:set_input_description(nil)
			end
		else
			var_15_1.content.button_hotspot.disable_button = false
			var_15_1.content.visible = true
			var_15_2.content.button_hotspot.disable_button = true
			var_15_2.content.visible = false
			var_15_2.content.dlc_name = nil
			var_15_5.content.visible = false
			var_15_0.difficulty_lock_text.content.text = ""
			var_15_0.difficulty_second_lock_text.content.text = ""
			var_15_0.difficulty_is_locked_text.content.text = ""

			if not arg_15_0._has_exited then
				arg_15_0.parent:set_input_description("select_difficulty")
			end
		end

		var_15_3.content.visible = var_15_7.show_warning or false
		var_15_4.content.visible = var_15_7.show_warning or false
	else
		var_15_1.content.button_hotspot.disable_button = true
		var_15_2.content.button_hotspot.disable_button = true
		var_15_2.content.visible = false
		var_15_2.content.dlc_name = nil
		var_15_3.content.visible = false
		var_15_4.content.visible = false
		var_15_5.content.visible = false

		if not arg_15_0._has_exited then
			arg_15_0.parent:set_input_description(nil)
		end
	end
end

StartGameWindowDifficulty._update_selected_difficulty_option = function (arg_16_0, arg_16_1)
	arg_16_1 = arg_16_1 or Managers.state.difficulty:get_difficulty()

	if arg_16_1 ~= arg_16_0._selected_difficulty_key then
		arg_16_0:_set_selected_difficulty_option(arg_16_1)

		arg_16_0._selected_difficulty_key = arg_16_1

		arg_16_0:_set_info_window(arg_16_1)
	end
end

StartGameWindowDifficulty.draw = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.ui_renderer
	local var_17_1 = arg_17_0.ui_scenegraph
	local var_17_2 = arg_17_0.parent:window_input_service()

	UIRenderer.begin_pass(var_17_0, var_17_1, var_17_2, arg_17_1, nil, arg_17_0.render_settings)

	local var_17_3 = arg_17_0._widgets

	for iter_17_0 = 1, #var_17_3 do
		local var_17_4 = var_17_3[iter_17_0]

		UIRenderer.draw_widget(var_17_0, var_17_4)
	end

	UIRenderer.end_pass(var_17_0)
end

StartGameWindowDifficulty._play_sound = function (arg_18_0, arg_18_1)
	arg_18_0.parent:play_sound(arg_18_1)
end

StartGameWindowDifficulty._animate_difficulty_option_button = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_1.content
	local var_19_1 = arg_19_1.style
	local var_19_2 = var_19_0.button_hotspot
	local var_19_3 = var_19_0.has_focus
	local var_19_4 = var_19_2.is_hover or var_19_3
	local var_19_5 = var_19_2.is_selected
	local var_19_6 = not var_19_5 and var_19_2.is_clicked and var_19_2.is_clicked == 0
	local var_19_7 = var_19_2.input_progress or 0
	local var_19_8 = var_19_2.hover_progress or 0
	local var_19_9 = var_19_2.selection_progress or 0
	local var_19_10 = 8
	local var_19_11 = 20

	if var_19_6 then
		var_19_7 = math.min(var_19_7 + arg_19_2 * var_19_11, 1)
	else
		var_19_7 = math.max(var_19_7 - arg_19_2 * var_19_11, 0)
	end

	local var_19_12 = math.easeOutCubic(var_19_7)
	local var_19_13 = math.easeInCubic(var_19_7)

	if var_19_4 then
		var_19_8 = math.min(var_19_8 + arg_19_2 * var_19_10, 1)
	else
		var_19_8 = math.max(var_19_8 - arg_19_2 * var_19_10, 0)
	end

	local var_19_14 = math.easeOutCubic(var_19_8)
	local var_19_15 = math.easeInCubic(var_19_8)

	if var_19_5 then
		var_19_9 = math.min(var_19_9 + arg_19_2 * var_19_10, 1)
	else
		var_19_9 = math.max(var_19_9 - arg_19_2 * var_19_10, 0)
	end

	local var_19_16 = math.easeOutCubic(var_19_9)
	local var_19_17 = math.easeInCubic(var_19_9)
	local var_19_18 = math.max(var_19_8, var_19_9)
	local var_19_19 = math.max(var_19_16, var_19_14)
	local var_19_20 = math.max(var_19_15, var_19_17)
	local var_19_21 = 255 * var_19_7

	var_19_1.button_clicked_rect.color[1] = 100 * var_19_7
	var_19_1.hover_glow.color[1] = 255 * var_19_18

	local var_19_22 = 255 * var_19_9

	var_19_1.select_glow.color[1] = var_19_22
	var_19_1.skull_select_glow.color[1] = var_19_22
	var_19_1.icon_bg_glow.color[1] = var_19_22

	local var_19_23 = var_19_1.title_text_disabled
	local var_19_24 = var_19_23.default_text_color
	local var_19_25 = var_19_23.text_color

	var_19_25[2] = var_19_24[2] * 0.4
	var_19_25[3] = var_19_24[3] * 0.4
	var_19_25[4] = var_19_24[4] * 0.4

	local var_19_26 = var_19_1.title_text
	local var_19_27 = var_19_26.text_color
	local var_19_28 = var_19_26.default_text_color
	local var_19_29 = var_19_26.select_text_color

	Colors.lerp_color_tables(var_19_28, var_19_29, var_19_18, var_19_27)

	local var_19_30 = var_19_1.icon.color

	var_19_30[2] = var_19_27[2]
	var_19_30[3] = var_19_27[3]
	var_19_30[4] = var_19_27[4]

	local var_19_31 = var_19_1.background_icon
	local var_19_32 = var_19_31.color
	local var_19_33 = var_19_31.default_color

	var_19_32[2] = var_19_33[2] + var_19_18 * (255 - var_19_33[2])
	var_19_32[3] = var_19_33[3] + var_19_18 * (255 - var_19_33[3])
	var_19_32[4] = var_19_33[4] + var_19_18 * (255 - var_19_33[4])
	var_19_2.hover_progress = var_19_8
	var_19_2.input_progress = var_19_7
	var_19_2.selection_progress = var_19_9
end

StartGameWindowDifficulty._show_storepage = function (arg_20_0, arg_20_1)
	local var_20_0 = PLATFORM

	if IS_WINDOWS and rawget(_G, "Steam") then
		Steam.open_url(arg_20_1)
	end
end
