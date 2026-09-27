-- chunkname: @scripts/unit_extensions/weapons/projectiles/true_flight_utility.lua

local TrueFlightUtility = TrueFlightUtility

TrueFlightUtility = TrueFlightUtility or {}
TrueFlightUtility = TrueFlightUtility

local var_0_1
local var_0_2

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local get_data = Unit.get_data(arg_1_0, "breed")
	local get_data_2 = Unit.get_data(arg_1_1, "breed")

	if not (not get_data_2 and get_data) then
		return get_data or not not get_data_2 or var_0_1[arg_1_0] < var_0_1[arg_1_1]
	end

	local special = get_data.special

	if special ~= get_data_2.special then
		return special
	end

	local elite = get_data.elite

	if elite ~= get_data_2.elite then
		return elite
	end

	local var_1_4 = POSITION_LOOKUP[arg_1_0]
	local var_1_5 = POSITION_LOOKUP[arg_1_1]

	if not (not var_1_4 and var_1_5) then
		return var_1_4
	end

	if not var_0_2 then
		local num = Vector3.distance_squared(var_1_4, var_0_2) - Vector3.distance_squared(var_1_5, var_0_2)

		if math.abs(num) < math.epsilon then
			return num < 0
		end
	end

	return var_0_1[arg_1_0] < var_0_1[arg_1_1]
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local get_data = Unit.get_data(arg_2_0, "breed")
	local get_data_2 = Unit.get_data(arg_2_1, "breed")

	if not (not get_data_2 and get_data) then
		return get_data or not not get_data_2 or var_0_1[arg_2_0] < var_0_1[arg_2_1]
	end

	local elite = get_data.elite

	if elite ~= get_data_2.elite then
		return elite
	end

	local special = get_data.special

	if special ~= get_data_2.special then
		return special
	end

	local var_2_4 = POSITION_LOOKUP[arg_2_0]
	local var_2_5 = POSITION_LOOKUP[arg_2_1]

	if not (not var_2_4 and var_2_5) then
		return var_2_4
	end

	if not var_0_2 then
		local num = Vector3.distance_squared(var_2_4, var_0_2) - Vector3.distance_squared(var_2_5, var_0_2)

		if math.abs(num) < math.epsilon then
			return num < 0
		end
	end

	return var_0_1[arg_2_0] < var_0_1[arg_2_1]
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local get_data = Unit.get_data(arg_3_0, "breed")
	local get_data_2 = Unit.get_data(arg_3_1, "breed")

	if not (not get_data_2 and get_data) then
		return get_data or not not get_data_2 or var_0_1[arg_3_0] < var_0_1[arg_3_1]
	end

	local boss = get_data.boss

	if boss ~= get_data_2.boss then
		return boss
	end

	return fn_2(arg_3_0, arg_3_1)
end

TrueFlightUtility.sort_prioritize_specials = function (arg_4_0, arg_4_1)
	-- function 4
	var_0_1 = table.mirror_array(arg_4_0, FrameTable.alloc_table())
	var_0_2 = arg_4_1

	table.sort(arg_4_0, fn)

	return arg_4_0
end

TrueFlightUtility.sort_prioritize_elites = function (arg_5_0, arg_5_1)
	-- function 5
	var_0_1 = table.mirror_array(arg_5_0, FrameTable.alloc_table())
	var_0_2 = arg_5_1

	table.sort(arg_5_0, fn_2)

	return arg_5_0
end

TrueFlightUtility.sort_prioritize_bosses = function (arg_6_0, arg_6_1)
	-- function 6
	var_0_1 = table.mirror_array(arg_6_0, FrameTable.alloc_table())
	var_0_2 = arg_6_1

	table.sort(arg_6_0, fn_3)

	return arg_6_0
end

local function fn_4(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9)
	-- function 7
	local get_data = Unit.get_data(arg_7_0, "breed")

	if not get_data then
		return 0
	end

	local var_7_1 = POSITION_LOOKUP[arg_7_0]
	local height = get_data.height

	height = height or 2

	local num = height * 0.75
	local num_2 = num * 1.5
	local num_3 = var_7_1 + Vector3(0, 0, num) - arg_7_1
	local length = Vector3.length(num_3)
	local num_4 = length / math.sqrt(length * length + num_2 * num_2)

	arg_7_2 = Vector3.normalize(arg_7_2)

	local dot = Vector3.dot(Vector3.normalize(num_3), arg_7_2)

	if dot < num_4 then
		return 0
	end

	local num_5 = math.inv_lerp(math.acos(1 - num_4), 0, math.acos(dot))^2 * arg_7_8
	local length_2 = Vector3.length(num_3)

	if arg_7_6 < length_2 then
		return 0
	end

	local num_6 = num_5 + math.inv_lerp(arg_7_6, 0, length_2) * arg_7_7

	if not get_data.is_player then
		num_6 = num_6 * arg_7_9
	elseif not get_data.elite then
		num_6 = num_6 * arg_7_5
	elseif not get_data.special then
		num_6 = num_6 * arg_7_4
	elseif not get_data.boss then
		num_6 = num_6 * arg_7_3
	end

	return num_6
end

local tbl = {}

local function fn_5(arg_8_0, arg_8_1)
	-- function 8
	return tbl[arg_8_0] > tbl[arg_8_1]
end

TrueFlightUtility.sort = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9)
	-- function 9
	table.clear(tbl)

	for i = 1, #self do
		local var_9_0 = self[i]

		tbl[var_9_0] = fn_4(var_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9)
	end

	table.sort(self, fn_5)

	return tbl
end
