-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report.lua

local var_0_0 = local_require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report_definitions")

EndViewStateScoreVSTabReport = class(EndViewStateScoreVSTabReport)
EndViewStateScoreVSTabReport.NAME = "EndViewStateScoreVSTabReport"

local num = 5
local size = var_0_0.scenegraph_definition.hero_progress_item_anchor.size
local num_2 = 10

EndViewStateScoreVSTabReport.on_enter = function (self, arg_1_1)
	-- function 1
	print("[EndViewStateVS] Enter Substate EndViewStateScoreVSTabReport")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local context = arg_1_1.context

	self._context = context
	self._wwise_world = context.wwise_world
	self._ui_renderer = context.ui_renderer
	self._ui_top_renderer = context.ui_top_renderer
	self._input_manager = context.input_manager
	self._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._progression_presentation_done = self._context.progression_presentation_done
	self._animations = {}
	self._ui_animations = {}
	self._animation_callbacks = {}
	self._challenge_entry_widgets = {}
	self._level_up_item_index = 1

	self:_extract_rewards()
	self:_extract_hero_data()
	self:_create_ui_elements(self._params)

	self._reward_popup = RewardPopupUI:new(context)

	if not self._progression_presentation_done then
		self:_show_final_progression()
	else
		self:_initialize_entries()
		self:_start_transition_animation("on_enter", "on_enter")
	end

	self._parent:hide_team()
	self:_trigger_telemetry_events()
end

EndViewStateScoreVSTabReport._show_final_progression = function (self)
	-- function 2
	self:_initialize_entries()
	self:_gather_challenge_progression()
	self:_set_hero_progression()
	self:_start_transition_animation("on_enter_forced", "on_enter_forced")
	self:_start_transition_animation("animate_hero_progress", "animate_hero_progress_forced")
	self._parent:activate_back_to_keep_button()
end

EndViewStateScoreVSTabReport._set_hero_progression = function (self)
	-- function 3
	local local_player_hero_name = self._context.local_player_hero_name
	local get_experience = ExperienceSettings.get_experience(local_player_hero_name)
	local get_experience_pool = ExperienceSettings.get_experience_pool(local_player_hero_name)

	self._current_level = self:_set_current_experience(get_experience + get_experience_pool)
	self._widgets_by_name.portrait.content.level = self._current_level

	local var_3_3 = self._level_start[1]
	local num = self._current_level + self._extra_levels
	local num_2 = num + table.size(self._level_up_rewards)

	for i = num, num_2 do
		local var_3_6 = self._level_up_rewards[i]

		if not var_3_6 then
			self:_handle_rewards(var_3_6)
		end
	end
end

EndViewStateScoreVSTabReport._extract_hero_data = function (self)
	-- function 4
	local peer_id = Network.peer_id()
	local num = 1
	local str = peer_id .. ":" .. num
	local var_4_3 = self._player_session_scores[str]

	self._profile_index = var_4_3.profile_index
	self._career_index = var_4_3.career_index

	local var_4_4 = SPProfiles[self._profile_index]

	self._hero_name = Localize(var_4_4.character_name)

	local var_4_5 = var_4_4.careers[self._career_index]

	self._career_name = Localize(var_4_5.name)
end

EndViewStateScoreVSTabReport._extract_rewards = function (self)
	-- function 5
	self._game_won = self._context.game_won
	self._rewards = self._context.rewards
	self._level_up_rewards = self._params.parent.level_up_rewards
	self._versus_level_up_rewards = self._params.parent.versus_level_up_rewards
	self._level_start = self._rewards.level_start
	self._versus_level_start = self._rewards.versus_level_start
	self._mission_results = self._rewards.mission_results
	self._player_session_scores = self._context.players_session_score
	self._challenge_progression_status = self._context.challenge_progression_status
end

EndViewStateScoreVSTabReport._trigger_telemetry_events = function (self)
	-- function 6
	if not MODDED_REALM then
		return
	end

	local var_6_0 = self._versus_level_start[1]
	local var_6_1 = self._versus_level_start[2]

	Managers.telemetry_events:start_versus_experience(var_6_0, var_6_1)

	local get_versus_experience = ExperienceSettings.get_versus_experience()

	Managers.telemetry_events:versus_experience_gained(get_versus_experience - var_6_1)

	local get_versus_level_from_experience, var_6_4, var_6_5 = ExperienceSettings.get_versus_level_from_experience(var_6_1 + self._total_experience_gained)

	Managers.telemetry_events:versus_level_gained(var_6_0, get_versus_level_from_experience)

	local num = 0

	for k, v in pairs(self._versus_level_up_rewards) do
		for k_2, v_2 in pairs(v) do
			if v_2.currency == "VS" then
				num = num + v_2.awarded
			end
		end
	end

	Managers.telemetry_events:versus_currency_gained(num)
end

EndViewStateScoreVSTabReport._setup_hero_progression = function (self)
	-- function 7
	local _level_start = self._level_start
	local var_7_1 = _level_start[1]
	local var_7_2 = _level_start[2]
	local var_7_3 = _level_start[3]

	self._progress_data = self:_get_total_experience_progress_data(var_7_2, var_7_3)

	if self._progress_data.bonus_experience > 0 then
		self._extra_levels = self._extra_levels + self._progress_data.start_extra_level
	end

	self._experience_presentation_completed = self._progression_presentation_done
end

EndViewStateScoreVSTabReport._get_total_experience_progress_data = function (self, arg_8_1, arg_8_2)
	-- function 8
	local get_level, var_8_1 = ExperienceSettings.get_level(arg_8_1)
	local get_extra_level, var_8_3 = ExperienceSettings.get_extra_level(arg_8_2)
	local local_player_hero_name = self._context.local_player_hero_name
	local get_experience = ExperienceSettings.get_experience(local_player_hero_name)
	local get_level_2, var_8_7 = ExperienceSettings.get_level(get_experience)
	local get_experience_pool = ExperienceSettings.get_experience_pool(local_player_hero_name)
	local get_extra_level_2, var_8_10 = ExperienceSettings.get_extra_level(get_experience_pool)
	local num = get_level + get_extra_level
	local num_2 = get_level_2 + get_extra_level_2
	local num_3 = 0

	if not (get_level == ExperienceSettings.max_level or get_level_2 ~= ExperienceSettings.max_level) then
		var_8_7 = var_8_3
		num_3 = ExperienceSettings.get_experience_required_for_level(ExperienceSettings.max_level) * var_8_3
	end

	local num_4 = num_2 - num + (var_8_7 - var_8_1) + (var_8_10 - var_8_3)
	local num_5 = get_experience - arg_8_1 + (get_experience_pool - arg_8_2) + num_3

	if get_level == ExperienceSettings.max_level then
		arg_8_1 = arg_8_1 + arg_8_2
		var_8_1 = var_8_3
	end

	local bar_progress_min_time = UISettings.summary_screen.bar_progress_min_time
	local bar_progress_max_time = UISettings.summary_screen.bar_progress_max_time
	local bar_progress_experience_time_multiplier = UISettings.summary_screen.bar_progress_experience_time_multiplier
	local min = math.min(math.max(bar_progress_experience_time_multiplier * num_5, bar_progress_min_time), bar_progress_max_time)

	return {
		time = 0,
		complete = false,
		current_experience = arg_8_1,
		experience_to_add = num_5,
		total_progress = num_4,
		start_progress = var_8_1,
		start_extra_level = get_extra_level,
		bonus_experience = num_3,
		total_time = min
	}
end

EndViewStateScoreVSTabReport._play_sound = function (self, arg_9_1)
	-- function 9
	self._parent:play_sound(arg_9_1)
end

EndViewStateScoreVSTabReport._set_global_wwise_parameter = function (self, arg_10_1, arg_10_2)
	-- function 10
	WwiseWorld.set_global_parameter(self._wwise_world, arg_10_1, arg_10_2)
end

EndViewStateScoreVSTabReport._initialize_entries = function (self)
	-- function 11
	self:_create_summary_entries(self._game_won)
	self:_populate_hero_progression()
end

EndViewStateScoreVSTabReport._populate_hero_progression = function (self)
	-- function 12
	local peer_id = Network.peer_id()
	local num = 1
	local str = peer_id .. ":" .. num
	local var_12_3 = self._player_session_scores[str]
	local profile_index = var_12_3.profile_index
	local career_index = var_12_3.career_index
	local str_2 = "portrait"
	local portrait_frame = var_12_3.portrait_frame
	local _level_start = self._level_start
	local var_12_9 = _level_start[1]
	local var_12_10 = _level_start[2]
	local var_12_11 = _level_start[3]
	local get_level = ExperienceSettings.get_level(var_12_10)
	local num_2 = var_12_10 + var_12_11

	if get_level < ExperienceSettings.max_level then
		num_2 = var_12_10
	end

	self._widgets_by_name.experience_gained_text.content.text = string.format(var_0_0.summary_value_string, self._total_experience_gained)
	self._current_level, self._extra_levels = self:_set_current_experience(num_2)

	local var_12_14 = tostring(self._current_level)
	local num_3 = 1
	local flag = false
	local get_portrait_image_by_profile_index

	if not career_index then
		get_portrait_image_by_profile_index = UIUtils.get_portrait_image_by_profile_index(profile_index, career_index)

		if not get_portrait_image_by_profile_index then
			-- Nothing
		end
	end

	get_portrait_image_by_profile_index = "unit_frame_portrait_default"

	::label_12_0::

	local create_portrait_frame = UIWidgets.create_portrait_frame(str_2, portrait_frame, var_12_14, num_3, flag, get_portrait_image_by_profile_index)
	local var_12_19 = UIWidget.init(create_portrait_frame)

	self._widgets_by_name.portrait = var_12_19
	self._hero_progress_widgets[#self._hero_progress_widgets + 1] = var_12_19

	local var_12_20 = SPProfiles[profile_index]
	local var_12_21 = Localize(var_12_20.character_name)
	local var_12_22 = var_12_20.careers[career_index]
	local var_12_23 = Localize(var_12_22.name)

	self._widgets_by_name.hero_name.content.text = var_12_21
	self._widgets_by_name.career_name.content.text = var_12_23
end

EndViewStateScoreVSTabReport._animate_experience_bar = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _progress_data = self._progress_data

	if not _progress_data and _progress_data.complete or arg_13_2 or self.level_up_anim_id or not self._experience_presentation_completed then
		return
	end

	if not self._playing_experience_bar_sound then
		self:_play_sound("Play_vs_hud_progression_hero_counter_loop")

		self._playing_experience_bar_sound = true
	end

	local time = _progress_data.time
	local total_time = _progress_data.total_time
	local num = time / total_time
	local smoothstep = math.smoothstep(num, 0, 1)
	local min = math.min(time + arg_13_1, total_time)

	_progress_data.time = min

	self:_set_global_wwise_parameter("summary_meter_progress", min / total_time)

	local current_experience = _progress_data.current_experience
	local experience_to_add = _progress_data.experience_to_add
	local floor = math.floor(experience_to_add * smoothstep)
	local floor_2 = math.floor(current_experience + floor)
	local _set_current_experience, var_13_11 = self:_set_current_experience(floor_2)
	local flag = _set_current_experience ~= self._current_level

	if self._extra_levels ~= nil then
		if self._progress_data.bonus_experience > 0 then
			var_13_11 = var_13_11 + self._progress_data.start_extra_level
		end

		flag = flag or var_13_11 ~= self._extra_levels
	end

	if not flag then
		self._current_level = _set_current_experience
		self._extra_levels = var_13_11
		self._level_up_anim_id = self._ui_animator:start_animation("level_up", self._widgets_by_name, var_0_0.scenegraph_definition, {
			wwise_world = self.wwise_world
		})
		self._widgets_by_name.portrait.content.level = self._current_level

		local num_2 = self._current_level + self._extra_levels
		local var_13_14 = self._level_up_rewards[num_2]

		if not var_13_14 then
			self:_handle_rewards(var_13_14)
		end

		self._playing_experience_bar_sound = false

		self:_play_sound("Stop_vs_hud_progression_hero_counter_loop")
	end

	if min == total_time then
		_progress_data.complete = true
		self._experience_presentation_completed = true

		self:_play_sound("Stop_vs_hud_progression_hero_counter_loop")
		self:_gather_challenge_progression()
	end
end

EndViewStateScoreVSTabReport._gather_challenge_progression = function (self)
	-- function 14
	local tbl = {}
	local start_progress = self._challenge_progression_status.start_progress
	local end_progress = self._challenge_progression_status.end_progress
	local num = 0
	local tbl_2 = {}

	for k, v in pairs(start_progress) do
		local var_14_5 = end_progress[k]

		if v ~= var_14_5 then
			tbl[#tbl + 1] = {
				id = k,
				start_progress = v,
				end_progress = var_14_5
			}

			local flag

			flag = not (var_14_5 >= 1) or not 1 or 0
			num = num + flag
		end
	end

	local function fn(self, arg_15_1)
		-- function 15
		return self.end_progress > arg_15_1.end_progress
	end

	table.sort(tbl, fn)
	self:_trim_trailing_group_entries(tbl)

	local challenge_progress_text = self._widgets_by_name.challenge_progress_text

	if num > 0 then
		challenge_progress_text.content.text = string.format(var_0_0.challenge_progress_text_string, num)
	else
		challenge_progress_text.content.text = Localize("achv_menu_achievements_category_title")
	end

	self:_start_transition_animation("animate_challenge_progress", "animate_challenge_progress")

	if not self._progression_presentation_done then
		self:_setup_challenge_progression_widgets(tbl)
	else
		self._animation_callbacks.animate_challenge_progress = callback(self, "_setup_challenge_progression_widgets", tbl)
	end
end

local tbl = {}

EndViewStateScoreVSTabReport._trim_trailing_group_entries = function (arg_16_0, arg_16_1)
	-- function 16
	table.clear(tbl)

	local tbl_2 = {}

	for i = 1, #arg_16_1 do
		local var_16_1 = arg_16_1[i]
		local id = var_16_1.id
		local group = AchievementTemplates.achievements[id].group

		if not group then
			if not tbl_2[group] then
				tbl_2[group] = var_16_1.end_progress < 1
			else
				tbl[#tbl + 1] = i
			end
		end
	end

	for j = #tbl, 1, -1 do
		table.remove(arg_16_1, tbl[j])
	end
end

EndViewStateScoreVSTabReport._setup_challenge_progression_widgets = function (self, arg_17_1)
	-- function 17
	local num = 25
	local var_17_1

	for i = 1, #arg_17_1 do
		local var_17_2 = arg_17_1[i]
		local num_2 = i - 1
		local tbl = {
			num_2 % 2 * 400,
			-math.floor(num_2 / 2) * (var_0_0.scenegraph_definition.challenge_entry_anchor.size[2] + num),
			0
		}
		local create_challenge_entry_func = var_0_0.create_challenge_entry_func(var_17_2.id, var_17_2.start_progress, var_17_2.end_progress, tbl, self._progression_presentation_done)
		local var_17_6 = UIWidget.init(create_challenge_entry_func)

		self._challenge_entry_widgets[#self._challenge_entry_widgets + 1] = var_17_6

		local str = "achievement_entry_" .. #self._challenge_entry_widgets

		self._widgets_by_name[str] = var_17_6

		self:_start_challenge_entry_animation(i, str)
	end

	local num_3 = math.ceil(#arg_17_1 / 2) * (var_0_0.scenegraph_definition.challenge_entry_anchor.size[2] + num) - var_0_0.scenegraph_definition.challenge_progress_anchor.size[2]

	if num_3 > 0 then
		local _ui_scenegraph = self._ui_scenegraph
		local str_2 = "challenge_entry_anchor"
		local str_3 = "challenge_progress_area"
		local flag = false
		local var_17_13
		local var_17_14

		self._scrollbar_ui = ScrollbarUI:new(_ui_scenegraph, str_2, str_3, num_3, flag, var_17_13, var_17_14)
	end

	self._parent:activate_back_to_keep_button()
end

EndViewStateScoreVSTabReport._start_challenge_entry_animation = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	if not self._progression_presentation_done then
		return
	end

	self:_play_sound("Play_vs_hud_progression_challenge_appear")

	local str = "wait_" .. arg_18_1 - 1

	if not (table.is_empty(self._animations) or arg_18_3) then
		self._animation_callbacks[str] = callback(self, "_start_challenge_entry_animation", arg_18_1, arg_18_2, true)
	else
		local tbl = {
			entry_name = arg_18_2
		}
		local str_2 = "animate_challenge_entry_" .. arg_18_1
		local str_3 = "wait_" .. arg_18_1

		self:_start_transition_animation(str_2, "animate_challenge_entry", tbl)
		self:_start_transition_animation(str_3, "wait")
	end
end

EndViewStateScoreVSTabReport._handle_rewards = function (self, arg_19_1)
	-- function 19
	local _level_up_item_index = self._level_up_item_index
	local get_interface = Managers.backend:get_interface("items")

	for i, v in ipairs(arg_19_1) do
		local backend_id = v.backend_id
		local get_item_from_id = get_interface:get_item_from_id(backend_id)
		local num_3 = _level_up_item_index - 1
		local num_4 = num_3 % num
		local floor = math.floor(num_3 / num)
		local num_5 = num_4 * size[1] + (num_4 - 1) * num_2
		local num_6 = -floor * size[2] - (floor - 1) * num_2
		local tbl = {
			num_5,
			num_6,
			0
		}
		local create_item_widget_func = var_0_0.create_item_widget_func(get_item_from_id, tbl, self._progression_presentation_done)
		local var_19_11 = UIWidget.init(create_item_widget_func)

		self._widgets[#self._widgets + 1] = var_19_11
		self._widgets_by_name["rewards_" .. _level_up_item_index] = var_19_11

		if not self._progression_presentation_done then
			local tbl_2 = {
				widget = var_19_11,
				offset = table.clone(tbl)
			}
			local flag

			flag = get_item_from_id.key == "level_chest" or get_item_from_id.key == "level_chest_lesser" or "Play_vs_hud_progression_hero_chest_appear" or "Play_vs_hud_progression_hero_item_appear"
			tbl_2.sound = flag

			if i > 1 then
				self._animation_callbacks["animate_item_" .. _level_up_item_index - 1] = callback(self, "_start_transition_animation", "animate_item_" .. _level_up_item_index, "animate_item", tbl_2)
			else
				self:_start_transition_animation("animate_item_" .. _level_up_item_index, "animate_item", tbl_2)
			end
		end

		_level_up_item_index = _level_up_item_index + 1
	end

	if not self._progression_presentation_done then
		self:_play_sound("Play_vs_hud_progression_hero_level_up")
	end

	self._level_up_item_index = _level_up_item_index
end

EndViewStateScoreVSTabReport._set_current_experience = function (self, arg_20_1)
	-- function 20
	local get_level, var_20_1 = ExperienceSettings.get_level(arg_20_1)
	local num = 0

	if get_level == ExperienceSettings.max_level then
		local num_2 = arg_20_1 - ExperienceSettings.max_experience

		num, var_20_1 = ExperienceSettings.get_extra_level(num_2)
	end

	local clamp = math.clamp(get_level + 1, 0, ExperienceSettings.max_level)

	if not ((self._progression_presentation_done or not self._current_level or get_level > self._current_level or not self._extra_levels) and not (num > self._extra_levels)) then
		var_20_1 = 1
	end

	local experience_bar = self._widgets_by_name.experience_bar
	local content = experience_bar.content
	local style = experience_bar.style
	local default_size = style.experience_bar.default_size

	style.experience_bar.size[1] = default_size[1] * var_20_1
	style.experience_bar_end.offset[1] = default_size[1] * var_20_1

	return get_level, num
end

EndViewStateScoreVSTabReport._create_summary_entries = function (self)
	-- function 21
	local _mission_results = self._mission_results
	local tbl = {}
	local num = 0
	local num_2 = 0
	local num_3 = 1

	for i, v in ipairs(_mission_results) do
		local experience = v.experience

		experience = not experience and math.round(v.experience)

		if not (not experience and not (experience > 0)) then
			local str = "summary_entry_" .. num_3
			local text = v.text
			local format_values = v.format_values
			local var_21_9

			if not text then
				if not format_values then
					var_21_9 = UIUtils.format_localized_description(text, format_values)
				else
					var_21_9 = Localize(text)
				end
			end

			local value = v.value
			local bonus = v.bonus
			local icon = v.icon
			local var_21_13

			if not experience then
				var_21_13 = tostring(experience)

				if not var_21_13 then
					-- Nothing
				end
			end

			if not value then
				var_21_13 = tostring(value)

				if not var_21_13 then
					-- Nothing
				end
			end

			var_21_13 = ""

			::label_21_0::

			local var_21_14 = var_21_9
			local str_2

			if not value then
				str_2 = " (" .. tostring(value) .. ")"

				if not str_2 then
					-- Nothing
				end
			end

			str_2 = ""

			::label_21_1::

			local str_3 = var_21_14 .. str_2
			local tbl_2 = {
				name = str,
				title_text = str_3,
				experience = experience,
				value = value,
				value_text = var_21_13,
				bonus = bonus,
				icon = icon
			}

			tbl[#tbl + 1] = tbl_2

			local create_summery_entry_func = var_0_0.create_summery_entry_func(num_3, str_3, experience, self._progression_presentation_done)
			local var_21_19 = UIWidget.init(create_summery_entry_func)

			self._widgets[#self._widgets + 1] = var_21_19
			self._widgets_by_name[str] = var_21_19
			num_2 = num_2 + experience
			num_3 = num_3 + 1
		end
	end

	self._total_experience_gained = num_2

	if not self._progression_presentation_done then
		self:_set_final_level_up_progress(num_2)
	else
		self:_setup_entry_animations(tbl, num_2)
	end
end

EndViewStateScoreVSTabReport._set_final_level_up_progress = function (self, arg_22_1)
	-- function 22
	local bar_thresholds = var_0_0.bar_thresholds
	local _versus_level_start = self._versus_level_start

	if not table.is_empty(_versus_level_start) then
		_versus_level_start[1] = ExperienceSettings.get_versus_level()
		_versus_level_start[2] = ExperienceSettings.get_versus_experience()
	end

	local var_22_2 = _versus_level_start[1]
	local var_22_3 = _versus_level_start[2]
	local get_versus_level_from_experience, var_22_5 = ExperienceSettings.get_versus_level_from_experience(var_22_3)
	local get_versus_level_from_experience_2, var_22_7, var_22_8 = ExperienceSettings.get_versus_level_from_experience(var_22_3 + arg_22_1)
	local num = get_versus_level_from_experience_2 - var_22_2
	local content = self._widgets_by_name.level_up.content

	if num > 0 then
		content.starting_progress = 0
		content.final_progress = math.lerp(bar_thresholds[1], bar_thresholds[2], var_22_7)
	elseif var_22_2 == ExperienceSettings.max_versus_level then
		content.starting_progress = 1
		content.final_progress = 1
	else
		content.starting_progress = math.lerp(bar_thresholds[1], bar_thresholds[2], var_22_5)
		content.final_progress = math.lerp(bar_thresholds[1], bar_thresholds[2], var_22_7)
	end

	content.level_text = get_versus_level_from_experience_2

	local insignia = self._widgets_by_name.insignia
	local get_insignia_texture_settings_from_level, var_22_13 = UIAtlasHelper.get_insignia_texture_settings_from_level(get_versus_level_from_experience_2)

	insignia.content.insignia_main.uvs = get_insignia_texture_settings_from_level
	insignia.content.insignia_addon.uvs = var_22_13
	insignia.content.level = get_versus_level_from_experience_2
	self._widgets_by_name.summary_value_text.content.text = string.format(var_0_0.summary_value_string, arg_22_1)
end

EndViewStateScoreVSTabReport._setup_entry_animations = function (self, arg_23_1, arg_23_2)
	-- function 23
	if #arg_23_1 > 0 then
		local tbl = {
			entry_name = "summary_entry_1"
		}

		self:_start_transition_animation("animate_progression_entry_1", "animate_progression_entry", tbl)

		for i = 2, #arg_23_1 do
			local tbl_2 = {
				entry_name = "summary_entry_" .. i
			}

			self._animation_callbacks["animate_progression_entry_" .. i - 1] = callback(self, "_start_transition_animation", "animate_progression_entry_" .. i, "animate_progression_entry", tbl_2)
		end

		local str = "animate_progression_entry_" .. #arg_23_1
		local _versus_level_start = self._versus_level_start

		if not table.is_empty(_versus_level_start) then
			_versus_level_start[1] = ExperienceSettings.get_versus_level()
			_versus_level_start[2] = ExperienceSettings.get_versus_experience()
		end

		local var_23_4 = _versus_level_start[1]
		local var_23_5 = _versus_level_start[2]

		if var_23_4 ~= ExperienceSettings.max_versus_level then
			local get_versus_level_from_experience, var_23_7 = ExperienceSettings.get_versus_level_from_experience(var_23_5)
			local get_versus_level_from_experience_2, var_23_9 = ExperienceSettings.get_versus_level_from_experience(var_23_5 + arg_23_2)
			local get_versus_progress_breakdown, var_23_11 = ExperienceSettings.get_versus_progress_breakdown(var_23_5, arg_23_2)
			local num = get_versus_level_from_experience_2 - var_23_4
			local num_2 = 0
			local var_23_14

			for j = 0, num do
				local min = math.min(var_23_4 + (j + 1), ExperienceSettings.max_versus_level)
				local str_2 = "animate_level_up_" .. j + 1

				if j == 0 then
					if num > 0 then
						local tbl_3 = {
							final_progress = 1,
							starting_progress = var_23_7,
							level = min,
							sound_parameter_values = {
								num_2,
								num_2 + get_versus_progress_breakdown[var_23_11]
							}
						}

						if min == ExperienceSettings.max_versus_level then
							tbl_3.on_complete_optional_starting_progress = 1
							tbl_3.on_complete_optional_final_progress = 1
						end

						self._animation_callbacks[str] = callback(self, "_start_transition_animation", str_2, "animate_level_up_start", tbl_3)
						var_23_14 = min
					else
						local tbl_4 = {
							starting_progress = var_23_7,
							final_progress = var_23_9,
							sound_parameter_values = {
								num_2,
								num_2 + get_versus_progress_breakdown[var_23_11]
							}
						}

						self._animation_callbacks[str] = callback(self, "_start_transition_animation", str_2, "animate_level_up_start_end", tbl_4)
					end
				elseif j < num then
					local tbl_5 = {
						final_progress = 1,
						starting_progress = 0,
						level = min,
						sound_parameter_values = {
							num_2,
							num_2 + get_versus_progress_breakdown[var_23_11]
						}
					}
					local var_23_20 = callback(self, "_start_transition_animation", str_2, "animate_level_up_linear", tbl_5)

					self._animation_callbacks[str] = callback(self, "_start_level_up_reward_presentation", var_23_14, var_23_20)
					var_23_14 = min
				elseif min == ExperienceSettings.max_versus_level then
					local tbl_6 = {
						final_progress = 1,
						starting_progress = 1,
						level = ExperienceSettings.max_versus_level
					}
					local var_23_22 = callback(self, "_start_transition_animation", str_2, "animate_level_up_instant", tbl_6)

					self._animation_callbacks[str] = callback(self, "_start_level_up_reward_presentation", var_23_14, var_23_22)
				else
					local tbl_7 = {
						starting_progress = 0,
						final_progress = var_23_9,
						level = min,
						sound_parameter_values = {
							num_2,
							num_2 + get_versus_progress_breakdown[var_23_11]
						}
					}
					local var_23_24 = callback(self, "_start_transition_animation", str_2, "animate_level_up_end", tbl_7)

					self._animation_callbacks[str] = callback(self, "_start_level_up_reward_presentation", var_23_14, var_23_24)
				end

				str = str_2
				num_2 = num_2 + get_versus_progress_breakdown[var_23_11]
				var_23_11 = var_23_11 + 1
			end

			self._animation_callbacks[str] = callback(self, "_start_transition_animation", "versus_level_up_pause", "versus_level_up_pause")
			str = "versus_level_up_pause"
		end

		self._animation_callbacks[str] = callback(self, "_start_transition_animation", "animate_hero_progress", "animate_hero_progress")
		self._animation_callbacks.animate_hero_progress = callback(self, "_setup_hero_progression")
	else
		self:_start_transition_animation("animate_hero_progress", "animate_hero_progress")

		self._animation_callbacks.animate_hero_progress = callback(self, "_setup_hero_progression")
	end
end

local tbl_2 = {}

EndViewStateScoreVSTabReport._start_level_up_reward_presentation = function (self, arg_24_1, arg_24_2)
	-- function 24
	table.clear(tbl_2)

	local var_24_0 = self._versus_level_up_rewards[arg_24_1]

	if not var_24_0 then
		arg_24_2()

		return
	end

	local tbl = {}
	local tbl_3 = {
		Localize("summary_screen_rank_up"),
		Localize("versus_level_tag") .. " " .. arg_24_1
	}

	tbl[#tbl + 1] = {
		widget_type = "description",
		value = tbl_3
	}

	local tbl_4 = {}
	local get_interface = Managers.backend:get_interface("items")

	for i = 1, #var_24_0 do
		local var_24_5 = var_24_0[i]
		local var_24_6
		local backend_id = var_24_5.backend_id

		if not backend_id then
			var_24_6 = get_interface:get_item_from_id(backend_id)
		else
			local tbl_5 = {}
			local get_fake_currency_item = BackendUtils.get_fake_currency_item
			local currency = var_24_5.currency

			currency = currency or "SM"
			tbl_5.data = get_fake_currency_item(currency, var_24_5.awarded)
			var_24_6 = tbl_5
		end

		tbl_4[#tbl_4 + 1] = var_24_6
	end

	tbl[#tbl + 1] = {
		widget_type = "item_list",
		value = tbl_4
	}
	tbl_2[#tbl_2 + 1] = tbl
	tbl_2.bg_alpha = 200
	tbl_2.offset = {
		0,
		0,
		1
	}

	self._reward_popup:display_presentation(tbl_2, arg_24_2)
end

EndViewStateScoreVSTabReport.on_exit = function (self, arg_25_1)
	-- function 25
	print("[EndViewStateVS] Exit Substate EndViewStateScoreVSTabReport")

	self._ui_scenegraph = nil
	self._widgets = nil
	self._widgets_by_name = nil
	self._ui_animator = nil
	self._context.progression_presentation_done = true

	if not self._reward_popup then
		self._reward_popup:destroy()

		self._reward_popup = nil
	end
end

EndViewStateScoreVSTabReport._create_ui_elements = function (self, arg_26_1)
	-- function 26
	local widget_definitions = var_0_0.widget_definitions
	local challenge_widget_definitions = var_0_0.challenge_widget_definitions
	local hero_progress_widget_definitions = var_0_0.hero_progress_widget_definitions
	local summary_entry_widgets = var_0_0.summary_entry_widgets
	local scenegraph_definition = var_0_0.scenegraph_definition
	local animation_definitions = var_0_0.animation_definitions
	local bar_thresholds = var_0_0.bar_thresholds

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._scenegraph_definition = scenegraph_definition
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widget_definitions, {}, {})
	self._hero_progress_widgets, self._widgets_by_name = UIUtils.create_widgets(hero_progress_widget_definitions, {}, self._widgets_by_name)
	self._challenge_widgets, self._widgets_by_name = UIUtils.create_widgets(challenge_widget_definitions, {}, self._widgets_by_name)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local _versus_level_start = self._versus_level_start

	if not table.is_empty(_versus_level_start) then
		_versus_level_start[1] = ExperienceSettings.get_versus_level()
		_versus_level_start[2] = ExperienceSettings.get_versus_experience()
	end

	local var_26_8 = _versus_level_start[1]
	local var_26_9 = _versus_level_start[2]
	local get_versus_level_from_experience, var_26_11 = ExperienceSettings.get_versus_level_from_experience(var_26_9)
	local level_up = self._widgets_by_name.level_up

	if var_26_8 == ExperienceSettings.max_versus_level then
		level_up.content.starting_progress = 1
		level_up.content.final_progress = 1
	else
		level_up.content.starting_progress = math.lerp(bar_thresholds[1], bar_thresholds[2], var_26_11)
		level_up.content.final_progress = math.lerp(bar_thresholds[1], bar_thresholds[2], var_26_11)
	end

	level_up.content.level_text = var_26_8

	local insignia = self._widgets_by_name.insignia
	local get_insignia_texture_settings_from_level, var_26_15 = UIAtlasHelper.get_insignia_texture_settings_from_level(var_26_8)

	insignia.content.insignia_main.uvs = get_insignia_texture_settings_from_level
	insignia.content.insignia_addon.uvs = var_26_15
	insignia.content.level = var_26_8
end

EndViewStateScoreVSTabReport._get_definitions = function (arg_27_0)
	-- function 27
	return local_require("scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report_definitions")
end

EndViewStateScoreVSTabReport.update = function (self, arg_28_1, arg_28_2)
	-- function 28
	self:_draw(arg_28_1, arg_28_2)
	self:_update_animations(arg_28_1, arg_28_2)
	self:_handle_reward_popup(arg_28_1, arg_28_2)
end

EndViewStateScoreVSTabReport._handle_reward_popup = function (self, arg_29_1, arg_29_2)
	-- function 29
	self._reward_popup:update(arg_29_1, arg_29_2)
end

EndViewStateScoreVSTabReport.post_update = function (arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	return
end

EndViewStateScoreVSTabReport._handle_input = function (self, arg_31_1, arg_31_2)
	-- function 31
	if not self._input_manager:get_service("end_of_level"):get("confirm_hold") then
		return arg_31_1 * 5
	end

	return arg_31_1
end

EndViewStateScoreVSTabReport._update_animations = function (self, arg_32_1)
	-- function 32
	self._ui_animator:update(arg_32_1)

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_32_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil

			local var_32_2 = self._animation_callbacks[k_2]

			self._animation_callbacks[k_2] = nil

			if not var_32_2 then
				var_32_2()
			end
		end
	end

	if not table.is_empty(self._animations) then
		self:_animate_experience_bar(arg_32_1)
	end
end

EndViewStateScoreVSTabReport._draw = function (self, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	local get_service = self._input_manager:get_service("end_of_level")
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_33_2, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	local alpha_multiplier = _render_settings.alpha_multiplier
	local hero_progress_alpha_multiplier = _render_settings.hero_progress_alpha_multiplier

	hero_progress_alpha_multiplier = hero_progress_alpha_multiplier or 0
	_render_settings.alpha_multiplier = hero_progress_alpha_multiplier

	for i_2, v_2 in ipairs(self._hero_progress_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v_2)
	end

	_render_settings.alpha_multiplier = alpha_multiplier

	local alpha_multiplier_2 = _render_settings.alpha_multiplier
	local challenge_alpha_multiplier = _render_settings.challenge_alpha_multiplier

	challenge_alpha_multiplier = challenge_alpha_multiplier or 0
	_render_settings.alpha_multiplier = challenge_alpha_multiplier

	for i_3, v_3 in ipairs(self._challenge_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v_3)
	end

	_render_settings.alpha_multiplier = alpha_multiplier_2

	local var_33_8 = self._ui_scenegraph.challenge_entry_anchor.local_position[2]
	local var_33_9 = self._ui_scenegraph.challenge_entry_anchor.size[2]
	local var_33_10 = self._ui_scenegraph.challenge_progress_area.size[2]
	local alpha_multiplier_3 = _render_settings.alpha_multiplier

	for i_4, v_4 in ipairs(self._challenge_entry_widgets) do
		_render_settings.alpha_multiplier = v_4.content.alpha_multiplier

		local num = v_4.offset[2] + var_33_8

		if num < -var_33_10 then
			break
		elseif num - var_33_9 < 0 then
			UIRenderer.draw_widget(_ui_top_renderer, v_4)
		end
	end

	_render_settings.alpha_multiplier = alpha_multiplier_3

	UIRenderer.end_pass(_ui_top_renderer)

	if not self._scrollbar_ui then
		self._scrollbar_ui:update(arg_33_2, arg_33_3, _ui_top_renderer, get_service, _render_settings)
	end
end

EndViewStateScoreVSTabReport._start_transition_animation = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	local tbl = {
		set_global_wwise_parameter = callback(self, "_set_global_wwise_parameter"),
		play_sound = callback(self, "_play_sound"),
		render_settings = self._render_settings,
		data = arg_34_3
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_34_2, _widgets_by_name, self._scenegraph_definition, tbl)

	self._animations[arg_34_1] = start_animation
end
