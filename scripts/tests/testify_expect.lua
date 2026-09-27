-- chunkname: @scripts/tests/testify_expect.lua

TestifyExpect = class(TestifyExpect)

TestifyExpect.init = function (self)
	-- function 1
	self._expects = {}
end

TestifyExpect.update = function (self)
	-- function 2
	local _expects = self._expects

	for k, v in pairs(_expects) do
		self:_handle_expect(v)

		_expects[k] = nil
	end
end

TestifyExpect.fail = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:_expect(arg_3_1, false, arg_3_2)
end

TestifyExpect.is_true = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	arg_4_2 = arg_4_2 == true

	self:_expect(arg_4_1, arg_4_2, arg_4_3)
end

TestifyExpect.is_false = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	arg_5_2 = arg_5_2 == false

	self:_expect(arg_5_1, arg_5_2, arg_5_3)
end

TestifyExpect.is_not_nil = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local flag = arg_6_2 ~= nil

	self:_expect(arg_6_1, flag, arg_6_3)
end

TestifyExpect.is_nil = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local flag = arg_7_2 == nil

	self:_expect(arg_7_1, flag, arg_7_3)
end

TestifyExpect.are_equal = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local _are_equal = self:_are_equal(arg_8_2, arg_8_3)

	self:_expect(arg_8_1, _are_equal, arg_8_4)
end

TestifyExpect.are_not_equal = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local flag = not self:_are_equal(arg_9_2, arg_9_3)

	self:_expect(arg_9_1, flag, arg_9_4)
end

TestifyExpect._expect = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local tbl = {
		expect = arg_10_1,
		condition = arg_10_2,
		message = arg_10_3
	}
	local _expects = self._expects

	_expects[#_expects + 1] = tbl
end

TestifyExpect._handle_expect = function (arg_11_0, arg_11_1)
	-- function 11
	if not string.is_snake_case(arg_11_1.expect) then
		ferror("expect parameter must be in snake case format (eg: this_is_snake_case): " .. arg_11_1.expect)
	end

	local tbl = {
		[arg_11_1.expect] = fassert,
		expect_data = arg_11_1
	}
	local var_11_1 = loadstring(string.format("%s(expect_data.condition, expect_data.message)", arg_11_1.expect))

	setfenv(var_11_1, tbl)
	var_11_1(arg_11_1)
end

TestifyExpect._are_equal = function (self, arg_12_1, arg_12_2)
	-- function 12
	if arg_12_1 == arg_12_2 then
		return true
	end

	local var_12_0 = type(arg_12_1)

	if var_12_0 ~= type(arg_12_2) then
		return false
	end

	if var_12_0 ~= "table" then
		return false
	end

	local tbl = {}

	for k, v in pairs(arg_12_1) do
		local var_12_2 = arg_12_2[k]

		if not (var_12_2 == nil or self:_are_equal(v, var_12_2) ~= false) then
			return false
		end

		tbl[k] = true
	end

	for k_2, v_2 in pairs(arg_12_2) do
		if not tbl[k_2] then
			return false
		end
	end

	return true
end

return TestifyExpect
