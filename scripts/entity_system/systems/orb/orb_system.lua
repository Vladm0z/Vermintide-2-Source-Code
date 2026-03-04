-- chunkname: @scripts/entity_system/systems/orb/orb_system.lua

OrbSystem = class(OrbSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_spawn_orb"
}
local var_0_1 = 1
local var_0_2 = 3

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = math.atan2(arg_1_4.x, arg_1_4.y)
	local var_1_1 = arg_1_5 * 0.5
	local var_1_2 = var_1_0 - var_1_1
	local var_1_3 = var_1_0 + var_1_1
	local var_1_4 = var_0_1
	local var_1_5 = var_0_2
	local var_1_6

	for iter_1_0 = 1, 5 do
		local var_1_7, var_1_8 = math.get_uniformly_random_point_inside_sector(var_1_4, var_1_5, var_1_2, var_1_3)
		local var_1_9 = Vector3(arg_1_3.x + var_1_7, arg_1_3.y + var_1_8, arg_1_3.z)
		local var_1_10, var_1_11 = GwNavQueries.triangle_from_position(arg_1_0, var_1_9, 5, 5)

		if var_1_10 then
			Vector3.set_z(var_1_9, var_1_11)

			var_1_6 = Vector3Box(var_1_9)

			break
		end
	end

	if not var_1_6 then
		local var_1_12, var_1_13 = GwNavQueries.triangle_from_position(arg_1_0, arg_1_3, 5, 5)

		if var_1_12 then
			local var_1_14 = Vector3(arg_1_3[1], arg_1_3[2], var_1_13)

			var_1_6 = Vector3Box(var_1_14)
		else
			local var_1_15 = GwNavQueries.inside_position_from_outside_position(arg_1_0, arg_1_3, 4, 4, 5)

			if var_1_15 then
				var_1_6 = Vector3Box(var_1_15)
			end
		end
	end

	if not var_1_6 then
		return
	end

	local var_1_16 = AllPickups[arg_1_1]
	local var_1_17 = var_1_16.unit_name
	local var_1_18 = var_1_16.unit_template_name
	local var_1_19 = "buff"
	local var_1_20 = {
		pickup_system = {
			has_physics = false,
			spawn_limit = 1,
			flight_enabled = true,
			pickup_name = arg_1_1,
			spawn_type = var_1_19,
			owner_peer_id = arg_1_2,
			orb_flight_target_position = var_1_6
		}
	}

	if var_1_16.local_only then
		return Managers.state.unit_spawner:spawn_local_unit_with_extensions(var_1_17, var_1_18, var_1_20, arg_1_3)
	else
		return Managers.state.unit_spawner:spawn_network_unit(var_1_17, var_1_18, var_1_20, arg_1_3)
	end
end

OrbSystem.init = function (arg_2_0, arg_2_1, ...)
	OrbSystem.super.init(arg_2_0, arg_2_1, ...)

	local var_2_0 = arg_2_1.network_event_delegate

	arg_2_0.network_event_delegate = var_2_0

	var_2_0:register(arg_2_0, unpack(var_0_0))

	arg_2_0._is_server = arg_2_1.is_server
end

OrbSystem.rpc_spawn_orb = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = Managers.state.entity:system("ai_system"):nav_world()

	if not var_3_0 then
		return
	end

	arg_3_2 = NetworkLookup.pickup_names[arg_3_2]

	local var_3_1 = Vector3Box(arg_3_4)
	local var_3_2 = Vector3Box(arg_3_5)

	local function var_3_3()
		var_0_3(var_3_0, arg_3_2, arg_3_3, var_3_1:unbox(), var_3_2:unbox(), arg_3_6)
	end

	Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_3_3)
end

OrbSystem.spawn_orb = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
	local var_5_0 = Managers.state.entity:system("ai_system"):nav_world()

	if not var_5_0 then
		return
	end

	local var_5_1 = Vector3Box(arg_5_3)
	local var_5_2 = Vector3Box(arg_5_4)

	local function var_5_3()
		local var_6_0 = var_0_3(var_5_0, arg_5_1, arg_5_2, var_5_1:unbox(), var_5_2:unbox(), arg_5_5)

		if var_6_0 then
			if arg_5_6 then
				arg_5_6(var_6_0)
			end
		elseif arg_5_7 then
			arg_5_7()
		end
	end

	Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_5_3)
end

OrbSystem.destroy = function (arg_7_0)
	arg_7_0.network_event_delegate:unregister(arg_7_0)
end
