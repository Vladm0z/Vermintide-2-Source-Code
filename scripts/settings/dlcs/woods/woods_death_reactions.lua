-- chunkname: @scripts/settings/dlcs/woods/woods_death_reactions.lua

return {
	thorn_wall = {
		unit = {
			pre_start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				return
			end,
			start = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = ScriptUnit.extension(arg_2_0, "door_system")

				var_2_0.dead = true

				var_2_0:update_nav_graphs()

				local var_2_1 = ScriptUnit.has_extension(arg_2_0, "props_system")

				if var_2_1 then
					var_2_1:die()
				end
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				return DeathReactions.IS_DONE
			end
		},
		husk = {
			pre_start = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			start = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = ScriptUnit.has_extension(arg_5_0, "props_system")

				if var_5_0 then
					var_5_0:die()
				end
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				return DeathReactions.IS_DONE
			end
		}
	}
}
