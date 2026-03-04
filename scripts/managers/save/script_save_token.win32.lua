-- chunkname: @scripts/managers/save/script_save_token.win32.lua

ScriptSaveToken = class(ScriptSaveToken)

function ScriptSaveToken.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._adapter = arg_1_1
	arg_1_0._token = arg_1_2
	arg_1_0._info = {}
end

function ScriptSaveToken.update(arg_2_0)
	arg_2_0._info = arg_2_0._adapter.progress(arg_2_0._token)
end

function ScriptSaveToken.info(arg_3_0)
	return arg_3_0._info
end

function ScriptSaveToken.done(arg_4_0)
	return arg_4_0._info.done
end

function ScriptSaveToken.close(arg_5_0)
	arg_5_0._adapter.close(arg_5_0._token)
end
