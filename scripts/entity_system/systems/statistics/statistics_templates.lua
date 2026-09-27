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
		-- function 1
		return {
			kills_total_last = 0,
			kill_times_n = 0,
			kill_times = {}
		}
	end,
	update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local multikill = arg_2_1.multikill
		local kills_total_last = multikill.kills_total_last
		local get_stat = arg_2_2.statistics_db:get_stat(arg_2_1.statistics_id, "kills_total")

		if get_stat <= kills_total_last then
			return
		end

		local time_window = StatisticsTemplates.multikill.config.time_window
		local kills_to_get = StatisticsTemplates.multikill.config.kills_to_get
		local kill_times = multikill.kill_times
		local kill_times_n = multikill.kill_times_n
		local num = 1

		while num <= kill_times_n do
			if arg_2_3 > kill_times[num] + time_window then
				kill_times[num] = kill_times[kill_times_n]
				kill_times[kill_times_n] = nil
				kill_times_n = kill_times_n - 1
			else
				num = num + 1
			end
		end

		local num_2 = kill_times_n + 1

		kill_times[num_2] = arg_2_3

		if kills_to_get <= num_2 then
			local player_profile = ScriptUnit.extension(arg_2_0, "dialogue_system").context.player_profile

			SurroundingAwareSystem.add_event(arg_2_0, "multikill", DialogueSettings.default_view_distance, "profile_name", player_profile, "number_of_kills", num_2)
		end

		multikill.kill_times_n = num_2
		multikill.kills_total_last = get_stat
	end
}

local tbl = {}

for k, v in pairs(StatisticsTemplates) do
	v.name = k
end

for k_2, v_2 in pairs(StatisticsTemplateCategories) do
	assert(StatisticsTemplates[k_2] == nil, "Statistics templates: Can't have category with the same name as a template")
end
