-- chunkname: @scripts/ui/hud_ui/buff_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/buff_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local MAX_BUFF_ROWS = var_0_0.MAX_BUFF_ROWS
local MAX_BUFF_COLUMNS = var_0_0.MAX_BUFF_COLUMNS
local MAX_NUMBER_OF_BUFFS = var_0_0.MAX_NUMBER_OF_BUFFS
local BUFF_SIZE = var_0_0.BUFF_SIZE
local BUFF_SPACING = var_0_0.BUFF_SPACING

local function fn(self)
	-- function 1
	return not self.duration and self.duration == math.huge
end

local function fn_2(self, arg_2_1)
	-- function 2
	local content = self.content
	local content_2 = arg_2_1.content
	local buff = content.buff
	local buff_2 = content_2.buff

	if fn(buff) ~= fn(buff_2) then
		return fn(buff_2)
	end

	return content_2.static_start_time < content.static_start_time
end

local function fn_3(self)
	-- function 3
	local huge

	if not fn(self) then
		huge = math.huge

		if not huge then
			-- Nothing
		end
	end

	huge = self.start_time + self.duration

	::label_3_0::

	return huge
end

BuffUI = class(BuffUI)

BuffUI.init = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._ui_renderer = arg_4_2.ui_renderer
	self._player = arg_4_2.player
	self._is_spectator = false
	self._spectated_player_unit = nil
	self._render_settings = {
		alpha_multiplier = 1
	}

	self:_create_ui_elements()
	Managers.state.event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
	Managers.state.event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
	Managers.state.event:register(self, "on_game_options_changed", "on_game_options_changed")
end

BuffUI._set_widget_dirty = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_1.element.dirty = true
end

BuffUI.on_game_options_changed = function (self)
	-- function 6
	local _insignia_visibility = self._insignia_visibility
	local user_setting = Application.user_setting("toggle_versus_level_in_all_game_modes")
	local flag = Managers.mechanism:current_mechanism_name() == "versus" or user_setting

	if _insignia_visibility ~= flag then
		local position = self._ui_scenegraph.pivot_parent.position
		local INSIGNIA_OFFSET

		if not flag then
			INSIGNIA_OFFSET = UISettings.INSIGNIA_OFFSET

			if not INSIGNIA_OFFSET then
				-- Nothing
			end
		end

		INSIGNIA_OFFSET = 0

		::label_6_0::

		position[1] = INSIGNIA_OFFSET

		for i = 1, #self._active_buff_widgets do
			self:_set_widget_dirty(self._active_buff_widgets[i])
		end

		self._dirty = true
		self._insignia_visibility = flag
	end
end

BuffUI._create_ui_elements = function (self)
	-- function 7
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}

	for i = 1, MAX_NUMBER_OF_BUFFS do
		tbl[i] = UIWidget.init(var_0_0.buff_widget_definition)
	end

	self._unused_buff_widgets = tbl
	self._active_buff_widgets = {}
	self._buff_name_to_widget = {}

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
	self:set_visible(true)

	self._dirty = true
	self._current_career_index = -1

	self:on_game_options_changed()
end

BuffUI.on_spectator_target_changed = function (self, arg_8_1)
	-- function 8
	self._spectated_player_unit = arg_8_1
	self._is_spectator = true

	self:set_visible(false)
	self:set_visible(true)

	self._dirty = true
	self._current_career_index = ScriptUnit.extension(arg_8_1, "career_system"):career_index()
end

BuffUI._sync_buffs = function (self)
	-- function 9
	local _active_buff_widgets = self._active_buff_widgets
	local flag = false

	for i = 1, #_active_buff_widgets do
		_active_buff_widgets[i].content.stack_count = 0
	end

	local _spectated_player_unit

	if not self._is_spectator then
		_spectated_player_unit = self._spectated_player_unit

		if not _spectated_player_unit then
			-- Nothing
		end
	end

	_spectated_player_unit = self._player.player_unit

	::label_9_0::

	local has_extension = ScriptUnit.has_extension(_spectated_player_unit, "buff_system")

	if not has_extension then
		local active_buffs, var_9_5 = has_extension:active_buffs()

		for j = 1, #active_buffs do
			local var_9_6 = active_buffs[j]
			local var_9_7

			if not var_9_6.removed then
				local template = var_9_6.template

				var_9_7 = template.icon

				if not template.icon_modifier_func then
					var_9_7 = template.icon_modifier_func(_spectated_player_unit, var_9_7)
				end
			end

			if not var_9_7 and not self:_add_buff(var_9_6, var_9_7) then
				flag = true
			end
		end
	end

	if not flag then
		table.sort(_active_buff_widgets, fn_2)
	end

	local num = BUFF_SIZE[1] + BUFF_SPACING
	local num_2 = BUFF_SIZE[2] + BUFF_SPACING
	local time = Managers.time:time("game")
	local num_3 = -1

	for k = #_active_buff_widgets, 1, -1 do
		local var_9_13 = _active_buff_widgets[k]
		local content = var_9_13.content

		if content.stack_count == 0 or not content.buff.is_stale then
			self:_remove_buff(k)

			flag = true
			var_9_13.element.dirty = true
			self._dirty = true
		else
			local buff = content.buff

			if not fn(buff) then
				local duration = buff.duration

				duration = duration or math.huge

				if duration == 0 then
					content.progress = 0
				else
					local var_9_17 = fn_3(buff)

					content.progress = 1 - math.clamp((var_9_17 - time) / duration, 0, 1)
				end

				var_9_13.element.dirty = true
				self._dirty = true
			elseif content.stack_count ~= content.last_stack_count then
				content.last_stack_count = content.stack_count

				local flag_2

				flag_2 = not buff.template.is_cooldown and 1 and 0
				content.progress = flag_2
				var_9_13.element.dirty = true
				self._dirty = true
			end

			num_3 = num_3 + 1

			if not flag then
				local offset = var_9_13.offset
				local num_4 = num_3 % MAX_BUFF_COLUMNS
				local floor = math.floor(num_3 / MAX_BUFF_COLUMNS)

				offset[1] = num * num_4
				offset[2] = num_2 * floor
				var_9_13.element.dirty = true
				self._dirty = true
			end
		end
	end
end

local tbl = {
	255,
	48,
	255,
	0
}
local tbl_2 = {
	255,
	255,
	30,
	0
}

BuffUI._add_buff = function (self, arg_10_1, arg_10_2)
	-- function 10
	local template = arg_10_1.template
	local start_time = arg_10_1.start_time
	local var_10_2 = fn_3(arg_10_1)
	local var_10_3 = fn(arg_10_1)
	local is_cooldown = template.is_cooldown
	local var_10_5 = self._buff_name_to_widget[template.name]

	if not var_10_5 then
		local content = var_10_5.content

		content.stack_count = content.stack_count + 1

		if var_10_2 < fn_3(content.buff) then
			content.buff = arg_10_1
			var_10_5.style.texture_icon.saturated = is_cooldown
			var_10_5.style.texture_icon_bg.saturated = not is_cooldown and var_10_3
		end

		return false
	end

	local _active_buff_widgets = self._active_buff_widgets
	local count = #_active_buff_widgets

	if count >= MAX_NUMBER_OF_BUFFS then
		return false
	end

	local remove = table.remove(self._unused_buff_widgets)
	local content_2 = remove.content

	content_2.texture_icon = arg_10_2
	content_2.is_cooldown = is_cooldown
	content_2.buff = arg_10_1
	content_2.name = template.name
	content_2.static_start_time = start_time
	content_2.stack_count = 1

	local flag

	flag = not is_cooldown and 1 and 0
	content_2.progress = flag

	UIRenderer.set_element_visible(self._ui_renderer, remove.element, true)

	local style = remove.style
	local var_10_13

	if not template.debuff then
		var_10_13 = tbl_2

		if not var_10_13 then
			-- Nothing
		end
	end

	var_10_13 = tbl

	::label_10_0::

	Colors.copy_to(style.texture_duration.color, var_10_13)

	style.texture_icon.saturated = is_cooldown
	style.texture_icon_bg.saturated = not is_cooldown and var_10_3
	self._buff_name_to_widget[template.name] = remove
	_active_buff_widgets[count + 1] = remove

	return true
end

BuffUI._remove_buff = function (self, arg_11_1)
	-- function 11
	local remove = table.remove(self._active_buff_widgets, arg_11_1)
	local _unused_buff_widgets = self._unused_buff_widgets

	_unused_buff_widgets[#_unused_buff_widgets + 1] = remove
	self._buff_name_to_widget[remove.content.name] = nil

	UIRenderer.set_element_visible(self._ui_renderer, remove.element, false)
end

BuffUI.destroy = function (self)
	-- function 12
	self:set_visible(false)
	Managers.state.event:unregister("on_spectator_target_changed", self)
	Managers.state.event:unregister("on_game_options_changed", self)
end

BuffUI.set_visible = function (self, arg_13_1)
	-- function 13
	self._is_visible = arg_13_1

	local _ui_renderer = self._ui_renderer
	local _active_buff_widgets = self._active_buff_widgets

	for i = 1, #_active_buff_widgets do
		local var_13_2 = _active_buff_widgets[i]

		UIRenderer.set_element_visible(_ui_renderer, var_13_2.element, arg_13_1)
	end

	self._dirty = true
end

local tbl_3 = {
	root_scenegraph_id = "pivot",
	label = "Buff bar",
	registry_key = "buff_ui",
	drag_scenegraph_id = "pivot_dragger"
}

BuffUI.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	if not HudCustomizer.run(self._ui_renderer, self._ui_scenegraph, tbl_3) then
		UIUtils.mark_dirty(self._active_buff_widgets)

		self._dirty = true
	end

	self:_sync_buffs()

	if not RESOLUTION_LOOKUP.modified then
		UIUtils.mark_dirty(self._active_buff_widgets)

		self._dirty = true
	end

	self:draw(arg_14_1)
end

BuffUI.draw = function (self, arg_15_1)
	-- function 15
	if not (not self._is_visible and self._dirty) then
		return
	end

	local _ui_renderer = self._ui_renderer

	UIRenderer.begin_pass(_ui_renderer, self._ui_scenegraph, FAKE_INPUT_SERVICE, arg_15_1, nil, self._render_settings)

	local _active_buff_widgets = self._active_buff_widgets

	for i = #_active_buff_widgets, 1, -1 do
		UIRenderer.draw_widget(_ui_renderer, _active_buff_widgets[i])
	end

	UIRenderer.end_pass(_ui_renderer)

	self._dirty = false
end

BuffUI.set_panel_alpha = function (self, arg_16_1)
	-- function 16
	local _render_settings = self._render_settings

	if _render_settings.alpha_multiplier ~= arg_16_1 then
		_render_settings.alpha_multiplier = arg_16_1

		UIUtils.mark_dirty(self._active_buff_widgets)

		self._dirty = true
	end
end
