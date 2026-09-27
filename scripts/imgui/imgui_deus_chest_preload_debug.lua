-- chunkname: @scripts/imgui/imgui_deus_chest_preload_debug.lua

ImguiDeusChestPreloadDebug = class(ImguiDeusChestPreload)

ImguiDeusChestPreloadDebug.init = function (arg_1_0)
	-- function 1
	return
end

ImguiDeusChestPreloadDebug.update = function (arg_2_0)
	-- function 2
	return
end

ImguiDeusChestPreloadDebug.is_persistent = function (arg_3_0)
	-- function 3
	return true
end

ImguiDeusChestPreloadDebug.draw = function (arg_4_0, arg_4_1)
	-- function 4
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local begin_window = Imgui.begin_window("ImguiDeusChestPreloadDebug", "always_auto_resize")

	Imgui.end_window()

	return begin_window
end
