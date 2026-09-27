-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/buff_area_extension.lua

BuffAreaExtension = class(BuffAreaExtension)

BuffAreaExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self._unit_spawner = Managers.state.unit_spawner
	self._world = world
	self._unit = arg_1_2

	Unit.set_unit_visibility(self._unit, false)

	local time = Managers.time:time("game")
	local sub_buff_template = arg_1_3.sub_buff_template
	local duration = sub_buff_template.duration

	duration = duration or math.huge
	self._end_t = time + duration
	self.sub_buff_id = arg_1_3.sub_buff_id
	self.template = sub_buff_template

	local radius = arg_1_3.radius

	self.owner_unit = arg_1_3.owner_unit
	self.source_unit = arg_1_3.source_unit
	self.radius = radius
	self.radius_squared = radius * radius
	self._buff_area_system = arg_1_1.owning_system
	self._unlimited = self.template.unlimited
	self.side_id = arg_1_3.side_id
	self.side = Managers.state.side:get_side(self.side_id)
	self._buff_allies = sub_buff_template.buff_allies
	self._buff_enemies = sub_buff_template.buff_enemies
	self._buff_self = sub_buff_template.buff_self
	self._wwise_world = Managers.world:wwise_world(world)
	self._area_start_sfx = sub_buff_template.area_start_sfx
	self._area_end_sfx = sub_buff_template.area_end_sfx
	self._enter_area_sfx = sub_buff_template.enter_area_sfx
	self._leave_area_sfx = sub_buff_template.leave_area_sfx

	if not sub_buff_template.area_start_sfx then
		self:_play_unit_audio()
	end

	self:_spawn_particles()

	self._is_server = Managers.state.network.is_server

	if not self._is_server then
		self:_spawn_los_blocker()
	end
end

BuffAreaExtension.game_object_initialized = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._is_owner = GameSession.game_object_owned(Managers.state.network:game(), arg_2_2)
end

BuffAreaExtension.destroy = function (self)
	-- function 3
	if not self._is_server and not Unit.alive(self._los_blocker_unit) then
		self._unit_spawner:mark_for_deletion(self._los_blocker_unit)

		self._los_blocker_unit = nil
	end

	if not self._is_owner and not Managers.state.network:game() then
		self:_cleanup_inside_units()
	end

	if not self._leave_area_sfx then
		self:play_leave_buff_zone_sfx()
	end

	if not self._area_end_sfx then
		self:_stop_unit_audio()
	end

	self:_destroy_particles()
end

BuffAreaExtension._cleanup_inside_units = function (self)
	-- function 4
	local inside_by_area = self._buff_area_system:inside_by_area(self)
	local by_position = inside_by_area.by_position

	for k in pairs(by_position) do
		self:_set_not_inside(by_position, k)
	end

	local by_broadphase = inside_by_area.by_broadphase

	for k_2 in pairs(by_broadphase) do
		self:_set_not_inside(by_broadphase, k_2)
	end
end

BuffAreaExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if not self._particle_state and not self._particle_state.update_fx then
		BuffUtils.update_attached_particles(self._world, self._particle_state, arg_5_5)
	end

	if not self._is_owner then
		return
	end

	if not (not self._end_t and not (arg_5_5 > self._end_t)) then
		self:_remove_unit()
		self:_cleanup_inside_units()

		return
	end

	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local radius = self.radius

	if self._buff_allies or not self._buff_enemies then
		self:_check_ai(var_5_0, radius)
	end

	self:_check_players(var_5_0, radius)
end

BuffAreaExtension._check_ai = function (self, arg_6_1, arg_6_2)
	-- function 6
	local source_unit = self.source_unit

	source_unit = source_unit or self.owner_unit

	local by_broadphase = self._buff_area_system:inside_by_area(self).by_broadphase
	local _buff_allies = self._buff_allies
	local _buff_enemies = self._buff_enemies
	local side = Managers.state.side
	local alloc_table = FrameTable.alloc_table()
	local alloc_table_2 = FrameTable.alloc_table()
	local broadphase_query = AiUtils.broadphase_query(arg_6_1, arg_6_2, alloc_table)

	for i = 1, broadphase_query do
		local var_6_8 = alloc_table[i]

		alloc_table_2[var_6_8] = true

		if not by_broadphase[var_6_8] then
			local is_ally

			if not _buff_allies then
				is_ally = side:is_ally(source_unit, var_6_8)

				if not is_ally then
					-- Nothing
				end
			end

			is_ally = not _buff_enemies and side:is_enemy(source_unit, var_6_8)

			::label_6_0::

			if not is_ally then
				self:_set_inside(by_broadphase, var_6_8)
			end
		end
	end

	for k in pairs(by_broadphase) do
		if not alloc_table_2[k] then
			self:_set_not_inside(by_broadphase, k)
		end
	end
end

BuffAreaExtension._check_players = function (self, arg_7_1)
	-- function 7
	local alloc_table = FrameTable.alloc_table()

	if not self._buff_self then
		local source_unit = self.source_unit

		source_unit = source_unit or self.owner_unit
		alloc_table[source_unit] = self:_update_by_position(source_unit)
	end

	local side = self.side

	if not self._buff_allies then
		local PLAYER_AND_BOT_UNITS = side.PLAYER_AND_BOT_UNITS

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_7_4 = PLAYER_AND_BOT_UNITS[i]

			alloc_table[var_7_4] = self:_update_by_position(var_7_4)
		end
	end

	if not self._buff_enemies then
		local ENEMY_PLAYER_AND_BOT_UNITS = side.ENEMY_PLAYER_AND_BOT_UNITS

		for j = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
			local var_7_6 = ENEMY_PLAYER_AND_BOT_UNITS[j]

			alloc_table[var_7_6] = self:_update_by_position(var_7_6)
		end
	end

	local by_position = self._buff_area_system:inside_by_area(self).by_position

	for k in pairs(by_position) do
		if not alloc_table[k] then
			self:_set_not_inside(by_position, k)
		end
	end
end

BuffAreaExtension._update_by_position = function (self, arg_8_1)
	-- function 8
	local by_position = self._buff_area_system:inside_by_area(self).by_position
	local flag = false
	local var_8_2 = POSITION_LOOKUP[arg_8_1]

	if not var_8_2 then
		local var_8_3 = POSITION_LOOKUP[self._unit]

		flag = Vector3.length_squared(var_8_3 - var_8_2) <= self.radius_squared
	end

	if not flag then
		self:_set_inside(by_position, arg_8_1)
	else
		self:_set_not_inside(by_position, arg_8_1)
	end

	return flag
end

BuffAreaExtension.set_unit_position = function (self, arg_9_1)
	-- function 9
	Unit.set_local_position(self._unit, 0, arg_9_1)
end

BuffAreaExtension.set_duration = function (self, arg_10_1)
	-- function 10
	self._end_t = Managers.time:time("game") + arg_10_1
end

BuffAreaExtension._leave_func = function (self, arg_11_1)
	-- function 11
	if not self._unlimited then
		local system = Managers.state.entity:system("buff_system")
		local buff_ids = self._buff_area_system:inside_by_area(self).buff_ids
		local var_11_2 = buff_ids[arg_11_1]

		system:remove_buff_synced(arg_11_1, var_11_2)

		buff_ids[arg_11_1] = nil
	end

	local owner = Managers.player:owner(arg_11_1)
	local flag = not owner and owner:network_id()
	local _unit = self._unit

	_unit = not _unit and Managers.state.unit_storage:go_id(self._unit)

	if not self._leave_area_sfx and not flag and not _unit then
		Managers.state.network.network_transmit:send_rpc("rpc_play_leave_buff_zone_sfx", flag, _unit)
	end
end

BuffAreaExtension._enter_func = function (self, arg_12_1)
	-- function 12
	local system = Managers.state.entity:system("buff_system")
	local template = self.template
	local buff_area_buff = template.buff_area_buff
	local buff_sync_type = template.buff_sync_type

	buff_sync_type = buff_sync_type or BuffSyncType.Local

	local alloc_table = FrameTable.alloc_table()
	local source_unit = self.source_unit

	alloc_table.attacker_unit = source_unit
	alloc_table.source_attacker_unit = source_unit

	local owner = Managers.player:owner(arg_12_1)
	local flag = not owner and owner:network_id()
	local _unit = self._unit

	_unit = not _unit and Managers.state.unit_storage:go_id(self._unit)

	if not self._leave_area_sfx and not flag and not _unit then
		Managers.state.network.network_transmit:send_rpc("rpc_play_enter_buff_zone_sfx", flag, _unit)
	end

	if not ((buff_sync_type == BuffSyncType.Client or buff_sync_type == BuffSyncType.ClientAndServer) and flag) then
		return
	end

	self._buff_area_system:inside_by_area(self).buff_ids[arg_12_1] = system:add_buff_synced(arg_12_1, buff_area_buff, buff_sync_type, alloc_table, flag)
end

BuffAreaExtension._remove_unit = function (self)
	-- function 13
	if not ALIVE[self._unit] then
		self._unit_spawner:mark_for_deletion(self._unit)

		self._unit = nil
	end
end

BuffAreaExtension._spawn_los_blocker = function (self)
	-- function 14
	local world_position = Unit.world_position(self._unit, 0)
	local radius = self.radius
	local str = "units/gameplay/line_of_sight_blocker/hemisphere_los_blocker"
	local str_2 = "network_synched_dummy_unit"
	local spawn_network_unit, var_14_5 = self._unit_spawner:spawn_network_unit(str, str_2, nil, world_position, Quaternion.identity(), nil)

	Unit.set_local_scale(spawn_network_unit, 0, Vector3(radius, radius, radius))

	self._los_blocker_unit = spawn_network_unit
end

BuffAreaExtension._set_inside = function (self, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0 = arg_15_1[arg_15_2]

	var_15_0 = var_15_0 or {}
	arg_15_1[arg_15_2] = var_15_0

	local is_empty = table.is_empty(var_15_0)

	var_15_0[self] = true

	if not is_empty then
		self:_enter_func(arg_15_2)
	end
end

BuffAreaExtension._set_not_inside = function (self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0 = arg_16_1[arg_16_2]

	if not var_16_0 and not var_16_0[self] then
		var_16_0[self] = nil

		if not table.is_empty(var_16_0) then
			arg_16_1[arg_16_2] = nil

			self:_leave_func(arg_16_2)
		end
	end
end

BuffAreaExtension._spawn_particles = function (self)
	-- function 17
	local buff_area_particles = self.template.buff_area_particles

	if not buff_area_particles then
		return
	end

	local flag = false

	self._particle_state = BuffUtils.create_attached_particles(self._world, buff_area_particles, self._unit, flag, self.source_unit, self._end_t)
end

BuffAreaExtension._destroy_particles = function (self)
	-- function 18
	local _particle_state = self._particle_state

	if not _particle_state then
		return
	end

	BuffUtils.destroy_attached_particles(self._world, _particle_state)
end

BuffAreaExtension._play_unit_audio = function (self)
	-- function 19
	self._unit_source_id = WwiseWorld.make_manual_source(self._wwise_world, POSITION_LOOKUP[self._unit])

	WwiseWorld.trigger_event(self._wwise_world, self._area_start_sfx, self._unit_source_id)
end

BuffAreaExtension._stop_unit_audio = function (self)
	-- function 20
	if not self._unit_source_id then
		WwiseWorld.trigger_event(self._wwise_world, self._area_end_sfx, true, self._unit_source_id)
		WwiseWorld.destroy_manual_source(self._wwise_world, self._unit_source_id)
	end
end

BuffAreaExtension.play_enter_buff_zone_sfx = function (self)
	-- function 21
	self._inside_zone_audio_id = WwiseUtils.make_unit_auto_source(self._world, self._unit)

	WwiseWorld.trigger_event(self._wwise_world, self._enter_area_sfx, true, self._inside_zone_audio_id)
end

BuffAreaExtension.play_leave_buff_zone_sfx = function (self)
	-- function 22
	if not self._inside_zone_audio_id then
		WwiseWorld.trigger_event(self._wwise_world, self._leave_area_sfx, true, self._inside_zone_audio_id)

		self._inside_zone_audio_id = nil
	end
end
