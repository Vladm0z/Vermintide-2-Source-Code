-- chunkname: @scripts/utils/loaded_dice.lua

LoadedDice = {}

LoadedDice.create = function (self, arg_1_1)
	-- function 1
	local count = #self
	local tbl = {}
	local tbl_2 = {}

	if not arg_1_1 then
		tbl_2 = table.clone(self)
	else
		local num = 0

		for i = 1, count do
			num = num + self[i]
		end

		for j = 1, count do
			tbl_2[j] = self[j] / num
		end
	end

	local tbl_3 = {}
	local tbl_4 = {}
	local num_2 = 1 / count

	for k = 1, count do
		if num_2 <= tbl_2[k] then
			tbl_4[#tbl_4 + 1] = k
		else
			tbl_3[#tbl_3 + 1] = k
		end
	end

	while not (next(tbl_3) == nil or next(tbl_4) == nil) do
		local var_1_7 = tbl_3[#tbl_3]

		tbl_3[#tbl_3] = nil

		local var_1_8 = tbl_4[#tbl_4]

		tbl_4[#tbl_4] = nil
		tbl[var_1_7] = var_1_8
		tbl_2[var_1_8] = tbl_2[var_1_8] + tbl_2[var_1_7] - num_2

		if num_2 <= tbl_2[var_1_8] then
			tbl_4[#tbl_4 + 1] = var_1_8
		else
			tbl_3[#tbl_3 + 1] = var_1_8
		end
	end

	while next(tbl_3) ~= nil do
		tbl_2[tbl_3[#tbl_3]] = num_2
		tbl_3[#tbl_3] = nil
	end

	while next(tbl_4) ~= nil do
		tbl_2[tbl_4[#tbl_4]] = num_2
		tbl_4[#tbl_4] = nil
	end

	for l = 1, count do
		tbl_2[l] = tbl_2[l] * count
	end

	return tbl_2, tbl
end

LoadedDice.roll = function (self, arg_2_1)
	-- function 2
	local random = math.random(1, #self)

	return not (math.random() < self[random]) and random and arg_2_1[random]
end

LoadedDice.roll_seeded = function (self, arg_3_1, arg_3_2)
	-- function 3
	local next_random, var_3_1 = Math.next_random(arg_3_2, 1, #self)
	local next_random_2, var_3_3 = Math.next_random(next_random)
	local flag = var_3_3 < self[var_3_1]

	return next_random_2, not flag and var_3_1 and arg_3_1[var_3_1]
end

local tbl = {}

LoadedDice.create_from_mixed = function (self, arg_4_1)
	-- function 4
	local var_4_0 = tbl
	local num = #self / 2

	for i = num, #var_4_0 do
		var_4_0[i] = nil
	end

	for j = 1, num do
		var_4_0[j] = self[j * 2]
	end

	local var_4_2, var_4_3 = LoadedDice.create(var_4_0, arg_4_1)

	return {
		var_4_2,
		var_4_3
	}
end

LoadedDice.roll_easy = function (self)
	-- function 5
	return LoadedDice.roll(self[1], self[2])
end

LoadedDice.roll_easy_seeded = function (self, arg_6_1)
	-- function 6
	return LoadedDice.roll_seeded(self[1], self[2], arg_6_1)
end

LoadedDice.test = function ()
	-- function 7
	local tbl = {
		10,
		5,
		3,
		2
	}
	local var_7_1, var_7_2 = LoadedDice.create(tbl, false)
	local num = 100000
	local tbl_2 = {
		0,
		0,
		0,
		0
	}

	for i = 1, num do
		local roll = LoadedDice.roll(var_7_1, var_7_2)

		tbl_2[roll] = tbl_2[roll] + 1
	end

	local str = "Loaded Dice | "

	for j = 1, #tbl do
		str = str .. tbl[j] .. "->" .. tbl_2[j] .. "( " .. tbl_2[j] / num .. "% ) | "
	end

	print(str)
end
