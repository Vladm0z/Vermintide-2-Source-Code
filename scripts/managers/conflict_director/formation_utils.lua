-- chunkname: @scripts/managers/conflict_director/formation_utils.lua

FormationUtils = {}

FormationUtils.make_formation = function (self, arg_1_1)
	-- function 1
	local tbl = {
		arrangement = {},
		formation_template = self,
		x = self.x,
		y = self.y
	}
	local var_1_1 = self.size[1]
	local var_1_2 = self.size[2]
	local num = arg_1_1 / 2
	local num_2 = var_1_1 / 2 - num
	local num_3 = var_1_2 / 2 - num
	local arrangement = tbl.arrangement
	local num_4 = 0

	for i = 0, var_1_2 - 1 do
		for j = 0, var_1_1 - 1 do
			num_4 = num_4 + 1
			arrangement[num_4] = {
				j * arg_1_1 - num_2,
				i * arg_1_1 - num_3
			}
		end
	end

	return tbl, num_4
end

FormationUtils.make_encampment = function (self)
	-- function 2
	local tbl = {
		army_size = 0,
		encampment_template = self
	}
	local num = 0
	local var_2_2

	for i = 1, #self do
		local var_2_3 = self[i]
		local num_2 = 1
		local var_2_5

		tbl[i], var_2_5 = FormationUtils.make_formation(var_2_3, num_2)
		num = num + var_2_5
	end

	tbl.army_size = num

	return tbl
end

local tbl = {
	light = {
		222,
		88,
		0
	},
	heavy = {
		0,
		128,
		240
	},
	special = {
		240,
		240,
		0
	},
	boss = {
		40,
		200,
		40
	}
}

FormationUtils.draw_encampment = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_3 = arg_3_3 or QuickDrawer

	arg_3_3:sphere(arg_3_1, 0.25, Color(0, 180, 0))

	for i = 1, #self do
		local var_3_0 = self[i]
		local var_3_1 = tbl[var_3_0.formation_template.category]
		local var_3_2 = Color(var_3_1[1], var_3_1[2], var_3_1[3])
		local var_3_3 = arg_3_2
		local num = arg_3_1 + Quaternion.rotate(arg_3_2, Vector2(var_3_0.x, var_3_0.y))

		FormationUtils.draw_formation(var_3_0, num, var_3_3, var_3_2, arg_3_3)
	end
end

FormationUtils.draw_formation = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	arg_4_4:line(arg_4_1, arg_4_1 + Vector3(0, 0, 3), arg_4_3)

	local dir = self.formation_template.dir
	local look

	if not dir then
		look = Quaternion.look(Vector3(dir[1], dir[2], 0))

		if not look then
			-- Nothing
		end
	end

	look = Quaternion.look(Vector3(0, 1, 0))

	::label_4_0::

	local multiply = Quaternion.multiply(arg_4_2, look)
	local arrangement = self.arrangement

	for i = 1, #arrangement do
		local var_4_4 = arrangement[i]
		local num = arg_4_1 + Quaternion.rotate(multiply, Vector3(var_4_4[1], var_4_4[2], 0))

		arg_4_4:sphere(num, 0.5, arg_4_3)
	end
end

FormationUtils.spawn_formation = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local conflict = Managers.state.conflict
	local nav_world = conflict.nav_world
	local arrangement = self.arrangement
	local dir = self.formation_template.dir
	local look

	if not dir then
		look = Quaternion.look(Vector3(dir[1], dir[2], 0))

		if not look then
			-- Nothing
		end
	end

	look = Quaternion.look(Vector3(0, 1, 0))

	::label_5_0::

	local multiply = Quaternion.multiply(arg_5_2, look)

	for i = 1, #arrangement do
		local var_5_6 = arrangement[i]
		local num = arg_5_1 + Quaternion.rotate(multiply, Vector3(var_5_6[1], var_5_6[2], 0))
		local triangle_from_position, var_5_9 = GwNavQueries.triangle_from_position(nav_world, num, 2, 2)

		if not triangle_from_position then
			Vector3.set_z(num, var_5_9)

			local str = "roam"
			local str_2 = "encampment"
			local var_5_12 = Breeds[arg_5_3]
			local var_5_13
			local tbl = {
				side_id = arg_5_5
			}

			conflict:spawn_queued_unit(var_5_12, Vector3Box(num), QuaternionBox(multiply), str_2, nil, str, tbl, arg_5_4)
		end
	end
end

FormationUtils.spawn_encampment = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local tbl = {
		template = "encampment",
		id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
		size = self.army_size,
		group_data = {
			sneaky = true,
			idle = true,
			encampment = self,
			spawn_time = Managers.time:time("game"),
			side_id = arg_6_4
		},
		side_id = arg_6_4
	}

	self.pos = Vector3Box(arg_6_1)

	for i = 1, #self do
		local var_6_1 = self[i]
		local var_6_2 = arg_6_3[var_6_1.formation_template.category]
		local num = arg_6_1 + Quaternion.rotate(arg_6_2, Vector2(var_6_1.x, var_6_1.y))

		FormationUtils.spawn_formation(var_6_1, num, arg_6_2, var_6_2, tbl, arg_6_4)
	end
end
