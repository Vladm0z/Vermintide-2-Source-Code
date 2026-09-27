-- chunkname: @scripts/ui/views/cutscene_overlay_ui.lua

local var_0_0 = local_require("scripts/ui/views/cutscene_overlay_ui_definitions")

CutsceneOverlayUI = class(CutsceneOverlayUI)

CutsceneOverlayUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer

	local world = Managers.world

	if not (not world and world:has_world("level_world")) then
		local world_2 = world:world("level_world")

		self._wwise_world = world:wwise_world(world_2)
	end

	local event = Managers.state.event

	if not event then
		self._registered_event = true

		event:register(self, "event_start_cutscene_overlay", "event_start_function")
	end

	self._render_settings = {
		alpha_multiplier = 1
	}
end

CutsceneOverlayUI.force_unregister_event_listener = function (self)
	-- function 2
	local event = Managers.state.event

	if not event and not self._registered_event then
		event:unregister("event_start_cutscene_overlay", self)
	end

	self._registered_event = nil
end

CutsceneOverlayUI._create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(self._templates) do
		tbl_2[k] = {
			text_widget = UIWidget.init(var_0_0.widget_definitions.text),
			image_widget = UIWidget.init(var_0_0.widget_definitions.image)
		}
		tbl[k] = {}
	end

	self._active_template_lists = tbl
	self._widgets_by_template = tbl_2
end

CutsceneOverlayUI.destroy = function (self)
	-- function 4
	local event = Managers.state.event

	if not event and not self._registered_event then
		event:unregister("event_start_cutscene_overlay", self)
	end
end

CutsceneOverlayUI.event_start_function = function (self, arg_5_1)
	-- function 5
	self:start(arg_5_1)
end

CutsceneOverlayUI.start = function (self, arg_6_1)
	-- function 6
	local templates = arg_6_1.templates

	self._templates = table.clone(templates)
	self._start_time = Managers.time:time("ui")
	self._complete = false

	self:_create_ui_elements()
end

CutsceneOverlayUI._present_template_entry = function (self, arg_7_1, arg_7_2)
	-- function 7
	local text = arg_7_2.text
	local image = arg_7_2.image
	local num = 255
	local duration = arg_7_2.duration
	local start_time = arg_7_2.start_time
	local end_time = arg_7_2.end_time
	local fade_in_duration = arg_7_2.fade_in_duration
	local fade_out_duration = arg_7_2.fade_out_duration
	local var_7_8 = self._widgets_by_template[arg_7_1]
	local var_7_9

	if not text then
		var_7_9 = var_7_8.text_widget

		local content = var_7_9.content
		local var_7_11

		if not arg_7_2.localize then
			var_7_11 = Localize(text)

			if not var_7_11 then
				-- Nothing
			end
		end

		var_7_11 = text

		::label_7_0::

		content.text = var_7_11

		local font_size = arg_7_2.font_size
		local font_type = arg_7_2.font_type
		local word_wrap = arg_7_2.word_wrap
		local font_upper_case = arg_7_2.font_upper_case
		local vertical_alignment = arg_7_2.vertical_alignment

		vertical_alignment = vertical_alignment or "center"

		if not arg_7_2.horizontal_alignment then
			local str = "center"
		end

		local color = arg_7_2.color

		color = color or Colors.get_color_table_with_alpha("white", 255)

		local offset = arg_7_2.offset
		local use_shadow = arg_7_2.use_shadow
		local inject_alpha = arg_7_2.inject_alpha
		local style = var_7_9.style
		local text_2 = style.text
		local text_shadow = style.text_shadow
		local text_color = text_2.text_color

		num = color[1]
		text_color[2] = color[2]
		text_color[3] = color[3]
		text_color[4] = color[4]
		text_2.inject_alpha = inject_alpha
		text_2.font_size = font_size
		text_shadow.font_size = font_size
		text_2.font_type = font_type
		text_shadow.font_type = font_type
		text_2.word_wrap = word_wrap
		text_shadow.word_wrap = word_wrap
		text_2.upper_case = font_upper_case
		text_shadow.upper_case = font_upper_case
		text_2.vertical_alignment = vertical_alignment
		text_shadow.vertical_alignment = vertical_alignment

		if use_shadow ~= nil then
			content.use_shadow = use_shadow
		end

		local offset_2 = text_2.offset
		local offset_3 = text_shadow.offset

		offset_2[1] = offset[1]
		offset_2[2] = offset[2]
		offset_2[3] = offset[3]
		offset_3[1] = offset[1] + 2
		offset_3[2] = offset[2] - 2
		offset_3[3] = offset[3] - 1
	elseif not image then
		var_7_9 = var_7_8.image_widget
		var_7_9.content.texture_id = image

		local texture_id = var_7_9.style.texture_id
		local offset_4 = texture_id.offset
		local offset_5 = arg_7_2.offset

		offset_4[1] = offset_5[1]
		offset_4[2] = offset_5[2]
		offset_4[3] = offset_5[3]

		local image_size = arg_7_2.image_size
		local texture_size = texture_id.texture_size

		texture_size[1] = image_size[1]
		texture_size[2] = image_size[2]
	end

	return {
		initialized = false,
		text = text,
		image = image,
		duration = duration,
		widget = var_7_9,
		max_alpha = num,
		start_time = start_time,
		end_time = end_time,
		fade_in_duration = not fade_in_duration and not (fade_in_duration > 0) or fade_in_duration,
		fade_out_duration = not fade_out_duration and not (fade_out_duration > 0) or fade_out_duration
	}
end

CutsceneOverlayUI._convert_string_timestamp_to_float = function (arg_8_0, arg_8_1)
	-- function 8
	local match, var_8_1, var_8_2 = string.match(arg_8_1, "(%d+)%:(%d+)%:(%d+)")
	local num = match * 60 + var_8_1 + var_8_2 * 0.01
end

CutsceneOverlayUI._has_list_entries = function (self, arg_9_1)
	-- function 9
	return #self._templates[arg_9_1] > 0
end

CutsceneOverlayUI._get_entry_by_time = function (self, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = self._templates[arg_10_1]
	local var_10_1 = var_10_0[1]

	if not var_10_1 then
		return
	end

	local start_time = var_10_1.start_time

	if arg_10_2 >= var_10_1.end_time then
		table.remove(var_10_0, 1)

		return self:_get_entry_by_time(arg_10_1, arg_10_2)
	end

	if start_time <= arg_10_2 then
		return table.remove(var_10_0, 1)
	end
end

CutsceneOverlayUI.update = function (self, arg_11_1)
	-- function 11
	if not self._start_time and not self._complete then
		return
	end

	local num = Managers.time:time("ui") - self._start_time
	local flag = true

	for k, v in pairs(self._active_template_lists) do
		local flag_2 = false
		local active_entry_data = v.active_entry_data

		if not active_entry_data then
			local start_time = active_entry_data.start_time
			local end_time = active_entry_data.end_time
			local duration = active_entry_data.duration

			if num > start_time + duration then
				v.active_entry_data = nil
			else
				local widget = active_entry_data.widget
				local fade_out_duration = active_entry_data.fade_out_duration
				local fade_in_duration = active_entry_data.fade_in_duration
				local max_alpha = active_entry_data.max_alpha
				local num_2 = 1

				if not (not fade_in_duration and not (num <= start_time + fade_in_duration)) then
					num_2 = math.min((num - start_time) / fade_in_duration, 1)
				elseif not (not fade_out_duration and not (num >= start_time + duration - fade_out_duration)) then
					num_2 = 1 - math.min((num - (end_time - fade_out_duration)) / fade_out_duration, 1)
				end

				self:_fade(widget, max_alpha, num_2)
				self:_draw(widget, arg_11_1)
			end
		elseif not self:_has_list_entries(k) then
			self._active_template_lists[k] = nil
			flag_2 = true
		else
			local _get_entry_by_time = self:_get_entry_by_time(k, num)
			local flag_3 = not _get_entry_by_time and self:_present_template_entry(k, _get_entry_by_time)

			v.active_entry_data = flag_3

			if not (not flag_3 and flag_3.initialized) then
				flag_3.initialized = true

				local sound_event = flag_3.sound_event

				if not sound_event and not self._wwise_world then
					WwiseWorld.trigger_event(self._wwise_world, sound_event)
				end
			end
		end

		if not flag_2 then
			flag = false
		end
	end

	self._complete = flag
end

CutsceneOverlayUI._fade = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local num = arg_12_3 * arg_12_2
	local style = arg_12_1.style

	if not style.text then
		local text_color = style.text.text_color
		local text_color_2 = style.text_shadow.text_color

		text_color[1] = num
		text_color_2[1] = num
	else
		style.texture_id.color[1] = num
	end
end

CutsceneOverlayUI._draw = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE
	local render_settings = self.render_settings

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, arg_13_2, render_settings)
	UIRenderer.draw_widget(_ui_renderer, arg_13_1)
	UIRenderer.end_pass(_ui_renderer)
end
