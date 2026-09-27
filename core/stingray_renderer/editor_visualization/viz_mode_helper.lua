-- chunkname: @core/stingray_renderer/editor_visualization/viz_mode_helper.lua

local core = core

core = core or {}
core = core

local core_2 = core
local vis_modes = core.vis_modes

vis_modes = vis_modes or {}
core_2.vis_modes = vis_modes

core.render_vis_on = function (arg_1_0)
	-- function 1
	for k, v in pairs(core.vis_modes) do
		Application.set_render_setting(v, "false")
	end

	for k_2, v_2 in pairs(arg_1_0) do
		Application.set_render_setting(k_2, tostring(v_2))
		print(k_2 .. ":" .. tostring(v_2))

		core.vis_modes[k_2] = k_2
	end
end
