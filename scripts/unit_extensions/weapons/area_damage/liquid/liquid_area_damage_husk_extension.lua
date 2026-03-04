-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/liquid_area_damage_husk_extension.lua

LiquidAreaDamageHuskExtension = class(LiquidAreaDamageHuskExtension)

LiquidAreaDamageHuskExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0._unit = arg_1_2
	arg_1_0._blobs = {}
	arg_1_0._world = var_1_0
	arg_1_0._source_attacker_unit = arg_1_3.source_unit
	arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()

	local var_1_1 = arg_1_3.liquid_template
	local var_1_2 = LiquidAreaDamageTemplates.templates[var_1_1]

	arg_1_0._fx_name_filled = var_1_2.fx_name_filled
	arg_1_0._fx_name_rim = var_1_2.fx_name_rim
	arg_1_0._liquid_area_damage_template = var_1_1

	Unit.set_unit_visibility(arg_1_0._unit, false)

	local var_1_3 = var_1_2.sfx_name_start

	arg_1_0._sfx_name_start = var_1_3
	arg_1_0._sfx_name_stop = var_1_2.sfx_name_stop

	if var_1_3 then
		WwiseUtils.trigger_unit_event(var_1_0, var_1_3, arg_1_2, 0)
	end

	local var_1_4 = var_1_2.init_function

	if var_1_4 then
		local var_1_5 = Managers.time:time("game")

		LiquidAreaDamageTemplates[var_1_4](arg_1_0, var_1_5)
	end

	local var_1_6 = var_1_2.update_function

	if var_1_6 then
		arg_1_0._liquid_update_function = LiquidAreaDamageTemplates[var_1_6]
	end
end

LiquidAreaDamageHuskExtension._get_rotation_from_navmesh = function (arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0._nav_world
	local var_2_1, var_2_2, var_2_3, var_2_4, var_2_5 = GwNavQueries.triangle_from_position(var_2_0, arg_2_1, 2, 2)
	local var_2_6

	if var_2_1 then
		local var_2_7 = Vector3.normalize(var_2_4 - var_2_3)
		local var_2_8 = Vector3.normalize(var_2_5 - var_2_3)
		local var_2_9 = Vector3.normalize(Vector3.cross(var_2_7, var_2_8))

		var_2_6 = Quaternion.look(var_2_7, var_2_9)
	else
		var_2_6 = Quaternion.identity()
	end

	return var_2_6
end

LiquidAreaDamageHuskExtension.add_damage_blob = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0
	local var_3_1 = arg_3_0._fx_name_rim

	if not script_data.debug_liquid_system and var_3_1 then
		local var_3_2 = arg_3_0:_get_rotation_from_navmesh(arg_3_2)

		var_3_0 = World.create_particles(arg_3_0._world, var_3_1, arg_3_2, var_3_2)
	end

	arg_3_0._blobs[arg_3_1] = {
		fx_id = var_3_0,
		position = Vector3Box(arg_3_2),
		full = arg_3_3
	}

	if arg_3_3 then
		arg_3_0:set_damage_blob_filled(arg_3_1)
	end
end

LiquidAreaDamageHuskExtension.set_damage_blob_filled = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._blobs[arg_4_1]
	local var_4_1 = var_4_0.fx_id
	local var_4_2 = arg_4_0._world

	if var_4_1 then
		World.stop_spawning_particles(var_4_2, var_4_1)
	end

	local var_4_3 = arg_4_0._fx_name_filled

	if not script_data.debug_liquid_system and var_4_3 then
		local var_4_4 = var_4_0.position:unbox()
		local var_4_5 = arg_4_0:_get_rotation_from_navmesh(var_4_4)

		var_4_0.fx_id = World.create_particles(var_4_2, var_4_3, var_4_4, var_4_5)
	else
		var_4_0.fx_id = nil
	end

	var_4_0.full = true
end

LiquidAreaDamageHuskExtension.remove_damage_blob = function (arg_5_0, arg_5_1)
	return
end

LiquidAreaDamageHuskExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if arg_6_0._liquid_update_function and not arg_6_0._liquid_update_function(arg_6_0, arg_6_5, arg_6_3) then
		arg_6_0._liquid_update_function = nil
	end
end

LiquidAreaDamageHuskExtension.destroy = function (arg_7_0)
	local var_7_0 = arg_7_0._world
	local var_7_1 = arg_7_0._sfx_name_stop

	if var_7_1 then
		local var_7_2 = arg_7_0._unit

		WwiseUtils.trigger_unit_event(var_7_0, var_7_1, var_7_2, 0)
	end

	for iter_7_0, iter_7_1 in pairs(arg_7_0._blobs) do
		local var_7_3 = iter_7_1.fx_id

		if var_7_3 then
			World.stop_spawning_particles(var_7_0, var_7_3)
		end
	end
end

LiquidAreaDamageHuskExtension.get_source_attacker_unit = function (arg_8_0)
	return arg_8_0._source_attacker_unit
end
