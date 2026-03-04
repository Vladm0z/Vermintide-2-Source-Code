-- chunkname: @scripts/level/environment/environment_blender.lua

require("scripts/level/environment/environment_handler")

EnvironmentBlender = class(EnvironmentBlender)

function EnvironmentBlender.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.world = arg_1_1
	arg_1_0.environment_handler = EnvironmentHandler:new()
	arg_1_0.shading_settings = {}
	arg_1_0.viewport = arg_1_2
	arg_1_0.particle_light_intensity = nil

	arg_1_0.environment_handler:add_blend_group("volumes")

	local var_1_0 = {
		volume_name = "world",
		environment = "default",
		always_inside = true,
		override_sun_snap = false,
		particle_light_intensity = 1,
		viewport = arg_1_0.viewport
	}

	arg_1_0.environment_handler:add_blend("EnvironmentBlendVolume", "volumes", -1, var_1_0)

	local var_1_1 = Managers.state.event

	var_1_1:register(arg_1_0, "register_environment_volume", "event_register_environment_volume")
	var_1_1:register(arg_1_0, "unregister_environment_volume", "event_unregister_environment_volume")
end

function EnvironmentBlender.event_register_environment_volume(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
	local var_2_0 = {
		always_inside = false,
		level = LevelHelper:current_level(arg_2_0.world),
		viewport = arg_2_0.viewport,
		environment = arg_2_2,
		volume_name = arg_2_1,
		blend_time = arg_2_4,
		override_sun_snap = arg_2_5,
		particle_light_intensity = arg_2_6,
		is_sphere = arg_2_7 and arg_2_8,
		sphere_pos = arg_2_7 and Vector3Box(arg_2_7),
		sphere_radius = arg_2_8
	}

	arg_2_0.environment_handler:add_blend("EnvironmentBlendVolume", "volumes", arg_2_3, var_2_0, arg_2_9)
end

function EnvironmentBlender.event_unregister_environment_volume(arg_3_0, arg_3_1)
	arg_3_0.environment_handler:remove_blend(arg_3_1)
end

function EnvironmentBlender.update(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.environment_handler:update(arg_4_1, arg_4_2)
	arg_4_0:update_shading_settings()
end

function EnvironmentBlender.update_shading_settings(arg_5_0)
	local var_5_0 = arg_5_0.environment_handler
	local var_5_1 = var_5_0:weights("volumes")
	local var_5_2 = arg_5_0.shading_settings

	table.clear(var_5_2)

	local var_5_3 = 0

	for iter_5_0, iter_5_1 in ipairs(var_5_1) do
		if iter_5_1.weight > 0 then
			local var_5_4 = iter_5_1.weight

			var_5_2[#var_5_2 + 1] = iter_5_1.environment
			var_5_2[#var_5_2 + 1] = var_5_4
			var_5_3 = var_5_3 + var_5_4 * iter_5_1.particle_light_intensity
		end
	end

	if var_5_3 ~= arg_5_0.particle_light_intensity then
		World.set_particles_light_intensity(arg_5_0.world, var_5_3)

		arg_5_0.particle_light_intensity = var_5_3
	end

	World.set_data(arg_5_0.world, "override_shading_settings", var_5_0:override_settings())
	World.set_data(arg_5_0.world, "shading_settings", var_5_2)

	if script_data.debug_environment_blend then
		arg_5_0:debug_draw(var_5_2)
	end
end

function EnvironmentBlender.destroy(arg_6_0)
	arg_6_0.environment_handler:destroy()

	arg_6_0.environment_handler = nil
end

local var_0_0 = {
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

function EnvironmentBlender.debug_color(arg_7_0)
	return table.remove(var_0_0)
end

function EnvironmentBlender.debug_draw(arg_8_0, arg_8_1)
	local var_8_0, var_8_1 = Gui.resolution()
	local var_8_2 = var_8_0 * 0.01
	local var_8_3 = var_8_1 * 0.95
	local var_8_4 = 5
	local var_8_5 = 36
	local var_8_6 = 0

	for iter_8_0 = 1, #arg_8_1, 2 do
		local var_8_7 = arg_8_1[iter_8_0]
		local var_8_8 = arg_8_1[iter_8_0 + 1]
		local var_8_9 = string.format("%.2f", var_8_8) .. " " .. var_8_7

		Managers.state.debug:draw_screen_text(var_8_2, var_8_3 + var_8_6, 999, var_8_9, var_8_5, Color(255, 255, 255, 255))
		Managers.state.debug:draw_screen_text(var_8_2 + 2, var_8_3 + var_8_6 - 2, 998, var_8_9, var_8_5, Color(255, 0, 0, 0))

		var_8_6 = var_8_6 - var_8_5 - var_8_4
	end
end
