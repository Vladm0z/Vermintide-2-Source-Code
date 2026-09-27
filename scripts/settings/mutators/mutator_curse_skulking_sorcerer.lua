-- chunkname: @scripts/settings/mutators/mutator_curse_skulking_sorcerer.lua

local scripts_settings_mutators_mutator_skulking_sorcerer = require("scripts/settings/mutators/mutator_skulking_sorcerer")
local clone = table.clone(scripts_settings_mutators_mutator_skulking_sorcerer)
local num = 2
local num_2 = 3
local num_3 = 4
local num_4 = 5
local num_5 = 6
local num_6 = 6
local num_7 = 7
local tbl = {
	[num] = 30,
	[num_2] = 30,
	[num_3] = 30,
	[num_4] = 30,
	[num_5] = 30
}
local tbl_2 = {
	[num] = 20,
	[num_2] = 30,
	[num_3] = 44,
	[num_4] = 66,
	[num_5] = 90,
	[num_6] = 120,
	[num_7] = 150
}

clone.display_name = "curse_skulking_sorcerer_name"
clone.description = "curse_skulking_sorcerer_desc"
clone.icon = "deus_curse_nurgle_01"

clone.server_initialize_function = function (arg_1_0, arg_1_1)
	-- function 1
	MutatorUtils.store_breed_and_action_settings(arg_1_0, arg_1_1)

	Breeds.curse_mutator_sorcerer.max_health = tbl_2
end

clone.server_start_function = function (arg_2_0, arg_2_1)
	-- function 2
	scripts_settings_mutators_mutator_skulking_sorcerer.server_start_function(arg_2_0, arg_2_1)

	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_2_1 = tbl[get_difficulty_rank]

	var_2_1 = var_2_1 or tbl[num]
	arg_2_1.respawn_times = {
		var_2_1,
		var_2_1 + 1
	}
	arg_2_1.breed_name = "curse_mutator_sorcerer"
end

clone.server_stop_function = function (arg_3_0, arg_3_1)
	-- function 3
	MutatorUtils.restore_breed_and_action_settings(arg_3_0, arg_3_1)
end

clone.server_ai_killed_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if (arg_4_4.breed.name ~= "curse_mutator_sorcerer" or not HEALTH_ALIVE[arg_4_3]) and not Managers.player:is_player_unit(arg_4_3) then
		local extension_input = ScriptUnit.extension_input(arg_4_3, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event("curse_positive_effect_happened", alloc_table)
	end
end

return clone
