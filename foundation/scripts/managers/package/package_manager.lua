-- chunkname: @foundation/scripts/managers/package/package_manager.lua

local function var_0_0(arg_1_0, ...)
	if script_data.package_debug then
		print(string.format("[PackageManager] " .. arg_1_0, ...))
	end
end

PackageManager = PackageManager or {}

function PackageManager.init(arg_2_0)
	arg_2_0._packages = {}
	arg_2_0._asynch_packages = {}
	arg_2_0._references = {}
	arg_2_0._queued_async_packages = {}
	arg_2_0._queue_order = {}
	arg_2_0._delayed_packages_to_remove = {}
end

function PackageManager.load(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	var_0_0("Load:  %s, %s, %s, %s", arg_3_1, arg_3_2, arg_3_4 and "async-read" or "sync-read", arg_3_5 and "prioritized" or "")
	assert(arg_3_2 ~= nil, "No reference name passed when loading package")

	arg_3_0._delayed_packages_to_remove[arg_3_1] = nil

	if arg_3_0._references[arg_3_1] then
		arg_3_0._references[arg_3_1][arg_3_2] = (arg_3_0._references[arg_3_1][arg_3_2] or 0) + 1

		if not arg_3_4 and arg_3_0._asynch_packages[arg_3_1] then
			arg_3_0:force_load(arg_3_1)

			if arg_3_3 then
				arg_3_3()
			end
		elseif not arg_3_4 and arg_3_0._queued_async_packages[arg_3_1] then
			arg_3_0:force_load_queued_package(arg_3_1)

			if arg_3_3 then
				arg_3_3()
			end
		elseif arg_3_0._asynch_packages[arg_3_1] then
			local var_3_0 = arg_3_0._asynch_packages[arg_3_1].callbacks

			var_3_0[#var_3_0 + 1] = arg_3_3
		elseif arg_3_0._queued_async_packages[arg_3_1] then
			local var_3_1 = arg_3_0._queued_async_packages[arg_3_1].callbacks

			var_3_1[#var_3_1 + 1] = arg_3_3

			if arg_3_5 then
				local var_3_2 = table.find(arg_3_0._queue_order, arg_3_1)

				table.remove(arg_3_0._queue_order, var_3_2)
				table.insert(arg_3_0._queue_order, 1, arg_3_1)
			end
		elseif arg_3_3 then
			arg_3_3()
		end
	else
		assert(arg_3_0._packages[arg_3_1] == nil, "Package '" .. tostring(arg_3_1) .. "' is already loaded")
		assert(arg_3_0._asynch_packages[arg_3_1] == nil, "Package '" .. tostring(arg_3_1) .. "' is already being loaded")
		assert(arg_3_0._queued_async_packages[arg_3_1] == nil, "Package '" .. tostring(arg_3_1) .. "' is already queued")

		arg_3_0._references[arg_3_1] = {
			[arg_3_2] = 1
		}

		if next(arg_3_0._asynch_packages) and arg_3_4 then
			arg_3_0._queued_async_packages[arg_3_1] = {
				callbacks = {
					arg_3_3
				}
			}

			if arg_3_5 then
				table.insert(arg_3_0._queue_order, 1, arg_3_1)
			else
				arg_3_0._queue_order[#arg_3_0._queue_order + 1] = arg_3_1
			end
		elseif not arg_3_4 then
			local var_3_3 = Application.resource_package(arg_3_1)

			ResourcePackage.load(var_3_3)
			ResourcePackage.flush(var_3_3)

			arg_3_0._packages[arg_3_1] = var_3_3
		else
			arg_3_0._asynch_packages[arg_3_1] = {
				callbacks = {
					arg_3_3
				}
			}

			local var_3_4 = Application.resource_package(arg_3_1)

			ResourcePackage.load(var_3_4)

			arg_3_0._asynch_packages[arg_3_1].handle = var_3_4
		end
	end
end

function PackageManager.force_load(arg_4_0, arg_4_1)
	var_0_0("Force_load:  %s", arg_4_1)

	local var_4_0 = arg_4_0:_get_async_handle(arg_4_1, true)

	if not var_4_0 then
		var_4_0 = Application.resource_package(arg_4_1)

		ResourcePackage.load(var_4_0)
	end

	assert(not arg_4_0._packages[arg_4_1], "Package %q is already loaded", arg_4_1)
	ResourcePackage.flush(var_4_0)

	arg_4_0._packages[arg_4_1] = var_4_0

	local var_4_1 = arg_4_0._asynch_packages[arg_4_1]

	arg_4_0._asynch_packages[arg_4_1] = nil

	if var_4_1.callbacks then
		for iter_4_0, iter_4_1 in ipairs(var_4_1.callbacks) do
			iter_4_1()
		end
	end

	arg_4_0:_pop_queue()
end

function PackageManager.force_load_queued_package(arg_5_0, arg_5_1)
	var_0_0("Force_load_queued_package:  %s", arg_5_1)

	local var_5_0 = arg_5_0._queued_async_packages[arg_5_1]

	assert(var_5_0, "Package %q is not being loaded", arg_5_1)

	local var_5_1 = Application.resource_package(arg_5_1)

	ResourcePackage.load(var_5_1)
	assert(not arg_5_0._packages[arg_5_1], "Package %q is already loaded", arg_5_1)
	ResourcePackage.flush(var_5_1)

	arg_5_0._packages[arg_5_1] = var_5_1
	arg_5_0._queued_async_packages[arg_5_1] = nil

	if var_5_0.callbacks then
		for iter_5_0, iter_5_1 in ipairs(var_5_0.callbacks) do
			iter_5_1()
		end
	end

	local var_5_2 = table.find(arg_5_0._queue_order, arg_5_1)

	table.remove(arg_5_0._queue_order, var_5_2)
	arg_5_0:_pop_queue()
end

function PackageManager._pop_queue(arg_6_0)
	local var_6_0
	local var_6_1 = 1

	while #arg_6_0._queue_order > 0 and var_6_1 <= #arg_6_0._queue_order do
		var_6_0 = arg_6_0._queue_order[var_6_1]

		if arg_6_0._queued_async_packages[var_6_0] then
			break
		end

		var_6_1 = var_6_1 + 1
		var_6_0 = nil
	end

	if arg_6_0._queued_async_packages[var_6_0] then
		local var_6_2 = arg_6_0._queued_async_packages[var_6_0]

		var_0_0("Queueing new asynch package:  %s", var_6_0)

		arg_6_0._queued_async_packages[var_6_0] = nil
		arg_6_0._queue_order = table.crop(arg_6_0._queue_order, var_6_1 + 1)
		arg_6_0._asynch_packages[var_6_0] = {
			callbacks = var_6_2.callbacks
		}

		local var_6_3 = Application.resource_package(var_6_0)

		ResourcePackage.load(var_6_3)

		arg_6_0._asynch_packages[var_6_0].handle = var_6_3
	else
		table.clear(arg_6_0._queue_order)
	end
end

function PackageManager.unload(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._references[arg_7_1]

	assert(var_7_0[arg_7_2] ~= nil, "[PackageManager] Trying to unload package with unknown reference name")

	local var_7_1 = var_7_0[arg_7_2] - 1

	if var_7_1 == 0 then
		var_7_0[arg_7_2] = nil
	else
		var_7_0[arg_7_2] = var_7_1
	end

	if table.is_empty(var_7_0) then
		local var_7_2 = arg_7_0:_get_async_handle(arg_7_1, true) or arg_7_0._packages[arg_7_1]

		if var_7_2 then
			if arg_7_0:can_unload(arg_7_1) then
				ResourcePackage.unload(var_7_2)
				Application.release_resource_package(var_7_2)

				arg_7_0._delayed_packages_to_remove[arg_7_1] = nil

				var_0_0("Unload:  %s, %s", arg_7_1, arg_7_2)
			else
				arg_7_0._delayed_packages_to_remove[arg_7_1] = var_7_2

				var_0_0("Delayed Unload of:  %s, %s", arg_7_1, arg_7_2)
			end
		end

		arg_7_0._packages[arg_7_1] = nil
		arg_7_0._asynch_packages[arg_7_1] = nil
		arg_7_0._references[arg_7_1] = nil
		arg_7_0._queued_async_packages[arg_7_1] = nil

		if table.is_empty(arg_7_0._asynch_packages) then
			arg_7_0:_pop_queue()
		end
	else
		var_0_0("Unload:  %s, %s -> Package still referenced, NOT unloaded:", arg_7_1, arg_7_2)
	end
end

function PackageManager.can_unload(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._packages[arg_8_1]

	if arg_8_0._asynch_packages[arg_8_1] then
		var_8_0 = arg_8_0._asynch_packages[arg_8_1].handle
	end

	if var_8_0 and arg_8_0._packages[arg_8_1] then
		return ResourcePackage.can_unload(var_8_0)
	end

	return true
end

function PackageManager.destroy(arg_9_0)
	var_0_0("Destroy()")
	table.clear(arg_9_0._queue_order)
	table.clear(arg_9_0._queued_async_packages)

	for iter_9_0, iter_9_1 in pairs(arg_9_0._packages) do
		for iter_9_2, iter_9_3 in pairs(arg_9_0._references[iter_9_0]) do
			for iter_9_4 = 1, iter_9_3 do
				arg_9_0:unload(iter_9_0, iter_9_2)
			end
		end
	end

	for iter_9_5, iter_9_6 in pairs(arg_9_0._asynch_packages) do
		for iter_9_7, iter_9_8 in pairs(arg_9_0._references[iter_9_5]) do
			for iter_9_9 = 1, iter_9_8 do
				arg_9_0:unload(iter_9_5, iter_9_7)
			end
		end
	end

	for iter_9_10, iter_9_11 in pairs(arg_9_0._delayed_packages_to_remove) do
		var_0_0("We have delayed packages during destroy. This will likely crash during unload. Unloading delayed package:  %s", iter_9_10)
		ResourcePackage.unload(iter_9_11)
		Application.release_resource_package(iter_9_11)
	end
end

function PackageManager.is_loading(arg_10_0, arg_10_1, arg_10_2)
	return arg_10_0._packages[arg_10_1] == nil and (arg_10_0._asynch_packages[arg_10_1] ~= nil or arg_10_0._queued_async_packages[arg_10_1] ~= nil) and (not arg_10_2 or arg_10_0._references[arg_10_1][arg_10_2])
end

function PackageManager.has_loaded(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._packages[arg_11_1] ~= nil and arg_11_0._asynch_packages[arg_11_1] == nil and arg_11_0._queued_async_packages[arg_11_1] == nil

	if arg_11_2 then
		return var_11_0 and arg_11_0._references[arg_11_1][arg_11_2] ~= nil
	else
		return var_11_0
	end
end

function PackageManager.reference_count(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = 0

	if arg_12_0._references[arg_12_1] then
		var_12_0 = arg_12_0._references[arg_12_1][arg_12_2]
	end

	return var_12_0
end

function PackageManager.update(arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in pairs(arg_13_0._asynch_packages) do
		local var_13_0 = arg_13_0:_get_async_handle(iter_13_0, false)

		if var_13_0 and ResourcePackage.has_loaded(var_13_0) then
			var_0_0("Finished loading asynchronous package:  %s", iter_13_0)
			arg_13_0:force_load(iter_13_0)

			break
		end
	end

	for iter_13_2, iter_13_3 in pairs(arg_13_0._delayed_packages_to_remove) do
		if ResourcePackage.can_unload(iter_13_3) then
			var_0_0("Unloading delayed package:  %s", iter_13_2)
			ResourcePackage.unload(iter_13_3)
			Application.release_resource_package(iter_13_3)

			arg_13_0._delayed_packages_to_remove[iter_13_2] = nil
		end
	end

	return next(arg_13_0._asynch_packages) == nil
end

function PackageManager.num_references(arg_14_0, arg_14_1)
	local var_14_0 = 0
	local var_14_1 = arg_14_0._references[arg_14_1]

	if var_14_1 then
		for iter_14_0, iter_14_1 in pairs(var_14_1) do
			var_14_0 = var_14_0 + iter_14_1
		end
	end

	return var_14_0
end

function PackageManager.unload_dangling_painting_materials(arg_15_0)
	local var_15_0 = false

	print("############### UNLOADING PACKAGES ###############")

	for iter_15_0, iter_15_1 in pairs(arg_15_0._packages) do
		if PaintingPackageNames[iter_15_0] then
			var_15_0 = true

			arg_15_0:_force_unload(iter_15_0)
		end
	end

	if var_15_0 then
		Crashify.print_exception("Keep Decorations", "unloading dangling painting packages")
	end
end

function PackageManager._get_async_handle(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._asynch_packages[arg_16_1]

	if var_16_0 then
		local var_16_1 = var_16_0.handle

		fassert(var_16_1, "Package '%s' is not loaded", arg_16_1)

		return var_16_1
	end
end

function PackageManager._force_unload(arg_17_0, arg_17_1)
	table.clear(arg_17_0._references[arg_17_1])

	local var_17_0 = arg_17_0:_get_async_handle(arg_17_1, true) or arg_17_0._packages[arg_17_1]

	if var_17_0 then
		ResourcePackage.unload(var_17_0)
		Application.release_resource_package(var_17_0)
	end

	arg_17_0._packages[arg_17_1] = nil
	arg_17_0._asynch_packages[arg_17_1] = nil
	arg_17_0._references[arg_17_1] = nil
	arg_17_0._queued_async_packages[arg_17_1] = nil

	if table.is_empty(arg_17_0._asynch_packages) then
		arg_17_0:_pop_queue()
	end

	var_0_0("Unload:  %s, %s", arg_17_1, "Keep Painting Error")
end

function PackageManager.dump_reference_counter(arg_18_0, arg_18_1)
	printf("[PackageManager] Dumping reference counters for %s", arg_18_1)

	for iter_18_0, iter_18_1 in pairs(arg_18_0._references) do
		local var_18_0 = iter_18_1[arg_18_1]

		if var_18_0 then
			printf("%s - referenced %i", iter_18_0, var_18_0)
		end
	end

	printf("[PackageManager] Done!")
end
