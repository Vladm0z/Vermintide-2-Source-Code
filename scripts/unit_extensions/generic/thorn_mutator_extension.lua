-- chunkname: @scripts/unit_extensions/generic/thorn_mutator_extension.lua

ThornMutatorExtension = class(ThornMutatorExtension)

local num = 1

ThornMutatorExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local spawn_animation_time = arg_1_3.spawn_animation_time

	spawn_animation_time = spawn_animation_time or 0
	self.spawn_time = spawn_animation_time

	local despawn_animation_time = arg_1_3.despawn_animation_time

	despawn_animation_time = despawn_animation_time or 0
	self.despawn_time = despawn_animation_time
	self._spawn_timer = 0
	self._life_timer = 0
	self._is_server = Managers.state.network.is_server
	self._unit = arg_1_2

	local local_scale = Unit.local_scale(arg_1_2, 0)

	self._scale_x = local_scale.x
	self._scale_y = local_scale.y
	self._scale_z = local_scale.z

	local extension = ScriptUnit.extension(arg_1_2, "area_damage_system")

	self._area_damage_extension = extension
	self._life_time = extension.life_time
	self._despawning = false
end

ThornMutatorExtension.current_progress = function (self)
	-- function 2
	return self._spawn_timer
end

ThornMutatorExtension.get_spawn_time = function (self)
	-- function 3
	return self.spawn_time
end

ThornMutatorExtension.setup_rpc_sync = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.spawn_time = arg_4_1
	self._spawn_timer = arg_4_2
end

ThornMutatorExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local spawn_time = self.spawn_time
	local _spawn_timer = self._spawn_timer

	if _spawn_timer < 1 then
		local clamp = math.clamp(_spawn_timer + arg_5_3 / spawn_time, 0, 1)

		if clamp ~= 1 or not self._is_server then
			local network = Managers.state.network
			local unit_game_object_id = network:unit_game_object_id(self._unit)

			network.network_transmit:send_rpc_clients("rpc_thorn_bush_trigger_area_damage", unit_game_object_id)
			self:trigger_area_damage()
		end

		self._spawn_timer = clamp
	end

	if not (self._spawn_timer ~= 1 or not (self._life_timer < 1)) then
		local num_2 = self._life_time - self.despawn_time
		local _life_timer = self._life_timer

		if not self._despawning then
			local clamp_2 = math.clamp(_life_timer + arg_5_3 / num_2, 0, 1)

			if clamp_2 ~= 1 or not self._is_server then
				local network_2 = Managers.state.network
				local unit_game_object_id_2 = network_2:unit_game_object_id(self._unit)

				network_2.network_transmit:send_rpc_clients("rpc_thorn_bush_trigger_despawn", unit_game_object_id_2)
				self:despawn()

				self._despawn_done_time = arg_5_5 + num
			end

			self._life_timer = clamp_2
		end
	end

	if not (not self._is_server and not (self._area_damage_extension.num_hits > 0) or self._despawning) then
		local network_3 = Managers.state.network
		local unit_game_object_id_3 = network_3:unit_game_object_id(self._unit)

		network_3.network_transmit:send_rpc_clients("rpc_thorn_bush_trigger_despawn", unit_game_object_id_3)
		WwiseUtils.trigger_unit_event(arg_5_4.world, "Play_winds_life_gameplay_thorn_hit_player", arg_5_1, 0)
		self:despawn()

		self._despawn_done_time = arg_5_5 + num
	end

	if not self._is_server then
		self:_check_for_deletion(arg_5_5)
	end
end

ThornMutatorExtension.trigger_area_damage = function (self)
	-- function 6
	Unit.flow_event(self._unit, "set_static_material")
	ScriptUnit.extension(self._unit, "area_damage_system"):enable_area_damage(true)
end

ThornMutatorExtension.despawn = function (self)
	-- function 7
	Unit.flow_event(self._unit, "despawn")

	self._despawning = true

	ScriptUnit.extension(self._unit, "area_damage_system"):enable_area_damage(false)
end

ThornMutatorExtension._check_for_deletion = function (self, arg_8_1)
	-- function 8
	local _despawn_done_time = self._despawn_done_time

	_despawn_done_time = not _despawn_done_time and arg_8_1 > self._despawn_done_time

	if not _despawn_done_time then
		Managers.state.unit_spawner:mark_for_deletion(self._unit)
	end
end
