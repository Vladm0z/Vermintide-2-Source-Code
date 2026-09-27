-- chunkname: @scripts/managers/account/qos/script_qos_token.lua

ScriptQoSToken = class(ScriptQoSToken)

ScriptQoSToken.init = function (self, arg_1_1)
	-- function 1
	self._token = arg_1_1
	self._result = {}
	self._done = false
end

ScriptQoSToken.update = function (self)
	-- function 2
	local status, var_2_1, var_2_2, var_2_3 = QoS.status(self._token)

	self._done = var_2_1
	self._result_code = var_2_3
end

ScriptQoSToken.info = function (self)
	-- function 3
	local tbl = {}
	local flag = bit.band(self._result_code, QoS.UP_FAILED) > 0
	local flag_2 = bit.band(self._result_code, QoS.DOWN_FAILED) > 0

	tbl.up_failed = flag
	tbl.down_failed = flag_2

	if flag or not flag_2 then
		local str = "Your"
		local flag_3

		flag_3 = not flag and " upload bandwidth " and ""

		local flag_4

		flag_4 = not flag_2 and " download bandwidth " and ""

		local var_3_6 = str
		local var_3_7 = flag_3
		local flag_5

		flag_5 = not flag and not flag_2 and "and" and ""

		local var_3_9 = flag_4
		local flag_6

		flag_6 = not flag and not flag_2 and "are too low" and "is too low"
		tbl.error = var_3_6 .. var_3_7 .. flag_5 .. var_3_9 .. flag_6
	end

	return tbl
end

ScriptQoSToken.done = function (self)
	-- function 4
	return self._done
end

ScriptQoSToken.close = function (self)
	-- function 5
	QoS.release(self._token)
end
