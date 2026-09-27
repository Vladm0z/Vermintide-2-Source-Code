-- chunkname: @scripts/network/network_event_delegate.lua

NetworkEventDelegate = class(NetworkEventDelegate)

local var_0_0 = getmetatable(NetworkEventDelegate)

local function fn()
	-- function 1
	return
end

local function fn_2()
	-- function 2
	return false
end

NetworkEventDelegate.init = function (self)
	-- function 3
	self._registered_objects = {}

	local tbl = {
		__index = function (arg_4_0, arg_4_1)
			-- function 4
			if arg_4_1 == "approve_channel" then
				return fn_2
			end

			visual_assert(false, "RPC not registered %q", arg_4_1)
			printf("RPC not registered %q", arg_4_1)

			return fn
		end
	}

	self.event_table = setmetatable({}, tbl)
	self._return_objects = {}
end

NetworkEventDelegate.register = function (self, arg_5_1, ...)
	-- function 5
	for i = 1, select("#", ...) do
		local var_5_0 = select(i, ...)

		fassert(arg_5_1[var_5_0], "[NetworkEventDelegate]: No callback function with name %q specified in passed object", var_5_0)

		local _registered_objects = self._registered_objects
		local var_5_2 = self._registered_objects[var_5_0]

		var_5_2 = var_5_2 or {}
		_registered_objects[var_5_0] = var_5_2
		self._registered_objects[var_5_0][#self._registered_objects[var_5_0] + 1] = arg_5_1

		if rawget(self.event_table, var_5_0) == nil then
			local function fn(arg_6_0, ...)
				-- function 6
				local var_6_0 = self._registered_objects[var_5_0]
				local count = #var_6_0

				for i = 1, count do
					local var_6_2 = var_6_0[i]

					var_6_2[var_5_0](var_6_2, ...)
				end
			end

			self.event_table[var_5_0] = fn
		end
	end
end

NetworkEventDelegate.register_with_return = function (self, arg_7_1, arg_7_2)
	-- function 7
	fassert(arg_7_1[arg_7_2], "[NetworkEventDelegate]: No callback function with name %q specified in passed object", arg_7_2)
	fassert(self._return_objects[arg_7_2] == nil, "[NetworkEventDelegate]: Can only register one of these", arg_7_2)

	self._return_objects[arg_7_2] = arg_7_1

	if rawget(self.event_table, arg_7_2) == nil then
		local function fn(arg_8_0, ...)
			-- function 8
			local var_8_0 = self._return_objects[arg_7_2]

			return var_8_0[arg_7_2](var_8_0, ...)
		end

		self.event_table[arg_7_2] = fn
	end
end

NetworkEventDelegate.unregister = function (self, arg_9_1)
	-- function 9
	for k, v in pairs(self._registered_objects) do
		local count = #v
		local var_9_1

		for k_2 = count, 1, -1 do
			if arg_9_1 == v[k_2] then
				table.remove(v, k_2)

				var_9_1 = true
			end
		end

		if #v ~= 0 or not var_9_1 then
			assert(rawget(self.event_table, k))

			self.event_table[k] = nil
		end
	end

	for k_3, v_2 in pairs(self._return_objects) do
		if arg_9_1 == v_2 then
			self._return_objects[k_3] = nil
		end
	end
end

NetworkEventDelegate.unregister_callback = function (arg_10_0, arg_10_1)
	-- function 10
	arg_10_0._registered_objects[arg_10_1] = nil
end

NetworkEventDelegate._cleanup = function (self)
	-- function 11
	for k, v in pairs(self._registered_objects) do
		local count = #v

		fassert(count == 0, "[NetworkEventDelegate]: Object(s) not unregistered at cleanup for callback_name: %q", k)

		self.event_table[k] = nil
	end

	self._registered_objects = nil
end

NetworkEventDelegate.destroy = function (self)
	-- function 12
	self:_cleanup()

	self.event_table = nil

	GarbageLeakDetector.register_object(self, "NetworkEventDelegate")
end
