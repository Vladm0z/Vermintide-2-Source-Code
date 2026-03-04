-- chunkname: @scripts/unit_extensions/weaves/weave_socket_extension.lua

WeaveSocketExtension = class(WeaveSocketExtension, BaseObjectiveExtension)
WeaveSocketExtension.NAME = "WeaveSocketExtension"

WeaveSocketExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	WeaveSocketExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._value = 0
	arg_1_0._is_done = false
	arg_1_0.keep_alive = true
	arg_1_0._num_sockets = 0
	arg_1_0._num_closed_sockets = 0
end

WeaveSocketExtension.extensions_ready = function (arg_2_0)
	arg_2_0._objective_socket_extension = ScriptUnit.has_extension(arg_2_0._unit, "objective_socket_system")

	if arg_2_0._objective_socket_extension then
		arg_2_0._objective_socket_extension.distance = math.huge
		arg_2_0._num_sockets = arg_2_0._objective_socket_extension.num_sockets
	end
end

WeaveSocketExtension.display_name = function (arg_3_0)
	return "objective_sockets_name_single"
end

WeaveSocketExtension.initial_sync_data = function (arg_4_0, arg_4_1)
	arg_4_1.value = arg_4_0:get_percentage_done()
end

WeaveSocketExtension._set_objective_data = function (arg_5_0, arg_5_1)
	arg_5_0._on_start_func = arg_5_1.on_start_func
	arg_5_0._on_progress_func = arg_5_1.on_progress_func
	arg_5_0._on_complete_func = arg_5_1.on_complete_func
end

WeaveSocketExtension._activate = function (arg_6_0)
	Unit.flow_event(arg_6_0._unit, "enable_socket")
end

WeaveSocketExtension._deactivate = function (arg_7_0)
	local var_7_0 = Unit.local_position(arg_7_0._unit, 0)

	for iter_7_0 = 1, 15 do
		local var_7_1 = math.random(-10, 10) / 10
		local var_7_2 = math.random(-10, 10) / 10
		local var_7_3 = math.random(-10, 10) / 10

		Managers.state.entity:system("objective_system"):weave_essence_handler():spawn_essence_unit(var_7_0 + Vector3(0, 0, 0.5) + Vector3(var_7_1, var_7_2, var_7_3))
	end
end

WeaveSocketExtension.is_done = function (arg_8_0)
	return arg_8_0._is_done
end

WeaveSocketExtension._server_update = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._objective_socket_extension.num_closed_sockets

	if var_9_0 > arg_9_0._num_closed_sockets then
		arg_9_0._num_closed_sockets = var_9_0

		if arg_9_0._on_start_func then
			arg_9_0._on_start_func(arg_9_0._unit)

			arg_9_0._on_start_func = nil
		end

		if arg_9_0._on_progress_func then
			arg_9_0._on_progress_func(arg_9_0._unit, var_9_0, arg_9_0._num_sockets)
		end

		arg_9_0:server_set_value(arg_9_0:get_percentage_done())

		if var_9_0 >= arg_9_0._num_sockets then
			arg_9_0._is_done = true
		end
	end
end

WeaveSocketExtension._client_update = function (arg_10_0, arg_10_1, arg_10_2)
	return
end

WeaveSocketExtension.get_percentage_done = function (arg_11_0)
	if arg_11_0._num_sockets == 0 then
		return 0
	end

	return math.clamp01(arg_11_0._num_closed_sockets / arg_11_0._num_sockets)
end
