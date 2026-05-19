-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_grid_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_grid_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.overlay_widgets
local var_0_5 = var_0_0.delete_deeds_button_widgets
local var_0_6 = "confirm_press"
local var_0_7 = {
	{
		wield = true,
		name = "heroic_deeds",
		display_name = "heroic_deeds",
		item_filter = "slot_type == deed",
		hero_specific_filter = false,
		item_types = {
			"deed"
		},
		icon = UISettings.slot_icons.melee
	}
}
local var_0_8 = table.enum("clear", "delete_selected")

local function var_0_9(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.data
	local var_1_1 = arg_1_1.data
	local var_1_2 = arg_1_0.rarity or var_1_0.rarity
	local var_1_3 = arg_1_1.rarity or var_1_1.rarity
	local var_1_4 = UISettings.item_rarity_order
	local var_1_5 = var_1_4[var_1_2]
	local var_1_6 = var_1_4[var_1_3]
	local var_1_7 = arg_1_0.backend_id
	local var_1_8 = arg_1_1.backend_id
	local var_1_9 = ItemHelper.is_favorite_backend_id(var_1_7, arg_1_0)

	if var_1_9 == ItemHelper.is_favorite_backend_id(var_1_8, arg_1_1) then
		if var_1_5 == var_1_6 then
			local var_1_10 = Localize(var_1_0.item_type)
			local var_1_11 = Localize(var_1_1.item_type)

			if var_1_10 == var_1_11 then
				local var_1_12, var_1_13 = UIUtils.get_ui_information_from_item(arg_1_0)
				local var_1_14, var_1_15 = UIUtils.get_ui_information_from_item(arg_1_1)

				return Localize(var_1_13) < Localize(var_1_15)
			else
				return var_1_10 < var_1_11
			end
		else
			return var_1_5 < var_1_6
		end
	elseif var_1_9 then
		return true
	else
		return false
	end
end

local var_0_10 = "trigger_cycle_next"
local var_0_11 = "trigger_cycle_previous"

StartGameWindowMutatorGridConsole = class(StartGameWindowMutatorGridConsole)
StartGameWindowMutatorGridConsole.NAME = "StartGameWindowMutatorGridConsole"

function StartGameWindowMutatorGridConsole.on_enter(arg_2_0, arg_2_1, arg_2_2)
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorGridConsole")

	arg_2_0.parent = arg_2_1.parent

	local var_2_0 = arg_2_1.ingame_ui_context

	arg_2_0.ui_renderer = var_2_0.ui_renderer
	arg_2_0._ui_top_renderer = var_2_0.ui_top_renderer
	arg_2_0.input_manager = var_2_0.input_manager
	arg_2_0.statistics_db = var_2_0.statistics_db
	arg_2_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_2_1 = Managers.player

	arg_2_0._stats_id = var_2_1:local_player():stats_id()
	arg_2_0.player_manager = var_2_1
	arg_2_0.peer_id = var_2_0.peer_id
	arg_2_0._deeds_marked_for_deletion = {}
	arg_2_0._animations = {}

	arg_2_0:create_ui_elements(arg_2_1, arg_2_2)

	arg_2_0._previously_selected_backend_id = arg_2_0.parent:get_selected_heroic_deed_backend_id()

	if not Managers.backend:get_interface("items"):get_item_from_id(arg_2_0._previously_selected_backend_id) then
		arg_2_0._previously_selected_backend_id = nil

		arg_2_0.parent:set_selected_heroic_deed_backend_id(nil)
	end

	local var_2_2 = "empire_soldier"
	local var_2_3 = 1
	local var_2_4 = ItemGridUI:new(var_0_7, arg_2_0._widgets_by_name.item_grid, var_2_2, var_2_3)

	var_2_4:change_category("heroic_deeds")
	var_2_4:disable_item_drag()
	var_2_4:apply_item_sorting_function(var_0_9)

	local var_2_5 = Managers.mechanism and Managers.mechanism:mechanism_setting_for_title("override_levels")

	if var_2_5 then
		local var_2_6 = var_2_4:items()

		for iter_2_0 = 1, #var_2_6 do
			local var_2_7 = var_2_6[iter_2_0]

			if var_2_5[var_2_7.level_key] == false then
				var_2_4:lock_item_by_id(var_2_7.backend_id, true)
			end
		end

		var_2_4:mark_locked_items(true)
		var_2_4:disable_locked_items(true)
	end

	arg_2_0:_setup_input_buttons()

	arg_2_0._item_grid = var_2_4

	arg_2_0.parent:set_input_description("select_heroic_deed")
	arg_2_0:_start_transition_animation("on_enter")

	if not Managers.input:is_device_active("gamepad") then
		arg_2_0.parent:set_selected_heroic_deed_backend_id(nil)
	end

	arg_2_0._deed_manager = Managers.deed
	arg_2_0._can_delete_deeds = false
end

function StartGameWindowMutatorGridConsole._start_transition_animation(arg_3_0, arg_3_1)
	local var_3_0 = {
		render_settings = arg_3_0.render_settings
	}
	local var_3_1 = {}
	local var_3_2 = arg_3_0.ui_animator:start_animation(arg_3_1, var_3_1, var_0_2, var_3_0)

	arg_3_0._animations[arg_3_1] = var_3_2
end

function StartGameWindowMutatorGridConsole.create_ui_elements(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_4_0._widgets, arg_4_0._widgets_by_name = UIUtils.create_widgets(var_0_1)
	arg_4_0._overlay_widgets, arg_4_0._overlay_widgets_by_name = UIUtils.create_widgets(var_0_4)
	arg_4_0._delete_deeds_buttons_widgets, arg_4_0._delete_deeds_buttons_widgets_by_name = UIUtils.create_widgets(var_0_5)

	if script_data["eac-untrusted"] then
		local var_4_0 = arg_4_0._delete_deeds_buttons_widgets_by_name

		var_4_0.button_delete.content.button_hotspot.disable_button = true
		var_4_0.button_clear.content.button_hotspot.disable_button = true
	end

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_3)

	if arg_4_2 then
		local var_4_1 = arg_4_0.ui_scenegraph.window.local_position

		var_4_1[1] = var_4_1[1] + arg_4_2[1]
		var_4_1[2] = var_4_1[2] + arg_4_2[2]
		var_4_1[3] = var_4_1[3] + arg_4_2[3]
	end
end

function StartGameWindowMutatorGridConsole.on_exit(arg_5_0, arg_5_1)
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorGridConsole")

	arg_5_0.ui_animator = nil

	arg_5_0._item_grid:destroy()

	arg_5_0._item_grid = nil

	arg_5_0.parent:set_input_description(nil)

	if arg_5_0._previously_selected_backend_id and not arg_5_0._selected_backend_id or not arg_5_0._confirm_selection then
		arg_5_0.parent:set_selected_heroic_deed_backend_id(arg_5_0._previously_selected_backend_id)
	end

	arg_5_0._confirm_selection = nil
end

function StartGameWindowMutatorGridConsole.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._item_grid:update(arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_update_page_info()
	arg_6_0:_update_selected_item_backend_id()
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_handle_gamepad_activity()
	arg_6_0:draw(arg_6_1)
	arg_6_0:_update_on_removal_state(arg_6_2)

	local var_6_0 = arg_6_0._popup_id

	if var_6_0 then
		local var_6_1 = Managers.popup:query_result(var_6_0)

		if var_6_1 then
			if var_6_1 == "yes" then
				arg_6_0:_handle_deeds_deletion()
			end

			arg_6_0._popup_id = nil
		end
	end
end

function StartGameWindowMutatorGridConsole.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function StartGameWindowMutatorGridConsole._update_animations(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.ui_animator

	var_8_0:update(arg_8_1)

	local var_8_1 = arg_8_0._animations

	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		if var_8_0:is_animation_completed(iter_8_1) then
			var_8_0:stop_animation(iter_8_1)

			var_8_1[iter_8_0] = nil
		end
	end

	local var_8_2 = arg_8_0._widgets_by_name
	local var_8_3 = var_8_2.page_button_next
	local var_8_4 = var_8_2.page_button_previous

	UIWidgetUtils.animate_arrow_button(var_8_3, arg_8_1)
	UIWidgetUtils.animate_arrow_button(var_8_4, arg_8_1)
end

function StartGameWindowMutatorGridConsole._handle_input(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.parent:window_input_service()
	local var_9_1 = arg_9_0._item_grid

	if var_9_1:handle_gamepad_selection(var_9_0) then
		arg_9_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_9_1:is_item_hovered() then
		arg_9_0:_play_sound("play_gui_equipment_selection_hover")
	end

	local var_9_2 = Managers.input:is_device_active("gamepad")
	local var_9_3
	local var_9_4

	if var_9_2 then
		local var_9_5, var_9_6 = var_9_1:get_selected_item_grid_slot()

		var_9_3 = var_9_1:get_item_in_slot(var_9_5, var_9_6)
		var_9_4 = var_9_1:get_item_content(var_9_5, var_9_6)
	else
		local var_9_7, var_9_8 = var_9_1:get_item_hovered_slot()

		var_9_3 = var_9_1:get_item_hovered()
		var_9_4 = var_9_1:get_item_content(var_9_7, var_9_8)
	end

	if var_9_3 and not var_9_3.marked_for_deletion and (var_9_0 and var_9_0:get("right_stick_press") or var_9_0:get("mouse_middle_press")) then
		var_9_3.marked_for_deletion = true
		var_9_4.reserved = true

		table.insert(arg_9_0._deeds_marked_for_deletion, var_9_3)
		arg_9_0:_play_sound("hud_deed_delete_select")
	elseif var_9_3 and var_9_3.marked_for_deletion and (var_9_0 and var_9_0:get("right_stick_press") or var_9_0:get("mouse_middle_press")) then
		var_9_3.marked_for_deletion = false
		var_9_4.reserved = false

		local var_9_9 = table.index_of(arg_9_0._deeds_marked_for_deletion, var_9_3)

		table.swap_delete(arg_9_0._deeds_marked_for_deletion, var_9_9)
		arg_9_0:_play_sound("hud_deed_delete_select")
	end

	local var_9_10 = var_9_1:selected_item()

	if var_9_10 and var_9_10.backend_id ~= arg_9_0._selected_backend_id then
		arg_9_0.parent:set_selected_heroic_deed_backend_id(var_9_10.backend_id)
	end

	local var_9_11 = true
	local var_9_12 = var_9_1:is_item_pressed(var_9_11)

	if var_9_12 then
		arg_9_0:_play_sound("play_gui_lobby_button_04_heroic_deed_inventory_click")

		local var_9_13 = var_9_12.backend_id

		arg_9_0.parent:set_selected_heroic_deed_backend_id(var_9_13)

		arg_9_0._selected_backend_id = var_9_13
		arg_9_0._confirm_selection = true

		arg_9_0.parent:set_layout_by_name("heroic_deeds")
	end

	local var_9_14 = arg_9_0._widgets_by_name
	local var_9_15 = var_9_14.page_button_next
	local var_9_16 = var_9_14.page_button_previous

	if UIUtils.is_button_hover_enter(var_9_15) or UIUtils.is_button_hover_enter(var_9_16) then
		arg_9_0:_play_sound("play_gui_inventory_next_hover")
	end

	local var_9_17 = arg_9_0._current_page

	if UIUtils.is_button_pressed(var_9_15) or var_9_0:get(var_0_10) then
		var_9_17 = math.min(var_9_17 + 1, arg_9_0._total_pages)
	elseif UIUtils.is_button_pressed(var_9_16) or var_9_0:get(var_0_11) then
		var_9_17 = math.max(var_9_17 - 1, 1)
	end

	if var_9_17 ~= arg_9_0._current_page then
		var_9_1:set_item_page(var_9_17)
		arg_9_0:_play_sound("play_gui_equipment_inventory_next_click")

		local var_9_18 = arg_9_0._item_grid:get_item_in_slot(1, 1)

		if var_9_18 then
			arg_9_0.parent:set_selected_heroic_deed_backend_id(var_9_18.backend_id)
		end
	end

	local var_9_19 = arg_9_0._delete_deeds_buttons_widgets_by_name.button_clear

	if UIUtils.is_button_hover_enter(var_9_19) then
		arg_9_0:_play_sound("play_gui_start_menu_button_hover")
	end

	if UIUtils.is_button_pressed(var_9_19) or var_9_0:get("refresh") then
		arg_9_0._popup_id = Managers.popup:queue_popup(Localize("delete_deeds_popup_warning_message"), Localize("popup_discard_changes_topic"), "yes", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		arg_9_0._delete_type = var_0_8.clear

		arg_9_0.parent:set_selected_heroic_deed_backend_id(nil)
	end

	local var_9_20 = arg_9_0._delete_deeds_buttons_widgets_by_name.button_delete

	if UIUtils.is_button_hover_enter(var_9_20) then
		arg_9_0:_play_sound("play_gui_start_menu_button_hover")
	end

	if (UIUtils.is_button_pressed(var_9_20) or var_9_0:get("special_1")) and not table.is_empty(arg_9_0._deeds_marked_for_deletion) then
		arg_9_0._popup_id = Managers.popup:queue_popup(Localize("delete_deeds_popup_warning_message"), Localize("popup_discard_changes_topic"), "yes", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
		arg_9_0._delete_type = var_0_8.delete_selected

		arg_9_0.parent:set_selected_heroic_deed_backend_id(nil)
	end

	UIWidgetUtils.animate_default_button(var_9_19, arg_9_1)
	UIWidgetUtils.animate_default_button(var_9_20, arg_9_1)

	if var_9_0:get(var_0_6) then
		arg_9_0._confirm_selection = true

		arg_9_0.parent:set_layout_by_name("heroic_deeds")
	end
end

function StartGameWindowMutatorGridConsole._play_sound(arg_10_0, arg_10_1)
	arg_10_0.parent:play_sound(arg_10_1)
end

function StartGameWindowMutatorGridConsole._update_selected_item_backend_id(arg_11_0)
	local var_11_0 = Managers.input:is_device_active("mouse")
	local var_11_1 = arg_11_0.parent
	local var_11_2 = arg_11_0._item_grid

	if not var_11_0 then
		local var_11_3 = var_11_1:get_selected_heroic_deed_backend_id()

		if var_11_3 ~= arg_11_0._selected_backend_id then
			arg_11_0._selected_backend_id = var_11_3

			var_11_2:set_backend_id_selected(var_11_3)
		elseif not var_11_3 then
			local var_11_4 = var_11_2:get_item_in_slot(1, 1)

			if var_11_4 then
				var_11_1:set_selected_heroic_deed_backend_id(var_11_4.backend_id)
			end
		end
	else
		local var_11_5 = var_11_2:get_item_hovered()
		local var_11_6 = var_11_5 and var_11_5.backend_id

		if var_11_6 ~= arg_11_0._selected_backend_id then
			arg_11_0._selected_backend_id = var_11_6

			var_11_1:set_selected_heroic_deed_backend_id(var_11_6)
		elseif not var_11_6 then
			var_11_1:set_selected_heroic_deed_backend_id(nil)
			var_11_2:set_backend_id_selected(nil)

			arg_11_0._selected_backend_id = nil
		end
	end
end

function StartGameWindowMutatorGridConsole.draw(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._ui_top_renderer
	local var_12_1 = arg_12_0.ui_scenegraph
	local var_12_2 = arg_12_0.parent:window_input_service()
	local var_12_3 = arg_12_0.render_settings
	local var_12_4 = var_12_3.snap_pixel_positions
	local var_12_5 = var_12_3.alpha_multiplier or 1

	UIRenderer.begin_pass(var_12_0, var_12_1, var_12_2, arg_12_1, nil, arg_12_0.render_settings)

	local var_12_6 = arg_12_0._widgets

	for iter_12_0 = 1, #var_12_6 do
		local var_12_7 = var_12_6[iter_12_0]

		UIRenderer.draw_widget(var_12_0, var_12_7)
	end

	if arg_12_0:_is_deleting() then
		for iter_12_1, iter_12_2 in ipairs(arg_12_0._overlay_widgets) do
			if iter_12_2.snap_pixel_positions ~= nil then
				var_12_3.snap_pixel_positions = iter_12_2.snap_pixel_positions
			end

			var_12_3.alpha_multiplier = iter_12_2.alpha_multiplier or var_12_5

			UIRenderer.draw_widget(var_12_0, iter_12_2)

			var_12_3.snap_pixel_positions = var_12_4
		end
	end

	for iter_12_3, iter_12_4 in ipairs(arg_12_0._delete_deeds_buttons_widgets) do
		UIRenderer.draw_widget(var_12_0, iter_12_4)
	end

	UIRenderer.end_pass(var_12_0)
end

function StartGameWindowMutatorGridConsole._update_page_info(arg_13_0)
	local var_13_0, var_13_1 = arg_13_0._item_grid:get_page_info()

	if var_13_0 ~= arg_13_0._current_page or var_13_1 ~= arg_13_0._total_pages then
		arg_13_0._total_pages = var_13_1
		arg_13_0._current_page = var_13_0
		var_13_0 = var_13_0 or 1
		var_13_1 = var_13_1 or 1

		local var_13_2 = arg_13_0._widgets_by_name

		var_13_2.page_text_left.content.text = tostring(var_13_0)
		var_13_2.page_text_right.content.text = tostring(var_13_1)
		var_13_2.page_button_next.content.hotspot.disable_button = var_13_0 == var_13_1
		var_13_2.page_button_previous.content.hotspot.disable_button = var_13_0 == 1
	end
end

function StartGameWindowMutatorGridConsole._setup_input_buttons(arg_14_0)
	local var_14_0 = arg_14_0.parent:window_input_service()
	local var_14_1 = arg_14_0._widgets_by_name
	local var_14_2 = UISettings.get_gamepad_input_texture_data(var_14_0, var_0_10, true)
	local var_14_3 = var_14_1.input_icon_next
	local var_14_4 = var_14_3.style.texture_id

	var_14_4.horizontal_alignment = "center"
	var_14_4.vertical_alignment = "center"
	var_14_4.texture_size = {
		var_14_2.size[1],
		var_14_2.size[2]
	}
	var_14_3.content.texture_id = var_14_2.texture

	local var_14_5 = UISettings.get_gamepad_input_texture_data(var_14_0, var_0_11, true)
	local var_14_6 = var_14_1.input_icon_previous
	local var_14_7 = var_14_6.style.texture_id

	var_14_7.horizontal_alignment = "center"
	var_14_7.vertical_alignment = "center"
	var_14_7.texture_size = {
		var_14_5.size[1],
		var_14_5.size[2]
	}
	var_14_6.content.texture_id = var_14_5.texture
end

function StartGameWindowMutatorGridConsole._set_gamepad_input_buttons_visibility(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._widgets_by_name
	local var_15_1 = var_15_0.input_icon_next
	local var_15_2 = var_15_0.input_icon_previous
	local var_15_3 = var_15_0.input_arrow_next
	local var_15_4 = var_15_0.input_arrow_previous

	var_15_1.content.visible = arg_15_1
	var_15_2.content.visible = arg_15_1
	var_15_3.content.visible = arg_15_1
	var_15_4.content.visible = arg_15_1
end

function StartGameWindowMutatorGridConsole._handle_gamepad_activity(arg_16_0)
	local var_16_0 = arg_16_0.gamepad_active_last_frame == nil

	if Managers.input:is_device_active("gamepad") then
		if not arg_16_0.gamepad_active_last_frame or var_16_0 then
			arg_16_0.gamepad_active_last_frame = true

			arg_16_0:_set_gamepad_input_buttons_visibility(true)
			arg_16_0:_set_delete_buttons_visible(false)
		end
	elseif arg_16_0.gamepad_active_last_frame or var_16_0 then
		arg_16_0.gamepad_active_last_frame = false

		arg_16_0:_set_gamepad_input_buttons_visibility(false)
		arg_16_0:_set_delete_buttons_visible(true)
	end
end

function StartGameWindowMutatorGridConsole._delete_deeds(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._deed_manager
	local var_17_1
	local var_17_2, var_17_3, var_17_4 = var_17_0:can_delete_deeds(arg_17_1, arg_17_2)

	if not var_17_3 then
		printf("[StartGameWindowMutatorGridConsole]:Failed to remove deeds from the inventory: %s)", var_17_4)

		return nil
	else
		return var_17_0:delete_marked_deeds(var_17_3), var_17_2
	end

	arg_17_0.parent:window_input_service():set_blocked(true)
end

function StartGameWindowMutatorGridConsole._handle_deeds_deletion(arg_18_0)
	local var_18_0 = arg_18_0._item_grid:items()

	if arg_18_0._delete_type == "clear" then
		arg_18_0:_mark_all_for_deletion()
	end

	local var_18_1 = arg_18_0._deeds_marked_for_deletion

	if table.is_empty(var_18_0) or table.is_empty(var_18_1) then
		return
	end

	local var_18_2, var_18_3 = arg_18_0:_delete_deeds(var_18_0, var_18_1)

	arg_18_0._deed_removal_id = var_18_2
end

function StartGameWindowMutatorGridConsole._update_on_removal_state(arg_19_0, arg_19_1)
	if not arg_19_0._deed_removal_id then
		return
	end

	if not arg_19_0._deed_manager:is_deleting_deeds() then
		arg_19_0:_on_removal_complete()

		arg_19_0._deed_removal_id = nil
	end
end

function StartGameWindowMutatorGridConsole._is_deleting(arg_20_0)
	return arg_20_0._deed_removal_id
end

function StartGameWindowMutatorGridConsole._on_removal_complete(arg_21_0)
	local var_21_0 = arg_21_0._item_grid

	var_21_0:clear_item_grid()
	var_21_0:change_item_filter(var_0_7[1].item_filter, true)
	arg_21_0.parent:window_input_service():set_blocked(false)

	local var_21_1 = arg_21_0.parent:get_selected_heroic_deed_backend_id()

	arg_21_0:_play_sound("hud_deed_delete_confirmed")
end

function StartGameWindowMutatorGridConsole._set_delete_buttons_visible(arg_22_0, arg_22_1)
	local var_22_0
	local var_22_1
	local var_22_2 = arg_22_0._delete_deeds_buttons_widgets_by_name.button_clear
	local var_22_3 = arg_22_0._delete_deeds_buttons_widgets_by_name.button_delete

	var_22_2.content.visible = arg_22_1
	var_22_3.content.visible = arg_22_1
end

function StartGameWindowMutatorGridConsole._mark_all_for_deletion(arg_23_0)
	arg_23_0._deeds_marked_for_deletion = {}

	local var_23_0 = arg_23_0._item_grid:items()

	for iter_23_0, iter_23_1 in ipairs(var_23_0) do
		iter_23_1.marked_for_deletion = true
		arg_23_0._deeds_marked_for_deletion[#arg_23_0._deeds_marked_for_deletion + 1] = iter_23_1
	end
end
