-- chunkname: @scripts/flow/flow_callbacks_enemy.lua

require("foundation/scripts/util/table")
require("scripts/settings/unit_variation_settings")
require("scripts/settings/unit_gib_settings")

local num = 3
local num_2 = 2
local num_3 = 0.15

function flow_callback_enemy_dissolve_data(arg_1_0)
	-- function 1
	return {
		dissovle_time = num,
		darken_time = num_2,
		darken_to = num_3
	}
end

function flow_callback_enemy_dissolve_darken_vector(arg_2_0)
	-- function 2
	return {
		darken_vector = Vector3(1, num_3, num_2)
	}
end

local function fn(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	for i = 1, #arg_3_1 do
		if not Unit.has_mesh(arg_3_0, arg_3_1[i]) then
			local mesh = Unit.mesh(arg_3_0, arg_3_1[i])
			local material = Mesh.material(mesh, arg_3_2)

			Material.set_scalar(material, arg_3_3, arg_3_4)
		end
	end
end

local function fn_2(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local random = math.random(arg_4_2.min, arg_4_2.max)

	if arg_4_2.scale ~= nil then
		random = random * arg_4_2.scale
	end

	local meshes = arg_4_2.meshes

	if not meshes then
		for i = 1, #arg_4_2.variables do
			Unit.set_scalar_for_material_table(arg_4_0, arg_4_2.materials, arg_4_2.variables[i], random)

			if arg_4_1 ~= nil then
				for j = 1, #arg_4_1 do
					local var_4_2 = arg_4_1[j]

					Unit.set_scalar_for_material_table(var_4_2, arg_4_2.materials, arg_4_2.variables[i], random)
				end
			end
		end
	else
		for k = 1, #arg_4_2.materials do
			for l = 1, #arg_4_2.variables do
				fn(arg_4_0, meshes, arg_4_2.materials[k], arg_4_2.variables[l], random)

				if arg_4_1 ~= nil then
					for i4 = 1, #arg_4_1 do
						local var_4_3 = arg_4_1[i4]

						fn(var_4_3, meshes, arg_4_2.materials[k], arg_4_2.variables[l], random)
					end
				end
			end
		end
	end

	for i5 = 1, #arg_4_2.materials do
		for i6 = 1, #arg_4_2.variables do
			table.insert(arg_4_3, {
				material = arg_4_2.materials[i5],
				variable = arg_4_2.variables[i6],
				value = random,
				meshes = arg_4_2.meshes
			})
		end
	end

	return {}
end

local function fn_3(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	for i = 1, #arg_5_3 do
		fn_2(arg_5_0, arg_5_1, arg_5_2.material_variations[arg_5_3[i]], arg_5_4)
	end
end

local function fn_4(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	for i = 1, #arg_6_3 do
		local var_6_0 = arg_6_3[i]
		local var_6_1 = arg_6_2.body_parts[var_6_0]
		local var_6_2 = var_6_1[math.random(#var_6_1)]

		if not var_6_2.group then
			Unit.set_visibility(arg_6_0, var_6_2.group, true)
			table.insert(arg_6_4, var_6_2.group)

			if arg_6_2.material_variations ~= nil then
				local var_6_3 = arg_6_2.material_variations[var_6_2.group]

				if not var_6_3 then
					fn_2(arg_6_0, arg_6_1, var_6_3, arg_6_5)
				end
			end
		end

		if not var_6_2.enables then
			fn_4(arg_6_0, arg_6_1, arg_6_2, var_6_2.enables, arg_6_4, arg_6_5)
		end
	end
end

local function fn_5(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local var_7_0

	for k, v in pairs(arg_7_2.scale_variation) do
		for k_2 = 1, #v do
			if v[k_2] ~= nil then
				if not Unit.has_node(arg_7_0, v[k_2]) then
					local node = Unit.node(arg_7_0, v[k_2])

					Unit.set_local_scale(arg_7_0, node, Vector3(0, 0, 0))
				end

				if arg_7_1 ~= nil then
					for l = 1, #arg_7_1 do
						if not Unit.has_node(arg_7_1[l], v[k_2]) then
							local node_2 = Unit.node(arg_7_1[l], v[k_2])

							Unit.set_local_scale(arg_7_1[l], node_2, Vector3(0, 0, 0))
						end
					end
				end

				arg_7_3[v[k_2]] = 0
			end
		end

		local var_7_3 = v[math.random(#v)]

		if var_7_3 ~= nil then
			if not Unit.has_node(arg_7_0, var_7_3) then
				local node_3 = Unit.node(arg_7_0, var_7_3)

				Unit.set_local_scale(arg_7_0, node_3, Vector3(1, 1, 1))
			end

			if arg_7_1 ~= nil then
				for i4 = 1, #arg_7_1 do
					if not Unit.has_node(arg_7_1[i4], var_7_3) then
						local node_4 = Unit.node(arg_7_1[i4], var_7_3)

						Unit.set_local_scale(arg_7_1[i4], node_4, Vector3(1, 1, 1))
					end
				end
			end

			arg_7_3[var_7_3] = 1
		end
	end
end

function flow_callback_enemy_variation(self)
	-- function 8
	local unit = self.unit
	local breed_type = self.breed_type
	local get_data = Unit.get_data(unit, "breed")

	if get_data ~= nil then
		breed_type = get_data.name
	end

	if breed_type == nil then
		return {}
	end

	if not self.baked then
		breed_type = breed_type .. "_baked"
	end

	if UnitVariationSettings[breed_type] == nil then
		return {}
	end

	local var_8_3 = UnitVariationSettings[breed_type]
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local tbl_6 = {}

	if ScriptUnit ~= nil then
		local has_extension = ScriptUnit.has_extension(unit, "ai_inventory_system")

		if has_extension ~= nil then
			tbl_5 = has_extension.inventory_item_outfit_units
			tbl_6 = has_extension.inventory_item_helmet_units
		end
	else
		tbl_5 = Unit.get_data(unit, "outfit_items") or {}
		tbl_6 = Unit.get_data(unit, "helmet_items") or {}
	end

	if tbl_5 ~= nil then
		for i = 1, #tbl_5 do
			local get_data_2 = Unit.get_data(tbl_5[i], "gib_variation")

			if get_data_2 ~= nil then
				table.insert(tbl_3, get_data_2)
			end
		end
	end

	if tbl_6 ~= nil then
		tbl_5 = table.shallow_copy(tbl_5)

		for j = 1, #tbl_6 do
			table.insert(tbl_5, tbl_6[j])
		end
	end

	if var_8_3.materials_enabled_from_start ~= nil then
		fn_3(unit, tbl_5, var_8_3, var_8_3.materials_enabled_from_start, tbl_2)
	end

	if var_8_3.enabled_from_start ~= nil then
		if not Unit.has_visibility_group(unit, "all") then
			Unit.set_visibility(unit, "all", false)
		end

		fn_4(unit, tbl_5, var_8_3, var_8_3.enabled_from_start, tbl_3, tbl_2)
	end

	if var_8_3.scale_variation ~= nil then
		fn_5(unit, tbl_5, var_8_3, tbl_4)
	end

	tbl.groups = tbl_3
	tbl.materials = tbl_2
	tbl.scaling = tbl_4

	Unit.set_data(unit, "variation_data", tbl)
	Unit.set_data(unit, "dismember_filter", {})

	return {}
end

local function fn_6(arg_9_0, arg_9_1)
	-- function 9
	local get_data = Unit.get_data(arg_9_0, "dismember_filter")

	get_data = get_data or {}

	if not table.contains(get_data, arg_9_1) then
		return false
	end

	return true
end

local function fn_7(arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local get_data = Unit.get_data(arg_10_0, "dismember_filter")

	get_data = get_data or {}

	if not table.contains(get_data, arg_10_1) then
		table.insert(get_data, arg_10_1)
	end

	if arg_10_2.disable_gibs ~= nil then
		for i = 1, #arg_10_2.disable_gibs do
			if not table.contains(get_data, arg_10_2.disable_gibs[i]) then
				table.insert(get_data, arg_10_2.disable_gibs[i])
			end
		end
	end

	Unit.set_data(arg_10_0, "dismember_filter", get_data)
end

local function fn_8(arg_11_0, arg_11_1)
	-- function 11
	local tbl = {}

	if arg_11_1 ~= nil then
		tbl = arg_11_1.inventory_item_helmet_units
	else
		tbl = Unit.get_data(arg_11_0, "helmet_items") or {}
	end

	return tbl
end

local function fn_9(arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	if arg_12_2.gib_helmet_link_node ~= nil then
		local var_12_0 = fn_8(arg_12_0, arg_12_1)

		for i = 1, #var_12_0 do
			if not Unit.has_animation_state_machine(var_12_0[i]) then
				Unit.disable_animation_state_machine(var_12_0[i])
			end
		end
	end
end

local function fn_10(self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	local node = Unit.node(arg_13_1, arg_13_3.gib_parent_align_node)
	local world_rotation = Unit.world_rotation(arg_13_1, node)
	local world_position = Unit.world_position(arg_13_1, node)

	if not Vector3.is_valid(world_position) then
		return
	end

	local from_quaternion_position = Matrix4x4.from_quaternion_position(world_rotation, world_position)

	if arg_13_3.gib_disable_auto_scale ~= true then
		local local_scale = Unit.local_scale(arg_13_1, 1)

		if arg_13_6 ~= nil then
			local _size_variation = arg_13_6._size_variation

			_size_variation = _size_variation or 1
			local_scale = Vector3(_size_variation, _size_variation, _size_variation)
		end

		Matrix4x4.set_scale(from_quaternion_position, local_scale)
	end

	local var_13_6

	if self ~= nil then
		if arg_13_3.gib_unit_template ~= nil then
			var_13_6 = self:spawn_local_unit_with_extensions(arg_13_3.gib_unit, arg_13_3.gib_unit_template, nil, from_quaternion_position)
		else
			var_13_6 = self:spawn_local_unit(arg_13_3.gib_unit, from_quaternion_position)
		end
	else
		var_13_6 = World.spawn_unit(arg_13_2, arg_13_3.gib_unit, from_quaternion_position)
	end

	if arg_13_3.gib_helmet_link_node ~= nil then
		local var_13_7 = fn_8(arg_13_1, arg_13_5)

		for i = 1, #var_13_7 do
			World.unlink_unit(arg_13_2, var_13_7[i])
			World.link_unit(Unit.world(var_13_6), var_13_7[i], var_13_6, Unit.node(var_13_6, arg_13_3.gib_helmet_link_node))
			Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(var_13_7[i], "outline_unit", false)
		end
	end

	local actor = Unit.actor(var_13_6, arg_13_3.gib_push_actor)

	if not actor then
		-- Nothing
	else
		if not Unit.has_node(var_13_6, "a_push") then
			node = Unit.node(var_13_6, "a_push")
		else
			node = Script.index_offset()
		end

		if arg_13_4 ~= 1 then
			Actor.add_velocity(actor, Quaternion.rotate(Unit.world_rotation(var_13_6, node), Vector3(2 + math.random(-0.5, 0.5), math.random(-1, 1), math.random(-1, 1))) * (arg_13_3.gib_push_force * 0.75) * arg_13_4)
			Actor.add_angular_velocity(actor, Vector3(math.random(0, 2), math.random(0, 2), math.random(0, 2)) * arg_13_4)
		else
			Actor.add_velocity(actor, Quaternion.rotate(Unit.world_rotation(var_13_6, node), Vector3(2 + 0.5 * math.random(), math.random() - 0.5, math.random() - 0.5)) * arg_13_3.gib_push_force)
		end
	end

	return var_13_6
end

local function fn_11(self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local node = Unit.node(arg_14_1, arg_14_3.stump_parent_align_node)
	local var_14_1

	if not arg_14_4 and not arg_14_3.pulp_stump_unit then
		if type(arg_14_3.pulp_stump_unit) == "table" then
			var_14_1 = arg_14_3.pulp_stump_unit[Math.random(1, #arg_14_3.pulp_stump_unit)]
		else
			var_14_1 = arg_14_3.pulp_stump_unit
		end
	else
		var_14_1 = arg_14_3.stump_unit
	end

	local var_14_2

	if self ~= nil then
		var_14_2 = self:spawn_local_unit(var_14_1, Unit.world_position(arg_14_1, node), Unit.world_rotation(arg_14_1, node))
	else
		var_14_2 = World.spawn_unit(arg_14_2, var_14_1, Unit.world_position(arg_14_1, node), Unit.world_rotation(arg_14_1, node))
	end

	local stump_link_nodes = arg_14_3.stump_link_nodes
	local parent_link_nodes = arg_14_3.parent_link_nodes

	World.link_unit(arg_14_2, var_14_2, Script.index_offset(), arg_14_1, Unit.node(arg_14_1, parent_link_nodes[1]))

	for i = 1, #parent_link_nodes do
		local node_2 = Unit.node(arg_14_1, parent_link_nodes[i])
		local node_3 = Unit.node(var_14_2, stump_link_nodes[i])

		World.link_unit(arg_14_2, var_14_2, node_3, arg_14_1, node_2)
	end

	if not Unit.has_lod_object(arg_14_1, "lod") and not Unit.has_lod_object(var_14_2, "lod") then
		local lod_object = Unit.lod_object(arg_14_1, "lod")
		local lod_object_2 = Unit.lod_object(var_14_2, "lod")

		LODObject.set_bounding_volume(lod_object_2, LODObject.bounding_volume(lod_object))
		World.link_unit(arg_14_2, var_14_2, LODObject.node(lod_object_2), arg_14_1, LODObject.node(lod_object))
	end

	return var_14_2
end

local function fn_12(arg_15_0, arg_15_1)
	-- function 15
	for k, v in pairs(arg_15_1.materials) do
		local meshes = v.meshes

		if not meshes then
			Unit.set_scalar_for_material(arg_15_0, v.material, v.variable, v.value)
		else
			fn(arg_15_0, meshes, v.material, v.variable, v.value)
		end
	end

	if not Unit.has_visibility_group(arg_15_0, "all") then
		Unit.set_visibility(arg_15_0, "all", false)

		for k_2 = 1, #arg_15_1.groups do
			if not Unit.has_visibility_group(arg_15_0, arg_15_1.groups[k_2]) then
				Unit.set_visibility(arg_15_0, arg_15_1.groups[k_2], true)
			end
		end
	end

	for k_3, v_2 in pairs(arg_15_1.scaling) do
		if not Unit.has_node(arg_15_0, k_3) then
			local node = Unit.node(arg_15_0, k_3)

			Unit.set_local_scale(arg_15_0, node, Vector3(v_2, v_2, v_2))
		end
	end
end

local function fn_13(arg_16_0)
	-- function 16
	local num_meshes = Unit.num_meshes(arg_16_0)
	local index_offset = Script.index_offset()
	local num = 1 - index_offset

	for i = index_offset, num_meshes - num do
		local mesh = Unit.mesh(arg_16_0, i)
		local num_materials = Mesh.num_materials(mesh)

		for j = index_offset, num_materials - num do
			local material = Mesh.material(mesh, j)

			Material.set_scalar(material, "snow", 1)
		end
	end
end

local function fn_14(arg_17_0, arg_17_1)
	-- function 17
	if not Unit.has_visibility_group(arg_17_0, "all") then
		Unit.set_visibility(arg_17_0, "all", false)

		if not Unit.has_visibility_group(arg_17_0, "var" .. arg_17_1) then
			Unit.set_visibility(arg_17_0, "var" .. arg_17_1, true)
		end
	end
end

local function fn_15(arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local get_data = Unit.get_data(arg_18_0, "variation_data")
	local get_data_2 = Unit.get_data(arg_18_0, "gib_variation")

	if not (get_data ~= nil or get_data_2 ~= nil) then
		return
	end

	if get_data ~= nil then
		if arg_18_1 ~= nil then
			fn_12(arg_18_1, get_data)
		end

		if arg_18_2 ~= nil then
			fn_12(arg_18_2, get_data)
		end
	end

	if get_data_2 ~= nil then
		if arg_18_1 ~= nil then
			fn_14(arg_18_1, get_data_2)
		end

		if arg_18_2 ~= nil then
			fn_14(arg_18_2, get_data_2)
		end
	end
end

local function fn_16(arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	if arg_19_2 ~= nil then
		local disabled_actors = arg_19_2.disabled_actors

		for i = 1, #arg_19_1 do
			local actor = Unit.actor(arg_19_0, arg_19_1[i])

			if not actor then
				Actor.set_scene_query_enabled(actor, false)
				Actor.set_collision_filter(actor, "filter_ragdoll_secondary")

				if disabled_actors ~= nil then
					table.insert(disabled_actors, arg_19_1[i])
				end
			end
		end

		arg_19_2.disabled_actors = disabled_actors
	else
		for j = 1, #arg_19_1 do
			if Unit.actor(arg_19_0, arg_19_1[j]) ~= nil then
				Unit.destroy_actor(arg_19_0, arg_19_1[j])
			end
		end
	end
end

local function fn_17(self, arg_20_1)
	-- function 20
	local unit = self.unit
	local breed_type = self.breed_type
	local get_data = Unit.get_data(unit, "breed")

	if get_data ~= nil then
		breed_type = get_data.name
	end

	if breed_type == nil then
		return
	end

	if not self.baked then
		breed_type = breed_type .. "_baked"
	end

	if UnitGibSettings[breed_type] == nil then
		return
	end

	local bodypart = self.bodypart

	if UnitGibSettings[breed_type].parts[bodypart] == nil then
		return
	end

	local var_20_4 = UnitGibSettings[breed_type].parts[bodypart]

	if not fn_6(unit, bodypart) then
		return
	end

	local world = Unit.world(unit)
	local var_20_6
	local var_20_7
	local var_20_8
	local var_20_9

	if ScriptUnit ~= nil then
		var_20_7 = ScriptUnit.has_extension(unit, "ai_inventory_system")
		var_20_8 = ScriptUnit.has_extension(unit, "ai_system")
		var_20_9 = Managers.state.unit_spawner

		if not ScriptUnit.has_extension(unit, "projectile_linker_system") then
			Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(unit)
		end
	end

	local var_20_10

	if not arg_20_1 then
		var_20_10 = fn_10(var_20_9, unit, world, var_20_4, 1, var_20_7, var_20_8)
	else
		fn_9(unit, var_20_7, var_20_4)
	end

	fn_16(unit, var_20_4.parent_destroy_actors, var_20_7)
	fn_16(unit, var_20_4.ragdoll_destroy_actors, nil)

	local var_20_11 = fn_11(var_20_9, unit, world, var_20_4, not arg_20_1)

	fn_15(unit, var_20_10, var_20_11)

	if not Unit.get_data(unit, "was_burned") then
		Unit.flow_event(var_20_11, "lua_already_burned")

		if var_20_10 ~= nil then
			Unit.flow_event(var_20_10, "lua_already_burned")
		end
	end

	if not Unit.get_data(unit, "snow_state") then
		fn_13(var_20_11)

		if var_20_10 ~= nil then
			fn_13(var_20_10)
		end
	end

	local var_20_12

	if var_20_7 ~= nil then
		var_20_12 = var_20_7.gibbed_nodes or {}
	end

	for i = 1, #var_20_4.parent_scale_nodes do
		local node = Unit.node(unit, var_20_4.parent_scale_nodes[i])

		Unit.set_local_scale(unit, node, Vector3(var_20_4.parent_scale, var_20_4.parent_scale, var_20_4.parent_scale))

		if var_20_12 ~= nil then
			var_20_12[#var_20_12 + 1] = node
		end
	end

	if var_20_7 ~= nil then
		var_20_7.gibbed_nodes = var_20_12
	end

	if var_20_4.parent_hide_group == nil or not Unit.has_visibility_group(unit, var_20_4.parent_hide_group) then
		Unit.set_visibility(unit, var_20_4.parent_hide_group, false)
	end

	if var_20_4.send_outfit_event ~= nil then
		if var_20_7 ~= nil then
			for j = 1, #var_20_7.inventory_item_outfit_units do
				Unit.flow_event(var_20_7.inventory_item_outfit_units[j], var_20_4.send_outfit_event)
			end
		else
			local get_data_2 = Unit.get_data(unit, "outfit_items")

			get_data_2 = get_data_2 or {}

			for k = 1, #get_data_2 do
				Unit.flow_event(get_data_2[k], var_20_4.send_outfit_event)
			end
		end
	end

	if BloodSettings == nil or not BloodSettings.enemy_blood.enabled then
		local node_2 = Unit.node(var_20_11, "a_vfx")

		if var_20_4.vfx ~= nil then
			local create_particles = World.create_particles(world, var_20_4.vfx, Unit.world_position(var_20_11, node_2), Unit.world_rotation(var_20_11, node_2))

			World.link_particles(world, create_particles, var_20_11, node_2, Matrix4x4.identity(), "destroy")
		end

		if not (var_20_10 ~= nil or var_20_4.pulp_vfx == nil) then
			local create_particles_2 = World.create_particles(world, var_20_4.pulp_vfx, Unit.world_position(var_20_11, node_2), Unit.world_rotation(var_20_11, node_2))

			World.link_particles(world, create_particles_2, var_20_11, node_2, Matrix4x4.identity(), "destroy")
		end
	end

	if not (arg_20_1 or bodypart ~= "head") then
		local wwise_world = Wwise.wwise_world(world)
		local node_3 = Unit.node(var_20_11, "a_vfx")

		WwiseWorld.trigger_event(wwise_world, "Play_combat_enemy_head_crush", var_20_11, node_3)
	end

	if ScriptUnit == nil or not var_20_4.stop_death_sound then
		local has_extension = ScriptUnit.has_extension(unit, "hit_reaction_system")

		if not has_extension then
			local wwise_world_2 = Wwise.wwise_world(world)
			local death_sound_event_id = has_extension:death_sound_event_id()

			if not death_sound_event_id then
				WwiseWorld.stop_event(wwise_world_2, death_sound_event_id)
			end
		end
	end

	if var_20_7 ~= nil then
		if var_20_10 ~= nil then
			local gib_items = var_20_7.gib_items

			table.insert(gib_items, var_20_10)

			var_20_7.gib_items = gib_items
		end

		local stump_items = var_20_7.stump_items

		table.insert(stump_items, var_20_11)

		var_20_7.stump_items = stump_items
	else
		if var_20_10 ~= nil then
			local get_data_3 = Unit.get_data(unit, "gib_items")

			get_data_3 = get_data_3 or {}

			table.insert(get_data_3, var_20_10)
			Unit.set_data(unit, "gib_items", get_data_3)
		end

		local get_data_4 = Unit.get_data(unit, "stump_items")

		get_data_4 = get_data_4 or {}

		table.insert(get_data_4, var_20_11)
		Unit.set_data(unit, "stump_items", get_data_4)
	end

	fn_7(unit, bodypart, var_20_4)
end

function enemy_explode(self)
	-- function 21
	local unit = self.unit
	local breed_type = self.breed_type
	local get_data = Unit.get_data(unit, "breed")

	if get_data ~= nil then
		breed_type = get_data.name
	end

	if breed_type == nil then
		return
	end

	if not self.baked then
		breed_type = breed_type .. "_baked"
	end

	if UnitGibSettings[breed_type] == nil then
		return
	end

	if UnitGibSettings[breed_type].explode == nil then
		return
	end

	local explode = UnitGibSettings[breed_type].explode

	if explode.part_combos == nil then
		return
	end

	local world = Unit.world(unit)
	local var_21_5
	local var_21_6

	if ScriptUnit ~= nil then
		var_21_5 = ScriptUnit.has_extension(unit, "ai_inventory_system")
		var_21_6 = Managers.state.unit_spawner
	end

	if var_21_5 ~= nil then
		if #var_21_5.stump_items ~= 0 then
			return
		end
	elseif Unit.get_data(unit, "stump_items") ~= nil then
		return
	end

	if not Unit.get_data(unit, "exploded") then
		return
	end

	local var_21_7

	if not Unit.get_data(unit, "was_burned") then
		var_21_7 = true
	end

	local var_21_8 = explode.part_combos[math.random(#explode.part_combos)]
	local flag = false
	local num = 1

	if type(explode.push_force_multiplier) == "number" then
		num = explode.push_force_multiplier
	end

	for i = 1, #var_21_8 do
		if UnitGibSettings[breed_type].parts[var_21_8[i]] == nil then
			-- Nothing
		else
			local var_21_11 = UnitGibSettings[breed_type].parts[var_21_8[i]]
			local var_21_12 = fn_10(var_21_6, unit, world, var_21_11, num, var_21_5)

			fn_15(unit, var_21_12, nil)

			if not var_21_7 then
				Unit.flow_event(var_21_12, "lua_already_burned")
			end

			Unit.flow_event(var_21_12, "lua_start_despawn_timer")

			if var_21_11.gib_helmet_link_node ~= nil then
				flag = true
			end
		end
	end

	if not ((BloodSettings == nil or not BloodSettings.enemy_blood.enabled) and explode.vfx_align_node == nil) then
		local node = Unit.node(unit, explode.vfx_align_node)

		if explode.vfx ~= nil then
			local create_particles = World.create_particles(world, explode.vfx, Unit.world_position(unit, node), Unit.world_rotation(unit, node))

			World.link_particles(world, create_particles, unit, node, Matrix4x4.identity(), "destroy")
		end
	end

	local tbl = {}

	if var_21_5 ~= nil then
		tbl = var_21_5.inventory_item_outfit_units or {}
	else
		tbl = Unit.get_data(unit, "outfit_items") or {}
	end

	for j = 1, #tbl do
		Unit.set_unit_visibility(tbl[j], false)
	end

	local parts = UnitGibSettings[breed_type].parts

	for k = 1, #var_21_8 do
		local var_21_17 = parts[var_21_8[k]]

		if not (not var_21_17 and var_21_17.send_outfit_event == nil) then
			for l = 1, #tbl do
				Unit.flow_event(tbl[l], var_21_17.send_outfit_event)
			end
		end
	end

	local var_21_18 = fn_8(unit, var_21_5)

	for i4 = 1, #var_21_18 do
		if flag == false then
			Unit.set_unit_visibility(var_21_18[i4], false)
		else
			if var_21_5 == nil then
				Unit.set_data(unit, "helmet_items", {})
			end

			Unit.flow_event(var_21_18[i4], "lua_start_despawn_timer")
		end
	end

	Unit.set_unit_visibility(unit, false)
	Unit.disable_physics(unit)
	Unit.set_data(unit, "exploded", true)
end

function flow_callback_enemy_gib(arg_22_0)
	-- function 22
	if BloodSettings == nil or not BloodSettings.dismemberment.enabled then
		fn_17(arg_22_0, true)
	end

	return {}
end

function flow_callback_enemy_set_base_variation(self)
	-- function 23
	local unit = self.unit
	local tbl = {
		groups = {},
		materials = {},
		scaling = {}
	}

	Unit.set_data(unit, "variation_data", tbl)
end

function flow_callback_enemy_gib_prop_cleanup(self)
	-- function 24
	local unit = self.unit
	local get_data = Unit.get_data(unit, "gib_items")

	get_data = get_data or {}

	local get_data_2 = Unit.get_data(unit, "stump_items")

	get_data_2 = get_data_2 or {}

	local remove_gibs = self.remove_gibs

	if ScriptUnit ~= nil then
		if remove_gibs == true then
			for i = 1, #get_data do
				Managers.state.unit_spawner:mark_for_deletion(get_data[i])
			end

			Unit.set_data(unit, "gib_items", {})
		end

		for j = 1, #get_data_2 do
			Managers.state.unit_spawner:mark_for_deletion(get_data_2[j])
		end

		Unit.set_data(unit, "stump_items", {})
	end

	return {}
end

function flow_callback_enemy_pulp(arg_25_0)
	-- function 25
	if BloodSettings == nil or not BloodSettings.dismemberment.enabled then
		fn_17(arg_25_0, false)
	end

	return {}
end

function flow_callback_enemy_explode(arg_26_0)
	-- function 26
	if BloodSettings == nil or not BloodSettings.dismemberment.enabled then
		enemy_explode(arg_26_0)
	end

	return {}
end
