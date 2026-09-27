-- chunkname: @scripts/imgui/imgui_umbra_debug.lua

ImguiUmbraDebug = class(ImguiUmbraDebug)

local flag = true

ImguiUmbraDebug.init = function (self)
	-- function 1
	self.enable_debug = false
	self.debug_options = {
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
	self.debug_config = {}
	self.debug_config.portal_query_distance = {
		speed = 1,
		idx = 0,
		min = 0,
		max = 100
	}
	self.debug_config.portal_query_accurate_occlusion_threshold = {
		speed = 1,
		idx = 1,
		min = 0,
		max = 255
	}
	self.debug_config.portal_query_contribution_threshold_distance = {
		speed = 1,
		idx = 2,
		min = 0,
		max = 255
	}
	self.debug_config.portal_query_contribution_threshold = {
		speed = 1,
		idx = 3,
		min = 0,
		max = 1
	}
	self.sub_windows = {
		{
			option = self.debug_options[10],
			draw = World.imgui_draw_umbra_debug_occlusion_buffer
		},
		{
			option = self.debug_options[11],
			draw = World.imgui_draw_umbra_debug_shadowmask_buffer
		},
		{
			option = self.debug_options[8],
			draw = World.imgui_draw_umbra_debug_statistics
		}
	}
end

ImguiUmbraDebug.update = function (arg_2_0)
	-- function 2
	if not flag then
		ImguiUmbraDebug:init()

		flag = false
	end
end

ImguiUmbraDebug.is_persistent = function (self)
	-- function 3
	return self:_has_floater()
end

ImguiUmbraDebug._has_floater = function (self)
	-- function 4
	local num = 0

	if self.enable_debug == false then
		return false
	end

	for i, v in ipairs(self.sub_windows) do
		local flag

		flag = v.option.enabled ~= true or not 1 or 0
		num = num + flag
	end

	return num > 0
end

ImguiUmbraDebug.draw = function (self, arg_5_1)
	-- function 5
	if not Managers.world:has_world("level_world") then
		return
	end

	local world = Managers.world:world("level_world")
	local flag = false

	if not arg_5_1 then
		flag = Imgui.begin_window("Umbra Debug")
		self.enable_debug = Imgui.checkbox("Enable Debug", self.enable_debug)

		if not self.enable_debug then
			if not Imgui.tree_node("Debug render options", true) then
				for i, v in ipairs(self.debug_options) do
					v.enabled = Imgui.checkbox(v.name, v.enabled)
				end

				Imgui.tree_pop()
			end

			if not Imgui.tree_node("Config parameters") then
				for k, v_2 in pairs(self.debug_config) do
					local get_umbra_debug_config_value = World.get_umbra_debug_config_value(world, v_2.idx)
					local slider_float = Imgui.slider_float(k, get_umbra_debug_config_value, v_2.min, v_2.max, v_2.speed)

					if get_umbra_debug_config_value ~= slider_float then
						World.set_umbra_debug_config_value(world, v_2.idx, slider_float)
					end
				end

				Imgui.tree_pop()
			end
		end

		Imgui.end_window("Umbra Debug")
	end

	World.set_umbra_debug_enable(world, self.enable_debug)

	if not self.enable_debug then
		for k_2, v_3 in pairs(self.debug_options) do
			World.set_umbra_debug_flag(world, v_3.query, v_3.mask, v_3.enabled)
		end
	end

	if not self:_has_floater() then
		self:_update_floater(world)
	end

	return flag
end

ImguiUmbraDebug._update_floater = function (self, arg_6_1)
	-- function 6
	Imgui.begin_window("Umbra Floater")

	for i, v in ipairs(self.sub_windows) do
		if not v.option.enabled then
			v.draw(arg_6_1)
		end
	end

	Imgui.end_window()
end
