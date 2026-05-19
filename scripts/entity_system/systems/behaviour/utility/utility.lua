-- chunkname: @scripts/entity_system/systems/behaviour/utility/utility.lua

require("scripts/entity_system/systems/behaviour/utility/utility_considerations")

Utility = Utility or {}

local var_0_0 = Utility

function var_0_0.GetUtilityValueFromSpline(arg_1_0, arg_1_1)
	for iter_1_0 = 3, #arg_1_0, 2 do
		if arg_1_1 <= arg_1_0[iter_1_0] then
			local var_1_0 = arg_1_0[iter_1_0]
			local var_1_1 = arg_1_0[iter_1_0 + 1]
			local var_1_2 = arg_1_0[iter_1_0 - 2]

			return (var_1_1 - arg_1_0[iter_1_0 - 1]) / (var_1_0 - var_1_2) * (arg_1_1 - var_1_0) + var_1_1
		end
	end

	return arg_1_0[#arg_1_0]
end

function var_0_0.get_action_utility(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = 1
	local var_2_1 = arg_2_2.utility_actions[arg_2_1]
	local var_2_2 = var_0_0.GetUtilityValueFromSpline
	local var_2_3 = arg_2_0.considerations

	for iter_2_0, iter_2_1 in pairs(var_2_3) do
		local var_2_4 = iter_2_1.blackboard_input
		local var_2_5 = var_2_1[var_2_4] or arg_2_2[var_2_4]
		local var_2_6 = 0

		if iter_2_1.is_condition then
			local var_2_7 = iter_2_1.invert

			var_2_6 = var_2_5 and (var_2_7 and 0 or 1) or var_2_7 and 1 or 0
		else
			local var_2_8 = iter_2_1.min_value or 0
			local var_2_9 = math.clamp((var_2_5 - var_2_8) / (iter_2_1.max_value - var_2_8), 0, 1)

			var_2_6 = var_2_2(iter_2_1.spline, var_2_9)
		end

		if var_2_6 <= 0 then
			return 0
		end

		var_2_0 = var_2_0 * var_2_6
	end

	return var_2_0 * arg_2_0.action_weight
end
