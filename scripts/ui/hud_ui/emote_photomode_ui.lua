-- chunkname: @scripts/ui/hud_ui/emote_photomode_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/emote_photomode_ui_definitions")
local widgets = var_0_0.widgets
local widgets_pc = var_0_0.widgets_pc
local widgets_gamepad = var_0_0.widgets_gamepad
local scenegraph_definition = var_0_0.scenegraph_definition

EmotePhotomodeUI = class(EmotePhotomodeUI)

local flag = false

EmotePhotomodeUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ingame_ui_context = arg_1_2
	self._render_settings = {}

	self:_create_ui_elements()

	self._is_enabled = false
end

EmotePhotomodeUI.destroy = function (arg_2_0)
	-- function 2
	return
end

EmotePhotomodeUI._create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local _render_settings = self._render_settings

	_render_settings = _render_settings or {}
	self._render_settings = _render_settings
	self._widgets = {}

	for k, v in pairs(widgets) do
		local var_3_1 = UIWidget.init(v)

		self._widgets[k] = var_3_1
	end

	self._widgets_pc = {}

	for k_2, v_2 in pairs(widgets_pc) do
		local var_3_2 = UIWidget.init(v_2)

		self._widgets_pc[k_2] = var_3_2
	end

	self._widgets_gamepad = {}

	for k_3, v_3 in pairs(widgets_gamepad) do
		local var_3_3 = UIWidget.init(v_3)

		self._widgets_gamepad[k_3] = var_3_3
	end

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

EmotePhotomodeUI.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._is_enabled then
		return
	end

	self:_draw(arg_4_1, arg_4_2)
end

EmotePhotomodeUI.set_enabled = function (self, arg_5_1)
	-- function 5
	self._is_enabled = arg_5_1
end

EmotePhotomodeUI._draw = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local get_service = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_6_1, nil, _render_settings)

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	if not Managers.input:is_device_active("gamepad") then
		for k_2, v_2 in pairs(self._widgets_gamepad) do
			UIRenderer.draw_widget(_ui_renderer, v_2)
		end
	else
		for k_3, v_3 in pairs(self._widgets_pc) do
			UIRenderer.draw_widget(_ui_renderer, v_3)
		end
	end

	UIRenderer.end_pass(_ui_renderer)
end
