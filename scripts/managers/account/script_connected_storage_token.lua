-- chunkname: @scripts/managers/account/script_connected_storage_token.lua

ScriptConnectedStorageToken = class(ScriptConnectedStorageToken, ScriptSaveToken)

ScriptConnectedStorageToken.info = function (self)
	-- function 1
	local tbl = {}

	if self._status == self._adapter.COMPLETED then
		print("GET STORAGE ID SUCCESS", self._status)

		tbl = {
			storage_id = self._token
		}
	else
		print("GET STORAGE ID ERROR", self._status)

		tbl = {
			error = self:_parse_error(self._status)
		}
	end

	return tbl
end

ScriptConnectedStorageQueryToken = class(ScriptConnectedStorageQueryToken, ScriptSaveToken)

ScriptConnectedStorageQueryToken.info = function (self)
	-- function 2
	local tbl = {}

	if self._status == self._adapter.COMPLETED then
		tbl = self._adapter.query_result(self._token)
	else
		print("QUERY ERROR")

		tbl = {
			error = self:_parse_error(self._status)
		}
	end

	return tbl
end

ScriptConnectedStorageDeleteToken = class(ScriptConnectedStorageDeleteToken, ScriptSaveToken)

ScriptConnectedStorageDeleteToken.info = function (self)
	-- function 3
	local tbl = {}

	if self._status == self._adapter.ERROR then
		print("DELETE ERROR")

		tbl = {
			error = self:_parse_error(self._status)
		}
	end

	return tbl
end
