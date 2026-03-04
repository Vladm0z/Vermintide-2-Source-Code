-- chunkname: @scripts/managers/achievements/achievement_templates_gecko.lua

local var_0_0 = rawget(_G, "LevelSettings")

for iter_0_0, iter_0_1 in pairs(var_0_0) do
	if table.contains(UnlockableLevels, iter_0_0) then
		local var_0_1 = #QuestSettings.scrap_count_level

		for iter_0_2 = 1, var_0_1 do
			local var_0_2 = "gecko_scraps_" .. iter_0_0 .. "_" .. iter_0_2
			local var_0_3 = "collected_painting_scraps"

			AchievementTemplates.achievements[var_0_2] = {
				name = "achv_" .. var_0_2 .. "_name",
				icon = "achievement_trophy_gecko_scraps_" .. iter_0_0,
				desc = function ()
					return string.format(Localize("achv_" .. var_0_2 .. "_desc"), QuestSettings.scrap_count_level[iter_0_2])
				end,
				completed = function (arg_2_0, arg_2_1)
					return arg_2_0:get_persistent_stat(arg_2_1, var_0_3, iter_0_0) >= QuestSettings.scrap_count_level[iter_0_2]
				end,
				progress = function (arg_3_0, arg_3_1)
					local var_3_0 = arg_3_0:get_persistent_stat(arg_3_1, var_0_3, iter_0_0)
					local var_3_1 = math.min(var_3_0, QuestSettings.scrap_count_level[iter_0_2])

					return {
						var_3_1,
						QuestSettings.scrap_count_level[iter_0_2]
					}
				end
			}
		end
	end
end

local var_0_4 = #QuestSettings.scrap_count_generic

for iter_0_3 = 1, var_0_4 do
	local var_0_5 = "gecko_scraps_generic_" .. iter_0_3

	AchievementTemplates.achievements[var_0_5] = {
		icon = "achievement_trophy_gecko_scraps_generic",
		name = "achv_" .. var_0_5 .. "_name",
		desc = function ()
			return string.format(Localize("achv_" .. var_0_5 .. "_desc"), QuestSettings.scrap_count_generic[iter_0_3])
		end,
		completed = function (arg_5_0, arg_5_1)
			local var_5_0
			local var_5_1 = "collected_painting_scraps_generic"
			local var_5_2 = arg_5_0:get_persistent_stat(arg_5_1, var_5_1)

			return var_5_2 and var_5_2 >= QuestSettings.scrap_count_generic[iter_0_3]
		end,
		progress = function (arg_6_0, arg_6_1)
			local var_6_0
			local var_6_1 = "collected_painting_scraps_generic"
			local var_6_2 = arg_6_0:get_persistent_stat(arg_6_1, var_6_1)
			local var_6_3 = math.min(var_6_2, QuestSettings.scrap_count_generic[iter_0_3])

			return {
				var_6_3,
				QuestSettings.scrap_count_generic[iter_0_3]
			}
		end
	}
end
