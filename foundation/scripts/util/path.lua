-- chunkname: @foundation/scripts/util/path.lua

Path = {}

Path.normalize_path = function (arg_1_0)
	arg_1_0 = arg_1_0:gsub("\\", "/")
	arg_1_0 = arg_1_0:gsub("//", "/")

	return arg_1_0
end

Path.path_from_string = function (arg_2_0)
	arg_2_0 = Path.normalize_path(arg_2_0)

	local var_2_0 = {
		size = 0
	}
	local var_2_1 = 0
	local var_2_2 = #arg_2_0
	local var_2_3 = 0

	while var_2_3 ~= nil do
		local var_2_4 = arg_2_0:find("/", var_2_3)

		var_2_0[var_2_1], var_2_1 = arg_2_0:sub(var_2_3, var_2_4 and var_2_4 - 1 or nil), var_2_1 + 1

		if var_2_4 == nil or var_2_4 == var_2_2 then
			break
		end

		var_2_3 = var_2_4 + 1
	end

	var_2_0.size = var_2_1

	return var_2_0
end

Path.path_from_parts = function (...)
	local var_3_0 = select("#", ...)
	local var_3_1 = {
		size = var_3_0
	}

	for iter_3_0 = 1, var_3_0 do
		var_3_1[iter_3_0] = select(iter_3_0, ...)
	end

	return var_3_1
end

Path.copy = function (arg_4_0)
	local var_4_0 = {
		size = arg_4_0.size
	}

	for iter_4_0 = 1, arg_4_0.size do
		var_4_0[iter_4_0] = arg_4_0[iter_4_0]
	end

	return var_4_0
end

Path.change_dir_up = function (arg_5_0)
	assert(arg_5_0.size > 0)

	arg_5_0.size = arg_5_0.size - 1
end

Path.add_path_part = function (arg_6_0, arg_6_1)
	arg_6_0.size = arg_6_0.size + 1
	arg_6_0[arg_6_0.size] = arg_6_1
end

Path.join = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	arg_7_2.size = 0

	for iter_7_0 = 1, arg_7_0.size do
		arg_7_2.size = arg_7_2.size + 1
		arg_7_2[arg_7_2.size] = arg_7_0[iter_7_0]
	end

	for iter_7_1 = 1, arg_7_1.size do
		arg_7_2.size = arg_7_2.size + 1
		arg_7_2[arg_7_2.size] = arg_7_1[iter_7_1]
	end

	return arg_7_2
end

Path.tostring = function (arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or "/"

	local var_8_0 = ""

	for iter_8_0 = 1, arg_8_0.size - 1 do
		var_8_0 = var_8_0 .. arg_8_0[iter_8_0] .. arg_8_1
	end

	return var_8_0 .. arg_8_0[arg_8_0.size]
end

local var_0_0 = true

if var_0_0 then
	local var_0_1 = math.random()
	local var_0_2 = Path.path_from_string("hej")

	assert(var_0_2.size == 1)

	local var_0_3 = Path.path_from_string("hej/apa")

	assert(var_0_3.size == 2)
	assert(var_0_3[var_0_3.size] == "apa")

	local var_0_4 = Path.path_from_string("hej\\apa\\")

	assert(var_0_4.size == 2)
	assert(var_0_4[var_0_4.size] == "apa")

	local var_0_5 = Path.path_from_parts("hej", "apa")

	assert(var_0_5.size == 2)
	Path.change_dir_up(var_0_5)
	assert(var_0_5.size == 1)
	Path.add_path_part(var_0_5, "lols")
	assert(var_0_5.size == 2)
	assert(var_0_5[var_0_5.size] == "lols")

	local var_0_6 = Path.path_from_parts("anders", "isn't", "best")
	local var_0_7 = {}

	Path.join(var_0_5, var_0_6, var_0_7)
	assert(var_0_7.size == var_0_5.size + var_0_6.size)
	assert(var_0_7[var_0_7.size] == "best")

	local var_0_8 = Path.tostring(var_0_7)

	assert(var_0_8 == "hej/lols/anders/isn't/best")

	local var_0_9 = Path.path_from_string("C:\\trunk/lols/")

	assert(var_0_9.size == 3)

	local var_0_10 = Path.tostring(var_0_9)

	assert(var_0_10 == "C:/trunk/lols")
end
