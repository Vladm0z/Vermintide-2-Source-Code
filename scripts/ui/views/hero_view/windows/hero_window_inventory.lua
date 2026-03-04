-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_inventory.lua

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_inventory_definitions")
local var_0_4 = var_0_3.widgets
local var_0_5 = var_0_3.scenegraph_definition
local var_0_6 = var_0_3.animation_definitions
local var_0_7 = false

HeroWindowInventory = class(HeroWindowInventory)
HeroWindowInventory.NAME = "HeroWindowInventory"

HeroWindowInventory.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowInventory")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.profile_index = arg_1_1.profile_index

	local var_1_2 = ItemGridUI:new(var_0_0, arg_1_0._widgets_by_name.item_grid, arg_1_0.hero_name, arg_1_0.career_index)

	arg_1_0._item_grid = var_1_2

	var_1_2:mark_equipped_items(true)
	var_1_2:mark_locked_items(true)
	var_1_2:disable_locked_items(true)
	var_1_2:disable_item_drag()

	arg_1_0._inventory_sync_id = arg_1_0.parent.inventory_sync_id

	arg_1_0.parent:set_inventory_grid(var_1_2)
end

HeroWindowInventory.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_5)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_4) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_6)

	if arg_2_2 then
		local var_2_3 = arg_2_0.ui_scenegraph.window.local_position

		var_2_3[1] = var_2_3[1] + arg_2_2[1]
		var_2_3[2] = var_2_3[2] + arg_2_2[2]
		var_2_3[3] = var_2_3[3] + arg_2_2[3]
	end
end

HeroWindowInventory.on_exit = function (arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate HeroWindowInventory")

	arg_3_0.ui_animator = nil

	arg_3_0._item_grid:destroy()

	arg_3_0._item_grid = nil
end

HeroWindowInventory.update = function (arg_4_0, arg_4_1, arg_4_2)
	if var_0_7 then
		var_0_7 = false

		arg_4_0:create_ui_elements()
	end

	arg_4_0._item_grid:update(arg_4_1, arg_4_2)
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:_update_inventory_items()
	arg_4_0:_update_disabled_backend_ids()
	arg_4_0:_update_page_info()
	arg_4_0:draw(arg_4_1)
end

HeroWindowInventory.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	return
end

HeroWindowInventory._update_animations = function (arg_6_0, arg_6_1)
	arg_6_0.ui_animator:update(arg_6_1)

	local var_6_0 = arg_6_0._animations
	local var_6_1 = arg_6_0.ui_animator

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if var_6_1:is_animation_completed(iter_6_1) then
			var_6_1:stop_animation(iter_6_1)

			var_6_0[iter_6_0] = nil
		end
	end

	local var_6_2 = arg_6_0._widgets_by_name
end

HeroWindowInventory._is_button_pressed = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		return true
	end
end

HeroWindowInventory._is_button_hovered = function (arg_8_0, arg_8_1)
	if arg_8_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowInventory._handle_input = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._widgets_by_name
	local var_9_1 = arg_9_0.parent
	local var_9_2 = arg_9_0._item_grid
	local var_9_3 = false
	local var_9_4 = var_9_2:is_item_pressed(var_9_3)
	local var_9_5 = var_9_2:is_item_dragged()
	local var_9_6 = var_9_4 or var_9_5

	if var_9_2:is_item_hovered() then
		arg_9_0:_play_sound("play_gui_inventory_item_hover")
	end

	for iter_9_0 = 1, 6 do
		local var_9_7 = var_9_0["material_text_" .. iter_9_0]

		if arg_9_0:_is_button_hovered(var_9_7) then
			arg_9_0:_play_sound("play_gui_equipment_button_hover")
		end
	end

	if var_9_6 then
		local var_9_8 = var_9_6.backend_id

		arg_9_0._pressed_backend_id = var_9_8

		local var_9_9 = var_9_5 ~= nil

		var_9_1:set_pressed_item_backend_id(var_9_8, var_9_9)
	elseif arg_9_0._pressed_backend_id then
		if var_9_1:get_pressed_item_backend_id() == arg_9_0._pressed_backend_id then
			var_9_1:set_pressed_item_backend_id(nil)
		end

		arg_9_0._pressed_backend_id = nil
	end

	local var_9_10 = var_9_0.page_button_next
	local var_9_11 = var_9_0.page_button_previous

	UIWidgetUtils.animate_default_button(var_9_10, arg_9_1)
	UIWidgetUtils.animate_default_button(var_9_11, arg_9_1)

	if arg_9_0:_is_button_hovered(var_9_10) or arg_9_0:_is_button_hovered(var_9_11) then
		arg_9_0:_play_sound("play_gui_inventory_next_hover")
	end

	if arg_9_0:_is_button_pressed(var_9_10) then
		local var_9_12 = arg_9_0._current_page + 1

		var_9_2:set_item_page(var_9_12)
		arg_9_0:_play_sound("play_gui_craft_inventory_next")
	elseif arg_9_0:_is_button_pressed(var_9_11) then
		local var_9_13 = arg_9_0._current_page - 1

		var_9_2:set_item_page(var_9_13)
		arg_9_0:_play_sound("play_gui_craft_inventory_next")
	end
end

HeroWindowInventory._update_page_info = function (arg_10_0)
	local var_10_0, var_10_1 = arg_10_0._item_grid:get_page_info()

	if var_10_0 ~= arg_10_0._current_page or var_10_1 ~= arg_10_0._total_pages then
		arg_10_0._total_pages = var_10_1
		arg_10_0._current_page = var_10_0
		var_10_0 = var_10_0 or 1
		var_10_1 = var_10_1 or 1

		local var_10_2 = arg_10_0._widgets_by_name

		var_10_2.page_text_left.content.text = tostring(var_10_0)
		var_10_2.page_text_right.content.text = tostring(var_10_1)
		var_10_2.page_button_next.content.button_hotspot.disable_button = var_10_0 == var_10_1
		var_10_2.page_button_previous.content.button_hotspot.disable_button = var_10_0 == 1
	end
end

HeroWindowInventory._update_crafting_material_panel = function (arg_11_0)
	local var_11_0 = Managers.backend:get_interface("items")
	local var_11_1 = UISettings.crafting_material_icons_small
	local var_11_2 = UISettings.crafting_material_order
	local var_11_3 = arg_11_0._widgets_by_name
	local var_11_4 = 1

	for iter_11_0, iter_11_1 in ipairs(var_11_2) do
		local var_11_5 = var_11_1[iter_11_1]
		local var_11_6 = "item_key == " .. iter_11_1
		local var_11_7 = var_11_0:get_filtered_items(var_11_6)
		local var_11_8 = var_11_7 and var_11_7[1]
		local var_11_9 = var_11_8 and var_11_8.backend_id
		local var_11_10 = var_11_9 and var_11_0:get_item_amount(var_11_9) or 0
		local var_11_11 = var_11_3["material_text_" .. iter_11_0].content
		local var_11_12

		if var_11_10 < 10000 then
			var_11_12 = tostring(var_11_10)
		elseif var_11_10 < 100000 then
			var_11_12 = string.format("%.1fk", var_11_10 * 0.001)
		else
			var_11_12 = "+99k"
		end

		var_11_11.text = var_11_12
		var_11_11.icon = var_11_5

		if not var_11_11.item then
			var_11_11.item = var_11_8 or {
				data = table.clone(ItemMasterList[iter_11_1])
			}
		end
	end
end

HeroWindowInventory._update_inventory_items = function (arg_12_0)
	local var_12_0 = arg_12_0._item_grid
	local var_12_1 = arg_12_0.parent
	local var_12_2 = var_12_1.inventory_sync_id
	local var_12_3 = var_12_1:get_selected_craft_page()
	local var_12_4 = var_12_1:get_craft_optional_item_filter()

	if var_12_2 ~= arg_12_0._inventory_sync_id or var_12_3 ~= arg_12_0._selected_craft_page_name or arg_12_0._optional_craft_item_filter ~= var_12_4 then
		if var_12_3 ~= arg_12_0._selected_craft_page_name then
			arg_12_0:_change_category_by_name(var_12_3)
		elseif var_12_4 then
			arg_12_0:change_item_filter(var_12_4, true)
		else
			arg_12_0:_change_category_by_index(nil, true)
		end

		arg_12_0._inventory_sync_id = var_12_2
		arg_12_0._selected_craft_page_name = var_12_3
		arg_12_0._optional_craft_item_filter = var_12_4

		arg_12_0:_update_crafting_material_panel()
	end
end

HeroWindowInventory._update_disabled_backend_ids = function (arg_13_0)
	local var_13_0 = arg_13_0._item_grid
	local var_13_1 = arg_13_0.parent.disabled_backend_ids_sync_id

	if var_13_1 ~= arg_13_0._disabled_backend_ids_sync_id then
		arg_13_0._disabled_backend_ids_sync_id = var_13_1

		var_13_0:clear_locked_items()

		local var_13_2 = arg_13_0.parent:get_disabled_backend_ids()

		for iter_13_0, iter_13_1 in pairs(var_13_2) do
			var_13_0:lock_item_by_id(iter_13_0, true)
		end

		var_13_0:update_items_status()
	end
end

HeroWindowInventory._exit = function (arg_14_0, arg_14_1)
	arg_14_0.exit = true
	arg_14_0.exit_level_id = arg_14_1
end

HeroWindowInventory.draw = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.ui_renderer
	local var_15_1 = arg_15_0.ui_top_renderer
	local var_15_2 = arg_15_0.ui_scenegraph
	local var_15_3 = arg_15_0.parent:window_input_service()

	UIRenderer.begin_pass(var_15_1, var_15_2, var_15_3, arg_15_1, nil, arg_15_0.render_settings)

	for iter_15_0, iter_15_1 in ipairs(arg_15_0._widgets) do
		UIRenderer.draw_widget(var_15_1, iter_15_1)
	end

	UIRenderer.end_pass(var_15_1)
end

HeroWindowInventory._play_sound = function (arg_16_0, arg_16_1)
	arg_16_0.parent:play_sound(arg_16_1)
end

HeroWindowInventory._change_category_by_name = function (arg_17_0, arg_17_1)
	for iter_17_0, iter_17_1 in ipairs(var_0_0) do
		if iter_17_1.name == arg_17_1 then
			arg_17_0:_change_category_by_index(iter_17_0)

			break
		end
	end
end

HeroWindowInventory._change_category_by_index = function (arg_18_0, arg_18_1, arg_18_2)
	if arg_18_2 then
		arg_18_1 = arg_18_0._current_category_index or 1
	end

	if arg_18_0._current_category_index == arg_18_1 and not arg_18_2 then
		return
	end

	arg_18_0._current_category_index = arg_18_1

	local var_18_0 = var_0_0[arg_18_1]
	local var_18_1 = var_18_0.name
	local var_18_2 = var_18_0.item_sort_func

	if var_18_2 then
		arg_18_0._item_grid:apply_item_sorting_function(var_18_2)
	end

	arg_18_0._item_grid:change_category(var_18_1, arg_18_2)

	return true
end

HeroWindowInventory.change_item_filter = function (arg_19_0, arg_19_1, arg_19_2)
	arg_19_2 = arg_19_2 or arg_19_2 == nil

	arg_19_0._item_grid:change_item_filter(arg_19_1, arg_19_2)
end
