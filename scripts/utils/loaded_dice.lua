-- chunkname: @scripts/utils/loaded_dice.lua

LoadedDice = {}

function LoadedDice.create(arg_1_0, arg_1_1)
	local var_1_0 = #arg_1_0
	local var_1_1 = {}
	local var_1_2 = {}

	if arg_1_1 then
		var_1_2 = table.clone(arg_1_0)
	else
		local var_1_3 = 0

		for iter_1_0 = 1, var_1_0 do
			var_1_3 = var_1_3 + arg_1_0[iter_1_0]
		end

		for iter_1_1 = 1, var_1_0 do
			var_1_2[iter_1_1] = arg_1_0[iter_1_1] / var_1_3
		end
	end

	local var_1_4 = {}
	local var_1_5 = {}
	local var_1_6 = 1 / var_1_0

	for iter_1_2 = 1, var_1_0 do
		if var_1_6 <= var_1_2[iter_1_2] then
			var_1_5[#var_1_5 + 1] = iter_1_2
		else
			var_1_4[#var_1_4 + 1] = iter_1_2
		end
	end

	while next(var_1_4) ~= nil and next(var_1_5) ~= nil do
		local var_1_7 = var_1_4[#var_1_4]

		var_1_4[#var_1_4] = nil

		local var_1_8 = var_1_5[#var_1_5]

		var_1_5[#var_1_5] = nil
		var_1_1[var_1_7] = var_1_8
		var_1_2[var_1_8] = var_1_2[var_1_8] + var_1_2[var_1_7] - var_1_6

		if var_1_6 <= var_1_2[var_1_8] then
			var_1_5[#var_1_5 + 1] = var_1_8
		else
			var_1_4[#var_1_4 + 1] = var_1_8
		end
	end

	while next(var_1_4) ~= nil do
		var_1_2[var_1_4[#var_1_4]] = var_1_6
		var_1_4[#var_1_4] = nil
	end

	while next(var_1_5) ~= nil do
		var_1_2[var_1_5[#var_1_5]] = var_1_6
		var_1_5[#var_1_5] = nil
	end

	for iter_1_3 = 1, var_1_0 do
		var_1_2[iter_1_3] = var_1_2[iter_1_3] * var_1_0
	end

	return var_1_2, var_1_1
end

function LoadedDice.roll(arg_2_0, arg_2_1)
	local var_2_0 = math.random(1, #arg_2_0)

	return math.random() < arg_2_0[var_2_0] and var_2_0 or arg_2_1[var_2_0]
end

function LoadedDice.roll_seeded(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0, var_3_1 = Math.next_random(arg_3_2, 1, #arg_3_0)
	local var_3_2, var_3_3 = Math.next_random(var_3_0)
	local var_3_4 = var_3_3 < arg_3_0[var_3_1]

	return var_3_2, var_3_4 and var_3_1 or arg_3_1[var_3_1]
end

local var_0_0 = {}

function LoadedDice.create_from_mixed(arg_4_0, arg_4_1)
	local var_4_0 = var_0_0
	local var_4_1 = #arg_4_0 / 2

	for iter_4_0 = var_4_1, #var_4_0 do
		var_4_0[iter_4_0] = nil
	end

	for iter_4_1 = 1, var_4_1 do
		var_4_0[iter_4_1] = arg_4_0[iter_4_1 * 2]
	end

	local var_4_2, var_4_3 = LoadedDice.create(var_4_0, arg_4_1)

	return {
		var_4_2,
		var_4_3
	}
end

function LoadedDice.roll_easy(arg_5_0)
	return LoadedDice.roll(arg_5_0[1], arg_5_0[2])
end

function LoadedDice.roll_easy_seeded(arg_6_0, arg_6_1)
	return LoadedDice.roll_seeded(arg_6_0[1], arg_6_0[2], arg_6_1)
end

function LoadedDice.test()
	local var_7_0 = {
		10,
		5,
		3,
		2
	}
	local var_7_1, var_7_2 = LoadedDice.create(var_7_0, false)
	local var_7_3 = 100000
	local var_7_4 = {
		0,
		0,
		0,
		0
	}

	for iter_7_0 = 1, var_7_3 do
		local var_7_5 = LoadedDice.roll(var_7_1, var_7_2)

		var_7_4[var_7_5] = var_7_4[var_7_5] + 1
	end

	local var_7_6 = "Loaded Dice | "

	for iter_7_1 = 1, #var_7_0 do
		var_7_6 = var_7_6 .. var_7_0[iter_7_1] .. "->" .. var_7_4[iter_7_1] .. "( " .. var_7_4[iter_7_1] / var_7_3 .. "% ) | "
	end

	print(var_7_6)
end
