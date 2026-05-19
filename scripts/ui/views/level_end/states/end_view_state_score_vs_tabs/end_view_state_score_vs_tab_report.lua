-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report_definitions")

EndViewStateScoreVSTabReport = class(EndViewStateScoreVSTabReport)
EndViewStateScoreVSTabReport.NAME = "EndViewStateScoreVSTabReport"

local var_0_1 = 5
local var_0_2 = var_0_0.scenegraph_definition.hero_progress_item_anchor.size
local var_0_3 = 10

function EndViewStateScoreVSTabReport.on_enter(arg_1_0, arg_1_1)
	print("[EndViewStateVS] Enter Substate EndViewStateScoreVSTabReport")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.context

	arg_1_0._context = var_1_0
	arg_1_0._wwise_world = var_1_0.wwise_world
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._progression_presentation_done = arg_1_0._context.progression_presentation_done
	arg_1_0._is_untrusted = script_data["eac-untrusted"]
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._animation_callbacks = {}
	arg_1_0._challenge_entry_widgets = {}
	arg_1_0._level_up_item_index = 1

	arg_1_0:_extract_rewards()
	arg_1_0:_extract_hero_data()
	arg_1_0:_create_ui_elements(arg_1_0._params)

	arg_1_0._reward_popup = RewardPopupUI:new(var_1_0)

	if arg_1_0._progression_presentation_done then
		arg_1_0:_show_final_progression()
	else
		arg_1_0:_initialize_entries()
		arg_1_0:_start_transition_animation("on_enter", "on_enter")
	end

	arg_1_0._parent:hide_team()
	arg_1_0:_trigger_telemetry_events()
end

function EndViewStateScoreVSTabReport._show_final_progression(arg_2_0)
	arg_2_0:_initialize_entries()
	arg_2_0:_gather_challenge_progression()
	arg_2_0:_set_hero_progression()
	arg_2_0:_start_transition_animation("on_enter_forced", "on_enter_forced")
	arg_2_0:_start_transition_animation("animate_hero_progress", "animate_hero_progress_forced")
	arg_2_0._parent:activate_back_to_keep_button()
end

function EndViewStateScoreVSTabReport._set_hero_progression(arg_3_0)
	local var_3_0 = arg_3_0._context.local_player_hero_name
	local var_3_1 = ExperienceSettings.get_experience(var_3_0)
	local var_3_2 = ExperienceSettings.get_experience_pool(var_3_0)

	arg_3_0._current_level = arg_3_0:_set_current_experience(var_3_1 + var_3_2)
	arg_3_0._widgets_by_name.portrait.content.level = arg_3_0._current_level

	local var_3_3 = arg_3_0._level_start[1]
	local var_3_4 = arg_3_0._current_level + arg_3_0._extra_levels
	local var_3_5 = var_3_4 + table.size(arg_3_0._level_up_rewards)

	for iter_3_0 = var_3_4, var_3_5 do
		local var_3_6 = arg_3_0._level_up_rewards[iter_3_0]

		if var_3_6 then
			arg_3_0:_handle_rewards(var_3_6)
		end
	end
end

function EndViewStateScoreVSTabReport._extract_hero_data(arg_4_0)
	local var_4_0 = Network.peer_id()
	local var_4_1 = 1
	local var_4_2 = var_4_0 .. ":" .. var_4_1
	local var_4_3 = arg_4_0._player_session_scores[var_4_2]

	arg_4_0._profile_index = var_4_3.profile_index
	arg_4_0._career_index = var_4_3.career_index

	local var_4_4 = SPProfiles[arg_4_0._profile_index]

	arg_4_0._hero_name = Localize(var_4_4.character_name)

	local var_4_5 = var_4_4.careers[arg_4_0._career_index]

	arg_4_0._career_name = Localize(var_4_5.name)
end

function EndViewStateScoreVSTabReport._extract_rewards(arg_5_0)
	arg_5_0._game_won = arg_5_0._context.game_won
	arg_5_0._rewards = arg_5_0._context.rewards
	arg_5_0._level_up_rewards = arg_5_0._params.parent.level_up_rewards
	arg_5_0._versus_level_up_rewards = arg_5_0._params.parent.versus_level_up_rewards
	arg_5_0._level_start = arg_5_0._rewards.level_start
	arg_5_0._versus_level_start = arg_5_0._rewards.versus_level_start
	arg_5_0._mission_results = arg_5_0._rewards.mission_results
	arg_5_0._player_session_scores = arg_5_0._context.players_session_score
	arg_5_0._challenge_progression_status = arg_5_0._context.challenge_progression_status
end

function EndViewStateScoreVSTabReport._trigger_telemetry_events(arg_6_0)
	if arg_6_0._is_untrusted then
		return
	end

	local var_6_0 = arg_6_0._versus_level_start[1]
	local var_6_1 = arg_6_0._versus_level_start[2]

	Managers.telemetry_events:start_versus_experience(var_6_0, var_6_1)

	local var_6_2 = ExperienceSettings.get_versus_experience()

	Managers.telemetry_events:versus_experience_gained(var_6_2 - var_6_1)

	local var_6_3, var_6_4, var_6_5 = ExperienceSettings.get_versus_level_from_experience(var_6_1 + arg_6_0._total_experience_gained)

	Managers.telemetry_events:versus_level_gained(var_6_0, var_6_3)

	local var_6_6 = 0

	for iter_6_0, iter_6_1 in pairs(arg_6_0._versus_level_up_rewards) do
		for iter_6_2, iter_6_3 in pairs(iter_6_1) do
			if iter_6_3.currency == "VS" then
				var_6_6 = var_6_6 + iter_6_3.awarded
			end
		end
	end

	Managers.telemetry_events:versus_currency_gained(var_6_6)
end

function EndViewStateScoreVSTabReport._setup_hero_progression(arg_7_0)
	local var_7_0 = arg_7_0._level_start
	local var_7_1 = var_7_0[1]
	local var_7_2 = var_7_0[2]
	local var_7_3 = var_7_0[3]

	arg_7_0._progress_data = arg_7_0:_get_total_experience_progress_data(var_7_2, var_7_3)

	if arg_7_0._progress_data.bonus_experience > 0 then
		arg_7_0._extra_levels = arg_7_0._extra_levels + arg_7_0._progress_data.start_extra_level
	end

	arg_7_0._experience_presentation_completed = arg_7_0._progression_presentation_done
end

function EndViewStateScoreVSTabReport._get_total_experience_progress_data(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0, var_8_1 = ExperienceSettings.get_level(arg_8_1)
	local var_8_2, var_8_3 = ExperienceSettings.get_extra_level(arg_8_2)
	local var_8_4 = arg_8_0._context.local_player_hero_name
	local var_8_5 = ExperienceSettings.get_experience(var_8_4)
	local var_8_6, var_8_7 = ExperienceSettings.get_level(var_8_5)
	local var_8_8 = ExperienceSettings.get_experience_pool(var_8_4)
	local var_8_9, var_8_10 = ExperienceSettings.get_extra_level(var_8_8)
	local var_8_11 = var_8_0 + var_8_2
	local var_8_12 = var_8_6 + var_8_9
	local var_8_13 = 0

	if var_8_0 ~= ExperienceSettings.max_level and var_8_6 == ExperienceSettings.max_level then
		var_8_7 = var_8_3
		var_8_13 = ExperienceSettings.get_experience_required_for_level(ExperienceSettings.max_level) * var_8_3
	end

	local var_8_14 = var_8_12 - var_8_11 + (var_8_7 - var_8_1) + (var_8_10 - var_8_3)
	local var_8_15 = var_8_5 - arg_8_1 + (var_8_8 - arg_8_2) + var_8_13

	if var_8_0 == ExperienceSettings.max_level then
		arg_8_1 = arg_8_1 + arg_8_2
		var_8_1 = var_8_3
	end

	local var_8_16 = UISettings.summary_screen.bar_progress_min_time
	local var_8_17 = UISettings.summary_screen.bar_progress_max_time
	local var_8_18 = UISettings.summary_screen.bar_progress_experience_time_multiplier
	local var_8_19 = math.min(math.max(var_8_18 * var_8_15, var_8_16), var_8_17)

	return {
		time = 0,
		complete = false,
		current_experience = arg_8_1,
		experience_to_add = var_8_15,
		total_progress = var_8_14,
		start_progress = var_8_1,
		start_extra_level = var_8_2,
		bonus_experience = var_8_13,
		total_time = var_8_19
	}
end

function EndViewStateScoreVSTabReport._play_sound(arg_9_0, arg_9_1)
	arg_9_0._parent:play_sound(arg_9_1)
end

function EndViewStateScoreVSTabReport._set_global_wwise_parameter(arg_10_0, arg_10_1, arg_10_2)
	WwiseWorld.set_global_parameter(arg_10_0._wwise_world, arg_10_1, arg_10_2)
end

function EndViewStateScoreVSTabReport._initialize_entries(arg_11_0)
	arg_11_0:_create_summary_entries(arg_11_0._game_won)
	arg_11_0:_populate_hero_progression()
end

function EndViewStateScoreVSTabReport._populate_hero_progression(arg_12_0)
	local var_12_0 = Network.peer_id()
	local var_12_1 = 1
	local var_12_2 = var_12_0 .. ":" .. var_12_1
	local var_12_3 = arg_12_0._player_session_scores[var_12_2]
	local var_12_4 = var_12_3.profile_index
	local var_12_5 = var_12_3.career_index
	local var_12_6 = "portrait"
	local var_12_7 = var_12_3.portrait_frame
	local var_12_8 = arg_12_0._level_start
	local var_12_9 = var_12_8[1]
	local var_12_10 = var_12_8[2]
	local var_12_11 = var_12_8[3]
	local var_12_12 = ExperienceSettings.get_level(var_12_10)
	local var_12_13 = var_12_10 + var_12_11

	if var_12_12 < ExperienceSettings.max_level then
		var_12_13 = var_12_10
	end

	arg_12_0._widgets_by_name.experience_gained_text.content.text = string.format(var_0_0.summary_value_string, arg_12_0._total_experience_gained)
	arg_12_0._current_level, arg_12_0._extra_levels = arg_12_0:_set_current_experience(var_12_13)

	local var_12_14 = tostring(arg_12_0._current_level)
	local var_12_15 = 1
	local var_12_16 = false
	local var_12_17 = var_12_5 and UIUtils.get_portrait_image_by_profile_index(var_12_4, var_12_5) or "unit_frame_portrait_default"
	local var_12_18 = UIWidgets.create_portrait_frame(var_12_6, var_12_7, var_12_14, var_12_15, var_12_16, var_12_17)
	local var_12_19 = UIWidget.init(var_12_18)

	arg_12_0._widgets_by_name.portrait = var_12_19
	arg_12_0._hero_progress_widgets[#arg_12_0._hero_progress_widgets + 1] = var_12_19

	local var_12_20 = SPProfiles[var_12_4]
	local var_12_21 = Localize(var_12_20.character_name)
	local var_12_22 = var_12_20.careers[var_12_5]
	local var_12_23 = Localize(var_12_22.name)

	arg_12_0._widgets_by_name.hero_name.content.text = var_12_21
	arg_12_0._widgets_by_name.career_name.content.text = var_12_23
end

function EndViewStateScoreVSTabReport._animate_experience_bar(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._progress_data

	if not var_13_0 or var_13_0.complete or arg_13_2 or arg_13_0.level_up_anim_id or arg_13_0._experience_presentation_completed then
		return
	end

	if not arg_13_0._playing_experience_bar_sound then
		arg_13_0:_play_sound("Play_vs_hud_progression_hero_counter_loop")

		arg_13_0._playing_experience_bar_sound = true
	end

	local var_13_1 = var_13_0.time
	local var_13_2 = var_13_0.total_time
	local var_13_3 = var_13_1 / var_13_2
	local var_13_4 = math.smoothstep(var_13_3, 0, 1)
	local var_13_5 = math.min(var_13_1 + arg_13_1, var_13_2)

	var_13_0.time = var_13_5

	arg_13_0:_set_global_wwise_parameter("summary_meter_progress", var_13_5 / var_13_2)

	local var_13_6 = var_13_0.current_experience
	local var_13_7 = var_13_0.experience_to_add
	local var_13_8 = math.floor(var_13_7 * var_13_4)
	local var_13_9 = math.floor(var_13_6 + var_13_8)
	local var_13_10, var_13_11 = arg_13_0:_set_current_experience(var_13_9)
	local var_13_12 = var_13_10 ~= arg_13_0._current_level

	if arg_13_0._extra_levels ~= nil then
		if arg_13_0._progress_data.bonus_experience > 0 then
			var_13_11 = var_13_11 + arg_13_0._progress_data.start_extra_level
		end

		var_13_12 = var_13_12 or var_13_11 ~= arg_13_0._extra_levels
	end

	if var_13_12 then
		arg_13_0._current_level = var_13_10
		arg_13_0._extra_levels = var_13_11
		arg_13_0._level_up_anim_id = arg_13_0._ui_animator:start_animation("level_up", arg_13_0._widgets_by_name, var_0_0.scenegraph_definition, {
			wwise_world = arg_13_0.wwise_world
		})
		arg_13_0._widgets_by_name.portrait.content.level = arg_13_0._current_level

		local var_13_13 = arg_13_0._current_level + arg_13_0._extra_levels
		local var_13_14 = arg_13_0._level_up_rewards[var_13_13]

		if var_13_14 then
			arg_13_0:_handle_rewards(var_13_14)
		end

		arg_13_0._playing_experience_bar_sound = false

		arg_13_0:_play_sound("Stop_vs_hud_progression_hero_counter_loop")
	end

	if var_13_5 == var_13_2 then
		var_13_0.complete = true
		arg_13_0._experience_presentation_completed = true

		arg_13_0:_play_sound("Stop_vs_hud_progression_hero_counter_loop")
		arg_13_0:_gather_challenge_progression()
	end
end

function EndViewStateScoreVSTabReport._gather_challenge_progression(arg_14_0)
	local var_14_0 = {}
	local var_14_1 = arg_14_0._challenge_progression_status.start_progress
	local var_14_2 = arg_14_0._challenge_progression_status.end_progress
	local var_14_3 = 0
	local var_14_4 = {}

	for iter_14_0, iter_14_1 in pairs(var_14_1) do
		local var_14_5 = var_14_2[iter_14_0]

		if iter_14_1 ~= var_14_5 then
			var_14_0[#var_14_0 + 1] = {
				id = iter_14_0,
				start_progress = iter_14_1,
				end_progress = var_14_5
			}
			var_14_3 = var_14_3 + (var_14_5 >= 1 and 1 or 0)
		end
	end

	local function var_14_6(arg_15_0, arg_15_1)
		return arg_15_0.end_progress > arg_15_1.end_progress
	end

	table.sort(var_14_0, var_14_6)
	arg_14_0:_trim_trailing_group_entries(var_14_0)

	local var_14_7 = arg_14_0._widgets_by_name.challenge_progress_text

	if var_14_3 > 0 then
		var_14_7.content.text = string.format(var_0_0.challenge_progress_text_string, var_14_3)
	else
		var_14_7.content.text = Localize("achv_menu_achievements_category_title")
	end

	arg_14_0:_start_transition_animation("animate_challenge_progress", "animate_challenge_progress")

	if arg_14_0._progression_presentation_done then
		arg_14_0:_setup_challenge_progression_widgets(var_14_0)
	else
		arg_14_0._animation_callbacks.animate_challenge_progress = callback(arg_14_0, "_setup_challenge_progression_widgets", var_14_0)
	end
end

local var_0_4 = {}

function EndViewStateScoreVSTabReport._trim_trailing_group_entries(arg_16_0, arg_16_1)
	table.clear(var_0_4)

	local var_16_0 = {}

	for iter_16_0 = 1, #arg_16_1 do
		local var_16_1 = arg_16_1[iter_16_0]
		local var_16_2 = var_16_1.id
		local var_16_3 = AchievementTemplates.achievements[var_16_2].group

		if var_16_3 then
			if not var_16_0[var_16_3] then
				var_16_0[var_16_3] = var_16_1.end_progress < 1
			else
				var_0_4[#var_0_4 + 1] = iter_16_0
			end
		end
	end

	for iter_16_1 = #var_0_4, 1, -1 do
		table.remove(arg_16_1, var_0_4[iter_16_1])
	end
end

function EndViewStateScoreVSTabReport._setup_challenge_progression_widgets(arg_17_0, arg_17_1)
	local var_17_0 = 25
	local var_17_1

	for iter_17_0 = 1, #arg_17_1 do
		local var_17_2 = arg_17_1[iter_17_0]
		local var_17_3 = iter_17_0 - 1
		local var_17_4 = {
			var_17_3 % 2 * 400,
			-math.floor(var_17_3 / 2) * (var_0_0.scenegraph_definition.challenge_entry_anchor.size[2] + var_17_0),
			0
		}
		local var_17_5 = var_0_0.create_challenge_entry_func(var_17_2.id, var_17_2.start_progress, var_17_2.end_progress, var_17_4, arg_17_0._progression_presentation_done)
		local var_17_6 = UIWidget.init(var_17_5)

		arg_17_0._challenge_entry_widgets[#arg_17_0._challenge_entry_widgets + 1] = var_17_6

		local var_17_7 = "achievement_entry_" .. #arg_17_0._challenge_entry_widgets

		arg_17_0._widgets_by_name[var_17_7] = var_17_6

		arg_17_0:_start_challenge_entry_animation(iter_17_0, var_17_7)
	end

	local var_17_8 = math.ceil(#arg_17_1 / 2) * (var_0_0.scenegraph_definition.challenge_entry_anchor.size[2] + var_17_0) - var_0_0.scenegraph_definition.challenge_progress_anchor.size[2]

	if var_17_8 > 0 then
		local var_17_9 = arg_17_0._ui_scenegraph
		local var_17_10 = "challenge_entry_anchor"
		local var_17_11 = "challenge_progress_area"
		local var_17_12 = false
		local var_17_13
		local var_17_14

		arg_17_0._scrollbar_ui = ScrollbarUI:new(var_17_9, var_17_10, var_17_11, var_17_8, var_17_12, var_17_13, var_17_14)
	end

	arg_17_0._parent:activate_back_to_keep_button()
end

function EndViewStateScoreVSTabReport._start_challenge_entry_animation(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_0._progression_presentation_done then
		return
	end

	arg_18_0:_play_sound("Play_vs_hud_progression_challenge_appear")

	local var_18_0 = "wait_" .. arg_18_1 - 1

	if not table.is_empty(arg_18_0._animations) and not arg_18_3 then
		arg_18_0._animation_callbacks[var_18_0] = callback(arg_18_0, "_start_challenge_entry_animation", arg_18_1, arg_18_2, true)
	else
		local var_18_1 = {
			entry_name = arg_18_2
		}
		local var_18_2 = "animate_challenge_entry_" .. arg_18_1
		local var_18_3 = "wait_" .. arg_18_1

		arg_18_0:_start_transition_animation(var_18_2, "animate_challenge_entry", var_18_1)
		arg_18_0:_start_transition_animation(var_18_3, "wait")
	end
end

function EndViewStateScoreVSTabReport._handle_rewards(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._level_up_item_index
	local var_19_1 = Managers.backend:get_interface("items")

	for iter_19_0, iter_19_1 in ipairs(arg_19_1) do
		local var_19_2 = iter_19_1.backend_id
		local var_19_3 = var_19_1:get_item_from_id(var_19_2)
		local var_19_4 = var_19_0 - 1
		local var_19_5 = var_19_4 % var_0_1
		local var_19_6 = math.floor(var_19_4 / var_0_1)
		local var_19_7 = var_19_5 * var_0_2[1] + (var_19_5 - 1) * var_0_3
		local var_19_8 = -var_19_6 * var_0_2[2] - (var_19_6 - 1) * var_0_3
		local var_19_9 = {
			var_19_7,
			var_19_8,
			0
		}
		local var_19_10 = var_0_0.create_item_widget_func(var_19_3, var_19_9, arg_19_0._progression_presentation_done)
		local var_19_11 = UIWidget.init(var_19_10)

		arg_19_0._widgets[#arg_19_0._widgets + 1] = var_19_11
		arg_19_0._widgets_by_name["rewards_" .. var_19_0] = var_19_11

		if not arg_19_0._progression_presentation_done then
			local var_19_12 = {
				widget = var_19_11,
				offset = table.clone(var_19_9),
				sound = (var_19_3.key == "level_chest" or var_19_3.key == "level_chest_lesser") and "Play_vs_hud_progression_hero_chest_appear" or "Play_vs_hud_progression_hero_item_appear"
			}

			if iter_19_0 > 1 then
				arg_19_0._animation_callbacks["animate_item_" .. var_19_0 - 1] = callback(arg_19_0, "_start_transition_animation", "animate_item_" .. var_19_0, "animate_item", var_19_12)
			else
				arg_19_0:_start_transition_animation("animate_item_" .. var_19_0, "animate_item", var_19_12)
			end
		end

		var_19_0 = var_19_0 + 1
	end

	if not arg_19_0._progression_presentation_done then
		arg_19_0:_play_sound("Play_vs_hud_progression_hero_level_up")
	end

	arg_19_0._level_up_item_index = var_19_0
end

function EndViewStateScoreVSTabReport._set_current_experience(arg_20_0, arg_20_1)
	local var_20_0, var_20_1 = ExperienceSettings.get_level(arg_20_1)
	local var_20_2 = 0

	if var_20_0 == ExperienceSettings.max_level then
		local var_20_3 = arg_20_1 - ExperienceSettings.max_experience

		var_20_2, var_20_1 = ExperienceSettings.get_extra_level(var_20_3)
	end

	local var_20_4 = math.clamp(var_20_0 + 1, 0, ExperienceSettings.max_level)

	if not arg_20_0._progression_presentation_done and (arg_20_0._current_level and var_20_0 > arg_20_0._current_level or arg_20_0._extra_levels and var_20_2 > arg_20_0._extra_levels) then
		var_20_1 = 1
	end

	local var_20_5 = arg_20_0._widgets_by_name.experience_bar
	local var_20_6 = var_20_5.content
	local var_20_7 = var_20_5.style
	local var_20_8 = var_20_7.experience_bar.default_size

	var_20_7.experience_bar.size[1] = var_20_8[1] * var_20_1
	var_20_7.experience_bar_end.offset[1] = var_20_8[1] * var_20_1

	return var_20_0, var_20_2
end

function EndViewStateScoreVSTabReport._create_summary_entries(arg_21_0)
	local var_21_0 = arg_21_0._mission_results
	local var_21_1 = {}
	local var_21_2 = 0
	local var_21_3 = 0
	local var_21_4 = 1

	for iter_21_0, iter_21_1 in ipairs(var_21_0) do
		local var_21_5 = iter_21_1.experience and math.round(iter_21_1.experience)

		if var_21_5 and var_21_5 > 0 then
			local var_21_6 = "summary_entry_" .. var_21_4
			local var_21_7 = iter_21_1.text
			local var_21_8 = iter_21_1.format_values
			local var_21_9

			if var_21_7 then
				if var_21_8 then
					var_21_9 = UIUtils.format_localized_description(var_21_7, var_21_8)
				else
					var_21_9 = Localize(var_21_7)
				end
			end

			local var_21_10 = iter_21_1.value
			local var_21_11 = iter_21_1.bonus
			local var_21_12 = iter_21_1.icon
			local var_21_13 = var_21_5 and tostring(var_21_5) or var_21_10 and tostring(var_21_10) or ""
			local var_21_14 = var_21_9 .. (var_21_10 and " (" .. tostring(var_21_10) .. ")" or "")
			local var_21_15 = {
				name = var_21_6,
				title_text = var_21_14,
				experience = var_21_5,
				value = var_21_10,
				value_text = var_21_13,
				bonus = var_21_11,
				icon = var_21_12
			}

			var_21_1[#var_21_1 + 1] = var_21_15

			local var_21_16 = var_0_0.create_summery_entry_func(var_21_4, var_21_14, var_21_5, arg_21_0._progression_presentation_done)
			local var_21_17 = UIWidget.init(var_21_16)

			arg_21_0._widgets[#arg_21_0._widgets + 1] = var_21_17
			arg_21_0._widgets_by_name[var_21_6] = var_21_17
			var_21_3 = var_21_3 + var_21_5
			var_21_4 = var_21_4 + 1
		end
	end

	arg_21_0._total_experience_gained = var_21_3

	if arg_21_0._progression_presentation_done then
		arg_21_0:_set_final_level_up_progress(var_21_3)
	else
		arg_21_0:_setup_entry_animations(var_21_1, var_21_3)
	end
end

function EndViewStateScoreVSTabReport._set_final_level_up_progress(arg_22_0, arg_22_1)
	local var_22_0 = var_0_0.bar_thresholds
	local var_22_1 = arg_22_0._versus_level_start

	if table.is_empty(var_22_1) then
		var_22_1[1] = ExperienceSettings.get_versus_level()
		var_22_1[2] = ExperienceSettings.get_versus_experience()
	end

	local var_22_2 = var_22_1[1]
	local var_22_3 = var_22_1[2]
	local var_22_4, var_22_5 = ExperienceSettings.get_versus_level_from_experience(var_22_3)
	local var_22_6, var_22_7, var_22_8 = ExperienceSettings.get_versus_level_from_experience(var_22_3 + arg_22_1)
	local var_22_9 = var_22_6 - var_22_2
	local var_22_10 = arg_22_0._widgets_by_name.level_up.content

	if var_22_9 > 0 then
		var_22_10.starting_progress = 0
		var_22_10.final_progress = math.lerp(var_22_0[1], var_22_0[2], var_22_7)
	elseif var_22_2 == ExperienceSettings.max_versus_level then
		var_22_10.starting_progress = 1
		var_22_10.final_progress = 1
	else
		var_22_10.starting_progress = math.lerp(var_22_0[1], var_22_0[2], var_22_5)
		var_22_10.final_progress = math.lerp(var_22_0[1], var_22_0[2], var_22_7)
	end

	var_22_10.level_text = var_22_6

	local var_22_11 = arg_22_0._widgets_by_name.insignia
	local var_22_12, var_22_13 = UIAtlasHelper.get_insignia_texture_settings_from_level(var_22_6)

	var_22_11.content.insignia_main.uvs = var_22_12
	var_22_11.content.insignia_addon.uvs = var_22_13
	var_22_11.content.level = var_22_6
	arg_22_0._widgets_by_name.summary_value_text.content.text = string.format(var_0_0.summary_value_string, arg_22_1)
end

function EndViewStateScoreVSTabReport._setup_entry_animations(arg_23_0, arg_23_1, arg_23_2)
	if #arg_23_1 > 0 then
		local var_23_0 = {
			entry_name = "summary_entry_1"
		}

		arg_23_0:_start_transition_animation("animate_progression_entry_1", "animate_progression_entry", var_23_0)

		for iter_23_0 = 2, #arg_23_1 do
			local var_23_1 = {
				entry_name = "summary_entry_" .. iter_23_0
			}

			arg_23_0._animation_callbacks["animate_progression_entry_" .. iter_23_0 - 1] = callback(arg_23_0, "_start_transition_animation", "animate_progression_entry_" .. iter_23_0, "animate_progression_entry", var_23_1)
		end

		local var_23_2 = "animate_progression_entry_" .. #arg_23_1
		local var_23_3 = arg_23_0._versus_level_start

		if table.is_empty(var_23_3) then
			var_23_3[1] = ExperienceSettings.get_versus_level()
			var_23_3[2] = ExperienceSettings.get_versus_experience()
		end

		local var_23_4 = var_23_3[1]
		local var_23_5 = var_23_3[2]

		if var_23_4 ~= ExperienceSettings.max_versus_level then
			local var_23_6, var_23_7 = ExperienceSettings.get_versus_level_from_experience(var_23_5)
			local var_23_8, var_23_9 = ExperienceSettings.get_versus_level_from_experience(var_23_5 + arg_23_2)
			local var_23_10, var_23_11 = ExperienceSettings.get_versus_progress_breakdown(var_23_5, arg_23_2)
			local var_23_12 = var_23_8 - var_23_4
			local var_23_13 = 0
			local var_23_14

			for iter_23_1 = 0, var_23_12 do
				local var_23_15 = math.min(var_23_4 + (iter_23_1 + 1), ExperienceSettings.max_versus_level)
				local var_23_16 = "animate_level_up_" .. iter_23_1 + 1

				if iter_23_1 == 0 then
					if var_23_12 > 0 then
						local var_23_17 = {
							final_progress = 1,
							starting_progress = var_23_7,
							level = var_23_15,
							sound_parameter_values = {
								var_23_13,
								var_23_13 + var_23_10[var_23_11]
							}
						}

						if var_23_15 == ExperienceSettings.max_versus_level then
							var_23_17.on_complete_optional_starting_progress = 1
							var_23_17.on_complete_optional_final_progress = 1
						end

						arg_23_0._animation_callbacks[var_23_2] = callback(arg_23_0, "_start_transition_animation", var_23_16, "animate_level_up_start", var_23_17)
						var_23_14 = var_23_15
					else
						local var_23_18 = {
							starting_progress = var_23_7,
							final_progress = var_23_9,
							sound_parameter_values = {
								var_23_13,
								var_23_13 + var_23_10[var_23_11]
							}
						}

						arg_23_0._animation_callbacks[var_23_2] = callback(arg_23_0, "_start_transition_animation", var_23_16, "animate_level_up_start_end", var_23_18)
					end
				elseif iter_23_1 < var_23_12 then
					local var_23_19 = {
						final_progress = 1,
						starting_progress = 0,
						level = var_23_15,
						sound_parameter_values = {
							var_23_13,
							var_23_13 + var_23_10[var_23_11]
						}
					}
					local var_23_20 = callback(arg_23_0, "_start_transition_animation", var_23_16, "animate_level_up_linear", var_23_19)

					arg_23_0._animation_callbacks[var_23_2] = callback(arg_23_0, "_start_level_up_reward_presentation", var_23_14, var_23_20)
					var_23_14 = var_23_15
				elseif var_23_15 == ExperienceSettings.max_versus_level then
					local var_23_21 = {
						final_progress = 1,
						starting_progress = 1,
						level = ExperienceSettings.max_versus_level
					}
					local var_23_22 = callback(arg_23_0, "_start_transition_animation", var_23_16, "animate_level_up_instant", var_23_21)

					arg_23_0._animation_callbacks[var_23_2] = callback(arg_23_0, "_start_level_up_reward_presentation", var_23_14, var_23_22)
				else
					local var_23_23 = {
						starting_progress = 0,
						final_progress = var_23_9,
						level = var_23_15,
						sound_parameter_values = {
							var_23_13,
							var_23_13 + var_23_10[var_23_11]
						}
					}
					local var_23_24 = callback(arg_23_0, "_start_transition_animation", var_23_16, "animate_level_up_end", var_23_23)

					arg_23_0._animation_callbacks[var_23_2] = callback(arg_23_0, "_start_level_up_reward_presentation", var_23_14, var_23_24)
				end

				var_23_2 = var_23_16
				var_23_13 = var_23_13 + var_23_10[var_23_11]
				var_23_11 = var_23_11 + 1
			end

			arg_23_0._animation_callbacks[var_23_2] = callback(arg_23_0, "_start_transition_animation", "versus_level_up_pause", "versus_level_up_pause")
			var_23_2 = "versus_level_up_pause"
		end

		arg_23_0._animation_callbacks[var_23_2] = callback(arg_23_0, "_start_transition_animation", "animate_hero_progress", "animate_hero_progress")
		arg_23_0._animation_callbacks.animate_hero_progress = callback(arg_23_0, "_setup_hero_progression")
	else
		arg_23_0:_start_transition_animation("animate_hero_progress", "animate_hero_progress")

		arg_23_0._animation_callbacks.animate_hero_progress = callback(arg_23_0, "_setup_hero_progression")
	end
end

local var_0_5 = {}

function EndViewStateScoreVSTabReport._start_level_up_reward_presentation(arg_24_0, arg_24_1, arg_24_2)
	table.clear(var_0_5)

	local var_24_0 = arg_24_0._versus_level_up_rewards[arg_24_1]

	if not var_24_0 then
		arg_24_2()

		return
	end

	local var_24_1 = {}
	local var_24_2 = {
		Localize("summary_screen_rank_up"),
		Localize("versus_level_tag") .. " " .. arg_24_1
	}

	var_24_1[#var_24_1 + 1] = {
		widget_type = "description",
		value = var_24_2
	}

	local var_24_3 = {}
	local var_24_4 = Managers.backend:get_interface("items")

	for iter_24_0 = 1, #var_24_0 do
		local var_24_5 = var_24_0[iter_24_0]
		local var_24_6
		local var_24_7 = var_24_5.backend_id

		if var_24_7 then
			var_24_6 = var_24_4:get_item_from_id(var_24_7)
		else
			var_24_6 = {
				data = BackendUtils.get_fake_currency_item(var_24_5.currency or "SM", var_24_5.awarded)
			}
		end

		var_24_3[#var_24_3 + 1] = var_24_6
	end

	var_24_1[#var_24_1 + 1] = {
		widget_type = "item_list",
		value = var_24_3
	}
	var_0_5[#var_0_5 + 1] = var_24_1
	var_0_5.bg_alpha = 200
	var_0_5.offset = {
		0,
		0,
		1
	}

	arg_24_0._reward_popup:display_presentation(var_0_5, arg_24_2)
end

function EndViewStateScoreVSTabReport.on_exit(arg_25_0, arg_25_1)
	print("[EndViewStateVS] Exit Substate EndViewStateScoreVSTabReport")

	arg_25_0._ui_scenegraph = nil
	arg_25_0._widgets = nil
	arg_25_0._widgets_by_name = nil
	arg_25_0._ui_animator = nil
	arg_25_0._context.progression_presentation_done = true

	if arg_25_0._reward_popup then
		arg_25_0._reward_popup:destroy()

		arg_25_0._reward_popup = nil
	end
end

function EndViewStateScoreVSTabReport._create_ui_elements(arg_26_0, arg_26_1)
	local var_26_0 = var_0_0.widget_definitions
	local var_26_1 = var_0_0.challenge_widget_definitions
	local var_26_2 = var_0_0.hero_progress_widget_definitions
	local var_26_3 = var_0_0.summary_entry_widgets
	local var_26_4 = var_0_0.scenegraph_definition
	local var_26_5 = var_0_0.animation_definitions
	local var_26_6 = var_0_0.bar_thresholds

	UIRenderer.clear_scenegraph_queue(arg_26_0._ui_renderer)

	arg_26_0._scenegraph_definition = var_26_4
	arg_26_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_26_4)
	arg_26_0._widgets, arg_26_0._widgets_by_name = UIUtils.create_widgets(var_26_0, {}, {})
	arg_26_0._hero_progress_widgets, arg_26_0._widgets_by_name = UIUtils.create_widgets(var_26_2, {}, arg_26_0._widgets_by_name)
	arg_26_0._challenge_widgets, arg_26_0._widgets_by_name = UIUtils.create_widgets(var_26_1, {}, arg_26_0._widgets_by_name)
	arg_26_0._ui_animator = UIAnimator:new(arg_26_0._ui_scenegraph, var_26_5)

	local var_26_7 = arg_26_0._versus_level_start

	if table.is_empty(var_26_7) then
		var_26_7[1] = ExperienceSettings.get_versus_level()
		var_26_7[2] = ExperienceSettings.get_versus_experience()
	end

	local var_26_8 = var_26_7[1]
	local var_26_9 = var_26_7[2]
	local var_26_10, var_26_11 = ExperienceSettings.get_versus_level_from_experience(var_26_9)
	local var_26_12 = arg_26_0._widgets_by_name.level_up

	if var_26_8 == ExperienceSettings.max_versus_level then
		var_26_12.content.starting_progress = 1
		var_26_12.content.final_progress = 1
	else
		var_26_12.content.starting_progress = math.lerp(var_26_6[1], var_26_6[2], var_26_11)
		var_26_12.content.final_progress = math.lerp(var_26_6[1], var_26_6[2], var_26_11)
	end

	var_26_12.content.level_text = var_26_8

	local var_26_13 = arg_26_0._widgets_by_name.insignia
	local var_26_14, var_26_15 = UIAtlasHelper.get_insignia_texture_settings_from_level(var_26_8)

	var_26_13.content.insignia_main.uvs = var_26_14
	var_26_13.content.insignia_addon.uvs = var_26_15
	var_26_13.content.level = var_26_8
end

function EndViewStateScoreVSTabReport._get_definitions(arg_27_0)
	return local_require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report_definitions")
end

function EndViewStateScoreVSTabReport.update(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0:_draw(arg_28_1, arg_28_2)
	arg_28_0:_update_animations(arg_28_1, arg_28_2)
	arg_28_0:_handle_reward_popup(arg_28_1, arg_28_2)
end

function EndViewStateScoreVSTabReport._handle_reward_popup(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0._reward_popup:update(arg_29_1, arg_29_2)
end

function EndViewStateScoreVSTabReport.post_update(arg_30_0, arg_30_1, arg_30_2)
	return
end

function EndViewStateScoreVSTabReport._handle_input(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_0._input_manager:get_service("end_of_level"):get("confirm_hold") then
		return arg_31_1 * 5
	end

	return arg_31_1
end

function EndViewStateScoreVSTabReport._update_animations(arg_32_0, arg_32_1)
	arg_32_0._ui_animator:update(arg_32_1)

	for iter_32_0, iter_32_1 in pairs(arg_32_0._ui_animations) do
		UIAnimation.update(iter_32_1, arg_32_1)

		if UIAnimation.completed(iter_32_1) then
			arg_32_0._ui_animations[iter_32_0] = nil
		end
	end

	local var_32_0 = arg_32_0._animations
	local var_32_1 = arg_32_0._ui_animator

	for iter_32_2, iter_32_3 in pairs(var_32_0) do
		if var_32_1:is_animation_completed(iter_32_3) then
			var_32_1:stop_animation(iter_32_3)

			var_32_0[iter_32_2] = nil

			local var_32_2 = arg_32_0._animation_callbacks[iter_32_2]

			arg_32_0._animation_callbacks[iter_32_2] = nil

			if var_32_2 then
				var_32_2()
			end
		end
	end

	if table.is_empty(arg_32_0._animations) then
		arg_32_0:_animate_experience_bar(arg_32_1)
	end
end

function EndViewStateScoreVSTabReport._draw(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = arg_33_0._input_manager:get_service("end_of_level")
	local var_33_1 = arg_33_0._ui_top_renderer
	local var_33_2 = arg_33_0._ui_scenegraph
	local var_33_3 = arg_33_0._render_settings

	UIRenderer.begin_pass(var_33_1, var_33_2, var_33_0, arg_33_2, nil, var_33_3)

	for iter_33_0, iter_33_1 in ipairs(arg_33_0._widgets) do
		UIRenderer.draw_widget(var_33_1, iter_33_1)
	end

	local var_33_4 = var_33_3.alpha_multiplier

	var_33_3.alpha_multiplier = var_33_3.hero_progress_alpha_multiplier or 0

	for iter_33_2, iter_33_3 in ipairs(arg_33_0._hero_progress_widgets) do
		UIRenderer.draw_widget(var_33_1, iter_33_3)
	end

	var_33_3.alpha_multiplier = var_33_4

	local var_33_5 = var_33_3.alpha_multiplier

	var_33_3.alpha_multiplier = var_33_3.challenge_alpha_multiplier or 0

	for iter_33_4, iter_33_5 in ipairs(arg_33_0._challenge_widgets) do
		UIRenderer.draw_widget(var_33_1, iter_33_5)
	end

	var_33_3.alpha_multiplier = var_33_5

	local var_33_6 = arg_33_0._ui_scenegraph.challenge_entry_anchor.local_position[2]
	local var_33_7 = arg_33_0._ui_scenegraph.challenge_entry_anchor.size[2]
	local var_33_8 = arg_33_0._ui_scenegraph.challenge_progress_area.size[2]
	local var_33_9 = var_33_3.alpha_multiplier

	for iter_33_6, iter_33_7 in ipairs(arg_33_0._challenge_entry_widgets) do
		var_33_3.alpha_multiplier = iter_33_7.content.alpha_multiplier

		local var_33_10 = iter_33_7.offset[2] + var_33_6

		if var_33_10 < -var_33_8 then
			break
		elseif var_33_10 - var_33_7 < 0 then
			UIRenderer.draw_widget(var_33_1, iter_33_7)
		end
	end

	var_33_3.alpha_multiplier = var_33_9

	UIRenderer.end_pass(var_33_1)

	if arg_33_0._scrollbar_ui then
		arg_33_0._scrollbar_ui:update(arg_33_2, arg_33_3, var_33_1, var_33_0, var_33_3)
	end
end

function EndViewStateScoreVSTabReport._start_transition_animation(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = {
		set_global_wwise_parameter = callback(arg_34_0, "_set_global_wwise_parameter"),
		play_sound = callback(arg_34_0, "_play_sound"),
		render_settings = arg_34_0._render_settings,
		data = arg_34_3
	}
	local var_34_1 = arg_34_0._widgets_by_name
	local var_34_2 = arg_34_0._ui_animator:start_animation(arg_34_2, var_34_1, arg_34_0._scenegraph_definition, var_34_0)

	arg_34_0._animations[arg_34_1] = var_34_2
end
