-- chunkname: @scripts/managers/conflict_director/nav_tag_volume_handler.lua

NavTagVolumeHandler = class(NavTagVolumeHandler)

NavTagVolumeHandler.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.world = arg_1_1
	arg_1_0.nav_world = arg_1_2
	arg_1_0.mappings_available = false
	arg_1_0.created_tag_volumes = {}
	arg_1_0.level_volumes_by_layer = {}
	arg_1_0.mapping_lookup_table = {}
	arg_1_0._runtime_volume_index = 1
	arg_1_0._volume_lookup_id = 1
	arg_1_0.mappings = {}

	local var_1_0 = LevelHelper:current_level_settings(arg_1_1).level_name

	if LevelResource.nested_level_count(var_1_0) > 0 then
		var_1_0 = LevelResource.nested_level_resource_name(var_1_0, 0)
	end

	if IS_CONSOLE then
		GwNavWorld.set_dynamicnavmesh_budget(arg_1_0.nav_world, 5)
	end

	local var_1_1 = var_1_0 .. "_nav_tag_volumes"

	if Application.can_get("lua", var_1_1) then
		local var_1_2 = require(var_1_1)

		arg_1_0.mappings = table.clone(var_1_2.nav_tag_volumes)
		arg_1_0.mappings_available = true

		for iter_1_0, iter_1_1 in pairs(arg_1_0.mappings) do
			arg_1_0.mapping_lookup_table[arg_1_0._volume_lookup_id] = iter_1_0
			arg_1_0.mapping_lookup_table[iter_1_0] = arg_1_0._volume_lookup_id
			arg_1_0._volume_lookup_id = arg_1_0._volume_lookup_id + 1

			if iter_1_1.layer_name ~= "undefined" then
				arg_1_0:create_tag_volume_from_mappings(iter_1_0)
			end
		end
	end

	if IS_CONSOLE then
		GwNavWorld.update(arg_1_0.nav_world, 0)
		GwNavWorld.set_dynamicnavmesh_budget(arg_1_0.nav_world, 0.0045)
	end
end

NavTagVolumeHandler.create_tag_volume_from_mappings = function (arg_2_0, arg_2_1)
	if arg_2_0.created_tag_volumes[arg_2_1] then
		return
	end

	local var_2_0, var_2_1, var_2_2 = Script.temp_count()

	fassert(arg_2_0.mappings_available, "[NavTagVolumeHandler] Current level requires world_nav_tag_volumes.lua to be located in the level directory. Run SpawnGenerator in the level editor to export it!")

	local var_2_3 = arg_2_0.mappings[arg_2_1]

	fassert(var_2_3, "[NavTagVolumeHandler] Level volume %q could not be found in world_nav_tag_volumes.lua. Run SpawnGenerator in the level editor to export it!", arg_2_1)

	local var_2_4 = var_2_3.bottom_points
	local var_2_5 = {}

	for iter_2_0 = 1, #var_2_4 do
		local var_2_6 = var_2_4[iter_2_0]

		var_2_5[iter_2_0] = Vector3(var_2_6[1], var_2_6[2], var_2_6[3])
	end

	local var_2_7 = Color(var_2_3.color[1], var_2_3.color[2], var_2_3.color[3], var_2_3.color[4])
	local var_2_8 = LAYER_ID_MAPPING[var_2_3.layer_name]
	local var_2_9 = GwNavTagVolume.create(arg_2_0.nav_world, var_2_5, var_2_3.alt_min, var_2_3.alt_max, false, var_2_7, var_2_8, -1, arg_2_0.mapping_lookup_table[arg_2_1])

	GwNavTagVolume.add_to_world(var_2_9)

	arg_2_0.created_tag_volumes[arg_2_1] = var_2_9

	local var_2_10 = arg_2_0.level_volumes_by_layer[var_2_3.layer_name] or {}

	var_2_10[#var_2_10 + 1] = arg_2_1
	arg_2_0.level_volumes_by_layer[var_2_3.layer_name] = var_2_10

	Script.set_temp_count(var_2_0, var_2_1, var_2_2)
end

NavTagVolumeHandler.create_mapping = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = "runtime_volume_" .. arg_3_0._runtime_volume_index

	fassert(not arg_3_0.mappings[var_3_0], "[NavTagVolumeHandler] There is already a nav tag volume called %s registered", var_3_0)

	local var_3_1 = {}
	local var_3_2 = arg_3_1 + Vector3(-arg_3_2, 0, 0)
	local var_3_3 = arg_3_1 + Vector3.normalize(Vector3(-arg_3_2, -arg_3_2, 0)) * arg_3_2
	local var_3_4 = arg_3_1 + Vector3(0, -arg_3_2, 0)
	local var_3_5 = arg_3_1 + Vector3.normalize(Vector3(arg_3_2, -arg_3_2, 0)) * arg_3_2
	local var_3_6 = arg_3_1 + Vector3(arg_3_2, 0, 0)
	local var_3_7 = arg_3_1 + Vector3.normalize(Vector3(arg_3_2, arg_3_2, 0)) * arg_3_2
	local var_3_8 = arg_3_1 + Vector3(0, arg_3_2, 0)
	local var_3_9 = arg_3_1 + Vector3.normalize(Vector3(-arg_3_2, arg_3_2, 0)) * arg_3_2

	var_3_1.bottom_points = {
		{
			var_3_2[1],
			var_3_2[2],
			var_3_2[3]
		},
		{
			var_3_3[1],
			var_3_3[2],
			var_3_3[3]
		},
		{
			var_3_4[1],
			var_3_4[2],
			var_3_4[3]
		},
		{
			var_3_5[1],
			var_3_5[2],
			var_3_5[3]
		},
		{
			var_3_6[1],
			var_3_6[2],
			var_3_6[3]
		},
		{
			var_3_7[1],
			var_3_7[2],
			var_3_7[3]
		},
		{
			var_3_8[1],
			var_3_8[2],
			var_3_8[3]
		},
		{
			var_3_9[1],
			var_3_9[2],
			var_3_9[3]
		}
	}
	var_3_1.color = {
		255,
		255,
		255,
		255
	}
	var_3_1.layer_name = arg_3_3
	var_3_1.alt_min = arg_3_1[3] - arg_3_2
	var_3_1.alt_max = arg_3_1[3] + arg_3_2
	arg_3_0.mappings[var_3_0] = var_3_1
	arg_3_0.mapping_lookup_table[arg_3_0._volume_lookup_id] = var_3_0
	arg_3_0.mapping_lookup_table[var_3_0] = arg_3_0._volume_lookup_id
	arg_3_0._runtime_volume_index = arg_3_0._runtime_volume_index + 1
	arg_3_0._volume_lookup_id = arg_3_0._volume_lookup_id + 1

	return var_3_0
end

NavTagVolumeHandler.get_mapping_from_lookup_id = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.mapping_lookup_table[arg_4_1]

	return var_4_0 and arg_4_0.mappings[var_4_0]
end

NavTagVolumeHandler.destroy_nav_tag_volume = function (arg_5_0, arg_5_1)
	fassert(arg_5_0.mappings[arg_5_1], "[NavTagVolumeHandler] There is not nav tag volume MAPPING with that name (%s)", arg_5_1)
	fassert(arg_5_0.created_tag_volumes[arg_5_1], "[NavTagVolumeHandler] There is not NAV TAG VOLUME with that name (%s)", arg_5_1)

	local var_5_0 = arg_5_0.mapping_lookup_table[arg_5_1]
	local var_5_1 = arg_5_0.created_tag_volumes[arg_5_1]

	GwNavTagVolume.destroy(var_5_1)

	arg_5_0.mappings[arg_5_1] = nil
	arg_5_0.created_tag_volumes[arg_5_1] = nil
	arg_5_0.mapping_lookup_table[arg_5_1] = nil
	arg_5_0.mapping_lookup_table[var_5_0] = nil
end

NavTagVolumeHandler.set_mapping_layer_name = function (arg_6_0, arg_6_1, arg_6_2)
	fassert(arg_6_0.mappings_available, "[NavTagVolumeHandler] Current level requires world_nav_tag_volumes.lua to be located in the level directory. Run SpawnGenerator in the level editor to export it!")

	local var_6_0 = arg_6_0.mappings[arg_6_1]

	fassert(var_6_0, "[NavTagVolumeHandler] Level volume %q could not be found in world_nav_tag_volumes.lua. Run SpawnGenerator in the level editor to export it!", arg_6_1)

	var_6_0.layer_name = arg_6_2
end

NavTagVolumeHandler.destroy = function (arg_7_0)
	for iter_7_0, iter_7_1 in pairs(arg_7_0.created_tag_volumes) do
		GwNavTagVolume.destroy(iter_7_1)
	end

	arg_7_0.created_tag_volumes = nil
	arg_7_0.level_volumes_by_layer = nil
end
