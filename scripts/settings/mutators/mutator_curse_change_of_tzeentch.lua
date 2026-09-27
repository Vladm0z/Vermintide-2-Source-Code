-- chunkname: @scripts/settings/mutators/mutator_curse_change_of_tzeentch.lua

local scripts_settings_mutators_mutator_splitting_enemies = require("scripts/settings/mutators/mutator_splitting_enemies")
local clone = table.clone(scripts_settings_mutators_mutator_splitting_enemies)

clone.display_name = "curse_change_of_tzeentch_name"
clone.description = "curse_change_of_tzeentch_desc"
clone.icon = "deus_curse_tzeentch_01"

local num = 0.25

clone.server_start_function = function (arg_1_0, arg_1_1)
	-- function 1
	scripts_settings_mutators_mutator_splitting_enemies.server_start_function(arg_1_0, arg_1_1)

	arg_1_1.seed = Managers.mechanism:get_level_seed("mutator")
end

clone.server_ai_killed_function = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local var_2_0
	local var_2_1

	arg_2_1.seed, var_2_1 = Math.next_random(arg_2_1.seed)

	if var_2_1 > num then
		return
	end

	scripts_settings_mutators_mutator_splitting_enemies.server_ai_killed_function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end

clone.on_split_enemy = function (arg_3_0)
	-- function 3
	if not HEALTH_ALIVE[arg_3_0] and not Managers.player:is_player_unit(arg_3_0) then
		local extension_input = ScriptUnit.extension_input(arg_3_0, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event("curse_negative_effect_happened", alloc_table)
	end
end

return clone
