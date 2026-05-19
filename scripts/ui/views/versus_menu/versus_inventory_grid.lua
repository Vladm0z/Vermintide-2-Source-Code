-- chunkname: @scripts/ui/views/versus_menu/versus_inventory_grid.lua

local var_0_0 = local_require("scripts/ui/views/versus_menu/versus_inventory_grid_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.generic_input_actions
local var_0_5 = false

VersusInventoryGrid = class(VersusInventoryGrid)
VersusInventoryGrid.NAME = "VersusInventoryGrid"

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

function VersusInventoryGrid._create_item_categories(arg_2_0)
	local var_2_0 = arg_2_0.career_index
	local var_2_1 = arg_2_0.profile_index
	local var_2_2 = SPProfiles[var_2_1].careers[var_2_0].item_slot_types_by_slot_name
	local var_2_3 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_2) do
		local var_2_4 = InventorySettings.slots_by_name[iter_2_0].ui_slot_index

		if var_2_4 then
			local var_2_5 = "( "
			local var_2_6 = ""
			local var_2_7
			local var_2_8 = {}

			for iter_2_2, iter_2_3 in ipairs(iter_2_1) do
				local var_2_9 = var_0_7[iter_2_3]

				var_2_6 = var_2_6 .. var_2_9
				var_2_5 = var_2_5 .. "slot_type == " .. iter_2_3

				if iter_2_2 < #iter_2_1 then
					var_2_6 = var_2_6 .. " - "
					var_2_5 = var_2_5 .. " or "
				else
					var_2_5 = var_2_5 .. " ) and item_rarity ~= magic"
				end

				for iter_2_4, iter_2_5 in pairs(UISettings.slot_icons) do
					if string.find(iter_2_4, iter_2_3) then
						var_2_8[iter_2_4] = iter_2_5
					end
				end
			end

			for iter_2_6, iter_2_7 in pairs(var_2_8) do
				local var_2_10 = true

				for iter_2_8, iter_2_9 in ipairs(iter_2_1) do
					if not string.find(iter_2_6, iter_2_9) then
						var_2_10 = false

						break
					end
				end

				if var_2_10 then
					var_2_7 = iter_2_7

					break
				end
			end

			var_2_3[var_2_4] = {
				hero_specific_filter = true,
				name = iter_2_0,
				display_name = var_2_6,
				icon = var_2_7,
				item_types = iter_2_1,
				slot_index = var_2_4,
				slot_name = iter_2_0,
				item_filter = var_2_5
			}
		end
	end

	return var_2_3
end

function VersusInventoryGrid.on_enter(arg_3_0, arg_3_1, arg_3_2)
	print("[HeroViewWindow] Enter Substate VersusInventoryGrid")

	arg_3_0.parent = arg_3_1.parent

	local var_3_0 = arg_3_1.ingame_ui_context

	arg_3_0.ui_renderer = var_3_0.ui_renderer
	arg_3_0.ui_top_renderer = var_3_0.ui_top_renderer
	arg_3_0.input_manager = var_3_0.input_manager
	arg_3_0.statistics_db = var_3_0.statistics_db
	arg_3_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_3_1 = Managers.player
	local var_3_2 = var_3_1:local_player()

	arg_3_0._stats_id = var_3_2:stats_id()
	arg_3_0.player_manager = var_3_1
	arg_3_0.peer_id = var_3_0.peer_id
	arg_3_0.hero_name = arg_3_1.hero_name
	arg_3_0.career_index = arg_3_1.career_index
	arg_3_0.profile_index = arg_3_1.profile_index
	arg_3_0._category_settings = arg_3_0:_create_item_categories()
	arg_3_0._animations = {}

	arg_3_0:create_ui_elements(arg_3_1, arg_3_2)

	local var_3_3 = ItemGridUI:new(arg_3_0._category_settings, arg_3_0._widgets_by_name.item_grid, arg_3_0.hero_name, arg_3_0.career_index)

	arg_3_0._item_grid = var_3_3

	var_3_3:mark_equipped_items(true)
	var_3_3:mark_locked_items(true)
	var_3_3:disable_locked_items(true)
	var_3_3:disable_unwieldable_items(true)
	var_3_3:disable_item_drag()
	var_3_3:apply_item_sorting_function(var_0_6)

	local var_3_4 = var_3_2 and var_3_2.player_unit

	if var_3_4 then
		local var_3_5 = ScriptUnit.has_extension(var_3_4, "inventory_system")

		if var_3_5 then
			var_3_5:check_and_drop_pickups("enter_inventory")
		end
	end

	arg_3_0._selected_loadout_slot_index = arg_3_1.loadout_slot_index or 1

	arg_3_0:_change_category_by_index(arg_3_0._selected_loadout_slot_index)

	arg_3_0._job_done = false
end

function VersusInventoryGrid.create_ui_elements(arg_4_0, arg_4_1, arg_4_2)
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

function VersusInventoryGrid._setup_tab_widget(arg_5_0)
	local var_5_0 = SPProfiles[arg_5_0.profile_index].careers[arg_5_0.career_index].item_slot_types_by_slot_name
	local var_5_1 = {}
	local var_5_2 = {}

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		for iter_5_2, iter_5_3 in ipairs(iter_5_1) do
			for iter_5_4, iter_5_5 in ipairs(arg_5_0._category_settings) do
				if "slot_" .. iter_5_3 == iter_5_5.name then
					var_5_2[iter_5_4] = true
					var_5_1[iter_5_4] = iter_5_4

					break
				end
			end
		end
	end

	local var_5_3 = 0
	local var_5_4 = {}

	for iter_5_6, iter_5_7 in pairs(var_5_2) do
		var_5_3 = var_5_3 + 1
		var_5_4[#var_5_4 + 1] = iter_5_6
	end

	local function var_5_5(arg_6_0, arg_6_1)
		return arg_6_0 < arg_6_1
	end

	table.sort(var_5_4, var_5_5)

	arg_5_0._tabs_category_index_lookups = var_5_4
	arg_5_0._career_category_settings_index_lookup = var_5_1

	local var_5_6 = arg_5_0._widgets
	local var_5_7 = arg_5_0._widgets_by_name
	local var_5_8 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_vertical", {
		5,
		35
	}, "item_tabs_segments", var_5_3 - 1))
	local var_5_9 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_top", {
		17,
		9
	}, "item_tabs_segments_top", var_5_3 - 1))
	local var_5_10 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_bottom", {
		17,
		9
	}, "item_tabs_segments_bottom", var_5_3 - 1))

	var_5_7.item_tabs_segments = var_5_8
	var_5_7.item_tabs_segments_top = var_5_9
	var_5_7.item_tabs_segments_bottom = var_5_10
	var_5_6[#var_5_6 + 1] = var_5_8
	var_5_6[#var_5_6 + 1] = var_5_9
	var_5_6[#var_5_6 + 1] = var_5_10
end

function VersusInventoryGrid.on_exit(arg_7_0, arg_7_1)
	print("[HeroViewWindow] Exit Substate VersusInventoryGrid")

	arg_7_0.ui_animator = nil

	arg_7_0._item_grid:destroy()

	arg_7_0._item_grid = nil
end

function VersusInventoryGrid.update(arg_8_0, arg_8_1, arg_8_2)
	if var_0_5 then
		var_0_5 = false

		arg_8_0:create_ui_elements()
	end

	arg_8_0._item_grid:update(arg_8_1, arg_8_2)
	arg_8_0:_update_animations(arg_8_1)
	arg_8_0:_handle_input(arg_8_1, arg_8_2)
	arg_8_0:_update_page_info()
	arg_8_0:draw(arg_8_1)

	return arg_8_0._job_done
end

function VersusInventoryGrid.post_update(arg_9_0, arg_9_1, arg_9_2)
	return
end

function VersusInventoryGrid._update_animations(arg_10_0, arg_10_1)
	arg_10_0.ui_animator:update(arg_10_1)

	local var_10_0 = arg_10_0._animations
	local var_10_1 = arg_10_0.ui_animator

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if var_10_1:is_animation_completed(iter_10_1) then
			var_10_1:stop_animation(iter_10_1)

			var_10_0[iter_10_0] = nil
		end
	end

	local var_10_2 = arg_10_0._widgets_by_name
end

function VersusInventoryGrid._is_button_pressed(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	if var_11_0.on_release then
		var_11_0.on_release = false

		return true
	end
end

function VersusInventoryGrid._is_button_hovered(arg_12_0, arg_12_1)
	if arg_12_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

function VersusInventoryGrid._handle_input(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._widgets_by_name
	local var_13_1 = arg_13_0.parent
	local var_13_2 = arg_13_0._item_grid
	local var_13_3 = false
	local var_13_4, var_13_5 = var_13_2:is_item_pressed(var_13_3)
	local var_13_6 = var_13_1:window_input_service()

	if var_13_2:handle_favorite_marking(var_13_6) then
		arg_13_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_13_2:is_item_hovered() then
		arg_13_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_13_4 then
		arg_13_0:_set_loadout_item(var_13_4, arg_13_0._strict_slot_type)
		arg_13_0:_play_sound("play_gui_equipment_equip_hero")
	end

	if var_13_4 and var_13_5 or var_13_6:get("toggle_menu") then
		arg_13_0._job_done = true
	end

	if Managers.input:is_device_active("gamepad") then
		local var_13_7 = Managers.input:get_service("hero_view")
		local var_13_8 = var_13_1._selected_loadout_slot_index or 1
		local var_13_9 = #arg_13_0._career_category_settings_index_lookup

		if var_13_7:get("cycle_previous") and var_13_8 > 1 then
			var_13_1:set_selected_loadout_slot_index(var_13_8 - 1)
			arg_13_0:_play_sound("play_gui_inventory_tab_click")
		elseif var_13_7:get("cycle_next") and var_13_8 < var_13_9 then
			var_13_1:set_selected_loadout_slot_index(var_13_8 + 1)
			arg_13_0:_play_sound("play_gui_inventory_tab_click")
		end
	end

	local var_13_10 = var_13_0.page_button_next
	local var_13_11 = var_13_0.page_button_previous

	UIWidgetUtils.animate_default_button(var_13_10, arg_13_1)
	UIWidgetUtils.animate_default_button(var_13_11, arg_13_1)

	if arg_13_0:_is_button_hovered(var_13_10) or arg_13_0:_is_button_hovered(var_13_11) then
		arg_13_0:_play_sound("play_gui_inventory_next_hover")
	end

	if arg_13_0:_is_button_pressed(var_13_10) then
		local var_13_12 = arg_13_0._current_page + 1

		var_13_2:set_item_page(var_13_12)
		arg_13_0:_play_sound("play_gui_equipment_inventory_next_click")
	elseif arg_13_0:_is_button_pressed(var_13_11) then
		local var_13_13 = arg_13_0._current_page - 1

		var_13_2:set_item_page(var_13_13)
		arg_13_0:_play_sound("play_gui_equipment_inventory_next_click")
	end
end

function VersusInventoryGrid._update_page_info(arg_14_0)
	local var_14_0, var_14_1 = arg_14_0._item_grid:get_page_info()

	if var_14_0 ~= arg_14_0._current_page or var_14_1 ~= arg_14_0._total_pages then
		arg_14_0._total_pages = var_14_1
		arg_14_0._current_page = var_14_0
		var_14_0 = var_14_0 or 1
		var_14_1 = var_14_1 or 1

		local var_14_2 = arg_14_0._widgets_by_name

		var_14_2.page_text_left.content.text = tostring(var_14_0)
		var_14_2.page_text_right.content.text = tostring(var_14_1)
		var_14_2.page_button_next.content.button_hotspot.disable_button = var_14_0 == var_14_1
		var_14_2.page_button_previous.content.button_hotspot.disable_button = var_14_0 == 1
	end
end

function VersusInventoryGrid._get_actual_loadout_category_index(arg_15_0, arg_15_1)
	return arg_15_0._career_category_settings_index_lookup[arg_15_1]
end

function VersusInventoryGrid._update_selected_loadout_slot_index(arg_16_0)
	local var_16_0 = arg_16_0.parent:get_selected_loadout_slot_index()
	local var_16_1 = arg_16_0._career_category_settings_index_lookup[var_16_0]

	if var_16_0 ~= arg_16_0._selected_loadout_slot_index then
		arg_16_0:_change_category_by_index(var_16_0)

		arg_16_0._selected_loadout_slot_index = var_16_0
		arg_16_0._internal_slot_index = var_16_1
	end
end

function VersusInventoryGrid._update_loadout_sync(arg_17_0)
	local var_17_0 = arg_17_0._item_grid
	local var_17_1 = arg_17_0.parent.loadout_sync_id

	if var_17_1 ~= arg_17_0._loadout_sync_id then
		arg_17_0._loadout_sync_id = var_17_1

		var_17_0:update_items_status()
	end
end

function VersusInventoryGrid._exit(arg_18_0, arg_18_1)
	arg_18_0.exit = true
	arg_18_0.exit_level_id = arg_18_1
end

function VersusInventoryGrid.draw(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.ui_top_renderer
	local var_19_1 = arg_19_0.ui_scenegraph
	local var_19_2 = arg_19_0.parent:window_input_service()

	UIRenderer.begin_pass(var_19_0, var_19_1, var_19_2, arg_19_1, nil, arg_19_0.render_settings)

	for iter_19_0, iter_19_1 in ipairs(arg_19_0._widgets) do
		UIRenderer.draw_widget(var_19_0, iter_19_1)
	end

	local var_19_3 = arg_19_0._active_node_widgets

	if var_19_3 then
		for iter_19_2, iter_19_3 in ipairs(var_19_3) do
			UIRenderer.draw_widget(var_19_0, iter_19_3)
		end
	end

	UIRenderer.end_pass(var_19_0)
end

function VersusInventoryGrid._play_sound(arg_20_0, arg_20_1)
	arg_20_0.parent:play_sound(arg_20_1)
end

function VersusInventoryGrid._change_category_by_index(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._career_category_settings_index_lookup[arg_21_1]

	if arg_21_2 then
		arg_21_1 = arg_21_0._internal_slot_index or 1
	end

	arg_21_0._strict_slot_type = arg_21_0._category_settings[arg_21_1].name

	if arg_21_0._internal_slot_index == var_21_0 then
		return
	end

	local var_21_1 = arg_21_0._category_settings[var_21_0]
	local var_21_2 = var_21_1.name
	local var_21_3 = var_21_1.display_name

	arg_21_0._widgets_by_name.item_grid_header.content.text = var_21_3

	arg_21_0._item_grid:change_category(var_21_2)

	return true
end

function VersusInventoryGrid._get_slot_by_type(arg_22_0, arg_22_1)
	local var_22_0 = InventorySettings.slots_by_slot_index

	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		if arg_22_1 == "slot_" .. iter_22_1.type then
			return iter_22_1
		end
	end
end

function VersusInventoryGrid._set_loadout_item(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.profile_index
	local var_23_1 = arg_23_0.career_index
	local var_23_2 = SPProfiles[var_23_0].careers[var_23_1]
	local var_23_3 = arg_23_1.data
	local var_23_4 = arg_23_2 or var_23_3.slot_type
	local var_23_5 = arg_23_0:_get_slot_by_type(var_23_4)
	local var_23_6 = arg_23_1.backend_id
	local var_23_7 = var_23_2.name
	local var_23_8 = var_23_5.name

	Managers.backend:get_interface("items"):set_loadout_item(var_23_6, var_23_7, var_23_8)
	arg_23_0.parent:new_item_equipped()

	arg_23_0._job_done = true
end
