-- chunkname: @scripts/managers/conflict_director/formation_utils.lua

FormationUtils = {}

function FormationUtils.make_formation(arg_1_0, arg_1_1)
	local var_1_0 = {
		arrangement = {},
		formation_template = arg_1_0,
		x = arg_1_0.x,
		y = arg_1_0.y
	}
	local var_1_1 = arg_1_0.size[1]
	local var_1_2 = arg_1_0.size[2]
	local var_1_3 = arg_1_1 / 2
	local var_1_4 = var_1_1 / 2 - var_1_3
	local var_1_5 = var_1_2 / 2 - var_1_3
	local var_1_6 = var_1_0.arrangement
	local var_1_7 = 0

	for iter_1_0 = 0, var_1_2 - 1 do
		for iter_1_1 = 0, var_1_1 - 1 do
			var_1_7 = var_1_7 + 1
			var_1_6[var_1_7] = {
				iter_1_1 * arg_1_1 - var_1_4,
				iter_1_0 * arg_1_1 - var_1_5
			}
		end
	end

	return var_1_0, var_1_7
end

function FormationUtils.make_encampment(arg_2_0)
	local var_2_0 = {
		army_size = 0,
		encampment_template = arg_2_0
	}
	local var_2_1 = 0
	local var_2_2

	for iter_2_0 = 1, #arg_2_0 do
		local var_2_3 = arg_2_0[iter_2_0]
		local var_2_4 = 1
		local var_2_5

		var_2_0[iter_2_0], var_2_5 = FormationUtils.make_formation(var_2_3, var_2_4)
		var_2_1 = var_2_1 + var_2_5
	end

	var_2_0.army_size = var_2_1

	return var_2_0
end

local var_0_0 = {
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

function FormationUtils.draw_encampment(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_3 = arg_3_3 or QuickDrawer

	arg_3_3:sphere(arg_3_1, 0.25, Color(0, 180, 0))

	for iter_3_0 = 1, #arg_3_0 do
		local var_3_0 = arg_3_0[iter_3_0]
		local var_3_1 = var_0_0[var_3_0.formation_template.category]
		local var_3_2 = Color(var_3_1[1], var_3_1[2], var_3_1[3])
		local var_3_3 = arg_3_2
		local var_3_4 = arg_3_1 + Quaternion.rotate(arg_3_2, Vector2(var_3_0.x, var_3_0.y))

		FormationUtils.draw_formation(var_3_0, var_3_4, var_3_3, var_3_2, arg_3_3)
	end
end

function FormationUtils.draw_formation(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_4:line(arg_4_1, arg_4_1 + Vector3(0, 0, 3), arg_4_3)

	local var_4_0 = arg_4_0.formation_template.dir
	local var_4_1 = var_4_0 and Quaternion.look(Vector3(var_4_0[1], var_4_0[2], 0)) or Quaternion.look(Vector3(0, 1, 0))
	local var_4_2 = Quaternion.multiply(arg_4_2, var_4_1)
	local var_4_3 = arg_4_0.arrangement

	for iter_4_0 = 1, #var_4_3 do
		local var_4_4 = var_4_3[iter_4_0]
		local var_4_5 = arg_4_1 + Quaternion.rotate(var_4_2, Vector3(var_4_4[1], var_4_4[2], 0))

		arg_4_4:sphere(var_4_5, 0.5, arg_4_3)
	end
end

function FormationUtils.spawn_formation(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = Managers.state.conflict
	local var_5_1 = var_5_0.nav_world
	local var_5_2 = arg_5_0.arrangement
	local var_5_3 = arg_5_0.formation_template.dir
	local var_5_4 = var_5_3 and Quaternion.look(Vector3(var_5_3[1], var_5_3[2], 0)) or Quaternion.look(Vector3(0, 1, 0))
	local var_5_5 = Quaternion.multiply(arg_5_2, var_5_4)

	for iter_5_0 = 1, #var_5_2 do
		local var_5_6 = var_5_2[iter_5_0]
		local var_5_7 = arg_5_1 + Quaternion.rotate(var_5_5, Vector3(var_5_6[1], var_5_6[2], 0))
		local var_5_8, var_5_9 = GwNavQueries.triangle_from_position(var_5_1, var_5_7, 2, 2)

		if var_5_8 then
			Vector3.set_z(var_5_7, var_5_9)

			local var_5_10 = "roam"
			local var_5_11 = "encampment"
			local var_5_12 = Breeds[arg_5_3]
			local var_5_13
			local var_5_14 = {
				side_id = arg_5_5
			}

			var_5_0:spawn_queued_unit(var_5_12, Vector3Box(var_5_7), QuaternionBox(var_5_5), var_5_11, nil, var_5_10, var_5_14, arg_5_4)
		end
	end
end

function FormationUtils.spawn_encampment(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = {
		template = "encampment",
		id = Managers.state.entity:system("ai_group_system"):generate_group_id(),
		size = arg_6_0.army_size,
		group_data = {
			sneaky = true,
			idle = true,
			encampment = arg_6_0,
			spawn_time = Managers.time:time("game"),
			side_id = arg_6_4
		},
		side_id = arg_6_4
	}

	arg_6_0.pos = Vector3Box(arg_6_1)

	for iter_6_0 = 1, #arg_6_0 do
		local var_6_1 = arg_6_0[iter_6_0]
		local var_6_2 = arg_6_3[var_6_1.formation_template.category]
		local var_6_3 = arg_6_1 + Quaternion.rotate(arg_6_2, Vector2(var_6_1.x, var_6_1.y))

		FormationUtils.spawn_formation(var_6_1, var_6_3, arg_6_2, var_6_2, var_6_0, arg_6_4)
	end
end
