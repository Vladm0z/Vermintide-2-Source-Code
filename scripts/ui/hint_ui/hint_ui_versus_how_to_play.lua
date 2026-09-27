-- chunkname: @scripts/ui/hint_ui/hint_ui_versus_how_to_play.lua

require("scripts/ui/hint_ui/hint_ui")

HintUIVersusHowToPlay = class(HintUIVersusHowToPlay, HintUI)

HintUIVersusHowToPlay.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	HintUIVersusHowToPlay.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._shown = false
	self._duration = self._hint_data.duration
	self._gamepad_active = Managers.input:is_device_active("gamepad")
end

HintUIVersusHowToPlay.create_ui_elements = function (self)
	-- function 2
	local data = self._hint_settings.data

	data.definitions.widget_definitions.hint_widgets = UIWidgets.create_versus_gameplay_hint_widget("hint_anchor", data)

	HintUIVersusHowToPlay.super.create_ui_elements(self)
end

HintUIVersusHowToPlay.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self._shown then
		return
	end

	if not (not self._duration and self._shown or self._start_t) then
		self._start_t = arg_3_2

		self:start_animation("enter", self._widgets_by_name.hint_widgets)
	end

	if not (not self._duration and not (arg_3_2 <= self._start_t + self._duration)) then
		local hint_widgets = self._widgets_by_name.hint_widgets
		local content = hint_widgets.content

		if not content.duration_bar then
			local uvs = content.duration_bar.uvs
			local _duration = self._duration
			local num = 1 - (self._start_t + self._duration - arg_3_2) / _duration

			uvs[2][1] = num
			hint_widgets.style.duration_bar.texture_size[1] = 400 * num
		end
	end

	if not self._hint_data.input_data then
		self:_update_input(arg_3_1, arg_3_2, self._hint_data.input_data)
	end

	HintUIVersusHowToPlay.super.update(self, arg_3_1, arg_3_2)

	if not self._start_t then
		if not (not (arg_3_2 > self._start_t + self._duration) or self._is_exiting) then
			local tbl = {
				wwise_world = self._wwise_world,
				render_settings = self._render_settings,
				self = self
			}

			self:start_animation("exit", self._widgets_by_name.hint_widgets, tbl)

			self._is_exiting = true
		end

		if not (not self:should_show() and self._has_widget_been_closed) then
			self:show()
		end
	end
end

HintUIVersusHowToPlay.show = function (self)
	-- function 4
	HintUIVersusHowToPlay.super.show(self)
	self:_set_hint_widget_size()
end

HintUIVersusHowToPlay._set_hint_widget_size = function (self)
	-- function 5
	local hint_widgets = self._widgets_by_name.hint_widgets
	local content = hint_widgets.content
	local style = hint_widgets.style
	local title_text = style.title_text
	local body_text = style.body_text
	local get_text_height = UIUtils.get_text_height(self._ui_top_renderer, title_text.size, title_text, content.title_text)
	local get_text_height_2, var_5_7 = UIUtils.get_text_height(self._ui_top_renderer, body_text.size, body_text, content.body_text)
	local num = get_text_height + get_text_height_2 + var_5_7 * 2 + 10

	if not self._duration then
		num = num + 8
	end

	if not self._hint_data.foot_text then
		local foot_text = style.foot_text
		local get_text_height_3, var_5_11 = UIUtils.get_text_height(self._ui_top_renderer, foot_text.size, foot_text, content.foot_text)

		num = num + get_text_height_3 + var_5_11 * 2
	end

	if not self._hint_data.icon then
		num = num + style.foot_icon.texture_size[2] / 2 - 5
	end

	content.size[2] = num
	hint_widgets.offset[2] = -(num / 2)
end

HintUIVersusHowToPlay._update_input = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not arg_6_3.input_action then
		return
	end

	local is_device_active = Managers.input:is_device_active("gamepad")

	if self._gamepad_active ~= is_device_active then
		self._gamepad_active = is_device_active

		local input_action = arg_6_3.input_action

		input_action = not input_action and not is_device_active and arg_6_3.gamepad_action and input_action

		local str = "$KEY;" .. arg_6_3.input_service_name .. "__" .. input_action .. ":"
		local format = string.format(Localize(self._hint_data.foot_text), str)

		self._widgets_by_name.hint_widgets.content.foot_text = format
	end
end

HintUIVersusHowToPlay.hide = function (self)
	-- function 7
	self._shown = true
	self._has_widget_been_closed = true
	self._exit_anim_id = nil

	HintUIVersusHowToPlay.super.hide(self)
end
