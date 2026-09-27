-- chunkname: @scripts/imgui/imgui_package_debug.lua

ImguiPackageDebug = class(ImguiPackageDebug)

local flag = true

ImguiPackageDebug.init = function (arg_1_0)
	-- function 1
	return
end

ImguiPackageDebug._hijack_package_manager = function (self)
	-- function 2
	local package = Managers.package

	self._old_load_func = package.load
	self._old_unload_func = package.unload

	PackageManager.load = function (arg_3_0, ...)
		-- function 3
		self._refresh_references = true

		self._old_load_func(arg_3_0, ...)
	end

	PackageManager.unload = function (arg_4_0, ...)
		-- function 4
		self._refresh_references = true

		self._old_unload_func(arg_4_0, ...)
	end

	self._refresh_references = true
end

ImguiPackageDebug.on_show = function (self)
	-- function 5
	self:_hijack_package_manager()
end

ImguiPackageDebug.on_hide = function (self)
	-- function 6
	PackageManager.load = self._old_load_func
	PackageManager.unload = self._old_unload_func
end

ImguiPackageDebug.update = function (self)
	-- function 7
	if not flag then
		self:init()

		flag = false
	end

	if not self._refresh_references then
		self._refresh_references = false

		local package = Managers.package

		self._packages = self:_steal_and_sort(package._packages)
		self._asynch_packages = self:_steal_and_sort(package._asynch_packages)
		self._references = self:_steal_and_sort(package._references)
		self._queued_async_packages = self:_steal_and_sort(package._queued_async_packages)
		self._queue_order = self:_steal_and_sort(package._queue_order)
	end
end

ImguiPackageDebug._steal_and_sort = function (arg_8_0, arg_8_1)
	-- function 8
	local shallow_copy = table.shallow_copy(arg_8_1)
	local keys = table.keys(shallow_copy)

	table.sort(keys)

	shallow_copy._sorted_keys = keys

	return shallow_copy
end

ImguiPackageDebug.is_persistent = function (arg_9_0)
	-- function 9
	return true
end

ImguiPackageDebug.draw = function (self, arg_10_1)
	-- function 10
	local begin_window = Imgui.begin_window("Package Debug")

	self:_display_packages("packages", self._packages)
	self:_display_packages("async packages", self._asynch_packages)
	self:_display_references("references", self._references)
	self:_display_packages("queued async packages", self._queued_async_packages)
	self:_display_queue_order("queue order", self._queue_order)
	Imgui.end_window()

	return begin_window
end

ImguiPackageDebug._display_references = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	if not Imgui.tree_node(arg_11_1) then
		if not arg_11_2 then
			local _sorted_keys = arg_11_2._sorted_keys

			for i = 1, #_sorted_keys do
				local var_11_1 = _sorted_keys[i]
				local var_11_2 = arg_11_2[var_11_1]

				if not Imgui.tree_node(var_11_1) then
					for k, v in pairs(var_11_2) do
						Imgui.text(k .. "(" .. v .. ")")
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
	-- function 12
	if not Imgui.tree_node(arg_12_1) then
		if not arg_12_2 then
			local _sorted_keys = arg_12_2._sorted_keys

			for i = 1, #_sorted_keys do
				local var_12_1 = _sorted_keys[i]

				Imgui.text(var_12_1)
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiPackageDebug._display_queue_order = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	if not Imgui.tree_node(arg_13_1) then
		if not arg_13_2 then
			for i = 1, #arg_13_2 do
				local var_13_0 = arg_13_2[i]

				Imgui.text(i .. ": " .. var_13_0)
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiPackageDebug._display_userdata = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	if not Imgui.tree_node(arg_14_1) then
		if not arg_14_2 then
			local _sorted_keys = arg_14_2._sorted_keys

			for i = 1, #_sorted_keys do
				local var_14_1 = _sorted_keys[i]
				local var_14_2 = arg_14_2[var_14_1]

				if not Imgui.tree_node(var_14_1) then
					for k, v in pairs(var_14_2) do
						Imgui.text(k .. "(userdata)")
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
