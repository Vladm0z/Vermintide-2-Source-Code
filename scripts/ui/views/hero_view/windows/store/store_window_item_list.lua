-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_item_list.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_item_list_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = 10
local var_0_5 = 800

StoreWindowItemList = class(StoreWindowItemList)
StoreWindowItemList.NAME = "StoreWindowItemList"

function StoreWindowItemList.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate StoreWindowItemList")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0, var_1_1 = arg_1_0._parent:get_renderers()

	arg_1_0._ui_renderer = var_1_0
	arg_1_0._ui_top_renderer = var_1_1
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._layout_settings = arg_1_1.layout_settings
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0._parent:set_list_details_visibility(true)
	arg_1_0._parent:set_list_details_length(930, 0.3)
	arg_1_0._parent:change_generic_actions("default")
end

function StoreWindowItemList._start_transition_animation(arg_2_0, arg_2_1)
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

function StoreWindowItemList._create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
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

function StoreWindowItemList.on_exit(arg_4_0, arg_4_1, arg_4_2)
	print("[HeroViewWindow] Exit Substate StoreWindowItemList")

	arg_4_0._ui_animator = nil

	arg_4_0:_destroy_product_widgets(arg_4_2)
end

function StoreWindowItemList.update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_handle_gamepad_activity()

	if arg_5_0:_sync_products_version() then
		arg_5_0:_update_item_list()

		if not arg_5_0._initialized then
			arg_5_0._initialized = true

			arg_5_0:_start_transition_animation("on_enter")
		end
	end

	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_draw(arg_5_1)
end

function StoreWindowItemList.post_update(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._initialized then
		arg_6_0:_handle_input(arg_6_1, arg_6_2)
	end
end

function StoreWindowItemList._sync_products_version(arg_7_0)
	local var_7_0 = arg_7_0._parent:products_version_id()

	if var_7_0 ~= arg_7_0._products_version_id then
		arg_7_0._products_version_id = var_7_0

		return true
	end

	return false
end

function StoreWindowItemList._update_animations(arg_8_0, arg_8_1)
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

function StoreWindowItemList._is_list_hovered(arg_9_0)
	return arg_9_0._widgets_by_name.list.content.list_hotspot.is_hover or false
end

function StoreWindowItemList._handle_input(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._parent
	local var_10_1 = arg_10_0._widgets_by_name
	local var_10_2 = arg_10_0._parent:window_input_service()

	if arg_10_0._list_initialized then
		if arg_10_0:_is_list_hovered() then
			local var_10_3 = arg_10_0:_list_index_pressed()

			if var_10_3 then
				arg_10_0:_play_sound("Play_hud_store_button_select")
				arg_10_0:_on_list_index_selected(var_10_3)
			end
		end

		if arg_10_0._gamepad_active_last_frame then
			arg_10_0:_handle_gamepad_grid_selection(var_10_2)
		end

		arg_10_0._scrollbar_logic:update(arg_10_1, arg_10_2)
		arg_10_0:_update_scroll_position()
	end
end

function StoreWindowItemList._draw(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._ui_top_renderer
	local var_11_1 = arg_11_0._ui_scenegraph
	local var_11_2 = arg_11_0._parent:window_input_service()
	local var_11_3 = arg_11_0._render_settings

	UIRenderer.begin_pass(var_11_0, var_11_1, var_11_2, arg_11_1, nil, var_11_3)

	for iter_11_0, iter_11_1 in ipairs(arg_11_0._widgets) do
		UIRenderer.draw_widget(var_11_0, iter_11_1)
	end

	if arg_11_0._list_initialized then
		local var_11_4 = arg_11_0._list_widgets

		if var_11_4 then
			local var_11_5 = arg_11_0:_update_visible_list_entries()

			for iter_11_2, iter_11_3 in ipairs(var_11_4) do
				if var_11_5 or iter_11_3.content.visible then
					UIRenderer.draw_widget(var_11_0, iter_11_3)
				end
			end
		end
	end

	UIRenderer.end_pass(var_11_0)
end

function StoreWindowItemList._play_sound(arg_12_0, arg_12_1)
	arg_12_0._parent:play_sound(arg_12_1)
end

function StoreWindowItemList._handle_gamepad_activity(arg_13_0)
	local var_13_0 = Managers.input:is_device_active("mouse")
	local var_13_1 = arg_13_0._gamepad_active_last_frame == nil

	if not var_13_0 then
		if not arg_13_0._gamepad_active_last_frame or var_13_1 then
			arg_13_0._gamepad_active_last_frame = true
		end
	elseif arg_13_0._gamepad_active_last_frame or var_13_1 then
		arg_13_0._gamepad_active_last_frame = false
	end
end

function StoreWindowItemList._list_index_pressed(arg_14_0)
	local var_14_0 = arg_14_0._list_widgets

	if var_14_0 then
		for iter_14_0, iter_14_1 in ipairs(var_14_0) do
			local var_14_1 = iter_14_1.content
			local var_14_2 = var_14_1.hotspot or var_14_1.button_hotspot

			if var_14_2 and var_14_2.on_release then
				var_14_2.on_release = false

				return iter_14_0
			end
		end
	end
end

function StoreWindowItemList._animate_list_entries(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._parent
	local var_15_1 = arg_15_0:_is_list_hovered()

	if arg_15_0._gamepad_active_last_frame then
		var_15_1 = true
	end

	local var_15_2 = arg_15_0._list_widgets

	for iter_15_0, iter_15_1 in ipairs(var_15_2) do
		local var_15_3 = iter_15_1.content
		local var_15_4 = iter_15_1.style
		local var_15_5 = var_15_3.button_hotspot or var_15_3.hotspot

		if var_15_5.on_hover_enter then
			arg_15_0:_play_sound("Play_hud_store_button_hover")

			var_15_5.on_hover_enter = false
		end

		var_15_0:animate_store_product(iter_15_1, arg_15_1, var_15_1)
	end
end

function StoreWindowItemList._get_items_by_filter(arg_16_0, arg_16_1)
	return (Managers.backend:get_interface("peddler"):get_filtered_items(arg_16_1))
end

function StoreWindowItemList._get_all_items(arg_17_0)
	return (Managers.backend:get_interface("peddler"):get_peddler_stock())
end

function StoreWindowItemList._update_item_list(arg_18_0)
	if arg_18_0._initialized then
		local var_18_0 = arg_18_0._params.selected_product.item

		if arg_18_0._params.selected_product.product_type == "collection" then
			local var_18_1 = Managers.backend:get_interface("items")
			local var_18_2 = arg_18_0._params.selected_product.product_item.data.bundle
			local var_18_3 = var_18_2 and var_18_2.BundledItems
			local var_18_4 = true

			for iter_18_0 = 1, #var_18_3 do
				local var_18_5 = var_18_3[iter_18_0]

				if not var_18_1:has_item(var_18_5) then
					var_18_4 = false

					break
				end
			end

			if var_18_4 then
				for iter_18_1 = 1, #arg_18_0._list_widgets do
					arg_18_0._list_widgets[iter_18_1].content.owned = true
				end
			end
		elseif var_18_0 then
			local var_18_6 = Managers.backend:get_interface("items")
			local var_18_7 = var_18_0.key
			local var_18_8 = var_18_6:has_item(var_18_7) or var_18_6:has_weapon_illusion(var_18_7) or var_18_6:has_bundle_contents(var_18_0.data.bundle_contains)
			local var_18_9 = var_18_0.data.item_type

			var_18_0.owned = var_18_8
			arg_18_0._list_widgets[arg_18_0._selected_gamepad_grid_index].content.owned = var_18_8
		end

		return
	end

	arg_18_0:_destroy_product_widgets()

	local var_18_10 = arg_18_0._parent:get_store_path()
	local var_18_11 = StoreLayoutConfig.pages
	local var_18_12 = var_18_10[#var_18_10]
	local var_18_13 = var_18_11[var_18_12] or arg_18_0._parent:get_temporary_page(var_18_12)
	local var_18_14 = var_18_13.type
	local var_18_15 = var_18_13.content
	local var_18_16 = {}

	if var_18_14 == "item" then
		local var_18_17 = StoreLayoutConfig.get_item_filter(var_18_10, callback(arg_18_0._parent.get_temporary_page, arg_18_0))
		local var_18_18 = arg_18_0:_get_items_by_filter(var_18_17)
		local var_18_19 = 0

		for iter_18_2, iter_18_3 in pairs(var_18_18) do
			local var_18_20 = iter_18_3.data
			local var_18_21 = var_18_20 and var_18_20.bundle

			if var_18_21 then
				for iter_18_4, iter_18_5 in ipairs(var_18_21.BundledItems) do
					local var_18_22 = table.clone(ItemMasterList[iter_18_5])

					var_18_22.data = var_18_22

					local var_18_23 = {
						item = var_18_22,
						type = var_18_14,
						product_id = var_18_20.key,
						sort_key = var_18_22.key,
						settings = {
							hide_price = true,
							icon_size = var_18_20.icon_size
						}
					}

					var_18_16[#var_18_16 + 1] = var_18_23
				end
			else
				var_18_16[var_18_19], var_18_19 = {
					item = iter_18_3,
					type = var_18_14,
					product_id = iter_18_3.key,
					sort_key = StoreLayoutConfig.make_sort_key(iter_18_3)
				}, var_18_19 + 1
			end
		end

		table.sort(var_18_16, StoreLayoutConfig.compare_sort_key)
	elseif var_18_14 == "dlc" then
		for iter_18_6, iter_18_7 in ipairs(var_18_15) do
			local var_18_24 = table.find_by_key(StoreDlcSettings, "dlc_name", iter_18_7)
			local var_18_25 = StoreDlcSettings[var_18_24]

			if var_18_25 then
				var_18_16[#var_18_16 + 1] = {
					dlc_settings = var_18_25,
					type = var_18_14,
					product_id = var_18_25.dlc_name
				}
			end
		end
	elseif var_18_14 == "bundle_items" then
		local var_18_26 = var_18_13.bundle_contains

		for iter_18_8, iter_18_9 in pairs(var_18_26) do
			local var_18_27 = ItemMasterList[iter_18_9]

			var_18_16[#var_18_16 + 1] = {
				type = "item",
				item = {
					dlc_name = var_18_13.dlc_name,
					data = var_18_27
				},
				product_id = var_18_27.key,
				settings = {
					hide_price = true,
					hide_new = true
				}
			}
		end
	elseif var_18_14 == "collection_item" then
		local var_18_28 = ""
		local var_18_29 = 0
		local var_18_30 = var_18_10[#var_18_10]
		local var_18_31 = var_18_11[var_18_30] or arg_18_0._parent:get_temporary_page(var_18_30)

		if var_18_31.item_filter then
			if var_18_29 > 0 then
				var_18_28 = var_18_28 .. " and "
			end

			var_18_28 = var_18_28 .. var_18_31.item_filter
			var_18_29 = var_18_29 + 1
		end

		local var_18_32

		if var_18_29 > 0 then
			var_18_32 = arg_18_0:_get_items_by_filter(var_18_28)
		else
			var_18_32 = arg_18_0:_get_all_items()
		end

		for iter_18_10, iter_18_11 in pairs(var_18_32) do
			local var_18_33 = iter_18_11.data
			local var_18_34 = var_18_33 and var_18_33.bundle

			for iter_18_12, iter_18_13 in ipairs(var_18_34.BundledItems) do
				local var_18_35 = table.clone(ItemMasterList[iter_18_13])

				var_18_35.data = table.clone(var_18_35)
				var_18_16[#var_18_16 + 1] = {
					product_type = "collection",
					item = var_18_35,
					product_item = iter_18_11,
					type = var_18_35.item_type,
					product_id = iter_18_11.key,
					settings = {
						hide_price = true,
						part_of_bundle = true,
						hide_new = true,
						icon_size = var_18_33.icon_size
					},
					parent_settings = {
						icon_size = var_18_33.icon_size
					},
					sort_key = StoreLayoutConfig.make_sort_key(var_18_35)
				}
			end

			table.sort(var_18_16, StoreLayoutConfig.compare_sort_key)
		end
	end

	arg_18_0._layout = var_18_16

	arg_18_0:_create_product_widgets(var_18_16)

	arg_18_0._list_initialized = true
end

local var_0_6 = {
	common = 2,
	promo = 7,
	magic = 5,
	plentiful = 1,
	exotic = 4,
	rare = 3,
	unique = 6
}

function StoreWindowItemList._sort_peddler_items_by_type(arg_19_0, arg_19_1)
	local var_19_0 = {}

	table.clear(var_19_0)

	local var_19_1 = {}
	local var_19_2

	for iter_19_0, iter_19_1 in pairs(arg_19_1) do
		local var_19_3 = iter_19_1.data and iter_19_1.data.item_type or "unknown"

		if var_19_3 == "weapon_skin" then
			var_19_3 = iter_19_1.data and iter_19_1.data.matching_item_key or "unknown"
		end

		var_19_0[var_19_3] = var_19_0[var_19_3] or {}
		var_19_0[var_19_3][#var_19_0[var_19_3] + 1] = iter_19_1
	end

	local function var_19_4(arg_20_0, arg_20_1)
		return (arg_20_0.data and arg_20_0.data.rarity and var_0_6[arg_20_0.data.rarity] or 1) > (arg_20_1.data and arg_20_1.data.rarity and var_0_6[arg_20_1.data.rarity] or 1)
	end

	for iter_19_2, iter_19_3 in pairs(var_19_0) do
		table.sort(iter_19_3, var_19_4)
		table.append(var_19_1, iter_19_3)
		print(iter_19_2)
	end

	return var_19_1
end

function StoreWindowItemList._sort_peddler_items_by_price(arg_21_0, arg_21_1)
	local function var_21_0(arg_22_0, arg_22_1)
		return (arg_22_0.current_prices and arg_22_0.current_prices.SM or 0) > (arg_22_1.current_prices and arg_22_1.current_prices.SM or 0)
	end

	table.sort(arg_21_1, var_21_0)

	return arg_21_1
end

function StoreWindowItemList._get_list_index_by_product_id(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._layout
	local var_23_1 = 1

	for iter_23_0, iter_23_1 in ipairs(var_23_0) do
		if iter_23_1.product_id == arg_23_1 then
			return iter_23_0
		end
	end
end

function StoreWindowItemList._on_list_index_selected(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._layout[arg_24_1]

	arg_24_0._params.selected_product = var_24_0

	local var_24_1 = arg_24_0._list_widgets

	if var_24_0.item then
		local var_24_2 = var_24_0.item.data

		ItemHelper.set_shop_item_seen(var_24_0.product_id, var_24_2.item_type, arg_24_0._parent.tab_cat)
	elseif var_24_0.dlc_settings then
		ItemHelper.set_shop_item_seen(var_24_0.product_id, "dlc", arg_24_0._parent.tab_cat)
	end

	local var_24_3
	local var_24_4

	if var_24_1 then
		for iter_24_0, iter_24_1 in ipairs(var_24_1) do
			local var_24_5 = iter_24_1.content
			local var_24_6 = var_24_5.hotspot or var_24_5.button_hotspot

			if var_24_6 then
				local var_24_7 = iter_24_0 == arg_24_1

				var_24_6.is_selected = var_24_7

				if var_24_7 then
					var_24_3 = var_24_5.row
					var_24_4 = var_24_5.column
					var_24_6.on_hover_enter = true
				end
			end
		end
	end

	arg_24_0._previous_gamepad_grid_index = arg_24_0._selected_gamepad_grid_index
	arg_24_0._previous_gamepad_grid_row = arg_24_0._selected_gamepad_grid_row
	arg_24_0._previous_gamepad_grid_column = arg_24_0._selected_gamepad_grid_column
	arg_24_0._selected_gamepad_grid_index = arg_24_1
	arg_24_0._selected_gamepad_grid_row = var_24_3
	arg_24_0._selected_gamepad_grid_column = var_24_4

	if arg_24_2 then
		local var_24_8 = arg_24_0._widgets_by_name.list_scrollbar.content.scroll_bar_info
		local var_24_9 = UIAnimation.function_by_time
		local var_24_10 = var_24_8
		local var_24_11 = "scroll_value"
		local var_24_12 = var_24_8.scroll_value
		local var_24_13 = arg_24_2
		local var_24_14 = 0.3
		local var_24_15 = math.easeOutCubic

		arg_24_0._ui_animations.scrollbar = UIAnimation.init(var_24_9, var_24_10, var_24_11, var_24_12, var_24_13, var_24_14, var_24_15)
	else
		arg_24_0._ui_animations.scrollbar = nil
	end
end

function StoreWindowItemList._create_product_widgets(arg_25_0, arg_25_1)
	local var_25_0 = {}
	local var_25_1 = arg_25_0._parent
	local var_25_2 = "item_root"
	local var_25_3 = true

	for iter_25_0, iter_25_1 in ipairs(arg_25_1) do
		local var_25_4 = var_25_1:create_item_widget(iter_25_1, var_25_2, var_25_3)

		var_25_1:populate_product_widget(var_25_4, iter_25_1)

		var_25_0[iter_25_0] = var_25_4
	end

	arg_25_0._list_widgets = var_25_0

	arg_25_0:_align_item_widgets()
	arg_25_0:_initialize_scrollbar()

	if #var_25_0 > 0 then
		local var_25_5 = arg_25_0._params.last_selected_product or arg_25_0._params.selected_product
		local var_25_6 = var_25_5 and var_25_5.product_id
		local var_25_7 = arg_25_0:_get_list_index_by_product_id(var_25_6) or 1

		arg_25_0:_on_list_index_selected(var_25_7)
		arg_25_0:_scroll_to_list_index(var_25_7)
	else
		arg_25_0._params.selected_product = nil
	end
end

function StoreWindowItemList._destroy_product_widgets(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._parent
	local var_26_1 = arg_26_0._layout
	local var_26_2 = arg_26_0._list_widgets

	if var_26_2 and var_26_1 then
		for iter_26_0, iter_26_1 in ipairs(var_26_1) do
			local var_26_3 = var_26_2[iter_26_0]

			var_26_0:destroy_product_widget(var_26_3, iter_26_1, arg_26_1)
		end
	end
end

function StoreWindowItemList._align_item_widgets(arg_27_0)
	local var_27_0 = 0
	local var_27_1 = 0
	local var_27_2 = 0
	local var_27_3 = 1
	local var_27_4 = 1
	local var_27_5 = {}
	local var_27_6 = arg_27_0._list_widgets
	local var_27_7 = #var_27_6

	for iter_27_0, iter_27_1 in ipairs(var_27_6) do
		local var_27_8 = iter_27_1.offset
		local var_27_9 = iter_27_1.content
		local var_27_10 = var_27_9.size
		local var_27_11 = var_27_10[1]
		local var_27_12 = var_27_10[2]

		if var_27_1 + var_27_11 > var_0_5 then
			var_27_4 = 1
			var_27_3 = var_27_3 + 1
			var_27_1 = 0
			var_27_2 = var_27_2 - (var_27_12 + var_0_4)
		end

		var_27_8[1] = var_27_1
		var_27_8[2] = var_27_2
		iter_27_1.default_offset = table.clone(var_27_8)
		var_27_9.row = var_27_3
		var_27_9.column = var_27_4
		var_27_1 = var_27_1 + (var_27_11 + var_0_4)

		if iter_27_0 == var_27_7 then
			var_27_0 = math.abs(var_27_2 - var_27_12)
		end

		if not var_27_5[var_27_3] then
			var_27_5[var_27_3] = {}
		end

		var_27_5[var_27_3][var_27_4] = iter_27_0
		var_27_4 = var_27_4 + 1
	end

	arg_27_0._gamepad_navigation = var_27_5
	arg_27_0._total_list_height = var_27_0
end

function StoreWindowItemList._handle_gamepad_grid_selection(arg_28_0, arg_28_1)
	if not arg_28_0._selected_gamepad_grid_index then
		return
	end

	local var_28_0 = arg_28_0._gamepad_navigation
	local var_28_1 = #var_28_0
	local var_28_2 = arg_28_0._selected_gamepad_grid_index
	local var_28_3 = arg_28_0._selected_gamepad_grid_row
	local var_28_4 = arg_28_0._selected_gamepad_grid_column
	local var_28_5 = var_28_0[var_28_3]
	local var_28_6 = #var_28_5
	local var_28_7
	local var_28_8

	if arg_28_1:get("move_left_hold_continuous") then
		if var_28_4 > 1 then
			var_28_8 = var_28_5[var_28_4 - 1]
		end
	elseif arg_28_1:get("move_right_hold_continuous") then
		if var_28_4 < var_28_6 then
			var_28_8 = var_28_5[var_28_4 + 1]
		end
	elseif arg_28_1:get("move_up_hold_continuous") then
		var_28_7 = math.max(var_28_3 - 1, 1)
	elseif arg_28_1:get("move_down_hold_continuous") then
		var_28_7 = math.min(var_28_3 + 1, var_28_1)
	end

	if var_28_7 and var_28_7 ~= var_28_3 then
		local var_28_9 = var_28_0[var_28_7]

		var_28_8 = arg_28_0:_find_closest_neighbour(var_28_9, var_28_2, 1)
	end

	if var_28_8 then
		local var_28_10 = arg_28_0:_get_scrollbar_percentage_by_index(var_28_8)

		arg_28_0:_on_list_index_selected(var_28_8, var_28_10)
	end
end

function StoreWindowItemList._find_closest_neighbour(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0._list_widgets
	local var_29_1 = var_29_0[arg_29_2]
	local var_29_2 = var_29_1.content.size
	local var_29_3 = var_29_1.offset
	local var_29_4 = var_29_2[1] * 0.5 + var_29_3[1]
	local var_29_5 = math.huge
	local var_29_6

	for iter_29_0, iter_29_1 in pairs(arg_29_1) do
		local var_29_7 = var_29_0[iter_29_1]
		local var_29_8 = var_29_7.offset
		local var_29_9 = var_29_7.content.size[1] * 0.5 + var_29_8[1]
		local var_29_10 = math.abs(var_29_9 - var_29_4)

		if var_29_10 < var_29_5 then
			var_29_5 = var_29_10
			var_29_6 = iter_29_1
		end
	end

	if var_29_6 then
		return var_29_6
	end
end

function StoreWindowItemList._initialize_scrollbar(arg_30_0)
	local var_30_0 = var_0_2.list_window.size
	local var_30_1 = var_0_2.list_scrollbar.size
	local var_30_2 = var_30_0[2]
	local var_30_3 = arg_30_0._total_list_height
	local var_30_4 = var_30_1[2]
	local var_30_5 = 220 + var_0_4 * 1.5
	local var_30_6 = 1
	local var_30_7 = arg_30_0._scrollbar_logic

	var_30_7:set_scrollbar_values(var_30_2, var_30_3, var_30_4, var_30_5, var_30_6)
	var_30_7:set_scroll_percentage(var_30_7._scroll_value or 0)
end

function StoreWindowItemList._update_scroll_position(arg_31_0)
	local var_31_0 = arg_31_0._scrollbar_logic:get_scrolled_length()

	if var_31_0 ~= arg_31_0._scrolled_length then
		arg_31_0._ui_scenegraph.list.local_position[2] = var_31_0
		arg_31_0._scrolled_length = var_31_0
	end
end

function StoreWindowItemList._update_visible_list_entries(arg_32_0)
	local var_32_0 = arg_32_0._scrollbar_logic

	if not var_32_0:enabled() then
		return true
	end

	local var_32_1 = var_32_0:get_scroll_percentage()
	local var_32_2 = var_32_0:get_scrolled_length()
	local var_32_3 = var_32_0:get_scroll_length()
	local var_32_4 = var_0_2.list_window.size
	local var_32_5 = var_0_4 * 2
	local var_32_6 = var_32_4[2] + var_32_5
	local var_32_7 = arg_32_0._list_widgets
	local var_32_8 = #var_32_7

	for iter_32_0, iter_32_1 in ipairs(var_32_7) do
		local var_32_9 = iter_32_1.offset
		local var_32_10 = iter_32_1.content
		local var_32_11 = var_32_10.size
		local var_32_12 = math.abs(var_32_9[2]) + var_32_11[2]
		local var_32_13 = false

		if var_32_12 < var_32_2 - var_32_5 then
			var_32_13 = true
		elseif var_32_6 < math.abs(var_32_9[2]) - var_32_2 then
			var_32_13 = true
		end

		var_32_10.visible = not var_32_13
	end
end

function StoreWindowItemList._scroll_to_list_index(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0._scrollbar_logic

	if var_33_0:enabled() then
		local var_33_1 = var_33_0:get_scroll_percentage()
		local var_33_2 = var_33_0:get_scrolled_length()
		local var_33_3 = var_33_0:get_scroll_length()
		local var_33_4 = var_0_2.list_window.size[2]
		local var_33_5 = var_33_2
		local var_33_6 = var_33_5 + var_33_4
		local var_33_7 = arg_33_0._list_widgets

		if var_33_7 then
			local var_33_8 = var_33_7[arg_33_1]
			local var_33_9 = var_33_8.content
			local var_33_10 = var_33_8.offset
			local var_33_11 = var_33_9.size[2]
			local var_33_12 = math.abs(var_33_10[2])
			local var_33_13 = var_33_12 + var_33_11
			local var_33_14

			if var_33_6 < var_33_13 then
				local var_33_15 = var_33_13 - var_33_6

				var_33_14 = math.clamp(var_33_15 / var_33_3, 0, 1)
			elseif var_33_12 < var_33_5 then
				local var_33_16 = var_33_5 - var_33_12

				var_33_14 = -math.clamp(var_33_16 / var_33_3, 0, 1)
			end

			if var_33_14 then
				local var_33_17 = math.clamp(var_33_1 + var_33_14, 0, 1)

				var_33_0:set_scroll_percentage(var_33_17)
			end
		end
	end
end

function StoreWindowItemList._get_scrollbar_percentage_by_index(arg_34_0, arg_34_1)
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
			local var_34_14 = 0

			if var_34_6 < var_34_13 then
				local var_34_15 = var_34_13 - var_34_6

				var_34_14 = math.clamp(var_34_15 / var_34_3, 0, 1)
			elseif var_34_12 < var_34_5 then
				local var_34_16 = var_34_5 - var_34_12

				var_34_14 = -math.clamp(var_34_16 / var_34_3, 0, 1)
			end

			if var_34_14 then
				return (math.clamp(var_34_1 + var_34_14, 0, 1))
			end
		end
	end

	return 0
end
