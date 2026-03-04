-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_category_list.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_category_list_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

local function var_0_4(arg_1_0, arg_1_1)
	return (arg_1_0.sort_order or math.huge) < (arg_1_1.sort_order or math.huge)
end

local var_0_5 = 10
local var_0_6 = 800

StoreWindowCategoryList = class(StoreWindowCategoryList)
StoreWindowCategoryList.NAME = "StoreWindowCategoryList"

StoreWindowCategoryList.on_enter = function (arg_2_0, arg_2_1, arg_2_2)
	print("[HeroViewWindow] Enter Substate StoreWindowCategoryList")

	arg_2_0._params = arg_2_1
	arg_2_0._parent = arg_2_1.parent
	arg_2_0._params.last_selected_product = nil

	local var_2_0, var_2_1 = arg_2_0._parent:get_renderers()

	arg_2_0._ui_renderer = var_2_0
	arg_2_0._ui_top_renderer = var_2_1
	arg_2_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_2_0._layout_settings = arg_2_1.layout_settings
	arg_2_0._animations = {}
	arg_2_0._ui_animations = {}

	arg_2_0:_create_ui_elements(arg_2_1, arg_2_2)
	arg_2_0:_start_transition_animation("on_enter")
	arg_2_0._parent:set_list_details_visibility(true)
	arg_2_0._parent:set_list_details_length(680, 0.3)
	arg_2_0._parent:change_generic_actions("default")
end

StoreWindowCategoryList._start_transition_animation = function (arg_3_0, arg_3_1)
	local var_3_0 = {
		render_settings = arg_3_0._render_settings
	}
	local var_3_1 = {
		widgets_by_name = arg_3_0._widgets_by_name,
		list_widgets = arg_3_0._list_widgets
	}
	local var_3_2 = arg_3_0._ui_animator:start_animation(arg_3_1, var_3_1, var_0_2, var_3_0)

	arg_3_0._animations[arg_3_1] = var_3_2
end

StoreWindowCategoryList._create_ui_elements = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_top_renderer)

	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_3)

	local var_4_3 = arg_4_0._widgets_by_name.list_scrollbar

	arg_4_0._scrollbar_logic = ScrollBarLogic:new(var_4_3)

	arg_4_0:_setup_list_elements()
end

StoreWindowCategoryList.on_exit = function (arg_5_0, arg_5_1, arg_5_2)
	print("[HeroViewWindow] Exit Substate StoreWindowCategoryList")

	arg_5_0._ui_animator = nil

	arg_5_0:_destroy_product_widgets(arg_5_2)
end

StoreWindowCategoryList.update = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_draw(arg_6_1)
end

StoreWindowCategoryList.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0._list_initialized then
		arg_7_0:_handle_input(arg_7_1, arg_7_2)
		arg_7_0:_handle_gamepad_activity()
		arg_7_0:_update_gamepad_focus()
	end
end

StoreWindowCategoryList._update_animations = function (arg_8_0, arg_8_1)
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

StoreWindowCategoryList._is_list_hovered = function (arg_9_0)
	return arg_9_0._widgets_by_name.list.content.list_hotspot.is_hover or false
end

StoreWindowCategoryList._handle_input = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._parent
	local var_10_1 = arg_10_0._widgets_by_name
	local var_10_2 = arg_10_0._parent:window_input_service()

	if arg_10_0._list_initialized then
		if arg_10_0:_is_list_hovered() then
			local var_10_3 = arg_10_0:_list_index_pressed()

			if var_10_3 then
				arg_10_0:_on_list_index_pressed(var_10_3)
			end
		end

		if arg_10_0._gamepad_active_last_frame then
			if var_10_2:get("confirm_press") then
				if arg_10_0._selected_gamepad_grid_index then
					arg_10_0:_on_list_index_pressed(arg_10_0._selected_gamepad_grid_index)
				end
			else
				arg_10_0:_handle_gamepad_grid_selection(var_10_2)
			end
		end

		arg_10_0._scrollbar_logic:update(arg_10_1, arg_10_2)
		arg_10_0:_update_scroll_position()
	end
end

StoreWindowCategoryList._draw = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._ui_top_renderer
	local var_11_1 = arg_11_0._ui_scenegraph
	local var_11_2 = arg_11_0._parent:window_input_service()

	UIRenderer.begin_pass(var_11_0, var_11_1, var_11_2, arg_11_1, nil, arg_11_0._render_settings)

	for iter_11_0, iter_11_1 in ipairs(arg_11_0._widgets) do
		UIRenderer.draw_widget(var_11_0, iter_11_1)
	end

	if arg_11_0._list_initialized then
		local var_11_3 = arg_11_0._list_widgets

		if var_11_3 then
			local var_11_4 = arg_11_0:_update_visible_list_entries()

			for iter_11_2, iter_11_3 in ipairs(var_11_3) do
				if var_11_4 or iter_11_3.content.visible then
					UIRenderer.draw_widget(var_11_0, iter_11_3)
				end
			end
		end
	end

	UIRenderer.end_pass(var_11_0)
end

StoreWindowCategoryList._play_sound = function (arg_12_0, arg_12_1)
	arg_12_0._parent:play_sound(arg_12_1)
end

StoreWindowCategoryList._update_gamepad_focus = function (arg_13_0)
	local var_13_0 = arg_13_0._params.category_focused

	if var_13_0 ~= arg_13_0._category_focused then
		arg_13_0._category_focused = var_13_0

		if var_13_0 then
			if arg_13_0._gamepad_active_last_frame then
				arg_13_0:_on_list_index_selected(1)
			end
		else
			arg_13_0:_on_list_index_selected(nil)
		end
	end
end

StoreWindowCategoryList._handle_gamepad_activity = function (arg_14_0)
	local var_14_0 = Managers.input:is_device_active("mouse")
	local var_14_1 = arg_14_0._gamepad_active_last_frame == nil

	if not var_14_0 then
		if not arg_14_0._gamepad_active_last_frame or var_14_1 then
			arg_14_0._gamepad_active_last_frame = true
			arg_14_0._params.category_focused = true
		end
	elseif arg_14_0._gamepad_active_last_frame or var_14_1 then
		arg_14_0._gamepad_active_last_frame = false
		arg_14_0._params.category_focused = nil
	end
end

StoreWindowCategoryList._get_items_by_filter = function (arg_15_0, arg_15_1)
	return (Managers.backend:get_interface("peddler"):get_filtered_items(arg_15_1))
end

StoreWindowCategoryList._get_all_items = function (arg_16_0)
	return (Managers.backend:get_interface("peddler"):get_peddler_stock())
end

StoreWindowCategoryList._get_items_by_path = function (arg_17_0, arg_17_1)
	local var_17_0 = ""
	local var_17_1 = 0
	local var_17_2 = StoreLayoutConfig.pages

	for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
		local var_17_3 = var_17_2[iter_17_1]

		if var_17_3.item_filter then
			if var_17_1 > 0 then
				var_17_0 = var_17_0 .. " and "
			end

			var_17_0 = var_17_0 .. var_17_3.item_filter
			var_17_1 = var_17_1 + 1
		end
	end

	local var_17_4

	if var_17_1 > 0 then
		var_17_4 = arg_17_0:_get_items_by_filter(var_17_0)
	else
		var_17_4 = arg_17_0:_get_all_items()
	end

	return var_17_4
end

StoreWindowCategoryList._populate_list = function (arg_18_0, arg_18_1)
	local var_18_0 = {}
	local var_18_1 = "item_root"
	local var_18_2 = true
	local var_18_3 = {
		550,
		80
	}
	local var_18_4 = Managers.backend:get_interface("items")
	local var_18_5 = UISettings.item_rarity_textures
	local var_18_6 = arg_18_0._parent:get_store_path()

	for iter_18_0, iter_18_1 in ipairs(arg_18_1) do
		local var_18_7 = iter_18_1.type
		local var_18_8

		if var_18_7 == "collection_item" then
			local var_18_9 = UIWidgets.create_store_collection_entry_definition(var_18_1, var_18_3, var_18_2)

			var_18_8 = UIWidget.init(var_18_9)
		else
			local var_18_10 = UIWidgets.create_store_category_entry_definition(var_18_1, var_18_3, var_18_2)

			var_18_8 = UIWidget.init(var_18_10)
		end

		var_18_0[iter_18_0] = var_18_8

		local var_18_11 = var_18_8.content
		local var_18_12 = var_18_8.style
		local var_18_13 = iter_18_1.display_name

		var_18_11.title = Localize(var_18_13)

		if var_18_7 == "collection_item" then
			arg_18_0._parent:populate_product_widget(var_18_8, iter_18_1)
		else
			local var_18_14 = iter_18_1.category_texture

			var_18_11.category_texture = var_18_14

			if var_18_14 then
				local var_18_15 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_18_14).size
				local var_18_16 = var_18_12.category_texture.texture_size

				var_18_16[1] = var_18_15[1]
				var_18_16[2] = var_18_15[2]
			end
		end

		local var_18_17 = table.clone(var_18_6)
		local var_18_18 = #var_18_17
		local var_18_19 = iter_18_1.page_name

		var_18_17[var_18_18 + 1] = var_18_19
	end

	arg_18_0._list_widgets = var_18_0

	arg_18_0:_align_entry_widgets()
	arg_18_0:_initialize_scrollbar()
end

StoreWindowCategoryList._destroy_product_widgets = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._parent
	local var_19_1 = arg_19_0._layout
	local var_19_2 = arg_19_0._list_widgets

	if var_19_2 and var_19_1 then
		for iter_19_0, iter_19_1 in ipairs(var_19_1) do
			if iter_19_1.type == "collection_item" then
				local var_19_3 = var_19_2[iter_19_0]

				var_19_0:destroy_product_widget(var_19_3, iter_19_1, arg_19_1)
			end
		end
	end
end

StoreWindowCategoryList._align_entry_widgets = function (arg_20_0)
	local var_20_0 = 0
	local var_20_1 = 0
	local var_20_2 = var_0_5
	local var_20_3 = 1
	local var_20_4 = 1
	local var_20_5 = {}
	local var_20_6 = arg_20_0._list_widgets
	local var_20_7 = #var_20_6

	for iter_20_0, iter_20_1 in ipairs(var_20_6) do
		local var_20_8 = iter_20_1.offset
		local var_20_9 = iter_20_1.content
		local var_20_10 = var_20_9.size
		local var_20_11 = var_20_10[1]
		local var_20_12 = var_20_10[2]
		local var_20_13 = var_20_1 + var_20_11 > var_0_6

		if iter_20_0 == 1 then
			var_20_2 = -var_20_12
		end

		if var_20_13 then
			var_20_4 = 1
			var_20_3 = var_20_3 + 1
			var_20_1 = 0
			var_20_2 = var_20_2 - (var_20_12 + var_0_5)
		end

		var_20_8[1] = var_20_1
		var_20_8[2] = var_20_2
		iter_20_1.default_offset = table.clone(var_20_8)
		var_20_9.row = var_20_3
		var_20_9.column = var_20_4
		var_20_1 = var_20_1 + (var_20_11 + var_0_5)

		if iter_20_0 == var_20_7 then
			var_20_0 = math.abs(var_20_2)
		end

		if not var_20_5[var_20_3] then
			var_20_5[var_20_3] = {}
		end

		var_20_5[var_20_3][var_20_4] = iter_20_0
		var_20_4 = var_20_4 + 1
	end

	arg_20_0._gamepad_navigation = var_20_5
	arg_20_0._total_list_height = var_20_0
end

StoreWindowCategoryList._list_index_pressed = function (arg_21_0)
	local var_21_0 = arg_21_0._list_widgets

	if var_21_0 then
		for iter_21_0, iter_21_1 in ipairs(var_21_0) do
			local var_21_1 = iter_21_1.content
			local var_21_2 = var_21_1.hotspot or var_21_1.button_hotspot

			if var_21_2 and var_21_2.on_release then
				var_21_2.on_release = false

				return iter_21_0
			end
		end
	end
end

StoreWindowCategoryList._animate_list_entries = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._parent
	local var_22_1 = arg_22_0:_is_list_hovered()
	local var_22_2 = arg_22_0._list_widgets

	if arg_22_0._gamepad_active_last_frame then
		var_22_1 = true
	end

	for iter_22_0, iter_22_1 in ipairs(var_22_2) do
		local var_22_3 = iter_22_1.content
		local var_22_4 = iter_22_1.style
		local var_22_5 = var_22_3.button_hotspot or var_22_3.hotspot

		if var_22_5.on_hover_enter then
			arg_22_0:_play_sound("Play_hud_store_button_hover")

			var_22_5.on_hover_enter = false
		end

		arg_22_0:_animate_list_entry(var_22_3, var_22_4, arg_22_1, var_22_1)
	end
end

StoreWindowCategoryList._animate_list_entry = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = arg_23_1.button_hotspot or arg_23_1.hotspot
	local var_23_1 = arg_23_4 and var_23_0.on_hover_enter
	local var_23_2 = arg_23_4 and var_23_0.is_hover
	local var_23_3 = var_23_0.is_selected
	local var_23_4 = not var_23_3 and var_23_0.is_clicked and var_23_0.is_clicked == 0
	local var_23_5 = var_23_0.input_progress or 0
	local var_23_6 = var_23_0.hover_progress or 0
	local var_23_7 = var_23_0.pulse_progress or 1
	local var_23_8 = var_23_0.selection_progress or 0
	local var_23_9 = (var_23_2 or var_23_3) and 14 or 3
	local var_23_10 = 3
	local var_23_11 = 20

	if var_23_4 then
		var_23_5 = math.min(var_23_5 + arg_23_3 * var_23_11, 1)
	else
		var_23_5 = math.max(var_23_5 - arg_23_3 * var_23_11, 0)
	end

	local var_23_12 = math.easeOutCubic(var_23_5)
	local var_23_13 = math.easeInCubic(var_23_5)

	if var_23_1 then
		var_23_7 = 0
	end

	local var_23_14 = math.min(var_23_7 + arg_23_3 * var_23_10, 1)
	local var_23_15 = math.easeOutCubic(var_23_14)
	local var_23_16 = math.easeInCubic(var_23_14)

	if var_23_2 then
		var_23_6 = math.min(var_23_6 + arg_23_3 * var_23_9, 1)
	else
		var_23_6 = math.max(var_23_6 - arg_23_3 * var_23_9, 0)
	end

	local var_23_17 = math.easeOutCubic(var_23_6)
	local var_23_18 = math.easeInCubic(var_23_6)

	if var_23_3 then
		var_23_8 = math.min(var_23_8 + arg_23_3 * var_23_9, 1)
	else
		var_23_8 = math.max(var_23_8 - arg_23_3 * var_23_9, 0)
	end

	local var_23_19 = math.easeOutCubic(var_23_8)
	local var_23_20 = math.easeInCubic(var_23_8)
	local var_23_21 = math.max(var_23_6, var_23_8)
	local var_23_22 = math.max(var_23_19, var_23_17)
	local var_23_23 = math.max(var_23_18, var_23_20)
	local var_23_24 = 255 * var_23_21

	arg_23_2.hover_frame.color[1] = var_23_24

	local var_23_25 = 100 + 155 * var_23_21

	arg_23_2.category_texture.color[1] = var_23_25

	local var_23_26 = 255 - 255 * var_23_14

	arg_23_2.pulse_frame.color[1] = var_23_26

	local var_23_27 = arg_23_2.title
	local var_23_28 = var_23_27.text_color
	local var_23_29 = var_23_27.default_text_color
	local var_23_30 = var_23_27.select_text_color

	Colors.lerp_color_tables(var_23_29, var_23_30, var_23_21, var_23_28)

	var_23_0.pulse_progress = var_23_14
	var_23_0.hover_progress = var_23_6
	var_23_0.input_progress = var_23_5
	var_23_0.selection_progress = var_23_8
end

StoreWindowCategoryList._setup_list_elements = function (arg_24_0)
	arg_24_0:_destroy_product_widgets()

	local var_24_0 = arg_24_0._parent:get_store_path()
	local var_24_1 = StoreLayoutConfig.structure

	for iter_24_0, iter_24_1 in pairs(var_24_0) do
		var_24_1 = var_24_1[iter_24_1]
	end

	local var_24_2 = {}
	local var_24_3 = StoreLayoutConfig.pages
	local var_24_4 = var_24_3[var_24_0[#var_24_0]]

	if var_24_4.type == "collection_item" then
		local var_24_5 = var_24_4.item_filter
		local var_24_6

		if var_24_5 then
			var_24_6 = arg_24_0:_get_items_by_filter(var_24_5)
		else
			var_24_6 = arg_24_0:_get_all_items()
		end

		for iter_24_2, iter_24_3 in ipairs(var_24_6) do
			local var_24_7 = iter_24_3.data
			local var_24_8 = {
				type = "collection_item",
				display_name = var_24_7.display_name,
				page_name = var_24_7.display_name,
				page = {
					sound_event_enter = "Play_hud_store_category_button",
					layout = "item_list",
					type = "collection_item",
					category_button_texture = "store_category_icon_pactsworn",
					hide_preview_details = true,
					exclusive_filter = true,
					display_name = var_24_7.display_name,
					item_filter = var_24_5 .. " and item_key == " .. var_24_7.key
				},
				product_id = var_24_7.key,
				item = iter_24_3,
				sort_order = Localize(var_24_7.display_name)
			}

			var_24_2[#var_24_2 + 1] = var_24_8
		end
	else
		for iter_24_4, iter_24_5 in pairs(var_24_1) do
			local var_24_9 = var_24_3[iter_24_4]

			if arg_24_0:_valid_category(var_24_9.item_filter) then
				local var_24_10 = {
					display_name = var_24_9.display_name,
					page_name = iter_24_4,
					sort_order = var_24_9.sort_order,
					category_texture = var_24_9.category_button_texture
				}

				var_24_2[#var_24_2 + 1] = var_24_10
			end
		end
	end

	table.sort(var_24_2, var_0_4)
	arg_24_0:_populate_list(var_24_2)

	arg_24_0._layout = var_24_2
	arg_24_0._list_initialized = true
end

StoreWindowCategoryList._valid_category = function (arg_25_0, arg_25_1)
	return #arg_25_0:_get_items_by_filter(arg_25_1) ~= 0
end

StoreWindowCategoryList._on_list_index_pressed = function (arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._layout[arg_26_1]
	local var_26_1 = var_26_0.page_name
	local var_26_2 = arg_26_0._parent
	local var_26_3 = var_26_2:get_store_path()
	local var_26_4 = table.clone(var_26_3)

	var_26_4[#var_26_4 + 1] = var_26_1

	var_26_2:go_to_store_path(var_26_4, nil, var_26_0.page)
end

StoreWindowCategoryList._on_list_index_selected = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0._layout[arg_27_1]

	arg_27_0._params.selected_product = var_27_0

	local var_27_1
	local var_27_2
	local var_27_3 = arg_27_0._list_widgets

	if var_27_3 then
		for iter_27_0, iter_27_1 in ipairs(var_27_3) do
			local var_27_4 = iter_27_1.content
			local var_27_5 = var_27_4.hotspot or var_27_4.button_hotspot

			if var_27_5 then
				local var_27_6 = iter_27_0 == arg_27_1

				var_27_5.is_selected = var_27_6

				if var_27_6 then
					var_27_1 = var_27_4.row
					var_27_2 = var_27_4.column
					var_27_5.on_hover_enter = true
				end
			end
		end
	end

	arg_27_0._previous_gamepad_grid_index = arg_27_0._selected_gamepad_grid_index
	arg_27_0._previous_gamepad_grid_row = arg_27_0._selected_gamepad_grid_row
	arg_27_0._previous_gamepad_grid_column = arg_27_0._selected_gamepad_grid_column
	arg_27_0._selected_gamepad_grid_index = arg_27_1
	arg_27_0._selected_gamepad_grid_row = var_27_1
	arg_27_0._selected_gamepad_grid_column = var_27_2

	if arg_27_2 then
		local var_27_7 = arg_27_0._widgets_by_name.list_scrollbar.content.scroll_bar_info
		local var_27_8 = UIAnimation.function_by_time
		local var_27_9 = var_27_7
		local var_27_10 = "scroll_value"
		local var_27_11 = var_27_7.scroll_value
		local var_27_12 = arg_27_2
		local var_27_13 = 0.3
		local var_27_14 = math.easeOutCubic

		arg_27_0._ui_animations.scrollbar = UIAnimation.init(var_27_8, var_27_9, var_27_10, var_27_11, var_27_12, var_27_13, var_27_14)
	else
		arg_27_0._ui_animations.scrollbar = nil
	end
end

StoreWindowCategoryList._handle_gamepad_grid_selection = function (arg_28_0, arg_28_1)
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
		arg_28_0._params.category_focused = false
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

StoreWindowCategoryList._find_closest_neighbour = function (arg_29_0, arg_29_1, arg_29_2)
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

StoreWindowCategoryList._initialize_scrollbar = function (arg_30_0)
	local var_30_0 = var_0_2.list_window.size
	local var_30_1 = var_0_2.list_scrollbar.size
	local var_30_2 = var_30_0[2]
	local var_30_3 = arg_30_0._total_list_height
	local var_30_4 = var_30_1[2]
	local var_30_5 = 80
	local var_30_6 = 1
	local var_30_7 = arg_30_0._scrollbar_logic

	var_30_7:set_scrollbar_values(var_30_2, var_30_3, var_30_4, var_30_5, var_30_6)
	var_30_7:set_scroll_percentage(0)
end

StoreWindowCategoryList._update_scroll_position = function (arg_31_0)
	local var_31_0 = arg_31_0._scrollbar_logic:get_scrolled_length()

	if var_31_0 ~= arg_31_0._scrolled_length then
		arg_31_0._ui_scenegraph.list.local_position[2] = var_31_0
		arg_31_0._scrolled_length = var_31_0
	end
end

StoreWindowCategoryList._update_visible_list_entries = function (arg_32_0)
	local var_32_0 = arg_32_0._scrollbar_logic

	if not var_32_0:enabled() then
		return true
	end

	local var_32_1 = var_32_0:get_scroll_percentage()
	local var_32_2 = var_32_0:get_scrolled_length()
	local var_32_3 = var_32_0:get_scroll_length()
	local var_32_4 = var_0_2.list_window.size
	local var_32_5 = var_0_5 * 2
	local var_32_6 = var_32_4[2] + var_32_5
	local var_32_7 = arg_32_0._list_widgets
	local var_32_8 = #var_32_7

	for iter_32_0, iter_32_1 in ipairs(var_32_7) do
		local var_32_9 = iter_32_1.offset
		local var_32_10 = iter_32_1.content
		local var_32_11 = var_32_10.size
		local var_32_12 = math.abs(var_32_9[2])
		local var_32_13 = false

		if var_32_12 < var_32_2 - var_32_5 then
			var_32_13 = true
		elseif var_32_6 < math.abs(var_32_9[2] + var_32_11[2]) - var_32_2 then
			var_32_13 = true
		end

		var_32_10.visible = not var_32_13
	end
end

StoreWindowCategoryList._scroll_to_list_index = function (arg_33_0, arg_33_1)
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

StoreWindowCategoryList._get_scrollbar_percentage_by_index = function (arg_34_0, arg_34_1)
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
			local var_34_12 = math.abs(var_34_10[2] + var_34_11)
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
