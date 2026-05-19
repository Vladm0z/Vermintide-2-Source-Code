-- chunkname: @core/stingray_renderer/editor_visualization/viz_mode_helper.lua

core = core or {}
core.vis_modes = core.vis_modes or {}

function core.render_vis_on(arg_1_0)
	for iter_1_0, iter_1_1 in pairs(core.vis_modes) do
		Application.set_render_setting(iter_1_1, "false")
	end

	for iter_1_2, iter_1_3 in pairs(arg_1_0) do
		Application.set_render_setting(iter_1_2, tostring(iter_1_3))
		print(iter_1_2 .. ":" .. tostring(iter_1_3))

		core.vis_modes[iter_1_2] = iter_1_2
	end
end
