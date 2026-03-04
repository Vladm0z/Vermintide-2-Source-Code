-- chunkname: @scripts/managers/save/script_save_token.win32.lua

ScriptSaveToken = class(ScriptSaveToken)

ScriptSaveToken.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._adapter = arg_1_1
	arg_1_0._token = arg_1_2
	arg_1_0._info = {}
end

ScriptSaveToken.update = function (arg_2_0)
	arg_2_0._info = arg_2_0._adapter.progress(arg_2_0._token)
end

ScriptSaveToken.info = function (arg_3_0)
	return arg_3_0._info
end

ScriptSaveToken.done = function (arg_4_0)
	return arg_4_0._info.done
end

ScriptSaveToken.close = function (arg_5_0)
	arg_5_0._adapter.close(arg_5_0._token)
end
