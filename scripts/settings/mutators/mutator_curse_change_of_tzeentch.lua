-- chunkname: @scripts/settings/mutators/mutator_curse_change_of_tzeentch.lua

local var_0_0 = require("scripts/settings/mutators/mutator_splitting_enemies")
local var_0_1 = table.clone(var_0_0)

var_0_1.display_name = "curse_change_of_tzeentch_name"
var_0_1.description = "curse_change_of_tzeentch_desc"
var_0_1.icon = "deus_curse_tzeentch_01"

local var_0_2 = 0.25

function var_0_1.server_start_function(arg_1_0, arg_1_1)
	var_0_0.server_start_function(arg_1_0, arg_1_1)

	arg_1_1.seed = Managers.mechanism:get_level_seed("mutator")
end

function var_0_1.server_ai_killed_function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0
	local var_2_1

	arg_2_1.seed, var_2_1 = Math.next_random(arg_2_1.seed)

	if var_2_1 > var_0_2 then
		return
	end

	var_0_0.server_ai_killed_function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end

function var_0_1.on_split_enemy(arg_3_0)
	if HEALTH_ALIVE[arg_3_0] and Managers.player:is_player_unit(arg_3_0) then
		local var_3_0 = ScriptUnit.extension_input(arg_3_0, "dialogue_system")
		local var_3_1 = FrameTable.alloc_table()

		var_3_0:trigger_dialogue_event("curse_negative_effect_happened", var_3_1)
	end
end

return var_0_1
