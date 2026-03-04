-- chunkname: @scripts/settings/mutators/mutator_deus_difficulty_tweak.lua

local var_0_0 = {
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
local var_0_1 = {
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
local var_0_2 = {
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
local var_0_3 = "deus_difficulty_tweak_boss_buff"

local function var_0_4(arg_1_0, arg_1_1)
	fassert(#arg_1_0 >= 1, "need at least one step for the difficulty lerp to work.")

	local var_1_0
	local var_1_1

	for iter_1_0 = 1, #var_0_0 do
		local var_1_2 = var_0_0[iter_1_0]

		if arg_1_1 <= var_1_2[1] then
			local var_1_3 = var_0_0[iter_1_0 - 1]
			local var_1_4 = var_0_0[iter_1_0 + 1]

			var_1_0 = var_1_3 or var_1_2
			var_1_1 = var_1_3 and var_1_2 or var_1_4

			break
		end
	end

	if var_1_0 then
		local var_1_5 = var_1_1[1] - var_1_0[1]
		local var_1_6 = (arg_1_1 - var_1_0[1]) / var_1_5

		return (math.lerp(var_1_0[2], var_1_1[2], var_1_6))
	end
end

return {
	hide_from_player_ui = true,
	tweak_pack_spawning_settings = function(arg_2_0, arg_2_1)
		local var_2_0, var_2_1 = Managers.state.difficulty:get_difficulty()
		local var_2_2 = var_0_4(var_0_0, var_2_1)

		MutatorUtils.tweak_pack_spawning_settings_density_multiplier(arg_2_1, var_2_2)

		local var_2_3 = var_0_4(var_0_1, var_2_1)
		local var_2_4 = var_0_4(var_0_2, var_2_1)

		MutatorUtils.tweak_pack_spawning_settings_override_chance(arg_2_1, var_2_3, var_2_4)
	end,
	server_ai_spawned_function = function(arg_3_0, arg_3_1, arg_3_2)
		if Unit.get_data(arg_3_2, "breed").boss then
			local var_3_0, var_3_1 = Managers.state.difficulty:get_difficulty()
			local var_3_2 = DifficultyTweak.range
			local var_3_3 = (var_3_1 + var_3_2) / (var_3_2 * 2)
			local var_3_4 = {
				variable_value = var_3_3
			}

			ScriptUnit.extension(arg_3_2, "buff_system"):add_buff(var_0_3, var_3_4)
		end
	end
}
