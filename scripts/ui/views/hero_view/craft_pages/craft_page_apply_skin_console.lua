-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_apply_skin_console.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_apply_skin_console_definitions")
local var_0_4 = var_0_3.widgets
local var_0_5 = var_0_3.category_settings
local var_0_6 = var_0_3.scenegraph_definition
local var_0_7 = var_0_3.animation_definitions
local var_0_8 = false
local var_0_9 = 1

CraftPageApplySkinConsole = class(CraftPageApplySkinConsole)
CraftPageApplySkinConsole.NAME = "CraftPageApplySkinConsole"

CraftPageApplySkinConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroWindowCraft] Enter Substate CraftPageApplySkinConsole")

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
	arg_1_0.career_name = SPProfiles[arg_1_0.profile_index].careers[arg_1_0.career_index].name
	arg_1_0.settings = arg_1_2
	arg_1_0._recipe_name = arg_1_2.name
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1)

	arg_1_0._material_items = {}
	arg_1_0._item_grid = ItemGridUI:new(var_0_5, arg_1_0._widgets_by_name.item_grid, arg_1_0.hero_name, arg_1_0.career_index)

	arg_1_0._item_grid:disable_locked_items(true)
	arg_1_0._item_grid:mark_locked_items(true)
	arg_1_0._item_grid:hide_slots(true)
	arg_1_0._item_grid:disable_item_drag()

	arg_1_0._item_grid_2 = ItemGridUI:new(var_0_5, arg_1_0._widgets_by_name.item_grid_2, arg_1_0.hero_name, arg_1_0.career_index)

	arg_1_0._item_grid_2:disable_item_drag()
	arg_1_0._item_grid_2:mark_locked_items(true)
	arg_1_0._item_grid_2:hide_slots(true)
	arg_1_0._item_grid_2:disable_item_drag()
	arg_1_0.super_parent:clear_disabled_backend_ids()
	arg_1_0:_weapon_slot_updated()
	arg_1_0:setup_recipe_requirements()
end

CraftPageApplySkinConsole.setup_recipe_requirements = function (arg_2_0)
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

CraftPageApplySkinConsole.reset_requirements = function (arg_3_0, arg_3_1)
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

CraftPageApplySkinConsole.create_ui_elements = function (arg_4_0, arg_4_1)
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

CraftPageApplySkinConsole._weapon_slot_updated = function (arg_5_0)
	local var_5_0 = Managers.backend:get_interface("items")
	local var_5_1 = arg_5_0._craft_item
	local var_5_2 = var_5_1 and var_5_0:get_item_masterlist_data(var_5_1)
	local var_5_3

	var_5_3 = var_5_2 and var_5_2.slot_type

	if var_5_2 then
		local var_5_4 = var_5_2.key .. "_skin"
		local var_5_5 = "item_key == " .. var_5_4

		arg_5_0.parent.parent:set_craft_optional_item_filter(var_5_5)
		arg_5_0.parent.parent:disable_filter(true)
		arg_5_0.parent.parent:disable_search(true)
	else
		arg_5_0.parent.parent:set_craft_optional_item_filter(nil)
		arg_5_0.parent.parent:disable_filter(false)
		arg_5_0.parent.parent:disable_search(false)
	end
end

CraftPageApplySkinConsole.on_exit = function (arg_6_0, arg_6_1)
	arg_6_0.parent.parent:set_craft_optional_item_filter(nil)
	arg_6_0.parent.parent:disable_filter(false)
	arg_6_0.parent.parent:disable_search(false)
	print("[HeroWindowCraft] Exit Substate CraftPageApplySkinConsole")

	arg_6_0.ui_animator = nil

	if arg_6_0._craft_input_time then
		arg_6_0:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

CraftPageApplySkinConsole.update = function (arg_7_0, arg_7_1, arg_7_2)
	if var_0_8 then
		var_0_8 = false

		arg_7_0:create_ui_elements()
	end

	arg_7_0:_handle_input(arg_7_1, arg_7_2)
	arg_7_0:_update_animations(arg_7_1)
	arg_7_0:_update_craft_items()
	arg_7_0:draw(arg_7_1)
end

CraftPageApplySkinConsole.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	return
end

CraftPageApplySkinConsole._update_animations = function (arg_9_0, arg_9_1)
	arg_9_0.ui_animator:update(arg_9_1)

	local var_9_0 = arg_9_0._animations
	local var_9_1 = arg_9_0.ui_animator

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if var_9_1:is_animation_completed(iter_9_1) then
			var_9_1:stop_animation(iter_9_1)

			var_9_0[iter_9_0] = nil
		end
	end

	local var_9_2 = arg_9_0._widgets_by_name
end

CraftPageApplySkinConsole._is_button_pressed = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.on_release then
		var_10_0.on_release = false

		return true
	end
end

CraftPageApplySkinConsole._is_button_hovered = function (arg_11_0, arg_11_1)
	if arg_11_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

CraftPageApplySkinConsole._is_button_held = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	if var_12_0.is_clicked then
		return var_12_0.is_clicked
	end
end

CraftPageApplySkinConsole._handle_input = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.parent

	if var_13_0:waiting_for_craft() or arg_13_0._craft_result then
		return
	end

	local var_13_1 = arg_13_0._widgets_by_name
	local var_13_2 = arg_13_0.super_parent
	local var_13_3 = Managers.input:is_device_active("gamepad")
	local var_13_4 = arg_13_0.super_parent:window_input_service()
	local var_13_5 = not var_13_1.craft_button.content.button_hotspot.disable_button
	local var_13_6 = arg_13_0:_is_button_held(var_13_1.craft_button)
	local var_13_7 = var_13_5 and var_13_3 and var_13_4:get("refresh_hold")
	local var_13_8 = var_13_5 and not var_13_3 and var_13_4:get("skip")
	local var_13_9 = false

	if var_13_4:get("special_1") or arg_13_0._craft_item and var_13_4:get("toggle_menu", true) then
		arg_13_0:reset()
	elseif (var_13_6 == 0 or var_13_7 or var_13_8) and arg_13_0._craft_item and arg_13_0._skin_item and arg_13_0._has_all_requirements then
		if not arg_13_0._craft_input_time then
			arg_13_0._craft_input_time = 0

			arg_13_0:_play_sound("play_gui_craft_forge_button_begin")
		else
			arg_13_0._craft_input_time = arg_13_0._craft_input_time + arg_13_1
		end

		local var_13_10 = UISettings.crafting_progress_time
		local var_13_11 = math.min(arg_13_0._craft_input_time / var_13_10, 1)

		var_13_9 = arg_13_0:_handle_craft_input_progress(var_13_11)

		WwiseWorld.set_global_parameter(arg_13_0.wwise_world, "craft_forge_button_progress", var_13_11)
	elseif arg_13_0._craft_input_time then
		arg_13_0._craft_input_time = nil

		arg_13_0:_handle_craft_input_progress(0)
		arg_13_0:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if var_13_9 then
		local var_13_12 = arg_13_0._craft_item
		local var_13_13 = arg_13_0._skin_item
		local var_13_14 = {
			var_13_12,
			var_13_13
		}
		local var_13_15 = arg_13_0._material_items

		for iter_13_0, iter_13_1 in ipairs(var_13_15) do
			var_13_14[#var_13_14 + 1] = iter_13_1
		end

		if var_13_0:craft(var_13_14, arg_13_0._recipe_name) then
			arg_13_0:_set_craft_button_disabled(true)
			arg_13_0._item_grid:lock_item_by_id(var_13_12, true)
			arg_13_0._item_grid:update_items_status()
			arg_13_0._item_grid_2:lock_item_by_id(var_13_13, true)
			arg_13_0._item_grid_2:update_items_status()
			arg_13_0:_play_sound("play_gui_craft_forge_button_completed")
			arg_13_0:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

CraftPageApplySkinConsole._handle_craft_input_progress = function (arg_14_0, arg_14_1)
	return arg_14_0.parent:_set_input_progress(arg_14_1)
end

CraftPageApplySkinConsole.craft_result = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if not arg_15_2 then
		arg_15_0._craft_result = arg_15_1
	end
end

CraftPageApplySkinConsole.reset = function (arg_16_0)
	local var_16_0 = arg_16_0._item_grid
	local var_16_1 = arg_16_0._item_grid_2

	if arg_16_0._craft_item then
		arg_16_0:_remove_item(var_16_0, arg_16_0._craft_item)

		arg_16_0._craft_item = nil
	end

	if arg_16_0._skin_item then
		arg_16_0:_remove_item(var_16_1, arg_16_0._skin_item)

		arg_16_0._skin_item = nil
	end

	var_16_0:clear_locked_items()
	var_16_0:update_items_status()
	var_16_1:clear_locked_items()
	var_16_1:update_items_status()
	arg_16_0:_weapon_slot_updated()
end

CraftPageApplySkinConsole.present_results = function (arg_17_0)
	arg_17_0.super_parent:clear_disabled_backend_ids()
	arg_17_0.super_parent:update_inventory_items()
	arg_17_0:_weapon_slot_updated()
	arg_17_0:setup_recipe_requirements()
end

CraftPageApplySkinConsole.on_craft_completed = function (arg_18_0)
	local var_18_0 = arg_18_0._item_grid
	local var_18_1 = arg_18_0._item_grid_2
	local var_18_2 = arg_18_0._craft_item
	local var_18_3 = Managers.backend:get_interface("items"):get_item_from_id(var_18_2)

	arg_18_0.parent:set_reward_tooltip_item(var_18_3)

	if arg_18_0._craft_item then
		arg_18_0:_remove_item(var_18_0, arg_18_0._craft_item)

		arg_18_0._craft_item = nil
	end

	if arg_18_0._skin_item then
		arg_18_0:_remove_item(var_18_1, arg_18_0._skin_item)

		arg_18_0._skin_item = nil
	end

	arg_18_0._craft_result = nil

	if var_18_2 and ItemHelper.is_equiped_backend_id(var_18_2, arg_18_0.career_name) then
		local var_18_4 = Managers.backend:get_interface("items"):get_item_from_id(var_18_2)
		local var_18_5, var_18_6 = ItemHelper.get_equipped_slots(var_18_2, arg_18_0.career_name)

		for iter_18_0 = 1, var_18_6 do
			arg_18_0.super_parent:_set_loadout_item(var_18_4, var_18_5[iter_18_0])
		end

		if var_18_4.data.slot_type == "skin" then
			arg_18_0.super_parent:update_skin_sync()
		end
	end
end

CraftPageApplySkinConsole._update_craft_items = function (arg_19_0)
	local var_19_0 = arg_19_0.super_parent
	local var_19_1 = arg_19_0._item_grid
	local var_19_2 = arg_19_0._item_grid_2
	local var_19_3, var_19_4 = var_19_0:get_pressed_item_backend_id()

	if var_19_3 then
		if not arg_19_0._craft_item then
			arg_19_0:_add_item(var_19_1, var_19_3)

			arg_19_0._craft_item = var_19_3

			arg_19_0:_weapon_slot_updated()
		else
			if arg_19_0._skin_item then
				arg_19_0.super_parent:set_disabled_backend_id(arg_19_0._skin_item, false)
			end

			local var_19_5 = true

			if arg_19_0._skin_item == var_19_3 then
				arg_19_0:_remove_item(var_19_2, var_19_3)

				arg_19_0._skin_item = nil
				var_19_5 = false
			end

			if var_19_5 then
				arg_19_0:_add_item(var_19_2, var_19_3)

				arg_19_0._skin_item = var_19_3
			end

			arg_19_0:_weapon_slot_updated()

			if arg_19_0._has_all_requirements then
				arg_19_0:_set_craft_button_disabled(false)
			end
		end
	end

	local var_19_6 = var_19_1:is_item_pressed()

	if var_19_6 then
		local var_19_7 = var_19_6.backend_id

		arg_19_0:_remove_item(var_19_1, var_19_7)

		arg_19_0._craft_item = nil

		if arg_19_0._skin_item then
			arg_19_0:_remove_item(var_19_2, arg_19_0._skin_item)

			arg_19_0._skin_item = nil
		end

		arg_19_0:_weapon_slot_updated()
		arg_19_0:_set_craft_button_disabled(true)
	end

	local var_19_8 = var_19_2:is_item_pressed()

	if var_19_8 then
		local var_19_9 = var_19_8.backend_id

		arg_19_0:_remove_item(var_19_2, var_19_9)

		arg_19_0._skin_item = nil

		arg_19_0:_weapon_slot_updated()
		arg_19_0:_set_craft_button_disabled(true)
	end
end

CraftPageApplySkinConsole._remove_item = function (arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.super_parent:set_disabled_backend_id(arg_20_2, false)
	arg_20_1:add_item_to_slot_index(1, nil)
	arg_20_0:_set_craft_button_disabled(true)
	arg_20_0:_play_sound("play_gui_craft_item_drag")
end

CraftPageApplySkinConsole._add_item = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_1:clear_item_grid()

	local var_21_0 = 1

	if var_21_0 then
		local var_21_1 = Managers.backend:get_interface("items")
		local var_21_2 = arg_21_2 and var_21_1:get_item_from_id(arg_21_2)

		arg_21_1:add_item_to_slot_index(var_21_0, var_21_2)
		arg_21_0.super_parent:set_disabled_backend_id(arg_21_2, true)

		if arg_21_2 and not arg_21_3 then
			arg_21_0:_play_sound("play_gui_craft_item_drop")
		end
	end
end

CraftPageApplySkinConsole._set_craft_button_disabled = function (arg_22_0, arg_22_1)
	arg_22_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_22_1

	arg_22_0.parent:set_input_description(not arg_22_1 and arg_22_0.settings.name or "disabled")
end

CraftPageApplySkinConsole._exit = function (arg_23_0, arg_23_1)
	arg_23_0.exit = true
	arg_23_0.exit_level_id = arg_23_1
end

CraftPageApplySkinConsole.draw = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.ui_renderer
	local var_24_1 = arg_24_0.ui_top_renderer
	local var_24_2 = arg_24_0.ui_scenegraph
	local var_24_3 = arg_24_0.super_parent:window_input_service()

	UIRenderer.begin_pass(var_24_1, var_24_2, var_24_3, arg_24_1, nil, arg_24_0.render_settings)

	for iter_24_0, iter_24_1 in ipairs(arg_24_0._widgets) do
		UIRenderer.draw_widget(var_24_1, iter_24_1)
	end

	UIRenderer.end_pass(var_24_1)
end

CraftPageApplySkinConsole._play_sound = function (arg_25_0, arg_25_1)
	arg_25_0.super_parent:play_sound(arg_25_1)
end

CraftPageApplySkinConsole._set_craft_button_text = function (arg_26_0, arg_26_1, arg_26_2)
	arg_26_0._widgets_by_name.craft_button.content.button_text = arg_26_2 and Localize(arg_26_1) or arg_26_1
end

CraftPageApplySkinConsole._add_crafting_material_requirement = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = UISettings.crafting_material_icons_small
	local var_27_1 = arg_27_0._widgets_by_name["material_text_" .. arg_27_1].content

	var_27_1.icon, var_27_1.text = var_27_0[arg_27_2], arg_27_3
	var_27_1.warning = not arg_27_4
	var_27_1.item = {
		data = table.clone(ItemMasterList[arg_27_2])
	}
end
