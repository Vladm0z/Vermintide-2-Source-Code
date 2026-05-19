-- chunkname: @scripts/managers/account/script_connected_storage_token.lua

ScriptConnectedStorageToken = class(ScriptConnectedStorageToken, ScriptSaveToken)

function ScriptConnectedStorageToken.info(arg_1_0)
	local var_1_0 = {}

	if arg_1_0._status == arg_1_0._adapter.COMPLETED then
		print("GET STORAGE ID SUCCESS", arg_1_0._status)

		var_1_0 = {
			storage_id = arg_1_0._token
		}
	else
		print("GET STORAGE ID ERROR", arg_1_0._status)

		var_1_0 = {
			error = arg_1_0:_parse_error(arg_1_0._status)
		}
	end

	return var_1_0
end

ScriptConnectedStorageQueryToken = class(ScriptConnectedStorageQueryToken, ScriptSaveToken)

function ScriptConnectedStorageQueryToken.info(arg_2_0)
	local var_2_0 = {}

	if arg_2_0._status == arg_2_0._adapter.COMPLETED then
		var_2_0 = arg_2_0._adapter.query_result(arg_2_0._token)
	else
		print("QUERY ERROR")

		var_2_0 = {
			error = arg_2_0:_parse_error(arg_2_0._status)
		}
	end

	return var_2_0
end

ScriptConnectedStorageDeleteToken = class(ScriptConnectedStorageDeleteToken, ScriptSaveToken)

function ScriptConnectedStorageDeleteToken.info(arg_3_0)
	local var_3_0 = {}

	if arg_3_0._status == arg_3_0._adapter.ERROR then
		print("DELETE ERROR")

		var_3_0 = {
			error = arg_3_0:_parse_error(arg_3_0._status)
		}
	end

	return var_3_0
end
