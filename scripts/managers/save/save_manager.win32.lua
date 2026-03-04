-- chunkname: @scripts/managers/save/save_manager.win32.lua

require("scripts/managers/save/script_save_token")

SaveManager = class(SaveManager)

SaveManager.init = function (arg_1_0, arg_1_1)
	if not arg_1_1 and rawget(_G, "Steam") and Cloud.enabled() then
		fassert(rawget(_G, "Steam"), "Steam is required for cloud saves")

		arg_1_0._impl = Cloud
	else
		arg_1_0._impl = SaveSystem
	end
end

SaveManager.auto_save = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_4 and SaveSystem or arg_2_0._impl
	local var_2_1 = var_2_0.auto_save(arg_2_1, arg_2_2)
	local var_2_2 = ScriptSaveToken:new(var_2_0, var_2_1)

	Managers.token:register_token(var_2_2, arg_2_3)

	return var_2_2
end

SaveManager.auto_load = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_3 and SaveSystem or arg_3_0._impl
	local var_3_1 = var_3_0.auto_load(arg_3_1)
	local var_3_2 = ScriptSaveToken:new(var_3_0, var_3_1)

	Managers.token:register_token(var_3_2, arg_3_2)

	return var_3_2
end
