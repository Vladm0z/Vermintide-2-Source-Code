-- chunkname: @scripts/ui/views/end_screens/versus_round_end_screen_ui.lua

require("scripts/ui/views/end_screens/base_end_screen_ui")

local var_0_0 = local_require("scripts/ui/views/end_screens/versus_round_end_screen_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = {
	500,
	80
}
local var_0_3 = 1.2
local var_0_4 = 800
local var_0_5 = 400
local var_0_6 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	default_offset = {
		0,
		-10,
		12
	},
	offset = {
		0,
		-10,
		12
	}
}

VersusRoundEndScreenUI = class(VersusRoundEndScreenUI, BaseEndScreenUI)

function VersusRoundEndScreenUI.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.player

	arg_1_0._player = var_1_0
	arg_1_0._peer_id = var_1_0:network_id()
	arg_1_0._local_player_id = var_1_0:local_player_id()
	arg_1_0._side = Managers.state.side:get_side_from_player_unique_id(var_1_0:unique_id())
	arg_1_0._win_conditions = Managers.mechanism:game_mechanism():win_conditions()
	arg_1_0._input_service = arg_1_2

	VersusRoundEndScreenUI.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)
end

function VersusRoundEndScreenUI._create_ui_elements(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.scenegraph_definition
	local var_2_1 = arg_2_1.widget_definitions
	local var_2_2, var_2_3 = Managers.party:get_party_from_player_id(arg_2_0._peer_id, arg_2_0._local_player_id)

	var_2_3 = var_2_3 == 0 and 1 or var_2_3

	local var_2_4 = var_2_3 == 1 and 2 or 1

	arg_2_0:_build_score_widgets_scenegraph(var_2_0)

	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_2_0)

	UISceneGraph.update_scenegraph(arg_2_0._ui_scenegraph)

	arg_2_0._widgets, arg_2_0._widgets_by_name = {}, {}

	arg_2_0:_setup_score_widgets(var_2_0, var_2_1, var_2_3, var_2_4)

	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		local var_2_5 = UIWidget.init(iter_2_1, arg_2_0._ui_renderer)

		arg_2_0._widgets[#arg_2_0._widgets + 1] = var_2_5
		arg_2_0._widgets_by_name[iter_2_0] = var_2_5
	end

	if arg_2_0._current_round_bg_widget_def then
		local var_2_6 = UIWidget.init(arg_2_0._current_round_bg_widget_def, arg_2_0._ui_renderer)

		arg_2_0._widgets[#arg_2_0._widgets + 1] = var_2_6
		arg_2_0._widgets_by_name.current_round_bg_widget = var_2_6
	end

	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, arg_2_1.animation_definitions)

	local var_2_7 = Managers.level_transition_handler:get_current_level_key()

	arg_2_0:_setup_top_detail_banner(var_2_7)
	arg_2_0:_setup_total_score_progress_bars_widgets(var_2_7, var_2_3, var_2_4)
	arg_2_0:_set_team_banner(var_2_3, var_2_4)

	local var_2_8 = arg_2_0:_get_current_set()
	local var_2_9 = string.format("cutscene_camera_vs_round_%s", var_2_8)
	local var_2_10 = arg_2_0._ingame_ui_context.world_manager:world("level_world")
	local var_2_11 = LevelHelper:current_level(var_2_10)

	Managers.state.entity:system("animation_system"):add_safe_animation_callback(function()
		for iter_3_0, iter_3_1 in pairs(MoodSettings) do
			Managers.state.camera:clear_mood(iter_3_0)
		end

		Level.trigger_event(var_2_11, var_2_9)
	end)
end

function VersusRoundEndScreenUI._draw_widgets(arg_4_0, arg_4_1, arg_4_2)
	arg_4_2.alpha_multiplier = arg_4_2.alpha_multiplier

	VersusRoundEndScreenUI.super._draw_widgets(arg_4_0, arg_4_1, arg_4_2)
end

function VersusRoundEndScreenUI._on_fade_in(arg_5_0)
	arg_5_0:_play_sound("versus_round_end_transition")
end

function VersusRoundEndScreenUI._start(arg_6_0)
	local var_6_0 = var_0_0.scenegraph_definition
	local var_6_1 = {
		draw_flags = arg_6_0._draw_flags,
		wwise_world = arg_6_0._wwise_world,
		num_rounds = arg_6_0._num_rounds,
		current_round = arg_6_0:_get_current_set()
	}

	arg_6_0._round_end_anim_id = arg_6_0._ui_animator:start_animation("round_end", arg_6_0._widgets_by_name, var_6_0, var_6_1)
end

function VersusRoundEndScreenUI._update(arg_7_0, arg_7_1)
	if arg_7_0._completed then
		return
	end

	if arg_7_0._round_end_anim_id and (arg_7_0._ui_animator:is_animation_completed(arg_7_0._round_end_anim_id) or script_data.auto_complete_rounds) then
		arg_7_0._round_end_anim_id = nil
	end

	if arg_7_0._round_end_anim_id == nil then
		arg_7_0:_on_completed()
	end

	arg_7_0:draw(arg_7_1)
end

function VersusRoundEndScreenUI._get_round_count(arg_8_0)
	return (Managers.mechanism:game_mechanism():win_conditions():get_current_round())
end

function VersusRoundEndScreenUI._get_teams_ui_settings(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_9_1]
	local var_9_1 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_9_2]
	local var_9_2 = DLCSettings.carousel
	local var_9_3 = var_9_2.teams_ui_assets[var_9_0]
	local var_9_4 = var_9_2.teams_ui_assets[var_9_1]

	return var_9_3, var_9_4
end

function VersusRoundEndScreenUI._build_score_widgets_scenegraph(arg_10_0, arg_10_1)
	local var_10_0 = Managers.mechanism:game_mechanism():num_sets()

	arg_10_0._num_rounds = var_10_0
	arg_10_0._num_round_splits = var_10_0 * 2

	for iter_10_0 = 1, var_10_0 do
		local var_10_1 = "round_" .. iter_10_0 .. "_bg"

		arg_10_1[var_10_1] = {
			vertical_alignment = "center",
			parent = "screen",
			horizontal_alignment = "center",
			position = {
				0,
				-160 + -110 * (iter_10_0 - 1),
				2
			},
			size = {
				920,
				100
			}
		}
		arg_10_1["round_" .. iter_10_0 .. "_team_1_score_bar"] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_10_1,
			position = {
				40,
				-20,
				3
			},
			size = {
				400,
				14
			}
		}
		arg_10_1["round_" .. iter_10_0 .. "_team_2_score_bar"] = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			parent = var_10_1,
			position = {
				-40,
				-20,
				3
			},
			size = {
				400,
				14
			}
		}
	end
end

function VersusRoundEndScreenUI._setup_score_widgets(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_0._num_rounds
	local var_11_1 = arg_11_0:_get_current_set()

	for iter_11_0 = 1, var_11_0 do
		local var_11_2 = arg_11_0._win_conditions:get_sets_data_for_party(arg_11_3)[iter_11_0]
		local var_11_3 = var_11_2.max_points
		local var_11_4 = var_11_2.claimed_points
		local var_11_5 = var_11_4 / var_11_3
		local var_11_6 = "round_" .. iter_11_0 .. "_team_1_score_bar"
		local var_11_7 = UIWidgets.create_round_score_progress_bar(var_11_6, arg_11_1[var_11_6].size, nil, true, var_11_3, var_11_4)

		var_11_7.content.bar_fill_threashold = var_11_5

		local var_11_8 = UIWidget.init(var_11_7, arg_11_0._ui_renderer)

		arg_11_0._widgets[#arg_11_0._widgets + 1] = var_11_8
		arg_11_0._widgets_by_name[var_11_6] = var_11_8

		local var_11_9 = arg_11_0._win_conditions:get_sets_data_for_party(arg_11_4)[iter_11_0]
		local var_11_10 = var_11_9.max_points
		local var_11_11 = var_11_9.claimed_points
		local var_11_12 = var_11_11 / var_11_10
		local var_11_13 = "round_" .. iter_11_0 .. "_team_2_score_bar"
		local var_11_14 = UIWidgets.create_round_score_progress_bar(var_11_13, arg_11_1[var_11_13].size, nil, false, var_11_10, var_11_11)

		var_11_14.content.bar_fill_threashold = var_11_12

		local var_11_15 = UIWidget.init(var_11_14, arg_11_0._ui_renderer)

		arg_11_0._widgets[#arg_11_0._widgets + 1] = var_11_15
		arg_11_0._widgets_by_name[var_11_13] = var_11_15

		local var_11_16 = "round_" .. iter_11_0 .. "_bg"
		local var_11_17 = "round_" .. iter_11_0 .. "_text"
		local var_11_18 = "%s %d"
		local var_11_19 = table.clone(var_0_6)

		var_11_19.text_color = var_11_1 == iter_11_0 and Colors.get_color_table_with_alpha("font_default", 255) or Colors.get_color_table_with_alpha("font_button_normal", 255)

		local var_11_20 = UIWidgets.create_simple_text(string.format(var_11_18, Localize("versus_round"), iter_11_0), var_11_16, nil, nil, var_11_19)
		local var_11_21 = UIWidget.init(var_11_20, arg_11_0._ui_renderer)

		arg_11_0._widgets[#arg_11_0._widgets + 1] = var_11_21
		arg_11_0._widgets_by_name[var_11_17] = var_11_21
	end

	local var_11_22 = "round_" .. var_11_1 .. "_bg"

	arg_11_0._current_round_bg_widget_def = UIWidgets.create_round_end_round_score_bg_widget(var_11_22)
end

function VersusRoundEndScreenUI._set_team_banner(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0, var_12_1 = arg_12_0:_get_teams_ui_settings(arg_12_1, arg_12_2)

	arg_12_0._widgets_by_name.team_1_banner.content.texture_id = var_12_0.local_flag_long_texture

	local var_12_2 = arg_12_0._widgets_by_name.team_1_info

	var_12_2.content.team_name = Localize(var_12_0.display_name)
	var_12_2.content.team_side = Localize("vs_lobby_your_team")
	arg_12_0._widgets_by_name.team_2_banner.content.texture_id = var_12_1.opponent_flag_long_texture

	local var_12_3 = arg_12_0._widgets_by_name.team_2_info

	var_12_3.content.team_name = Localize(var_12_1.display_name)
	var_12_3.content.team_side = Localize("vs_lobby_enemy_team")
end

function VersusRoundEndScreenUI._setup_top_detail_banner(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = LevelSettings[arg_13_1]
	local var_13_1 = var_13_0.display_name

	arg_13_0._widgets_by_name.level_name.content.text = Localize(var_13_1)
	arg_13_0._widgets_by_name.level_image.content.icon = var_13_0.level_image

	local var_13_2 = arg_13_0:_get_current_set()
	local var_13_3 = VersusObjectiveSettings[arg_13_1].num_sets

	arg_13_0._widgets_by_name.round_counter.content.text = string.format(Localize("versus_round_count"), var_13_2, var_13_3)
end

function VersusRoundEndScreenUI._setup_total_score_progress_bars_widgets(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = VersusObjectiveSettings[arg_14_1].max_score
	local var_14_1 = arg_14_0._win_conditions:get_total_score(arg_14_2)
	local var_14_2 = arg_14_0._win_conditions:get_total_score(arg_14_3)
	local var_14_3 = var_14_2 < var_14_1
	local var_14_4 = var_14_1 < var_14_2
	local var_14_5 = UIWidgets.create_total_score_progress_bar("team_1_total_score", var_0_1.team_1_total_score.size, var_14_0, var_14_1, true)
	local var_14_6 = UIWidget.init(var_14_5)

	arg_14_0._widgets[#arg_14_0._widgets + 1] = var_14_6
	arg_14_0._widgets_by_name.team_1_total_score = var_14_6

	local var_14_7 = var_14_6.content

	var_14_7.bar_fill_threashold = var_14_1 / var_14_0
	var_14_7.is_winning = var_14_3

	local var_14_8 = UIWidgets.create_total_score_progress_bar("team_2_total_score", var_0_1.team_2_total_score.size, var_14_0, var_14_2, false)
	local var_14_9 = UIWidget.init(var_14_8)

	arg_14_0._widgets[#arg_14_0._widgets + 1] = var_14_9
	arg_14_0._widgets_by_name.team_2_total_score = var_14_9

	local var_14_10 = var_14_9.content

	var_14_10.bar_fill_threashold = var_14_2 / var_14_0
	var_14_10.is_winning = var_14_4

	local var_14_11, var_14_12 = arg_14_0:_get_teams_ui_settings(arg_14_2, arg_14_3)
	local var_14_13 = arg_14_0._widgets_by_name.total_score_bg

	var_14_13.content.team_1_icon = var_14_11.team_icon
	var_14_13.content.team_2_icon = var_14_12.team_icon

	local var_14_14

	if var_14_3 then
		var_14_14 = UIWidgets.create_simple_texture("winner_icon", "team_1_winner")
	elseif var_14_4 then
		var_14_14 = UIWidgets.create_simple_texture("winner_icon", "team_2_winner")
	end

	if var_14_14 then
		local var_14_15 = UIWidget.init(var_14_14)

		arg_14_0._widgets[#arg_14_0._widgets + 1] = var_14_15
		arg_14_0._widgets_by_name.winner_team_crown = var_14_15
	end

	local var_14_16 = ""

	arg_14_0._widgets_by_name.team_wining_status_text.content.text = var_14_16
end

function VersusRoundEndScreenUI._get_current_set(arg_15_0)
	local var_15_0 = arg_15_0._win_conditions:get_current_round()

	return math.round(var_15_0 / 2)
end

function VersusRoundEndScreenUI._get_close_to_winning_score(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0:_get_current_set()
	local var_16_1 = arg_16_0:_get_round_count()
	local var_16_2 = arg_16_0._num_rounds
	local var_16_3 = VersusObjectiveSettings[arg_16_1].max_score
	local var_16_4 = arg_16_0._win_conditions:get_total_score(arg_16_2)
	local var_16_5 = arg_16_0._win_conditions:get_sets_data_for_party(arg_16_2)
	local var_16_6 = arg_16_0._win_conditions:get_total_score(arg_16_3)
	local var_16_7 = arg_16_0._win_conditions:get_sets_data_for_party(arg_16_3)
	local var_16_8 = var_16_3
	local var_16_9 = var_16_3
	local var_16_10 = Managers.player:local_player()
	local var_16_11 = Managers.state.side and Managers.state.side:get_side_from_player_unique_id(var_16_10:unique_id())
	local var_16_12 = var_16_11 and var_16_11:name() == "heroes"
	local var_16_13 = Managers.mechanism:get_state()
	local var_16_14 = Managers.state.game_mode and Managers.state.game_mode:game_mode()
	local var_16_15

	var_16_15 = var_16_14 and var_16_14:match_in_round_over_state()

	local var_16_16 = false
	local var_16_17 = false

	if var_16_1 % var_16_0 ~= 0 then
		var_16_16 = var_16_12
		var_16_17 = not var_16_12
	elseif var_16_1 % var_16_0 == 0 then
		var_16_16 = true
		var_16_17 = true
	end

	local var_16_18 = arg_16_0._win_conditions:is_final_round()

	for iter_16_0 = 1, var_16_2 do
		local var_16_19 = var_16_5[iter_16_0]
		local var_16_20 = var_16_7[iter_16_0]

		if iter_16_0 < var_16_0 then
			var_16_8 = var_16_8 - (var_16_19.max_points - var_16_19.claimed_points or 0)
			var_16_9 = var_16_9 - (var_16_20.max_points - var_16_20.claimed_points or 0)
		end
	end

	local var_16_21 = var_16_8 < var_16_9 and var_16_8 or var_16_9
	local var_16_22 = var_16_21 - var_16_4
	local var_16_23 = var_16_21 - var_16_6
	local var_16_24 = var_16_2 >= var_16_0 + 1 and var_16_0 + 1 or var_16_2
	local var_16_25 = 0
	local var_16_26 = 0

	if var_16_16 and var_16_17 then
		local var_16_27 = var_16_6 + var_16_7[var_16_24].max_points
		local var_16_28 = var_16_4 + var_16_5[var_16_24].max_points
	else
		local var_16_29 = var_16_7[var_16_0]
		local var_16_30 = var_16_6 + (var_16_29.max_points - var_16_29.claimed_points)
		local var_16_31 = var_16_5[var_16_0]
		local var_16_32 = var_16_4 + (var_16_31.max_points - var_16_31.claimed_points)
	end

	if var_16_1 + 1 == arg_16_0._num_rounds * 2 then
		if var_16_12 then
			return arg_16_3, var_16_23 + 1
		else
			return arg_16_2, var_16_22 + 1
		end
	end

	if var_16_22 < var_16_23 then
		if var_16_22 < var_16_5[var_16_24].max_points then
			return arg_16_2, var_16_22 + 1
		end
	elseif var_16_23 < var_16_22 then
		if var_16_23 < var_16_7[var_16_24].max_points then
			return arg_16_3, var_16_23 + 1
		end
	elseif var_16_22 < var_16_5[var_16_24].max_points then
		return arg_16_2, var_16_22 + 1
	end

	return nil, nil
end
