-- chunkname: @scripts/ui/views/popup_profile_picker.lua

local var_0_0 = local_require("scripts/ui/views/popup_profile_picker_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.hero_widget_definition
local var_0_4 = var_0_0.hero_icon_widget_definition

PopupProfilePicker = class(PopupProfilePicker)

function PopupProfilePicker.init(arg_1_0, arg_1_1, ...)
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	local var_1_0 = arg_1_1.input_manager

	arg_1_0._input_manager = var_1_0

	var_1_0:create_input_service("popup_profile_picker", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_0:map_device_to_service("popup_profile_picker", "keyboard")
	var_1_0:map_device_to_service("popup_profile_picker", "mouse")
	var_1_0:map_device_to_service("popup_profile_picker", "gamepad")

	local var_1_1 = var_1_0:get_service("popup_profile_picker")

	arg_1_0._menu_input_desc = MenuInputDescriptionUI:new(nil, arg_1_0._ui_top_renderer, var_1_1, 5, 900, var_0_0.generic_input_actions.default)

	arg_1_0._menu_input_desc:set_input_description(nil)
	arg_1_0:_create_ui_elements()
	arg_1_0:show(...)
end

function PopupProfilePicker._create_ui_elements(arg_2_0)
	arg_2_0._widgets, arg_2_0._widgets_by_name = UIUtils.create_widgets(var_0_2)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_top_renderer)

	local var_2_0 = Managers.backend:get_interface("hero_attributes")
	local var_2_1 = {}

	arg_2_0._hero_widgets = var_2_1

	local var_2_2 = {}

	arg_2_0._hero_icon_widgets = var_2_2
	arg_2_0._num_max_hero_columns = #ProfilePriority
	arg_2_0._num_max_career_columns = 4

	for iter_2_0, iter_2_1 in ipairs(ProfilePriority) do
		local var_2_3 = SPProfiles[iter_2_1]
		local var_2_4 = var_2_3.display_name
		local var_2_5 = var_2_0:get(var_2_4, "experience") or 0
		local var_2_6 = ExperienceSettings.get_level(var_2_5)
		local var_2_7 = UIWidget.init(var_0_4)

		var_2_2[#var_2_2 + 1] = var_2_7
		var_2_7.offset[1] = (iter_2_0 - 1) * 124

		local var_2_8 = var_2_3.hero_selection_image

		var_2_7.content.icon = var_2_8
	end

	for iter_2_2 = 1, 4 do
		local var_2_9 = UIWidget.init(var_0_3)

		var_2_1[iter_2_2] = var_2_9
		var_2_9.offset[1] = (iter_2_2 - 1) * 124 + 62
	end
end

function PopupProfilePicker.update(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:_update_occupied_profiles(arg_3_2)

	local var_3_0 = arg_3_0._ui_top_renderer
	local var_3_1 = arg_3_0:input_service()

	if arg_3_0._cancel_timer then
		arg_3_0._cancel_timer = math.max(arg_3_0._cancel_timer - arg_3_1, 0)

		local var_3_2 = tostring(math.ceil(arg_3_0._cancel_timer))

		arg_3_0:_set_timer_text(var_3_2)

		if arg_3_0._cancel_timer <= 0 then
			local var_3_3 = false

			arg_3_0:set_result(var_3_3)
		end
	end

	arg_3_0:_handle_input(arg_3_1, arg_3_2)
	arg_3_0:draw(var_3_0, var_3_1, arg_3_1)
end

PopupProfilePicker._INPUT_DEVICES = {
	"keyboard",
	"gamepad",
	"mouse"
}

function PopupProfilePicker.show(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	arg_4_0._join_lobby_result = nil
	arg_4_0._makeshift_lobby_data = {}
	arg_4_0._lobby_client = arg_4_6
	arg_4_0._reserved_party_id = arg_4_7

	arg_4_0._ingame_ui:handle_transition(arg_4_4 and "exit_menu" or "close_active")
	ShowCursorStack.show("PopupProfilePicker")

	local var_4_0 = arg_4_1 or 1
	local var_4_1 = arg_4_2 or 1
	local var_4_2 = true

	arg_4_0:_select_hero(var_4_0, var_4_1, var_4_2)

	arg_4_0._cancel_timer = arg_4_3
	arg_4_0._optional_locked_profile_index = arg_4_8

	arg_4_0._input_manager:capture_input(arg_4_0._INPUT_DEVICES, 1, "popup_profile_picker", "PopupProfilePicker")
	arg_4_0:_play_sound("hud_hot_join_hero_popup")
end

function PopupProfilePicker.hide(arg_5_0)
	arg_5_0._input_manager:release_input(arg_5_0._INPUT_DEVICES, 1, "popup_profile_picker", "PopupProfilePicker")
	ShowCursorStack.hide("PopupProfilePicker")

	arg_5_0._selected_hero_name = nil
	arg_5_0._selected_career_name = nil
	arg_5_0._makeshift_lobby_data = nil

	arg_5_0:_play_sound("hud_hot_join_hero_popup_stop")
end

function PopupProfilePicker.input_service(arg_6_0)
	return arg_6_0._input_manager:get_service("popup_profile_picker")
end

function PopupProfilePicker.draw(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	UIRenderer.begin_pass(arg_7_1, arg_7_0._ui_scenegraph, arg_7_2, arg_7_3, nil, arg_7_0._render_settings)

	local var_7_0 = arg_7_0._widgets

	for iter_7_0, iter_7_1 in ipairs(var_7_0) do
		UIRenderer.draw_widget(arg_7_1, iter_7_1)
	end

	for iter_7_2, iter_7_3 in pairs(arg_7_0._hero_widgets) do
		UIRenderer.draw_widget(arg_7_1, iter_7_3)
	end

	for iter_7_4, iter_7_5 in ipairs(arg_7_0._hero_icon_widgets) do
		UIRenderer.draw_widget(arg_7_1, iter_7_5)
	end

	UIRenderer.end_pass(arg_7_1)

	if Managers.input:is_device_active("gamepad") then
		arg_7_0._menu_input_desc:draw(arg_7_1, arg_7_3)
	end
end

function PopupProfilePicker.set_result(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1 and arg_8_0._selected_hero_name
	local var_8_1 = arg_8_1 and arg_8_0._selected_career_name

	if arg_8_1 then
		arg_8_0:_play_sound("hud_hot_join_hero_popup_accept")
	else
		arg_8_0:_play_sound("hud_hot_join_hero_popup_decline")
	end

	arg_8_0._join_lobby_result = {
		accepted = arg_8_1,
		selected_hero_name = var_8_0,
		selected_career_name = var_8_1,
		reason = arg_8_2
	}
end

function PopupProfilePicker.query_result(arg_9_0)
	return arg_9_0._join_lobby_result
end

function PopupProfilePicker.destroy(arg_10_0)
	return
end

function PopupProfilePicker._handle_input(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._widgets_by_name
	local var_11_1 = Managers.input:get_service("popup_profile_picker")

	arg_11_0:_handle_mouse_selection()
	arg_11_0:_handle_gamepad_selection(var_11_1)

	local var_11_2 = var_11_0.select_button
	local var_11_3 = var_11_0.cancel_button

	UIWidgetUtils.animate_default_button(var_11_2, arg_11_1)
	UIWidgetUtils.animate_default_button(var_11_3, arg_11_1)

	if UIUtils.is_button_hover_enter(var_11_2) or UIUtils.is_button_hover_enter(var_11_3) then
		arg_11_0:_play_sound("play_gui_start_menu_button_hover")
	end

	if arg_11_0._selection_approved and (UIUtils.is_button_pressed(var_11_0.select_button) or var_11_1:get("confirm", true)) then
		arg_11_0:_play_sound("play_gui_start_menu_button_click")
		arg_11_0:set_result(true)
	elseif UIUtils.is_button_pressed(var_11_0.cancel_button) or var_11_1:get("back_menu", true) then
		arg_11_0:_play_sound("play_gui_start_menu_button_click")
		arg_11_0:set_result(false, "cancelled")
	end
end

function PopupProfilePicker._handle_mouse_selection(arg_12_0)
	local var_12_0 = arg_12_0._hero_icon_widgets

	for iter_12_0 = 1, #var_12_0 do
		local var_12_1 = var_12_0[iter_12_0].content

		if not var_12_1.taken then
			local var_12_2 = var_12_1.button_hotspot

			if var_12_2.on_hover_enter then
				arg_12_0:_play_sound("play_gui_hero_select_hero_hover")
			end

			if var_12_2.on_pressed and iter_12_0 ~= arg_12_0._selected_hero_column then
				local var_12_3 = ProfilePriority[iter_12_0]
				local var_12_4 = math.min(arg_12_0._selected_career_index, #SPProfiles[var_12_3].careers)

				arg_12_0:_select_hero(var_12_3, var_12_4)

				return
			end
		end
	end

	local var_12_5 = arg_12_0._hero_widgets

	for iter_12_1 = 1, #var_12_5 do
		local var_12_6 = var_12_5[iter_12_1].content

		if var_12_6.exists and not var_12_6.taken and not var_12_6.locked then
			local var_12_7 = var_12_6.button_hotspot

			if var_12_7.on_hover_enter then
				arg_12_0:_play_sound("play_gui_hero_select_career_hover")
			end

			if var_12_7.on_pressed and iter_12_1 ~= arg_12_0._selected_career_column then
				local var_12_8 = arg_12_0._selected_profile_index
				local var_12_9 = iter_12_1

				arg_12_0:_select_hero(var_12_8, var_12_9)

				return
			end
		end
	end
end

function PopupProfilePicker._handle_gamepad_selection(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._num_max_hero_columns
	local var_13_1 = arg_13_0._num_max_career_columns
	local var_13_2 = arg_13_0._selected_hero_column
	local var_13_3 = arg_13_0._selected_career_column

	if var_13_2 and var_13_3 then
		local var_13_4 = false

		if var_13_2 > 1 and arg_13_1:get("cycle_previous") then
			var_13_2 = var_13_2 - 1
			var_13_4 = true
		elseif var_13_2 < var_13_0 and arg_13_1:get("cycle_next") then
			var_13_2 = var_13_2 + 1
			var_13_4 = true
		end

		if var_13_3 > 1 and arg_13_1:get("move_left") then
			var_13_3 = var_13_3 - 1
			var_13_4 = true
		elseif var_13_3 < var_13_1 and arg_13_1:get("move_right") then
			var_13_3 = var_13_3 + 1
			var_13_4 = true
		end

		if var_13_4 then
			local var_13_5 = ProfilePriority[var_13_2]
			local var_13_6 = var_13_3

			arg_13_0:_select_hero(var_13_5, var_13_6)
		end
	end
end

function PopupProfilePicker._select_hero(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = SPProfiles[arg_14_1]
	local var_14_1 = var_14_0.careers[arg_14_2]
	local var_14_2 = Managers.backend:get_interface("dlcs")

	if not var_14_1 or var_14_2:is_unreleased_career(var_14_1.name) then
		return
	end

	local var_14_3 = var_14_0.display_name
	local var_14_4 = var_14_0.character_name
	local var_14_5 = var_14_1.name
	local var_14_6 = var_14_1.display_name
	local var_14_7 = Localize(var_14_4)
	local var_14_8 = Localize(var_14_6)
	local var_14_9 = Managers.backend:get_interface("hero_attributes"):get(var_14_3, "experience") or 0
	local var_14_10 = ExperienceSettings.get_level(var_14_9)

	arg_14_0:_set_hero_info(var_14_7, var_14_8, var_14_10)

	local var_14_11 = arg_14_0._hero_widgets
	local var_14_12 = arg_14_0._num_max_hero_rows
	local var_14_13 = arg_14_0._num_max_hero_columns

	arg_14_0._selected_career_index = arg_14_2
	arg_14_0._selected_profile_index = arg_14_1
	arg_14_0._selected_hero_name = var_14_3
	arg_14_0._selected_career_name = var_14_5
	arg_14_0._selected_hero_column = ProfileIndexToPriorityIndex[arg_14_1]
	arg_14_0._selected_career_column = arg_14_2

	arg_14_0:_set_hero_icon_selected(arg_14_0._selected_hero_column)

	local var_14_14 = Managers.backend:get_interface("dlcs")

	for iter_14_0, iter_14_1 in ipairs(arg_14_0._hero_widgets) do
		local var_14_15 = var_14_0.careers[iter_14_0]
		local var_14_16 = iter_14_1.content
		local var_14_17 = var_14_15 and not var_14_14:is_unreleased_career(var_14_15.name)

		var_14_16.exists = var_14_17

		if var_14_17 then
			var_14_16.career_settings = var_14_15
			var_14_16.portrait = var_14_15.picking_image or "medium_" .. var_14_15.portrait_image

			local var_14_18, var_14_19, var_14_20 = var_14_15:is_unlocked_function(var_14_3, var_14_10)

			var_14_16.locked = not var_14_18

			if var_14_20 then
				var_14_16.lock_texture = "hero_icon_locked_gold"
				var_14_16.frame = "menu_frame_12_gold"
			else
				var_14_16.lock_texture = "hero_icon_locked"
				var_14_16.frame = "menu_frame_12"
			end

			var_14_16.button_hotspot.is_selected = iter_14_0 == arg_14_0._selected_career_column
		end
	end

	if not arg_14_3 then
		arg_14_0:_play_sound("play_gui_hero_select_hero_click")
	end
end

function PopupProfilePicker._set_hero_icon_selected(arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in ipairs(arg_15_0._hero_icon_widgets) do
		iter_15_1.content.button_hotspot.is_selected = iter_15_0 == arg_15_1
	end
end

function PopupProfilePicker._set_hero_info(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0._widgets_by_name

	var_16_0.info_hero_name.content.text = arg_16_1
	var_16_0.info_career_name.content.text = arg_16_2
	var_16_0.info_hero_level.content.text = arg_16_3
end

function PopupProfilePicker._set_timer_text(arg_17_0, arg_17_1)
	arg_17_0._widgets_by_name.timer_text.content.text = arg_17_1
end

function PopupProfilePicker.set_difficulty(arg_18_0, arg_18_1)
	arg_18_0._difficulty = arg_18_1
end

local var_0_5 = 2

function PopupProfilePicker._update_occupied_profiles(arg_19_0, arg_19_1)
	if arg_19_0._lobby_client.request_data and arg_19_1 > (arg_19_0._request_timer or 0) then
		arg_19_0._lobby_client:request_data()

		arg_19_0._request_timer = arg_19_1 + var_0_5
	end

	local var_19_0 = arg_19_0._makeshift_lobby_data

	var_19_0.reserved_profiles = arg_19_0._lobby_client:lobby_data("reserved_profiles")

	local var_19_1 = arg_19_0._hero_widgets
	local var_19_2 = arg_19_0._hero_icon_widgets
	local var_19_3 = false

	for iter_19_0 = 1, #var_19_2 do
		local var_19_4
		local var_19_5 = ProfilePriority[iter_19_0]
		local var_19_6 = not ProfileSynchronizer.is_free_in_lobby(var_19_5, var_19_0, arg_19_0._reserved_party_id)

		var_19_6 = arg_19_0._optional_locked_profile_index == var_19_5 or var_19_6

		local var_19_7 = var_19_2[iter_19_0].content
		local var_19_8 = var_19_7.button_hotspot

		var_19_7.taken = var_19_6
	end

	local var_19_9 = not ProfileSynchronizer.is_free_in_lobby(arg_19_0._selected_profile_index, var_19_0, arg_19_0._reserved_party_id)

	var_19_9 = arg_19_0._optional_locked_profile_index == arg_19_0._selected_profile_index or var_19_9

	for iter_19_1 = 1, #var_19_1 do
		var_19_1[iter_19_1].content.taken = var_19_9
	end

	local var_19_10 = var_19_1[arg_19_0._selected_career_column].content

	if var_19_10.button_hotspot.is_selected and not var_19_10.taken and not var_19_10.locked then
		var_19_3 = true
	end

	arg_19_0:set_select_button_enable_state(var_19_3)
end

function PopupProfilePicker._animate_element_by_time(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, math.ease_out_quad))
end

function PopupProfilePicker.set_select_button_enable_state(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._widgets_by_name.select_button.content

	var_21_0.title_text = arg_21_1 and Localize("input_description_confirm") or Localize("dlc1_2_difficulty_unavailable")
	var_21_0.button_hotspot.disable_button = not arg_21_1
	arg_21_0._selection_approved = arg_21_1

	if arg_21_1 then
		arg_21_0._menu_input_desc:set_input_description(var_0_0.generic_input_actions.confirm_available)
	else
		arg_21_0._menu_input_desc:set_input_description(nil)
	end
end

function PopupProfilePicker._play_sound(arg_22_0, arg_22_1)
	WwiseWorld.trigger_event(arg_22_0._wwise_world, arg_22_1)
end
