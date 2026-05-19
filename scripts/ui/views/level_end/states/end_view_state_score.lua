-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_score_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.player_score_size
local var_0_3 = var_0_0.hero_widgets
local var_0_4 = var_0_0.score_widgets
local var_0_5 = var_0_0.scenegraph_definition
local var_0_6 = var_0_0.animation_definitions
local var_0_7 = 16
local var_0_8 = false

EndViewStateScore = class(EndViewStateScore)
EndViewStateScore.NAME = "EndViewStateScore"

function EndViewStateScore.on_enter(arg_1_0, arg_1_1)
	print("[PlayState] Enter Substate EndViewStateScore")

	arg_1_0.parent = arg_1_1.parent
	arg_1_0.game_won = arg_1_1.game_won
	arg_1_0.game_mode_key = arg_1_1.game_mode_key

	local var_1_0 = arg_1_1.context

	arg_1_0._context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.rewards = var_1_0.rewards
	arg_1_0.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0.world_previewer = arg_1_1.world_previewer
	arg_1_0.platform = PLATFORM
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1)

	if arg_1_1.initial_state then
		arg_1_0._initial_preview = true
		arg_1_1.initial_state = nil
	end

	arg_1_0:_start_transition_animation("on_enter", "transition_enter")

	arg_1_0._exit_timer = nil

	local var_1_1 = arg_1_0._context.players_session_score

	arg_1_0:_setup_player_scores(var_1_1)
	arg_1_0:_setup_level_widget()
	arg_1_0:_play_sound("play_gui_mission_summary_team_summary_enter")
end

function EndViewStateScore.exit(arg_2_0, arg_2_1)
	arg_2_0._exit_started = true

	arg_2_0:_start_transition_animation("on_enter", "transition_exit")
end

function EndViewStateScore.exit_done(arg_3_0)
	return arg_3_0._exit_started and arg_3_0._animations.on_enter == nil
end

function EndViewStateScore.create_ui_elements(arg_4_0, arg_4_1)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_5)
	arg_4_0._widgets, arg_4_0._widgets_by_name = UIUtils.create_widgets(var_0_1)
	arg_4_0._hero_widgets = {
		UIWidget.init(var_0_3.player_frame_1),
		UIWidget.init(var_0_3.player_frame_2),
		UIWidget.init(var_0_3.player_frame_3),
		UIWidget.init(var_0_3.player_frame_4)
	}
	arg_4_0._score_widgets = {
		UIWidget.init(var_0_4.player_score_1),
		UIWidget.init(var_0_4.player_score_2),
		UIWidget.init(var_0_4.player_score_3),
		UIWidget.init(var_0_4.player_score_4)
	}

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_6)

	arg_4_0:_create_gamepad_elements()
end

function EndViewStateScore._create_gamepad_elements(arg_5_0)
	local var_5_0 = UIFrameSettings.frame_outer_glow_01
	local var_5_1 = "player_panel_1"
	local var_5_2 = arg_5_0.ui_scenegraph[var_5_1].size
	local var_5_3 = {
		-var_5_0.texture_sizes.vertical[1],
		-var_5_0.texture_sizes.horizontal[2],
		0
	}
	local var_5_4 = {
		var_5_2[1] + var_5_0.texture_sizes.vertical[1] * 2,
		var_5_2[2] + var_5_0.texture_sizes.horizontal[2] * 2
	}
	local var_5_5 = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = var_5_3,
		size = var_5_4
	}

	arg_5_0._gamepad_selection_screen = UIWidget.init(UIWidgets.create_simple_frame(var_5_0.texture, var_5_0.texture_size, var_5_0.texture_sizes.corner, var_5_0.texture_sizes.vertical, var_5_0.texture_sizes.horizontal, "player_panel_1", var_5_5))
	arg_5_0._current_gamepad_selection = 1
end

function EndViewStateScore._wanted_state(arg_6_0)
	return (arg_6_0.parent:wanted_menu_state())
end

function EndViewStateScore.set_input_manager(arg_7_0, arg_7_1)
	arg_7_0.input_manager = arg_7_1
end

function EndViewStateScore.on_exit(arg_8_0, arg_8_1)
	print("[PlayState] Exit Substate EndViewStateScore")

	arg_8_0.ui_animator = nil
end

function EndViewStateScore.done(arg_9_0)
	return false
end

function EndViewStateScore._update_transition_timer(arg_10_0, arg_10_1)
	if not arg_10_0._transition_timer then
		return
	end

	if arg_10_0._transition_timer == 0 then
		arg_10_0._transition_timer = nil
	else
		arg_10_0._transition_timer = math.max(arg_10_0._transition_timer - arg_10_1, 0)
	end
end

function EndViewStateScore.update(arg_11_0, arg_11_1, arg_11_2)
	if var_0_8 then
		var_0_8 = false

		arg_11_0:create_ui_elements()

		local var_11_0 = arg_11_0._context.players_session_score

		arg_11_0:_setup_player_scores(var_11_0)
	end

	local var_11_1 = arg_11_0.input_manager:get_service("end_of_level")

	arg_11_0:draw(var_11_1, arg_11_1)
	arg_11_0:_update_transition_timer(arg_11_1)

	local var_11_2 = arg_11_0:_wanted_state()

	if not arg_11_0._transition_timer and (var_11_2 or arg_11_0._new_state) then
		arg_11_0.parent:clear_wanted_menu_state()

		return var_11_2 or arg_11_0._new_state
	end

	arg_11_0:_update_entry_hover(arg_11_1)
	arg_11_0.ui_animator:update(arg_11_1)
	arg_11_0:_update_animations(arg_11_1)
	arg_11_0:_update_gamepad_input(arg_11_1, var_11_1)

	if not arg_11_0.parent:transitioning() and not arg_11_0._transition_timer then
		arg_11_0:_handle_input(arg_11_1, arg_11_2)
	end
end

function EndViewStateScore.post_update(arg_12_0, arg_12_1, arg_12_2)
	return
end

function EndViewStateScore._update_gamepad_input(arg_13_0, arg_13_1, arg_13_2)
	if not Managers.input:is_device_active("gamepad") or not arg_13_0.parent:input_enabled() then
		return
	end

	local var_13_0 = not Managers.account:offline_mode()
	local var_13_1 = arg_13_0._current_gamepad_selection
	local var_13_2 = arg_13_0._current_gamepad_selection

	if arg_13_2:get("move_left") then
		var_13_1 = math.max(var_13_1 - 1, 1)
	elseif arg_13_2:get("move_right") then
		var_13_1 = math.min(var_13_1 + 1, 4)
	elseif arg_13_2:get("confirm_press") then
		local var_13_3 = arg_13_0._players_by_widget_index[var_13_1]

		if var_13_3 and var_13_3.is_player_controlled and var_13_0 then
			arg_13_0:show_gamercard(var_13_3.peer_id)
		end
	end

	if var_13_1 ~= var_13_2 then
		arg_13_0._gamepad_selection_screen.scenegraph_id = "player_panel_" .. var_13_1
		arg_13_0._current_gamepad_selection = var_13_1

		local var_13_4 = arg_13_0._players_by_widget_index[var_13_1]

		if var_13_4 and var_13_4.is_player_controlled and var_13_0 then
			arg_13_0.parent:set_input_description("profile_available")
		else
			arg_13_0.parent:set_input_description(nil)
		end
	end
end

function EndViewStateScore.show_gamercard(arg_14_0, arg_14_1)
	if arg_14_1 then
		if IS_WINDOWS and rawget(_G, "Steam") then
			local var_14_0 = Steam.id_hex_to_dec(arg_14_1)
			local var_14_1 = "http://steamcommunity.com/profiles/" .. var_14_0

			Steam.open_url(var_14_1)
		elseif IS_XB1 then
			if arg_14_0._context.lobby and arg_14_0._context.lobby.lobby then
				local var_14_2 = arg_14_0._context.lobby:xuid(arg_14_1)

				if var_14_2 then
					Managers.account:show_player_profile(var_14_2)
				end
			end
		elseif IS_PS4 then
			Managers.account:show_player_profile_with_account_id(arg_14_1)
		end
	end
end

function EndViewStateScore._update_animations(arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(arg_15_0._ui_animations) do
		UIAnimation.update(iter_15_1, arg_15_1)

		if UIAnimation.completed(iter_15_1) then
			arg_15_0._ui_animations[iter_15_0] = nil
		end
	end

	local var_15_0 = arg_15_0._animations
	local var_15_1 = arg_15_0.ui_animator

	for iter_15_2, iter_15_3 in pairs(var_15_0) do
		if var_15_1:is_animation_completed(iter_15_3) then
			var_15_1:stop_animation(iter_15_3)

			var_15_0[iter_15_2] = nil
		end
	end
end

function EndViewStateScore._update_entry_hover(arg_16_0)
	local var_16_0
	local var_16_1 = arg_16_0._widgets_by_name.scores_topics.content
	local var_16_2 = var_16_1.num_rows

	for iter_16_0 = 1, var_16_2 do
		local var_16_3 = "_" .. iter_16_0
		local var_16_4 = var_16_1["hotspot" .. var_16_3]

		if var_16_4 and var_16_4.is_hover and var_16_1["row_bg" .. var_16_3].has_score then
			var_16_0 = iter_16_0

			break
		end
	end

	if var_16_0 ~= arg_16_0._current_topic_hover_index then
		arg_16_0:_set_entry_hover_index(var_16_0)

		arg_16_0._current_topic_hover_index = var_16_0
	end
end

function EndViewStateScore._set_entry_hover_index(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._widgets_by_name
	local var_17_1 = arg_17_0._score_widgets

	for iter_17_0, iter_17_1 in ipairs(var_17_1) do
		iter_17_1.content.hover_index = arg_17_1
	end

	var_17_0.scores_topics.content.hover_index = arg_17_1
end

function EndViewStateScore._handle_input(arg_18_0, arg_18_1, arg_18_2)
	if Development.parameter("tobii_button") then
		arg_18_0:_handle_tobii_button(arg_18_1)
	end
end

function EndViewStateScore._handle_tobii_button(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._widgets_by_name.tobii_button

	UIWidgetUtils.animate_default_button(var_19_0, arg_19_1)

	if arg_19_0:_is_button_hover_enter(var_19_0) then
		arg_19_0:_play_sound("play_gui_start_menu_button_hover")
	end

	if arg_19_0:_is_button_pressed(var_19_0) then
		arg_19_0:_play_sound("play_gui_start_menu_button_click")

		local var_19_1 = "https://vermintide2beta.com/?utm_medium=referral&utm_campaign=vermintide2beta&utm_source=ingame#challenge"

		Application.open_url_in_browser(var_19_1)
	end
end

function EndViewStateScore._is_button_pressed(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.content.button_hotspot

	if var_20_0.on_release then
		var_20_0.on_release = false

		return true
	end
end

function EndViewStateScore._is_button_hover_enter(arg_21_0, arg_21_1)
	return arg_21_1.content.button_hotspot.on_hover_enter
end

function EndViewStateScore.draw(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0.ui_renderer
	local var_22_1 = arg_22_0.ui_scenegraph
	local var_22_2 = arg_22_0.render_settings
	local var_22_3 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_22_0, var_22_1, arg_22_1, arg_22_2, nil, var_22_2)

	for iter_22_0, iter_22_1 in ipairs(arg_22_0._widgets) do
		UIRenderer.draw_widget(var_22_0, iter_22_1)
	end

	for iter_22_2, iter_22_3 in ipairs(arg_22_0._hero_widgets) do
		UIRenderer.draw_widget(var_22_0, iter_22_3)
	end

	for iter_22_4, iter_22_5 in ipairs(arg_22_0._score_widgets) do
		UIRenderer.draw_widget(var_22_0, iter_22_5)
	end

	if var_22_3 and arg_22_0.parent:input_enabled() then
		UIRenderer.draw_widget(var_22_0, arg_22_0._gamepad_selection_screen)
	end

	UIRenderer.end_pass(var_22_0)
end

function EndViewStateScore._start_transition_animation(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = {
		wwise_world = arg_23_0.wwise_world,
		render_settings = arg_23_0.render_settings,
		self = arg_23_0
	}
	local var_23_1 = arg_23_0._hero_widgets
	local var_23_2 = arg_23_0.ui_animator:start_animation(arg_23_2, var_23_1, var_0_5, var_23_0)

	arg_23_0._animations[arg_23_1] = var_23_2
end

function EndViewStateScore._animate_element_by_time(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, math.ease_out_quad))
end

function EndViewStateScore._animate_element_by_catmullrom(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8))
end

function EndViewStateScore._transform_player_session_score(arg_26_0, arg_26_1)
	local var_26_0 = {
		group_scores = {}
	}

	for iter_26_0, iter_26_1 in pairs(arg_26_1) do
		for iter_26_2, iter_26_3 in pairs(iter_26_1.group_scores) do
			if not var_26_0.group_scores[iter_26_2] then
				var_26_0.group_scores[iter_26_2] = {}
			end

			for iter_26_4, iter_26_5 in ipairs(iter_26_3) do
				if not var_26_0.group_scores[iter_26_2][iter_26_4] then
					var_26_0.group_scores[iter_26_2][iter_26_4] = {
						player_scores = {}
					}
				end

				local var_26_1 = var_26_0.group_scores[iter_26_2][iter_26_4].highscore or 0

				var_26_0.group_scores[iter_26_2][iter_26_4].stat_name = iter_26_5.stat_name
				var_26_0.group_scores[iter_26_2][iter_26_4].display_name = iter_26_5.display_name
				var_26_0.group_scores[iter_26_2][iter_26_4].highscore = var_26_1 < iter_26_5.score and iter_26_5.score or var_26_1
				var_26_0.group_scores[iter_26_2][iter_26_4].player_scores[iter_26_0] = iter_26_5.score
			end
		end
	end

	return var_26_0
end

function EndViewStateScore._group_scores_by_player_and_topic(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	for iter_27_0, iter_27_1 in pairs(arg_27_2.group_scores) do
		if not arg_27_1[iter_27_0] then
			arg_27_1[iter_27_0] = {}
		end

		local var_27_0 = 0

		for iter_27_2, iter_27_3 in ipairs(iter_27_1) do
			if not arg_27_1[iter_27_0][iter_27_2] then
				arg_27_1[iter_27_0][iter_27_2] = {
					player_scores = {}
				}
			end

			local var_27_1 = arg_27_1[iter_27_0][iter_27_2].highscore or 0
			local var_27_2 = iter_27_3.stat_name

			arg_27_1[iter_27_0][iter_27_2].stat_name = var_27_2
			arg_27_1[iter_27_0][iter_27_2].display_text = iter_27_3.display_text
			arg_27_1[iter_27_0][iter_27_2].player_scores[arg_27_3] = iter_27_3.score

			if var_27_2 == "damage_taken" then
				local var_27_3 = var_27_1 > iter_27_3.score and iter_27_3.score or var_27_1

				arg_27_1[iter_27_0][iter_27_2].highscore = var_27_3
			else
				local var_27_4 = var_27_1 < iter_27_3.score and iter_27_3.score or var_27_1

				arg_27_1[iter_27_0][iter_27_2].highscore = var_27_4
			end
		end
	end
end

function EndViewStateScore._setup_player_scores(arg_28_0, arg_28_1)
	local var_28_0 = {}
	local var_28_1 = {}
	local var_28_2 = 1
	local var_28_3 = 1

	arg_28_0._players_by_widget_index = {}

	local var_28_4 = arg_28_0._players_by_widget_index
	local var_28_5 = 0
	local var_28_6 = arg_28_0._hero_widgets

	for iter_28_0, iter_28_1 in pairs(arg_28_1) do
		arg_28_0:_set_topic_data(iter_28_1, var_28_2)
		arg_28_0:_group_scores_by_player_and_topic(var_28_0, iter_28_1, var_28_2)

		var_28_1[var_28_2] = iter_28_1.name
		var_28_4[var_28_2] = iter_28_1

		local var_28_7 = iter_28_1.peer_id
		local var_28_8 = iter_28_1.profile_index
		local var_28_9 = iter_28_1.career_index
		local var_28_10 = SPProfiles[var_28_8].careers[var_28_9].portrait_image
		local var_28_11 = iter_28_1.portrait_frame or "default"
		local var_28_12 = iter_28_1.player_level
		local var_28_13 = iter_28_1.is_player_controlled

		if IS_WINDOWS and var_28_7 and var_28_13 then
			var_28_5 = var_28_5 + 1
		end

		local var_28_14 = var_28_13 and (var_28_12 and tostring(var_28_12) or "-") or "BOT"
		local var_28_15 = UIWidgets.create_portrait_frame("player_frame_" .. var_28_2, var_28_11, var_28_14, 1, nil, var_28_10)

		var_28_6[var_28_2] = UIWidget.init(var_28_15, arg_28_0.ui_renderer)
		var_28_2 = var_28_2 + 1
	end

	if IS_WINDOWS then
		Presence.set_presence("steam_player_group_size", var_28_5)
	end

	arg_28_0:_setup_score_panel(var_28_0, var_28_1)
end

function EndViewStateScore._setup_level_widget(arg_29_0)
	local var_29_0 = arg_29_0._widgets_by_name.level.content
	local var_29_1 = arg_29_0._context.level_key
	local var_29_2 = LevelSettings[var_29_1]

	var_29_0.icon = var_29_2 and var_29_2.level_image or "level_image_any"

	local var_29_3 = arg_29_0._context.difficulty
	local var_29_4 = DifficultySettings[var_29_3]

	var_29_0.frame = var_29_4 and var_29_4.completed_frame_texture or "map_frame_00"
end

local var_0_9 = {
	Colors.get_color_table_with_alpha("cyan", 255),
	Colors.get_color_table_with_alpha("gold", 255),
	Colors.get_color_table_with_alpha("silver", 255),
	Colors.get_color_table_with_alpha("gray", 255)
}
local var_0_10 = {
	nil,
	"scoreboard_topic_02",
	"scoreboard_topic_03",
	"scoreboard_topic_04"
}

function EndViewStateScore._set_topic_data(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._score_widgets[arg_30_2]
	local var_30_1 = var_30_0.content
	local var_30_2 = var_30_0.style
	local var_30_3 = 0
	local var_30_4 = arg_30_1.group_scores

	for iter_30_0, iter_30_1 in pairs(var_30_4) do
		local var_30_5 = 0

		for iter_30_2, iter_30_3 in ipairs(iter_30_1) do
			var_30_5 = var_30_5 + iter_30_3.score
			var_30_3 = var_30_3 + iter_30_3.score
		end

		iter_30_1.total_score = var_30_5
	end
end

function EndViewStateScore._setup_score_panel(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = 30
	local var_31_1 = 22
	local var_31_2 = 1
	local var_31_3 = 1
	local var_31_4 = arg_31_0._score_widgets

	for iter_31_0, iter_31_1 in pairs(arg_31_1) do
		local var_31_5 = "title_text_" .. tostring(var_31_2)
		local var_31_6 = "horizontal_divider_" .. tostring(var_31_2)

		if var_31_2 == 1 then
			for iter_31_2, iter_31_3 in ipairs(arg_31_2) do
				local var_31_7 = "score_player_" .. tostring(iter_31_2) .. "_" .. tostring(var_31_2)
				local var_31_8 = var_31_4[iter_31_2]
				local var_31_9 = var_31_8.content
				local var_31_10 = var_31_8.style
				local var_31_11 = "_" .. var_31_2
				local var_31_12 = "score_text" .. var_31_11

				var_31_9["row_bg" .. var_31_11][var_31_12] = UTF8Utils.string_length(iter_31_3) > var_0_7 and UIRenderer.crop_text_width(arg_31_0.ui_renderer, iter_31_3, var_0_2[1] - 40, var_31_10[var_31_12]) or iter_31_3
			end

			var_31_2 = var_31_2 + 1
		end

		for iter_31_4, iter_31_5 in ipairs(iter_31_1) do
			local var_31_13 = iter_31_5.stat_name
			local var_31_14 = math.round(iter_31_5.highscore)
			local var_31_15 = iter_31_5.player_scores

			for iter_31_6, iter_31_7 in ipairs(var_31_15) do
				local var_31_16 = var_31_4[iter_31_6]
				local var_31_17 = var_31_16.content
				local var_31_18 = var_31_16.style

				iter_31_7 = math.round(iter_31_7)

				local var_31_19 = "title_text_" .. tostring(var_31_2)
				local var_31_20 = "score_player_" .. tostring(iter_31_6) .. "_" .. tostring(var_31_2)
				local var_31_21 = "high_score_marker_" .. tostring(iter_31_6) .. "_" .. tostring(var_31_2)
				local var_31_22 = "horizontal_divider_" .. tostring(var_31_2)
				local var_31_23 = "row_bg_" .. tostring(var_31_2)
				local var_31_24 = false

				if var_31_13 == "damage_taken" then
					var_31_24 = iter_31_7 <= var_31_14
				else
					var_31_24 = var_31_14 <= iter_31_7 and var_31_14 > 0
				end

				local var_31_25 = false
				local var_31_26 = "_" .. var_31_2
				local var_31_27 = "score_text" .. var_31_26
				local var_31_28 = var_31_17["row_bg" .. var_31_26]

				var_31_28[var_31_27] = iter_31_7
				var_31_28.has_background = var_31_2 % 2 == 0
				var_31_28.has_highscore = var_31_24
				var_31_28.has_score = true

				arg_31_0:_set_score_topic_by_row(var_31_2, Localize(iter_31_5.display_text))
			end

			var_31_2 = var_31_2 + 1
		end

		var_31_3 = var_31_3 + 1
	end
end

function EndViewStateScore._set_score_topic_by_row(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0._widgets_by_name.scores_topics.content
	local var_32_1 = "_" .. arg_32_1
	local var_32_2 = "score_text" .. var_32_1
	local var_32_3 = var_32_0["row_bg" .. var_32_1]

	var_32_3[var_32_2] = arg_32_2
	var_32_3.has_score = true
	var_32_3.has_background = arg_32_1 % 2 == 0
end

function EndViewStateScore._setup_hero_score_tooltip(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_1.content.tooltip
	local var_33_1 = arg_33_1.style.tooltip
	local var_33_2 = var_33_1.text_styles
	local var_33_3 = var_33_1.value_styles

	table.clear(var_33_2)
	table.clear(var_33_3)
	table.clear(var_33_0)

	for iter_33_0, iter_33_1 in pairs(arg_33_2) do
		var_33_0[iter_33_0] = iter_33_0

		local var_33_4 = iter_33_0 .. "_value"

		var_33_0[var_33_4] = iter_33_1.total_score
		var_33_2[#var_33_2 + 1] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			font_size = 20,
			font_type = "hell_shark",
			word_wrap = true,
			name = iter_33_0,
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			value_style = {
				vertical_alignment = "top",
				word_wrap = true,
				horizontal_alignment = "right",
				font_size = 20,
				font_type = "hell_shark",
				name = var_33_4,
				text_color = Colors.get_color_table_with_alpha("font_title", 255)
			}
		}

		for iter_33_2, iter_33_3 in ipairs(iter_33_1) do
			local var_33_5 = iter_33_3.stat_name
			local var_33_6 = iter_33_3.score
			local var_33_7 = iter_33_3.display_text

			var_33_0[var_33_5] = Localize(var_33_7) .. ":"

			local var_33_8 = var_33_5 .. "_value"

			var_33_0[var_33_8] = tostring(var_33_6)
			var_33_2[#var_33_2 + 1] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = 20,
				font_type = "hell_shark",
				word_wrap = true,
				name = var_33_5,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				value_style = {
					vertical_alignment = "top",
					word_wrap = true,
					horizontal_alignment = "right",
					font_size = 20,
					font_type = "hell_shark",
					name = var_33_8,
					text_color = Colors.get_color_table_with_alpha("font_default", 255)
				}
			}
		end
	end
end

function EndViewStateScore._player_score_data_by_stats_id(arg_34_0, arg_34_1)
	return arg_34_0._players_list[arg_34_1]
end

function EndViewStateScore._get_player_position_in_score_table(arg_35_0, arg_35_1, arg_35_2)
	for iter_35_0, iter_35_1 in ipairs(arg_35_2.scores) do
		if iter_35_1.stats_id == arg_35_1 then
			return iter_35_0
		end
	end
end

function EndViewStateScore._start_hero_score_animation(arg_36_0, arg_36_1)
	local var_36_0 = {
		wwise_world = arg_36_0.wwise_world
	}

	return arg_36_0.ui_animator:start_animation(arg_36_1, arg_36_0._hero_widgets, var_0_5, var_36_0)
end

function EndViewStateScore._play_sound(arg_37_0, arg_37_1)
	arg_37_0.parent:play_sound(arg_37_1)
end
