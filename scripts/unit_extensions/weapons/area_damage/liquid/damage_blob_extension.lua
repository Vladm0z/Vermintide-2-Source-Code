-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_blob_extension.lua

DamageBlobExtension = class(DamageBlobExtension)

local var_0_0 = Unit.alive
local var_0_1 = POSITION_LOOKUP

DamageBlobExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world
	local var_1_1 = Managers.state.entity
	local var_1_2 = var_1_1:system("ai_system")
	local var_1_3 = Managers.state.network

	arg_1_0.world = var_1_0
	arg_1_0.game = var_1_3:game()
	arg_1_0.unit = arg_1_2
	arg_1_0.nav_world = var_1_2:nav_world()
	arg_1_0.ai_system = var_1_2
	arg_1_0.physics_world = World.physics_world(var_1_0)
	arg_1_0.network_transmit = var_1_3.network_transmit
	arg_1_0.ai_blob_index = 1
	arg_1_0.blobs = {}
	arg_1_0.rim_nodes = {}
	arg_1_0.fx_list = {}
	arg_1_0.sfx_list = {}
	arg_1_0.ai_units_inside = {}
	arg_1_0.player_units_inside = {}
	arg_1_0.buff_system = var_1_1:system("buff_system")
	arg_1_0._source_unit = arg_1_3.source_unit
	arg_1_0._source_side = Managers.state.side.side_by_unit[arg_1_0._source_unit]

	local var_1_4 = arg_1_3.damage_blob_template_name
	local var_1_5 = DamageBlobTemplates.templates[var_1_4]

	arg_1_0.template = var_1_5
	arg_1_0.damage_blob_template_name = var_1_4
	arg_1_0.immune_breeds = var_1_5.immune_breeds
	arg_1_0.fx_name_filled = var_1_5.fx_name_filled
	arg_1_0.fx_name_rim = var_1_5.fx_name_rim
	arg_1_0.fx_size_variable = var_1_5.fx_size_variable
	arg_1_0.fx_max_height = var_1_5.fx_max_height
	arg_1_0.fx_max_radius = var_1_5.fx_max_radius
	arg_1_0.buff_template_name = var_1_5.buff_template_name
	arg_1_0.buff_template_type = var_1_5.buff_template_type
	arg_1_0.blob_radius = var_1_5.blob_radius
	arg_1_0.blob_separation_dist = var_1_5.blob_separation_dist
	arg_1_0.fx_separation_dist = var_1_5.fx_separation_dist
	arg_1_0.apply_buff_to_ai = var_1_5.apply_buff_to_ai
	arg_1_0.apply_buff_to_player = var_1_5.apply_buff_to_player
	arg_1_0.time_of_life = var_1_5.time_of_life
	arg_1_0.blob_life_time = var_1_5.blob_life_time
	arg_1_0._sfx_name_stop = var_1_5.sfx_name_stop
	arg_1_0._sfx_name_start_remains = var_1_5.sfx_name_start_remains
	arg_1_0._sfx_name_stop_remains = var_1_5.sfx_name_stop_remains
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0._create_blobs = var_1_5.create_blobs

	local var_1_6 = var_1_5.init_function

	if var_1_6 then
		local var_1_7 = Managers.time:time("game")

		DamageBlobTemplates[var_1_6](arg_1_0, var_1_7)
	end

	local var_1_8 = var_1_5.update_function

	if var_1_8 then
		arg_1_0._blob_update_function = DamageBlobTemplates[var_1_8]
	end

	local var_1_9 = var_1_5.sfx_name_start

	if var_1_9 then
		WwiseUtils.trigger_unit_event(var_1_0, var_1_9, arg_1_2, 0)
	end
end

DamageBlobExtension.start_placing_blobs = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.state = "waiting"
	arg_2_0.last_blob_pos = Vector3Box()
	arg_2_0.last_blob_dist = 0
	arg_2_0.last_fx_pos = Vector3Box()
	arg_2_0.last_fx_dist = 0

	local var_2_0 = arg_2_0.unit

	arg_2_0.unit_id = Managers.state.network:unit_game_object_id(var_2_0)
	arg_2_0.wait_time = arg_2_2 + arg_2_1

	if arg_2_0._create_blobs then
		local var_2_1 = arg_2_0.template
		local var_2_2 = var_2_1.use_nav_cost_map_volumes

		if var_2_2 then
			local var_2_3 = var_2_1.nav_cost_map_cost_type
			local var_2_4 = 10

			arg_2_0._nav_cost_map_id = arg_2_0.ai_system:create_nav_cost_map(var_2_3, var_2_4)
		end

		arg_2_0.use_nav_cost_map_volumes = var_2_2
	end
end

local var_0_2 = 0.5

DamageBlobExtension.stop_placing_blobs = function (arg_3_0, arg_3_1)
	arg_3_0.state = "lingering"
	arg_3_0.linger_time = arg_3_1 + arg_3_0.time_of_life

	local var_3_0 = arg_3_0.unit
	local var_3_1 = arg_3_0._sfx_name_stop

	if var_3_1 and var_0_0(var_3_0) then
		WwiseUtils.trigger_unit_event(arg_3_0.world, var_3_1, var_3_0, 0)
	end

	local var_3_2 = arg_3_0.blobs
	local var_3_3 = #var_3_2

	if var_3_3 > 0 then
		local var_3_4 = Unit.local_rotation(var_3_0, 0)
		local var_3_5 = Quaternion.forward(var_3_4)
		local var_3_6 = var_3_2[var_3_3]
		local var_3_7 = Vector3(var_3_6[1], var_3_6[2], var_3_6[3]) + var_3_5 * (var_3_6[4] + var_0_2)
		local var_3_8, var_3_9 = GwNavQueries.triangle_from_position(arg_3_0.nav_world, var_3_7, 1.5, 1.5)

		if var_3_8 then
			local var_3_10 = arg_3_0.rim_nodes

			var_3_7.z = var_3_9
			var_3_10[#var_3_10 + 1] = Vector3Box(var_3_7)
		end
	end

	arg_3_0.aborted = true
end

DamageBlobExtension._remove_blob = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0.buff_system
	local var_4_1 = arg_4_0.ai_units_inside
	local var_4_2 = arg_4_1[5]

	for iter_4_0, iter_4_1 in pairs(var_4_2) do
		if ALIVE[iter_4_0] then
			var_4_0:remove_server_controlled_buff(iter_4_0, iter_4_1)
		end

		var_4_1[iter_4_0] = nil
	end

	local var_4_3 = arg_4_1[7]

	if var_4_3 then
		local var_4_4 = arg_4_0.ai_system
		local var_4_5 = arg_4_0._nav_cost_map_id

		var_4_4:remove_nav_cost_map_volume(var_4_3, var_4_5)
	end

	table.remove(arg_4_3, arg_4_2)
end

DamageBlobExtension.destroy = function (arg_5_0)
	local var_5_0 = arg_5_0.unit
	local var_5_1 = arg_5_0.buff_system
	local var_5_2 = arg_5_0.player_units_inside

	for iter_5_0, iter_5_1 in pairs(var_5_2) do
		if var_0_0(iter_5_0) then
			if ScriptUnit.extension(iter_5_0, "status_system").in_liquid_unit == var_5_0 then
				StatusUtils.set_in_liquid_network(iter_5_0, false)
			end

			var_5_1:remove_server_controlled_buff(iter_5_0, iter_5_1)
		end
	end

	local var_5_3 = arg_5_0.blobs
	local var_5_4 = #var_5_3
	local var_5_5 = arg_5_0.ai_system
	local var_5_6 = arg_5_0._nav_cost_map_id

	for iter_5_2 = 1, var_5_4 do
		local var_5_7 = var_5_3[iter_5_2]
		local var_5_8 = var_5_7[5]

		for iter_5_3, iter_5_4 in pairs(var_5_8) do
			if ALIVE[iter_5_3] then
				var_5_1:remove_server_controlled_buff(iter_5_3, iter_5_4)
			end
		end

		local var_5_9 = var_5_7[7]

		if var_5_9 then
			var_5_5:remove_nav_cost_map_volume(var_5_9, var_5_6)
		end
	end

	if var_5_6 then
		var_5_5:destroy_nav_cost_map(var_5_6)
	end

	local var_5_10 = arg_5_0.world
	local var_5_11 = arg_5_0.fx_list

	for iter_5_5 = 1, #var_5_11 do
		local var_5_12 = var_5_11[iter_5_5].id

		World.stop_spawning_particles(var_5_10, var_5_12)

		var_5_11[iter_5_5] = nil
	end

	local var_5_13 = arg_5_0._sfx_name_stop

	if var_5_13 and var_0_0(var_5_0) then
		WwiseUtils.trigger_unit_event(var_5_10, var_5_13, var_5_0, 0)
	end

	local var_5_14 = Managers.world:wwise_world(var_5_10)
	local var_5_15 = arg_5_0.sfx_list

	for iter_5_6 = 1, #var_5_15 do
		local var_5_16 = var_5_15[iter_5_6].source

		if WwiseWorld.has_source(var_5_14, var_5_16) then
			WwiseWorld.trigger_event(var_5_14, arg_5_0._sfx_name_stop_remains, var_5_16)
		end

		var_5_15[iter_5_6] = nil
	end

	arg_5_0.aborted = true
end

DamageBlobExtension.place_blobs = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = var_0_1[arg_6_1]
	local var_6_1 = arg_6_0.nav_world
	local var_6_2, var_6_3, var_6_4, var_6_5, var_6_6 = GwNavQueries.triangle_from_position(var_6_1, var_6_0, 5, 5)

	if var_6_2 then
		var_6_0 = Vector3(var_6_0.x, var_6_0.y, var_6_3)
	end

	local var_6_7 = arg_6_0.last_blob_pos:unbox() - var_6_0
	local var_6_8 = Vector3.length_squared(var_6_7)
	local var_6_9 = arg_6_0.blob_separation_dist^2
	local var_6_10 = Unit.local_rotation(arg_6_1, 0)

	if var_6_9 <= var_6_8 then
		local var_6_11 = arg_6_0.blob_radius

		arg_6_0:insert_blob(var_6_0, var_6_11, var_6_10, arg_6_2, var_6_1)

		if var_6_2 and not DEDICATED_SERVER then
			local var_6_12, var_6_13 = WwiseUtils.trigger_position_event(arg_6_0.world, arg_6_0._sfx_name_start_remains, var_6_0)
			local var_6_14 = arg_6_0.sfx_list

			var_6_14[#var_6_14 + 1] = {
				source = var_6_13,
				time = arg_6_2 + arg_6_0.blob_life_time
			}
		end
	end

	local var_6_15 = arg_6_0.last_fx_pos:unbox() - var_6_0

	if Vector3.length_squared(var_6_15) >= arg_6_0.fx_separation_dist^2 then
		local var_6_16

		if var_6_4 then
			local var_6_17 = var_6_5 - var_6_4
			local var_6_18 = Vector3.cross(var_6_17 - var_6_4, var_6_6 - var_6_4)

			var_6_16 = Quaternion.look(var_6_17, var_6_18)
		else
			var_6_16 = Quaternion.look(var_6_7, Vector3(0, 0, 1))
		end

		arg_6_0:insert_fx(var_6_0, var_6_16, arg_6_2)
	end

	local var_6_19 = arg_6_0.game
	local var_6_20 = arg_6_0.unit_id

	GameSession.set_game_object_field(var_6_19, var_6_20, "position", var_6_0)
	GameSession.set_game_object_field(var_6_19, var_6_20, "rotation", var_6_10)
end

DamageBlobExtension.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_0.state

	if var_7_0 == "waiting" then
		if arg_7_5 > arg_7_0.wait_time then
			arg_7_0.state = "running"
		end
	elseif var_7_0 == "running" then
		if arg_7_0._create_blobs then
			arg_7_0:place_blobs(arg_7_1, arg_7_5)
		end
	elseif var_7_0 == "lingering" and arg_7_5 > arg_7_0.linger_time then
		Managers.state.unit_spawner:mark_for_deletion(arg_7_1)
	end

	if arg_7_0._create_blobs then
		arg_7_0:update_blobs_fx_and_sfx(arg_7_5, arg_7_3)
		arg_7_0:update_blob_overlaps(arg_7_5)
	end

	if arg_7_0._blob_update_function then
		local var_7_1 = arg_7_0._blob_update_function(arg_7_0, arg_7_5, arg_7_3, arg_7_1, arg_7_0.physics_world)
		local var_7_2 = arg_7_0.unit_id

		if not var_7_1 and var_7_2 then
			arg_7_0._blob_update_function = nil

			if arg_7_0.is_server then
				arg_7_0.network_transmit:send_rpc_clients("rpc_abort_damage_blob", var_7_2)
			else
				arg_7_0.network_transmit:send_rpc_server("rpc_abort_damage_blob", var_7_2)
			end
		end
	end
end

DamageBlobExtension.insert_blob = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0

	if arg_8_0.use_nav_cost_map_volumes then
		local var_8_1 = arg_8_0.ai_system
		local var_8_2 = arg_8_0._nav_cost_map_id

		var_8_0 = var_8_1:add_nav_cost_map_sphere_volume(arg_8_1, arg_8_2, var_8_2)
	end

	local var_8_3 = arg_8_0.blobs
	local var_8_4 = #var_8_3 + 1

	var_8_3[var_8_4] = {
		arg_8_1[1],
		arg_8_1[2],
		arg_8_1[3],
		arg_8_2,
		{},
		arg_8_4 + arg_8_0.blob_life_time,
		var_8_0
	}

	arg_8_0.last_blob_pos:store(arg_8_1)

	local var_8_5 = arg_8_0.rim_nodes
	local var_8_6 = arg_8_2 + var_0_2
	local var_8_7 = Quaternion.right(arg_8_3)
	local var_8_8 = arg_8_1 + var_8_7 * var_8_6
	local var_8_9, var_8_10 = GwNavQueries.triangle_from_position(arg_8_5, var_8_8, 1.5, 1.5)

	if var_8_9 then
		var_8_8.z = var_8_10
		var_8_5[#var_8_5 + 1] = Vector3Box(var_8_8)
	end

	local var_8_11 = arg_8_1 + -var_8_7 * var_8_6
	local var_8_12, var_8_13 = GwNavQueries.triangle_from_position(arg_8_5, var_8_11, 1.5, 1.5)

	if var_8_12 then
		var_8_11.z = var_8_13
		var_8_5[#var_8_5 + 1] = Vector3Box(var_8_11)
	end

	if var_8_4 == 1 then
		local var_8_14 = arg_8_1 + -Quaternion.forward(arg_8_3) * var_8_6
		local var_8_15, var_8_16 = GwNavQueries.triangle_from_position(arg_8_5, var_8_14, 1.5, 1.5)

		if var_8_15 then
			var_8_14.z = var_8_16
			var_8_5[#var_8_5 + 1] = Vector3Box(var_8_14)
		end
	end
end

DamageBlobExtension.insert_fx = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.world
	local var_9_1 = arg_9_0.fx_list
	local var_9_2 = arg_9_3 + arg_9_0.blob_life_time
	local var_9_3 = arg_9_0.fx_name_filled
	local var_9_4 = World.create_particles(var_9_0, var_9_3, arg_9_1, arg_9_2 or Quaternion.identity())

	var_9_1[#var_9_1 + 1] = {
		position = Vector3Box(arg_9_1),
		id = var_9_4,
		time = var_9_2,
		size = Vector3Box(0.6, 1.2, 0)
	}

	local var_9_5 = arg_9_0.fx_name_rim
	local var_9_6 = World.create_particles(var_9_0, var_9_5, arg_9_1, arg_9_2 or Quaternion.identity())

	var_9_1[#var_9_1 + 1] = {
		position = Vector3Box(arg_9_1),
		id = var_9_6,
		time = var_9_2
	}

	local var_9_7 = arg_9_0.unit_id

	if var_9_7 then
		local var_9_8 = 1

		if arg_9_0.is_server then
			arg_9_0.network_transmit:send_rpc_clients("rpc_add_damage_blob_fx", var_9_7, arg_9_1, var_9_8)
		else
			arg_9_0.network_transmit:send_rpc_server("rpc_add_damage_blob_fx", var_9_7, arg_9_1, var_9_8)
		end
	end

	arg_9_0.last_fx_pos:store(arg_9_1)
end

DamageBlobExtension.update_blobs_fx_and_sfx = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.world
	local var_10_1 = arg_10_0.fx_name_filled
	local var_10_2 = arg_10_0.fx_size_variable
	local var_10_3 = arg_10_0.fx_max_radius
	local var_10_4 = arg_10_0.fx_max_height
	local var_10_5 = arg_10_0.fx_list

	if #var_10_5 >= 1 then
		local var_10_6 = next(arg_10_0.fx_list, arg_10_0.current_fx_index) or 1
		local var_10_7 = var_10_5[var_10_6]

		if var_10_7 then
			arg_10_0.current_fx_index = var_10_6

			local var_10_8 = var_10_7.id
			local var_10_9 = var_10_7.size

			if var_10_9 then
				local var_10_10 = var_10_9:unbox()

				var_10_10[1] = math.min(var_10_10[1] + arg_10_2 * 1.5, var_10_3)
				var_10_10[2] = math.min(var_10_10[2] + arg_10_2 * 2, var_10_4)

				local var_10_11 = World.find_particles_variable(var_10_0, var_10_1, var_10_2)

				World.set_particles_variable(var_10_0, var_10_8, var_10_11, var_10_10)
				var_10_9:store(var_10_10)
			end

			if arg_10_1 > var_10_7.time then
				World.stop_spawning_particles(var_10_0, var_10_8)
			end
		end
	end

	local var_10_12 = arg_10_0.sfx_list
	local var_10_13 = arg_10_0._sfx_name_stop_remains
	local var_10_14 = Managers.world:wwise_world(var_10_0)
	local var_10_15 = WwiseWorld.has_source
	local var_10_16 = WwiseWorld.trigger_event

	for iter_10_0 = 1, #var_10_12 do
		local var_10_17 = var_10_12[iter_10_0]
		local var_10_18 = var_10_17.source

		if arg_10_1 > var_10_17.time and not var_10_17.stopped_sound_event and var_10_15(var_10_14, var_10_18) then
			var_10_16(var_10_14, var_10_13, var_10_18)

			var_10_17.stopped_sound_event = true
		end
	end
end

DamageBlobExtension.update_blob_overlaps = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.blobs
	local var_11_1 = #var_11_0

	if var_11_1 < 1 then
		return
	end

	local var_11_2 = arg_11_0.unit
	local var_11_3 = arg_11_0.buff_system
	local var_11_4 = var_11_0[1]
	local var_11_5 = var_11_0[var_11_1]
	local var_11_6 = Vector3(var_11_4[1], var_11_4[2], var_11_4[3])
	local var_11_7 = Vector3(var_11_5[1], var_11_5[2], var_11_5[3])

	if arg_11_0.apply_buff_to_player then
		local var_11_8 = arg_11_0._source_side.ENEMY_PLAYER_AND_BOT_UNITS
		local var_11_9 = arg_11_0.blob_radius

		for iter_11_0 = 1, #var_11_8 do
			local var_11_10 = var_11_8[iter_11_0]

			arg_11_0:check_overlap(var_11_2, var_11_10, var_11_9, var_11_6, var_11_7, var_11_3, var_11_1)
		end
	end

	if not arg_11_0.apply_buff_to_ai then
		return
	end

	local var_11_11 = 1
	local var_11_12 = arg_11_0.ai_blob_index
	local var_11_13 = math.min(var_11_11, var_11_1)
	local var_11_14 = arg_11_0.buff_template_name
	local var_11_15 = arg_11_0.buff_template_type
	local var_11_16 = arg_11_0.immune_breeds
	local var_11_17 = arg_11_0.ai_units_inside
	local var_11_18 = BLACKBOARDS
	local var_11_19 = FrameTable.alloc_table()
	local var_11_20 = FrameTable.alloc_table()

	while var_11_13 > 0 do
		local var_11_21 = var_11_0[var_11_12]
		local var_11_22 = Vector3(var_11_21[1], var_11_21[2], var_11_21[3])
		local var_11_23 = var_11_21[4]
		local var_11_24 = var_11_21[5]

		if arg_11_1 > var_11_21[6] then
			arg_11_0:_remove_blob(var_11_21, var_11_12, var_11_0)

			var_11_1 = var_11_1 - 1
		else
			local var_11_25 = AiUtils.broadphase_query(var_11_22, var_11_23, var_11_19)

			for iter_11_1 = 1, var_11_25 do
				local var_11_26 = var_11_19[iter_11_1]
				local var_11_27 = var_11_17[var_11_26]

				if HEALTH_ALIVE[var_11_26] and (var_11_27 == nil or var_11_27 == var_11_21) then
					local var_11_28 = var_0_1[var_11_26]
					local var_11_29 = Geometry.closest_point_on_line(var_11_28, var_11_6, var_11_7)

					if Vector3.distance_squared(var_11_28, var_11_29) < var_11_23^2 then
						local var_11_30 = var_11_18[var_11_26].breed.name
						local var_11_31 = ScriptUnit.has_extension(var_11_26, "buff_system")

						if var_11_31 and not var_11_16[var_11_30] and not var_11_31:has_buff_type(var_11_15) then
							var_11_24[var_11_26] = var_11_3:add_buff(var_11_26, var_11_14, var_11_2, true)
						end

						var_11_17[var_11_26] = var_11_21
						var_11_20[var_11_26] = true
					end
				end
			end

			for iter_11_2, iter_11_3 in pairs(var_11_24) do
				if not var_11_20[iter_11_2] then
					if ALIVE[iter_11_2] then
						var_11_3:remove_server_controlled_buff(iter_11_2, iter_11_3)
					end

					var_11_17[iter_11_2] = nil
					var_11_24[iter_11_2] = nil
				end
			end

			var_11_12 = var_11_12 + 1
		end

		if var_11_1 < var_11_12 then
			var_11_12 = 1
		end

		var_11_13 = var_11_13 - 1
	end

	arg_11_0.ai_blob_index = var_11_12
end

DamageBlobExtension.check_overlap = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	local var_12_0 = arg_12_0.player_units_inside
	local var_12_1 = var_0_1[arg_12_2]
	local var_12_2 = Geometry.closest_point_on_line(var_12_1, arg_12_4, arg_12_5)
	local var_12_3 = Vector3.flat(var_12_1 - var_12_2)
	local var_12_4 = Vector3.length_squared(var_12_3)
	local var_12_5 = arg_12_3^2
	local var_12_6 = var_12_0[arg_12_2]
	local var_12_7 = ScriptUnit.extension(arg_12_2, "status_system")

	if var_12_6 then
		if var_12_5 < var_12_4 then
			if var_12_7.in_liquid_unit == arg_12_1 then
				StatusUtils.set_in_liquid_network(arg_12_2, false)
			end

			arg_12_6:remove_server_controlled_buff(arg_12_2, var_12_6)

			var_12_0[arg_12_2] = nil
		end
	elseif var_12_4 < var_12_5 then
		local var_12_8 = Vector3.distance(arg_12_4, var_12_2)
		local var_12_9 = math.floor(0.5 + var_12_8 * arg_12_7) + 1
		local var_12_10 = math.clamp(var_12_9, 1, arg_12_7)
		local var_12_11 = arg_12_0.blobs[var_12_10][3]
		local var_12_12 = arg_12_0.buff_template_name
		local var_12_13 = arg_12_0.buff_template_type
		local var_12_14 = ScriptUnit.extension(arg_12_2, "buff_system")

		if arg_12_3 > math.abs(var_12_1.z - var_12_11) and not var_12_14:has_buff_type(var_12_13) then
			if var_12_7.in_liquid_unit ~= arg_12_1 then
				StatusUtils.set_in_liquid_network(arg_12_2, true, arg_12_1)
			end

			var_12_0[arg_12_2] = arg_12_6:add_buff(arg_12_2, var_12_12, arg_12_1, true)
		end
	end
end

DamageBlobExtension.get_rim_nodes = function (arg_13_0)
	return arg_13_0.rim_nodes, true
end

DamageBlobExtension.is_position_inside = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.blobs
	local var_14_1 = #var_14_0

	if var_14_1 == 0 then
		return false
	end

	local var_14_2 = arg_14_0.template.nav_cost_map_cost_type

	if var_14_2 == nil or arg_14_2 and arg_14_2[var_14_2] == 1 then
		return false
	end

	local var_14_3 = var_14_0[1]
	local var_14_4 = var_14_0[var_14_1]
	local var_14_5 = Vector3(var_14_3[1], var_14_3[2], var_14_3[3])
	local var_14_6 = Vector3(var_14_4[1], var_14_4[2], var_14_4[3])
	local var_14_7 = Geometry.closest_point_on_line(arg_14_1, var_14_5, var_14_6)

	return Vector3.distance_squared(arg_14_1, var_14_7) <= arg_14_0.blob_radius^2
end

DamageBlobExtension.hot_join_sync = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.fx_list
	local var_15_1 = arg_15_0.unit_id
	local var_15_2 = arg_15_0.network_transmit
	local var_15_3 = Managers.time:time("game")
	local var_15_4 = arg_15_0.blob_life_time

	for iter_15_0 = 1, #var_15_0 - 1, 2 do
		local var_15_5 = var_15_0[iter_15_0]
		local var_15_6 = var_15_5.position:unbox()
		local var_15_7 = math.max(var_15_5.time - var_15_3, 0) / var_15_4

		var_15_2:send_rpc("rpc_add_damage_blob_fx", arg_15_1, var_15_1, var_15_6, var_15_7)
	end
end

DamageBlobExtension._debug_render_blobs = function (arg_16_0)
	local var_16_0 = arg_16_0.blobs

	for iter_16_0 = 1, #var_16_0 do
		local var_16_1 = var_16_0[iter_16_0]
		local var_16_2 = Vector3(var_16_1[1], var_16_1[2], var_16_1[3])
		local var_16_3 = var_16_1[4]

		QuickDrawer:circle(var_16_2, var_16_3, Vector3(0, 0, 1), Color(255, 146, 60))

		local var_16_4 = var_16_1[5]

		for iter_16_1, iter_16_2 in pairs(var_16_4) do
			if ALIVE[iter_16_1] then
				local var_16_5 = var_0_1[iter_16_1]

				QuickDrawer:sphere(var_16_5, 0.5, Color(70, 146, 60))
				QuickDrawer:line(var_16_5, var_16_2, Color(70, 146, 60))
			end
		end
	end

	local var_16_6 = arg_16_0.rim_nodes

	for iter_16_3 = 1, #var_16_6 do
		local var_16_7 = var_16_6[iter_16_3]:unbox()

		QuickDrawer:sphere(var_16_7, 0.05)
	end

	local var_16_8 = arg_16_0.player_units_inside

	for iter_16_4, iter_16_5 in pairs(var_16_8) do
		if var_0_0(iter_16_4) then
			local var_16_9 = var_0_1[iter_16_4]

			QuickDrawer:sphere(var_16_9, 0.3, Color(255, 0, 60))
		end
	end
end

DamageBlobExtension.get_source_attacker_unit = function (arg_17_0)
	return arg_17_0._source_unit
end
