-- chunkname: @scripts/ui/views/loading_icon_view.lua

require("foundation/scripts/util/local_require")
require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local scripts_ui_views_loading_icon_view_definitions = require("scripts/ui/views/loading_icon_view_definitions")
local num = 0.5
local tbl = {
	frames_per_second = 30
}
local str = "loadingicon_0000"
local num_2 = 86

tbl.image_db = {}

local image_db = tbl.image_db

for i = 0, num_2 - 1 do
	image_db[#image_db + 1] = str .. string.format("%02d", i)
end

LoadingIconView = class(LoadingIconView)

LoadingIconView.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_loading")
	self._render_settings = {
		snap_pixel_positions = true
	}

	self:_create_ui_elements()

	self._icon_fade_timer = 0
	self._show_loading_icon = false
end

LoadingIconView._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scripts_ui_views_loading_icon_view_definitions.scenegraph_definition)
	self._loading_icon_widget = UIWidget.init(scripts_ui_views_loading_icon_view_definitions.loading_icon)
end

LoadingIconView.show_loading_icon = function (self)
	-- function 3
	self._show_loading_icon = true
end

LoadingIconView.hide_loading_icon = function (self)
	-- function 4
	self._show_loading_icon = false
end

LoadingIconView.show_icon_background = function (arg_5_0)
	-- function 5
	arg_5_0._loading_icon_widget.style.background_rect.color[1] = 255
end

LoadingIconView.hide_icon_background = function (arg_6_0)
	-- function 6
	arg_6_0._loading_icon_widget.style.background_rect.color[1] = 0
end

LoadingIconView.active = function (self)
	-- function 7
	local _show_loading_icon = self._show_loading_icon

	_show_loading_icon = _show_loading_icon or self._icon_fade_timer > 0

	return _show_loading_icon
end

local flag = true

LoadingIconView.update = function (self, arg_8_1)
	-- function 8
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	if not self:active() then
		self:_update_loading_icon(arg_8_1)
		self:_draw(arg_8_1)
	end
end

LoadingIconView._update_loading_icon = function (self, arg_9_1)
	-- function 9
	local _loading_icon_widget = self._loading_icon_widget
	local content = _loading_icon_widget.content
	local loading_icon = _loading_icon_widget.style.loading_icon
	local current_index = content.current_index
	local var_9_4 = tbl
	local num_2 = 1 / var_9_4.frames_per_second

	if not self.icon_timer then
		self.icon_timer = num_2
	else
		local num_3 = self.icon_timer - math.min(arg_9_1, 0.05)

		if num_3 <= 0 then
			local num_4 = 1 + current_index % #var_9_4.image_db

			content.current_index = num_4
			content.loading_icon_id = var_9_4.image_db[num_4]
			self.icon_timer = num_3 + num_2
		else
			self.icon_timer = num_3
		end
	end

	if not self._show_loading_icon then
		self._icon_fade_timer = math.clamp(self._icon_fade_timer + arg_9_1, 0, num)
	else
		self._icon_fade_timer = math.clamp(self._icon_fade_timer - arg_9_1, 0, num)
	end

	loading_icon.color[1] = self._icon_fade_timer / num * 255
end

LoadingIconView._draw = function (self, arg_10_1)
	-- function 10
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, arg_10_1, nil, self._render_settings)
	UIRenderer.draw_widget(_ui_renderer, self._loading_icon_widget)
	UIRenderer.end_pass(_ui_renderer)
end

LoadingIconView.destroy = function (self)
	-- function 11
	UIRenderer.destroy(self._ui_renderer, self._world)
end
