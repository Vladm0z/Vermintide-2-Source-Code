-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = false

HeroWindowCosmeticsLoadout = class(HeroWindowCosmeticsLoadout)
HeroWindowCosmeticsLoadout.NAME = "HeroWindowCosmeticsLoadout"

function HeroWindowCosmeticsLoadout.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCosmeticsLoadout")

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

function HeroWindowCosmeticsLoadout.create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

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

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_3)

	if arg_2_2 then
		local var_2_3 = arg_2_0.ui_scenegraph.window.local_position

		var_2_3[1] = var_2_3[1] + arg_2_2[1]
		var_2_3[2] = var_2_3[2] + arg_2_2[2]
		var_2_3[3] = var_2_3[3] + arg_2_2[3]
	end
end

function HeroWindowCosmeticsLoadout.on_exit(arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCosmeticsLoadout")

	arg_3_0.ui_animator = nil
end

function HeroWindowCosmeticsLoadout.update(arg_4_0, arg_4_1, arg_4_2)
	if var_0_4 then
		var_0_4 = false

		arg_4_0:create_ui_elements()
	end

	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_update_loadout_sync()
	arg_4_0:_update_selected_cosmetic_slot_index()
	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:draw(arg_4_1)
end

function HeroWindowCosmeticsLoadout.post_update(arg_5_0, arg_5_1, arg_5_2)
	return
end

function HeroWindowCosmeticsLoadout._update_animations(arg_6_0, arg_6_1)
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

function HeroWindowCosmeticsLoadout._is_button_pressed(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		return true
	end
end

function HeroWindowCosmeticsLoadout._handle_input(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.parent

	if arg_8_0:_is_equipment_slot_hovered() then
		arg_8_0:_play_sound("play_gui_cosmetics_selection_hover")
	end

	local var_8_1 = arg_8_0:_is_equipment_slot_pressed()

	if var_8_1 then
		var_8_0:set_selected_cosmetic_slot_index(var_8_1)
		arg_8_0:_play_sound("play_gui_cosmetics_selection_click")
	end
end

function HeroWindowCosmeticsLoadout._update_selected_cosmetic_slot_index(arg_9_0)
	local var_9_0 = arg_9_0.parent:get_selected_cosmetic_slot_index()

	if var_9_0 ~= arg_9_0._selected_cosmetic_slot_index then
		arg_9_0:_set_equipment_slot_selected(var_9_0)

		arg_9_0._selected_cosmetic_slot_index = var_9_0
	end
end

function HeroWindowCosmeticsLoadout._update_loadout_sync(arg_10_0)
	local var_10_0 = arg_10_0.parent.loadout_sync_id

	if var_10_0 ~= arg_10_0._loadout_sync_id then
		arg_10_0:_populate_loadout()

		arg_10_0._loadout_sync_id = var_10_0
	end
end

function HeroWindowCosmeticsLoadout._exit(arg_11_0, arg_11_1)
	arg_11_0.exit = true
	arg_11_0.exit_level_id = arg_11_1
end

function HeroWindowCosmeticsLoadout.draw(arg_12_0, arg_12_1)
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

function HeroWindowCosmeticsLoadout._play_sound(arg_13_0, arg_13_1)
	arg_13_0.parent:play_sound(arg_13_1)
end

function HeroWindowCosmeticsLoadout._setup_slot_icons(arg_14_0)
	local var_14_0 = InventorySettings.slots_by_cosmetic_index

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

function HeroWindowCosmeticsLoadout._populate_loadout(arg_15_0)
	local var_15_0 = arg_15_0.hero_name
	local var_15_1 = InventorySettings.slots_by_cosmetic_index
	local var_15_2 = arg_15_0.career_index
	local var_15_3 = FindProfileIndex(var_15_0)
	local var_15_4 = SPProfiles[var_15_3].careers[var_15_2].name

	for iter_15_0, iter_15_1 in pairs(var_15_1) do
		local var_15_5 = iter_15_1.name
		local var_15_6 = BackendUtils.get_loadout_item(var_15_4, var_15_5)

		if var_15_6 then
			arg_15_0:_equip_item_presentation(var_15_6, iter_15_1)
		end
	end
end

function HeroWindowCosmeticsLoadout._equip_item_presentation(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1.data.slot_type
	local var_16_1 = arg_16_2.slot_index
	local var_16_2 = arg_16_2.cosmetic_index
	local var_16_3 = arg_16_0._widgets_by_name

	if var_16_2 then
		arg_16_0._equipment_items[var_16_2] = arg_16_1

		local var_16_4 = var_16_3.loadout_grid
		local var_16_5 = var_16_4.content
		local var_16_6 = var_16_4.style
		local var_16_7 = "_1_" .. tostring(var_16_2)
		local var_16_8 = "item_icon" .. var_16_7
		local var_16_9 = "hotspot" .. var_16_7
		local var_16_10 = "item_tooltip" .. var_16_7
		local var_16_11, var_16_12, var_16_13 = UIUtils.get_ui_information_from_item(arg_16_1)

		var_16_5[var_16_10] = var_16_12
		var_16_5["item" .. var_16_7] = arg_16_1

		local var_16_14 = arg_16_1.backend_id
		local var_16_15 = arg_16_1.rarity
		local var_16_16 = Managers.backend:get_interface("items")

		if var_16_14 then
			var_16_15 = var_16_16:get_item_rarity(var_16_14)
		end

		if var_16_15 then
			var_16_5["rarity_texture" .. var_16_7] = UISettings.item_rarity_textures[var_16_15]
		end

		local var_16_17 = var_16_5[var_16_9]

		if var_16_17 then
			var_16_17[var_16_8] = var_16_11
		end
	end
end

function HeroWindowCosmeticsLoadout._is_equipment_slot_pressed(arg_17_0)
	local var_17_0 = arg_17_0._widgets_by_name.loadout_grid.content
	local var_17_1 = var_17_0.rows
	local var_17_2 = var_17_0.columns

	for iter_17_0 = 1, var_17_1 do
		for iter_17_1 = 1, var_17_2 do
			local var_17_3 = "_" .. tostring(iter_17_0) .. "_" .. tostring(iter_17_1)

			if var_17_0["hotspot" .. var_17_3].on_pressed then
				return iter_17_1
			end
		end
	end
end

function HeroWindowCosmeticsLoadout._is_equipment_slot_hovered(arg_18_0)
	local var_18_0 = arg_18_0._widgets_by_name.loadout_grid.content
	local var_18_1 = var_18_0.rows
	local var_18_2 = var_18_0.columns

	for iter_18_0 = 1, var_18_1 do
		for iter_18_1 = 1, var_18_2 do
			local var_18_3 = "_" .. tostring(iter_18_0) .. "_" .. tostring(iter_18_1)

			if var_18_0["hotspot" .. var_18_3].on_hover_enter then
				return iter_18_1
			end
		end
	end
end

function HeroWindowCosmeticsLoadout._set_equipment_slot_selected(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._widgets_by_name.loadout_grid.content
	local var_19_1 = var_19_0.rows
	local var_19_2 = var_19_0.columns

	for iter_19_0 = 1, var_19_1 do
		for iter_19_1 = 1, var_19_2 do
			local var_19_3 = "_" .. tostring(iter_19_0) .. "_" .. tostring(iter_19_1)

			var_19_0["hotspot" .. var_19_3].is_selected = arg_19_1 and arg_19_1 == iter_19_1
		end
	end
end

function HeroWindowCosmeticsLoadout._is_equipment_slot_hovered_by_type(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._widgets_by_name.loadout_grid.content
	local var_20_1 = var_20_0.rows
	local var_20_2 = var_20_0.columns
	local var_20_3 = InventorySettings.slots_by_cosmetic_index

	for iter_20_0 = 1, var_20_1 do
		for iter_20_1 = 1, var_20_2 do
			if var_20_3[iter_20_1].type == arg_20_1 then
				local var_20_4 = "_" .. tostring(iter_20_0) .. "_" .. tostring(iter_20_1)

				if var_20_0["hotspot" .. var_20_4].internal_is_hover then
					return iter_20_1
				end
			end
		end
	end
end

function HeroWindowCosmeticsLoadout._highlight_equipment_slot_by_type(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._widgets_by_name.loadout_grid
	local var_21_1 = var_21_0.content
	local var_21_2 = var_21_0.style
	local var_21_3 = var_21_1.rows
	local var_21_4 = var_21_1.columns
	local var_21_5 = InventorySettings.slots_by_cosmetic_index

	for iter_21_0 = 1, var_21_3 do
		for iter_21_1 = 1, var_21_4 do
			local var_21_6 = var_21_5[iter_21_1]
			local var_21_7 = "_" .. tostring(iter_21_0) .. "_" .. tostring(iter_21_1)
			local var_21_8 = "hotspot" .. var_21_7
			local var_21_9 = "slot_hover" .. var_21_7
			local var_21_10 = var_21_1[var_21_8]
			local var_21_11 = var_21_6.type == arg_21_1

			var_21_10.highlight = var_21_11

			local var_21_12 = var_21_10.internal_is_hover and 255 or 100

			var_21_2[var_21_9].color[1] = var_21_11 and var_21_12 or 255
		end
	end
end
