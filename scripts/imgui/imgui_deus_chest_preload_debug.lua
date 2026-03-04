-- chunkname: @scripts/imgui/imgui_deus_chest_preload_debug.lua

ImguiDeusChestPreloadDebug = class(ImguiDeusChestPreload)

function ImguiDeusChestPreloadDebug.init(arg_1_0)
	return
end

function ImguiDeusChestPreloadDebug.update(arg_2_0)
	return
end

function ImguiDeusChestPreloadDebug.is_persistent(arg_3_0)
	return true
end

function ImguiDeusChestPreloadDebug.draw(arg_4_0, arg_4_1)
	local var_4_0 = Managers.mechanism:current_mechanism_name()
	local var_4_1 = Imgui.begin_window("ImguiDeusChestPreloadDebug", "always_auto_resize")

	Imgui.end_window()

	return var_4_1
end
