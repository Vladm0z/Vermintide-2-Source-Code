-- chunkname: @foundation/scripts/managers/package/package_manager.lua

local function fn(arg_1_0, ...)
	-- function 1
	if not script_data.package_debug then
		print(string.format("[PackageManager] " .. arg_1_0, ...))
	end
end

local PackageManager = PackageManager

PackageManager = PackageManager or {}
PackageManager = PackageManager

PackageManager.init = function (self)
	-- function 2
	self._packages = {}
	self._asynch_packages = {}
	self._references = {}
	self._queued_async_packages = {}
	self._queue_order = {}
	self._delayed_packages_to_remove = {}
end

PackageManager.load = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local var_3_0 = fn
	local str = "Load:  %s, %s, %s, %s"
	local var_3_2 = arg_3_1
	local var_3_3 = arg_3_2
	local flag

	flag = not arg_3_4 and "async-read" and "sync-read"

	local flag_2

	flag_2 = not arg_3_5 and "prioritized" and ""

	var_3_0(str, var_3_2, var_3_3, flag, flag_2)
	assert(arg_3_2 ~= nil, "No reference name passed when loading package")

	self._delayed_packages_to_remove[arg_3_1] = nil

	if not self._references[arg_3_1] then
		local var_3_6 = self._references[arg_3_1]
		local var_3_7 = self._references[arg_3_1][arg_3_2]

		var_3_7 = var_3_7 or 0
		var_3_6[arg_3_2] = var_3_7 + 1

		if arg_3_4 or not self._asynch_packages[arg_3_1] then
			self:force_load(arg_3_1)

			if not arg_3_3 then
				arg_3_3()
			end
		elseif arg_3_4 or not self._queued_async_packages[arg_3_1] then
			self:force_load_queued_package(arg_3_1)

			if not arg_3_3 then
				arg_3_3()
			end
		elseif not self._asynch_packages[arg_3_1] then
			local callbacks = self._asynch_packages[arg_3_1].callbacks

			callbacks[#callbacks + 1] = arg_3_3
		elseif not self._queued_async_packages[arg_3_1] then
			local callbacks_2 = self._queued_async_packages[arg_3_1].callbacks

			callbacks_2[#callbacks_2 + 1] = arg_3_3

			if not arg_3_5 then
				local find = table.find(self._queue_order, arg_3_1)

				table.remove(self._queue_order, find)
				table.insert(self._queue_order, 1, arg_3_1)
			end
		elseif not arg_3_3 then
			arg_3_3()
		end
	else
		assert(self._packages[arg_3_1] == nil, "Package '" .. tostring(arg_3_1) .. "' is already loaded")
		assert(self._asynch_packages[arg_3_1] == nil, "Package '" .. tostring(arg_3_1) .. "' is already being loaded")
		assert(self._queued_async_packages[arg_3_1] == nil, "Package '" .. tostring(arg_3_1) .. "' is already queued")

		self._references[arg_3_1] = {
			[arg_3_2] = 1
		}

		if not next(self._asynch_packages) and not arg_3_4 then
			self._queued_async_packages[arg_3_1] = {
				callbacks = {
					arg_3_3
				}
			}

			if not arg_3_5 then
				table.insert(self._queue_order, 1, arg_3_1)
			else
				self._queue_order[#self._queue_order + 1] = arg_3_1
			end
		elseif not arg_3_4 then
			local resource_package = Application.resource_package(arg_3_1)

			ResourcePackage.load(resource_package)
			ResourcePackage.flush(resource_package)

			self._packages[arg_3_1] = resource_package
		else
			self._asynch_packages[arg_3_1] = {
				callbacks = {
					arg_3_3
				}
			}

			local resource_package_2 = Application.resource_package(arg_3_1)

			ResourcePackage.load(resource_package_2)

			self._asynch_packages[arg_3_1].handle = resource_package_2
		end
	end
end

PackageManager.force_load = function (self, arg_4_1)
	-- function 4
	fn("Force_load:  %s", arg_4_1)

	local _get_async_handle = self:_get_async_handle(arg_4_1, true)

	if not _get_async_handle then
		_get_async_handle = Application.resource_package(arg_4_1)

		ResourcePackage.load(_get_async_handle)
	end

	assert(not self._packages[arg_4_1], "Package %q is already loaded", arg_4_1)
	ResourcePackage.flush(_get_async_handle)

	self._packages[arg_4_1] = _get_async_handle

	local var_4_1 = self._asynch_packages[arg_4_1]

	self._asynch_packages[arg_4_1] = nil

	if not var_4_1.callbacks then
		for i, v in ipairs(var_4_1.callbacks) do
			v()
		end
	end

	self:_pop_queue()
end

PackageManager.force_load_queued_package = function (self, arg_5_1)
	-- function 5
	fn("Force_load_queued_package:  %s", arg_5_1)

	local var_5_0 = self._queued_async_packages[arg_5_1]

	assert(var_5_0, "Package %q is not being loaded", arg_5_1)

	local resource_package = Application.resource_package(arg_5_1)

	ResourcePackage.load(resource_package)
	assert(not self._packages[arg_5_1], "Package %q is already loaded", arg_5_1)
	ResourcePackage.flush(resource_package)

	self._packages[arg_5_1] = resource_package
	self._queued_async_packages[arg_5_1] = nil

	if not var_5_0.callbacks then
		for i, v in ipairs(var_5_0.callbacks) do
			v()
		end
	end

	local find = table.find(self._queue_order, arg_5_1)

	table.remove(self._queue_order, find)
	self:_pop_queue()
end

PackageManager._pop_queue = function (self)
	-- function 6
	local var_6_0
	local num = 1

	while not (not (#self._queue_order > 0) or not (num <= #self._queue_order)) do
		var_6_0 = self._queue_order[num]

		if not self._queued_async_packages[var_6_0] then
			break
		end

		num = num + 1
		var_6_0 = nil
	end

	if not self._queued_async_packages[var_6_0] then
		local var_6_2 = self._queued_async_packages[var_6_0]

		fn("Queueing new asynch package:  %s", var_6_0)

		self._queued_async_packages[var_6_0] = nil
		self._queue_order = table.crop(self._queue_order, num + 1)
		self._asynch_packages[var_6_0] = {
			callbacks = var_6_2.callbacks
		}

		local resource_package = Application.resource_package(var_6_0)

		ResourcePackage.load(resource_package)

		self._asynch_packages[var_6_0].handle = resource_package
	else
		table.clear(self._queue_order)
	end
end

PackageManager.unload = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = self._references[arg_7_1]

	assert(var_7_0[arg_7_2] ~= nil, "[PackageManager] Trying to unload package with unknown reference name")

	local num = var_7_0[arg_7_2] - 1

	if num == 0 then
		var_7_0[arg_7_2] = nil
	else
		var_7_0[arg_7_2] = num
	end

	if not table.is_empty(var_7_0) then
		local _get_async_handle = self:_get_async_handle(arg_7_1, true)

		_get_async_handle = _get_async_handle or self._packages[arg_7_1]

		if not _get_async_handle then
			if not self:can_unload(arg_7_1) then
				ResourcePackage.unload(_get_async_handle)
				Application.release_resource_package(_get_async_handle)

				self._delayed_packages_to_remove[arg_7_1] = nil

				fn("Unload:  %s, %s", arg_7_1, arg_7_2)
			else
				self._delayed_packages_to_remove[arg_7_1] = _get_async_handle

				fn("Delayed Unload of:  %s, %s", arg_7_1, arg_7_2)
			end
		end

		self._packages[arg_7_1] = nil
		self._asynch_packages[arg_7_1] = nil
		self._references[arg_7_1] = nil
		self._queued_async_packages[arg_7_1] = nil

		if not table.is_empty(self._asynch_packages) then
			self:_pop_queue()
		end
	else
		fn("Unload:  %s, %s -> Package still referenced, NOT unloaded:", arg_7_1, arg_7_2)
	end
end

PackageManager.can_unload = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self._packages[arg_8_1]

	if not self._asynch_packages[arg_8_1] then
		var_8_0 = self._asynch_packages[arg_8_1].handle
	end

	if not var_8_0 and not self._packages[arg_8_1] then
		return ResourcePackage.can_unload(var_8_0)
	end

	return true
end

PackageManager.destroy = function (self)
	-- function 9
	fn("Destroy()")
	table.clear(self._queue_order)
	table.clear(self._queued_async_packages)

	for k, v in pairs(self._packages) do
		for k_2, v_2 in pairs(self._references[k]) do
			for i4 = 1, v_2 do
				self:unload(k, k_2)
			end
		end
	end

	for k_3, v_3 in pairs(self._asynch_packages) do
		for k_4, v_4 in pairs(self._references[k_3]) do
			for i9 = 1, v_4 do
				self:unload(k_3, k_4)
			end
		end
	end

	for k_5, v_5 in pairs(self._delayed_packages_to_remove) do
		fn("We have delayed packages during destroy. This will likely crash during unload. Unloading delayed package:  %s", k_5)
		ResourcePackage.unload(v_5)
		Application.release_resource_package(v_5)
	end
end

PackageManager.is_loading = function (self, arg_10_1, arg_10_2)
	-- function 10
	return (self._packages[arg_10_1] ~= nil or self._asynch_packages[arg_10_1] ~= nil or self._queued_async_packages[arg_10_1] ~= nil) and not arg_10_2 and self._references[arg_10_1][arg_10_2]
end

PackageManager.has_loaded = function (self, arg_11_1, arg_11_2)
	-- function 11
	local flag = self._packages[arg_11_1] == nil or self._asynch_packages[arg_11_1] ~= nil or self._queued_async_packages[arg_11_1] == nil

	if not arg_11_2 then
		return not flag and self._references[arg_11_1][arg_11_2] ~= nil
	else
		return flag
	end
end

PackageManager.reference_count = function (self, arg_12_1, arg_12_2)
	-- function 12
	local num = 0

	if not self._references[arg_12_1] then
		num = self._references[arg_12_1][arg_12_2]
	end

	return num
end

PackageManager.update = function (self, arg_13_1)
	-- function 13
	for k, v in pairs(self._asynch_packages) do
		local _get_async_handle = self:_get_async_handle(k, false)

		if not _get_async_handle and not ResourcePackage.has_loaded(_get_async_handle) then
			fn("Finished loading asynchronous package:  %s", k)
			self:force_load(k)

			break
		end
	end

	for k_2, v_2 in pairs(self._delayed_packages_to_remove) do
		if not ResourcePackage.can_unload(v_2) then
			fn("Unloading delayed package:  %s", k_2)
			ResourcePackage.unload(v_2)
			Application.release_resource_package(v_2)

			self._delayed_packages_to_remove[k_2] = nil
		end
	end

	return next(self._asynch_packages) == nil
end

PackageManager.num_references = function (self, arg_14_1)
	-- function 14
	local num = 0
	local var_14_1 = self._references[arg_14_1]

	if not var_14_1 then
		for k, v in pairs(var_14_1) do
			num = num + v
		end
	end

	return num
end

PackageManager.unload_dangling_painting_materials = function (self)
	-- function 15
	local flag = false

	print("############### UNLOADING PACKAGES ###############")

	for k, v in pairs(self._packages) do
		if not PaintingPackageNames[k] then
			flag = true

			self:_force_unload(k)
		end
	end

	if not flag then
		Crashify.print_exception("Keep Decorations", "unloading dangling painting packages")
	end
end

PackageManager._get_async_handle = function (self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0 = self._asynch_packages[arg_16_1]

	if not var_16_0 then
		local handle = var_16_0.handle

		fassert(handle, "Package '%s' is not loaded", arg_16_1)

		return handle
	end
end

PackageManager._force_unload = function (self, arg_17_1)
	-- function 17
	table.clear(self._references[arg_17_1])

	local _get_async_handle = self:_get_async_handle(arg_17_1, true)

	_get_async_handle = _get_async_handle or self._packages[arg_17_1]

	if not _get_async_handle then
		ResourcePackage.unload(_get_async_handle)
		Application.release_resource_package(_get_async_handle)
	end

	self._packages[arg_17_1] = nil
	self._asynch_packages[arg_17_1] = nil
	self._references[arg_17_1] = nil
	self._queued_async_packages[arg_17_1] = nil

	if not table.is_empty(self._asynch_packages) then
		self:_pop_queue()
	end

	fn("Unload:  %s, %s", arg_17_1, "Keep Painting Error")
end

PackageManager.dump_reference_counter = function (self, arg_18_1)
	-- function 18
	printf("[PackageManager] Dumping reference counters for %s", arg_18_1)

	for k, v in pairs(self._references) do
		local var_18_0 = v[arg_18_1]

		if not var_18_0 then
			printf("%s - referenced %i", k, var_18_0)
		end
	end

	printf("[PackageManager] Done!")
end
