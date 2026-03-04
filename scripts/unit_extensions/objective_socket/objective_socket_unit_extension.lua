-- chunkname: @scripts/unit_extensions/objective_socket/objective_socket_unit_extension.lua

ObjectiveSocketUnitExtension = class(ObjectiveSocketUnitExtension)

local var_0_0 = {
	optional_color = {
		0.02,
		0.02,
		0.1
	}
}

ObjectiveSocketUnitExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = arg_1_4
	arg_1_0.sockets = {}
	arg_1_0.num_sockets = 0
	arg_1_0.num_open_sockets = 0
	arg_1_0.num_closed_sockets = 0
	arg_1_0.distance = 10000

	arg_1_0:setup_sockets(arg_1_2)

	arg_1_0.pick_config = Unit.get_data(arg_1_2, "pick_config") or "ordered"
	POSITION_LOOKUP[arg_1_2] = Unit.world_position(arg_1_2, 0)

	arg_1_0:_handle_optional_slots(arg_1_2)
end

ObjectiveSocketUnitExtension._handle_optional_slots = function (arg_2_0, arg_2_1)
	if Unit.get_data(arg_2_1, "optional") then
		script_data.socket_unit = arg_2_1

		local var_2_0 = var_0_0.optional_color
		local var_2_1 = Vector3(var_2_0[1], var_2_0[2], var_2_0[3])
		local var_2_2 = 0

		while Unit.has_data(arg_2_1, "optional_meshes", var_2_2) do
			local var_2_3 = Unit.get_data(arg_2_1, "optional_meshes", var_2_2)
			local var_2_4 = Unit.mesh(arg_2_1, var_2_3)
			local var_2_5 = Mesh.num_materials(var_2_4)

			for iter_2_0 = 0, var_2_5 - 1 do
				local var_2_6 = Mesh.material(var_2_4, iter_2_0)

				Material.set_vector3(var_2_6, "rgb", var_2_1)
			end

			var_2_2 = var_2_2 + 1
		end
	end
end

ObjectiveSocketUnitExtension.destroy = function (arg_3_0)
	POSITION_LOOKUP[arg_3_0.unit] = nil
end

ObjectiveSocketUnitExtension.setup_sockets = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.sockets
	local var_4_1 = "socket_"
	local var_4_2 = 1
	local var_4_3 = "socket_1"

	while Unit.has_node(arg_4_1, var_4_3) do
		local var_4_4 = Unit.node(arg_4_1, var_4_3)

		var_4_0[var_4_2] = {
			open = true,
			socket_name = var_4_3,
			node_index = var_4_4
		}
		var_4_2 = var_4_2 + 1
		var_4_3 = var_4_1 .. var_4_2
	end

	fassert(var_4_2 - 1 > 0, "No socket nodes in unit %q", arg_4_1)

	arg_4_0.num_sockets = var_4_2 - 1
end

ObjectiveSocketUnitExtension.pick_socket_ordered = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.num_sockets

	for iter_5_0 = 1, var_5_0 do
		local var_5_1 = arg_5_1[iter_5_0]

		if var_5_1.open then
			return var_5_1, iter_5_0
		end
	end

	print("[ObjectiveSocketUnitExtension]: No sockets open")
end

ObjectiveSocketUnitExtension.pick_socket_closest = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = POSITION_LOOKUP[arg_6_2]
	local var_6_1 = arg_6_0.unit
	local var_6_2 = arg_6_0.num_sockets
	local var_6_3 = math.huge
	local var_6_4
	local var_6_5

	for iter_6_0 = 1, var_6_2 do
		local var_6_6 = arg_6_1[iter_6_0]

		if var_6_6.open then
			local var_6_7 = Unit.world_position(var_6_1, var_6_6.node_index)
			local var_6_8 = Vector3.distance_squared(var_6_0, var_6_7)

			if var_6_8 < var_6_3 then
				var_6_3 = var_6_8
				var_6_4 = var_6_6
				var_6_5 = iter_6_0
			end
		end
	end

	if not var_6_4 then
		print("[ObjectiveSocketUnitExtension]: No sockets open")
	end

	return var_6_4, var_6_5
end

ObjectiveSocketUnitExtension.pick_socket = function (arg_7_0, arg_7_1)
	local var_7_0
	local var_7_1
	local var_7_2 = arg_7_0.pick_config

	if var_7_2 == "ordered" then
		var_7_0, var_7_1 = arg_7_0:pick_socket_ordered(arg_7_0.sockets)
	elseif var_7_2 == "closest" then
		var_7_0, var_7_1 = arg_7_0:pick_socket_closest(arg_7_0.sockets, arg_7_1)
	else
		ferror("[ObjectiveSocketSystem] Unknown pick_config %q in unit %q", var_7_2, arg_7_0.unit)
	end

	return var_7_0, var_7_1
end

ObjectiveSocketUnitExtension.socket_from_id = function (arg_8_0, arg_8_1)
	return arg_8_0.sockets[arg_8_1]
end

ObjectiveSocketUnitExtension.update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	return
end
