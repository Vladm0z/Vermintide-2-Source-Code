-- chunkname: @scripts/ui/views/deus_menu/deus_map_view.lua

require(script_data.FEATURE_old_map_ui and "scripts/ui/views/deus_menu/deus_map_ui" or "scripts/ui/views/deus_menu/deus_map_ui_v2")
require("scripts/ui/views/deus_menu/deus_map_scene")

local var_0_0 = 1

DeusMapView = class(DeusMapView)

local var_0_1 = "deus_map_input_service_name"

DeusMapView.init = function (arg_1_0, arg_1_1)
	arg_1_0._ui = DeusMapUI:new(arg_1_1)
	arg_1_0._scene = DeusMapScene:new()
	arg_1_0._active = false
	arg_1_0._deus_run_controller = arg_1_1.deus_run_controller

	local var_1_0 = arg_1_1.input_manager

	arg_1_0._input_manager = var_1_0
	arg_1_0._network_event_delegate = arg_1_1.network_event_delegate

	var_1_0:create_input_service(var_0_1, "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_0:map_device_to_service(var_0_1, "keyboard")
	var_1_0:map_device_to_service(var_0_1, "mouse")
	var_1_0:map_device_to_service(var_0_1, "gamepad")
end

DeusMapView.start = function (arg_2_0, arg_2_1)
	fassert(arg_2_1, "DeusMapView needs params to be set in order to function properly, see GameModeMapDeus")

	arg_2_0._finish_cb = arg_2_1.finish_cb
	arg_2_0._active = true

	local var_2_0 = arg_2_0._input_manager

	var_2_0:capture_input({
		"mouse"
	}, 1, var_0_1, "DeusMapView")
	ShowCursorStack.show("DeusMapView")
	var_2_0:enable_gamepad_cursor()

	local var_2_1 = var_2_0:get_service(var_0_1)

	arg_2_0._scene:on_enter(arg_2_0._deus_run_controller:get_graph_data(), var_2_1, callback(arg_2_0, "_node_pressed"), callback(arg_2_0, "_node_hovered"), callback(arg_2_0, "_node_unhovered"))
	arg_2_0._ui:on_enter(var_2_1)
	arg_2_0:_start()
end

DeusMapView._finish = function (arg_3_0)
	local var_3_0 = arg_3_0._input_manager

	var_3_0:release_input({
		"mouse"
	}, 1, var_0_1, "DeusMapView")
	ShowCursorStack.hide("DeusMapView")
	var_3_0:disable_gamepad_cursor()

	arg_3_0._active = false

	arg_3_0._scene:on_finish()
end

DeusMapView.update = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._active then
		arg_4_0:_update(arg_4_1, arg_4_2)
	end

	arg_4_0._ui:update(arg_4_1, arg_4_2)
	arg_4_0._scene:update(arg_4_1, arg_4_2, Managers.input:is_device_active("gamepad"))
end

DeusMapView.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._scene:post_update(arg_5_1, arg_5_2)
end

DeusMapView.input_service = function (arg_6_0)
	return arg_6_0._input_manager:get_service(var_0_1)
end

DeusMapView.is_active = function (arg_7_0)
	return arg_7_0._active
end

DeusMapView.destroy = function (arg_8_0)
	if arg_8_0._active then
		arg_8_0:_finish()
	end

	arg_8_0._scene:destroy()
	arg_8_0._ui:destroy()
end

DeusMapView.register_rpcs = function (arg_9_0, arg_9_1, arg_9_2)
	if arg_9_1 then
		local var_9_0 = arg_9_0._get_rpcs and arg_9_0:_get_rpcs()

		if var_9_0 then
			arg_9_1:register(arg_9_0, unpack(var_9_0))
		end
	end
end

DeusMapView.unregister_rpcs = function (arg_10_0)
	if arg_10_0._network_event_delegate then
		arg_10_0._network_event_delegate:unregister(arg_10_0)
	end
end

DeusMapView._start = function (arg_11_0, arg_11_1)
	return
end

DeusMapView._update = function (arg_12_0, arg_12_1, arg_12_2)
	return
end

DeusMapView._get_rpcs = function (arg_13_0)
	return
end

DeusMapView._node_pressed = function (arg_14_0, arg_14_1)
	return
end

DeusMapView._node_hovered = function (arg_15_0, arg_15_1)
	return
end

DeusMapView._node_unhovered = function (arg_16_0)
	return
end
