-- chunkname: @scripts/helpers/pactsworn_utils.lua

PactswornUtils = {}

local num = 1

PactswornUtils.get_hoist_position = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local var_1_0 = POSITION_LOOKUP[arg_1_1]
	local var_1_1 = POSITION_LOOKUP[arg_1_2]
	local direction_length, var_1_3 = Vector3.direction_length(var_1_0 - var_1_1)

	direction_length.z = 0

	local num_2 = var_1_1 + Vector3.normalize(direction_length) * var_1_3
	local direction_length_2, var_1_6 = Vector3.direction_length(num_2 - var_1_0)

	if var_1_6 < math.epsilon then
		return var_1_0
	end

	local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(arg_1_0, var_1_0, direction_length_2, var_1_6, "static_collision_filter", "filter_player_ray_projectile_static_only", "max_hits", 1)

	if not immediate_raycast_actors then
		local var_1_8 = immediate_raycast_actors[1]

		if not script_data.vs_debug_hoist then
			QuickDrawerStay:sphere(var_1_8[num], 0.15, Colors.get("tomato"))
			QuickDrawerStay:line(var_1_8[num], num_2, Colors.get("tomato"))
			QuickDrawerStay:sphere(num_2, 0.15, Colors.get("cyan"))
		end

		num_2 = var_1_8[num]
	end

	return num_2
end
