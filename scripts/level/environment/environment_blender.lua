-- chunkname: @scripts/level/environment/environment_blender.lua

require("scripts/level/environment/environment_handler")

EnvironmentBlender = class(EnvironmentBlender)

EnvironmentBlender.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.world = arg_1_1
	self.environment_handler = EnvironmentHandler:new()
	self.shading_settings = {}
	self.viewport = arg_1_2
	self.particle_light_intensity = nil

	self.environment_handler:add_blend_group("volumes")

	local tbl = {
		volume_name = "world",
		environment = "default",
		always_inside = true,
		override_sun_snap = false,
		particle_light_intensity = 1,
		viewport = self.viewport
	}

	self.environment_handler:add_blend("EnvironmentBlendVolume", "volumes", -1, tbl)

	local event = Managers.state.event

	event:register(self, "register_environment_volume", "event_register_environment_volume")
	event:register(self, "unregister_environment_volume", "event_unregister_environment_volume")
end

EnvironmentBlender.event_register_environment_volume = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
	-- function 2
	local tbl = {
		always_inside = false,
		level = LevelHelper:current_level(self.world),
		viewport = self.viewport,
		environment = arg_2_2,
		volume_name = arg_2_1,
		blend_time = arg_2_4,
		override_sun_snap = arg_2_5,
		particle_light_intensity = arg_2_6,
		is_sphere = not arg_2_7 and arg_2_8,
		sphere_pos = not arg_2_7 and Vector3Box(arg_2_7),
		sphere_radius = arg_2_8
	}

	self.environment_handler:add_blend("EnvironmentBlendVolume", "volumes", arg_2_3, tbl, arg_2_9)
end

EnvironmentBlender.event_unregister_environment_volume = function (self, arg_3_1)
	-- function 3
	self.environment_handler:remove_blend(arg_3_1)
end

EnvironmentBlender.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.environment_handler:update(arg_4_1, arg_4_2)
	self:update_shading_settings()
end

EnvironmentBlender.update_shading_settings = function (self)
	-- function 5
	local environment_handler = self.environment_handler
	local weights = environment_handler:weights("volumes")
	local shading_settings = self.shading_settings

	table.clear(shading_settings)

	local num = 0

	for i, v in ipairs(weights) do
		if v.weight > 0 then
			local weight = v.weight

			shading_settings[#shading_settings + 1] = v.environment
			shading_settings[#shading_settings + 1] = weight
			num = num + weight * v.particle_light_intensity
		end
	end

	if num ~= self.particle_light_intensity then
		World.set_particles_light_intensity(self.world, num)

		self.particle_light_intensity = num
	end

	World.set_data(self.world, "override_shading_settings", environment_handler:override_settings())
	World.set_data(self.world, "shading_settings", shading_settings)

	if not script_data.debug_environment_blend then
		self:debug_draw(shading_settings)
	end
end

EnvironmentBlender.destroy = function (self)
	-- function 6
	self.environment_handler:destroy()

	self.environment_handler = nil
end

local tbl = {
	{
		255,
		100,
		100,
		200
	},
	{
		255,
		100,
		200,
		100
	},
	{
		255,
		200,
		100,
		100
	},
	{
		255,
		200,
		200,
		100
	}
}

EnvironmentBlender.debug_color = function (arg_7_0)
	-- function 7
	return table.remove(tbl)
end

EnvironmentBlender.debug_draw = function (arg_8_0, arg_8_1)
	-- function 8
	local resolution, var_8_1 = Gui.resolution()
	local num = resolution * 0.01
	local num_2 = var_8_1 * 0.95
	local num_3 = 5
	local num_4 = 36
	local num_5 = 0

	for i = 1, #arg_8_1, 2 do
		local var_8_7 = arg_8_1[i]
		local var_8_8 = arg_8_1[i + 1]
		local str = string.format("%.2f", var_8_8) .. " " .. var_8_7

		Managers.state.debug:draw_screen_text(num, num_2 + num_5, 999, str, num_4, Color(255, 255, 255, 255))
		Managers.state.debug:draw_screen_text(num + 2, num_2 + num_5 - 2, 998, str, num_4, Color(255, 0, 0, 0))

		num_5 = num_5 - num_4 - num_3
	end
end
