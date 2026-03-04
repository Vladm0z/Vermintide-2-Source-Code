-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_roll_properties.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_roll_properties_definitions")
local var_0_4 = var_0_3.widgets
local var_0_5 = var_0_3.category_settings
local var_0_6 = var_0_3.scenegraph_definition
local var_0_7 = var_0_3.animation_definitions
local var_0_8 = false
local var_0_9 = 1

CraftPageRollProperties = class(CraftPageRollProperties)
CraftPageRollProperties.NAME = "CraftPageRollProperties"

function CraftPageRollProperties.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroWindowCraft] Enter Substate CraftPageRollProperties")

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
	arg_1_0._recipe_grid = ItemGridUI:new(var_0_5, arg_1_0._widgets_by_name.recipe_grid, arg_1_0.hero_name, arg_1_0.career_index)

	arg_1_0._item_grid:disable_locked_items(true)
	arg_1_0._item_grid:mark_locked_items(true)
	arg_1_0._item_grid:hide_slots(true)
	arg_1_0._item_grid:disable_item_drag()
	arg_1_0._recipe_grid:disable_item_drag()
	arg_1_0.super_parent:clear_disabled_backend_ids()
	arg_1_0:setup_recipe_requirements()
end

function CraftPageRollProperties.setup_recipe_requirements(arg_2_0)
	local var_2_0 = arg_2_0._recipe_grid
	local var_2_1 = arg_2_0.settings.name
	local var_2_2 = var_0_1[var_2_1].ingredients
	local var_2_3 = arg_2_0._material_items

	table.clear(var_2_3)

	local var_2_4 = Managers.backend:get_interface("items")
	local var_2_5 = var_2_4:get_filtered_items("item_type == crafting_material")
	local var_2_6 = true
	local var_2_7 = 1

	for iter_2_0, iter_2_1 in ipairs(var_2_2) do
		if not iter_2_1.catergory then
			local var_2_8 = iter_2_1.name
			local var_2_9 = iter_2_1.amount
			local var_2_10 = 0
			local var_2_11

			for iter_2_2, iter_2_3 in ipairs(var_2_5) do
				local var_2_12 = iter_2_3.backend_id

				if iter_2_3.data.key == var_2_8 then
					var_2_11 = var_2_12
					var_2_10 = var_2_4:get_item_amount(var_2_12)

					break
				end
			end

			local var_2_13 = var_2_9 <= var_2_10
			local var_2_14 = (var_2_10 < UISettings.max_craft_material_presentation_amount and tostring(var_2_10) or "*") .. "/" .. tostring(var_2_9)
			local var_2_15 = {
				data = table.clone(ItemMasterList[var_2_8]),
				amount = var_2_14,
				insufficient_amount = not var_2_13
			}

			var_2_0:add_item_to_slot_index(var_2_7, var_2_15)

			var_2_7 = var_2_7 + 1

			if var_2_13 then
				var_2_3[#var_2_3 + 1] = var_2_11
			else
				var_2_6 = false
			end
		end
	end

	arg_2_0._has_all_requirements = var_2_6
end

function CraftPageRollProperties.create_ui_elements(arg_3_0, arg_3_1)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_6)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_4) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_7)

	arg_3_0:_set_craft_button_disabled(true)
	arg_3_0:_handle_craft_input_progress(0)
end

function CraftPageRollProperties.on_exit(arg_4_0, arg_4_1)
	print("[HeroWindowCraft] Exit Substate CraftPageRollProperties")

	arg_4_0.ui_animator = nil

	if arg_4_0._craft_input_time then
		arg_4_0:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

function CraftPageRollProperties.update(arg_5_0, arg_5_1, arg_5_2)
	if var_0_8 then
		var_0_8 = false

		arg_5_0:create_ui_elements()
	end

	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_update_craft_items()
	arg_5_0:draw(arg_5_1)
end

function CraftPageRollProperties.post_update(arg_6_0, arg_6_1, arg_6_2)
	return
end

function CraftPageRollProperties._update_animations(arg_7_0, arg_7_1)
	arg_7_0.ui_animator:update(arg_7_1)

	local var_7_0 = arg_7_0._animations
	local var_7_1 = arg_7_0.ui_animator

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		if var_7_1:is_animation_completed(iter_7_1) then
			var_7_1:stop_animation(iter_7_1)

			var_7_0[iter_7_0] = nil
		end
	end

	local var_7_2 = arg_7_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_7_2.craft_button, arg_7_1)
end

function CraftPageRollProperties._is_button_pressed(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.content.button_hotspot

	if var_8_0.on_release then
		var_8_0.on_release = false

		return true
	end
end

function CraftPageRollProperties._is_button_hovered(arg_9_0, arg_9_1)
	if arg_9_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

function CraftPageRollProperties._is_button_held(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.is_clicked then
		return var_10_0.is_clicked
	end
end

function CraftPageRollProperties._handle_input(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.parent

	if var_11_0:waiting_for_craft() or arg_11_0._craft_result then
		return
	end

	local var_11_1 = arg_11_0._widgets_by_name
	local var_11_2 = arg_11_0.super_parent
	local var_11_3 = Managers.input:is_device_active("gamepad")
	local var_11_4 = arg_11_0.super_parent:window_input_service()
	local var_11_5 = not var_11_1.craft_button.content.button_hotspot.disable_button
	local var_11_6 = arg_11_0:_is_button_held(var_11_1.craft_button)
	local var_11_7 = var_11_5 and var_11_3 and var_11_4:get("refresh_hold")
	local var_11_8 = false

	if (var_11_6 == 0 or var_11_7) and arg_11_0._has_all_requirements then
		if not arg_11_0._craft_input_time then
			arg_11_0._craft_input_time = 0

			arg_11_0:_play_sound("play_gui_craft_forge_button_begin")
		else
			arg_11_0._craft_input_time = arg_11_0._craft_input_time + arg_11_1
		end

		local var_11_9 = UISettings.crafting_progress_time
		local var_11_10 = math.min(arg_11_0._craft_input_time / var_11_9, 1)

		var_11_8 = arg_11_0:_handle_craft_input_progress(var_11_10)

		WwiseWorld.set_global_parameter(arg_11_0.wwise_world, "craft_forge_button_progress", var_11_10)
	elseif arg_11_0._craft_input_time then
		arg_11_0._craft_input_time = nil

		arg_11_0:_handle_craft_input_progress(0)
		arg_11_0:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if var_11_8 then
		local var_11_11 = arg_11_0._craft_items
		local var_11_12 = arg_11_0._material_items
		local var_11_13 = {}

		for iter_11_0, iter_11_1 in ipairs(var_11_11) do
			var_11_13[#var_11_13 + 1] = iter_11_1
		end

		for iter_11_2, iter_11_3 in ipairs(var_11_12) do
			var_11_13[#var_11_13 + 1] = iter_11_3
		end

		if var_11_0:craft(var_11_13, arg_11_0._recipe_name) then
			arg_11_0:_set_craft_button_disabled(true)

			local var_11_14 = arg_11_0._item_grid

			for iter_11_4, iter_11_5 in pairs(var_11_13) do
				var_11_14:lock_item_by_id(iter_11_5, true)
			end

			var_11_14:update_items_status()
			arg_11_0:_play_sound("play_gui_craft_forge_button_completed")
			arg_11_0:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

function CraftPageRollProperties._handle_craft_input_progress(arg_12_0, arg_12_1)
	local var_12_0

	var_12_0 = arg_12_1 ~= 0

	local var_12_1 = var_0_6.craft_bar.size[1]

	arg_12_0.ui_scenegraph.craft_bar.size[1] = var_12_1 * arg_12_1

	if arg_12_1 == 1 then
		return true
	end
end

function CraftPageRollProperties.craft_result(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not arg_13_2 then
		arg_13_0._craft_result = arg_13_1
	end
end

function CraftPageRollProperties.reset(arg_14_0)
	local var_14_0 = arg_14_0._item_grid

	var_14_0:clear_locked_items()
	var_14_0:update_items_status()
end

function CraftPageRollProperties.on_craft_completed(arg_15_0)
	local var_15_0 = arg_15_0._craft_result
	local var_15_1 = arg_15_0._item_grid

	arg_15_0.super_parent:clear_disabled_backend_ids()
	arg_15_0.super_parent:update_inventory_items()
	arg_15_0:setup_recipe_requirements()

	local var_15_2 = true

	for iter_15_0 = 1, var_0_9 do
		local var_15_3 = arg_15_0._craft_items[iter_15_0]

		arg_15_0:_remove_craft_item(var_15_3, iter_15_0, var_15_2)
		arg_15_0:_add_craft_item(var_15_3, iter_15_0, var_15_2)
	end

	arg_15_0._craft_result = nil
end

function CraftPageRollProperties._update_craft_items(arg_16_0)
	local var_16_0 = arg_16_0.super_parent
	local var_16_1 = arg_16_0._item_grid
	local var_16_2 = var_16_1:is_dragging_item() or var_16_1:is_item_dragged() ~= nil
	local var_16_3, var_16_4 = var_16_0:get_pressed_item_backend_id()

	if var_16_3 then
		if var_16_4 then
			if not var_16_2 then
				local var_16_5 = var_16_1:is_slot_hovered()

				if var_16_5 then
					arg_16_0:_add_craft_item(var_16_3, var_16_5)
				end
			end
		else
			arg_16_0:_add_craft_item(var_16_3)
		end
	end

	local var_16_6 = var_16_1:is_item_pressed()

	if var_16_6 then
		local var_16_7 = var_16_6.backend_id

		arg_16_0:_remove_craft_item(var_16_7)
	end
end

function CraftPageRollProperties._remove_craft_item(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
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

		if not arg_17_3 then
			arg_17_0:_play_sound("play_gui_craft_item_drag")
		end

		arg_17_0._recipe_name = arg_17_0.settings.name
	end
end

function CraftPageRollProperties._add_craft_item(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_0._num_craft_items == 0 then
		arg_18_0._item_grid:clear_item_grid()
		table.clear(arg_18_0._craft_items)
	end

	local var_18_0 = arg_18_0._craft_items

	if not arg_18_2 then
		for iter_18_0 = 1, 1 do
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
		local var_18_3 = arg_18_1 and var_18_1:get_item_masterlist_data(arg_18_1)
		local var_18_4 = var_18_3 and var_18_3.slot_type

		if var_18_4 == "ranged" or var_18_4 == "melee" then
			arg_18_0._recipe_name = "reroll_weapon_properties"
		elseif var_18_4 == "trinket" or var_18_4 == "ring" or var_18_4 == "necklace" then
			arg_18_0._recipe_name = "reroll_jewellery_properties"
		end

		arg_18_0._item_grid:add_item_to_slot_index(arg_18_2, var_18_2)
		arg_18_0.super_parent:set_disabled_backend_id(arg_18_1, true)

		arg_18_0._num_craft_items = math.min((arg_18_0._num_craft_items or 0) + 1, var_0_9)

		if arg_18_0._num_craft_items > 0 and arg_18_0._has_all_requirements then
			arg_18_0:_set_craft_button_disabled(false)
		end

		if arg_18_1 and not arg_18_3 then
			arg_18_0:_play_sound("play_gui_craft_item_drop")
		end
	end
end

function CraftPageRollProperties._set_craft_button_disabled(arg_19_0, arg_19_1)
	arg_19_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_19_1
end

function CraftPageRollProperties._exit(arg_20_0, arg_20_1)
	arg_20_0.exit = true
	arg_20_0.exit_level_id = arg_20_1
end

function CraftPageRollProperties.draw(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.ui_renderer
	local var_21_1 = arg_21_0.ui_top_renderer
	local var_21_2 = arg_21_0.ui_scenegraph
	local var_21_3 = arg_21_0.super_parent:window_input_service()

	UIRenderer.begin_pass(var_21_1, var_21_2, var_21_3, arg_21_1, nil, arg_21_0.render_settings)

	for iter_21_0, iter_21_1 in ipairs(arg_21_0._widgets) do
		UIRenderer.draw_widget(var_21_1, iter_21_1)
	end

	UIRenderer.end_pass(var_21_1)
end

function CraftPageRollProperties._play_sound(arg_22_0, arg_22_1)
	arg_22_0.super_parent:play_sound(arg_22_1)
end

function CraftPageRollProperties._set_craft_button_text(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0._widgets_by_name.craft_button.content.button_text = arg_23_2 and Localize(arg_23_1) or arg_23_1
end
