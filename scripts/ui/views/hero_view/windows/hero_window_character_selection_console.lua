-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_character_selection_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_character_selection_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.hero_widget
local var_0_3 = var_0_0.empty_hero_widget
local var_0_4 = var_0_0.hero_icon_widget
local var_0_5 = var_0_0.generic_input_actions
local var_0_6 = var_0_0.animation_definitions
local var_0_7 = var_0_0.scenegraph_definition
local var_0_8 = false

HeroWindowCharacterSelectionConsole = class(HeroWindowCharacterSelectionConsole)
HeroWindowCharacterSelectionConsole.NAME = "HeroWindowCharacterSelectionConsole"

HeroWindowCharacterSelectionConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCharacterSelectionConsole")

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

	local var_1_2 = UILayer.default + 300
	local var_1_3 = arg_1_0._parent:window_input_service()

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(var_1_0, arg_1_0._ui_top_renderer, var_1_3, 4, var_1_2 + 100, var_0_5.default, true)

	arg_1_0._menu_input_description:set_input_description(nil)
	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_start_transition_animation("on_enter", "on_enter")

	if arg_1_0._profile_index > 0 and arg_1_0._career_index > 0 then
		arg_1_0:_select_hero(arg_1_0._profile_index, arg_1_0._career_index, true)
	else
		local var_1_4, var_1_5 = arg_1_0._profile_synchronizer:profile_by_peer(arg_1_0._peer_id, arg_1_0._local_player_id)

		if var_1_4 and var_1_5 then
			arg_1_0._profile_index = var_1_4
			arg_1_0._career_index = var_1_5

			local var_1_6 = Managers.backend:get_interface("hero_attributes")

			arg_1_0:_select_hero(var_1_4, var_1_5, true)
		end
	end
end

HeroWindowCharacterSelectionConsole._select_hero = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if not arg_2_3 then
		arg_2_0:_play_sound("play_gui_hero_select_career_click")
	end

	local var_2_0 = SPProfiles[arg_2_1]
	local var_2_1 = var_2_0.careers[arg_2_2]
	local var_2_2 = var_2_0.display_name
	local var_2_3 = var_2_0.character_name
	local var_2_4 = var_2_1.display_name

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_2_4 == "bw_necromancer")

	local var_2_5 = Localize(var_2_3)
	local var_2_6 = Localize(var_2_4)
	local var_2_7 = Managers.backend:get_interface("hero_attributes"):get(var_2_2, "experience") or 0
	local var_2_8 = ExperienceSettings.get_level(var_2_7)

	arg_2_0:_set_hero_info(var_2_5, var_2_6, var_2_8)

	local var_2_9 = arg_2_0._hero_widgets
	local var_2_10 = arg_2_0._num_max_hero_rows

	arg_2_0._selected_career_index = arg_2_2
	arg_2_0._selected_profile_index = arg_2_1
	arg_2_0._selected_hero_name = var_2_2
	arg_2_0._selected_hero_row = ProfileIndexToPriorityIndex[arg_2_1]
	arg_2_0._selected_hero_column = arg_2_2

	arg_2_0:_set_hero_icon_selected(arg_2_0._selected_hero_row)

	local var_2_11 = 1
	local var_2_12 = arg_2_0._widgets_by_name.info_text.content
	local var_2_13 = true

	for iter_2_0 = 1, var_2_10 do
		local var_2_14 = arg_2_0._num_hero_columns[iter_2_0]

		for iter_2_1 = 1, var_2_14 do
			local var_2_15 = iter_2_0 == arg_2_0._selected_hero_row and iter_2_1 == arg_2_0._selected_hero_column
			local var_2_16 = var_2_9[var_2_11].content

			var_2_16.button_hotspot.is_selected = var_2_15
			var_2_11 = var_2_11 + 1

			if var_2_15 then
				local var_2_17 = not var_2_16.locked
				local var_2_18 = var_2_16.dlc_name

				arg_2_0:_update_selectable(var_2_17, var_2_18)

				var_2_13 = var_2_17
			end
		end
	end

	if not arg_2_3 then
		if var_2_13 then
			Managers.state.event:trigger("respawn_hero", {
				hero_name = var_2_2,
				career_index = arg_2_2
			})
		else
			Managers.state.event:trigger("despawn_hero")
		end
	end
end

HeroWindowCharacterSelectionConsole._update_selectable = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._widgets_by_name.select_button

	var_3_0.content.button_hotspot.disable_button = not arg_3_1
	var_3_0.content.dlc_name = not arg_3_1 and arg_3_2
	arg_3_0._widgets_by_name.info_text.content.visible = arg_3_1

	local var_3_1 = "default"

	if not arg_3_1 then
		var_3_1 = "hero_unavailable"

		if arg_3_2 then
			var_3_1 = "dlc_unavailable"
		end
	end

	arg_3_0._menu_input_description:change_generic_actions(var_0_5[var_3_1])
end

HeroWindowCharacterSelectionConsole._set_hero_icon_selected = function (arg_4_0, arg_4_1)
	for iter_4_0, iter_4_1 in ipairs(arg_4_0._hero_icon_widgets) do
		iter_4_1.content.selected = iter_4_0 == arg_4_1
	end
end

HeroWindowCharacterSelectionConsole._set_hero_info = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0._widgets_by_name

	var_5_0.info_hero_name.content.text = arg_5_1
	var_5_0.info_career_name.content.text = arg_5_2
	var_5_0.info_hero_level.content.text = arg_5_3
end

HeroWindowCharacterSelectionConsole._start_transition_animation = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = {
		wwise_world = arg_6_0._wwise_world,
		render_settings = arg_6_0._render_settings
	}
	local var_6_1 = {}
	local var_6_2 = arg_6_0._ui_animator:start_animation(arg_6_2, var_6_1, var_0_7, var_6_0)

	arg_6_0._animations[arg_6_1] = var_6_2
end

HeroWindowCharacterSelectionConsole._create_ui_elements = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_7)

	local var_7_0 = {}
	local var_7_1 = {}

	for iter_7_0, iter_7_1 in pairs(var_0_1) do
		local var_7_2 = UIWidget.init(iter_7_1)

		var_7_0[#var_7_0 + 1] = var_7_2
		var_7_1[iter_7_0] = var_7_2
	end

	arg_7_0._widgets = var_7_0
	arg_7_0._widgets_by_name = var_7_1

	arg_7_0:_setup_hero_selection_widgets()
	UIRenderer.clear_scenegraph_queue(arg_7_0._ui_renderer)

	arg_7_0._ui_animator = UIAnimator:new(arg_7_0._ui_scenegraph, var_0_6)

	if arg_7_2 then
		local var_7_3 = arg_7_0._ui_scenegraph.window.local_position

		var_7_3[1] = var_7_3[1] + arg_7_2[1]
		var_7_3[2] = var_7_3[2] + arg_7_2[2]
		var_7_3[3] = var_7_3[3] + arg_7_2[3]
	end
end

HeroWindowCharacterSelectionConsole._setup_hero_selection_widgets = function (arg_8_0)
	local var_8_0 = {}

	arg_8_0._hero_widgets = var_8_0

	local var_8_1 = {}

	arg_8_0._hero_icon_widgets = var_8_1

	local var_8_2 = Managers.backend:get_interface("hero_attributes")
	local var_8_3, var_8_4 = arg_8_0._profile_synchronizer:profile_by_peer(arg_8_0._peer_id, arg_8_0._local_player_id)
	local var_8_5 = #SPProfilesAbbreviation

	if not PlayerData.bot_spawn_priority[1] then
		local var_8_6 = ProfileIndexToPriorityIndex
	end

	arg_8_0._num_hero_columns = {}

	for iter_8_0, iter_8_1 in ipairs(ProfilePriority) do
		local var_8_7 = SPProfiles[iter_8_1]
		local var_8_8 = var_8_7.display_name
		local var_8_9 = var_8_2:get(var_8_8, "experience") or 0
		local var_8_10 = ExperienceSettings.get_level(var_8_9)
		local var_8_11 = var_8_7.careers

		arg_8_0._num_hero_columns[iter_8_0] = #var_8_11

		local var_8_12 = UIWidget.init(var_0_4)

		var_8_1[#var_8_1 + 1] = var_8_12
		var_8_12.offset[2] = -((iter_8_0 - 1) * 144)

		local var_8_13 = "hero_icon_large_" .. var_8_8

		var_8_12.content.icon = var_8_13
		var_8_12.content.icon_selected = var_8_13 .. "_glow"

		for iter_8_2, iter_8_3 in ipairs(var_8_11) do
			local var_8_14 = UIWidget.init(var_0_2)

			var_8_0[#var_8_0 + 1] = var_8_14

			local var_8_15 = var_8_14.offset
			local var_8_16 = var_8_14.content

			var_8_16.career_settings = iter_8_3

			local var_8_17 = iter_8_3.portrait_image

			var_8_16.portrait = "medium_" .. var_8_17

			local var_8_18, var_8_19, var_8_20, var_8_21 = iter_8_3:is_unlocked_function(var_8_8, var_8_10)

			var_8_16.locked = not var_8_18
			var_8_16.locked_reason = not var_8_18 and (var_8_21 and var_8_19 or Localize(var_8_19))
			var_8_16.dlc_name = var_8_20

			if var_8_19 == "dlc_not_owned" then
				var_8_16.lock_texture = var_8_16.lock_texture .. "_gold"
				var_8_16.frame = var_8_16.frame .. "_gold"
			end

			local var_8_22 = var_8_2:get(var_8_8, "career")

			if (var_8_2:get(var_8_8, "bot_career") or var_8_22 or 1) == iter_8_2 then
				var_8_16.bot_selected = true
			end

			if var_8_3 == iter_8_1 and var_8_4 == iter_8_2 then
				var_8_16.is_currently_selected_character = true
			end

			var_8_15[1] = (iter_8_2 - 1) * 124
			var_8_15[2] = -((iter_8_0 - 1) * 144)
		end

		local var_8_23 = arg_8_0._widgets

		for iter_8_4 = #var_8_11 + 1, 4 do
			local var_8_24 = UIWidget.init(var_0_3)
			local var_8_25 = var_8_24.offset

			var_8_25[1] = var_8_25[1] + 124 * (iter_8_4 - 1)
			var_8_25[2] = var_8_25[2] - 144 * (iter_8_0 - 1)
			var_8_23[#var_8_23 + 1] = var_8_24
		end
	end

	arg_8_0._num_max_hero_rows = var_8_5
end

HeroWindowCharacterSelectionConsole.on_exit = function (arg_9_0, arg_9_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCharacterSelectionConsole")

	arg_9_0._ui_animator = nil

	local var_9_0, var_9_1, var_9_2 = arg_9_0._parent:currently_selected_profile()

	if arg_9_0._selected_profile_index ~= var_9_0 or arg_9_0._selected_career_index ~= var_9_1 then
		Managers.state.event:trigger("respawn_hero", {
			hero_name = var_9_2,
			career_index = var_9_1
		})

		local var_9_3 = SPProfiles[var_9_0].careers[var_9_1].name

		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_9_3 == "bw_necromancer")
	end
end

HeroWindowCharacterSelectionConsole.update = function (arg_10_0, arg_10_1, arg_10_2)
	if var_0_8 then
		var_0_8 = false

		arg_10_0:_create_ui_elements()
	end

	arg_10_0:_update_animations(arg_10_1)
	arg_10_0:_update_input(arg_10_1)
	arg_10_0:_draw(arg_10_1)
end

HeroWindowCharacterSelectionConsole.post_update = function (arg_11_0, arg_11_1, arg_11_2)
	return
end

HeroWindowCharacterSelectionConsole._update_animations = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._ui_animations
	local var_12_1 = arg_12_0._animations
	local var_12_2 = arg_12_0._ui_animator

	for iter_12_0, iter_12_1 in pairs(arg_12_0._ui_animations) do
		UIAnimation.update(iter_12_1, arg_12_1)

		if UIAnimation.completed(iter_12_1) then
			arg_12_0._ui_animations[iter_12_0] = nil
		end
	end

	var_12_2:update(arg_12_1)

	for iter_12_2, iter_12_3 in pairs(var_12_1) do
		if var_12_2:is_animation_completed(iter_12_3) then
			var_12_2:stop_animation(iter_12_3)

			var_12_1[iter_12_2] = nil
		end
	end
end

HeroWindowCharacterSelectionConsole._update_input = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._parent:window_input_service()

	arg_13_0:_handle_gamepad_selection(var_13_0)
	arg_13_0:_handle_mouse_selection()

	local var_13_1, var_13_2 = arg_13_0._profile_synchronizer:profile_by_peer(arg_13_0._peer_id, arg_13_0._local_player_id)
	local var_13_3 = arg_13_0._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(var_13_3, arg_13_1)

	if UIUtils.is_button_hover_enter(var_13_3) then
		arg_13_0:_play_sound("play_gui_start_menu_button_hover")
	end

	local var_13_4 = Managers.input:is_device_active("gamepad")
	local var_13_5 = not var_13_3.content.button_hotspot.disable_button
	local var_13_6 = var_13_0:get("confirm", true)

	if var_13_4 and arg_13_0.allow_back_button then
		local var_13_7 = var_13_0:get("back_menu", true)
	end

	if (UIUtils.is_button_pressed(var_13_3) or var_13_6) and var_13_5 then
		arg_13_0:_play_sound("play_gui_start_menu_button_click")

		local var_13_8 = var_13_3.content.verify_dlc_name

		if var_13_8 and Managers.unlock:dlc_requires_restart(var_13_8) then
			arg_13_0._parent:close_menu()

			return
		end

		arg_13_0._parent:change_profile(arg_13_0._selected_profile_index, arg_13_0._selected_career_index)

		local var_13_9 = arg_13_0._parent:get_previous_selected_game_mode_index()

		arg_13_0._parent:set_layout(var_13_9 or 1)
	elseif var_13_6 and var_13_3.content.dlc_name then
		arg_13_0:_play_sound("play_gui_start_menu_button_click")
		Managers.state.event:trigger("ui_show_popup", var_13_3.content.dlc_name, "upsell")
	end
end

HeroWindowCharacterSelectionConsole._handle_mouse_selection = function (arg_14_0)
	local var_14_0 = arg_14_0._hero_widgets
	local var_14_1 = arg_14_0._num_max_hero_rows
	local var_14_2 = arg_14_0._selected_hero_row
	local var_14_3 = arg_14_0._selected_hero_column
	local var_14_4 = 1

	for iter_14_0 = 1, var_14_1 do
		local var_14_5 = arg_14_0._num_hero_columns[iter_14_0]

		for iter_14_1 = 1, var_14_5 do
			local var_14_6 = var_14_0[var_14_4].content
			local var_14_7 = var_14_6.button_hotspot

			if not var_14_6.locked and var_14_7.on_pressed and (iter_14_0 ~= var_14_2 or iter_14_1 ~= var_14_3) then
				local var_14_8 = ProfilePriority[iter_14_0]
				local var_14_9 = iter_14_1

				arg_14_0:_select_hero(var_14_8, var_14_9)

				return
			elseif var_14_6.dlc_name and var_14_7.on_pressed and (iter_14_0 ~= var_14_2 or iter_14_1 ~= var_14_3) then
				Managers.state.event:trigger("ui_show_popup", var_14_6.dlc_name, "upsell")
			end

			var_14_4 = var_14_4 + 1
		end
	end
end

HeroWindowCharacterSelectionConsole._handle_gamepad_selection = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._selected_hero_row
	local var_15_1 = arg_15_0._selected_hero_column
	local var_15_2 = arg_15_0._num_max_hero_rows
	local var_15_3 = arg_15_0._num_hero_columns[var_15_0]

	if var_15_0 and var_15_1 then
		local var_15_4 = false

		if var_15_1 > 1 and arg_15_1:get("move_left_hold_continuous") then
			var_15_1 = var_15_1 - 1
			var_15_4 = true
		elseif var_15_1 < var_15_3 and arg_15_1:get("move_right_hold_continuous") then
			var_15_1 = var_15_1 + 1
			var_15_4 = true
		end

		if var_15_0 > 1 and arg_15_1:get("move_up_hold_continuous") then
			var_15_0 = var_15_0 - 1
			var_15_3 = arg_15_0._num_hero_columns[var_15_0]
			var_15_4 = true
		elseif var_15_0 < var_15_2 and arg_15_1:get("move_down_hold_continuous") then
			var_15_0 = var_15_0 + 1
			var_15_3 = arg_15_0._num_hero_columns[var_15_0]
			var_15_4 = true
		end

		if var_15_3 < var_15_1 then
			var_15_1 = var_15_3
			var_15_4 = true
		end

		if var_15_4 then
			local var_15_5 = ProfilePriority[var_15_0]
			local var_15_6 = var_15_1

			arg_15_0:_select_hero(var_15_5, var_15_6)
		end
	end
end

HeroWindowCharacterSelectionConsole.set_focus = function (arg_16_0, arg_16_1)
	arg_16_0._focused = arg_16_1
end

HeroWindowCharacterSelectionConsole._exit = function (arg_17_0, arg_17_1)
	arg_17_0.exit = true
	arg_17_0.exit_level_id = arg_17_1
end

HeroWindowCharacterSelectionConsole._draw = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._ui_renderer
	local var_18_1 = arg_18_0._ui_top_renderer
	local var_18_2 = arg_18_0._ui_scenegraph
	local var_18_3 = arg_18_0._parent:window_input_service()
	local var_18_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_18_1, var_18_2, var_18_3, arg_18_1, nil, arg_18_0._render_settings)

	for iter_18_0, iter_18_1 in ipairs(arg_18_0._widgets) do
		UIRenderer.draw_widget(var_18_1, iter_18_1)
	end

	for iter_18_2, iter_18_3 in ipairs(arg_18_0._hero_widgets) do
		UIRenderer.draw_widget(var_18_1, iter_18_3)
	end

	for iter_18_4, iter_18_5 in ipairs(arg_18_0._hero_icon_widgets) do
		UIRenderer.draw_widget(var_18_1, iter_18_5)
	end

	UIRenderer.end_pass(var_18_1)

	if var_18_4 then
		arg_18_0._menu_input_description:draw(var_18_1, arg_18_1)
	end
end

HeroWindowCharacterSelectionConsole._play_sound = function (arg_19_0, arg_19_1)
	arg_19_0._parent:play_sound(arg_19_1)
end
