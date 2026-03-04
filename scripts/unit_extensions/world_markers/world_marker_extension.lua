-- chunkname: @scripts/unit_extensions/world_markers/world_marker_extension.lua

WorldMarkerExtension = class(WorldMarkerExtension)

WorldMarkerExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._unit = arg_1_2
	arg_1_0._visible = false
	arg_1_0._id = nil
	arg_1_0._event_manager = Managers.state.event
	arg_1_0._marker_type = nil
	arg_1_0._add_event_name = nil
	arg_1_0._remove_event_name = nil
end

WorldMarkerExtension.extensions_ready = function (arg_2_0)
	if arg_2_0._extensions_ready then
		arg_2_0:_extensions_ready()
	end
end

WorldMarkerExtension.destroy = function (arg_3_0)
	if arg_3_0._destroy then
		arg_3_0:_destroy()
	end

	arg_3_0:remove_marker()
end

WorldMarkerExtension.add_marker = function (arg_4_0, arg_4_1)
	if arg_4_0._adding_marker then
		return
	end

	arg_4_0:remove_marker()

	arg_4_0._adding_marker = true

	local var_4_0 = callback(arg_4_0, "cb_add_marker", arg_4_1)

	arg_4_0:_add_marker(var_4_0)
end

WorldMarkerExtension.remove_marker = function (arg_5_0)
	local var_5_0 = arg_5_0._id

	if var_5_0 then
		local var_5_1 = arg_5_0._event_manager
		local var_5_2 = arg_5_0._remove_event_name

		var_5_1:trigger(var_5_2, var_5_0)

		arg_5_0._id = nil
	elseif arg_5_0._adding_marker then
		arg_5_0._remove_marker_queued = true
	end
end

WorldMarkerExtension.hot_join_sync = function (arg_6_0, arg_6_1)
	if arg_6_0._hot_join_sync then
		arg_6_0:_hot_join_sync(arg_6_1)
	end
end

WorldMarkerExtension.cb_add_marker = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._id = arg_7_2
	arg_7_0._adding_marker = false

	if arg_7_1 then
		arg_7_1(arg_7_2)
	end

	if arg_7_0._remove_marker_queued then
		arg_7_0._remove_marker_queued = nil

		arg_7_0:remove_marker()
	end
end
