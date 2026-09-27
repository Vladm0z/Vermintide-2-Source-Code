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

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	local num = 0

	for i, v in ipairs(arg_1_2) do
		num = num + self:get_stat(arg_1_1, unpack(v))
	end

	return num
end

PerformanceTitles.templates = {
	equal_higher = {
		evaluate = function (arg_2_0, arg_2_1, arg_2_2)
			-- function 2
			local var_2_0 = fn(arg_2_0, arg_2_1, arg_2_2.stat_types)

			return var_2_0 >= arg_2_2.amount, var_2_0
		end,
		compare = function (arg_3_0, arg_3_1)
			-- function 3
			return arg_3_1 <= arg_3_0
		end
	}
}

for k, v in pairs(PerformanceTitles.titles) do
	fassert(v.display_name, "No display name in performance title %s", k)

	local evaluation_template = v.evaluation_template
	local var_0_2 = PerformanceTitles.templates[evaluation_template]

	fassert(var_0_2, "Performance Titles %s failed, no evaluation_template called %s", k, tostring(evaluation_template))
end
