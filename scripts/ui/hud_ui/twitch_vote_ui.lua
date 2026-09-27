-- chunkname: @scripts/ui/hud_ui/twitch_vote_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/twitch_vote_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local settings = var_0_0.settings
local vote_texts = var_0_0.vote_texts
local flag = false
local num = 3
local num_2 = 5

TwitchVoteUI = class(TwitchVoteUI)

TwitchVoteUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ingame_ui = arg_1_2.ingame_ui
	self._input_manager = arg_1_2.input_manager
	self._world_manager = arg_1_2.world_manager
	self.active = false
	self._active_vote = nil
	self._vote_activated = false
	self._votes = {}
	self._ui_animations = {}
	self._animation_callbacks = {}
	self._render_settings = {
		alpha_multiplier = 1
	}
	self._last_played_countdown_sfx = num_2 + 1

	local world = self._world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	self:_create_elements()
	Managers.state.event:register(self, "add_vote_ui", "event_add_vote_ui")
	Managers.state.event:register(self, "finish_vote_ui", "event_finish_vote_ui")
	Managers.state.event:register(self, "reset_vote_ui", "event_reset_vote_ui")
end

TwitchVoteUI.event_add_vote_ui = function (self, arg_2_1)
	-- function 2
	local get_vote_data = Managers.twitch:get_vote_data(arg_2_1)

	if not get_vote_data then
		return
	end

	if get_vote_data.vote_type == "standard_vote" then
		self:start_standard_vote(get_vote_data.vote_templates[1], get_vote_data.vote_templates[2], get_vote_data.option_strings, arg_2_1)
	elseif get_vote_data.vote_type == "multiple_choice" then
		self:start_multiple_choice_vote(get_vote_data.vote_templates[1], get_vote_data.option_strings, arg_2_1)
	end
end

TwitchVoteUI.event_finish_vote_ui = function (self, arg_3_1, arg_3_2)
	-- function 3
	local get_vote_data = Managers.twitch:get_vote_data(arg_3_1)

	if not get_vote_data then
		return
	end

	local var_3_1 = get_vote_data.vote_templates[arg_3_2]
	local vote_type = get_vote_data.vote_type
	local _active_vote = self._active_vote
	local var_3_4 = TwitchVoteTemplates[var_3_1]

	self._vote_result = {
		vote_key = arg_3_1,
		winning_index = arg_3_2,
		winning_template_name = var_3_1,
		vote_template = var_3_4
	}

	if vote_type == "standard_vote" then
		self:show_ui("standard_vote_result")
	elseif vote_type == "multiple_choice" then
		self:show_ui("multiple_choice_result")
	end

	Application.error("[TwitchVoteUI] event_finish_vote_ui")
end

TwitchVoteUI.event_reset_vote_ui = function (self, arg_4_1)
	-- function 4
	if not arg_4_1 then
		if not (not self._active_vote and self._active_vote.vote_key ~= arg_4_1) then
			self._active_vote = nil
			self._vote_widget = nil
		end

		for i, v in ipairs(self._votes) do
			if v.vote_key == arg_4_1 then
				table.remove(self._votes, i)

				break
			end
		end

		print("RESET: Removed Active vote with key")
	else
		self._votes = {}
		self.active = false
		self._active_vote = nil
		self._vote_widget = nil

		print("RESET: Removed Active vote")
	end
end

TwitchVoteUI.start_standard_vote = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local var_5_0 = TwitchVoteTemplates[arg_5_1]

	fassert(var_5_0, "[TwitchVoteUI] Could not find any vote template for %s", arg_5_1)

	local var_5_1 = TwitchVoteTemplates[arg_5_2]

	fassert(var_5_1, "[TwitchVoteUI] Could not find any vote template for %s", arg_5_2)

	local get_vote_data = Managers.twitch:get_vote_data(arg_5_4)

	self._active_vote, self.active = {
		vote_type = "standard_vote",
		vote_template_a = table.clone(var_5_0),
		vote_template_b = table.clone(var_5_1),
		inputs = arg_5_3 or {
			"#a",
			"#b"
		},
		vote_key = arg_5_4,
		timer = get_vote_data.timer
	}, true

	self:show_ui("standard_vote")
end

TwitchVoteUI.start_multiple_choice_vote = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = TwitchVoteTemplates[arg_6_1]

	fassert(var_6_0, "[TwitchVoteUI] Could not find any vote template for %s", arg_6_1)
	print("added multiple choice vote")

	local get_vote_data = Managers.twitch:get_vote_data(arg_6_3)

	self._active_vote, self.active = {
		vote_type = "multiple_choice",
		vote_template = table.clone(var_6_0),
		inputs = arg_6_2 or {
			"#a",
			"#b",
			"#c",
			"#d",
			"#e"
		},
		vote_key = arg_6_3,
		timer = get_vote_data.timer
	}, true

	self:show_ui("multiple_choice_vote")
end

TwitchVoteUI.set_visible = function (self, arg_7_1)
	-- function 7
	self._visible = arg_7_1
end

TwitchVoteUI._create_elements = function (self)
	-- function 8
	local scenegraph_definition = var_0_0.scenegraph_definition

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets = {}
	self._vote_count = {
		0,
		0,
		0,
		0,
		0
	}
	self._vote_icon_count = 0
	self._vote_widget = nil

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

local tbl = {
	root_scenegraph_id = "pivot",
	label = "Twitch",
	registry_key = "twitch",
	drag_scenegraph_id = "pivot_dragger"
}

TwitchVoteUI.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	HudCustomizer.run(self._ui_renderer, self._ui_scenegraph, tbl)

	if not self.active then
		return
	end

	if not flag and not self._active_vote then
		for i = 1, 5 do
			Debug.text("                               Vote Percentages: " .. self._active_vote.vote_percentages[i])
		end
	end

	self:_update_transition(arg_9_1)
	self:_draw(arg_9_1, arg_9_2)
	self:_update_active_vote(arg_9_1, arg_9_2)

	local _ui = self._ui

	if _ui == "multiple_choice_vote" then
		self:_update_multiple_votes_ui(arg_9_1)
	elseif _ui == "standard_vote" then
		self:_update_standard_vote(arg_9_1)
	elseif not (_ui == "multiple_choice_result" or _ui ~= "standard_vote_result") then
		self:_update_result(arg_9_1)
	end
end

TwitchVoteUI._update_transition = function (self, arg_10_1)
	-- function 10
	if not self._fade_out then
		local num = 1
		local _render_settings = self._render_settings
		local clamp = math.clamp(_render_settings.alpha_multiplier - arg_10_1 * num, 0, 1)

		_render_settings.alpha_multiplier = clamp

		if clamp == 0 then
			self._ui = nil
			self._fade_out = nil

			if not self._next_ui then
				self:_show_next_ui()
			else
				self.active = false
			end
		end

		return
	end

	if not self._fade_in then
		local num_2 = 5
		local _render_settings_2 = self._render_settings
		local clamp_2 = math.clamp(_render_settings_2.alpha_multiplier + arg_10_1 * num_2, 0, 1)

		_render_settings_2.alpha_multiplier = clamp_2

		if clamp_2 == 1 then
			self._fade_in = nil
		end

		return
	end
end

TwitchVoteUI.show_ui = function (self, arg_11_1)
	-- function 11
	self._next_ui = arg_11_1

	if not self._ui then
		self._fade_out = true
	else
		self:_show_next_ui()
	end
end

TwitchVoteUI.hide_ui = function (self)
	-- function 12
	self._fade_out = true
end

TwitchVoteUI._show_next_ui = function (self)
	-- function 13
	local _next_ui = self._next_ui

	if _next_ui == "multiple_choice_vote" then
		self:_show_multiple_choice_vote()
	elseif _next_ui == "multiple_choice_result" then
		self:_show_multiple_choice_result()
	elseif _next_ui == "standard_vote" then
		self:_show_standard_vote()
	elseif _next_ui == "standard_vote_result" then
		self:_show_standard_vote_result()
	end

	self._ui = _next_ui
	self._fade_in = true
	self._next_ui = nil
end

TwitchVoteUI._create_vote_icon = function (self, arg_14_1)
	-- function 14
	if not (self._ui_animations.animate_in or table.size(self._widgets) >= 50 or self._vote_widget) then
		return
	end

	local scenegraph_definition = var_0_0.scenegraph_definition
	local str = "vote_icon_" .. self._vote_icon_count
	local content = self._vote_widget.content
	local style = self._vote_widget.style
	local icon_texture_func = content.icon_texture_func(content, style, arg_14_1)
	local icon_offset_func = content.icon_offset_func(content, style, arg_14_1)

	scenegraph_definition[str] = {
		parent = "vote_icon",
		position = {
			icon_offset_func,
			0,
			0
		}
	}
	self._widgets[str] = UIWidget.init(UIWidgets.create_simple_texture(icon_texture_func, str))

	local var_14_6 = self._widgets[str]

	self._ui_animations[str .. "_offset_y"] = UIAnimation.init(UIAnimation.function_by_time_with_offset, var_14_6.style.texture_id.offset, 2, 0, Math.random(100, 200), 3, math.random(0, 10), math.easeOutCubic)
	self._ui_animations[str .. "_offset_x"] = UIAnimation.init(UIAnimation.function_by_time_with_offset, var_14_6.style.texture_id.offset, 1, 0, 1, 3, math.random(0, 10), altered_sin)
	self._ui_animations[str .. "_color"] = UIAnimation.init(UIAnimation.function_by_time_with_offset, var_14_6.style.texture_id.color, 1, 255, 0, 3.2, math.random(0, 10), math.ease_exp)
	self._animation_callbacks[str .. "_color"] = callback(self, "cb_destroy_vote_icon", str)
	self._vote_icon_count = self._vote_icon_count + 1
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
end

TwitchVoteUI.cb_destroy_vote_icon = function (arg_15_0, arg_15_1)
	-- function 15
	arg_15_0._widgets[arg_15_1] = nil
end

TwitchVoteUI._update_active_vote = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not self._active_vote and not self._active_vote.completed then
		return
	end

	local vote_key = self._active_vote.vote_key
	local get_vote_data = Managers.twitch:get_vote_data(vote_key)

	if not get_vote_data then
		Application.error("[TwitchVoteUI] There is no vote data for key (" .. vote_key .. ")")

		self._active_vote = nil
		self._vote_widget = nil

		table.remove(self._votes, 1)

		return
	end

	local options = get_vote_data.options
	local _vote_count = self._vote_count

	_vote_count = _vote_count or {
		0,
		0,
		0,
		0,
		0
	}
	self._vote_count = _vote_count

	local num = options[1] - self._vote_count[1]
	local num_2 = options[2] - self._vote_count[2]
	local num_3 = options[3] - self._vote_count[3]
	local num_4 = options[4] - self._vote_count[4]
	local num_5 = options[5] - self._vote_count[5]

	if num > 0 then
		for i = 1, num do
			self:_create_vote_icon(1)
		end
	end

	if num_2 > 0 then
		for j = 1, num_2 do
			self:_create_vote_icon(2)
		end
	end

	if num_3 > 0 then
		for k = 1, num_3 do
			self:_create_vote_icon(3)
		end
	end

	if num_4 > 0 then
		for l = 1, num_4 do
			self:_create_vote_icon(4)
		end
	end

	if num_5 > 0 then
		for i4 = 1, num_5 do
			self:_create_vote_icon(5)
		end
	end

	local num_6 = 0

	for i5 = 1, 5 do
		self._vote_count[i5] = options[i5]
		num_6 = num_6 + options[i5]
	end

	local tbl = {}

	for i6 = 1, 5 do
		local num_7

		if num_6 > 0 then
			num_7 = options[i6] / num_6

			if not num_7 then
				-- Nothing
			end
		end

		num_7 = 0

		::label_16_0::

		tbl[i6] = num_7
	end

	local _active_vote = self._active_vote
	local vote_percentages = self._active_vote.vote_percentages

	vote_percentages = vote_percentages or {
		0,
		0,
		0,
		0,
		0
	}
	_active_vote.vote_percentages = vote_percentages

	for i7 = 1, 5 do
		local vote_percentages_2 = self._active_vote.vote_percentages
		local lerp = math.lerp
		local var_16_16 = self._active_vote.vote_percentages[i7]

		var_16_16 = var_16_16 or 0
		vote_percentages_2[i7] = lerp(var_16_16, tbl[i7], arg_16_1 * 2)
	end

	if not flag then
		Debug.text("                                " .. self._vote_count[1])
		Debug.text("                                " .. self._vote_count[2])
		Debug.text("                                " .. self._vote_count[3])
		Debug.text("                                " .. self._vote_count[4])
		Debug.text("                                " .. self._vote_count[5])
	end

	self._active_vote.timer = get_vote_data.timer
	self._active_vote.options = options
	self._vote_activated = get_vote_data.activated
end

TwitchVoteUI._draw = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("ingame_menu")
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_17_1, nil, _render_settings)

	if not self._ui then
		for k, v in pairs(self._widgets) do
			UIRenderer.draw_widget(_ui_renderer, v)
		end
	end

	UIRenderer.end_pass(_ui_renderer)
end

TwitchVoteUI.destroy = function (arg_18_0)
	-- function 18
	Managers.state.event:unregister("add_vote_ui", arg_18_0)
	Managers.state.event:unregister("finish_vote_ui", arg_18_0)
	Managers.state.event:unregister("reset_vote_ui", arg_18_0)
end

TwitchVoteUI._show_multiple_choice_vote = function (self)
	-- function 19
	local _active_vote = self._active_vote

	if not _active_vote then
		return
	end

	self._widgets = {}

	local multiple_choice = var_0_0.widgets.multiple_choice

	for k, v in pairs(multiple_choice) do
		self._widgets[k] = UIWidget.init(v)
	end

	local _sorted_player_list = self:_sorted_player_list()
	local inputs = _active_vote.inputs

	for k_2, v_2 in pairs(_sorted_player_list) do
		repeat
			local profile_index = v_2:profile_index()
			local var_19_5 = SPProfiles[profile_index]

			if not (not var_19_5 and not (k_2 <= PlayerManager.MAX_PLAYERS)) then
				local str = "hero_" .. k_2
				local var_19_7 = self._widgets[str]

				if not var_19_7 then
					local career_index = v_2:career_index()
					local var_19_9 = var_19_5.careers[career_index]
					local str_2 = var_19_9.portrait_image .. "_twitch"
					local str_3 = var_19_9.portrait_image .. "_masked"
					local content = var_19_7.content

					content.portrait = str_2
					content.masked_portrait = str_3
					content.profile_index = profile_index

					local str_4 = "hero_vote_" .. k_2

					self._widgets[str_4].content.text = inputs[profile_index]
				end
			end
		until true
	end

	local vote_icon = self._widgets.vote_icon
	local vote_template = _active_vote.vote_template
	local texture_id = vote_template.texture_id

	vote_icon.content.texture_id = texture_id

	local vote_text = self._widgets.vote_text
	local text = vote_template.text

	vote_text.content.text = text

	self:_play_multiple_vote_start()
end

TwitchVoteUI._update_multiple_votes_ui = function (self, arg_20_1)
	-- function 20
	local _active_vote = self._active_vote

	if not _active_vote then
		return
	end

	local num = 0
	local num_2 = 0

	for i = 1, 4 do
		local str = "hero_" .. i
		local var_20_4 = self._widgets[str]
		local profile_index = var_20_4.content.profile_index
		local var_20_6 = _active_vote.vote_percentages[profile_index]

		var_20_6 = var_20_6 or 0

		local style = var_20_4.style
		local num_3 = style.mask.base_size[2] * var_20_6

		style.mask.texture_size[2] = num_3

		if num < var_20_6 then
			num_2 = i
			num = var_20_6
		end
	end

	for j = 1, 4 do
		local str_2 = "hero_glow_" .. j
		local var_20_10 = self._widgets[str_2]
		local flag = j == num_2

		var_20_10.content.visible = flag
	end

	local timer = _active_vote.timer
	local abs = math.abs(math.ceil(timer))

	self._widgets.timer.content.text = abs

	self:_play_timer_sfx(abs)
end

TwitchVoteUI._show_multiple_choice_result = function (self)
	-- function 21
	self._fade_out = false

	local _vote_result = self._vote_result

	assert(_vote_result)
	WwiseWorld.trigger_event(self.wwise_world, "Play_twitch_vote_end")

	self._widgets = {}

	local multiple_choice_result = var_0_0.widgets.multiple_choice_result

	for k, v in pairs(multiple_choice_result) do
		self._widgets[k] = UIWidget.init(v)
	end

	local winner_text = self._widgets.winner_text
	local winner_portrait = self._widgets.winner_portrait
	local winning_index = _vote_result.winning_index

	print("winning_index", winning_index)
	assert(not (winning_index > 0) or winning_index <= 5)

	local human_and_bot_players = Managers.player:human_and_bot_players()

	for k_2, v_2 in pairs(human_and_bot_players) do
		local profile_index = v_2:profile_index()

		if profile_index == winning_index then
			local name = v_2:name()

			winner_text.content.text = name

			local var_21_8 = SPProfiles[profile_index]
			local career_index = v_2:career_index()
			local portrait_image = var_21_8.careers[career_index].portrait_image

			winner_portrait.content.portrait = portrait_image
			winner_portrait.content.visible = true
		end
	end

	local vote_template = _vote_result.vote_template

	if not vote_template then
		local result_icon = self._widgets.result_icon
		local texture_id = vote_template.texture_id

		result_icon.content.texture_id = texture_id

		local result_text = self._widgets.result_text
		local text = vote_template.text

		result_text.content.text = text
	end

	self._result_timer = num
end

TwitchVoteUI._update_result = function (self, arg_22_1)
	-- function 22
	self._result_timer = self._result_timer - arg_22_1

	if self._result_timer > 0 then
		return
	end

	self:hide_ui()
end

TwitchVoteUI._show_standard_vote = function (self)
	-- function 23
	local _active_vote = self._active_vote

	if not _active_vote then
		return
	end

	self._widgets = {}

	local standard_vote = var_0_0.widgets.standard_vote

	for k, v in pairs(standard_vote) do
		self._widgets[k] = UIWidget.init(v)
	end

	local vote_template_a = _active_vote.vote_template_a
	local vote_template_b = _active_vote.vote_template_b
	local vote_icon_a = self._widgets.vote_icon_a
	local texture_id = vote_template_a.texture_id
	local flag = true

	vote_icon_a.content.texture_id = texture_id

	local vote_icon_b = self._widgets.vote_icon_b
	local texture_id_2 = vote_template_b.texture_id
	local flag_2 = true

	vote_icon_b.content.texture_id = texture_id_2
	self._widgets.vote_icon_rect_a.content.visible = flag
	self._widgets.vote_icon_rect_b.content.visible = flag_2
	self._widgets.vote_text_a.content.text = vote_template_a.text
	self._widgets.vote_text_b.content.text = vote_template_b.text

	self:_play_standard_vote_start()
end

TwitchVoteUI._update_standard_vote = function (self)
	-- function 24
	local _active_vote = self._active_vote

	if not _active_vote then
		return
	end

	local timer = _active_vote.timer
	local abs = math.abs(math.ceil(timer))
	local timer_2 = self._widgets.timer

	if not timer_2 then
		table.dump(self._widgets, "### TWITCH VOTE UI CRASH INFO ###", 3)

		return
	end

	timer_2.content.text = abs

	self:_play_timer_sfx(abs)

	local vote_percentages = _active_vote.vote_percentages
	local var_24_5 = vote_percentages[1]
	local var_24_6 = vote_percentages[2]
	local size = scenegraph_definition.result_a_bar.size

	self._ui_scenegraph.result_a_bar.size[1] = math.ceil(size[1] * var_24_5)

	local size_2 = scenegraph_definition.result_b_bar.size

	self._ui_scenegraph.result_b_bar.size[1] = math.ceil(size_2[1] * var_24_6)
	self._widgets.result_bar_a_eyes.content.visible = var_24_6 <= var_24_5
	self._widgets.result_bar_b_eyes.content.visible = var_24_5 <= var_24_6
end

TwitchVoteUI._show_standard_vote_result = function (self)
	-- function 25
	self._fade_out = false

	local _vote_result = self._vote_result

	assert(_vote_result)

	self._widgets = {}

	local standard_vote_result = var_0_0.widgets.standard_vote_result

	for k, v in pairs(standard_vote_result) do
		self._widgets[k] = UIWidget.init(v)
	end

	self._result_timer = num

	local winning_template_name = _vote_result.winning_template_name

	assert(winning_template_name)

	local var_25_3 = TwitchVoteTemplates[winning_template_name]
	local texture_id = var_25_3.texture_id

	self._widgets.result_icon.content.texture_id = texture_id

	local cost = var_25_3.cost

	self:_play_winning_sfx(cost)

	local result_icon = self._widgets.result_icon
	local texture_id_2 = var_25_3.texture_id

	result_icon.content.texture_id = texture_id_2

	local flag = true

	self._widgets.result_icon_rect.content.visible = flag

	local result_text = self._widgets.result_text
	local text = var_25_3.text

	result_text.content.text = text

	local result_description_text = self._widgets.result_description_text

	if not var_25_3.description then
		local description = var_25_3.description

		result_description_text.content.text = description
	else
		result_description_text.content.visible = false
	end
end

TwitchVoteUI._sorted_player_list = function (arg_26_0)
	-- function 26
	local human_and_bot_players = Managers.player:human_and_bot_players()
	local tbl = {}

	for k, v in pairs(human_and_bot_players) do
		if not v:profile_index() then
			table.insert(tbl, v)
		end
	end

	local function fn(self, arg_27_1)
		-- function 27
		return self:profile_index() < arg_27_1:profile_index()
	end

	table.sort(tbl, fn)

	return tbl
end

TwitchVoteUI._play_winning_sfx = function (self, arg_28_1)
	-- function 28
	if arg_28_1 == nil then
		return
	end

	if arg_28_1 <= 0 then
		WwiseWorld.trigger_event(self.wwise_world, "Play_twitch_vote_end")
	else
		WwiseWorld.trigger_event(self.wwise_world, "Play_twitch_vote_evil_won")
	end
end

TwitchVoteUI._play_timer_sfx = function (self, arg_29_1)
	-- function 29
	if not (not (arg_29_1 <= num_2) or arg_29_1 == self._last_played_countdown_sfx) then
		WwiseWorld.trigger_event(self.wwise_world, "Play_twitch_count")

		self._last_played_countdown_sfx = arg_29_1
	end
end

TwitchVoteUI._play_multiple_vote_start = function (self)
	-- function 30
	WwiseWorld.trigger_event(self.wwise_world, "Play_twitch_vote_multiple_start")
end

TwitchVoteUI._play_standard_vote_start = function (self)
	-- function 31
	WwiseWorld.trigger_event(self.wwise_world, "Play_twitch_vote_standard_buff_start")
end
