-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_inventory_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_inventory_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.category_settings
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.generic_input_actions
local var_0_6 = false
local var_0_7 = "trigger_cycle_next"
local var_0_8 = "trigger_cycle_previous"

local function var_0_9(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.data
	local var_1_1 = arg_1_1.data
	local var_1_2 = var_1_0.key
	local var_1_3 = var_1_1.key
	local var_1_4 = arg_1_0.power_level or 0
	local var_1_5 = arg_1_1.power_level or 0
	local var_1_6 = arg_1_0.backend_id
	local var_1_7 = arg_1_1.backend_id
	local var_1_8 = ItemHelper.is_favorite_backend_id(var_1_6, arg_1_0)

	if var_1_8 == ItemHelper.is_favorite_backend_id(var_1_7, arg_1_1) then
		if var_1_4 == var_1_5 then
			local var_1_9 = arg_1_0.rarity or var_1_0.rarity
			local var_1_10 = arg_1_1.rarity or var_1_1.rarity
			local var_1_11 = UISettings.item_rarity_order
			local var_1_12 = var_1_11[var_1_9]
			local var_1_13 = var_1_11[var_1_10]

			if var_1_12 == var_1_13 then
				local var_1_14 = Localize(var_1_0.item_type)
				local var_1_15 = Localize(var_1_1.item_type)

				if var_1_14 == var_1_15 then
					local var_1_16, var_1_17 = UIUtils.get_ui_information_from_item(arg_1_0)
					local var_1_18, var_1_19 = UIUtils.get_ui_information_from_item(arg_1_1)

					return Localize(var_1_17) < Localize(var_1_19)
				else
					return var_1_14 < var_1_15
				end
			else
				return var_1_12 < var_1_13
			end
		else
			return var_1_5 < var_1_4
		end
	elseif var_1_8 then
		return true
	else
		return false
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole = class(HeroWindowCosmeticsLoadoutInventoryConsole)
HeroWindowCosmeticsLoadoutInventoryConsole.NAME = "HeroWindowCosmeticsLoadoutInventoryConsole"

HeroWindowCosmeticsLoadoutInventoryConsole.on_enter = function (arg_2_0, arg_2_1, arg_2_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsLoadoutInventoryConsole")

	arg_2_0.params = arg_2_1
	arg_2_0.parent = arg_2_1.parent

	local var_2_0 = arg_2_1.ingame_ui_context

	arg_2_0.ui_renderer = var_2_0.ui_renderer
	arg_2_0.ui_top_renderer = var_2_0.ui_top_renderer
	arg_2_0.input_manager = var_2_0.input_manager
	arg_2_0.statistics_db = var_2_0.statistics_db
	arg_2_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_2_1 = Managers.player
	local var_2_2 = var_2_1:local_player()

	arg_2_0._stats_id = var_2_2:stats_id()
	arg_2_0.player_manager = var_2_1
	arg_2_0.peer_id = var_2_0.peer_id
	arg_2_0.hero_name = arg_2_1.hero_name
	arg_2_0.career_index = arg_2_1.career_index
	arg_2_0.profile_index = arg_2_1.profile_index
	arg_2_0.career_name = SPProfiles[arg_2_0.profile_index].careers[arg_2_0.career_index].name
	arg_2_0._animations = {}

	arg_2_0:create_ui_elements(arg_2_1, arg_2_2)
	arg_2_0:_setup_input_buttons()

	local var_2_3 = {
		profile_index = arg_2_1.profile_index,
		career_index = arg_2_1.career_index
	}
	local var_2_4 = ItemGridUI:new(var_0_2, arg_2_0._widgets_by_name.item_grid, arg_2_0.hero_name, arg_2_0.career_index, var_2_3)

	arg_2_0._item_grid = var_2_4

	var_2_4:mark_equipped_items(true)
	var_2_4:mark_locked_items(true)
	var_2_4:disable_locked_items(true)
	var_2_4:disable_item_drag()
	var_2_4:apply_item_sorting_function(var_0_9)
	arg_2_0:_set_item_compare_enable_state(false)

	local var_2_5 = var_2_2 and var_2_2.player_unit

	if var_2_5 then
		local var_2_6 = ScriptUnit.has_extension(var_2_5, "inventory_system")

		if var_2_6 then
			var_2_6:check_and_drop_pickups("enter_inventory")
		end
	end

	arg_2_0:_start_transition_animation("on_enter")
end

HeroWindowCosmeticsLoadoutInventoryConsole._start_transition_animation = function (arg_3_0, arg_3_1)
	local var_3_0 = {
		wwise_world = arg_3_0.wwise_world,
		render_settings = arg_3_0.render_settings
	}
	local var_3_1 = {}
	local var_3_2 = arg_3_0.ui_animator:start_animation(arg_3_1, var_3_1, var_0_3, var_3_0)

	arg_3_0._animations[arg_3_1] = var_3_2
end

HeroWindowCosmeticsLoadoutInventoryConsole.create_ui_elements = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1

	local var_4_3 = Managers.input:get_service("hero_view")
	local var_4_4 = UILayer.default + 300

	arg_4_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_4_0.ui_top_renderer, var_4_3, 6, var_4_4, var_0_5.default, true)

	arg_4_0._menu_input_description:set_input_description(nil)
	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_4)

	if arg_4_2 then
		local var_4_5 = arg_4_0.ui_scenegraph.window.local_position

		var_4_5[1] = var_4_5[1] + arg_4_2[1]
		var_4_5[2] = var_4_5[2] + arg_4_2[2]
		var_4_5[3] = var_4_5[3] + arg_4_2[3]
	end

	var_4_1.item_tooltip.content.profile_index = arg_4_0.params.profile_index
	var_4_1.item_tooltip.content.career_index = arg_4_0.params.career_index
	var_4_1.item_tooltip_compare.content.profile_index = arg_4_0.params.profile_index
	var_4_1.item_tooltip_compare.content.career_index = arg_4_0.params.career_index
end

HeroWindowCosmeticsLoadoutInventoryConsole._input_service = function (arg_5_0)
	local var_5_0 = arg_5_0.parent

	if var_5_0:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return var_5_0:window_input_service()
end

HeroWindowCosmeticsLoadoutInventoryConsole.set_focus = function (arg_6_0, arg_6_1)
	arg_6_0._focused = arg_6_1
	arg_6_0.render_settings.alpha_multiplier = arg_6_1 and 1 or 0.5
	arg_6_0._widgets_by_name.item_tooltip.content.visible = arg_6_1
end

HeroWindowCosmeticsLoadoutInventoryConsole.on_exit = function (arg_7_0, arg_7_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsLoadoutInventoryConsole")

	arg_7_0.ui_animator = nil

	arg_7_0._item_grid:destroy()

	arg_7_0._item_grid = nil

	arg_7_0._menu_input_description:destroy()

	arg_7_0._menu_input_description = nil
end

HeroWindowCosmeticsLoadoutInventoryConsole.update = function (arg_8_0, arg_8_1, arg_8_2)
	if var_0_6 then
		var_0_6 = false

		arg_8_0:create_ui_elements()
	end

	arg_8_0._item_grid:update(arg_8_1, arg_8_2)
	arg_8_0:_update_animations(arg_8_1)
	arg_8_0:_update_selected_cosmetic_slot_index()
	arg_8_0:_update_loadout_sync()
	arg_8_0:_update_page_info()
	arg_8_0:_update_input_description()

	if arg_8_0._focused then
		arg_8_0:_handle_gamepad_activity()
		arg_8_0:_update_selected_item_tooltip()
		arg_8_0:_handle_input(arg_8_1, arg_8_2)
		arg_8_0:_handle_gamepad_input(arg_8_1, arg_8_2)
	end

	arg_8_0:draw(arg_8_1)
end

HeroWindowCosmeticsLoadoutInventoryConsole.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	return
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_input_description = function (arg_10_0)
	local var_10_0 = arg_10_0.params
	local var_10_1 = arg_10_0.params.hero_statistics_active

	if var_10_1 ~= arg_10_0._hero_statistics_active then
		arg_10_0._hero_statistics_active = var_10_1

		if var_10_1 then
			arg_10_0._menu_input_description:change_generic_actions(var_0_5.details)
		else
			arg_10_0._menu_input_description:change_generic_actions(var_0_5.default)
		end
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._set_item_compare_enable_state = function (arg_11_0, arg_11_1)
	arg_11_0._widgets_by_name.item_tooltip_compare.content.visible = arg_11_1
	arg_11_0._draw_item_compare = arg_11_1
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_equipped_item_tooltip = function (arg_12_0)
	local var_12_0 = arg_12_0._selected_cosmetic_slot_index
	local var_12_1 = InventorySettings.slots_by_cosmetic_index[var_12_0].name
	local var_12_2 = Managers.backend:get_interface("items")
	local var_12_3 = BackendUtils.get_loadout_item_id(arg_12_0.career_name, var_12_1)
	local var_12_4 = var_12_3 and var_12_2:get_item_from_id(var_12_3)

	arg_12_0._widgets_by_name.item_tooltip_compare.content.item = var_12_4
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_selected_item_tooltip = function (arg_13_0)
	local var_13_0 = arg_13_0._item_grid:selected_item()
	local var_13_1 = var_13_0 and var_13_0.backend_id

	if var_13_1 ~= arg_13_0._selected_backend_id then
		arg_13_0._widgets_by_name.item_tooltip.content.item = var_13_0
	end

	arg_13_0._selected_backend_id = var_13_1
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_animations = function (arg_14_0, arg_14_1)
	arg_14_0.ui_animator:update(arg_14_1)

	local var_14_0 = arg_14_0._animations
	local var_14_1 = arg_14_0.ui_animator

	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		if var_14_1:is_animation_completed(iter_14_1) then
			var_14_1:stop_animation(iter_14_1)

			var_14_0[iter_14_0] = nil
		end
	end

	local var_14_2 = arg_14_0._widgets_by_name
	local var_14_3 = var_14_2.page_button_next
	local var_14_4 = var_14_2.page_button_previous

	UIWidgetUtils.animate_arrow_button(var_14_3, arg_14_1)
	UIWidgetUtils.animate_arrow_button(var_14_4, arg_14_1)
end

HeroWindowCosmeticsLoadoutInventoryConsole._is_button_pressed = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.content
	local var_15_1 = var_15_0.button_hotspot or var_15_0.hotspot

	if var_15_1.on_release then
		var_15_1.on_release = false

		return true
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._is_button_hovered = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.content

	if (var_16_0.button_hotspot or var_16_0.hotspot).on_hover_enter then
		return true
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._handle_gamepad_input = function (arg_17_0, arg_17_1, arg_17_2)
	if Managers.input:is_device_active("mouse") then
		return
	end

	local var_17_0 = arg_17_0.parent
	local var_17_1 = arg_17_0:_input_service()
	local var_17_2 = arg_17_0._item_grid

	if var_17_2:handle_gamepad_selection(var_17_1) then
		arg_17_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_17_1:get("confirm", true) then
		local var_17_3, var_17_4 = var_17_2:selected_item()

		if var_17_3 and var_17_2:is_item_wieldable(var_17_3) then
			var_17_0:_set_loadout_item(var_17_3)
			arg_17_0:_play_sound("play_gui_equipment_equip_hero")

			if var_17_3.data.slot_type == "skin" then
				var_17_0:update_skin_sync()
			end
		end
	elseif var_17_1:get("special_1", true) then
		arg_17_0:_set_item_compare_enable_state(not arg_17_0._draw_item_compare)
	end

	local var_17_5 = arg_17_0._current_page
	local var_17_6 = arg_17_0._total_pages

	if var_17_5 and var_17_6 then
		if var_17_5 < var_17_6 and var_17_1:get(var_0_7) then
			var_17_2:set_item_page(var_17_5 + 1)
			arg_17_0:_play_sound("play_gui_equipment_inventory_next_click")

			local var_17_7 = var_17_2:get_item_in_slot(1, 1)

			var_17_2:set_item_selected(var_17_7)
		elseif var_17_5 > 1 and var_17_1:get(var_0_8) then
			var_17_2:set_item_page(var_17_5 - 1)
			arg_17_0:_play_sound("play_gui_equipment_inventory_next_click")

			local var_17_8 = var_17_2:get_item_in_slot(1, 1)

			var_17_2:set_item_selected(var_17_8)
		end
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._handle_input = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0._widgets_by_name
	local var_18_1 = arg_18_0.parent
	local var_18_2 = arg_18_0._item_grid
	local var_18_3 = false
	local var_18_4, var_18_5 = var_18_2:is_item_pressed(var_18_3)
	local var_18_6 = arg_18_0:_input_service()

	if var_18_2:is_item_hovered() then
		arg_18_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_18_2:handle_favorite_marking(var_18_6) then
		arg_18_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_18_4 and not var_18_5 then
		var_18_1:_set_loadout_item(var_18_4)
		arg_18_0:_play_sound("play_gui_equipment_equip_hero")

		local var_18_7 = var_18_4.data

		if var_18_7.slot_type == "skin" then
			var_18_1:update_skin_sync()

			if var_18_7.linked_weapon then
				local var_18_8 = Managers.backend:get_interface("items"):get_item_from_key(var_18_7.linked_weapon)

				if var_18_8 then
					var_18_1:_set_loadout_item(var_18_8)
				end
			end
		end
	end

	local var_18_9 = var_18_0.page_button_next
	local var_18_10 = var_18_0.page_button_previous

	if arg_18_0:_is_button_hovered(var_18_9) or arg_18_0:_is_button_hovered(var_18_10) then
		arg_18_0:_play_sound("play_gui_inventory_next_hover")
	end

	if arg_18_0:_is_button_pressed(var_18_9) then
		local var_18_11 = arg_18_0._current_page + 1

		var_18_2:set_item_page(var_18_11)
		arg_18_0:_play_sound("play_gui_equipment_inventory_next_click")
	elseif arg_18_0:_is_button_pressed(var_18_10) then
		local var_18_12 = arg_18_0._current_page - 1

		var_18_2:set_item_page(var_18_12)
		arg_18_0:_play_sound("play_gui_equipment_inventory_next_click")
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_page_info = function (arg_19_0)
	local var_19_0, var_19_1 = arg_19_0._item_grid:get_page_info()

	if var_19_0 ~= arg_19_0._current_page or var_19_1 ~= arg_19_0._total_pages then
		arg_19_0._total_pages = var_19_1
		arg_19_0._current_page = var_19_0
		var_19_0 = var_19_0 or 1
		var_19_1 = var_19_1 or 1

		local var_19_2 = arg_19_0._widgets_by_name

		var_19_2.page_text_left.content.text = tostring(var_19_0)
		var_19_2.page_text_right.content.text = tostring(var_19_1)
		var_19_2.page_button_next.content.hotspot.disable_button = var_19_0 == var_19_1
		var_19_2.page_button_previous.content.hotspot.disable_button = var_19_0 == 1
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_selected_cosmetic_slot_index = function (arg_20_0)
	local var_20_0 = arg_20_0.parent:get_selected_cosmetic_slot_index()

	if var_20_0 ~= arg_20_0._selected_cosmetic_slot_index then
		arg_20_0._selected_cosmetic_slot_index = var_20_0

		arg_20_0:_change_category_by_index(var_20_0)
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._update_loadout_sync = function (arg_21_0)
	local var_21_0 = arg_21_0._item_grid
	local var_21_1 = arg_21_0.parent.loadout_sync_id

	if var_21_1 ~= arg_21_0._loadout_sync_id then
		arg_21_0._loadout_sync_id = var_21_1

		var_21_0:update_items_status()
		arg_21_0:_update_equipped_item_tooltip()
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._exit = function (arg_22_0, arg_22_1)
	arg_22_0.exit = true
	arg_22_0.exit_level_id = arg_22_1
end

HeroWindowCosmeticsLoadoutInventoryConsole.draw = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.ui_renderer
	local var_23_1 = arg_23_0.ui_top_renderer
	local var_23_2 = arg_23_0.ui_scenegraph
	local var_23_3 = arg_23_0:_input_service()
	local var_23_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_23_1, var_23_2, var_23_3, arg_23_1, nil, arg_23_0.render_settings)

	for iter_23_0, iter_23_1 in ipairs(arg_23_0._widgets) do
		UIRenderer.draw_widget(var_23_1, iter_23_1)
	end

	local var_23_5 = arg_23_0._active_node_widgets

	if var_23_5 then
		for iter_23_2, iter_23_3 in ipairs(var_23_5) do
			UIRenderer.draw_widget(var_23_1, iter_23_3)
		end
	end

	UIRenderer.end_pass(var_23_1)

	if var_23_4 and arg_23_0._menu_input_description then
		arg_23_0._menu_input_description:draw(var_23_1, arg_23_1)
	end
end

HeroWindowCosmeticsLoadoutInventoryConsole._play_sound = function (arg_24_0, arg_24_1)
	arg_24_0.parent:play_sound(arg_24_1)
end

HeroWindowCosmeticsLoadoutInventoryConsole._change_category_by_index = function (arg_25_0, arg_25_1, arg_25_2)
	if arg_25_2 then
		arg_25_1 = arg_25_0._current_category_index or 1
	end

	if arg_25_0._current_category_index == arg_25_1 then
		return
	end

	arg_25_0._current_category_index = arg_25_1

	local var_25_0 = var_0_2[arg_25_1]
	local var_25_1 = var_25_0.name
	local var_25_2 = var_25_0.display_name

	arg_25_0._item_grid:change_category(var_25_1)

	return true
end

HeroWindowCosmeticsLoadoutInventoryConsole._setup_input_buttons = function (arg_26_0)
	local var_26_0 = arg_26_0.parent:window_input_service()
	local var_26_1 = UISettings.get_gamepad_input_texture_data(var_26_0, var_0_7, true)
	local var_26_2 = UISettings.get_gamepad_input_texture_data(var_26_0, var_0_8, true)
	local var_26_3 = arg_26_0._widgets_by_name
	local var_26_4 = var_26_3.input_icon_next
	local var_26_5 = var_26_3.input_icon_previous
	local var_26_6 = var_26_4.style.texture_id

	var_26_6.horizontal_alignment = "center"
	var_26_6.vertical_alignment = "center"
	var_26_6.texture_size = {
		var_26_1.size[1],
		var_26_1.size[2]
	}
	var_26_4.content.texture_id = var_26_1.texture

	local var_26_7 = var_26_5.style.texture_id

	var_26_7.horizontal_alignment = "center"
	var_26_7.vertical_alignment = "center"
	var_26_7.texture_size = {
		var_26_2.size[1],
		var_26_2.size[2]
	}
	var_26_5.content.texture_id = var_26_2.texture
end

HeroWindowCosmeticsLoadoutInventoryConsole._set_gamepad_input_buttons_visibility = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._widgets_by_name
	local var_27_1 = var_27_0.input_icon_next
	local var_27_2 = var_27_0.input_icon_previous
	local var_27_3 = var_27_0.input_arrow_next
	local var_27_4 = var_27_0.input_arrow_previous

	var_27_1.content.visible = arg_27_1
	var_27_2.content.visible = arg_27_1
	var_27_3.content.visible = arg_27_1
	var_27_4.content.visible = arg_27_1
end

HeroWindowCosmeticsLoadoutInventoryConsole._handle_gamepad_activity = function (arg_28_0)
	local var_28_0 = Managers.input:is_device_active("mouse")
	local var_28_1 = arg_28_0.gamepad_active_last_frame == nil

	if not var_28_0 then
		if not arg_28_0.gamepad_active_last_frame or var_28_1 then
			arg_28_0.gamepad_active_last_frame = true

			local var_28_2 = arg_28_0._item_grid
			local var_28_3 = var_28_2:get_item_in_slot(1, 1)

			var_28_2:set_item_selected(var_28_3)
			arg_28_0:_set_gamepad_input_buttons_visibility(true)
		end
	elseif arg_28_0.gamepad_active_last_frame or var_28_1 then
		arg_28_0.gamepad_active_last_frame = false

		arg_28_0._item_grid:set_item_selected(nil)

		if arg_28_0._draw_item_compare then
			arg_28_0:_set_item_compare_enable_state(false)
		end

		arg_28_0:_set_gamepad_input_buttons_visibility(false)
	end
end
