-- chunkname: @scripts/tests/testify_expect.lua

TestifyExpect = class(TestifyExpect)

TestifyExpect.init = function (arg_1_0)
	arg_1_0._expects = {}
end

TestifyExpect.update = function (arg_2_0)
	local var_2_0 = arg_2_0._expects

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		arg_2_0:_handle_expect(iter_2_1)

		var_2_0[iter_2_0] = nil
	end
end

TestifyExpect.fail = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:_expect(arg_3_1, false, arg_3_2)
end

TestifyExpect.is_true = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_2 = arg_4_2 == true

	arg_4_0:_expect(arg_4_1, arg_4_2, arg_4_3)
end

TestifyExpect.is_false = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_2 = arg_5_2 == false

	arg_5_0:_expect(arg_5_1, arg_5_2, arg_5_3)
end

TestifyExpect.is_not_nil = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_2 ~= nil

	arg_6_0:_expect(arg_6_1, var_6_0, arg_6_3)
end

TestifyExpect.is_nil = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2 == nil

	arg_7_0:_expect(arg_7_1, var_7_0, arg_7_3)
end

TestifyExpect.are_equal = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_0:_are_equal(arg_8_2, arg_8_3)

	arg_8_0:_expect(arg_8_1, var_8_0, arg_8_4)
end

TestifyExpect.are_not_equal = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = not arg_9_0:_are_equal(arg_9_2, arg_9_3)

	arg_9_0:_expect(arg_9_1, var_9_0, arg_9_4)
end

TestifyExpect._expect = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = {
		expect = arg_10_1,
		condition = arg_10_2,
		message = arg_10_3
	}
	local var_10_1 = arg_10_0._expects

	var_10_1[#var_10_1 + 1] = var_10_0
end

TestifyExpect._handle_expect = function (arg_11_0, arg_11_1)
	if not string.is_snake_case(arg_11_1.expect) then
		ferror("expect parameter must be in snake case format (eg: this_is_snake_case): " .. arg_11_1.expect)
	end

	local var_11_0 = {
		[arg_11_1.expect] = fassert,
		expect_data = arg_11_1
	}
	local var_11_1 = loadstring(string.format("%s(expect_data.condition, expect_data.message)", arg_11_1.expect))

	setfenv(var_11_1, var_11_0)
	var_11_1(arg_11_1)
end

TestifyExpect._are_equal = function (arg_12_0, arg_12_1, arg_12_2)
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

	local var_12_1 = {}

	for iter_12_0, iter_12_1 in pairs(arg_12_1) do
		local var_12_2 = arg_12_2[iter_12_0]

		if var_12_2 == nil or arg_12_0:_are_equal(iter_12_1, var_12_2) == false then
			return false
		end

		var_12_1[iter_12_0] = true
	end

	for iter_12_2, iter_12_3 in pairs(arg_12_2) do
		if not var_12_1[iter_12_2] then
			return false
		end
	end

	return true
end

return TestifyExpect
