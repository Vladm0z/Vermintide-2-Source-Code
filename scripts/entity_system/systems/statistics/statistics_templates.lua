-- chunkname: @scripts/entity_system/systems/statistics/statistics_templates.lua

StatisticsTemplateCategories = {}
StatisticsTemplateCategories.player = {
	"multikill"
}
StatisticsTemplates = {}
StatisticsTemplates.multikill = {
	config = {
		kills_to_get = 1,
		time_window = 10
	},
	init = function ()
		return {
			kills_total_last = 0,
			kill_times_n = 0,
			kill_times = {}
		}
	end,
	update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = arg_2_1.multikill
		local var_2_1 = var_2_0.kills_total_last
		local var_2_2 = arg_2_2.statistics_db:get_stat(arg_2_1.statistics_id, "kills_total")

		if var_2_2 <= var_2_1 then
			return
		end

		local var_2_3 = StatisticsTemplates.multikill.config.time_window
		local var_2_4 = StatisticsTemplates.multikill.config.kills_to_get
		local var_2_5 = var_2_0.kill_times
		local var_2_6 = var_2_0.kill_times_n
		local var_2_7 = 1

		while var_2_7 <= var_2_6 do
			if arg_2_3 > var_2_5[var_2_7] + var_2_3 then
				var_2_5[var_2_7] = var_2_5[var_2_6]
				var_2_5[var_2_6] = nil
				var_2_6 = var_2_6 - 1
			else
				var_2_7 = var_2_7 + 1
			end
		end

		local var_2_8 = var_2_6 + 1

		var_2_5[var_2_8] = arg_2_3

		if var_2_4 <= var_2_8 then
			local var_2_9 = ScriptUnit.extension(arg_2_0, "dialogue_system").context.player_profile

			SurroundingAwareSystem.add_event(arg_2_0, "multikill", DialogueSettings.default_view_distance, "profile_name", var_2_9, "number_of_kills", var_2_8)
		end

		var_2_0.kill_times_n = var_2_8
		var_2_0.kills_total_last = var_2_2
	end
}

local var_0_0 = {}

for iter_0_0, iter_0_1 in pairs(StatisticsTemplates) do
	iter_0_1.name = iter_0_0
end

for iter_0_2, iter_0_3 in pairs(StatisticsTemplateCategories) do
	assert(StatisticsTemplates[iter_0_2] == nil, "Statistics templates: Can't have category with the same name as a template")
end
