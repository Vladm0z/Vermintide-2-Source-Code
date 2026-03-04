-- chunkname: @foundation/scripts/util/script_unit.lua

ScriptUnit = ScriptUnit or {}

local var_0_0 = rawget(_G, "G_Entities")

if not var_0_0 then
	var_0_0 = {}

	rawset(_G, "G_Entities", var_0_0)
end

local function var_0_1()
	var_0_0 = {}

	rawset(_G, "G_Entities", var_0_0)
end

local function var_0_2(arg_2_0)
	var_0_0[arg_2_0] = nil
end

local function var_0_3(arg_3_0, arg_3_1)
	local var_3_0 = var_0_0[arg_3_0]

	fassert(var_3_0)
	fassert(var_3_0[arg_3_1], "Tried to remove system %s extension for unit %s", arg_3_1, arg_3_0)

	var_3_0[arg_3_1] = nil
end

local function var_0_4(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = var_0_0[arg_4_0]

	if not var_4_0 then
		var_4_0 = {}
		var_0_0[arg_4_0] = var_4_0
	end

	var_4_0[arg_4_1] = arg_4_2
end

local function var_0_5(arg_5_0, arg_5_1)
	local var_5_0 = var_0_0[arg_5_0]

	return var_5_0 and var_5_0[arg_5_1]
end

local function var_0_6(arg_6_0, arg_6_1)
	local var_6_0 = var_0_0[arg_6_0]

	return var_6_0 and var_6_0[arg_6_1] and var_6_0[arg_6_1].input
end

ScriptUnit.extension_input = function (arg_7_0, arg_7_1)
	return var_0_5(arg_7_0, arg_7_1).input
end

ScriptUnit.extension = function (arg_8_0, arg_8_1)
	local var_8_0 = var_0_0[arg_8_0]

	return var_8_0 and var_8_0[arg_8_1]
end

ScriptUnit.extensions = function (arg_9_0)
	return var_0_0[arg_9_0]
end

ScriptUnit.has_extension = var_0_5

ScriptUnit.has_extension_input = function (arg_10_0, arg_10_1)
	local var_10_0 = var_0_0[arg_10_0]

	return var_10_0 and var_10_0[arg_10_1] and var_10_0[arg_10_1].input
end

ScriptUnit.check_all_units_deleted = function ()
	if next(var_0_0) then
		print("------------ UNITS THAT HAVENT BEEN DELETED --------------")

		for iter_11_0, iter_11_1 in pairs(var_0_0) do
			local var_11_0 = unit_alive_info(iter_11_0)

			print(iter_11_0, Unit.alive(iter_11_0), var_11_0)
		end

		fassert(false, "Some units have not been cleaned up properly!")
	end
end

ScriptUnit.set_extension = function (arg_12_0, arg_12_1, arg_12_2)
	var_0_4(arg_12_0, arg_12_1, arg_12_2)
end

ScriptUnit.add_extension = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	local var_13_0 = rawget(_G, arg_13_2)

	fassert(var_13_0, "No class found for extension with name %q", arg_13_2)

	local var_13_1
	local var_13_2 = var_13_0:new(arg_13_0, arg_13_1, arg_13_4)

	fassert(not ScriptUnit.has_extension(arg_13_1, arg_13_3), "An extension already exists with name %q belonging to unit %s", arg_13_3, arg_13_1)
	var_0_4(arg_13_1, arg_13_3, var_13_2)

	return var_13_2
end

ScriptUnit.destroy_extension = function (arg_14_0, arg_14_1)
	local var_14_0 = ScriptUnit.extension(arg_14_0, arg_14_1)

	if var_14_0.destroy then
		var_14_0:destroy()
	end
end

ScriptUnit.optimize = function (arg_15_0)
	if Unit.alive(arg_15_0) then
		if Unit.get_data(arg_15_0, "disable_shadows") then
			local var_15_0 = Unit.num_meshes(arg_15_0)

			for iter_15_0 = 0, var_15_0 - 1 do
				Unit.set_mesh_visibility(arg_15_0, iter_15_0, false, "shadow_caster")
			end
		end

		if Unit.get_data(arg_15_0, "force_ssm") then
			local var_15_1 = Unit.num_meshes(arg_15_0)

			for iter_15_1 = 0, var_15_1 - 1 do
				Unit.set_mesh_ssm_visibility(arg_15_0, iter_15_1, true)
			end
		end

		if Unit.get_data(arg_15_0, "disable_physics") then
			local var_15_2 = Unit.num_actors(arg_15_0)

			for iter_15_2 = 0, var_15_2 - 1 do
				Unit.destroy_actor(arg_15_0, iter_15_2)
			end
		end
	end
end

ScriptUnit.remove_extension = function (arg_16_0, arg_16_1)
	var_0_3(arg_16_0, arg_16_1)
end

ScriptUnit.remove_unit = var_0_2

ScriptUnit.extension_definitions = function (arg_17_0)
	local var_17_0 = {}
	local var_17_1 = 0

	while Unit.has_data(arg_17_0, "extensions", var_17_1) do
		var_17_0[var_17_1], var_17_1 = Unit.get_data(arg_17_0, "extensions", var_17_1), var_17_1 + 1
	end

	return var_17_0, var_17_1
end

ScriptUnit.move_extensions = function (arg_18_0, arg_18_1)
	var_0_0[arg_18_1] = var_0_0[arg_18_0]
	var_0_0[arg_18_0] = nil
end

ScriptUnit.save_scene_graph = function (arg_19_0)
	local var_19_0 = {}

	for iter_19_0 = 0, Unit.num_scene_graph_items(arg_19_0) - 1 do
		local var_19_1 = Unit.scene_graph_parent(arg_19_0, iter_19_0)
		local var_19_2 = Matrix4x4Box(Unit.local_pose(arg_19_0, iter_19_0))

		var_19_0[iter_19_0] = {
			parent = var_19_1,
			local_pose = var_19_2
		}
	end

	return var_19_0
end

ScriptUnit.restore_scene_graph = function (arg_20_0, arg_20_1)
	for iter_20_0, iter_20_1 in ipairs(arg_20_1) do
		if iter_20_1.parent then
			Unit.scene_graph_link(arg_20_0, iter_20_0, iter_20_1.parent)
			Unit.set_local_pose(arg_20_0, iter_20_0, iter_20_1.local_pose:unbox())
		end
	end
end

ScriptUnit.set_material_variable = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if type(arg_21_2) == "number" then
		Unit.set_scalar_for_materials(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	elseif type(arg_21_2) == "table" then
		local var_21_0 = #arg_21_2

		if var_21_0 == 2 then
			Unit.set_vector2_for_materials(arg_21_0, arg_21_1, Vector2(arg_21_2[1], arg_21_2[2]), arg_21_3)
		elseif var_21_0 == 3 then
			Unit.set_vector3_for_materials(arg_21_0, arg_21_1, Vector3(arg_21_2[1], arg_21_2[2], arg_21_2[3]), arg_21_3)
		else
			Unit.set_vector4_for_materials(arg_21_0, arg_21_1, Color(arg_21_2[1], arg_21_2[2], arg_21_2[3], arg_21_2[4]), arg_21_3)
		end
	end
end
