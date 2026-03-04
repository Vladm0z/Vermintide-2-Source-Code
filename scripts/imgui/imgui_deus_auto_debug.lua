-- chunkname: @scripts/imgui/imgui_deus_auto_debug.lua

ImguiDeusAutoDebug = class(ImguiDeusAutoDebug)

local var_0_0 = {
	"That ain't working.",
	"Have you tried restarting?",
	"Maybe furiously spamming this button will work.",
	"I'm not helpful",
	"I'm helpful",
	"I'm a notorious liar",
	"What is truth",
	"This is a helpful response",
	"It is wednesday my dudes"
}

ImguiDeusAutoDebug.init = function (arg_1_0)
	arg_1_0._current_response = ""
end

ImguiDeusAutoDebug.update = function (arg_2_0)
	return
end

ImguiDeusAutoDebug.is_persistent = function (arg_3_0)
	return false
end

ImguiDeusAutoDebug.draw = function (arg_4_0)
	local var_4_0 = Imgui.begin_window("DeusAutoDebug", "always_auto_resize")

	if Imgui.button("Automatically debug my problems") then
		local var_4_1 = table.clone(var_0_0)

		table.array_remove_if(var_4_1, function (arg_5_0)
			return arg_5_0 == arg_4_0._current_response
		end)

		arg_4_0._current_response = var_4_1[math.random(1, #var_4_1)]
	end

	Imgui.text(arg_4_0._current_response)
	Imgui.end_window()

	return var_4_0
end
