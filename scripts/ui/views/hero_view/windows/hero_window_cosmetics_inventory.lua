-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_inventory.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_inventory_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.category_settings
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.generic_input_actions
local var_0_6 = false

local function var_0_7(arg_1_0, arg_1_1)
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

local var_0_8 = script_data.testify and require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_inventory_testify")

HeroWindowCosmeticsInventory = class(HeroWindowCosmeticsInventory)
HeroWindowCosmeticsInventory.NAME = "HeroWindowCosmeticsInventory"

function HeroWindowCosmeticsInventory.on_enter(arg_2_0, arg_2_1, arg_2_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsInventory")

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

	arg_2_0._stats_id = var_2_1:local_player():stats_id()
	arg_2_0.player_manager = var_2_1
	arg_2_0.peer_id = var_2_0.peer_id
	arg_2_0._animations = {}

	arg_2_0:create_ui_elements(arg_2_1, arg_2_2)

	arg_2_0.hero_name = arg_2_1.hero_name
	arg_2_0.career_index = arg_2_1.career_index
	arg_2_0.profile_index = arg_2_1.profile_index

	local var_2_2 = ItemGridUI:new(var_0_2, arg_2_0._widgets_by_name.item_grid, arg_2_0.hero_name, arg_2_0.career_index)

	arg_2_0._item_grid = var_2_2

	var_2_2:mark_equipped_items(true)
	var_2_2:mark_locked_items(true)
	var_2_2:disable_locked_items(true)
	var_2_2:disable_item_drag()
	var_2_2:apply_item_sorting_function(var_0_7)
end

function HeroWindowCosmeticsInventory.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_4)

	if arg_3_2 then
		local var_3_3 = arg_3_0.ui_scenegraph.window.local_position

		var_3_3[1] = var_3_3[1] + arg_3_2[1]
		var_3_3[2] = var_3_3[2] + arg_3_2[2]
		var_3_3[3] = var_3_3[3] + arg_3_2[3]
	end

	arg_3_0:_assign_tab_icons()
end

function HeroWindowCosmeticsInventory._assign_tab_icons(arg_4_0)
	local var_4_0 = arg_4_0._widgets_by_name.item_tabs.content
	local var_4_1 = var_4_0.amount

	for iter_4_0 = 1, var_4_1 do
		local var_4_2 = "_" .. tostring(iter_4_0)
		local var_4_3 = "hotspot" .. var_4_2
		local var_4_4 = "icon" .. var_4_2

		var_4_0[var_4_3][var_4_4] = var_0_2[iter_4_0].icon
	end
end

function HeroWindowCosmeticsInventory.on_exit(arg_5_0, arg_5_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsInventory")

	arg_5_0.ui_animator = nil

	arg_5_0._item_grid:destroy()

	arg_5_0._item_grid = nil
end

function HeroWindowCosmeticsInventory.update(arg_6_0, arg_6_1, arg_6_2)
	if var_0_6 then
		var_0_6 = false

		arg_6_0:create_ui_elements()
	end

	arg_6_0._item_grid:update(arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_update_selected_cosmetic_slot_index()
	arg_6_0:_update_loadout_sync()
	arg_6_0:_update_page_info()
	arg_6_0:draw(arg_6_1)

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_8, arg_6_0)
	end
end

function HeroWindowCosmeticsInventory.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function HeroWindowCosmeticsInventory._update_animations(arg_8_0, arg_8_1)
	arg_8_0.ui_animator:update(arg_8_1)

	local var_8_0 = arg_8_0._animations
	local var_8_1 = arg_8_0.ui_animator

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if var_8_1:is_animation_completed(iter_8_1) then
			var_8_1:stop_animation(iter_8_1)

			var_8_0[iter_8_0] = nil
		end
	end

	local var_8_2 = arg_8_0._widgets_by_name
end

function HeroWindowCosmeticsInventory._is_button_pressed(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.on_release then
		var_9_0.on_release = false

		return true
	end
end

function HeroWindowCosmeticsInventory._is_button_hovered(arg_10_0, arg_10_1)
	if arg_10_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

function HeroWindowCosmeticsInventory._is_inventory_tab_hovered(arg_11_0)
	local var_11_0 = arg_11_0._widgets_by_name.item_tabs.content
	local var_11_1 = var_11_0.amount

	for iter_11_0 = 1, var_11_1 do
		local var_11_2 = "_" .. tostring(iter_11_0)

		if var_11_0["hotspot" .. var_11_2].on_hover_enter then
			return iter_11_0
		end
	end
end

function HeroWindowCosmeticsInventory._is_inventory_tab_pressed(arg_12_0)
	local var_12_0 = arg_12_0._widgets_by_name.item_tabs.content
	local var_12_1 = var_12_0.amount

	for iter_12_0 = 1, var_12_1 do
		local var_12_2 = "_" .. tostring(iter_12_0)
		local var_12_3 = var_12_0["hotspot" .. var_12_2]

		if var_12_3.on_release and not var_12_3.is_selected then
			return iter_12_0
		end
	end
end

function HeroWindowCosmeticsInventory._select_tab_by_category_index(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._widgets_by_name.item_tabs.content
	local var_13_1 = var_13_0.amount

	for iter_13_0 = 1, var_13_1 do
		local var_13_2 = "_" .. tostring(iter_13_0)

		var_13_0["hotspot" .. var_13_2].is_selected = iter_13_0 == arg_13_1
	end
end

function HeroWindowCosmeticsInventory._handle_input(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._widgets_by_name
	local var_14_1 = arg_14_0.parent
	local var_14_2 = arg_14_0._item_grid
	local var_14_3 = false
	local var_14_4, var_14_5 = var_14_2:is_item_pressed(var_14_3)
	local var_14_6 = var_14_1:window_input_service()

	if var_14_2:handle_favorite_marking(var_14_6) then
		arg_14_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_14_2:is_item_hovered() then
		arg_14_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_14_4 and not var_14_5 then
		var_14_1:_set_loadout_item(var_14_4)
		arg_14_0:_play_sound("play_gui_equipment_equip_hero")

		if var_14_4.data.slot_type == "skin" then
			var_14_1:update_skin_sync()
		end
	end

	local var_14_7 = var_14_0.item_tabs

	UIWidgetUtils.animate_default_icon_tabs(var_14_7, arg_14_1)

	if arg_14_0:_is_inventory_tab_hovered() then
		arg_14_0:_play_sound("play_gui_inventory_tab_hover")
	end

	local var_14_8 = arg_14_0:_is_inventory_tab_pressed()

	if var_14_8 and var_14_8 ~= arg_14_0._selected_cosmetic_slot_index then
		var_14_1:set_selected_cosmetic_slot_index(var_14_8)
		arg_14_0:_play_sound("play_gui_inventory_tab_click")
	elseif Managers.input:is_device_active("gamepad") then
		local var_14_9 = Managers.input:get_service("hero_view")
		local var_14_10 = arg_14_0._widgets_by_name.item_tabs.content.amount
		local var_14_11 = var_14_1._selected_cosmetic_slot_index or 1

		if var_14_9:get("cycle_previous") and var_14_11 > 1 then
			var_14_1:set_selected_cosmetic_slot_index(var_14_11 - 1)
			arg_14_0:_play_sound("play_gui_cosmetics_selection_click")
		elseif var_14_9:get("cycle_next") and var_14_11 < var_14_10 then
			var_14_1:set_selected_cosmetic_slot_index(var_14_11 + 1)
			arg_14_0:_play_sound("play_gui_cosmetics_selection_click")
		end
	end

	local var_14_12 = var_14_0.page_button_next
	local var_14_13 = var_14_0.page_button_previous

	UIWidgetUtils.animate_default_button(var_14_12, arg_14_1)
	UIWidgetUtils.animate_default_button(var_14_13, arg_14_1)

	if arg_14_0:_is_button_hovered(var_14_12) or arg_14_0:_is_button_hovered(var_14_13) then
		arg_14_0:_play_sound("play_gui_inventory_next_hover")
	end

	if arg_14_0:_is_button_pressed(var_14_12) then
		local var_14_14 = arg_14_0._current_page + 1

		var_14_2:set_item_page(var_14_14)
		arg_14_0:_play_sound("play_gui_cosmetics_inventory_next_click")
	elseif arg_14_0:_is_button_pressed(var_14_13) then
		local var_14_15 = arg_14_0._current_page - 1

		var_14_2:set_item_page(var_14_15)
		arg_14_0:_play_sound("play_gui_cosmetics_inventory_next_click")
	end
end

function HeroWindowCosmeticsInventory._update_page_info(arg_15_0)
	local var_15_0, var_15_1 = arg_15_0._item_grid:get_page_info()

	if var_15_0 ~= arg_15_0._current_page or var_15_1 ~= arg_15_0._total_pages then
		arg_15_0._total_pages = var_15_1
		arg_15_0._current_page = var_15_0
		var_15_0 = var_15_0 or 1
		var_15_1 = var_15_1 or 1

		local var_15_2 = arg_15_0._widgets_by_name

		var_15_2.page_text_left.content.text = tostring(var_15_0)
		var_15_2.page_text_right.content.text = tostring(var_15_1)
		var_15_2.page_button_next.content.button_hotspot.disable_button = var_15_0 == var_15_1
		var_15_2.page_button_previous.content.button_hotspot.disable_button = var_15_0 == 1
	end
end

function HeroWindowCosmeticsInventory._update_selected_cosmetic_slot_index(arg_16_0)
	local var_16_0 = arg_16_0.parent:get_selected_cosmetic_slot_index()

	if var_16_0 ~= arg_16_0._selected_cosmetic_slot_index then
		arg_16_0._selected_cosmetic_slot_index = var_16_0

		arg_16_0:_change_category_by_index(var_16_0)
	end
end

function HeroWindowCosmeticsInventory._update_loadout_sync(arg_17_0)
	local var_17_0 = arg_17_0._item_grid
	local var_17_1 = arg_17_0.parent.loadout_sync_id

	if var_17_1 ~= arg_17_0._loadout_sync_id then
		arg_17_0._loadout_sync_id = var_17_1

		var_17_0:update_items_status()
	end
end

function HeroWindowCosmeticsInventory._exit(arg_18_0, arg_18_1)
	arg_18_0.exit = true
	arg_18_0.exit_level_id = arg_18_1
end

function HeroWindowCosmeticsInventory.draw(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.ui_renderer
	local var_19_1 = arg_19_0.ui_top_renderer
	local var_19_2 = arg_19_0.ui_scenegraph
	local var_19_3 = arg_19_0.parent:window_input_service()
	local var_19_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_19_1, var_19_2, var_19_3, arg_19_1, nil, arg_19_0.render_settings)

	for iter_19_0, iter_19_1 in ipairs(arg_19_0._widgets) do
		UIRenderer.draw_widget(var_19_1, iter_19_1)
	end

	local var_19_5 = arg_19_0._active_node_widgets

	if var_19_5 then
		for iter_19_2, iter_19_3 in ipairs(var_19_5) do
			UIRenderer.draw_widget(var_19_1, iter_19_3)
		end
	end

	UIRenderer.end_pass(var_19_1)
end

function HeroWindowCosmeticsInventory._play_sound(arg_20_0, arg_20_1)
	arg_20_0.parent:play_sound(arg_20_1)
end

function HeroWindowCosmeticsInventory._change_category_by_index(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0:_select_tab_by_category_index(arg_21_1)

	if arg_21_2 then
		arg_21_1 = arg_21_0._current_category_index or 1
	end

	if arg_21_0._current_category_index == arg_21_1 then
		return
	end

	arg_21_0._current_category_index = arg_21_1

	local var_21_0 = var_0_2[arg_21_1]
	local var_21_1 = var_21_0.name
	local var_21_2 = var_21_0.display_name

	arg_21_0._item_grid:change_category(var_21_1)

	arg_21_0._widgets_by_name.item_grid_header.content.text = var_21_2

	return true
end
