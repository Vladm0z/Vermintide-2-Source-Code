-- chunkname: @scripts/ui/views/skip_input_ui.lua

local var_0_0 = local_require("scripts/ui/views/skip_input_ui_definitions")

SkipInputUI = class(SkipInputUI)

SkipInputUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._context = arg_1_2
	self._skip = false
	self._render_settings = {
		alpha_multiplier = 0,
		internal_alpha_multiplier = 0,
		snap_pixel_positions = false
	}

	self:_create_ui_elements()
end

SkipInputUI._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local _ui_renderer = self._ui_renderer
	local input_service = self._parent:input_service()

	input_service = input_service or FAKE_INPUT_SERVICE

	local create_skip_widget = var_0_0.create_skip_widget(self, _ui_renderer, input_service)

	self._skip_widget = UIWidget.init(create_skip_widget)
end

SkipInputUI.destroy = function (arg_3_0)
	-- function 3
	return
end

SkipInputUI.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	self:_update_input(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	self:_draw(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
end

SkipInputUI._update_input = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local internal_alpha_multiplier = self._render_settings.internal_alpha_multiplier

	if not self._active then
		internal_alpha_multiplier = not arg_5_3 and not arg_5_3:get("cancel_video") and 1 and math.max(internal_alpha_multiplier - arg_5_1 * 2, 0)
	end

	if arg_5_3:get("left_release") or not arg_5_3:get("confirm") then
		self._active = true
	end

	self._render_settings.internal_alpha_multiplier = internal_alpha_multiplier
end

SkipInputUI.skip = function (self)
	-- function 6
	self._skip = true
end

SkipInputUI.skipped = function (self)
	-- function 7
	local _skip = self._skip

	self._skip = false

	return _skip
end

SkipInputUI._draw = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local _parent = self._parent
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local flag = arg_8_3 or FAKE_INPUT_SERVICE
	local alpha_multiplier

	if not arg_8_4 then
		alpha_multiplier = arg_8_4.alpha_multiplier

		if not alpha_multiplier then
			-- Nothing
		end
	end

	alpha_multiplier = 1

	::label_8_0::

	_render_settings.alpha_multiplier = alpha_multiplier * _render_settings.internal_alpha_multiplier

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, flag, arg_8_1, nil, _render_settings)
	UIRenderer.draw_widget(_ui_renderer, self._skip_widget)
	UIRenderer.end_pass(_ui_renderer)
end
