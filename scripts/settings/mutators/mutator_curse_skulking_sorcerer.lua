-- chunkname: @scripts/settings/mutators/mutator_curse_skulking_sorcerer.lua

local var_0_0 = require("scripts/settings/mutators/mutator_skulking_sorcerer")
local var_0_1 = table.clone(var_0_0)
local var_0_2 = 2
local var_0_3 = 3
local var_0_4 = 4
local var_0_5 = 5
local var_0_6 = 6
local var_0_7 = 6
local var_0_8 = 7
local var_0_9 = {
	[var_0_2] = 30,
	[var_0_3] = 30,
	[var_0_4] = 30,
	[var_0_5] = 30,
	[var_0_6] = 30
}
local var_0_10 = {
	[var_0_2] = 20,
	[var_0_3] = 30,
	[var_0_4] = 44,
	[var_0_5] = 66,
	[var_0_6] = 90,
	[var_0_7] = 120,
	[var_0_8] = 150
}

var_0_1.display_name = "curse_skulking_sorcerer_name"
var_0_1.description = "curse_skulking_sorcerer_desc"
var_0_1.icon = "deus_curse_nurgle_01"

var_0_1.server_initialize_function = function (arg_1_0, arg_1_1)
	MutatorUtils.store_breed_and_action_settings(arg_1_0, arg_1_1)

	Breeds.curse_mutator_sorcerer.max_health = var_0_10
end

var_0_1.server_start_function = function (arg_2_0, arg_2_1)
	var_0_0.server_start_function(arg_2_0, arg_2_1)

	local var_2_0 = Managers.state.difficulty:get_difficulty_rank()
	local var_2_1 = var_0_9[var_2_0] or var_0_9[var_0_2]

	arg_2_1.respawn_times = {
		var_2_1,
		var_2_1 + 1
	}
	arg_2_1.breed_name = "curse_mutator_sorcerer"
end

var_0_1.server_stop_function = function (arg_3_0, arg_3_1)
	MutatorUtils.restore_breed_and_action_settings(arg_3_0, arg_3_1)
end

var_0_1.server_ai_killed_function = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_4.breed.name == "curse_mutator_sorcerer" and HEALTH_ALIVE[arg_4_3] and Managers.player:is_player_unit(arg_4_3) then
		local var_4_0 = ScriptUnit.extension_input(arg_4_3, "dialogue_system")
		local var_4_1 = FrameTable.alloc_table()

		var_4_0:trigger_dialogue_event("curse_positive_effect_happened", var_4_1)
	end
end

return var_0_1
