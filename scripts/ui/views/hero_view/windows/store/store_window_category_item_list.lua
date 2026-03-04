-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_category_item_list.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_category_item_list_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = 10
local var_0_5 = 800

StoreWindowCategoryItemList = class(StoreWindowCategoryItemList)
StoreWindowCategoryItemList.NAME = "StoreWindowCategoryItemList"

StoreWindowCategoryItemList.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate StoreWindowCategoryItemList")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0, var_1_1 = arg_1_0._parent:get_renderers()

	arg_1_0._ui_renderer = var_1_0
	arg_1_0._ui_top_renderer = var_1_1
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		list_alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._layout_settings = arg_1_1.layout_settings
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_start_transition_animation("on_enter")
end

StoreWindowCategoryItemList._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {
		widgets_by_name = arg_2_0._widgets_by_name,
		list_widgets = arg_2_0._list_widgets
	}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_2, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

StoreWindowCategoryItemList._create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_top_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_3)

	local var_3_3 = arg_3_0._widgets_by_name.list_scrollbar

	arg_3_0._scrollbar_logic = ScrollBarLogic:new(var_3_3)
end

StoreWindowCategoryItemList.on_exit = function (arg_4_0, arg_4_1, arg_4_2)
	print("[HeroViewWindow] Exit Substate StoreWindowCategoryItemList")

	arg_4_0._ui_animator = nil

	arg_4_0:_destroy_product_widgets(arg_4_2)
end

StoreWindowCategoryItemList.update = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = false

	if arg_5_0:_sync_products_version() then
		var_5_0 = arg_5_0._selected_product ~= nil
	end

	if arg_5_0._create_widgets then
		arg_5_0._create_widgets = arg_5_0:_create_product_widgets(arg_5_0._layout, false)
	end

	arg_5_0:_sync_layout_path(var_5_0)
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_draw(arg_5_1)
end

StoreWindowCategoryItemList._sync_products_version = function (arg_6_0)
	local var_6_0 = arg_6_0._parent:products_version_id()

	if var_6_0 ~= arg_6_0._products_version_id then
		arg_6_0._products_version_id = var_6_0

		return true
	end

	return false
end

StoreWindowCategoryItemList.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0._list_initialized then
		arg_7_0:_handle_input(arg_7_1, arg_7_2)
		arg_7_0:_handle_gamepad_activity()
		arg_7_0:_update_gamepad_focus()
	end
end

StoreWindowCategoryItemList._update_animations = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._ui_animations
	local var_8_1 = arg_8_0._animations
	local var_8_2 = arg_8_0._ui_animator

	for iter_8_0, iter_8_1 in pairs(arg_8_0._ui_animations) do
		UIAnimation.update(iter_8_1, arg_8_1)

		if UIAnimation.completed(iter_8_1) then
			arg_8_0._ui_animations[iter_8_0] = nil
		end
	end

	var_8_2:update(arg_8_1)

	for iter_8_2, iter_8_3 in pairs(var_8_1) do
		if var_8_2:is_animation_completed(iter_8_3) then
			var_8_2:stop_animation(iter_8_3)

			var_8_1[iter_8_2] = nil
		end
	end

	if arg_8_0._list_initialized then
		arg_8_0:_animate_list_entries(arg_8_1)
	end
end

StoreWindowCategoryItemList._is_list_hovered = function (arg_9_0)
	return arg_9_0._widgets_by_name.list.content.list_hotspot.is_hover or false
end

StoreWindowCategoryItemList._handle_input = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._parent
	local var_10_1 = arg_10_0._widgets_by_name
	local var_10_2 = arg_10_0._parent:window_input_service()

	if arg_10_0._list_initialized then
		if arg_10_0:_is_list_hovered() then
			local var_10_3 = arg_10_0:_list_index_pressed()

			if var_10_3 then
				arg_10_0:_play_sound("Play_hud_store_button_select")
				arg_10_0:_on_list_index_pressed(var_10_3)
			end
		end

		if arg_10_0._gamepad_active_last_frame then
			if var_10_2:get("confirm_press") then
				local var_10_4 = arg_10_0._selected_gamepad_grid_index

				if var_10_4 then
					arg_10_0:_play_sound("Play_hud_store_button_select")
					arg_10_0:_on_list_index_pressed(var_10_4)
				end
			else
				arg_10_0:_handle_gamepad_grid_selection(var_10_2)
			end
		end

		arg_10_0._scrollbar_logic:update(arg_10_1, arg_10_2)
		arg_10_0:_update_scroll_position()
	end
end

StoreWindowCategoryItemList._draw = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._ui_top_renderer
	local var_11_1 = arg_11_0._ui_scenegraph
	local var_11_2 = arg_11_0._parent:window_input_service()
	local var_11_3 = arg_11_0._render_settings
	local var_11_4 = var_11_3.alpha_multiplier or 0
	local var_11_5 = var_11_3.list_alpha_multiplier or 0

	UIRenderer.begin_pass(var_11_0, var_11_1, var_11_2, arg_11_1, nil, var_11_3)

	var_11_3.alpha_multiplier = var_11_4

	for iter_11_0, iter_11_1 in ipairs(arg_11_0._widgets) do
		UIRenderer.draw_widget(var_11_0, iter_11_1)
	end

	var_11_3.alpha_multiplier = math.min(var_11_4, var_11_5)

	if arg_11_0._list_initialized then
		local var_11_6 = arg_11_0._list_widgets

		if var_11_6 then
			local var_11_7 = arg_11_0:_update_visible_list_entries()

			for iter_11_2, iter_11_3 in ipairs(var_11_6) do
				if var_11_7 or iter_11_3.content.visible then
					UIRenderer.draw_widget(var_11_0, iter_11_3)
				end
			end
		end
	end

	var_11_3.alpha_multiplier = var_11_4

	UIRenderer.end_pass(var_11_0)
end

StoreWindowCategoryItemList._play_sound = function (arg_12_0, arg_12_1)
	arg_12_0._parent:play_sound(arg_12_1)
end

StoreWindowCategoryItemList._update_gamepad_focus = function (arg_13_0)
	local var_13_0 = arg_13_0._params.category_focused

	if var_13_0 ~= arg_13_0._category_focused then
		arg_13_0._category_focused = var_13_0

		if var_13_0 then
			arg_13_0:_on_list_index_selected(nil)
		elseif arg_13_0._gamepad_active_last_frame then
			arg_13_0:_on_list_index_selected(arg_13_0._previous_gamepad_grid_index or 1)
		end
	end
end

StoreWindowCategoryItemList._handle_gamepad_activity = function (arg_14_0)
	local var_14_0 = Managers.input:is_device_active("mouse")
	local var_14_1 = arg_14_0._gamepad_active_last_frame == nil

	if not var_14_0 then
		if not arg_14_0._gamepad_active_last_frame or var_14_1 then
			arg_14_0._gamepad_active_last_frame = true
		end
	elseif arg_14_0._gamepad_active_last_frame or var_14_1 then
		arg_14_0._gamepad_active_last_frame = false

		arg_14_0:_on_list_index_selected(nil)
	end
end

StoreWindowCategoryItemList._list_index_pressed = function (arg_15_0)
	local var_15_0 = arg_15_0._list_widgets

	if var_15_0 then
		for iter_15_0, iter_15_1 in ipairs(var_15_0) do
			local var_15_1 = iter_15_1.content
			local var_15_2 = var_15_1.hotspot or var_15_1.button_hotspot

			if var_15_2 and var_15_2.on_release then
				var_15_2.on_release = false

				return iter_15_0
			end
		end
	end
end

StoreWindowCategoryItemList._animate_list_entries = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._parent
	local var_16_1 = arg_16_0:_is_list_hovered()
	local var_16_2 = arg_16_0._list_widgets

	if arg_16_0._gamepad_active_last_frame then
		var_16_1 = true
	end

	for iter_16_0, iter_16_1 in ipairs(var_16_2) do
		local var_16_3 = iter_16_1.content
		local var_16_4 = iter_16_1.style
		local var_16_5 = var_16_3.button_hotspot or var_16_3.hotspot

		if var_16_5.on_hover_enter then
			arg_16_0:_play_sound("Play_hud_store_button_hover")

			var_16_5.on_hover_enter = false
		end

		var_16_0:animate_store_product(iter_16_1, arg_16_1, var_16_1)
	end
end

StoreWindowCategoryItemList._get_items_by_filter = function (arg_17_0, arg_17_1)
	return (Managers.backend:get_interface("peddler"):get_filtered_items(arg_17_1))
end

StoreWindowCategoryItemList._get_all_items = function (arg_18_0)
	return (Managers.backend:get_interface("peddler"):get_peddler_stock())
end

StoreWindowCategoryItemList._update_item_list = function (arg_19_0)
	arg_19_0:_destroy_product_widgets()

	local var_19_0 = arg_19_0._parent:get_store_path()
	local var_19_1 = StoreLayoutConfig.pages
	local var_19_2 = "item"
	local var_19_3 = {}
	local var_19_4 = StoreLayoutConfig.get_item_filter(var_19_0, callback(arg_19_0._parent.get_temporary_page, arg_19_0))
	local var_19_5 = arg_19_0:_get_items_by_filter(var_19_4)
	local var_19_6 = 0

	for iter_19_0, iter_19_1 in pairs(var_19_5) do
		local var_19_7 = iter_19_1.data
		local var_19_8 = var_19_7 and var_19_7.bundle

		if var_19_8 then
			for iter_19_2, iter_19_3 in ipairs(var_19_8.BundledItems) do
				local var_19_9 = ItemMasterList[iter_19_3]
				local var_19_10 = {
					item = var_19_9,
					type = var_19_9.item_type,
					product_item = iter_19_1,
					product_id = var_19_7.key,
					sort_key = Localize(var_19_7.display_name),
					settings = {
						hide_price = true,
						hide_new = true,
						icon_size = var_19_7.icon_size
					},
					page_name = var_19_7.display_name,
					page = {
						sound_event_enter = "Play_hud_store_category_button",
						type = "collection_item",
						category_button_texture = "store_category_icon_pactsworn",
						hide_preview_details = true,
						exclusive_filter = true,
						layout = "item_list",
						sort_order = 5,
						display_name = var_19_7.display_name,
						item_filter = "item_type == " .. var_19_7.item_type .. " and item_key == " .. var_19_7.key
					}
				}

				var_19_3[#var_19_3 + 1] = var_19_10
			end
		else
			var_19_3[var_19_6], var_19_6 = {
				item = iter_19_1,
				type = var_19_2,
				product_id = iter_19_1.key,
				sort_key = StoreLayoutConfig.make_sort_key(iter_19_1)
			}, var_19_6 + 1
		end
	end

	table.sort(var_19_3, StoreLayoutConfig.compare_sort_key)

	arg_19_0._layout = var_19_3
	arg_19_0._create_widgets = arg_19_0:_create_product_widgets(var_19_3, true)

	local var_19_11 = var_19_0[#var_19_0]
	local var_19_12 = (var_19_1[var_19_11] or arg_19_0._parent:get_temporary_page(var_19_11)).display_name

	arg_19_0:_set_title_texts(Localize(var_19_12))

	arg_19_0._previous_gamepad_grid_index = nil
	arg_19_0._previous_gamepad_grid_row = nil
	arg_19_0._previous_gamepad_grid_column = nil

	if not arg_19_0._list_initialized then
		arg_19_0:_start_transition_animation("on_item_list_initialized")
	else
		arg_19_0:_start_transition_animation("on_item_list_updated")
	end

	arg_19_0._list_initialized = true
end

StoreWindowCategoryItemList._set_title_texts = function (arg_20_0, arg_20_1)
	arg_20_0._widgets_by_name.title_text.content.text = arg_20_1
end

StoreWindowCategoryItemList._get_list_index_by_product_id = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._layout
	local var_21_1 = 1

	for iter_21_0, iter_21_1 in ipairs(var_21_0) do
		if iter_21_1.product_id == arg_21_1 then
			return iter_21_0
		end
	end
end

StoreWindowCategoryItemList._on_list_index_selected = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._layout[arg_22_1]

	arg_22_0._params.selected_product = var_22_0

	local var_22_1
	local var_22_2
	local var_22_3 = arg_22_0._list_widgets

	if var_22_3 then
		for iter_22_0, iter_22_1 in ipairs(var_22_3) do
			local var_22_4 = iter_22_1.content
			local var_22_5 = var_22_4.hotspot or var_22_4.button_hotspot

			if var_22_5 then
				local var_22_6 = iter_22_0 == arg_22_1

				var_22_5.is_selected = var_22_6

				if var_22_6 then
					var_22_1 = var_22_4.row
					var_22_2 = var_22_4.column
					var_22_5.on_hover_enter = true
				end
			end
		end
	end

	arg_22_0._previous_gamepad_grid_index = arg_22_0._selected_gamepad_grid_index
	arg_22_0._previous_gamepad_grid_row = arg_22_0._selected_gamepad_grid_row
	arg_22_0._previous_gamepad_grid_column = arg_22_0._selected_gamepad_grid_column
	arg_22_0._selected_gamepad_grid_index = arg_22_1
	arg_22_0._selected_gamepad_grid_row = var_22_1
	arg_22_0._selected_gamepad_grid_column = var_22_2

	if arg_22_2 then
		local var_22_7 = arg_22_0._widgets_by_name.list_scrollbar.content.scroll_bar_info
		local var_22_8 = UIAnimation.function_by_time
		local var_22_9 = var_22_7
		local var_22_10 = "scroll_value"
		local var_22_11 = var_22_7.scroll_value
		local var_22_12 = arg_22_2
		local var_22_13 = 0.3
		local var_22_14 = math.easeOutCubic

		arg_22_0._ui_animations.scrollbar = UIAnimation.init(var_22_8, var_22_9, var_22_10, var_22_11, var_22_12, var_22_13, var_22_14)
	else
		arg_22_0._ui_animations.scrollbar = nil
	end
end

StoreWindowCategoryItemList._on_list_index_pressed = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._layout[arg_23_1]
	local var_23_1 = var_23_0.product_id
	local var_23_2 = arg_23_0._parent
	local var_23_3 = true
	local var_23_4 = var_23_2:get_store_path()
	local var_23_5 = table.clone(var_23_4)

	if var_23_0.page then
		local var_23_6 = var_23_0.page_name

		var_23_5[#var_23_5 + 1] = var_23_6

		var_23_2:go_to_store_path(var_23_5, var_23_3, var_23_0.page)
	else
		var_23_5[#var_23_5 + 1] = "all_items"

		var_23_2:go_to_product(var_23_1, var_23_5, nil, var_23_3)
	end
end

StoreWindowCategoryItemList._create_product_widgets = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._create_widget_index
	local var_24_1 = arg_24_0._list_widgets
	local var_24_2 = 12

	if arg_24_2 then
		var_24_0 = 1
		var_24_1 = {}
		arg_24_0._list_widgets = var_24_1
	end

	local var_24_3 = arg_24_0._parent
	local var_24_4 = "item_root"
	local var_24_5 = true

	for iter_24_0 = var_24_0, math.min(#arg_24_1, var_24_0 + var_24_2) do
		var_24_0 = var_24_0 + 1

		local var_24_6 = arg_24_1[iter_24_0]
		local var_24_7 = var_24_3:create_item_widget(var_24_6, var_24_4, var_24_5)

		var_24_3:populate_product_widget(var_24_7, var_24_6)

		var_24_1[iter_24_0] = var_24_7
	end

	arg_24_0._create_widget_index = var_24_0

	arg_24_0:_align_item_widgets()
	arg_24_0:_initialize_scrollbar()

	return var_24_0 <= #arg_24_1
end

StoreWindowCategoryItemList._destroy_product_widgets = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._parent
	local var_25_1 = arg_25_0._layout
	local var_25_2 = arg_25_0._list_widgets

	if var_25_2 and var_25_1 then
		for iter_25_0, iter_25_1 in ipairs(var_25_2) do
			local var_25_3 = var_25_1[iter_25_0]

			var_25_0:destroy_product_widget(iter_25_1, var_25_3, arg_25_1)
		end
	end
end

StoreWindowCategoryItemList._align_item_widgets = function (arg_26_0)
	local var_26_0 = 0
	local var_26_1 = 0
	local var_26_2 = 0
	local var_26_3 = 1
	local var_26_4 = 1
	local var_26_5 = {}
	local var_26_6 = arg_26_0._list_widgets
	local var_26_7 = #var_26_6

	for iter_26_0, iter_26_1 in ipairs(var_26_6) do
		local var_26_8 = iter_26_1.offset
		local var_26_9 = iter_26_1.content
		local var_26_10 = var_26_9.size
		local var_26_11 = var_26_10[1]
		local var_26_12 = var_26_10[2]

		if var_26_1 + var_26_11 > var_0_5 then
			var_26_4 = 1
			var_26_3 = var_26_3 + 1
			var_26_1 = 0
			var_26_2 = var_26_2 - (var_26_12 + var_0_4)
		end

		var_26_8[1] = var_26_1
		var_26_8[2] = var_26_2
		iter_26_1.default_offset = table.clone(var_26_8)
		var_26_9.row = var_26_3
		var_26_9.column = var_26_4
		var_26_1 = var_26_1 + (var_26_11 + var_0_4)

		if iter_26_0 == var_26_7 then
			var_26_0 = math.abs(var_26_2 - var_26_12)
		end

		if not var_26_5[var_26_3] then
			var_26_5[var_26_3] = {}
		end

		var_26_5[var_26_3][var_26_4] = iter_26_0
		var_26_4 = var_26_4 + 1
	end

	arg_26_0._gamepad_navigation = var_26_5
	arg_26_0._total_list_height = var_26_0

	arg_26_0:_right_align_item_widgets()
end

StoreWindowCategoryItemList._right_align_item_widgets = function (arg_27_0)
	local var_27_0 = arg_27_0._list_widgets
	local var_27_1
	local var_27_2

	for iter_27_0, iter_27_1 in ripairs(var_27_0) do
		local var_27_3 = iter_27_1.offset
		local var_27_4 = iter_27_1.default_offset
		local var_27_5 = iter_27_1.content
		local var_27_6 = var_27_5.size[1]
		local var_27_7 = var_27_3[1]

		if var_0_5 - (var_27_7 + var_27_6) == 0 then
			break
		end

		if var_27_2 then
			var_27_2 = var_27_2 - (var_27_6 + var_0_4)
		else
			var_27_2 = var_0_5 - var_27_6
		end

		var_27_3[1] = var_27_2
		var_27_4[1] = var_27_2

		local var_27_8 = var_27_5.column

		if var_27_1 and var_27_8 < var_27_1 then
			break
		end

		var_27_1 = var_27_8
	end
end

StoreWindowCategoryItemList._sync_layout_path = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._parent:get_store_path()
	local var_28_1 = StoreLayoutConfig.structure
	local var_28_2 = StoreLayoutConfig.pages
	local var_28_3 = arg_28_0._saved_path or {}
	local var_28_4 = false

	if #var_28_0 ~= #var_28_3 then
		var_28_4 = true
	else
		for iter_28_0 = 1, #var_28_0 do
			if var_28_0[iter_28_0] ~= var_28_3[iter_28_0] then
				var_28_4 = true

				break
			end
		end
	end

	if var_28_4 or arg_28_1 then
		arg_28_0:_update_item_list()

		arg_28_0._saved_path = table.clone(var_28_0)
	end
end

StoreWindowCategoryItemList._handle_gamepad_grid_selection = function (arg_29_0, arg_29_1)
	if not arg_29_0._selected_gamepad_grid_index then
		return
	end

	local var_29_0 = arg_29_0._gamepad_navigation
	local var_29_1 = #var_29_0
	local var_29_2 = arg_29_0._selected_gamepad_grid_index
	local var_29_3 = arg_29_0._selected_gamepad_grid_row
	local var_29_4 = arg_29_0._selected_gamepad_grid_column
	local var_29_5 = var_29_0[var_29_3]
	local var_29_6 = #var_29_5
	local var_29_7
	local var_29_8

	if arg_29_1:get("move_left_hold_continuous") then
		if var_29_4 == 1 then
			arg_29_0._params.category_focused = true

			return
		elseif var_29_4 > 1 then
			var_29_8 = var_29_5[var_29_4 - 1]
		end
	elseif arg_29_1:get("move_right_hold_continuous") then
		if var_29_4 < var_29_6 then
			var_29_8 = var_29_5[var_29_4 + 1]
		end
	elseif arg_29_1:get("move_up_hold_continuous") then
		var_29_7 = math.max(var_29_3 - 1, 1)
	elseif arg_29_1:get("move_down_hold_continuous") then
		var_29_7 = math.min(var_29_3 + 1, var_29_1)
	end

	if var_29_7 and var_29_7 ~= var_29_3 then
		local var_29_9 = var_29_0[var_29_7]

		var_29_8 = arg_29_0:_find_closest_neighbour(var_29_9, var_29_2, 1)
	end

	if var_29_8 then
		local var_29_10 = arg_29_0:_get_scrollbar_percentage_by_index(var_29_8)

		arg_29_0:_on_list_index_selected(var_29_8, var_29_10)
	end
end

StoreWindowCategoryItemList._find_closest_neighbour = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._list_widgets
	local var_30_1 = var_30_0[arg_30_2]
	local var_30_2 = var_30_1.content.size
	local var_30_3 = var_30_1.offset
	local var_30_4 = var_30_2[1] * 0.5 + var_30_3[1]
	local var_30_5 = math.huge
	local var_30_6

	for iter_30_0, iter_30_1 in pairs(arg_30_1) do
		local var_30_7 = var_30_0[iter_30_1]
		local var_30_8 = var_30_7.offset
		local var_30_9 = var_30_7.content.size[1] * 0.5 + var_30_8[1]
		local var_30_10 = math.abs(var_30_9 - var_30_4)

		if var_30_10 < var_30_5 then
			var_30_5 = var_30_10
			var_30_6 = iter_30_1
		end
	end

	if var_30_6 then
		return var_30_6
	end
end

StoreWindowCategoryItemList._initialize_scrollbar = function (arg_31_0)
	local var_31_0 = var_0_2.list_window.size
	local var_31_1 = var_0_2.list_scrollbar.size
	local var_31_2 = var_31_0[2]
	local var_31_3 = arg_31_0._total_list_height
	local var_31_4 = var_31_1[2]
	local var_31_5 = 200
	local var_31_6 = 1
	local var_31_7 = arg_31_0._scrollbar_logic

	var_31_7:set_scrollbar_values(var_31_2, var_31_3, var_31_4, var_31_5, var_31_6)
	var_31_7:set_scroll_percentage(0)
end

StoreWindowCategoryItemList._update_scroll_position = function (arg_32_0)
	local var_32_0 = arg_32_0._scrollbar_logic:get_scrolled_length()

	if var_32_0 ~= arg_32_0._scrolled_length then
		arg_32_0._ui_scenegraph.list.local_position[2] = var_32_0
		arg_32_0._scrolled_length = var_32_0
	end
end

StoreWindowCategoryItemList._update_visible_list_entries = function (arg_33_0)
	local var_33_0 = arg_33_0._scrollbar_logic

	if not var_33_0:enabled() then
		return true
	end

	local var_33_1 = var_33_0:get_scroll_percentage()
	local var_33_2 = var_33_0:get_scrolled_length()
	local var_33_3 = var_33_0:get_scroll_length()
	local var_33_4 = var_0_2.list_window.size
	local var_33_5 = var_0_4 * 2
	local var_33_6 = var_33_4[2] + var_33_5
	local var_33_7 = arg_33_0._list_widgets
	local var_33_8 = #var_33_7

	for iter_33_0, iter_33_1 in ipairs(var_33_7) do
		local var_33_9 = iter_33_1.offset
		local var_33_10 = iter_33_1.content
		local var_33_11 = var_33_10.size
		local var_33_12 = math.abs(var_33_9[2]) + var_33_11[2]
		local var_33_13 = false

		if var_33_12 < var_33_2 - var_33_5 then
			var_33_13 = true
		elseif var_33_6 < math.abs(var_33_9[2]) - var_33_2 then
			var_33_13 = true
		end

		var_33_10.visible = not var_33_13

		local var_33_14 = var_33_10.button_hotspot or var_33_10.hotspot

		if var_33_13 then
			table.clear(var_33_14)
		end
	end
end

StoreWindowCategoryItemList._scroll_to_list_index = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._scrollbar_logic

	if var_34_0:enabled() then
		local var_34_1 = var_34_0:get_scroll_percentage()
		local var_34_2 = var_34_0:get_scrolled_length()
		local var_34_3 = var_34_0:get_scroll_length()
		local var_34_4 = var_0_2.list_window.size[2]
		local var_34_5 = var_34_2
		local var_34_6 = var_34_5 + var_34_4
		local var_34_7 = arg_34_0._list_widgets

		if var_34_7 then
			local var_34_8 = var_34_7[arg_34_1]
			local var_34_9 = var_34_8.content
			local var_34_10 = var_34_8.offset
			local var_34_11 = var_34_9.size[2]
			local var_34_12 = math.abs(var_34_10[2])
			local var_34_13 = var_34_12 + var_34_11
			local var_34_14

			if var_34_6 < var_34_13 then
				local var_34_15 = var_34_13 - var_34_6

				var_34_14 = math.clamp(var_34_15 / var_34_3, 0, 1)
			elseif var_34_12 < var_34_5 then
				local var_34_16 = var_34_5 - var_34_12

				var_34_14 = -math.clamp(var_34_16 / var_34_3, 0, 1)
			end

			if var_34_14 then
				local var_34_17 = math.clamp(var_34_1 + var_34_14, 0, 1)

				var_34_0:set_scroll_percentage(var_34_17)
			end
		end
	end
end

StoreWindowCategoryItemList._get_scrollbar_percentage_by_index = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._scrollbar_logic

	if var_35_0:enabled() then
		local var_35_1 = var_35_0:get_scroll_percentage()
		local var_35_2 = var_35_0:get_scrolled_length()
		local var_35_3 = var_35_0:get_scroll_length()
		local var_35_4 = var_0_2.list_window.size[2]
		local var_35_5 = var_35_2
		local var_35_6 = var_35_5 + var_35_4
		local var_35_7 = arg_35_0._list_widgets

		if var_35_7 then
			local var_35_8 = var_35_7[arg_35_1]
			local var_35_9 = var_35_8.content
			local var_35_10 = var_35_8.offset
			local var_35_11 = var_35_9.size[2]
			local var_35_12 = math.abs(var_35_10[2])
			local var_35_13 = var_35_12 + var_35_11
			local var_35_14 = 0

			if var_35_6 < var_35_13 then
				local var_35_15 = var_35_13 - var_35_6

				var_35_14 = math.clamp(var_35_15 / var_35_3, 0, 1)
			elseif var_35_12 < var_35_5 then
				local var_35_16 = var_35_5 - var_35_12

				var_35_14 = -math.clamp(var_35_16 / var_35_3, 0, 1)
			end

			if var_35_14 then
				return (math.clamp(var_35_1 + var_35_14, 0, 1))
			end
		end
	end

	return 0
end
