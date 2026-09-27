-- chunkname: @scripts/managers/achievements/achievement_templates_gecko.lua

local var_0_0 = rawget(_G, "LevelSettings")

for k, v in pairs(var_0_0) do
	if not table.contains(UnlockableLevels, k) then
		local count = #QuestSettings.scrap_count_level

		for k_2 = 1, count do
			local str = "gecko_scraps_" .. k .. "_" .. k_2
			local str_2 = "collected_painting_scraps"

			AchievementTemplates.achievements[str] = {
				name = "achv_" .. str .. "_name",
				icon = "achievement_trophy_gecko_scraps_" .. k,
				desc = function ()
					-- function 1
					return string.format(Localize("achv_" .. str .. "_desc"), QuestSettings.scrap_count_level[k_2])
				end,
				completed = function (self, arg_2_1)
					-- function 2
					return self:get_persistent_stat(arg_2_1, str_2, k) >= QuestSettings.scrap_count_level[k_2]
				end,
				progress = function (self, arg_3_1)
					-- function 3
					local get_persistent_stat = self:get_persistent_stat(arg_3_1, str_2, k)
					local min = math.min(get_persistent_stat, QuestSettings.scrap_count_level[k_2])

					return {
						min,
						QuestSettings.scrap_count_level[k_2]
					}
				end
			}
		end
	end
end

local count_2 = #QuestSettings.scrap_count_generic

for l = 1, count_2 do
	local str_3 = "gecko_scraps_generic_" .. l

	AchievementTemplates.achievements[str_3] = {
		icon = "achievement_trophy_gecko_scraps_generic",
		name = "achv_" .. str_3 .. "_name",
		desc = function ()
			-- function 4
			return string.format(Localize("achv_" .. str_3 .. "_desc"), QuestSettings.scrap_count_generic[l])
		end,
		completed = function (self, arg_5_1)
			-- function 5
			local var_5_0
			local str = "collected_painting_scraps_generic"
			local get_persistent_stat = self:get_persistent_stat(arg_5_1, str)

			return not get_persistent_stat and get_persistent_stat >= QuestSettings.scrap_count_generic[l]
		end,
		progress = function (self, arg_6_1)
			-- function 6
			local var_6_0
			local str = "collected_painting_scraps_generic"
			local get_persistent_stat = self:get_persistent_stat(arg_6_1, str)
			local min = math.min(get_persistent_stat, QuestSettings.scrap_count_generic[l])

			return {
				min,
				QuestSettings.scrap_count_generic[l]
			}
		end
	}
end
