-- chunkname: @scripts/ui/hud_ui/news_feed_ui.lua

require("scripts/settings/news_feed_templates")

local var_0_0 = local_require("scripts/ui/hud_ui/news_feed_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local num = 0.8
local num_2 = 0.6
local num_3 = 0.6
local num_4 = 1.5
local num_5 = 10
local str = "exit"
local str_2 = "enter"
local MAX_NUMBER_OF_NEWS = var_0_0.MAX_NUMBER_OF_NEWS
local WIDGET_SIZE = var_0_0.WIDGET_SIZE
local NEWS_SPACING = var_0_0.NEWS_SPACING

NewsFeedUI = class(NewsFeedUI)

NewsFeedUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.peer_id = arg_1_2.peer_id
	self.player_manager = arg_1_2.player_manager
	self.ui_animations = {}
	self.is_in_inn = arg_1_2.is_in_inn

	self:_create_ui_elements()
end

NewsFeedUI._create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for i, v in ipairs(var_0_0.buff_widget_definitions) do
		tbl[i] = UIWidget.init(v)
		tbl_2[i] = tbl[i]
	end

	self._news_widgets = tbl
	self._unused_news_widgets = tbl_2
	self._active_news = {}
	self.conditions_params = {
		rarities_to_ignore = table.enum_safe("magic")
	}
	self.templates_on_cooldown = {}
	self.feed_sync_delay = num_4

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
	self:set_visible(true)
end

local tbl = {}
local tbl_2 = {}

NewsFeedUI._sync_news = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self.is_in_inn then
		return
	end

	local feed_sync_delay = self.feed_sync_delay

	if not feed_sync_delay then
		local max = math.max(0, feed_sync_delay - arg_3_1)

		if max == 0 then
			self.feed_sync_delay = nil
		else
			self.feed_sync_delay = max
		end

		return
	end

	local templates_on_cooldown = self.templates_on_cooldown

	for k, v in pairs(templates_on_cooldown) do
		if v > 0 then
			v = math.max(0, v - arg_3_1)

			if v == 0 then
				templates_on_cooldown[k] = nil
			else
				templates_on_cooldown[k] = v
			end
		end
	end

	local local_player = Managers.player:local_player(1)
	local player_unit = local_player.player_unit
	local conditions_params = self.conditions_params

	if not player_unit then
		local profile_display_name = local_player:profile_display_name()
		local career_name = local_player:career_name()

		if not (conditions_params.hero_name ~= profile_display_name or conditions_params.career_name == career_name) then
			while #self._active_news > 0 do
				self:_remove_entry(1)
			end
		end

		conditions_params.hero_name = profile_display_name
		conditions_params.career_name = career_name
	else
		return
	end

	local _active_news = self._active_news
	local player_unit_2 = Managers.player:local_player(1).player_unit
	local NewsFeedTemplates = NewsFeedTemplates

	if not player_unit_2 then
		table.clear(tbl_2)

		for k_2 = 1, #_active_news do
			_active_news[k_2].verified = false
		end

		local flag = false

		for i, v_2 in ipairs(NewsFeedTemplates) do
			local name = v_2.name
			local condition_func = v_2.condition_func

			if templates_on_cooldown[name] or condition_func(conditions_params) or not script_data.show_all_news_feed_items then
				local flag_2 = false

				for i5 = 1, #_active_news do
					local var_3_15 = _active_news[i5]

					if var_3_15.name == name then
						var_3_15.verified = true
						flag_2 = true

						break
					end
				end

				if not (flag_2 or flag) then
					tbl_2[#tbl_2 + 1] = name
					flag = true
				end
			end
		end

		table.clear(tbl)

		for iter_3_6, iter_3_7 in ripairs(_active_news) do
			if not iter_3_7.verified then
				tbl[#tbl + 1] = iter_3_6
			end
		end

		for i8 = 1, #tbl do
			local var_3_16 = tbl[i8]

			self:_mark_entry_for_removal(var_3_16)
		end

		local flag_3 = false

		for i_2, v_3 in ipairs(NewsFeedTemplates) do
			for i_3, v_4 in ipairs(tbl_2) do
				if v_4 ~= v_3.name or not self:_add_entry(v_3) then
					flag_3 = true
				end
			end
		end

		if not flag_3 then
			self:_update_alignment_duration()

			self.feed_sync_delay = num_4
		else
			self.feed_sync_delay = num_5
		end
	end
end

NewsFeedUI._add_entry = function (self, arg_4_1)
	-- function 4
	local name = arg_4_1.name
	local hidden = arg_4_1.hidden
	local duration = arg_4_1.duration
	local cooldown = arg_4_1.cooldown
	local infinite = arg_4_1.infinite
	local title = arg_4_1.title
	local description = arg_4_1.description
	local icon = arg_4_1.icon
	local icon_offset = arg_4_1.icon_offset
	local icon_size = arg_4_1.icon_size
	local _unused_news_widgets = self._unused_news_widgets

	if #self._active_news >= MAX_NUMBER_OF_NEWS then
		return false
	end

	local tbl = {
		state = "enter",
		name = name,
		duration = duration,
		cooldown = cooldown,
		infinite = infinite,
		anim_duration = num_2,
		removed_func = arg_4_1.removed_func
	}
	local _active_news = self._active_news

	_active_news[#_active_news + 1] = tbl

	local count = #self._active_news

	if not hidden then
		local remove = table.remove(_unused_news_widgets, 1)
		local content = remove.content
		local style = remove.style

		tbl.widget = remove
		content.title_text = Localize(title)
		content.text = Localize(description)
		content.is_infinite = infinite
		content.icon = icon
		style.icon.texture_size = icon_size
		style.icon.offset = icon_offset

		local num = WIDGET_SIZE[2] + NEWS_SPACING
		local offset = remove.offset

		if count > 1 then
			offset[2] = _active_news[count - 1].widget.offset[2] - num
		else
			offset[2] = 0
		end
	end

	if not arg_4_1.added_func then
		arg_4_1.added_func()
	end

	return true
end

NewsFeedUI._update_alignment_duration = function (self)
	-- function 5
	self._alignment_duration = num

	for i, v in ipairs(self._active_news) do
		local widget = v.widget

		if not widget then
			v.current_position = widget.offset[2]
		end
	end
end

NewsFeedUI._update_entries_expire_time = function (self, arg_6_1, arg_6_2)
	-- function 6
	for i, v in ipairs(self._active_news) do
		local duration = v.duration

		if not duration then
			local max = math.max(0, duration - arg_6_1)

			if max == 0 then
				v.duration = nil

				self:_mark_entry_for_removal(i)
			else
				v.duration = max
			end
		end
	end
end

NewsFeedUI._mark_entry_for_removal = function (self, arg_7_1)
	-- function 7
	local var_7_0 = self._active_news[arg_7_1]

	if var_7_0.state ~= str then
		var_7_0.state = str
		var_7_0.anim_duration = num_3
	end
end

NewsFeedUI._remove_entry = function (self, arg_8_1)
	-- function 8
	local _active_news = self._active_news
	local remove = table.remove(_active_news, arg_8_1)
	local widget = remove.widget

	if not widget then
		local _unused_news_widgets = self._unused_news_widgets

		table.insert(_unused_news_widgets, #_unused_news_widgets + 1, widget)
	end

	self:_update_alignment_duration()

	local name = remove.name
	local cooldown = remove.cooldown

	self.templates_on_cooldown[name] = cooldown

	local removed_func = remove.removed_func

	if not removed_func then
		removed_func()
	end
end

NewsFeedUI._update_alignment = function (self, arg_9_1)
	-- function 9
	local _alignment_duration = self._alignment_duration

	if not _alignment_duration then
		return
	end

	local max = math.max(_alignment_duration - arg_9_1, 0)
	local num_2 = max / num
	local easeCubic = math.easeCubic(num_2)

	if num_2 == 1 then
		self._alignment_duration = nil
	else
		self._alignment_duration = max
	end

	local num_3 = WIDGET_SIZE[2] + NEWS_SPACING
	local num_4 = 0

	for i, v in ipairs(self._active_news) do
		local widget = v.widget

		if not widget then
			local offset = widget.offset
			local current_position = v.current_position

			offset[2] = current_position - (current_position - num_4) * (1 - easeCubic)
			num_4 = num_4 - num_3
		end
	end
end

NewsFeedUI._update_state_animations = function (self, arg_10_1)
	-- function 10
	local num = WIDGET_SIZE[2] + NEWS_SPACING
	local num_3 = 0
	local _active_news = self._active_news

	for i, v in ipairs(_active_news) do
		local flag = false
		local state = v.state
		local anim_duration = v.anim_duration

		if not anim_duration then
			local max = math.max(anim_duration - arg_10_1, 0)
			local num_4 = 0

			if state == str_2 then
				num_4 = 1 - max / num_2

				if num_4 == 1 then
					v.anim_duration = nil
				else
					v.anim_duration = max
				end
			elseif state == str then
				num_4 = max / num_2

				if num_4 == 0 then
					v.anim_duration = nil
					flag = true
				else
					v.anim_duration = max
				end
			end

			if not flag then
				local widget = v.widget

				if not widget then
					self:_animate_widget(widget, state, num_4)
				end
			else
				v.delete = flag
			end
		end
	end

	for iter_10_2, iter_10_3 in ripairs(_active_news) do
		if not iter_10_3.delete then
			self:_remove_entry(iter_10_2)
		end
	end
end

NewsFeedUI._animate_widget = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local offset = arg_11_1.offset
	local style = arg_11_1.style
	local num = 0

	if arg_11_2 == str_2 then
		num = math.easeCubic(math.min(arg_11_3 * 2, 1))
	else
		num = math.easeCubic(arg_11_3)
	end

	offset[1] = 100 - num * 100

	local num_2 = num * 255

	style.text.text_color[1] = num_2
	style.text_shadow.text_color[1] = num_2
	style.title_text.text_color[1] = num_2
	style.title_text_shadow.text_color[1] = num_2
	style.background.color[1] = num_2
	style.icon.color[1] = num_2

	local effect = style.effect
	local color = effect.color

	if arg_11_2 == str_2 then
		color[1] = math.ease_pulse(arg_11_3) * 255
		effect.offset[1] = 120 - offset[1]

		local num_3 = 75
		local easeCubic = math.easeCubic(arg_11_3)

		effect.angle = math.degrees_to_radians(num_3 * easeCubic)
	elseif num_2 < color[1] then
		color[1] = num_2
	end
end

NewsFeedUI.set_position = function (self, arg_12_1, arg_12_2)
	-- function 12
	local local_position = self.ui_scenegraph.pivot.local_position

	local_position[1] = arg_12_1
	local_position[2] = arg_12_2
end

NewsFeedUI.destroy = function (self)
	-- function 13
	self:set_visible(false)
end

NewsFeedUI.set_visible = function (self, arg_14_1)
	-- function 14
	self._is_visible = arg_14_1

	local ui_renderer = self.ui_renderer
end

NewsFeedUI.update = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self._is_visible then
		return
	end

	self:_sync_news(arg_15_1, arg_15_2)
	self:_update_state_animations(arg_15_1)
	self:_update_alignment(arg_15_1)
	self:_handle_resolution_modified()
	self:_update_entries_expire_time(arg_15_1, arg_15_2)
	self:draw(arg_15_1)
end

NewsFeedUI._handle_resolution_modified = function (self)
	-- function 16
	if not RESOLUTION_LOOKUP.modified then
		self:_on_resolution_modified()
	end
end

NewsFeedUI._on_resolution_modified = function (arg_17_0)
	-- function 17
	return
end

NewsFeedUI.draw = function (self, arg_18_1)
	-- function 18
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_18_1)

	local _active_news = self._active_news

	for i = 1, #_active_news do
		local widget = _active_news[i].widget

		if not widget then
			UIRenderer.draw_widget(ui_renderer, widget)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end
