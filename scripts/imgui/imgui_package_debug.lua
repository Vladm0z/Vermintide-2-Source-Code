-- chunkname: @scripts/imgui/imgui_package_debug.lua

ImguiPackageDebug = class(ImguiPackageDebug)

local var_0_0 = true

ImguiPackageDebug.init = function (arg_1_0)
	return
end

ImguiPackageDebug._hijack_package_manager = function (arg_2_0)
	local var_2_0 = Managers.package

	arg_2_0._old_load_func = var_2_0.load
	arg_2_0._old_unload_func = var_2_0.unload

	PackageManager.load = function (arg_3_0, ...)
		arg_2_0._refresh_references = true

		arg_2_0._old_load_func(arg_3_0, ...)
	end

	PackageManager.unload = function (arg_4_0, ...)
		arg_2_0._refresh_references = true

		arg_2_0._old_unload_func(arg_4_0, ...)
	end

	arg_2_0._refresh_references = true
end

ImguiPackageDebug.on_show = function (arg_5_0)
	arg_5_0:_hijack_package_manager()
end

ImguiPackageDebug.on_hide = function (arg_6_0)
	PackageManager.load = arg_6_0._old_load_func
	PackageManager.unload = arg_6_0._old_unload_func
end

ImguiPackageDebug.update = function (arg_7_0)
	if var_0_0 then
		arg_7_0:init()

		var_0_0 = false
	end

	if arg_7_0._refresh_references then
		arg_7_0._refresh_references = false

		local var_7_0 = Managers.package

		arg_7_0._packages = arg_7_0:_steal_and_sort(var_7_0._packages)
		arg_7_0._asynch_packages = arg_7_0:_steal_and_sort(var_7_0._asynch_packages)
		arg_7_0._references = arg_7_0:_steal_and_sort(var_7_0._references)
		arg_7_0._queued_async_packages = arg_7_0:_steal_and_sort(var_7_0._queued_async_packages)
		arg_7_0._queue_order = arg_7_0:_steal_and_sort(var_7_0._queue_order)
	end
end

ImguiPackageDebug._steal_and_sort = function (arg_8_0, arg_8_1)
	local var_8_0 = table.shallow_copy(arg_8_1)
	local var_8_1 = table.keys(var_8_0)

	table.sort(var_8_1)

	var_8_0._sorted_keys = var_8_1

	return var_8_0
end

ImguiPackageDebug.is_persistent = function (arg_9_0)
	return true
end

ImguiPackageDebug.draw = function (arg_10_0, arg_10_1)
	local var_10_0 = Imgui.begin_window("Package Debug")

	arg_10_0:_display_packages("packages", arg_10_0._packages)
	arg_10_0:_display_packages("async packages", arg_10_0._asynch_packages)
	arg_10_0:_display_references("references", arg_10_0._references)
	arg_10_0:_display_packages("queued async packages", arg_10_0._queued_async_packages)
	arg_10_0:_display_queue_order("queue order", arg_10_0._queue_order)
	Imgui.end_window()

	return var_10_0
end

ImguiPackageDebug._display_references = function (arg_11_0, arg_11_1, arg_11_2)
	if Imgui.tree_node(arg_11_1) then
		if arg_11_2 then
			local var_11_0 = arg_11_2._sorted_keys

			for iter_11_0 = 1, #var_11_0 do
				local var_11_1 = var_11_0[iter_11_0]
				local var_11_2 = arg_11_2[var_11_1]

				if Imgui.tree_node(var_11_1) then
					for iter_11_1, iter_11_2 in pairs(var_11_2) do
						Imgui.text(iter_11_1 .. "(" .. iter_11_2 .. ")")
						Imgui.separator()
					end
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiPackageDebug._display_packages = function (arg_12_0, arg_12_1, arg_12_2)
	if Imgui.tree_node(arg_12_1) then
		if arg_12_2 then
			local var_12_0 = arg_12_2._sorted_keys

			for iter_12_0 = 1, #var_12_0 do
				local var_12_1 = var_12_0[iter_12_0]

				Imgui.text(var_12_1)
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiPackageDebug._display_queue_order = function (arg_13_0, arg_13_1, arg_13_2)
	if Imgui.tree_node(arg_13_1) then
		if arg_13_2 then
			for iter_13_0 = 1, #arg_13_2 do
				local var_13_0 = arg_13_2[iter_13_0]

				Imgui.text(iter_13_0 .. ": " .. var_13_0)
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiPackageDebug._display_userdata = function (arg_14_0, arg_14_1, arg_14_2)
	if Imgui.tree_node(arg_14_1) then
		if arg_14_2 then
			local var_14_0 = arg_14_2._sorted_keys

			for iter_14_0 = 1, #var_14_0 do
				local var_14_1 = var_14_0[iter_14_0]
				local var_14_2 = arg_14_2[var_14_1]

				if Imgui.tree_node(var_14_1) then
					for iter_14_1, iter_14_2 in pairs(var_14_2) do
						Imgui.text(iter_14_1 .. "(userdata)")
						Imgui.separator()
					end

					Imgui.tree_pop()
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end
