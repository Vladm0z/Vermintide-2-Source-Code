-- chunkname: @scripts/settings/difficulty_tweak.lua

local num = 10

local function fn(arg_1_0, arg_1_1)
	-- function 1
	for i = table.index_of(Difficulties, arg_1_0), 1, -1 do
		local var_1_0 = arg_1_1[Difficulties[i]]

		if not var_1_0 then
			return var_1_0
		end
	end
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local index_of = table.index_of(Difficulties, arg_2_0)

	fassert(index_of ~= -1, "need an existing difficulty")
	fassert(arg_2_1 > 0, "need at least one step")
	fassert(not (arg_2_2 >= -num) or arg_2_2 <= num, "tweak needs to be an integer from -" .. num .. " to " .. num)

	local round = math.round(math.lerp(-arg_2_1, arg_2_1, (arg_2_2 + num) / (num * 2)))
	local clamp = math.clamp(index_of + round, 1, #Difficulties)

	return Difficulties[clamp]
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	fassert(arg_3_1 > 0, "need at least one step")
	fassert(not (arg_3_2 >= -num) or arg_3_2 <= num, "tweak needs to be an integer from -" .. num .. " to " .. num)

	local round = math.round(math.lerp(-arg_3_1, arg_3_1, (arg_3_2 + num) / (num * 2)))

	return math.clamp(arg_3_0 + round, MinimumDifficultyRank, MaximumDifficultyRank)
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = fn(arg_4_0, arg_4_2)

	fassert(var_4_0, "Value doesn't exist for difficulty " .. arg_4_0 .. " or for lower difficulties, config needs to be added.")

	if arg_4_1 == 0 then
		return var_4_0
	end

	local var_4_1 = fn_2(arg_4_0, 1, arg_4_1)
	local var_4_2 = fn(var_4_1, arg_4_2)

	fassert(var_4_2, "Value doesn't exist for difficulty " .. var_4_1 .. " or for lower difficulties, config needs to be added.")

	local abs = math.abs(arg_4_1 / num)

	return math.lerp(var_4_0, var_4_2, abs)
end

local function fn_5(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	fassert(not (arg_5_1 >= -num) or arg_5_1 <= num, "tweak needs to be an integer from -" .. num .. " to " .. num)

	local var_5_0 = arg_5_2[arg_5_0]

	if not var_5_0 then
		for i = arg_5_1, -num, -1 do
			local var_5_1 = var_5_0[i]

			if not var_5_1 then
				return var_5_1
			end
		end
	end

	return nil
end

local DifficultyTweak = DifficultyTweak

DifficultyTweak = DifficultyTweak or {
	range = num,
	converters = {
		composition = function (arg_6_0, arg_6_1)
			-- function 6
			return fn_2(arg_6_0, 2, arg_6_1)
		end,
		composition_rank = function (arg_7_0, arg_7_1)
			-- function 7
			return fn_3(arg_7_0, 2, arg_7_1)
		end,
		pacing = function (arg_8_0, arg_8_1)
			-- function 8
			return fn_2(arg_8_0, 2, arg_8_1)
		end,
		intensity = function (arg_9_0, arg_9_1)
			-- function 9
			return fn_2(arg_9_0, 2, arg_9_1)
		end,
		tweaked_delay_threat_value = function (arg_10_0, arg_10_1, arg_10_2)
			-- function 10
			return fn_4(arg_10_0, arg_10_1, arg_10_2)
		end,
		closest_tweak_match = function (arg_11_0, arg_11_1, arg_11_2)
			-- function 11
			return fn_5(arg_11_0, arg_11_1, arg_11_2)
		end
	}
}
DifficultyTweak = DifficultyTweak
