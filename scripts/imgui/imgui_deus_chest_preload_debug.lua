-- chunkname: @scripts/imgui/imgui_deus_chest_preload_debug.lua

ImguiDeusChestPreloadDebug = class(ImguiDeusChestPreload)

ImguiDeusChestPreloadDebug.init = function (self)
	-- function 1
	return
end

ImguiDeusChestPreloadDebug.update = function (self)
	-- function 2
	return
end

ImguiDeusChestPreloadDebug.is_persistent = function (self)
	-- function 3
	return true
end

ImguiDeusChestPreloadDebug.draw = function (self, is_open)
	-- function 4
	local mechanism_name = Managers.mechanism:current_mechanism_name()
	local do_close = Imgui.begin_window("ImguiDeusChestPreloadDebug", "always_auto_resize")

	Imgui.end_window()

	return do_close
end
