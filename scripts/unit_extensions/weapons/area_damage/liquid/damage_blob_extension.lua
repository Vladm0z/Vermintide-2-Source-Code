-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_blob_extension.lua

DamageBlobExtension = class(DamageBlobExtension)

local alive = Unit.alive
local POSITION_LOOKUP = POSITION_LOOKUP

DamageBlobExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world
	local entity = Managers.state.entity
	local system = entity:system("ai_system")
	local network = Managers.state.network

	self.world = world
	self.game = network:game()
	self.unit = arg_1_2
	self.nav_world = system:nav_world()
	self.ai_system = system
	self.physics_world = World.physics_world(world)
	self.network_transmit = network.network_transmit
	self.ai_blob_index = 1
	self.blobs = {}
	self.rim_nodes = {}
	self.fx_list = {}
	self.sfx_list = {}
	self.ai_units_inside = {}
	self.player_units_inside = {}
	self.buff_system = entity:system("buff_system")
	self._source_unit = arg_1_3.source_unit
	self._source_side = Managers.state.side.side_by_unit[self._source_unit]

	local damage_blob_template_name = arg_1_3.damage_blob_template_name
	local var_1_5 = DamageBlobTemplates.templates[damage_blob_template_name]

	self.template = var_1_5
	self.damage_blob_template_name = damage_blob_template_name
	self.immune_breeds = var_1_5.immune_breeds
	self.fx_name_filled = var_1_5.fx_name_filled
	self.fx_name_rim = var_1_5.fx_name_rim
	self.fx_size_variable = var_1_5.fx_size_variable
	self.fx_max_height = var_1_5.fx_max_height
	self.fx_max_radius = var_1_5.fx_max_radius
	self.buff_template_name = var_1_5.buff_template_name
	self.buff_template_type = var_1_5.buff_template_type
	self.blob_radius = var_1_5.blob_radius
	self.blob_separation_dist = var_1_5.blob_separation_dist
	self.fx_separation_dist = var_1_5.fx_separation_dist
	self.apply_buff_to_ai = var_1_5.apply_buff_to_ai
	self.apply_buff_to_player = var_1_5.apply_buff_to_player
	self.time_of_life = var_1_5.time_of_life
	self.blob_life_time = var_1_5.blob_life_time
	self._sfx_name_stop = var_1_5.sfx_name_stop
	self._sfx_name_start_remains = var_1_5.sfx_name_start_remains
	self._sfx_name_stop_remains = var_1_5.sfx_name_stop_remains
	self.is_server = Managers.player.is_server
	self._create_blobs = var_1_5.create_blobs

	local init_function = var_1_5.init_function

	if not init_function then
		local time = Managers.time:time("game")

		DamageBlobTemplates[init_function](self, time)
	end

	local update_function = var_1_5.update_function

	if not update_function then
		self._blob_update_function = DamageBlobTemplates[update_function]
	end

	local sfx_name_start = var_1_5.sfx_name_start

	if not sfx_name_start then
		WwiseUtils.trigger_unit_event(world, sfx_name_start, arg_1_2, 0)
	end
end

DamageBlobExtension.start_placing_blobs = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.state = "waiting"
	self.last_blob_pos = Vector3Box()
	self.last_blob_dist = 0
	self.last_fx_pos = Vector3Box()
	self.last_fx_dist = 0

	local unit = self.unit

	self.unit_id = Managers.state.network:unit_game_object_id(unit)
	self.wait_time = arg_2_2 + arg_2_1

	if not self._create_blobs then
		local template = self.template
		local use_nav_cost_map_volumes = template.use_nav_cost_map_volumes

		if not use_nav_cost_map_volumes then
			local nav_cost_map_cost_type = template.nav_cost_map_cost_type
			local num = 10

			self._nav_cost_map_id = self.ai_system:create_nav_cost_map(nav_cost_map_cost_type, num)
		end

		self.use_nav_cost_map_volumes = use_nav_cost_map_volumes
	end
end

local num = 0.5

DamageBlobExtension.stop_placing_blobs = function (self, arg_3_1)
	-- function 3
	self.state = "lingering"
	self.linger_time = arg_3_1 + self.time_of_life

	local unit = self.unit
	local _sfx_name_stop = self._sfx_name_stop

	if not _sfx_name_stop and not alive(unit) then
		WwiseUtils.trigger_unit_event(self.world, _sfx_name_stop, unit, 0)
	end

	local blobs = self.blobs
	local count = #blobs

	if count > 0 then
		local local_rotation = Unit.local_rotation(unit, 0)
		local forward = Quaternion.forward(local_rotation)
		local var_3_6 = blobs[count]
		local num_2 = Vector3(var_3_6[1], var_3_6[2], var_3_6[3]) + forward * (var_3_6[4] + num)
		local triangle_from_position, var_3_9 = GwNavQueries.triangle_from_position(self.nav_world, num_2, 1.5, 1.5)

		if not triangle_from_position then
			local rim_nodes = self.rim_nodes

			num_2.z = var_3_9
			rim_nodes[#rim_nodes + 1] = Vector3Box(num_2)
		end
	end

	self.aborted = true
end

DamageBlobExtension._remove_blob = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local buff_system = self.buff_system
	local ai_units_inside = self.ai_units_inside
	local var_4_2 = arg_4_1[5]

	for k, v in pairs(var_4_2) do
		if not ALIVE[k] then
			buff_system:remove_server_controlled_buff(k, v)
		end

		ai_units_inside[k] = nil
	end

	local var_4_3 = arg_4_1[7]

	if not var_4_3 then
		local ai_system = self.ai_system
		local _nav_cost_map_id = self._nav_cost_map_id

		ai_system:remove_nav_cost_map_volume(var_4_3, _nav_cost_map_id)
	end

	table.remove(arg_4_3, arg_4_2)
end

DamageBlobExtension.destroy = function (self)
	-- function 5
	local unit = self.unit
	local buff_system = self.buff_system
	local player_units_inside = self.player_units_inside

	for k, v in pairs(player_units_inside) do
		if not alive(k) then
			if ScriptUnit.extension(k, "status_system").in_liquid_unit == unit then
				StatusUtils.set_in_liquid_network(k, false)
			end

			buff_system:remove_server_controlled_buff(k, v)
		end
	end

	local blobs = self.blobs
	local count = #blobs
	local ai_system = self.ai_system
	local _nav_cost_map_id = self._nav_cost_map_id

	for k_2 = 1, count do
		local var_5_7 = blobs[k_2]
		local var_5_8 = var_5_7[5]

		for k_3, v_2 in pairs(var_5_8) do
			if not ALIVE[k_3] then
				buff_system:remove_server_controlled_buff(k_3, v_2)
			end
		end

		local var_5_9 = var_5_7[7]

		if not var_5_9 then
			ai_system:remove_nav_cost_map_volume(var_5_9, _nav_cost_map_id)
		end
	end

	if not _nav_cost_map_id then
		ai_system:destroy_nav_cost_map(_nav_cost_map_id)
	end

	local world = self.world
	local fx_list = self.fx_list

	for i5 = 1, #fx_list do
		local id = fx_list[i5].id

		World.stop_spawning_particles(world, id)

		fx_list[i5] = nil
	end

	local _sfx_name_stop = self._sfx_name_stop

	if not _sfx_name_stop and not alive(unit) then
		WwiseUtils.trigger_unit_event(world, _sfx_name_stop, unit, 0)
	end

	local wwise_world = Managers.world:wwise_world(world)
	local sfx_list = self.sfx_list

	for i6 = 1, #sfx_list do
		local source = sfx_list[i6].source

		if not WwiseWorld.has_source(wwise_world, source) then
			WwiseWorld.trigger_event(wwise_world, self._sfx_name_stop_remains, source)
		end

		sfx_list[i6] = nil
	end

	self.aborted = true
end

DamageBlobExtension.place_blobs = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = POSITION_LOOKUP[arg_6_1]
	local nav_world = self.nav_world
	local triangle_from_position, var_6_3, var_6_4, var_6_5, var_6_6 = GwNavQueries.triangle_from_position(nav_world, var_6_0, 5, 5)

	if not triangle_from_position then
		var_6_0 = Vector3(var_6_0.x, var_6_0.y, var_6_3)
	end

	local num = self.last_blob_pos:unbox() - var_6_0
	local length_squared = Vector3.length_squared(num)
	local num_2 = self.blob_separation_dist^2
	local local_rotation = Unit.local_rotation(arg_6_1, 0)

	if num_2 <= length_squared then
		local blob_radius = self.blob_radius

		self:insert_blob(var_6_0, blob_radius, local_rotation, arg_6_2, nav_world)

		if not (not triangle_from_position and DEDICATED_SERVER) then
			local trigger_position_event, var_6_13 = WwiseUtils.trigger_position_event(self.world, self._sfx_name_start_remains, var_6_0)
			local sfx_list = self.sfx_list

			sfx_list[#sfx_list + 1] = {
				source = var_6_13,
				time = arg_6_2 + self.blob_life_time
			}
		end
	end

	local num_3 = self.last_fx_pos:unbox() - var_6_0

	if Vector3.length_squared(num_3) >= self.fx_separation_dist^2 then
		local var_6_16

		if not var_6_4 then
			local num_4 = var_6_5 - var_6_4
			local cross = Vector3.cross(num_4 - var_6_4, var_6_6 - var_6_4)

			var_6_16 = Quaternion.look(num_4, cross)
		else
			var_6_16 = Quaternion.look(num, Vector3(0, 0, 1))
		end

		self:insert_fx(var_6_0, var_6_16, arg_6_2)
	end

	local game = self.game
	local unit_id = self.unit_id

	GameSession.set_game_object_field(game, unit_id, "position", var_6_0)
	GameSession.set_game_object_field(game, unit_id, "rotation", local_rotation)
end

DamageBlobExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local state = self.state

	if state == "waiting" then
		if arg_7_5 > self.wait_time then
			self.state = "running"
		end
	elseif state == "running" then
		if not self._create_blobs then
			self:place_blobs(arg_7_1, arg_7_5)
		end
	elseif not (state ~= "lingering" or not (arg_7_5 > self.linger_time)) then
		Managers.state.unit_spawner:mark_for_deletion(arg_7_1)
	end

	if not self._create_blobs then
		self:update_blobs_fx_and_sfx(arg_7_5, arg_7_3)
		self:update_blob_overlaps(arg_7_5)
	end

	if not self._blob_update_function then
		local _blob_update_function = self._blob_update_function(self, arg_7_5, arg_7_3, arg_7_1, self.physics_world)
		local unit_id = self.unit_id

		if _blob_update_function or not unit_id then
			self._blob_update_function = nil

			if not self.is_server then
				self.network_transmit:send_rpc_clients("rpc_abort_damage_blob", unit_id)
			else
				self.network_transmit:send_rpc_server("rpc_abort_damage_blob", unit_id)
			end
		end
	end
end

DamageBlobExtension.insert_blob = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local var_8_0

	if not self.use_nav_cost_map_volumes then
		local ai_system = self.ai_system
		local _nav_cost_map_id = self._nav_cost_map_id

		var_8_0 = ai_system:add_nav_cost_map_sphere_volume(arg_8_1, arg_8_2, _nav_cost_map_id)
	end

	local blobs = self.blobs
	local num_2 = #blobs + 1

	blobs[num_2] = {
		arg_8_1[1],
		arg_8_1[2],
		arg_8_1[3],
		arg_8_2,
		{},
		arg_8_4 + self.blob_life_time,
		var_8_0
	}

	self.last_blob_pos:store(arg_8_1)

	local rim_nodes = self.rim_nodes
	local num_3 = arg_8_2 + num
	local right = Quaternion.right(arg_8_3)
	local num_4 = arg_8_1 + right * num_3
	local triangle_from_position, var_8_10 = GwNavQueries.triangle_from_position(arg_8_5, num_4, 1.5, 1.5)

	if not triangle_from_position then
		num_4.z = var_8_10
		rim_nodes[#rim_nodes + 1] = Vector3Box(num_4)
	end

	local num_5 = arg_8_1 + -right * num_3
	local triangle_from_position_2, var_8_13 = GwNavQueries.triangle_from_position(arg_8_5, num_5, 1.5, 1.5)

	if not triangle_from_position_2 then
		num_5.z = var_8_13
		rim_nodes[#rim_nodes + 1] = Vector3Box(num_5)
	end

	if num_2 == 1 then
		local num_6 = arg_8_1 + -Quaternion.forward(arg_8_3) * num_3
		local triangle_from_position_3, var_8_16 = GwNavQueries.triangle_from_position(arg_8_5, num_6, 1.5, 1.5)

		if not triangle_from_position_3 then
			num_6.z = var_8_16
			rim_nodes[#rim_nodes + 1] = Vector3Box(num_6)
		end
	end
end

DamageBlobExtension.insert_fx = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local world = self.world
	local fx_list = self.fx_list
	local num = arg_9_3 + self.blob_life_time
	local fx_name_filled = self.fx_name_filled
	local create_particles = World.create_particles(world, fx_name_filled, arg_9_1, arg_9_2 or Quaternion.identity())

	fx_list[#fx_list + 1] = {
		position = Vector3Box(arg_9_1),
		id = create_particles,
		time = num,
		size = Vector3Box(0.6, 1.2, 0)
	}

	local fx_name_rim = self.fx_name_rim
	local create_particles_2 = World.create_particles(world, fx_name_rim, arg_9_1, arg_9_2 or Quaternion.identity())

	fx_list[#fx_list + 1] = {
		position = Vector3Box(arg_9_1),
		id = create_particles_2,
		time = num
	}

	local unit_id = self.unit_id

	if not unit_id then
		local num_2 = 1

		if not self.is_server then
			self.network_transmit:send_rpc_clients("rpc_add_damage_blob_fx", unit_id, arg_9_1, num_2)
		else
			self.network_transmit:send_rpc_server("rpc_add_damage_blob_fx", unit_id, arg_9_1, num_2)
		end
	end

	self.last_fx_pos:store(arg_9_1)
end

DamageBlobExtension.update_blobs_fx_and_sfx = function (self, arg_10_1, arg_10_2)
	-- function 10
	local world = self.world
	local fx_name_filled = self.fx_name_filled
	local fx_size_variable = self.fx_size_variable
	local fx_max_radius = self.fx_max_radius
	local fx_max_height = self.fx_max_height
	local fx_list = self.fx_list

	if #fx_list >= 1 then
		local var_10_6 = next(self.fx_list, self.current_fx_index)

		var_10_6 = var_10_6 or 1

		local var_10_7 = fx_list[var_10_6]

		if not var_10_7 then
			self.current_fx_index = var_10_6

			local id = var_10_7.id
			local size = var_10_7.size

			if not size then
				local unbox = size:unbox()

				unbox[1] = math.min(unbox[1] + arg_10_2 * 1.5, fx_max_radius)
				unbox[2] = math.min(unbox[2] + arg_10_2 * 2, fx_max_height)

				local find_particles_variable = World.find_particles_variable(world, fx_name_filled, fx_size_variable)

				World.set_particles_variable(world, id, find_particles_variable, unbox)
				size:store(unbox)
			end

			if arg_10_1 > var_10_7.time then
				World.stop_spawning_particles(world, id)
			end
		end
	end

	local sfx_list = self.sfx_list
	local _sfx_name_stop_remains = self._sfx_name_stop_remains
	local wwise_world = Managers.world:wwise_world(world)
	local has_source = WwiseWorld.has_source
	local trigger_event = WwiseWorld.trigger_event

	for i = 1, #sfx_list do
		local var_10_17 = sfx_list[i]
		local source = var_10_17.source

		if not (arg_10_1 > var_10_17.time) or var_10_17.stopped_sound_event or not has_source(wwise_world, source) then
			trigger_event(wwise_world, _sfx_name_stop_remains, source)

			var_10_17.stopped_sound_event = true
		end
	end
end

DamageBlobExtension.update_blob_overlaps = function (self, arg_11_1)
	-- function 11
	local blobs = self.blobs
	local count = #blobs

	if count < 1 then
		return
	end

	local unit = self.unit
	local buff_system = self.buff_system
	local var_11_4 = blobs[1]
	local var_11_5 = blobs[count]
	local var_11_6 = Vector3(var_11_4[1], var_11_4[2], var_11_4[3])
	local var_11_7 = Vector3(var_11_5[1], var_11_5[2], var_11_5[3])

	if not self.apply_buff_to_player then
		local ENEMY_PLAYER_AND_BOT_UNITS = self._source_side.ENEMY_PLAYER_AND_BOT_UNITS
		local blob_radius = self.blob_radius

		for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
			local var_11_10 = ENEMY_PLAYER_AND_BOT_UNITS[i]

			self:check_overlap(unit, var_11_10, blob_radius, var_11_6, var_11_7, buff_system, count)
		end
	end

	if not self.apply_buff_to_ai then
		return
	end

	local num = 1
	local ai_blob_index = self.ai_blob_index
	local min = math.min(num, count)
	local buff_template_name = self.buff_template_name
	local buff_template_type = self.buff_template_type
	local immune_breeds = self.immune_breeds
	local ai_units_inside = self.ai_units_inside
	local BLACKBOARDS = BLACKBOARDS
	local alloc_table = FrameTable.alloc_table()
	local alloc_table_2 = FrameTable.alloc_table()

	while min > 0 do
		local var_11_21 = blobs[ai_blob_index]
		local var_11_22 = Vector3(var_11_21[1], var_11_21[2], var_11_21[3])
		local var_11_23 = var_11_21[4]
		local var_11_24 = var_11_21[5]

		if arg_11_1 > var_11_21[6] then
			self:_remove_blob(var_11_21, ai_blob_index, blobs)

			count = count - 1
		else
			local broadphase_query = AiUtils.broadphase_query(var_11_22, var_11_23, alloc_table)

			for j = 1, broadphase_query do
				local var_11_26 = alloc_table[j]
				local var_11_27 = ai_units_inside[var_11_26]

				if not (not HEALTH_ALIVE[var_11_26] and var_11_27 == nil or var_11_27 ~= var_11_21) then
					local var_11_28 = POSITION_LOOKUP[var_11_26]
					local closest_point_on_line = Geometry.closest_point_on_line(var_11_28, var_11_6, var_11_7)

					if Vector3.distance_squared(var_11_28, closest_point_on_line) < var_11_23^2 then
						local name = BLACKBOARDS[var_11_26].breed.name
						local has_extension = ScriptUnit.has_extension(var_11_26, "buff_system")

						if not (not has_extension and immune_breeds[name] or has_extension:has_buff_type(buff_template_type)) then
							var_11_24[var_11_26] = buff_system:add_buff(var_11_26, buff_template_name, unit, true)
						end

						ai_units_inside[var_11_26] = var_11_21
						alloc_table_2[var_11_26] = true
					end
				end
			end

			for k, v in pairs(var_11_24) do
				if not alloc_table_2[k] then
					if not ALIVE[k] then
						buff_system:remove_server_controlled_buff(k, v)
					end

					ai_units_inside[k] = nil
					var_11_24[k] = nil
				end
			end

			ai_blob_index = ai_blob_index + 1
		end

		if count < ai_blob_index then
			ai_blob_index = 1
		end

		min = min - 1
	end

	self.ai_blob_index = ai_blob_index
end

DamageBlobExtension.check_overlap = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	-- function 12
	local player_units_inside = self.player_units_inside
	local var_12_1 = POSITION_LOOKUP[arg_12_2]
	local closest_point_on_line = Geometry.closest_point_on_line(var_12_1, arg_12_4, arg_12_5)
	local flat = Vector3.flat(var_12_1 - closest_point_on_line)
	local length_squared = Vector3.length_squared(flat)
	local num = arg_12_3^2
	local var_12_6 = player_units_inside[arg_12_2]
	local extension = ScriptUnit.extension(arg_12_2, "status_system")

	if not var_12_6 then
		if num < length_squared then
			if extension.in_liquid_unit == arg_12_1 then
				StatusUtils.set_in_liquid_network(arg_12_2, false)
			end

			arg_12_6:remove_server_controlled_buff(arg_12_2, var_12_6)

			player_units_inside[arg_12_2] = nil
		end
	elseif length_squared < num then
		local distance = Vector3.distance(arg_12_4, closest_point_on_line)
		local num_2 = math.floor(0.5 + distance * arg_12_7) + 1
		local clamp = math.clamp(num_2, 1, arg_12_7)
		local var_12_11 = self.blobs[clamp][3]
		local buff_template_name = self.buff_template_name
		local buff_template_type = self.buff_template_type
		local extension_2 = ScriptUnit.extension(arg_12_2, "buff_system")

		if not (not (arg_12_3 > math.abs(var_12_1.z - var_12_11)) or extension_2:has_buff_type(buff_template_type)) then
			if extension.in_liquid_unit ~= arg_12_1 then
				StatusUtils.set_in_liquid_network(arg_12_2, true, arg_12_1)
			end

			player_units_inside[arg_12_2] = arg_12_6:add_buff(arg_12_2, buff_template_name, arg_12_1, true)
		end
	end
end

DamageBlobExtension.get_rim_nodes = function (self)
	-- function 13
	return self.rim_nodes, true
end

DamageBlobExtension.is_position_inside = function (self, arg_14_1, arg_14_2)
	-- function 14
	local blobs = self.blobs
	local count = #blobs

	if count == 0 then
		return false
	end

	local nav_cost_map_cost_type = self.template.nav_cost_map_cost_type

	if not ((nav_cost_map_cost_type == nil or not arg_14_2) and arg_14_2[nav_cost_map_cost_type] ~= 1) then
		return false
	end

	local var_14_3 = blobs[1]
	local var_14_4 = blobs[count]
	local var_14_5 = Vector3(var_14_3[1], var_14_3[2], var_14_3[3])
	local var_14_6 = Vector3(var_14_4[1], var_14_4[2], var_14_4[3])
	local closest_point_on_line = Geometry.closest_point_on_line(arg_14_1, var_14_5, var_14_6)

	return Vector3.distance_squared(arg_14_1, closest_point_on_line) <= self.blob_radius^2
end

DamageBlobExtension.hot_join_sync = function (self, arg_15_1)
	-- function 15
	local fx_list = self.fx_list
	local unit_id = self.unit_id
	local network_transmit = self.network_transmit
	local time = Managers.time:time("game")
	local blob_life_time = self.blob_life_time

	for i = 1, #fx_list - 1, 2 do
		local var_15_5 = fx_list[i]
		local unbox = var_15_5.position:unbox()
		local num = math.max(var_15_5.time - time, 0) / blob_life_time

		network_transmit:send_rpc("rpc_add_damage_blob_fx", arg_15_1, unit_id, unbox, num)
	end
end

DamageBlobExtension._debug_render_blobs = function (self)
	-- function 16
	local blobs = self.blobs

	for i = 1, #blobs do
		local var_16_1 = blobs[i]
		local var_16_2 = Vector3(var_16_1[1], var_16_1[2], var_16_1[3])
		local var_16_3 = var_16_1[4]

		QuickDrawer:circle(var_16_2, var_16_3, Vector3(0, 0, 1), Color(255, 146, 60))

		local var_16_4 = var_16_1[5]

		for k, v in pairs(var_16_4) do
			if not ALIVE[k] then
				local var_16_5 = POSITION_LOOKUP[k]

				QuickDrawer:sphere(var_16_5, 0.5, Color(70, 146, 60))
				QuickDrawer:line(var_16_5, var_16_2, Color(70, 146, 60))
			end
		end
	end

	local rim_nodes = self.rim_nodes

	for l = 1, #rim_nodes do
		local unbox = rim_nodes[l]:unbox()

		QuickDrawer:sphere(unbox, 0.05)
	end

	local player_units_inside = self.player_units_inside

	for k_2, v_2 in pairs(player_units_inside) do
		if not alive(k_2) then
			local var_16_9 = POSITION_LOOKUP[k_2]

			QuickDrawer:sphere(var_16_9, 0.3, Color(255, 0, 60))
		end
	end
end

DamageBlobExtension.get_source_attacker_unit = function (self)
	-- function 17
	return self._source_unit
end
