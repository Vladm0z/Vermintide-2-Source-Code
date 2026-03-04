-- chunkname: @scripts/managers/performance_title/performance_title_templates.lua

PerformanceTitles = {}
PerformanceTitles.titles = {
	headhunter = {
		evaluation_template = "equal_higher",
		display_name = "performance_title_headhunter",
		amount = 1,
		stat_types = {
			{
				"headshots"
			}
		}
	},
	doctor = {
		evaluation_template = "equal_higher",
		display_name = "performance_title_doctor",
		amount = 1,
		stat_types = {
			{
				"times_friend_healed"
			}
		}
	},
	savior = {
		evaluation_template = "equal_higher",
		display_name = "performance_title_savior",
		amount = 1,
		stat_types = {
			{
				"saves"
			}
		}
	},
	reviver = {
		evaluation_template = "equal_higher",
		display_name = "performance_title_reviver",
		amount = 1,
		stat_types = {
			{
				"revives"
			}
		}
	}
}

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = 0

	for iter_1_0, iter_1_1 in ipairs(arg_1_2) do
		var_1_0 = var_1_0 + arg_1_0:get_stat(arg_1_1, unpack(iter_1_1))
	end

	return var_1_0
end

PerformanceTitles.templates = {
	equal_higher = {
		evaluate = function (arg_2_0, arg_2_1, arg_2_2)
			local var_2_0 = var_0_0(arg_2_0, arg_2_1, arg_2_2.stat_types)

			return var_2_0 >= arg_2_2.amount, var_2_0
		end,
		compare = function (arg_3_0, arg_3_1)
			return arg_3_1 <= arg_3_0
		end
	}
}

for iter_0_0, iter_0_1 in pairs(PerformanceTitles.titles) do
	fassert(iter_0_1.display_name, "No display name in performance title %s", iter_0_0)

	local var_0_1 = iter_0_1.evaluation_template
	local var_0_2 = PerformanceTitles.templates[var_0_1]

	fassert(var_0_2, "Performance Titles %s failed, no evaluation_template called %s", iter_0_0, tostring(var_0_1))
end
