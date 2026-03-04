-- chunkname: @scripts/settings/difficulty_tweak.lua

local var_0_0 = 10

local function var_0_1(arg_1_0, arg_1_1)
	for iter_1_0 = table.index_of(Difficulties, arg_1_0), 1, -1 do
		local var_1_0 = arg_1_1[Difficulties[iter_1_0]]

		if var_1_0 then
			return var_1_0
		end
	end
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = table.index_of(Difficulties, arg_2_0)

	fassert(var_2_0 ~= -1, "need an existing difficulty")
	fassert(arg_2_1 > 0, "need at least one step")
	fassert(arg_2_2 >= -var_0_0 and arg_2_2 <= var_0_0, "tweak needs to be an integer from -" .. var_0_0 .. " to " .. var_0_0)

	local var_2_1 = math.round(math.lerp(-arg_2_1, arg_2_1, (arg_2_2 + var_0_0) / (var_0_0 * 2)))
	local var_2_2 = math.clamp(var_2_0 + var_2_1, 1, #Difficulties)

	return Difficulties[var_2_2]
end

local function var_0_3(arg_3_0, arg_3_1, arg_3_2)
	fassert(arg_3_1 > 0, "need at least one step")
	fassert(arg_3_2 >= -var_0_0 and arg_3_2 <= var_0_0, "tweak needs to be an integer from -" .. var_0_0 .. " to " .. var_0_0)

	local var_3_0 = math.round(math.lerp(-arg_3_1, arg_3_1, (arg_3_2 + var_0_0) / (var_0_0 * 2)))

	return math.clamp(arg_3_0 + var_3_0, MinimumDifficultyRank, MaximumDifficultyRank)
end

local function var_0_4(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = var_0_1(arg_4_0, arg_4_2)

	fassert(var_4_0, "Value doesn't exist for difficulty " .. arg_4_0 .. " or for lower difficulties, config needs to be added.")

	if arg_4_1 == 0 then
		return var_4_0
	end

	local var_4_1 = var_0_2(arg_4_0, 1, arg_4_1)
	local var_4_2 = var_0_1(var_4_1, arg_4_2)

	fassert(var_4_2, "Value doesn't exist for difficulty " .. var_4_1 .. " or for lower difficulties, config needs to be added.")

	local var_4_3 = math.abs(arg_4_1 / var_0_0)

	return math.lerp(var_4_0, var_4_2, var_4_3)
end

local function var_0_5(arg_5_0, arg_5_1, arg_5_2)
	fassert(arg_5_1 >= -var_0_0 and arg_5_1 <= var_0_0, "tweak needs to be an integer from -" .. var_0_0 .. " to " .. var_0_0)

	local var_5_0 = arg_5_2[arg_5_0]

	if var_5_0 then
		for iter_5_0 = arg_5_1, -var_0_0, -1 do
			local var_5_1 = var_5_0[iter_5_0]

			if var_5_1 then
				return var_5_1
			end
		end
	end

	return nil
end

DifficultyTweak = DifficultyTweak or {
	range = var_0_0,
	converters = {
		composition = function(arg_6_0, arg_6_1)
			return var_0_2(arg_6_0, 2, arg_6_1)
		end,
		composition_rank = function(arg_7_0, arg_7_1)
			return var_0_3(arg_7_0, 2, arg_7_1)
		end,
		pacing = function(arg_8_0, arg_8_1)
			return var_0_2(arg_8_0, 2, arg_8_1)
		end,
		intensity = function(arg_9_0, arg_9_1)
			return var_0_2(arg_9_0, 2, arg_9_1)
		end,
		tweaked_delay_threat_value = function(arg_10_0, arg_10_1, arg_10_2)
			return var_0_4(arg_10_0, arg_10_1, arg_10_2)
		end,
		closest_tweak_match = function(arg_11_0, arg_11_1, arg_11_2)
			return var_0_5(arg_11_0, arg_11_1, arg_11_2)
		end
	}
}
