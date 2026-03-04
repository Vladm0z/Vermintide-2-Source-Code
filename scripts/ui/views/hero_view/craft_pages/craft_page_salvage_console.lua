-- chunkname: @scripts/ui/views/hero_view/craft_pages/craft_page_salvage_console.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/craft_pages/definitions/craft_page_salvage_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.category_settings
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.NUM_CRAFT_SLOTS
local var_0_6 = false

CraftPageSalvageConsole = class(CraftPageSalvageConsole)
CraftPageSalvageConsole.NAME = "CraftPageSalvageConsole"

function CraftPageSalvageConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroWindowCraft] Enter Substate CraftPageSalvageConsole")

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

	arg_1_0:_reset_reward_materials(false)
	arg_1_0.super_parent:clear_disabled_backend_ids()
	arg_1_0.super_parent:set_disabled_item_icon("salvage_item_icon")

	local var_1_2 = tostring(arg_1_0._num_craft_items or 0)

	arg_1_0:_set_craft_counter_text(var_1_2, true)
	arg_1_0:_start_transition_animation("on_enter")
end

function CraftPageSalvageConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_3, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function CraftPageSalvageConsole.create_ui_elements(arg_3_0, arg_3_1)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_4)

	arg_3_0:_set_craft_button_disabled(true)
	arg_3_0:_handle_craft_input_progress(0)

	var_3_1.max_counter_text.content.text = "/" .. tostring(CraftingSettings.NUM_SALVAGE_SLOTS)
end

function CraftPageSalvageConsole.on_exit(arg_4_0, arg_4_1)
	print("[HeroWindowCraft] Exit Substate CraftPageSalvageConsole")

	arg_4_0.ui_animator = nil

	if arg_4_0._craft_input_time then
		arg_4_0:_play_sound("play_gui_craft_forge_button_aborted")
	end

	arg_4_0.super_parent:set_disabled_item_icon(nil)
end

function CraftPageSalvageConsole.update(arg_5_0, arg_5_1, arg_5_2)
	if var_0_6 then
		var_0_6 = false

		arg_5_0:create_ui_elements()
	end

	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_update_craft_items()
	arg_5_0:_update_reward_material_fade_out(arg_5_1)
	arg_5_0:draw(arg_5_1)
end

function CraftPageSalvageConsole.post_update(arg_6_0, arg_6_1, arg_6_2)
	return
end

function CraftPageSalvageConsole._update_animations(arg_7_0, arg_7_1)
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

	UIWidgetUtils.animate_icon_button(var_7_2.auto_fill_plentiful, arg_7_1)
	UIWidgetUtils.animate_icon_button(var_7_2.auto_fill_common, arg_7_1)
	UIWidgetUtils.animate_icon_button(var_7_2.auto_fill_rare, arg_7_1)
	UIWidgetUtils.animate_icon_button(var_7_2.auto_fill_exotic, arg_7_1)
	UIWidgetUtils.animate_icon_button(var_7_2.auto_fill_clear, arg_7_1)
end

function CraftPageSalvageConsole._handle_input(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.parent

	if var_8_0:waiting_for_craft() or arg_8_0._craft_result then
		return
	end

	local var_8_1 = arg_8_0._widgets_by_name
	local var_8_2 = arg_8_0.super_parent
	local var_8_3 = Managers.input:is_device_active("gamepad")
	local var_8_4 = true
	local var_8_5 = var_8_2:filter_selected()
	local var_8_6 = var_8_2:filter_active()
	local var_8_7 = not var_8_5 and not var_8_6
	local var_8_8 = arg_8_0.super_parent:window_input_service()
	local var_8_9 = not var_8_1.craft_button.content.button_hotspot.disable_button
	local var_8_10

	if var_8_7 then
		var_8_10 = UIUtils.is_button_pressed(var_8_1.auto_fill_plentiful) and "plentiful" or var_8_10
		var_8_10 = UIUtils.is_button_pressed(var_8_1.auto_fill_common) and "common" or var_8_10
		var_8_10 = UIUtils.is_button_pressed(var_8_1.auto_fill_rare) and "rare" or var_8_10
		var_8_10 = UIUtils.is_button_pressed(var_8_1.auto_fill_exotic) and "exotic" or var_8_10

		arg_8_0.super_parent:set_auto_fill_rarity(var_8_10)
	end

	local var_8_11 = UIUtils.is_button_pressed(var_8_1.auto_fill_clear)
	local var_8_12 = UIUtils.is_button_held(var_8_1.craft_button)
	local var_8_13 = var_8_9 and var_8_3 and var_8_8:get("refresh_hold")
	local var_8_14 = var_8_9 and not var_8_3 and var_8_8:get("skip")
	local var_8_15 = false

	if (var_8_8:get("special_1") or var_8_11) and var_8_7 then
		arg_8_0:reset()
	elseif (var_8_12 or var_8_13 or var_8_14) and var_8_7 then
		if not arg_8_0._craft_input_time then
			arg_8_0._craft_input_time = 0

			arg_8_0:_play_sound("play_gui_craft_forge_button_begin")
		else
			arg_8_0._craft_input_time = arg_8_0._craft_input_time + arg_8_1
		end

		local var_8_16 = UISettings.crafting_progress_time
		local var_8_17 = math.min(arg_8_0._craft_input_time / var_8_16, 1)

		var_8_15 = arg_8_0:_handle_craft_input_progress(var_8_17)

		WwiseWorld.set_global_parameter(arg_8_0.wwise_world, "craft_forge_button_progress", var_8_17)
	elseif arg_8_0._craft_input_time then
		arg_8_0._craft_input_time = nil

		arg_8_0:_handle_craft_input_progress(0)
		arg_8_0:_play_sound("play_gui_craft_forge_button_aborted")
	end

	if var_8_15 then
		local var_8_18 = arg_8_0._craft_items
		local var_8_19 = {}

		for iter_8_0, iter_8_1 in pairs(var_8_18) do
			var_8_19[#var_8_19 + 1] = iter_8_0
		end

		if var_8_0:craft(var_8_19, arg_8_0._recipe_name) then
			arg_8_0:_set_craft_button_disabled(true)
			arg_8_0:_play_sound("play_gui_craft_forge_button_completed")
			arg_8_0:_play_sound("play_gui_craft_forge_begin")
		end
	end
end

function CraftPageSalvageConsole._handle_craft_input_progress(arg_9_0, arg_9_1)
	return arg_9_0.parent:_set_input_progress(arg_9_1)
end

function CraftPageSalvageConsole.craft_result(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not arg_10_2 then
		arg_10_0._craft_result = arg_10_1
	end
end

function CraftPageSalvageConsole.reset(arg_11_0)
	for iter_11_0, iter_11_1 in pairs(arg_11_0._craft_items) do
		arg_11_0:_remove_craft_item(iter_11_0)
	end

	arg_11_0.super_parent:clear_disabled_backend_ids()
	arg_11_0.super_parent:update_inventory_items()

	arg_11_0._material_fade_out_time = 0
end

function CraftPageSalvageConsole.present_results(arg_12_0)
	arg_12_0.super_parent:clear_disabled_backend_ids()
	arg_12_0.super_parent:update_inventory_items()
end

function CraftPageSalvageConsole.on_craft_completed(arg_13_0)
	local var_13_0 = arg_13_0._craft_result

	table.clear(arg_13_0._craft_items)

	local var_13_1 = 0

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		var_13_1 = var_13_1 + 1
	end

	arg_13_0:_reset_reward_materials(true)

	local var_13_2 = true

	for iter_13_2, iter_13_3 in pairs(var_13_0) do
		local var_13_3 = iter_13_3[1]
		local var_13_4 = iter_13_3[3]

		arg_13_0:_set_reward_material_by_index(var_13_3, var_13_4)
	end

	arg_13_0._num_craft_items = 0

	arg_13_0:_set_craft_button_disabled(true)

	arg_13_0._craft_result = nil

	arg_13_0:_set_craft_counter_text("", false)

	arg_13_0._presenting_rewards = true
end

function CraftPageSalvageConsole._update_craft_items(arg_14_0)
	local var_14_0 = arg_14_0.super_parent
	local var_14_1, var_14_2 = var_14_0:get_pressed_item_backend_id()

	if var_14_1 then
		if arg_14_0:_has_added_item_by_id(var_14_1) then
			arg_14_0:_remove_craft_item(var_14_1)
		elseif (arg_14_0._num_craft_items or 0) < CraftingSettings.NUM_SALVAGE_SLOTS then
			arg_14_0:_add_craft_item(var_14_1)
		end
	end

	local var_14_3 = var_14_0:get_selected_items_backend_ids()

	if var_14_3 then
		local var_14_4 = false

		for iter_14_0, iter_14_1 in ipairs(var_14_3) do
			if not arg_14_0:_has_added_item_by_id(iter_14_1) and (arg_14_0._num_craft_items or 0) < CraftingSettings.NUM_SALVAGE_SLOTS then
				var_14_4 = true

				arg_14_0:_add_craft_item(iter_14_1, true)
			end
		end

		if var_14_4 then
			arg_14_0:_play_sound("play_gui_craft_item_drop")
		end
	end
end

function CraftPageSalvageConsole._remove_craft_item(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._craft_items

	if arg_15_1 then
		arg_15_0.super_parent:set_disabled_backend_id(arg_15_1, false)

		var_15_0[arg_15_1] = nil
		arg_15_0._num_craft_items = math.max((arg_15_0._num_craft_items or 0) - 1, 0)

		if arg_15_0._num_craft_items == 0 then
			arg_15_0:_set_craft_button_disabled(true)
		else
			arg_15_0:_set_craft_button_disabled(false)
		end

		local var_15_1 = tostring(arg_15_0._num_craft_items)

		arg_15_0:_set_craft_counter_text(var_15_1, true)
		arg_15_0:_play_sound("play_gui_craft_item_drag")
	end
end

function CraftPageSalvageConsole._add_craft_item(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_0._presenting_rewards then
		arg_16_0:_on_craft_material_fade_complete()
	end

	if arg_16_0._num_craft_items == 0 then
		table.clear(arg_16_0._craft_items)
	end

	arg_16_0._craft_items[arg_16_1] = true

	local var_16_0 = Managers.backend:get_interface("items")
	local var_16_1

	var_16_1 = arg_16_1 and var_16_0:get_item_from_id(arg_16_1)

	arg_16_0.super_parent:set_disabled_backend_id(arg_16_1, true)

	arg_16_0._num_craft_items = (arg_16_0._num_craft_items or 0) + 1

	if arg_16_0._num_craft_items > 0 then
		arg_16_0:_set_craft_button_disabled(false)
	end

	local var_16_2 = tostring(arg_16_0._num_craft_items)

	arg_16_0:_set_craft_counter_text(var_16_2, true)

	if arg_16_1 and not arg_16_2 then
		arg_16_0:_play_sound("play_gui_craft_item_drop")
	end
end

function CraftPageSalvageConsole._set_craft_counter_text(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0._presenting_rewards then
		return
	end

	local var_17_0 = arg_17_0._widgets_by_name
	local var_17_1 = var_17_0.counter_text
	local var_17_2 = var_17_0.max_counter_text

	var_17_1.content.text = tostring(arg_17_1)
	var_17_1.content.visible = arg_17_2
	var_17_2.content.visible = arg_17_2
end

function CraftPageSalvageConsole._set_craft_button_disabled(arg_18_0, arg_18_1)
	arg_18_0._widgets_by_name.craft_button.content.button_hotspot.disable_button = arg_18_1

	local var_18_0 = not arg_18_1 and arg_18_0.settings.name or "disabled"

	if (arg_18_0._num_craft_items or 0) < CraftingSettings.NUM_SALVAGE_SLOTS then
		var_18_0 = var_18_0 .. "_auto"
	end

	arg_18_0.parent:set_input_description(var_18_0)
end

function CraftPageSalvageConsole._exit(arg_19_0, arg_19_1)
	arg_19_0.exit = true
	arg_19_0.exit_level_id = arg_19_1
end

function CraftPageSalvageConsole.draw(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.ui_renderer
	local var_20_1 = arg_20_0.ui_top_renderer
	local var_20_2 = arg_20_0.ui_scenegraph
	local var_20_3 = arg_20_0.super_parent:window_input_service()

	UIRenderer.begin_pass(var_20_1, var_20_2, var_20_3, arg_20_1, nil, arg_20_0.render_settings)

	for iter_20_0, iter_20_1 in ipairs(arg_20_0._widgets) do
		UIRenderer.draw_widget(var_20_1, iter_20_1)
	end

	UIRenderer.end_pass(var_20_1)
end

function CraftPageSalvageConsole._play_sound(arg_21_0, arg_21_1)
	arg_21_0.super_parent:play_sound(arg_21_1)
end

function CraftPageSalvageConsole._set_craft_button_text(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0._widgets_by_name.craft_button.content.button_text = arg_22_2 and Localize(arg_22_1) or arg_22_1
end

function CraftPageSalvageConsole._has_added_item_by_id(arg_23_0, arg_23_1)
	return arg_23_0._craft_items[arg_23_1]
end

function CraftPageSalvageConsole._update_reward_material_fade_out(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._material_fade_out_time

	if var_24_0 then
		local var_24_1 = 2
		local var_24_2 = math.min(var_24_0 + arg_24_1, var_24_1)
		local var_24_3 = 1 - var_24_2 / var_24_1
		local var_24_4 = math.easeOutCubic(var_24_3)

		arg_24_0:_set_reward_material_alpha_fraction(var_24_4)

		if var_24_3 == 0 then
			arg_24_0:_on_craft_material_fade_complete()
		else
			arg_24_0._material_fade_out_time = var_24_2
		end
	end
end

function CraftPageSalvageConsole._on_craft_material_fade_complete(arg_25_0)
	arg_25_0._presenting_rewards = nil

	arg_25_0:_reset_reward_materials(false)

	local var_25_0 = tostring(arg_25_0._num_craft_items or 0)

	arg_25_0:_set_craft_counter_text(var_25_0)

	arg_25_0._material_fade_out_time = nil
end

function CraftPageSalvageConsole._set_reward_material_alpha_fraction(arg_26_0, arg_26_1)
	local var_26_0 = 255 * arg_26_1
	local var_26_1 = arg_26_0._widgets_by_name

	for iter_26_0 = 1, #UISettings.crafting_material_order do
		local var_26_2 = var_26_1["material_text_" .. iter_26_0].style
		local var_26_3 = var_26_2.text
		local var_26_4 = var_26_2.text_shadow
		local var_26_5 = var_26_2.icon

		var_26_3.text_color[1] = var_26_0
		var_26_4.text_color[1] = var_26_0
		var_26_5.color[1] = var_26_0
	end

	var_26_1.material_cross.style.texture_id.color[1] = var_26_0
end

function CraftPageSalvageConsole._reset_reward_materials(arg_27_0, arg_27_1)
	local var_27_0 = UISettings.crafting_material_icons_small
	local var_27_1 = UISettings.crafting_material_order_by_item_key
	local var_27_2 = arg_27_0._widgets_by_name

	for iter_27_0, iter_27_1 in pairs(var_27_1) do
		local var_27_3 = var_27_2["material_text_" .. iter_27_1].content

		var_27_3.icon = var_27_0[iter_27_0]
		var_27_3.visible = arg_27_1
		var_27_3.text = "0"

		arg_27_0:_set_material_enabled_state(iter_27_1, false)
	end

	arg_27_0:_set_reward_material_alpha_fraction(1)

	var_27_2.material_cross.content.visible = arg_27_1
end

function CraftPageSalvageConsole._set_material_enabled_state(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0._widgets_by_name["material_text_" .. arg_28_1].style
	local var_28_1 = var_28_0.text
	local var_28_2 = var_28_0.icon
	local var_28_3 = arg_28_2 and 255 or 100
	local var_28_4 = var_28_1.text_color

	var_28_4[2] = var_28_3
	var_28_4[3] = var_28_3
	var_28_4[4] = var_28_3

	local var_28_5 = var_28_2.color

	var_28_5[2] = var_28_3
	var_28_5[3] = var_28_3
	var_28_5[4] = var_28_3
	var_28_2.saturated = not arg_28_2
end

function CraftPageSalvageConsole._set_reward_material_by_index(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = UISettings.crafting_material_order_by_item_key
	local var_29_1 = Managers.backend:get_interface("items"):get_key(arg_29_1)
	local var_29_2 = var_29_0[var_29_1]
	local var_29_3 = arg_29_0._widgets_by_name["material_text_" .. var_29_2].content

	var_29_3.visible = true
	var_29_3.text = arg_29_2
	var_29_3.item = {
		data = table.clone(ItemMasterList[var_29_1])
	}

	arg_29_0:_set_material_enabled_state(var_29_2, true)
end
