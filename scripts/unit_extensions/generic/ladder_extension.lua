-- chunkname: @scripts/unit_extensions/generic/ladder_extension.lua

LadderExtension = class(LadderExtension)

LadderExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._unit = arg_1_2
	self._is_server = Managers.state.network.is_server
	self._seed_x = Math.random()
	self._seed_y = Math.random()

	local get_data = Unit.get_data(arg_1_2, "ladder_shake_node")

	get_data = get_data or 0
	self._node = get_data
	self._enable_shake = not Unit.get_data(arg_1_2, "disable_shake")
	self._start_position = Vector3Box(Unit.world_position(self._unit, self._node))
	self._top_position = Vector3Box(Unit.world_position(arg_1_2, Unit.node(arg_1_2, "node_top")))
	self._bottom_position = Vector3Box(Unit.world_position(arg_1_2, Unit.node(arg_1_2, "node_bottom")))

	if not self._is_server then
		Managers.state.bot_nav_transition:register_ladder(arg_1_2)
	end
end

LadderExtension.ladder_extents = function (self)
	-- function 2
	return self._bottom_position:unbox(), self._top_position:unbox()
end

LadderExtension.perlin_shake = {
	persistance = 1,
	magnitude = 0.1,
	frequency_multiplier = 4,
	duration = 1,
	min_value = 0,
	octaves = 6
}

local function fn(arg_3_0, arg_3_1)
	-- function 3
	local next_random, var_3_1 = Math.next_random(arg_3_0 * arg_3_1)
	local next_random_2, var_3_3 = Math.next_random(next_random)

	return var_3_3 * 2 - 1
end

local function fn_2(arg_4_0, arg_4_1)
	-- function 4
	return fn(arg_4_0, arg_4_1) / 2 + fn(arg_4_0 - 1, arg_4_1) / 4 + fn(arg_4_0 + 1, arg_4_1) / 4
end

local function fn_3(arg_5_0, arg_5_1)
	-- function 5
	local floor = math.floor(arg_5_0)
	local num = arg_5_0 - floor
	local var_5_2 = fn_2(floor, arg_5_1)
	local var_5_3 = fn_2(floor + 1, arg_5_1)

	return math.lerp(var_5_2, var_5_3, num)
end

local function fn_4(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local num = 0
	local num_2 = 0

	for i = 0, arg_6_2 do
		local num_3 = 2^i
		local num_4 = arg_6_1^i

		num = num + fn_3(arg_6_0 * num_3, arg_6_3) * num_4
		num_2 = num_2 + num_4
	end

	return num / num_2
end

LadderExtension.update_enabled = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	if not self._shaking then
		local num = arg_7_5 - self._shaking
		local perlin_shake = self.perlin_shake
		local duration = perlin_shake.duration

		if num < duration then
			if not self._enable_shake then
				local var_7_3 = fn_4(num * perlin_shake.frequency_multiplier, perlin_shake.persistance, perlin_shake.octaves, self._seed_x)
				local var_7_4 = fn_4(num * perlin_shake.frequency_multiplier, perlin_shake.persistance, perlin_shake.octaves, self._seed_y)
				local num_2 = perlin_shake.magnitude * math.lerp(1, 0, num / duration)^2

				Unit.set_local_position(self._unit, self._node, self._start_position:unbox() + Vector3(var_7_3 * num_2, var_7_4 * num_2, 0))
			end
		else
			Managers.state.entity:system("ladder_system"):disable_update_function("LadderExtension", "update", self._unit)

			self.update = nil
			self._shaking = false
		end
	end
end

LadderExtension.is_shaking = function (self)
	-- function 8
	local flag

	flag = not self._shaking and true and false

	return flag
end

LadderExtension.shake = function (self)
	-- function 9
	if not self._shaking then
		self._shaking = Managers.time:time("game")

		if not self._is_server then
			local current_level = LevelHelper:current_level(self._world)
			local unit_index = Level.unit_index(current_level, self._unit)

			Managers.state.network.network_transmit:send_rpc_clients("rpc_ladder_shake", unit_index)
		end

		Managers.state.entity:system("ladder_system"):enable_update_function("LadderExtension", "update", self._unit, self)

		self.update = self.update_enabled
	end
end

LadderExtension.destroy = function (self)
	-- function 10
	if not self._is_server then
		Managers.state.bot_nav_transition:unregister_ladder(self._unit)
	end
end
