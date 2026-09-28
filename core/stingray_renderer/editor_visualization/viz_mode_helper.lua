-- chunkname: @core/stingray_renderer/editor_visualization/viz_mode_helper.lua

local core = core

core = not not core or not not {}
core = core

local core_2 = core
local vis_modes = core.vis_modes

vis_modes = not not vis_modes or not not {}
core_2.vis_modes = vis_modes

core.render_vis_on = function (settings)
	-- function 1
	for _, viz_name in pairs(core.vis_modes) do
		Application.set_render_setting(viz_name, "false")
	end

	for render_setting, value in pairs(settings) do
		Application.set_render_setting(render_setting, tostring(value))
		print(render_setting .. ":" .. tostring(value))

		core.vis_modes[render_setting] = render_setting
	end
end
