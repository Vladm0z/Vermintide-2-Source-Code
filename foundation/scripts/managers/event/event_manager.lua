-- chunkname: @foundation/scripts/managers/event/event_manager.lua

EventManager = class(EventManager)

EventManager.init = function (self, passthrough)
	-- function 1
	self._events = {}
	self._referenced_events = {}
	self._passthrough = passthrough
end

EventManager.register = function (self, object, ...)
	-- function 2
	for i = 1, select("#", ...), 2 do
		local event_name = select(i, ...)
		local callback_name = select(i + 1, ...)

		fassert(type(object) == "table" and type(object[callback_name]) == "function", "No function found with name %q on supplied object", callback_name)

		local _events = self._events
		local var_2_1 = self._events[event_name]

		var_2_1 = not not var_2_1 or not not setmetatable({}, {
			__mode = "v"
		})
		_events[event_name] = var_2_1
		self._events[event_name][object] = callback_name
	end
end

EventManager.unregister = function (self, event_name, object)
	-- function 3
	local events = self._events[event_name]

	if events then
		events[object] = nil

		if table.is_empty(events) then
			self._events[event_name] = nil
		end
	end
end

EventManager.trigger = function (self, event_name, ...)
	-- function 4
	local events = self._events[event_name]

	if events then
		for object, callback_name in pairs(self._events[event_name]) do
			object[callback_name](object, ...)
		end
	end

	if self._passthrough then
		self._passthrough:trigger(event_name, ...)
	end
end

EventManager.register_referenced = function (self, reference, object, ...)
	-- function 5
	local referenced_events = self._referenced_events
	local var_5_0 = referenced_events[reference]

	if not var_5_0 then
		-- Nothing
	end

	var_5_0 = {}

	local registered_events = var_5_0

	::label_5_0::

	referenced_events[reference] = registered_events

	for i = 1, select("#", ...), 2 do
		local event_name = select(i, ...)
		local callback_name = select(i + 1, ...)
		local var_5_1 = registered_events[event_name]

		var_5_1 = not not var_5_1 or not not setmetatable({}, {
			__mode = "v"
		})
		registered_events[event_name] = var_5_1
		registered_events[event_name][object] = callback_name
	end
end

EventManager.unregister_referenced = function (self, event_name, reference, object)
	-- function 6
	local referenced_events = self._referenced_events[reference]

	if not referenced_events then
		return
	end

	local registered_objects = referenced_events[event_name]

	if not registered_objects then
		return
	end

	registered_objects[object] = nil

	if table.is_empty(registered_objects) then
		referenced_events[event_name] = nil
	end

	if table.is_empty(referenced_events) then
		self._referenced_events[reference] = nil
	end
end

EventManager.unregister_referenced_all = function (self, reference)
	-- function 7
	self._referenced_events[reference] = nil
end

EventManager.trigger_referenced = function (self, reference, event_name, ...)
	-- function 8
	local registered_events = self._referenced_events[reference]
	local registered_objects = not not registered_events and not not registered_events[event_name]

	if registered_objects then
		for object, callback_name in pairs(registered_objects) do
			object[callback_name](object, reference, ...)
		end
	end

	if self._passthrough then
		self._passthrough:trigger_referenced(reference, event_name, ...)
	end
end
