-- chunkname: @scripts/settings/dlcs/morris/morris_death_reactions.lua

local var_0_0 = {
	destructible_buff_objective_unit = {
		unit = {
			pre_start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				return
			end,
			start = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				Managers.state.game_mode:level_object_killed(arg_2_0, arg_2_3)
				Unit.set_flow_variable(arg_2_0, "current_health", 0)
				Unit.flow_event(arg_2_0, "lua_on_death")
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				Managers.state.unit_spawner:mark_for_deletion(arg_3_0)

				return DeathReactions.IS_DONE
			end
		},
		husk = {
			pre_start = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				Managers.state.game_mode:level_object_killed(arg_4_0, arg_4_3)
				Unit.flow_event(arg_4_0, "lua_on_death")
			end,
			start = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				return
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				return DeathReactions.IS_DONE
			end
		}
	},
	chaos_greed_pinata = table.clone(DeathReactions.templates.ai_default)
}

var_0_0.chaos_greed_pinata.unit.start = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0, var_7_1 = DeathReactions.templates.ai_default.unit.start(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)

	if arg_7_4 then
		local var_7_2 = Managers.state.entity:system("dialogue_system"):get_random_player()

		if var_7_2 then
			local var_7_3 = ScriptUnit.extension_input(var_7_2, "dialogue_system")
			local var_7_4 = FrameTable.alloc_table()

			var_7_3:trigger_dialogue_event("curse_very_positive_effect_happened", var_7_4)
		end
	end

	return var_7_0, var_7_1
end

return var_0_0
