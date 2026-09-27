-- chunkname: @scripts/ui/views/level_end/states/end_view_state_summary.lua

local flag = false

EndViewStateSummary = class(EndViewStateSummary)
EndViewStateSummary.NAME = "EndViewStateSummary"
EndViewStateSummary.CAN_SPEED_UP = true

EndViewStateSummary.on_enter = function (self, arg_1_1)
	-- function 1
	print("[EndViewState] Enter Substate EndViewStateSummary")

	self._params = arg_1_1
	self.parent = arg_1_1.parent
	self.game_won = arg_1_1.game_won
	self.game_mode_key = arg_1_1.game_mode_key

	local context = arg_1_1.context

	self._context = context
	self.ui_renderer = context.ui_renderer
	self.ui_top_renderer = context.ui_top_renderer
	self.input_manager = context.input_manager
	self.statistics_db = context.statistics_db
	self.profile_synchronizer = context.profile_synchronizer
	self.rewards = context.rewards
	self.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self.wwise_world = context.wwise_world
	self.world_previewer = arg_1_1.world_previewer
	self.platform = PLATFORM
	self._animations = {}
	self._ui_animations = {}
	self.peer_id = context.peer_id
	self._hero_name = context.local_player_hero_name

	self:create_ui_elements(arg_1_1)

	if not arg_1_1.initial_state then
		self._initial_preview = true
		arg_1_1.initial_state = nil
	end

	if not self.game_won then
		self:_start_transition_animation("on_enter", "transition_enter_fast")
	else
		self:_start_transition_animation("on_enter", "transition_enter")
	end

	self._exit_timer = nil

	local level_start = self._context.rewards.level_start
	local var_1_2 = level_start[1]
	local var_1_3 = level_start[2]
	local var_1_4 = level_start[3]

	self:_setup_essence_presentation()

	self._progress_data = self:_get_total_experience_progress_data(var_1_3, var_1_4)

	local get_level = ExperienceSettings.get_level(var_1_3)
	local num = var_1_3 + var_1_4

	if get_level < ExperienceSettings.max_level then
		num = var_1_3
	end

	local _set_current_experience, var_1_8 = self:_set_current_experience(num)

	self._current_level = _set_current_experience

	if self._progress_data.bonus_experience > 0 then
		self._extra_levels = var_1_8 + self._progress_data.start_extra_level
	else
		self._extra_levels = var_1_8
	end

	self._experience_presentation_completed = nil

	if not IS_WINDOWS then
		self:_set_player_count_presence(context)
	end

	self:_play_sound("play_gui_mission_summary_appear")
end

EndViewStateSummary.exit = function (self, arg_2_1)
	-- function 2
	self._exit_started = true

	self:_start_transition_animation("on_enter", "transition_exit")
	self:_play_sound("play_gui_mission_summary_end")

	if not self.game_won and not Managers.package:has_loaded("resource_packages/levels/ui_end_screen") then
		local tbl = {
			level_name = "levels/end_screen_victory/parading_screen",
			camera_name = "end_screen_camera",
			animation_name = "transition"
		}

		self.parent:trigger_transition(tbl)
	end
end

EndViewStateSummary.exit_done = function (self)
	-- function 3
	local _exit_started = self._exit_started

	_exit_started = not _exit_started and self._animations.on_enter == nil

	return _exit_started
end

EndViewStateSummary._get_definitions = function (arg_4_0)
	-- function 4
	return local_require("scripts/ui/views/level_end/states/definitions/end_view_state_summary_definitions")
end

EndViewStateSummary.create_ui_elements = function (self, arg_5_1)
	-- function 5
	local _get_definitions = self:_get_definitions()
	local widgets = _get_definitions.widgets
	local summary_entry_widgets = _get_definitions.summary_entry_widgets
	local scenegraph_definition = _get_definitions.scenegraph_definition
	local animation_definitions = _get_definitions.animation_definitions

	flag = false
	self._scenegraph_definition = scenegraph_definition
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_5_7 = UIWidget.init(v)

		tbl[#tbl + 1] = var_5_7
		tbl_2[k] = var_5_7
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(summary_entry_widgets) do
		local var_5_10 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_5_10
		tbl_4[k_2] = var_5_10
	end

	self._entry_widgets = tbl_3
	self._entry_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
end

EndViewStateSummary._wanted_state = function (self)
	-- function 6
	return (self.parent:wanted_menu_state())
end

EndViewStateSummary.set_input_manager = function (self, arg_7_1)
	-- function 7
	self.input_manager = arg_7_1
end

EndViewStateSummary.on_exit = function (self, arg_8_1)
	-- function 8
	print("[EndViewState] Exit Substate EndViewStateSummary")

	self.ui_animator = nil
end

EndViewStateSummary._update_transition_timer = function (self, arg_9_1)
	-- function 9
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_9_1, 0)
	end
end

EndViewStateSummary.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not flag then
		self:on_enter(self._params)
	end

	local get_service = self.input_manager:get_service("end_of_level")

	if not (self._animations.on_enter or self._summary_entries) then
		self:_initialize_entries()
	end

	self:draw(get_service, arg_10_1)
	self:_update_transition_timer(arg_10_1)

	local _wanted_state = self:_wanted_state()

	if self._transition_timer or _wanted_state or not self._new_state then
		self.parent:clear_wanted_menu_state()

		return _wanted_state or self._new_state
	end

	local displaying_reward_presentation = self.parent:displaying_reward_presentation()

	if not self._summary_entries and not self._summary_entries.complete then
		self:_animate_experience_bar(arg_10_1, displaying_reward_presentation)
	end

	if not displaying_reward_presentation then
		self.ui_animator:update(arg_10_1)
		self:_animate_summary_entries(arg_10_1)
	end

	self:_update_animations(arg_10_1)

	if not (self.parent:transitioning() or self._transition_timer) then
		self:_handle_input(arg_10_1, arg_10_2)
	end
end

EndViewStateSummary.post_update = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	return
end

EndViewStateSummary._update_animations = function (self, arg_12_1)
	-- function 12
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_12_1)

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

	if not self.level_up_anim_id and not ui_animator:is_animation_completed(self.level_up_anim_id) then
		ui_animator:stop_animation(self.level_up_anim_id)

		self.level_up_anim_id = nil

		local max_level = ExperienceSettings.max_level
		local var_12_3

		if max_level > self._current_level then
			var_12_3 = self._current_level
		else
			local _current_level = self._current_level
			local _extra_levels = self._extra_levels

			_extra_levels = _extra_levels or 0
			var_12_3 = _current_level + _extra_levels
		end

		self.parent:present_level_up(self._hero_name, var_12_3)
	end
end

EndViewStateSummary._handle_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _widgets_by_name = self._widgets_by_name
end

EndViewStateSummary.draw = function (self, arg_14_1, arg_14_2)
	-- function 14
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_14_1, arg_14_2, nil, render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	local _summary_entries = self._summary_entries

	if not _summary_entries then
		for i_2, v_2 in ipairs(_summary_entries) do
			local widget = v_2.widget

			if not widget then
				UIRenderer.draw_widget(ui_renderer, widget)
			end
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

EndViewStateSummary._start_transition_animation = function (self, arg_15_1, arg_15_2)
	-- function 15
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_15_2, tbl_2, self._scenegraph_definition, tbl)

	self._animations[arg_15_1] = start_animation
end

EndViewStateSummary._start_animation = function (self, arg_16_1, arg_16_2)
	-- function 16
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self.ui_animator:start_animation(arg_16_2, _widgets_by_name, self._scenegraph_definition, tbl)

	self._animations[arg_16_1] = start_animation
end

EndViewStateSummary._animate_element_by_time = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	-- function 17
	return (UIAnimation.init(UIAnimation.function_by_time, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, math.ease_out_quad))
end

EndViewStateSummary._animate_element_by_catmullrom = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8)
	-- function 18
	return (UIAnimation.init(UIAnimation.catmullrom, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8))
end

EndViewStateSummary._initialize_entries = function (self)
	-- function 19
	local _get_summary_entries, var_19_1 = self:_get_summary_entries(self.game_won, self.game_mode_key)

	self._summary_entries = _get_summary_entries
end

EndViewStateSummary._get_summary_entries = function (self, arg_20_1, arg_20_2)
	-- function 20
	local mission_results = self._context.rewards.mission_results
	local _entry_widgets = self._entry_widgets
	local tbl = {}
	local num = 0
	local num_2 = 0

	for i, v in ipairs(mission_results) do
		num = num % #_entry_widgets + 1

		local str = "entry_" .. i
		local text = v.text
		local format_values = v.format_values
		local experience = v.experience

		experience = not experience and math.round(v.experience)

		local value = v.value
		local bonus = v.bonus
		local icon = v.icon
		local var_20_12 = _entry_widgets[num]
		local var_20_13

		if not text then
			if not format_values then
				var_20_13 = UIUtils.format_localized_description(text, format_values)
			else
				var_20_13 = Localize(text)
			end
		end

		local var_20_14

		if not experience then
			var_20_14 = tostring(experience)

			if not var_20_14 then
				-- Nothing
			end
		end

		if not value then
			var_20_14 = tostring(value)

			if not var_20_14 then
				-- Nothing
			end
		end

		var_20_14 = ""

		::label_20_0::

		tbl[i] = {
			spacing = 8,
			start_counter_sound = true,
			name = str,
			title_text = var_20_13,
			experience = experience,
			value = value,
			value_text = var_20_14,
			bonus = bonus,
			widget = var_20_12,
			icon = icon,
			list_index = i,
			wwise_world = self.wwise_world
		}

		if not experience then
			num_2 = num_2 + experience
		end
	end

	return tbl, num_2
end

EndViewStateSummary._animate_summary_entries = function (self, arg_21_1)
	-- function 21
	local _summary_entries = self._summary_entries

	if not _summary_entries and not _summary_entries.complete then
		if not (not _summary_entries and not _summary_entries.complete and not self._is_max_level and self._experience_presentation_completed) then
			self._experience_presentation_completed = true

			self.parent:present_additional_rewards()
		end

		return
	end

	local ui_animator = self.ui_animator
	local str = "summary_entry_initial"
	local str_2 = "summary_entry_text_shadow"

	if not self.total_experience_count_anim_id and not ui_animator:is_animation_completed(self.total_experience_count_anim_id) then
		ui_animator:stop_animation(self.total_experience_count_anim_id)

		self.total_experience_count_anim_id = nil
	end

	local flag = true

	for i, v in ipairs(_summary_entries) do
		if not v.animation_completed then
			if not self.summary_entry_enter_anim_id then
				self.summary_entry_enter_anim_id = self.ui_animator:start_animation(str, self._widgets_by_name, self._scenegraph_definition, v)
			elseif not ui_animator:is_animation_completed(self.summary_entry_enter_anim_id) then
				ui_animator:stop_animation(self.summary_entry_enter_anim_id)

				self.summary_entry_enter_anim_id = nil
				v.animation_completed = true
				self.total_experience_count_anim_id = self.ui_animator:start_animation("total_experience_increase", self._widgets_by_name, self._scenegraph_definition, v)
			end

			flag = false
		end
	end

	_summary_entries.complete = flag

	if not flag then
		-- Nothing
	end
end

EndViewStateSummary._get_essence_earned = function (self)
	-- function 22
	local essence = self._context.rewards.end_of_level_rewards.essence

	if not essence then
		return nil
	end

	if essence.awarded ~= nil then
		return essence.awarded
	end

	return essence[1].awarded
end

EndViewStateSummary._setup_essence_presentation = function (self)
	-- function 23
	local _get_essence_earned = self:_get_essence_earned()
	local flag = not Managers.unlock:is_dlc_unlocked("scorpion") and _get_essence_earned ~= nil
	local _widgets_by_name = self._widgets_by_name
	local flag_2 = true

	if not _get_essence_earned then
		local get_interface = Managers.backend:get_interface("weaves")
		local get_essence = get_interface:get_essence()
		local get_total_essence = get_interface:get_total_essence()
		local get_maximum_essence = get_interface:get_maximum_essence()

		if not (not (get_maximum_essence < get_total_essence) or not (get_maximum_essence > get_total_essence - _get_essence_earned)) then
			_get_essence_earned = _get_essence_earned - (get_maximum_essence - get_total_essence)
		elseif get_maximum_essence < get_total_essence - _get_essence_earned then
			_get_essence_earned = nil
			flag_2 = false
		end

		if not _get_essence_earned then
			local essence_total_text = _widgets_by_name.essence_total_text

			essence_total_text.content.text = _get_essence_earned

			local get_text_width = UIUtils.get_text_width(self.ui_renderer, essence_total_text.style.text, tostring(_get_essence_earned))

			_widgets_by_name.icon_essence.offset[1] = -get_text_width
		end
	end

	_widgets_by_name.essence_background.content.visible = flag
	_widgets_by_name.essence_background_frame.content.visible = flag
	_widgets_by_name.essence_background_shadow.content.visible = flag
	_widgets_by_name.essence_background_effect_left.content.visible = flag
	_widgets_by_name.essence_background_effect_right.content.visible = flag
	_widgets_by_name.total_essence_title.content.visible = flag
	_widgets_by_name.icon_essence.content.visible = not flag_2 and flag and false
	_widgets_by_name.essence_total_text.content.visible = _get_essence_earned == nil or not flag or false
	_widgets_by_name.essence_total_text_max.content.visible = not flag and not flag_2
end

EndViewStateSummary._get_total_experience_progress_data = function (self, arg_24_1, arg_24_2)
	-- function 24
	local get_level, var_24_1 = ExperienceSettings.get_level(arg_24_1)
	local get_extra_level, var_24_3 = ExperienceSettings.get_extra_level(arg_24_2)
	local _hero_name = self._hero_name
	local get_experience = ExperienceSettings.get_experience(_hero_name)
	local get_level_2, var_24_7 = ExperienceSettings.get_level(get_experience)
	local get_experience_pool = ExperienceSettings.get_experience_pool(_hero_name)
	local get_extra_level_2, var_24_10 = ExperienceSettings.get_extra_level(get_experience_pool)
	local num = get_level + get_extra_level
	local num_2 = get_level_2 + get_extra_level_2
	local num_3 = 0

	if not (get_level == ExperienceSettings.max_level or get_level_2 ~= ExperienceSettings.max_level) then
		var_24_7 = var_24_3
		num_3 = ExperienceSettings.get_experience_required_for_level(ExperienceSettings.max_level) * var_24_3
	end

	local num_4 = num_2 - num + (var_24_7 - var_24_1) + (var_24_10 - var_24_3)
	local num_5 = get_experience - arg_24_1 + (get_experience_pool - arg_24_2) + num_3

	if get_level == ExperienceSettings.max_level then
		arg_24_1 = arg_24_1 + arg_24_2
		var_24_1 = var_24_3
	end

	local bar_progress_min_time = UISettings.summary_screen.bar_progress_min_time
	local bar_progress_max_time = UISettings.summary_screen.bar_progress_max_time
	local bar_progress_experience_time_multiplier = UISettings.summary_screen.bar_progress_experience_time_multiplier
	local min = math.min(math.max(bar_progress_experience_time_multiplier * num_5, bar_progress_min_time), bar_progress_max_time)

	return {
		time = 0,
		complete = false,
		current_experience = arg_24_1,
		experience_to_add = num_5,
		total_progress = num_4,
		start_progress = var_24_1,
		start_extra_level = get_extra_level,
		bonus_experience = num_3,
		total_time = min
	}
end

EndViewStateSummary._animate_experience_bar = function (self, arg_25_1, arg_25_2)
	-- function 25
	local _progress_data = self._progress_data

	if not _progress_data and _progress_data.complete or arg_25_2 or self.level_up_anim_id or not self._experience_presentation_completed then
		return
	end

	if not self._experience_bar_started then
		self:_play_sound("play_gui_mission_summary_experience_bar_begin")

		self._experience_bar_started = true
	end

	local time = _progress_data.time
	local total_time = _progress_data.total_time
	local num = time / total_time
	local smoothstep = math.smoothstep(num, 0, 1)
	local min = math.min(time + arg_25_1, total_time)

	_progress_data.time = min

	local current_experience = _progress_data.current_experience
	local experience_to_add = _progress_data.experience_to_add
	local floor = math.floor(experience_to_add * smoothstep)
	local floor_2 = math.floor(current_experience + floor)
	local _set_current_experience, var_25_11 = self:_set_current_experience(floor_2)
	local flag = _set_current_experience ~= self._current_level

	if self._extra_levels ~= nil then
		if self._progress_data.bonus_experience > 0 then
			var_25_11 = var_25_11 + self._progress_data.start_extra_level
		end

		flag = flag or var_25_11 ~= self._extra_levels
	end

	if not flag then
		self._current_level = _set_current_experience
		self._extra_levels = var_25_11

		self:_play_sound("play_gui_mission_summary_experience_bar_end")

		self.level_up_anim_id = self.ui_animator:start_animation("level_up", self._widgets_by_name, self._scenegraph_definition, {
			wwise_world = self.wwise_world
		})
	end

	if min == total_time then
		_progress_data.complete = true
		self._experience_presentation_completed = true

		self:_play_sound("play_gui_mission_summary_experience_bar_end")
		self.parent:present_additional_rewards()
	end
end

EndViewStateSummary._set_current_experience = function (self, arg_26_1)
	-- function 26
	local get_level, var_26_1 = ExperienceSettings.get_level(arg_26_1)
	local num = 0

	if get_level == ExperienceSettings.max_level then
		local num_2 = arg_26_1 - ExperienceSettings.max_experience

		num, var_26_1 = ExperienceSettings.get_extra_level(num_2)
	end

	local clamp = math.clamp(get_level + 1, 0, ExperienceSettings.max_level)

	if not ((not self._current_level and get_level > self._current_level or not self._extra_levels) and not (num > self._extra_levels)) then
		var_26_1 = 1
	end

	local _widgets_by_name = self._widgets_by_name
	local experience_bar = _widgets_by_name.experience_bar
	local content = experience_bar.content
	local style = experience_bar.style
	local default_size = style.experience_bar.default_size

	style.experience_bar.size[1] = default_size[1] * var_26_1
	style.experience_bar_end.offset[1] = default_size[1] * var_26_1

	if not (var_26_1 ~= 1 or get_level == clamp) then
		_widgets_by_name.current_level_text.content.text = tostring(get_level - 1)
		_widgets_by_name.next_level_text.content.text = tostring(clamp - 1)
	else
		_widgets_by_name.current_level_text.content.text = tostring(get_level)
		_widgets_by_name.next_level_text.content.text = tostring(clamp)
	end

	WwiseWorld.set_global_parameter(self.wwise_world, "summary_meter_progress", var_26_1)

	return get_level, num
end

EndViewStateSummary.done = function (self)
	-- function 27
	local _experience_presentation_completed = self._experience_presentation_completed

	_experience_presentation_completed = not _experience_presentation_completed and self._summary_entries.complete

	return _experience_presentation_completed
end

EndViewStateSummary._play_sound = function (self, arg_28_1)
	-- function 28
	self.parent:play_sound(arg_28_1)
end

EndViewStateSummary._set_player_count_presence = function (arg_29_0, arg_29_1)
	-- function 29
	local players_session_score = arg_29_1.players_session_score
	local num = 0

	for k, v in pairs(players_session_score) do
		local peer_id = v.peer_id
		local is_player_controlled = v.is_player_controlled

		if not peer_id and not is_player_controlled then
			num = num + 1
		end
	end

	Presence.set_presence("steam_player_group_size", num)
end
