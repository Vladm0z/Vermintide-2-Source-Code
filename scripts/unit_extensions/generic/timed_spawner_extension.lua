-- chunkname: @scripts/unit_extensions/generic/timed_spawner_extension.lua

TimedSpawnerExtension = class(TimedSpawnerExtension)

local flag = true
local tbl = {
	"rpc_on_timed_spawn"
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_1_0, arg_1_1, 1, 1)

	pos_on_mesh = pos_on_mesh or GwNavQueries.inside_position_from_outside_position(arg_1_0, arg_1_1, 6, 6, 8, 0.5)

	return pos_on_mesh
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local next_random, var_2_1 = Math.next_random(arg_2_0, 1, #arg_2_1)

	return next_random, arg_2_1[var_2_1]
end

TimedSpawnerExtension.init = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	self._is_server = arg_3_1.is_server
	self._world = arg_3_1.world
	self._unit = arg_3_2
	self._network_manager = Managers.state.network
	self._conflict_director = Managers.state.conflict
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._unit_storage = arg_3_1.unit_storage
	self.network_transmit = arg_3_1.network_transmit
	self.network_event_delegate = self.network_transmit.network_event_delegate

	self.network_event_delegate:register(self, unpack(tbl))

	self._spawn_rate = arg_3_3.spawn_rate
	self._spawnable_breeds = arg_3_3.spawnable_breeds
	self._max_spawn_amount = arg_3_3.max_spawn_amount
	self._cb_unit_spawned_function = arg_3_3.cb_unit_spawned_function
	self._seed = Managers.mechanism:get_level_seed()
	self._timer = self._network_manager:network_time() + self._spawn_rate
	self._spawn_amount = 0
end

TimedSpawnerExtension.extensions_ready = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	return
end

TimedSpawnerExtension.destroy = function (self)
	-- function 5
	if not self.network_event_delegate then
		self.network_event_delegate:unregister(self)

		self.network_event_delegate = nil
	end
end

TimedSpawnerExtension._can_spawn = function (self, arg_6_1)
	-- function 6
	local flag = self._spawn_amount >= self._max_spawn_amount
	local flag_2 = arg_6_1 >= self._timer

	return not not flag or flag_2
end

TimedSpawnerExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	if not self._is_server then
		return
	end

	local network_time = self._network_manager:network_time()

	if not self:_can_spawn(network_time) then
		self:_spawn_breed()

		local go_id = self._unit_storage:go_id(arg_7_1)

		self:rpc_on_timed_spawn(Network.peer_id(), go_id)
		self.network_transmit:send_rpc_clients("rpc_on_timed_spawn", go_id)

		self._spawn_amount = self._spawn_amount + 1
		self._timer = network_time + self._spawn_rate
	end

	local flag_2 = self._spawn_amount >= self._max_spawn_amount

	if not flag and not flag_2 then
		Managers.state.unit_spawner:mark_for_deletion(arg_7_1)
	end
end

TimedSpawnerExtension._spawn_breed = function (self)
	-- function 8
	local _unit = self._unit
	local var_8_1 = POSITION_LOOKUP[_unit]
	local flag = not var_8_1 and fn(self._nav_world, var_8_1)

	if not var_8_1 then
		return
	end

	local local_rotation = Unit.local_rotation(_unit, 0)
	local var_8_4
	local var_8_5

	self._seed, var_8_5 = fn_2(self._seed, self._spawnable_breeds)

	local var_8_6 = Breeds[var_8_5]
	local var_8_7 = Vector3Box(flag)
	local var_8_8 = QuaternionBox(local_rotation)
	local str = "misc"
	local str_2 = "terror_event"
	local tbl = {
		spawned_func = self._cb_unit_spawned_function
	}

	self._conflict_director:spawn_queued_unit(var_8_6, var_8_7, var_8_8, str, nil, str_2, tbl)
	Managers.state.event:trigger("spawned_timed_breed", _unit)
end

TimedSpawnerExtension.rpc_on_timed_spawn = function (self, arg_9_1, arg_9_2)
	-- function 9
	local unit = self._unit_storage:unit(arg_9_2)

	if unit ~= self._unit then
		return
	end

	Unit.flow_event(unit, "on_timed_spawn")
end

TimedSpawnerExtension.get_spawn_rate = function (self)
	-- function 10
	return self._spawn_rate
end

TimedSpawnerExtension.get_spawnable_breeds = function (self)
	-- function 11
	return self._spawnable_breeds
end

TimedSpawnerExtension.get_max_spawn_amount = function (self)
	-- function 12
	return self._max_spawn_amount
end
