-- chunkname: @scripts/unit_extensions/weaves/weave_doom_wheel_extension.lua

WeaveDoomWheelExtension = class(WeaveDoomWheelExtension, BaseObjectiveExtension)
WeaveDoomWheelExtension.NAME = "WeaveDoomWheelExtension"

WeaveDoomWheelExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	WeaveDoomWheelExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._is_done = false
	self._num_sockets = 0
	self._num_closed_sockets = 0
	self._on_socket_start_func = arg_1_3.on_socket_start_func
	self._on_socket_progress_func = arg_1_3.on_socket_progress_func
	self._on_socket_complete_func = arg_1_3.on_socket_complete_func
	self._on_fuze_start_func = arg_1_3.on_fuze_start_func
	self._on_fuze_progress_func = arg_1_3.on_fuze_progress_func
	self._on_fuze_complete_func = arg_1_3.on_fuze_complete_func

	local timer = arg_1_3.timer

	timer = timer or 10
	self._max_timer = timer
	self._timer = self._max_timer
	self.keep_alive = true

	local terror_event_spawner_id = arg_1_3.terror_event_spawner_id

	Unit.set_data(arg_1_2, "terror_event_spawner_id", terror_event_spawner_id)
end

WeaveDoomWheelExtension.extensions_ready = function (self)
	-- function 2
	self._objective_socket_extension = ScriptUnit.has_extension(self._unit, "objective_socket_system")

	if not self._objective_socket_extension then
		self._objective_socket_extension.distance = math.huge
		self._num_sockets = self._objective_socket_extension.num_sockets
	end
end

WeaveDoomWheelExtension.display_name = function (arg_3_0)
	-- function 3
	return "objective_destroy_doom_wheels_name_single"
end

WeaveDoomWheelExtension.initial_sync_data = function (self, arg_4_1)
	-- function 4
	arg_4_1.value = self:get_percentage_done()
end

WeaveDoomWheelExtension._set_objective_data = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

WeaveDoomWheelExtension._activate = function (arg_6_0)
	-- function 6
	return
end

WeaveDoomWheelExtension.complete = function (self, ...)
	-- function 7
	if not self._on_fuze_complete_func then
		self._on_fuze_complete_func(self._unit)
	end

	WeaveDoomWheelExtension.super.complete(self, ...)
end

WeaveDoomWheelExtension._deactivate = function (self)
	-- function 8
	Unit.flow_event(self._unit, "force_destroy")

	local local_position = Unit.local_position(self._unit, 0)

	for i = 1, 15 do
		local num = math.random(-10, 10) / 10
		local num_2 = math.random(-10, 10) / 10
		local num_3 = math.random(-10, 10) / 10

		Managers.state.entity:system("objective_system"):weave_essence_handler():spawn_essence_unit(local_position + Vector3(0, 0, 0.5) + Vector3(num, num_2, num_3))
	end
end

WeaveDoomWheelExtension._server_update = function (self, arg_9_1, arg_9_2)
	-- function 9
	local num_closed_sockets = self._objective_socket_extension.num_closed_sockets

	if num_closed_sockets > self._num_closed_sockets then
		self._num_closed_sockets = num_closed_sockets

		if not self._on_socket_start_func then
			self._on_socket_start_func(self._unit)

			self._on_socket_start_func = nil
		end

		if not self._on_socket_progress_func then
			self._on_socket_progress_func(self._unit, num_closed_sockets, self._num_sockets)
		end

		self:server_set_value(self:get_percentage_done())
	end

	if num_closed_sockets >= self._num_sockets then
		if not self._on_socket_complete_func then
			self._on_socket_complete_func(self._unit)

			self._on_socket_complete_func = nil
		end

		if self._timer <= 0 then
			self._is_done = true
		else
			self._timer = self._timer - arg_9_1

			if not self._on_fuze_start_func then
				self._on_fuze_start_func(self._unit)

				self._on_fuze_start_func = nil
			end

			if not self._on_fuze_progress_func then
				self._on_fuze_progress_func(self._unit, self._timer, self._max_timer)
			end

			self:server_set_value(self:get_percentage_done())
		end
	end
end

WeaveDoomWheelExtension._client_update = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

WeaveDoomWheelExtension.is_done = function (self)
	-- function 11
	return self._is_done
end

WeaveDoomWheelExtension.get_percentage_done = function (self)
	-- function 12
	if self._num_sockets == 0 then
		return 0
	end

	local num = self._num_closed_sockets / self._num_sockets
	local num_2 = 1 - self._timer / self._max_timer

	return math.clamp((num + num_2) / 2, 0, 1)
end
