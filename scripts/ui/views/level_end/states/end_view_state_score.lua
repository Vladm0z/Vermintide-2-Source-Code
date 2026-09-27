-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_score_definitions")
local widgets = var_0_0.widgets
local player_score_size = var_0_0.player_score_size
local hero_widgets = var_0_0.hero_widgets
local score_widgets = var_0_0.score_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local num = 16
local flag = false

EndViewStateScore = class(EndViewStateScore)
EndViewStateScore.NAME = "EndViewStateScore"

EndViewStateScore.on_enter = function (self, arg_1_1)
	-- function 1
	print("[PlayState] Enter Substate EndViewStateScore")

	self.parent = arg_1_1.parent
	self.game_won = arg_1_1.game_won
	self.game_mode_key = arg_1_1.game_mode_key

	local context = arg_1_1.context

	self._context = context
	self.ui_renderer = context.ui_top_renderer
	self.input_manager = context.input_manager
	self.statistics_db = context.statistics_db
	self.rewards = context.rewards
	self.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self.world_previewer = arg_1_1.world_previewer
	self.platform = PLATFORM
	self.peer_id = context.peer_id
	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1)

	if not arg_1_1.initial_state then
		self._initial_preview = true
		arg_1_1.initial_state = nil
	end

	self:_start_transition_animation("on_enter", "transition_enter")

	self._exit_timer = nil

	local players_session_score = self._context.players_session_score

	self:_setup_player_scores(players_session_score)
	self:_setup_level_widget()
	self:_play_sound("play_gui_mission_summary_team_summary_enter")
end

EndViewStateScore.exit = function (self, arg_2_1)
	-- function 2
	self._exit_started = true

	self:_start_transition_animation("on_enter", "transition_exit")
end

EndViewStateScore.exit_done = function (self)
	-- function 3
	local _exit_started = self._exit_started

	_exit_started = not _exit_started and self._animations.on_enter == nil

	return _exit_started
end

EndViewStateScore.create_ui_elements = function (self, arg_4_1)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)
	self._hero_widgets = {
		UIWidget.init(hero_widgets.player_frame_1),
		UIWidget.init(hero_widgets.player_frame_2),
		UIWidget.init(hero_widgets.player_frame_3),
		UIWidget.init(hero_widgets.player_frame_4)
	}
	self._score_widgets = {
		UIWidget.init(score_widgets.player_score_1),
		UIWidget.init(score_widgets.player_score_2),
		UIWidget.init(score_widgets.player_score_3),
		UIWidget.init(score_widgets.player_score_4)
	}

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	self:_create_gamepad_elements()
end

EndViewStateScore._create_gamepad_elements = function (self)
	-- function 5
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local str = "player_panel_1"
	local size = self.ui_scenegraph[str].size
	local tbl = {
		-frame_outer_glow_01.texture_sizes.vertical[1],
		-frame_outer_glow_01.texture_sizes.horizontal[2],
		0
	}
	local tbl_2 = {
		size[1] + frame_outer_glow_01.texture_sizes.vertical[1] * 2,
		size[2] + frame_outer_glow_01.texture_sizes.horizontal[2] * 2
	}
	local tbl_3 = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl,
		size = tbl_2
	}

	self._gamepad_selection_screen = UIWidget.init(UIWidgets.create_simple_frame(frame_outer_glow_01.texture, frame_outer_glow_01.texture_size, frame_outer_glow_01.texture_sizes.corner, frame_outer_glow_01.texture_sizes.vertical, frame_outer_glow_01.texture_sizes.horizontal, "player_panel_1", tbl_3))
	self._current_gamepad_selection = 1
end

EndViewStateScore._wanted_state = function (self)
	-- function 6
	return (self.parent:wanted_menu_state())
end

EndViewStateScore.set_input_manager = function (self, arg_7_1)
	-- function 7
	self.input_manager = arg_7_1
end

EndViewStateScore.on_exit = function (self, arg_8_1)
	-- function 8
	print("[PlayState] Exit Substate EndViewStateScore")

	self.ui_animator = nil
end

EndViewStateScore.done = function (arg_9_0)
	-- function 9
	return false
end

EndViewStateScore._update_transition_timer = function (self, arg_10_1)
	-- function 10
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_10_1, 0)
	end
end

EndViewStateScore.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not flag then
		flag = false

		self:create_ui_elements()

		local players_session_score = self._context.players_session_score

		self:_setup_player_scores(players_session_score)
	end

	local get_service = self.input_manager:get_service("end_of_level")

	self:draw(get_service, arg_11_1)
	self:_update_transition_timer(arg_11_1)

	local _wanted_state = self:_wanted_state()

	if self._transition_timer or _wanted_state or not self._new_state then
		self.parent:clear_wanted_menu_state()

		return _wanted_state or self._new_state
	end

	self:_update_entry_hover(arg_11_1)
	self.ui_animator:update(arg_11_1)
	self:_update_animations(arg_11_1)
	self:_update_gamepad_input(arg_11_1, get_service)

	if not (self.parent:transitioning() or self._transition_timer) then
		self:_handle_input(arg_11_1, arg_11_2)
	end
end

EndViewStateScore.post_update = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	return
end

EndViewStateScore._update_gamepad_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not (not Managers.input:is_device_active("gamepad") and self.parent:input_enabled()) then
		return
	end

	local flag = not Managers.account:offline_mode()
	local _current_gamepad_selection = self._current_gamepad_selection
	local _current_gamepad_selection_2 = self._current_gamepad_selection

	if not arg_13_2:get("move_left") then
		_current_gamepad_selection = math.max(_current_gamepad_selection - 1, 1)
	elseif not arg_13_2:get("move_right") then
		_current_gamepad_selection = math.min(_current_gamepad_selection + 1, 4)
	elseif not arg_13_2:get("confirm_press") then
		local var_13_3 = self._players_by_widget_index[_current_gamepad_selection]

		if not var_13_3 and not var_13_3.is_player_controlled and not flag then
			self:show_gamercard(var_13_3.peer_id)
		end
	end

	if _current_gamepad_selection ~= _current_gamepad_selection_2 then
		self._gamepad_selection_screen.scenegraph_id = "player_panel_" .. _current_gamepad_selection
		self._current_gamepad_selection = _current_gamepad_selection

		local var_13_4 = self._players_by_widget_index[_current_gamepad_selection]

		if not var_13_4 and not var_13_4.is_player_controlled and not flag then
			self.parent:set_input_description("profile_available")
		else
			self.parent:set_input_description(nil)
		end
	end
end

EndViewStateScore.show_gamercard = function (self, arg_14_1)
	-- function 14
	if not arg_14_1 then
		if not IS_WINDOWS and not rawget(_G, "Steam") then
			local id_hex_to_dec = Steam.id_hex_to_dec(arg_14_1)
			local str = "http://steamcommunity.com/profiles/" .. id_hex_to_dec

			Steam.open_url(str)
		elseif not IS_XB1 then
			if not self._context.lobby and not self._context.lobby.lobby then
				local xuid = self._context.lobby:xuid(arg_14_1)

				if not xuid then
					Managers.account:show_player_profile(xuid)
				end
			end
		elseif not IS_PS4 then
			Managers.account:show_player_profile_with_account_id(arg_14_1)
		end
	end
end

EndViewStateScore._update_animations = function (self, arg_15_1)
	-- function 15
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_15_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

EndViewStateScore._update_entry_hover = function (self)
	-- function 16
	local var_16_0
	local content = self._widgets_by_name.scores_topics.content
	local num_rows = content.num_rows

	for i = 1, num_rows do
		local str = "_" .. i
		local var_16_4 = content["hotspot" .. str]

		if not var_16_4 and not var_16_4.is_hover and not content["row_bg" .. str].has_score then
			var_16_0 = i

			break
		end
	end

	if var_16_0 ~= self._current_topic_hover_index then
		self:_set_entry_hover_index(var_16_0)

		self._current_topic_hover_index = var_16_0
	end
end

EndViewStateScore._set_entry_hover_index = function (self, arg_17_1)
	-- function 17
	local _widgets_by_name = self._widgets_by_name
	local _score_widgets = self._score_widgets

	for i, v in ipairs(_score_widgets) do
		v.content.hover_index = arg_17_1
	end

	_widgets_by_name.scores_topics.content.hover_index = arg_17_1
end

EndViewStateScore._handle_input = function (self, arg_18_1, arg_18_2)
	-- function 18
	if not Development.parameter("tobii_button") then
		self:_handle_tobii_button(arg_18_1)
	end
end

EndViewStateScore._handle_tobii_button = function (self, arg_19_1)
	-- function 19
	local tobii_button = self._widgets_by_name.tobii_button

	UIWidgetUtils.animate_default_button(tobii_button, arg_19_1)

	if not self:_is_button_hover_enter(tobii_button) then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	if not self:_is_button_pressed(tobii_button) then
		self:_play_sound("play_gui_start_menu_button_click")

		local str = "https://vermintide2beta.com/?utm_medium=referral&utm_campaign=vermintide2beta&utm_source=ingame#challenge"

		Application.open_url_in_browser(str)
	end
end

EndViewStateScore._is_button_pressed = function (arg_20_0, arg_20_1)
	-- function 20
	local button_hotspot = arg_20_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

EndViewStateScore._is_button_hover_enter = function (arg_21_0, arg_21_1)
	-- function 21
	return arg_21_1.content.button_hotspot.on_hover_enter
end

EndViewStateScore.draw = function (self, arg_22_1, arg_22_2)
	-- function 22
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local render_settings = self.render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_22_1, arg_22_2, nil, render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	for i_2, v_2 in ipairs(self._hero_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_2)
	end

	for i_3, v_3 in ipairs(self._score_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_3)
	end

	if not is_device_active and not self.parent:input_enabled() then
		UIRenderer.draw_widget(ui_renderer, self._gamepad_selection_screen)
	end

	UIRenderer.end_pass(ui_renderer)
end

EndViewStateScore._start_transition_animation = function (self, arg_23_1, arg_23_2)
	-- function 23
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings,
		self = self
	}
	local _hero_widgets = self._hero_widgets
	local start_animation = self.ui_animator:start_animation(arg_23_2, _hero_widgets, scenegraph_definition, tbl)

	self._animations[arg_23_1] = start_animation
end

EndViewStateScore._animate_element_by_time = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	-- function 24
	return (UIAnimation.init(UIAnimation.function_by_time, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, math.ease_out_quad))
end

EndViewStateScore._animate_element_by_catmullrom = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8)
	-- function 25
	return (UIAnimation.init(UIAnimation.catmullrom, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8))
end

EndViewStateScore._transform_player_session_score = function (arg_26_0, arg_26_1)
	-- function 26
	local tbl = {
		group_scores = {}
	}

	for k, v in pairs(arg_26_1) do
		for k_2, v_2 in pairs(v.group_scores) do
			if not tbl.group_scores[k_2] then
				tbl.group_scores[k_2] = {}
			end

			for i, v_3 in ipairs(v_2) do
				if not tbl.group_scores[k_2][i] then
					tbl.group_scores[k_2][i] = {
						player_scores = {}
					}
				end

				local highscore = tbl.group_scores[k_2][i].highscore

				highscore = highscore or 0
				tbl.group_scores[k_2][i].stat_name = v_3.stat_name
				tbl.group_scores[k_2][i].display_name = v_3.display_name

				local var_26_2 = tbl.group_scores[k_2][i]
				local score

				if highscore < v_3.score then
					score = v_3.score

					if not score then
						-- Nothing
					end
				end

				score = highscore

				::label_26_0::

				var_26_2.highscore = score
				tbl.group_scores[k_2][i].player_scores[k] = v_3.score
			end
		end
	end

	return tbl
end

EndViewStateScore._group_scores_by_player_and_topic = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	for k, v in pairs(arg_27_2.group_scores) do
		if not arg_27_1[k] then
			arg_27_1[k] = {}
		end

		local num = 0

		for i, v_2 in ipairs(v) do
			if not arg_27_1[k][i] then
				arg_27_1[k][i] = {
					player_scores = {}
				}
			end

			local highscore = arg_27_1[k][i].highscore

			highscore = highscore or 0

			local stat_name = v_2.stat_name

			arg_27_1[k][i].stat_name = stat_name
			arg_27_1[k][i].display_text = v_2.display_text
			arg_27_1[k][i].player_scores[arg_27_3] = v_2.score

			if stat_name == "damage_taken" then
				local score

				if highscore > v_2.score then
					score = v_2.score

					if not score then
						-- Nothing
					end
				end

				score = highscore

				::label_27_0::

				arg_27_1[k][i].highscore = score
			else
				local score_2

				if highscore < v_2.score then
					score_2 = v_2.score

					if not score_2 then
						-- Nothing
					end
				end

				score_2 = highscore

				::label_27_1::

				arg_27_1[k][i].highscore = score_2
			end
		end
	end
end

EndViewStateScore._setup_player_scores = function (self, arg_28_1)
	-- function 28
	local tbl = {}
	local tbl_2 = {}
	local num = 1
	local num_2 = 1

	self._players_by_widget_index = {}

	local _players_by_widget_index = self._players_by_widget_index
	local num_3 = 0
	local _hero_widgets = self._hero_widgets

	for k, v in pairs(arg_28_1) do
		self:_set_topic_data(v, num)
		self:_group_scores_by_player_and_topic(tbl, v, num)

		tbl_2[num] = v.name
		_players_by_widget_index[num] = v

		local peer_id = v.peer_id
		local profile_index = v.profile_index
		local career_index = v.career_index
		local portrait_image = SPProfiles[profile_index].careers[career_index].portrait_image
		local portrait_frame = v.portrait_frame

		portrait_frame = portrait_frame or "default"

		local player_level = v.player_level
		local is_player_controlled = v.is_player_controlled

		if not IS_WINDOWS and not peer_id and not is_player_controlled then
			num_3 = num_3 + 1
		end

		local var_28_14

		if not is_player_controlled then
			if not player_level then
				var_28_14 = tostring(player_level)

				if not var_28_14 then
					-- Nothing
				end
			end

			var_28_14 = "-"
		else
			var_28_14 = "BOT"
		end

		::label_28_0::

		local create_portrait_frame = UIWidgets.create_portrait_frame("player_frame_" .. num, portrait_frame, var_28_14, 1, nil, portrait_image)

		_hero_widgets[num] = UIWidget.init(create_portrait_frame, self.ui_renderer)
		num = num + 1
	end

	if not IS_WINDOWS then
		Presence.set_presence("steam_player_group_size", num_3)
	end

	self:_setup_score_panel(tbl, tbl_2)
end

EndViewStateScore._setup_level_widget = function (self)
	-- function 29
	local content = self._widgets_by_name.level.content
	local level_key = self._context.level_key
	local var_29_2 = LevelSettings[level_key]
	local level_image

	if not var_29_2 then
		level_image = var_29_2.level_image

		if not level_image then
			-- Nothing
		end
	end

	level_image = "level_image_any"

	::label_29_0::

	content.icon = level_image

	local difficulty = self._context.difficulty
	local var_29_5 = DifficultySettings[difficulty]
	local completed_frame_texture

	if not var_29_5 then
		completed_frame_texture = var_29_5.completed_frame_texture

		if not completed_frame_texture then
			-- Nothing
		end
	end

	completed_frame_texture = "map_frame_00"

	::label_29_1::

	content.frame = completed_frame_texture
end

local tbl = {
	Colors.get_color_table_with_alpha("cyan", 255),
	Colors.get_color_table_with_alpha("gold", 255),
	Colors.get_color_table_with_alpha("silver", 255),
	Colors.get_color_table_with_alpha("gray", 255)
}
local tbl_2 = {
	nil,
	"scoreboard_topic_02",
	"scoreboard_topic_03",
	"scoreboard_topic_04"
}

EndViewStateScore._set_topic_data = function (self, arg_30_1, arg_30_2)
	-- function 30
	local var_30_0 = self._score_widgets[arg_30_2]
	local content = var_30_0.content
	local style = var_30_0.style
	local num = 0
	local group_scores = arg_30_1.group_scores

	for k, v in pairs(group_scores) do
		local num_2 = 0

		for i, v_2 in ipairs(v) do
			num_2 = num_2 + v_2.score
			num = num + v_2.score
		end

		v.total_score = num_2
	end
end

EndViewStateScore._setup_score_panel = function (self, arg_31_1, arg_31_2)
	-- function 31
	local num_2 = 30
	local num_3 = 22
	local num_4 = 1
	local num_5 = 1
	local _score_widgets = self._score_widgets

	for k, v in pairs(arg_31_1) do
		local str = "title_text_" .. tostring(num_4)
		local str_2 = "horizontal_divider_" .. tostring(num_4)

		if num_4 == 1 then
			for i, v_2 in ipairs(arg_31_2) do
				local str_3 = "score_player_" .. tostring(i) .. "_" .. tostring(num_4)
				local var_31_8 = _score_widgets[i]
				local content = var_31_8.content
				local style = var_31_8.style
				local str_4 = "_" .. num_4
				local str_5 = "score_text" .. str_4
				local var_31_13 = content["row_bg" .. str_4]
				local crop_text_width

				if Utf8.length(v_2) > num then
					crop_text_width = UIRenderer.crop_text_width(self.ui_renderer, v_2, player_score_size[1] - 40, style[str_5])

					if not crop_text_width then
						-- Nothing
					end
				end

				crop_text_width = v_2

				::label_31_0::

				var_31_13[str_5] = crop_text_width
			end

			num_4 = num_4 + 1
		end

		for i_2, v_3 in ipairs(v) do
			local stat_name = v_3.stat_name
			local round = math.round(v_3.highscore)
			local player_scores = v_3.player_scores

			for i_3, v_4 in ipairs(player_scores) do
				local var_31_18 = _score_widgets[i_3]
				local content_2 = var_31_18.content
				local style_2 = var_31_18.style

				v_4 = math.round(v_4)

				local str_6 = "title_text_" .. tostring(num_4)
				local str_7 = "score_player_" .. tostring(i_3) .. "_" .. tostring(num_4)
				local str_8 = "high_score_marker_" .. tostring(i_3) .. "_" .. tostring(num_4)
				local str_9 = "horizontal_divider_" .. tostring(num_4)
				local str_10 = "row_bg_" .. tostring(num_4)
				local flag = false

				if stat_name == "damage_taken" then
					flag = v_4 <= round
				else
					flag = not (round <= v_4) or round > 0
				end

				local flag_2 = false
				local str_11 = "_" .. num_4
				local str_12 = "score_text" .. str_11
				local var_31_30 = content_2["row_bg" .. str_11]

				var_31_30[str_12] = v_4
				var_31_30.has_background = num_4 % 2 == 0
				var_31_30.has_highscore = flag
				var_31_30.has_score = true

				self:_set_score_topic_by_row(num_4, Localize(v_3.display_text))
			end

			num_4 = num_4 + 1
		end

		num_5 = num_5 + 1
	end
end

EndViewStateScore._set_score_topic_by_row = function (self, arg_32_1, arg_32_2)
	-- function 32
	local content = self._widgets_by_name.scores_topics.content
	local str = "_" .. arg_32_1
	local str_2 = "score_text" .. str
	local var_32_3 = content["row_bg" .. str]

	var_32_3[str_2] = arg_32_2
	var_32_3.has_score = true
	var_32_3.has_background = arg_32_1 % 2 == 0
end

EndViewStateScore._setup_hero_score_tooltip = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local tooltip = arg_33_1.content.tooltip
	local tooltip_2 = arg_33_1.style.tooltip
	local text_styles = tooltip_2.text_styles
	local value_styles = tooltip_2.value_styles

	table.clear(text_styles)
	table.clear(value_styles)
	table.clear(tooltip)

	for k, v in pairs(arg_33_2) do
		tooltip[k] = k

		local str = k .. "_value"

		tooltip[str] = v.total_score
		text_styles[#text_styles + 1] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			font_size = 20,
			font_type = "hell_shark",
			word_wrap = true,
			name = k,
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			value_style = {
				vertical_alignment = "top",
				word_wrap = true,
				horizontal_alignment = "right",
				font_size = 20,
				font_type = "hell_shark",
				name = str,
				text_color = Colors.get_color_table_with_alpha("font_title", 255)
			}
		}

		for i, v_2 in ipairs(v) do
			local stat_name = v_2.stat_name
			local score = v_2.score
			local display_text = v_2.display_text

			tooltip[stat_name] = Localize(display_text) .. ":"

			local str_2 = stat_name .. "_value"

			tooltip[str_2] = tostring(score)
			text_styles[#text_styles + 1] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = 20,
				font_type = "hell_shark",
				word_wrap = true,
				name = stat_name,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				value_style = {
					vertical_alignment = "top",
					word_wrap = true,
					horizontal_alignment = "right",
					font_size = 20,
					font_type = "hell_shark",
					name = str_2,
					text_color = Colors.get_color_table_with_alpha("font_default", 255)
				}
			}
		end
	end
end

EndViewStateScore._player_score_data_by_stats_id = function (self, arg_34_1)
	-- function 34
	return self._players_list[arg_34_1]
end

EndViewStateScore._get_player_position_in_score_table = function (arg_35_0, arg_35_1, arg_35_2)
	-- function 35
	for i, v in ipairs(arg_35_2.scores) do
		if v.stats_id == arg_35_1 then
			return i
		end
	end
end

EndViewStateScore._start_hero_score_animation = function (self, arg_36_1)
	-- function 36
	local tbl = {
		wwise_world = self.wwise_world
	}

	return self.ui_animator:start_animation(arg_36_1, self._hero_widgets, scenegraph_definition, tbl)
end

EndViewStateScore._play_sound = function (self, arg_37_1)
	-- function 37
	self.parent:play_sound(arg_37_1)
end
