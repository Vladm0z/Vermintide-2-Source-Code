-- chunkname: @scripts/ui/views/deus_menu/deus_map_view.lua

local require = require
local flag

flag = not script_data.FEATURE_old_map_ui and "scripts/ui/views/deus_menu/deus_map_ui" and "scripts/ui/views/deus_menu/deus_map_ui_v2"

require(flag)
require("scripts/ui/views/deus_menu/deus_map_scene")

local num = 1

DeusMapView = class(DeusMapView)

local str = "deus_map_input_service_name"

DeusMapView.init = function (self, arg_1_1)
	-- function 1
	self._ui = DeusMapUI:new(arg_1_1)
	self._scene = DeusMapScene:new()
	self._active = false
	self._deus_run_controller = arg_1_1.deus_run_controller

	local input_manager = arg_1_1.input_manager

	self._input_manager = input_manager
	self._network_event_delegate = arg_1_1.network_event_delegate

	input_manager:create_input_service(str, "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service(str, "keyboard")
	input_manager:map_device_to_service(str, "mouse")
	input_manager:map_device_to_service(str, "gamepad")
end

DeusMapView.start = function (self, arg_2_1)
	-- function 2
	fassert(arg_2_1, "DeusMapView needs params to be set in order to function properly, see GameModeMapDeus")

	self._finish_cb = arg_2_1.finish_cb
	self._active = true

	local _input_manager = self._input_manager

	_input_manager:capture_input({
		"mouse"
	}, 1, str, "DeusMapView")
	ShowCursorStack.show("DeusMapView")
	_input_manager:enable_gamepad_cursor()

	local get_service = _input_manager:get_service(str)

	self._scene:on_enter(self._deus_run_controller:get_graph_data(), get_service, callback(self, "_node_pressed"), callback(self, "_node_hovered"), callback(self, "_node_unhovered"))
	self._ui:on_enter(get_service)
	self:_start()
end

DeusMapView._finish = function (self)
	-- function 3
	local _input_manager = self._input_manager

	_input_manager:release_input({
		"mouse"
	}, 1, str, "DeusMapView")
	ShowCursorStack.hide("DeusMapView")
	_input_manager:disable_gamepad_cursor()

	self._active = false

	self._scene:on_finish()
end

DeusMapView.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._active then
		self:_update(arg_4_1, arg_4_2)
	end

	self._ui:update(arg_4_1, arg_4_2)
	self._scene:update(arg_4_1, arg_4_2, Managers.input:is_device_active("gamepad"))
end

DeusMapView.post_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._scene:post_update(arg_5_1, arg_5_2)
end

DeusMapView.input_service = function (self)
	-- function 6
	return self._input_manager:get_service(str)
end

DeusMapView.is_active = function (self)
	-- function 7
	return self._active
end

DeusMapView.destroy = function (self)
	-- function 8
	if not self._active then
		self:_finish()
	end

	self._scene:destroy()
	self._ui:destroy()
end

DeusMapView.register_rpcs = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not arg_9_1 then
		local _get_rpcs = self._get_rpcs

		_get_rpcs = not _get_rpcs and self:_get_rpcs()

		if not _get_rpcs then
			arg_9_1:register(self, unpack(_get_rpcs))
		end
	end
end

DeusMapView.unregister_rpcs = function (self)
	-- function 10
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)
	end
end

DeusMapView._start = function (arg_11_0, arg_11_1)
	-- function 11
	return
end

DeusMapView._update = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	return
end

DeusMapView._get_rpcs = function (arg_13_0)
	-- function 13
	return
end

DeusMapView._node_pressed = function (arg_14_0, arg_14_1)
	-- function 14
	return
end

DeusMapView._node_hovered = function (arg_15_0, arg_15_1)
	-- function 15
	return
end

DeusMapView._node_unhovered = function (arg_16_0)
	-- function 16
	return
end
