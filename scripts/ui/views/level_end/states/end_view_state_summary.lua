-- chunkname: @scripts/ui/views/level_end/states/end_view_state_summary.lua

local var_0_0 = false

EndViewStateSummary = class(EndViewStateSummary)
EndViewStateSummary.NAME = "EndViewStateSummary"
EndViewStateSummary.CAN_SPEED_UP = true

function EndViewStateSummary.on_enter(arg_1_0, arg_1_1)
	print("[EndViewState] Enter Substate EndViewStateSummary")

	arg_1_0._params = arg_1_1
	arg_1_0.parent = arg_1_1.parent
	arg_1_0.game_won = arg_1_1.game_won
	arg_1_0.game_mode_key = arg_1_1.game_mode_key

	local var_1_0 = arg_1_1.context

	arg_1_0._context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.profile_synchronizer = var_1_0.profile_synchronizer
	arg_1_0.rewards = var_1_0.rewards
	arg_1_0.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0.wwise_world = var_1_0.wwise_world
	arg_1_0.world_previewer = arg_1_1.world_previewer
	arg_1_0.platform = PLATFORM
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._hero_name = var_1_0.local_player_hero_name

	arg_1_0:create_ui_elements(arg_1_1)

	if arg_1_1.initial_state then
		arg_1_0._initial_preview = true
		arg_1_1.initial_state = nil
	end

	if arg_1_0.game_won then
		arg_1_0:_start_transition_animation("on_enter", "transition_enter_fast")
	else
		arg_1_0:_start_transition_animation("on_enter", "transition_enter")
	end

	arg_1_0._exit_timer = nil

	local var_1_1 = arg_1_0._context.rewards.level_start
	local var_1_2 = var_1_1[1]
	local var_1_3 = var_1_1[2]
	local var_1_4 = var_1_1[3]

	arg_1_0:_setup_essence_presentation()

	arg_1_0._progress_data = arg_1_0:_get_total_experience_progress_data(var_1_3, var_1_4)

	local var_1_5 = ExperienceSettings.get_level(var_1_3)
	local var_1_6 = var_1_3 + var_1_4

	if var_1_5 < ExperienceSettings.max_level then
		var_1_6 = var_1_3
	end

	local var_1_7, var_1_8 = arg_1_0:_set_current_experience(var_1_6)

	arg_1_0._current_level = var_1_7

	if arg_1_0._progress_data.bonus_experience > 0 then
		arg_1_0._extra_levels = var_1_8 + arg_1_0._progress_data.start_extra_level
	else
		arg_1_0._extra_levels = var_1_8
	end

	arg_1_0._experience_presentation_completed = nil

	if IS_WINDOWS then
		arg_1_0:_set_player_count_presence(var_1_0)
	end

	arg_1_0:_play_sound("play_gui_mission_summary_appear")
end

function EndViewStateSummary.exit(arg_2_0, arg_2_1)
	arg_2_0._exit_started = true

	arg_2_0:_start_transition_animation("on_enter", "transition_exit")
	arg_2_0:_play_sound("play_gui_mission_summary_end")

	if arg_2_0.game_won and Managers.package:has_loaded("resource_packages/levels/ui_end_screen") then
		local var_2_0 = {
			level_name = "levels/end_screen_victory/parading_screen",
			camera_name = "end_screen_camera",
			animation_name = "transition"
		}

		arg_2_0.parent:trigger_transition(var_2_0)
	end
end

function EndViewStateSummary.exit_done(arg_3_0)
	return arg_3_0._exit_started and arg_3_0._animations.on_enter == nil
end

function EndViewStateSummary._get_definitions(arg_4_0)
	return local_require("scripts/ui/views/level_end/states/definitions/end_view_state_summary_definitions")
end

function EndViewStateSummary.create_ui_elements(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:_get_definitions()
	local var_5_1 = var_5_0.widgets
	local var_5_2 = var_5_0.summary_entry_widgets
	local var_5_3 = var_5_0.scenegraph_definition
	local var_5_4 = var_5_0.animation_definitions

	var_0_0 = false
	arg_5_0._scenegraph_definition = var_5_3
	arg_5_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_5_3)

	local var_5_5 = {}
	local var_5_6 = {}

	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		local var_5_7 = UIWidget.init(iter_5_1)

		var_5_5[#var_5_5 + 1] = var_5_7
		var_5_6[iter_5_0] = var_5_7
	end

	arg_5_0._widgets = var_5_5
	arg_5_0._widgets_by_name = var_5_6

	local var_5_8 = {}
	local var_5_9 = {}

	for iter_5_2, iter_5_3 in pairs(var_5_2) do
		local var_5_10 = UIWidget.init(iter_5_3)

		var_5_8[#var_5_8 + 1] = var_5_10
		var_5_9[iter_5_2] = var_5_10
	end

	arg_5_0._entry_widgets = var_5_8
	arg_5_0._entry_widgets_by_name = var_5_9

	UIRenderer.clear_scenegraph_queue(arg_5_0.ui_renderer)

	arg_5_0.ui_animator = UIAnimator:new(arg_5_0.ui_scenegraph, var_5_4)
end

function EndViewStateSummary._wanted_state(arg_6_0)
	return (arg_6_0.parent:wanted_menu_state())
end

function EndViewStateSummary.set_input_manager(arg_7_0, arg_7_1)
	arg_7_0.input_manager = arg_7_1
end

function EndViewStateSummary.on_exit(arg_8_0, arg_8_1)
	print("[EndViewState] Exit Substate EndViewStateSummary")

	arg_8_0.ui_animator = nil
end

function EndViewStateSummary._update_transition_timer(arg_9_0, arg_9_1)
	if not arg_9_0._transition_timer then
		return
	end

	if arg_9_0._transition_timer == 0 then
		arg_9_0._transition_timer = nil
	else
		arg_9_0._transition_timer = math.max(arg_9_0._transition_timer - arg_9_1, 0)
	end
end

function EndViewStateSummary.update(arg_10_0, arg_10_1, arg_10_2)
	if var_0_0 then
		arg_10_0:on_enter(arg_10_0._params)
	end

	local var_10_0 = arg_10_0.input_manager:get_service("end_of_level")

	if not arg_10_0._animations.on_enter and not arg_10_0._summary_entries then
		arg_10_0:_initialize_entries()
	end

	arg_10_0:draw(var_10_0, arg_10_1)
	arg_10_0:_update_transition_timer(arg_10_1)

	local var_10_1 = arg_10_0:_wanted_state()

	if not arg_10_0._transition_timer and (var_10_1 or arg_10_0._new_state) then
		arg_10_0.parent:clear_wanted_menu_state()

		return var_10_1 or arg_10_0._new_state
	end

	local var_10_2 = arg_10_0.parent:displaying_reward_presentation()

	if arg_10_0._summary_entries and arg_10_0._summary_entries.complete then
		arg_10_0:_animate_experience_bar(arg_10_1, var_10_2)
	end

	if not var_10_2 then
		arg_10_0.ui_animator:update(arg_10_1)
		arg_10_0:_animate_summary_entries(arg_10_1)
	end

	arg_10_0:_update_animations(arg_10_1)

	if not arg_10_0.parent:transitioning() and not arg_10_0._transition_timer then
		arg_10_0:_handle_input(arg_10_1, arg_10_2)
	end
end

function EndViewStateSummary.post_update(arg_11_0, arg_11_1, arg_11_2)
	return
end

function EndViewStateSummary._update_animations(arg_12_0, arg_12_1)
	for iter_12_0, iter_12_1 in pairs(arg_12_0._ui_animations) do
		UIAnimation.update(iter_12_1, arg_12_1)

		if UIAnimation.completed(iter_12_1) then
			arg_12_0._ui_animations[iter_12_0] = nil
		end
	end

	local var_12_0 = arg_12_0._animations
	local var_12_1 = arg_12_0.ui_animator

	for iter_12_2, iter_12_3 in pairs(var_12_0) do
		if var_12_1:is_animation_completed(iter_12_3) then
			var_12_1:stop_animation(iter_12_3)

			var_12_0[iter_12_2] = nil
		end
	end

	if arg_12_0.level_up_anim_id and var_12_1:is_animation_completed(arg_12_0.level_up_anim_id) then
		var_12_1:stop_animation(arg_12_0.level_up_anim_id)

		arg_12_0.level_up_anim_id = nil

		local var_12_2 = ExperienceSettings.max_level
		local var_12_3

		if var_12_2 > arg_12_0._current_level then
			var_12_3 = arg_12_0._current_level
		else
			var_12_3 = arg_12_0._current_level + (arg_12_0._extra_levels or 0)
		end

		arg_12_0.parent:present_level_up(arg_12_0._hero_name, var_12_3)
	end
end

function EndViewStateSummary._handle_input(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._widgets_by_name
end

function EndViewStateSummary.draw(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.ui_renderer
	local var_14_1 = arg_14_0.ui_scenegraph
	local var_14_2 = arg_14_0.render_settings

	UIRenderer.begin_pass(var_14_0, var_14_1, arg_14_1, arg_14_2, nil, var_14_2)

	for iter_14_0, iter_14_1 in ipairs(arg_14_0._widgets) do
		UIRenderer.draw_widget(var_14_0, iter_14_1)
	end

	local var_14_3 = arg_14_0._summary_entries

	if var_14_3 then
		for iter_14_2, iter_14_3 in ipairs(var_14_3) do
			local var_14_4 = iter_14_3.widget

			if var_14_4 then
				UIRenderer.draw_widget(var_14_0, var_14_4)
			end
		end
	end

	UIRenderer.end_pass(var_14_0)
end

function EndViewStateSummary._start_transition_animation(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = {
		wwise_world = arg_15_0.wwise_world,
		render_settings = arg_15_0.render_settings
	}
	local var_15_1 = {}
	local var_15_2 = arg_15_0.ui_animator:start_animation(arg_15_2, var_15_1, arg_15_0._scenegraph_definition, var_15_0)

	arg_15_0._animations[arg_15_1] = var_15_2
end

function EndViewStateSummary._start_animation(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {
		wwise_world = arg_16_0.wwise_world,
		render_settings = arg_16_0.render_settings
	}
	local var_16_1 = arg_16_0._widgets_by_name
	local var_16_2 = arg_16_0.ui_animator:start_animation(arg_16_2, var_16_1, arg_16_0._scenegraph_definition, var_16_0)

	arg_16_0._animations[arg_16_1] = var_16_2
end

function EndViewStateSummary._animate_element_by_time(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, math.ease_out_quad))
end

function EndViewStateSummary._animate_element_by_catmullrom(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8))
end

function EndViewStateSummary._initialize_entries(arg_19_0)
	local var_19_0, var_19_1 = arg_19_0:_get_summary_entries(arg_19_0.game_won, arg_19_0.game_mode_key)

	arg_19_0._summary_entries = var_19_0
end

function EndViewStateSummary._get_summary_entries(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._context.rewards.mission_results
	local var_20_1 = arg_20_0._entry_widgets
	local var_20_2 = {}
	local var_20_3 = 0
	local var_20_4 = 0

	for iter_20_0, iter_20_1 in ipairs(var_20_0) do
		var_20_3 = var_20_3 % #var_20_1 + 1

		local var_20_5 = "entry_" .. iter_20_0
		local var_20_6 = iter_20_1.text
		local var_20_7 = iter_20_1.format_values
		local var_20_8 = iter_20_1.experience and math.round(iter_20_1.experience)
		local var_20_9 = iter_20_1.value
		local var_20_10 = iter_20_1.bonus
		local var_20_11 = iter_20_1.icon
		local var_20_12 = var_20_1[var_20_3]
		local var_20_13

		if var_20_6 then
			if var_20_7 then
				var_20_13 = UIUtils.format_localized_description(var_20_6, var_20_7)
			else
				var_20_13 = Localize(var_20_6)
			end
		end

		local var_20_14 = var_20_8 and tostring(var_20_8) or var_20_9 and tostring(var_20_9) or ""

		var_20_2[iter_20_0] = {
			spacing = 8,
			start_counter_sound = true,
			name = var_20_5,
			title_text = var_20_13,
			experience = var_20_8,
			value = var_20_9,
			value_text = var_20_14,
			bonus = var_20_10,
			widget = var_20_12,
			icon = var_20_11,
			list_index = iter_20_0,
			wwise_world = arg_20_0.wwise_world
		}

		if var_20_8 then
			var_20_4 = var_20_4 + var_20_8
		end
	end

	return var_20_2, var_20_4
end

function EndViewStateSummary._animate_summary_entries(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._summary_entries

	if not var_21_0 or var_21_0.complete then
		if var_21_0 and var_21_0.complete and arg_21_0._is_max_level and not arg_21_0._experience_presentation_completed then
			arg_21_0._experience_presentation_completed = true

			arg_21_0.parent:present_additional_rewards()
		end

		return
	end

	local var_21_1 = arg_21_0.ui_animator
	local var_21_2 = "summary_entry_initial"
	local var_21_3 = "summary_entry_text_shadow"

	if arg_21_0.total_experience_count_anim_id and var_21_1:is_animation_completed(arg_21_0.total_experience_count_anim_id) then
		var_21_1:stop_animation(arg_21_0.total_experience_count_anim_id)

		arg_21_0.total_experience_count_anim_id = nil
	end

	local var_21_4 = true

	for iter_21_0, iter_21_1 in ipairs(var_21_0) do
		if not iter_21_1.animation_completed then
			if not arg_21_0.summary_entry_enter_anim_id then
				arg_21_0.summary_entry_enter_anim_id = arg_21_0.ui_animator:start_animation(var_21_2, arg_21_0._widgets_by_name, arg_21_0._scenegraph_definition, iter_21_1)
			elseif var_21_1:is_animation_completed(arg_21_0.summary_entry_enter_anim_id) then
				var_21_1:stop_animation(arg_21_0.summary_entry_enter_anim_id)

				arg_21_0.summary_entry_enter_anim_id = nil
				iter_21_1.animation_completed = true
				arg_21_0.total_experience_count_anim_id = arg_21_0.ui_animator:start_animation("total_experience_increase", arg_21_0._widgets_by_name, arg_21_0._scenegraph_definition, iter_21_1)
			end

			var_21_4 = false
		end
	end

	var_21_0.complete = var_21_4

	if var_21_4 then
		-- block empty
	end
end

function EndViewStateSummary._get_essence_earned(arg_22_0)
	local var_22_0 = arg_22_0._context.rewards.end_of_level_rewards.essence

	if not var_22_0 then
		return nil
	end

	if var_22_0.awarded ~= nil then
		return var_22_0.awarded
	end

	return var_22_0[1].awarded
end

function EndViewStateSummary._setup_essence_presentation(arg_23_0)
	local var_23_0 = arg_23_0:_get_essence_earned()
	local var_23_1 = Managers.unlock:is_dlc_unlocked("scorpion") and var_23_0 ~= nil
	local var_23_2 = arg_23_0._widgets_by_name
	local var_23_3 = true

	if var_23_0 then
		local var_23_4 = Managers.backend:get_interface("weaves")
		local var_23_5 = var_23_4:get_essence()
		local var_23_6 = var_23_4:get_total_essence()
		local var_23_7 = var_23_4:get_maximum_essence()

		if var_23_7 < var_23_6 and var_23_7 > var_23_6 - var_23_0 then
			var_23_0 = var_23_0 - (var_23_7 - var_23_6)
		elseif var_23_7 < var_23_6 - var_23_0 then
			var_23_0 = nil
			var_23_3 = false
		end

		if var_23_0 then
			local var_23_8 = var_23_2.essence_total_text

			var_23_8.content.text = var_23_0

			local var_23_9 = UIUtils.get_text_width(arg_23_0.ui_renderer, var_23_8.style.text, tostring(var_23_0))

			var_23_2.icon_essence.offset[1] = -var_23_9
		end
	end

	var_23_2.essence_background.content.visible = var_23_1
	var_23_2.essence_background_frame.content.visible = var_23_1
	var_23_2.essence_background_shadow.content.visible = var_23_1
	var_23_2.essence_background_effect_left.content.visible = var_23_1
	var_23_2.essence_background_effect_right.content.visible = var_23_1
	var_23_2.total_essence_title.content.visible = var_23_1
	var_23_2.icon_essence.content.visible = var_23_3 and var_23_1 or false
	var_23_2.essence_total_text.content.visible = var_23_0 ~= nil and var_23_1 or false
	var_23_2.essence_total_text_max.content.visible = var_23_1 and not var_23_3
end

function EndViewStateSummary._get_total_experience_progress_data(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0, var_24_1 = ExperienceSettings.get_level(arg_24_1)
	local var_24_2, var_24_3 = ExperienceSettings.get_extra_level(arg_24_2)
	local var_24_4 = arg_24_0._hero_name
	local var_24_5 = ExperienceSettings.get_experience(var_24_4)
	local var_24_6, var_24_7 = ExperienceSettings.get_level(var_24_5)
	local var_24_8 = ExperienceSettings.get_experience_pool(var_24_4)
	local var_24_9, var_24_10 = ExperienceSettings.get_extra_level(var_24_8)
	local var_24_11 = var_24_0 + var_24_2
	local var_24_12 = var_24_6 + var_24_9
	local var_24_13 = 0

	if var_24_0 ~= ExperienceSettings.max_level and var_24_6 == ExperienceSettings.max_level then
		var_24_7 = var_24_3
		var_24_13 = ExperienceSettings.get_experience_required_for_level(ExperienceSettings.max_level) * var_24_3
	end

	local var_24_14 = var_24_12 - var_24_11 + (var_24_7 - var_24_1) + (var_24_10 - var_24_3)
	local var_24_15 = var_24_5 - arg_24_1 + (var_24_8 - arg_24_2) + var_24_13

	if var_24_0 == ExperienceSettings.max_level then
		arg_24_1 = arg_24_1 + arg_24_2
		var_24_1 = var_24_3
	end

	local var_24_16 = UISettings.summary_screen.bar_progress_min_time
	local var_24_17 = UISettings.summary_screen.bar_progress_max_time
	local var_24_18 = UISettings.summary_screen.bar_progress_experience_time_multiplier
	local var_24_19 = math.min(math.max(var_24_18 * var_24_15, var_24_16), var_24_17)

	return {
		time = 0,
		complete = false,
		current_experience = arg_24_1,
		experience_to_add = var_24_15,
		total_progress = var_24_14,
		start_progress = var_24_1,
		start_extra_level = var_24_2,
		bonus_experience = var_24_13,
		total_time = var_24_19
	}
end

function EndViewStateSummary._animate_experience_bar(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._progress_data

	if not var_25_0 or var_25_0.complete or arg_25_2 or arg_25_0.level_up_anim_id or arg_25_0._experience_presentation_completed then
		return
	end

	if not arg_25_0._experience_bar_started then
		arg_25_0:_play_sound("play_gui_mission_summary_experience_bar_begin")

		arg_25_0._experience_bar_started = true
	end

	local var_25_1 = var_25_0.time
	local var_25_2 = var_25_0.total_time
	local var_25_3 = var_25_1 / var_25_2
	local var_25_4 = math.smoothstep(var_25_3, 0, 1)
	local var_25_5 = math.min(var_25_1 + arg_25_1, var_25_2)

	var_25_0.time = var_25_5

	local var_25_6 = var_25_0.current_experience
	local var_25_7 = var_25_0.experience_to_add
	local var_25_8 = math.floor(var_25_7 * var_25_4)
	local var_25_9 = math.floor(var_25_6 + var_25_8)
	local var_25_10, var_25_11 = arg_25_0:_set_current_experience(var_25_9)
	local var_25_12 = var_25_10 ~= arg_25_0._current_level

	if arg_25_0._extra_levels ~= nil then
		if arg_25_0._progress_data.bonus_experience > 0 then
			var_25_11 = var_25_11 + arg_25_0._progress_data.start_extra_level
		end

		var_25_12 = var_25_12 or var_25_11 ~= arg_25_0._extra_levels
	end

	if var_25_12 then
		arg_25_0._current_level = var_25_10
		arg_25_0._extra_levels = var_25_11

		arg_25_0:_play_sound("play_gui_mission_summary_experience_bar_end")

		arg_25_0.level_up_anim_id = arg_25_0.ui_animator:start_animation("level_up", arg_25_0._widgets_by_name, arg_25_0._scenegraph_definition, {
			wwise_world = arg_25_0.wwise_world
		})
	end

	if var_25_5 == var_25_2 then
		var_25_0.complete = true
		arg_25_0._experience_presentation_completed = true

		arg_25_0:_play_sound("play_gui_mission_summary_experience_bar_end")
		arg_25_0.parent:present_additional_rewards()
	end
end

function EndViewStateSummary._set_current_experience(arg_26_0, arg_26_1)
	local var_26_0, var_26_1 = ExperienceSettings.get_level(arg_26_1)
	local var_26_2 = 0

	if var_26_0 == ExperienceSettings.max_level then
		local var_26_3 = arg_26_1 - ExperienceSettings.max_experience

		var_26_2, var_26_1 = ExperienceSettings.get_extra_level(var_26_3)
	end

	local var_26_4 = math.clamp(var_26_0 + 1, 0, ExperienceSettings.max_level)

	if arg_26_0._current_level and var_26_0 > arg_26_0._current_level or arg_26_0._extra_levels and var_26_2 > arg_26_0._extra_levels then
		var_26_1 = 1
	end

	local var_26_5 = arg_26_0._widgets_by_name
	local var_26_6 = var_26_5.experience_bar
	local var_26_7 = var_26_6.content
	local var_26_8 = var_26_6.style
	local var_26_9 = var_26_8.experience_bar.default_size

	var_26_8.experience_bar.size[1] = var_26_9[1] * var_26_1
	var_26_8.experience_bar_end.offset[1] = var_26_9[1] * var_26_1

	if var_26_1 == 1 and var_26_0 ~= var_26_4 then
		var_26_5.current_level_text.content.text = tostring(var_26_0 - 1)
		var_26_5.next_level_text.content.text = tostring(var_26_4 - 1)
	else
		var_26_5.current_level_text.content.text = tostring(var_26_0)
		var_26_5.next_level_text.content.text = tostring(var_26_4)
	end

	WwiseWorld.set_global_parameter(arg_26_0.wwise_world, "summary_meter_progress", var_26_1)

	return var_26_0, var_26_2
end

function EndViewStateSummary.done(arg_27_0)
	return arg_27_0._experience_presentation_completed and arg_27_0._summary_entries.complete
end

function EndViewStateSummary._play_sound(arg_28_0, arg_28_1)
	arg_28_0.parent:play_sound(arg_28_1)
end

function EndViewStateSummary._set_player_count_presence(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.players_session_score
	local var_29_1 = 0

	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		local var_29_2 = iter_29_1.peer_id
		local var_29_3 = iter_29_1.is_player_controlled

		if var_29_2 and var_29_3 then
			var_29_1 = var_29_1 + 1
		end
	end

	Presence.set_presence("steam_player_group_size", var_29_1)
end
