-- chunkname: @scripts/ui/views/end_screens/versus_round_end_screen_ui.lua

require("scripts/ui/views/end_screens/base_end_screen_ui")

local var_0_0 = local_require("scripts/ui/views/end_screens/versus_round_end_screen_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local tbl = {
	500,
	80
}
local num = 1.2
local num_2 = 800
local num_3 = 400
local tbl_2 = {
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

VersusRoundEndScreenUI.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local player = arg_1_1.player

	self._player = player
	self._peer_id = player:network_id()
	self._local_player_id = player:local_player_id()
	self._side = Managers.state.side:get_side_from_player_unique_id(player:unique_id())
	self._win_conditions = Managers.mechanism:game_mechanism():win_conditions()
	self._input_service = arg_1_2

	VersusRoundEndScreenUI.super.init(self, arg_1_1, arg_1_2, var_0_0)
end

VersusRoundEndScreenUI._create_ui_elements = function (self, arg_2_1)
	-- function 2
	local scenegraph_definition = arg_2_1.scenegraph_definition
	local widget_definitions = arg_2_1.widget_definitions
	local get_party_from_player_id, var_2_3 = Managers.party:get_party_from_player_id(self._peer_id, self._local_player_id)

	var_2_3 = var_2_3 ~= 0 or not 1 or var_2_3

	local flag

	flag = var_2_3 ~= 1 or not 2 or 1

	self:_build_score_widgets_scenegraph(scenegraph_definition)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	UISceneGraph.update_scenegraph(self._ui_scenegraph)

	self._widgets, self._widgets_by_name = {}, {}

	self:_setup_score_widgets(scenegraph_definition, widget_definitions, var_2_3, flag)

	for k, v in pairs(widget_definitions) do
		local var_2_5 = UIWidget.init(v, self._ui_renderer)

		self._widgets[#self._widgets + 1] = var_2_5
		self._widgets_by_name[k] = var_2_5
	end

	if not self._current_round_bg_widget_def then
		local var_2_6 = UIWidget.init(self._current_round_bg_widget_def, self._ui_renderer)

		self._widgets[#self._widgets + 1] = var_2_6
		self._widgets_by_name.current_round_bg_widget = var_2_6
	end

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, arg_2_1.animation_definitions)

	local get_current_level_key = Managers.level_transition_handler:get_current_level_key()

	self:_setup_top_detail_banner(get_current_level_key)
	self:_setup_total_score_progress_bars_widgets(get_current_level_key, var_2_3, flag)
	self:_set_team_banner(var_2_3, flag)

	local _get_current_set = self:_get_current_set()
	local format = string.format("cutscene_camera_vs_round_%s", _get_current_set)
	local world = self._ingame_ui_context.world_manager:world("level_world")
	local current_level = LevelHelper:current_level(world)

	Managers.state.entity:system("animation_system"):add_safe_animation_callback(function ()
		-- function 3
		for k, v in pairs(MoodSettings) do
			Managers.state.camera:clear_mood(k)
		end

		Level.trigger_event(current_level, format)
	end)
end

VersusRoundEndScreenUI._draw_widgets = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	arg_4_2.alpha_multiplier = arg_4_2.alpha_multiplier

	VersusRoundEndScreenUI.super._draw_widgets(arg_4_0, arg_4_1, arg_4_2)
end

VersusRoundEndScreenUI._on_fade_in = function (self)
	-- function 5
	self:_play_sound("versus_round_end_transition")
end

VersusRoundEndScreenUI._start = function (self)
	-- function 6
	local scenegraph_definition = var_0_0.scenegraph_definition
	local tbl = {
		draw_flags = self._draw_flags,
		wwise_world = self._wwise_world,
		num_rounds = self._num_rounds,
		current_round = self:_get_current_set()
	}

	self._round_end_anim_id = self._ui_animator:start_animation("round_end", self._widgets_by_name, scenegraph_definition, tbl)
end

VersusRoundEndScreenUI._update = function (self, arg_7_1)
	-- function 7
	if not self._completed then
		return
	end

	if not self._round_end_anim_id and self._ui_animator:is_animation_completed(self._round_end_anim_id) and not script_data.auto_complete_rounds then
		self._round_end_anim_id = nil
	end

	if self._round_end_anim_id == nil then
		self:_on_completed()
	end

	self:draw(arg_7_1)
end

VersusRoundEndScreenUI._get_round_count = function (arg_8_0)
	-- function 8
	return (Managers.mechanism:game_mechanism():win_conditions():get_current_round())
end

VersusRoundEndScreenUI._get_teams_ui_settings = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_9_1]
	local var_9_1 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_9_2]
	local carousel = DLCSettings.carousel
	local var_9_3 = carousel.teams_ui_assets[var_9_0]
	local var_9_4 = carousel.teams_ui_assets[var_9_1]

	return var_9_3, var_9_4
end

VersusRoundEndScreenUI._build_score_widgets_scenegraph = function (self, arg_10_1)
	-- function 10
	local num_sets = Managers.mechanism:game_mechanism():num_sets()

	self._num_rounds = num_sets
	self._num_round_splits = num_sets * 2

	for i = 1, num_sets do
		local str = "round_" .. i .. "_bg"

		arg_10_1[str] = {
			vertical_alignment = "center",
			parent = "screen",
			horizontal_alignment = "center",
			position = {
				0,
				-160 + -110 * (i - 1),
				2
			},
			size = {
				920,
				100
			}
		}
		arg_10_1["round_" .. i .. "_team_1_score_bar"] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str,
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
		arg_10_1["round_" .. i .. "_team_2_score_bar"] = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			parent = str,
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

VersusRoundEndScreenUI._setup_score_widgets = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local _num_rounds = self._num_rounds
	local _get_current_set = self:_get_current_set()

	for i = 1, _num_rounds do
		local var_11_2 = self._win_conditions:get_sets_data_for_party(arg_11_3)[i]
		local max_points = var_11_2.max_points
		local claimed_points = var_11_2.claimed_points
		local num = claimed_points / max_points
		local str = "round_" .. i .. "_team_1_score_bar"
		local create_round_score_progress_bar = UIWidgets.create_round_score_progress_bar(str, arg_11_1[str].size, nil, true, max_points, claimed_points)

		create_round_score_progress_bar.content.bar_fill_threashold = num

		local var_11_8 = UIWidget.init(create_round_score_progress_bar, self._ui_renderer)

		self._widgets[#self._widgets + 1] = var_11_8
		self._widgets_by_name[str] = var_11_8

		local var_11_9 = self._win_conditions:get_sets_data_for_party(arg_11_4)[i]
		local max_points_2 = var_11_9.max_points
		local claimed_points_2 = var_11_9.claimed_points
		local num_2 = claimed_points_2 / max_points_2
		local str_2 = "round_" .. i .. "_team_2_score_bar"
		local create_round_score_progress_bar_2 = UIWidgets.create_round_score_progress_bar(str_2, arg_11_1[str_2].size, nil, false, max_points_2, claimed_points_2)

		create_round_score_progress_bar_2.content.bar_fill_threashold = num_2

		local var_11_15 = UIWidget.init(create_round_score_progress_bar_2, self._ui_renderer)

		self._widgets[#self._widgets + 1] = var_11_15
		self._widgets_by_name[str_2] = var_11_15

		local str_3 = "round_" .. i .. "_bg"
		local str_4 = "round_" .. i .. "_text"
		local str_5 = "%s %d"
		local clone = table.clone(tbl_2)
		local get_color_table_with_alpha

		if _get_current_set == i then
			get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_default", 255)

			if not get_color_table_with_alpha then
				-- Nothing
			end
		end

		get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_button_normal", 255)

		::label_11_0::

		clone.text_color = get_color_table_with_alpha

		local create_simple_text = UIWidgets.create_simple_text(string.format(str_5, Localize("versus_round"), i), str_3, nil, nil, clone)
		local var_11_22 = UIWidget.init(create_simple_text, self._ui_renderer)

		self._widgets[#self._widgets + 1] = var_11_22
		self._widgets_by_name[str_4] = var_11_22
	end

	local str_6 = "round_" .. _get_current_set .. "_bg"

	self._current_round_bg_widget_def = UIWidgets.create_round_end_round_score_bg_widget(str_6)
end

VersusRoundEndScreenUI._set_team_banner = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _get_teams_ui_settings, var_12_1 = self:_get_teams_ui_settings(arg_12_1, arg_12_2)

	self._widgets_by_name.team_1_banner.content.texture_id = _get_teams_ui_settings.local_flag_long_texture

	local team_1_info = self._widgets_by_name.team_1_info

	team_1_info.content.team_name = Localize(_get_teams_ui_settings.display_name)
	team_1_info.content.team_side = Localize("vs_lobby_your_team")
	self._widgets_by_name.team_2_banner.content.texture_id = var_12_1.opponent_flag_long_texture

	local team_2_info = self._widgets_by_name.team_2_info

	team_2_info.content.team_name = Localize(var_12_1.display_name)
	team_2_info.content.team_side = Localize("vs_lobby_enemy_team")
end

VersusRoundEndScreenUI._setup_top_detail_banner = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local var_13_0 = LevelSettings[arg_13_1]
	local display_name = var_13_0.display_name

	self._widgets_by_name.level_name.content.text = Localize(display_name)
	self._widgets_by_name.level_image.content.icon = var_13_0.level_image

	local _get_current_set = self:_get_current_set()
	local num_sets = VersusObjectiveSettings[arg_13_1].num_sets

	self._widgets_by_name.round_counter.content.text = string.format(Localize("versus_round_count"), _get_current_set, num_sets)
end

VersusRoundEndScreenUI._setup_total_score_progress_bars_widgets = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local max_score = VersusObjectiveSettings[arg_14_1].max_score
	local get_total_score = self._win_conditions:get_total_score(arg_14_2)
	local get_total_score_2 = self._win_conditions:get_total_score(arg_14_3)
	local flag = get_total_score_2 < get_total_score
	local flag_2 = get_total_score < get_total_score_2
	local create_total_score_progress_bar = UIWidgets.create_total_score_progress_bar("team_1_total_score", scenegraph_definition.team_1_total_score.size, max_score, get_total_score, true)
	local var_14_6 = UIWidget.init(create_total_score_progress_bar)

	self._widgets[#self._widgets + 1] = var_14_6
	self._widgets_by_name.team_1_total_score = var_14_6

	local content = var_14_6.content

	content.bar_fill_threashold = get_total_score / max_score
	content.is_winning = flag

	local create_total_score_progress_bar_2 = UIWidgets.create_total_score_progress_bar("team_2_total_score", scenegraph_definition.team_2_total_score.size, max_score, get_total_score_2, false)
	local var_14_9 = UIWidget.init(create_total_score_progress_bar_2)

	self._widgets[#self._widgets + 1] = var_14_9
	self._widgets_by_name.team_2_total_score = var_14_9

	local content_2 = var_14_9.content

	content_2.bar_fill_threashold = get_total_score_2 / max_score
	content_2.is_winning = flag_2

	local _get_teams_ui_settings, var_14_12 = self:_get_teams_ui_settings(arg_14_2, arg_14_3)
	local total_score_bg = self._widgets_by_name.total_score_bg

	total_score_bg.content.team_1_icon = _get_teams_ui_settings.team_icon
	total_score_bg.content.team_2_icon = var_14_12.team_icon

	local var_14_14

	if not flag then
		var_14_14 = UIWidgets.create_simple_texture("winner_icon", "team_1_winner")
	elseif not flag_2 then
		var_14_14 = UIWidgets.create_simple_texture("winner_icon", "team_2_winner")
	end

	if not var_14_14 then
		local var_14_15 = UIWidget.init(var_14_14)

		self._widgets[#self._widgets + 1] = var_14_15
		self._widgets_by_name.winner_team_crown = var_14_15
	end

	local str = ""

	self._widgets_by_name.team_wining_status_text.content.text = str
end

VersusRoundEndScreenUI._get_current_set = function (self)
	-- function 15
	local get_current_round = self._win_conditions:get_current_round()

	return math.round(get_current_round / 2)
end

VersusRoundEndScreenUI._get_close_to_winning_score = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local _get_current_set = self:_get_current_set()
	local _get_round_count = self:_get_round_count()
	local _num_rounds = self._num_rounds
	local max_score = VersusObjectiveSettings[arg_16_1].max_score
	local get_total_score = self._win_conditions:get_total_score(arg_16_2)
	local get_sets_data_for_party = self._win_conditions:get_sets_data_for_party(arg_16_2)
	local get_total_score_2 = self._win_conditions:get_total_score(arg_16_3)
	local get_sets_data_for_party_2 = self._win_conditions:get_sets_data_for_party(arg_16_3)
	local var_16_8 = max_score
	local var_16_9 = max_score
	local local_player = Managers.player:local_player()
	local side = Managers.state.side

	side = not side and Managers.state.side:get_side_from_player_unique_id(local_player:unique_id())

	local flag = not side and side:name() == "heroes"
	local get_state = Managers.mechanism:get_state()
	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode()

	local flag_2

	flag_2 = not game_mode and game_mode:match_in_round_over_state()

	local flag_3 = false
	local flag_4 = false

	if _get_round_count % _get_current_set ~= 0 then
		flag_3 = flag
		flag_4 = not flag
	elseif _get_round_count % _get_current_set == 0 then
		flag_3 = true
		flag_4 = true
	end

	local is_final_round = self._win_conditions:is_final_round()

	for i = 1, _num_rounds do
		local var_16_19 = get_sets_data_for_party[i]
		local var_16_20 = get_sets_data_for_party_2[i]

		if i < _get_current_set then
			local num = var_16_19.max_points - var_16_19.claimed_points

			num = num or 0
			var_16_8 = var_16_8 - num
			var_16_9 = var_16_9 - (var_16_20.max_points - var_16_20.claimed_points or 0)
		end
	end

	local flag_5 = not (var_16_8 < var_16_9) or not var_16_8 or var_16_9
	local num_2 = flag_5 - get_total_score
	local num_3 = flag_5 - get_total_score_2
	local num_4

	if _num_rounds >= _get_current_set + 1 then
		num_4 = _get_current_set + 1

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = _num_rounds

	::label_16_0::

	local num_5 = 0
	local num_6 = 0

	if not flag_3 and not flag_4 then
		local num_7 = get_total_score_2 + get_sets_data_for_party_2[num_4].max_points
		local num_8 = get_total_score + get_sets_data_for_party[num_4].max_points
	else
		local var_16_30 = get_sets_data_for_party_2[_get_current_set]
		local num_9 = get_total_score_2 + (var_16_30.max_points - var_16_30.claimed_points)
		local var_16_32 = get_sets_data_for_party[_get_current_set]
		local num_10 = get_total_score + (var_16_32.max_points - var_16_32.claimed_points)
	end

	if not (_get_round_count + 1 == self._num_rounds * 2) then
		if not flag then
			return arg_16_3, num_3 + 1
		else
			return arg_16_2, num_2 + 1
		end
	end

	if num_2 < num_3 then
		if num_2 < get_sets_data_for_party[num_4].max_points then
			return arg_16_2, num_2 + 1
		end
	elseif num_3 < num_2 then
		if num_3 < get_sets_data_for_party_2[num_4].max_points then
			return arg_16_3, num_3 + 1
		end
	elseif num_2 < get_sets_data_for_party[num_4].max_points then
		return arg_16_2, num_2 + 1
	end

	return nil, nil
end
