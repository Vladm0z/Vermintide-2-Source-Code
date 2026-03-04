-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_roll_properties_console.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_roll_properties_console_definitions")
local var_0_4 = var_0_3.widgets
local var_0_5 = var_0_3.category_settings
local var_0_6 = var_0_3.scenegraph_definition
local var_0_7 = var_0_3.animation_definitions
local var_0_8 = false
local var_0_9 = 1

CraftPageRollPropertiesConsole = class(CraftPageRollPropertiesConsole)
CraftPageRollPropertiesConsole.NAME = "CraftPageRollPropertiesConsole"

CraftPageRollPropertiesConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroWindowCraft] Enter Substate CraftPageRollPropertiesConsole")

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
	arg_1_0:setup_recipe_requirements()
end

CraftPageRollPropertiesConsole.setup_recipe_requirements = function (arg_2_0)
	local var_2_0 = arg_2_0.settings.name
	local var_2_1 = var_0_1[var_2_0]
	local var_2_2 = var_2_1.ingredients
	local var_2_3 = var_2_1.ingredients
	local var_2_4 = 0

	for iter_2_0, iter_2_1 in ipairs(var_2_3) do
		if not iter_2_1.catergory then
			var_2_4 = var_2_4 + 1
		end
	end

	arg_2_0:reset_requirements(var_2_4)

	local var_2_5 = arg_2_0._material_items

	table.clear(var_2_5)

	local var_2_6 = Managers.backend:get_interface("items")
	local var_2_7 = var_2_6:get_filtered_items("item_type == crafting_material")
	local var_2_8 = true
	local var_2_9 = 1

	for iter_2_2, iter_2_3 in ipairs(var_2_3) do
		if not iter_2_3.catergory then
			local var_2_10 = iter_2_3.name
			local var_2_11 = iter_2_3.amount
			local var_2_12 = 0
			local var_2_13

			for iter_2_4, iter_2_5 in ipairs(var_2_7) do
				local var_2_14 = iter_2_5.backend_id

				if iter_2_5.data.key == var_2_10 then
					var_2_13 = var_2_14
					var_2_12 = var_2_6:get_item_amount(var_2_14)

					break
				end
			end

			local var_2_15 = var_2_11 <= var_2_12
			local var_2_16 = (var_2_12 < UISettings.max_craft_material_presentation_amount and tostring(var_2_12) or "*") .. "/" .. tostring(var_2_11)

			arg_2_0:_add_crafting_material_requirement(var_2_9, var_2_10, var_2_16, var_2_15)

			var_2_9 = var_2_9 + 1

			if var_2_15 then
				var_2_5[#var_2_5 + 1] = var_2_13
			else
				var_2_8 = false
			end
		end
	end

	arg_2_0._has_all_requirements = var_2_8
end

CraftPageRollPropertiesConsole.reset_requirements = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._widgets_by_name
	local var_3_1 = 60
	local var_3_2 = 10
	local var_3_3 = -((var_3_1 + var_3_2) * (arg_3_1 - 1)) / 2
	local var_3_4 = #UISettings.crafting_material_order

	for iter_3_0 = 1, var_3_4 do
		local var_3_5 = var_3_0["material_text_" .. iter_3_0]
		local var_3_6 = iter_3_0 <= arg_3_1

		var_3_5.content.visible = var_3_6

		if var_3_6 then
			var_3_5.offset[1] = var_3_3
			var_3_3 = var_3_3 + var_3_1 + var_3_2
		end
	end
end

CraftPageRollPropertiesConsole.create_ui_elements = function (arg_4_0, arg_4_1)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_6)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_4) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_7)

	arg_4_0:_set_craft_button_disabled(true)
	arg_4_0:_handle_craft_input_progress(0)
end

CraftPageRollPropertiesConsole.on_exit = function (arg_5_0, arg_5_1)
	print("[HeroWindowCraft] Exit Substate CraftPageRollPropertiesConsole")

	arg_5_0.ui_animator = nil

	if arg_5_0._craft_input_time then
		arg_5_0:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageRollPropertiesConsole.update = function (arg_6_0, arg_6_1, arg_6_2)
	if var_0_8 then
		var_0_8 = false

		arg_6_0:create_ui_elements()
	end

	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_update_craft_items()
	arg_6_0:draw(arg_6_1)
end

CraftPageRollPropertiesConsole.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

CraftPageRollPropertiesConsole._update_animations = function (arg_8_0, arg_8_1)
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

CraftPageRollPropertiesConsole._is_button_pressed = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.on_release then
		var_9_0.on_release = false

		return true
	end
end

CraftPageRollPropertiesConsole._is_button_hovered = function (arg_10_0, arg_10_1)
	if arg_10_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageRollPropertiesConsole._is_button_held = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	if var_11_0.is_clicked then
		return var_11_0.is_clicked
	end
end

CraftPageRollPropertiesConsole._handle_input = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.parent

	if var_12_0:waiting_for_craft() or arg_12_0._craft_result then
		return
	end

	local var_12_1 = arg_12_0._widgets_by_name
	local var_12_2 = arg_12_0.super_parent
	local var_12_3 = Managers.input:is_device_active("gamepad")
	local var_12_4 = arg_12_0.super_parent:window_input_service()
	local var_12_5 = not var_12_1.craft_button.content.button_hotspot.disable_button
	local var_12_6 = arg_12_0:_is_button_held(var_12_1.craft_button)
	local var_12_7 = var_12_5 and var_12_3 and var_12_4:get("refresh_hold")
	local var_12_8 = var_12_5 and not var_12_3 and var_12_4:get("skip")
	local var_12_9 = false

	if var_12_4:get("special_1") then
		arg_12_0:reset()
	elseif (var_12_6 == 0 or var_12_7 or var_12_8) and arg_12_0._has_all_requirements then
		if not arg_12_0._craft_input_time then
			arg_12_0._craft_input_time = 0

			arg_12_0:_play_sound("play_gui_craft_forge_button_begin")
		else
			arg_12_0._craft_input_time = arg_12_0._craft_input_time + arg_12_1
		end

		local var_12_10 = UISettings.crafting_progress_time
		local var_12_11 = math.min(arg_12_0._craft_input_time / var_12_10, 1)

		var_12_9 = arg_12_0:_handle_craft_input_progress(var_12_11)

		WwiseWorld.set_global_parameter(arg_12_0.wwise_world, "craft_forge_button_progress", var_12_11)
	elseif arg_12_0._craft_input_time then
		arg_12_0._craft_input_time = nil

		arg_12_0:_handle_craft_input_progress(0)
		arg_12_0:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if var_12_9 then
		local var_12_12 = arg_12_0._craft_items
		local var_12_13 = arg_12_0._material_items
		local var_12_14 = {}

		for iter_12_0, iter_12_1 in ipairs(var_12_12) do
			var_12_14[#var_12_14 + 1] = iter_12_1
		end

		for iter_12_2, iter_12_3 in ipairs(var_12_13) do
			var_12_14[#var_12_14 + 1] = iter_12_3
		end

		if var_12_0:craft(var_12_14, arg_12_0._recipe_name) then
			arg_12_0:_set_craft_button_disabled(true)

			local var_12_15 = arg_12_0._item_grid

			for iter_12_4, iter_12_5 in pairs(var_12_14) do
				var_12_15:lock_item_by_id(iter_12_5, true)
			end

			var_12_15:update_items_status()
			arg_12_0:_play_sound("play_gui_craft_forge_button_completed")
			arg_12_0:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

CraftPageRollPropertiesConsole._handle_craft_input_progress = function (arg_13_0, arg_13_1)
	return arg_13_0.parent:_set_input_progress(arg_13_1)
end

CraftPageRollPropertiesConsole.craft_result = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not arg_14_2 then
		arg_14_0._craft_result = arg_14_1
	end
end

CraftPageRollPropertiesConsole.reset = function (arg_15_0)
	for iter_15_0 = 1, var_0_9 do
		local var_15_0 = arg_15_0._craft_items[iter_15_0]

		if var_15_0 then
			arg_15_0:_remove_craft_item(var_15_0)
		end
	end

	local var_15_1 = arg_15_0._item_grid

	var_15_1:clear_locked_items()
	var_15_1:update_items_status()
	arg_15_0:setup_recipe_requirements()
end

CraftPageRollPropertiesConsole.present_results = function (arg_16_0)
	local var_16_0 = arg_16_0._item_grid

	var_16_0:clear_locked_items()
	var_16_0:update_items_status()
	arg_16_0.super_parent:update_inventory_items()
	arg_16_0:setup_recipe_requirements()
end

CraftPageRollPropertiesConsole.on_craft_completed = function (arg_17_0)
	arg_17_0._craft_result = nil

	local var_17_0 = arg_17_0._item_grid
	local var_17_1 = true
	local var_17_2 = arg_17_0._craft_items[1]

	arg_17_0:_add_craft_item(var_17_2, nil, var_17_1)

	local var_17_3 = Managers.backend:get_interface("items"):get_item_from_id(var_17_2)

	arg_17_0.parent:set_reward_tooltip_item(var_17_3)
end

CraftPageRollPropertiesConsole._update_craft_items = function (arg_18_0)
	local var_18_0 = arg_18_0.super_parent
	local var_18_1 = arg_18_0._item_grid

	if not var_18_1:is_dragging_item() then
		local var_18_2

		var_18_2 = var_18_1:is_item_dragged() ~= nil
	end

	local var_18_3, var_18_4 = var_18_0:get_pressed_item_backend_id()

	if var_18_3 then
		if arg_18_0:_has_added_item_by_id(var_18_3) then
			arg_18_0:_remove_craft_item(var_18_3)
		else
			arg_18_0:_add_craft_item(var_18_3)
		end
	end

	local var_18_5 = var_18_1:is_item_pressed()

	if var_18_5 then
		local var_18_6 = var_18_5.backend_id

		arg_18_0:_remove_craft_item(var_18_6)
	end
end

CraftPageRollPropertiesConsole._remove_craft_item = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_0._craft_items

	if arg_19_2 then
		if var_19_0[arg_19_2] then
			arg_19_1 = var_19_0[arg_19_2]
		end
	else
		for iter_19_0, iter_19_1 in pairs(var_19_0) do
			if iter_19_1 == arg_19_1 then
				arg_19_2 = iter_19_0

				break
			end
		end
	end

	if arg_19_1 and arg_19_2 then
		arg_19_0.super_parent:set_disabled_backend_id(arg_19_1, false)
		arg_19_0._item_grid:add_item_to_slot_index(arg_19_2, nil)

		var_19_0[arg_19_2] = nil
		arg_19_0._num_craft_items = math.max((arg_19_0._num_craft_items or 0) - 1, 0)

		if arg_19_0._num_craft_items == 0 then
			arg_19_0:_set_craft_button_disabled(true)
		end

		if not arg_19_3 then
			arg_19_0:_play_sound("play_gui_craft_item_drag")
		end

		arg_19_0._recipe_name = arg_19_0.settings.name
	end
end

CraftPageRollPropertiesConsole._add_craft_item = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0:_clear_item_grid()

	local var_20_0 = arg_20_0._craft_items

	if not arg_20_2 then
		for iter_20_0 = 1, var_0_9 do
			if not var_20_0[iter_20_0] then
				arg_20_2 = iter_20_0

				break
			end
		end
	end

	if arg_20_2 then
		var_20_0[arg_20_2] = arg_20_1

		local var_20_1 = Managers.backend:get_interface("items")
		local var_20_2 = arg_20_1 and var_20_1:get_item_from_id(arg_20_1)
		local var_20_3 = arg_20_1 and var_20_1:get_item_masterlist_data(arg_20_1)
		local var_20_4 = var_20_3 and var_20_3.slot_type

		if var_20_4 == "ranged" or var_20_4 == "melee" then
			arg_20_0._recipe_name = "reroll_weapon_properties"
		elseif var_20_4 == "trinket" or var_20_4 == "ring" or var_20_4 == "necklace" then
			arg_20_0._recipe_name = "reroll_jewellery_properties"
		end

		arg_20_0._item_grid:add_item_to_slot_index(arg_20_2, var_20_2)
		arg_20_0.super_parent:set_disabled_backend_id(arg_20_1, true)

		arg_20_0._num_craft_items = math.min((arg_20_0._num_craft_items or 0) + 1, var_0_9)

		if arg_20_0._num_craft_items > 0 and arg_20_0._has_all_requirements then
			arg_20_0:_set_craft_button_disabled(false)
		end

		if arg_20_1 and not arg_20_3 then
			arg_20_0:_play_sound("play_gui_craft_item_drop")
		end
	end
end

CraftPageRollPropertiesConsole._set_craft_button_disabled = function (arg_21_0, arg_21_1)
	arg_21_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_21_1

	arg_21_0.parent:set_input_description(not arg_21_1 and arg_21_0.settings.name or "disabled")
end

CraftPageRollPropertiesConsole._exit = function (arg_22_0, arg_22_1)
	arg_22_0.exit = true
	arg_22_0.exit_level_id = arg_22_1
end

CraftPageRollPropertiesConsole.draw = function (arg_23_0, arg_23_1)
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

CraftPageRollPropertiesConsole._play_sound = function (arg_24_0, arg_24_1)
	arg_24_0.super_parent:play_sound(arg_24_1)
end

CraftPageRollPropertiesConsole._set_craft_button_text = function (arg_25_0, arg_25_1, arg_25_2)
	arg_25_0._widgets_by_name.craft_button.content.button_text = arg_25_2 and Localize(arg_25_1) or arg_25_1
end

CraftPageRollPropertiesConsole._add_crafting_material_requirement = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = UISettings.crafting_material_icons_small
	local var_26_1 = arg_26_0._widgets_by_name["material_text_" .. arg_26_1].content

	var_26_1.icon, var_26_1.text = var_26_0[arg_26_2], arg_26_3
	var_26_1.warning = not arg_26_4
	var_26_1.item = {
		data = table.clone(ItemMasterList[arg_26_2])
	}
end

CraftPageRollPropertiesConsole._clear_item_grid = function (arg_27_0)
	local var_27_0 = arg_27_0._craft_items
	local var_27_1 = arg_27_0.super_parent

	for iter_27_0 = 1, var_0_9 do
		if var_27_0[iter_27_0] then
			var_27_1:set_disabled_backend_id(var_27_0[iter_27_0], false)
		end
	end

	arg_27_0._item_grid:clear_item_grid()
	table.clear(var_27_0)
end

CraftPageRollPropertiesConsole._has_added_item_by_id = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._craft_items

	for iter_28_0 = 1, var_0_9 do
		if var_28_0[iter_28_0] == arg_28_1 then
			return true
		end
	end

	return false
end
