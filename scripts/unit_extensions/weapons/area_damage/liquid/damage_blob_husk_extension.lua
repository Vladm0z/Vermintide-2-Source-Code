-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_blob_husk_extension.lua

DamageBlobHuskExtension = class(DamageBlobHuskExtension)

DamageBlobHuskExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0.world = var_1_0
	arg_1_0.game = Managers.state.network:game()
	arg_1_0.unit = arg_1_2
	arg_1_0.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_1_0._source_unit = arg_1_3.source_unit
	arg_1_0.physics_world = World.physics_world(var_1_0)
	arg_1_0.go_id = Managers.state.unit_storage:go_id(arg_1_2)
	arg_1_0.fx_list = {}
	arg_1_0.sfx_list = {}

	local var_1_1 = arg_1_3.damage_blob_template_name
	local var_1_2 = DamageBlobTemplates.templates[var_1_1]

	arg_1_0.fx_name_filled = var_1_2.fx_name_filled
	arg_1_0.fx_name_rim = var_1_2.fx_name_rim
	arg_1_0.fx_size_variable = var_1_2.fx_size_variable
	arg_1_0.fx_max_height = var_1_2.fx_max_height
	arg_1_0.fx_max_radius = var_1_2.fx_max_radius
	arg_1_0.blob_life_time = var_1_2.blob_life_time
	arg_1_0._sfx_name_stop = var_1_2.sfx_name_stop
	arg_1_0._sfx_name_start_remains = var_1_2.sfx_name_start_remains
	arg_1_0._sfx_name_stop_remains = var_1_2.sfx_name_stop_remains

	local var_1_3 = var_1_2.init_function

	if var_1_3 then
		local var_1_4 = Managers.time:time("game")

		DamageBlobTemplates[var_1_3](arg_1_0, var_1_4)
	end

	local var_1_5 = var_1_2.update_function

	if var_1_5 then
		arg_1_0._blob_update_function = DamageBlobTemplates[var_1_5]
	end

	local var_1_6 = var_1_2.sfx_name_start

	if var_1_6 then
		WwiseUtils.trigger_unit_event(var_1_0, var_1_6, arg_1_2, 0)
	end
end

DamageBlobHuskExtension.destroy = function (arg_2_0)
	local var_2_0 = arg_2_0.world
	local var_2_1 = arg_2_0.fx_list

	for iter_2_0 = 1, #var_2_1 do
		local var_2_2 = var_2_1[iter_2_0].id

		World.stop_spawning_particles(var_2_0, var_2_2)

		var_2_1[iter_2_0] = nil
	end

	local var_2_3 = arg_2_0.unit
	local var_2_4 = arg_2_0._sfx_name_stop

	if var_2_4 and Unit.alive(var_2_3) then
		WwiseUtils.trigger_unit_event(var_2_0, var_2_4, var_2_3, 0)
	end

	local var_2_5 = Managers.world:wwise_world(var_2_0)
	local var_2_6 = arg_2_0.sfx_list

	for iter_2_1 = 1, #var_2_6 do
		local var_2_7 = var_2_6[iter_2_1].source

		if WwiseWorld.has_source(var_2_5, var_2_7) then
			WwiseWorld.trigger_event(var_2_5, arg_2_0._sfx_name_stop_remains, var_2_7)
		end

		var_2_6[iter_2_1] = nil
	end

	arg_2_0.aborted = true
end

DamageBlobHuskExtension.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_0.game
	local var_3_1 = arg_3_0.go_id
	local var_3_2 = GameSession.game_object_field(var_3_0, var_3_1, "position")

	Unit.set_local_position(arg_3_1, 0, var_3_2)

	local var_3_3 = GameSession.game_object_field(var_3_0, var_3_1, "rotation")

	Unit.set_local_rotation(arg_3_1, 0, var_3_3)
	arg_3_0:update_blobs_fx_and_sfx(arg_3_5, arg_3_3)

	if arg_3_0._blob_update_function and not arg_3_0._blob_update_function(arg_3_0, arg_3_5, arg_3_3, arg_3_1, arg_3_0.physics_world) then
		arg_3_0._blob_update_function = nil
	end
end

DamageBlobHuskExtension.update_blobs_fx_and_sfx = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.world
	local var_4_1 = arg_4_0.fx_name_filled
	local var_4_2 = arg_4_0.fx_size_variable
	local var_4_3 = arg_4_0.fx_max_radius
	local var_4_4 = arg_4_0.fx_max_height
	local var_4_5 = arg_4_0.fx_list

	for iter_4_0 = 1, #var_4_5 do
		local var_4_6 = var_4_5[iter_4_0]
		local var_4_7 = var_4_6.id
		local var_4_8 = var_4_6.size

		if var_4_8 then
			local var_4_9 = var_4_8:unbox()

			var_4_9[1] = math.min(var_4_9[1] + arg_4_2 * 1.5, var_4_3)
			var_4_9[2] = math.min(var_4_9[2] + arg_4_2 * 2, var_4_4)

			local var_4_10 = World.find_particles_variable(var_4_0, var_4_1, var_4_2)

			World.set_particles_variable(var_4_0, var_4_7, var_4_10, var_4_9)
			var_4_8:store(var_4_9)
		end

		if arg_4_1 > var_4_6.time then
			World.stop_spawning_particles(var_4_0, var_4_7)
		end
	end

	local var_4_11 = arg_4_0.sfx_list
	local var_4_12 = arg_4_0._sfx_name_stop_remains
	local var_4_13 = Managers.world:wwise_world(arg_4_0.world)

	for iter_4_1 = 1, #var_4_11 do
		local var_4_14 = var_4_11[iter_4_1]
		local var_4_15 = var_4_14.source
		local var_4_16 = WwiseWorld.has_source(var_4_13, var_4_15)

		if arg_4_1 > var_4_14.time and var_4_16 then
			WwiseWorld.trigger_event(var_4_13, var_4_12, var_4_15)
		end
	end
end

DamageBlobHuskExtension.add_damage_blob_fx = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.unit
	local var_5_1 = arg_5_0.world
	local var_5_2 = Unit.local_rotation(var_5_0, 0)
	local var_5_3 = Managers.time:time("game")
	local var_5_4 = arg_5_0.blob_life_time
	local var_5_5 = arg_5_2 * var_5_4
	local var_5_6 = math.max(var_5_4 - var_5_5, 0)
	local var_5_7 = var_5_3 + var_5_5
	local var_5_8 = Vector3Box(0.6, 1.2, 0)
	local var_5_9 = arg_5_0.fx_max_radius
	local var_5_10 = arg_5_0.fx_max_height

	var_5_8[1] = math.min(var_5_8[1] + var_5_6 * 1.5, var_5_9)
	var_5_8[2] = math.min(var_5_8[2] + var_5_6 * 2, var_5_10)

	print(arg_5_2, var_5_5)

	local var_5_11 = arg_5_0.fx_list
	local var_5_12 = World.create_particles(var_5_1, arg_5_0.fx_name_filled, arg_5_1, var_5_2)

	var_5_11[#var_5_11 + 1] = {
		id = var_5_12,
		time = var_5_7,
		size = var_5_8
	}

	local var_5_13 = World.create_particles(var_5_1, arg_5_0.fx_name_rim, arg_5_1, var_5_2)

	var_5_11[#var_5_11 + 1] = {
		id = var_5_13,
		time = var_5_7
	}

	if not DEDICATED_SERVER then
		local var_5_14, var_5_15 = WwiseUtils.trigger_position_event(var_5_1, arg_5_0._sfx_name_start_remains, arg_5_1)
		local var_5_16 = arg_5_0.sfx_list

		var_5_16[#var_5_16 + 1] = {
			source = var_5_15,
			time = var_5_7
		}
	end
end

DamageBlobHuskExtension.abort = function (arg_6_0)
	local var_6_0 = arg_6_0.unit
	local var_6_1 = arg_6_0._sfx_name_stop

	if var_6_1 and Unit.alive(var_6_0) then
		WwiseUtils.trigger_unit_event(arg_6_0.world, var_6_1, var_6_0, 0)
	end

	arg_6_0.aborted = true
end

DamageBlobHuskExtension.get_source_attacker_unit = function (arg_7_0)
	return arg_7_0._source_unit
end
