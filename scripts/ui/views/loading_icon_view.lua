-- chunkname: @scripts/ui/views/loading_icon_view.lua

require("foundation/scripts/util/local_require")
require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local var_0_0 = require("scripts/ui/views/loading_icon_view_definitions")
local var_0_1 = 0.5
local var_0_2 = {
	frames_per_second = 30
}
local var_0_3 = "loadingicon_0000"
local var_0_4 = 86

var_0_2.image_db = {}

local var_0_5 = var_0_2.image_db

for iter_0_0 = 0, var_0_4 - 1 do
	var_0_5[#var_0_5 + 1] = var_0_3 .. string.format("%02d", iter_0_0)
end

LoadingIconView = class(LoadingIconView)

LoadingIconView.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_loading")
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:_create_ui_elements()

	arg_1_0._icon_fade_timer = 0
	arg_1_0._show_loading_icon = false
end

LoadingIconView._create_ui_elements = function (arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0._loading_icon_widget = UIWidget.init(var_0_0.loading_icon)
end

LoadingIconView.show_loading_icon = function (arg_3_0)
	arg_3_0._show_loading_icon = true
end

LoadingIconView.hide_loading_icon = function (arg_4_0)
	arg_4_0._show_loading_icon = false
end

LoadingIconView.show_icon_background = function (arg_5_0)
	arg_5_0._loading_icon_widget.style.background_rect.color[1] = 255
end

LoadingIconView.hide_icon_background = function (arg_6_0)
	arg_6_0._loading_icon_widget.style.background_rect.color[1] = 0
end

LoadingIconView.active = function (arg_7_0)
	return arg_7_0._show_loading_icon or arg_7_0._icon_fade_timer > 0
end

local var_0_6 = true

LoadingIconView.update = function (arg_8_0, arg_8_1)
	if var_0_6 then
		var_0_6 = false

		arg_8_0:_create_ui_elements()
	end

	if arg_8_0:active() then
		arg_8_0:_update_loading_icon(arg_8_1)
		arg_8_0:_draw(arg_8_1)
	end
end

LoadingIconView._update_loading_icon = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._loading_icon_widget
	local var_9_1 = var_9_0.content
	local var_9_2 = var_9_0.style.loading_icon
	local var_9_3 = var_9_1.current_index
	local var_9_4 = var_0_2
	local var_9_5 = 1 / var_9_4.frames_per_second

	if not arg_9_0.icon_timer then
		arg_9_0.icon_timer = var_9_5
	else
		local var_9_6 = arg_9_0.icon_timer - math.min(arg_9_1, 0.05)

		if var_9_6 <= 0 then
			local var_9_7 = 1 + var_9_3 % #var_9_4.image_db

			var_9_1.current_index = var_9_7
			var_9_1.loading_icon_id = var_9_4.image_db[var_9_7]
			arg_9_0.icon_timer = var_9_6 + var_9_5
		else
			arg_9_0.icon_timer = var_9_6
		end
	end

	if arg_9_0._show_loading_icon then
		arg_9_0._icon_fade_timer = math.clamp(arg_9_0._icon_fade_timer + arg_9_1, 0, var_0_1)
	else
		arg_9_0._icon_fade_timer = math.clamp(arg_9_0._icon_fade_timer - arg_9_1, 0, var_0_1)
	end

	var_9_2.color[1] = arg_9_0._icon_fade_timer / var_0_1 * 255
end

LoadingIconView._draw = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._ui_renderer
	local var_10_1 = arg_10_0._ui_scenegraph

	UIRenderer.begin_pass(var_10_0, var_10_1, FAKE_INPUT_SERVICE, arg_10_1, nil, arg_10_0._render_settings)
	UIRenderer.draw_widget(var_10_0, arg_10_0._loading_icon_widget)
	UIRenderer.end_pass(var_10_0)
end

LoadingIconView.destroy = function (arg_11_0)
	UIRenderer.destroy(arg_11_0._ui_renderer, arg_11_0._world)
end
