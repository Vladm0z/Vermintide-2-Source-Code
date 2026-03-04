-- chunkname: @scripts/unit_extensions/weaves/weave_doom_wheel_extension.lua

WeaveDoomWheelExtension = class(WeaveDoomWheelExtension, BaseObjectiveExtension)
WeaveDoomWheelExtension.NAME = "WeaveDoomWheelExtension"

WeaveDoomWheelExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	WeaveDoomWheelExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._is_done = false
	arg_1_0._num_sockets = 0
	arg_1_0._num_closed_sockets = 0
	arg_1_0._on_socket_start_func = arg_1_3.on_socket_start_func
	arg_1_0._on_socket_progress_func = arg_1_3.on_socket_progress_func
	arg_1_0._on_socket_complete_func = arg_1_3.on_socket_complete_func
	arg_1_0._on_fuze_start_func = arg_1_3.on_fuze_start_func
	arg_1_0._on_fuze_progress_func = arg_1_3.on_fuze_progress_func
	arg_1_0._on_fuze_complete_func = arg_1_3.on_fuze_complete_func
	arg_1_0._max_timer = arg_1_3.timer or 10
	arg_1_0._timer = arg_1_0._max_timer
	arg_1_0.keep_alive = true

	local var_1_0 = arg_1_3.terror_event_spawner_id

	Unit.set_data(arg_1_2, "terror_event_spawner_id", var_1_0)
end

WeaveDoomWheelExtension.extensions_ready = function (arg_2_0)
	arg_2_0._objective_socket_extension = ScriptUnit.has_extension(arg_2_0._unit, "objective_socket_system")

	if arg_2_0._objective_socket_extension then
		arg_2_0._objective_socket_extension.distance = math.huge
		arg_2_0._num_sockets = arg_2_0._objective_socket_extension.num_sockets
	end
end

WeaveDoomWheelExtension.display_name = function (arg_3_0)
	return "objective_destroy_doom_wheels_name_single"
end

WeaveDoomWheelExtension.initial_sync_data = function (arg_4_0, arg_4_1)
	arg_4_1.value = arg_4_0:get_percentage_done()
end

WeaveDoomWheelExtension._set_objective_data = function (arg_5_0, arg_5_1)
	return
end

WeaveDoomWheelExtension._activate = function (arg_6_0)
	return
end

WeaveDoomWheelExtension.complete = function (arg_7_0, ...)
	if arg_7_0._on_fuze_complete_func then
		arg_7_0._on_fuze_complete_func(arg_7_0._unit)
	end

	WeaveDoomWheelExtension.super.complete(arg_7_0, ...)
end

WeaveDoomWheelExtension._deactivate = function (arg_8_0)
	Unit.flow_event(arg_8_0._unit, "force_destroy")

	local var_8_0 = Unit.local_position(arg_8_0._unit, 0)

	for iter_8_0 = 1, 15 do
		local var_8_1 = math.random(-10, 10) / 10
		local var_8_2 = math.random(-10, 10) / 10
		local var_8_3 = math.random(-10, 10) / 10

		Managers.state.entity:system("objective_system"):weave_essence_handler():spawn_essence_unit(var_8_0 + Vector3(0, 0, 0.5) + Vector3(var_8_1, var_8_2, var_8_3))
	end
end

WeaveDoomWheelExtension._server_update = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._objective_socket_extension.num_closed_sockets

	if var_9_0 > arg_9_0._num_closed_sockets then
		arg_9_0._num_closed_sockets = var_9_0

		if arg_9_0._on_socket_start_func then
			arg_9_0._on_socket_start_func(arg_9_0._unit)

			arg_9_0._on_socket_start_func = nil
		end

		if arg_9_0._on_socket_progress_func then
			arg_9_0._on_socket_progress_func(arg_9_0._unit, var_9_0, arg_9_0._num_sockets)
		end

		arg_9_0:server_set_value(arg_9_0:get_percentage_done())
	end

	if var_9_0 >= arg_9_0._num_sockets then
		if arg_9_0._on_socket_complete_func then
			arg_9_0._on_socket_complete_func(arg_9_0._unit)

			arg_9_0._on_socket_complete_func = nil
		end

		if arg_9_0._timer <= 0 then
			arg_9_0._is_done = true
		else
			arg_9_0._timer = arg_9_0._timer - arg_9_1

			if arg_9_0._on_fuze_start_func then
				arg_9_0._on_fuze_start_func(arg_9_0._unit)

				arg_9_0._on_fuze_start_func = nil
			end

			if arg_9_0._on_fuze_progress_func then
				arg_9_0._on_fuze_progress_func(arg_9_0._unit, arg_9_0._timer, arg_9_0._max_timer)
			end

			arg_9_0:server_set_value(arg_9_0:get_percentage_done())
		end
	end
end

WeaveDoomWheelExtension._client_update = function (arg_10_0, arg_10_1, arg_10_2)
	return
end

WeaveDoomWheelExtension.is_done = function (arg_11_0)
	return arg_11_0._is_done
end

WeaveDoomWheelExtension.get_percentage_done = function (arg_12_0)
	if arg_12_0._num_sockets == 0 then
		return 0
	end

	local var_12_0 = arg_12_0._num_closed_sockets / arg_12_0._num_sockets
	local var_12_1 = 1 - arg_12_0._timer / arg_12_0._max_timer

	return math.clamp((var_12_0 + var_12_1) / 2, 0, 1)
end
