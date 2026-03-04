-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_loadout.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.category_settings
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = false

HeroWindowLoadout = class(HeroWindowLoadout)
HeroWindowLoadout.NAME = "HeroWindowLoadout"

HeroWindowLoadout.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowLoadout")

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
	arg_1_0._equipment_items = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
end

HeroWindowLoadout.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_4)

	if arg_2_2 then
		local var_2_3 = arg_2_0.ui_scenegraph.window.local_position

		var_2_3[1] = var_2_3[1] + arg_2_2[1]
		var_2_3[2] = var_2_3[2] + arg_2_2[2]
		var_2_3[3] = var_2_3[3] + arg_2_2[3]
	end
end

HeroWindowLoadout.on_exit = function (arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate HeroWindowLoadout")

	arg_3_0.ui_animator = nil
end

HeroWindowLoadout.update = function (arg_4_0, arg_4_1, arg_4_2)
	if var_0_5 then
		var_0_5 = false

		arg_4_0:create_ui_elements()
	end

	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_update_loadout_sync()
	arg_4_0:_update_selected_loadout_slot_index()
	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:draw(arg_4_1)
end

HeroWindowLoadout.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	return
end

HeroWindowLoadout._update_animations = function (arg_6_0, arg_6_1)
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

HeroWindowLoadout._is_button_pressed = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		return true
	end
end

HeroWindowLoadout._handle_input = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.parent

	if arg_8_0:_is_equipment_slot_hovered() then
		arg_8_0:_play_sound("play_gui_equipment_selection_hover")
	end

	local var_8_1 = arg_8_0:_is_equipment_slot_pressed()

	if var_8_1 then
		var_8_0:set_selected_loadout_slot_index(var_8_1)
		arg_8_0:_play_sound("play_gui_equipment_selection_click")
	end
end

HeroWindowLoadout._update_selected_loadout_slot_index = function (arg_9_0)
	local var_9_0 = arg_9_0.parent:get_selected_loadout_slot_index()

	if var_9_0 ~= arg_9_0._selected_loadout_slot_index then
		arg_9_0:_set_equipment_slot_selected(var_9_0)
	end
end

HeroWindowLoadout._update_loadout_sync = function (arg_10_0)
	local var_10_0 = arg_10_0.parent.loadout_sync_id

	if var_10_0 ~= arg_10_0._loadout_sync_id then
		arg_10_0:_populate_loadout()

		arg_10_0._loadout_sync_id = var_10_0
	end
end

HeroWindowLoadout._exit = function (arg_11_0, arg_11_1)
	arg_11_0.exit = true
	arg_11_0.exit_level_id = arg_11_1
end

HeroWindowLoadout.draw = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0.ui_top_renderer
	local var_12_2 = arg_12_0.ui_scenegraph
	local var_12_3 = arg_12_0.parent:window_input_service()

	UIRenderer.begin_pass(var_12_1, var_12_2, var_12_3, arg_12_1, nil, arg_12_0.render_settings)

	for iter_12_0, iter_12_1 in ipairs(arg_12_0._widgets) do
		UIRenderer.draw_widget(var_12_1, iter_12_1)
	end

	local var_12_4 = arg_12_0._active_node_widgets

	if var_12_4 then
		for iter_12_2, iter_12_3 in ipairs(var_12_4) do
			UIRenderer.draw_widget(var_12_1, iter_12_3)
		end
	end

	UIRenderer.end_pass(var_12_1)
end

HeroWindowLoadout._play_sound = function (arg_13_0, arg_13_1)
	arg_13_0.parent:play_sound(arg_13_1)
end

HeroWindowLoadout._setup_slot_icons = function (arg_14_0)
	local var_14_0 = InventorySettings.slots_by_slot_index

	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		local var_14_1 = iter_14_1.ui_slot_index

		if var_14_1 then
			local var_14_2 = arg_14_0._widgets_by_name.loadout_grid.content
			local var_14_3 = "_1_" .. tostring(var_14_1)
			local var_14_4 = "item_icon" .. var_14_3
			local var_14_5 = "hotspot" .. var_14_3
			local var_14_6 = "item_tooltip" .. var_14_3
			local var_14_7 = "slot_icon" .. var_14_3
			local var_14_8 = iter_14_1.type

			var_14_2[var_14_7] = slot_icon_by_type[var_14_8] or "tabs_icon_all_selected"
		end
	end
end

HeroWindowLoadout._populate_loadout = function (arg_15_0)
	local var_15_0 = arg_15_0.hero_name
	local var_15_1 = InventorySettings.slots_by_slot_index
	local var_15_2 = arg_15_0.career_index
	local var_15_3 = FindProfileIndex(var_15_0)
	local var_15_4 = SPProfiles[var_15_3].careers[var_15_2].name

	for iter_15_0, iter_15_1 in pairs(var_15_1) do
		local var_15_5 = iter_15_1.name

		arg_15_0:_clear_item_slot(iter_15_1)

		local var_15_6 = BackendUtils.get_loadout_item(var_15_4, var_15_5)

		if var_15_6 then
			arg_15_0:_equip_item_presentation(var_15_6, iter_15_1)
		end
	end
end

HeroWindowLoadout._equip_item_presentation = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1.data.slot_type
	local var_16_1 = arg_16_2.slot_index
	local var_16_2 = arg_16_2.ui_slot_index
	local var_16_3 = arg_16_0._widgets_by_name

	if var_16_2 then
		arg_16_0._equipment_items[var_16_1] = arg_16_1

		local var_16_4 = var_16_3.loadout_grid
		local var_16_5 = var_16_4.content
		local var_16_6 = var_16_4.style
		local var_16_7 = "_1_" .. tostring(var_16_1)
		local var_16_8 = "item_icon" .. var_16_7
		local var_16_9 = "hotspot" .. var_16_7
		local var_16_10 = "item_tooltip" .. var_16_7
		local var_16_11, var_16_12, var_16_13 = UIUtils.get_ui_information_from_item(arg_16_1)

		var_16_5[var_16_10] = var_16_12
		var_16_5["item" .. var_16_7] = arg_16_1

		local var_16_14 = arg_16_1.backend_id
		local var_16_15 = arg_16_1.rarity
		local var_16_16 = Managers.backend:get_interface("items")

		if var_16_15 then
			var_16_5["rarity_texture" .. var_16_7] = UISettings.item_rarity_textures[var_16_15]
		end

		var_16_5[var_16_9][var_16_8] = var_16_11
	end
end

HeroWindowLoadout._clear_item_slot = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.type
	local var_17_1 = arg_17_1.slot_index
	local var_17_2 = arg_17_1.ui_slot_index
	local var_17_3 = arg_17_0._widgets_by_name

	if var_17_2 then
		arg_17_0._equipment_items[var_17_1] = nil

		local var_17_4 = var_17_3.loadout_grid
		local var_17_5 = var_17_4.content
		local var_17_6 = var_17_4.style
		local var_17_7 = "_1_" .. tostring(var_17_1)
		local var_17_8 = "item_icon" .. var_17_7
		local var_17_9 = "hotspot" .. var_17_7

		var_17_5["item_tooltip" .. var_17_7] = nil
		var_17_5["item" .. var_17_7] = nil
		var_17_5[var_17_9][var_17_8] = nil
	end
end

HeroWindowLoadout._is_equipment_slot_right_clicked = function (arg_18_0)
	local var_18_0 = arg_18_0._widgets_by_name.loadout_grid.content
	local var_18_1 = var_18_0.rows
	local var_18_2 = var_18_0.columns

	for iter_18_0 = 1, var_18_1 do
		for iter_18_1 = 1, var_18_2 do
			local var_18_3 = "_" .. tostring(iter_18_0) .. "_" .. tostring(iter_18_1)

			if var_18_0["hotspot" .. var_18_3].on_right_click then
				return iter_18_1
			end
		end
	end
end

HeroWindowLoadout._is_equipment_slot_pressed = function (arg_19_0)
	local var_19_0 = arg_19_0._widgets_by_name.loadout_grid.content
	local var_19_1 = var_19_0.rows
	local var_19_2 = var_19_0.columns

	for iter_19_0 = 1, var_19_1 do
		for iter_19_1 = 1, var_19_2 do
			local var_19_3 = "_" .. tostring(iter_19_0) .. "_" .. tostring(iter_19_1)

			if var_19_0["hotspot" .. var_19_3].on_pressed then
				return iter_19_1
			end
		end
	end
end

HeroWindowLoadout._is_equipment_slot_hovered = function (arg_20_0)
	local var_20_0 = arg_20_0._widgets_by_name.loadout_grid.content
	local var_20_1 = var_20_0.rows
	local var_20_2 = var_20_0.columns

	for iter_20_0 = 1, var_20_1 do
		for iter_20_1 = 1, var_20_2 do
			local var_20_3 = "_" .. tostring(iter_20_0) .. "_" .. tostring(iter_20_1)

			if var_20_0["hotspot" .. var_20_3].on_hover_enter then
				return iter_20_1
			end
		end
	end
end

HeroWindowLoadout._set_equipment_slot_selected = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._widgets_by_name.loadout_grid.content
	local var_21_1 = var_21_0.rows
	local var_21_2 = var_21_0.columns

	for iter_21_0 = 1, var_21_1 do
		for iter_21_1 = 1, var_21_2 do
			local var_21_3 = "_" .. tostring(iter_21_0) .. "_" .. tostring(iter_21_1)

			var_21_0["hotspot" .. var_21_3].is_selected = arg_21_1 and arg_21_1 == iter_21_1
		end
	end
end

HeroWindowLoadout._is_equipment_slot_hovered_by_type = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._widgets_by_name.loadout_grid.content
	local var_22_1 = var_22_0.rows
	local var_22_2 = var_22_0.columns
	local var_22_3 = InventorySettings.slots_by_ui_slot_index

	for iter_22_0 = 1, var_22_1 do
		for iter_22_1 = 1, var_22_2 do
			if var_22_3[iter_22_1].type == arg_22_1 then
				local var_22_4 = "_" .. tostring(iter_22_0) .. "_" .. tostring(iter_22_1)

				if var_22_0["hotspot" .. var_22_4].internal_is_hover then
					return iter_22_1
				end
			end
		end
	end
end

HeroWindowLoadout._highlight_equipment_slot_by_type = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._widgets_by_name.loadout_grid
	local var_23_1 = var_23_0.content
	local var_23_2 = var_23_0.style
	local var_23_3 = var_23_1.rows
	local var_23_4 = var_23_1.columns
	local var_23_5 = InventorySettings.slots_by_ui_slot_index

	for iter_23_0 = 1, var_23_3 do
		for iter_23_1 = 1, var_23_4 do
			local var_23_6 = var_23_5[iter_23_1]
			local var_23_7 = "_" .. tostring(iter_23_0) .. "_" .. tostring(iter_23_1)
			local var_23_8 = "hotspot" .. var_23_7
			local var_23_9 = "slot_hover" .. var_23_7
			local var_23_10 = var_23_1[var_23_8]
			local var_23_11 = var_23_6.type == arg_23_1

			var_23_10.highlight = var_23_11

			local var_23_12 = var_23_10.internal_is_hover and 255 or 100

			var_23_2[var_23_9].color[1] = var_23_11 and var_23_12 or 255
		end
	end
end
