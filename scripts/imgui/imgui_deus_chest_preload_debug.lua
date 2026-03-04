-- chunkname: @scripts/imgui/imgui_deus_chest_preload_debug.lua

ImguiDeusChestPreloadDebug = class(ImguiDeusChestPreload)

ImguiDeusChestPreloadDebug.init = function (arg_1_0)
	return
end

ImguiDeusChestPreloadDebug.update = function (arg_2_0)
	return
end

ImguiDeusChestPreloadDebug.is_persistent = function (arg_3_0)
	return true
end

ImguiDeusChestPreloadDebug.draw = function (arg_4_0, arg_4_1)
	local var_4_0 = Managers.mechanism:current_mechanism_name()
	local var_4_1 = Imgui.begin_window("ImguiDeusChestPreloadDebug", "always_auto_resize")

	Imgui.end_window()

	return var_4_1
end
