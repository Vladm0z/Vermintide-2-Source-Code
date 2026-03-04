-- chunkname: @scripts/imgui/imgui_umbra_debug.lua

ImguiUmbraDebug = class(ImguiUmbraDebug)

local var_0_0 = true

ImguiUmbraDebug.init = function (arg_1_0)
	arg_1_0.enable_debug = false
	arg_1_0.debug_options = {
		{
			mask = 16,
			name = "Draw Viewcell",
			enabled = false,
			query = 0
		},
		{
			mask = 32,
			name = "Draw Portals",
			enabled = false,
			query = 0
		},
		{
			mask = 64,
			name = "Draw Visibility Lines",
			enabled = false,
			query = 0
		},
		{
			mask = 128,
			name = "Draw Object bounds",
			enabled = false,
			query = 0
		},
		{
			mask = 256,
			name = "Draw Visible Volume",
			enabled = false,
			query = 0
		},
		{
			mask = 512,
			name = "Draw View Frustum",
			enabled = false,
			query = 0
		},
		{
			mask = 32,
			name = "Draw Shadow Projection",
			enabled = false,
			query = 1
		},
		{
			mask = 1024,
			name = "Show Statistics",
			enabled = false,
			query = 0
		},
		{
			mask = 1,
			name = "Single Threaded Query",
			enabled = false,
			query = 2
		},
		{
			mask = 2,
			name = "Show Occlusion Buffer",
			enabled = false,
			query = 2
		},
		{
			mask = 4,
			name = "Show Shadow Mask Buffer",
			enabled = false,
			query = 2
		},
		{
			mask = 8,
			name = "Draw Visible Objects",
			enabled = false,
			query = 2
		},
		{
			mask = 16,
			name = "Draw Culled Shadow Casters",
			enabled = false,
			query = 2
		},
		{
			mask = 32,
			name = "Draw Visible Shadow Casters",
			enabled = false,
			query = 2
		}
	}
	arg_1_0.debug_config = {}
	arg_1_0.debug_config.portal_query_distance = {
		speed = 1,
		idx = 0,
		min = 0,
		max = 100
	}
	arg_1_0.debug_config.portal_query_accurate_occlusion_threshold = {
		speed = 1,
		idx = 1,
		min = 0,
		max = 255
	}
	arg_1_0.debug_config.portal_query_contribution_threshold_distance = {
		speed = 1,
		idx = 2,
		min = 0,
		max = 255
	}
	arg_1_0.debug_config.portal_query_contribution_threshold = {
		speed = 1,
		idx = 3,
		min = 0,
		max = 1
	}
	arg_1_0.sub_windows = {
		{
			option = arg_1_0.debug_options[10],
			draw = World.imgui_draw_umbra_debug_occlusion_buffer
		},
		{
			option = arg_1_0.debug_options[11],
			draw = World.imgui_draw_umbra_debug_shadowmask_buffer
		},
		{
			option = arg_1_0.debug_options[8],
			draw = World.imgui_draw_umbra_debug_statistics
		}
	}
end

ImguiUmbraDebug.update = function (arg_2_0)
	if var_0_0 then
		ImguiUmbraDebug:init()

		var_0_0 = false
	end
end

ImguiUmbraDebug.is_persistent = function (arg_3_0)
	return arg_3_0:_has_floater()
end

ImguiUmbraDebug._has_floater = function (arg_4_0)
	local var_4_0 = 0

	if arg_4_0.enable_debug == false then
		return false
	end

	for iter_4_0, iter_4_1 in ipairs(arg_4_0.sub_windows) do
		var_4_0 = var_4_0 + (iter_4_1.option.enabled == true and 1 or 0)
	end

	return var_4_0 > 0
end

ImguiUmbraDebug.draw = function (arg_5_0, arg_5_1)
	if not Managers.world:has_world("level_world") then
		return
	end

	local var_5_0 = Managers.world:world("level_world")
	local var_5_1 = false

	if arg_5_1 then
		var_5_1 = Imgui.begin_window("Umbra Debug")
		arg_5_0.enable_debug = Imgui.checkbox("Enable Debug", arg_5_0.enable_debug)

		if arg_5_0.enable_debug then
			if Imgui.tree_node("Debug render options", true) then
				for iter_5_0, iter_5_1 in ipairs(arg_5_0.debug_options) do
					iter_5_1.enabled = Imgui.checkbox(iter_5_1.name, iter_5_1.enabled)
				end

				Imgui.tree_pop()
			end

			if Imgui.tree_node("Config parameters") then
				for iter_5_2, iter_5_3 in pairs(arg_5_0.debug_config) do
					local var_5_2 = World.get_umbra_debug_config_value(var_5_0, iter_5_3.idx)
					local var_5_3 = Imgui.slider_float(iter_5_2, var_5_2, iter_5_3.min, iter_5_3.max, iter_5_3.speed)

					if var_5_2 ~= var_5_3 then
						World.set_umbra_debug_config_value(var_5_0, iter_5_3.idx, var_5_3)
					end
				end

				Imgui.tree_pop()
			end
		end

		Imgui.end_window("Umbra Debug")
	end

	World.set_umbra_debug_enable(var_5_0, arg_5_0.enable_debug)

	if arg_5_0.enable_debug then
		for iter_5_4, iter_5_5 in pairs(arg_5_0.debug_options) do
			World.set_umbra_debug_flag(var_5_0, iter_5_5.query, iter_5_5.mask, iter_5_5.enabled)
		end
	end

	if arg_5_0:_has_floater() then
		arg_5_0:_update_floater(var_5_0)
	end

	return var_5_1
end

ImguiUmbraDebug._update_floater = function (arg_6_0, arg_6_1)
	Imgui.begin_window("Umbra Floater")

	for iter_6_0, iter_6_1 in ipairs(arg_6_0.sub_windows) do
		if iter_6_1.option.enabled then
			iter_6_1.draw(arg_6_1)
		end
	end

	Imgui.end_window()
end
