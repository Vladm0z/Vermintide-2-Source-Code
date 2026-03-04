-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_character_summary.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_character_summary_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.career_info_widgets
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.create_talent_widget
local var_0_6 = var_0_0.create_stat_widget
local var_0_7 = var_0_0.create_hero_widget
local var_0_8 = var_0_0.create_hero_icon_widget
local var_0_9 = var_0_0.list_spacing
local var_0_10 = false
local var_0_11 = 0.3

HeroWindowCharacterSummary = class(HeroWindowCharacterSummary)
HeroWindowCharacterSummary.NAME = "HeroWindowCharacterSummary"

HeroWindowCharacterSummary.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCharacterSummary")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._profile_synchronizer = var_1_0.profile_synchronizer
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements(arg_1_1)
	arg_1_0:_start_transition_animation("on_enter")
	arg_1_0:_setup_title_texts()
	arg_1_0:_toggle_statistics(false)
	arg_1_0:_setup_hero_selection_widgets()
	arg_1_0:_set_career_selection_state(false)
end

HeroWindowCharacterSummary._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_3, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

HeroWindowCharacterSummary._create_ui_elements = function (arg_3_0, arg_3_1)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	local var_3_3 = {}
	local var_3_4 = {}

	for iter_3_2, iter_3_3 in pairs(var_0_2) do
		local var_3_5 = UIWidget.init(iter_3_3)

		var_3_3[#var_3_3 + 1] = var_3_5
		var_3_4[iter_3_2] = var_3_5
	end

	arg_3_0._carrer_info_widgets = var_3_3
	arg_3_0._carrer_info_widgets_by_name = var_3_4

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_4)

	local var_3_6 = arg_3_0._widgets_by_name.list_scrollbar

	arg_3_0._scrollbar_logic = ScrollBarLogic:new(var_3_6)

	arg_3_0._scrollbar_logic:set_gamepad_scroll_enabled(true)

	var_3_1.hero_selection_warning.content.visible = false
end

HeroWindowCharacterSummary.on_exit = function (arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCharacterSummary")

	arg_4_0.ui_animator = nil

	arg_4_0:_commit_talent_changes()
end

HeroWindowCharacterSummary._input_service = function (arg_5_0)
	local var_5_0 = arg_5_0._parent

	if var_5_0:is_friends_list_active() then
		return var_5_0.fake_input_service
	end

	return var_5_0:window_input_service()
end

HeroWindowCharacterSummary.update = function (arg_6_0, arg_6_1, arg_6_2)
	if var_0_10 then
		var_0_10 = false

		arg_6_0:_create_ui_elements()
	end

	local var_6_0 = Managers.player:local_player().player_unit

	if Unit.alive(var_6_0) then
		arg_6_0:_update_hero_sync()
	end

	arg_6_0:_update_scroll_position()
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_draw(arg_6_1)

	local var_6_1 = arg_6_0:_input_service()

	arg_6_0:_handle_input(var_6_1, arg_6_1, arg_6_2)
end

HeroWindowCharacterSummary.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

HeroWindowCharacterSummary._handle_input = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._widgets_by_name
	local var_8_1 = arg_8_0._parent
	local var_8_2 = true
	local var_8_3 = Managers.input:is_device_active("gamepad")

	arg_8_0._scrollbar_logic:update(arg_8_2, arg_8_3)

	local var_8_4 = Managers.input:any_input_pressed()
	local var_8_5 = false
	local var_8_6 = arg_8_0._talent_slot_widgets

	if var_8_6 then
		for iter_8_0, iter_8_1 in ipairs(var_8_6) do
			if arg_8_0:_is_button_pressed(iter_8_1) then
				arg_8_0:_on_talent_slot_pressed(iter_8_0)

				var_8_5 = true
			end
		end
	end

	local var_8_7 = arg_8_0._selected_talent_index

	if var_8_7 then
		local var_8_8 = arg_8_0._talent_widgets[var_8_7]

		for iter_8_2, iter_8_3 in ipairs(var_8_8) do
			if arg_8_0:_is_button_pressed(iter_8_3) then
				arg_8_0:_on_talent_pressed(var_8_7, iter_8_2)

				var_8_5 = true
			end
		end
	else
		local var_8_9 = var_8_0.window_button
		local var_8_10 = var_8_0.hero_selection_button

		if arg_8_0:_is_button_pressed(var_8_10) or arg_8_1:get("special_1_press", var_8_2) or arg_8_0._draw_hero_selection and arg_8_1:get("back_menu", var_8_2) then
			var_8_5 = true

			arg_8_0:_set_career_selection_state(not arg_8_0._draw_hero_selection)
		end

		if arg_8_0._draw_hero_selection then
			if arg_8_0:_handle_gamepad_selection(arg_8_1) then
				var_8_5 = true
			end

			if arg_8_1:get("confirm_press", var_8_2) then
				var_8_5 = true

				arg_8_0:_set_career_selection_state(false, true)
			end

			if not var_8_3 and not var_8_5 then
				local var_8_11 = arg_8_0._hero_widgets

				for iter_8_4, iter_8_5 in ipairs(var_8_11) do
					if arg_8_0:_is_button_hovered(iter_8_5) then
						local var_8_12 = iter_8_5.content.career_settings

						arg_8_0:_change_carrer(var_8_12)
					end

					if arg_8_0:_is_button_pressed(iter_8_5) then
						var_8_5 = true

						arg_8_0:_set_career_selection_state(false, true)
						table.clear(iter_8_5.content.button_hotspot)
					end
				end

				if not arg_8_0:_is_button_hover(var_8_9) then
					local var_8_13 = arg_8_0._previous_career_settings

					arg_8_0:_change_carrer(var_8_13)
				end
			end
		elseif not var_8_5 then
			local var_8_14 = var_8_0.list_scrollbar.content.scroll_bar_info.is_hover

			if arg_8_0:_is_button_pressed(var_8_9) and not var_8_14 or arg_8_1:get("right_stick_press") then
				arg_8_0:_toggle_statistics(not arg_8_0._draw_statistics)
			end
		end
	end

	if not var_8_3 and not var_8_5 and Managers.input:any_input_pressed() then
		if arg_8_0._selected_talent_index then
			arg_8_0:_on_talent_slot_pressed(nil)
		elseif arg_8_0._draw_hero_selection then
			arg_8_0:_set_career_selection_state(false)
		end
	end
end

HeroWindowCharacterSummary._handle_gamepad_selection = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._num_max_hero_rows
	local var_9_1 = arg_9_0._num_max_hero_columns
	local var_9_2 = arg_9_0._selected_hero_row
	local var_9_3 = arg_9_0._selected_hero_column
	local var_9_4 = false

	if var_9_2 and var_9_3 then
		local var_9_5 = false

		if arg_9_1:get("move_left_hold_continuous") then
			if var_9_3 > 1 then
				var_9_3 = var_9_3 - 1
				var_9_5 = true
			end

			var_9_4 = true
		elseif arg_9_1:get("move_right_hold_continuous") then
			if var_9_3 < var_9_1 then
				var_9_3 = var_9_3 + 1
				var_9_5 = true
			end

			var_9_4 = true
		end

		if arg_9_1:get("move_up_hold_continuous") then
			if var_9_2 > 1 then
				var_9_2 = var_9_2 - 1
				var_9_5 = true
			end

			var_9_4 = true
		elseif arg_9_1:get("move_down_hold_continuous") then
			if var_9_2 < var_9_0 then
				var_9_2 = var_9_2 + 1
				var_9_5 = true
			end

			var_9_4 = true
		end

		if var_9_5 then
			arg_9_0:_set_selected_hero_by_coordinates(var_9_2, var_9_3)

			local var_9_6 = arg_9_0:_selected_hero_career()

			arg_9_0:_change_carrer(var_9_6)
		end
	end

	return var_9_4
end

HeroWindowCharacterSummary._set_career_selection_state = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._draw_hero_selection = arg_10_1

	local var_10_0 = arg_10_0._parent:current_career()

	if arg_10_1 then
		arg_10_0._previous_career_settings = CareerSettings[var_10_0]

		local var_10_1 = arg_10_0._hero_widgets

		for iter_10_0, iter_10_1 in ipairs(var_10_1) do
			if iter_10_1.content.career_settings.name == var_10_0 then
				arg_10_0:_set_selected_hero_index(iter_10_0)
			end
		end
	else
		if not arg_10_2 then
			local var_10_2 = arg_10_0._previous_career_settings

			if var_10_2 and var_10_2.name ~= var_10_0 then
				arg_10_0:_change_carrer(var_10_2)
			end
		end

		arg_10_0._previous_career_settings = nil
	end

	local var_10_3 = arg_10_0._widgets_by_name

	var_10_3.summary_title.content.visible = not arg_10_1
	var_10_3.hero_selection_title.content.visible = arg_10_1
	var_10_3.list_scrollbar.content.visible = not arg_10_1 and arg_10_0._draw_statistics or false
	arg_10_0._params.changing_hero = arg_10_1
end

HeroWindowCharacterSummary._change_carrer = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._parent
	local var_11_1 = var_11_0:current_career()
	local var_11_2 = arg_11_1.name

	if var_11_2 == var_11_1 then
		return
	end

	local var_11_3 = arg_11_1.profile_name
	local var_11_4 = FindProfileIndex(var_11_3)
	local var_11_5 = career_index_from_name(var_11_4, var_11_2)

	var_11_0:set_current_career(var_11_4, var_11_5)

	local var_11_6 = var_11_0.playing_career_index
	local var_11_7 = var_11_0.playing_profile_index
	local var_11_8 = var_11_6 == var_11_5 and var_11_7 == var_11_4

	arg_11_0._widgets_by_name.hero_selection_warning.content.visible = not var_11_8
end

HeroWindowCharacterSummary._set_selected_hero_by_coordinates = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._hero_widgets

	for iter_12_0, iter_12_1 in ipairs(var_12_0) do
		local var_12_1 = iter_12_1.content
		local var_12_2 = var_12_1.row == arg_12_1
		local var_12_3 = var_12_1.column == arg_12_2

		if var_12_2 and var_12_3 then
			arg_12_0:_set_selected_hero_index(iter_12_0)

			return
		end
	end
end

HeroWindowCharacterSummary._set_selected_hero_index = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._hero_widgets

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		local var_13_1 = iter_13_1.content
		local var_13_2 = var_13_1.button_hotspot
		local var_13_3 = iter_13_0 == arg_13_1

		var_13_2.is_selected = var_13_3

		if var_13_3 then
			arg_13_0._selected_hero_row = var_13_1.row
			arg_13_0._selected_hero_column = var_13_1.column
		end
	end

	arg_13_0._selected_hero_index = arg_13_1
end

HeroWindowCharacterSummary._selected_hero_career = function (arg_14_0)
	local var_14_0 = arg_14_0._selected_hero_index
	local var_14_1 = arg_14_0._hero_widgets

	for iter_14_0, iter_14_1 in ipairs(var_14_1) do
		local var_14_2 = iter_14_1.content
		local var_14_3 = var_14_2.button_hotspot

		if iter_14_0 == var_14_0 then
			return var_14_2.career_settings
		end
	end
end

HeroWindowCharacterSummary._on_talent_pressed = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._selected_talents

	if var_15_0[arg_15_1] == 0 then
		arg_15_0:_play_sound("play_gui_talent_unlock")
	else
		arg_15_0:_play_sound("play_gui_talents_selection_click")
	end

	arg_15_0._talent_changes_done = true
	var_15_0[arg_15_1] = arg_15_2

	local var_15_1 = arg_15_0._talent_widgets[arg_15_1][arg_15_2]

	table.clear(var_15_1.content.button_hotspot)
	arg_15_0:_set_talent_selected(arg_15_1, arg_15_2)
	arg_15_0:_on_talent_slot_pressed(arg_15_1)
end

HeroWindowCharacterSummary._set_talent_selected = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._talent_slot_widgets
	local var_16_1 = arg_16_0._talent_widgets[arg_16_1]

	for iter_16_0, iter_16_1 in ipairs(var_16_1) do
		local var_16_2 = iter_16_1.content
		local var_16_3 = iter_16_1.style
		local var_16_4 = iter_16_0 == arg_16_2

		var_16_2.selected = var_16_4
		var_16_3.icon.saturated = not var_16_4

		if var_16_4 then
			local var_16_5 = var_16_0[arg_16_1]
			local var_16_6 = var_16_5.content
			local var_16_7 = var_16_5.style

			var_16_6.icon = var_16_2.icon
			var_16_6.talent = var_16_2.talent
			var_16_6.talent_id = var_16_2.talent_id
		end
	end
end

HeroWindowCharacterSummary._on_talent_slot_pressed = function (arg_17_0, arg_17_1)
	local var_17_0
	local var_17_1 = arg_17_0._talent_slot_widgets

	for iter_17_0, iter_17_1 in ipairs(var_17_1) do
		local var_17_2 = iter_17_1.content
		local var_17_3 = var_17_2.button_hotspot
		local var_17_4 = not var_17_3.is_selected and arg_17_1 == iter_17_0

		var_17_2.active = var_17_4
		var_17_3.is_selected = var_17_4

		if var_17_4 then
			var_17_0 = arg_17_1
		end
	end

	arg_17_0._selected_talent_index = var_17_0
	arg_17_0._talents_position_timer = 0
	arg_17_0._widgets_by_name.list_scrollbar.content.scroll_bar_info.disable_button = var_17_0 ~= nil

	arg_17_0:_enable_talent_row(nil)
end

HeroWindowCharacterSummary._enable_talent_row = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._talent_widgets

	for iter_18_0, iter_18_1 in ipairs(var_18_0) do
		for iter_18_2, iter_18_3 in ipairs(iter_18_1) do
			iter_18_3.content.button_hotspot.disable_button = iter_18_0 ~= arg_18_1
		end
	end
end

HeroWindowCharacterSummary._toggle_statistics = function (arg_19_0, arg_19_1)
	arg_19_0._draw_statistics = arg_19_1

	local var_19_0 = arg_19_0._widgets_by_name

	var_19_0.list_scrollbar.content.visible = arg_19_1
	var_19_0.summary_title.content.selected_option = arg_19_1 and 2 or 1
end

HeroWindowCharacterSummary._update_hero_sync = function (arg_20_0)
	local var_20_0 = arg_20_0._parent
	local var_20_1 = var_20_0.loadout_sync_id
	local var_20_2 = var_20_0.hero_sync_id
	local var_20_3 = var_20_0.talent_sync_id
	local var_20_4 = arg_20_0._hero_sync_id ~= var_20_2
	local var_20_5 = var_20_4 or arg_20_0._talent_sync_id ~= var_20_3
	local var_20_6 = var_20_4 or arg_20_0._loadout_sync_id ~= var_20_1
	local var_20_7 = var_20_4 or var_20_5 or var_20_6
	local var_20_8 = var_20_7 and var_20_0:current_hero()
	local var_20_9 = var_20_7 and var_20_0:current_career()

	if var_20_4 then
		arg_20_0:_commit_talent_changes()
		arg_20_0:_populate_career_info(var_20_9)

		arg_20_0._hero_sync_id = var_20_2
	end

	if var_20_5 then
		arg_20_0:_populate_talents(var_20_8, var_20_9)

		arg_20_0._talent_sync_id = var_20_3
	end

	if var_20_6 then
		arg_20_0:_sync_statistics()

		arg_20_0._loadout_sync_id = var_20_1
	end
end

HeroWindowCharacterSummary._commit_talent_changes = function (arg_21_0)
	local var_21_0 = arg_21_0._talent_changes_done
	local var_21_1 = arg_21_0._selected_talents

	if var_21_0 and var_21_1 then
		local var_21_2 = arg_21_0._selected_talents_career_name

		Managers.backend:get_interface("talents"):set_talents(var_21_2, arg_21_0._selected_talents)

		arg_21_0._talent_changes_done = nil

		local var_21_3 = arg_21_0._parent

		var_21_3:update_talent_sync()

		arg_21_0._talent_sync_id = var_21_3.talent_sync_id
	end
end

HeroWindowCharacterSummary._update_animations = function (arg_22_0, arg_22_1)
	arg_22_0.ui_animator:update(arg_22_1)

	local var_22_0 = arg_22_0._animations
	local var_22_1 = arg_22_0.ui_animator

	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		if var_22_1:is_animation_completed(iter_22_1) then
			var_22_1:stop_animation(iter_22_1)

			var_22_0[iter_22_0] = nil
		end
	end

	arg_22_0:_animate_title_button(arg_22_1)
	arg_22_0:_update_talent_position_animation(arg_22_1)

	local var_22_2 = arg_22_0._talent_slot_widgets

	for iter_22_2, iter_22_3 in ipairs(var_22_2) do
		arg_22_0:_animate_talent_widget(iter_22_3, arg_22_1)
	end

	local var_22_3 = arg_22_0._talent_widgets

	for iter_22_4, iter_22_5 in ipairs(var_22_3) do
		for iter_22_6, iter_22_7 in ipairs(iter_22_5) do
			arg_22_0:_animate_talent_widget(iter_22_7, arg_22_1)
		end
	end

	local var_22_4
	local var_22_5 = arg_22_0._hero_widgets

	for iter_22_8, iter_22_9 in ipairs(var_22_5) do
		arg_22_0:_animate_hero_widget(iter_22_9, arg_22_1)

		if iter_22_8 == arg_22_0._selected_hero_index then
			var_22_4 = math.ceil(iter_22_8 / 3)
		end
	end

	local var_22_6 = arg_22_0._hero_icon_widgets

	for iter_22_10, iter_22_11 in ipairs(var_22_6) do
		local var_22_7 = var_22_4 == iter_22_10

		arg_22_0:_animate_hero_icon_widget(iter_22_11, var_22_7, arg_22_1)
	end
end

HeroWindowCharacterSummary._is_button_pressed = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1.content
	local var_23_1 = var_23_0.button_hotspot or var_23_0.hotspot

	if var_23_1.on_pressed then
		var_23_1.on_pressed = false

		return true
	end
end

HeroWindowCharacterSummary._is_button_hovered = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_1.content

	if (var_24_0.button_hotspot or var_24_0.hotspot).on_hover_enter then
		return true
	end
end

HeroWindowCharacterSummary._is_button_hover = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1.content

	return (var_25_0.button_hotspot or var_25_0.hotspot).is_hover
end

HeroWindowCharacterSummary._exit = function (arg_26_0)
	arg_26_0.exit = true
end

HeroWindowCharacterSummary._draw = function (arg_27_0, arg_27_1)
	arg_27_0:_update_visible_list_entries()

	local var_27_0 = arg_27_0._ui_renderer
	local var_27_1 = arg_27_0._ui_top_renderer
	local var_27_2 = arg_27_0._ui_scenegraph
	local var_27_3 = arg_27_0:_input_service()
	local var_27_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_27_1, var_27_2, var_27_3, arg_27_1, nil, arg_27_0._render_settings)

	for iter_27_0, iter_27_1 in ipairs(arg_27_0._widgets) do
		UIRenderer.draw_widget(var_27_1, iter_27_1)
	end

	local var_27_5 = arg_27_0._talent_slot_widgets

	if var_27_5 then
		local var_27_6

		for iter_27_2, iter_27_3 in ipairs(var_27_5) do
			UIRenderer.draw_widget(var_27_1, iter_27_3)

			if iter_27_3.content.active then
				local var_27_7 = iter_27_2
			end
		end

		local var_27_8 = arg_27_0._selected_talent_index

		if var_27_8 then
			local var_27_9 = arg_27_0._talent_widgets

			if var_27_9 then
				local var_27_10 = var_27_9[var_27_8]

				for iter_27_4, iter_27_5 in ipairs(var_27_10) do
					UIRenderer.draw_widget(var_27_1, iter_27_5)
				end
			end
		end
	end

	if arg_27_0._draw_hero_selection then
		local var_27_11 = arg_27_0._hero_widgets

		if var_27_11 then
			for iter_27_6, iter_27_7 in ipairs(var_27_11) do
				UIRenderer.draw_widget(var_27_1, iter_27_7)
			end
		end

		local var_27_12 = arg_27_0._hero_icon_widgets

		if var_27_12 then
			for iter_27_8, iter_27_9 in ipairs(var_27_12) do
				UIRenderer.draw_widget(var_27_1, iter_27_9)
			end
		end
	elseif arg_27_0._draw_statistics then
		local var_27_13 = arg_27_0._list_widgets

		if var_27_13 then
			for iter_27_10, iter_27_11 in ipairs(var_27_13) do
				UIRenderer.draw_widget(var_27_1, iter_27_11)
			end
		end
	else
		local var_27_14 = arg_27_0._carrer_info_widgets

		if var_27_14 then
			for iter_27_12, iter_27_13 in ipairs(var_27_14) do
				UIRenderer.draw_widget(var_27_1, iter_27_13)
			end
		end
	end

	UIRenderer.end_pass(var_27_1)
end

HeroWindowCharacterSummary._play_sound = function (arg_28_0, arg_28_1)
	arg_28_0._parent:play_sound(arg_28_1)
end

HeroWindowCharacterSummary._sync_statistics = function (arg_29_0)
	local var_29_0 = HeroStatisticsTemplate
	local var_29_1 = UIUtils.get_hero_statistics_by_template(var_29_0)

	arg_29_0:_populate_statistics(var_29_1)
end

HeroWindowCharacterSummary._populate_talents = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._ui_renderer
	local var_30_1 = "talent_root"
	local var_30_2 = var_0_5(var_30_1)
	local var_30_3 = Managers.backend:get_interface("talents")
	local var_30_4 = var_30_3:get_talents(arg_30_2)

	arg_30_0._selected_talents = table.clone(var_30_4)
	arg_30_0._talent_interface = var_30_3
	arg_30_0._selected_talents_career_name = arg_30_2

	local var_30_5 = ExperienceSettings.get_experience(arg_30_1)
	local var_30_6 = ExperienceSettings.get_level(var_30_5)
	local var_30_7 = {}
	local var_30_8 = {}
	local var_30_9 = CareerSettings[arg_30_2]
	local var_30_10 = TalentTrees[arg_30_1][var_30_9.talent_tree_index]
	local var_30_11 = arg_30_0._selected_talents
	local var_30_12 = 12
	local var_30_13 = 5

	for iter_30_0 = 1, NumTalentRows do
		local var_30_14 = "talent_point_" .. iter_30_0
		local var_30_15 = ProgressionUnlocks.is_unlocked(var_30_14, var_30_6)
		local var_30_16 = ProgressionUnlocks.get_unlock(var_30_14)
		local var_30_17 = tostring(var_30_16.level_requirement)
		local var_30_18 = UIWidget.init(var_30_2)

		var_30_7[iter_30_0] = var_30_18

		local var_30_19 = var_30_18.content.size
		local var_30_20 = var_30_18.offset

		var_30_20[1] = (iter_30_0 - 1) * (var_30_19[1] + var_30_12)
		var_30_20[3] = NumTalentColumns * var_30_13
		var_30_18.content.level_text = var_30_17
		var_30_18.content.locked = not var_30_15

		local var_30_21 = {}

		for iter_30_1 = 1, NumTalentColumns do
			local var_30_22 = UIWidget.init(var_30_2)

			var_30_21[#var_30_21 + 1] = var_30_22

			local var_30_23 = var_30_10[iter_30_0][iter_30_1]
			local var_30_24 = TalentIDLookup[var_30_23]
			local var_30_25 = TalentUtils.get_talent_by_id(arg_30_1, var_30_24)
			local var_30_26 = var_30_22.content

			var_30_26.icon = var_30_25 and var_30_25.icon or "icons_placeholder"
			var_30_26.talent = var_30_25
			var_30_26.talent_id = var_30_24

			local var_30_27 = var_30_22.offset

			var_30_27[1] = (iter_30_0 - 1) * (var_30_19[1] + var_30_12)
			var_30_27[2] = iter_30_1 * var_30_19[2]
			var_30_27[3] = (NumTalentColumns - iter_30_1) * var_30_13
		end

		var_30_8[iter_30_0] = var_30_21
	end

	arg_30_0._talent_slot_widgets = var_30_7
	arg_30_0._talent_widgets = var_30_8

	for iter_30_2 = 1, NumTalentRows do
		local var_30_28 = var_30_11[iter_30_2]
		local var_30_29

		var_30_29 = not var_30_28 or var_30_28 == 0

		for iter_30_3 = 1, NumTalentColumns do
			if var_30_28 == iter_30_3 then
				arg_30_0:_set_talent_selected(iter_30_2, iter_30_3)
			end
		end
	end
end

HeroWindowCharacterSummary._populate_statistics = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._ui_renderer
	local var_31_1 = {}
	local var_31_2 = "list_item"
	local var_31_3 = true
	local var_31_4 = var_0_6(var_31_2, var_31_3)
	local var_31_5 = #arg_31_1

	for iter_31_0 = 1, var_31_5 do
		local var_31_6 = arg_31_1[iter_31_0]
		local var_31_7 = UIWidget.init(var_31_4)

		var_31_1[iter_31_0] = var_31_7

		local var_31_8 = ""
		local var_31_9 = ""
		local var_31_10 = ""
		local var_31_11 = var_31_6.type
		local var_31_12 = 0

		if var_31_11 == "title" then
			var_31_8 = var_31_6.display_name

			local var_31_13 = 10
		elseif var_31_11 == "entry" then
			var_31_9 = var_31_6.display_name
			var_31_10 = var_31_6.value
		end

		local var_31_14 = var_31_7.content
		local var_31_15 = var_31_7.style

		var_31_14.name = UIRenderer.crop_text_width(var_31_0, var_31_9, 300, var_31_15.name)
		var_31_14.title = UIRenderer.crop_text_width(var_31_0, var_31_8, 300, var_31_15.title)
		var_31_14.value = var_31_10
	end

	arg_31_0._list_widgets = var_31_1
	arg_31_0._total_list_height = arg_31_0:_align_list_widgets(var_31_1, var_0_9)

	arg_31_0:_initialize_scrollbar()
end

HeroWindowCharacterSummary._align_list_widgets = function (arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = 0
	local var_32_1 = #arg_32_1

	for iter_32_0, iter_32_1 in ipairs(arg_32_1) do
		local var_32_2 = iter_32_1.offset
		local var_32_3 = iter_32_1.content.size

		iter_32_1.default_offset = table.clone(var_32_2)

		local var_32_4 = var_32_3[2]

		var_32_2[2] = -var_32_0
		var_32_0 = var_32_0 + var_32_4

		if iter_32_0 ~= var_32_1 then
			var_32_0 = var_32_0 + arg_32_2
		end
	end

	return var_32_0
end

HeroWindowCharacterSummary._initialize_scrollbar = function (arg_33_0)
	local var_33_0 = var_0_3.item_list.size
	local var_33_1 = var_0_3.list_scrollbar.size
	local var_33_2 = var_33_0[2]
	local var_33_3 = arg_33_0._total_list_height
	local var_33_4 = var_33_1[2]
	local var_33_5 = 200 + var_0_9 * 1.5
	local var_33_6 = 1
	local var_33_7 = arg_33_0._scrollbar_logic

	var_33_7:set_scrollbar_values(var_33_2, var_33_3, var_33_4, var_33_5, var_33_6)
	var_33_7:set_scroll_percentage(0)

	arg_33_0._list_thumb_scale = var_33_7:thumb_scale()
end

HeroWindowCharacterSummary._update_scroll_position = function (arg_34_0)
	local var_34_0 = arg_34_0._scrollbar_logic:get_scrolled_length()

	if var_34_0 ~= arg_34_0._scrolled_length then
		arg_34_0._ui_scenegraph.list_scroll_root.local_position[2] = math.round(var_34_0)
		arg_34_0._scrolled_length = var_34_0
	end
end

HeroWindowCharacterSummary._update_visible_list_entries = function (arg_35_0)
	local var_35_0 = arg_35_0._scrollbar_logic

	if not var_35_0:enabled() then
		return
	end

	local var_35_1 = var_35_0:get_scroll_percentage()
	local var_35_2 = var_35_0:get_scrolled_length()
	local var_35_3 = var_35_0:get_scroll_length()
	local var_35_4 = var_0_3.item_list.size
	local var_35_5 = var_0_9 * 2
	local var_35_6 = var_35_4[2] + var_35_5
	local var_35_7 = arg_35_0._list_widgets
	local var_35_8 = #var_35_7

	for iter_35_0, iter_35_1 in ipairs(var_35_7) do
		local var_35_9 = iter_35_1.offset
		local var_35_10 = iter_35_1.content
		local var_35_11 = var_35_10.size
		local var_35_12 = math.abs(var_35_9[2]) + var_35_11[2]
		local var_35_13 = false

		if var_35_12 < var_35_2 - var_35_5 then
			var_35_13 = true
		elseif var_35_6 < math.abs(var_35_9[2]) - var_35_2 then
			var_35_13 = true
		end

		var_35_10.visible = not var_35_13
	end
end

HeroWindowCharacterSummary._get_scrollbar_percentage_by_index = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._scrollbar_logic

	if var_36_0:enabled() then
		local var_36_1 = var_36_0:get_scroll_percentage()
		local var_36_2 = var_36_0:get_scrolled_length()
		local var_36_3 = var_36_0:get_scroll_length()
		local var_36_4 = var_0_3.item_list.size[2]
		local var_36_5 = var_36_2
		local var_36_6 = var_36_5 + var_36_4
		local var_36_7 = arg_36_0._list_widgets

		if var_36_7 then
			local var_36_8 = var_36_7[arg_36_1]
			local var_36_9 = var_36_8.content
			local var_36_10 = var_36_8.offset
			local var_36_11 = var_36_9.size[2]
			local var_36_12 = math.abs(var_36_10[2])
			local var_36_13 = var_36_12 + var_36_11
			local var_36_14 = 0

			if var_36_6 < var_36_13 then
				local var_36_15 = var_36_13 - var_36_6

				var_36_14 = math.clamp(var_36_15 / var_36_3, 0, 1)
			elseif var_36_12 < var_36_5 then
				local var_36_16 = var_36_5 - var_36_12

				var_36_14 = -math.clamp(var_36_16 / var_36_3, 0, 1)
			end

			if var_36_14 then
				return (math.clamp(var_36_1 + var_36_14, 0, 1))
			end
		end
	end

	return 0
end

HeroWindowCharacterSummary._setup_title_texts = function (arg_37_0)
	local var_37_0 = arg_37_0._widgets_by_name.summary_title
	local var_37_1 = var_37_0.content
	local var_37_2 = var_37_0.style
	local var_37_3 = var_37_1.size
	local var_37_4 = var_37_1.text_spacing
	local var_37_5 = arg_37_0._ui_renderer
	local var_37_6 = UIUtils.get_text_width(var_37_5, var_37_2.title_text1, var_37_1.title_text1)
	local var_37_7 = UIUtils.get_text_width(var_37_5, var_37_2.title_text2, var_37_1.title_text2)
	local var_37_8 = UIUtils.get_text_width(var_37_5, var_37_2.divider, var_37_1.divider)
	local var_37_9 = var_37_3[1]
	local var_37_10 = -var_37_9 / 2 + var_37_4

	var_37_2.title_text1.offset[1] = -var_37_9 + var_37_6 + var_37_4
	var_37_2.title_text1_shadow.offset[1] = var_37_2.title_text1.offset[1] + 2
	var_37_2.divider.offset[1] = var_37_6
	var_37_2.divider_shadow.offset[1] = var_37_2.divider.offset[1] + 2
	var_37_2.title_text2.offset[1] = var_37_6 + var_37_8
	var_37_2.title_text2_shadow.offset[1] = var_37_2.title_text2.offset[1] + 2
end

HeroWindowCharacterSummary._animate_title_button = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._widgets_by_name.summary_title
	local var_38_1 = var_38_0.content
	local var_38_2 = var_38_0.style
	local var_38_3 = var_38_1.selected_option

	for iter_38_0 = 1, 2 do
		local var_38_4 = "title_text" .. iter_38_0
		local var_38_5 = "title_text" .. iter_38_0 .. "_shadow"
		local var_38_6 = var_38_2[var_38_4]
		local var_38_7 = var_38_2[var_38_5]
		local var_38_8 = iter_38_0 == var_38_3
		local var_38_9 = var_38_6.selected_progress or 0
		local var_38_10 = 15

		if var_38_8 then
			var_38_9 = math.min(var_38_9 + var_38_10 * arg_38_1, 1)
		else
			var_38_9 = math.max(var_38_9 - var_38_10 * arg_38_1, 0)
		end

		var_38_6.selected_progress = var_38_9

		local var_38_11 = 255 * var_38_9
		local var_38_12 = var_38_6.default_font_size + 6 * var_38_9

		var_38_6.font_size = var_38_12
		var_38_7.font_size = var_38_12

		local var_38_13 = (1 - var_38_9) * 3

		var_38_6.offset[2] = var_38_6.default_offset[2] + var_38_13
		var_38_7.offset[2] = var_38_7.default_offset[2] + var_38_13

		local var_38_14 = var_38_6.text_color
		local var_38_15 = var_38_6.default_color
		local var_38_16 = var_38_6.selected_color

		Colors.lerp_color_tables(var_38_15, var_38_16, var_38_9, var_38_14)
	end
end

HeroWindowCharacterSummary._populate_career_info = function (arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0._ui_renderer
	local var_39_1 = arg_39_0._ui_scenegraph
	local var_39_2 = CareerSettings[arg_39_1]
	local var_39_3 = var_39_2.character_selection_image
	local var_39_4 = var_39_2.display_name
	local var_39_5 = arg_39_0._carrer_info_widgets_by_name

	if not Colors.color_definitions[arg_39_1] or not Colors.get_color_table_with_alpha(arg_39_1, 255) then
		local var_39_6 = {
			255,
			255,
			255,
			255
		}
	end

	local var_39_7 = CareerUtils.get_passive_ability_by_career(var_39_2)
	local var_39_8 = PROFILES_BY_CAREER_NAMES[arg_39_1].index
	local var_39_9 = career_index_from_name(var_39_8, arg_39_1)
	local var_39_10 = CareerUtils.get_ability_data_by_career(var_39_2, 1)
	local var_39_11 = var_39_7.display_name
	local var_39_12 = var_39_7.icon
	local var_39_13 = var_39_10.display_name
	local var_39_14 = var_39_10.icon

	var_39_5.passive_title_text.content.text = Localize(var_39_11)
	var_39_5.passive_description_text.content.text = UIUtils.get_ability_description(var_39_7)
	var_39_5.passive_icon.content.texture_id = var_39_12
	var_39_5.active_title_text.content.text = Localize(var_39_13)
	var_39_5.active_description_text.content.text = UIUtils.get_ability_description(var_39_10)
	var_39_5.active_icon.content.texture_id = var_39_14

	local var_39_15 = var_39_7.perks
	local var_39_16 = 0
	local var_39_17 = 0

	for iter_39_0 = 1, 3 do
		local var_39_18 = var_39_5["career_perk_" .. iter_39_0]
		local var_39_19 = var_39_18.content
		local var_39_20 = var_39_18.style
		local var_39_21 = var_39_1[var_39_18.scenegraph_id].size

		var_39_18.offset[2] = -var_39_16

		local var_39_22 = var_39_15[iter_39_0]

		if var_39_22 then
			local var_39_23 = Localize(var_39_22.display_name)
			local var_39_24 = UIUtils.get_perk_description(var_39_22)
			local var_39_25 = var_39_20.title_text
			local var_39_26 = var_39_20.description_text
			local var_39_27 = var_39_20.description_text_shadow

			var_39_19.title_text = var_39_23
			var_39_19.description_text = var_39_24

			local var_39_28 = UIUtils.get_text_height(var_39_0, var_39_21, var_39_25, var_39_23)
			local var_39_29 = UIUtils.get_text_height(var_39_0, var_39_21, var_39_26, var_39_24)

			var_39_26.offset[2] = -var_39_29
			var_39_27.offset[2] = -(var_39_29 + 2)
			var_39_16 = var_39_16 + var_39_28 + var_39_29 + var_39_17
		end

		var_39_19.visible = var_39_22 ~= nil
	end
end

HeroWindowCharacterSummary._animate_talent_widget = function (arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_1.content
	local var_40_1 = arg_40_1.style
	local var_40_2 = var_40_0.button_hotspot or var_40_0.hotspot
	local var_40_3 = var_40_2.is_hover
	local var_40_4 = var_40_2.is_selected
	local var_40_5 = var_40_2.hover_progress or 0
	local var_40_6 = var_40_2.selection_progress or 0
	local var_40_7 = 8

	if var_40_3 then
		var_40_5 = math.min(var_40_5 + arg_40_2 * var_40_7, 1)
	else
		var_40_5 = math.max(var_40_5 - arg_40_2 * var_40_7, 0)
	end

	local var_40_8 = math.easeOutCubic(var_40_5)
	local var_40_9 = math.easeInCubic(var_40_5)

	if var_40_4 then
		var_40_6 = math.min(var_40_6 + arg_40_2 * var_40_7, 1)
	else
		var_40_6 = math.max(var_40_6 - arg_40_2 * var_40_7, 0)
	end

	local var_40_10 = math.easeOutCubic(var_40_6)
	local var_40_11 = math.easeInCubic(var_40_6)
	local var_40_12 = math.max(var_40_5, var_40_6)
	local var_40_13 = math.max(var_40_10, var_40_8)
	local var_40_14 = math.max(var_40_9, var_40_11)
	local var_40_15 = 255 * var_40_5

	var_40_1.hover_frame.color[1] = var_40_15

	local var_40_16 = var_40_1.icon.color
	local var_40_17 = 200 + 55 * var_40_12

	var_40_16[2] = var_40_17
	var_40_16[3] = var_40_17
	var_40_16[4] = var_40_17
	var_40_2.hover_progress = var_40_5
	var_40_2.selection_progress = var_40_6
end

HeroWindowCharacterSummary._update_talent_position_animation = function (arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0._selected_talent_index

	if not var_41_0 then
		return
	end

	local var_41_1 = arg_41_0._talents_position_timer

	if not var_41_1 then
		return
	end

	local var_41_2, var_41_3 = arg_41_0:_get_timer_progress(var_41_1, var_0_11, arg_41_1)
	local var_41_4 = var_41_2 == 1
	local var_41_5 = math.easeOutCubic

	if var_41_4 then
		arg_41_0._talents_position_timer = nil

		arg_41_0:_enable_talent_row(var_41_0)
	else
		arg_41_0._talents_position_timer = var_41_3
	end

	local var_41_6 = arg_41_0._talent_widgets[var_41_0]

	arg_41_0:_set_talent_list_animation_progress(var_41_6, var_41_5(var_41_2))
end

HeroWindowCharacterSummary._get_timer_progress = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = arg_42_1 + arg_42_3

	return math.min(var_42_0 / arg_42_2, 1), var_42_0
end

HeroWindowCharacterSummary._set_talent_list_animation_progress = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = 255 * arg_43_2

	for iter_43_0, iter_43_1 in ipairs(arg_43_1) do
		local var_43_1 = iter_43_1.content.size

		iter_43_1.offset[2] = var_43_1[2] * iter_43_0 * arg_43_2
	end
end

HeroWindowCharacterSummary._setup_hero_selection_widgets = function (arg_44_0)
	local var_44_0 = {}

	arg_44_0._hero_widgets = var_44_0

	local var_44_1 = {}

	arg_44_0._hero_icon_widgets = var_44_1

	local var_44_2 = Managers.backend:get_interface("hero_attributes")
	local var_44_3 = #SPProfilesAbbreviation
	local var_44_4 = 0
	local var_44_5 = var_0_7("hero_root")
	local var_44_6 = var_0_8("hero_icon_root")
	local var_44_7 = 144
	local var_44_8 = 116
	local var_44_9 = 136

	for iter_44_0, iter_44_1 in ipairs(ProfilePriority) do
		local var_44_10 = SPProfiles[iter_44_1]
		local var_44_11 = var_44_10.display_name
		local var_44_12 = var_44_2:get(var_44_11, "experience") or 0
		local var_44_13 = ExperienceSettings.get_level(var_44_12)
		local var_44_14 = var_44_10.careers

		var_44_4 = math.max(var_44_4, #var_44_14)

		local var_44_15 = UIWidget.init(var_44_6)

		var_44_1[#var_44_1 + 1] = var_44_15
		var_44_15.offset[2] = -((iter_44_0 - 1) * var_44_9)

		local var_44_16 = "hero_icon_large_" .. var_44_11

		var_44_15.content.icon = var_44_16
		var_44_15.content.icon_highlight = var_44_16 .. "_glow"

		for iter_44_2, iter_44_3 in ipairs(var_44_14) do
			local var_44_17 = UIWidget.init(var_44_5)

			var_44_0[#var_44_0 + 1] = var_44_17

			local var_44_18 = var_44_17.offset
			local var_44_19 = var_44_17.content

			var_44_19.career_settings = iter_44_3
			var_44_19.row = iter_44_0
			var_44_19.column = iter_44_2

			local var_44_20 = iter_44_3.portrait_image

			var_44_19.portrait = "medium_" .. var_44_20
			var_44_19.locked = not iter_44_3.is_unlocked_function(var_44_11, var_44_13)
			var_44_19.button_hotspot.disable_button = var_44_19.locked
			var_44_18[1] = (iter_44_2 - 1) * var_44_8
			var_44_18[2] = -((iter_44_0 - 1) * var_44_9)

			print("lol", #var_44_0, iter_44_0, iter_44_2)
		end
	end

	arg_44_0._num_max_hero_rows = var_44_3
	arg_44_0._num_max_hero_columns = var_44_4
end

HeroWindowCharacterSummary._animate_hero_widget = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_1.content
	local var_45_1 = arg_45_1.style
	local var_45_2 = var_45_0.button_hotspot or var_45_0.hotspot
	local var_45_3 = var_45_2.is_hover
	local var_45_4 = var_45_2.is_selected
	local var_45_5 = var_45_2.hover_progress or 0
	local var_45_6 = var_45_2.selection_progress or 0
	local var_45_7 = 8

	if var_45_3 then
		var_45_5 = math.min(var_45_5 + arg_45_2 * var_45_7, 1)
	else
		var_45_5 = math.max(var_45_5 - arg_45_2 * var_45_7, 0)
	end

	local var_45_8 = math.easeOutCubic(var_45_5)
	local var_45_9 = math.easeInCubic(var_45_5)

	if var_45_4 then
		var_45_6 = math.min(var_45_6 + arg_45_2 * var_45_7, 1)
	else
		var_45_6 = math.max(var_45_6 - arg_45_2 * var_45_7, 0)
	end

	local var_45_10 = math.easeOutCubic(var_45_6)
	local var_45_11 = math.easeInCubic(var_45_6)
	local var_45_12 = math.max(var_45_5, var_45_6)
	local var_45_13 = math.max(var_45_10, var_45_8)
	local var_45_14 = math.max(var_45_9, var_45_11)
	local var_45_15 = 255 * var_45_5

	var_45_1.hover_frame.color[1] = 255 * var_45_12

	local var_45_16 = var_45_1.portrait.color
	local var_45_17 = 170 + 85 * var_45_12

	var_45_16[2] = var_45_17
	var_45_16[3] = var_45_17
	var_45_16[4] = var_45_17
	var_45_2.hover_progress = var_45_5
	var_45_2.selection_progress = var_45_6
end

HeroWindowCharacterSummary._animate_hero_icon_widget = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = arg_46_1.content
	local var_46_1 = arg_46_1.style
	local var_46_2 = var_46_0.animation_progress or 0
	local var_46_3 = 8

	if arg_46_2 then
		var_46_2 = math.min(var_46_2 + arg_46_3 * var_46_3, 1)
	else
		var_46_2 = math.max(var_46_2 - arg_46_3 * var_46_3, 0)
	end

	local var_46_4 = math.easeOutCubic(var_46_2)
	local var_46_5 = math.easeInCubic(var_46_2)
	local var_46_6 = 255 * var_46_2

	var_46_1.icon_highlight.color[1] = var_46_6
	var_46_0.animation_progress = var_46_2
end
