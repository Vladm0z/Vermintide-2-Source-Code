-- chunkname: @scripts/unit_extensions/weapons/projectiles/true_flight_utility.lua

TrueFlightUtility = TrueFlightUtility or {}

local var_0_0
local var_0_1

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = Unit.get_data(arg_1_0, "breed")
	local var_1_1 = Unit.get_data(arg_1_1, "breed")

	if not var_1_1 or not var_1_0 then
		return var_1_0 or not var_1_1 and var_0_0[arg_1_0] < var_0_0[arg_1_1]
	end

	local var_1_2 = var_1_0.special

	if var_1_2 ~= var_1_1.special then
		return var_1_2
	end

	local var_1_3 = var_1_0.elite

	if var_1_3 ~= var_1_1.elite then
		return var_1_3
	end

	local var_1_4 = POSITION_LOOKUP[arg_1_0]
	local var_1_5 = POSITION_LOOKUP[arg_1_1]

	if not var_1_4 or not var_1_5 then
		return var_1_4
	end

	if var_0_1 then
		local var_1_6 = Vector3.distance_squared(var_1_4, var_0_1) - Vector3.distance_squared(var_1_5, var_0_1)

		if math.abs(var_1_6) < math.epsilon then
			return var_1_6 < 0
		end
	end

	return var_0_0[arg_1_0] < var_0_0[arg_1_1]
end

local function var_0_3(arg_2_0, arg_2_1)
	local var_2_0 = Unit.get_data(arg_2_0, "breed")
	local var_2_1 = Unit.get_data(arg_2_1, "breed")

	if not var_2_1 or not var_2_0 then
		return var_2_0 or not var_2_1 and var_0_0[arg_2_0] < var_0_0[arg_2_1]
	end

	local var_2_2 = var_2_0.elite

	if var_2_2 ~= var_2_1.elite then
		return var_2_2
	end

	local var_2_3 = var_2_0.special

	if var_2_3 ~= var_2_1.special then
		return var_2_3
	end

	local var_2_4 = POSITION_LOOKUP[arg_2_0]
	local var_2_5 = POSITION_LOOKUP[arg_2_1]

	if not var_2_4 or not var_2_5 then
		return var_2_4
	end

	if var_0_1 then
		local var_2_6 = Vector3.distance_squared(var_2_4, var_0_1) - Vector3.distance_squared(var_2_5, var_0_1)

		if math.abs(var_2_6) < math.epsilon then
			return var_2_6 < 0
		end
	end

	return var_0_0[arg_2_0] < var_0_0[arg_2_1]
end

local function var_0_4(arg_3_0, arg_3_1)
	local var_3_0 = Unit.get_data(arg_3_0, "breed")
	local var_3_1 = Unit.get_data(arg_3_1, "breed")

	if not var_3_1 or not var_3_0 then
		return var_3_0 or not var_3_1 and var_0_0[arg_3_0] < var_0_0[arg_3_1]
	end

	local var_3_2 = var_3_0.boss

	if var_3_2 ~= var_3_1.boss then
		return var_3_2
	end

	return var_0_3(arg_3_0, arg_3_1)
end

TrueFlightUtility.sort_prioritize_specials = function (arg_4_0, arg_4_1)
	var_0_0 = table.mirror_array(arg_4_0, FrameTable.alloc_table())
	var_0_1 = arg_4_1

	table.sort(arg_4_0, var_0_2)

	return arg_4_0
end

TrueFlightUtility.sort_prioritize_elites = function (arg_5_0, arg_5_1)
	var_0_0 = table.mirror_array(arg_5_0, FrameTable.alloc_table())
	var_0_1 = arg_5_1

	table.sort(arg_5_0, var_0_3)

	return arg_5_0
end

TrueFlightUtility.sort_prioritize_bosses = function (arg_6_0, arg_6_1)
	var_0_0 = table.mirror_array(arg_6_0, FrameTable.alloc_table())
	var_0_1 = arg_6_1

	table.sort(arg_6_0, var_0_4)

	return arg_6_0
end

local function var_0_5(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9)
	local var_7_0 = Unit.get_data(arg_7_0, "breed")

	if not var_7_0 then
		return 0
	end

	local var_7_1 = POSITION_LOOKUP[arg_7_0]
	local var_7_2 = (var_7_0.height or 2) * 0.75
	local var_7_3 = var_7_2 * 1.5
	local var_7_4 = var_7_1 + Vector3(0, 0, var_7_2) - arg_7_1
	local var_7_5 = Vector3.length(var_7_4)
	local var_7_6 = var_7_5 / math.sqrt(var_7_5 * var_7_5 + var_7_3 * var_7_3)

	arg_7_2 = Vector3.normalize(arg_7_2)

	local var_7_7 = Vector3.dot(Vector3.normalize(var_7_4), arg_7_2)

	if var_7_7 < var_7_6 then
		return 0
	end

	local var_7_8 = math.inv_lerp(math.acos(1 - var_7_6), 0, math.acos(var_7_7))^2 * arg_7_8
	local var_7_9 = Vector3.length(var_7_4)

	if arg_7_6 < var_7_9 then
		return 0
	end

	local var_7_10 = var_7_8 + math.inv_lerp(arg_7_6, 0, var_7_9) * arg_7_7

	if var_7_0.is_player then
		var_7_10 = var_7_10 * arg_7_9
	elseif var_7_0.elite then
		var_7_10 = var_7_10 * arg_7_5
	elseif var_7_0.special then
		var_7_10 = var_7_10 * arg_7_4
	elseif var_7_0.boss then
		var_7_10 = var_7_10 * arg_7_3
	end

	return var_7_10
end

local var_0_6 = {}

local function var_0_7(arg_8_0, arg_8_1)
	return var_0_6[arg_8_0] > var_0_6[arg_8_1]
end

TrueFlightUtility.sort = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9)
	table.clear(var_0_6)

	for iter_9_0 = 1, #arg_9_0 do
		local var_9_0 = arg_9_0[iter_9_0]

		var_0_6[var_9_0] = var_0_5(var_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9)
	end

	table.sort(arg_9_0, var_0_7)

	return var_0_6
end
