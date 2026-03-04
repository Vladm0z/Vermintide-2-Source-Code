-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_grid.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_grid_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = {
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

local function var_0_4(arg_1_0, arg_1_1)
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

StartGameWindowMutatorGrid = class(StartGameWindowMutatorGrid)
StartGameWindowMutatorGrid.NAME = "StartGameWindowMutatorGrid"

function StartGameWindowMutatorGrid.on_enter(arg_2_0, arg_2_1, arg_2_2)
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorGrid")

	arg_2_0.parent = arg_2_1.parent

	local var_2_0 = arg_2_1.ingame_ui_context

	arg_2_0.ui_renderer = var_2_0.ui_renderer
	arg_2_0.input_manager = var_2_0.input_manager
	arg_2_0.statistics_db = var_2_0.statistics_db
	arg_2_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_2_1 = Managers.player

	arg_2_0._stats_id = var_2_1:local_player():stats_id()
	arg_2_0.player_manager = var_2_1
	arg_2_0.peer_id = var_2_0.peer_id

	arg_2_0:create_ui_elements(arg_2_1, arg_2_2)

	local var_2_2 = "empire_soldier"
	local var_2_3 = 1
	local var_2_4 = ItemGridUI:new(var_0_3, arg_2_0._widgets_by_name.item_grid, var_2_2, var_2_3)

	var_2_4:change_category("heroic_deeds")
	var_2_4:disable_item_drag()
	var_2_4:apply_item_sorting_function(var_0_4)

	arg_2_0._item_grid = var_2_4
end

function StartGameWindowMutatorGrid.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = UISceneGraph.init_scenegraph(var_0_2)

	arg_3_0.ui_scenegraph = var_3_0

	local var_3_1 = {}
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_3 = UIWidget.init(iter_3_1)

		var_3_1[#var_3_1 + 1] = var_3_3
		var_3_2[iter_3_0] = var_3_3
	end

	arg_3_0._widgets = var_3_1
	arg_3_0._widgets_by_name = var_3_2

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	if arg_3_2 then
		local var_3_4 = var_3_0.window.local_position

		var_3_4[1] = var_3_4[1] + arg_3_2[1]
		var_3_4[2] = var_3_4[2] + arg_3_2[2]
		var_3_4[3] = var_3_4[3] + arg_3_2[3]
	end
end

function StartGameWindowMutatorGrid.on_exit(arg_4_0, arg_4_1)
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorGrid")
	arg_4_0._item_grid:destroy()

	arg_4_0._item_grid = nil
end

function StartGameWindowMutatorGrid.update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._item_grid:update(arg_5_1, arg_5_2)
	arg_5_0:_update_page_info()
	arg_5_0:_update_selected_item_backend_id()
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:draw(arg_5_1)
end

function StartGameWindowMutatorGrid.post_update(arg_6_0, arg_6_1, arg_6_2)
	return
end

function StartGameWindowMutatorGrid._is_button_pressed(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		return true
	end
end

function StartGameWindowMutatorGrid._is_button_hovered(arg_8_0, arg_8_1)
	if arg_8_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

function StartGameWindowMutatorGrid._handle_input(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._widgets_by_name
	local var_9_1 = arg_9_0._item_grid
	local var_9_2 = true
	local var_9_3 = var_9_1:is_item_pressed(var_9_2)

	if var_9_1:is_item_hovered() then
		arg_9_0:_play_sound("play_gui_inventory_item_hover")
	end

	if var_9_3 then
		arg_9_0:_play_sound("play_gui_lobby_button_04_heroic_deed_inventory_click")

		local var_9_4 = var_9_3.backend_id

		arg_9_0.parent:set_selected_heroic_deed_backend_id(var_9_4)
	end

	local var_9_5 = var_9_0.page_button_next
	local var_9_6 = var_9_0.page_button_previous

	if arg_9_0:_is_button_hovered(var_9_5) or arg_9_0:_is_button_hovered(var_9_6) then
		arg_9_0:_play_sound("play_gui_inventory_next_hover")
	end

	if arg_9_0:_is_button_pressed(var_9_5) then
		local var_9_7 = arg_9_0._current_page + 1

		var_9_1:set_item_page(var_9_7)
		arg_9_0:_play_sound("play_gui_equipment_inventory_next_click")
	elseif arg_9_0:_is_button_pressed(var_9_6) then
		local var_9_8 = arg_9_0._current_page - 1

		var_9_1:set_item_page(var_9_8)
		arg_9_0:_play_sound("play_gui_equipment_inventory_next_click")
	end
end

function StartGameWindowMutatorGrid._play_sound(arg_10_0, arg_10_1)
	arg_10_0.parent:play_sound(arg_10_1)
end

function StartGameWindowMutatorGrid._update_selected_item_backend_id(arg_11_0)
	local var_11_0 = arg_11_0.parent:get_selected_heroic_deed_backend_id()

	if var_11_0 ~= arg_11_0._selected_backend_id then
		arg_11_0._selected_backend_id = var_11_0

		arg_11_0._item_grid:set_backend_id_selected(var_11_0)
	elseif not var_11_0 then
		local var_11_1 = arg_11_0._item_grid:get_item_in_slot(1, 1)

		if var_11_1 then
			arg_11_0.parent:set_selected_heroic_deed_backend_id(var_11_1.backend_id)
		end
	end
end

function StartGameWindowMutatorGrid.draw(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0.ui_scenegraph
	local var_12_2 = arg_12_0.parent:window_input_service()

	UIRenderer.begin_pass(var_12_0, var_12_1, var_12_2, arg_12_1, nil, arg_12_0.render_settings)

	local var_12_3 = arg_12_0._widgets

	for iter_12_0 = 1, #var_12_3 do
		local var_12_4 = var_12_3[iter_12_0]

		UIRenderer.draw_widget(var_12_0, var_12_4)
	end

	UIRenderer.end_pass(var_12_0)
end

function StartGameWindowMutatorGrid._update_page_info(arg_13_0)
	local var_13_0, var_13_1 = arg_13_0._item_grid:get_page_info()

	if var_13_0 ~= arg_13_0._current_page or var_13_1 ~= arg_13_0._total_pages then
		arg_13_0._total_pages = var_13_1
		arg_13_0._current_page = var_13_0
		var_13_0 = var_13_0 or 1
		var_13_1 = var_13_1 or 1

		local var_13_2 = arg_13_0._widgets_by_name

		var_13_2.page_text_left.content.text = tostring(var_13_0)
		var_13_2.page_text_right.content.text = tostring(var_13_1)
		var_13_2.page_button_next.content.button_hotspot.disable_button = var_13_0 == var_13_1
		var_13_2.page_button_previous.content.button_hotspot.disable_button = var_13_0 == 1
	end
end
