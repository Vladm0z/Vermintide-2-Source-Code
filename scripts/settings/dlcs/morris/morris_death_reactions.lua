-- chunkname: @scripts/settings/dlcs/morris/morris_death_reactions.lua

local tbl = {
	destructible_buff_objective_unit = {
		unit = {
			pre_start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				return
			end,
			start = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				Managers.state.game_mode:level_object_killed(arg_2_0, arg_2_3)
				Unit.set_flow_variable(arg_2_0, "current_health", 0)
				Unit.flow_event(arg_2_0, "lua_on_death")
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				Managers.state.unit_spawner:mark_for_deletion(arg_3_0)

				return DeathReactions.IS_DONE
			end
		},
		husk = {
			pre_start = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				Managers.state.game_mode:level_object_killed(arg_4_0, arg_4_3)
				Unit.flow_event(arg_4_0, "lua_on_death")
			end,
			start = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				return
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				return DeathReactions.IS_DONE
			end
		}
	},
	chaos_greed_pinata = table.clone(DeathReactions.templates.ai_default)
}

tbl.chaos_greed_pinata.unit.start = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local start, var_7_1 = DeathReactions.templates.ai_default.unit.start(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)

	if not arg_7_4 then
		local get_random_player = Managers.state.entity:system("dialogue_system"):get_random_player()

		if not get_random_player then
			local extension_input = ScriptUnit.extension_input(get_random_player, "dialogue_system")
			local alloc_table = FrameTable.alloc_table()

			extension_input:trigger_dialogue_event("curse_very_positive_effect_happened", alloc_table)
		end
	end

	return start, var_7_1
end

return tbl
