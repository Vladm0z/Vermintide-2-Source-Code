-- chunkname: @foundation/scripts/util/script_unit.lua

local ScriptUnit = ScriptUnit

ScriptUnit = ScriptUnit or {}
ScriptUnit = ScriptUnit

local var_0_1 = rawget(_G, "G_Entities")

if not var_0_1 then
	var_0_1 = {}

	rawset(_G, "G_Entities", var_0_1)
end

local function fn()
	-- function 1
	var_0_1 = {}

	rawset(_G, "G_Entities", var_0_1)
end

local function fn_2(arg_2_0)
	-- function 2
	var_0_1[arg_2_0] = nil
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local var_3_0 = var_0_1[arg_3_0]

	fassert(var_3_0)
	fassert(var_3_0[arg_3_1], "Tried to remove system %s extension for unit %s", arg_3_1, arg_3_0)

	var_3_0[arg_3_1] = nil
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = var_0_1[arg_4_0]

	if not var_4_0 then
		var_4_0 = {}
		var_0_1[arg_4_0] = var_4_0
	end

	var_4_0[arg_4_1] = arg_4_2
end

local function fn_5(arg_5_0, arg_5_1)
	-- function 5
	local var_5_0 = var_0_1[arg_5_0]

	return not var_5_0 and var_5_0[arg_5_1]
end

local function fn_6(arg_6_0, arg_6_1)
	-- function 6
	local var_6_0 = var_0_1[arg_6_0]

	if not var_6_0 then
		-- Nothing
	end

	::label_6_0::

	local var_6_1 = var_6_0[arg_6_1]

	var_6_1 = not var_6_1 and var_6_0[arg_6_1].input

	::label_6_1::

	return var_6_1
end

ScriptUnit.extension_input = function (arg_7_0, arg_7_1)
	-- function 7
	return fn_5(arg_7_0, arg_7_1).input
end

ScriptUnit.extension = function (arg_8_0, arg_8_1)
	-- function 8
	local var_8_0 = var_0_1[arg_8_0]

	return not var_8_0 and var_8_0[arg_8_1]
end

ScriptUnit.extensions = function (arg_9_0)
	-- function 9
	return var_0_1[arg_9_0]
end

ScriptUnit.has_extension = fn_5

ScriptUnit.has_extension_input = function (arg_10_0, arg_10_1)
	-- function 10
	local var_10_0 = var_0_1[arg_10_0]

	if not var_10_0 then
		-- Nothing
	end

	::label_10_0::

	local var_10_1 = var_10_0[arg_10_1]

	var_10_1 = not var_10_1 and var_10_0[arg_10_1].input

	::label_10_1::

	return var_10_1
end

ScriptUnit.check_all_units_deleted = function ()
	-- function 11
	if not next(var_0_1) then
		print("------------ UNITS THAT HAVENT BEEN DELETED --------------")

		for k, v in pairs(var_0_1) do
			local var_11_0 = unit_alive_info(k)

			print(k, Unit.alive(k), var_11_0)
		end

		fassert(false, "Some units have not been cleaned up properly!")
	end
end

ScriptUnit.set_extension = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	fn_4(arg_12_0, arg_12_1, arg_12_2)
end

ScriptUnit.add_extension = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	local var_13_0 = rawget(_G, arg_13_2)

	fassert(var_13_0, "No class found for extension with name %q", arg_13_2)

	local var_13_1
	local var_13_2 = var_13_0:new(arg_13_0, arg_13_1, arg_13_4)

	fassert(not ScriptUnit.has_extension(arg_13_1, arg_13_3), "An extension already exists with name %q belonging to unit %s", arg_13_3, arg_13_1)
	fn_4(arg_13_1, arg_13_3, var_13_2)

	return var_13_2
end

ScriptUnit.destroy_extension = function (arg_14_0, arg_14_1)
	-- function 14
	local extension = ScriptUnit.extension(arg_14_0, arg_14_1)

	if not extension.destroy then
		extension:destroy()
	end
end

ScriptUnit.optimize = function (arg_15_0)
	-- function 15
	if not Unit.alive(arg_15_0) then
		if not Unit.get_data(arg_15_0, "disable_shadows") then
			local num_meshes = Unit.num_meshes(arg_15_0)

			for i = 0, num_meshes - 1 do
				Unit.set_mesh_visibility(arg_15_0, i, false, "shadow_caster")
			end
		end

		if not Unit.get_data(arg_15_0, "force_ssm") then
			local num_meshes_2 = Unit.num_meshes(arg_15_0)

			for j = 0, num_meshes_2 - 1 do
				Unit.set_mesh_ssm_visibility(arg_15_0, j, true)
			end
		end

		if not Unit.get_data(arg_15_0, "disable_physics") then
			local num_actors = Unit.num_actors(arg_15_0)

			for k = 0, num_actors - 1 do
				Unit.destroy_actor(arg_15_0, k)
			end
		end
	end
end

ScriptUnit.remove_extension = function (arg_16_0, arg_16_1)
	-- function 16
	fn_3(arg_16_0, arg_16_1)
end

ScriptUnit.remove_unit = fn_2

ScriptUnit.extension_definitions = function (arg_17_0)
	-- function 17
	local tbl = {}
	local num = 0

	while not Unit.has_data(arg_17_0, "extensions", num) do
		tbl[num], num = Unit.get_data(arg_17_0, "extensions", num), num + 1
	end

	return tbl, num
end

ScriptUnit.move_extensions = function (arg_18_0, arg_18_1)
	-- function 18
	var_0_1[arg_18_1] = var_0_1[arg_18_0]
	var_0_1[arg_18_0] = nil
end

ScriptUnit.save_scene_graph = function (arg_19_0)
	-- function 19
	local tbl = {}

	for i = 0, Unit.num_scene_graph_items(arg_19_0) - 1 do
		local scene_graph_parent = Unit.scene_graph_parent(arg_19_0, i)
		local var_19_2 = Matrix4x4Box(Unit.local_pose(arg_19_0, i))

		tbl[i] = {
			parent = scene_graph_parent,
			local_pose = var_19_2
		}
	end

	return tbl
end

ScriptUnit.restore_scene_graph = function (arg_20_0, arg_20_1)
	-- function 20
	for i, v in ipairs(arg_20_1) do
		if not v.parent then
			Unit.scene_graph_link(arg_20_0, i, v.parent)
			Unit.set_local_pose(arg_20_0, i, v.local_pose:unbox())
		end
	end
end

ScriptUnit.set_material_variable = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	if type(arg_21_2) == "number" then
		Unit.set_scalar_for_materials(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	elseif type(arg_21_2) == "table" then
		local count = #arg_21_2

		if count == 2 then
			Unit.set_vector2_for_materials(arg_21_0, arg_21_1, Vector2(arg_21_2[1], arg_21_2[2]), arg_21_3)
		elseif count == 3 then
			Unit.set_vector3_for_materials(arg_21_0, arg_21_1, Vector3(arg_21_2[1], arg_21_2[2], arg_21_2[3]), arg_21_3)
		else
			Unit.set_vector4_for_materials(arg_21_0, arg_21_1, Color(arg_21_2[1], arg_21_2[2], arg_21_2[3], arg_21_2[4]), arg_21_3)
		end
	end
end
