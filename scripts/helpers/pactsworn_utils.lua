-- chunkname: @scripts/helpers/pactsworn_utils.lua

PactswornUtils = {}

local var_0_0 = 1

function PactswornUtils.get_hoist_position(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = POSITION_LOOKUP[arg_1_1]
	local var_1_1 = POSITION_LOOKUP[arg_1_2]
	local var_1_2, var_1_3 = Vector3.direction_length(var_1_0 - var_1_1)

	var_1_2.z = 0

	local var_1_4 = var_1_1 + Vector3.normalize(var_1_2) * var_1_3
	local var_1_5, var_1_6 = Vector3.direction_length(var_1_4 - var_1_0)

	if var_1_6 < math.epsilon then
		return var_1_0
	end

	local var_1_7 = PhysicsWorld.immediate_raycast_actors(arg_1_0, var_1_0, var_1_5, var_1_6, "static_collision_filter", "filter_player_ray_projectile_static_only", "max_hits", 1)

	if var_1_7 then
		local var_1_8 = var_1_7[1]

		if script_data.vs_debug_hoist then
			QuickDrawerStay:sphere(var_1_8[var_0_0], 0.15, Colors.get("tomato"))
			QuickDrawerStay:line(var_1_8[var_0_0], var_1_4, Colors.get("tomato"))
			QuickDrawerStay:sphere(var_1_4, 0.15, Colors.get("cyan"))
		end

		var_1_4 = var_1_8[var_0_0]
	end

	return var_1_4
end
