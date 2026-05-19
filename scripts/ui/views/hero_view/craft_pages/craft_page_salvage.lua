-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_salvage.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_salvage_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.category_settings
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = false

CraftPageSalvage = class(CraftPageSalvage)
CraftPageSalvage.NAME = "CraftPageSalvage"

function CraftPageSalvage.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroWindowCraft] Enter Substate CraftPageSalvage")

	arg_1_0.parent = arg_1_1.parent
	arg_1_0.super_parent = arg_1_0.parent.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ingame_ui_context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.crafting_manager = Managers.state.crafting

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.profile_index = arg_1_1.profile_index
	arg_1_0.wwise_world = arg_1_1.wwise_world
	arg_1_0.settings = arg_1_2
	arg_1_0._recipe_name = arg_1_2.name
	arg_1_0._num_craft_items = 0
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1)

	arg_1_0._craft_items = {}
	arg_1_0._item_grid = ItemGridUI:new(var_0_2, arg_1_0._widgets_by_name.item_grid, arg_1_0.hero_name, arg_1_0.career_index)

	arg_1_0._item_grid:disable_locked_items(true)
	arg_1_0._item_grid:mark_locked_items(true)
	arg_1_0._item_grid:hide_slots(true)
	arg_1_0._item_grid:disable_item_drag()
	arg_1_0.super_parent:clear_disabled_backend_ids()
end

function CraftPageSalvage.create_ui_elements(arg_2_0, arg_2_1)
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

	arg_2_0:_set_craft_button_disabled(true)
	arg_2_0:_handle_craft_input_progress(0)
end

function CraftPageSalvage.on_exit(arg_3_0, arg_3_1)
	print("[HeroWindowCraft] Exit Substate CraftPageSalvage")

	arg_3_0.ui_animator = nil

	if arg_3_0._craft_input_time then
		arg_3_0:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

function CraftPageSalvage.update(arg_4_0, arg_4_1, arg_4_2)
	if var_0_5 then
		var_0_5 = false

		arg_4_0:create_ui_elements()
	end

	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_update_craft_items()
	arg_4_0:draw(arg_4_1)
end

function CraftPageSalvage.post_update(arg_5_0, arg_5_1, arg_5_2)
	return
end

function CraftPageSalvage._update_animations(arg_6_0, arg_6_1)
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

	UIWidgetUtils.animate_default_button(var_6_2.craft_button, arg_6_1)
	UIWidgetUtils.animate_icon_button(var_6_2.auto_fill_plentiful, arg_6_1)
	UIWidgetUtils.animate_icon_button(var_6_2.auto_fill_common, arg_6_1)
	UIWidgetUtils.animate_icon_button(var_6_2.auto_fill_rare, arg_6_1)
	UIWidgetUtils.animate_icon_button(var_6_2.auto_fill_exotic, arg_6_1)
	UIWidgetUtils.animate_icon_button(var_6_2.auto_fill_clear, arg_6_1)
end

function CraftPageSalvage._is_button_pressed(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		return true
	end
end

function CraftPageSalvage._is_button_hovered(arg_8_0, arg_8_1)
	if arg_8_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

function CraftPageSalvage._is_button_held(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.is_clicked then
		return var_9_0.is_clicked
	end
end

function CraftPageSalvage._handle_input(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.parent

	if var_10_0:waiting_for_craft() or arg_10_0._craft_result then
		return
	end

	local var_10_1 = arg_10_0._widgets_by_name
	local var_10_2 = arg_10_0.super_parent
	local var_10_3 = Managers.input:is_device_active("gamepad")
	local var_10_4 = arg_10_0.super_parent:window_input_service()
	local var_10_5 = not var_10_1.craft_button.content.button_hotspot.disable_button
	local var_10_6 = arg_10_0:_is_button_held(var_10_1.craft_button)
	local var_10_7 = var_10_5 and var_10_3 and var_10_4:get("refresh_hold")
	local var_10_8 = false

	if var_10_6 == 0 or var_10_7 then
		if not arg_10_0._craft_input_time then
			arg_10_0._craft_input_time = 0

			arg_10_0:_play_sound("play_gui_craft_forge_button_begin")
		else
			arg_10_0._craft_input_time = arg_10_0._craft_input_time + arg_10_1
		end

		local var_10_9 = UISettings.crafting_progress_time
		local var_10_10 = math.min(arg_10_0._craft_input_time / var_10_9, 1)

		var_10_8 = arg_10_0:_handle_craft_input_progress(var_10_10)

		WwiseWorld.set_global_parameter(arg_10_0.wwise_world, "craft_forge_button_progress", var_10_10)
	elseif arg_10_0._craft_input_time then
		arg_10_0._craft_input_time = nil

		arg_10_0:_handle_craft_input_progress(0)
		arg_10_0:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if var_10_8 then
		local var_10_11 = arg_10_0._craft_items

		if var_10_0:craft(var_10_11, arg_10_0._recipe_name) then
			arg_10_0:_set_craft_button_disabled(true)

			local var_10_12 = arg_10_0._item_grid

			for iter_10_0, iter_10_1 in pairs(var_10_11) do
				var_10_12:lock_item_by_id(iter_10_1, true)
			end

			var_10_12:update_items_status()
			arg_10_0:_play_sound("play_gui_craft_forge_button_completed")
			arg_10_0:_play_sound("play_gui_craft_forge_begin")
		end
	end

	if not var_10_8 then
		if arg_10_0:_is_button_pressed(var_10_1.auto_fill_plentiful) then
			arg_10_0:_fill_by_rarity("plentiful")
		end

		if arg_10_0:_is_button_pressed(var_10_1.auto_fill_common) then
			arg_10_0:_fill_by_rarity("common")
		end

		if arg_10_0:_is_button_pressed(var_10_1.auto_fill_rare) then
			arg_10_0:_fill_by_rarity("rare")
		end

		if arg_10_0:_is_button_pressed(var_10_1.auto_fill_exotic) then
			arg_10_0:_fill_by_rarity("exotic")
		end

		if arg_10_0:_is_button_pressed(var_10_1.auto_fill_clear) then
			arg_10_0:clear_craft_items()
		end
	end
end

function CraftPageSalvage._fill_by_rarity(arg_11_0, arg_11_1)
	if not arg_11_0.parent:get_active_recipe() then
		return
	end

	if CraftingSettings.NUM_SALVAGE_SLOTS - arg_11_0._num_craft_items <= 0 then
		return
	end

	local var_11_0 = false
	local var_11_1 = arg_11_0.super_parent:get_inventory_grid()
	local var_11_2 = arg_11_0._craft_items
	local var_11_3 = var_11_1:items()

	for iter_11_0, iter_11_1 in ipairs(var_11_3) do
		local var_11_4 = iter_11_1.backend_id

		if var_11_4 and iter_11_1.rarity == arg_11_1 and not table.find(var_11_2, var_11_4) then
			local var_11_5 = arg_11_0:_add_craft_item(var_11_4, nil, var_11_0)

			var_11_0 = var_11_0 or var_11_5

			if table.size(var_11_2) == CraftingSettings.NUM_SALVAGE_SLOTS then
				break
			end
		end
	end
end

function CraftPageSalvage._handle_craft_input_progress(arg_12_0, arg_12_1)
	local var_12_0

	var_12_0 = arg_12_1 ~= 0

	local var_12_1 = var_0_3.craft_bar.size[1]

	arg_12_0.ui_scenegraph.craft_bar.size[1] = var_12_1 * arg_12_1

	if arg_12_1 == 1 then
		return true
	end
end

function CraftPageSalvage.craft_result(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not arg_13_2 then
		arg_13_0._craft_result = arg_13_1
	end
end

function CraftPageSalvage.clear_craft_items(arg_14_0)
	local var_14_0 = false

	for iter_14_0, iter_14_1 in pairs(arg_14_0._craft_items) do
		local var_14_1 = arg_14_0:_remove_craft_item(iter_14_1, nil, var_14_0)

		var_14_0 = var_14_0 or var_14_1
	end

	arg_14_0.super_parent:clear_disabled_backend_ids()
	arg_14_0.super_parent:update_inventory_items()
	arg_14_0:reset()
end

function CraftPageSalvage.reset(arg_15_0)
	local var_15_0 = arg_15_0._item_grid

	var_15_0:clear_locked_items()
	var_15_0:update_items_status()
end

function CraftPageSalvage.on_craft_completed(arg_16_0)
	local var_16_0 = arg_16_0._craft_result
	local var_16_1 = arg_16_0._item_grid

	table.clear(arg_16_0._craft_items)

	for iter_16_0 = 1, CraftingSettings.NUM_SALVAGE_SLOTS do
		arg_16_0._craft_items[iter_16_0] = nil
	end

	var_16_1:clear_item_grid()
	arg_16_0.super_parent:clear_disabled_backend_ids()
	arg_16_0.super_parent:update_inventory_items()

	local var_16_2 = 0

	for iter_16_1, iter_16_2 in pairs(var_16_0) do
		var_16_2 = var_16_2 + 1
	end

	local var_16_3 = true

	for iter_16_3, iter_16_4 in pairs(var_16_0) do
		local var_16_4 = iter_16_4[1]
		local var_16_5 = iter_16_4[3]

		if var_16_2 == 1 then
			arg_16_0:_add_craft_item(var_16_4, 5, var_16_3, var_16_5)
		else
			arg_16_0:_add_craft_item(var_16_4, iter_16_3, var_16_3, var_16_5)
		end
	end

	var_16_1:clear_locked_items()

	for iter_16_5, iter_16_6 in pairs(arg_16_0._craft_items) do
		var_16_1:lock_item_by_id(iter_16_6, true)
	end

	var_16_1:update_items_status()

	arg_16_0._num_craft_items = 0

	arg_16_0:_set_craft_button_disabled(true)

	arg_16_0._craft_result = nil
end

function CraftPageSalvage._update_craft_items(arg_17_0)
	local var_17_0 = arg_17_0.super_parent
	local var_17_1 = arg_17_0._item_grid
	local var_17_2 = var_17_1:is_dragging_item() or var_17_1:is_item_dragged() ~= nil
	local var_17_3, var_17_4 = var_17_0:get_pressed_item_backend_id()

	if var_17_3 then
		if var_17_4 then
			if not var_17_2 then
				local var_17_5 = var_17_1:is_slot_hovered()

				if var_17_5 then
					arg_17_0:_add_craft_item(var_17_3, var_17_5)
				end
			end
		else
			arg_17_0:_add_craft_item(var_17_3)
		end
	end

	local var_17_6 = var_17_1:is_item_pressed()

	if var_17_6 then
		local var_17_7 = var_17_6.backend_id

		arg_17_0:_remove_craft_item(var_17_7)
	end
end

function CraftPageSalvage._remove_craft_item(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_0._craft_items

	if arg_18_2 then
		if var_18_0[arg_18_2] then
			arg_18_1 = var_18_0[arg_18_2]
		end
	else
		for iter_18_0, iter_18_1 in pairs(var_18_0) do
			if iter_18_1 == arg_18_1 then
				arg_18_2 = iter_18_0

				break
			end
		end
	end

	if arg_18_1 and arg_18_2 then
		arg_18_0.super_parent:set_disabled_backend_id(arg_18_1, false)
		arg_18_0._item_grid:add_item_to_slot_index(arg_18_2, nil)

		var_18_0[arg_18_2] = nil
		arg_18_0._num_craft_items = math.max((arg_18_0._num_craft_items or 0) - 1, 0)

		if arg_18_0._num_craft_items == 0 then
			arg_18_0:_set_craft_button_disabled(true)
		end

		if not arg_18_3 then
			arg_18_0:_play_sound("play_gui_craft_item_drag")
		end

		return true
	end

	return false
end

function CraftPageSalvage._add_craft_item(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	if arg_19_0._num_craft_items == 0 then
		arg_19_0._item_grid:clear_item_grid()
		table.clear(arg_19_0._craft_items)
	end

	local var_19_0 = arg_19_0._craft_items

	if not arg_19_2 then
		for iter_19_0 = 1, CraftingSettings.NUM_SALVAGE_SLOTS do
			if not var_19_0[iter_19_0] then
				arg_19_2 = iter_19_0

				break
			end
		end
	end

	if arg_19_2 then
		var_19_0[arg_19_2] = arg_19_1

		local var_19_1 = Managers.backend:get_interface("items")
		local var_19_2 = arg_19_1 and var_19_1:get_item_from_id(arg_19_1)

		arg_19_0._item_grid:add_item_to_slot_index(arg_19_2, var_19_2, arg_19_4)
		arg_19_0.super_parent:set_disabled_backend_id(arg_19_1, true)

		arg_19_0._num_craft_items = math.min((arg_19_0._num_craft_items or 0) + 1, CraftingSettings.NUM_SALVAGE_SLOTS)

		if arg_19_0._num_craft_items > 0 then
			arg_19_0:_set_craft_button_disabled(false)
		end

		if arg_19_1 and not arg_19_3 then
			arg_19_0:_play_sound("play_gui_craft_item_drop")
		end

		return true
	end

	return false
end

function CraftPageSalvage._set_craft_button_disabled(arg_20_0, arg_20_1)
	arg_20_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_20_1
end

function CraftPageSalvage._exit(arg_21_0, arg_21_1)
	arg_21_0.exit = true
	arg_21_0.exit_level_id = arg_21_1
end

function CraftPageSalvage.draw(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.ui_renderer
	local var_22_1 = arg_22_0.ui_top_renderer
	local var_22_2 = arg_22_0.ui_scenegraph
	local var_22_3 = arg_22_0.super_parent:window_input_service()

	UIRenderer.begin_pass(var_22_1, var_22_2, var_22_3, arg_22_1, nil, arg_22_0.render_settings)

	for iter_22_0, iter_22_1 in ipairs(arg_22_0._widgets) do
		UIRenderer.draw_widget(var_22_1, iter_22_1)
	end

	UIRenderer.end_pass(var_22_1)
end

function CraftPageSalvage._play_sound(arg_23_0, arg_23_1)
	arg_23_0.super_parent:play_sound(arg_23_1)
end

function CraftPageSalvage._set_craft_button_text(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0._widgets_by_name.craft_button.content.button_text = arg_24_2 and Localize(arg_24_1) or arg_24_1
end
