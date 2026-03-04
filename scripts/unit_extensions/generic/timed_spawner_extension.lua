-- chunkname: @scripts/unit_extensions/generic/timed_spawner_extension.lua

TimedSpawnerExtension = class(TimedSpawnerExtension)

local var_0_0 = true
local var_0_1 = {
	"rpc_on_timed_spawn"
}

local function var_0_2(arg_1_0, arg_1_1)
	return LocomotionUtils.pos_on_mesh(arg_1_0, arg_1_1, 1, 1) or GwNavQueries.inside_position_from_outside_position(arg_1_0, arg_1_1, 6, 6, 8, 0.5)
end

local function var_0_3(arg_2_0, arg_2_1)
	local var_2_0, var_2_1 = Math.next_random(arg_2_0, 1, #arg_2_1)

	return var_2_0, arg_2_1[var_2_1]
end

TimedSpawnerExtension.init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0._is_server = arg_3_1.is_server
	arg_3_0._world = arg_3_1.world
	arg_3_0._unit = arg_3_2
	arg_3_0._network_manager = Managers.state.network
	arg_3_0._conflict_director = Managers.state.conflict
	arg_3_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
	arg_3_0._unit_storage = arg_3_1.unit_storage
	arg_3_0.network_transmit = arg_3_1.network_transmit
	arg_3_0.network_event_delegate = arg_3_0.network_transmit.network_event_delegate

	arg_3_0.network_event_delegate:register(arg_3_0, unpack(var_0_1))

	arg_3_0._spawn_rate = arg_3_3.spawn_rate
	arg_3_0._spawnable_breeds = arg_3_3.spawnable_breeds
	arg_3_0._max_spawn_amount = arg_3_3.max_spawn_amount
	arg_3_0._cb_unit_spawned_function = arg_3_3.cb_unit_spawned_function
	arg_3_0._seed = Managers.mechanism:get_level_seed()
	arg_3_0._timer = arg_3_0._network_manager:network_time() + arg_3_0._spawn_rate
	arg_3_0._spawn_amount = 0
end

TimedSpawnerExtension.extensions_ready = function (arg_4_0, arg_4_1, arg_4_2)
	return
end

TimedSpawnerExtension.destroy = function (arg_5_0)
	if arg_5_0.network_event_delegate then
		arg_5_0.network_event_delegate:unregister(arg_5_0)

		arg_5_0.network_event_delegate = nil
	end
end

TimedSpawnerExtension._can_spawn = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._spawn_amount >= arg_6_0._max_spawn_amount
	local var_6_1 = arg_6_1 >= arg_6_0._timer

	return not var_6_0 and var_6_1
end

TimedSpawnerExtension.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	if not arg_7_0._is_server then
		return
	end

	local var_7_0 = arg_7_0._network_manager:network_time()

	if arg_7_0:_can_spawn(var_7_0) then
		arg_7_0:_spawn_breed()

		local var_7_1 = arg_7_0._unit_storage:go_id(arg_7_1)

		arg_7_0:rpc_on_timed_spawn(Network.peer_id(), var_7_1)
		arg_7_0.network_transmit:send_rpc_clients("rpc_on_timed_spawn", var_7_1)

		arg_7_0._spawn_amount = arg_7_0._spawn_amount + 1
		arg_7_0._timer = var_7_0 + arg_7_0._spawn_rate
	end

	local var_7_2 = arg_7_0._spawn_amount >= arg_7_0._max_spawn_amount

	if var_0_0 and var_7_2 then
		Managers.state.unit_spawner:mark_for_deletion(arg_7_1)
	end
end

TimedSpawnerExtension._spawn_breed = function (arg_8_0)
	local var_8_0 = arg_8_0._unit
	local var_8_1 = POSITION_LOOKUP[var_8_0]
	local var_8_2 = var_8_1 and var_0_2(arg_8_0._nav_world, var_8_1)

	if not var_8_1 then
		return
	end

	local var_8_3 = Unit.local_rotation(var_8_0, 0)
	local var_8_4
	local var_8_5

	arg_8_0._seed, var_8_5 = var_0_3(arg_8_0._seed, arg_8_0._spawnable_breeds)

	local var_8_6 = Breeds[var_8_5]
	local var_8_7 = Vector3Box(var_8_2)
	local var_8_8 = QuaternionBox(var_8_3)
	local var_8_9 = "misc"
	local var_8_10 = "terror_event"
	local var_8_11 = {
		spawned_func = arg_8_0._cb_unit_spawned_function
	}

	arg_8_0._conflict_director:spawn_queued_unit(var_8_6, var_8_7, var_8_8, var_8_9, nil, var_8_10, var_8_11)
	Managers.state.event:trigger("spawned_timed_breed", var_8_0)
end

TimedSpawnerExtension.rpc_on_timed_spawn = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._unit_storage:unit(arg_9_2)

	if var_9_0 ~= arg_9_0._unit then
		return
	end

	Unit.flow_event(var_9_0, "on_timed_spawn")
end

TimedSpawnerExtension.get_spawn_rate = function (arg_10_0)
	return arg_10_0._spawn_rate
end

TimedSpawnerExtension.get_spawnable_breeds = function (arg_11_0)
	return arg_11_0._spawnable_breeds
end

TimedSpawnerExtension.get_max_spawn_amount = function (arg_12_0)
	return arg_12_0._max_spawn_amount
end
