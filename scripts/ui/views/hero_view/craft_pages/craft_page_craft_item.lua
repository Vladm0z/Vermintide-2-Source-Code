-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_craft_item.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_craft_item_definitions")
local var_0_4 = var_0_3.widgets
local var_0_5 = var_0_3.category_settings
local var_0_6 = var_0_3.scenegraph_definition
local var_0_7 = var_0_3.animation_definitions
local var_0_8 = false
local var_0_9 = 1

CraftPageCraftItem = class(CraftPageCraftItem)
CraftPageCraftItem.NAME = "CraftPageCraftItem"

CraftPageCraftItem.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroWindowCraft] Enter Substate CraftPageCraftItem")

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
	arg_1_0:setup_recipe_requirements()
end

CraftPageCraftItem.setup_recipe_requirements = function (arg_2_0)
	local var_2_0 = arg_2_0.settings.name
	local var_2_1 = arg_2_0._craft_items[1]
	local var_2_2 = Managers.backend:get_interface("items")
	local var_2_3 = var_2_1 and var_2_2:get_item_masterlist_data(var_2_1)
	local var_2_4 = var_2_3 and var_2_3.slot_type
	local var_2_5 = var_2_1 and var_2_2:get_item_rarity(var_2_1)
	local var_2_6 = not var_2_1 or var_2_5 == "default"

	if var_2_1 then
		if var_2_4 == "ranged" or var_2_4 == "melee" then
			var_2_0 = "craft_weapon"
		elseif var_2_4 == "trinket" or var_2_4 == "ring" or var_2_4 == "necklace" then
			var_2_0 = "craft_jewellery"
		end
	end

	arg_2_0._recipe_name = var_2_0

	local var_2_7 = var_0_1[var_2_0].ingredients
	local var_2_8 = 0

	for iter_2_0, iter_2_1 in ipairs(var_2_7) do
		if not iter_2_1.catergory then
			var_2_8 = var_2_8 + 1
		end
	end

	arg_2_0:create_recipe_grid_by_amount(var_2_8)

	local var_2_9 = arg_2_0._material_items

	table.clear(var_2_9)

	local var_2_10 = Managers.backend:get_interface("items")
	local var_2_11 = var_2_10:get_filtered_items("item_type == crafting_material")
	local var_2_12 = true
	local var_2_13 = 1
	local var_2_14 = arg_2_0._recipe_grid

	for iter_2_2, iter_2_3 in ipairs(var_2_7) do
		if not iter_2_3.catergory then
			local var_2_15 = iter_2_3.name
			local var_2_16 = iter_2_3.amount
			local var_2_17 = 0
			local var_2_18

			for iter_2_4, iter_2_5 in ipairs(var_2_11) do
				local var_2_19 = iter_2_5.backend_id

				if iter_2_5.data.key == var_2_15 then
					var_2_18 = var_2_19
					var_2_17 = var_2_10:get_item_amount(var_2_19)

					break
				end
			end

			local var_2_20 = var_2_16 <= var_2_17
			local var_2_21 = (var_2_17 < UISettings.max_craft_material_presentation_amount and tostring(var_2_17) or "*") .. "/" .. tostring(var_2_16)
			local var_2_22 = {
				data = table.clone(ItemMasterList[var_2_15]),
				amount = var_2_21,
				insufficient_amount = not var_2_20
			}

			var_2_14:add_item_to_slot_index(var_2_13, var_2_22)

			var_2_13 = var_2_13 + 1

			if var_2_20 then
				var_2_9[#var_2_9 + 1] = var_2_18
			else
				var_2_12 = false
			end
		end
	end

	arg_2_0._has_all_requirements = var_2_12 and var_2_6

	arg_2_0:_set_craft_button_disabled(not arg_2_0._has_all_requirements)
end

CraftPageCraftItem.create_recipe_grid_by_amount = function (arg_3_0, arg_3_1)
	if arg_3_0._recipe_grid then
		arg_3_0._recipe_grid:destroy()

		arg_3_0._recipe_grid = nil
	end

	local var_3_0 = UIWidgets.create_recipe_grid("recipe_grid", var_0_6.recipe_grid.size, 1, arg_3_1, 30, 30)
	local var_3_1 = UIWidget.init(var_3_0)

	for iter_3_0, iter_3_1 in ipairs(arg_3_0._widgets) do
		if iter_3_1 == arg_3_0._widgets_by_name.recipe_grid then
			arg_3_0._widgets[iter_3_0] = var_3_1
			arg_3_0._widgets_by_name.recipe_grid = var_3_1

			break
		end
	end

	arg_3_0._recipe_grid = ItemGridUI:new(var_0_5, arg_3_0._widgets_by_name.recipe_grid, arg_3_0.hero_name, arg_3_0.career_index)

	arg_3_0._recipe_grid:disable_item_drag()
end

CraftPageCraftItem.create_ui_elements = function (arg_4_0, arg_4_1)
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

	arg_4_0:_handle_craft_input_progress(0)
end

CraftPageCraftItem.on_exit = function (arg_5_0, arg_5_1)
	print("[HeroWindowCraft] Exit Substate CraftPageCraftItem")

	arg_5_0.ui_animator = nil

	if arg_5_0._craft_input_time then
		arg_5_0:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageCraftItem.update = function (arg_6_0, arg_6_1, arg_6_2)
	if var_0_8 then
		var_0_8 = false

		arg_6_0:create_ui_elements()
	end

	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_update_craft_items()
	arg_6_0:draw(arg_6_1)
end

CraftPageCraftItem.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

CraftPageCraftItem._update_animations = function (arg_8_0, arg_8_1)
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

	UIWidgetUtils.animate_default_button(var_8_2.craft_button, arg_8_1)
end

CraftPageCraftItem._is_button_pressed = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.on_release then
		var_9_0.on_release = false

		return true
	end
end

CraftPageCraftItem._is_button_hovered = function (arg_10_0, arg_10_1)
	if arg_10_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageCraftItem._is_button_held = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	if var_11_0.is_clicked then
		return var_11_0.is_clicked
	end
end

CraftPageCraftItem._handle_input = function (arg_12_0, arg_12_1, arg_12_2)
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
	local var_12_8 = false

	if (var_12_6 == 0 or var_12_7) and arg_12_0._has_all_requirements then
		if not arg_12_0._craft_input_time then
			arg_12_0._craft_input_time = 0

			arg_12_0:_play_sound("play_gui_craft_forge_button_begin")
		else
			arg_12_0._craft_input_time = arg_12_0._craft_input_time + arg_12_1
		end

		local var_12_9 = UISettings.crafting_progress_time
		local var_12_10 = math.min(arg_12_0._craft_input_time / var_12_9, 1)

		var_12_8 = arg_12_0:_handle_craft_input_progress(var_12_10)

		WwiseWorld.set_global_parameter(arg_12_0.wwise_world, "craft_forge_button_progress", var_12_10)
	elseif arg_12_0._craft_input_time then
		arg_12_0._craft_input_time = nil

		arg_12_0:_handle_craft_input_progress(0)
		arg_12_0:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if var_12_8 then
		local var_12_11 = arg_12_0._craft_items
		local var_12_12 = arg_12_0._material_items
		local var_12_13 = {}

		for iter_12_0, iter_12_1 in ipairs(var_12_11) do
			var_12_13[#var_12_13 + 1] = iter_12_1
		end

		for iter_12_2, iter_12_3 in ipairs(var_12_12) do
			var_12_13[#var_12_13 + 1] = iter_12_3
		end

		if var_12_0:craft(var_12_13, arg_12_0._recipe_name) then
			arg_12_0:_set_craft_button_disabled(true)

			local var_12_14 = arg_12_0._item_grid

			for iter_12_4, iter_12_5 in pairs(var_12_13) do
				var_12_14:lock_item_by_id(iter_12_5, true)
			end

			var_12_14:update_items_status()
			arg_12_0:_play_sound("play_gui_craft_forge_button_completed")
			arg_12_0:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

CraftPageCraftItem._handle_craft_input_progress = function (arg_13_0, arg_13_1)
	local var_13_0

	var_13_0 = arg_13_1 ~= 0

	local var_13_1 = var_0_6.craft_bar.size[1]

	arg_13_0.ui_scenegraph.craft_bar.size[1] = var_13_1 * arg_13_1

	if arg_13_1 == 1 then
		return true
	end
end

CraftPageCraftItem.craft_result = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not arg_14_2 then
		arg_14_0._craft_result = arg_14_1
	end
end

CraftPageCraftItem.reset = function (arg_15_0)
	local var_15_0 = arg_15_0._item_grid

	var_15_0:clear_locked_items()
	var_15_0:update_items_status()
	arg_15_0:_set_craft_button_disabled(not arg_15_0._has_all_requirements)
end

CraftPageCraftItem.on_craft_completed = function (arg_16_0)
	local var_16_0 = arg_16_0._craft_result
	local var_16_1 = arg_16_0._item_grid

	table.clear(arg_16_0._craft_items)

	for iter_16_0 = 1, var_0_9 do
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

		arg_16_0:_add_craft_item(var_16_4, iter_16_3, var_16_3)
	end

	var_16_1:clear_locked_items()

	for iter_16_5, iter_16_6 in pairs(arg_16_0._craft_items) do
		var_16_1:lock_item_by_id(iter_16_6, true)
	end

	var_16_1:update_items_status()

	arg_16_0._num_craft_items = 0

	arg_16_0:_set_craft_button_disabled(true)

	arg_16_0._craft_result = nil

	arg_16_0:setup_recipe_requirements()
end

CraftPageCraftItem._update_craft_items = function (arg_17_0)
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
					arg_17_0:setup_recipe_requirements()
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

CraftPageCraftItem._remove_craft_item = function (arg_18_0, arg_18_1, arg_18_2)
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

		arg_18_0:_play_sound("play_gui_craft_item_drag")
		arg_18_0:setup_recipe_requirements()

		arg_18_0._widgets_by_name.item_grid_random_icon.content.visible = true
	end
end

CraftPageCraftItem._add_craft_item = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if arg_19_0._num_craft_items == 0 then
		arg_19_0._item_grid:clear_item_grid()
		table.clear(arg_19_0._craft_items)
	end

	local var_19_0 = arg_19_0._craft_items

	if not arg_19_2 then
		for iter_19_0 = 1, var_0_9 do
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

		arg_19_0._item_grid:add_item_to_slot_index(arg_19_2, var_19_2)
		arg_19_0.super_parent:set_disabled_backend_id(arg_19_1, true)

		arg_19_0._num_craft_items = math.min((arg_19_0._num_craft_items or 0) + 1, var_0_9)

		if arg_19_1 and not arg_19_3 then
			arg_19_0:_play_sound("play_gui_craft_item_drop")
		end

		arg_19_0._widgets_by_name.item_grid_random_icon.content.visible = false
	end

	arg_19_0:setup_recipe_requirements()
end

CraftPageCraftItem._set_craft_button_disabled = function (arg_20_0, arg_20_1)
	arg_20_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_20_1
end

CraftPageCraftItem._exit = function (arg_21_0, arg_21_1)
	arg_21_0.exit = true
	arg_21_0.exit_level_id = arg_21_1
end

CraftPageCraftItem.draw = function (arg_22_0, arg_22_1)
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

CraftPageCraftItem._play_sound = function (arg_23_0, arg_23_1)
	arg_23_0.super_parent:play_sound(arg_23_1)
end

CraftPageCraftItem._set_craft_button_text = function (arg_24_0, arg_24_1, arg_24_2)
	arg_24_0._widgets_by_name.craft_button.content.button_text = arg_24_2 and Localize(arg_24_1) or arg_24_1
end
