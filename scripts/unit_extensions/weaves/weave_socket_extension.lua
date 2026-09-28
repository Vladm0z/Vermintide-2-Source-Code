-- chunkname: @scripts/unit_extensions/weaves/weave_socket_extension.lua

WeaveSocketExtension = class(WeaveSocketExtension, BaseObjectiveExtension)
WeaveSocketExtension.NAME = "WeaveSocketExtension"

WeaveSocketExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	WeaveSocketExtension.super.init(self, extension_init_context, unit, extension_init_data)

	self._value = 0
	self._is_done = false
	self.keep_alive = true
	self._num_sockets = 0
	self._num_closed_sockets = 0
end

WeaveSocketExtension.extensions_ready = function (self)
	-- function 2
	self._objective_socket_extension = ScriptUnit.has_extension(self._unit, "objective_socket_system")

	if self._objective_socket_extension then
		self._objective_socket_extension.distance = math.huge
		self._num_sockets = self._objective_socket_extension.num_sockets
	end
end

WeaveSocketExtension.display_name = function (self)
	-- function 3
	return "objective_sockets_name_single"
end

WeaveSocketExtension.initial_sync_data = function (self, game_object_data_table)
	-- function 4
	game_object_data_table.value = self:get_percentage_done()
end

WeaveSocketExtension._set_objective_data = function (self, objective_data)
	-- function 5
	self._on_start_func = objective_data.on_start_func
	self._on_progress_func = objective_data.on_progress_func
	self._on_complete_func = objective_data.on_complete_func
end

WeaveSocketExtension._activate = function (self)
	-- function 6
	Unit.flow_event(self._unit, "enable_socket")
end

WeaveSocketExtension._deactivate = function (self)
	-- function 7
	local position = Unit.local_position(self._unit, 0)

	for i = 1, 15 do
		local x_offset = math.random(-10, 10) / 10
		local y_offset = math.random(-10, 10) / 10
		local z_offset = math.random(-10, 10) / 10
		local objective_system = Managers.state.entity:system("objective_system")
		local weave_essence_handler = objective_system:weave_essence_handler()

		weave_essence_handler:spawn_essence_unit(position + Vector3(0, 0, 0.5) + Vector3(x_offset, y_offset, z_offset))
	end
end

WeaveSocketExtension.is_done = function (self)
	-- function 8
	return self._is_done
end

WeaveSocketExtension._server_update = function (self, dt, t)
	-- function 9
	local num_closed_sockets = self._objective_socket_extension.num_closed_sockets

	if num_closed_sockets > self._num_closed_sockets then
		self._num_closed_sockets = num_closed_sockets

		if self._on_start_func then
			self._on_start_func(self._unit)

			self._on_start_func = nil
		end

		if self._on_progress_func then
			self._on_progress_func(self._unit, num_closed_sockets, self._num_sockets)
		end

		self:server_set_value(self:get_percentage_done())

		if num_closed_sockets >= self._num_sockets then
			self._is_done = true
		end
	end
end

WeaveSocketExtension._client_update = function (self, dt, t)
	-- function 10
	return
end

WeaveSocketExtension.get_percentage_done = function (self)
	-- function 11
	if self._num_sockets == 0 then
		return 0
	end

	return math.clamp01(self._num_closed_sockets / self._num_sockets)
end
