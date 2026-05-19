-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_dark_pact_character_selection_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_dark_pact_character_selection_console_definitions")
local var_0_1 = var_0_0.widget_definitions
local var_0_2 = var_0_0.generic_input_actions
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.scenegraph_definition
local var_0_5 = 5
local var_0_6 = 5

HeroWindowDarkPactCharacterSelectionConsole = class(HeroWindowDarkPactCharacterSelectionConsole)
HeroWindowDarkPactCharacterSelectionConsole.NAME = "HeroWindowDarkPactCharacterSelectionConsole"

function HeroWindowDarkPactCharacterSelectionConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowDarkPactCharacterSelectionConsole")

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._profile_synchronizer = var_1_0.profile_synchronizer
	arg_1_0._ingame_ui = var_1_0.ingame_ui
	arg_1_0._parent = arg_1_1.parent
	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._hero_name = arg_1_1.hero_name
	arg_1_0._career_index = arg_1_1.career_index or 0
	arg_1_0._profile_index = arg_1_1.profile_index or 0
	arg_1_0._profile_selectable = false
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	local var_1_1 = Managers.player:local_player()

	arg_1_0._peer_id = var_1_1:network_id()
	arg_1_0._local_player_id = var_1_1:local_player_id()
	arg_1_0._player_stats_id = var_1_1:stats_id()
	arg_1_0._statistics_db = var_1_0.statistics_db

	local var_1_2 = UILayer.default + 300
	local var_1_3 = arg_1_0._parent:window_input_service()

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(var_1_0, arg_1_0._ui_top_renderer, var_1_3, 4, var_1_2 + 100, var_0_2.default, true)

	arg_1_0._menu_input_description:set_input_description(nil)

	arg_1_0._dark_pact_profiles = arg_1_0:_get_dark_pact_selectable_profiles()

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_start_transition_animation("on_enter", "on_enter")
	arg_1_0:_first_pactsworn_setup(arg_1_0._profile_index, arg_1_0._career_index)

	local var_1_4 = (DLCSettings.carousel and DLCSettings.carousel.hero_window_mood_settings).pactsworn or "default"

	arg_1_0._parent:set_background_mood(var_1_4)
end

function HeroWindowDarkPactCharacterSelectionConsole._first_pactsworn_setup(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = SPProfiles[arg_2_1]
	local var_2_1 = 1
	local var_2_2 = 1

	if var_2_0.affiliation ~= "dark_pact" then
		local var_2_3 = Math.random(1, arg_2_0._num_max_rows)
		local var_2_4 = arg_2_0._num_hero_columns[var_2_3] or 1
		local var_2_5 = Math.random(1, var_2_4)

		arg_2_0._selected_row = var_2_3
		arg_2_0._selected_column = var_2_5
		arg_2_1, arg_2_2 = arg_2_0:_get_selected_dark_pact_profile_and_career_indx(var_2_3, var_2_5)
	end

	arg_2_0._selected_dark_pact_profile_index = arg_2_1
	arg_2_0._selected_dark_pact_career_index = arg_2_2

	arg_2_0:_set_selected_portrait(arg_2_1, arg_2_2)

	if arg_2_0._selected_dark_pact_profile_index > 0 and arg_2_0._selected_dark_pact_career_index > 0 then
		arg_2_0:_select_hero(arg_2_0._selected_dark_pact_profile_index, arg_2_0._selected_dark_pact_career_index)
	end
end

function HeroWindowDarkPactCharacterSelectionConsole._set_selected_portrait(arg_3_0, arg_3_1, arg_3_2)
	for iter_3_0 = 1, arg_3_0._num_max_rows do
		for iter_3_1 = 1, arg_3_0._num_hero_columns[iter_3_0] do
			local var_3_0 = arg_3_0._selection_widget_lookup[iter_3_0][iter_3_1].content
			local var_3_1 = arg_3_1 == var_3_0.profile_index and arg_3_2 == var_3_0.career_index

			var_3_0.selected = var_3_1

			if var_3_1 then
				arg_3_0._selected_row = iter_3_0
				arg_3_0._selected_column = iter_3_1
			end
		end
	end
end

function HeroWindowDarkPactCharacterSelectionConsole._get_selected_dark_pact_profile_and_career_indx(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_0._selection_widget_lookup then
		return arg_4_0._dark_pact_profiles[1], 1
	end

	if arg_4_2 > arg_4_0._num_hero_columns[arg_4_1] then
		arg_4_2 = arg_4_0._num_hero_columns[arg_4_1]
	end

	local var_4_0 = arg_4_0._selection_widget_lookup[arg_4_1][arg_4_2].content
	local var_4_1 = var_4_0.profile_index
	local var_4_2 = var_4_0.career_index

	return var_4_1, var_4_2
end

function HeroWindowDarkPactCharacterSelectionConsole._select_hero(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if not arg_5_3 then
		arg_5_0:_play_sound("play_gui_hero_select_career_click")
	end

	local var_5_0 = SPProfiles[arg_5_1]
	local var_5_1 = var_5_0.careers[arg_5_2]
	local var_5_2 = var_5_0.display_name
	local var_5_3 = var_5_0.character_name
	local var_5_4 = var_5_1.display_name

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_5_4 == "bw_necromancer")

	local var_5_5 = Localize(var_5_3)
	local var_5_6 = Localize(var_5_4)

	arg_5_0._selected_dark_pact_career_index = arg_5_2
	arg_5_0._selected_dark_pact_profile_index = arg_5_1
	arg_5_0._selected_hero_name = var_5_2

	Managers.state.event:trigger("respawn_hero", {
		hero_name = var_5_2,
		career_index = arg_5_2
	})
	arg_5_0:_setup_dark_pact_loadut_data(arg_5_1, arg_5_2)
	arg_5_0._parent:change_profile(arg_5_1, arg_5_2)
end

local var_0_7 = 2

function HeroWindowDarkPactCharacterSelectionConsole._setup_dark_pact_loadut_data(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = SPProfiles[arg_6_1].careers[arg_6_2]
	local var_6_1 = arg_6_0._widgets_by_name.pactsworn_name
	local var_6_2 = var_6_0.display_name
	local var_6_3 = var_6_0.name

	var_6_1.content.text = Localize(var_6_2)

	local var_6_4 = "slot_skin"
	local var_6_5 = BackendUtils.get_loadout_item(var_6_3, var_6_4)
	local var_6_6 = DLCSettings.carousel
	local var_6_7 = var_6_6.hero_window_pactsworn_stats_by_name[var_6_3] or var_6_6.hero_window_pactsworn_stats_by_name.default

	for iter_6_0 = 1, var_0_7 do
		local var_6_8 = arg_6_0._widgets_by_name["pactsworn_stat_" .. iter_6_0].content
		local var_6_9 = var_6_7[iter_6_0]
		local var_6_10 = math.round(arg_6_0._statistics_db:get_persistent_stat(arg_6_0._player_stats_id, unpack(var_6_9)))
		local var_6_11 = Localize(var_6_6.stats_string_lookup[var_6_9[1]])

		var_6_8.text = "{#color(160,146,101,255)}" .. var_6_11 .. "{#reset()} : " .. var_6_10
		arg_6_0._widgets_by_name["pactsworn_stat_shadow_" .. iter_6_0].content.text = var_6_11 .. " : " .. var_6_10
		arg_6_0._widgets_by_name["pactsworn_stat_" .. iter_6_0 .. "_icon"].content.texture_id = var_6_6.stats_icons_lookup[var_6_9[1]]
	end

	arg_6_0._widgets_by_name.pactsworn_description.content.text = Localize(var_6_0.description)

	local var_6_12 = arg_6_0._widgets_by_name.equipment_skin.content

	if var_6_5 then
		var_6_12[var_6_4].item = var_6_5
		var_6_12[var_6_4].icon = var_6_5.data.inventory_icon
		var_6_12[var_6_4].profile_index = arg_6_0._selected_dark_pact_profile_index
		var_6_12[var_6_4].career_index = arg_6_0._selected_dark_pact_career_index
		var_6_12[var_6_4].rarity = UISettings.item_rarity_textures[var_6_5.rarity]
	end

	var_6_12.is_dark_pact = true
end

function HeroWindowDarkPactCharacterSelectionConsole._update_selectable(arg_7_0, arg_7_1, arg_7_2)
	return
end

function HeroWindowDarkPactCharacterSelectionConsole._start_transition_animation(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = {
		wwise_world = arg_8_0._wwise_world,
		render_settings = arg_8_0._render_settings
	}
	local var_8_1 = {}
	local var_8_2 = arg_8_0._ui_animator:start_animation(arg_8_2, var_8_1, var_0_4, var_8_0)

	arg_8_0._animations[arg_8_1] = var_8_2
end

function HeroWindowDarkPactCharacterSelectionConsole._create_ui_elements(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_4)

	local var_9_0 = {}
	local var_9_1 = {}

	for iter_9_0, iter_9_1 in pairs(var_0_1) do
		local var_9_2 = UIWidget.init(iter_9_1)

		var_9_0[#var_9_0 + 1] = var_9_2
		var_9_1[iter_9_0] = var_9_2
	end

	arg_9_0._widgets = var_9_0
	arg_9_0._widgets_by_name = var_9_1

	arg_9_0:_setup_dark_pact_selection_widgets()
	UIRenderer.clear_scenegraph_queue(arg_9_0._ui_renderer)

	arg_9_0._ui_animator = UIAnimator:new(arg_9_0._ui_scenegraph, var_0_3)

	if arg_9_2 then
		local var_9_3 = arg_9_0._ui_scenegraph.window.local_position

		var_9_3[1] = var_9_3[1] + arg_9_2[1]
		var_9_3[2] = var_9_3[2] + arg_9_2[2]
		var_9_3[3] = var_9_3[3] + arg_9_2[3]
	end
end

function HeroWindowDarkPactCharacterSelectionConsole._setup_dark_pact_selection_widgets(arg_10_0)
	local var_10_0 = {}

	arg_10_0._pactsworn_widgets = var_10_0

	local var_10_1 = {}

	arg_10_0._selection_widget_lookup = var_10_1
	arg_10_0._num_hero_columns = {}

	local var_10_2 = 5
	local var_10_3 = 1
	local var_10_4 = 1

	for iter_10_0, iter_10_1 in ipairs(arg_10_0._dark_pact_profiles) do
		local var_10_5 = SPProfiles[iter_10_1]
		local var_10_6 = var_10_5.display_name
		local var_10_7 = var_10_5.careers[1]
		local var_10_8 = UIWidgets.create_dark_pact_selection_widget("selection_anchor")
		local var_10_9 = UIWidget.init(var_10_8)

		var_10_0[#var_10_0 + 1] = var_10_9
		arg_10_0._widgets_by_name["selection_widget_" .. iter_10_0] = var_10_9

		local var_10_10 = var_10_9.content

		var_10_10.portrait = var_10_7.picking_image_square
		var_10_10.career_settings = var_10_7
		var_10_10.profile_index = iter_10_1
		var_10_10.career_index = 1

		if var_10_5.enemy_role == "boss" then
			var_10_10.portrait_frame = "pactsworn_frame_gold"
		end

		if not var_10_1[var_10_4] then
			var_10_1[var_10_4] = {}
		end

		var_10_1[var_10_4][var_10_3] = var_10_9

		local var_10_11 = var_10_4 % 2 == 0
		local var_10_12 = 140 * var_10_3 - 1 + 10 * var_10_3 - 1
		local var_10_13 = 140 * var_10_4 - 1 + 10 * var_10_4 - 1

		var_10_9.offset[1] = var_10_11 and var_10_12 + 70 or var_10_12
		var_10_9.offset[2] = var_10_11 and -var_10_13 + 35 or -var_10_13
		var_10_9.offset[3] = -iter_10_0 * 10
		arg_10_0._num_hero_columns[var_10_4] = var_10_3

		if var_10_3 == 5 then
			var_10_4 = var_10_4 + 1
			var_10_3 = 0
		end

		var_10_3 = var_10_3 + 1
	end

	arg_10_0._num_max_columns = var_10_2
	arg_10_0._num_max_rows = var_10_4
end

function HeroWindowDarkPactCharacterSelectionConsole._get_dark_pact_selectable_profiles(arg_11_0)
	local var_11_0 = {}

	for iter_11_0, iter_11_1 in ipairs(SPProfiles) do
		if iter_11_1.affiliation == "dark_pact" and iter_11_1.role ~= nil then
			var_11_0[#var_11_0 + 1] = iter_11_0
		end
	end

	return var_11_0
end

function HeroWindowDarkPactCharacterSelectionConsole.on_exit(arg_12_0, arg_12_1)
	print("[HeroViewWindow] Exit Substate HeroWindowDarkPactCharacterSelectionConsole")

	arg_12_0._ui_animator = nil

	local var_12_0, var_12_1, var_12_2 = arg_12_0._parent:currently_selected_profile()

	if arg_12_0._selected_profile_index ~= var_12_0 or arg_12_0._selected_career_index ~= var_12_1 then
		Managers.state.event:trigger("respawn_hero", {
			hero_name = var_12_2,
			career_index = var_12_1
		})

		local var_12_3 = SPProfiles[var_12_0].careers[var_12_1].name

		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_12_3 == "bw_necromancer")
	end
end

function HeroWindowDarkPactCharacterSelectionConsole.update(arg_13_0, arg_13_1, arg_13_2)
	if DO_RELOAD then
		DO_RELOAD = false

		arg_13_0:_create_ui_elements()
	end

	arg_13_0:_update_animations(arg_13_1)
	arg_13_0:_update_portraits(arg_13_1)
	arg_13_0:_update_input(arg_13_1)
	arg_13_0:_draw(arg_13_1)
end

function HeroWindowDarkPactCharacterSelectionConsole.post_update(arg_14_0, arg_14_1, arg_14_2)
	return
end

function HeroWindowDarkPactCharacterSelectionConsole._update_animations(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._ui_animations
	local var_15_1 = arg_15_0._animations
	local var_15_2 = arg_15_0._ui_animator

	for iter_15_0, iter_15_1 in pairs(arg_15_0._ui_animations) do
		UIAnimation.update(iter_15_1, arg_15_1)

		if UIAnimation.completed(iter_15_1) then
			arg_15_0._ui_animations[iter_15_0] = nil
		end
	end

	var_15_2:update(arg_15_1)

	for iter_15_2, iter_15_3 in pairs(var_15_1) do
		if var_15_2:is_animation_completed(iter_15_3) then
			var_15_2:stop_animation(iter_15_3)

			var_15_1[iter_15_2] = nil
		end
	end
end

function HeroWindowDarkPactCharacterSelectionConsole._update_input(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._parent:window_input_service()
	local var_16_1 = Managers.input:is_device_active("gamepad")

	if var_16_1 then
		arg_16_0:_handle_gamepad_selection(var_16_0)
	else
		arg_16_0:_handle_mouse_selection()
	end

	arg_16_0._widgets_by_name.equipment_skin.content.slot_skin.highlight = arg_16_0._higlight_inventory_selection and var_16_1
end

function HeroWindowDarkPactCharacterSelectionConsole._handle_mouse_selection(arg_17_0)
	local var_17_0 = arg_17_0._hero_widgets
	local var_17_1 = arg_17_0._num_max_rows
	local var_17_2 = arg_17_0._num_max_columns
	local var_17_3 = arg_17_0._selected_dark_pact_profile_index
	local var_17_4 = arg_17_0._selected_dark_pact_career_index
	local var_17_5 = 1

	for iter_17_0 = 1, var_17_1 do
		for iter_17_1 = 1, var_17_2 do
			local var_17_6 = arg_17_0._selection_widget_lookup[iter_17_0][iter_17_1]

			if not var_17_6 then
				break
			end

			local var_17_7 = var_17_6.content
			local var_17_8 = var_17_7.hotspot
			local var_17_9 = var_17_7.profile_index
			local var_17_10 = var_17_7.career_index

			if var_17_8.on_pressed and (var_17_9 ~= var_17_3 or var_17_10 ~= var_17_4) then
				arg_17_0:_select_hero(var_17_9, var_17_10)
				arg_17_0:_set_selected_portrait(var_17_9, var_17_10)
			end
		end
	end

	local var_17_11 = arg_17_0._widgets_by_name.equipment_skin

	if UIUtils.is_button_pressed(var_17_11, "slot_skin") then
		arg_17_0:_play_sound("play_gui_equipment_selection_click")
		arg_17_0._parent:set_selected_cosmetic_slot_index(2)
		arg_17_0._parent:set_layout_by_name("cosmetics_selection_dark_pact")
	end
end

function HeroWindowDarkPactCharacterSelectionConsole._handle_gamepad_selection(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._selected_row
	local var_18_1 = arg_18_0._selected_column
	local var_18_2 = arg_18_0._num_max_rows
	local var_18_3 = arg_18_0._num_hero_columns[var_18_0]

	if var_18_0 and var_18_1 and not arg_18_0._higlight_inventory_selection then
		local var_18_4 = false

		if var_18_1 > 1 and arg_18_1:get("move_left_hold_continuous") then
			var_18_1 = var_18_1 - 1
			var_18_4 = true
		elseif var_18_1 < var_18_3 and arg_18_1:get("move_right_hold_continuous") then
			var_18_1 = var_18_1 + 1
			var_18_4 = true
		end

		if var_18_0 > 1 and arg_18_1:get("move_up_hold_continuous") then
			var_18_0 = var_18_0 - 1
			var_18_3 = arg_18_0._num_hero_columns[var_18_0]
			var_18_4 = true
		elseif var_18_0 < var_18_2 and arg_18_1:get("move_down_hold_continuous") then
			var_18_0 = var_18_0 + 1
			var_18_3 = arg_18_0._num_hero_columns[var_18_0]
			var_18_4 = true
		end

		if var_18_3 < var_18_1 then
			var_18_1 = var_18_3
			var_18_4 = true
		end

		if var_18_4 then
			local var_18_5, var_18_6 = arg_18_0:_get_selected_dark_pact_profile_and_career_indx(var_18_0, var_18_1)

			arg_18_0:_set_selected_portrait(var_18_5, var_18_6)
		end
	end

	if arg_18_0._higlight_inventory_selection and arg_18_1:get("confirm") then
		arg_18_0._higlight_inventory_selection = nil

		arg_18_0._parent:pause_input(false)
		arg_18_0:_play_sound("play_gui_equipment_selection_click")
		arg_18_0._parent:set_selected_cosmetic_slot_index(2)
		arg_18_0._parent:set_layout_by_name("cosmetics_selection_dark_pact")

		return
	elseif arg_18_0._higlight_inventory_selection and arg_18_1:get("back") then
		arg_18_0._higlight_inventory_selection = nil

		arg_18_0._menu_input_description:change_generic_actions(var_0_2.default)
		arg_18_0._parent:pause_input(false)
	end

	local var_18_7, var_18_8 = arg_18_0:_get_selected_dark_pact_profile_and_career_indx(arg_18_0._selected_row, arg_18_0._selected_column)

	if var_18_7 and var_18_8 and not arg_18_0._higlight_inventory_selection and arg_18_1:get("confirm") then
		arg_18_0._higlight_inventory_selection = true

		arg_18_0:_select_hero(var_18_7, var_18_8)
		arg_18_0._parent:pause_input(true)
		arg_18_0._menu_input_description:change_generic_actions(var_0_2.select_inventory)
	end
end

function HeroWindowDarkPactCharacterSelectionConsole.set_focus(arg_19_0, arg_19_1)
	arg_19_0._focused = arg_19_1
end

function HeroWindowDarkPactCharacterSelectionConsole._exit(arg_20_0, arg_20_1)
	arg_20_0.exit = true
	arg_20_0.exit_level_id = arg_20_1
end

function HeroWindowDarkPactCharacterSelectionConsole._draw(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._ui_renderer
	local var_21_1 = arg_21_0._ui_top_renderer
	local var_21_2 = arg_21_0._ui_scenegraph
	local var_21_3 = arg_21_0._parent:window_input_service()
	local var_21_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_21_1, var_21_2, var_21_3, arg_21_1, nil, arg_21_0._render_settings)

	for iter_21_0, iter_21_1 in ipairs(arg_21_0._widgets) do
		UIRenderer.draw_widget(var_21_1, iter_21_1)
	end

	if arg_21_0._pactsworn_widgets then
		UIRenderer.draw_all_widgets(var_21_1, arg_21_0._pactsworn_widgets)
	end

	UIRenderer.end_pass(var_21_1)

	if var_21_4 then
		arg_21_0._menu_input_description:draw(var_21_1, arg_21_1)
	end
end

function HeroWindowDarkPactCharacterSelectionConsole._play_sound(arg_22_0, arg_22_1)
	arg_22_0._parent:play_sound(arg_22_1)
end

function HeroWindowDarkPactCharacterSelectionConsole._update_portraits(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._pactsworn_widgets
	local var_23_1 = arg_23_0._selected_dark_pact_profile_index
	local var_23_2 = arg_23_0._selected_dark_pact_career_index
	local var_23_3 = Managers.input:is_device_active("gamepad")

	for iter_23_0 = 1, #var_23_0 do
		local var_23_4 = var_23_0[iter_23_0]
		local var_23_5 = var_23_4.content
		local var_23_6 = var_23_5.hotspot
		local var_23_7 = var_23_6.hover_progress or 0
		local var_23_8 = var_23_6.selection_progress or 0
		local var_23_9
		local var_23_10

		if var_23_3 then
			var_23_9 = var_23_5.profile_index == var_23_1 and var_23_5.career_index == var_23_2 and arg_23_0._higlight_inventory_selection
			var_23_10 = var_23_5.selected
		else
			var_23_9 = var_23_5.profile_index == var_23_1 and var_23_5.career_index == var_23_2
			var_23_10 = var_23_6.is_hover or var_23_5.selected
		end

		if var_23_10 then
			var_23_7 = math.min(var_23_7 + arg_23_1 * var_0_6, 1)
		else
			var_23_7 = math.max(var_23_7 - arg_23_1 * var_0_6, 0)
		end

		if var_23_9 then
			var_23_8 = math.min(var_23_8 + arg_23_1 * var_0_6, 1)
		else
			var_23_8 = math.max(var_23_8 - arg_23_1 * var_0_6, 0)
		end

		local var_23_11 = var_23_4.style
		local var_23_12 = var_23_11.portrait_frame
		local var_23_13 = var_23_11.portrait
		local var_23_14 = var_23_11.portrait_frame_selected
		local var_23_15 = var_23_12.texture_size
		local var_23_16 = var_23_12.default_size
		local var_23_17 = var_23_12.offset
		local var_23_18 = var_23_12.default_offset
		local var_23_19 = var_23_13.texture_size
		local var_23_20 = var_23_13.default_size
		local var_23_21 = var_23_13.offset
		local var_23_22 = var_23_13.default_offset
		local var_23_23 = var_23_14.texture_size
		local var_23_24 = var_23_14.default_size
		local var_23_25 = var_23_14.offset
		local var_23_26 = var_23_14.default_offset
		local var_23_27 = 0.125
		local var_23_28 = 0.2
		local var_23_29 = math.easeOutCubic(var_23_8)

		var_23_15[1] = var_23_16[1] + var_23_16[1] * var_23_27 * var_23_29
		var_23_15[2] = var_23_16[2] + var_23_16[2] * var_23_27 * var_23_29
		var_23_17[1] = var_23_18[1] - var_23_16[1] * var_23_27 * var_23_29 * 0.5
		var_23_19[1] = var_23_20[1] + var_23_20[1] * var_23_28 * var_23_29
		var_23_19[2] = var_23_20[2] + var_23_20[2] * var_23_28 * var_23_29
		var_23_21[1] = var_23_22[1] - var_23_20[1] * var_23_28 * var_23_29 * 0.5
		var_23_23[1] = var_23_24[1] + var_23_24[1] * var_23_27 * var_23_29
		var_23_23[2] = var_23_24[2] + var_23_24[2] * var_23_27 * var_23_29
		var_23_25[1] = var_23_26[1] - var_23_24[1] * var_23_27 * var_23_29 * 0.5
		var_23_14.color[1] = 255 * var_23_7
		var_23_6.hover_progress = var_23_7
		var_23_6.selection_progress = var_23_8
	end
end
