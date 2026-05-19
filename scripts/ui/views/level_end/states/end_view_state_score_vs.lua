-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_score_vs_definitions")

require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_details")
require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report")

local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.tab_size
local var_0_5 = false
local var_0_6 = 30

EndViewStateScoreVS = class(EndViewStateScoreVS)
EndViewStateScoreVS.NAME = "EndViewStateScoreVS"

function EndViewStateScoreVS.on_enter(arg_1_0, arg_1_1)
	print("[PlayState] Enter Substate EndViewStateScoreVS")

	arg_1_0._params = arg_1_1

	local var_1_0 = arg_1_1.context

	arg_1_0._parent = arg_1_1.parent
	arg_1_0._context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}

	local var_1_1 = table.shallow_copy(var_0_0.tab_layouts)

	for iter_1_0 = #var_1_1, 1, -1 do
		local var_1_2 = var_1_1[iter_1_0].condition_func

		if var_1_2 and not var_1_2() then
			table.remove(var_1_1, iter_1_0)
		end
	end

	arg_1_0._layout_settings = var_1_1

	arg_1_0:create_ui_elements(arg_1_1)
	arg_1_0:_align_tabs()
	arg_1_0:_setup_level_widget()

	arg_1_0._ui_animator = UIAnimator:new(arg_1_0._ui_scenegraph, var_0_3)
	arg_1_0._animations = {}
	arg_1_0._animation_callbacks = {}
	arg_1_0._selected_layout_name = arg_1_0._layout_settings[1].name

	arg_1_0:_update_tab_selection(1)
	arg_1_0._parent:hide_team()
	arg_1_0:_play_animation("transition_enter")

	function arg_1_0._animation_callbacks.transition_enter()
		arg_1_0:_set_initial_tab()
	end

	arg_1_0._parent:set_input_description(nil)
end

function EndViewStateScoreVS.exit(arg_3_0, arg_3_1)
	arg_3_0._exit_started = true

	arg_3_0:_play_animation("transition_exit")
end

function EndViewStateScoreVS._play_animation(arg_4_0, arg_4_1)
	local var_4_0 = {
		render_settings = arg_4_0._render_settings
	}
	local var_4_1 = arg_4_0._ui_animator:start_animation(arg_4_1, arg_4_0._widgets_by_name, var_0_2, var_4_0)

	arg_4_0._animations[arg_4_1] = var_4_1
end

function EndViewStateScoreVS.play_sound(arg_5_0, arg_5_1)
	arg_5_0._parent:play_sound(arg_5_1)
end

function EndViewStateScoreVS.exit_done(arg_6_0)
	return arg_6_0._exit_started and table.is_empty(arg_6_0._animations)
end

function EndViewStateScoreVS.create_ui_elements(arg_7_0, arg_7_1)
	UIRenderer.clear_scenegraph_queue(arg_7_0._ui_renderer)

	arg_7_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_7_0._widgets, arg_7_0._widgets_by_name = UIUtils.create_widgets(var_0_1, {}, {})

	local var_7_0 = {}
	local var_7_1 = arg_7_0._layout_settings
	local var_7_2 = 0

	for iter_7_0 = 1, #var_7_1 do
		local var_7_3 = var_7_1[iter_7_0]
		local var_7_4 = "tab"
		local var_7_5 = var_7_3.display_name or "n/a"
		local var_7_6 = var_0_0.create_tab(var_7_4, var_7_5)
		local var_7_7 = UIWidget.init(var_7_6)
		local var_7_8 = UIUtils.get_text_width(arg_7_0._ui_renderer, var_7_7.style.text, var_7_5)

		var_7_7.offset[1] = var_7_2 + (iter_7_0 > 1 and var_7_8 * 0.5 or 0)
		var_7_2 = var_7_2 + var_7_8 * 0.5 + var_0_6
		var_7_7.style.hotspot.area_size[1] = var_7_8 * 0.5

		local var_7_9 = var_7_3.name

		var_7_7.content.layout_name = var_7_9
		var_7_0[#var_7_0 + 1] = var_7_7
	end

	arg_7_0._title_button_widgets = var_7_0
	arg_7_0._ui_animations = {}

	local var_7_10 = var_0_0.create_team_score_func
	local var_7_11 = Network.peer_id()
	local var_7_12 = 1
	local var_7_13 = arg_7_0._context.party_composition[PlayerUtils.unique_player_id(var_7_11, var_7_12)]
	local var_7_14 = var_7_13 == 1 and 2 or 1
	local var_7_15 = GameModeSettings.versus.party_names_lookup_by_id[var_7_13]
	local var_7_16 = GameModeSettings.versus.party_names_lookup_by_id[var_7_14]
	local var_7_17 = arg_7_0._context.rewards.team_scores
	local var_7_18 = var_7_17[var_7_13]
	local var_7_19 = var_7_17[var_7_14]
	local var_7_20 = var_7_10("local_team", var_7_15, var_7_18)
	local var_7_21 = var_7_10("opponent_team", var_7_16, var_7_19)
	local var_7_22 = UIWidget.init(var_7_20)
	local var_7_23 = UIWidget.init(var_7_21)

	arg_7_0._widgets[#arg_7_0._widgets + 1] = var_7_22
	arg_7_0._widgets[#arg_7_0._widgets + 1] = var_7_23
	arg_7_0._widgets_by_name.local_score = var_7_22
	arg_7_0._widgets_by_name.opponent_score = var_7_23

	local var_7_24 = #var_7_1

	arg_7_0._widgets_by_name.tab_selection.content.visible = var_7_24 > 1
	arg_7_0._widgets_by_name.prev_tab.content.visible = var_7_24 > 1
	arg_7_0._widgets_by_name.next_tab.content.visible = var_7_24 > 1

	local var_7_25 = arg_7_0._widgets_by_name.back_to_keep_button

	UIUtils.enable_button(var_7_25, false)
end

function EndViewStateScoreVS._align_tabs(arg_8_0)
	local var_8_0 = 0

	for iter_8_0, iter_8_1 in pairs(arg_8_0._title_button_widgets) do
		var_8_0 = var_8_0 + iter_8_1.style.hotspot.area_size[1] + var_0_6
	end

	for iter_8_2, iter_8_3 in pairs(arg_8_0._title_button_widgets) do
		iter_8_3.offset[1] = iter_8_3.offset[1] - var_8_0
	end

	local var_8_1 = arg_8_0._title_button_widgets[1]
	local var_8_2 = var_8_1.content.text
	local var_8_3 = var_8_1.style.text
	local var_8_4 = UIUtils.get_text_width(arg_8_0._ui_renderer, var_8_3, var_8_2)

	arg_8_0._widgets_by_name.prev_tab.offset[1] = -var_8_0 - var_8_4 * 0.5 - var_0_6 * 2

	local var_8_5 = arg_8_0._title_button_widgets[#arg_8_0._title_button_widgets]
	local var_8_6 = var_8_5.content.text
	local var_8_7 = var_8_5.style.text
	local var_8_8 = UIUtils.get_text_width(arg_8_0._ui_renderer, var_8_7, var_8_6)
	local var_8_9 = var_8_5.offset

	arg_8_0._widgets_by_name.next_tab.offset[1] = var_8_9[1] + var_8_8 * 0.5 + var_0_6 * 2
end

function EndViewStateScoreVS._setup_level_widget(arg_9_0)
	local var_9_0 = arg_9_0._widgets_by_name.level.content
	local var_9_1 = arg_9_0._context.level_key
	local var_9_2 = LevelSettings[var_9_1]

	var_9_0.icon = var_9_2 and var_9_2.level_image or "level_image_any"

	local var_9_3 = arg_9_0._context.difficulty
	local var_9_4 = DifficultySettings[var_9_3]

	var_9_0.frame = var_9_4 and var_9_4.completed_frame_texture or "map_frame_00"
	arg_9_0._widgets_by_name.level_text.content.text = Localize(var_9_2.display_name)
end

function EndViewStateScoreVS._set_text_button_size(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1.style

	var_10_0.selected_texture.texture_size[1] = arg_10_2

	local var_10_1 = 5
	local var_10_2 = arg_10_2 - var_10_1 * 2

	var_10_0.text.size[1] = var_10_2
	var_10_0.text_shadow.size[1] = var_10_2
	var_10_0.text_hover.size[1] = var_10_2
	var_10_0.text_disabled.size[1] = var_10_2
	var_10_0.text.offset[1] = var_10_0.text.default_offset[1] + var_10_1
	var_10_0.text_shadow.offset[1] = var_10_0.text_shadow.default_offset[1] + var_10_1
	var_10_0.text_hover.offset[1] = var_10_0.text_hover.default_offset[1] + var_10_1
	var_10_0.text_disabled.offset[1] = var_10_0.text_disabled.default_offset[1] + var_10_1
end

function EndViewStateScoreVS._wanted_state(arg_11_0)
	return (arg_11_0.parent:wanted_menu_state())
end

function EndViewStateScoreVS.set_input_manager(arg_12_0, arg_12_1)
	arg_12_0.input_manager = arg_12_1
end

function EndViewStateScoreVS.on_exit(arg_13_0, arg_13_1)
	print("[PlayState] Exit Substate EndViewStateScoreVS")

	arg_13_0.ui_animator = nil
end

function EndViewStateScoreVS._update_transition_timer(arg_14_0, arg_14_1)
	if not arg_14_0._transition_timer then
		return
	end

	if arg_14_0._transition_timer == 0 then
		arg_14_0._transition_timer = nil
	else
		arg_14_0._transition_timer = math.max(arg_14_0._transition_timer - arg_14_1, 0)
	end
end

function EndViewStateScoreVS.update(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0:_update_animations(arg_15_1, arg_15_2)
	arg_15_0:_handle_input(arg_15_1, arg_15_2)
	arg_15_0:_draw(arg_15_1, arg_15_2)

	if arg_15_0._active_tab then
		arg_15_0._active_tab:update(arg_15_1, arg_15_2)
	end
end

function EndViewStateScoreVS._update_animations(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._animations
	local var_16_1 = arg_16_0._ui_animator

	var_16_1:update(arg_16_1)

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		if var_16_1:is_animation_completed(iter_16_1) then
			var_16_1:stop_animation(iter_16_1)

			var_16_0[iter_16_0] = nil

			local var_16_2 = arg_16_0._animation_callbacks[iter_16_0]

			if var_16_2 then
				var_16_2()

				arg_16_0._animation_callbacks[iter_16_0] = nil
			end
		end
	end

	for iter_16_2, iter_16_3 in pairs(arg_16_0._ui_animations) do
		UIAnimation.update(iter_16_3, arg_16_1)

		if UIAnimation.completed(iter_16_3) then
			arg_16_0._ui_animations[iter_16_2] = nil

			local var_16_3 = arg_16_0._animation_callbacks[iter_16_2]

			if var_16_3 then
				var_16_3()

				arg_16_0._animation_callbacks[iter_16_2] = nil
			end
		end
	end

	local var_16_4 = arg_16_0._widgets_by_name.back_to_keep_button

	UIWidgetUtils.animate_default_button(var_16_4, arg_16_1)
end

function EndViewStateScoreVS._set_initial_tab(arg_17_0)
	arg_17_0:_change_tab(arg_17_0._selected_layout_name, 1, "")
end

function EndViewStateScoreVS._handle_input(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0._input_manager:get_service("end_of_level")
	local var_18_1 = arg_18_0._title_button_widgets

	if #var_18_1 > 1 then
		for iter_18_0 = 1, #var_18_1 do
			local var_18_2 = var_18_1[iter_18_0]

			if UIUtils.is_button_pressed(var_18_2) then
				local var_18_3 = var_18_2.content.layout_name

				if var_18_3 ~= arg_18_0._selected_layout_name then
					arg_18_0:_change_tab(var_18_3, iter_18_0, arg_18_0._selected_layout_name)
					arg_18_0:_set_selected_option(var_18_3)
				end

				arg_18_0:play_sound("Play_hud_select")

				break
			elseif UIUtils.is_button_hover_enter(var_18_2) then
				arg_18_0:play_sound("Play_hud_hover")
			end
		end
	end

	local var_18_4

	if UIUtils.is_button_pressed(arg_18_0._widgets_by_name.prev_tab) or var_18_0:get("cycle_previous") then
		var_18_4 = arg_18_0._selected_tab_index
		var_18_4 = math.clamp((var_18_4 or 1) - 1, 1, #arg_18_0._title_button_widgets)
	elseif UIUtils.is_button_pressed(arg_18_0._widgets_by_name.next_tab) or var_18_0:get("cycle_next") then
		var_18_4 = arg_18_0._selected_tab_index
		var_18_4 = math.clamp((var_18_4 or 1) + 1, 1, #arg_18_0._title_button_widgets)
	end

	if var_18_4 then
		local var_18_5 = arg_18_0._title_button_widgets[var_18_4].content.layout_name

		if var_18_5 ~= arg_18_0._selected_layout_name then
			arg_18_0:_change_tab(var_18_5, var_18_4, arg_18_0._selected_layout_name)
		end
	end

	local var_18_6 = arg_18_0._widgets_by_name.back_to_keep_button
	local var_18_7 = UIUtils.is_button_enabled(var_18_6) and var_18_0:get("refresh")

	if UIUtils.is_button_pressed(var_18_6) or var_18_7 then
		arg_18_0._done = true

		UIUtils.enable_button(var_18_6, false)
		arg_18_0:play_sound("play_gui_mission_summary_button_return_to_keep_click")
		Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
	elseif UIUtils.is_button_hover_enter(var_18_6) then
		arg_18_0:play_sound("Play_hud_hover")
	end
end

function EndViewStateScoreVS._change_tab(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if arg_19_2 < 0 or arg_19_2 > #arg_19_0._title_button_widgets then
		return
	end

	local var_19_0 = arg_19_0:_get_tab_settings_by_layout_name(arg_19_3)

	if arg_19_0._active_tab and arg_19_0._active_tab.NAME == var_19_0.class_name then
		arg_19_0._active_tab:on_exit()

		arg_19_0._active_tab = nil
	end

	local var_19_1 = arg_19_0._layout_settings[arg_19_2].class_name
	local var_19_2 = rawget(_G, var_19_1):new()

	if var_19_2.on_enter then
		var_19_2:on_enter(arg_19_0._params)
	end

	arg_19_0._active_tab = var_19_2
	arg_19_0._selected_layout_name = arg_19_1

	arg_19_0:_update_tab_selection(arg_19_2)
	arg_19_0:play_sound("Play_vs_hud_progression_scoreboard_appear")
end

function EndViewStateScoreVS._update_tab_selection(arg_20_0, arg_20_1)
	arg_20_0._selected_tab_index = arg_20_1

	for iter_20_0, iter_20_1 in ipairs(arg_20_0._title_button_widgets) do
		iter_20_1.content.hotspot.is_selected = iter_20_0 == arg_20_1
	end

	local var_20_0 = arg_20_0._title_button_widgets[arg_20_1]
	local var_20_1 = var_20_0.content.text
	local var_20_2 = var_20_0.style.text
	local var_20_3 = var_20_0.offset[1]
	local var_20_4 = 20
	local var_20_5 = UIUtils.get_text_width(arg_20_0._ui_renderer, var_20_2, var_20_1)
	local var_20_6 = arg_20_0._widgets_by_name.tab_selection
	local var_20_7 = var_20_6.style.rect

	arg_20_0._ui_animations.tab_selection_position = UIAnimation.init(UIAnimation.function_by_time, var_20_6.offset, 1, var_20_6.offset[1], var_20_3, 0.25, math.easeOutCubic)
	arg_20_0._ui_animations.tab_selection_size = UIAnimation.init(UIAnimation.function_by_time, var_20_7.texture_size, 1, var_20_7.texture_size[1], var_20_5 + var_20_4, 0.25, math.easeOutCubic)
end

function EndViewStateScoreVS._set_selected_option(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._title_button_widgets

	for iter_21_0 = 1, #var_21_0 do
		local var_21_1 = var_21_0[iter_21_0].content
		local var_21_2 = var_21_1.layout_name

		var_21_1.hotspot.is_selected = var_21_2 == arg_21_1
	end
end

function EndViewStateScoreVS.post_update(arg_22_0, arg_22_1, arg_22_2)
	return
end

function EndViewStateScoreVS._draw(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0._ui_renderer
	local var_23_1 = arg_23_0._ui_scenegraph
	local var_23_2 = arg_23_0._render_settings
	local var_23_3 = Managers.input:is_device_active("gamepad")
	local var_23_4 = arg_23_0._input_manager:get_service("end_of_level")

	UIRenderer.begin_pass(var_23_0, var_23_1, var_23_4, arg_23_1, nil, var_23_2)
	UIRenderer.draw_all_widgets(var_23_0, arg_23_0._widgets)

	if #arg_23_0._title_button_widgets > 1 then
		UIRenderer.draw_all_widgets(var_23_0, arg_23_0._title_button_widgets)
	end

	UIRenderer.end_pass(var_23_0)
end

function EndViewStateScoreVS.done(arg_24_0)
	return arg_24_0._done
end

function EndViewStateScoreVS._get_tab_settings_by_layout_name(arg_25_0, arg_25_1)
	for iter_25_0, iter_25_1 in ipairs(arg_25_0._layout_settings) do
		if iter_25_1.name == arg_25_1 then
			return iter_25_1
		end
	end
end

function EndViewStateScoreVS.activate_back_to_keep_button(arg_26_0)
	local var_26_0 = arg_26_0._widgets_by_name.back_to_keep_button

	UIUtils.enable_button(var_26_0, true)
end
