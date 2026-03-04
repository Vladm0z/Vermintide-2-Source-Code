-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_loadout_inventory.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_inventory_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.generic_input_actions
local var_0_5 = false

HeroWindowLoadoutInventory = class(HeroWindowLoadoutInventory)
HeroWindowLoadoutInventory.NAME = "HeroWindowLoadoutInventory"

local function var_0_6(arg_1_0, arg_1_1)
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

local var_0_7 = {
	melee = Localize("inventory_screen_melee_weapon_title"),
	ranged = Localize("inventory_screen_ranged_weapon_title"),
	necklace = Localize("inventory_screen_necklace_title"),
	trinket = Localize("inventory_screen_trinket_title"),
	ring = Localize("inventory_screen_ring_title")
}

HeroWindowLoadoutInventory.on_enter = function (arg_2_0, arg_2_1, arg_2_2)
	print("[HeroViewWindow] Enter Substate HeroWindowLoadoutInventory")

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
	arg_2_0._categories = arg_2_0:_create_item_categories(arg_2_0.profile_index, arg_2_0.career_index)
	arg_2_0._animations = {}

	arg_2_0:create_ui_elements(arg_2_1, arg_2_2)

	local var_2_3 = ItemGridUI:new(arg_2_0._categories, arg_2_0._widgets_by_name.item_grid, arg_2_0.hero_name, arg_2_0.career_index)

	arg_2_0._item_grid = var_2_3

	var_2_3:mark_equipped_items(true)
	var_2_3:mark_locked_items(true)
	var_2_3:disable_locked_items(true)
	var_2_3:disable_unwieldable_items(true)
	var_2_3:disable_item_drag()
	var_2_3:apply_item_sorting_function(var_0_6)

	local var_2_4 = var_2_2 and var_2_2.player_unit

	if var_2_4 then
		local var_2_5 = ScriptUnit.has_extension(var_2_4, "inventory_system")

		if var_2_5 then
			var_2_5:check_and_drop_pickups("enter_inventory")
		end
	end
end

HeroWindowLoadoutInventory._create_item_categories = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.career_index
	local var_3_1 = arg_3_0.profile_index
	local var_3_2 = SPProfiles[var_3_1].careers[var_3_0].item_slot_types_by_slot_name
	local var_3_3 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_2) do
		local var_3_4 = InventorySettings.slots_by_name[iter_3_0].ui_slot_index

		if var_3_4 then
			local var_3_5 = "( "
			local var_3_6 = ""
			local var_3_7
			local var_3_8 = {}

			for iter_3_2, iter_3_3 in ipairs(iter_3_1) do
				local var_3_9 = var_0_7[iter_3_3]

				var_3_6 = var_3_6 .. var_3_9
				var_3_5 = var_3_5 .. "slot_type == " .. iter_3_3

				if iter_3_2 < #iter_3_1 then
					var_3_6 = var_3_6 .. " - "
					var_3_5 = var_3_5 .. " or "
				else
					var_3_5 = var_3_5 .. " ) and item_rarity ~= magic"
				end

				for iter_3_4, iter_3_5 in pairs(UISettings.slot_icons) do
					if string.find(iter_3_4, iter_3_3) then
						var_3_8[iter_3_4] = iter_3_5
					end
				end
			end

			for iter_3_6, iter_3_7 in pairs(var_3_8) do
				local var_3_10 = true

				for iter_3_8, iter_3_9 in ipairs(iter_3_1) do
					if not string.find(iter_3_6, iter_3_9) then
						var_3_10 = false

						break
					end
				end

				if var_3_10 then
					var_3_7 = iter_3_7

					break
				end
			end

			var_3_3[var_3_4] = {
				hero_specific_filter = true,
				name = iter_3_0,
				display_name = var_3_6,
				icon = var_3_7,
				item_types = iter_3_1,
				slot_index = var_3_4,
				slot_name = iter_3_0,
				item_filter = var_3_5
			}
		end
	end

	return var_3_3
end

HeroWindowLoadoutInventory.create_ui_elements = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_3)

	if arg_4_2 then
		local var_4_3 = arg_4_0.ui_scenegraph.window.local_position

		var_4_3[1] = var_4_3[1] + arg_4_2[1]
		var_4_3[2] = var_4_3[2] + arg_4_2[2]
		var_4_3[3] = var_4_3[3] + arg_4_2[3]
	end

	arg_4_0:_setup_tab_widget()
end

HeroWindowLoadoutInventory._setup_tab_widget = function (arg_5_0)
	local var_5_0 = arg_5_0._categories
	local var_5_1 = #var_5_0
	local var_5_2 = arg_5_0._widgets
	local var_5_3 = arg_5_0._widgets_by_name
	local var_5_4 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_vertical", {
		5,
		35
	}, "item_tabs_segments", var_5_1 - 1))
	local var_5_5 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_top", {
		17,
		9
	}, "item_tabs_segments_top", var_5_1 - 1))
	local var_5_6 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_bottom", {
		17,
		9
	}, "item_tabs_segments_bottom", var_5_1 - 1))

	var_5_3.item_tabs_segments = var_5_4
	var_5_3.item_tabs_segments_top = var_5_5
	var_5_3.item_tabs_segments_bottom = var_5_6
	var_5_2[#var_5_2 + 1] = var_5_4
	var_5_2[#var_5_2 + 1] = var_5_5
	var_5_2[#var_5_2 + 1] = var_5_6

	local var_5_7 = "item_tabs"
	local var_5_8 = var_0_2.item_tabs.size
	local var_5_9 = UIWidgets.create_default_icon_tabs(var_5_7, var_5_8, var_5_1)
	local var_5_10 = UIWidget.init(var_5_9)

	var_5_3[var_5_7] = var_5_10
	var_5_2[#var_5_2 + 1] = var_5_10

	local var_5_11 = var_5_10.content

	for iter_5_0, iter_5_1 in ipairs(var_5_0) do
		local var_5_12 = "_" .. tostring(iter_5_0)
		local var_5_13 = "hotspot" .. var_5_12
		local var_5_14 = "icon" .. var_5_12
		local var_5_15 = var_5_11[var_5_13]

		var_5_15.slot_index, var_5_15[var_5_14] = iter_5_1.slot_index, iter_5_1.icon
	end
end

HeroWindowLoadoutInventory.on_exit = function (arg_6_0, arg_6_1)
	print("[HeroViewWindow] Exit Substate HeroWindowLoadoutInventory")

	arg_6_0.ui_animator = nil

	arg_6_0._item_grid:destroy()

	arg_6_0._item_grid = nil
end

HeroWindowLoadoutInventory.update = function (arg_7_0, arg_7_1, arg_7_2)
	if var_0_5 then
		var_0_5 = false

		arg_7_0:create_ui_elements()
	end

	arg_7_0._item_grid:update(arg_7_1, arg_7_2)
	arg_7_0:_update_animations(arg_7_1)
	arg_7_0:_handle_input(arg_7_1, arg_7_2)
	arg_7_0:_update_selected_loadout_slot_index()
	arg_7_0:_update_loadout_sync()
	arg_7_0:_update_page_info()
	arg_7_0:draw(arg_7_1)
end

HeroWindowLoadoutInventory.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	return
end

HeroWindowLoadoutInventory._update_animations = function (arg_9_0, arg_9_1)
	arg_9_0.ui_animator:update(arg_9_1)

	local var_9_0 = arg_9_0._animations
	local var_9_1 = arg_9_0.ui_animator

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if var_9_1:is_animation_completed(iter_9_1) then
			var_9_1:stop_animation(iter_9_1)

			var_9_0[iter_9_0] = nil
		end
	end

	local var_9_2 = arg_9_0._widgets_by_name
end

HeroWindowLoadoutInventory._is_button_pressed = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.on_release then
		var_10_0.on_release = false

		return true
	end
end

HeroWindowLoadoutInventory._is_button_hovered = function (arg_11_0, arg_11_1)
	if arg_11_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowLoadoutInventory._is_inventory_tab_hovered = function (arg_12_0)
	local var_12_0 = arg_12_0._widgets_by_name.item_tabs.content
	local var_12_1 = var_12_0.amount

	for iter_12_0 = 1, var_12_1 do
		local var_12_2 = "_" .. tostring(iter_12_0)

		if var_12_0["hotspot" .. var_12_2].on_hover_enter then
			return iter_12_0
		end
	end
end

HeroWindowLoadoutInventory._is_inventory_tab_pressed = function (arg_13_0)
	local var_13_0 = arg_13_0._widgets_by_name.item_tabs.content
	local var_13_1 = var_13_0.amount

	for iter_13_0 = 1, var_13_1 do
		local var_13_2 = "_" .. tostring(iter_13_0)
		local var_13_3 = var_13_0["hotspot" .. var_13_2]

		if var_13_3.on_release and not var_13_3.is_selected then
			return iter_13_0
		end
	end
end

HeroWindowLoadoutInventory._select_tab_by_slot_index = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._widgets_by_name.item_tabs.content
	local var_14_1 = var_14_0.amount

	for iter_14_0 = 1, var_14_1 do
		local var_14_2 = "_" .. tostring(iter_14_0)
		local var_14_3 = var_14_0["hotspot" .. var_14_2]

		var_14_3.is_selected = arg_14_1 == var_14_3.slot_index
	end
end

HeroWindowLoadoutInventory._handle_input = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._widgets_by_name
	local var_15_1 = arg_15_0.parent
	local var_15_2 = arg_15_0._item_grid
	local var_15_3 = false
	local var_15_4, var_15_5 = var_15_2:is_item_pressed(var_15_3)
	local var_15_6 = var_15_1:window_input_service()

	if var_15_2:handle_favorite_marking(var_15_6) then
		arg_15_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_15_2:is_item_hovered() then
		arg_15_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_15_4 and not var_15_5 then
		var_15_1:_set_loadout_item(var_15_4, arg_15_0._strict_slot_name)
		arg_15_0:_play_sound("play_gui_equipment_equip_hero")
	end

	local var_15_7 = var_15_0.item_tabs

	UIWidgetUtils.animate_default_icon_tabs(var_15_7, arg_15_1)

	if arg_15_0:_is_inventory_tab_hovered() then
		arg_15_0:_play_sound("play_gui_inventory_tab_hover")
	end

	local var_15_8 = arg_15_0:_is_inventory_tab_pressed()

	if var_15_8 and var_15_8 ~= arg_15_0._category_index then
		local var_15_9 = arg_15_0:_get_category_slot_index(var_15_8)

		var_15_1:set_selected_loadout_slot_index(var_15_9)
		arg_15_0:_play_sound("play_gui_inventory_tab_click")
	elseif Managers.input:is_device_active("gamepad") then
		local var_15_10 = Managers.input:get_service("hero_view")
		local var_15_11 = var_15_1._selected_loadout_slot_index or 1
		local var_15_12 = #arg_15_0._categories

		if var_15_10:get("cycle_previous") and var_15_11 > 1 then
			var_15_1:set_selected_loadout_slot_index(var_15_11 - 1)
			arg_15_0:_play_sound("play_gui_inventory_tab_click")
		elseif var_15_10:get("cycle_next") and var_15_11 < var_15_12 then
			var_15_1:set_selected_loadout_slot_index(var_15_11 + 1)
			arg_15_0:_play_sound("play_gui_inventory_tab_click")
		end
	end

	local var_15_13 = var_15_0.page_button_next
	local var_15_14 = var_15_0.page_button_previous

	UIWidgetUtils.animate_default_button(var_15_13, arg_15_1)
	UIWidgetUtils.animate_default_button(var_15_14, arg_15_1)

	if arg_15_0:_is_button_hovered(var_15_13) or arg_15_0:_is_button_hovered(var_15_14) then
		arg_15_0:_play_sound("play_gui_inventory_next_hover")
	end

	if arg_15_0:_is_button_pressed(var_15_13) then
		local var_15_15 = arg_15_0._current_page + 1

		var_15_2:set_item_page(var_15_15)
		arg_15_0:_play_sound("play_gui_equipment_inventory_next_click")
	elseif arg_15_0:_is_button_pressed(var_15_14) then
		local var_15_16 = arg_15_0._current_page - 1

		var_15_2:set_item_page(var_15_16)
		arg_15_0:_play_sound("play_gui_equipment_inventory_next_click")
	end
end

HeroWindowLoadoutInventory._update_page_info = function (arg_16_0)
	local var_16_0, var_16_1 = arg_16_0._item_grid:get_page_info()

	if var_16_0 ~= arg_16_0._current_page or var_16_1 ~= arg_16_0._total_pages then
		arg_16_0._total_pages = var_16_1
		arg_16_0._current_page = var_16_0
		var_16_0 = var_16_0 or 1
		var_16_1 = var_16_1 or 1

		local var_16_2 = arg_16_0._widgets_by_name

		var_16_2.page_text_left.content.text = tostring(var_16_0)
		var_16_2.page_text_right.content.text = tostring(var_16_1)
		var_16_2.page_button_next.content.button_hotspot.disable_button = var_16_0 == var_16_1
		var_16_2.page_button_previous.content.button_hotspot.disable_button = var_16_0 == 1
	end
end

HeroWindowLoadoutInventory._get_category_slot_index = function (arg_17_0, arg_17_1)
	return arg_17_0._categories[arg_17_1].slot_index
end

HeroWindowLoadoutInventory._get_category_index_by_slot_index = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._categories

	for iter_18_0, iter_18_1 in ipairs(var_18_0) do
		if iter_18_1.slot_index == arg_18_1 then
			return iter_18_0
		end
	end
end

HeroWindowLoadoutInventory._update_selected_loadout_slot_index = function (arg_19_0)
	local var_19_0 = arg_19_0.parent:get_selected_loadout_slot_index()
	local var_19_1 = arg_19_0:_get_category_index_by_slot_index(var_19_0)

	if var_19_0 ~= arg_19_0._selected_loadout_slot_index then
		arg_19_0:_change_category_by_index(var_19_1)

		arg_19_0._selected_loadout_slot_index = var_19_0
		arg_19_0._category_index = var_19_1
	end
end

HeroWindowLoadoutInventory._update_loadout_sync = function (arg_20_0)
	local var_20_0 = arg_20_0._item_grid
	local var_20_1 = arg_20_0.parent.loadout_sync_id

	if var_20_1 ~= arg_20_0._loadout_sync_id then
		arg_20_0._loadout_sync_id = var_20_1

		var_20_0:update_items_status()
	end
end

HeroWindowLoadoutInventory._exit = function (arg_21_0, arg_21_1)
	arg_21_0.exit = true
	arg_21_0.exit_level_id = arg_21_1
end

HeroWindowLoadoutInventory.draw = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.ui_renderer
	local var_22_1 = arg_22_0.ui_top_renderer
	local var_22_2 = arg_22_0.ui_scenegraph
	local var_22_3 = arg_22_0.parent:window_input_service()
	local var_22_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_22_1, var_22_2, var_22_3, arg_22_1, nil, arg_22_0.render_settings)

	for iter_22_0, iter_22_1 in ipairs(arg_22_0._widgets) do
		UIRenderer.draw_widget(var_22_1, iter_22_1)
	end

	UIRenderer.end_pass(var_22_1)
end

HeroWindowLoadoutInventory._play_sound = function (arg_23_0, arg_23_1)
	arg_23_0.parent:play_sound(arg_23_1)
end

HeroWindowLoadoutInventory._change_category_by_index = function (arg_24_0, arg_24_1)
	arg_24_0:_select_tab_by_slot_index(arg_24_1)

	local var_24_0 = arg_24_0._categories[arg_24_1]

	arg_24_0._strict_slot_name = var_24_0.slot_name

	local var_24_1 = var_24_0.name
	local var_24_2 = var_24_0.display_name

	arg_24_0._widgets_by_name.item_grid_header.content.text = var_24_2

	arg_24_0._item_grid:change_category(var_24_1)

	return true
end
