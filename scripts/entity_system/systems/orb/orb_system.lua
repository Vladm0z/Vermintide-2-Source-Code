-- chunkname: @scripts/entity_system/systems/orb/orb_system.lua

OrbSystem = class(OrbSystem, ExtensionSystemBase)

local tbl = {
	"rpc_spawn_orb"
}
local num = 1
local num_2 = 3

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local atan2 = math.atan2(arg_1_4.x, arg_1_4.y)
	local num_3 = arg_1_5 * 0.5
	local num_4 = atan2 - num_3
	local num_5 = atan2 + num_3
	local var_1_4 = num
	local var_1_5 = num_2
	local var_1_6

	for i = 1, 5 do
		local get_uniformly_random_point_inside_sector, var_1_8 = math.get_uniformly_random_point_inside_sector(var_1_4, var_1_5, num_4, num_5)
		local var_1_9 = Vector3(arg_1_3.x + get_uniformly_random_point_inside_sector, arg_1_3.y + var_1_8, arg_1_3.z)
		local triangle_from_position, var_1_11 = GwNavQueries.triangle_from_position(arg_1_0, var_1_9, 5, 5)

		if not triangle_from_position then
			Vector3.set_z(var_1_9, var_1_11)

			var_1_6 = Vector3Box(var_1_9)

			break
		end
	end

	if not var_1_6 then
		local triangle_from_position_2, var_1_13 = GwNavQueries.triangle_from_position(arg_1_0, arg_1_3, 5, 5)

		if not triangle_from_position_2 then
			local var_1_14 = Vector3(arg_1_3[1], arg_1_3[2], var_1_13)

			var_1_6 = Vector3Box(var_1_14)
		else
			local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(arg_1_0, arg_1_3, 4, 4, 5)

			if not inside_position_from_outside_position then
				var_1_6 = Vector3Box(inside_position_from_outside_position)
			end
		end
	end

	if not var_1_6 then
		return
	end

	local var_1_16 = AllPickups[arg_1_1]
	local unit_name = var_1_16.unit_name
	local unit_template_name = var_1_16.unit_template_name
	local str = "buff"
	local tbl = {
		pickup_system = {
			has_physics = false,
			spawn_limit = 1,
			flight_enabled = true,
			pickup_name = arg_1_1,
			spawn_type = str,
			owner_peer_id = arg_1_2,
			orb_flight_target_position = var_1_6
		}
	}

	if not var_1_16.local_only then
		return Managers.state.unit_spawner:spawn_local_unit_with_extensions(unit_name, unit_template_name, tbl, arg_1_3)
	else
		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl, arg_1_3)
	end
end

OrbSystem.init = function (self, arg_2_1, ...)
	-- function 2
	OrbSystem.super.init(self, arg_2_1, ...)

	local network_event_delegate = arg_2_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self._is_server = arg_2_1.is_server
end

OrbSystem.rpc_spawn_orb = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	if not nav_world then
		return
	end

	arg_3_2 = NetworkLookup.pickup_names[arg_3_2]

	local var_3_1 = Vector3Box(arg_3_4)
	local var_3_2 = Vector3Box(arg_3_5)

	local function fn_2()
		-- function 4
		fn(nav_world, arg_3_2, arg_3_3, var_3_1:unbox(), var_3_2:unbox(), arg_3_6)
	end

	Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn_2)
end

OrbSystem.spawn_orb = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
	-- function 5
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	if not nav_world then
		return
	end

	local var_5_1 = Vector3Box(arg_5_3)
	local var_5_2 = Vector3Box(arg_5_4)

	local function fn_2()
		-- function 6
		local var_6_0 = fn(nav_world, arg_5_1, arg_5_2, var_5_1:unbox(), var_5_2:unbox(), arg_5_5)

		if not var_6_0 then
			if not arg_5_6 then
				arg_5_6(var_6_0)
			end
		elseif not arg_5_7 then
			arg_5_7()
		end
	end

	Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn_2)
end

OrbSystem.destroy = function (self)
	-- function 7
	self.network_event_delegate:unregister(self)
end
