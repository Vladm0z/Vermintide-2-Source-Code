-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/liquid_area_damage_husk_extension.lua

LiquidAreaDamageHuskExtension = class(LiquidAreaDamageHuskExtension)

LiquidAreaDamageHuskExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self._unit = arg_1_2
	self._blobs = {}
	self._world = world
	self._source_attacker_unit = arg_1_3.source_unit
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()

	local liquid_template = arg_1_3.liquid_template
	local var_1_2 = LiquidAreaDamageTemplates.templates[liquid_template]

	self._fx_name_filled = var_1_2.fx_name_filled
	self._fx_name_rim = var_1_2.fx_name_rim
	self._liquid_area_damage_template = liquid_template

	Unit.set_unit_visibility(self._unit, false)

	local sfx_name_start = var_1_2.sfx_name_start

	self._sfx_name_start = sfx_name_start
	self._sfx_name_stop = var_1_2.sfx_name_stop

	if not sfx_name_start then
		WwiseUtils.trigger_unit_event(world, sfx_name_start, arg_1_2, 0)
	end

	local init_function = var_1_2.init_function

	if not init_function then
		local time = Managers.time:time("game")

		LiquidAreaDamageTemplates[init_function](self, time)
	end

	local update_function = var_1_2.update_function

	if not update_function then
		self._liquid_update_function = LiquidAreaDamageTemplates[update_function]
	end
end

LiquidAreaDamageHuskExtension._get_rotation_from_navmesh = function (self, arg_2_1)
	-- function 2
	local _nav_world = self._nav_world
	local triangle_from_position, var_2_2, var_2_3, var_2_4, var_2_5 = GwNavQueries.triangle_from_position(_nav_world, arg_2_1, 2, 2)
	local var_2_6

	if not triangle_from_position then
		local normalize = Vector3.normalize(var_2_4 - var_2_3)
		local normalize_2 = Vector3.normalize(var_2_5 - var_2_3)
		local normalize_3 = Vector3.normalize(Vector3.cross(normalize, normalize_2))

		var_2_6 = Quaternion.look(normalize, normalize_3)
	else
		var_2_6 = Quaternion.identity()
	end

	return var_2_6
end

LiquidAreaDamageHuskExtension.add_damage_blob = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local var_3_0
	local _fx_name_rim = self._fx_name_rim

	if script_data.debug_liquid_system or not _fx_name_rim then
		local _get_rotation_from_navmesh = self:_get_rotation_from_navmesh(arg_3_2)

		var_3_0 = World.create_particles(self._world, _fx_name_rim, arg_3_2, _get_rotation_from_navmesh)
	end

	self._blobs[arg_3_1] = {
		fx_id = var_3_0,
		position = Vector3Box(arg_3_2),
		full = arg_3_3
	}

	if not arg_3_3 then
		self:set_damage_blob_filled(arg_3_1)
	end
end

LiquidAreaDamageHuskExtension.set_damage_blob_filled = function (self, arg_4_1)
	-- function 4
	local var_4_0 = self._blobs[arg_4_1]
	local fx_id = var_4_0.fx_id
	local _world = self._world

	if not fx_id then
		World.stop_spawning_particles(_world, fx_id)
	end

	local _fx_name_filled = self._fx_name_filled

	if script_data.debug_liquid_system or not _fx_name_filled then
		local unbox = var_4_0.position:unbox()
		local _get_rotation_from_navmesh = self:_get_rotation_from_navmesh(unbox)

		var_4_0.fx_id = World.create_particles(_world, _fx_name_filled, unbox, _get_rotation_from_navmesh)
	else
		var_4_0.fx_id = nil
	end

	var_4_0.full = true
end

LiquidAreaDamageHuskExtension.remove_damage_blob = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

LiquidAreaDamageHuskExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	if not (not self._liquid_update_function and self._liquid_update_function(self, arg_6_5, arg_6_3)) then
		self._liquid_update_function = nil
	end
end

LiquidAreaDamageHuskExtension.destroy = function (self)
	-- function 7
	local _world = self._world
	local _sfx_name_stop = self._sfx_name_stop

	if not _sfx_name_stop then
		local _unit = self._unit

		WwiseUtils.trigger_unit_event(_world, _sfx_name_stop, _unit, 0)
	end

	for k, v in pairs(self._blobs) do
		local fx_id = v.fx_id

		if not fx_id then
			World.stop_spawning_particles(_world, fx_id)
		end
	end
end

LiquidAreaDamageHuskExtension.get_source_attacker_unit = function (self)
	-- function 8
	return self._source_attacker_unit
end
