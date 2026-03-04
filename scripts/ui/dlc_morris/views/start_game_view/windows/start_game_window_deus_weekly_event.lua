-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_weekly_event.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_weekly_event_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.create_weekly_event_information_box
local var_0_5 = var_0_0.selector_input_definitions
local var_0_6 = "refresh_press"
local var_0_7 = "confirm_press"

StartGameWindowDeusWeeklyEvent = class(StartGameWindowDeusWeeklyEvent)
StartGameWindowDeusWeeklyEvent.NAME = "StartGameWindowDeusWeeklyEvent"

function StartGameWindowDeusWeeklyEvent.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowDeusWeeklyEvent")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_index = arg_1_1.input_index or 1
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_handle_new_selection(arg_1_0._input_index)

	arg_1_0._current_difficulty = arg_1_0._parent:get_difficulty_option(true) or Managers.state.difficulty:get_difficulty()

	arg_1_0:_update_difficulty_option(arg_1_0._current_difficulty)
	arg_1_0:_fetch_event_data()

	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._show_additional_settings = false
	arg_1_0._previous_can_play = nil
	arg_1_0._num_requests = 0

	arg_1_0._parent:change_generic_actions("deus_default")
	arg_1_0:_start_transition_animation("on_enter")
end

local var_0_8 = {}

function StartGameWindowDeusWeeklyEvent._fetch_event_data(arg_2_0)
	local var_2_0 = Managers.backend:get_interface("live_events")
	local var_2_1, var_2_2 = var_2_0:get_weekly_chaos_wastes_game_mode_data()
	local var_2_3 = var_2_0:get_weekly_chaos_wastes_rewards_data() or var_0_8

	arg_2_0._refresh_time = os.time(os.date("!*t", var_2_2.end_timestamp / 1000))
	arg_2_0._weekly_journey_name = var_2_1 and var_2_1.journey_name

	local var_2_4 = var_0_4(var_2_1)
	local var_2_5 = UIWidget.init(var_2_4)

	arg_2_0._widgets[#arg_2_0._widgets + 1] = var_2_5
	arg_2_0._widgets_by_name.weekly_info_box = var_2_5

	local var_2_6 = 10
	local var_2_7 = 0

	arg_2_0._info_box_widgets = {}

	local var_2_8 = arg_2_0:_setup_curses(var_2_1, var_2_6, var_2_7)
	local var_2_9 = arg_2_0:_setup_boons(var_2_1, var_2_6, var_2_8)
	local var_2_10 = arg_2_0:_setup_rewards(var_2_3, var_2_6, var_2_9)
	local var_2_11 = math.abs(var_0_1.info_box.size[2] - math.abs(var_2_10))

	if var_2_11 > 0 then
		local var_2_12 = arg_2_0._ui_scenegraph
		local var_2_13 = "info_box_anchor"
		local var_2_14 = "scrollbar_window"
		local var_2_15 = true
		local var_2_16
		local var_2_17

		arg_2_0._scrollbar_ui = ScrollbarUI:new(var_2_12, var_2_13, var_2_14, var_2_11, var_2_15, var_2_16, var_2_17)
	end
end

function StartGameWindowDeusWeeklyEvent._setup_curses(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = "curse"
	local var_3_1 = var_0_0.create_header("cw_weekly_expedition_modifier_negative", arg_3_3, var_3_0)
	local var_3_2 = UIWidget.init(var_3_1)

	arg_3_0._info_box_widgets[#arg_3_0._info_box_widgets + 1] = var_3_2
	arg_3_0._widgets_by_name.curse_header = var_3_2
	arg_3_3 = arg_3_3 - 40 - arg_3_2

	local var_3_3 = arg_3_1.mutators or var_0_8
	local var_3_4 = RESOLUTION_LOOKUP.inv_scale

	for iter_3_0, iter_3_1 in ipairs(var_3_3) do
		local var_3_5 = MutatorTemplates[iter_3_1]
		local var_3_6 = var_3_5.display_name
		local var_3_7 = var_3_5.icon
		local var_3_8 = Localize(var_3_5.description)
		local var_3_9 = var_0_0.create_entry_widget(var_3_7, var_3_6, var_3_8, arg_3_3, arg_3_2)
		local var_3_10 = UIWidget.init(var_3_9)

		arg_3_0._info_box_widgets[#arg_3_0._info_box_widgets + 1] = var_3_10
		arg_3_0._widgets_by_name["curse_" .. iter_3_0] = var_3_10

		local var_3_11 = var_3_10.style.desc
		local var_3_12, var_3_13 = UIFontByResolution(var_3_11)
		local var_3_14 = var_3_12[1]
		local var_3_15 = var_3_13
		local var_3_16 = arg_3_0._ui_top_renderer.gui
		local var_3_17, var_3_18, var_3_19 = UIGetFontHeight(var_3_16, var_3_11.font_type, var_3_15)
		local var_3_20 = (var_3_19 - var_3_18) * var_3_4
		local var_3_21, var_3_22 = UIRenderer.word_wrap(arg_3_0._ui_top_renderer, var_3_8, var_3_14, var_3_15, var_3_11.area_size[1])

		arg_3_3 = arg_3_3 - var_3_20 * #var_3_21

		local var_3_23 = var_3_10.style.title
		local var_3_24, var_3_25 = UIFontByResolution(var_3_23)
		local var_3_26 = var_3_24[1]
		local var_3_27 = var_3_25
		local var_3_28, var_3_29, var_3_30 = UIGetFontHeight(var_3_16, var_3_23.font_type, var_3_27)
		local var_3_31 = (var_3_30 - var_3_29) * var_3_4
		local var_3_32, var_3_33 = UIRenderer.word_wrap(arg_3_0._ui_top_renderer, Localize(var_3_6), var_3_26, var_3_27, var_3_23.area_size[1])

		arg_3_3 = arg_3_3 - var_3_31 * #var_3_32 - arg_3_2
	end

	return arg_3_3 - arg_3_2
end

function StartGameWindowDeusWeeklyEvent._setup_boons(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = "boon"
	local var_4_1 = var_0_0.create_header("cw_weekly_expedition_modifier_positive", arg_4_3, var_4_0)
	local var_4_2 = UIWidget.init(var_4_1)

	arg_4_0._info_box_widgets[#arg_4_0._info_box_widgets + 1] = var_4_2
	arg_4_0._widgets_by_name.boon_header = var_4_2
	arg_4_3 = arg_4_3 - 40 - arg_4_2

	local var_4_3 = Managers.player:local_player()
	local var_4_4 = var_4_3:profile_index()
	local var_4_5 = var_4_3:career_index()
	local var_4_6 = arg_4_1.boons or var_0_8
	local var_4_7 = RESOLUTION_LOOKUP.inv_scale

	for iter_4_0, iter_4_1 in ipairs(var_4_6) do
		local var_4_8 = DeusPowerUpsLookup[iter_4_1]
		local var_4_9 = var_4_8.display_name
		local var_4_10 = DeusPowerUpUtils.get_power_up_icon(var_4_8, var_4_4, var_4_5)
		local var_4_11 = DeusPowerUpUtils.get_power_up_description(var_4_8, var_4_4, var_4_5)
		local var_4_12 = var_0_0.create_entry_widget(var_4_10, var_4_9, var_4_11, arg_4_3)
		local var_4_13 = UIWidget.init(var_4_12)

		arg_4_0._info_box_widgets[#arg_4_0._info_box_widgets + 1] = var_4_13
		arg_4_0._widgets_by_name["boon_" .. iter_4_0] = var_4_13

		local var_4_14 = var_4_13.style.desc
		local var_4_15, var_4_16 = UIFontByResolution(var_4_14)
		local var_4_17 = var_4_15[1]
		local var_4_18 = var_4_16
		local var_4_19 = arg_4_0._ui_top_renderer.gui
		local var_4_20, var_4_21, var_4_22 = UIGetFontHeight(var_4_19, var_4_14.font_type, var_4_18)
		local var_4_23 = (var_4_22 - var_4_21) * var_4_7
		local var_4_24, var_4_25 = UIRenderer.word_wrap(arg_4_0._ui_top_renderer, var_4_11, var_4_17, var_4_18, var_4_14.area_size[1])

		arg_4_3 = arg_4_3 - var_4_23 * #var_4_24

		local var_4_26 = var_4_13.style.title
		local var_4_27, var_4_28 = UIFontByResolution(var_4_26)
		local var_4_29 = var_4_27[1]
		local var_4_30 = var_4_28
		local var_4_31, var_4_32, var_4_33 = UIGetFontHeight(var_4_19, var_4_26.font_type, var_4_30)
		local var_4_34 = (var_4_33 - var_4_32) * var_4_7
		local var_4_35, var_4_36 = UIRenderer.word_wrap(arg_4_0._ui_top_renderer, Localize(var_4_9), var_4_29, var_4_30, var_4_26.area_size[1])

		arg_4_3 = arg_4_3 - var_4_34 * #var_4_35 - arg_4_2
	end

	return arg_4_3 - arg_4_2
end

function StartGameWindowDeusWeeklyEvent._setup_rewards(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0
	local var_5_1 = var_0_0.create_header("cw_weekly_expedition_rewards_name", arg_5_3, var_5_0)
	local var_5_2 = UIWidget.init(var_5_1)

	var_5_2.style.header.text_color = Colors.get_color_table_with_alpha("white", 255)
	arg_5_0._info_box_widgets[#arg_5_0._info_box_widgets + 1] = var_5_2
	arg_5_0._widgets_by_name.rewards_header = var_5_2
	arg_5_3 = arg_5_3 - 40 - arg_5_2

	local var_5_3 = arg_5_1
	local var_5_4 = RESOLUTION_LOOKUP.inv_scale

	for iter_5_0, iter_5_1 in ipairs(DefaultDifficulties) do
		local var_5_5 = var_5_3 and var_5_3[iter_5_1]

		if var_5_5 then
			local var_5_6 = arg_5_0:_evaluate_rewards(var_5_5, iter_5_1)
			local var_5_7 = var_0_0.create_reward_widget(var_5_6, arg_5_3)
			local var_5_8 = UIWidget.init(var_5_7)

			arg_5_0._info_box_widgets[#arg_5_0._info_box_widgets + 1] = var_5_8
			arg_5_0._widgets_by_name["reward_" .. iter_5_0] = var_5_8

			local var_5_9 = var_5_8.style.desc
			local var_5_10, var_5_11 = UIFontByResolution(var_5_9)
			local var_5_12 = var_5_10[1]
			local var_5_13 = var_5_11
			local var_5_14 = arg_5_0._ui_top_renderer.gui
			local var_5_15, var_5_16, var_5_17 = UIGetFontHeight(var_5_14, var_5_9.font_type, var_5_13)
			local var_5_18 = (var_5_17 - var_5_16) * var_5_4
			local var_5_19, var_5_20 = UIRenderer.word_wrap(arg_5_0._ui_top_renderer, Localize(var_5_6.desc or " "), var_5_12, var_5_13, var_5_9.area_size[1])

			arg_5_3 = arg_5_3 - var_5_18 * #var_5_19 - arg_5_2 - 20
		end
	end

	return arg_5_3 - arg_5_2
end

function StartGameWindowDeusWeeklyEvent._evaluate_rewards(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1.rewards
	local var_6_1 = arg_6_1.claimed
	local var_6_2 = {
		difficulty_name = Localize(DifficultySettings[arg_6_2] and DifficultySettings[arg_6_2].display_name or "lb_unknown"),
		num_rewards = #var_6_0,
		collected = var_6_1
	}
	local var_6_3 = var_6_0[1]
	local var_6_4 = var_6_3 and var_6_3.reward_type

	if var_6_4 == "experience" then
		local var_6_5 = tonumber(var_6_3.amount) or 0

		var_6_2.icon = "experience"

		local var_6_6 = Localize("cw_weekly_expedition_xp_reward")

		var_6_2.desc = string.format(var_6_6, var_6_5)
	elseif var_6_4 == "item" or var_6_4 == "loot_chest" then
		local var_6_7 = var_6_3.item_name or var_6_3.weapon_skin_name
		local var_6_8 = var_6_7 and ItemMasterList[var_6_7]

		var_6_2.desc = Localize(var_6_8 and var_6_8.display_name or "lb_unkown")
		var_6_2.icon = var_6_8 and var_6_8.inventory_icon or "icons_placeholder"
	elseif var_6_4 == "weapon_skin" then
		local var_6_9 = var_6_3.item_name or var_6_3.weapon_skin_name
		local var_6_10 = Managers.backend:get_interface("crafting"):get_unlocked_weapon_skins()

		var_6_2.collected = var_6_1 or var_6_10[var_6_9] ~= nil

		local var_6_11 = WeaponSkins.skins[var_6_9] or ItemMasterList[var_6_9]

		var_6_2.desc = Localize(var_6_11 and var_6_11.display_name or "lb_unkown")
		var_6_2.icon = var_6_11 and var_6_11.inventory_icon or "icons_placeholder"
	else
		var_6_2.icon = "icons_placeholder"
		var_6_2.desc = Localize("lb_unkown")
	end

	return var_6_2
end

function StartGameWindowDeusWeeklyEvent._setup_debug_texts(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = "info_box_anchor"
	local var_7_1 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		use_shadow = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			2
		}
	}
	local var_7_2, var_7_3 = UIFontByResolution(var_7_1)
	local var_7_4 = var_7_2[1]
	local var_7_5 = var_7_3
	local var_7_6 = arg_7_0._ui_top_renderer.gui
	local var_7_7, var_7_8, var_7_9 = UIGetFontHeight(var_7_6, var_7_1.font_type, var_7_5)
	local var_7_10 = RESOLUTION_LOOKUP.inv_scale
	local var_7_11 = (var_7_9 - var_7_8) * var_7_10
	local var_7_12 = "This is just a temporary text This is just a temporary text This is just a temporary text"

	for iter_7_0 = 1, 50 do
		local var_7_13 = var_7_12 .. " " .. iter_7_0
		local var_7_14 = UIWidgets.create_simple_text(var_7_13, var_7_0, var_7_5, nil, var_7_1)
		local var_7_15 = UIWidget.init(var_7_14)

		var_7_15.offset[2] = arg_7_3
		arg_7_0._widgets[#arg_7_0._widgets + 1] = var_7_15
		arg_7_0._widgets_by_name["temp_text_" .. iter_7_0] = var_7_15

		local var_7_16, var_7_17 = UIRenderer.word_wrap(arg_7_0._ui_top_renderer, var_7_13, var_7_4, var_7_5, var_0_1.info_box.size[1])

		arg_7_3 = arg_7_3 - var_7_11 * #var_7_16 - arg_7_2
	end

	return arg_7_3
end

function StartGameWindowDeusWeeklyEvent._start_transition_animation(arg_8_0, arg_8_1)
	local var_8_0 = {
		render_settings = arg_8_0._render_settings
	}
	local var_8_1 = {}
	local var_8_2 = arg_8_0._ui_animator:start_animation(arg_8_1, var_8_1, var_0_1, var_8_0)

	arg_8_0._animations[arg_8_1] = var_8_2
end

function StartGameWindowDeusWeeklyEvent._create_ui_elements(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_9_0._widgets, arg_9_0._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)

	UIRenderer.clear_scenegraph_queue(arg_9_0._ui_renderer)

	arg_9_0._ui_animator = UIAnimator:new(arg_9_0._ui_scenegraph, var_0_3)

	if arg_9_2 then
		local var_9_0 = arg_9_0._ui_scenegraph.window.local_position

		var_9_0[1] = var_9_0[1] + arg_9_2[1]
		var_9_0[2] = var_9_0[2] + arg_9_2[2]
		var_9_0[3] = var_9_0[3] + arg_9_2[3]
	end

	arg_9_0._widgets_by_name.difficulty_info.content.visible = false
end

function StartGameWindowDeusWeeklyEvent.on_exit(arg_10_0, arg_10_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowDeusWeeklyEvent")

	arg_10_0._ui_animator = nil

	if arg_10_0._play_button_pressed then
		arg_10_1.input_index = nil
	else
		arg_10_1.input_index = arg_10_0._input_index
	end

	arg_10_0._parent:set_difficulty_option(arg_10_0._current_difficulty)
end

function StartGameWindowDeusWeeklyEvent.set_focus(arg_11_0, arg_11_1)
	arg_11_0._is_focused = arg_11_1
end

function StartGameWindowDeusWeeklyEvent.update(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0:_update_can_play()
	arg_12_0:_update_animations(arg_12_1)
	arg_12_0:_update_time_left()
	arg_12_0:_handle_gamepad_activity()
	arg_12_0:_handle_input(arg_12_1, arg_12_2)
	arg_12_0:_draw(arg_12_1, arg_12_2)
end

function StartGameWindowDeusWeeklyEvent.post_update(arg_13_0, arg_13_1, arg_13_2)
	return
end

function StartGameWindowDeusWeeklyEvent._handle_gamepad_activity(arg_14_0)
	local var_14_0 = arg_14_0.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not arg_14_0.gamepad_active_last_frame or var_14_0 then
			arg_14_0.gamepad_active_last_frame = true
			arg_14_0._input_index = 1

			local var_14_1 = var_0_5[arg_14_0._input_index]

			if var_14_1 and var_14_1.enter_requirements(arg_14_0) then
				var_14_1.on_enter(arg_14_0)
			end
		end
	elseif arg_14_0.gamepad_active_last_frame or var_14_0 then
		arg_14_0.gamepad_active_last_frame = false

		var_0_5[arg_14_0._input_index].on_exit(arg_14_0)
	end
end

function StartGameWindowDeusWeeklyEvent._update_can_play(arg_15_0)
	local var_15_0 = arg_15_0:_can_play()

	arg_15_0._widgets_by_name.play_button.content.button_hotspot.disable_button = not var_15_0

	local var_15_1 = "deus_default"

	if var_15_0 then
		var_15_1 = "deus_default_play"
	elseif arg_15_0._dlc_locked then
		var_15_1 = "deus_default_buy"
	end

	if var_15_1 ~= arg_15_0._prev_input_desc then
		arg_15_0._parent:set_input_description(var_15_1)

		arg_15_0._prev_input_desc = var_15_1
	end
end

function StartGameWindowDeusWeeklyEvent._handle_input(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._parent
	local var_16_1 = var_16_0:window_input_service()
	local var_16_2 = Managers.input:is_device_active("mouse")

	if not var_16_2 then
		local var_16_3 = arg_16_0._input_index
		local var_16_4

		if var_16_1:get("move_down") then
			var_16_3 = var_16_3 + 1
			var_16_4 = 1
		elseif var_16_1:get("move_up") then
			var_16_3 = var_16_3 - 1
			var_16_4 = -1
		else
			var_0_5[var_16_3].update(arg_16_0, var_16_1, arg_16_1, arg_16_2)
		end

		if var_16_3 ~= arg_16_0._input_index then
			arg_16_0:_gamepad_selector_input_func(var_16_3, var_16_4)
		end

		if var_16_1:get(var_0_7, true) and arg_16_0._dlc_locked then
			Managers.unlock:open_dlc_page(arg_16_0._dlc_name)
		end

		if arg_16_0:_can_play() and var_16_1:get(var_0_6) then
			arg_16_0._parent:set_difficulty_option(arg_16_0._current_difficulty)

			arg_16_0._play_button_pressed = true

			arg_16_0._parent:play(arg_16_2, "deus_weekly")
		end
	else
		local var_16_5 = arg_16_0._widgets_by_name

		for iter_16_0 = 1, #var_0_5 do
			local var_16_6 = var_0_5[iter_16_0].widget_name
			local var_16_7 = var_16_5[var_16_6]
			local var_16_8 = var_16_7.content.is_selected

			if var_16_6 == "difficulty_stepper" then
				if not var_16_8 and UIUtils.is_button_hover_enter(var_16_7, "left_arrow_hotspot") then
					arg_16_0:_handle_new_selection(iter_16_0)
					arg_16_0:_play_sound("Play_hud_hover")
				end

				if not var_16_8 and UIUtils.is_button_hover_enter(var_16_7, "right_arrow_hotspot") then
					arg_16_0:_handle_new_selection(iter_16_0)
					arg_16_0:_play_sound("Play_hud_hover")
				end

				if UIUtils.is_button_hover(var_16_7, "info_hotspot") or UIUtils.is_button_hover(arg_16_0._widgets_by_name.difficulty_info, "widget_hotspot") or not var_16_2 and var_16_8 then
					local var_16_9 = {
						difficulty_info = arg_16_0._widgets_by_name.difficulty_info,
						upsell_button = arg_16_0._widgets_by_name.upsell_button
					}

					if not arg_16_0._diff_info_anim_played then
						arg_16_0._diff_anim_id = arg_16_0._ui_animator:start_animation("difficulty_info_enter", var_16_9, var_0_1)
						arg_16_0._diff_info_anim_played = true
					end

					arg_16_0:_handle_difficulty_info(true)
				else
					if arg_16_0._diff_anim_id then
						arg_16_0._ui_animator:stop_animation(arg_16_0._diff_anim_id)
					end

					arg_16_0._diff_info_anim_played = false
					arg_16_0._widgets_by_name.upsell_button.content.visible = false
					arg_16_0._widgets_by_name.difficulty_info.content.visible = false

					arg_16_0:_handle_difficulty_info(false)
				end

				if UIUtils.is_button_pressed(var_16_7, "left_arrow_hotspot") or var_16_1:get("move_left") then
					arg_16_0:_option_selected(var_16_6, "left_arrow", arg_16_2)
				elseif UIUtils.is_button_pressed(var_16_7, "right_arrow_hotspot") or var_16_1:get("move_right") then
					arg_16_0:_option_selected(var_16_6, "right_arrow", arg_16_2)
				end
			elseif var_16_6 == "play_button" and arg_16_0:_can_play() then
				if not var_16_8 and UIUtils.is_button_hover_enter(var_16_5.play_button) then
					arg_16_0:_handle_new_selection(iter_16_0)
					arg_16_0:_play_sound("Play_hud_hover")
				end

				if UIUtils.is_button_pressed(var_16_5.play_button) then
					arg_16_0:_option_selected(var_16_6, "play_button", arg_16_2)
				end
			end
		end

		local var_16_10 = arg_16_0._widgets_by_name.upsell_button

		if UIUtils.is_button_pressed(var_16_10) then
			Managers.unlock:open_dlc_page(arg_16_0._dlc_name)
		end
	end

	local var_16_11 = true

	if DLCSettings.quick_play_preferences and var_16_1:get("right_stick_press", var_16_11) then
		var_16_0:set_layout_by_name("adventure_level_preferences")
	end
end

function StartGameWindowDeusWeeklyEvent._play_sound(arg_17_0, arg_17_1)
	return arg_17_0._parent:play_sound(arg_17_1)
end

function StartGameWindowDeusWeeklyEvent._can_play(arg_18_0)
	if not (arg_18_0._current_difficulty ~= nil and not arg_18_0._dlc_locked) then
		return false
	end

	return arg_18_0._weekly_journey_name and not LevelUnlockUtils.is_journey_disabled(arg_18_0._weekly_journey_name)
end

function StartGameWindowDeusWeeklyEvent._set_info_window(arg_19_0, arg_19_1)
	local var_19_0 = DifficultySettings[arg_19_1]
	local var_19_1 = var_19_0.description
	local var_19_2 = var_19_0.max_chest_power_level
	local var_19_3 = arg_19_0._widgets_by_name.difficulty_info

	var_19_3.content.difficulty_description = Localize(var_19_1)
	var_19_3.content.highest_obtainable_level = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(var_19_2)
end

function StartGameWindowDeusWeeklyEvent._update_difficulty_option(arg_20_0, arg_20_1)
	if arg_20_1 then
		local var_20_0 = DifficultySettings[arg_20_1]
		local var_20_1 = arg_20_0._widgets_by_name.difficulty_stepper

		var_20_1.content.selected_difficulty_text = Localize(var_20_0.display_name)

		local var_20_2 = var_20_0.display_image

		var_20_1.content.difficulty_icon = var_20_2

		arg_20_0:_set_info_window(arg_20_1)

		arg_20_0._current_difficulty = arg_20_1
	end
end

function StartGameWindowDeusWeeklyEvent._option_selected(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_1 == "difficulty_stepper" then
		local var_21_0 = arg_21_0._current_difficulty
		local var_21_1 = GameModeSettings.deus.difficulties
		local var_21_2 = table.find(var_21_1, var_21_0)
		local var_21_3 = 0

		if arg_21_2 == "left_arrow" then
			if var_21_2 - 1 >= 1 then
				var_21_3 = var_21_2 - 1

				arg_21_0._parent:play_sound("hud_morris_start_menu_set")
			end
		elseif arg_21_2 == "right_arrow" and var_21_2 + 1 <= #var_21_1 then
			var_21_3 = var_21_2 + 1

			arg_21_0._parent:play_sound("hud_morris_start_menu_set")
		end

		arg_21_0:_update_difficulty_option(var_21_1[var_21_3])
	elseif arg_21_1 == "play_button" then
		arg_21_0._parent:set_difficulty_option(arg_21_0._current_difficulty)

		arg_21_0._play_button_pressed = true

		arg_21_0._parent:play(arg_21_3, "deus_weekly")
	else
		ferror("Unknown selector_input_definition: %s", arg_21_1)
	end
end

function StartGameWindowDeusWeeklyEvent._verify_selection_index(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._input_index
	local var_22_1 = #var_0_5

	arg_22_1 = math.clamp(arg_22_1, 1, var_22_1)

	if not arg_22_2 then
		return arg_22_1
	end

	local var_22_2 = var_0_5[arg_22_1]

	while var_22_2 and arg_22_1 < var_22_1 and not var_22_2.enter_requirements() do
		arg_22_1 = arg_22_1 + arg_22_2
		var_22_2 = var_0_5[arg_22_1]
	end

	if var_22_2 and var_22_2.enter_requirements() then
		var_22_0 = arg_22_1
	end

	return var_22_0
end

function StartGameWindowDeusWeeklyEvent._gamepad_selector_input_func(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = Managers.input:is_device_active("mouse")

	arg_23_1 = arg_23_0:_verify_selection_index(arg_23_1, arg_23_2)

	if arg_23_0._input_index ~= arg_23_1 and not var_23_0 then
		arg_23_0._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if arg_23_0._input_index then
			var_0_5[arg_23_0._input_index].on_exit(arg_23_0)
		end

		var_0_5[arg_23_1].on_enter(arg_23_0)
	end

	arg_23_0._input_index = arg_23_1
end

function StartGameWindowDeusWeeklyEvent._handle_new_selection(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = #var_0_5

	arg_24_1 = math.clamp(arg_24_1, 1, var_24_0)

	local var_24_1 = arg_24_0._widgets_by_name

	for iter_24_0 = 1, #var_0_5 do
		local var_24_2 = var_24_1[var_0_5[iter_24_0].widget_name]
		local var_24_3 = iter_24_0 == arg_24_1

		var_24_2.content.is_selected = var_24_3
	end

	arg_24_0._input_index = arg_24_1
end

function StartGameWindowDeusWeeklyEvent._update_animations(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._ui_animator

	var_25_0:update(arg_25_1)

	if not Managers.input:is_device_active("gamepad") then
		arg_25_0:_update_button_animations(arg_25_1)
	end

	local var_25_1 = arg_25_0._animations

	for iter_25_0, iter_25_1 in pairs(var_25_1) do
		if var_25_0:is_animation_completed(iter_25_1) then
			var_25_0:stop_animation(iter_25_1)

			var_25_1[iter_25_0] = nil
		end
	end
end

function StartGameWindowDeusWeeklyEvent._refresh_data(arg_26_0)
	if arg_26_0._num_requests > 0 then
		return
	end

	local var_26_0 = Managers.backend:get_interface("live_events")
	local var_26_1 = callback(arg_26_0, "_refresh_data_cb")

	var_26_0:request_live_events(var_26_1)
	var_26_0:request_weekly_event_rewards(var_26_1)

	arg_26_0._num_requests = 2
end

function StartGameWindowDeusWeeklyEvent._refresh_data_cb(arg_27_0, arg_27_1)
	arg_27_0._num_requests = arg_27_0._num_requests - 1

	if arg_27_0._num_requests <= 0 then
		arg_27_0:_fetch_event_data()
	end
end

function StartGameWindowDeusWeeklyEvent._update_time_left(arg_28_0)
	local var_28_0 = os.time(os.date("!*t"))
	local var_28_1 = arg_28_0._refresh_time - var_28_0
	local var_28_2 = arg_28_0._widgets_by_name.timer.content

	if var_28_1 > 120 then
		local var_28_3 = var_28_1 / 86400
		local var_28_4 = var_28_1 / 3600 % 24
		local var_28_5 = var_28_1 / 60 % 60
		local var_28_6 = Localize("deus_start_game_mod_timer")

		var_28_2.text = string.format(var_28_6, var_28_3, var_28_4, var_28_5)
	else
		local var_28_7 = Localize("deus_start_game_mod_timer_seconds")

		if var_28_1 < 0 then
			var_28_1 = 0

			arg_28_0:_refresh_data()
		end

		var_28_2.text = string.format(var_28_7, var_28_1)
	end
end

function StartGameWindowDeusWeeklyEvent._update_button_animations(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_29_0.upsell_button, arg_29_1)
end

function StartGameWindowDeusWeeklyEvent._draw(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._ui_top_renderer
	local var_30_1 = arg_30_0._ui_scenegraph
	local var_30_2 = arg_30_0._parent:window_input_service()
	local var_30_3 = arg_30_0._render_settings
	local var_30_4

	UIRenderer.begin_pass(var_30_0, var_30_1, var_30_2, arg_30_1, var_30_4, var_30_3)
	UIRenderer.draw_all_widgets(var_30_0, arg_30_0._widgets)

	if not table.is_empty(arg_30_0._info_box_widgets) then
		UIRenderer.draw_all_widgets(var_30_0, arg_30_0._info_box_widgets)
	end

	UIRenderer.end_pass(var_30_0)

	if arg_30_0._scrollbar_ui then
		arg_30_0._scrollbar_ui:update(arg_30_1, arg_30_2, var_30_0, var_30_2, var_30_3)
	end
end

function StartGameWindowDeusWeeklyEvent._update_difficulty_lock(arg_31_0)
	local var_31_0 = arg_31_0._current_difficulty
	local var_31_1 = arg_31_0._widgets_by_name.difficulty_info
	local var_31_2 = arg_31_0._widgets_by_name.upsell_button

	if var_31_0 then
		local var_31_3, var_31_4, var_31_5, var_31_6 = arg_31_0._parent:is_difficulty_approved(var_31_0)

		if not var_31_3 then
			if var_31_4 then
				var_31_1.content.should_show_diff_lock_text = true
				var_31_1.content.difficulty_lock_text = var_31_4 and Localize(var_31_4) or ""
			else
				var_31_1.content.should_show_diff_lock_text = false
			end

			if var_31_5 then
				var_31_1.content.should_show_dlc_lock = true
				arg_31_0._dlc_locked = var_31_5
				arg_31_0._dlc_name = var_31_5
				var_31_2.content.visible = true
			else
				var_31_1.content.should_show_dlc_lock = false
				var_31_2.content.visible = false
				arg_31_0._dlc_locked = nil
				arg_31_0._dlc_name = nil
			end
		else
			var_31_1.content.should_show_dlc_lock = false
			var_31_1.content.should_show_diff_lock_text = false
			var_31_1.content.should_resize = false
			var_31_2.content.visible = false
			arg_31_0._dlc_locked = nil
			arg_31_0._dlc_name = nil
		end

		arg_31_0._difficulty_approved = var_31_3
	else
		var_31_1.content.should_show_dlc_lock = false
		var_31_2.content.visible = false
	end

	local var_31_7 = arg_31_0:_calculate_difficulty_info_widget_size(var_31_1)
	local var_31_8 = (math.floor(var_31_7) - var_0_1.difficulty_info.size[2]) / 2

	arg_31_0:_resize_difficulty_info({
		math.floor(var_0_1.difficulty_info.size[1]),
		math.floor(var_31_7)
	}, {
		0,
		-var_31_8,
		1
	})

	var_31_2.offset[2] = -math.floor(var_31_7) / 2 + 24
end

function StartGameWindowDeusWeeklyEvent._handle_difficulty_info(arg_32_0, arg_32_1)
	if arg_32_1 then
		arg_32_0:_update_difficulty_lock()
	end
end

function StartGameWindowDeusWeeklyEvent._calculate_difficulty_info_widget_size(arg_33_0, arg_33_1)
	local var_33_0 = 20
	local var_33_1 = arg_33_1.style.difficulty_description
	local var_33_2 = arg_33_1.content.difficulty_description
	local var_33_3 = UIUtils.get_text_height(arg_33_0._ui_renderer, var_33_1.size, var_33_1, var_33_2)

	arg_33_1.content.difficulty_description_text_size = var_33_3

	local var_33_4 = arg_33_1.style.highest_obtainable_level
	local var_33_5 = arg_33_1.content.highest_obtainable_level
	local var_33_6 = UIUtils.get_text_height(arg_33_0._ui_renderer, var_33_4.size, var_33_4, var_33_5) + var_33_0
	local var_33_7 = arg_33_1.style.difficulty_lock_text
	local var_33_8 = arg_33_1.content.difficulty_lock_text
	local var_33_9 = 0

	if arg_33_1.content.should_show_diff_lock_text then
		var_33_9 = UIUtils.get_text_height(arg_33_0._ui_renderer, var_33_7.size, var_33_7, var_33_8) + var_33_0
		arg_33_1.content.difficulty_lock_text_height = var_33_9
	end

	local var_33_10 = arg_33_1.style.dlc_lock_text
	local var_33_11 = arg_33_1.content.dlc_lock_text
	local var_33_12 = 0

	if arg_33_1.content.should_show_dlc_lock then
		var_33_12 = UIUtils.get_text_height(arg_33_0._ui_renderer, var_33_10.size, var_33_10, var_33_11) + var_33_0
	end

	return var_33_6 + var_33_3 + var_33_9 + var_33_12 + 50
end

function StartGameWindowDeusWeeklyEvent._resize_difficulty_info(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._widgets_by_name.difficulty_info

	var_34_0.content.should_resize = true
	var_34_0.content.resize_size = arg_34_1
	var_34_0.content.resize_offset = arg_34_2
	var_34_0.style.widget_hotspot.size = arg_34_1
	var_34_0.style.widget_hotspot.offset = arg_34_2
end

function StartGameWindowDeusWeeklyEvent._handle_difficulty_stepper_gamepad(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = {}

	if arg_35_2:get("move_left") and arg_35_1.content.is_selected then
		arg_35_0:_option_selected(arg_35_0._input_index, "left_arrow", arg_35_3)

		arg_35_1.content.left_arrow_pressed = true
		var_35_0.left_key = arg_35_1.style.left_arrow_gamepad_highlight

		if arg_35_0._arrow_anim_id then
			arg_35_0._ui_animator:stop_animation(arg_35_0._arrow_anim_id)

			arg_35_1.style.right_arrow_gamepad_highlight.color[1] = 0
		end

		arg_35_0._arrow_anim_id = arg_35_0._ui_animator:start_animation("left_arrow_flick", arg_35_1, var_0_1, var_35_0)
	elseif arg_35_2:get("move_right") and arg_35_1.content.is_selected then
		arg_35_0:_option_selected(arg_35_0._input_index, "right_arrow", arg_35_3)

		arg_35_1.content.right_arrow_pressed = true
		var_35_0.right_key = arg_35_1.style.right_arrow_gamepad_highlight

		if arg_35_0._arrow_anim_id then
			arg_35_0._ui_animator:stop_animation(arg_35_0._arrow_anim_id)

			arg_35_1.style.left_arrow_gamepad_highlight.color[1] = 0
		end

		arg_35_0._arrow_anim_id = arg_35_0._ui_animator:start_animation("right_arrow_flick", arg_35_1, var_0_1, var_35_0)
	end
end
