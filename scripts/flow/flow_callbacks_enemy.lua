-- chunkname: @scripts/flow/flow_callbacks_enemy.lua

require("foundation/scripts/util/table")
require("scripts/settings/unit_variation_settings")
require("scripts/settings/unit_gib_settings")

local var_0_0 = 3
local var_0_1 = 2
local var_0_2 = 0.15

function flow_callback_enemy_dissolve_data(arg_1_0)
	return {
		dissovle_time = var_0_0,
		darken_time = var_0_1,
		darken_to = var_0_2
	}
end

function flow_callback_enemy_dissolve_darken_vector(arg_2_0)
	return {
		darken_vector = Vector3(1, var_0_2, var_0_1)
	}
end

local function var_0_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	for iter_3_0 = 1, #arg_3_1 do
		if Unit.has_mesh(arg_3_0, arg_3_1[iter_3_0]) then
			local var_3_0 = Unit.mesh(arg_3_0, arg_3_1[iter_3_0])
			local var_3_1 = Mesh.material(var_3_0, arg_3_2)

			Material.set_scalar(var_3_1, arg_3_3, arg_3_4)
		end
	end
end

local function var_0_4(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = math.random(arg_4_2.min, arg_4_2.max)

	if arg_4_2.scale ~= nil then
		var_4_0 = var_4_0 * arg_4_2.scale
	end

	local var_4_1 = arg_4_2.meshes

	if not var_4_1 then
		for iter_4_0 = 1, #arg_4_2.variables do
			Unit.set_scalar_for_material_table(arg_4_0, arg_4_2.materials, arg_4_2.variables[iter_4_0], var_4_0)

			if arg_4_1 ~= nil then
				for iter_4_1 = 1, #arg_4_1 do
					local var_4_2 = arg_4_1[iter_4_1]

					Unit.set_scalar_for_material_table(var_4_2, arg_4_2.materials, arg_4_2.variables[iter_4_0], var_4_0)
				end
			end
		end
	else
		for iter_4_2 = 1, #arg_4_2.materials do
			for iter_4_3 = 1, #arg_4_2.variables do
				var_0_3(arg_4_0, var_4_1, arg_4_2.materials[iter_4_2], arg_4_2.variables[iter_4_3], var_4_0)

				if arg_4_1 ~= nil then
					for iter_4_4 = 1, #arg_4_1 do
						local var_4_3 = arg_4_1[iter_4_4]

						var_0_3(var_4_3, var_4_1, arg_4_2.materials[iter_4_2], arg_4_2.variables[iter_4_3], var_4_0)
					end
				end
			end
		end
	end

	for iter_4_5 = 1, #arg_4_2.materials do
		for iter_4_6 = 1, #arg_4_2.variables do
			table.insert(arg_4_3, {
				material = arg_4_2.materials[iter_4_5],
				variable = arg_4_2.variables[iter_4_6],
				value = var_4_0,
				meshes = arg_4_2.meshes
			})
		end
	end

	return {}
end

local function var_0_5(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	for iter_5_0 = 1, #arg_5_3 do
		var_0_4(arg_5_0, arg_5_1, arg_5_2.material_variations[arg_5_3[iter_5_0]], arg_5_4)
	end
end

local function var_0_6(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	for iter_6_0 = 1, #arg_6_3 do
		local var_6_0 = arg_6_3[iter_6_0]
		local var_6_1 = arg_6_2.body_parts[var_6_0]
		local var_6_2 = var_6_1[math.random(#var_6_1)]

		if var_6_2.group then
			Unit.set_visibility(arg_6_0, var_6_2.group, true)
			table.insert(arg_6_4, var_6_2.group)

			if arg_6_2.material_variations ~= nil then
				local var_6_3 = arg_6_2.material_variations[var_6_2.group]

				if var_6_3 then
					var_0_4(arg_6_0, arg_6_1, var_6_3, arg_6_5)
				end
			end
		end

		if var_6_2.enables then
			var_0_6(arg_6_0, arg_6_1, arg_6_2, var_6_2.enables, arg_6_4, arg_6_5)
		end
	end
end

local function var_0_7(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0

	for iter_7_0, iter_7_1 in pairs(arg_7_2.scale_variation) do
		for iter_7_2 = 1, #iter_7_1 do
			if iter_7_1[iter_7_2] ~= nil then
				if Unit.has_node(arg_7_0, iter_7_1[iter_7_2]) then
					local var_7_1 = Unit.node(arg_7_0, iter_7_1[iter_7_2])

					Unit.set_local_scale(arg_7_0, var_7_1, Vector3(0, 0, 0))
				end

				if arg_7_1 ~= nil then
					for iter_7_3 = 1, #arg_7_1 do
						if Unit.has_node(arg_7_1[iter_7_3], iter_7_1[iter_7_2]) then
							local var_7_2 = Unit.node(arg_7_1[iter_7_3], iter_7_1[iter_7_2])

							Unit.set_local_scale(arg_7_1[iter_7_3], var_7_2, Vector3(0, 0, 0))
						end
					end
				end

				arg_7_3[iter_7_1[iter_7_2]] = 0
			end
		end

		local var_7_3 = iter_7_1[math.random(#iter_7_1)]

		if var_7_3 ~= nil then
			if Unit.has_node(arg_7_0, var_7_3) then
				local var_7_4 = Unit.node(arg_7_0, var_7_3)

				Unit.set_local_scale(arg_7_0, var_7_4, Vector3(1, 1, 1))
			end

			if arg_7_1 ~= nil then
				for iter_7_4 = 1, #arg_7_1 do
					if Unit.has_node(arg_7_1[iter_7_4], var_7_3) then
						local var_7_5 = Unit.node(arg_7_1[iter_7_4], var_7_3)

						Unit.set_local_scale(arg_7_1[iter_7_4], var_7_5, Vector3(1, 1, 1))
					end
				end
			end

			arg_7_3[var_7_3] = 1
		end
	end
end

function flow_callback_enemy_variation(arg_8_0)
	local var_8_0 = arg_8_0.unit
	local var_8_1 = arg_8_0.breed_type
	local var_8_2 = Unit.get_data(var_8_0, "breed")

	if var_8_2 ~= nil then
		var_8_1 = var_8_2.name
	end

	if var_8_1 == nil then
		return {}
	end

	if arg_8_0.baked then
		var_8_1 = var_8_1 .. "_baked"
	end

	if UnitVariationSettings[var_8_1] == nil then
		return {}
	end

	local var_8_3 = UnitVariationSettings[var_8_1]
	local var_8_4 = {}
	local var_8_5 = {}
	local var_8_6 = {}
	local var_8_7 = {}
	local var_8_8 = {}
	local var_8_9 = {}

	if ScriptUnit ~= nil then
		local var_8_10 = ScriptUnit.has_extension(var_8_0, "ai_inventory_system")

		if var_8_10 ~= nil then
			var_8_8 = var_8_10.inventory_item_outfit_units
			var_8_9 = var_8_10.inventory_item_helmet_units
		end
	else
		var_8_8 = Unit.get_data(var_8_0, "outfit_items") or {}
		var_8_9 = Unit.get_data(var_8_0, "helmet_items") or {}
	end

	if var_8_8 ~= nil then
		for iter_8_0 = 1, #var_8_8 do
			local var_8_11 = Unit.get_data(var_8_8[iter_8_0], "gib_variation")

			if var_8_11 ~= nil then
				table.insert(var_8_6, var_8_11)
			end
		end
	end

	if var_8_9 ~= nil then
		var_8_8 = table.shallow_copy(var_8_8)

		for iter_8_1 = 1, #var_8_9 do
			table.insert(var_8_8, var_8_9[iter_8_1])
		end
	end

	if var_8_3.materials_enabled_from_start ~= nil then
		var_0_5(var_8_0, var_8_8, var_8_3, var_8_3.materials_enabled_from_start, var_8_5)
	end

	if var_8_3.enabled_from_start ~= nil then
		if Unit.has_visibility_group(var_8_0, "all") then
			Unit.set_visibility(var_8_0, "all", false)
		end

		var_0_6(var_8_0, var_8_8, var_8_3, var_8_3.enabled_from_start, var_8_6, var_8_5)
	end

	if var_8_3.scale_variation ~= nil then
		var_0_7(var_8_0, var_8_8, var_8_3, var_8_7)
	end

	var_8_4.groups = var_8_6
	var_8_4.materials = var_8_5
	var_8_4.scaling = var_8_7

	Unit.set_data(var_8_0, "variation_data", var_8_4)
	Unit.set_data(var_8_0, "dismember_filter", {})

	return {}
end

local function var_0_8(arg_9_0, arg_9_1)
	local var_9_0 = Unit.get_data(arg_9_0, "dismember_filter") or {}

	if table.contains(var_9_0, arg_9_1) then
		return false
	end

	return true
end

local function var_0_9(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Unit.get_data(arg_10_0, "dismember_filter") or {}

	if not table.contains(var_10_0, arg_10_1) then
		table.insert(var_10_0, arg_10_1)
	end

	if arg_10_2.disable_gibs ~= nil then
		for iter_10_0 = 1, #arg_10_2.disable_gibs do
			if not table.contains(var_10_0, arg_10_2.disable_gibs[iter_10_0]) then
				table.insert(var_10_0, arg_10_2.disable_gibs[iter_10_0])
			end
		end
	end

	Unit.set_data(arg_10_0, "dismember_filter", var_10_0)
end

local function var_0_10(arg_11_0, arg_11_1)
	local var_11_0 = {}

	if arg_11_1 ~= nil then
		var_11_0 = arg_11_1.inventory_item_helmet_units
	else
		var_11_0 = Unit.get_data(arg_11_0, "helmet_items") or {}
	end

	return var_11_0
end

local function var_0_11(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_2.gib_helmet_link_node ~= nil then
		local var_12_0 = var_0_10(arg_12_0, arg_12_1)

		for iter_12_0 = 1, #var_12_0 do
			if Unit.has_animation_state_machine(var_12_0[iter_12_0]) then
				Unit.disable_animation_state_machine(var_12_0[iter_12_0])
			end
		end
	end
end

local function var_0_12(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0 = Unit.node(arg_13_1, arg_13_3.gib_parent_align_node)
	local var_13_1 = Matrix4x4.from_quaternion_position(Unit.world_rotation(arg_13_1, var_13_0), Unit.world_position(arg_13_1, var_13_0))

	if arg_13_3.gib_disable_auto_scale ~= true then
		local var_13_2 = Unit.local_scale(arg_13_1, 1)

		if arg_13_6 ~= nil then
			local var_13_3 = arg_13_6._size_variation or 1

			var_13_2 = Vector3(var_13_3, var_13_3, var_13_3)
		end

		Matrix4x4.set_scale(var_13_1, var_13_2)
	end

	local var_13_4

	if arg_13_0 ~= nil then
		if arg_13_3.gib_unit_template ~= nil then
			var_13_4 = arg_13_0:spawn_local_unit_with_extensions(arg_13_3.gib_unit, arg_13_3.gib_unit_template, nil, var_13_1)
		else
			var_13_4 = arg_13_0:spawn_local_unit(arg_13_3.gib_unit, var_13_1)
		end
	else
		var_13_4 = World.spawn_unit(arg_13_2, arg_13_3.gib_unit, var_13_1)
	end

	if arg_13_3.gib_helmet_link_node ~= nil then
		local var_13_5 = var_0_10(arg_13_1, arg_13_5)

		for iter_13_0 = 1, #var_13_5 do
			World.unlink_unit(arg_13_2, var_13_5[iter_13_0])
			World.link_unit(Unit.world(var_13_4), var_13_5[iter_13_0], var_13_4, Unit.node(var_13_4, arg_13_3.gib_helmet_link_node))
			Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(var_13_5[iter_13_0], "outline_unit", false)
		end
	end

	local var_13_6 = Unit.actor(var_13_4, arg_13_3.gib_push_actor)

	if not var_13_6 then
		-- Nothing
	else
		if Unit.has_node(var_13_4, "a_push") then
			var_13_0 = Unit.node(var_13_4, "a_push")
		else
			var_13_0 = Script.index_offset()
		end

		if arg_13_4 ~= 1 then
			Actor.add_velocity(var_13_6, Quaternion.rotate(Unit.world_rotation(var_13_4, var_13_0), Vector3(2 + math.random(-0.5, 0.5), math.random(-1, 1), math.random(-1, 1))) * (arg_13_3.gib_push_force * 0.75) * arg_13_4)
			Actor.add_angular_velocity(var_13_6, Vector3(math.random(0, 2), math.random(0, 2), math.random(0, 2)) * arg_13_4)
		else
			Actor.add_velocity(var_13_6, Quaternion.rotate(Unit.world_rotation(var_13_4, var_13_0), Vector3(2 + 0.5 * math.random(), math.random() - 0.5, math.random() - 0.5)) * arg_13_3.gib_push_force)
		end
	end

	return var_13_4
end

local function var_0_13(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = Unit.node(arg_14_1, arg_14_3.stump_parent_align_node)
	local var_14_1

	if arg_14_4 and arg_14_3.pulp_stump_unit then
		if type(arg_14_3.pulp_stump_unit) == "table" then
			var_14_1 = arg_14_3.pulp_stump_unit[Math.random(1, #arg_14_3.pulp_stump_unit)]
		else
			var_14_1 = arg_14_3.pulp_stump_unit
		end
	else
		var_14_1 = arg_14_3.stump_unit
	end

	local var_14_2

	if arg_14_0 ~= nil then
		var_14_2 = arg_14_0:spawn_local_unit(var_14_1, Unit.world_position(arg_14_1, var_14_0), Unit.world_rotation(arg_14_1, var_14_0))
	else
		var_14_2 = World.spawn_unit(arg_14_2, var_14_1, Unit.world_position(arg_14_1, var_14_0), Unit.world_rotation(arg_14_1, var_14_0))
	end

	local var_14_3 = arg_14_3.stump_link_nodes
	local var_14_4 = arg_14_3.parent_link_nodes

	World.link_unit(arg_14_2, var_14_2, Script.index_offset(), arg_14_1, Unit.node(arg_14_1, var_14_4[1]))

	for iter_14_0 = 1, #var_14_4 do
		local var_14_5 = Unit.node(arg_14_1, var_14_4[iter_14_0])
		local var_14_6 = Unit.node(var_14_2, var_14_3[iter_14_0])

		World.link_unit(arg_14_2, var_14_2, var_14_6, arg_14_1, var_14_5)
	end

	if Unit.has_lod_object(arg_14_1, "lod") and Unit.has_lod_object(var_14_2, "lod") then
		local var_14_7 = Unit.lod_object(arg_14_1, "lod")
		local var_14_8 = Unit.lod_object(var_14_2, "lod")

		LODObject.set_bounding_volume(var_14_8, LODObject.bounding_volume(var_14_7))
		World.link_unit(arg_14_2, var_14_2, LODObject.node(var_14_8), arg_14_1, LODObject.node(var_14_7))
	end

	return var_14_2
end

local function var_0_14(arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(arg_15_1.materials) do
		local var_15_0 = iter_15_1.meshes

		if not var_15_0 then
			Unit.set_scalar_for_material(arg_15_0, iter_15_1.material, iter_15_1.variable, iter_15_1.value)
		else
			var_0_3(arg_15_0, var_15_0, iter_15_1.material, iter_15_1.variable, iter_15_1.value)
		end
	end

	if Unit.has_visibility_group(arg_15_0, "all") then
		Unit.set_visibility(arg_15_0, "all", false)

		for iter_15_2 = 1, #arg_15_1.groups do
			if Unit.has_visibility_group(arg_15_0, arg_15_1.groups[iter_15_2]) then
				Unit.set_visibility(arg_15_0, arg_15_1.groups[iter_15_2], true)
			end
		end
	end

	for iter_15_3, iter_15_4 in pairs(arg_15_1.scaling) do
		if Unit.has_node(arg_15_0, iter_15_3) then
			local var_15_1 = Unit.node(arg_15_0, iter_15_3)

			Unit.set_local_scale(arg_15_0, var_15_1, Vector3(iter_15_4, iter_15_4, iter_15_4))
		end
	end
end

local function var_0_15(arg_16_0)
	local var_16_0 = Unit.num_meshes(arg_16_0)
	local var_16_1 = Script.index_offset()
	local var_16_2 = 1 - var_16_1

	for iter_16_0 = var_16_1, var_16_0 - var_16_2 do
		local var_16_3 = Unit.mesh(arg_16_0, iter_16_0)
		local var_16_4 = Mesh.num_materials(var_16_3)

		for iter_16_1 = var_16_1, var_16_4 - var_16_2 do
			local var_16_5 = Mesh.material(var_16_3, iter_16_1)

			Material.set_scalar(var_16_5, "snow", 1)
		end
	end
end

local function var_0_16(arg_17_0, arg_17_1)
	if Unit.has_visibility_group(arg_17_0, "all") then
		Unit.set_visibility(arg_17_0, "all", false)

		if Unit.has_visibility_group(arg_17_0, "var" .. arg_17_1) then
			Unit.set_visibility(arg_17_0, "var" .. arg_17_1, true)
		end
	end
end

local function var_0_17(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = Unit.get_data(arg_18_0, "variation_data")
	local var_18_1 = Unit.get_data(arg_18_0, "gib_variation")

	if var_18_0 == nil and var_18_1 == nil then
		return
	end

	if var_18_0 ~= nil then
		if arg_18_1 ~= nil then
			var_0_14(arg_18_1, var_18_0)
		end

		if arg_18_2 ~= nil then
			var_0_14(arg_18_2, var_18_0)
		end
	end

	if var_18_1 ~= nil then
		if arg_18_1 ~= nil then
			var_0_16(arg_18_1, var_18_1)
		end

		if arg_18_2 ~= nil then
			var_0_16(arg_18_2, var_18_1)
		end
	end
end

local function var_0_18(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_2 ~= nil then
		local var_19_0 = arg_19_2.disabled_actors

		for iter_19_0 = 1, #arg_19_1 do
			local var_19_1 = Unit.actor(arg_19_0, arg_19_1[iter_19_0])

			if var_19_1 then
				Actor.set_scene_query_enabled(var_19_1, false)
				Actor.set_collision_filter(var_19_1, "filter_ragdoll_secondary")

				if var_19_0 ~= nil then
					table.insert(var_19_0, arg_19_1[iter_19_0])
				end
			end
		end

		arg_19_2.disabled_actors = var_19_0
	else
		for iter_19_1 = 1, #arg_19_1 do
			if Unit.actor(arg_19_0, arg_19_1[iter_19_1]) ~= nil then
				Unit.destroy_actor(arg_19_0, arg_19_1[iter_19_1])
			end
		end
	end
end

local function var_0_19(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.unit
	local var_20_1 = arg_20_0.breed_type
	local var_20_2 = Unit.get_data(var_20_0, "breed")

	if var_20_2 ~= nil then
		var_20_1 = var_20_2.name
	end

	if var_20_1 == nil then
		return
	end

	if arg_20_0.baked then
		var_20_1 = var_20_1 .. "_baked"
	end

	if UnitGibSettings[var_20_1] == nil then
		return
	end

	local var_20_3 = arg_20_0.bodypart

	if UnitGibSettings[var_20_1].parts[var_20_3] == nil then
		return
	end

	local var_20_4 = UnitGibSettings[var_20_1].parts[var_20_3]

	if not var_0_8(var_20_0, var_20_3) then
		return
	end

	local var_20_5 = Unit.world(var_20_0)
	local var_20_6
	local var_20_7
	local var_20_8
	local var_20_9

	if ScriptUnit ~= nil then
		var_20_7 = ScriptUnit.has_extension(var_20_0, "ai_inventory_system")
		var_20_8 = ScriptUnit.has_extension(var_20_0, "ai_system")
		var_20_9 = Managers.state.unit_spawner

		if ScriptUnit.has_extension(var_20_0, "projectile_linker_system") then
			Managers.state.entity:system("projectile_linker_system"):clear_linked_projectiles(var_20_0)
		end
	end

	local var_20_10

	if arg_20_1 then
		var_20_10 = var_0_12(var_20_9, var_20_0, var_20_5, var_20_4, 1, var_20_7, var_20_8)
	else
		var_0_11(var_20_0, var_20_7, var_20_4)
	end

	var_0_18(var_20_0, var_20_4.parent_destroy_actors, var_20_7)
	var_0_18(var_20_0, var_20_4.ragdoll_destroy_actors, nil)

	local var_20_11 = var_0_13(var_20_9, var_20_0, var_20_5, var_20_4, not arg_20_1)

	var_0_17(var_20_0, var_20_10, var_20_11)

	if Unit.get_data(var_20_0, "was_burned") then
		Unit.flow_event(var_20_11, "lua_already_burned")

		if var_20_10 ~= nil then
			Unit.flow_event(var_20_10, "lua_already_burned")
		end
	end

	if Unit.get_data(var_20_0, "snow_state") then
		var_0_15(var_20_11)

		if var_20_10 ~= nil then
			var_0_15(var_20_10)
		end
	end

	local var_20_12

	if var_20_7 ~= nil then
		var_20_12 = var_20_7.gibbed_nodes or {}
	end

	for iter_20_0 = 1, #var_20_4.parent_scale_nodes do
		local var_20_13 = Unit.node(var_20_0, var_20_4.parent_scale_nodes[iter_20_0])

		Unit.set_local_scale(var_20_0, var_20_13, Vector3(var_20_4.parent_scale, var_20_4.parent_scale, var_20_4.parent_scale))

		if var_20_12 ~= nil then
			var_20_12[#var_20_12 + 1] = var_20_13
		end
	end

	if var_20_7 ~= nil then
		var_20_7.gibbed_nodes = var_20_12
	end

	if var_20_4.parent_hide_group ~= nil and Unit.has_visibility_group(var_20_0, var_20_4.parent_hide_group) then
		Unit.set_visibility(var_20_0, var_20_4.parent_hide_group, false)
	end

	if var_20_4.send_outfit_event ~= nil then
		if var_20_7 ~= nil then
			for iter_20_1 = 1, #var_20_7.inventory_item_outfit_units do
				Unit.flow_event(var_20_7.inventory_item_outfit_units[iter_20_1], var_20_4.send_outfit_event)
			end
		else
			local var_20_14 = Unit.get_data(var_20_0, "outfit_items") or {}

			for iter_20_2 = 1, #var_20_14 do
				Unit.flow_event(var_20_14[iter_20_2], var_20_4.send_outfit_event)
			end
		end
	end

	if BloodSettings == nil or BloodSettings.enemy_blood.enabled then
		local var_20_15 = Unit.node(var_20_11, "a_vfx")

		if var_20_4.vfx ~= nil then
			local var_20_16 = World.create_particles(var_20_5, var_20_4.vfx, Unit.world_position(var_20_11, var_20_15), Unit.world_rotation(var_20_11, var_20_15))

			World.link_particles(var_20_5, var_20_16, var_20_11, var_20_15, Matrix4x4.identity(), "destroy")
		end

		if var_20_10 == nil and var_20_4.pulp_vfx ~= nil then
			local var_20_17 = World.create_particles(var_20_5, var_20_4.pulp_vfx, Unit.world_position(var_20_11, var_20_15), Unit.world_rotation(var_20_11, var_20_15))

			World.link_particles(var_20_5, var_20_17, var_20_11, var_20_15, Matrix4x4.identity(), "destroy")
		end
	end

	if not arg_20_1 and var_20_3 == "head" then
		local var_20_18 = Wwise.wwise_world(var_20_5)
		local var_20_19 = Unit.node(var_20_11, "a_vfx")

		WwiseWorld.trigger_event(var_20_18, "Play_combat_enemy_head_crush", var_20_11, var_20_19)
	end

	if ScriptUnit ~= nil and var_20_4.stop_death_sound then
		local var_20_20 = ScriptUnit.has_extension(var_20_0, "hit_reaction_system")

		if var_20_20 then
			local var_20_21 = Wwise.wwise_world(var_20_5)
			local var_20_22 = var_20_20:death_sound_event_id()

			if var_20_22 then
				WwiseWorld.stop_event(var_20_21, var_20_22)
			end
		end
	end

	if var_20_7 ~= nil then
		if var_20_10 ~= nil then
			local var_20_23 = var_20_7.gib_items

			table.insert(var_20_23, var_20_10)

			var_20_7.gib_items = var_20_23
		end

		local var_20_24 = var_20_7.stump_items

		table.insert(var_20_24, var_20_11)

		var_20_7.stump_items = var_20_24
	else
		if var_20_10 ~= nil then
			local var_20_25 = Unit.get_data(var_20_0, "gib_items") or {}

			table.insert(var_20_25, var_20_10)
			Unit.set_data(var_20_0, "gib_items", var_20_25)
		end

		local var_20_26 = Unit.get_data(var_20_0, "stump_items") or {}

		table.insert(var_20_26, var_20_11)
		Unit.set_data(var_20_0, "stump_items", var_20_26)
	end

	var_0_9(var_20_0, var_20_3, var_20_4)
end

function enemy_explode(arg_21_0)
	local var_21_0 = arg_21_0.unit
	local var_21_1 = arg_21_0.breed_type
	local var_21_2 = Unit.get_data(var_21_0, "breed")

	if var_21_2 ~= nil then
		var_21_1 = var_21_2.name
	end

	if var_21_1 == nil then
		return
	end

	if arg_21_0.baked then
		var_21_1 = var_21_1 .. "_baked"
	end

	if UnitGibSettings[var_21_1] == nil then
		return
	end

	if UnitGibSettings[var_21_1].explode == nil then
		return
	end

	local var_21_3 = UnitGibSettings[var_21_1].explode

	if var_21_3.part_combos == nil then
		return
	end

	local var_21_4 = Unit.world(var_21_0)
	local var_21_5
	local var_21_6

	if ScriptUnit ~= nil then
		var_21_5 = ScriptUnit.has_extension(var_21_0, "ai_inventory_system")
		var_21_6 = Managers.state.unit_spawner
	end

	if var_21_5 ~= nil then
		if #var_21_5.stump_items ~= 0 then
			return
		end
	elseif Unit.get_data(var_21_0, "stump_items") ~= nil then
		return
	end

	if Unit.get_data(var_21_0, "exploded") then
		return
	end

	local var_21_7

	if Unit.get_data(var_21_0, "was_burned") then
		var_21_7 = true
	end

	local var_21_8 = var_21_3.part_combos[math.random(#var_21_3.part_combos)]
	local var_21_9 = false
	local var_21_10 = 1

	if type(var_21_3.push_force_multiplier) == "number" then
		var_21_10 = var_21_3.push_force_multiplier
	end

	for iter_21_0 = 1, #var_21_8 do
		if UnitGibSettings[var_21_1].parts[var_21_8[iter_21_0]] == nil then
			-- Nothing
		else
			local var_21_11 = UnitGibSettings[var_21_1].parts[var_21_8[iter_21_0]]
			local var_21_12 = var_0_12(var_21_6, var_21_0, var_21_4, var_21_11, var_21_10, var_21_5)

			var_0_17(var_21_0, var_21_12, nil)

			if var_21_7 then
				Unit.flow_event(var_21_12, "lua_already_burned")
			end

			Unit.flow_event(var_21_12, "lua_start_despawn_timer")

			if var_21_11.gib_helmet_link_node ~= nil then
				var_21_9 = true
			end
		end
	end

	if (BloodSettings == nil or BloodSettings.enemy_blood.enabled) and var_21_3.vfx_align_node ~= nil then
		local var_21_13 = Unit.node(var_21_0, var_21_3.vfx_align_node)

		if var_21_3.vfx ~= nil then
			local var_21_14 = World.create_particles(var_21_4, var_21_3.vfx, Unit.world_position(var_21_0, var_21_13), Unit.world_rotation(var_21_0, var_21_13))

			World.link_particles(var_21_4, var_21_14, var_21_0, var_21_13, Matrix4x4.identity(), "destroy")
		end
	end

	local var_21_15 = {}

	if var_21_5 ~= nil then
		var_21_15 = var_21_5.inventory_item_outfit_units or {}
	else
		var_21_15 = Unit.get_data(var_21_0, "outfit_items") or {}
	end

	for iter_21_1 = 1, #var_21_15 do
		Unit.set_unit_visibility(var_21_15[iter_21_1], false)
	end

	local var_21_16 = UnitGibSettings[var_21_1].parts

	for iter_21_2 = 1, #var_21_8 do
		local var_21_17 = var_21_16[var_21_8[iter_21_2]]

		if var_21_17 and var_21_17.send_outfit_event ~= nil then
			for iter_21_3 = 1, #var_21_15 do
				Unit.flow_event(var_21_15[iter_21_3], var_21_17.send_outfit_event)
			end
		end
	end

	local var_21_18 = var_0_10(var_21_0, var_21_5)

	for iter_21_4 = 1, #var_21_18 do
		if var_21_9 == false then
			Unit.set_unit_visibility(var_21_18[iter_21_4], false)
		else
			if var_21_5 == nil then
				Unit.set_data(var_21_0, "helmet_items", {})
			end

			Unit.flow_event(var_21_18[iter_21_4], "lua_start_despawn_timer")
		end
	end

	Unit.set_unit_visibility(var_21_0, false)
	Unit.disable_physics(var_21_0)
	Unit.set_data(var_21_0, "exploded", true)
end

function flow_callback_enemy_gib(arg_22_0)
	if BloodSettings == nil or BloodSettings.dismemberment.enabled then
		var_0_19(arg_22_0, true)
	end

	return {}
end

function flow_callback_enemy_set_base_variation(arg_23_0)
	local var_23_0 = arg_23_0.unit
	local var_23_1 = {
		groups = {},
		materials = {},
		scaling = {}
	}

	Unit.set_data(var_23_0, "variation_data", var_23_1)
end

function flow_callback_enemy_gib_prop_cleanup(arg_24_0)
	local var_24_0 = arg_24_0.unit
	local var_24_1 = Unit.get_data(var_24_0, "gib_items") or {}
	local var_24_2 = Unit.get_data(var_24_0, "stump_items") or {}
	local var_24_3 = arg_24_0.remove_gibs

	if ScriptUnit ~= nil then
		if var_24_3 == true then
			for iter_24_0 = 1, #var_24_1 do
				Managers.state.unit_spawner:mark_for_deletion(var_24_1[iter_24_0])
			end

			Unit.set_data(var_24_0, "gib_items", {})
		end

		for iter_24_1 = 1, #var_24_2 do
			Managers.state.unit_spawner:mark_for_deletion(var_24_2[iter_24_1])
		end

		Unit.set_data(var_24_0, "stump_items", {})
	end

	return {}
end

function flow_callback_enemy_pulp(arg_25_0)
	if BloodSettings == nil or BloodSettings.dismemberment.enabled then
		var_0_19(arg_25_0, false)
	end

	return {}
end

function flow_callback_enemy_explode(arg_26_0)
	if BloodSettings == nil or BloodSettings.dismemberment.enabled then
		enemy_explode(arg_26_0)
	end

	return {}
end
