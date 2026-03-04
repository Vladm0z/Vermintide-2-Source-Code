-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_convert_dust.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_convert_dust_definitions")
local var_0_4 = var_0_3.widgets
local var_0_5 = var_0_3.category_settings
local var_0_6 = var_0_3.scenegraph_definition
local var_0_7 = var_0_3.animation_definitions
local var_0_8 = false
local var_0_9 = 1

CraftPageConvertDust = class(CraftPageConvertDust)
CraftPageConvertDust.NAME = "CraftPageConvertDust"

CraftPageConvertDust.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroWindowCraft] Enter Substate CraftPageConvertDust")

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
	arg_1_0._item_grid = ItemGridUI:new(var_0_5, arg_1_0._widgets_by_name.item_grid, arg_1_0.hero_name, arg_1_0.career_index)

	arg_1_0._item_grid:disable_locked_items(true)
	arg_1_0._item_grid:mark_locked_items(true)
	arg_1_0._item_grid:hide_slots(true)
	arg_1_0._item_grid:disable_item_drag()
	arg_1_0.super_parent:clear_disabled_backend_ids()
	arg_1_0:setup_recipe_requirements()
end

CraftPageConvertDust._has_required_item_amount = function (arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0:_get_recipe_by_backend_id(arg_2_1)
	local var_2_1 = var_0_1[var_2_0]
	local var_2_2 = var_2_1.item_filter
	local var_2_3 = var_2_1.ingredients
	local var_2_4 = Managers.backend:get_interface("items")
	local var_2_5 = var_2_4:get_filtered_items(var_2_2)
	local var_2_6 = var_2_4:get_item_amount(arg_2_1)
	local var_2_7 = var_2_4:get_item_from_id(arg_2_1)

	for iter_2_0, iter_2_1 in ipairs(var_2_3) do
		if not iter_2_1.catergory then
			local var_2_8 = iter_2_1.name
			local var_2_9 = iter_2_1.amount

			if var_2_7.key == var_2_8 then
				return var_2_9 <= var_2_6
			end
		end
	end

	return false
end

CraftPageConvertDust._get_recipe_by_backend_id = function (arg_3_0, arg_3_1)
	local var_3_0 = Managers.backend:get_interface("items"):get_key(arg_3_1)
	local var_3_1

	if var_3_0 == "crafting_material_dust_2" then
		var_3_1 = "convert_blue_dust"
	elseif var_3_0 == "crafting_material_dust_3" then
		var_3_1 = "convert_orange_dust"
	end

	return var_3_1
end

CraftPageConvertDust.setup_recipe_requirements = function (arg_4_0)
	local var_4_0 = arg_4_0.settings
	local var_4_1
	local var_4_2 = var_4_0.item_filter
	local var_4_3 = arg_4_0._craft_items[1]

	if var_4_3 then
		var_4_1 = arg_4_0:_get_recipe_by_backend_id(var_4_3)
	end

	arg_4_0._recipe_name = var_4_1 or var_4_0.name

	local var_4_4 = true

	if not var_4_1 then
		var_4_4 = false

		arg_4_0:reset_requirements(0)
	else
		local var_4_5 = var_0_1[var_4_1]
		local var_4_6 = var_4_5.item_filter
		local var_4_7 = var_4_5.ingredients
		local var_4_8 = var_4_5.presentation_ingredients
		local var_4_9 = 0

		for iter_4_0, iter_4_1 in ipairs(var_4_8) do
			if not iter_4_1.catergory then
				var_4_9 = var_4_9 + 1
			end
		end

		arg_4_0:reset_requirements(var_4_9)

		for iter_4_2, iter_4_3 in ipairs(var_4_8) do
			local var_4_10 = iter_4_3.name
			local var_4_11 = iter_4_3.amount
			local var_4_12 = tostring(var_4_11)

			arg_4_0:_add_crafting_material_requirement(iter_4_2, var_4_10, var_4_12, true)
		end

		local var_4_13 = Managers.backend:get_interface("items")
		local var_4_14 = var_4_13:get_filtered_items(var_4_6)

		for iter_4_4, iter_4_5 in ipairs(var_4_7) do
			if not iter_4_5.catergory then
				local var_4_15 = iter_4_5.name
				local var_4_16 = iter_4_5.amount
				local var_4_17 = 0
				local var_4_18

				for iter_4_6, iter_4_7 in ipairs(var_4_14) do
					local var_4_19 = iter_4_7.backend_id

					if iter_4_7.data.key == var_4_15 then
						local var_4_20 = var_4_19

						var_4_17 = var_4_13:get_item_amount(var_4_19)

						break
					end
				end

				if not (var_4_16 <= var_4_17) then
					var_4_4 = false
				end
			end
		end
	end

	arg_4_0._has_all_requirements = var_4_3 and var_4_4

	if arg_4_0._has_all_requirements then
		arg_4_0:_set_craft_button_disabled(false)
	else
		arg_4_0:_set_craft_button_disabled(true)
	end
end

CraftPageConvertDust.reset_requirements = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._widgets_by_name
	local var_5_1 = 60
	local var_5_2 = 94
	local var_5_3 = -((var_5_1 + var_5_2) * (arg_5_1 - 1)) / 2

	for iter_5_0 = 1, 2 do
		local var_5_4 = var_5_0["material_text_" .. iter_5_0]
		local var_5_5 = iter_5_0 <= arg_5_1

		var_5_4.content.visible = var_5_5
		var_5_4.content.draw_background = false

		if var_5_5 then
			var_5_4.offset[1] = var_5_3
			var_5_3 = var_5_3 + var_5_1 + var_5_2
		end
	end
end

CraftPageConvertDust._add_crafting_material_requirement = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = UISettings.crafting_material_icons_small
	local var_6_1 = arg_6_0._widgets_by_name["material_text_" .. arg_6_1].content

	var_6_1.icon, var_6_1.text = var_6_0[arg_6_2], arg_6_3
	var_6_1.warning = not arg_6_4
	var_6_1.item = {
		data = table.clone(ItemMasterList[arg_6_2])
	}
end

CraftPageConvertDust.create_ui_elements = function (arg_7_0, arg_7_1)
	arg_7_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_6)

	local var_7_0 = {}
	local var_7_1 = {}

	for iter_7_0, iter_7_1 in pairs(var_0_4) do
		local var_7_2 = UIWidget.init(iter_7_1)

		var_7_0[#var_7_0 + 1] = var_7_2
		var_7_1[iter_7_0] = var_7_2
	end

	arg_7_0._widgets = var_7_0
	arg_7_0._widgets_by_name = var_7_1

	UIRenderer.clear_scenegraph_queue(arg_7_0.ui_renderer)

	arg_7_0.ui_animator = UIAnimator:new(arg_7_0.ui_scenegraph, var_0_7)

	arg_7_0:_set_craft_button_disabled(true)
	arg_7_0:_handle_craft_input_progress(0)
end

CraftPageConvertDust.on_exit = function (arg_8_0, arg_8_1)
	print("[HeroWindowCraft] Exit Substate CraftPageConvertDust")

	arg_8_0.ui_animator = nil

	if arg_8_0._craft_input_time then
		arg_8_0:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageConvertDust.update = function (arg_9_0, arg_9_1, arg_9_2)
	if var_0_8 then
		var_0_8 = false

		arg_9_0:create_ui_elements()
	end

	arg_9_0:_handle_input(arg_9_1, arg_9_2)
	arg_9_0:_update_animations(arg_9_1)
	arg_9_0:_update_craft_items()
	arg_9_0:draw(arg_9_1)
end

CraftPageConvertDust.post_update = function (arg_10_0, arg_10_1, arg_10_2)
	return
end

CraftPageConvertDust._update_animations = function (arg_11_0, arg_11_1)
	arg_11_0.ui_animator:update(arg_11_1)

	local var_11_0 = arg_11_0._animations
	local var_11_1 = arg_11_0.ui_animator

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		if var_11_1:is_animation_completed(iter_11_1) then
			var_11_1:stop_animation(iter_11_1)

			var_11_0[iter_11_0] = nil
		end
	end

	local var_11_2 = arg_11_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_11_2.craft_button, arg_11_1)
end

CraftPageConvertDust._is_button_pressed = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	if var_12_0.on_release then
		var_12_0.on_release = false

		return true
	end
end

CraftPageConvertDust._is_button_hovered = function (arg_13_0, arg_13_1)
	if arg_13_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageConvertDust._is_button_held = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.content.button_hotspot

	if var_14_0.is_clicked then
		return var_14_0.is_clicked
	end
end

CraftPageConvertDust._handle_input = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.parent

	if var_15_0:waiting_for_craft() or arg_15_0._craft_result then
		return
	end

	local var_15_1 = arg_15_0._widgets_by_name
	local var_15_2 = arg_15_0.super_parent
	local var_15_3 = Managers.input:is_device_active("gamepad")
	local var_15_4 = arg_15_0.super_parent:window_input_service()
	local var_15_5 = not var_15_1.craft_button.content.button_hotspot.disable_button
	local var_15_6 = arg_15_0:_is_button_held(var_15_1.craft_button)
	local var_15_7 = var_15_5 and var_15_3 and var_15_4:get("refresh_hold")
	local var_15_8 = false

	if (var_15_6 == 0 or var_15_7) and arg_15_0._has_all_requirements then
		if not arg_15_0._craft_input_time then
			arg_15_0._craft_input_time = 0

			arg_15_0:_play_sound("play_gui_craft_forge_button_begin")
		else
			arg_15_0._craft_input_time = arg_15_0._craft_input_time + arg_15_1
		end

		local var_15_9 = UISettings.crafting_progress_time
		local var_15_10 = math.min(arg_15_0._craft_input_time / var_15_9, 1)

		var_15_8 = arg_15_0:_handle_craft_input_progress(var_15_10)

		WwiseWorld.set_global_parameter(arg_15_0.wwise_world, "craft_forge_button_progress", var_15_10)
	elseif arg_15_0._craft_input_time then
		arg_15_0._craft_input_time = nil

		arg_15_0:_handle_craft_input_progress(0)
		arg_15_0:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if var_15_8 then
		local var_15_11 = arg_15_0._craft_items
		local var_15_12 = {}

		for iter_15_0, iter_15_1 in ipairs(var_15_11) do
			var_15_12[#var_15_12 + 1] = iter_15_1
		end

		if var_15_0:craft(var_15_12, arg_15_0._recipe_name) then
			arg_15_0:_set_craft_button_disabled(true)

			local var_15_13 = arg_15_0._item_grid

			for iter_15_2, iter_15_3 in pairs(var_15_12) do
				var_15_13:lock_item_by_id(iter_15_3, true)
			end

			var_15_13:update_items_status()
			arg_15_0:_play_sound("play_gui_craft_forge_button_completed")
			arg_15_0:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

CraftPageConvertDust._handle_craft_input_progress = function (arg_16_0, arg_16_1)
	local var_16_0

	var_16_0 = arg_16_1 ~= 0

	local var_16_1 = var_0_6.craft_bar.size[1]

	arg_16_0.ui_scenegraph.craft_bar.size[1] = var_16_1 * arg_16_1

	if arg_16_1 == 1 then
		return true
	end
end

CraftPageConvertDust.craft_result = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if not arg_17_2 then
		arg_17_0._craft_result = arg_17_1
	end
end

CraftPageConvertDust.reset = function (arg_18_0)
	local var_18_0 = arg_18_0._item_grid

	var_18_0:clear_locked_items()
	var_18_0:update_items_status()
end

CraftPageConvertDust.on_craft_completed = function (arg_19_0)
	local var_19_0 = arg_19_0._craft_result
	local var_19_1 = arg_19_0._item_grid

	arg_19_0.super_parent:clear_disabled_backend_ids()
	arg_19_0.super_parent:update_inventory_items()

	local var_19_2 = false

	arg_19_0._num_craft_items = 0

	local var_19_3 = arg_19_0._craft_items[1]

	if Managers.backend:get_interface("items"):get_item_from_id(var_19_3) then
		var_19_2 = true
	end

	if var_19_2 then
		local var_19_4 = true

		arg_19_0:_add_craft_item(var_19_3, 1, var_19_4)
	else
		var_19_1:clear_item_grid()
		table.clear(arg_19_0._craft_items)
	end

	var_19_1:clear_locked_items()

	for iter_19_0, iter_19_1 in pairs(arg_19_0._craft_items) do
		var_19_1:lock_item_by_id(iter_19_1, true)
	end

	var_19_1:update_items_status()
	arg_19_0:_set_craft_button_disabled(true)

	arg_19_0._craft_result = nil

	arg_19_0:setup_recipe_requirements()
end

CraftPageConvertDust._update_craft_items = function (arg_20_0)
	local var_20_0 = arg_20_0.super_parent
	local var_20_1 = arg_20_0._item_grid
	local var_20_2 = var_20_1:is_dragging_item() or var_20_1:is_item_dragged() ~= nil
	local var_20_3, var_20_4 = var_20_0:get_pressed_item_backend_id()

	if var_20_3 then
		if var_20_4 then
			if not var_20_2 then
				local var_20_5 = var_20_1:is_slot_hovered()

				if var_20_5 then
					arg_20_0:_add_craft_item(var_20_3, var_20_5)
					arg_20_0:setup_recipe_requirements()
				end
			end
		else
			arg_20_0:_add_craft_item(var_20_3)
			arg_20_0:setup_recipe_requirements()
		end
	end

	local var_20_6 = var_20_1:is_item_pressed()

	if var_20_6 then
		local var_20_7 = var_20_6.backend_id

		arg_20_0:_remove_craft_item(var_20_7)
	end
end

CraftPageConvertDust._remove_craft_item = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._craft_items

	if arg_21_2 then
		if var_21_0[arg_21_2] then
			arg_21_1 = var_21_0[arg_21_2]
		end
	else
		for iter_21_0, iter_21_1 in pairs(var_21_0) do
			if iter_21_1 == arg_21_1 then
				arg_21_2 = iter_21_0

				break
			end
		end
	end

	if arg_21_1 and arg_21_2 then
		arg_21_0.super_parent:set_disabled_backend_id(arg_21_1, false)
		arg_21_0._item_grid:add_item_to_slot_index(arg_21_2, nil)

		var_21_0[arg_21_2] = nil
		arg_21_0._num_craft_items = math.max((arg_21_0._num_craft_items or 0) - 1, 0)

		if arg_21_0._num_craft_items == 0 then
			arg_21_0:_set_craft_button_disabled(true)
		end

		arg_21_0:_play_sound("play_gui_craft_item_drag")
		arg_21_0:setup_recipe_requirements()
	end
end

CraftPageConvertDust._add_craft_item = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if arg_22_0._num_craft_items == 0 then
		arg_22_0._item_grid:clear_item_grid()
		table.clear(arg_22_0._craft_items)
	end

	local var_22_0 = arg_22_0._craft_items

	if not arg_22_2 then
		for iter_22_0 = 1, 1 do
			if not var_22_0[iter_22_0] then
				arg_22_2 = iter_22_0

				break
			end
		end
	end

	if arg_22_2 then
		var_22_0[arg_22_2] = arg_22_1

		local var_22_1 = Managers.backend:get_interface("items")
		local var_22_2 = arg_22_1 and var_22_1:get_item_from_id(arg_22_1)

		if var_22_2 then
			var_22_2 = table.clone(var_22_2)
			var_22_2.insufficient_amount = not arg_22_0:_has_required_item_amount(arg_22_1)
		end

		arg_22_0._item_grid:add_item_to_slot_index(arg_22_2, var_22_2)
		arg_22_0.super_parent:set_disabled_backend_id(arg_22_1, true)

		arg_22_0._num_craft_items = math.min((arg_22_0._num_craft_items or 0) + 1, var_0_9)

		if arg_22_1 and not arg_22_3 then
			arg_22_0:_play_sound("play_gui_craft_item_drop")
		end
	end
end

CraftPageConvertDust._set_craft_button_disabled = function (arg_23_0, arg_23_1)
	arg_23_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_23_1
end

CraftPageConvertDust._exit = function (arg_24_0, arg_24_1)
	arg_24_0.exit = true
	arg_24_0.exit_level_id = arg_24_1
end

CraftPageConvertDust.draw = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.ui_renderer
	local var_25_1 = arg_25_0.ui_top_renderer
	local var_25_2 = arg_25_0.ui_scenegraph
	local var_25_3 = arg_25_0.super_parent:window_input_service()

	UIRenderer.begin_pass(var_25_1, var_25_2, var_25_3, arg_25_1, nil, arg_25_0.render_settings)

	for iter_25_0, iter_25_1 in ipairs(arg_25_0._widgets) do
		UIRenderer.draw_widget(var_25_1, iter_25_1)
	end

	UIRenderer.end_pass(var_25_1)
end

CraftPageConvertDust._play_sound = function (arg_26_0, arg_26_1)
	arg_26_0.super_parent:play_sound(arg_26_1)
end

CraftPageConvertDust._set_craft_button_text = function (arg_27_0, arg_27_1, arg_27_2)
	arg_27_0._widgets_by_name.craft_button.content.button_text = arg_27_2 and Localize(arg_27_1) or arg_27_1
end
