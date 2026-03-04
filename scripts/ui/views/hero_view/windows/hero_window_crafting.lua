-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_crafting.lua

require("scripts/ui/views/hero_view/craft_pages/craft_page_salvage")
require("scripts/ui/views/hero_view/craft_pages/craft_page_roll_trait")
require("scripts/ui/views/hero_view/craft_pages/craft_page_roll_properties")
require("scripts/ui/views/hero_view/craft_pages/craft_page_craft_item")
require("scripts/ui/views/hero_view/craft_pages/craft_page_apply_skin")
require("scripts/ui/views/hero_view/craft_pages/craft_page_upgrade_item")
require("scripts/ui/views/hero_view/craft_pages/craft_page_convert_dust")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_definitions")
local var_0_1, var_0_2, var_0_3 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_4 = var_0_0.widgets
local var_0_5 = var_0_0.category_settings
local var_0_6 = var_0_0.scenegraph_definition
local var_0_7 = var_0_0.animation_definitions
local var_0_8 = false
local var_0_9 = {
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "salvage",
		class_name = "CraftPageSalvage",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "craft_random_item",
		class_name = "CraftPageCraftItem",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "reroll_weapon_properties",
		class_name = "CraftPageRollProperties",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "reroll_weapon_traits",
		class_name = "CraftPageRollTrait",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "upgrade_item_rarity_common",
		class_name = "CraftPageUpgradeItem",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "apply_weapon_skin",
		class_name = "CraftPageApplySkin",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "convert_blue_dust",
		class_name = "CraftPageConvertDust",
		sound_event_exit = "play_gui_equipment_close"
	}
}

HeroWindowCrafting = class(HeroWindowCrafting)
HeroWindowCrafting.NAME = "HeroWindowCrafting"

HeroWindowCrafting.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCrafting")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.crafting_manager = Managers.state.crafting
	arg_1_0.wwise_world = arg_1_1.wwise_world

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_set_crafting_fg_progress(0)

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.profile_index = arg_1_1.profile_index
	arg_1_0._page_params = {
		wwise_world = arg_1_0.wwise_world,
		ingame_ui_context = var_1_0,
		parent = arg_1_0,
		hero_name = arg_1_0.hero_name,
		career_index = arg_1_0.career_index,
		profile_index = arg_1_0.profile_index
	}
	arg_1_0.unblocked_services = {}
	arg_1_0.unblocked_services_n = 0

	arg_1_0:_change_recipe_page(1)
end

HeroWindowCrafting.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
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

	if arg_2_2 then
		local var_2_3 = arg_2_0.ui_scenegraph.window.local_position

		var_2_3[1] = var_2_3[1] + arg_2_2[1]
		var_2_3[2] = var_2_3[2] + arg_2_2[2]
		var_2_3[3] = var_2_3[3] + arg_2_2[3]
	end

	arg_2_0._widgets_by_name.crafting_fg_glow.style.texture_id.color[1] = 0
end

HeroWindowCrafting.on_exit = function (arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCrafting")

	arg_3_0.ui_animator = nil

	if arg_3_0._active_page then
		local var_3_0 = arg_3_0._page_params

		arg_3_0._active_page:on_exit(var_3_0)
	end

	if arg_3_0:is_crafting_anim_playing() then
		arg_3_0:cancel_crafting_animation()
	end
end

HeroWindowCrafting.update = function (arg_4_0, arg_4_1, arg_4_2)
	if var_0_8 then
		var_0_8 = false

		arg_4_0:create_ui_elements()
	end

	local var_4_0 = arg_4_0._current_craft_id

	if var_4_0 then
		local var_4_1 = Managers.backend:get_interface("crafting")

		if var_4_1:is_craft_complete(var_4_0) then
			local var_4_2 = var_4_1:get_craft_result(var_4_0)

			arg_4_0:craft_complete(var_4_2)

			arg_4_0._current_craft_id = nil
		end
	end

	if arg_4_0._active_page then
		arg_4_0._active_page:update(arg_4_1, arg_4_2)
	end

	arg_4_0:_update_craft_start_time(arg_4_1, arg_4_2)
	arg_4_0:_update_craft_end_time(arg_4_1, arg_4_2)
	arg_4_0:_update_craft_glow_wait_time(arg_4_1, arg_4_2)
	arg_4_0:_update_craft_glow_in_time(arg_4_1, arg_4_2)
	arg_4_0:_update_craft_glow_out_time(arg_4_1, arg_4_2)
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:draw(arg_4_1)
end

HeroWindowCrafting.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._active_page and arg_5_0._active_page.post_update then
		arg_5_0._active_page:post_update(arg_5_1, arg_5_2)
	end
end

HeroWindowCrafting._update_animations = function (arg_6_0, arg_6_1)
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

HeroWindowCrafting._is_button_pressed = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		return true
	end
end

HeroWindowCrafting._is_button_hovered = function (arg_8_0, arg_8_1)
	if arg_8_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowCrafting._is_button_held = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.is_clicked then
		return var_9_0.is_clicked
	end
end

HeroWindowCrafting._handle_input = function (arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0:is_crafting_anim_playing() then
		return
	end

	local var_10_0 = arg_10_0._widgets_by_name
	local var_10_1 = var_10_0.page_button_next
	local var_10_2 = var_10_0.page_button_previous

	UIWidgetUtils.animate_default_button(var_10_1, arg_10_1)
	UIWidgetUtils.animate_default_button(var_10_2, arg_10_1)

	if arg_10_0:_is_button_hovered(var_10_1) or arg_10_0:_is_button_hovered(var_10_2) then
		arg_10_0:_play_sound("play_gui_inventory_next_hover")
	end

	local var_10_3 = arg_10_0._total_pages
	local var_10_4 = arg_10_0._current_page

	if arg_10_0:_is_button_pressed(var_10_1) then
		local var_10_5 = var_10_4 % var_10_3 + 1

		arg_10_0:_change_recipe_page(var_10_5)
		arg_10_0:_play_sound("play_gui_craft_recipe_next")
	elseif arg_10_0:_is_button_pressed(var_10_2) then
		local var_10_6 = var_10_4 > 1 and var_10_4 - 1 or var_10_3

		arg_10_0:_change_recipe_page(var_10_6)
		arg_10_0:_play_sound("play_gui_craft_recipe_next")
	elseif Managers.input:is_device_active("gamepad") then
		local var_10_7 = Managers.input:get_service("hero_view")
		local var_10_8 = #var_0_9

		if var_10_7:get("cycle_next") then
			local var_10_9 = var_10_4 % var_10_8 + 1

			if var_10_9 <= var_10_8 then
				arg_10_0:_change_recipe_page(var_10_9)
				arg_10_0:_play_sound("play_gui_craft_recipe_next")
			end
		elseif var_10_7:get("cycle_previous") then
			local var_10_10 = var_10_4 > 1 and var_10_4 - 1 or var_10_8

			if var_10_10 > 0 then
				arg_10_0:_change_recipe_page(var_10_10)
				arg_10_0:_play_sound("play_gui_craft_recipe_next")
			end
		end
	end
end

HeroWindowCrafting._exit = function (arg_11_0, arg_11_1)
	arg_11_0.exit = true
	arg_11_0.exit_level_id = arg_11_1
end

HeroWindowCrafting.draw = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0.ui_top_renderer
	local var_12_2 = arg_12_0.ui_scenegraph
	local var_12_3 = arg_12_0.parent:window_input_service()
	local var_12_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_12_1, var_12_2, var_12_3, arg_12_1, nil, arg_12_0.render_settings)

	for iter_12_0, iter_12_1 in ipairs(arg_12_0._widgets) do
		UIRenderer.draw_widget(var_12_1, iter_12_1)
	end

	local var_12_5 = arg_12_0._active_node_widgets

	if var_12_5 then
		for iter_12_2, iter_12_3 in ipairs(var_12_5) do
			UIRenderer.draw_widget(var_12_1, iter_12_3)
		end
	end

	UIRenderer.end_pass(var_12_1)
end

HeroWindowCrafting._play_sound = function (arg_13_0, arg_13_1)
	arg_13_0.parent:play_sound(arg_13_1)
end

HeroWindowCrafting._change_recipe_page = function (arg_14_0, arg_14_1)
	local var_14_0 = #var_0_9
	local var_14_1 = var_0_9[arg_14_1].name
	local var_14_2 = var_0_2[var_14_1]

	arg_14_0._active_recipe = var_14_2

	local var_14_3 = var_14_2.ingredients
	local var_14_4 = arg_14_0._widgets_by_name

	var_14_4.title_text.content.text = Localize(var_14_2.display_name)
	var_14_4.description_text.content.text = Localize(var_14_2.description_text)

	if arg_14_1 ~= arg_14_0._current_page or var_14_0 ~= arg_14_0._total_pages then
		arg_14_0._total_pages = var_14_0
		arg_14_0._current_page = arg_14_1
		arg_14_1 = arg_14_1 or 1
		var_14_0 = var_14_0 or 1

		local var_14_5 = arg_14_0._widgets_by_name

		var_14_5.page_text_left.content.text = tostring(arg_14_1)
		var_14_5.page_text_right.content.text = tostring(var_14_0)

		arg_14_0:_set_page_index(arg_14_1)
	end

	arg_14_0._selected_page_index = arg_14_1
end

HeroWindowCrafting.window_input_service = function (arg_15_0)
	return
end

HeroWindowCrafting._set_page_index = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._active_page
	local var_16_1 = arg_16_0._page_params
	local var_16_2 = var_0_9[arg_16_1]
	local var_16_3 = var_16_2.name
	local var_16_4 = var_16_2.class_name

	if var_16_0 then
		if var_16_0.NAME == var_16_4 then
			return
		end

		if var_16_0.on_exit then
			var_16_0:on_exit(var_16_1)
		end
	end

	if arg_16_0:is_crafting_anim_playing() then
		arg_16_0:cancel_crafting_animation()
	end

	local var_16_5 = rawget(_G, var_16_4):new()

	arg_16_0.parent:set_selected_craft_page(var_16_3)

	if var_16_5.on_enter then
		var_16_5:on_enter(var_16_1, var_16_2)
	end

	arg_16_0._active_page = var_16_5
end

HeroWindowCrafting._update_craft_start_time = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._craft_start_duration

	if not var_17_0 then
		return
	end

	local var_17_1 = var_17_0 + arg_17_1
	local var_17_2 = UISettings.crafting_animation_in_time
	local var_17_3 = math.min(var_17_1 / var_17_2, 1)
	local var_17_4 = math.easeInCubic(var_17_3)

	arg_17_0:_set_crafting_fg_progress(var_17_4)

	if var_17_3 == 1 then
		arg_17_0._craft_start_duration = nil
		arg_17_0._craft_glow_in_duration = 0

		arg_17_0:_play_sound("play_gui_craft_forge_fire_begin")
	else
		arg_17_0._craft_start_duration = var_17_1
	end
end

HeroWindowCrafting._update_craft_glow_in_time = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0._craft_glow_in_duration

	if not var_18_0 then
		return
	end

	local var_18_1 = var_18_0 + arg_18_1
	local var_18_2 = UISettings.crafting_animation_in_time
	local var_18_3 = math.min(var_18_1 / var_18_2, 1)
	local var_18_4 = math.easeInCubic(var_18_3)

	arg_18_0._widgets_by_name.crafting_fg_glow.style.texture_id.color[1] = var_18_4 * 255

	if var_18_3 == 1 then
		arg_18_0._craft_glow_in_duration = nil
		arg_18_0._craft_glow_wait_duration = 0
	else
		arg_18_0._craft_glow_in_duration = var_18_1
	end
end

HeroWindowCrafting._update_craft_glow_wait_time = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0._craft_glow_wait_duration

	if not var_19_0 then
		return
	end

	local var_19_1 = var_19_0 + arg_19_1
	local var_19_2 = UISettings.crafting_animation_wait_time
	local var_19_3 = math.min(var_19_1 / var_19_2, 1)
	local var_19_4 = math.ease_pulse(1 - var_19_3)

	if var_19_3 == 1 then
		arg_19_0._craft_glow_wait_duration = nil
	else
		arg_19_0._craft_glow_wait_duration = var_19_1
	end
end

HeroWindowCrafting._update_craft_glow_out_time = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._craft_glow_out_duration

	if not var_20_0 or arg_20_0._craft_glow_in_duration or arg_20_0._craft_start_duration or arg_20_0._craft_glow_wait_duration then
		return
	end

	local var_20_1 = var_20_0 + arg_20_1
	local var_20_2 = UISettings.crafting_animation_out_time
	local var_20_3 = math.min(var_20_1 / var_20_2, 1)
	local var_20_4 = math.easeOutCubic(1 - var_20_3)

	arg_20_0._widgets_by_name.crafting_fg_glow.style.texture_id.color[1] = var_20_4 * 255

	if var_20_3 == 1 then
		arg_20_0._craft_end_duration = 0
		arg_20_0._craft_glow_out_duration = nil

		arg_20_0:_play_sound("play_gui_craft_forge_end")
	else
		if arg_20_0._craft_glow_out_duration == 0 and arg_20_0._active_page then
			arg_20_0._active_page:on_craft_completed()
		end

		arg_20_0._craft_glow_out_duration = var_20_1
	end
end

HeroWindowCrafting._set_crafting_fg_progress = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._widgets_by_name.crafting_fg
	local var_21_1 = var_21_0.content.texture_id.uvs
	local var_21_2 = var_21_0.scenegraph_id

	arg_21_0.ui_scenegraph[var_21_2].size[2] = var_0_6[var_21_2].size[2] * arg_21_1
	var_21_1[1][2] = 1 - arg_21_1
	var_21_1[2][2] = 1
end

HeroWindowCrafting._update_craft_end_time = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._craft_end_duration

	if not var_22_0 then
		return
	end

	local var_22_1 = var_22_0 + arg_22_1
	local var_22_2 = math.min(var_22_1 / 0.8, 1)
	local var_22_3 = math.easeCubic(1 - var_22_2)

	arg_22_0:_set_crafting_fg_progress(var_22_3)

	if var_22_2 == 1 then
		arg_22_0._craft_end_duration = nil

		if arg_22_0._active_page then
			arg_22_0._active_page:reset()
		end

		arg_22_0:unlock_input()
	else
		arg_22_0._craft_end_duration = var_22_1
	end
end

HeroWindowCrafting.get_active_recipe = function (arg_23_0)
	return arg_23_0._active_recipe
end

HeroWindowCrafting.craft = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0.crafting_manager:craft(arg_24_1, arg_24_2)

	if var_24_0 then
		arg_24_0._waiting_for_craft = true
		arg_24_0._craft_start_duration = 0
		arg_24_0._craft_glow_in_duration = nil
		arg_24_0._craft_glow_wait_duration = nil
		arg_24_0._craft_glow_out_duration = nil
		arg_24_0._craft_end_duration = nil

		arg_24_0:lock_input()

		arg_24_0._current_craft_id = var_24_0

		return true
	end

	return false
end

HeroWindowCrafting.craft_complete = function (arg_25_0, arg_25_1)
	arg_25_0._waiting_for_craft = false
	arg_25_0._craft_glow_out_duration = 0

	if arg_25_0._active_page then
		arg_25_0._active_page:craft_result(arg_25_1)
	end
end

HeroWindowCrafting.waiting_for_craft = function (arg_26_0)
	return arg_26_0._waiting_for_craft
end

HeroWindowCrafting.is_crafting_anim_playing = function (arg_27_0)
	return arg_27_0._craft_start_duration ~= nil or arg_27_0._craft_glow_in_duration ~= nil or arg_27_0._craft_glow_wait_duration ~= nil or arg_27_0._craft_glow_out_duration ~= nil or arg_27_0._craft_end_duration ~= nil or arg_27_0:waiting_for_craft()
end

HeroWindowCrafting.cancel_crafting_animation = function (arg_28_0)
	arg_28_0._waiting_for_craft = nil
	arg_28_0._craft_start_duration = nil
	arg_28_0._craft_glow_in_duration = nil
	arg_28_0._craft_glow_wait_duration = nil
	arg_28_0._craft_glow_out_duration = nil
	arg_28_0._craft_end_duration = nil

	arg_28_0:_play_sound("play_gui_craft_forge_end")

	arg_28_0._current_craft_id = nil
end

HeroWindowCrafting.lock_input = function (arg_29_0)
	local var_29_0 = arg_29_0.input_manager

	arg_29_0:unlock_input(true)

	arg_29_0.unblocked_services_n = var_29_0:get_unblocked_services(nil, nil, arg_29_0.unblocked_services)

	var_29_0:device_block_services("keyboard", 1, arg_29_0.unblocked_services, arg_29_0.unblocked_services_n, "crafting")
	var_29_0:device_block_services("gamepad", 1, arg_29_0.unblocked_services, arg_29_0.unblocked_services_n, "crafting")
	var_29_0:device_block_services("mouse", 1, arg_29_0.unblocked_services, arg_29_0.unblocked_services_n, "crafting")
end

HeroWindowCrafting.unlock_input = function (arg_30_0)
	local var_30_0 = arg_30_0.input_manager

	var_30_0:device_unblock_services("keyboard", 1, arg_30_0.unblocked_services, arg_30_0.unblocked_services_n)
	var_30_0:device_unblock_services("gamepad", 1, arg_30_0.unblocked_services, arg_30_0.unblocked_services_n)
	var_30_0:device_unblock_services("mouse", 1, arg_30_0.unblocked_services, arg_30_0.unblocked_services_n)
	table.clear(arg_30_0.unblocked_services)

	arg_30_0.unblocked_services_n = 0
end
