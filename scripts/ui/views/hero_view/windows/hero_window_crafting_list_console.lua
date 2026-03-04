-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_crafting_list_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_list_console_definitions")
local var_0_1, var_0_2, var_0_3 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_4 = var_0_0.widgets
local var_0_5 = var_0_0.title_button_definitions
local var_0_6 = var_0_0.scenegraph_definition
local var_0_7 = var_0_0.animation_definitions
local var_0_8 = var_0_0.generic_input_actions
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
local var_0_10 = "move_down_hold_continuous"
local var_0_11 = "move_up_hold_continuous"
local var_0_12 = false

HeroWindowCraftingListConsole = class(HeroWindowCraftingListConsole)
HeroWindowCraftingListConsole.NAME = "HeroWindowCraftingListConsole"

HeroWindowCraftingListConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCraftingListConsole")

	arg_1_0._params = arg_1_1
	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._animation_settings = {
		entry_alignment_progress = 0
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.profile_index = arg_1_1.profile_index

	local var_1_2 = arg_1_0.hero_name
	local var_1_3 = arg_1_0.career_index
	local var_1_4 = FindProfileIndex(var_1_2)
	local var_1_5 = SPProfiles[var_1_4].careers[var_1_3].name

	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.conditions_params = {
		hero_name = arg_1_0.hero_name,
		career_name = var_1_5,
		rarities_to_ignore = table.enum_safe("magic")
	}

	arg_1_0:_populate_buttons(var_0_9)

	local var_1_6 = arg_1_1.recipe_index or 1
	local var_1_7 = true

	arg_1_0:_on_button_selected(var_1_6, var_1_7)
	arg_1_0:_start_transition_animation("on_enter")
end

HeroWindowCraftingListConsole._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0.render_settings,
		animation_settings = arg_2_0._animation_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_6, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

HeroWindowCraftingListConsole.create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
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

	local var_3_3 = {}

	for iter_3_2, iter_3_3 in pairs(var_0_5) do
		local var_3_4 = UIWidget.init(iter_3_3)

		var_3_3[#var_3_3 + 1] = var_3_4
	end

	arg_3_0._title_button_widgets = var_3_3

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_top_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_7)

	if arg_3_2 then
		local var_3_5 = arg_3_0.ui_scenegraph.window.local_position

		var_3_5[1] = var_3_5[1] + arg_3_2[1]
		var_3_5[2] = var_3_5[2] + arg_3_2[2]
		var_3_5[3] = var_3_5[3] + arg_3_2[3]
	end

	local var_3_6 = Managers.input:get_service("hero_view")
	local var_3_7 = UILayer.default + 300

	arg_3_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_3_0.ui_top_renderer, var_3_6, 4, var_3_7, var_0_8.default, true)

	arg_3_0._menu_input_description:set_input_description(nil)
end

HeroWindowCraftingListConsole.on_exit = function (arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCraftingListConsole")

	arg_4_0.ui_animator = nil

	arg_4_0._menu_input_description:destroy()

	arg_4_0._menu_input_description = nil
end

HeroWindowCraftingListConsole._input_service = function (arg_5_0)
	local var_5_0 = arg_5_0.parent

	if var_5_0:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return var_5_0:window_input_service()
end

HeroWindowCraftingListConsole.update = function (arg_6_0, arg_6_1, arg_6_2)
	if var_0_12 then
		var_0_12 = false

		arg_6_0:create_ui_elements()
	end

	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:draw(arg_6_1)
end

HeroWindowCraftingListConsole.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:_handle_input(arg_7_1, arg_7_2)
end

HeroWindowCraftingListConsole._update_animations = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._ui_animations
	local var_8_1 = arg_8_0._animations
	local var_8_2 = arg_8_0.ui_animator

	for iter_8_0, iter_8_1 in pairs(arg_8_0._ui_animations) do
		UIAnimation.update(iter_8_1, arg_8_1)

		if UIAnimation.completed(iter_8_1) then
			arg_8_0._ui_animations[iter_8_0] = nil
		end
	end

	var_8_2:update(arg_8_1)

	for iter_8_2, iter_8_3 in pairs(var_8_1) do
		if var_8_2:is_animation_completed(iter_8_3) then
			var_8_2:stop_animation(iter_8_3)

			var_8_1[iter_8_2] = nil
		end
	end

	local var_8_3 = arg_8_0._animation_settings.entry_alignment_progress

	arg_8_0:_set_alignment_progress(var_8_3)

	local var_8_4 = arg_8_0._title_button_widgets

	for iter_8_4, iter_8_5 in ipairs(var_8_4) do
		arg_8_0:_animate_entry(iter_8_5, arg_8_1)
	end
end

HeroWindowCraftingListConsole._is_button_pressed = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content
	local var_9_1 = var_9_0.button_hotspot or var_9_0.button_text

	if var_9_1.on_release then
		var_9_1.on_release = false

		return true
	end
end

HeroWindowCraftingListConsole._is_stepper_button_pressed = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content
	local var_10_1 = var_10_0.button_hotspot_left
	local var_10_2 = var_10_0.button_hotspot_right

	if var_10_1.on_release then
		var_10_1.on_release = false

		return true, -1
	elseif var_10_2.on_release then
		var_10_2.on_release = false

		return true, 1
	end
end

HeroWindowCraftingListConsole._is_button_hover_enter = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	return var_11_0.on_hover_enter and not var_11_0.is_selected
end

HeroWindowCraftingListConsole._is_button_hover_exit = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	return var_12_0.on_hover_exit and not var_12_0.is_selected
end

HeroWindowCraftingListConsole._is_button_selected = function (arg_13_0, arg_13_1)
	return arg_13_1.content.button_hotspot.is_selected
end

HeroWindowCraftingListConsole._handle_input = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.parent
	local var_14_1 = arg_14_0._widgets_by_name
	local var_14_2 = arg_14_0:_input_service()
	local var_14_3 = arg_14_0:_selected_button_index()
	local var_14_4 = false
	local var_14_5 = arg_14_0._title_button_widgets

	for iter_14_0, iter_14_1 in ipairs(var_14_5) do
		if iter_14_0 ~= var_14_3 and arg_14_0:_is_button_hover_enter(iter_14_1) then
			arg_14_0:_on_button_selected(iter_14_0)

			var_14_4 = true
		end

		if arg_14_0:_is_button_pressed(iter_14_1) then
			var_14_4 = true

			arg_14_0:_open_recipe_page(iter_14_0)
		end
	end

	if var_14_2:get("confirm") then
		arg_14_0:_open_recipe_page(var_14_3)

		var_14_4 = true
	end

	if not var_14_4 then
		if var_14_2:get(var_0_11) and var_14_3 > 1 then
			arg_14_0:_on_button_selected(var_14_3 - 1)
		elseif var_14_2:get(var_0_10) and var_14_3 < #var_0_9 then
			arg_14_0:_on_button_selected(var_14_3 + 1)
		end
	end
end

HeroWindowCraftingListConsole._open_recipe_page = function (arg_15_0, arg_15_1)
	arg_15_0._params.recipe_index = arg_15_1

	arg_15_0.parent:set_layout_by_name("crafting_recipe")
end

HeroWindowCraftingListConsole._selected_button_index = function (arg_16_0)
	local var_16_0 = arg_16_0._title_button_widgets

	for iter_16_0, iter_16_1 in ipairs(var_16_0) do
		if iter_16_1.content.button_hotspot.is_selected then
			return iter_16_0
		end
	end
end

HeroWindowCraftingListConsole._on_button_selected = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._title_button_widgets

	for iter_17_0, iter_17_1 in ipairs(var_17_0) do
		iter_17_1.content.button_hotspot.is_selected = iter_17_0 == arg_17_1
	end

	local var_17_1 = var_0_9[arg_17_1].name
	local var_17_2 = var_0_2[var_17_1]
	local var_17_3 = var_17_2.description_text
	local var_17_4 = var_17_2.display_name
	local var_17_5 = arg_17_0._widgets_by_name
	local var_17_6 = var_17_5.description_text
	local var_17_7 = var_17_5.tite_text

	var_17_6.content.text = Localize(var_17_3)
	var_17_7.content.text = Localize(var_17_4)

	if not arg_17_2 then
		arg_17_0:_play_sound("play_gui_craft_hover_items")
	end
end

HeroWindowCraftingListConsole.draw = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.ui_renderer
	local var_18_1 = arg_18_0.ui_top_renderer
	local var_18_2 = arg_18_0.ui_scenegraph
	local var_18_3 = arg_18_0:_input_service()
	local var_18_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_18_1, var_18_2, var_18_3, arg_18_1, nil, arg_18_0.render_settings)

	for iter_18_0, iter_18_1 in ipairs(arg_18_0._widgets) do
		UIRenderer.draw_widget(var_18_1, iter_18_1)
	end

	for iter_18_2, iter_18_3 in ipairs(arg_18_0._title_button_widgets) do
		UIRenderer.draw_widget(var_18_1, iter_18_3)
	end

	UIRenderer.end_pass(var_18_1)

	if var_18_4 and arg_18_0._menu_input_description then
		arg_18_0._menu_input_description:draw(var_18_1, arg_18_1)
	end
end

HeroWindowCraftingListConsole._play_sound = function (arg_19_0, arg_19_1)
	arg_19_0.parent:play_sound(arg_19_1)
end

HeroWindowCraftingListConsole._populate_buttons = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._title_button_widgets

	for iter_20_0, iter_20_1 in ipairs(var_20_0) do
		local var_20_1 = arg_20_1[iter_20_0]
		local var_20_2 = iter_20_1.content
		local var_20_3 = iter_20_1.style

		var_20_2.visible = var_20_1 ~= nil

		if var_20_1 then
			local var_20_4 = var_20_1.name

			var_20_2.icon = var_0_2[var_20_4].display_icon_console
		end
	end
end

HeroWindowCraftingListConsole._set_alignment_progress = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._title_button_widgets
	local var_21_1 = #var_0_9
	local var_21_2 = 100
	local var_21_3 = var_21_1 * var_21_2 / 2 - var_21_2 / 2
	local var_21_4 = 1
	local var_21_5 = 6

	for iter_21_0, iter_21_1 in ipairs(var_21_0) do
		local var_21_6 = var_0_9[iter_21_0]
		local var_21_7 = iter_21_1.content
		local var_21_8 = iter_21_1.style
		local var_21_9 = iter_21_1.offset

		var_21_9[2] = var_21_3 * arg_21_1
		var_21_9[1] = -0.00055 * var_21_9[2]^2

		local var_21_10 = 0.001 * var_21_9[2]

		var_21_8.holder.angle = -(var_21_10 * arg_21_1)
		var_21_3 = var_21_3 - var_21_2
		var_21_4 = iter_21_0 > math.ceil(var_21_1 / 2) and var_21_4 - 1 or var_21_4 + 1

		if var_21_7.button_hotspot.is_selected then
			var_21_9[3] = (var_21_1 + 1) * var_21_5
		else
			var_21_9[3] = iter_21_0 * var_21_5
		end
	end
end

HeroWindowCraftingListConsole._setup_text_button_size = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_1.scenegraph_id
	local var_22_1 = arg_22_1.content
	local var_22_2 = arg_22_1.style.text
	local var_22_3 = var_22_1.text_field or var_22_1.text

	if var_22_2.localize then
		var_22_3 = Localize(var_22_3)
	end

	if var_22_2.upper_case then
		var_22_3 = TextToUpper(var_22_3)
	end

	local var_22_4 = arg_22_0.ui_scenegraph
	local var_22_5 = arg_22_0.ui_top_renderer
	local var_22_6, var_22_7 = UIFontByResolution(var_22_2)
	local var_22_8, var_22_9, var_22_10 = UIRenderer.text_size(var_22_5, var_22_3, var_22_6[1], var_22_7)

	var_22_4[var_22_0].size[1] = var_22_8

	return var_22_8
end

HeroWindowCraftingListConsole._set_text_button_horizontal_position = function (arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.ui_scenegraph[arg_23_1.scenegraph_id].local_position[1] = arg_23_2
end

HeroWindowCraftingListConsole._animate_entry = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_1.content
	local var_24_1 = arg_24_1.style
	local var_24_2 = var_24_0.button_hotspot
	local var_24_3 = var_24_2.is_hover
	local var_24_4 = var_24_2.is_selected
	local var_24_5 = not var_24_4 and var_24_2.is_clicked and var_24_2.is_clicked == 0
	local var_24_6 = var_24_2.input_progress or 0
	local var_24_7 = var_24_2.hover_progress or 0
	local var_24_8 = var_24_2.selection_progress or 0
	local var_24_9 = 8
	local var_24_10 = 20

	if var_24_5 then
		var_24_6 = math.min(var_24_6 + arg_24_2 * var_24_10, 1)
	else
		var_24_6 = math.max(var_24_6 - arg_24_2 * var_24_10, 0)
	end

	local var_24_11 = math.easeOutCubic(var_24_6)
	local var_24_12 = math.easeInCubic(var_24_6)

	if var_24_3 then
		var_24_7 = math.min(var_24_7 + arg_24_2 * var_24_9, 1)
	else
		var_24_7 = math.max(var_24_7 - arg_24_2 * var_24_9, 0)
	end

	local var_24_13 = math.easeOutCubic(var_24_7)
	local var_24_14 = math.easeInCubic(var_24_7)

	if var_24_4 then
		var_24_8 = math.min(var_24_8 + arg_24_2 * var_24_9, 1)
	else
		var_24_8 = math.max(var_24_8 - arg_24_2 * var_24_9, 0)
	end

	local var_24_15 = math.easeOutCubic(var_24_8)
	local var_24_16 = math.easeInCubic(var_24_8)
	local var_24_17 = math.max(var_24_7, var_24_8)
	local var_24_18 = math.max(var_24_15, var_24_13)
	local var_24_19 = math.max(var_24_14, var_24_16)
	local var_24_20 = 255 * var_24_17

	var_24_1.selection.color[1] = var_24_20

	local var_24_21 = 100 + 155 * var_24_17

	var_24_1.icon.color[2] = var_24_21
	var_24_1.icon.color[3] = var_24_21
	var_24_1.icon.color[4] = var_24_21
	var_24_2.hover_progress = var_24_7
	var_24_2.input_progress = var_24_6
	var_24_2.selection_progress = var_24_8
end
