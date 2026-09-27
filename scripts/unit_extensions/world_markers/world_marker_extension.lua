-- chunkname: @scripts/unit_extensions/world_markers/world_marker_extension.lua

WorldMarkerExtension = class(WorldMarkerExtension)

WorldMarkerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._unit = arg_1_2
	self._visible = false
	self._id = nil
	self._event_manager = Managers.state.event
	self._marker_type = nil
	self._add_event_name = nil
	self._remove_event_name = nil
end

WorldMarkerExtension.extensions_ready = function (self)
	-- function 2
	if not self._extensions_ready then
		self:_extensions_ready()
	end
end

WorldMarkerExtension.destroy = function (self)
	-- function 3
	if not self._destroy then
		self:_destroy()
	end

	self:remove_marker()
end

WorldMarkerExtension.add_marker = function (self, arg_4_1)
	-- function 4
	if not self._adding_marker then
		return
	end

	self:remove_marker()

	self._adding_marker = true

	local var_4_0 = callback(self, "cb_add_marker", arg_4_1)

	self:_add_marker(var_4_0)
end

WorldMarkerExtension.remove_marker = function (self)
	-- function 5
	local _id = self._id

	if not _id then
		local _event_manager = self._event_manager
		local _remove_event_name = self._remove_event_name

		_event_manager:trigger(_remove_event_name, _id)

		self._id = nil
	elseif not self._adding_marker then
		self._remove_marker_queued = true
	end
end

WorldMarkerExtension.hot_join_sync = function (self, arg_6_1)
	-- function 6
	if not self._hot_join_sync then
		self:_hot_join_sync(arg_6_1)
	end
end

WorldMarkerExtension.cb_add_marker = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._id = arg_7_2
	self._adding_marker = false

	if not arg_7_1 then
		arg_7_1(arg_7_2)
	end

	if not self._remove_marker_queued then
		self._remove_marker_queued = nil

		self:remove_marker()
	end
end
