-- chunkname: @scripts/unit_extensions/objective_socket/objective_socket_unit_extension.lua

ObjectiveSocketUnitExtension = class(ObjectiveSocketUnitExtension)

local tbl = {
	optional_color = {
		0.02,
		0.02,
		0.1
	}
}

ObjectiveSocketUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.is_server = arg_1_4
	self.sockets = {}
	self.num_sockets = 0
	self.num_open_sockets = 0
	self.num_closed_sockets = 0
	self.distance = 10000

	self:setup_sockets(arg_1_2)

	local get_data = Unit.get_data(arg_1_2, "pick_config")

	get_data = get_data or "ordered"
	self.pick_config = get_data
	POSITION_LOOKUP[arg_1_2] = Unit.world_position(arg_1_2, 0)

	self:_handle_optional_slots(arg_1_2)
end

ObjectiveSocketUnitExtension._handle_optional_slots = function (arg_2_0, arg_2_1)
	-- function 2
	if not Unit.get_data(arg_2_1, "optional") then
		script_data.socket_unit = arg_2_1

		local optional_color = tbl.optional_color
		local var_2_1 = Vector3(optional_color[1], optional_color[2], optional_color[3])
		local num = 0

		while not Unit.has_data(arg_2_1, "optional_meshes", num) do
			local get_data = Unit.get_data(arg_2_1, "optional_meshes", num)
			local mesh = Unit.mesh(arg_2_1, get_data)
			local num_materials = Mesh.num_materials(mesh)

			for i = 0, num_materials - 1 do
				local material = Mesh.material(mesh, i)

				Material.set_vector3(material, "rgb", var_2_1)
			end

			num = num + 1
		end
	end
end

ObjectiveSocketUnitExtension.destroy = function (arg_3_0)
	-- function 3
	POSITION_LOOKUP[arg_3_0.unit] = nil
end

ObjectiveSocketUnitExtension.setup_sockets = function (self, arg_4_1)
	-- function 4
	local sockets = self.sockets
	local str = "socket_"
	local num = 1
	local str_2 = "socket_1"

	while not Unit.has_node(arg_4_1, str_2) do
		local node = Unit.node(arg_4_1, str_2)

		sockets[num] = {
			open = true,
			socket_name = str_2,
			node_index = node
		}
		num = num + 1
		str_2 = str .. num
	end

	fassert(num - 1 > 0, "No socket nodes in unit %q", arg_4_1)

	self.num_sockets = num - 1
end

ObjectiveSocketUnitExtension.pick_socket_ordered = function (self, arg_5_1)
	-- function 5
	local num_sockets = self.num_sockets

	for i = 1, num_sockets do
		local var_5_1 = arg_5_1[i]

		if not var_5_1.open then
			return var_5_1, i
		end
	end

	print("[ObjectiveSocketUnitExtension]: No sockets open")
end

ObjectiveSocketUnitExtension.pick_socket_closest = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = POSITION_LOOKUP[arg_6_2]
	local unit = self.unit
	local num_sockets = self.num_sockets
	local huge = math.huge
	local var_6_4
	local var_6_5

	for i = 1, num_sockets do
		local var_6_6 = arg_6_1[i]

		if not var_6_6.open then
			local world_position = Unit.world_position(unit, var_6_6.node_index)
			local distance_squared = Vector3.distance_squared(var_6_0, world_position)

			if distance_squared < huge then
				huge = distance_squared
				var_6_4 = var_6_6
				var_6_5 = i
			end
		end
	end

	if not var_6_4 then
		print("[ObjectiveSocketUnitExtension]: No sockets open")
	end

	return var_6_4, var_6_5
end

ObjectiveSocketUnitExtension.pick_socket = function (self, arg_7_1)
	-- function 7
	local var_7_0
	local var_7_1
	local pick_config = self.pick_config

	if pick_config == "ordered" then
		var_7_0, var_7_1 = self:pick_socket_ordered(self.sockets)
	elseif pick_config == "closest" then
		var_7_0, var_7_1 = self:pick_socket_closest(self.sockets, arg_7_1)
	else
		ferror("[ObjectiveSocketSystem] Unknown pick_config %q in unit %q", pick_config, self.unit)
	end

	return var_7_0, var_7_1
end

ObjectiveSocketUnitExtension.socket_from_id = function (self, arg_8_1)
	-- function 8
	return self.sockets[arg_8_1]
end

ObjectiveSocketUnitExtension.update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	return
end
