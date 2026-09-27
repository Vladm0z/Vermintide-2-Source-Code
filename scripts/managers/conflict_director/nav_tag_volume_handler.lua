-- chunkname: @scripts/managers/conflict_director/nav_tag_volume_handler.lua

NavTagVolumeHandler = class(NavTagVolumeHandler)

NavTagVolumeHandler.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.world = arg_1_1
	self.nav_world = arg_1_2
	self.mappings_available = false
	self.created_tag_volumes = {}
	self.level_volumes_by_layer = {}
	self.mapping_lookup_table = {}
	self._runtime_volume_index = 1
	self._volume_lookup_id = 1
	self.mappings = {}

	local level_name = LevelHelper:current_level_settings(arg_1_1).level_name

	if LevelResource.nested_level_count(level_name) > 0 then
		level_name = LevelResource.nested_level_resource_name(level_name, 0)
	end

	if not IS_CONSOLE then
		GwNavWorld.set_dynamicnavmesh_budget(self.nav_world, 5)
	end

	local str = level_name .. "_nav_tag_volumes"

	if not Application.can_get("lua", str) then
		local var_1_2 = require(str)

		self.mappings = table.clone(var_1_2.nav_tag_volumes)
		self.mappings_available = true

		for k, v in pairs(self.mappings) do
			self.mapping_lookup_table[self._volume_lookup_id] = k
			self.mapping_lookup_table[k] = self._volume_lookup_id
			self._volume_lookup_id = self._volume_lookup_id + 1

			if v.layer_name ~= "undefined" then
				self:create_tag_volume_from_mappings(k)
			end
		end
	end

	if not IS_CONSOLE then
		GwNavWorld.update(self.nav_world, 0)
		GwNavWorld.set_dynamicnavmesh_budget(self.nav_world, 0.0045)
	end
end

NavTagVolumeHandler.create_tag_volume_from_mappings = function (self, arg_2_1)
	-- function 2
	if not self.created_tag_volumes[arg_2_1] then
		return
	end

	local temp_count, var_2_1, var_2_2 = Script.temp_count()

	fassert(self.mappings_available, "[NavTagVolumeHandler] Current level requires world_nav_tag_volumes.lua to be located in the level directory. Run SpawnGenerator in the level editor to export it!")

	local var_2_3 = self.mappings[arg_2_1]

	fassert(var_2_3, "[NavTagVolumeHandler] Level volume %q could not be found in world_nav_tag_volumes.lua. Run SpawnGenerator in the level editor to export it!", arg_2_1)

	local bottom_points = var_2_3.bottom_points
	local tbl = {}

	for i = 1, #bottom_points do
		local var_2_6 = bottom_points[i]

		tbl[i] = Vector3(var_2_6[1], var_2_6[2], var_2_6[3])
	end

	local var_2_7 = Color(var_2_3.color[1], var_2_3.color[2], var_2_3.color[3], var_2_3.color[4])
	local var_2_8 = LAYER_ID_MAPPING[var_2_3.layer_name]
	local var_2_9 = GwNavTagVolume.create(self.nav_world, tbl, var_2_3.alt_min, var_2_3.alt_max, false, var_2_7, var_2_8, -1, self.mapping_lookup_table[arg_2_1])

	GwNavTagVolume.add_to_world(var_2_9)

	self.created_tag_volumes[arg_2_1] = var_2_9

	local var_2_10 = self.level_volumes_by_layer[var_2_3.layer_name]

	var_2_10 = var_2_10 or {}
	var_2_10[#var_2_10 + 1] = arg_2_1
	self.level_volumes_by_layer[var_2_3.layer_name] = var_2_10

	Script.set_temp_count(temp_count, var_2_1, var_2_2)
end

NavTagVolumeHandler.create_mapping = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local str = "runtime_volume_" .. self._runtime_volume_index

	fassert(not self.mappings[str], "[NavTagVolumeHandler] There is already a nav tag volume called %s registered", str)

	local tbl = {}
	local num = arg_3_1 + Vector3(-arg_3_2, 0, 0)
	local num_2 = arg_3_1 + Vector3.normalize(Vector3(-arg_3_2, -arg_3_2, 0)) * arg_3_2
	local num_3 = arg_3_1 + Vector3(0, -arg_3_2, 0)
	local num_4 = arg_3_1 + Vector3.normalize(Vector3(arg_3_2, -arg_3_2, 0)) * arg_3_2
	local num_5 = arg_3_1 + Vector3(arg_3_2, 0, 0)
	local num_6 = arg_3_1 + Vector3.normalize(Vector3(arg_3_2, arg_3_2, 0)) * arg_3_2
	local num_7 = arg_3_1 + Vector3(0, arg_3_2, 0)
	local num_8 = arg_3_1 + Vector3.normalize(Vector3(-arg_3_2, arg_3_2, 0)) * arg_3_2

	tbl.bottom_points = {
		{
			num[1],
			num[2],
			num[3]
		},
		{
			num_2[1],
			num_2[2],
			num_2[3]
		},
		{
			num_3[1],
			num_3[2],
			num_3[3]
		},
		{
			num_4[1],
			num_4[2],
			num_4[3]
		},
		{
			num_5[1],
			num_5[2],
			num_5[3]
		},
		{
			num_6[1],
			num_6[2],
			num_6[3]
		},
		{
			num_7[1],
			num_7[2],
			num_7[3]
		},
		{
			num_8[1],
			num_8[2],
			num_8[3]
		}
	}
	tbl.color = {
		255,
		255,
		255,
		255
	}
	tbl.layer_name = arg_3_3
	tbl.alt_min = arg_3_1[3] - arg_3_2
	tbl.alt_max = arg_3_1[3] + arg_3_2
	self.mappings[str] = tbl
	self.mapping_lookup_table[self._volume_lookup_id] = str
	self.mapping_lookup_table[str] = self._volume_lookup_id
	self._runtime_volume_index = self._runtime_volume_index + 1
	self._volume_lookup_id = self._volume_lookup_id + 1

	return str
end

NavTagVolumeHandler.get_mapping_from_lookup_id = function (self, arg_4_1)
	-- function 4
	local var_4_0 = self.mapping_lookup_table[arg_4_1]

	return not var_4_0 and self.mappings[var_4_0]
end

NavTagVolumeHandler.destroy_nav_tag_volume = function (self, arg_5_1)
	-- function 5
	fassert(self.mappings[arg_5_1], "[NavTagVolumeHandler] There is not nav tag volume MAPPING with that name (%s)", arg_5_1)
	fassert(self.created_tag_volumes[arg_5_1], "[NavTagVolumeHandler] There is not NAV TAG VOLUME with that name (%s)", arg_5_1)

	local var_5_0 = self.mapping_lookup_table[arg_5_1]
	local var_5_1 = self.created_tag_volumes[arg_5_1]

	GwNavTagVolume.destroy(var_5_1)

	self.mappings[arg_5_1] = nil
	self.created_tag_volumes[arg_5_1] = nil
	self.mapping_lookup_table[arg_5_1] = nil
	self.mapping_lookup_table[var_5_0] = nil
end

NavTagVolumeHandler.set_mapping_layer_name = function (self, arg_6_1, arg_6_2)
	-- function 6
	fassert(self.mappings_available, "[NavTagVolumeHandler] Current level requires world_nav_tag_volumes.lua to be located in the level directory. Run SpawnGenerator in the level editor to export it!")

	local var_6_0 = self.mappings[arg_6_1]

	fassert(var_6_0, "[NavTagVolumeHandler] Level volume %q could not be found in world_nav_tag_volumes.lua. Run SpawnGenerator in the level editor to export it!", arg_6_1)

	var_6_0.layer_name = arg_6_2
end

NavTagVolumeHandler.destroy = function (self)
	-- function 7
	for k, v in pairs(self.created_tag_volumes) do
		GwNavTagVolume.destroy(v)
	end

	self.created_tag_volumes = nil
	self.level_volumes_by_layer = nil
end
