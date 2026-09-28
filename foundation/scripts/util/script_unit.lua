-- chunkname: @foundation/scripts/util/script_unit.lua

local ScriptUnit = ScriptUnit

ScriptUnit = not not ScriptUnit or not not {}
ScriptUnit = ScriptUnit

local Entities = rawget(_G, "G_Entities")

if not Entities then
	Entities = {}

	rawset(_G, "G_Entities", Entities)
end

local function reset_entities()
	-- function 1
	Entities = {}

	rawset(_G, "G_Entities", Entities)
end

local function remove_unit(unit)
	-- function 2
	Entities[unit] = nil
end

local function local_remove_extension(unit, system_name)
	-- function 3
	local unit_extensions = Entities[unit]

	fassert(unit_extensions)
	fassert(unit_extensions[system_name], "Tried to remove system %s extension for unit %s", system_name, unit)

	unit_extensions[system_name] = nil
end

local function set_extension_script(unit, system_name, extension)
	-- function 4
	local unit_extensions = Entities[unit]

	if not unit_extensions then
		unit_extensions = {}
		Entities[unit] = unit_extensions
	end

	unit_extensions[system_name] = extension
end

local function local_extension(unit, system_name)
	-- function 5
	local unit_extensions = Entities[unit]

	return not not unit_extensions and not not unit_extensions[system_name]
end

local function local_extension_input(unit, system_name)
	-- function 6
	local unit_extensions = Entities[unit]

	if unit_extensions then
		-- Nothing
	end

	::label_6_0::

	local var_6_0 = unit_extensions[system_name]

	var_6_0 = not not var_6_0 and not not unit_extensions[system_name].input

	::label_6_1::

	return var_6_0
end

ScriptUnit.extension_input = function (unit, system_name)
	-- function 7
	local extension = local_extension(unit, system_name)

	return extension.input
end

ScriptUnit.extension = function (unit, system_name)
	-- function 8
	local unit_extensions = Entities[unit]
	local extension = not not unit_extensions and not not unit_extensions[system_name]

	return extension
end

ScriptUnit.extensions = function (unit)
	-- function 9
	return Entities[unit]
end

ScriptUnit.has_extension = local_extension

ScriptUnit.has_extension_input = function (unit, extension_name)
	-- function 10
	local unit_extensions = Entities[unit]

	if unit_extensions then
		-- Nothing
	end

	::label_10_0::

	local var_10_0 = unit_extensions[extension_name]

	var_10_0 = not not var_10_0 and not not unit_extensions[extension_name].input

	::label_10_1::

	return var_10_0
end

ScriptUnit.check_all_units_deleted = function ()
	-- function 11
	if next(Entities) then
		print("------------ UNITS THAT HAVENT BEEN DELETED --------------")

		for unit, extensions in pairs(Entities) do
			local info = unit_alive_info(unit)

			print(unit, Unit.alive(unit), info)
		end

		fassert(false, "Some units have not been cleaned up properly!")
	end
end

ScriptUnit.set_extension = function (unit, system_name, extension)
	-- function 12
	set_extension_script(unit, system_name, extension)
end

ScriptUnit.add_extension = function (extension_init_context, unit, extension_name, extension_alias, extension_init_data, extension_pool_table)
	-- function 13
	local extension_class = rawget(_G, extension_name)

	fassert(extension_class, "No class found for extension with name %q", extension_name)

	local extension

	extension = extension_class:new(extension_init_context, unit, extension_init_data)

	fassert(not ScriptUnit.has_extension(unit, extension_alias), "An extension already exists with name %q belonging to unit %s", extension_alias, unit)
	set_extension_script(unit, extension_alias, extension)

	return extension
end

ScriptUnit.destroy_extension = function (unit, system_name)
	-- function 14
	local extension = ScriptUnit.extension(unit, system_name)

	if extension.destroy then
		extension:destroy()
	end
end

ScriptUnit.optimize = function (unit)
	-- function 15
	if Unit.alive(unit) then
		local disable_shadows = Unit.get_data(unit, "disable_shadows")

		if disable_shadows then
			local num_meshes = Unit.num_meshes(unit)

			for i = 0, num_meshes - 1 do
				Unit.set_mesh_visibility(unit, i, false, "shadow_caster")
			end
		end

		local force_ssm = Unit.get_data(unit, "force_ssm")

		if force_ssm then
			local num_meshes = Unit.num_meshes(unit)

			for i = 0, num_meshes - 1 do
				Unit.set_mesh_ssm_visibility(unit, i, true)
			end
		end

		local disable_physics = Unit.get_data(unit, "disable_physics")

		if disable_physics then
			local num_actors = Unit.num_actors(unit)

			for i = 0, num_actors - 1 do
				Unit.destroy_actor(unit, i)
			end
		end
	end
end

ScriptUnit.remove_extension = function (unit, system_name)
	-- function 16
	local_remove_extension(unit, system_name)
end

ScriptUnit.remove_unit = remove_unit

ScriptUnit.extension_definitions = function (unit)
	-- function 17
	local extensions = {}
	local i = 0

	while Unit.has_data(unit, "extensions", i) do
		local class_name = Unit.get_data(unit, "extensions", i)

		i = i + 1
		extensions[i] = class_name
	end

	return extensions, i
end

ScriptUnit.move_extensions = function (unit, new_unit)
	-- function 18
	Entities[new_unit] = Entities[unit]
	Entities[unit] = nil
end

ScriptUnit.save_scene_graph = function (unit)
	-- function 19
	local link_table = {}

	for node_index = 0, Unit.num_scene_graph_items(unit) - 1 do
		local parent_node = Unit.scene_graph_parent(unit, node_index)
		local local_pose = Matrix4x4Box(Unit.local_pose(unit, node_index))

		link_table[node_index] = {
			parent = parent_node,
			local_pose = local_pose
		}
	end

	return link_table
end

ScriptUnit.restore_scene_graph = function (unit, link_table)
	-- function 20
	for i, link in ipairs(link_table) do
		if link.parent then
			Unit.scene_graph_link(unit, i, link.parent)
			Unit.set_local_pose(unit, i, link.local_pose:unbox())
		end
	end
end

ScriptUnit.set_material_variable = function (unit, material_variable, value, include_children)
	-- function 21
	if type(value) == "number" then
		Unit.set_scalar_for_materials(unit, material_variable, value, include_children)
	elseif type(value) == "table" then
		local num_values = #value

		if num_values == 2 then
			Unit.set_vector2_for_materials(unit, material_variable, Vector2(value[1], value[2]), include_children)
		elseif num_values == 3 then
			Unit.set_vector3_for_materials(unit, material_variable, Vector3(value[1], value[2], value[3]), include_children)
		else
			Unit.set_vector4_for_materials(unit, material_variable, Color(value[1], value[2], value[3], value[4]), include_children)
		end
	end
end
