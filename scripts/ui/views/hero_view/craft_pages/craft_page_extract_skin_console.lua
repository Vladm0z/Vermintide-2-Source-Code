-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_extract_skin_console.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_extract_skin_console_definitions")
local var_0_4 = var_0_3.widgets
local var_0_5 = var_0_3.category_settings
local var_0_6 = var_0_3.scenegraph_definition
local var_0_7 = var_0_3.animation_definitions
local var_0_8 = false
local var_0_9 = 1

CraftPageExtractSkinConsole = class(CraftPageExtractSkinConsole)
CraftPageExtractSkinConsole.NAME = "CraftPageExtractSkinConsole"

CraftPageExtractSkinConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroWindowCraft] Enter Substate CraftPageExtractSkinConsole")

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
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1)

	arg_1_0._craft_items = {}
	arg_1_0._material_items = {}
	arg_1_0._item_grid = ItemGridUI:new(var_0_5, arg_1_0._widgets_by_name.item_grid, arg_1_0.hero_name, arg_1_0.career_index)

	arg_1_0._item_grid:disable_locked_items(true)
	arg_1_0._item_grid:mark_locked_items(true)
	arg_1_0._item_grid:hide_slots(true)
	arg_1_0._item_grid:disable_item_drag()
	arg_1_0.super_parent:clear_disabled_backend_ids()
end

CraftPageExtractSkinConsole.create_ui_elements = function (arg_2_0, arg_2_1)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_6)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_4) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(arg_2_0.ui_scenegraph, var_0_7)

	arg_2_0:_set_craft_button_disabled(true)
	arg_2_0:_handle_craft_input_progress(0)
end

CraftPageExtractSkinConsole.on_exit = function (arg_3_0, arg_3_1)
	print("[HeroWindowCraft] Exit Substate CraftPageExtractSkinConsole")

	arg_3_0.ui_animator = nil

	if arg_3_0._craft_input_time then
		arg_3_0:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageExtractSkinConsole.update = function (arg_4_0, arg_4_1, arg_4_2)
	if var_0_8 then
		var_0_8 = false

		arg_4_0:create_ui_elements()
	end

	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_update_craft_items()
	arg_4_0:draw(arg_4_1)
end

CraftPageExtractSkinConsole.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	return
end

CraftPageExtractSkinConsole._update_animations = function (arg_6_0, arg_6_1)
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

CraftPageExtractSkinConsole._is_button_pressed = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		return true
	end
end

CraftPageExtractSkinConsole._is_button_hovered = function (arg_8_0, arg_8_1)
	if arg_8_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageExtractSkinConsole._is_button_held = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.is_clicked then
		return var_9_0.is_clicked
	end
end

CraftPageExtractSkinConsole._handle_input = function (arg_10_0, arg_10_1, arg_10_2)
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

	if var_10_4:get("special_1") then
		arg_10_0:reset()
	elseif var_10_6 == 0 or var_10_7 then
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
		local var_10_12 = arg_10_0._material_items
		local var_10_13 = {}

		for iter_10_0, iter_10_1 in ipairs(var_10_11) do
			var_10_13[#var_10_13 + 1] = iter_10_1
		end

		for iter_10_2, iter_10_3 in ipairs(var_10_12) do
			var_10_13[#var_10_13 + 1] = iter_10_3
		end

		local var_10_14 = arg_10_0.settings.name

		if var_10_0:craft(var_10_13, var_10_14) then
			arg_10_0:_set_craft_button_disabled(true)

			local var_10_15 = arg_10_0._item_grid

			for iter_10_4, iter_10_5 in pairs(var_10_13) do
				var_10_15:lock_item_by_id(iter_10_5, true)
			end

			var_10_15:update_items_status()
			arg_10_0:_play_sound("play_gui_craft_forge_button_completed")
			arg_10_0:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

CraftPageExtractSkinConsole._handle_craft_input_progress = function (arg_11_0, arg_11_1)
	return arg_11_0.parent:_set_input_progress(arg_11_1)
end

CraftPageExtractSkinConsole.craft_result = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if not arg_12_2 then
		arg_12_0._craft_result = arg_12_1
	end
end

CraftPageExtractSkinConsole.reset = function (arg_13_0)
	for iter_13_0 = 1, var_0_9 do
		local var_13_0 = arg_13_0._craft_items[iter_13_0]

		if var_13_0 then
			arg_13_0:_remove_craft_item(var_13_0)
		end
	end

	local var_13_1 = arg_13_0._item_grid

	var_13_1:clear_locked_items()
	var_13_1:update_items_status()
end

CraftPageExtractSkinConsole.present_results = function (arg_14_0)
	local var_14_0 = arg_14_0._item_grid

	var_14_0:clear_locked_items()
	var_14_0:update_items_status()
	arg_14_0.super_parent:clear_disabled_backend_ids()
	arg_14_0.super_parent:update_inventory_items()
end

CraftPageExtractSkinConsole.on_craft_completed = function (arg_15_0)
	local var_15_0 = arg_15_0._craft_result
	local var_15_1

	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		var_15_1 = iter_15_1[1]

		local var_15_2 = iter_15_1[3]
	end

	if var_15_1 then
		local var_15_3 = Managers.backend:get_interface("items"):get_item_from_id(var_15_1)

		arg_15_0.parent:set_reward_tooltip_item(var_15_3)
	end

	arg_15_0._craft_result = nil

	local var_15_4 = arg_15_0._item_grid

	arg_15_0:_remove_craft_item(arg_15_0._craft_items[1])
end

CraftPageExtractSkinConsole._update_craft_items = function (arg_16_0)
	local var_16_0 = arg_16_0.super_parent
	local var_16_1 = arg_16_0._item_grid

	if not var_16_1:is_dragging_item() then
		local var_16_2

		var_16_2 = var_16_1:is_item_dragged() ~= nil
	end

	local var_16_3, var_16_4 = var_16_0:get_pressed_item_backend_id()

	if var_16_3 then
		if arg_16_0:_has_added_item_by_id(var_16_3) then
			arg_16_0:_remove_craft_item(var_16_3)
		else
			arg_16_0:_add_craft_item(var_16_3)
		end
	end

	local var_16_5 = var_16_1:is_item_pressed()

	if var_16_5 then
		local var_16_6 = var_16_5.backend_id

		arg_16_0:_remove_craft_item(var_16_6)
	end
end

CraftPageExtractSkinConsole._remove_craft_item = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._craft_items

	if arg_17_2 then
		if var_17_0[arg_17_2] then
			arg_17_1 = var_17_0[arg_17_2]
		end
	else
		for iter_17_0, iter_17_1 in pairs(var_17_0) do
			if iter_17_1 == arg_17_1 then
				arg_17_2 = iter_17_0

				break
			end
		end
	end

	if arg_17_1 and arg_17_2 then
		arg_17_0.super_parent:set_disabled_backend_id(arg_17_1, false)
		arg_17_0._item_grid:add_item_to_slot_index(arg_17_2, nil)

		var_17_0[arg_17_2] = nil
		arg_17_0._num_craft_items = math.max((arg_17_0._num_craft_items or 0) - 1, 0)

		if arg_17_0._num_craft_items == 0 then
			arg_17_0:_set_craft_button_disabled(true)
		end

		arg_17_0:_play_sound("play_gui_craft_item_drag")
	end
end

CraftPageExtractSkinConsole._add_craft_item = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0:_clear_item_grid()

	local var_18_0 = arg_18_0._craft_items

	if not arg_18_2 then
		for iter_18_0 = 1, var_0_9 do
			if not var_18_0[iter_18_0] then
				arg_18_2 = iter_18_0

				break
			end
		end
	end

	if arg_18_2 then
		var_18_0[arg_18_2] = arg_18_1

		local var_18_1 = Managers.backend:get_interface("items")
		local var_18_2 = arg_18_1 and var_18_1:get_item_from_id(arg_18_1)

		arg_18_0._item_grid:add_item_to_slot_index(arg_18_2, var_18_2)
		arg_18_0.super_parent:set_disabled_backend_id(arg_18_1, true)

		arg_18_0._num_craft_items = math.min((arg_18_0._num_craft_items or 0) + 1, var_0_9)

		if arg_18_0._num_craft_items > 0 then
			arg_18_0:_set_craft_button_disabled(false)
		end

		if arg_18_1 and not arg_18_3 then
			arg_18_0:_play_sound("play_gui_craft_item_drop")
		end
	end
end

CraftPageExtractSkinConsole._clear_item_grid = function (arg_19_0)
	local var_19_0 = arg_19_0._craft_items
	local var_19_1 = arg_19_0.super_parent

	for iter_19_0 = 1, var_0_9 do
		if var_19_0[iter_19_0] then
			var_19_1:set_disabled_backend_id(var_19_0[iter_19_0], false)
		end
	end

	arg_19_0._item_grid:clear_item_grid()
	table.clear(var_19_0)
end

CraftPageExtractSkinConsole._has_added_item_by_id = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._craft_items

	for iter_20_0 = 1, var_0_9 do
		if var_20_0[iter_20_0] == arg_20_1 then
			return true
		end
	end

	return false
end

CraftPageExtractSkinConsole._set_craft_button_disabled = function (arg_21_0, arg_21_1)
	arg_21_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_21_1

	arg_21_0.parent:set_input_description(not arg_21_1 and arg_21_0.settings.name or "disabled")
end

CraftPageExtractSkinConsole._exit = function (arg_22_0, arg_22_1)
	arg_22_0.exit = true
	arg_22_0.exit_level_id = arg_22_1
end

CraftPageExtractSkinConsole.draw = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.ui_renderer
	local var_23_1 = arg_23_0.ui_top_renderer
	local var_23_2 = arg_23_0.ui_scenegraph
	local var_23_3 = arg_23_0.super_parent:window_input_service()

	UIRenderer.begin_pass(var_23_1, var_23_2, var_23_3, arg_23_1, nil, arg_23_0.render_settings)

	for iter_23_0, iter_23_1 in ipairs(arg_23_0._widgets) do
		UIRenderer.draw_widget(var_23_1, iter_23_1)
	end

	UIRenderer.end_pass(var_23_1)
end

CraftPageExtractSkinConsole._play_sound = function (arg_24_0, arg_24_1)
	arg_24_0.super_parent:play_sound(arg_24_1)
end

CraftPageExtractSkinConsole._set_craft_button_text = function (arg_25_0, arg_25_1, arg_25_2)
	arg_25_0._widgets_by_name.craft_button.content.button_text = arg_25_2 and Localize(arg_25_1) or arg_25_1
end
