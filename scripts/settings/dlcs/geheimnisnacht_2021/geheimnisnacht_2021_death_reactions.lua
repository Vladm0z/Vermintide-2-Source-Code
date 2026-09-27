-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_death_reactions.lua

return {
	geheimnisnacht_2021_altar = {
		unit = {
			pre_start = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				return
			end,
			start = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local has_extension = ScriptUnit.has_extension(arg_2_0, "props_system")

				if not has_extension then
					has_extension:die()
				end

				return nil, DeathReactions.IS_DONE
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				return DeathReactions.IS_DONE
			end
		},
		husk = {
			pre_start = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end,
			start = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local has_extension = ScriptUnit.has_extension(arg_5_0, "props_system")

				if not has_extension then
					has_extension:die()
				end

				return nil, DeathReactions.IS_DONE
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				return DeathReactions.IS_DONE
			end
		}
	}
}
