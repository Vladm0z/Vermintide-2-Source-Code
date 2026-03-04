-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_apply_skin.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_apply_skin_definitions")
local var_0_4 = var_0_3.widgets
local var_0_5 = var_0_3.category_settings
local var_0_6 = var_0_3.scenegraph_definition
local var_0_7 = var_0_3.animation_definitions
local var_0_8 = false
local var_0_9 = 1

CraftPageApplySkin = class(CraftPageApplySkin)
CraftPageApplySkin.NAME = "CraftPageApplySkin"

function CraftPageApplySkin.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroWindowCraft] Enter Substate CraftPageApplySkin")

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
	arg_1_0.career_name = SPProfiles[arg_1_0.profile_index].careers[arg_1_0.career_index].name
	arg_1_0.wwise_world = arg_1_1.wwise_world
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

	arg_1_0._recipe_grid = ItemGridUI:new(var_0_5, arg_1_0._widgets_by_name.recipe_grid, arg_1_0.hero_name, arg_1_0.career_index)

	arg_1_0._recipe_grid:disable_item_drag()
	arg_1_0._recipe_grid:hide_slots(true)
	arg_1_0.super_parent:clear_disabled_backend_ids()
	arg_1_0:_weapon_slot_updated()
	arg_1_0:setup_recipe_requirements()
end

function CraftPageApplySkin.setup_recipe_requirements(arg_2_0)
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

function CraftPageApplySkin.create_ui_elements(arg_3_0, arg_3_1)
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

function CraftPageApplySkin._weapon_slot_updated(arg_4_0)
	local var_4_0 = Managers.backend:get_interface("items")
	local var_4_1 = arg_4_0._craft_item
	local var_4_2 = var_4_1 and var_4_0:get_item_masterlist_data(var_4_1)
	local var_4_3

	var_4_3 = var_4_2 and var_4_2.slot_type

	if var_4_2 then
		local var_4_4 = var_4_2.key .. "_skin"
		local var_4_5 = "is_fake_item and item_key == " .. var_4_4

		arg_4_0.parent.parent:set_craft_optional_item_filter(var_4_5)
	else
		arg_4_0.parent.parent:set_craft_optional_item_filter(nil)
	end
end

function CraftPageApplySkin.on_exit(arg_5_0, arg_5_1)
	arg_5_0.parent.parent:set_craft_optional_item_filter(nil)
	print("[HeroWindowCraft] Exit Substate CraftPageApplySkin")

	arg_5_0.ui_animator = nil

	if arg_5_0._craft_input_time then
		arg_5_0:_play_sound("play_gui_craft_forge_button_aborted")
	end
end

function CraftPageApplySkin.update(arg_6_0, arg_6_1, arg_6_2)
	if var_0_8 then
		var_0_8 = false

		arg_6_0:create_ui_elements()
	end

	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_update_craft_items()
	arg_6_0:draw(arg_6_1)
end

function CraftPageApplySkin.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function CraftPageApplySkin._update_animations(arg_8_0, arg_8_1)
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

function CraftPageApplySkin._is_button_pressed(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.on_release then
		var_9_0.on_release = false

		return true
	end
end

function CraftPageApplySkin._is_button_hovered(arg_10_0, arg_10_1)
	if arg_10_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

function CraftPageApplySkin._is_button_held(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	if var_11_0.is_clicked then
		return var_11_0.is_clicked
	end
end

function CraftPageApplySkin._handle_input(arg_12_0, arg_12_1, arg_12_2)
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

	if (var_12_6 == 0 or var_12_7) and arg_12_0._craft_item and arg_12_0._skin_item and arg_12_0._has_all_requirements then
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
		local var_12_11 = arg_12_0._craft_item
		local var_12_12 = arg_12_0._skin_item
		local var_12_13 = {
			var_12_11,
			var_12_12
		}
		local var_12_14 = arg_12_0._material_items

		for iter_12_0, iter_12_1 in ipairs(var_12_14) do
			var_12_13[#var_12_13 + 1] = iter_12_1
		end

		if var_12_0:craft(var_12_13, arg_12_0._recipe_name) then
			arg_12_0:_set_craft_button_disabled(true)
			arg_12_0._item_grid:lock_item_by_id(var_12_11, true)
			arg_12_0._item_grid:update_items_status()
			arg_12_0._item_grid_2:lock_item_by_id(var_12_12, true)
			arg_12_0._item_grid_2:update_items_status()
			arg_12_0:_play_sound("play_gui_craft_forge_button_completed")
			arg_12_0:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

function CraftPageApplySkin._handle_craft_input_progress(arg_13_0, arg_13_1)
	local var_13_0

	var_13_0 = arg_13_1 ~= 0

	local var_13_1 = var_0_6.craft_bar.size[1]

	arg_13_0.ui_scenegraph.craft_bar.size[1] = var_13_1 * arg_13_1

	if arg_13_1 == 1 then
		return true
	end
end

function CraftPageApplySkin.craft_result(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not arg_14_2 then
		arg_14_0._craft_result = arg_14_1
	end
end

function CraftPageApplySkin.reset(arg_15_0)
	local var_15_0 = arg_15_0._item_grid
	local var_15_1 = arg_15_0._item_grid_2

	var_15_0:clear_locked_items()
	var_15_0:update_items_status()
	var_15_1:clear_locked_items()
	var_15_1:update_items_status()
end

function CraftPageApplySkin.on_craft_completed(arg_16_0)
	local var_16_0 = arg_16_0._craft_result
	local var_16_1 = arg_16_0._item_grid
	local var_16_2 = arg_16_0._item_grid_2
	local var_16_3 = true
	local var_16_4 = arg_16_0._craft_item
	local var_16_5 = arg_16_0._skin_item

	arg_16_0:_remove_item(var_16_2, var_16_5, var_16_3)
	arg_16_0:_remove_item(var_16_1, var_16_4, var_16_3)
	var_16_1:clear_item_grid()
	var_16_2:clear_item_grid()
	arg_16_0.super_parent:clear_disabled_backend_ids()
	arg_16_0.super_parent:update_inventory_items()
	arg_16_0:_set_craft_button_disabled(true)

	arg_16_0._craft_result = nil
	arg_16_0._craft_item = nil
	arg_16_0._skin_item = nil
	arg_16_0._presenting_reward = true

	arg_16_0:_weapon_slot_updated()
	arg_16_0:setup_recipe_requirements()

	if var_16_4 and ItemHelper.is_equiped_backend_id(var_16_4, arg_16_0.career_name) then
		local var_16_6 = Managers.backend:get_interface("items"):get_item_from_id(var_16_4)
		local var_16_7, var_16_8 = ItemHelper.get_equipped_slots(var_16_4, arg_16_0.career_name)

		for iter_16_0 = 1, var_16_8 do
			arg_16_0.super_parent:_set_loadout_item(var_16_6, var_16_7[iter_16_0])
		end

		if var_16_6.data.slot_type == "skin" then
			arg_16_0.super_parent:update_skin_sync()
		end
	end
end

function CraftPageApplySkin._update_craft_items(arg_17_0)
	local var_17_0 = arg_17_0.super_parent
	local var_17_1 = arg_17_0._item_grid
	local var_17_2 = arg_17_0._item_grid_2
	local var_17_3, var_17_4 = var_17_0:get_pressed_item_backend_id()

	if var_17_3 then
		if not arg_17_0._craft_item then
			arg_17_0:_add_item(var_17_1, var_17_3)

			arg_17_0._craft_item = var_17_3

			arg_17_0:_weapon_slot_updated()
		else
			if arg_17_0._skin_item then
				arg_17_0.super_parent:set_disabled_backend_id(arg_17_0._skin_item, false)
			end

			local var_17_5 = true

			if arg_17_0._skin_item == var_17_3 then
				arg_17_0:_remove_item(var_17_2, var_17_3)

				arg_17_0._skin_item = nil
				var_17_5 = false
			end

			if var_17_5 then
				arg_17_0:_add_item(var_17_2, var_17_3)

				arg_17_0._skin_item = var_17_3
			end

			arg_17_0:_weapon_slot_updated()

			if arg_17_0._has_all_requirements then
				arg_17_0:_set_craft_button_disabled(false)
			end
		end
	end

	local var_17_6 = var_17_1:is_item_pressed()

	if var_17_6 then
		local var_17_7 = var_17_6.backend_id

		arg_17_0:_remove_item(var_17_1, var_17_7)

		arg_17_0._craft_item = nil

		if arg_17_0._presenting_reward then
			arg_17_0._presenting_reward = nil
		end

		if arg_17_0._skin_item then
			arg_17_0:_remove_item(var_17_2, arg_17_0._skin_item)

			arg_17_0._skin_item = nil
		end

		arg_17_0:_weapon_slot_updated()
		arg_17_0:_set_craft_button_disabled(true)
	end

	local var_17_8 = var_17_2:is_item_pressed()

	if var_17_8 then
		local var_17_9 = var_17_8.backend_id

		arg_17_0:_remove_item(var_17_2, var_17_9)

		arg_17_0._skin_item = nil

		arg_17_0:_weapon_slot_updated()
		arg_17_0:_set_craft_button_disabled(true)
	end
end

function CraftPageApplySkin._remove_item(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0.super_parent:set_disabled_backend_id(arg_18_2, false)
	arg_18_1:add_item_to_slot_index(1, nil)
	arg_18_0:_set_craft_button_disabled(true)

	if not arg_18_3 then
		arg_18_0:_play_sound("play_gui_craft_item_drag")
	end
end

function CraftPageApplySkin._add_item(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_1:clear_item_grid()

	local var_19_0 = 1

	if var_19_0 then
		local var_19_1 = Managers.backend:get_interface("items")
		local var_19_2 = arg_19_2 and var_19_1:get_item_from_id(arg_19_2)

		arg_19_1:add_item_to_slot_index(var_19_0, var_19_2)
		arg_19_0.super_parent:set_disabled_backend_id(arg_19_2, true)

		if arg_19_2 and not arg_19_3 then
			arg_19_0:_play_sound("play_gui_craft_item_drop")
		end
	end
end

function CraftPageApplySkin._set_craft_button_disabled(arg_20_0, arg_20_1)
	arg_20_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_20_1
end

function CraftPageApplySkin._exit(arg_21_0, arg_21_1)
	arg_21_0.exit = true
	arg_21_0.exit_level_id = arg_21_1
end

function CraftPageApplySkin.draw(arg_22_0, arg_22_1)
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

function CraftPageApplySkin._play_sound(arg_23_0, arg_23_1)
	arg_23_0.super_parent:play_sound(arg_23_1)
end

function CraftPageApplySkin._set_craft_button_text(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0._widgets_by_name.craft_button.content.button_text = arg_24_2 and Localize(arg_24_1) or arg_24_1
end
