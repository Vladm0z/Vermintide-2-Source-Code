-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_sticky_locomotion.lua

require("scripts/helpers/network_utils")

ProjectileStickyLocomotion = class(ProjectileStickyLocomotion)

ProjectileStickyLocomotion.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.world = arg_1_1.world
	self.is_server = Managers.player.is_server
	self.spawn_time = Managers.time:time("game")
	self.time_lived = 0
	self.stop_time = 0
	self.stopped = arg_1_3.stopped
	self.moved = false
	self.extension_init_data = arg_1_3
	self.is_husk = not not arg_1_3.is_husk
	self.rotation_offset = arg_1_3.rotation_offset
	self.speed = arg_1_3.speed
	self.target_vector = arg_1_3.target_vector
	self.target_unit = arg_1_3.target_unit

	self:_init_from_seed(arg_1_3.seed)

	local initial_position = arg_1_3.initial_position

	self._last_position = Vector3Box(POSITION_LOOKUP[arg_1_2])
	self.position_boxed = Vector3Box(POSITION_LOOKUP[arg_1_2])
	self._rotation = QuaternionBox(Unit.world_rotation(arg_1_2, 0))
	self.velocity = Vector3Box()
	self.target_vector_boxed = Vector3Box(self.target_vector)
	self.initial_position_boxed = Vector3Box(initial_position)
	self._target_unit_id = NetworkConstants.invalid_game_object_id

	if not self.stopped then
		if not ALIVE[self.target_unit] then
			self:stick_to_unit(self.target_unit)
		else
			self:stick_to_position(initial_position)
		end
	end
end

ProjectileStickyLocomotion._init_from_seed = function (self, arg_2_1)
	-- function 2
	arg_2_1 = arg_2_1 or 0
	self._seed = arg_2_1
	self._spin_dir = 1 - bit.band(arg_2_1, 128) / 64
	arg_2_1, self._wobble_min = math.next_random_range(arg_2_1, 0, 0)
	arg_2_1, self._wobble_max = math.next_random_range(arg_2_1, 0.3, 0.5)
	arg_2_1, self._wobble_speed = math.next_random_range(arg_2_1, 3, 6)
	arg_2_1, self._wobble_vertical_mult = math.next_random_range(arg_2_1, 0.7, 1)
	arg_2_1, self._wobble_horizontal_mult = math.next_random_range(arg_2_1, 1, 1.2)
	arg_2_1, self._wobble_stabiliztion_speed = math.next_random_range(arg_2_1, 0.5, 0.5)
end

ProjectileStickyLocomotion.destroy = function (arg_3_0)
	-- function 3
	return
end

ProjectileStickyLocomotion.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	self.moved = false

	local num = arg_4_5 - self.spawn_time

	self.time_lived = num

	local var_4_1
	local var_4_2

	if not self.stopped and not self.stop_time then
		local num_2 = arg_4_5 - self.stop_time
		local target_unit = self.target_unit
		local var_4_5 = POSITION_LOOKUP[target_unit]

		if not var_4_5 then
			local num_3 = self._hit_unit_radius * 12 / self.speed
			local unbox = self._impact_offset:unbox()
			local num_4 = var_4_5 + Vector3(0, 0, self._hit_unit_height)

			if num_2 < num_3 then
				local unbox_2 = self.initial_position_boxed:unbox()
				local num_5 = num_4 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), num), unbox)
				local num_6 = num_4 + unbox
				local num_7 = num_5 + unbox
				local num_8 = num_2 / num_3

				var_4_1 = Bezier.calc_point(num_8, unbox_2, num_6, num_7, num_5)
			else
				var_4_1 = num_4 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), num), unbox)
			end
		else
			local num_9 = 0.5
			local unbox_3 = self._impact_offset:unbox()
			local cross = Vector3.cross(unbox_3, Vector3.up())
			local unbox_4 = self.initial_position_boxed:unbox()
			local num_10 = unbox_4 + Vector3.up() * (0.1 + math.sin(num) * 0.1) + unbox_3 * (math.sin(num * 1.4) * 0.1) + cross * (math.sin(num * 1.8) * 0.1)

			if num_2 < num_9 then
				local easeOutCubic = math.easeOutCubic(num_2 / num_9)

				var_4_1 = Vector3.lerp(unbox_4, num_10, easeOutCubic)
				var_4_2 = Quaternion.lerp(Quaternion.look(self.target_vector_boxed:unbox()), Quaternion.look(unbox_3), easeOutCubic)
			else
				var_4_1 = num_10
				var_4_2 = Quaternion.look(unbox_3)
			end
		end
	else
		local unbox_5 = self.target_vector_boxed:unbox()
		local num_11 = unbox_5 * self.speed * num
		local num_12 = self.speed * 0.1
		local easeCubic = math.easeCubic(math.clamp(num * self._wobble_stabiliztion_speed * num_12, 0, 1))
		local clamp = math.clamp(easeCubic * 250, 0, 1)
		local num_13 = math.lerp(self._wobble_max, self._wobble_min, easeCubic) * clamp
		local num_14 = num_13 * self._wobble_vertical_mult
		local num_15 = num_13 * self._wobble_horizontal_mult
		local num_16 = self._wobble_speed * self._spin_dir
		local var_4_29 = Vector3(math.sin(num * num_16 - math.rad(115)) * num_15, 0, math.cos(num * num_16 - math.rad(115)) * num_14)
		local rotate = Quaternion.rotate(Quaternion.look(unbox_5), var_4_29)

		var_4_1 = self.initial_position_boxed:unbox() + num_11 + rotate
	end

	if not NetworkUtils.network_safe_position(var_4_1) then
		self:stop()

		if not self.is_husk then
			Managers.state.unit_spawner:mark_for_deletion(self.unit)
		end

		return
	end

	local unbox_6 = self.position_boxed:unbox()
	local num_17 = var_4_1 - unbox_6

	if Vector3.length_squared(num_17) <= 1e-06 then
		return
	end

	var_4_2 = var_4_2 or Quaternion.look(num_17)

	Unit.set_local_position(arg_4_1, 0, var_4_1)
	Unit.set_local_rotation(arg_4_1, 0, var_4_2)
	self._last_position:store(unbox_6)
	self.position_boxed:store(var_4_1)
	self.velocity:store(num_17)
	self._rotation:store(var_4_2)

	self.moved = true
end

ProjectileStickyLocomotion.moved_this_frame = function (self)
	-- function 5
	return self.moved
end

ProjectileStickyLocomotion.current_velocity = function (self)
	-- function 6
	return self.velocity:unbox()
end

ProjectileStickyLocomotion.current_position = function (self)
	-- function 7
	return self.position_boxed:unbox()
end

ProjectileStickyLocomotion.current_rotation = function (self)
	-- function 8
	return self._rotation:unbox()
end

ProjectileStickyLocomotion.last_position = function (self)
	-- function 9
	return self._last_position:unbox()
end

ProjectileStickyLocomotion.stop = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not self.is_husk then
		return
	end

	local has_extension = ScriptUnit.has_extension(arg_10_1, "ai_system")

	if not has_extension then
		self:stick_to_unit(arg_10_1)
	else
		self:stick_to_position(self:current_position(), arg_10_3)
	end

	local network = Managers.state.network
	local game = network:game()

	if not game then
		local unit_storage = Managers.state.unit_storage
		local go_id = unit_storage:go_id(self.unit)
		local unbox = self.initial_position_boxed:unbox()
		local flag = not has_extension and unit_storage:go_id(arg_10_1)

		if not flag then
			GameSession.set_game_object_field(game, go_id, "target_unit", flag)

			if not self.is_server then
				network.network_transmit:send_rpc_clients("rpc_projectile_stick_unit", go_id, flag)
			else
				network.network_transmit:send_rpc_server("rpc_projectile_stick_unit", go_id, flag)
			end
		elseif not self.is_server then
			network.network_transmit:send_rpc_clients("rpc_projectile_stick_position", go_id, unbox)
		else
			network.network_transmit:send_rpc_server("rpc_projectile_stick_position", go_id, unbox)
		end

		GameSession.set_game_object_field(game, go_id, "initial_position", unbox)
		GameSession.set_game_object_field(game, go_id, "stopped", true)
	end
end

ProjectileStickyLocomotion.stick_to_unit = function (self, arg_11_1)
	-- function 11
	self.stopped = true
	self.stop_time = Managers.time:time("game")

	self.initial_position_boxed:store(self:current_position())

	self.target_unit = arg_11_1

	local has_extension = ScriptUnit.has_extension(arg_11_1, "ai_system")

	if not has_extension then
		local _breed = has_extension._breed
		local radius = _breed.radius

		radius = radius or 1
		self._hit_unit_radius = radius

		local num

		if not _breed.aoe_height then
			num = _breed.aoe_height / 2

			if not num then
				-- Nothing
			end
		end

		num = 1

		::label_11_0::

		self._hit_unit_height = num
		self._impact_offset = Vector3Box(Vector3.normalize(Vector3.flat(self.target_vector_boxed:unbox()) * radius))

		Unit.flow_event(self.unit, "stopped")
	else
		self:stick_to_position(self:current_position())
	end
end

ProjectileStickyLocomotion.stick_to_position = function (self, arg_12_1, arg_12_2)
	-- function 12
	self.stopped = true
	self.stop_time = Managers.time:time("game")

	local var_12_0 = arg_12_1

	if not arg_12_2 then
		var_12_0 = var_12_0 + arg_12_2 * 0.1
	end

	self.position_boxed:store(var_12_0)
	self.initial_position_boxed:store(var_12_0)

	self.target_unit = nil
	self._impact_offset = Vector3Box(Vector3.normalize(Vector3.flat(self.target_vector_boxed:unbox())))

	Unit.flow_event(self.unit, "stopped")
end

ProjectileStickyLocomotion.has_stopped = function (self)
	-- function 13
	return self.stopped
end

ProjectileStickyLocomotion.hot_join_sync = function (self, arg_14_1)
	-- function 14
	local var_14_0 = PEER_ID_TO_CHANNEL[arg_14_1]

	if not ALIVE[self.unit] then
		local go_id = Managers.state.unit_storage:go_id(self.unit)
		local num = Managers.time:time("game") - self.stop_time

		RPC.rpc_hot_join_sync_projectile_sticky(var_14_0, go_id, self.time_lived, num)
	end
end

ProjectileStickyLocomotion.hot_join_sync_projectile_sticky = function (self, arg_15_1, arg_15_2)
	-- function 15
	local time = Managers.time:time("game")

	self.spawn_time = time - arg_15_1
	self.stop_time = time - arg_15_2
	self.time_lived = arg_15_1
end
