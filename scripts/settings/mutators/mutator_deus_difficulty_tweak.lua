-- chunkname: @scripts/settings/mutators/mutator_deus_difficulty_tweak.lua

local tbl = {
	{
		-10,
		1
	},
	{
		0,
		1.15
	},
	{
		10,
		1.3
	}
}
local tbl_2 = {
	{
		-10,
		0.1
	},
	{
		0,
		0.4
	},
	{
		10,
		0.8
	}
}
local tbl_3 = {
	{
		-10,
		0.3
	},
	{
		0,
		0.6
	},
	{
		10,
		1
	}
}
local str = "deus_difficulty_tweak_boss_buff"

local function fn(arg_1_0, arg_1_1)
	-- function 1
	fassert(#arg_1_0 >= 1, "need at least one step for the difficulty lerp to work.")

	local var_1_0
	local var_1_1

	for i = 1, #tbl do
		local var_1_2 = tbl[i]

		if arg_1_1 <= var_1_2[1] then
			local var_1_3 = tbl[i - 1]
			local var_1_4 = tbl[i + 1]

			var_1_0 = var_1_3 or var_1_2
			var_1_1 = not var_1_3 and var_1_2 and var_1_4

			break
		end
	end

	if not var_1_0 then
		local num = var_1_1[1] - var_1_0[1]
		local num_2 = (arg_1_1 - var_1_0[1]) / num

		return (math.lerp(var_1_0[2], var_1_1[2], num_2))
	end
end

return {
	hide_from_player_ui = true,
	tweak_pack_spawning_settings = function (arg_2_0, arg_2_1)
		-- function 2
		local get_difficulty, var_2_1 = Managers.state.difficulty:get_difficulty()
		local var_2_2 = fn(tbl, var_2_1)

		MutatorUtils.tweak_pack_spawning_settings_density_multiplier(arg_2_1, var_2_2)

		local var_2_3 = fn(tbl_2, var_2_1)
		local var_2_4 = fn(tbl_3, var_2_1)

		MutatorUtils.tweak_pack_spawning_settings_override_chance(arg_2_1, var_2_3, var_2_4)
	end,
	server_ai_spawned_function = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		if not Unit.get_data(arg_3_2, "breed").boss then
			local get_difficulty, var_3_1 = Managers.state.difficulty:get_difficulty()
			local range = DifficultyTweak.range
			local num = (var_3_1 + range) / (range * 2)
			local tbl = {
				variable_value = num
			}

			ScriptUnit.extension(arg_3_2, "buff_system"):add_buff(str, tbl)
		end
	end
}
