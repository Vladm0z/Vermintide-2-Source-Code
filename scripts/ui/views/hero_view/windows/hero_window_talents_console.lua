-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_talents_console.lua

require("scripts/ui/hud_ui/scrollbar_ui")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_talents_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.generic_input_actions
local var_0_5 = false

HeroWindowTalentsConsole = class(HeroWindowTalentsConsole)
HeroWindowTalentsConsole.NAME = "HeroWindowTalentsConsole"

HeroWindowTalentsConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowTalentsConsole")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player
	local var_1_2 = var_1_1:local_player()

	arg_1_0._stats_id = var_1_2:stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.player = var_1_2
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index

	local var_1_3 = FindProfileIndex(arg_1_0.hero_name)

	arg_1_0._career_name = SPProfiles[var_1_3].careers[arg_1_0.career_index].name

	local var_1_4 = ExperienceSettings.get_experience(arg_1_0.hero_name)

	arg_1_0.hero_level = ExperienceSettings.get_level(var_1_4)

	arg_1_0:_initialize_talents()
	arg_1_0:_start_transition_animation("on_enter")
end

HeroWindowTalentsConsole._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_2, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

HeroWindowTalentsConsole.on_exit = function (arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate HeroWindowTalentsConsole")

	arg_3_0.ui_animator = nil

	local var_3_0 = arg_3_0._talent_interface
	local var_3_1 = arg_3_0._career_name

	var_3_0:set_talents(var_3_1, arg_3_0._selected_talents)

	local var_3_2 = arg_3_0.player.player_unit

	if Unit.alive(var_3_2) then
		ScriptUnit.extension(var_3_2, "talent_system"):talents_changed()
		ScriptUnit.extension(var_3_2, "inventory_system"):apply_buffs_to_ammo()
	end
end

HeroWindowTalentsConsole._inject_additional_scenegraph_definitions = function (arg_4_0, arg_4_1)
	for iter_4_0, iter_4_1 in pairs(CareerSettings) do
		if iter_4_1.additional_ui_info_file then
			local var_4_0 = local_require(iter_4_1.additional_ui_info_file)

			for iter_4_2, iter_4_3 in pairs(var_4_0.scenegraph_definition_to_inject) do
				arg_4_1[iter_4_2] = iter_4_3
			end
		end
	end
end

HeroWindowTalentsConsole.create_ui_elements = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_inject_additional_scenegraph_definitions(var_0_2)

	arg_5_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_5_0 = {}
	local var_5_1 = {}

	for iter_5_0, iter_5_1 in pairs(var_0_1) do
		local var_5_2 = UIWidget.init(iter_5_1)

		var_5_0[#var_5_0 + 1] = var_5_2
		var_5_1[iter_5_0] = var_5_2
	end

	arg_5_0._widgets = var_5_0
	arg_5_0._widgets_by_name = var_5_1
	arg_5_0._additional_widgets = {}
	arg_5_0._additional_widgets_by_name = {}

	local var_5_3 = Managers.input:get_service("hero_view")
	local var_5_4 = UILayer.default + 300

	arg_5_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_5_0.ui_top_renderer, var_5_3, 7, var_5_4, var_0_4.default, true)

	arg_5_0._menu_input_description:set_input_description(nil)
	UIRenderer.clear_scenegraph_queue(arg_5_0.ui_renderer)

	arg_5_0.ui_animator = UIAnimator:new(arg_5_0._ui_scenegraph, var_0_3)

	if arg_5_2 then
		local var_5_5 = arg_5_0._ui_scenegraph.window.local_position

		var_5_5[1] = var_5_5[1] + arg_5_2[1]
		var_5_5[2] = var_5_5[2] + arg_5_2[2]
		var_5_5[3] = var_5_5[3] + arg_5_2[3]
	end
end

HeroWindowTalentsConsole._initialize_talents = function (arg_6_0)
	local var_6_0 = arg_6_0._career_name
	local var_6_1 = Managers.backend:get_interface("talents")
	local var_6_2 = var_6_1:get_talents(var_6_0)

	arg_6_0._selected_talents = table.clone(var_6_2)
	arg_6_0._talent_interface = var_6_1

	arg_6_0:_update_talents(true)

	arg_6_0._initialized = true
	arg_6_0._talent_sync_id = arg_6_0.parent.talent_sync_id
end

HeroWindowTalentsConsole._input_service = function (arg_7_0)
	local var_7_0 = arg_7_0.parent

	if var_7_0:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return var_7_0:window_input_service()
end

HeroWindowTalentsConsole.update = function (arg_8_0, arg_8_1, arg_8_2)
	if var_0_5 then
		var_0_5 = false

		arg_8_0:create_ui_elements()
	end

	arg_8_0:_update_animations(arg_8_1)
	arg_8_0:_update_talent_sync()
	arg_8_0:_handle_gamepad_input(arg_8_1, arg_8_2)
	arg_8_0:_handle_input(arg_8_1, arg_8_2)
	arg_8_0:draw(arg_8_1, arg_8_2)
end

HeroWindowTalentsConsole.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	return
end

HeroWindowTalentsConsole._update_talents = function (arg_10_0, arg_10_1)
	arg_10_0:_populate_talents_by_hero(arg_10_1)
	arg_10_0:_populate_career_info(arg_10_1)
	arg_10_0:_update_backend_talents(arg_10_1)
end

HeroWindowTalentsConsole._update_backend_talents = function (arg_11_0, arg_11_1)
	if arg_11_1 then
		return
	end

	local var_11_0 = arg_11_0._talent_interface
	local var_11_1 = arg_11_0._career_name

	var_11_0:set_talents(var_11_1, arg_11_0._selected_talents)
end

HeroWindowTalentsConsole._update_animations = function (arg_12_0, arg_12_1)
	arg_12_0.ui_animator:update(arg_12_1)

	local var_12_0 = arg_12_0._animations
	local var_12_1 = arg_12_0.ui_animator

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if var_12_1:is_animation_completed(iter_12_1) then
			var_12_1:stop_animation(iter_12_1)

			var_12_0[iter_12_0] = nil
		end
	end
end

HeroWindowTalentsConsole._is_button_pressed = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1.content.button_hotspot

	if var_13_0.on_pressed then
		var_13_0.on_pressed = false

		return true
	end
end

HeroWindowTalentsConsole._is_button_released = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.content.button_hotspot

	if var_14_0.on_release then
		var_14_0.on_release = false

		return true
	end
end

HeroWindowTalentsConsole._is_stepper_button_pressed = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.content
	local var_15_1 = var_15_0.button_hotspot_left
	local var_15_2 = var_15_0.button_hotspot_right

	if var_15_1.on_release then
		var_15_1.on_release = false

		return true, -1
	elseif var_15_2.on_release then
		var_15_2.on_release = false

		return true, 1
	end
end

HeroWindowTalentsConsole._is_button_hover_enter = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.content.button_hotspot

	return var_16_0.on_hover_enter and not var_16_0.is_selected
end

HeroWindowTalentsConsole._handle_gamepad_input = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0:_input_service()
	local var_17_1 = arg_17_0._focused_row
	local var_17_2 = arg_17_0._focused_column

	if var_17_1 and var_17_2 then
		local var_17_3 = false

		if var_17_2 > 1 and var_17_0:get("move_left_hold_continuous") then
			var_17_2 = var_17_2 - 1
			var_17_3 = true
		elseif var_17_2 < NumTalentColumns and var_17_0:get("move_right_hold_continuous") then
			var_17_2 = var_17_2 + 1
			var_17_3 = true
		end

		if var_17_1 > 1 and var_17_0:get("move_up_hold_continuous") then
			var_17_1 = var_17_1 - 1
			var_17_3 = true
		elseif var_17_1 < NumTalentRows and var_17_0:get("move_down_hold_continuous") then
			var_17_1 = var_17_1 + 1
			var_17_3 = true
		end

		if var_17_3 then
			arg_17_0:_set_talent_focused(var_17_1, var_17_2)
			arg_17_0:_play_sound("play_gui_talents_selection_hover")
		end

		local var_17_4, var_17_5 = arg_17_0:_can_press_talent(var_17_1, var_17_2)

		if var_17_4 then
			if not var_17_5 and var_17_0:get("confirm", true) then
				arg_17_0:_set_talent_selected(var_17_1, var_17_2)
			elseif var_17_0:get("refresh", true) then
				arg_17_0:_set_talent_selected(var_17_1, 0)
			end
		end
	end
end

HeroWindowTalentsConsole._handle_input = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.parent
	local var_18_1 = arg_18_0._widgets_by_name
	local var_18_2, var_18_3 = arg_18_0:_is_talent_hovered()

	if var_18_2 and var_18_3 then
		arg_18_0:_play_sound("play_gui_talents_selection_hover")
		arg_18_0:_set_talent_focused(var_18_2, var_18_3)
	end

	if arg_18_0:_is_disabled_talent_hovered() then
		arg_18_0:_play_sound("play_gui_talents_selection_hover_disabled")
	end

	local var_18_4, var_18_5 = arg_18_0:_is_talent_pressed()

	if var_18_4 and var_18_5 then
		arg_18_0:_set_talent_selected(var_18_4, var_18_5)
	end
end

HeroWindowTalentsConsole._set_talent_selected = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0._selected_talents

	if not var_19_0[arg_19_1] or var_19_0[arg_19_1] == 0 and arg_19_2 ~= 0 then
		arg_19_0:_play_sound("play_gui_talent_unlock")
	else
		arg_19_0:_play_sound("play_gui_talents_selection_click")
	end

	var_19_0[arg_19_1] = arg_19_2

	arg_19_0:_update_talents()
	arg_19_0.parent:update_talent_sync()

	arg_19_0._talent_sync_id = arg_19_0.parent.talent_sync_id
end

HeroWindowTalentsConsole._update_talent_sync = function (arg_20_0)
	local var_20_0 = arg_20_0.parent.talent_sync_id

	if var_20_0 ~= arg_20_0._talent_sync_id then
		local var_20_1 = arg_20_0._career_name
		local var_20_2 = Managers.backend:get_interface("talents")
		local var_20_3 = var_20_2:get_talents(var_20_1)

		arg_20_0._selected_talents = table.clone(var_20_3)
		arg_20_0._talent_interface = var_20_2

		arg_20_0:_update_talents(true)

		arg_20_0._talent_sync_id = var_20_0
	end
end

HeroWindowTalentsConsole.draw = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0.ui_renderer
	local var_21_1 = arg_21_0.ui_top_renderer
	local var_21_2 = arg_21_0._ui_scenegraph
	local var_21_3 = arg_21_0:_input_service()
	local var_21_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_21_1, var_21_2, var_21_3, arg_21_1, nil, arg_21_0.render_settings)

	for iter_21_0, iter_21_1 in ipairs(arg_21_0._widgets) do
		UIRenderer.draw_widget(var_21_1, iter_21_1)
	end

	local var_21_5 = arg_21_0._active_node_widgets

	if var_21_5 then
		for iter_21_2, iter_21_3 in ipairs(var_21_5) do
			UIRenderer.draw_widget(var_21_1, iter_21_3)
		end
	end

	for iter_21_4, iter_21_5 in ipairs(arg_21_0._additional_widgets) do
		UIRenderer.draw_widget(var_21_1, iter_21_5)
	end

	UIRenderer.end_pass(var_21_1)

	if var_21_4 and not arg_21_0.parent:input_blocked() then
		arg_21_0._menu_input_description:draw(var_21_1, arg_21_1)
	end

	if arg_21_0._scrollbar then
		arg_21_0._scrollbar:update(arg_21_1, arg_21_2, var_21_1, var_21_3, arg_21_0.render_settings)
	end
end

HeroWindowTalentsConsole._play_sound = function (arg_22_0, arg_22_1)
	arg_22_0.parent:play_sound(arg_22_1)
end

HeroWindowTalentsConsole._populate_talents_by_hero = function (arg_23_0, arg_23_1)
	arg_23_0:_clear_talents()

	local var_23_0 = arg_23_0._widgets_by_name
	local var_23_1 = arg_23_0.hero_name
	local var_23_2 = arg_23_0.career_index
	local var_23_3 = FindProfileIndex(var_23_1)
	local var_23_4 = SPProfiles[var_23_3].careers[var_23_2]
	local var_23_5 = (var_23_2 - 1) * NumTalentRows
	local var_23_6 = TalentTrees[var_23_1][var_23_4.talent_tree_index]
	local var_23_7 = arg_23_0._selected_talents
	local var_23_8 = PlayerUtils.get_talent_overrides_by_career(var_23_4.display_name)

	for iter_23_0 = 1, NumTalentRows do
		local var_23_9 = var_23_0["talent_row_" .. iter_23_0]

		if var_23_9 then
			local var_23_10 = var_23_9.content
			local var_23_11 = var_23_9.style
			local var_23_12 = var_23_7[iter_23_0]
			local var_23_13 = not var_23_12 or var_23_12 == 0
			local var_23_14 = "talent_point_" .. iter_23_0
			local var_23_15 = ProgressionUnlocks.is_unlocked(var_23_14, arg_23_0.hero_level)
			local var_23_16 = var_23_15 and Colors.get_color_table_with_alpha("green", 255) or Colors.get_color_table_with_alpha("red", 255)
			local var_23_17 = ProgressionUnlocks.get_unlock(var_23_14)

			var_23_10.level_text = tostring(var_23_17.level_requirement)
			var_23_11.level_text.text_color = var_23_16

			if var_23_15 and not var_23_13 then
				local var_23_18 = var_23_9.animations

				table.clear(var_23_18)
			end

			local var_23_19 = var_23_11.glow_frame

			var_23_19.color[1] = 0

			if arg_23_1 and var_23_15 and var_23_13 then
				local var_23_20 = arg_23_0:_animate_pulse(var_23_19.color, 1, 255, 100, 2)

				UIWidget.animate(var_23_9, var_23_20)
			end

			for iter_23_1 = 1, NumTalentColumns do
				local var_23_21 = var_23_12 == iter_23_1
				local var_23_22 = var_23_6[iter_23_0][iter_23_1]
				local var_23_23 = TalentIDLookup[var_23_22].talent_id
				local var_23_24 = TalentUtils.get_talent_by_id(var_23_1, var_23_23)
				local var_23_25 = "_" .. tostring(iter_23_1)
				local var_23_26 = "icon" .. var_23_25
				local var_23_27 = "hotspot" .. var_23_25
				local var_23_28 = "title_text" .. var_23_25
				local var_23_29 = "background_glow" .. var_23_25
				local var_23_30 = var_23_10[var_23_27]
				local var_23_31 = not var_23_15 or var_23_8 and var_23_8[var_23_22] == false

				if var_23_21 or var_23_13 and not var_23_31 then
					var_23_11[var_23_26].saturated = false
				else
					var_23_11[var_23_26].saturated = true
				end

				var_23_10[var_23_26] = var_23_24 and var_23_24.icon or "icons_placeholder"
				var_23_10[var_23_28] = var_23_24 and Localize(var_23_24.display_name or var_23_24.name) or "Undefined"
				var_23_30.is_selected = var_23_21
				var_23_30.talent = var_23_24
				var_23_30.talent_id = var_23_23
				var_23_30.disabled = var_23_31

				if not var_23_31 then
					var_23_11[var_23_29].saturated = false
				else
					var_23_11[var_23_29].saturated = true
				end
			end
		end
	end

	arg_23_0:_set_talent_focused(arg_23_0._focused_row or 1, arg_23_0._focused_column or 1)
end

HeroWindowTalentsConsole._clear_talents = function (arg_24_0)
	local var_24_0 = arg_24_0._widgets_by_name

	for iter_24_0 = 1, NumTalentRows do
		local var_24_1 = var_24_0["talent_row_" .. iter_24_0]

		if var_24_1 then
			local var_24_2 = var_24_1.content
			local var_24_3 = var_24_1.style

			for iter_24_1 = 1, NumTalentColumns do
				local var_24_4 = "_" .. tostring(iter_24_1)
				local var_24_5 = "icon" .. var_24_4
				local var_24_6 = "hotspot" .. var_24_4
				local var_24_7 = "title_text" .. var_24_4

				var_24_2[var_24_5] = "icons_placeholder"
				var_24_2[var_24_7] = "Undefined"
				var_24_2[var_24_6].is_selected = false
				var_24_2[var_24_6].disabled = true
			end
		end
	end
end

HeroWindowTalentsConsole._set_talent_focused = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._widgets_by_name

	for iter_25_0 = 1, NumTalentRows do
		local var_25_1 = var_25_0["talent_row_" .. iter_25_0]

		if var_25_1 then
			local var_25_2 = var_25_1.content

			for iter_25_1 = 1, NumTalentColumns do
				local var_25_3 = "_" .. tostring(iter_25_1)
				local var_25_4 = var_25_2["hotspot" .. var_25_3]
				local var_25_5 = iter_25_0 == arg_25_1 and iter_25_1 == arg_25_2

				var_25_4.focused = var_25_5

				if var_25_5 then
					local var_25_6 = var_25_4.talent
					local var_25_7 = var_25_4.disabled
					local var_25_8 = var_25_4.is_selected

					arg_25_0:_set_talent_tooltip(var_25_6, var_25_8, var_25_7)
				end
			end
		end
	end

	arg_25_0._focused_row = arg_25_1
	arg_25_0._focused_column = arg_25_2
end

HeroWindowTalentsConsole._can_press_talent = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._widgets_by_name["talent_row_" .. arg_26_1].content["hotspot_" .. arg_26_2]

	return not var_26_0.disabled, var_26_0.is_selected
end

HeroWindowTalentsConsole._is_talent_pressed = function (arg_27_0)
	local var_27_0 = arg_27_0._widgets_by_name

	for iter_27_0 = 1, NumTalentRows do
		local var_27_1 = var_27_0["talent_row_" .. iter_27_0]

		if var_27_1 then
			local var_27_2 = var_27_1.content

			for iter_27_1 = 1, NumTalentColumns do
				local var_27_3 = "_" .. tostring(iter_27_1)
				local var_27_4 = var_27_2["hotspot" .. var_27_3]

				if not var_27_4.disabled then
					if var_27_4.on_pressed and not var_27_4.is_selected then
						return iter_27_0, iter_27_1
					elseif var_27_4.on_right_click then
						return iter_27_0, 0
					end
				end
			end
		end
	end
end

HeroWindowTalentsConsole._is_talent_hovered = function (arg_28_0)
	local var_28_0 = arg_28_0._widgets_by_name

	for iter_28_0 = 1, NumTalentRows do
		local var_28_1 = var_28_0["talent_row_" .. iter_28_0]

		if var_28_1 then
			local var_28_2 = var_28_1.content

			for iter_28_1 = 1, NumTalentColumns do
				local var_28_3 = "_" .. tostring(iter_28_1)
				local var_28_4 = var_28_2["hotspot" .. var_28_3]

				if var_28_4.on_hover_enter and not var_28_4.disabled then
					return iter_28_0, iter_28_1
				end
			end
		end
	end
end

HeroWindowTalentsConsole._is_disabled_talent_hovered = function (arg_29_0)
	local var_29_0 = arg_29_0._widgets_by_name

	for iter_29_0 = 1, NumTalentRows do
		local var_29_1 = var_29_0["talent_row_" .. iter_29_0]

		if var_29_1 then
			local var_29_2 = var_29_1.content

			for iter_29_1 = 1, NumTalentColumns do
				local var_29_3 = "_" .. tostring(iter_29_1)
				local var_29_4 = var_29_2["hotspot" .. var_29_3]

				if var_29_4.on_hover_enter and var_29_4.disabled then
					return iter_29_0, iter_29_1
				end
			end
		end
	end
end

HeroWindowTalentsConsole._populate_career_info = function (arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.ui_renderer
	local var_30_1 = arg_30_0._ui_scenegraph
	local var_30_2 = arg_30_0.hero_name
	local var_30_3 = arg_30_0.career_index
	local var_30_4 = FindProfileIndex(var_30_2)
	local var_30_5 = SPProfiles[var_30_4].careers[var_30_3]
	local var_30_6 = var_30_5.name
	local var_30_7 = var_30_5.character_selection_image
	local var_30_8 = var_30_5.display_name
	local var_30_9 = arg_30_0._widgets_by_name

	if not Colors.color_definitions[var_30_6] or not Colors.get_color_table_with_alpha(var_30_6, 255) then
		local var_30_10 = {
			255,
			255,
			255,
			255
		}
	end

	local var_30_11 = CareerUtils.get_passive_ability_by_career(var_30_5)
	local var_30_12 = CareerUtils.get_ability_data_by_career(var_30_5, 1)
	local var_30_13 = var_30_11.display_name
	local var_30_14 = var_30_11.icon
	local var_30_15 = var_30_12.display_name
	local var_30_16 = var_30_12.icon

	var_30_9.passive_title_text.content.text = Localize(var_30_13)
	var_30_9.passive_description_text.content.text = UIUtils.get_ability_description(var_30_11)
	var_30_9.passive_icon.content.texture_id = var_30_14
	var_30_9.active_title_text.content.text = Localize(var_30_15)
	var_30_9.active_description_text.content.text = UIUtils.get_ability_description(var_30_12)
	var_30_9.active_icon.content.texture_id = var_30_16

	local var_30_17 = var_30_11.perks
	local var_30_18 = 0
	local var_30_19 = 0

	for iter_30_0 = 1, 3 do
		local var_30_20 = var_30_9["career_perk_" .. iter_30_0]
		local var_30_21 = var_30_20.content
		local var_30_22 = var_30_20.style
		local var_30_23 = var_30_1[var_30_20.scenegraph_id].size

		var_30_20.offset[2] = -var_30_18

		local var_30_24 = var_30_17[iter_30_0]

		if var_30_24 then
			local var_30_25 = Localize(var_30_24.display_name)
			local var_30_26 = UIUtils.get_perk_description(var_30_24)
			local var_30_27 = var_30_22.title_text
			local var_30_28 = var_30_22.description_text
			local var_30_29 = var_30_22.description_text_shadow

			var_30_21.title_text = var_30_25
			var_30_21.description_text = var_30_26

			local var_30_30 = UIUtils.get_text_height(var_30_0, var_30_23, var_30_27, var_30_25)
			local var_30_31 = UIUtils.get_text_height(var_30_0, var_30_23, var_30_28, var_30_26)

			var_30_28.offset[2] = -var_30_31
			var_30_29.offset[2] = -(var_30_31 + 2)
			var_30_18 = var_30_18 + var_30_30 + var_30_31 + var_30_19
		end

		var_30_21.visible = var_30_24 ~= nil
	end

	local var_30_32 = 260
	local var_30_33 = math.max(var_30_18 - var_30_32, 0)

	arg_30_0:_setup_additional_career_info(var_30_5, var_30_33)
end

HeroWindowTalentsConsole._setup_additional_career_info = function (arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_2 or 0

	if arg_31_1.additional_ui_info_file then
		local var_31_1 = local_require(arg_31_1.additional_ui_info_file)
		local var_31_2 = "scrollbar_window"
		local var_31_3 = "scrollbar_anchor"
		local var_31_4 = arg_31_0._ui_scenegraph[var_31_2].size[2]
		local var_31_5 = {
			0,
			-var_31_4,
			0
		}
		local var_31_6 = 0
		local var_31_7

		arg_31_0._additional_widgets, arg_31_0._additional_widgets_by_name, var_31_7 = var_31_1.setup(var_31_2, var_31_5)

		local var_31_8
		local var_31_9 = true

		arg_31_0._scrollbar = ScrollbarUI:new(arg_31_0._ui_scenegraph, var_31_2, var_31_3, var_31_7, var_31_9, var_31_8)
	else
		table.clear(arg_31_0._additional_widgets)
		table.clear(arg_31_0._additional_widgets_by_name)

		if var_31_0 > 0 then
			local var_31_10 = "scrollbar_window"
			local var_31_11 = "scrollbar_anchor"
			local var_31_12 = true
			local var_31_13

			arg_31_0._scrollbar = ScrollbarUI:new(arg_31_0._ui_scenegraph, var_31_10, var_31_11, var_31_0, var_31_12, var_31_13)
		elseif arg_31_0._scrollbar then
			arg_31_0._scrollbar:destroy(arg_31_0._ui_scenegraph)

			arg_31_0._scrollbar = nil
		end
	end
end

HeroWindowTalentsConsole._animate_pulse = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5))
end

HeroWindowTalentsConsole._set_talent_tooltip = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = arg_33_0._widgets_by_name
	local var_33_1 = var_33_0.tooltip_title
	local var_33_2 = var_33_0.tooltip_description
	local var_33_3 = var_33_0.tooltip_info
	local var_33_4 = Localize(arg_33_1.display_name or arg_33_1.name)
	local var_33_5 = UIUtils.get_talent_description(arg_33_1)
	local var_33_6
	local var_33_7

	if arg_33_3 then
		var_33_6 = Localize("talent_locked_desc")
	elseif not arg_33_2 then
		-- Nothing
	end

	var_33_1.content.text = var_33_4
	var_33_2.content.text = var_33_5
	var_33_3.content.text = var_33_6 or var_33_7 or ""
end
